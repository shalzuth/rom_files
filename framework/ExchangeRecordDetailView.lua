autoImport("ExchangeRecordDetailCell")

ExchangeRecordDetailView = class("ExchangeRecordDetailView",ContainerView)

ExchangeRecordDetailView.ViewType = UIViewType.PopUpLayer

local normalItemColor = "%s%s%s"
local damageItemColor = "[c][cf1c0f]%s%s%s[-][/c]"

function ExchangeRecordDetailView:OnExit()
	ShopMallProxy.Instance:SetExchangeRecordDetailType(nil)
	ShopMallProxy.Instance:ResetExchangeRecordDetailList()
	ExchangeRecordDetailView.super.OnExit(self)
end

function ExchangeRecordDetailView:Init()
	self:FindObj()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function ExchangeRecordDetailView:FindObj()
	self.table = self:FindGO("Table"):GetComponent(UITable)
	self.info = self:FindGO("Info")
	self.turnLeft = self:FindGO("TurnLeft")
	self.turnRight = self:FindGO("TurnRight")
	self.page = self:FindGO("Page"):GetComponent(UILabel)
end

function ExchangeRecordDetailView:AddEvts()
	self:AddClickEvent(self.turnLeft,function ()
		self:ClickTurnLeft()
	end)	
	self:AddClickEvent(self.turnRight,function ()
		self:ClickTurnRight()
	end)
end

function ExchangeRecordDetailView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.RecordTradeFetchNameInfoCmd , self.RecvDetail)
end

function ExchangeRecordDetailView:InitShow()
	if self.viewdata.viewdata then
		local grid = self:FindGO("List")
		if grid then
			grid = grid:GetComponent(UIGrid)
			self.logCtl = UIGridListCtrl.new(grid, ExchangeRecordDetailCell, "ExchangeRecordDetailCell")
		end

		self:UpdateView()
		self:ResetPage()

		self:CallFetchNameInfo( self.currentPage )
	end
end

function ExchangeRecordDetailView:UpdateView()
	local data = self.viewdata.viewdata

	if data and data.type then
		local info
		--商品 icon+精炼等级+道具名（破损变红色）
		local itemData = Table_Item[data.itemid]
		if itemData then
			local iconInfo = string.format("{itemicon=%s}",data.itemid)
			local refineLv = data:GetRefineLvString()
			local itemName = itemData.NameZh
			local color = normalItemColor
			if data.damage then
				color = damageItemColor
			end

			itemInfo = string.format(color,iconInfo,refineLv,itemName)
		else
			errorLog(string.format("ExchangeRecordCell Table_Item[%s] == nil",data.itemid))
		end

		--普通出售+公示期出售成功
		if data.type == ShopMallLogTypeEnum.NormalSell or data.type == ShopMallLogTypeEnum.PublicitySellSuccess then
			local count = data:GetCount()

			info = string.format(ZhString.ShopMall_ExchangeRecordDetailSell ,
						count , itemInfo )

		--普通购买
		elseif data.type == ShopMallLogTypeEnum.NormalBuy then
			local count = data:GetCount()

			info = string.format(ZhString.ShopMall_ExchangeRecordDetailNormalBuy ,
						count , itemInfo )

		--公示期购买成功
		elseif data.type == ShopMallLogTypeEnum.PublicityBuySuccess then
			local count = data:GetTotalcount()
			local successCount = data:GetCount()		--成功个数

			info = string.format(ZhString.ShopMall_ExchangeRecordDetailPublicityBuySuccess ,
						count , itemInfo , successCount)
		end

		if info then
			self.infoSL = SpriteLabel.new(self.info,nil,30,36,true)
			self.infoSL:SetText(info,true)

			ShopMallProxy.Instance:SetExchangeRecordDetailType(data.type)
		end

		self:UpdateNameList()
	end
end

function ExchangeRecordDetailView:UpdatePage()
	self.page.text = self.currentPage.."/"..self.totalPage
end

function ExchangeRecordDetailView:UpdateNameList(id,type)
	if id and type then
		local data = self.viewdata.viewdata
		if data.id ~= id or data.type ~= type then
			return
		end
	end

	local nameList = ShopMallProxy.Instance:GetExchangeRecordDetailList()
	self.logCtl:ResetDatas(nameList)

	self.table:Reposition()
end

function ExchangeRecordDetailView:ClickTurnLeft()
	local page = self.currentPage - 1
	if page >= 1 then
		self.currentPage = page

		self:CallFetchNameInfo( self.currentPage )
	end
end

function ExchangeRecordDetailView:ClickTurnRight()
	self:CallFetchNameInfo( self.currentPage + 1 )
end

function ExchangeRecordDetailView:CallFetchNameInfo(index)
	if index and index > 0 then
		local data = self.viewdata.viewdata
		if data then
			ServiceRecordTradeProxy.Instance:CallFetchNameInfoCmd(data.id , data.type , index - 1)
		end
	end
end

function ExchangeRecordDetailView:ResetPage()
	self.currentPage = 1
	self.totalPage = 1
	self:UpdatePage()
end

function ExchangeRecordDetailView:RecvDetail(note)
	local data = note.body
	if data then
		self:UpdateNameList(data.id,data.type)

		if data.index then
			self.currentPage = data.index + 1
		end
		if data.total_page_count then
			self.totalPage = data.total_page_count
		end
		self:UpdatePage()
	end
end