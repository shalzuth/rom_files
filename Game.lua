
Game = class("Game")

Game.GameObjectType = {
	Camera = 1,
	Light = 2,
	RoomHideObject = 3,
	SceneObjectFinder = 4,
	SceneAnimation = 5,
	LocalNPC = 6,
	DynamicObject = 7,
	CullingObject = 8,
	SceneSeat = 9,
	ScenePhotoFrame = 10,
	SceneGuildFlag = 11,
	WeddingPhotoFrame = 12,
}

Game.EState = {
	Running = 1,
	Finished = 2,
}

autoImport ("DataStructureManager")
autoImport ("FunctionSystemManager")
autoImport ("GUISystemManager")
autoImport ("GCSystemManager")

autoImport ("GOManager_Camera")
autoImport ("GOManager_Light")
autoImport ("GOManager_Room")
autoImport ("GOManager_SceneObject")
autoImport ("GOManager_LocalNPC")
autoImport ("GOManager_DynamicObject")
autoImport ("GOManager_CullingObject")
autoImport ("GOManager_SceneSeat")
autoImport ("GOManager_ScenePhotoFrame")
autoImport ("GOManager_SceneGuildFlag")
autoImport ("GOManager_WeddingPhotoFrame")

-- GameFunctions begin
autoImport ("PreprocessHelper")
autoImport ("Preprocess_Table")
autoImport ("Preprocess_SceneInfo")
autoImport ("Preprocess_EnviromentInfo")
autoImport ("Game_Interface_ForCSharp")
-- GameFunctions end
autoImport ("OverSeaFunc")

local ResolutionPool = {2160,1440,1080,720,540}
local ResolutionTextPool = {"4K","2K","1080p","720p","540p"}
local ResolutionGap = 100

Game.SwitchRoleScene = "SwitchRoleLoader"
Game.Param_SwitchRole = "Param_SwitchRole"

function Game.Me(param)
	if nil == Game.me then
		Game.me = Game.new(param)
	end
	return Game.me
end

function Game.GetResolutionNames()
	return Game.ScreenResolutionTexts
end

function Game.SetResolution(index)
	if nil == Game.ScreenResolutions or 0 >= #Game.ScreenResolutions then
		return
	end
	index = RandomUtil.Clamp( index, 1, #Game.ScreenResolutions )
	if 1 > index then
		index = 1
	end
	local resolution = Game.ScreenResolutions[index]
	Screen.SetResolution(resolution[1], resolution[2], true)
end

function Game.InitAppIsInReview()
	local inAppStoreReview = false
	local verStr = VersionUpdateManager.serverResJsonString
	helplog(verStr)
	if(verStr~=nil and verStr~='')then
		local result = StringUtil.Json2Lua(verStr)
		if(result and result["data"])then
			local data = result["data"]
			local res = data["lizi"]
			if(res) then
				if(type(res)=="string") then
					if(res=="true") then
						inAppStoreReview = true
					end
				elseif(type(res)=="boolean")then
					inAppStoreReview = res
				end
			end
		end
	end
	Game.inAppStoreReview = inAppStoreReview
end

function Game:ctor(param)

	-- todo xde ?????????game????????????(????????????GameLauncher????????????????????????????????????????????????)
	self:XDELogin()

	Game.State = Game.EState.Running
	-- 0. game config
	local screenWidth = LuaLuancher.originalScreenWidth
	local screenHeight = LuaLuancher.originalScreenHeight
	Game.ScreenResolutions = {
		{screenWidth, screenHeight}
	}
	Game.ScreenResolutionTexts = {
		ZhString.OriginalResolution
	}
	for i=1, #ResolutionPool do
		if ResolutionPool[i]+ResolutionGap < screenHeight then
			TableUtility.ArrayPushBack(
				Game.ScreenResolutions, 
				{
					math.ceil(ResolutionPool[i]*screenWidth/screenHeight), 
					ResolutionPool[i]
				})
			TableUtility.ArrayPushBack(
				Game.ScreenResolutionTexts, 
				ResolutionTextPool[i])
		end
	end


	local luaLuancher = LuaLuancher.Instance
	self.prefabs = luaLuancher.prefabs
	self.objects = luaLuancher.objects
	UnityEngine.Application.targetFrameRate = 30
	UnityEngine.Screen.sleepTimeout = -1;
	LeanTween.init( 1000 )

	Game.InitAppIsInReview()
	-- 1. preprocess config and table
	Game.Preprocess_Table()
	-- Game.Preprocess_SceneInfo() -- preprocess when switching map
	-- Game.Preprocess_EnviromentInfo() -- preprocess when setting enviroment

	-- 2. create managers
	self.dataStructureManager = DataStructureManager.new()
	self.functionSystemManager = FunctionSystemManager.new()
	self.guiSystemManager = GUISystemManager.new()
	self.gcSystemManager = GCSystemManager.new()

	-- 3. register GameObject managers
	local gameObjectManagers = {}
	gameObjectManagers[Game.GameObjectType.Camera] = GOManager_Camera.new()
	gameObjectManagers[Game.GameObjectType.Light] = GOManager_Light.new()
	gameObjectManagers[Game.GameObjectType.RoomHideObject] = GOManager_Room.new()
	local sceneObjectManager = GOManager_SceneObject.new()
	gameObjectManagers[Game.GameObjectType.SceneObjectFinder] = sceneObjectManager
	gameObjectManagers[Game.GameObjectType.SceneAnimation] = sceneObjectManager
	gameObjectManagers[Game.GameObjectType.LocalNPC] = GOManager_LocalNPC.new()
	gameObjectManagers[Game.GameObjectType.DynamicObject] = GOManager_DynamicObject.new()
	gameObjectManagers[Game.GameObjectType.CullingObject] = GOManager_CullingObject.new()
	gameObjectManagers[Game.GameObjectType.SceneSeat] = GOManager_SceneSeat.new()
	gameObjectManagers[Game.GameObjectType.ScenePhotoFrame] = GOManager_ScenePhotoFrame.new()
	gameObjectManagers[Game.GameObjectType.SceneGuildFlag] = GOManager_SceneGuildFlag.new()
	gameObjectManagers[Game.GameObjectType.WeddingPhotoFrame] = GOManager_WeddingPhotoFrame.new()
	self.gameObjectManagers = gameObjectManagers

	-- 4. set global objects
	Game.Instance = self
	Game.Prefab_RoleComplete = self.prefabs[1]:GetComponent(RoleComplete)
	Game.Prefab_SceneSeat = self.prefabs[2]:GetComponent(LuaGameObjectClickable)
	Game.Prefab_ScenePhoto = self.prefabs[3]:GetComponent(Renderer)
	Game.Prefab_SceneGuildIcon = self.prefabs[4]:GetComponent(Renderer)
	Game.Object_Rect = self.objects[1]
	Game.Object_GameObjectMap = self.objects[2]
	Game.Object_AudioSource2D = self.objects[3]
	-- c#
	Game.ShaderManager = ShaderManager.Instance
	Game.RolePartMaterialManager = RolePartMaterialManager.Instance
	Game.RoleFollowManager = RoleFollowManager.Instance
	Game.TransformFollowManager = TransformFollowManager.Instance
	Game.InputManager = InputManager.Instance
	Game.CameraPointManager = CameraPointManager.Instance
	-- Game.RoomPointManager = RoomPointManager.Instance
	Game.BusManager = BusManager.Instance
	Game.Map2DManager = Map2DManager.Instance
	Game.ResourceManager = ResourceManager.Instance
	
	Game.NetConnectionManager = NetConnectionManager.Instance
	Game.NetConnectionManager.EnableLog = false
	
	-- Game.FunctionLoginMono = FunctionLoginMono.Instance
	Game.InternetUtil = InternetUtil.Ins
	Game.NetIngFileTaskManager = NetIngFileTaskManager.Ins
	Game.HttpWWWRequest = HttpWWWRequest.Instance
	Game.FarmlandManager = FarmlandManager.Ins

	Game.GameObjectManagers = self.gameObjectManagers
	Game.DataStructureManager = self.dataStructureManager
	Game.FunctionSystemManager = self.functionSystemManager
	Game.GUISystemManager = self.guiSystemManager
	Game.GCSystemManager = self.gcSystemManager

	-- 5. preload
	Game.AssetManager_Role:PreloadComplete(200)

	-- 6. game real start
	NetConnectionManager.Instance:Restart()
	GameFacade.Instance:registerCommand(StartEvent.StartUp, StartUpCommand)
	-- ProtocolStatistics.Instance():Start()
	GameFacade.Instance:sendNotification(StartEvent.StartUp)
	FunctionInteractionGrass.Ins():Open()

	--<RB>purchase from app store
	if not BackwardCompatibilityUtil.CompatibilityMode_V19 then
		AppStorePurchase.Ins():AddListener()
	end
	--<RE>purchase from app store

	if(param == nil) then
		SceneProxy.Instance:SyncLoad('CharacterChoose')
		GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "StartGamePanel"})
	elseif(Game.Param_SwitchRole == param) then
		GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "SwitchRolePanel"})
	end
	DiskFileHandler.Ins():EnterRoot()
	DiskFileHandler.Ins():EnterExtension()
	DiskFileHandler.Ins():EnterPublicPicRoot()
	DiskFileHandler.Ins():EnterActivityPicture()
	DiskFileHandler.Ins():EnterLotteryPicture()
	FunctionsCallerInMainThread.Ins:Call(nil)
	CloudFile.CloudFileManager.Ins:Open()

	Game.MapManager:SetInputDisable(true)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))	
end

function Game:End(toScene,keepResManager)
	toScene = toScene or "Launch"
	Game.State = Game.EState.Finished
	Game.isSecurityDevice = false
	local netError = FunctionNetError.Me()
	netError:DisConnect()
	NetManager.GameClose()
	UpYunNetIngFileTaskManager.Ins:Close();
	CloudFile.CloudFileManager.Ins:Close()
	DiskFileManager.Instance:Reset()
	FrameRateSpeedUpChecker.Instance():Close()
	if not BackwardCompatibilityUtil.CompatibilityMode_V19 then
		AppStorePurchase.Ins():ClearCallbackAppStorePurchase()
	end
	netError:Clear()
	if(Game.Myself) then
		Game.Myself:Destroy()
		Game.Myself = nil
	end
	UIModelUtil.Instance:Reset()
	UIMultiModelUtil.Instance:Reset()
	FunctionAppStateMonitor.Me():Reset()
	HttpWWWRequest.Instance:Clear()
	local independentTestGo = GameObject.Find("IndependentTest (delete)")
	if(independentTestGo~=nil) then
		GameObject.Destroy(independentTestGo)
	end
	FunctionPreload.Me():Reset()
	if(LuaLuancher.Instance) then
		GameObject.Destroy(LuaLuancher.Instance.monoGameObject)
	end
	if(not keepResManager) then
		self:_DisposeResManager()
	end
	local shaderManager = GameObject.Find("ShaderManager(Clone)")
	if (shaderManager) then
		GameObject.Destroy(shaderManager)
	end
	local ImageCrop = GameObject.Find("ImageCrop")
	if (ImageCrop) then
		GameObject.Destroy(ImageCrop)
	end
	LeanTween.CancelAll()
	LuaTimer.DeleteAll()
	FunctionGetIpStrategy.Me():GameEnd()
	SceneUtil.SyncLoad(toScene)
	-- if (IndependentTest.Me != null) {
	-- 			GameObject.Destroy (IndependentTest.Me.gameObject);
	-- 		}
	-- 		if (MyLuaSrv.Instance != null) {
	-- 			MyLuaSrv.Instance.Dispose ();
	-- 		}
	-- 		if (SkillManager.Me != null) {
	-- 			SkillManager.Me.Reset ();
	-- 		}
	-- 		Player.Reset ();
	-- 		RoleControllerLua.ResetFactory ();
end

function Game:_DisposeResManager()
	ResourceManager.Instance:DestroySelf()
	GameObject.Destroy(ResourceManager.Instance.monoGameObject)
end

function Game:BackToSwitchRole()
	if(CameraController.Instance ~= nil and CameraController.Instance.monoGameObject ~= nil) then
		CameraController.Instance.monoGameObject:SetActive(false)
	end
	EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
	if(ApplicationHelper.AssetBundleLoadMode) then
		ResourceManager.Instance:SLoadScene(Game.SwitchRoleScene)
	end
	self:End(Game.SwitchRoleScene,true)
	self:_DisposeResManager()
end

function Game:BackToLogo()
	-- helplog("Game:BackToLogo")
	EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
	self:End()
end

function Game:BackToLogin()
	-- helplog("Game:BackToLogin")
	UpYunNetIngFileTaskManager.Ins:Close();
	FrameRateSpeedUpChecker.Instance():Close()
	GameFacade.Instance:sendNotification(FunctionNetError.BackToLogin)
	FunctionSelectCharacter.Me():Shutdown()
	GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "StartGamePanel"})
end

-- todo xde ????????????????????????
OverseasConfig = {}
NoTransString = {}
OverseasConfig.EquipParts = {}
transConfig = {
	["Table_Item"] = {"Desc","NameZh"},
	["Table_Map"] = {"NameZh", "CallZh"},
	["Table_Sysmsg"] = {"Text"},
	["Table_ItemType"] = {"Name"},
	["Table_NpcFunction"] = {"NameZh"},
	["Table_Buffer"] = {"Dsc", "BuffDesc", "BuffName"},
	["Table_Class"] = {"NameZh"},
	["Table_WantedQuest"] = {"Target"},
	["Table_Monster"] = {"NameZh"},
	["Table_AdventureAppend"] = {"Desc"},
	["Table_MCharacteristic"] = {"NameZh", "Desc"},
	["Table_Npc"] = {"NameZh"},
	["Table_Appellation"] = {"Name"},
	["Table_RoleData"] = {"PropName", "RuneName"},
	["Table_Viewspot"] = {"SpotName"},
	["Table_Skill"] = {"NameZh"},
	["Table_EquipSuit"] = {"EffectDesc"},
	["Table_ChatEmoji"] = {"Emoji"},
	["Table_RuneSpecial"] = {"RuneName"},
	["Table_Guild_Faith"] = {"Name"},
	["Table_Recipe"] = {"Name"},
	["Table_ItemTypeAdventureLog"] = {"Name"},
	["Table_ActivityStepShow"] = {"Trace_Text"},
	["Table_GuildBuilding"] = {"FuncDesc", "LevelUpPreview"},
	["Table_ItemAdvManual"] = {"LockDesc"},
	["Table_Menu"] = {"text", "Tip"},
	["Table_Guild_Treasure"] = {"Desc"}
}

-- @param object ???????????????
-- @return objectCopy ??????????????????
--]]
function clone( object )
    local lookup_table = {}
    local function copyObj( object )
        if type( object ) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs( object ) do
            new_table[copyObj( key )] = copyObj( value )
        end
        return setmetatable( new_table, getmetatable( object ) )
    end
    return copyObj( object )
end

-- ?????????
function track2 (t, keys)
    for __,key in pairs(keys) do
		t[key] = OverSea.LangManager.Instance():GetLangByKey(t[key])
	end
end

function track (t, keys)
    for _, v in pairs(t) do
        for __,key in pairs(keys) do
			v[key] = OverSea.LangManager.Instance():GetLangByKey(v[key])
		end
    end
end

function transTable(tbl)
	for k,v in pairs(tbl) do
		if type(v) == "string" then
			tbl[k] = OverSea.LangManager.Instance():GetLangByKey(v)
		elseif type(v) == "table" then
			transTable(v)
		end
	end
end

function transArray( arr )
	for i=1,#arr do
		arr[i] = OverSea.LangManager.Instance():GetLangByKey(arr[i])
	end
end

-- ??????????????????????????????xxx??????????????????????????????
function simpleReplace(origin)
	local ret = origin
	candidates = {"???????????????", "???????????????", "?????????????????????", "_?????????"}
	for _, candidate in ipairs(candidates) do
		local translated = OverSea.LangManager.Instance():GetLangByKey(candidate)
		ret = string.gsub(ret, candidate, translated)
	end
	return ret
end

-- ??? widget ?????? transform ?????????????????? offset
function alignWidgetToTransform_Right(widget, transform, offset)
	offset = offset or 0
	widget.leftAnchor.target = transform
	widget.leftAnchor.relative = 1
	widget.leftAnchor.absolute = offset
	widget.rightAnchor.target = transform
	widget.rightAnchor.relative = 1
	widget.rightAnchor.absolute = widget.width + offset
end

-- ??? widget ?????? transform ?????????????????? offset
function alignWidgetToTransform_Right2(widget, transform, offset)
	offset = offset or 0
	widget.leftAnchor.target = transform
	widget.leftAnchor.relative = 1
	widget.leftAnchor.absolute = offset * (-1) - widget.width
	widget.rightAnchor.target = transform
	widget.rightAnchor.relative = 1
	widget.rightAnchor.absolute = offset
end

function restoreOriginSize(sprite)
	local atlas = sprite.atlas
	-- helplog('atlas1', atlas:GetInstanceID())
	local name = sprite.spriteName
	sprite.atlas = nil
	sprite.atlas = atlas
	-- helplog('atlas2', sprite.atlas:GetInstanceID())
	local spriteData = sprite.atlas:GetSprite(name)
	if spriteData == nil then
		redlog("sprite is nil", name)
		return
	end
	-- helplog('width', spriteData.width, 'height', spriteData.height)
	sprite.width = spriteData.width
	sprite.height = spriteData.height
end

-- ?????????????????????????????????
function AppendSpace2Str(str)
	if str ~= nil and OverSea.LangManager.Instance():GetLangByKey(str) ~= str then
		helplog('?????????????????????????????????: ' .. str)
		return str .. '\002'
	end
	return str
end

-- ??????????????? label
function SkipTranslation(label)
	status, result = pcall(function ()
		label.skipTranslation = true
	end)
	if status ~= true then
		xdlog(status, result)
	end
end

-- ??????\r\n???\n
function ShowLineEnding(str)
	return str:gsub("\r\n", "[CRLF]"):gsub("\n", "[LF]")
end

function Game:XDELogin()
	LogUtility.SetEnable(ROLogger.enable)
	LogUtility.SetTraceEnable(ROLogger.enable)

	--[[ todo ???????????? debug
	local debugResource = Resources.Load("Debug/cell/GMInputCell")
	local enableLog = false
	if debugResource ~= nil then
		Debug.Log("<color=lime>debugRoot ??????</color>")
		-- enableLog = true
	else
		Debug.Log("<color=lime>debugRoot ?????????</color>")
	end
	MyLuaSrv.EnablePrint = enableLog
	LogUtility.SetEnable(enableLog)
	LogUtility.SetTraceEnable(enableLog)
	--]]

	-- ???????????????????????????????????????
	OverseasConfig.EquipParts = clone(GameConfig.EquipParts)
	NoTransString.FunctionDialogEvent_Replace = ZhString.FunctionDialogEvent_Replace
	-- ?????????????????????
	ZhString.QuickUsePopupFuncCell_EquipBtn = ZhString.Verb_Translation_1

	orginStringFormat = string.format
	string.format =function(format,...)
		local arg ={}
		for i=1,select('#',...) do
			local p = select(i,...)
			local langP = OverSea.LangManager.Instance():GetLangByKey(p)
			table.insert(arg,langP)
		end
		return orginStringFormat(OverSea.LangManager.Instance():GetLangByKey(format),unpack(arg))
	end
--
--	--todo xde ???????????????????????????????????????
--	if(PlayerPrefs.GetString("TestForce") ~='1') then
--		OverSea.LangManager.Instance():SetCurLang('Korean')
--	else
--		OverSea.LangManager.Instance():SetCurLang('ChineseSimplified')
--	end
--	OverSea.LangManager.Instance():SetCurLang('English')

	OverSea.LangManager.Instance():InitAtlass()

	local starttime = os.clock()

	track(Table_Item, {"Desc","NameZh"})
	track(Table_Map, {"NameZh", "CallZh"})
	track(Table_Sysmsg, {"Text"})
	track(Table_ItemType, {"Name"})
	track(Table_NpcFunction, {"NameZh"})
	track(Table_Buffer, {"Dsc", "BuffDesc", "BuffName"})
	track(Table_Class, {"NameZh"})
	track(Table_WantedQuest, {"Target"})
	track(Table_Monster, {"NameZh"})
	track(Table_AdventureAppend, {"Desc"})
	track(Table_MCharacteristic, {"NameZh", "Desc"})
	track(Table_Npc, {"NameZh"})
--	track(Table_Dialog, {"Text"})
	track(Table_Appellation, {"Name"})
	track(Table_RoleData, {"PropName", "RuneName"})
	track(Table_Viewspot, {"SpotName"})
	track(Table_Skill, {"NameZh"})
	track(Table_EquipSuit, {"EffectDesc"})
	track(Table_ChatEmoji, {"Emoji"})
	track(Table_RuneSpecial, {"RuneName"})
	track(Table_Guild_Faith, {"Name"})
	track(Table_Recipe, {"Name"})
	track(Table_ItemTypeAdventureLog, {"Name"})
	track(Table_ActivityStepShow, {"Trace_Text"})
	track(Table_GuildBuilding, {"FuncDesc", "LevelUpPreview"})
	track(Table_ItemAdvManual, {"LockDesc"})
	track(Table_Menu, {"text", "Tip"})
	track(Table_Guild_Treasure, {"Desc"})
	track(Table_Exchange, {"NameZh"})


	autoImport("DialogEventConfig")
	track(EventDialog, {"DialogText"})

	local endtime = os.clock()
	redlog(string.format("???????????????????????????  : %.4f", endtime - starttime));


	-- todo xde start ?????? GameConfig
	transTable(GameConfig)
	transTable(ZhString)

	-- ??????%02d ?????????????????????
	ZhString.MultiProfession_SaveName = ZhString.MultiProfession_SaveName:gsub(" ", "_")
	-- todo xde end

	Table_Deposit = Table_Deposit_ios_ww
	if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
		Table_Deposit = Table_Deposit_and_ww
	end

	-- todo xde ???????????????????????????
	for k,v in pairs(UIAtlasConfig.IconAtlas) do
		-- [2] = "Overseas/Atlas/Korean/Item_2",
		for i=1,#v do
			local rID = string.gsub(v[i], "GUI/atlas/preferb/", "Overseas/Atlas/Korean/")
			local atlasObj = ResourceManager.Instance:SLoad(rID);
			if(atlasObj~=nil) then
				UIAtlasConfig.IconAtlas[k][i] = rID
			end
		end
	end
	
--	-- ??????log
--	if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android or ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
--		LogUtility:SetEnable(false)
--	end
end