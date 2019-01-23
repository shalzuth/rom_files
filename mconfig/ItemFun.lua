ItemFun = {}

-- 秘银强化消耗
--quality 物品品质 1 2 3 4 5
--itemtype 物品类型(item表)
--lv  升级到的等级
function ItemFun.calcStrengthCost(quality, itemtype, lv)

    local cost = {}
    --------------------------------------------消耗费用--------------------------------------------
    ------------------------------------------------------------------------------------------------
    local Ten,Bits = 0
  local costMoneyLvRatio = {
    [1] = 0.091,
    [2] = 0.093,
    [3] = 0.095,
    [4] = 0.097,
    [5] = 0.099,
    [6] = 0.101,
    [7] = 0.103,
    [8] = 0.105,
    [9] = 0.107,
    [0] = 0.109,
}

  local costMoneyQualityRatio = {
  [1] = 0.3125,
  [2] = 0.46875,
  [3] = 0.625,
  [4] = 1,
  [5] = 2,
}

  local costMoneyMax = {
  [10] = 26510.84,
  [20] = 42417.34571,
  [30] = 79532.52,
  [40] = 116647.6971,
  [50] = 159065.04,
  [60] = 265108.4,
  [70] = 371151.76,
  [80] = 530216.8,
  [90] = 795325.2,
  [100] = 1060433.6,
}


  local costMoneyTypeRatio = {
    [500] = 1,      --铠甲类型
    [510] = 1,      --盾牌
    [511] = 1,      --宝珠
    [512] = 1,      --圣像
    [513] = 1,      --腕甲
    [514] = 1,      --手镯
    [515] = 1,      --手推车改装件
    [520] = 0.8,    --披风
    [530] = 0.8,    --鞋子
}
--------------------有修改
  local costMoneyRatio = {
  [10] = 1,
  [20] = 1.15,
  [30] = 1.3,
  [40] = 1.5,
  [50] = 1.7,
  [60] = 2.5,
  [70] = 3.1,
  [80] = 2.5,
  [90] = 2.8,
  [100] = 3.15,
 }

  if lv == 0 or quality == 0 or itemtype == 0 or lv == nil or quality == nil or itemtype == nil then
    cost[100] = 99999999
    cost[5030] = 99999999
    return cost
  end

  Bits = tonumber(string.sub(lv,string.len(lv),string.len(lv)))
  if lv <= 10 then
    Ten = 10
  else
    Ten =tonumber(string.sub(lv,1,string.len(lv)-1))                --获得首位
    if Bits == 0 then
      Ten = Ten * 10
    else
      Ten = Ten * 10 + 10
    end
  end

  if costMoneyMax[Ten] == nil or costMoneyLvRatio[Bits] == nil or costMoneyQualityRatio[quality]==nil or costMoneyTypeRatio[itemtype] ==nil or costMoneyRatio[Ten] ==nil then
    cost[100] = 99999999
  else

    local MoneyMax = costMoneyMax[Ten] 
    local LvRatio = costMoneyLvRatio[Bits] 
    local QualityRatio = costMoneyQualityRatio[quality] 
    local MoneyTypeRatio = costMoneyTypeRatio[itemtype] 
    local MoneyRatio = costMoneyRatio[Ten]
    costMoney = MoneyMax * LvRatio * QualityRatio * MoneyTypeRatio * MoneyRatio
    
    if costMoney <=0 then
      cost[100] = 0
    else
      cost[100] = math.ceil(costMoney)  --直接向上取整
    end

  end
    --------------------------------------------消耗秘银--------------------------------------------
    ------------------------------------------------------------------------------------------------
  local costItem = 0

  local costItemNum = {
  [10] = 1,
  [20] = 1.5,
  [30] = 2,
  [40] = 2.5,
  [50] = 3,
  [60] = 3.5,
  [70] = 4,
  [80] = 4.5,
  [90] = 5,
  [100] = 5.5,
 }

  local costItemTypeRatio = {
    [500] = 1.5,    --铠甲类型
    [510] = 1.5,    --盾牌
    [511] = 1.5,    --宝珠
    [512] = 1.5,    --圣像
    [513] = 1.5,      --腕甲
    [514] = 1.5,      --手镯
    [515] = 1.5,      --手推车改装件
    [520] = 1,        --披风
    [530] = 1,        --鞋子
}
----------------------------------有修改
  local costItemRatio = {
  [10] = 1,
  [20] = 1.15,
  [30] = 1.3,
  [40] = 1.5,
  [50] = 1.7,
  [60] = 2.5,
  [70] = 3.1,
  [80] = 2.5,
  [90] = 2.8,
  [100] = 3.15,
 }

  if costItemNum[Ten]  == nil or costItemTypeRatio[itemtype] == nil or costItemRatio[Ten] == nil then
    cost[5030] = 99999999
  else
    local ItemNum = costItemNum[Ten] 
    local ItemTypeRatio = costItemTypeRatio[itemtype] 
    local ItemRatio = costItemRatio[Ten] 
    costItem = ItemNum * ItemTypeRatio * ItemRatio 

    if costItem <= 0 then
      cost[5030] = 0
    else
      cost[5030] = math.floor(costItem + 0.5)   --四舍五入 向下取整
    end
  end

    return cost
end

-- 秘银强化属性加成
function ItemFun.calcStrengthAttr(quality, itemtype, lv)
  local result = {}

  if lv <= 0 then
    result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 0
    return result
  end


  local hp = 6000
  local a = 10
  local b = 2
  local c = 4
  local d = 400
  local lv10 = 0

  if lv >= 1 and lv <= 10 then
    lv10 = 0
  elseif lv >= 11 and lv <= 20 then
    lv10 = 4
  elseif lv >= 21 and lv <= 30 then
    lv10 = 10
  elseif lv >= 31 and lv <= 40 then
    lv10 = 18
  elseif lv >= 41 and lv <= 50 then
    lv10 = 28
  elseif lv >= 51 and lv <= 60 then
    lv10 = 40
  elseif lv >= 61 and lv <= 70 then
    lv10 = 57.78
  end

  local adjust = 1
  if lv >= 1 and lv <= 10 then
    adjust = 1
  elseif lv >= 11 and lv <= 20 then
    adjust = 1
  elseif lv >= 21 and lv <= 30 then
    adjust = 1
  elseif lv >= 31 and lv <= 40 then
    adjust = 1
  elseif lv >= 41 and lv <= 50 then
    adjust = 1
  elseif lv >= 51 and lv <= 60 then
    adjust = 1.27
  elseif lv >= 61 and lv <= 70 then
    adjust = 1.39
  end


  local qparam ={[1]=0.5,[2]=0.65,[3]=0.8,[4]=1,[5]=1,[6]=1,}
  local eparam ={[3]=0.3,[2]=0.3,[4]=0.2,[5]=0.2,[16]=0.3,[17]=0.3,[18]=0.3,[19]=0.3,}

  local qvalue = qparam[quality]
  local evalue = eparam[itemtype]
  if qvalue == nil or evalue == nil then
    --print("quality or itemtype error")
    return result
  end

  local tmp = (lv - 1) % 10
  local tmp1 = math.floor((lv - 1) / a)
  local maxhp = math.floor(((tmp + 1) * (tmp1 * b + c) * adjust + lv10 * 10) * hp * qvalue * evalue / d)

  --print("tmp = "..tmp)
  --print("tmp1 = "..tmp1)
  --print("lv10 = "..lv10)
  --print("quality = "..quality)
  --print("itemtype = "..itemtype)
  --print("maxhp = "..maxhp)

  result[CommonFun.RoleData.EATTRTYPE_MAXHP] = maxhp

  return result
end
-- 一键出售检查
function ItemFun.canQuickSell(id)
  local item_cfg = Table_Item[id]
  local equip_cfg = Table_Equip[id]
  local exchange_cfg = Table_Exchange[id]
  if item_cfg == nil or equip_cfg == nil or exchange_cfg ~= nil then
    return false
  end

  -- 功能性道具
  if item_cfg.Type == 65 then
    --print("typeerror")
    return false
  end
  -- 品质
  if item_cfg.Quality ~= 1 then
    --print("qualityerror")
    return false
  end
  -- 使用等级
  if item_cfg.Level == nil or item_cfg.Level <= 0 then
   -- print("levelerror")
    return false
  end
   --可以交易
  if item_cfg.AuctionPrice == 1 then
    --print("auctionpriceerror")
    return false
  end

  return true
end
