ArtifactDistributePopUp = class("ArtifactDistributePopUp", ContainerView)
ArtifactDistributePopUp.ViewType = UIViewType.PopUpLayer

autoImport("ArtifactDistributeCell");

function ArtifactDistributePopUp:Init(parent)
	self:InitView();
	self:MapEvent();
	self.artiData = self.viewdata.viewdata.data
	self.charID=self.viewdata.viewdata.charID
end
	
function ArtifactDistributePopUp:InitView()
	local wrapContainer = self:FindGO("Wrap");
	local wrapConfig = {
		wrapObj = wrapContainer, 
		pfbNum = 4, 
		cellName = "ArtifactDistributeCell", 
		control = ArtifactDistributeCell, 
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	self.wraplist:AddEventListener(MouseEvent.MouseClick, self.Option, self)
end

function ArtifactDistributePopUp:Option(cellctl)
	if(cellctl)then
		local data = cellctl.data
		helplog("CallArtifactOptGuildCmd  -----> data.Phase ",data.Phase,"data.guid: ",data.guid)
		local guidArray = {}
		guidArray[#guidArray+1]=data.guid
		local myGuildData = GuildProxy.Instance.myGuildData
		local guildMemberData = myGuildData:GetMemberByGuid(self.charID);
		if(data.Phase==ArtifactProxy.OptionType.Distribute)then
			if(guildMemberData)then
				if(not data:CanEquip(guildMemberData.profession))then
					MsgManager.ShowMsgByID(3794)
					return
				end		
			end
			if(not data:CanDistribute())then
				local disCount = data.staticData and data.staticData.DistributeCount or 2
				MsgManager.ShowMsgByIDTable(3793,disCount)
				return 
			end
		end
		local msgID
		if(data.Phase==ArtifactProxy.OptionType.Distribute)then
			msgID=3796
		elseif(data.Phase==ArtifactProxy.OptionType.Retrieve)then
			msgID=3797
		elseif(data.Phase==ArtifactProxy.OptionType.RetrieveCancle)then
			msgID=3798
		end
		MsgManager.ConfirmMsgByID(msgID,function ()
			ServiceGuildCmdProxy:CallArtifactOptGuildCmd(data.Phase,guidArray,self.charID)
			self:CloseSelf()
		end , nil , nil)
	end
end

function ArtifactDistributePopUp:OnEnter()
	ArtifactDistributePopUp.super.OnEnter(self);
	self:UpdateView();
end

function ArtifactDistributePopUp:UpdateView()
	if(self.artiData)then
		self.wraplist:UpdateInfo(self.artiData);
	end
end

function ArtifactDistributePopUp:MapEvent()
end

function ArtifactDistributePopUp:OnExit()
	ArtifactDistributePopUp.super.OnExit(self);
end