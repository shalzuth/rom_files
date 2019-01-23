UIEmojiView = class("UIEmojiView", ContainerView);

UIEmojiView.ViewType = UIViewType.ChatLayer;

autoImport("UIEmojiCell");

function UIEmojiView:Init()
	self.BlockEmojiClick = false
	self.BlockEmojiClickTwId = nil
	self:InitView();
	self:MapViewInterest();
end

function UIEmojiView:InitView()
	self.bord = self:FindGO("Bord");

	local emojiGrid = self:FindComponent("EmojiGrid", UIGrid);
	self.emojiCtl = UIGridListCtrl.new(emojiGrid , UIEmojiCell, "UIEmojiCell");
	self.emojiCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self);
end

function UIEmojiView:ClickCell(cellctl)
	if(not self.BlockEmojiClick)then
		self:StartBlockEmojiClick()
		if(cellctl.type == UIEmojiType.Action and cellctl.forbidState ~= 1)then
			local myself = Game.Myself;
			if(myself.data:IsTransformed())then
				MsgManager.ShowMsgByIDTable(830);
				return;
			end

			local sdata = Table_ActionAnime[cellctl.id];
			if(string.find(sdata.Name, "ride_"))then
				if(not myself.assetRole:HasActionRaw(sdata.Name))then
					local _BagProxy = BagProxy.Instance;

					local mount = _BagProxy.roleEquip:GetMount();
					if(mount)then
						local sites = mount.equipInfo:GetEquipSite();
						ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFF, sites[1], mount.id, false);
					end

					local fmount = _BagProxy.fashionEquipBag:GetMount();
					if(fmount)then
						local sites = fmount.equipInfo:GetEquipSite();
						ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFFASHION, sites[1], fmount.id, false);
					end
				end
			end
			if(sdata.Condition == 1)then
				if(not myself:IsOnSceneSeat())then
					MsgManager.ShowMsgByIDTable(925);
					return;
				end
			end
			myself:Client_PlayMotionAction(sdata.id);
			
		elseif(cellctl.type == UIEmojiType.Emoji and cellctl.forbidState ~= 2)then
		 	local roleid = Game.Myself.data.id;
		 	self:sendNotification(EmojiEvent.PlayEmoji, {roleid = roleid, emoji = cellctl.id});
		 	ServiceNUserProxy.Instance:CallUserActionNtf(roleid, cellctl.id, SceneUser2_pb.EUSERACTIONTYPE_EXPRESSION);
		end
	end
end

function UIEmojiView:StartBlockEmojiClick(  )
	-- body
	if(self.BlockEmojiClickTwId)then
		LeanTween.cancel(self.gameObject,self.BlockEmojiClickTwId)
		self.BlockEmojiClickTwId = nil
	end
	self.BlockEmojiClick = true
	local ret = LeanTween.delayedCall(self.gameObject,3,function (  )
			self.BlockEmojiClick = false
			self.BlockEmojiClickTwId = nil
		end)
	self.BlockEmojiClickTwId = ret.id
end

function UIEmojiView:OnEnter()
	UIEmojiView.super.OnEnter(self);

	self:sendNotification(MainViewEvent.EmojiViewShow, true);

	self:UpdateData();

	local viewdata = self.viewdata.viewdata;
	local state = viewdata and viewdata.state;
	if(state)then
		self:Forbid(state);
	end

	if(Game.Myself:IsDead())then
		self:Forbid(1);
	end
end

function UIEmojiView:Forbid(state)
	local cells = self.emojiCtl:GetCells();
	for i=1,#cells do
		cells[i]:Forbid(state);
	end
end

function UIEmojiView:UpdateData()
	if(not self.data)then
		self.data = {};
	else
		TableUtility.ArrayClear(self.data);
	end
	-- actionData
	local actionMap = MyselfProxy.Instance:GetUnlockActionMap();
	for _,actionData in pairs(Table_ActionAnime)do
		if(actionData.Type == 2)then
			if(actionMap[actionData.id] == 1)then
				local actionCellData = {};
				actionCellData.type = UIEmojiType.Action;
				actionCellData.id = actionData.id;
				actionCellData.name = actionData.Name;
				table.insert(self.data, actionCellData);	
			end
		end
	end

	-- emojiData
	local emojiMap = MyselfProxy.Instance:GetUnlockEmojiMap();
	for _,expressData in pairs(Table_Expression) do
		if(expressData.Type == "1" or (expressData.Type == "2" and emojiMap[expressData.id]))then
			local emojiCellData = {};
			emojiCellData.type = UIEmojiType.Emoji;
			emojiCellData.id = expressData.id;
			emojiCellData.name = expressData.NameEn;
			table.insert(self.data, emojiCellData);
		end
	end

	table.sort(self.data, function (a,b)
		if(a.type ~= b.type)then
			return a.type < b.type;
		end
		return a.id < b.id;
	end);

	self.emojiCtl:ResetDatas(self.data);
end

function UIEmojiView:MapViewInterest()
	self:AddListenEvt(EmojiEvent.ShowBord, self.RecvShowBord);
	self:AddListenEvt(EmojiEvent.HideBord, self.RecvHideBord);
	self:AddListenEvt(PhotographModeChangeEvent.ModeChangeEvent, self.RecvForbid);
	self:AddListenEvt(MyselfEvent.DeathBegin,self.HandleDeathBegin);
	self:AddListenEvt(MyselfEvent.ReliveStatus,self.HandleReliveStatus);
end

function UIEmojiView:HandleDeathBegin(note)
	self:Forbid(1);
end

function UIEmojiView:HandleReliveStatus(note)
	self:Forbid(0);
end

function UIEmojiView:RecvForbid(note)
	helplog("------UIEmojiView RecvForbid---------", note.body);
	self:Forbid(note.body or 0);
end

function UIEmojiView:RecvShowBord(note)
	self.bord:SetActive(true);
end

function UIEmojiView:RecvHideBord(note)
	self.bord:SetActive(false);
end

function UIEmojiView:OnExit()
	self:sendNotification(MainViewEvent.EmojiViewShow, false);

	local cells = self.emojiCtl:GetCells();
	for i=1,#cells do
		cells[i]:OnRemove();
	end
	
	UIEmojiView.super.OnExit(self);
end








