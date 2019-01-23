local baseCell = autoImport("BaseCell")
MVPResultHeadCell = class("MVPResultHeadCell", baseCell)

function MVPResultHeadCell:Init()
	self:FindObjs()
end

function MVPResultHeadCell:FindObjs()
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
end

function MVPResultHeadCell:SetData(data)
	self.data = data

	if data ~= nil then
		local staticData = Table_Monster[data]
		if staticData ~= nil then
			IconManager:SetFaceIcon(staticData.Icon, self.icon)
		end
	end
end