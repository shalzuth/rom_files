local BaseCell = autoImport("BaseCell");
PvpTeamCell = class("PvpTeamCell", BaseCell);

local pvpProxy;

PvpTeamCellEvent = 
{
	Join = "PvpTeamCellEvent_Join",
	ClickMember = "PvpTeamCellEvent_ClickMember",
}

local PvpTeamCell_BgColor = 
{
	[1] = "ffcad8",
	[2] = "b4ddff",
	[3] = "fffa68",
}

function PvpTeamCell:Init()
	pvpProxy = PvpProxy.Instance;

	local membersGrid = self:FindComponent("MembersGrid", UIGrid);
	self.membersCtl = UIGridListCtrl.new(membersGrid, PvpHeadCell, "PvpHeadCell");
	self.membersCtl:AddEventListener(MouseEvent.MouseClick, self.clickHeadCell, self);

	self.bg = self:FindComponent("Bg", UISprite);
	self.fightSymbol = self:FindGO("FightSymbol");

	self.teamInfo = self:FindGO("TeamInfo");
	self.joinButton = self:FindGO("JoinButton");	
	self:AddClickEvent(self.joinButton, function (go)
		self:PassEvent(PvpTeamCellEvent.Join, self);
	end);
end

function PvpTeamCell:clickHeadCell(cell)
	self:PassEvent(PvpTeamCellEvent.ClickMember, {self, cell});
end

function PvpTeamCell:SetData(data)
	self.data = data;
	
	local color = PvpTeamCell_BgColor[data.index];
	local hasc, rc = ColorUtil.TryParseHexString(color)
	self.bg.color = rc

	if(data.memberNum == 0)then
		self.teamInfo:SetActive(false);
		self.joinButton:SetActive(true);
	else
		self.teamInfo:SetActive(true);
		self.joinButton:SetActive(false);

		local headDatas = data:GetMemberHeadImageDatas();
		self.membersCtl:ResetDatas(headDatas);
	end
end

function PvpTeamCell:ActiveFightSymbol(b)
	self.fightSymbol:SetActive(b);
end