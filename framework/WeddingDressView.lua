WeddingDressView = class("WeddingDressView",ContainerView)

WeddingDressView.ViewType = UIViewType.NormalLayer

local backgroundName = "marry_bg_process"
local _PictureManager = PictureManager.Instance

function WeddingDressView:OnExit()
	_PictureManager:UnLoadWedding(backgroundName, self.backgroundL)
	_PictureManager:UnLoadWedding(backgroundName, self.backgroundR)
	WeddingDressView.super.OnExit(self)
end

function WeddingDressView:Init()
	self:FindObj()
	self:InitShow()
end

function WeddingDressView:FindObj()
	self.backgroundL = self:FindGO("BackgroundL"):GetComponent(UITexture)
	self.backgroundR = self:FindGO("BackgroundR"):GetComponent(UITexture)
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.from = self:FindGO("From"):GetComponent(UILabel)
end

function WeddingDressView:InitShow()
	_PictureManager:SetWedding(backgroundName, self.backgroundL)
	_PictureManager:SetWedding(backgroundName, self.backgroundR)

	self:UpdateView()
end

function WeddingDressView:UpdateView()
	local data = self.viewdata.viewdata
	if data then
		self:SetData(data)
	end
end

function WeddingDressView:SetData(data)
	if data then
		helplog(data.content, data.name)
		self.content.text = data.content
		self.from.text = data.name
	end
end