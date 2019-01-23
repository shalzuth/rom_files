CostUtil = {}

function CostUtil.CheckComposeItems(id,page)
	local compose = Table_Compose[id]
	if(not compose) then
		return false
	end
	return CostUtil.CheckItems(compose.BeCostItem,page)
end

--检测装备切页里
function CostUtil.CheckComposeItemsInEquip(id)
	return CostUtil.CheckComposeItems(id,GameConfig.ItemPage[2])
end

--检测消耗品切页里
function CostUtil.CheckComposeItemsInUse(id)
	return CostUtil.CheckComposeItems(id,GameConfig.ItemPage[1])
end

function CostUtil.CheckItems(items,page)
	local itemIDs = {}
	for i=1,#items do
		itemIDs[#itemIDs+1] = items[i].id
	end
	local numMap = BagProxy.Instance:GetItemNumByStaticIDs(itemIDs,page)
	local enough = true
	for k,v in pairs(items) do
		if(numMap[v.id]<v.num) then
			enough = false
		end
	end
	return enough,numMap
end

--返回num是否不大于checkValue
function CostUtil.CheckROB(num,checkValue)
	checkValue = checkValue or MyselfProxy.Instance:GetROB()
	return num<=checkValue,num,checkValue
end

function CostUtil.CheckComposeROB(id,checkValue)
	local num = Table_Compose[id].ROB
	return CostUtil.CheckROB(num,checkValue)
end

function CostUtil.CheckGold(num,checkValue)
	checkValue = checkValue or MyselfProxy.Instance:GetGold()
	return num<=checkValue,num,checkValue
end

function CostUtil.CheckComposeGold(id,checkValue)
	local num = Table_Compose[id].Gold
	return CostUtil.CheckGold(num,checkValue)
end

function CostUtil.CheckDiamond(num,checkValue)
	checkValue = checkValue or MyselfProxy.Instance:GetDiamond()
	return num<=checkValue,num,checkValue
end

local miyinConfID = 5030
function CostUtil.CheckMiyin(num, checkValue)
	checkValue = checkValue or BagProxy.Instance:GetItemNumByStaticID(miyinConfID)
	return num <= checkValue, num, checkValue
end

function CostUtil.CheckComposeDiamond(id,checkValue)
	local num = Table_Compose[id].Diamond
	return CostUtil.CheckDiamond(num,checkValue)
end

function CostUtil.CheckStrengthCost(data,level,checkValue)
	return CostUtil.CheckROB(CommonFun.calcEquipStrengthCost(level, data.Quality, data.Type),checkValue)
end

function CostUtil.CheckMiyinStrengthCost_Zeny(data, level, checkValue)
	local need = ItemFun.calcStrengthCost(data.Quality, data.Type, level)[100]
	return CostUtil.CheckROB(need, checkValue)
end

function CostUtil.CheckMiyinStrengthCost_Miyin(data, level, checkValue)
	local need = ItemFun.calcStrengthCost(data.Quality, data.Type, level)[miyinConfID]
	return CostUtil.CheckMiyin(need, checkValue)
end