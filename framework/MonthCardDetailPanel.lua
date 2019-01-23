MonthCardDetailPanel = class("MonthCardDetailPanel", ContainerView)

MonthCardDetailPanel.ViewType = UIViewType.PopUpLayer
autoImport("BeautifulAreaPhotoHandler")

function MonthCardDetailPanel:Init()
	self:initView()
	self:initData()
end

function MonthCardDetailPanel:initData(  )
	-- body
	self.monthCardData = self.viewdata.monthCardData
	if(self.monthCardData and self.monthCardData.Picture)then
		PictureManager.Instance:SetMonthCardUI(self.monthCardData.Picture, self.ModelTexture);
	end
end

function MonthCardDetailPanel:initView(  )
	-- body
	self.ModelTexture = self:FindGO("photo"):GetComponent(UITexture)
end

function MonthCardDetailPanel:OnExit(  )
	-- body
	if(self.monthCardData and self.monthCardData.Picture)then
		PictureManager.Instance:UnLoadMonthCard(self.monthCardData.Picture, self.ModelTexture);
	end
end