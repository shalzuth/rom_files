local baseCell = autoImport("BaseCell")
TutorTaskRewardCell = class("TutorTaskRewardCell", baseCell)

function TutorTaskRewardCell:Init()
	self:FindObjs()
end

function TutorTaskRewardCell:FindObjs()
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
	self.num = self:FindGO("Num"):GetComponent(UILabel)
end

function TutorTaskRewardCell:SetData(data)
	self.data = data

	if data then
		local item = Table_Item[data.id]
		if item then
			IconManager:SetItemIcon(item.Icon, self.icon)
		end

		self.num.text = data.num
	end
end