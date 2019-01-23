autoImport("WeddingBuyCell")

WeddingPackageView = class("WeddingPackageView", ContainerView)

WeddingPackageView.ViewType = UIViewType.PopUpLayer

local _WeddingProxy = WeddingProxy.Instance

function WeddingPackageView:OnExit()
	local _PictureManager = PictureManager.Instance
	local cells = self.itemWrapHelper:GetCellCtls()
	for i=1,#cells do
		cells[i]:UnLoadPic()
	end

	WeddingPackageView.super.OnExit(self)
end

function WeddingPackageView:Init()
	self:FindObjs()
	self:AddViewEvts()
	self:InitShow()
end

function WeddingPackageView:FindObjs()
	self.money = self:FindGO("Money"):GetComponent(UILabel)
end

function WeddingPackageView:AddViewEvts()
	self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
	self:AddListenEvt(ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd, self.UpdateView)
end

function WeddingPackageView:InitShow()
	local container = self:FindGO("Container")
	local wrapConfig = ReusableTable.CreateTable()
	wrapConfig.wrapObj = container
	wrapConfig.pfbNum = 4
	wrapConfig.cellName = "WeddingBuyCell"
	wrapConfig.control = WeddingBuyCell
	wrapConfig.dir = 2
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
	self.itemWrapHelper:AddEventListener(WeddingEvent.Buy, self.ClickBuy, self)
	ReusableTable.DestroyTable(wrapConfig)

	self:UpdateMoney()
	self:UpdateView()
end

function WeddingPackageView:UpdateView()
	local data = _WeddingProxy:GetWeddingPackageList()
	if data ~= nil then
		self.itemWrapHelper:UpdateInfo(data)
	end
end

function WeddingPackageView:UpdateMoney()
	self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
end

function WeddingPackageView:ClickBuy(cell)
	local data = cell.data
	if data ~= nil then
		local price = data:GetPrice()
		if price ~= nil then
			local itemName = ""
			local item = Table_Item[price.id]
			if item ~= nil then
				itemName = item.NameZh
			end

			local isEnough = _WeddingProxy:CheckIsEnough(price)
			if isEnough then
				local sb = LuaStringBuilder.CreateAsTable()
				sb:Append(StringUtil.NumThousandFormat(price.num))
				sb:Append(itemName)
				itemName = sb:ToString()
				sb:Destroy()

				local packageName = ""
				local staticData = Table_Item[data.id]
				if staticData ~= nil then
					packageName = staticData.NameZh
				end

				MsgManager.ConfirmMsgByID(9630, function ()
					ServiceWeddingCCmdProxy.Instance:CallBuyWeddingPackageCCmd(data.id, price.id)
				end, nil, nil, itemName, packageName)
			else
				MsgManager.ShowMsgByID(9620, itemName)
			end
		end
	end
end