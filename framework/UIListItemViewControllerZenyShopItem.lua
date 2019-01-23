autoImport('FunctionADBuiltInTyrantdb')
autoImport('FuncZenyShop')
autoImport('UIModelZenyShop')
autoImport('UIListItemCtrlLuckyBag')

UIListItemViewControllerZenyShopItem = class('UIListItemViewControllerZenyShopItem', BaseCell)

local gReusableTable = {}
local gReusableLuaVector3 = LuaVector3.zero

function UIListItemViewControllerZenyShopItem:Init()
	self:GetGameObjects()
	self:RegisterButtonClickEvent()
	self:ListenServerResponse()
end

function UIListItemViewControllerZenyShopItem:OnExit()
	EventManager.Me():RemoveEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
	EventManager.Me():RemoveEventListener(ServiceEvent.SessionSocialityQueryChargeVirginCmd, self.OnReceiveQueryChargeVirgin, self)
end

function UIListItemViewControllerZenyShopItem:GetGameObjects()
	self.goZenyCount = self:FindGO('ZenyCount', self.gameObject)
	self.goZenyIcon = self:FindGO('Icon', self.goZenyCount)
	self.spZenyIcon = self.goZenyIcon:GetComponent(UISprite)
	self.goLabZenyCount = self:FindGO('Lab', self.goZenyCount)
	self.labZenyCount = self.goLabZenyCount:GetComponent(UILabel)
	self.goBTNPurchase = self:FindGO('BTN_Purchase', self.gameObject)
	self.goTitleOfBTNPurchase = self:FindGO('Title', self.goBTNPurchase)
	self.labTitleOfBTNPurchase = self.goTitleOfBTNPurchase:GetComponent(UILabel)
	self.goAddition = self:FindGO('Addition', self.gameObject)
	self.goLabAddition = self:FindGO('Lab', self.goAddition)
	self.labAddition = self.goLabAddition:GetComponent(UILabel)
	self.goProductName = self:FindGO('Name', self.gameObject)
	self.goLabProductName = self:FindGO('Lab', self.goProductName)
	self.labProductName = self.goLabProductName:GetComponent(UILabel)
	self.goZenyIconAnimation = self:FindGO('ZenyIconAnimation', self.gameObject)
	self.goZenyIcon = self:FindGO('ZenyIcon', self.goZenyIconAnimation)
	self.goIcon = self:FindGO('Icon', self.gameObject)
	self.spIcon = self.goIcon:GetComponent(UISprite)
	self.goDiscount = self:FindGO('Discount', self.gameObject)
	self.goPercent = self:FindGO('Percent', self.goDiscount)
	self.labPercent = self:FindGO('Value1', self.goPercent):GetComponent(UILabel)
	self.goGainMore = self:FindGO('GainMore', self.gameObject)
	self.labMultipleNumber = self:FindGO('Value', self.goGainMore):GetComponent(UILabel)
	self.goPurchaseTimes = self:FindGO('PurchaseTimes', self.gameObject)
	self.labPurchaseTimes = self:FindGO('Lab', self.goPurchaseTimes):GetComponent(UILabel)
	self.labFirstPurchase = self:FindGO('FirstPurchase', self.gameObject)
end

function UIListItemViewControllerZenyShopItem:SetData(data)
	self.productID = data
	self:GetModelSet()

	self:LoadView()
	self:OpenPurchaseSwitch()
end

function UIListItemViewControllerZenyShopItem:GetModelSet()
	self.productConf = Table_Deposit[self.productID]

	self.activity = UIModelZenyShop.Ins():GetProductActivity(self.productID)
	if self.activity ~= nil then
		self.discountActivity = self.activity[1]
		if self.discountActivity ~= nil then
			local dActivityEndTime = self.discountActivity[5]
			local serverTime = ServerTime.CurServerTime() / 1000
			if dActivityEndTime > serverTime then
				self.activityProductID = self.discountActivity[2]
				self.productConf = Table_Deposit[self.activityProductID]
			end
		end
		self.gainMoreActivity = self.activity[2]
	end
end

function UIListItemViewControllerZenyShopItem:LoadView()
	local zenyItemID = self.productConf.ItemId
	local zenyItem = Table_Item[zenyItemID]
	IconManager:SetItemIcon(zenyItem.Icon, self.spZenyIcon)
	local zenyCount = self.productConf and self.productConf.Count or 0
	local milCommaZenyCount = FuncZenyShop.FormatMilComma(zenyCount)
	if milCommaZenyCount then
		self.labZenyCount.text = milCommaZenyCount
	end
	local currency = self.productConf and self.productConf.Rmb or 0
	--todo xde
	self.labTitleOfBTNPurchase.text = self.productConf.priceStr ~=nil and self.productConf.priceStr
		or '$' .. self.productConf.Rmb
	--	if math.floor(currency) == currency then
	--		strCurrency = strCurrency .. '.00'
	--	end
--	self.labTitleOfBTNPurchase.text = self.productConf.CurrencyType .. " " .. tostring(currency)
--	if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
--		self.labTitleOfBTNPurchase.text = self.productConf.CurrencyType .. " " .. FuncZenyShop.FormatMilComma(currency)
--	end
	--	self.labTitleOfBTNPurchase.text = '¥ ' .. strCurrency --todo xde 注释
	local zenyAdditionCount = nil
	if UIModelZenyShop.Ins():IsFPR(self.productID) then
		if self.productConf ~= nil then
			zenyAdditionCount = self.productConf.VirginCount
		else
			zenyAdditionCount = 0
		end
	else
		if self.productConf ~= nil then
			zenyAdditionCount = self.productConf.Count2
		else
			zenyAdditionCount = 0
		end
	end
	if zenyAdditionCount > 0 then
		self.goAddition:SetActive(true)
		local milCommaZenyAdditionCount = FuncZenyShop.FormatMilComma(zenyAdditionCount)
		if milCommaZenyAdditionCount then
			--todo xde 泰语特殊处理一下
			if(AppBundleConfig.GetSDKLang() == 'th') then
				self.labAddition.text =   ZhString.Giving .. milCommaZenyAdditionCount -- 修复语序问题
			else
				self.labAddition.text =   milCommaZenyAdditionCount .. ZhString.Giving -- 修复语序问题
			end
		end
	else
		self.goAddition:SetActive(false)
	end
	local productName = self.productConf and self.productConf.Desc or ''
	self.labProductName.text = productName
	UIUtil.WrapLabel(self.labProductName);
	local iconName = self.productConf and self.productConf.Picture or ''
	self.spIcon.spriteName = iconName
	self.spIcon:MakePixelPerfect()

	self.goDiscount:SetActive(false)
	self.goZenyCount:SetActive(true)
	self.goPurchaseTimes:SetActive(false)
	if self.discountActivity ~= nil then
		local dActivityEndTime = self.discountActivity[5]
		local serverTime = ServerTime.CurServerTime()/ 1000
		if dActivityEndTime > serverTime then
			local activityTimes = self.discountActivity[1]
			local activityUsedTimes = self.discountActivity[3]
			if activityUsedTimes < activityTimes then
				self.goDiscount:SetActive(true)
				local activityPrice = Table_Deposit[self.activityProductID].Rmb
				local discount = activityPrice / currency
				discount = math.ceil(discount)
				self.labPercent.text = discount
				self.goZenyCount:SetActive(false)
				self.goPurchaseTimes:SetActive(true)
				local isOccupyOriginalTimes = self.discountActivity[7]
				self.labPurchaseTimes.text = string.format(
					ZhString.LuckyBag_PurchaseTimesMonth,
					activityUsedTimes,
					UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(activityTimes)
				)
			end
		end
	end

	self.goGainMore:SetActive(false)
	self.goZenyCount:SetActive(true)
	self.goPurchaseTimes:SetActive(false)
	if self.gainMoreActivity ~= nil then
		local gActivityEndTime = self.gainMoreActivity[5]
		local serverTime = ServerTime.CurServerTime()/ 1000
		if gActivityEndTime > serverTime then
			local activityTimes = self.gainMoreActivity[1]
			local activityUsedTimes = self.gainMoreActivity[3]
			if activityUsedTimes < activityTimes then
				self.goGainMore:SetActive(true)
				self.labMultipleNumber.text = 'x' .. self.gainMoreActivity[2]
				self.goZenyCount:SetActive(false)
				self.goPurchaseTimes:SetActive(true)
				self.labPurchaseTimes.text = string.format(
					ZhString.LuckyBag_PurchaseTimesMonth,
					activityUsedTimes,
					UIListItemCtrlLuckyBag.PaintColorPurchaseTimes(activityTimes)
				)
			end
		end
	end

	local b = UIModelZenyShop.Ins():IsFPR(self.productID) == true;
	self.labFirstPurchase:SetActive(b);
end

function UIListItemViewControllerZenyShopItem:RegisterButtonClickEvent()
	self:AddClickEvent(self.goBTNPurchase, function ()
		--		self:OnClickForButtonPurchase()
		--todo xde 恢复购买提示
		local productID = self.productConf.ProductID
		if productID then
			local productName =  OverSea.LangManager.Instance():GetLangByKey(Table_Item[self.productConf.ItemId].NameZh)
			local productPrice = self.productConf.Rmb
			local productCount = self.productConf.Count
			local currencyType = self.productConf.CurrencyType
			self:OnClickForButtonPurchase()
--			GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ShopConfirmPanel,
--				viewdata = { data = { title = string.format("[262626FF]"..ZhString.ShopConfirmTitle.."[-]"," [0075BCFF]"..productCount.."[-] "..productName,currencyType,productPrice), desc = ZhString.ShopConfirmDes,
--					callback = function()
--						self:OnClickForButtonPurchase()
--					end}}});
		end
	end)
end

function UIListItemViewControllerZenyShopItem:ListenServerResponse()
	EventManager.Me():AddEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
	EventManager.Me():AddEventListener(ServiceEvent.SessionSocialityQueryChargeVirginCmd, self.OnReceiveQueryChargeVirgin, self)
end

function UIListItemViewControllerZenyShopItem:OnPaySuccess(str_result)
	local strResult = str_result or 'nil'
	Debug.Log('UIListItemViewControllerZenyShopItem:OnPaySuccess, ' .. strResult)

	if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
		local runtimePlatform = ApplicationInfo.GetRunPlatform()
		if runtimePlatform == RuntimePlatform.IPhonePlayer then
			if self.orderIDOfXDSDKPay ~= nil then
				FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(self.orderIDOfXDSDKPay, self.productConf.Rmb)
			end
		elseif runtimePlatform == RuntimePlatform.Android then
			if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
				-- "" is orderID
				FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd("", self.productConf.Rmb)
			else
				local orderID = FunctionSDK.Instance:GetOrderID()
				FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(orderID, self.productConf.Rmb)
			end
		end
	end
end

function UIListItemViewControllerZenyShopItem:OnPayFail(str_result)
	local strResult = str_result or 'nil'
	Debug.Log('UIListItemViewControllerZenyShopItem:OnPayFail, ' .. strResult)
end

function UIListItemViewControllerZenyShopItem:OnPayTimeout(str_result)
	local strResult = str_result or 'nil'
	Debug.Log('UIListItemViewControllerZenyShopItem:OnPayTimeout, ' .. strResult)
end

function UIListItemViewControllerZenyShopItem:OnPayCancel(str_result)
	local strResult = str_result or 'nil'
	Debug.Log('UIListItemViewControllerZenyShopItem:OnPayCancel, ' .. strResult)
end

function UIListItemViewControllerZenyShopItem:OnPayProductIllegal(str_result)
	local strResult = str_result or 'nil'
	Debug.Log('UIListItemViewControllerZenyShopItem:OnPayProductIllegal, ' .. strResult)
end

function UIListItemViewControllerZenyShopItem:OnPayPaying(str_result)
	local strResult = str_result or 'nil'
	Debug.Log('UIListItemViewControllerZenyShopItem:OnPayPaying, ' .. strResult)
end

function UIListItemViewControllerZenyShopItem:OnClickForButtonPurchase()
	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	if runtimePlatform == RuntimePlatform.IPhonePlayer then
		if self.productConf.Type == 3 then
			if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
				MsgManager.ConfirmMsgByID(
					3555,
					function ()
						AppBundleConfig.JumpToIOSAppStore()
					end,
					nil
				)
				return
			end
		end
	end

	self:RequestQueryChargeVirgin()

	if self:CouldPurchaseWithActivity() then
		if self.purchaseSwitch then
			self:ClosePurchaseSwitch()
			self:Purchase()
			self.isActivity = true
			if self.timerForPurchaseSwitch == nil then
				local interval = GameConfig.PurchaseMonthlyVIP.interval or 30 * 1000
				self.timerForPurchaseSwitch = TimeTickManager.Me():CreateTick(interval, interval, function ()
					self.timerForPurchaseSwitch:StopTick()
					self:OpenPurchaseSwitch()
				end, self, 1)
			else
				self.timerForPurchaseSwitch:Restart()
			end
		else
			MsgManager.ShowMsgByID(49)
		end
	else
		self:Purchase()
		self.isActivity = false
	end
end

function UIListItemViewControllerZenyShopItem:OnReceiveUpdateActivityCnt(data)
	self:GetModelSet()
	self:LoadView()
end

function UIListItemViewControllerZenyShopItem:CouldPurchaseWithActivity()
	if self.discountActivity ~= nil then
		local dActivityEndTime = self.discountActivity[5]
		local serverTime = ServerTime.CurServerTime() / 1000
		if dActivityEndTime > serverTime then
			local activityTimes = self.discountActivity[1]
			local activityUsedTimes = self.discountActivity[3]
			if activityUsedTimes < activityTimes and activityTimes > 0 then
				return true
			end
		end
	end
	if self.gainMoreActivity ~= nil then
		local gActivityEndTime = self.gainMoreActivity[5]
		local serverTime = ServerTime.CurServerTime() / 1000
		if gActivityEndTime > serverTime then
			local activityTimes = self.gainMoreActivity[1]
			local activityUsedTimes = self.gainMoreActivity[3]
			if activityUsedTimes < activityTimes and activityTimes > 0 then
				return true
			end
		end
	end
	return false
end

function UIListItemViewControllerZenyShopItem:RequestQueryChargeVirgin()
	ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end

function UIListItemViewControllerZenyShopItem:OnReceiveQueryChargeVirgin(message)
	self:LoadView()
end

function UIListItemViewControllerZenyShopItem:OpenPurchaseSwitch()
	self.purchaseSwitch = true
end

function UIListItemViewControllerZenyShopItem:ClosePurchaseSwitch()
	self.purchaseSwitch = false
end

function UIListItemViewControllerZenyShopItem:Purchase()
	-- local serverTime = ServerTime.CurServerTime()
	-- local orderID = tostring(math.floor(serverTime / 1000))
	-- local roleID = tostring(Game.Myself.data.id)
	-- local serverID = tostring(FunctionLogin.Me():getCurServerData().serverid)
	-- local url = string.format('http://172.24.15.238:5559/ios_charge?app=7fwwzfp5n7ggock&app_id=20001&app_order_id=B6CAEAF7258A40ECBD561DD8D537B400&client_id=7fwwzfp5n7ggock&ext={\"productGameID\":\"%d\",\"serverID\":\"%s\"}&gold=%d&order_id=%s&product_id=%s&role_id=%s&timestamp=1481203239&user_id=35612442&sign=c8266868767a767c3a7cf1e2b9441a37', self.productConf.id, serverID, self.productConf.Rmb, orderID, self.productConf.ProductID, roleID)
	-- HttpRequest.Instance:HTTPPost(url, nil, function (www)
	-- 	print(www.text)
	-- end)
	if self.productConf then
		local productID = self.productConf.ProductID
		if productID then
			local productName = self.productConf.Desc
			local productPrice = self.productConf.Rmb
			local productCount = 1
			local roleID = Game.Myself and (Game.Myself.data and Game.Myself.data.id or nil) or nil
			if roleID then
				local roleInfo = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
				local roleName = roleInfo and roleInfo.name or ''
				local roleGrade = MyselfProxy.Instance:RoleLevel() or 0
				local roleBalance = MyselfProxy.Instance:GetROB() or 0
				local server = FunctionLogin.Me():getCurServerData()
				local serverID = (server ~= nil) and server.serverid or nil
				if serverID then
					--todo xde 不管怎么样都用天下网游的支付
					local currentServerTime = ServerTime.CurServerTime() / 1000
					TableUtility.TableClear(gReusableTable)
					FunctionSDK.Instance:TXWYPay(
						productID,
						productCount,
						serverID,
						"{\"charid\":" .. roleID .. "}",
						roleGrade,
						function(x)
							self:OnPaySuccess(x)
						end,
						function(x)
							self:OnPayCancel(x)
						end
					)
					--					local runtimePlatform = ApplicationInfo.GetRunPlatform()
					--					if runtimePlatform == RuntimePlatform.Android and not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
					--						TableUtility.TableClear(gReusableTable)
					--						gReusableTable['productGameID'] = tostring(self.productConf.id)
					--						gReusableTable['serverID'] = tostring(serverID)
					--						gReusableTable['payCallbackCode'] = 1
					--						local ext = json.encode(gReusableTable)
					--						FunctionXDSDK.Ins:Pay(
					--							productName,
					--							productID,
					--							productPrice * 100,
					--							serverID,
					--							tostring(roleID),
					--							"", -- order id
					--							ext,
					--							function (x)
					--								self:OnPaySuccess(x)
					--							end,
					--							function (x)
					--								self:OnPayFail(x)
					--							end,
					--							function (x)
					--								self:OnPayCancel(x)
					--							end
					--						)
					--					else
					--						if FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.Any then
					--							if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V8) then
					--								FunctionSDK.Instance:ResetPayState()
					--							end
					--							TableUtility.TableClear(gReusableTable)
					--							gReusableTable['productGameID'] = self.productConf.id
					--							local custom = json.encode(gReusableTable)
					--							FunctionSDK.Instance:AnySDKPay(
					--								productID,
					--								productName,
					--								productPrice,
					--								productCount,
					--								tostring(roleID),
					--								roleName,
					--								roleGrade,
					--								roleBalance,
					--								tostring(serverID),
					--								custom,
					--								function (x)
					--									self:OnPaySuccess(x)
					--								end,
					--								function (x)
					--									self:OnPayFail(x)
					--								end,
					--								function (x)
					--									self:OnPayTimeout(x)
					--								end,
					--								function (x)
					--									self:OnPayCancel(x)
					--								end,
					--								function (x)
					--									self:OnPayProductIllegal(x)
					--								end,
					--								function (x)
					--									self:OnPayPaying(x)
					--								end
					--							)
					--						elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.XD then
					--							TableUtility.TableClear(gReusableTable)
					--							gReusableTable['productGameID'] = tostring(self.productConf.id)
					--							gReusableTable['serverID'] = tostring(serverID)
					--							local ext = json.encode(gReusableTable)
					--							if not BackwardCompatibilityUtil.CompatibilityMode_V17 then
					--								local roleAndServerTime = roleID .. '_' .. currentServerTime
					--								self.orderIDOfXDSDKPay = MyMD5.HashString(roleAndServerTime)
					--								FunctionSDK.Instance:XDSDKPay(
					--									productPrice * 100,
					--									tostring(serverID),
					--									productID,
					--									productName,
					--									tostring(roleID),
					--									ext,
					--									productCount,
					--									self.orderIDOfXDSDKPay,
					--									function (x)
					--										self:OnPaySuccess(x)
					--									end,
					--									function (x)
					--										self:OnPayFail(x)
					--									end,
					--									function (x)
					--										self:OnPayTimeout(x)
					--									end,
					--									function (x)
					--										self:OnPayCancel(x)
					--									end,
					--									function (x)
					--										self:OnPayProductIllegal(x)
					--									end
					--								)
					--							elseif not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
					--								self.orderIDOfXDSDKPay = FunctionSDK.Instance:XDSDKPay(
					--									productPrice * 100,
					--									tostring(serverID),
					--									productID,
					--									productName,
					--									tostring(roleID),
					--									ext,
					--									productCount,
					--									function (x)
					--										self:OnPaySuccess(x)
					--									end,
					--									function (x)
					--										self:OnPayFail(x)
					--									end,
					--									function (x)
					--										self:OnPayTimeout(x)
					--									end,
					--									function (x)
					--										self:OnPayCancel(x)
					--									end,
					--									function (x)
					--										self:OnPayProductIllegal(x)
					--									end
					--								)
					--							else
					--								FunctionSDK.Instance:XDSDKPay(
					--									productPrice * 100,
					--									tostring(serverID),
					--									productID,
					--									productName,
					--									tostring(roleID),
					--									ext,
					--									productCount,
					--									function (x)
					--										self:OnPaySuccess(x)
					--									end,
					--									function (x)
					--										self:OnPayFail(x)
					--									end,
					--									function (x)
					--										self:OnPayTimeout(x)
					--									end,
					--									function (x)
					--										self:OnPayCancel(x)
					--									end,
					--									function (x)
					--										self:OnPayProductIllegal(x)
					--									end
					--								)
					--							end
					--						end
					--					end
				end
			end
		end
	end
end

function UIListItemViewControllerZenyShopItem:SetZenyIconCount()
	local zenyIconCount = GameConfig.ZenyIconAnimation.countOfZenyIcon[self.productID]
	if zenyIconCount and zenyIconCount > 0 then
		self:DoSetZenyIconCount(zenyIconCount)
	end
end

function UIListItemViewControllerZenyShopItem:DoSetZenyIconCount(count)
	if self.zenyIconRoot then
		for i = 1, count do
			local goCopyZenyIcon = GameObject.Instantiate(self.goZenyIcon)
			goCopyZenyIcon:SetActive(true)
			local transCopyZenyIcon = goCopyZenyIcon.transform
			transCopyZenyIcon:SetParent(self.zenyIconRoot)
			local pos = transCopyZenyIcon.localPosition
			pos.x = -1280; pos.y = 0; pos.z = 0
			transCopyZenyIcon.localPosition = pos
			local rotation = transCopyZenyIcon.localRotation
			local eulerAngles = rotation.eulerAngles
			eulerAngles.x = 0; eulerAngles.y = 0; eulerAngles.z = 0
			rotation.eulerAngles = eulerAngles
			transCopyZenyIcon.localRotation = rotation
			local scale = transCopyZenyIcon.localScale
			scale.x = 1; scale.y = 1; scale.z = 1
			transCopyZenyIcon.localScale = scale
		end
	else
		LogUtility.Error('self.zenyIconRoot is nil')
	end
end

function UIListItemViewControllerZenyShopItem:PlayZenyIconAnimation(end_callback)
	if self.zenyIconRoot then
		local transZenyIconAnimation = self.goZenyIconAnimation.transform
		local pos = transZenyIconAnimation.position
		self.zenyIconRoot.position = pos

		self:PlayZenyIconAnimation1(function ()
			self:PlayZenyIconAnimation2(end_callback)
		end)
	else
		LogUtility.Error('self.zenyIconRoot is nil')
	end
end

-- only children exist, may call end_callback
function UIListItemViewControllerZenyShopItem:PlayZenyIconAnimation1(end_callback)
	if self.zenyIconRoot then
		local childCount = self.zenyIconRoot.childCount
		if childCount > 0 then
			local zenyIconEndFlag = {}
			for m = 0, childCount - 1 do
				zenyIconEndFlag[m] = false
			end

			if not self:GetRandomDiffusionTargetPosition() then -- fault-tolerant(configuration)
				if end_callback then
					end_callback()
				end
			else
				for i = 0, childCount - 1 do
					local child = self.zenyIconRoot:GetChild(i)
					child.gameObject:SetActive(true)
					gReusableLuaVector3:Set(0, 0, 0)
					child.localPosition = gReusableLuaVector3
					local scale = child.localScale
					gReusableLuaVector3:Set(1, 1, 1)
					child.localScale = gReusableLuaVector3
					local delta = GameConfig.ZenyIconAnimation.diffusionTime or 0
					local targetPosition = self:GetRandomDiffusionTargetPosition()
					local tp = TweenPosition.Begin(child.gameObject, delta, targetPosition, false)
					tp.method = 2
					tp:SetOnFinished(function ()
						zenyIconEndFlag[i] = true

						local allZenyIconIsEnd = true
						for j = 0, childCount - 1 do
							if zenyIconEndFlag[j] == false then
								allZenyIconIsEnd = false
								break
							end
						end

						if allZenyIconIsEnd then
							if end_callback then
								end_callback()
							end
							end_callback = nil
						end
					end)
				end
			end
		end
	else
		LogUtility.Error('self.zenyIconRoot is nil')
	end
end

-- only children exist, may call end_callback
function UIListItemViewControllerZenyShopItem:PlayZenyIconAnimation2(end_callback)
	local childCount = self.zenyIconRoot.childCount
	if childCount > 0 then
		local zenyIconEndFlag = {}
		for m = 0, childCount - 1 do
			zenyIconEndFlag[m] = false
		end

		if not self.zenyIconTargetPosition then -- fault-tolerant(client code)
			if end_callback then
				end_callback()
			end
		else
			for i = 0, childCount - 1 do
				local child = self.zenyIconRoot:GetChild(i)
				local delta = GameConfig.ZenyIconAnimation.flyToTargetTime or 0
				local targetPosition = self.zenyIconTargetPosition
				local tp = TweenPosition.Begin(child.gameObject, delta, targetPosition, true)
				tp.method = 1
				tp:SetOnFinished(function ()
					gReusableLuaVector3:Set(-1280, 0, 0)
					child.localPosition = gReusableLuaVector3
					zenyIconEndFlag[i] = true

					local allZenyIconIsEnd = true
					for j = 0, childCount - 1 do
						if zenyIconEndFlag[j] == false then
							allZenyIconIsEnd = false
							break
						end
					end

					if allZenyIconIsEnd then
						if end_callback then
							end_callback()
						end
						end_callback = nil
					end
				end)
				local targetScale = GameConfig.ZenyIconAnimation.scaleWhenReachTarget
				gReusableLuaVector3:Set(targetScale, targetScale, targetScale)
				local ts = TweenScale.Begin(child.gameObject, delta, gReusableLuaVector3)
			end
		end
	end
end

function UIListItemViewControllerZenyShopItem:GetRandomDiffusionTargetPosition()
	local direction = math.random(0, 360)
	local diffusionDistanceMin = GameConfig.ZenyIconAnimation.diffusionDistanceMin or 0
	local diffusionDistanceMax = GameConfig.ZenyIconAnimation.diffusionDistanceMax or 0
	if diffusionDistanceMax > diffusionDistanceMin then
		local distance = math.random(diffusionDistanceMin, diffusionDistanceMax)
		local xValue = distance * math.cos(direction / 180 * math.pi)
		local yValue = distance * math.sin(direction / 180 * math.pi)
		gReusableLuaVector3.x = xValue; gReusableLuaVector3.y = yValue; gReusableLuaVector3.z = 0
		return gReusableLuaVector3
	end
	return nil
end

function UIListItemViewControllerZenyShopItem:RegisterZenyIconTargetPosition(pos)
	self.zenyIconTargetPosition = pos
end

function UIListItemViewControllerZenyShopItem:SetZenyIconRoot(trans)
	self.zenyIconRoot = trans
end