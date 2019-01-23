autoImport("AddFriendCell")

local baseCell = autoImport("BaseCell")
SkyWheelSearchCell = class("SkyWheelSearchCell",AddFriendCell)

function SkyWheelSearchCell:Init()
	self:FindObjs()
	self:AddButtonEvt()
end

function SkyWheelSearchCell:FindObjs()
	SkyWheelSearchCell.super.FindObjs(self)

	self.selectBtn = self:FindGO("SelectBtn"):GetComponent(UISprite)
	self.selectLabel = self:FindGO("Label" , self.selectBtn.gameObject):GetComponent(UILabel)
end

function SkyWheelSearchCell:AddButtonEvt()
	self:SetEvent(self.selectBtn.gameObject, function ()
		if self.data.offlinetime ~= 0 then
			MsgManager.ShowMsgByID(864)
			return
		end

		if self.data.zoneid ~= MyselfProxy.Instance:GetZoneId() then
			MsgManager.ShowMsgByID(3607)
			return
		end

		self:PassEvent(SkyWheel.Select, self)
	end)
end

function SkyWheelSearchCell:SetData(data)

	SkyWheelSearchCell.super.SetData(self, data)

	if data ~= nil then

		if data.offlinetime == 0 and data.zoneid == MyselfProxy.Instance:GetZoneId() then
			self.selectBtn.color = ColorUtil.NGUIWhite
			self.selectLabel.effectColor = ColorUtil.ButtonLabelBlue
		else
			self.selectBtn.color = ColorUtil.NGUIShaderGray
			self.selectLabel.effectColor = ColorUtil.NGUIGray
		end
	end
end