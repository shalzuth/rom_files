autoImport("SocialBaseCell")

local baseCell = autoImport("BaseCell")
AddFriendCell = class("AddFriendCell", SocialBaseCell)

function AddFriendCell:Init()
	self:FindObjs()
	self:AddButtonEvt()
end

function AddFriendCell:FindObjs()
	AddFriendCell.super.FindObjs(self)

	self.Mask = self:FindGO("Mask")
	self.ID = self:FindGO("ID"):GetComponent(UILabel)
end

function AddFriendCell:AddButtonEvt()
	AddFriendCell.super.InitShow(self)

	local addFriendBtn = self:FindGO("AddFriendBtn")
	self:AddClickEvent(addFriendBtn,function (g)
		self:AddFriend(g)
	end)
end

local friend = {}
function AddFriendCell:AddFriend()
	FunctionPlayerTip.CallAddFriend(self.data.guid, self.data.name)
end

function AddFriendCell:SetData(data)
	AddFriendCell.super.SetData(self, data)

	if data ~= nil then
		self.ID.text = "ID "..data.guid

		if data.offlinetime == 0 then
			self.Mask:SetActive(false)
			self.headIcon:SetActive(true,true)
		else
			self.Mask:SetActive(true)
			self.headIcon:SetActive(false,true)
		end
	end
end