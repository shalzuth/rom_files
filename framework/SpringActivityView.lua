SpringActivityView = class("SpringActivityView",ContainerView)

SpringActivityView.ViewType = UIViewType.NormalLayer

local bgName = "letter_bg_cat"

function SpringActivityView:OnExit()
	PictureManager.Instance:UnLoadStar(bgName, self.bg)
	SpringActivityView.super.OnExit(self)
end

function SpringActivityView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function SpringActivityView:FindObj()
	self.bg = self:FindGO("Background"):GetComponent(UITexture)
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.from = self:FindGO("From"):GetComponent(UILabel)
	self.save = self:FindGO("Save")
end

function SpringActivityView:AddButtonEvt()
	self:AddClickEvent(self.save, function ()
		self:ClickSave()
	end)

	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton, function ()
		self:CloseView()
	end)
end

function SpringActivityView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.ItemSaveLoveLetterCmd , self.CloseView)
end

function SpringActivityView:InitShow()
	self.isQueue = self.viewdata.viewdata == nil

	PictureManager.Instance:SetStar(bgName, self.bg)

	self:UpdateView()
end

function SpringActivityView:UpdateView()
	local data
	if self.isQueue then
		data = StarProxy.Instance:GetFrontData()
	else
		data = self.viewdata.viewdata
	end
	if data then
		self:SetData(data)
	end
end

function SpringActivityView:SetData(data)
	if data then
		self.id = data.id		
		self.content.text = data.content
		self.from.text = data.name
		self.save:SetActive(data.from == LoveLetterData.FromType.Server and data.type == LoveLetterData.Type.SpringActivity)
	end
end

function SpringActivityView:ClickSave()
	if self.id then
		ServiceItemProxy.Instance:CallSaveLoveLetterCmd(self.id)
	end	
end

function SpringActivityView:CloseView()
	if self.isQueue then
		local isNext = StarProxy.Instance:ShowNext()
		if not isNext then
			self:UpdateView()
			return
		end
	end

	self:CloseSelf()
end