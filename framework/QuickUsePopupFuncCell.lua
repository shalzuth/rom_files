local baseCell = autoImport("BaseCell");
QuickUsePopupFuncCell = class("QuickUsePopupFuncCell",baseCell);

function QuickUsePopupFuncCell:Init()
	-- self.iconFixScale = Vector3(0.83,0.83,1)
	self.icon = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
	-- self.quality = self:FindGO("Quality"):GetComponent(UISprite)
	self.numLabel = self:FindComponent("NumLabel", UILabel);
	self.iconLabel = self:FindGO("IconLabel"):GetComponent(UILabel)
	self.closeBtn = self:FindGO("CloseBtn"):GetComponent(UIButton)
	self.functionTip = self:FindGO("FunctionTip");
	self:SetEvent(self.closeBtn.gameObject,function (obj)
		self:TryClose()
	end)
	self.btnLabel = self:FindGO("QuickUseBtnLabel"):GetComponent(UILabel)

	self.quickUseBtn = self:FindGO("QuickUseBtn");
	self:SetEvent(self.quickUseBtn,function (obj)
		self:BtnClick()
	end)
	self.doubleQuickUse = self:FindGO("DoubleQuickUse");
	local button1 = self:FindGO("Button1", self.doubleQuickUse);
	self.button1_label = self:FindComponent("Label", UILabel, button1);
	self:SetEvent(button1, function (go)
		self:DoButton1Event();
	end);
	local button2 = self:FindGO("Button2", self.doubleQuickUse)
	self.button2_label = self:FindComponent("Label", UILabel, button2);
	self:SetEvent(button2, function (go)
		self:DoButton2Event();
	end);

	self:InitTypes()
end

function QuickUsePopupFuncCell:InitTypes()
	self.typeShow = {}
	self.typeClick = {}
	self.typeRefreshNum = {}
	self.typeShow[QuickUseProxy.Type.Quest] = self.QuestShow
	self.typeShow[QuickUseProxy.Type.Equip] = self.EquipShow
	self.typeShow[QuickUseProxy.Type.Fashion] = self.FashionShow
	self.typeShow[QuickUseProxy.Type.Trigger] = self.TriggerShow
	self.typeShow[QuickUseProxy.Type.Common] = self.CommonShow
	self.typeShow[QuickUseProxy.Type.Item] = self.ItemShow
	self.typeShow[QuickUseProxy.Type.CatchPet] = self.CatchPetShow

	self.typeClick[QuickUseProxy.Type.Quest] = self.QuestClick
	self.typeClick[QuickUseProxy.Type.Equip] = self.EquipClick
	self.typeClick[QuickUseProxy.Type.Fashion] = self.FashionClick
	self.typeClick[QuickUseProxy.Type.Trigger] = self.TriggerClick
	self.typeClick[QuickUseProxy.Type.Common] = self.CommonClick
	self.typeClick[QuickUseProxy.Type.Item] = self.ItemClick

	self.typeRefreshNum[QuickUseProxy.Type.CatchPet] = self.CatchPetNumRefrehs

	self.doubleQuickUse_typeClick1 = {};
	self.doubleQuickUse_typeClick2 = {};
	self.doubleQuickUse_typeClick1[QuickUseProxy.Type.CatchPet] = self.CathPetClick1

	self.doubleQuickUse_typeClick2[QuickUseProxy.Type.CatchPet] = self.CathPetClick2
end

function QuickUsePopupFuncCell:SetData(data)
	self.data = data and data.data or nil
	if(data == nil) then
		self:Hide()
	else
		self.type = data.type
		self:Show()
		self:Refresh()
	end
end

function QuickUsePopupFuncCell:Refresh()
	self.closeBtn.gameObject:SetActive(self.type~=QuickUseProxy.Type.Quest)
	-- self.quality.gameObject:SetActive(self.type~=QuickUseProxy.Type.Quest)
	self.doubleQuickUse:SetActive(self.type == QuickUseProxy.Type.CatchPet);
	self.quickUseBtn:SetActive(self.type ~= QuickUseProxy.Type.CatchPet);

	self.numLabel.gameObject:SetActive(false);

	self.typeShow[self.type](self)
end

function QuickUsePopupFuncCell:UpdateEquipInfo(item,btnLabel)
	self.btnLabel.text = btnLabel or ZhString.QuickUsePopupFuncCell_EquipBtn
	self.iconLabel.text = item.staticData.NameZh
	IconManager:SetItemIcon(item.staticData.Icon, self.icon)
	self.icon:MakePixelPerfect()
	-- 功能类道具Tip
	if(self.functionTip)then
		self.functionTip:SetActive(item.staticData.Type == 65);
	end
	-- self.icon.transform.localScale = self.iconFixScale
	-- if(self.quality)then
	-- 	local qInt = item.staticData.Quality;
	-- 	if(qInt and qInt~=0)then
	-- 		self.quality.color = CustomColor.ItemFrameColor[qInt];
	-- 	end
	-- end
end

function QuickUsePopupFuncCell:ItemShow()
	self:UpdateEquipInfo(self.data,ZhString.QuickUsePopupFuncCell_UseBtn)
	if(self.data and type(self.data)=="table") then
		FunctionItemCompare.Me():SetHint(self.data)
	end
end

function QuickUsePopupFuncCell:EquipShow()
	self:UpdateEquipInfo(self.data)
	FunctionItemCompare.Me():SetHint(self.data)
end

function QuickUsePopupFuncCell:FashionShow()
	local item = BagProxy.Instance:GetItemByStaticID(self.data)
	if(item) then
		self:UpdateEquipInfo(item)
		FunctionItemCompare.Me():SetHint(item)
	end
end

function QuickUsePopupFuncCell:QuestShow()
	self.btnLabel.text =self.data.btn or ZhString.QuickUsePopupFuncCell_CameraBtn
	self.iconLabel.text = self.data.content
	self:TrySetIcon()
	-- self.icon.transform.localScale = self.iconFixScale
end

function QuickUsePopupFuncCell:TriggerShow()
	self:Hide(self.closeBtn.gameObject)
	if(self.data.data.skill) then
		local skill = SkillProxy.Instance:GetLearnedSkillWithSameSort(self.data.data.skill)
		-- local skill = self.data.data.skill
		local staticData = skill.staticData
		if(staticData) then
			IconManager:SetSkillIcon(staticData.Icon, self.icon)
			if(staticData.SkillType == GameConfig.SkillType.Purify.type) then
				self.btnLabel.text = MsgParserProxy.Instance:TryParse(Table_Sysmsg[701].button,self.data.params[1])
				self.iconLabel.text = MsgParserProxy.Instance:TryParse(Table_Sysmsg[701].Text,skill and skill.leftTimes or 0,skill and skill.maxTimes or 0)
			end
		else

		end
		
	end
	self.icon.width = 76
	self.icon.height = 76
end

function QuickUsePopupFuncCell:CommonShow()
	if(self.data.canClose) then
		self:Show(self.closeBtn.gameObject)
	else
		self:Hide(self.closeBtn.gameObject)
	end
	self:TrySetIcon()
	self.iconLabel.text = (self.data.iconStr~=nil and self.data.iconStr or "")
	self.btnLabel.text = (self.data.btnStr~=nil and self.data.btnStr or "")

	-- local qInt = self.data.iconQuality;
	-- if(qInt and qInt~=0)then
	-- 	self:Show(self.quality);
	-- 	self.quality.color = CustomColor.ItemFrameColor[qInt];
	-- else
	-- 	self:Hide(self.quality);
	-- end
end

function QuickUsePopupFuncCell:CatchPetShow()
	self:Hide(self.closeBtn.gameObject)

	local data = self.data;
	local cpatureData = data[2];
	if(cpatureData == nil)then
		return;
	end

	self.numLabel.gameObject:SetActive(true);
	self.numLabel.text = BagProxy.Instance:GetItemNumByStaticID(cpatureData.GiftItemID) or 0;

	local itemSData = Table_Item[cpatureData.GiftItemID];
	IconManager:SetItemIcon(itemSData.Icon, self.icon)
	self.icon:MakePixelPerfect()
	self.iconLabel.text = itemSData.NameZh;

	self.doubleQuickUse:SetActive(true);
	self.quickUseBtn:SetActive(false);

	self.button1_label.text = ZhString.QuickUsePopupFuncCell_Catch;
	self.button2_label.text = ZhString.QuickUsePopupFuncCell_Give;
end

function QuickUsePopupFuncCell:TrySetIcon()
	if(self.data.iconType=="itemIcon") then
		IconManager:SetItemIcon(self.data.iconID, self.icon)
		self.icon:MakePixelPerfect()
	elseif(self.data.iconType=="npcIcon") then
		IconManager:SetNpcMonsterIconByID(self.data.iconID, self.icon)
		self.icon.width = 76
		self.icon.height = 76
	elseif(self.data.iconType=="skillIcon") then
		IconManager:SetSkillIcon(self.data.iconID, self.icon)
		self.icon.width = 76
		self.icon.height = 76
	elseif(self.data.iconType=="uiIcon") then
		IconManager:SetUIIcon(self.data.iconID, self.icon)
		self.icon.width = 76
		self.icon.height = 76
	end
end

function QuickUsePopupFuncCell:BtnClick()
	-- print(self.type)
	self.typeClick[self.type](self)

	if(self.type ~= QuickUseProxy.Type.Item)then
		self:TryClose()
	end
end

function QuickUsePopupFuncCell:DoButton1Event()
	local func = self.doubleQuickUse_typeClick1[self.type]
	local needClose = false;
	if(func)then
		needClose = func(self);
	end
	if(needClose)then
		self:TryClose();
	end
end

function QuickUsePopupFuncCell:DoButton2Event()
	local func = self.doubleQuickUse_typeClick2[self.type]
	local needClose = false;
	if(func)then
		needClose = func(self);
	end
	if(needClose)then
		self:TryClose();
	end
end

function QuickUsePopupFuncCell:QuestClick()
	if(self.data.questData.questDataStepType==QuestDataStepType.QuestDataStepType_USE) then
		local questData = self.data.questData
		QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FinishJump)
	elseif(self.data.questData.questDataStepType ==QuestDataStepType.QuestDataStepType_SELFIE) then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.PhotographPanel,force=true,viewdata = {questData=self.data.questData}});
	end
end

function QuickUsePopupFuncCell:ItemClick()
	local data = self.data;
	if(data)then
		local itemTarget = data.staticData.ItemTarget;
		if(itemTarget and itemTarget.type)then
			local realTarget = Game.Myself:GetLockTarget();
			if(not realTarget)then
				MsgManager.ShowMsgByIDTable(710)
				return;
			end

			local creatureType = realTarget:GetCreatureType();
			if(Creature_Type.Player == creatureType and not data:CanUseForTarget(ItemTarget_Type.Player))then
				MsgManager.ShowMsgByIDTable(711)
				return;
			elseif(Creature_Type.Npc == creatureType)then 
				if(realTarget.data:IsNpc() and not data:CanUseForTarget(ItemTarget_Type.Npc))then
					MsgManager.ShowMsgByIDTable(711)
					return;
				elseif(realTarget.data:IsMonster() and not data:CanUseForTarget(ItemTarget_Type.Monster))then
					MsgManager.ShowMsgByIDTable(711)
					return;
				end
			end
		end
	end

	FunctionItemFunc.ItemUseEvt(self.data)
	self:TryClose();
end

function QuickUsePopupFuncCell:EquipClick()
	FunctionItemFunc.CallEquipEvt(self.data,self.data.site)
	-- ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_ON,nil, self.data.id);
end

function QuickUsePopupFuncCell:FashionClick()
	local item = BagProxy.Instance:GetItemByStaticID(self.data)
	-- print(self.data)
	if(item) then
		-- print(item.id)
		-- print(item.staticData.id)
		ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_ON,nil, item.id)
	else
		error("快捷装备，无法在背包中找到时装。静态id为"..self.data)
	end
end

function QuickUsePopupFuncCell:TriggerClick()
	if(self.data.type == SceneMap_pb.EACTTYPE_PURIFY) then
		if(self.data.data.skill) then
			local skill = SkillProxy.Instance:GetLearnedSkillWithSameSort(self.data.data.skill)
			if(skill) then
				if(skill.leftTimes and skill.leftTimes >= self.data.serverData.actvalue) then
					GameFacade.Instance:sendNotification(MyselfEvent.AskUseSkill,{skill=skill.id,target = self.data.master})
					FunctionPurify.Me():TryPurifyMonster(self.data.master)
				else
					MsgManager.ShowMsgByIDTable(702)
				end
			end
		end
	end
end

function QuickUsePopupFuncCell:CommonClick()
	if(self.data.ClickCall) then
		self.data.ClickCall()
	end
	self:TryClose()
end

function QuickUsePopupFuncCell:CathPetClick1()
	FunctionPet.Me():DoCatch(self.data[1])
	return false;
end

function QuickUsePopupFuncCell:CathPetClick2()
	ServiceScenePetProxy.Instance:CallCatchPetGiftPetCmd(self.data[1])
	return false;
end

function QuickUsePopupFuncCell:CatchPetNumRefrehs()
	local cpatureData = self.data[2];
	if(cpatureData == nil)then
		return;
	end

	self.numLabel.gameObject:SetActive(true);
	self.numLabel.text = BagProxy.Instance:GetItemNumByStaticID(cpatureData.GiftItemID) or 0;
end

function QuickUsePopupFuncCell:TryClose()
	if(self.type == QuickUseProxy.Type.Equip) then
		QuickUseProxy.Instance:RemoveBetterEquip(self.data)
	elseif(self.type == QuickUseProxy.Type.Fashion) then
		QuickUseProxy.Instance:RemoveNeverEquipedFashion(self.data,true)
	elseif(self.type == QuickUseProxy.Type.Item) then
		QuickUseProxy.Instance:RemoveItemUse(self.data)
	elseif(self.type == QuickUseProxy.Type.CatchPet) then
		QuickUseProxy.Instance:RemoveCatchPetData(self.data)
	else
		QuickUseProxy.Instance:RemoveCommon(self.data)
	end
	self:DispatchEvent(UIEvent.CloseUI)
end

function QuickUsePopupFuncCell:RefreshNum()
	if(not self.gameObject.activeSelf)then
		return;
	end

	local func = self.typeRefreshNum[self.type];
	if(func)then
		func(self);
	end
end