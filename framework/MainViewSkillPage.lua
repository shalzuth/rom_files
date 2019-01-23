autoImport("ShortCutSkill")
autoImport("UIGridListCtrl")

MainViewSkillPage = class("MainViewSkillPage",SubView)

function MainViewSkillPage:Init()
	-- self.shortcutSwitchID = ShortCutProxy.ShortCutEnum.ID1
	FunctionCDCommand.Me():StartCDProxy(ShotCutSkillCDRefresher,16)
	self.touchBoard =  self:FindChild("TouchCollider"):GetComponent(UIWidget)
	self.skillGrid =  self:FindChild("SkillBord");
	self.skillGrid = self:FindChild("SkillGrid", self.skillGrid):GetComponent(UIGridActiveSelf);
	-- self.skillBg =  self:FindChild("SkillBackGround"):GetComponent(UISprite);
	self.currentSelectPhaseSkillID = 0
	self.phaseSkillEffect = self:FindChild("PhaseSkillSelectEffect")
	self.skillShotCutList = UIGridListCtrl.new(self.skillGrid,ShortCutSkill,"ShortCutSkill")
	self.skillShotCutList:SetAddCellHandler(self.AddShortCutCellHandler,self)
	-- self.skillShotCutList:SetReverse(true)
	self.cancelTransformBtn = self:FindChild("cancelTransformBtn");
	self.skillShotCutList:AddEventListener(MouseEvent.MouseClick,self.ClickSkillHandler,self)
	self:InitSwitchShortCut()
	--主界面技能快捷栏switch
	self.shortcutSwitchIndex = 1
	self:SwitchShortCutTo(ShortCutProxy.SwitchList[self.shortcutSwitchIndex])
	self:AddViewEvts();
end

function MainViewSkillPage:InitSwitchShortCut()
	self.skillShortCutAnchor = self:FindChild("SwtichContainer"):GetComponent(UIWidget)
	self.skillShortCutSwitchIcon = self:FindChild("SwitchIcon"):GetComponent(UIMultiSprite)
	self.skillShortCutSwtichBtn = self:FindChild("SkillShortCutSwitch")
	self:AddButtonEvent("SkillShortCutSwitch",function () 
		self:TryGetNextSwitchID()
		self:SwitchShortCutTo(self.shortcutSwitchID)
	end)
	self:AddButtonEvent("cancelTransformBtn",function ()
		MsgManager.ConfirmMsgByID(924,function ()
			self:callCancelTransformState();
		end,nil,nil)
	end)
end

function MainViewSkillPage:TryGetNextSwitchID()
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

function MainViewSkillPage:callCancelTransformState()
	ServiceUserEventProxy.Instance:CallDelTransformUserEvent();
end

function MainViewSkillPage:SwitchShortCutTo(id)
	if id ~= nil then
		self.shortcutSwitchID = id
		self.skillShortCutSwitchIcon.CurrentState = self.shortcutSwitchIndex - 1
		self:UpdateSkills()
		local skillID = Game.SkillClickUseManager:GetNextUseSkillID()
		local cell = self:GetCell(skillID)
		if(cell) then
			self:_ShowWaitNextUseEffect(cell)
		else
			self:CancelWaitNextUseHandler()
		end
	end
end

function MainViewSkillPage:HandleShortCutSwitchActive(note)
	local funcEnable = false
	local _ShortCutEnum = ShortCutProxy.ShortCutEnum
	local _ShortCutProxy = ShortCutProxy.Instance
	local ID1 = _ShortCutEnum.ID1
	for k,v in pairs(_ShortCutEnum) do
		if v ~= ID1 then
			funcEnable = _ShortCutProxy:ShortCutListIsEnable(v)
			if funcEnable then
				break
			end
		end
	end

	if(not funcEnable) then
		--如果当前是在第二栏UI，却删除了第二栏，则回滚到第一栏
		if(self.shortcutSwitchID ~= ID1) then
			self:SwitchShortCutTo(ID1)
		end
	end
	local transformSkills = SkillProxy.Instance:GetTransformedSkills()
	local transformed = Game.Myself.data:IsTransformed()
	if(not funcEnable or transformed and transformSkills~=nil )then
		self:SetActive(self.skillShortCutSwtichBtn,false)

	else
		self:SetActive(self.skillShortCutSwtichBtn,true)
	end
end

function MainViewSkillPage:AddShortCutCellHandler(cell)
	cell.container = self.skillGrid
end

function MainViewSkillPage:ClickSkillHandler(obj)
	-- print("useskill.."..obj.target.data.id)
	local id = obj.data.data:GetID()
	if(id~=0) then
		if(self.currentSelectPhaseSkillID == id) then
			self:sendNotification(MyselfEvent.CancelAskUseSkill,id)
		else
			self:sendNotification(MyselfEvent.AskUseSkill,id)
		end
	else
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.CharactorProfessSkill})
	end
end

function MainViewSkillPage:KeyBoardUseSkillHandler(key)
	local index = key
	local cells = self.skillShotCutList:GetCells()
	if(index>0 and index <= #cells) then
		local cell = cells[index]
		if(cell) then
			if(cell:CanUseSkill()) then
				local hpEnough = SkillProxy.Instance:HasEnoughHp(cell.data:GetID())
				if(cell.data.fitPreCondion and hpEnough) then
					self:ClickSkillHandler({data = cell})
				else
					FunctionSkillEnableCheck.Me():MsgNotFit(cell.data)
					-- MsgManager.ShowMsgByIDTable(609)
				end
			end
		end
	end
end

function MainViewSkillPage:ShowPhaseSkillEffect(skillID)
	local cell = self:GetCell(skillID)
	if(self.phaseEffectCtrl==nil) then
		self.phaseEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillsPlay,self.phaseSkillEffect.transform)
	end
	local x,y,z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform,cell.gameObject.transform,Space.World)
	self.phaseEffectCtrl:ResetLocalPositionXYZ(x,y,z)
end

function MainViewSkillPage:HidePhaseSkillEffect(skillID)
	if(self.phaseEffectCtrl) then
		self.phaseEffectCtrl:Destroy()
		self.phaseEffectCtrl = nil
	end
end

function MainViewSkillPage:GetCell(skillID)
	if(skillID) then
		local cells = self.skillShotCutList:GetCells()
		for index, cell in pairs(cells) do
	        if cell.data:GetID() == skillID then
	            return cell
	        end
	    end
	end
	return nil
end

function MainViewSkillPage:AddViewEvts()
	self:AddListenEvt(SkillEvent.SkillUpdate, self.UpdateSkills);
	self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateSkills);
	self:AddListenEvt(ItemEvent.ItemUpdate, self.ItemUpdateHandler);
	self:AddListenEvt(MyselfEvent.ZenyChange, self.ItemUpdateHandler);
	self:AddListenEvt(MyselfEvent.SyncBuffs, self.BuffUpdateHandler);
	self:AddListenEvt(MyselfEvent.SelectTargetChange, self.SelectTargetChangeHandler);
	-- self:AddListenEvt(ServiceEvent.SkillSkillValidPos, self.UpdateSkills);
	self:AddListenEvt(SkillEvent.SkillUnlockPos, self.UnlockPosHandler);
	self:AddListenEvt(SkillEvent.SkillStartEvent, self.StartSkillCD);
	self:AddListenEvt(SkillEvent.SkillWaitNextUse, self.WaitNextUseHandler);
	self:AddListenEvt(SkillEvent.SkillCancelWaitNextUse, self.CancelWaitNextUseHandler);
	self:AddListenEvt(SkillEvent.SkillSelectPhaseStateChange, self.HandlePhaseSkillEffect);
	self:AddListenEvt(MyselfEvent.TransformChange, self.UpdateSkills);
	self:AddListenEvt(ServiceEvent.SkillDynamicSkillCmd, self.UpdateSkills);
	self:AddListenEvt(ServiceEvent.SkillUpdateDynamicSkillCmd, self.UpdateSkills);
	--team start
	self:AddListenEvt(TeamEvent.MemberEnterTeam, self.TeamMemberUpdateHandler);
	self:AddListenEvt(TeamEvent.MemberExitTeam, self.TeamMemberUpdateHandler);
	--team end
	self:AddDispatcherEvt(SkillEvent.SkillFitPreCondtion, self.UpdateSkillPreCondtion);
	self:AddDispatcherEvt(MyselfEvent.SkillGuideBegin, self.SkillGuideBeginHandler);
	self:AddDispatcherEvt(MyselfEvent.SkillGuideEnd, self.SkillGuideEndHandler);
	self:AddDispatcherEvt(MyselfEvent.SelectTargetClassChange, self.SelectTargetClassChangeHandler);
	self:AddDispatcherEvt(DungeonManager.Event.Launched, self.CheckSkillForbid);
	--
	self:AddDispatcherEvt("CJKeyBoardUseSkillEvent", self.KeyBoardUseSkillHandler);
end

function MainViewSkillPage:TeamMemberUpdateHandler(note)
	local member = note.body
	if(member) then
		local memberGUID = member.id
		local target = Game.Myself:GetLockTarget()
		if(target and target.data.id == memberGUID) then
			self:_HandleSelectTargetChange(target)
		end
	end
end

function MainViewSkillPage:_HandleSelectTargetChange( creature )
	local cells = self.skillShotCutList:GetCells()
	for i=1,#cells do
		cells[i]:CheckTargetValid(creature)
	end
end

function MainViewSkillPage:SelectTargetClassChangeHandler(creature)
	self:_HandleSelectTargetChange(creature)
end

function MainViewSkillPage:SelectTargetChangeHandler(note)
	self:_HandleSelectTargetChange(note.body)
end

function MainViewSkillPage:UpdateSkillPreCondtion(skill)
	local cell = self:GetCell(skill.id)
	if(cell) then
		cell:UpdatePreCondition()
	end
end

function MainViewSkillPage:WaitNextUseHandler(note)
	local skillID = note.body
	if(skillID) then
		local cell = self:GetCell(skillID)
		if(cell) then
			self:_ShowWaitNextUseEffect(cell)
		end
	end
end

function MainViewSkillPage:_ShowWaitNextUseEffect(cell)
	if(self.nextEffectCtrl==nil) then
		self.nextEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillWait,self.phaseSkillEffect.transform)
	end
	local x,y,z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform,cell.gameObject.transform,Space.World)
	self.nextEffectCtrl:ResetLocalPositionXYZ(x,y,z)
end

function MainViewSkillPage:CancelWaitNextUseHandler(note)
	if(self.nextEffectCtrl) then
		self.nextEffectCtrl:Destroy()
		self.nextEffectCtrl = nil
	end
end

function MainViewSkillPage:HandlePhaseSkillEffect(note)
	local skillID = Game.SkillClickUseManager.currentSelectPhaseSkillID
	if(skillID==0) then
		self:HidePhaseSkillEffect(skillID)
	else
		self:ShowPhaseSkillEffect(skillID)
	end
end

function MainViewSkillPage:UnlockPosHandler(note)
	ShortCutProxy.Instance:SetCacheListToRealList()
	self:UpdateSkills(note)
end

--显示可以返回人行的技能
function MainViewSkillPage:ShowCancelTransBtn(bShow)
	local _MapManager = Game.MapManager
	if _MapManager:IsPVPMode_PoringFight() or _MapManager:IsPveMode_AltMan() then
		bShow = false
	end
	if(bShow)then
		self:Show(self.cancelTransformBtn)
	else
		self:Hide(self.cancelTransformBtn)
	end
end

function MainViewSkillPage:UpdateSkills(note)
	self:ShowCancelTransBtn(Game.Myself.data:IsTransformed())
	local equipDatas = nil
	self:HandleShortCutSwitchActive()
	local transformSkills = SkillProxy.Instance:GetTransformedSkills()
	local transformed = Game.Myself.data:IsTransformed()
	if(transformed)then
		equipDatas = transformSkills
	else
		equipDatas = SkillProxy.Instance:GetCurrentEquipedSkillData(true,self.shortcutSwitchID)
	end
	if(equipDatas~=nil) then
		self.skillShotCutList:ResetDatas(equipDatas)
		-- self.skillBg.width = ShortCutProxy.Instance:GetUnLockSkillMaxIndex() * self.skillGrid.cellWidth + 30
		local cells = self.skillShotCutList:GetCells()
		if(cells and not transformed) then
			local data
			local locked
			for i=1,#cells do
				data = cells[i].data
				if(data) then
					locked = ShortCutProxy.Instance:SkillIsLocked(i,self.shortcutSwitchID)
					if(self.shortcutSwitchID == ShortCutProxy.ShortCutEnum.ID1) then
						cells[i]:NeedHide(locked)
					else
						if(locked)then
							--长度不允许超过第一快捷栏
							if(i>ShortCutProxy.Instance:GetUnLockSkillMaxIndex(ShortCutProxy.ShortCutEnum.ID1)) then
								cells[i]:NeedHide(true)
							else
								cells[i]:ExtendsEmptyShow()
							end
						else
							cells[i]:NeedHide(false)
						end
					end
				end
			end
			self.skillShotCutList:Layout()
		end
	end
	local cellnum = 0
	for k,v in pairs(self.skillShotCutList:GetCells()) do
		if(v.gameObject.activeSelf) then
			cellnum = cellnum + 1
		end
	end
	self.touchBoard.width = cellnum * self.skillGrid.cellWidth
	NGUITools.UpdateWidgetCollider(self.touchBoard.gameObject)
	self.skillShortCutAnchor:UpdateAnchors()
end

function MainViewSkillPage:StartSkillCD(note)
	local cells = self.skillShotCutList:GetCells()
	local skill = note.body
	for _, o in pairs(cells) do
        -- if(o.data~=nil and o.data == skill) then
        	o:TryStartCd()
        	-- break
        -- end
    end
end

function MainViewSkillPage:ItemUpdateHandler(note)
	local cells = self.skillShotCutList:GetCells()
	for i=1,#cells do
		cells[i]:UpdatePreCondition()
	end
end

function MainViewSkillPage:BuffUpdateHandler(note)
	self:ItemUpdateHandler(note)
end

function MainViewSkillPage:SkillGuideBeginHandler(skillInfo)
	if(skillInfo) then
		local cell = self:GetCell(skillInfo:GetSkillID())
		if(cell) then
			cell:GuideBegin(skillInfo)
		end
	end
end

function MainViewSkillPage:SkillGuideEndHandler(skillInfo)
	if(skillInfo) then
		local cell = self:GetCell(skillInfo:GetSkillID())
		if(cell) then
			cell:GuideEnd()
		end
	end
end

function MainViewSkillPage:CheckSkillForbid()
	local cells = self.skillShotCutList:GetCells()
	for i=1,#cells do
		cells[i]:CheckEnableUseSkill()
	end
end