GuildBuildingRankPopUp = class("GuildBuildingRankPopUp", ContainerView)
GuildBuildingRankPopUp.ViewType = UIViewType.PopUpLayer
autoImport("GuildBuildingRankCell");

function GuildBuildingRankPopUp:Init(parent)
	self:InitView();
end
	
function GuildBuildingRankPopUp:InitView()
	self.titleLab = self:FindComponent("Title",UILabel)
	self.rankDesc = self:FindComponent("RankDesc",UILabel)
	self.nameDesc = self:FindComponent("NameDesc",UILabel)
	self.totalDesc = self:FindComponent("TotalDesc",UILabel)
	self.wrap = self:FindGO("RankWrap");
	local wrapConfig = {
		wrapObj = self.wrap, 
		pfbNum = 7, 
		cellName = "GuildBuildingRankCell", 
		control = GuildBuildingRankCell, 
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	self.emptyTip = self:FindComponent("EmptyTip",UILabel);
	self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.closeComp.callBack = function (go)
		GuildBuildingProxy.Instance:ClearRankArray()
	end

	-- todo xde
	OverseaHostHelper:FixLabelOverV1(self.titleLab,0,440)
	OverseaHostHelper:FixLabelOverV1(self.emptyTip,3,430)

	OverseaHostHelper:FixLabelOverV1(self.rankDesc,3,200)
	OverseaHostHelper:FixLabelOverV1(self.nameDesc,3,200)
	OverseaHostHelper:FixLabelOverV1(self.totalDesc,3,200)
end

function GuildBuildingRankPopUp:CloseSelf()
	GuildBuildingRankPopUp.super.CloseSelf(self)
	GuildBuildingProxy.Instance:ClearRankArray()
end

function GuildBuildingRankPopUp:OnEnter()
	GuildBuildingRankPopUp.super.OnEnter(self);
	self:UpdateUI();
end

function GuildBuildingRankPopUp:UpdateUI()
	self.rankDesc.text = ZhString.GuildBuilding_RankDesc
	self.nameDesc.text = ZhString.GuildBuilding_NameDesc
	self.totalDesc.text = ZhString.GuildBuilding_TotalDesc
	local name = GuildBuildingProxy.Instance:GetCurBuilding()
	name = name and name.staticData.Name or ""
	self.titleLab.text = string.format(ZhString.GuildBuilding_RankName,name)
	self.emptyTip.text = ZhString.GuildBuilding_RankEmpty
	local rankArray = GuildBuildingProxy.Instance:GetRankArray()
	if(rankArray)then
		local rankList = {};
		for i=1,#rankArray do
			local rankData = {};
			rankData.rank = i;
			rankData.rankData = rankArray[i];
			table.insert(rankList, rankData);
		end
		self.wraplist:UpdateInfo(rankList);
		self.emptyTip.gameObject:SetActive(#rankArray == 0)
	else
		self.wrap:SetActive(false)
		self.emptyTip.gameObject:SetActive(true)
	end
end
