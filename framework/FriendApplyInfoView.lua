autoImport("WrapCellHelper")
autoImport("FriendProxy")
autoImport("FriendApplyCell")

FriendApplyInfoView = class("FriendApplyInfoView",ContainerView)

FriendApplyInfoView.ViewType = UIViewType.PopUpLayer;

function FriendApplyInfoView:OnExit()
	self.super.OnExit(self)

	RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SOCIAL_FRIEND_APPLY)
end

function FriendApplyInfoView:Init()
	self:FindObj()
	self:InitShow()
	self:AddButtonEvt()
	self:AddViewEvt()
end

function FriendApplyInfoView:FindObj()
	self.ApplyTip = self:FindGO("ApplyTip"):GetComponent(UILabel)
end

function FriendApplyInfoView:InitShow()

	self.ApplyTip.text = ZhString.Friend_ApplyTip

	self.funkey = {
		"InviteMember",
		"SendMessage",
		"AddFriend",
		"ShowDetail",
		"AddBlacklist",
		"InviteEnterGuild",
	}
	self.tipData = {}

	local container = self:FindGO("ContentContainer")
	local wrapConfig = {
		wrapObj = container, 
		pfbNum = 5, 
		cellName = "FriendApplyCell", 
		control = FriendApplyCell, 
		dir = 1,
		disableDragIfFit = true,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(FriendEvent.SelectHead, self.HandleClickItem, self)

	self:UpdateFriendApplyData()
end

function FriendApplyInfoView:AddButtonEvt()
	local AddAllBtn = self:FindGO("AddAllBtn")
	self:AddClickEvent(AddAllBtn,function (g)
		self:AddAllInfo(g)
	end)
	local IgnoreBtn = self:FindGO("IgnoreBtn")
	self:AddClickEvent(IgnoreBtn,function (g)
		self:IgnoreInfo(g)
	end)
end

local friend = {}
function FriendApplyInfoView:AddAllInfo()
	local datas = FriendProxy.Instance:GetApplyData()
	TableUtility.ArrayClear(friend)
	for i=1,#datas do
		table.insert(friend,datas[i].guid)
	end
	FriendProxy.Instance:CallAddFriend(friend)
end

function FriendApplyInfoView:IgnoreInfo()
	ServiceSessionSocialityProxy.Instance:CallRemoveRelation(0, SocialManager.PbRelation.Apply)
end

function FriendApplyInfoView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate,self.UpdateFriendApplyData)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate,self.UpdateFriendApplyData)
	self:AddListenEvt(RedTipProxy.UpdateRedTipEvent,self.AddRedTip)
end

function FriendApplyInfoView:UpdateFriendApplyData()

	local datas = FriendProxy.Instance:GetApplyData()

	if #datas > 0 then
		self.ApplyTip.gameObject:SetActive(false)
	else
		self.ApplyTip.gameObject:SetActive(true)
	end

	self.itemWrapHelper:UpdateInfo(datas)
end

function FriendApplyInfoView:HandleClickItem(cellctl)
	local playerData = PlayerTipData.new();
	playerData:SetByFriendData(cellctl.data);

	FunctionPlayerTip.Me():CloseTip()

	local playerTip = FunctionPlayerTip.Me():GetPlayerTip( cellctl.headIcon.clickObj , NGUIUtil.AnchorSide.Left, {-380,60})

	TableUtility.TableClear(self.tipData)
	self.tipData.playerData = playerData
	self.tipData.funckeys = funkey

	playerTip:SetData(self.tipData)
end

function FriendApplyInfoView:AddRedTip(note)
	local data = note.body
	local ERedSys = SceneTip_pb.EREDSYS_SOCIAL_FRIEND_APPLY
	local itemList = self.itemWrapHelper:GetCellCtls()

	if data and data.id == ERedSys then

		for i=1,#itemList do
			local cellctl = itemList[i]
			if cellctl.data then				
				for j=1,#data.paramIds do
					if cellctl.data.guid == data.paramIds[j] then
						cellctl:RegisterRedTip(ERedSys)
					end
				end
			end
		end
	end
end