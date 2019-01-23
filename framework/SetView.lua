SetView = class("SetView",ContainerView)

autoImport ("SetViewSystemState")
autoImport ("SetViewEffectState")
autoImport ("SetViewMsgPushState")
autoImport ("SetViewSecurityPage")
autoImport ("SetViewSwitchRolePage")

autoImport ("SetViewServicePage")
SetView.ViewType = UIViewType.NormalLayer
SetView.PlayerHeadCellResId = ResourcePathHelper.UICell("PlayerHeadCell")
SetView.SetToggleCellResId = ResourcePathHelper.UICell("SetToggleCell")

SetView.TabName = {
	[1] = ZhString.SetView_SystemTabName,
	[2] = ZhString.SetView_EffectTabName,
	[3] = ZhString.SetView_MsgPushTabName,
	[4] = ZhString.SetViewSecurityPage_TabText
}
SetView.LongPressEvent = "SetView_LongPress"

local state = nil
--local activePos = nil
--local inactivePos = nil
local stateTab = {}
local pageTab = {}
local BattleTimeStringColor = {}

function SetView:Init()

	local queryType = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUERYTYPE)
	if queryType then
		FunctionPerformanceSetting.Me():SetShowDetail(queryType)
	end

	self:CreateDynamicToggle()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:AddSubPage()
	self:InitData()
	self:InitShow()
end

function SetView:InitData ()
	BattleTimeStringColor[1] = "[41c419]%s[-]"
	BattleTimeStringColor[2] = "[ffc945]%s[-]"
	BattleTimeStringColor[3] = "[cf1c0f]%s[-]"
end

function SetView:FindObj()
	pageTab[1] = self:FindGO("SystemPage")
	pageTab[2] = self:FindGO("EffectPage")
	pageTab[3] = self:FindGO("MsgPushPage")
	pageTab[4] = self:FindGO("SecurityPage")
	self.gameTime = self:FindGO("GameTime"):GetComponent(UILabel)
	self.gameTimeTip = self:FindGO("GameTimeTip"):GetComponent(UILabel)
	self.battleTimeSlider = self:FindGO("BattleTimeSlider"):GetComponent(UISlider)
	self.activePanel = self:FindGO("ActivatedPanel"):GetComponent(UIScrollView)
    --self.inactivePanel = self:FindGO("InActivatedPanel")
    self.tutortimeTip = self:FindGO("TutorTimeTip"):GetComponent(UILabel)
    self:FindDynamicObj()


	--todo xde 去除自动播放语音
	self.autoAudio = self:FindGO("AutoAudio")
	self.autoAudio:SetActive(false);

--	self.gameLanguage = self:FindGO("GameLanguage")
--	self.gameLanguage:SetActive(false);
end

function SetView:AddSubPage()
	stateTab[1] = self:AddSubView("SetViewSystemState",SetViewSystemState)
	stateTab[2] = self:AddSubView("SetViewEffectState",SetViewEffectState)
	stateTab[3] = self:AddSubView("SetViewMsgPushState",SetViewMsgPushState)
	stateTab[4] = self:AddSubView("SetViewSecurityPage",SetViewSecurityPage)
	self:AddSubView("SetViewSwitchRolePage",SetViewSwitchRolePage)

	self:AddDynamicSubPage()
end

function SetView:AddButtonEvt()
	local backLoginBtn = self:FindGO("BackLoginBtn")
	self:AddClickEvent(backLoginBtn,function ()
		Game.Me():BackToLogo()
	end)

	local SaveBtn = self:FindGO("SaveBtn")
	self:AddClickEvent(SaveBtn,function ()
		self:Save()
	end)

	local togObj = self:FindGO("toggles")
	local SystemSettingToggle = self:FindGO("SystemSetting",togObj)
	local EffectSettingToggle = self:FindGO("EffectSetting",togObj)
	local MsgPushSettingToggle = self:FindGO("MsgPushSetting",togObj)
	local SecuritySettingToggle = self:FindGO("SecuritySetting",togObj)
	self:AddTabChangeEvent(SystemSettingToggle,pageTab[1],PanelConfig.SystemSettingPage)
	self:AddTabChangeEvent(EffectSettingToggle,pageTab[2],PanelConfig.EffectSettingPage)
	self:AddTabChangeEvent(MsgPushSettingToggle,pageTab[3],PanelConfig.MsgPushSettingPage)
	self:AddTabChangeEvent(SecuritySettingToggle,pageTab[4],PanelConfig.SecuritySettingPage)


	-- LongPress for TabNameTip
	self.toggleList = {SystemSettingToggle,EffectSettingToggle,MsgPushSettingToggle,SecuritySettingToggle}
	for i,v in ipairs(self.toggleList) do
		local longPress = v:GetComponent(UILongPress)
		longPress.pressEvent = function (obj, state)
			self:PassEvent(SetView.LongPressEvent, {state, i});
		end
	end
	self:AddEventListener(SetView.LongPressEvent, self.HandleLongPress, self)
	--todo xde
	self:AddDynamicButtonEvt()
	----------------
	MsgPushSettingToggle:SetActive(false)
	----------------
end

function SetView:TabChangeHandler (key)
	if state ~= key then
		local ret = SetView.super.TabChangeHandler(self,key)
		if state ~= nil then
			self:SwitchOff(state)
		end
		self:SwitchOn(key)

		if ret then
			self:SetCurrentTabIconColor(self.coreTabMap[key].go)
		end
	end
end

function SetView:SwitchOn (key)
	self:Activate()
	stateTab[key]:SwitchOn()
	state = key
end

function SetView:SwitchOff (key)
	self:InActivate()
	stateTab[key]:SwitchOff()
	state = nil
end

function SetView:Activate ()
	self.activePanel:ResetPosition()
	--pageTab[name].transform.parent = self.activePanel.transform
	--pageTab[name].transform.localPosition = activePos
end

function SetView:InActivate ()
	--pageTab[name].transform.parent = self.inactivePanel.transform
	--pageTab[name].transform.localPosition = inactivePos
end

function SetView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd , self.GetGameTime)
end

function SetView:InitShow()
	for i=1,#pageTab do
		pageTab[i]:SetActive(false)
	end

	-- Switch icon or text for TabNameTip
	local iconActive, nameLabelActive
	if not GameConfig.SystemForbid.TabNameTip then -- 显示图标和气泡
		iconActive=true;nameLabelActive=false;
	else -- 不显示图标和气泡
		iconActive=false;nameLabelActive=true;
	end
	for i,v in ipairs(self.toggleList) do
		local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
		icon:SetActive(iconActive)
		local label = GameObjectUtil.Instance:DeepFindChild(v, "Label")
		label:SetActive(nameLabelActive)
	end

	self:TabChangeHandler(1)
	self:InitPortrait()
	ServiceNUserProxy.Instance:CallBattleTimelenUserCmd()
end

function SetView:InitPortrait()
	if(not self.targetCell)then
		local headCellObj = self:FindGO("SetPortraitCell")			
		self.headCellObj = Game.AssetManager_UI:CreateAsset(SetView.PlayerHeadCellResId,headCellObj)
		self.headCellObj.transform.localPosition = LuaVector3.zero
		self.headCellObj.transform.localScale = LuaVector3.New(0.8,0.8,0.8)
		self.targetCell = PlayerFaceCell.new(self.headCellObj)
		self.targetCell:HideHpMp()
		self.targetCell:HideLevel()
	end
	local headData = HeadImageData.new()
	headData:TransByMyself()
	self.targetCell:SetData(headData)
end

function SetView:OnExit()
	for i=1,#stateTab do
		stateTab[i]:Exit()
	end
	self.super.OnExit(self)
	stateTab = {}
	pageTab = {}
	state = nil
end

function SetView:GetGameTime(note)
	local data = note.body
	if data then
		self:SetGameTime(data)
	end
end

function SetView:SetGameTime(data)
	local timeLen = 0
	local timeTotal = 0
	local musicTime = 0
	local tutorTime = 0
	local color = 1
	if data.timelen then
		timeLen = math.floor(data.timelen / 60)
	end
	if data.totaltime then
		timeTotal = math.floor(data.totaltime / 60)
	end
	if data.musictime then
		musicTime = math.ceil(data.musictime / 60)
	end
	if data.estatus and data.estatus ~= 0 then
		color = data.estatus
	end
	if data.tutortime then
		tutorTime = math.floor(data.tutortime / 60)
	end
	local str = string.format(BattleTimeStringColor[color],timeLen)
	self.gameTime.text = string.format(ZhString.Set_GameTime , str,timeTotal)
	self.gameTimeTip.text = string.format(ZhString.Set_GameTimeTip , musicTime)
	self.gameTimeTip.gameObject:SetActive(musicTime > 0)
	self.battleTimeSlider.value = 0
	if timeTotal > 0 then
		if timeLen < timeTotal then
			self.battleTimeSlider.value = timeLen / timeTotal
		else
			self.battleTimeSlider.value = 1
		end
	end

	if self.tutortimeTip then
		self.tutortimeTip.gameObject:SetActive(tutorTime > 0)
		self.tutortimeTip.text = string.format(ZhString.Set_GameTutortimeTip,tutorTime)
	end
end

function SetView:Save()
	for i=1,#stateTab do
		stateTab[i]:Save()
	end
end

function SetView:CreateObj(path, parent)
	if not GameObjectUtil.Instance:ObjectIsNULL(parent) then
		local obj = Game.AssetManager_UI:CreateAsset(path, parent)
		if not obj then
			return
		end
		obj:SetActive(true)
		GameObjectUtil.Instance:ChangeLayersRecursively(obj ,parent.layer)
		obj.transform.localPosition = Vector3.zero
		obj.transform.localScale = Vector3.one
		obj.transform.localRotation = Quaternion.identity
		return obj
	end
end

function SetView:_CreateDynamicToggle(togObjName, togName, pageObjName)
	local togRoot = self:FindGO("toggles")
	local toggleObj = self:CreateObj(SetView.SetToggleCellResId, togRoot)
	toggleObj.name = togObjName

	local togLabel = self:FindGO("Label", toggleObj):GetComponent(UILabel)
	togLabel.text = togName

	local pageResId = ResourcePathHelper.UIView(pageObjName)
	local pageRoot = self:FindGO("ActivatedPanel")
	self:CreateObj(pageResId, pageRoot)
end

function SetView:CreateDynamicToggle()
	-- todo xde
	self:_CreateDynamicToggle("ServiceSetting", ZhString.SetViewTabAbout, "SetViewServicePage")
end

function SetView:FindDynamicObj()
	-- todo xde
	pageTab[#pageTab + 1] = self:FindGO("SetViewServicePage")
end

function SetView:AddDynamicSubPage()
	-- todo xde
	stateTab[#stateTab + 1] = self:AddSubView("SetViewServicePage", SetViewServicePage)
end

function SetView:AddDynamicButtonEvt()
	-- todo xde
	local togObj = self:FindGO("toggles")
	local ServiceSettingToggle = self:FindGO("ServiceSetting", togObj)
	table.insert(self.toggleList, ServiceSettingToggle)
	self:AddTabChangeEvent(ServiceSettingToggle,pageTab[#pageTab], PanelConfig.ServiceSettingPage)
end

function SetView:HandleLongPress(param)
	local isPressing, index = param[1], param[2]

	-- Show TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then
		if isPressing then
			local backgroundSp = GameObjectUtil.Instance:DeepFindChild(self.coreTabMap[index].go, "Background"):GetComponent(UISprite);
			TipManager.Instance:TryShowHorizontalTabNameTip(SetView.TabName[index], backgroundSp, NGUIUtil.AnchorSide.Left)
		else
			TipManager.Instance:CloseTabNameTipWithFadeOut()
		end
	end
end

function SetView:ResetTabIconColor()
	for i,v in ipairs(self.toggleList) do
		local iconSp = GameObjectUtil.Instance:DeepFindChild(v, "Icon"):GetComponent(UISprite);

		if iconSp and ColorUtil.TabColor_White then
			iconSp.color = ColorUtil.TabColor_White
		else
			helplog("iconSp ColorUtil.TabColor_White == null")
		end	
	end
end

function SetView:SetCurrentTabIconColor(currentTabGo)
	self:ResetTabIconColor()
	if not currentTabGo then return end
	local iconSp = GameObjectUtil.Instance:DeepFindChild(currentTabGo, "Icon"):GetComponent(UISprite);
	if not iconSp then return end

	if iconSp and ColorUtil.TabColor_DeepBlue then
		iconSp.color = ColorUtil.TabColor_DeepBlue
	else
		helplog("iconSp ColorUtil.TabColor_White == null")
	end	
end