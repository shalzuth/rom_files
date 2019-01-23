autoImport("TutorApplyCell")

TutorApplyView = class("TutorApplyView",ContainerView)

TutorApplyView.ViewType = UIViewType.PopUpLayer

local funkey = {
	"InviteMember",
	"SendMessage",
	"AddFriend",
	"ShowDetail",
	"AddBlacklist",
	"InviteEnterGuild",
}
local tipData = {}

function TutorApplyView:OnEnter()
	TutorApplyView.super.OnEnter(self)
	RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TUTOR_APPLY)
end

function TutorApplyView:Init()
	self:AddViewEvt()
	self:InitShow()
end

function TutorApplyView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateView)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.HandleSocialUpdate)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.HandleSocialDataUpdate)
end

function TutorApplyView:InitShow()
	local container = self:FindGO("ContentContainer")
	local wrapConfig = {
		wrapObj = container, 
		pfbNum = 6, 
		cellName = "TutorApplyCell", 
		control = TutorApplyCell, 
		dir = 1,
		disableDragIfFit = true,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
	self.itemWrapHelper:AddEventListener(FriendEvent.SelectHead, self.ClickItem, self)

	self:UpdateView()
end

function TutorApplyView:UpdateView()
	local data = TutorProxy.Instance:GetApplyList()
	if data then
		self.itemWrapHelper:UpdateInfo(data)
	end

	if #data < 1 then
		self:CloseSelf()
	end
end

function TutorApplyView:HandleSocialUpdate(note)
	local data = note.body
	if data then
		-- for i=1,#data.updates do
		-- 	local socialData = data.updates[i]
		-- 	if BitUtil.band(socialData.relation, SocialManager.SocialRelation.Tutor) ~= 0 or 
		-- 		BitUtil.band(socialData.relation, SocialManager.SocialRelation.Student) ~= 0 then

		-- 		self:ConfirmMsg(socialData)
		-- 	end
		-- end

		self:UpdateView()
	end
end

function TutorApplyView:HandleSocialDataUpdate(note)
	local data = note.body
	if data then
		-- for i=1,#data.items do
		-- 	local updateData = data.items[i]
		-- 	if updateData.type == SessionSociality_pb.ESOCIALDATA_RELATION and 
		-- 		(BitUtil.band(updateData.value, SocialManager.SocialRelation.Tutor) ~= 0 or
		-- 		BitUtil.band(updateData.value, SocialManager.SocialRelation.Student) ~= 0) then

		-- 		local socialData = Game.SocialManager:Find(data.guid)
		-- 		if socialData then
		-- 			self:ConfirmMsg(socialData)
		-- 		end
		-- 	end
		-- end

		self:UpdateView()
	end
end

function TutorApplyView:ConfirmMsg(socialData)
	if not FriendProxy.Instance:IsFriend(socialData.guid) then
		MsgManager.ConfirmMsgByID(3218, function ()
			local tempArray = ReusableTable.CreateArray()
			tempArray[1] = socialData.guid
			FriendProxy.Instance:CallAddFriend(tempArray)
			ReusableTable.DestroyArray(tempArray)
		end, nil, nil, socialData.name)
	end
end

function TutorApplyView:ClickItem(cell)
	local data = cell.data
	if data then
		local playerData = PlayerTipData.new()
		playerData:SetByFriendData(data)

		FunctionPlayerTip.Me():CloseTip()

		local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380,60})

		tipData.playerData = playerData
		tipData.funckeys = funkey

		playerTip:SetData(tipData)
	end
end