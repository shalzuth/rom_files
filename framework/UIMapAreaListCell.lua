local baseCell = autoImport("BaseCell")
UIMapAreaListCell = class("UIMapAreaListCell", baseCell)

function UIMapAreaListCell:Init()
	self.labName = self:FindGO("Name"):GetComponent(UILabel)
	self.goCurrency = self:FindGO("Currency")
	self.goTransfer = self:FindGO("Transfer")
	self.goCurrency:SetActive(false)
	self.goTransfer:SetActive(false)
	self:AddClickEvent(self.gameObject, function (go)
		self:OnClick(go)
	end)
end

function UIMapAreaListCell:SetData(data)
	--print("UIMapAreaListCell:SetData")
	self.areaID = data or 0
	self.areaInfo = Table_ItemType[self.areaID]
	if self.areaInfo then
		if(AppBundleConfig.GetSDKLang() == 'th') then
			self.labName.text = ZhString.CapraTransmission_Area .. self.areaInfo.Name
		else
			self.labName.text = self.areaInfo.Name .. ZhString.CapraTransmission_Area
		end
	end
end

function UIMapAreaListCell:OnClick(go)
	FunctionNpcFunc.JumpPanel(PanelConfig.UIMapMapList, {areaID = self.areaID});
end