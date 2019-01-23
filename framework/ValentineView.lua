ValentineView = class("ValentineView",ContainerView)

ValentineView.ViewType = UIViewType.NormalLayer

function ValentineView:Init()
	self:FindObj()
	self:AddEvt()
	self:AddViewEvt()
	self:InitShow()
end

function ValentineView:FindObj()
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.from = self:FindGO("From"):GetComponent(UILabel)
end

function ValentineView:AddEvt()
	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton, function ()
		self:CloseView()
	end)
end

function ValentineView:AddViewEvt()

end

function ValentineView:InitShow()
	self:UpdateView()
end

function ValentineView:RecvLoveLetterNtf(note)
	local data = note.body
	if data then
		self.content.text = data.content
		self.from.text = data.name
	end
end

function ValentineView:UpdateView()
	local data = StarProxy.Instance:GetFrontData()
	if data then
		self:SetData(data)
	end
end

function ValentineView:SetData(data)
	if data then
		local content = ""
		local letter = Table_LoveLetter[data.staticId]
		if letter and letter.Letter then
			content = letter.Letter
		end
		self.content.text = content
		self.from.text = data.name
	end
end

function ValentineView:CloseView()
	local isNext = StarProxy.Instance:ShowNext()
	if isNext then
		self:CloseSelf()
	else
		self:UpdateView()
	end
end