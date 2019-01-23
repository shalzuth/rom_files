autoImport("MVPResultCell")

MVPResultView = class("MVPResultView", ContainerView)

MVPResultView.ViewType = UIViewType.NormalLayer

function MVPResultView:Init()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function MVPResultView:AddEvts()
	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton, function ()
		ServiceNUserProxy.Instance:ReturnToHomeCity()
		self:CloseSelf()
	end)
end

function MVPResultView:AddViewEvts()
	self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function MVPResultView:InitShow()
	local wrapConfig = ReusableTable.CreateTable()
	wrapConfig.wrapObj = self:FindGO("Container")
	wrapConfig.pfbNum = 7
	wrapConfig.cellName = "MVPResultCell"
	wrapConfig.control = MVPResultCell
	wrapConfig.dir = 1
	self.wrapHelper = WrapCellHelper.new(wrapConfig)
	ReusableTable.DestroyAndClearTable(wrapConfig)

	self:UpdateView()
end

function MVPResultView:UpdateView()
	local data = PvpProxy.Instance:GetMvpResult()
	if data ~= nil then
		self.wrapHelper:UpdateInfo(data)

		local cells = self.wrapHelper:GetCellCtls()
		for i=1,#cells do
			cells[i]:SetNum(i)
		end
	end
end