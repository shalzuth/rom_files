GuildFun = {}

-- 计算公会祈祷所需贡献
function GuildFun.calcGuildPrayCon(prayid, praylv)
  local cfg = Table_Guild_Faith[prayid]
  if cfg == nil then
    return 0
  end

  --print("con1 = "..cfg.Contribution1)
  --print("con2 = "..cfg.Contribution2)
  --print("---------------------------")
  if praylv<=10 then
     return math.floor(34)
  elseif praylv<=20 and praylv>10 then
     return math.floor(36)
  elseif praylv<=30 and praylv>20 then
     return math.floor(42)      
  elseif praylv<=40 and praylv>30 then
     return math.floor(80)
  elseif praylv<=50 and praylv>40 then
     return math.floor(152)
  elseif praylv<=60 and praylv>50 then
     return math.floor(284)
  elseif praylv<=70 and praylv>60 then
     return math.floor(450)
  elseif praylv<=80 and praylv>70 then
     return math.floor(588)
  elseif praylv<=90 and praylv>80 then
     return math.floor(728)
  else
     return math.floor(728)
  end

end

-- 计算公会祈祷所需货币
function GuildFun.calcGuildPrayMon(prayid, praylv)
  local cfg = Table_Guild_Faith[prayid]
  if cfg == nil then
    return 0
  end

  --print("mon1 = "..cfg.Money1)
  --print("mon2 = "..cfg.Money2)
  --print("---------------------------")

  local a1 = praylv % 10
  local b1=GameConfig.GuildPray.Remainder[a1]
  local a2=math.floor(praylv/10)
  local b2=GameConfig.GuildPray.Quotient[a2]

  local result = GameConfig.GuildPray.BaseCost * b1 * b2
    result = result - result % 10
  return result

end
---------------------------------------------------------------------------计算公会祈福属性
function GuildFun.calcGuildPrayAttr(prayid, praylv)
  local result = {}

  if praylv >= 0 and praylv <= 10 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 10 * praylv
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 0.4 * praylv
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 0.4 * praylv
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 0.2 * praylv
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 0.2 * praylv
    end
  elseif praylv >= 11 and praylv <= 20 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 18 * (praylv - 10)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 0.7 * (praylv - 10)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 0.7 * (praylv - 10)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 0.4 * (praylv - 10)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 0.4 * (praylv - 10)
    end
  elseif praylv >= 21 and praylv <= 30 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 180 + 28 * (praylv - 20)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 7 + 1.1 * (praylv - 20)
    elseif prayid == 3 then  
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 7 + 1.1 * (praylv - 20)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 4 + 0.5 * (praylv - 20)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 4 + 0.5 * (praylv - 20)
    end
  elseif praylv >= 31 and praylv <= 40 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 180 + 280 + 38 * (praylv - 30)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 7 + 11 + 1.5 * (praylv - 30)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 7 + 11 + 1.5 * (praylv - 30)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 4 + 5 + 0.7 * (praylv - 30)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 4 + 5 + 0.7 * (praylv - 30)
    end
  elseif praylv >= 41 and praylv <= 50 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 180 + 280 + 380 + 45 * (praylv - 40)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 7 + 11 + 15 + 1.8 * (praylv - 40)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 7 + 11 + 15 + 1.8 * (praylv - 40)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 4 + 5 + 7 + 0.9 * (praylv - 40)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 4 + 5 + 7 + 0.9 * (praylv - 40)
    end
  elseif praylv >= 51 and praylv <= 60 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 180 + 280 + 380 + 450 + 55 * (praylv - 50)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 7 + 11 + 15 + 18 + 2.2 * (praylv - 50)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 7 + 11 + 15 + 18 + 2.2 * (praylv - 50)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 4 + 5 + 7 + 9 + 1.1 * (praylv - 50)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 4 + 5 + 7 + 9 + 1.1 * (praylv - 50)
    end
  elseif praylv >= 61 and praylv <= 70 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 180 + 280 + 380 + 450 + 550 + 63 * (praylv - 60)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 7 + 11 + 15 + 18 + 22 + 2.5 * (praylv - 60)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 7 + 11 + 15 + 18 + 22 + 2.5 * (praylv - 60)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 4 + 5 + 7 + 9 + 11 + 1.3 * (praylv - 60)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 4 + 5 + 7 + 9 + 11 + 1.3 * (praylv - 60)
    end
  elseif praylv >= 71 and praylv <= 80 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 180 + 280 + 380 + 450 + 550 + 630 + 73 * (praylv - 70)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 7 + 11 + 15 + 18 + 22 + 25 + 2.9 * (praylv - 70)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 7 + 11 + 15 + 18 + 22 + 25 + 2.9 * (praylv - 70)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 4 + 5 + 7 + 9 + 11 + 13 + 1.5 * (praylv - 70)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 4 + 5 + 7 + 9 + 11 + 13 + 1.5 * (praylv - 70)
    end
  elseif praylv >= 81 and praylv <= 90 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 180 + 280 + 380 + 450 + 550 + 630 + 730 + 83 * (praylv - 80)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 7 + 11 + 15 + 18 + 22 + 25 + 29 + 3.3 * (praylv - 80)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 7 + 11 + 15 + 18 + 22 + 25 + 29 + 3.3 * (praylv - 80)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 4 + 5 + 7 + 9 + 11 + 13 + 15 + 1.6 * (praylv - 80)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 4 + 5 + 7 + 9 + 11 + 13 + 15 + 1.6 * (praylv - 80)
    end
  elseif praylv >= 91 and praylv <= 100 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 180 + 280 + 380 + 450 + 550 + 630 + 730 + 830 + 90 * (praylv - 90)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 7 + 11 + 15 + 18 + 22 + 25 + 29 + 33 + 3.6 * (praylv - 90)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 7 + 11 + 15 + 18 + 22 + 25 + 29 + 33 + 3.6 * (praylv - 90)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 4 + 5 + 7 + 9 + 11 + 13 + 15 + 16 + 1.8 * (praylv - 90)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 4 + 5 + 7 + 9 + 11 + 13 + 15 + 16 + 1.8 * (praylv - 90)
    end
  end

  return result
end
