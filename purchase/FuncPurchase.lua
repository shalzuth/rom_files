FuncPurchase = class('FuncPurchase')

local gReusableTable = {}

function FuncPurchase.Instance()
	if FuncPurchase.instance == nil then
		FuncPurchase.instance = FuncPurchase.new()
	end
	return FuncPurchase.instance
end

function FuncPurchase:ctor()
	self.callbacks = {}
end

function FuncPurchase:OnPaySuccess(product_conf, str_result)
	if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
		local runtimePlatform = ApplicationInfo.GetRunPlatform()
		if runtimePlatform == RuntimePlatform.IPhonePlayer then
			if self.orderIDOfXDSDKPay ~= nil then
				FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(self.orderIDOfXDSDKPay, product_conf.Rmb)
			end
		elseif runtimePlatform == RuntimePlatform.Android then
			if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
				-- "" is orderID
				FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd("", product_conf.Rmb)
			else
				local orderID = FunctionSDK.Instance:GetOrderID()
				FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(orderID, product_conf.Rmb)
			end
		end
	end

	local callbackSuccess = self.callbacks[product_conf.id][1]
	if callbackSuccess ~= nil then
		callbackSuccess(str_result)
		self.callbacks[product_conf.id] = nil
	end
end

function FuncPurchase:OnPayFail(product_conf, str_result)
	local callbackFail = self.callbacks[product_conf.id][2]
	if callbackFail ~= nil then
		callbackFail(str_result)
		self.callbacks[product_conf.id] = nil
	end
end

function FuncPurchase:OnPayTimeout(product_conf, str_result)
	local callbackTimeout = self.callbacks[product_conf.id][3]
	if callbackTimeout ~= nil then
		callbackTimeout(str_result)
		self.callbacks[product_conf.id] = nil
	end
end

function FuncPurchase:OnPayCancel(product_conf, str_result)
	local callbackCancel = self.callbacks[product_conf.id][4]
	if callbackCancel ~= nil then
		callbackCancel(str_result)
		self.callbacks[product_conf.id] = nil
	end
end

function FuncPurchase:OnPayProductIllegal(product_conf, str_result)
	local callbackProductIllegal = self.callbacks[product_conf.id][5]
	if callbackProductIllegal ~= nil then
		callbackProductIllegal(str_result)
		self.callbacks[product_conf.id] = nil
	end
end

function FuncPurchase:OnPayPaying(product_conf, str_result)
	local callbackPaying = self.callbacks[product_conf.id][6]
	if callbackPaying ~= nil then
		callbackPaying(str_result)
	end
end

function FuncPurchase:Purchase(product_conf_id, callbacks)
	local productConf = Table_Deposit[product_conf_id]
	if productConf then
		local productID = productConf.ProductID
		if productID then
			local productName = productConf.Desc
			local productPrice = productConf.Rmb
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
					local currentServerTime = ServerTime.CurServerTime() / 1000
					local runtimePlatform = ApplicationInfo.GetRunPlatform()
					if runtimePlatform == RuntimePlatform.Android and not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then

						self.callbacks[product_conf_id] = callbacks

						TableUtility.TableClear(gReusableTable)
						gReusableTable['productGameID'] = tostring(productConf.id)
						gReusableTable['serverID'] = tostring(serverID)
						gReusableTable['payCallbackCode'] = 1
						local ext = json.encode(gReusableTable)
						FunctionXDSDK.Ins:Pay(
							productName,
							productID,
							productPrice * 100,
							serverID,
							tostring(roleID),
							"", -- order id
							ext,
							function (x)
								self:OnPaySuccess(productConf, x)
							end,
							function (x)
								self:OnPayFail(productConf, x)
							end,
							function (x)
								self:OnPayCancel(productConf, x)
							end
						)
					else
						if FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.Any then

							self.callbacks[product_conf_id] = callbacks

							if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V8) then
								FunctionSDK.Instance:ResetPayState()
							end
							TableUtility.TableClear(gReusableTable)
							gReusableTable['productGameID'] = productConf.id
							local custom = json.encode(gReusableTable)
							FunctionSDK.Instance:AnySDKPay(
								productID,
								productName,
								productPrice,
								productCount,
								tostring(roleID),
								roleName,
								roleGrade,
								roleBalance,
								tostring(serverID),
								custom,
								function (x)
									self:OnPaySuccess(productConf, x)
								end,
								function (x)
									self:OnPayFail(productConf, x)
								end,
								function (x)
									self:OnPayTimeout(productConf, x)
								end,
								function (x)
									self:OnPayCancel(productConf, x)
								end,
								function (x)
									self:OnPayProductIllegal(productConf, x)
								end,
								function (x)
									self:OnPayPaying(productConf, x)
								end
							)
						elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.XD then

							self.callbacks[product_conf_id] = callbacks

							TableUtility.TableClear(gReusableTable)
							gReusableTable['productGameID'] = tostring(productConf.id)
							gReusableTable['serverID'] = tostring(serverID)
							local ext = json.encode(gReusableTable)
							if not BackwardCompatibilityUtil.CompatibilityMode_V17 then
								local roleAndServerTime = roleID .. '_' .. currentServerTime
								self.orderIDOfXDSDKPay = MyMD5.HashString(roleAndServerTime)
								FunctionSDK.Instance:XDSDKPay(
									productPrice * 100,
									tostring(serverID),
									productID,
									productName,
									tostring(roleID),
									ext,
									productCount,
									self.orderIDOfXDSDKPay,
									function (x)
										self:OnPaySuccess(productConf, x)
									end,
									function (x)
										self:OnPayFail(productConf, x)
									end,
									function (x)
										self:OnPayTimeout(productConf, x)
									end,
									function (x)
										self:OnPayCancel(productConf, x)
									end,
									function (x)
										self:OnPayProductIllegal(productConf, x)
									end
								)
							elseif not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
								self.orderIDOfXDSDKPay = FunctionSDK.Instance:XDSDKPay(
									productPrice * 100,
									tostring(serverID),
									productID,
									productName,
									tostring(roleID),
									ext,
									productCount,
									function (x)
										self:OnPaySuccess(productConf, x)
									end,
									function (x)
										self:OnPayFail(productConf, x)
									end,
									function (x)
										self:OnPayTimeout(productConf, x)
									end,
									function (x)
										self:OnPayCancel(productConf, x)
									end,
									function (x)
										self:OnPayProductIllegal(productConf, x)
									end
								)
							else
								FunctionSDK.Instance:XDSDKPay(
									productPrice * 100,
									tostring(serverID),
									productID,
									productName,
									tostring(roleID),
									ext,
									productCount,
									function (x)
										self:OnPaySuccess(productConf, x)
									end,
									function (x)
										self:OnPayFail(productConf, x)
									end,
									function (x)
										self:OnPayTimeout(productConf, x)
									end,
									function (x)
										self:OnPayCancel(productConf, x)
									end,
									function (x)
										self:OnPayProductIllegal(productConf, x)
									end
								)
							end
						end
					end
				end
			end
		end
	end
end