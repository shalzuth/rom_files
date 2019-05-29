GuildFun = {}
function GuildFun.calcGuildPrayCon(prayid, praylv)
  local cfg = Table_Guild_Faith[prayid]
  if cfg == nil then
    return 0
  end
  if praylv <= 10 then
    return math.floor(34)
  elseif praylv <= 20 and praylv > 10 then
    return math.floor(36)
  elseif praylv <= 30 and praylv > 20 then
    return math.floor(42)
  elseif praylv <= 40 and praylv > 30 then
    return math.floor(80)
  elseif praylv <= 50 and praylv > 40 then
    return math.floor(152)
  elseif praylv <= 60 and praylv > 50 then
    return math.floor(284)
  elseif praylv <= 70 and praylv > 60 then
    return math.floor(450)
  elseif praylv <= 80 and praylv > 70 then
    return math.floor(588)
  elseif praylv <= 90 and praylv > 80 then
    return math.floor(728)
  else
    return math.floor(728)
  end
end
function GuildFun.calcGuildPrayMon(prayid, praylv)
  local cfg = Table_Guild_Faith[prayid]
  if cfg == nil then
    return 0
  end
  local a1 = praylv % 10
  local b1 = GameConfig.GuildPray.Remainder[a1]
  local a2 = math.floor(praylv / 10)
  local b2 = GameConfig.GuildPray.Quotient[a2]
  local result = GameConfig.GuildPray.BaseCost * b1 * b2
  result = result - result % 10
  return result
end
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
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 280 + 28 * (praylv - 20)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 11 + 1.1 * (praylv - 20)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 11 + 1.1 * (praylv - 20)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 6 + 0.5 * (praylv - 20)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 6 + 0.5 * (praylv - 20)
    end
  elseif praylv >= 31 and praylv <= 40 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 560 + 38 * (praylv - 30)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 22 + 1.5 * (praylv - 30)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 22 + 1.5 * (praylv - 30)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 11 + 0.7 * (praylv - 30)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 11 + 0.7 * (praylv - 30)
    end
  elseif praylv >= 41 and praylv <= 50 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 940 + 45 * (praylv - 40)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 37 + 1.8 * (praylv - 40)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 37 + 1.8 * (praylv - 40)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 18 + 0.9 * (praylv - 40)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 18 + 0.9 * (praylv - 40)
    end
  elseif praylv >= 51 and praylv <= 60 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 1390 + 55 * (praylv - 50)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 55 + 2.2 * (praylv - 50)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 55 + 2.2 * (praylv - 50)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 27 + 1.1 * (praylv - 50)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 27 + 1.1 * (praylv - 50)
    end
  elseif praylv >= 61 and praylv <= 70 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 1940 + 63 * (praylv - 60)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 77 + 2.5 * (praylv - 60)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 77 + 2.5 * (praylv - 60)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 38 + 1.3 * (praylv - 60)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 38 + 1.3 * (praylv - 60)
    end
  elseif praylv >= 71 and praylv <= 80 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 2570 + 73 * (praylv - 70)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 102 + 2.9 * (praylv - 70)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 102 + 2.9 * (praylv - 70)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 51 + 1.5 * (praylv - 70)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 51 + 1.5 * (praylv - 70)
    end
  elseif praylv >= 81 and praylv <= 90 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 3300 + 83 * (praylv - 80)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 131 + 3.3 * (praylv - 80)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 131 + 3.3 * (praylv - 80)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 66 + 1.6 * (praylv - 80)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 66 + 1.6 * (praylv - 80)
    end
  elseif praylv >= 91 and praylv <= 100 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 4130 + 90 * (praylv - 90)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 164 + 3.6 * (praylv - 90)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 164 + 3.6 * (praylv - 90)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 82 + 1.8 * (praylv - 90)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 82 + 1.8 * (praylv - 90)
    end
  end
  return result
end
