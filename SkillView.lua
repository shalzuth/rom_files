autoImport("SkillCell")
autoImport("ShortCutSkillDragCell")
autoImport("SkillContentPage")
autoImport("BeingSkillContentPage")
SkillView = class("SkillView",ContainerView)

SkillView.ViewType = UIViewType.NormalLayer

local GOCameraType = Game.GameObjectType.Camera

function SkillView:GetShowHideMode()
	return PanelShowHideMode.ActiveAndDeactive
end

function SkillView:Init(viewObj)
	self:FindObjs()
	self.contentView = self:AddSubView("SkillContent",SkillContentPage)
	self.beingContentView = self:AddSubView("BeingSkillContentPage",BeingSkillContentPage)
	-- self:InitLines()
	self:InitShortCuts()
	self:InitAutoShortCuts()
	--????????????????????????switch
	self.shortcutSwitchIndex = 1
	self:SwitchShortCutTo(ShortCutProxy.SwitchList[self.shortcutSwitchIndex])
	self:InitTopToggles()
	self:CheckNeedShowProfessToggle()
	self:AddViewListener()
	self:RegisterGuide()
end

function SkillView:InitTabChangeHandler()
	--?????????????????????????????????????????????????????????????????????
	if(self.viewdata.view and self.viewdata.view.tab)then
		self:TabChangeHandler(self.viewdata.view.tab)
	else
		self:TabChangeHandler(PanelConfig.CharactorAdventureSkill.tab)
	end
end

function SkillView:OnEnter()
	local viewdata = self.viewdata.viewdata
	if viewdata ~= nil then
		self.multiSaveId = viewdata.saveId
		self.multiSaveType = viewdata.saveType
		SkillProxy.Instance:SetMultiSave(self.multiSaveId, self.multiSaveType)
	end

	if(self.upLeftWidget~=nil) then
		self.upLeftWidget:UpdateAnchors()
	end

	if(self.upRightWidget~=nil) then
		self.upRightWidget:UpdateAnchors()
	end
	self:InitTabChangeHandler()
	self:RefreshShortCuts()
	local profess = SkillProxy.Instance:GetMyProfession()
	self:UpdateTopByProfess(profess)
	self:UpdateTopToggles(profess)
	self:RegisterRedTip()
	self:UpdateTipLabel()
	
	local camera = Game.GameObjectManagers[GOCameraType]
	if camera ~= nil then
		camera:ActiveMainCamera(false)
	end

	SkillView.super.OnEnter(self)
end

function SkillView:OnExit()
	SkillProxy.Instance:SetMultiSave()
	local camera = Game.GameObjectManagers[GOCameraType]
	if camera ~= nil then
		camera:ActiveMainCamera(true)
	end
	SkillView.super.OnExit(self)
end

function SkillView:AddViewListener()
	self:AddListenEvt(SkillEvent.SkillUpdate,self.RefreshSkills)
	self:AddListenEvt(MyselfEvent.MyProfessionChange,self.RefreshProfess)
	-- self:AddListenEvt(SkillEvent.SkillUnlockPos,self.UnlockPosHandler)
end

function SkillView:FindObjs()
	self.shortCutGrid = self:FindGO("ShortCutGrid"):GetComponent(UIGrid)
	self.autoShortCutGrid = self:FindGO("AutoShortCutGrid"):GetComponent(UIGrid)
	self.skillToggleGrid = self:FindGO("SkillToggleGrid"):GetComponent(UIGrid)
	self.commonSkillToggle = self:FindGO("CommonToggle"):GetComponent(UIToggle)
	self.professSkillToggle = self:FindGO("ProfessToggle"):GetComponent(UIToggle)
	self.beingSkillToggle = self:FindGO("BeingToggle"):GetComponent(UIToggle)
	self.profess = self:FindGO("Profess")
	self.professIcon = self:FindGO("ProfessIcon"):GetComponent(UISprite)
	self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
	self.professNameLabel = self:FindGO("ProfessName"):GetComponent(UILabel)
	self.professLevelLabel = self:FindGO("ProfessLevel"):GetComponent(UILabel)
	self.currentProfessSkillPoints = self:FindGO("CostedPointLabel"):GetComponent(UILabel)
	self.commonIcon = self:FindGO("CommonSkill")
	self.closeBtn = self:FindGO("CloseButton")
	self.upLeftWidget = self:FindGO("Left"):GetComponent(UIWidget)
	self.upRightWidget = self:FindGO("Right"):GetComponent(UIWidget)
	self.tipLabel = self:FindGO("TipLabel")
end

function SkillView:RegisterGuide()
	self:AddOrRemoveGuideId(self.closeBtn,31)
end

function SkillView:RegisterRedTip()
	if self.multiSaveId == nil then
		self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SKILL_POINT,self.professSkillToggle.gameObject,10,{-10,-5})
		if(RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_PEAK_LEVEL)) then
			MsgManager.ConfirmMsgByID(3430,function ()
				RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_PEAK_LEVEL)
			end)
		end
	end
end

function SkillView:InitTopToggles()
	self:AddTabChangeEvent(self.commonSkillToggle.gameObject,nil,PanelConfig.CharactorAdventureSkill)
	self:AddTabChangeEvent(self.professSkillToggle.gameObject,nil,PanelConfig.CharactorProfessSkill)
	self:AddTabChangeEvent(self.beingSkillToggle.gameObject,nil,PanelConfig.CharactorBeingSkill)
end

function SkillView:_SetToggleWidth(toggle,width)
	local widget = toggle.gameObject:GetComponent(UIWidget)
	if(widget) then
		widget.width = width
	end
	widget = self:FindComponent("Background",UISprite,toggle.gameObject)
	if(widget) then
		widget.width = width
	end
	widget = self:FindComponent("Checkmark",UISprite,toggle.gameObject)
	if(widget) then
		widget.width = width+10
	end
end

function SkillView:UpdateTopToggles(profess)
	local myClassConfig = Table_Class[profess]
	-- myClassConfig = {TypeBranch=62}
	if(myClassConfig and myClassConfig.TypeBranch == 62) then
		--??????
		if(self.multiSaveId ~= nil)then
			if(self.beingContentView:GetSelectSkillBeingData() == nil)then
				self:Hide(self.beingSkillToggle)
				self.skillToggleGrid.cellWidth = 225
				self:_SetToggleWidth(self.professSkillToggle,200)
				self:_SetToggleWidth(self.commonSkillToggle,200)
				
				self.skillToggleGrid:Reposition()
				return;
			end
		end

		self:Show(self.beingSkillToggle)
		self.skillToggleGrid.cellWidth = 185
		self:_SetToggleWidth(self.professSkillToggle,160)
		self:_SetToggleWidth(self.commonSkillToggle,160)
		self.beingContentView:InitBeings()
	else
		self:Hide(self.beingSkillToggle)
		self.skillToggleGrid.cellWidth = 225
		self:_SetToggleWidth(self.professSkillToggle,200)
		self:_SetToggleWidth(self.commonSkillToggle,200)
	end
	self.skillToggleGrid:Reposition()
end

function SkillView:TabChangeHandler(key)
	if(self.coreTabMap) then
		local tabObj = self.coreTabMap[key]
		if(type(tabObj.check)=="table" and tabObj.check.id) then
			if(not FunctionUnLockFunc.Me():CheckCanOpenByPanelId(tabObj.check.id, true)) then
				if(tabObj.tog ~= self.commonSkillToggle) then
					self.commonSkillToggle.value = true
				end
				return tabObj
			end
		end
		tabObj.tog.value = true
		if(tabObj.tog == self.beingSkillToggle) then
			if(self.contentView.isEditMode) then
				self.professSkillToggle.value =true
				self.contentView:QuitProfess(self.ShowBeing,self)
			else
				self:ShowBeing()
			end
		else
			if(self.beingContentView.switch) then
				local data = self.beingContentView:GetSelectSkillBeingData()
				if(data:GetIsEditMode()) then
					self.beingSkillToggle.value =true
				end
				self.beingContentView:ConfirmEditMode(self.ConfirmShowMineContent,self,tabObj)
			else
				self:ConfirmShowMineContent(tabObj)
			end
		end
		return tabObj
	end
	return nil
end

function SkillView:ConfirmShowMineContent(tabObj)
	tabObj.tog.value = true
	if(tabObj.tog == self.commonSkillToggle) then
		if(self.contentView.isEditMode) then
			self.professSkillToggle.value =true
		end
		self:ShowCommon()
	elseif(tabObj.tog == self.professSkillToggle)then
		self:ShowProfess(true)
	end
end

function SkillView:ShowBeing()
	self.beingSkillToggle.value =true
	self.contentView:Switch(false)
	self.beingContentView:Switch(true)
end

function SkillView:ShowCommon()
	self.contentView:Switch(true)
	self.beingContentView:Switch(false)
	if(not self.contentView.ShowingCommon) then
		self.contentView:QuitProfess(self.ConfirmShowCommon,self)
	end
end

function SkillView:ConfirmShowCommon()
	self.contentView:Switch(true)
	self.beingContentView:Switch(false)
	self.commonSkillToggle.value = true
	self:Hide(self.profess)
	self.contentView:ShowCommon()
end

function SkillView:ShowProfess(force)
	self.contentView:Switch(true)
	self.beingContentView:Switch(false)
	if(self.contentView.ShowingCommon or force) then
		self:Show(self.profess)
		self.contentView:ShowProfess()
	end
end

function SkillView:AddCloseButtonEvent()
	self:AddButtonEvent("CloseButton", function (go)
		if(self.contentView.switch) then
			self.contentView:QuitProfess(self.TryCloseSelf,self)
		elseif(self.beingContentView.switch)then
			self.beingContentView:ConfirmEditMode(self.TryCloseSelf,self)
		end
		-- self:sendNotification(UIEvent.CloseUI,self.ViewType)
	end);
end

function SkillView:TryCloseSelf()
	local cells = self.autoShortCutList:GetCells()
	local hasAttackTypeSkill
	local skillData
	for i=1,#cells do
		skillData = cells[i].data
		if(skillData and skillData.staticData) then
			local config = Table_SkillMould[skillData.sortID*1000 + 1]
			if(config and config.Atktype and config.Atktype==1) then
				hasAttackTypeSkill = true
				break
			end
		end
	end
	if(hasAttackTypeSkill) then
		self:CloseSelf()
	else
		if self.multiSaveId ~= nil then
			self:CloseSelf()
		else
			local dont = LocalSaveProxy.Instance:GetDontShowAgain(1711)
			if(dont == nil)then
				local confirmHandler = function ()
					self:CloseSelf()
				end
				MsgManager.DontAgainConfirmMsgByID( 1711, confirmHandler, nil, nil)
			else
				self:CloseSelf()
			end
		end
	end
end

function SkillView:InitSwitchShortCut()
	self.skillShortCutSwitchIcon = self:FindChild("SwitchIcon"):GetComponent(UIMultiSprite)
	self.skillShortCutSwtichBtn = self:FindChild("SkillShortCutSwitch")
	self:AddButtonEvent("SkillShortCutSwitch",function () 
		self:TryGetNextSwitchID()
		self:SwitchShortCutTo(self.shortcutSwitchID)
	end)
end

function SkillView:TryGetNextSwitchID()
	self.shortcutSwitchIndex = self.shortcutSwitchIndex + 1
	if self.shortcutSwitchIndex > #ShortCutProxy.SwitchList then
		self.shortcutSwitchIndex = 1
	end

	local id = ShortCutProxy.SwitchList[self.shortcutSwitchIndex]
	local funcEnable = ShortCutProxy.Instance:ShortCutListIsEnable(id)
	if funcEnable then
		self.shortcutSwitchID = id
	else
		self:TryGetNextSwitchID()
	end
end

function SkillView:SwitchShortCutTo(id)
	if id ~= nil then
		self.shortcutSwitchID = id
		self.skillShortCutSwitchIcon.CurrentState = self.shortcutSwitchIndex - 1
		self:RefreshShortCuts()
	end
end

function SkillView:HandleShortCutSwitchActive(note)
	local funcEnable = false
	local _ShortCutEnum = ShortCutProxy.ShortCutEnum
	local _ShortCutProxy = ShortCutProxy.Instance
	local _SaveInfoProxy = SaveInfoProxy.Instance
	local ID1 = _ShortCutEnum.ID1
	for k,v in pairs(_ShortCutEnum) do
		if v ~= ID1 then
			if self.multiSaveId == nil then
				funcEnable = _ShortCutProxy:ShortCutListIsEnable(v)
			else
				local saveData = _SaveInfoProxy:GetSkillData(self.multiSaveId, self.multiSaveType)
				if saveData ~= nil then
					funcEnable = saveData:ShortCutListIsEnable(v)
				end
			end
			if funcEnable then
				break
			end
		end
	end

	if(funcEnable)then
		self:SetActive(self.skillShortCutSwtichBtn,true)
	else
		self:SetActive(self.skillShortCutSwtichBtn,false)
		--???????????????????????????UI????????????????????????????????????????????????
		if(self.shortcutSwitchID ~= ID1) then
			self:SwitchShortCutTo(ID1)
		end
	end
end

function SkillView:InitShortCuts()
	self:InitSwitchShortCut()
	self.shortCutList = UIGridListCtrl.new(self.shortCutGrid,ShortCutSkillDragCell,"ShortCutSkillDragCell")
	self.shortCutList:AddEventListener(DragDropEvent.SwapObj,self.SwapSkill,self)
	self.shortCutList:AddEventListener(DragDropEvent.DropEmpty,self.TakeOffSkill,self)
end

function SkillView:InitAutoShortCuts()
	self.autoShortCutList = UIGridListCtrl.new(self.autoShortCutGrid,AutoShortCutSkillDragCell,"ShortCutSkillDragCell")
	self.autoShortCutList:AddEventListener(DragDropEvent.SwapObj,self.SwapSkill,self)
	self.autoShortCutList:AddEventListener(DragDropEvent.DropEmpty,self.TakeOffSkill,self)
end

function SkillView:SwapSkill(obj)
	local source = obj.data.source
	local target = obj.data.target
	-- print("swap",source.data.id,target.data.pos)
	if(self.contentView.isEditMode) then
		if(source.class == SkillCell) then
			MsgManager.ShowMsgByIDTable(608)
			return
		end
	end
	if(target:IsLocked(self.shortcutSwitchID)) then
		return
	end
	if(source.class == AutoShortCutSkillDragCell and source:IsLocked(self.shortcutSwitchID)) then
		return
	end
	if source ~= nil and target ~= nil and self:_CheckPosUnequal(source.data, target.data) then
		local targetType = self:GetShotCutType(target.class)
		local sourceType = self:GetShotCutType(source.class)
		local targetPos = nil
		local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
		if targetType ~= sourceType and (sourceType == shortCutAuto or targetType == shortCutAuto) then
			--?????????????????????
			if((source~=nil and source.data.staticData and source.data.staticData.AutoCondition_Groove == 1) or 
				(target ~=nil and target.data.staticData and target.data.staticData.AutoCondition_Groove == 1)) then
				MsgManager.ShowMsgByIDTable(1950)
				return 
			end
		end
		if(targetType == SceneSkill_pb.ESKILLSHORTCUT_AUTO) then
			targetPos = target.data:GetPosInShortCutGroup(targetType)
		else
			targetPos = target.data:GetPosInShortCutGroup(targetType)
			if sourceType == shortCutAuto then
				--?????????????????????????????????????????????
				if((target.data == nil or target.data.staticData == nil) and self:CheckAutoIsLast()) then
					return
				end
			end
		end
		if(targetType ~= sourceType) then
			if targetType ~= shortCutAuto and sourceType ~= shortCutAuto 
				or source.data.staticData == nil or target.data.staticData == nil then
				TipManager.Instance:CloseBubbleTip(BubbleID.SkillFirstTimeOverFlow)
			end
			local normalAtkSkillID = Game.Myself.data:GetAttackSkillIDAndLevel()
			if(normalAtkSkillID) then
				--???????????????????????????????????????????????????
				if targetType == shortCutAuto and target.data and target.data.staticData and target.data.staticData.id == normalAtkSkillID
					or (sourceType == shortCutAuto and source.data and source.data.staticData and source.data.staticData.id == normalAtkSkillID) then
					MsgManager.ConfirmMsgByID( 1710,function ()
						ServiceSkillProxy.Instance:CallEquipSkill(source.data.id,targetPos,source.data.sourceId,sourceType,targetType)
					end)
					return
				end
			end
		end
		ServiceSkillProxy.Instance:CallEquipSkill(source.data.id,targetPos,source.data.sourceId,sourceType,targetType)
	end
end

function SkillView:_CheckPosUnequal(source, target)
	if source ~= nil and target ~= nil then
		local _ShortCutEnum = ShortCutProxy.ShortCutEnum
		for k,v in pairs(_ShortCutEnum) do
			if source:GetPosInShortCutGroup(v) ~= target:GetPosInShortCutGroup(v) then
				return true
			end
		end

		local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
		return source:GetPosInShortCutGroup(shortCutAuto) ~= target:GetPosInShortCutGroup(shortCutAuto)
	end
	return false
end

function SkillView:CheckAutoIsLast()
	if(SkillProxy.Instance:GetEquipedAutoSkillNum()<=1) then
		MsgManager.ShowMsgByIDTable(1951)
		return true
	end
	return false
end

function SkillView:TakeOffSkill(obj)
	local data = obj.data
	if(data~=nil) then
		if(data.class == AutoShortCutSkillDragCell) then
			if(self:CheckAutoIsLast()) then
				return
			end
			if(data:IsLocked(self.shortcutSwitchID)) then
				return
			end
			local normalAtkSkillID = Game.Myself.data:GetAttackSkillIDAndLevel()
			if(normalAtkSkillID) then
				--???????????????????????????????????????????????????
				local skillData = data.data
				if(skillData and skillData.staticData and skillData.staticData.id == normalAtkSkillID) then
					MsgManager.ConfirmMsgByID( 1710,function ()
						TipManager.Instance:CloseBubbleTip()
						ServiceSkillProxy.Instance:TakeOffSkill(skillData.id,skillData.sourceId,self:GetShotCutType(data.class))
					end)
					return
				end
			end
		end
		-- print("clear.."..obj.data.data.id)
		TipManager.Instance:CloseBubbleTip()
		ServiceSkillProxy.Instance:TakeOffSkill(data.data.id,data.data.sourceId,self:GetShotCutType(data.class))
	end
end

function SkillView:GetShotCutType(class)
	if(class == ShortCutSkillDragCell) then
		return self.shortcutSwitchID
	elseif(class == AutoShortCutSkillDragCell)then
		return SceneSkill_pb.ESKILLSHORTCUT_AUTO
	else
		return SceneSkill_pb.ESKILLSHORTCUT_MIN
	end
end

-- function SkillView:UnlockPosHandler(note)
-- 	ShortCutProxy.Instance:SetCacheListToRealList()
-- 	self:RefreshShortCuts()
-- end

function SkillView:CheckNeedShowProfessToggle()
	local myProfess = profess or MyselfProxy.Instance:GetMyProfession()
	local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(myProfess)
	--2016.1.6 MOMO?????????????????????????????????????????????
	-- if(professTree==nil) then
	-- 	--?????????
	-- 	self:Hide(self.professSkillToggle.gameObject)
	-- else
	-- 	self:Show(self.professSkillToggle.gameObject)
	-- end
end

function SkillView:UpdateTopByProfess(myProfess)
	local config = Table_Class[myProfess]
	IconManager:SetProfessionIcon(config.icon, self.professIcon)

	local jobLevel = ProfessionProxy.Instance:GetThisJobLevelForClient(myProfess,self:GetJobLevel())

	self.professLevelLabel.text = string.format("Lv.%s",jobLevel)
	self.professNameLabel.text = config.NameZh
	local iconColor = ColorUtil["CareerIconBg"..config.Type]
	if(iconColor==nil) then
		iconColor = ColorUtil.CareerIconBg1
	end
	self.professIconBG.color = iconColor
end

function SkillView:UpdateProfessSkillPoints(curPoints)
	self.currentProfessSkillPoints.text = string.format("%s/%s",curPoints,SkillProxy.UNLOCKPROSKILLPOINTS)
end

function SkillView:UpdateTipLabel()
	self.tipLabel:SetActive(self.multiSaveId == nil)
end

function SkillView:RefreshPoints()
	self.leftPointsLabel.text = string.format(ZhString.SkillView_LeftSkillPointText,Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT))
	-- self:RefreshContent()
end

function SkillView:RefreshShortCuts()
	self:HandleShortCutSwitchActive()
	local equipDatas = SkillProxy.Instance:GetCurrentEquipedSkillData(true,self.shortcutSwitchID)
	self.shortCutList:ResetDatas(equipDatas)
	local cells = self.shortCutList:GetCells()
	if(cells) then
		local data
		local HasJobBreak = MyselfProxy.Instance:HasJobBreak()
		local saveData = SaveInfoProxy.Instance:GetSkillData(self.multiSaveId, self.multiSaveType)
		for i=1,#cells do
			data = cells[i].data
			if(data) then
				if self.multiSaveId == nil then
					cells[i]:NeedHide(ShortCutProxy.Instance:SkillIsLocked(i,self.shortcutSwitchID))
				else
					if saveData ~= nil then
						cells[i]:NeedHide(saveData:SkillIsLocked(i,self.shortcutSwitchID))
					else
						cells[i]:NeedHide(data == nil or data.staticData == nil)
					end
				end
			end
			if(data.staticData==nil or (data:HasNextID(HasJobBreak)==false and data.staticData.Level <= 1)) then
				cells[i]:Hide(cells[i].level.gameObject)
			end
			if self.multiSaveId ~= nil then
				cells[i].dragDrop:SetDragEnable(false)
			end
		end
		self.shortCutList:Layout()
	end

	equipDatas = SkillProxy.Instance:GetEquipedAutoSkillData(true)
	self.autoShortCutList:ResetDatas(equipDatas)
	if self.multiSaveId ~= nil then
		local autocells = self.autoShortCutList:GetCells()
		if autocells then
			for i=1,#autocells do
				autocells[i].dragDrop:SetDragEnable(false)
			end
		end
	end
end

function SkillView:RefreshSkills()
	self:RefreshShortCuts()
end

function SkillView:RefreshProfess()
	self.contentView:CancelSimulate()
	self:CloseSelf()
end

function SkillView:GetJobLevel()
	if self.multiSaveId ~= nil then
		local level = SaveInfoProxy.Instance:GetJobLevel(self.multiSaveId, self.multiSaveType)
		if level ~= nil then
			return level
		end
	end
	return MyselfProxy.Instance:JobLevel()
end