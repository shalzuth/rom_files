ArtifactMakeData = class("ArtifactMakeData")

function ArtifactMakeData:ctor(data)
	self:Init()
	self:SetData(data)
end

function ArtifactMakeData:Init()
	self.isChoose = false
end

function ArtifactMakeData:SetData(data)
	self.artifactId = data
	self.staticData = Table_Artifact[data]
	if self.staticData then
		self.type=self.staticData.Type
		self.itemData = ItemData.new(nil,self.staticData.id)
	end
end

function ArtifactMakeData:SetChoose(isChoose)
	self.isChoose = isChoose
end

function ArtifactMakeData:IsChoose()
	return self.isChoose
end