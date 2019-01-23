autoImport("LotteryExpressBuyView")
autoImport("LotteryExpressPresentView")
LotteryExpressView = class("LotteryExpressView",ContainerView)

LotteryExpressView.ViewType = UIViewType.PopUpLayer

function LotteryExpressView:Init()
	self:FindObj()
	self:AddBtnEvt()
	self:AddViewEvt()
	self:InitShow()
end

function LotteryExpressView:FindObj()
	self.money = self:FindGO("Money"):GetComponent(UILabel)
	self.expressRoot = self:FindGO("ExpressRoot")
	self.buyRoot = self:FindGO("BuyRoot")
	self.limitLab = self:FindGO("limitLab"):GetComponent(UILabel)
end

function LotteryExpressView:AddBtnEvt()
end

function LotteryExpressView:ShowBuyView(flag)
	self.buyRoot:SetActive(flag)
	self.expressRoot:SetActive(not flag)
end

function LotteryExpressView:AddViewEvt()
	self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
end

function LotteryExpressView:InitShow()
	local data = self.viewdata.viewdata
	if data then
		self.monthData=data
	end
	self.tipData = {}
	self.tipData.funcConfig = {}
	local time = os.date("*t", ServerTime.CurServerTime()/1000)
	self.curYear = time.year
	self.curMonth = time.month
	local boxItemid = self.monthData and self.monthData.boxItemid or 3851
	self.itemdata = ItemData.new("LotteryExpress", boxItemid)

	local targetCellGO = self:FindGO("TargetCell")
	self.targetCell = BaseItemCell.new(targetCellGO)
	self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
	self.targetCell:SetData(self.itemdata)

	self:AddSubView("LotteryExpressBuyView", LotteryExpressBuyView)
	self:AddSubView("LotteryExpressPresentView",LotteryExpressPresentView)

	local moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
	local money = Table_Item[GameConfig.MoneyId.Lottery]
	if money and money.Icon then
		IconManager:SetItemIcon(money.Icon, moneyIcon)
	end

	self:UpdateMoney()
end

function LotteryExpressView:ClickTargetCell(cellctl)
	if(cellctl and cellctl.data)then
		self.tipData.itemdata = cellctl.data
		self:ShowItemTip(self.tipData , cellctl.icon , NGUIUtil.AnchorSide.Left, {-220,-30})
	end
end

function LotteryExpressView:IsCurMonth()
	if self.monthData and self.monthData.year == self.curYear and self.monthData.month == self.curMonth then
		return true
	end
	return false
end

function LotteryExpressView:SetPresentCount(c)
	self.presentCount=c
	self.itemdata.num=c
	self:SetLimitLab()
	self.targetCell:SetData(self.itemdata)
end

function LotteryExpressView:GetPresentCount()
	return self.presentCount
end

function LotteryExpressView:SetLimitLab()
	local cur = self.presentCount
	if(not self.sellPriceNum)then
		self.sellPriceNum=self:IsCurMonth() and GameConfig.Lottery.DiscountPrice or GameConfig.Lottery.SendPrice
	end
	local c = cur*self.sellPriceNum*10000
	local t = MyselfProxy.Instance:GetQuota()
	cur = StringUtil.NumThousandFormat(c)
	total = StringUtil.NumThousandFormat(t)
	if(c>t)then
		cur = string.format(ZhString.LotteryRedLimit,cur)
	end
	self.limitLab.text=string.format(ZhString.ShopMall_ExchangeExpressCredit,cur,total) 
end

function LotteryExpressView:UpdateMoney()
	self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
	self:SetLimitLab()
end


