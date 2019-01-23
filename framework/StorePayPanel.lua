StorePayPanel = class("StorePayPanel",BaseView)
StorePayPanel.ViewType = UIViewType.PopUpLayer

function StorePayPanel:Init()
    self:LoadView()
end

function StorePayPanel:LoadView()
    self.promotingIap = PlayerPrefs.GetString("PromotingIAP")
    PlayerPrefs.DeleteKey("PromotingIAP");
    helplog(self.promotingIap)
    self.curProduct = nil
    for _,v in pairs(Table_Deposit) do
        local tpro = v
        if(self.promotingIap ~= "" and tpro.ProductID == self.promotingIap) then
            self.curProduct = tpro
            break
        end
    end

    if(self.curProduct ~= nil) then

        self.PayBtn = self:FindGO("PayBtn")
        self:AddClickEvent(self.PayBtn, function (go)
            StorePayPanel:Pay(self.promotingIap)
        end)

        self.CloseBtn = self:FindGO("CloseButton")
        self:AddClickEvent(self.CloseBtn, function (go)
            self:PayEnd()
        end)

        self.title = self:FindGO("Title"):GetComponent(UILabel)
        self.title.text = self.curProduct and self.curProduct.Desc or ''

        self.paytitle = self:FindGO("PayTitle"):GetComponent(UILabel)
        self.paytitle.text = self.curProduct.priceStr ~=nil and self.curProduct.priceStr or '$' .. self.curProduct.Rmb

        self.zenytitle = self:FindGO("ZenyTitle"):GetComponent(UILabel)
        self.zenytitle.text = self.curProduct.priceStr ~=nil and self.curProduct.priceStr or '$' .. self.curProduct.Rmb

        local iconName = self.curProduct and self.curProduct.Picture or ''
        self.goIcon = self:FindGO('zeny', self.gameObject)
        self.spIcon = self.goIcon:GetComponent(UISprite)
        self.spIcon.spriteName = iconName
        self.spIcon:MakePixelPerfect()

        local priceObj = self:FindGO("price")
        local productDes = self:FindGO("producDes")
        local priceSprite =priceObj:GetComponent(UISprite)
        if(self.curProduct.Type == 1) then
            IconManager:SetItemIcon("item_100", priceSprite);
            priceSprite.width = 50
            priceSprite.height = 50
        elseif(self.curProduct.Type == 3) then
            IconManager:SetItemIcon("item_151", priceSprite);
            priceSprite.width = 60
            priceSprite.height = 60
        end

        if(self.curProduct.MonthLimit ~= nil) then
            priceObj:SetActive(false)
            self.productDesLabel = productDes:GetComponent(UILabel)
            -- 暂时写死 rrrrr
             local productId = self.curProduct.id
            local purchaseTimes = UIModelZenyShop.Ins():GetLuckyBagPurchaseTimes(productId) -- 全价
            if(purchaseTimes == 0) then
                 if(productId == 1777) then
                     productId = 1666
                 end
                local activity = UIModelZenyShop.Ins():GetProductActivity(productId) -- 半价
                if activity ~= nil then
                    local discountActivity = activity[1]
                    if discountActivity ~= nil then
                        local dActivityEndTime = discountActivity[5]
                        local serverTime = ServerTime.CurServerTime() / 1000
                        if dActivityEndTime > serverTime then
                            purchaseTimes = discountActivity[3]
                        else
                            purchaseTimes = -1
                        end
                    else
                        purchaseTimes = -1
                    end
                else
                    purchaseTimes = -1
                end
            end
        
            purchaseTimes = purchaseTimes or 0
        
            if(purchaseTimes ~= -1) then
                if(purchaseTimes >= self.curProduct.MonthLimit) then
                    self.productDesLabel.text = UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(string.format(ZhString.IAPBoughtLimit,self.curProduct.Desc))
                    self.PayBtn:SetActive(false)
                    self.productDesLabel.transform.localPosition = LuaVector3(0, -130, 0)
                else
                    self.productDesLabel.text = UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(string.format(
                        ZhString.LuckyBag_PurchaseTimesMonth,
                        purchaseTimes,
                        UIListItemCtrlLuckyBag.PaintColorMorePurchaseTimes(self.curProduct.MonthLimit)
                    ))
                end
            else
                self.productDesLabel.text = UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(ZhString.ActivityProductLimit)
                self.PayBtn:SetActive(false)
                self.productDesLabel.transform.localPosition = LuaVector3(0, -130, 0)
            end
        else
            productDes:SetActive(false)
        end
    end
end

function StorePayPanel:Pay(productID)
    local productCount = 1
    local roleGrade = MyselfProxy.Instance:RoleLevel() or 0
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = (server ~= nil) and server.serverid or nil
    local roleID = Game.Myself and (Game.Myself.data and Game.Myself.data.id or nil) or nil
    local this = self
    FunctionSDK.Instance:TXWYPay(
        productID,
        productCount,
        serverID,
        "{\"charid\":" .. roleID .. "}",
        roleGrade,
        function(x)
            this:PayEnd()
        end,
        function(x)
            this:PayEnd()
        end
    )
end

function StorePayPanel:PayEnd()
--    self:CloseSelf()
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, StorePayPanel.ViewType);
end

function StorePayPanel:OnEnter()
    StorePayPanel.super.OnEnter(self);
end

function StorePayPanel:OnExit()
    StorePayPanel.super.OnExit(self);
end

