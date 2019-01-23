GuildFindPopUp = class("GuildFindPopUp", ContainerView)

GuildFindPopUp.ViewType = UIViewType.PopUpLayer

autoImport("GuildCell");
autoImport("GuildFindPage");

function GuildFindPopUp:Init()
	local viewdata = self.viewdata.viewdata;
	if(viewdata)then
		self.npcinfo = viewdata.npcdata;
	end
	
	--todo xde
	self:FindGO("GuildFindPage"):SetActive(false)

	local parent = self:FindGO("FindPageContainer");
	self:AddSubView("GuildFindPage" ,GuildFindPage, parent);
end


function GuildFindPopUp:OnEnter()
	GuildFindPopUp.super.OnEnter(self);

	local npcRootTrans = self.npcinfo.assetRole.completeTransform;
	if(npcRootTrans)then
		local viewPort = CameraConfig.NPC_Dialog_ViewPort;
		if(type(self.camera)=="number")then
			viewPort = Vector3(viewPort.x, viewPort.y, self.camera);
		end
		local duration = CameraConfig.NPC_Dialog_DURATION;
		self:CameraFocusOnNpc(npcRootTrans, viewPort, duration);
	end
end

function GuildFindPopUp:OnExit()
	GuildFindPopUp.super.OnExit(self);
	self:CameraReset();
end











