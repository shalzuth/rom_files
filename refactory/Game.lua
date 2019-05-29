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
  InteractNpc = 13
}
Game.EState = {Running = 1, Finished = 2}
autoImport("DataStructureManager")
autoImport("FunctionSystemManager")
autoImport("GUISystemManager")
autoImport("GCSystemManager")
autoImport("GOManager_Camera")
autoImport("GOManager_Light")
autoImport("GOManager_Room")
autoImport("GOManager_SceneObject")
autoImport("GOManager_LocalNPC")
autoImport("GOManager_DynamicObject")
autoImport("GOManager_CullingObject")
autoImport("GOManager_SceneSeat")
autoImport("GOManager_ScenePhotoFrame")
autoImport("GOManager_SceneGuildFlag")
autoImport("GOManager_WeddingPhotoFrame")
autoImport("GOManager_InteractNpc")
autoImport("PreprocessHelper")
autoImport("Preprocess_Table")
autoImport("Preprocess_SceneInfo")
autoImport("Preprocess_EnviromentInfo")
autoImport("Game_Interface_ForCSharp")
autoImport("OverSeaFunc")
local ResolutionPool = {
  2160,
  1440,
  1080,
  720,
  540
}
local ResolutionTextPool = {
  "4K",
  "2K",
  "1080p",
  "720p",
  "540p"
}
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
  if nil == Game.ScreenResolutions or #Game.ScreenResolutions <= 0 then
    return
  end
  index = RandomUtil.Clamp(index, 1, #Game.ScreenResolutions)
  if index < 1 then
    index = 1
  end
  local resolution = Game.ScreenResolutions[index]
  if ApplicationInfo.IsRunOnWindowns() then
    index = LocalSaveProxy.Instance:GetWindowsResolution()
    helplog("Game SetResolution:", index)
    if index == 1 then
      Game.WindowSetting:SetFullScreen()
    else
      local resolution = Game.ScreenResolutions[index]
      Game.WindowSetting:SetWindowSize(resolution[1], resolution[2])
    end
  else
    helplog("Game SetResolution:", index)
    Screen.SetResolution(resolution[1], resolution[2], true)
  end
end
function Game.InitAppIsInReview()
  local inAppStoreReview = false
  local verStr = VersionUpdateManager.serverResJsonString
  helplog(verStr)
  if verStr ~= nil and verStr ~= "" then
    local result = StringUtil.Json2Lua(verStr)
    if result and result.data then
      local data = result.data
      local res = data.lizi
      if res then
        if type(res) == "string" then
          if res == "true" then
            inAppStoreReview = true
          end
        elseif type(res) == "boolean" then
          inAppStoreReview = res
        end
      end
    end
  end
  Game.inAppStoreReview = inAppStoreReview
end
function Game:InitResolutions()
  local screenWidth = LuaLuancher.originalScreenWidth
  local screenHeight = LuaLuancher.originalScreenHeight
  if ApplicationInfo.IsRunOnWindowns() then
    Game.ScreenResolutions = {
      {screenHeight, screenHeight},
      {1280, 720},
      {1280, 800},
      {800, 600}
    }
    Game.ScreenResolutionTexts = {
      ZhString.Game_FullScreen,
      "1280 x 720",
      "1280 x 800",
      "800 x 600"
    }
    return
  end
  Game.ScreenResolutions = {
    {screenWidth, screenHeight}
  }
  Game.ScreenResolutionTexts = {
    ZhString.OriginalResolution
  }
  for i = 1, #ResolutionPool do
    if screenHeight > ResolutionPool[i] + ResolutionGap then
      TableUtility.ArrayPushBack(Game.ScreenResolutions, {
        math.ceil(ResolutionPool[i] * screenWidth / screenHeight),
        ResolutionPool[i]
      })
      TableUtility.ArrayPushBack(Game.ScreenResolutionTexts, ResolutionTextPool[i])
    end
  end
end
function Game:ctor(param)
  self:XDELogin()
  Game.State = Game.EState.Running
  self:InitResolutions()
  LogUtility.SetEnable(ROLogger.enable)
  LogUtility.SetTraceEnable(ROLogger.enable)
  if Application.isEditor then
    LogUtility.SetEnable(true)
    LogUtility.SetTraceEnable(true)
    helplog("Editor \230\168\161\229\188\143\228\184\139\232\190\147\229\135\186\230\151\165\229\191\151")
  else
    LogUtility.SetEnable(false)
    LogUtility.SetTraceEnable(false)
  end
  local luaLuancher = LuaLuancher.Instance
  self.prefabs = luaLuancher.prefabs
  self.objects = luaLuancher.objects
  UnityEngine.Application.targetFrameRate = 30
  UnityEngine.Screen.sleepTimeout = -1
  LeanTween.init(1000)
  Game.InitAppIsInReview()
  Game.Preprocess_Table()
  if ApplicationInfo.IsRunOnWindowns() then
    Game.InputKey = InputKey and InputKey.Instance
    Game.WindowSetting = WindowSetting and WindowSetting.Instance
  end
  self.dataStructureManager = DataStructureManager.new()
  self.functionSystemManager = FunctionSystemManager.new()
  self.guiSystemManager = GUISystemManager.new()
  self.gcSystemManager = GCSystemManager.new()
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
  gameObjectManagers[Game.GameObjectType.InteractNpc] = GOManager_InteractNpc.new()
  self.gameObjectManagers = gameObjectManagers
  Game.Instance = self
  Game.Prefab_RoleComplete = self.prefabs[1]:GetComponent(RoleComplete)
  Game.Prefab_SceneSeat = self.prefabs[2]:GetComponent(LuaGameObjectClickable)
  Game.Prefab_ScenePhoto = self.prefabs[3]:GetComponent(Renderer)
  Game.Prefab_SceneGuildIcon = self.prefabs[4]:GetComponent(Renderer)
  Game.Object_Rect = self.objects[1]
  Game.Object_GameObjectMap = self.objects[2]
  Game.Object_AudioSource2D = self.objects[3]
  Game.ShaderManager = ShaderManager.Instance
  Game.RolePartMaterialManager = RolePartMaterialManager.Instance
  Game.RoleFollowManager = RoleFollowManager.Instance
  Game.TransformFollowManager = TransformFollowManager.Instance
  Game.InputManager = InputManager.Instance
  Game.CameraPointManager = CameraPointManager.Instance
  Game.BusManager = BusManager.Instance
  Game.Map2DManager = Map2DManager.Instance
  Game.ResourceManager = ResourceManager.Instance
  Game.NetConnectionManager = NetConnectionManager.Instance
  Game.NetConnectionManager.EnableLog = false
  Game.InternetUtil = InternetUtil.Ins
  Game.NetIngFileTaskManager = NetIngFileTaskManager.Ins
  Game.HttpWWWRequest = HttpWWWRequest.Instance
  Game.FarmlandManager = FarmlandManager.Ins
  Game.GameObjectManagers = self.gameObjectManagers
  Game.DataStructureManager = self.dataStructureManager
  Game.FunctionSystemManager = self.functionSystemManager
  Game.GUISystemManager = self.guiSystemManager
  Game.GCSystemManager = self.gcSystemManager
  Game.AssetManager_Role:PreloadComplete(200)
  NetConnectionManager.Instance:Restart()
  GameFacade.Instance:registerCommand(StartEvent.StartUp, StartUpCommand)
  GameFacade.Instance:sendNotification(StartEvent.StartUp)
  FunctionInteractionGrass.Ins():Open()
  AppStorePurchase.Ins():AddListener()
  if param == nil then
    SceneProxy.Instance:SyncLoad("CharacterChoose")
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "StartGamePanel"
    })
  elseif Game.Param_SwitchRole == param then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "SwitchRolePanel"
    })
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
function Game:End(toScene, keepResManager)
  local list = LuaUtils.CreateStringList()
  if ApplicationInfo.IsRunOnEditor() then
  else
    ROPush.SetTags(os.time(), list)
  end
  toScene = toScene or "Launch"
  Game.State = Game.EState.Finished
  Game.isSecurityDevice = false
  local netError = FunctionNetError.Me()
  netError:DisConnect()
  NetManager.GameClose()
  UpYunNetIngFileTaskManager.Ins:Close()
  CloudFile.CloudFileManager.Ins:Close()
  DiskFileManager.Instance:Reset()
  FrameRateSpeedUpChecker.Instance():Close()
  AppStorePurchase.Ins():ClearCallbackAppStorePurchase()
  netError:Clear()
  if Game.Myself then
    Game.Myself:Destroy()
    Game.Myself = nil
  end
  UIModelUtil.Instance:Reset()
  UIMultiModelUtil.Instance:Reset()
  FunctionAppStateMonitor.Me():Reset()
  HttpWWWRequest.Instance:Clear()
  local independentTestGo = GameObject.Find("IndependentTest (delete)")
  if independentTestGo ~= nil then
    GameObject.Destroy(independentTestGo)
  end
  FunctionPreload.Me():Reset()
  if LuaLuancher.Instance then
    GameObject.Destroy(LuaLuancher.Instance.monoGameObject)
  end
  if not keepResManager then
    self:_DisposeResManager()
  end
  local shaderManager = GameObject.Find("ShaderManager(Clone)")
  if shaderManager then
    GameObject.Destroy(shaderManager)
  end
  local ImageCrop = GameObject.Find("ImageCrop")
  if ImageCrop then
    GameObject.Destroy(ImageCrop)
  end
  LeanTween.CancelAll()
  LuaTimer.DeleteAll()
  FunctionGetIpStrategy.Me():GameEnd()
  SceneUtil.SyncLoad(toScene)
end
function Game:_DisposeResManager()
  ResourceManager.Instance:DestroySelf()
  GameObject.Destroy(ResourceManager.Instance.monoGameObject)
end
function Game:BackToSwitchRole()
  if CameraController.Instance ~= nil and CameraController.Instance.monoGameObject ~= nil then
    CameraController.Instance.monoGameObject:SetActive(false)
  end
  EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
  if ApplicationHelper.AssetBundleLoadMode then
    ResourceManager.Instance:SLoadScene(Game.SwitchRoleScene)
  end
  self:End(Game.SwitchRoleScene, true)
  self:_DisposeResManager()
end
function Game:BackToLogo()
  EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
  self:End()
end
function Game:BackToLogin()
  UpYunNetIngFileTaskManager.Ins:Close()
  FrameRateSpeedUpChecker.Instance():Close()
  GameFacade.Instance:sendNotification(FunctionNetError.BackToLogin)
  FunctionSelectCharacter.Me():Shutdown()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "StartGamePanel"
  })
end
function Game:XDELogin()
  orginStringFormat = string.format
  function string.format(format, ...)
    local arg = {}
    for i = 1, select("#", ...) do
      local p = select(i, ...)
      local langP = OverSea.LangManager.Instance():GetLangByKey(p)
      table.insert(arg, langP)
    end
    return orginStringFormat(OverSea.LangManager.Instance():GetLangByKey(format), unpack(arg))
  end
  if PlayerPrefs.GetString("TestForce") ~= "1" then
    OverSea.LangManager.Instance():SetCurLang("Japanese")
  else
    OverSea.LangManager.Instance():SetCurLang("ChineseSimplified")
  end
  OverSea.LangManager.Instance():InitAtlass()
  local starttime = os.clock()
  track(Table_Item, {"Desc", "NameZh"})
  track(Table_Map, {"NameZh", "CallZh"})
  track(Table_Sysmsg, {"Text"})
  track(Table_ItemType, {"Name"})
  track(Table_NpcFunction, {"NameZh"})
  track(Table_Buffer, {
    "Dsc",
    "BuffDesc",
    "BuffName"
  })
  track(Table_Class, {"NameZh"})
  track(Table_WantedQuest, {"Target"})
  track(Table_Monster, {"NameZh"})
  track(Table_AdventureAppend, {"Desc"})
  track(Table_MCharacteristic, {"NameZh", "Desc"})
  track(Table_Npc, {"NameZh"})
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
  track(Table_GuildBuilding, {
    "FuncDesc",
    "LevelUpPreview"
  })
  track(Table_ItemAdvManual, {"LockDesc"})
  track(Table_Menu, {"text", "Tip"})
  track(Table_Guild_Treasure, {"Desc"})
  track(Table_QuestVersion, {
    "VersionStory"
  })
  track(Table_Growth, {"desc"})
  track(Table_ServantImproveGroup, {"desc", "maintitle"})
  track(Table_ServantUnlockFunction, {"desc"})
  autoImport("DialogEventConfig")
  track(EventDialog, {"DialogText"})
  local endtime = os.clock()
  redlog(string.format("\231\191\187\232\175\145\233\133\141\231\189\174\232\161\168\232\138\177\232\180\185\230\151\182\233\151\180  : %.4f", endtime - starttime))
  transTable(GameConfig)
  transTable(ZhString)
  Table_Deposit = Table_Deposit_ios_jp
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    Table_Deposit = Table_Deposit_and_jp
  end
  local keys = {"Text"}
  for _, v in pairs(Table_Sysmsg) do
    for __, key in pairs(keys) do
      v[key] = v[key]:gsub("Item", "item")
    end
  end
  for k, v in pairs(UIAtlasConfig.IconAtlas) do
    for i = 1, #v do
      local rID = string.gsub(v[i], "GUI/atlas/preferb/", "Overseas/Atlas/Japanese/")
      local atlasObj = ResourceManager.Instance:SLoad(rID)
      if atlasObj ~= nil then
        UIAtlasConfig.IconAtlas[k][i] = rID
      end
    end
  end
end
function convert2OffLbl(lbl)
  local tmp = lbl.text
  local hasPct = tmp:find("%%")
  tmp = tmp:gsub("%%", "")
  tmp = tonumber(tmp)
  lbl.text = 100 - tmp
  if hasPct then
    lbl.text = lbl.text .. "%"
  end
end
