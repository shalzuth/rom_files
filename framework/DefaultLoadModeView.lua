autoImport("LoadingCardCell")
DefaultLoadModeView = class("DefaultLoadModeView",SubView)

DefaultLoadModeView.Mode = {
	Card = 1,
	Model = 2,
}

local tmpPos = LuaVector3.zero
function DefaultLoadModeView:Init()
	self:FindObjs()
	self:AddViewListeners()
	--test
	-- self:InitCardSettings()
end

function DefaultLoadModeView:FindObjs()
	self.bg = self:FindGO("Bg"):GetComponent(UITexture)
	self.panel = UIPanel.Find(self.bg.transform)
	local bar = self:FindGO("ProgressBar",self.gameObject)
	self.bar = bar:GetComponent(UISlider)
	self.barWidth = 1280
	local barWidget = self.bar.gameObject:GetComponent(UIWidget)
	if(barWidget) then
		barWidget:ResetAndUpdateAnchors()
		self.barWidth = barWidget.width
		local barForeground = self:FindGO("Foreground"):GetComponent(UISprite)
		barForeground.width = self.barWidth
		self.bar.value = 0
	end
	local label = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"Tips")
	self.label = label:GetComponent(UILabel)
	self.cardContainer = self:FindGO("CardContainer"):GetComponent(UIWidget)
	self.modelName = self:FindGO("ModelName"):GetComponent(UILabel)
	self.modelContainer = self:FindGO("Model")
	self.bar.gameObject:SetActive(false)

	self.spine = self:FindChild("Spine")
	self:Progress(0)
	--loading 的类型（首次进游戏，进副本）
	local loadingType = 1
	local tipList = self.getTipsByType(loadingType)
	local loadingBgIndex = math.random(#GameConfig.loadingBg)
	local loadingTipIndex = math.random(#tipList)
	self.label.text = tipList[loadingTipIndex].Desc
end

function DefaultLoadModeView:AddViewListeners()
	self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded,self.ServerReceiveLoadedHandler)
end

function DefaultLoadModeView:InitCardSettings()
	self.randomCard = {}
	for k,v in pairs(Table_Card) do
		if(v.NoShow == nil) then
			self.randomCard[#self.randomCard+1] = k
		end
	end
	self.showCardPercent = 0.1
	self.tweenDuration = 0.7
end

function DefaultLoadModeView:TryLoadPic(bgName)
	self.bgName = bgName or "loading"
	PictureManager.Instance:SetLoading(self.bgName,self.bg)
	self.bg:MakePixelPerfect();
	PictureManager.ReFitiPhoneXScreenHeight(self.bg)
end

function DefaultLoadModeView:UnLoadPic()
	if(self.bgName) then
		PictureManager.Instance:UnLoadLoading(self.bgName,self.bg)
	end
end

function DefaultLoadModeView:PlayCard()
	if(self.showCard == nil) then
		local card
		local randomIndex = math.random(#self.randomCard)
		card = Table_Card[self.randomCard[randomIndex]]
		self.showCard = LoadingCardCell.new()
		self.showCard:SetData(card)
		self.showCard.gameObject.transform:SetParent(self.cardContainer.transform)
		local y = self.cardContainer.height/2 + 300
		local targetPos = Vector3(0,0,0)
		local ease = LeanTweenType.easeOutQuart
		local startPos = Vector3(0,y,0)
		self.showCard.gameObject.transform.localPosition = startPos
		self.showCard.gameObject.transform.localScale = Vector3(1,1,1)
		LeanTweenUtil.moveLocal(self.showCard.gameObject,targetPos,self.tweenDuration):setEase(ease):setOnComplete(function ()
			self.showCard.tweenDone = true
			self:TryClose()
		end)
	end
end

function DefaultLoadModeView:OnEnter()
	Game.AssetManager_Role:SetForceLoadAll(true)
	DefaultLoadModeView.super.OnEnter(self)
end

function DefaultLoadModeView:OnExit()
	Game.AssetManager_Role:SetForceLoadAll(false)
	self:DisposeCards()
	self:Progress(0)
end

function DefaultLoadModeView:ServerReceiveLoadedHandler(note)
	TimeTickManager.Me():ClearTick(self)
	self.serverReceivedLoaded = true
	self:TryClose()
end

function DefaultLoadModeView:TryClose()
	if(self.serverReceivedLoaded) then
		if(self.mode == DefaultLoadModeView.Mode.Card and self.showCard and self.showCard.tweenDone and self.serverReceivedLoaded) then
			self:AllDone()
		elseif(self.mode == DefaultLoadModeView.Mode.Model) then
			self:AllDone()
		end
	end
end

function DefaultLoadModeView:AllDone()
	self.container:CloseSelf()
	self:UnLoadPic()
	-- if(self.cell) then
	-- 	GameObject.Destory(self.cell)
	-- 	self.cell = nil
	-- end
end

function DefaultLoadModeView:DisposeCards()
	if(self.showCard) then
		self.showCard:DisposeTexture()
		self.showCard = nil
	end
end

function DefaultLoadModeView:Progress(value)
	if(self.mode == DefaultLoadModeView.Mode.Card) then
		if(self.showCardPercent and value>=self.showCardPercent) then
			self:PlayCard()
		end
	end
	value = math.floor(value)
	self.bar.value = value/100;
	-- self.label.text = value.."%";

	local x = value/100*self.barWidth;
	if(x >= self.barWidth-88)then
		return
	end
	local sx,sy,sz = LuaGameObject.GetLocalPosition(self.spine.transform)
	tmpPos:Set(x,sy,0)
	self.spine.transform.localPosition = tmpPos
end

function DefaultLoadModeView:SceneFadeOut(note)
	self.bg.gameObject:SetActive(false)
	self.container:DoFadeOut()
end

function DefaultLoadModeView:SceneFadeOutFinish()
	self.bar.gameObject:SetActive(true)
end

function DefaultLoadModeView:StartLoadScene(note)
	self:RandomMode(note.body)
	self.bar.gameObject:SetActive(true)
end

function DefaultLoadModeView:Update(delta)
	self:Progress(SceneProxy.Instance:LoadingProgress())
end

function DefaultLoadModeView.getTipsByType( type )
	-- body
	local list = {}
	for key,value in pairs(Table_Tips) do
		if(value.Type == type)then
			table.insert(list,value)
		end
	end
	return list
end

function DefaultLoadModeView:RandomMode(sceneinfo)
	local vedioPlaying = UIManagerProxy.Instance:HasUINode(PanelConfig.VideoPanel)
	local value = math.random(1,100)
	local bgName = "loading"
	if(GameConfig.BgRandom) then
		local randomBgConfig = GameConfig.BgRandom[sceneinfo.mapID]
		if(randomBgConfig and #randomBgConfig>=2) then
			if(math.random(0,100)<=randomBgConfig[2]*100) then
				bgName = randomBgConfig[1]
			end
		end
	end
	self:TryLoadPic(bgName)
	if(vedioPlaying or value<=50) then
		--card
		self:CardMode()
	else
		--3d model
		self:Show(self.modelName)
		self.mode = DefaultLoadModeView.Mode.Model
		self:Init3DModel()
	end
end

function DefaultLoadModeView:CardMode()
	self:Hide(self.modelName)
	self.mode = DefaultLoadModeView.Mode.Card
	self:InitCardSettings()
end

function DefaultLoadModeView:Init3DModel()
	self.cell = GameObject("3DModelContainer")
	self.cell.transform.parent = self.modelContainer.transform
	self.cell.transform.localPosition = Vector3.zero
	self.cell.transform.localEulerAngles = Vector3.zero
	self.cell.layer = self.modelContainer.layer
	self.monsterData = self:RandomGetMonsterToShow()
	if(self.monsterData) then
		self.modelName.text = self.monsterData.NameZh
		self:LoadModel()
	end
	GameObjectUtil.Instance:ChangeLayersRecursively (self.cell, self.modelContainer.gameObject.layer)
end

function DefaultLoadModeView:LoadModel()
	if(self.monsterData) then
		self.modleAssetRole = Asset_RoleUtility.CreateMonsterRole( self.monsterData.id )
		self.modleAssetRole:PlayAction_Idle()
		self.modleAssetRole:SetLayer(self.cell.layer)
		self.modleAssetRole:SetParent( self.cell.transform, false )
		local configPos = self.monsterData.LoadShowPose;
		self.modleAssetRole:SetPosition(configPos and configPos or tmpPos)
		local configRot = self.monsterData.LoadShowRotate;
		self.modleAssetRole:SetEulerAngleY(configRot and configRot or 0)
		local configSize = self.monsterData.LoadShowSize;
		if(configSize)then
			self.modleAssetRole:SetScale(configSize * 0.5);
		else
			self.modleAssetRole:SetScale(1);
		end
	end
end

function DefaultLoadModeView:RandomGetMonsterToShow()
	self.randomCheckTimes = self.randomCheckTimes or 0
	self.randomCheckTimes = self.randomCheckTimes + 1
	if(self.randomCheckTimes>=5) then
		self:CardMode()
		return nil
	end
	local randomRange = RandomUtil.RandomInTable(GameConfig.LoadingRandomModel)
	local monsterID = math.random(randomRange[1],randomRange[2])
	local monsterData = Table_Monster[monsterID]
	if(monsterData) then
		return monsterData
	else
		return self:RandomGetMonsterToShow()
	end
end

function DefaultLoadModeView:SceneFadeInFinish()
	if(self.modleAssetRole) then
		self.modleAssetRole:Destory()
		self.modleAssetRole = nil
	end
	self.container:CloseSelf()
end

function DefaultLoadModeView:LoadFinish()
	self.container:FireLoadFinishEvent()
end