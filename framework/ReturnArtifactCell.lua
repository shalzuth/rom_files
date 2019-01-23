local baseCell = autoImport("BaseCell")
ReturnArtifactCell = class("ReturnArtifactCell", baseCell)

function ReturnArtifactCell:Init()
	self:FindObjs()
	self:AddEvts()
end

function ReturnArtifactCell:FindObjs()
	self.name = self:FindComponent("name",UILabel)
	self.icon = self:FindComponent("icon", UISprite)
	self.chooseSymbol = self:FindGO("ChooseSymbol");
end

function ReturnArtifactCell:AddEvts()
	self:AddCellClickEvent()
end

function ReturnArtifactCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(nil~=data)
	if data then
		self.staticData = Table_Item[data.itemID]
		self.guid=data.guid
		self.name.text=self.staticData.NameZh
		IconManager:SetItemIcon(self.staticData.Icon, self.icon);
	end
	self:UpdateChoose();
end

function ReturnArtifactCell:UpdateChoose()
	local showChoose=false
	local datas = ArtifactProxy.Instance:GetReturnArtifact()
	for k,_ in pairs(datas) do
		if(self.data and k==self.guid)then
			showChoose=true
			break
		end
	end
	self.chooseSymbol:SetActive(showChoose)
end



