autoImport("ShopMallExchangeSearchCombineCell")

ShopMallExchangeSearchView = class("ShopMallExchangeSearchView",ContainerView)

ShopMallExchangeSearchView.ViewType = UIViewType.PopUpLayer

function ShopMallExchangeSearchView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()	
end

function ShopMallExchangeSearchView:FindObjs()
	self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
	self.searchButton = self:FindGO("SearchButton")
	self.contentBg = self:FindGO("ContentBg")
	self.historyContainer = self:FindGO("HistoryContainer")
	self.contentContainer = self:FindGO("ContentContainer")

	UIUtil.LimitInputCharacter(self.contentInput, 20)
end

function ShopMallExchangeSearchView:AddEvts()
	self:AddClickEvent(self.searchButton,function (g)
		self:ClickSearchBtn()
	end)
	EventDelegate.Set(self.contentInput.onSubmit,function ()
		self:InputOnSubmit()
	end)
end

function ShopMallExchangeSearchView:AddViewEvts()
	-- body
end

function ShopMallExchangeSearchView:InitShow()

	self.contentBg:SetActive(false)

	local wrapConfig = {
		wrapObj = self.historyContainer, 
		pfbNum = 6, 
		cellName = "ShopMallExchangeSearchCombineCell", 
		control = ShopMallExchangeSearchCombineCell, 
		dir = 1,
	}
	self.historyWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.historyWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickHistory, self)

	TableUtility.TableClear(wrapConfig)
	wrapConfig.wrapObj = self.contentContainer
	wrapConfig.pfbNum = 6
	wrapConfig.cellName = "ShopMallExchangeSearchCombineCell"
	wrapConfig.control = ShopMallExchangeSearchCombineCell
	wrapConfig.dir = 1

	self.contentWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.contentWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickContent, self)

	self:UpdateHistory()
end

function ShopMallExchangeSearchView:UpdateHistory()
	local data = ShopMallProxy.Instance:GetExchangeSearchHistory()
	local newData = self:ReUniteCellData(data, 2)
	self.historyWrapHelper:UpdateInfo(newData)
end

function ShopMallExchangeSearchView:UpdateContent()
	local data = ShopMallProxy.Instance:GetExchangeSearchContent(self.contentInput.value)
	if #data > 0 then

		self.contentBg:SetActive(true)

		local newData = self:ReUniteCellData(data, 2)
		self.contentWrapHelper:UpdateInfo(newData)
	else
		self.contentBg:SetActive(false)
		MsgManager.ShowMsgByID(10252)
	end
end

function ShopMallExchangeSearchView:ClickSearchBtn()
	self:InputOnSubmit()
end

function ShopMallExchangeSearchView:InputOnSubmit()
	if #self.contentInput.value > 0 then
		self:UpdateContent()
	end
end

function ShopMallExchangeSearchView:ClickHistory(cellCtl)
	self:ClickCell(cellCtl)
end

function ShopMallExchangeSearchView:ClickContent(cellCtl)
	if cellCtl.data then
		LocalSaveProxy.Instance:AddExchangeSearchHistory(cellCtl.data)
	end
	self:ClickCell(cellCtl)
end

function ShopMallExchangeSearchView:ClickCell(cellCtl)
	local data = cellCtl.data
	if data and ItemData.CheckItemCanTrade(data) then
		self:sendNotification(ShopMallEvent.ExchangeSearchOpenDetail, cellCtl)
		self:CloseSelf()
	else
		MsgManager.ShowMsgByID(10252)
	end
end

local newData = {}
function ShopMallExchangeSearchView:ReUniteCellData(datas, perRowNum)
	TableUtility.TableClear(newData)
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/perRowNum)+1;
			local i2 = math.floor((i-1)%perRowNum)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end