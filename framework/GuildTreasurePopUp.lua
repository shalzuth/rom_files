GuildTreasurePopUp = class("GuildTreasurePopUp", ContainerView)
GuildTreasurePopUp.ViewType = UIViewType.PopUpLayer

autoImport("GuildTreasurePopCell");
autoImport("PlayerTipData");

function GuildTreasurePopUp:Init(parent)
	self:InitView();
	self:MapEvent();
end
	
function GuildTreasurePopUp:InitView()
	FunctionGuild.Me():QueryGuildEventList()
	local wrapContainer = self:FindGO("Wrap");
	local wrapConfig = {
		wrapObj = wrapContainer, 
		pfbNum = 8, 
		cellName = "GuildTreasurePopCell", 
		control = GuildTreasurePopCell, 
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	self.wraplist:AddEventListener(MouseEvent.MouseClick, self.OnClick, self)
end

function GuildTreasurePopUp:OnEnter()
	GuildTreasurePopUp.super.OnEnter(self);
	self:UpdateList()
end

function GuildTreasurePopUp:OnClick(cellCtl)
	local guildData = cellCtl.data;
	local bg = self:FindComponent("Bg", UISprite, cellCtl.gameObject);
	local playerTip = FunctionPlayerTip.Me():GetPlayerTip(bg, NGUIUtil.AnchorSide.Center, {-180,45});

	local ptdata = PlayerTipData.new();
	ptdata:SetByGuildMemberData(guildData);
	local Funckeys = {
		"DistributeArtifact",
	}
	local tipData = { 
		playerData = ptdata,
		funckeys =  Funckeys,
	};
	playerTip:SetData(tipData);
end

function GuildTreasurePopUp:UpdateList()
	local can = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Treasure)
	local memberList = GuildProxy.Instance.myGuildData:GetMemberList();
	if(not can)then
		for i=1,#memberList do
			local gmemb = memberList[i];
			if(gmemb.id==Game.Myself.data.id)then
				TableUtility.ArrayClear(memberList)
				TableUtility.ArrayPushBack(memberList,gmemb)
				break
			end
		end
	end
	if(can)then
		table.sort(memberList, function (a,b)
			local atotalbcoin = a.totalcoin or 0
			local btotalbcoin = b.totalcoin or 0
			local aweekbcoin = a.weekbcoin or 0
			local bweekbcoin = b.weekbcoin or 0
			if(aweekbcoin==bweekbcoin)then
				if(atotalbcoin==btotalbcoin)then
					return a.id<b.id;
				else
					return atotalbcoin>btotalbcoin
				end
			else
				return aweekbcoin>bweekbcoin
			end
		end);
	end
	self.wraplist:ResetDatas(memberList);
end

function GuildTreasurePopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, self.UpdateList);
	self:AddListenEvt(ServiceEvent.GuildCmdArtifactOptGuildCmd,self.UpdateList);
	self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.UpdateList);
	self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, self.UpdateList);
	self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.UpdateList);
	self:AddListenEvt(ServiceEvent.GuildCmdJobUpdateGuildCmd, self.UpdateList);
end

function GuildTreasurePopUp:OnExit()
	GuildTreasurePopUp.super.OnExit(self);
end


