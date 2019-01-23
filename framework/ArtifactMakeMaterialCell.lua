ArtifactMakeMaterialCell = class("ArtifactMakeMaterialCell", ItemCell)

function ArtifactMakeMaterialCell:Init()
	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	ArtifactMakeMaterialCell.super.Init(self)

	self:FindObjs()

	self:AddCellClickEvent()
end

function ArtifactMakeMaterialCell:FindObjs()
	self.count = self:FindGO("Count"):GetComponent(UILabel)
end

local redString = "[c][FF622CFF]%s[-][/c]"
function ArtifactMakeMaterialCell:SetData(data)
	if data then
		self.itemData = ItemData.new(nil,data.id)
		ArtifactMakeMaterialCell.super.SetData(self,self.itemData)

		local count =  GuildProxy.Instance:GetGuildPackItemNumByItemid(data.id)
		local str = string.format("%s/%s",tostring(count),tostring(data.num))

		self.isEnough = false
		if count >= data.num then
			self.isEnough = true
			self.count.text = str
		else
			self.count.text = string.format(redString, str)
		end
	end

	self.data = data
end

function ArtifactMakeMaterialCell:IsEnough()
	return self.isEnough
end

function ArtifactMakeMaterialCell:NeedCount()
	if self.isEnough then
		return 0
	else
		return self.data.num - GuildProxy.Instance:GetGuildPackItemNumByItemid(self.data.id)
	end
end