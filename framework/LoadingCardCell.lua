local baseCell = autoImport("BaseCell")
LoadingCardCell = class("LoadingCardCell", baseCell)
LoadingCardCell.cardCellResID = ResourcePathHelper.UICell("LoadingCardCell")

function LoadingCardCell:Init()
	self.gameObject = Game.AssetManager_UI:CreateAsset(LoadingCardCell.cardCellResID);
	self:FindObjs()
end

function LoadingCardCell:FindObjs()
    self.card = self:FindGO("Card"):GetComponent(UITexture);
    self.cardName = self:FindComponent("CardName", UILabel);
end

function LoadingCardCell:SetData(data)
	self.data = data
	self.cardName.text = data.Name;
	PictureManager.Instance:SetCard(data.Picture,self.card)
	-- self.card:MakePixelPerfect()
end

function LoadingCardCell:DisposeTexture()
	self.card.mainTexture = nil
	PictureManager.Instance:UnLoadCard(self.data.Picture,self.card)
end