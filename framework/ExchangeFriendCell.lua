autoImport("HeadIconCell")

local baseCell = autoImport("BaseCell")
ExchangeFriendCell = class("ExchangeFriendCell",baseCell)

function ExchangeFriendCell:Init()
	self:FindObjs()
	self:AddButtonEvt()
end

function ExchangeFriendCell:FindObjs()

	local headContainer = self:FindGO("HeadContainer")
	self.headIcon = HeadIconCell.new()
	self.headIcon:CreateSelf(headContainer)
	self.headIcon.gameObject:AddComponent(UIDragScrollView)
	self.headIcon:SetScale(0.6)
	self.headIcon:SetMinDepth(1)

	self.Profession = self:FindGO("ProfessIcon"):GetComponent(UISprite)
	self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
	self.Level = self:FindGO("Level"):GetComponent(UILabel)
	self.Mask = self:FindGO("Mask")
	self.GenderIcon = self:FindGO("GenderIcon"):GetComponent(UIMultiSprite)
	self.FriendName = self:FindGO("FriendName"):GetComponent(UILabel)
	self.ID = self:FindGO("ID"):GetComponent(UILabel)
	self.expressBtn = self:FindGO("ExpressBtn")
end

function ExchangeFriendCell:AddButtonEvt()
	self:AddClickEvent(self.expressBtn, function ()
		if self.data then
			self:sendNotification( ShopMallEvent.ExchangeSelectFriend, self.data.guid)
		end
	end)
end

function ExchangeFriendCell:SetData(data)

	self.data = data
	self.gameObject:SetActive( data ~= nil )

	if data ~= nil then

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

		local headData = Table_HeadImage[data.portrait]
		if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
			self.headIcon:SetSimpleIcon(headData.Picture)
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
		
		self.ID.text = "ID "..data:GetUIId()

		local presentMode = FriendProxy.Instance:GetPresentMode()

		if(presentMode==FriendProxy.PresentMode.Exchange)then
			if data.offlinetime == 0 then
				self:_refreshUI(false)
			else
				self:_refreshUI(true)
			end
		else
			self:_refreshUI(false)
		end
	end
end

function ExchangeFriendCell:_refreshUI(flag)
	self.Mask:SetActive(flag)
	self.headIcon:SetActive(not flag,true)
	self.expressBtn:SetActive(not flag)
end


