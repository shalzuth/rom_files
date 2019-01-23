ChangeZoneCell = class("ChangeZoneCell",baseCell)

function ChangeZoneCell:Init()
	self:FindObjs()

	self:AddCellClickEvent()
	
	--todo xde
	local label = self:FindGO("Label"):GetComponent(UILabel)
	label.pivot = UIWidget.Pivot.Center
	label.fontSize = 18
	OverseaHostHelper:FixLabelOverV1(label,3,140)
end

function ChangeZoneCell:FindObjs()
	self.label = self:FindGO("Label"):GetComponent(UILabel)
	self.bg = self:FindGO("Bg"):GetComponent(UISprite)
	self.bgline = self:FindGO("Bgline"):GetComponent(UISprite)
	self.dot = self:FindGO("Dot"):GetComponent(UISprite)
end

function ChangeZoneCell:SetData(data)
	if data then

		self.data = data.zoneid

		local typeName
		if data.type == ZoneData.JumpZone.Guild then
			typeName = ZhString.ChangeZone_Guild
		elseif data.type == ZoneData.JumpZone.Team then
			typeName = ZhString.ChangeZone_Team
		elseif data.type == ZoneData.JumpZone.User then
			typeName = ZhString.ChangeZone_User
		end
		local zoneStr = ChangeZoneProxy.Instance:ZoneNumToString(self.data) -- ZhString.ChangeZone_Name
		self.label.text = zoneStr..string.format(ZhString.ChangeZone_Type , tostring(typeName))

		local zoneData = ChangeZoneProxy.Instance:GetInfos(self.data)
		local status = ZoneData.ZoneStatus.None
		if zoneData then
			status = zoneData.status
		end

		local colorId = ZoneData.ZoneColor.VeryBusy
		if status == ZoneData.ZoneStatus.None then
			colorId = ZoneData.ZoneColor.None

		elseif status == ZoneData.ZoneStatus.Free then
			colorId = ZoneData.ZoneColor.Free

		elseif status == ZoneData.ZoneStatus.Busy then
			colorId = ZoneData.ZoneColor.Busy

		end

		local colorCfg = Table_GFaithUIColorConfig[colorId]
		if colorCfg then
			local hasc, rc = ColorUtil.TryParseHexString(colorCfg.bg_Color)
			self.bg.color = rc
			local hasc, rc = ColorUtil.TryParseHexString(colorCfg.bgline_Color)
			self.bgline.color = rc
			local hasc, rc = ColorUtil.TryParseHexString(colorCfg.name_Color)
			self.label.color = rc
			self.dot.color = rc
		end
	end
end