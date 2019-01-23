autoImport("HeadIconCell")

local baseCell = autoImport("BaseCell")
FriendApplyCell = class("FriendApplyCell", baseCell)

function FriendApplyCell:Init()
	self:FindObjs()
	self:AddButtonEvt()

	self:AddCellClickEvent()
end

function FriendApplyCell:FindObjs()

	local headContainer = self:FindGO("HeadContainer")
	self.headIcon = HeadIconCell.new()
	self.headIcon:CreateSelf(headContainer)
	self.headIcon.gameObject:AddComponent(UIDragScrollView)
	self.headIcon:SetScale(0.6)
	self.headIcon:SetMinDepth(1)

	self.Profession = self:FindGO("ProfessIcon"):GetComponent(UISprite)
	self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
	self.Level = self:FindGO("Level"):GetComponent(UILabel)
	self.GenderIcon = self:FindGO("GenderIcon"):GetComponent(UIMultiSprite)
	self.FriendName = self:FindGO("FriendName"):GetComponent(UILabel)
	self.Bg = self:FindGO("Bg")
end

function FriendApplyCell:AddButtonEvt()
	self:SetEvent(self.headIcon.clickObj.gameObject, function ()
		self:PassEvent(FriendEvent.SelectHead, self)
	end)
	local addFriendBtn = self:FindGO("AddFriendBtn")
	--todo xde
	addFriendBtn.transform.localPosition = Vector3(170,-4.2,0)
	self:AddClickEvent(addFriendBtn,function (g)
		self:AddFriend(g)
	end)
	local ignoreFriendBtn = self:FindGO("IgnoreFriendBtn")
	self:AddClickEvent(ignoreFriendBtn,function (g)
		self:IgnoreFriend(g)
	end)
end

local friend = {}
function FriendApplyCell:AddFriend()
	-- TableUtility.ArrayClear(friend)
	-- table.insert(friend,self.data.guid)
	-- FriendProxy.Instance:CallAddFriend(friend)
	FunctionPlayerTip.CallAddFriend(self.data.guid, self.data.name)
end

function FriendApplyCell:IgnoreFriend()
	ServiceSessionSocialityProxy.Instance:CallRemoveRelation(self.data.guid, SocialManager.PbRelation.Apply)
end

function FriendApplyCell:SetData(data)
	self.data = data
	self.gameObject:SetActive( data ~= nil )
	
	if data then
		local config = Table_Class[data.profession]
		if config then
			IconManager:SetProfessionIcon(config.icon, self.Profession)

			local iconColor = ColorUtil["CareerIconBg"..config.Type]
			if(iconColor==nil) then
				iconColor = ColorUtil.CareerIconBg0
			end
			self.professIconBG.color = iconColor
		end
		self.Level.text = "Lv."..data.level

		if data.portrait and data.portrait ~= 0 then
			local headData = Table_HeadImage[data.portrait]
			if headData and headData.Picture then
				self.headIcon:SetSimpleIcon(headData.Picture)
			end
		else
			self.headIcon:SetData(data)
		end

		if data.gender == ProtoCommon_pb.EGENDER_MALE then
			self.GenderIcon.CurrentState = 0
		elseif data.gender == ProtoCommon_pb.EGENDER_FEMALE then
			self.GenderIcon.CurrentState = 1	
		end
		self.GenderIcon:MakePixelPerfect()

		self.FriendName.text = data.name
		----[[ todo xde 不翻译玩家名字
		self.FriendName.text = AppendSpace2Str(data.name)
		--]]

		local ERedSys = SceneTip_pb.EREDSYS_SOCIAL_FRIEND_APPLY
		local isNew = RedTipProxy.Instance:IsNew(ERedSys, data.guid)
		if isNew then
			self:RegisterRedTip(ERedSys)
		end
	end
end

function FriendApplyCell:RegisterRedTip(key)
	RedTipProxy.Instance:RegisterUI(key, self.Bg, 10, {-2,-6})
end