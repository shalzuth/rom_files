ChristmasView = class("ChristmasView",ContainerView)

ChristmasView.ViewType = UIViewType.NormalLayer

local bgName = "letter_bg_10"

function ChristmasView:OnExit()
	PictureManager.Instance:UnLoadStar(bgName, self.bg)
	ChristmasView.super.OnExit(self)
end

function ChristmasView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function ChristmasView:FindObj()
	self.bg = self:FindGO("Background"):GetComponent(UITexture)
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.from = self:FindGO("From"):GetComponent(UILabel)
	self.save = self:FindGO("Save")
end

function ChristmasView:AddButtonEvt()
	self:AddClickEvent(self.save, function ()
		self:ClickSave()
	end)

	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton, function ()
		self:CloseView()
	end)
end

function ChristmasView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.ItemSaveLoveLetterCmd , self.CloseView)
end

function ChristmasView:InitShow()
	self.isQueue = self.viewdata.viewdata == nil

	PictureManager.Instance:SetStar(bgName, self.bg)

	self:UpdateView()
end

function ChristmasView:UpdateView()
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

function ChristmasView:SetData(data)
	if data then
		self.id = data.id
		
		self.content.text = data.content
		self.from.text = data.name

		self.save:SetActive(data.from == LoveLetterData.FromType.Server and data.type == LoveLetterData.Type.Christmas)
	end
end

function ChristmasView:ClickSave()
	if self.id then
		helplog("CallSaveLoveLetterCmd", self.id)
		ServiceItemProxy.Instance:CallSaveLoveLetterCmd(self.id)
	end	
end

function ChristmasView:CloseView()
	if self.isQueue then
		local isNext = StarProxy.Instance:ShowNext()
		if not isNext then
			self:UpdateView()
			return
		end
	end

	self:CloseSelf()
end