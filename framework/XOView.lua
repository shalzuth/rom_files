XOView = class("XOView", BaseView);

XOView.ViewType = UIViewType.DialogLayer

function XOView:Init()
	self:InitUI();
	self:MapEvent();
end

function XOView:InitUI()
	self.title = self:FindComponent("Title", UILabel);
	self.content = self:FindComponent("Content", UILabel);
	self:AddButtonEvent("CancleButton", function (go)
		if(self.guid and self.interid)then
			FunctionXO.Me():Answer(self.npcid, self.guid, self.interid, 1);
		end
		self:CloseSelf();
	end);
	self:AddButtonEvent("ConformButton", function (go)
		if(self.guid and self.interid)then
			FunctionXO.Me():Answer(self.npcid, self.guid, self.interid, 2);
		end
		self:CloseSelf();
	end);
end

function XOView:MapEvent()
	self:AddListenEvt(SceneUserEvent.SceneRemoveRoles, self.HandleRemoveRoles);
end

function XOView:HandleRemoveRoles(note)
	if(not self.npcinfo)then
		return;
	end
	local playerids = note.body;
	if(playerids)then
		for _,playerid in pairs(playerids)do
			if(playerid == self.npcinfo.data.id)then
				self:CloseSelf();
			end
		end
	end
end

function XOView:OnEnter()
	XOView.super.OnEnter(self);
	
	local viewdata = self.viewdata.viewdata;
	self.guid = viewdata and viewdata.guid;
	self.interid = viewdata and viewdata.interid;
	self.npcid = viewdata and viewdata.npcid;

	-- 停止人物当前操作
	FunctionSystem.InterruptMyselfAll()
	-- FunctionSystem.InterruptMyself()

	if(self.interid)then
		local xoData = Table_xo and Table_xo[self.interid];
		helplog(self.interid)
		helplog(xoData)
		for k,v in pairs(xoData) do
			helplog(k)
			helplog(v)
		end

		self.title.text = xoData.Title;
		self.content.text = xoData.Context;
	end

	if(self.npcid)then
		local npc = NSceneNpcProxy.Instance:Find(self.npcid);
		if(npc)then
			local npcRootTrans = npc.assetRole.completeTransform;

			local viewPort = CameraConfig.NPC_Dialog_ViewPort;
			if(type(self.camera)=="number")then
				viewPort = Vector3(viewPort.x, viewPort.y, self.camera);
			end
			local duration = CameraConfig.NPC_Dialog_DURATION;
			self:CameraFocusOnNpc(npcRootTrans, viewPort, duration);
		end
	end
end

function XOView:OnExit()
	XOView.super.OnExit(self);
	self.guid = nil;
	self.interid = nil;
	self.npcid = nil;

	self:CameraReset();
end


