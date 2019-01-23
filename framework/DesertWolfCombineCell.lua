autoImport("PvpHeadCell")
autoImport("DesertInviteHeadCell")

local baseCell = autoImport("BaseCell")
DesertWolfCombineCell = class("DesertWolfCombineCell", baseCell)

DesertWolfCombineEvent = 
{
	ClickMember = "DesertWolfCombineEvent_ClickMember",
}

local smallHeight = 98
local bigHeight = 226

function DesertWolfCombineCell:Init()
	self:FindObjs()
	self:AddEvts()
	self:InitShow()
end

function DesertWolfCombineCell:FindObjs()
	self.bg = self:FindGO("Bg"):GetComponent(UISprite)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.zone = self:FindGO("Zone"):GetComponent(UILabel)
	self.stateLab = self:FindGO("LabelState"):GetComponent(UILabel)
	self.challengeBtn = self:FindGO("ChallengeBtn")
	self.enterBtn=self:FindGO("EnterBtn")
	self.challengeWidget=self.challengeBtn:GetComponent(UIWidget)
	self.challengeLab=self:FindGO("challengeLab"):GetComponent(UILabel)
	self.detail = self:FindGO("Detail")
	self.detailGrid = self:FindGO("DetailGrid"):GetComponent(UIGrid)
	self.ChallengeBoxColider=self.challengeBtn:GetComponent(BoxCollider)
end

function DesertWolfCombineCell:AddEvts()
	self:SetEvent(self.bg.gameObject, function ()
		self:PassEvent(MouseEvent.MouseClick, self)
	end)
	
	self:AddClickEvent(self.challengeBtn,function ()
		self:ClickChallenge()
	end)

	self:AddClickEvent(self.enterBtn,function ()
		self:ClickEnterFight()
	end)
end

function DesertWolfCombineCell:InitShow()
	self.detailCtl = UIGridListCtrl.new(self.detailGrid , PvpHeadCell, "PvpHeadCell")
	self.detailCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMember, self);
end

function DesertWolfCombineCell:ClickMember(cell)
	self:PassEvent(DesertWolfCombineEvent.ClickMember, {self, cell});
end

function DesertWolfCombineCell:SetData(data)
	self.data = data
	self.roomid=data.roomid
	self.isDetail = false
	local isMyRoom = PvpProxy.Instance:GetMyRoomGuid()==self.roomid
	if(isMyRoom)then
		self.name.text=ZhString.DesertWolf_OwnRoom
	else
		self.name.text = data.name
	end
	self.zone.text = data:GetZoneString()
	self.state=data.state
	
	self:RefreshBtnState()
	self:RefreshDetalInfo()
end

function DesertWolfCombineCell:RefreshBtnState()
	local myRoomId = PvpProxy.Instance:GetMyRoomGuid()
	local myType = PvpProxy.Instance:GetMyRoomType()
	local roomId = self.roomid
	local status = PvpProxy.RoomStatus
	if(self.state == status.Fighting)then
		self.challengeBtn:SetActive(false)
		self.stateLab.gameObject:SetActive(false)
		self.enterBtn:SetActive(true)
	elseif(myRoomId==roomId and myType==PvpProxy.Type.DesertWolf)then
		self.challengeBtn:SetActive(false)
		self.enterBtn:SetActive(false)
		self.stateLab.gameObject:SetActive(true)
		self.stateLab.text=ZhString.DesertWolf_WaitChallenge
	elseif self.state == status.WaitJoin then
		self.stateLab.gameObject:SetActive(false)
		self.enterBtn:SetActive(false)
		self.challengeBtn:SetActive(true)
	elseif self.state == status.ReadyForFight then
		self.challengeBtn:SetActive(false)
		self.enterBtn:SetActive(false)
		self.stateLab.gameObject:SetActive(true)
		self.stateLab.text=ZhString.DesertWolf_SendChallenge
	end
end

function DesertWolfCombineCell:Click(isDetail)
	self.isDetail = isDetail
	if isDetail then
		self.bg.height = bigHeight
		self.detail:SetActive(true)
	else
		self.bg.height = smallHeight
		self.detail:SetActive(false)
	end
end


-- local headDatas = {}
function DesertWolfCombineCell:RefreshDetalInfo()
	if self.data and self.isDetail then
		local team = self.data:GetRoomTeamList()[1]
		if team then
			local headData = team:GetMemberHeadImageDatas()
			self.detailCtl:ResetDatas(headData)
		end
	end
end

function DesertWolfCombineCell:ClickChallenge()
	if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
		if self.data then
			ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.DesertWolf, self.data.roomid) 
		end
	else
		MsgManager.ShowMsgByID(954)
	end
end

function DesertWolfCombineCell:ClickEnterFight()
	local roomID = self.roomid
	ServiceMatchCCmdProxy.Instance:CallJoinFightingCCmd(PvpProxy.Type.DesertWolf, roomID) 
end




