FuncZenyShop = class('FuncZenyShop')

function FuncZenyShop.Instance()
	if FuncZenyShop.instance == nil then
		FuncZenyShop.instance = FuncZenyShop.new()
	end
	return FuncZenyShop.instance
end

function FuncZenyShop:OpenUI(panel_config)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panel_config, viewdata = nil})
end

function FuncZenyShop:AddProductPurchase(product_id, purchase_function)
	if self.productPurchase == nil then
		self.productPurchase = {}
	end
	self.productPurchase[product_id] = purchase_function
end

function FuncZenyShop:ClearProductPurchase()
	if self.productPurchase ~= nil then
		TableUtility.TableClear(self.productPurchase)
	end
end

function FuncZenyShop:TryPurchaseProduct(product_id)
	local purchaseFunction = self.productPurchase[product_id]
	if purchaseFunction ~= nil then
		purchaseFunction()
		return true
	end
	return false
end

function FuncZenyShop:GetMonthlyVIPController()
	return UIViewControllerZenyShop.instance.monthlyVIPController
end

function FuncZenyShop.FormatMilComma(int_number)
	if int_number then
		local isMinus = int_number < 0
		if isMinus then
			int_number = int_number * -1
		end
		local str = tostring(int_number)
		local tab = {}
		local count = 0
		for i = #str, 1, -1 do
			local char = string.sub(str, i, i)
			table.insert(tab, char)
			count = count + 1
			if count == 3 then
				if i > 1 then
					table.insert(tab, ',')
					count = 0
				end
			end
		end
		local result = ''
		for j = #tab, 1, -1 do
			local char = tab[j]
			result = result .. char
		end
		if isMinus then
			result = '-' .. result
		end
		return result
	end
	return nil
end