EpCardDetailPanel = class("EpCardDetailPanel", ContainerView)

EpCardDetailPanel.ViewType = UIViewType.PopUpLayer
autoImport("BeautifulAreaPhotoHandler")

function EpCardDetailPanel:Init()
	self:initView()
	self:initData()
end

function EpCardDetailPanel:initData(  )
	-- body
	local data = self.viewdata.monthCardData

	if(GameConfig.EpCardTexture and GameConfig.EpCardTexture[data.staticId])then
		self.epLabel.text = data:GetName()
		PictureManager.Instance:SetEPCardUI(GameConfig.EpCardTexture[data.staticId], self.ModelTexture)
	end
end

function EpCardDetailPanel:initView(  )
	-- body
	self.ModelTexture = self:FindComponent("photo",UITexture)
	self.epLabel = self:FindComponent("epLabel",UILabel)
end

function EpCardDetailPanel:OnExit(  )
	-- body
	if(self.monthCardData and self.monthCardData.Picture)then
		PictureManager.Instance:UnLoadMonthCard(self.monthCardData.Picture, self.ModelTexture);
	end
end