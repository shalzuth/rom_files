ProfessionProxy = class("ProfessionProxy", pm.Proxy)
ProfessionProxy.Instance = nil
ProfessionProxy.NAME = "ProfessionProxy"
function ProfessionProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ProfessionProxy.NAME
  if ProfessionProxy.Instance == nil then
    ProfessionProxy.Instance = self
  end
  self.professionMap = {}
  self:ParseProfession()
end
function ProfessionProxy:print()
  if self.enableLog then
  end
end
function ProfessionProxy:ParseProfession()
  self.professTreeByTypes = {}
  local rootID = 1
  local rootClass = Table_Class[rootID]
  self.rootProfession = ProfessionData.new(rootClass)
  if rootClass then
    self.professionMap[rootID] = self.rootProfession
    for i = 1, #rootClass.AdvanceClass do
      self:_ParseProfession(rootClass.AdvanceClass[i])
    end
    local superNoviceId = GameConfig.SuperNovice and GameConfig.SuperNovice.ClassId or 1
    self:_ParseProfession(superNoviceId, 3)
  else
    error(string.format("\232\167\163\230\158\144\232\129\140\228\184\154\232\161\168\229\135\186\233\148\153\239\188\140\230\156\170\230\137\190\229\136\176id %d\231\154\132\229\136\157\229\191\131\232\128\133", rootID))
  end
end
function ProfessionProxy:_ParseProfession(classid, depth)
  local class = Table_Class[classid]
  local profession = ProfessionData.new(class, depth or 1)
  self.professionMap[class.id] = profession
  local tree = ProfessionTree.new(self.rootProfession, profession)
  self:print("-----\229\188\128\229\167\139\232\167\163\230\158\144\228\186\140\232\189\172\232\129\140\228\184\154", class.id)
  self:ParseNextProfession(tree, profession)
  self.professTreeByTypes[class.Type] = tree
end
function ProfessionProxy:ParseNextProfession(tree, profession)
  local parentClass = profession.data
  local class, p
  if parentClass.AdvanceClass then
    for i = 1, #parentClass.AdvanceClass do
      class = Table_Class[parentClass.AdvanceClass[i]]
      self:print("-----", class.id)
      p = ProfessionData.new(class)
      self.professionMap[class.id] = p
      profession:AddNext(p)
      self:ParseNextProfession(tree, p)
    end
  end
end
function ProfessionProxy:GetProfessionTreeByType(t)
  if t == 0 then
    return nil
  else
    return self.professTreeByTypes[t]
  end
end
function ProfessionProxy:GetProfessionTreeByClassId(classID)
  local class = Table_Class[classID]
  return class and self:GetProfessionTreeByType(class.Type) or nil
end
function ProfessionProxy:GetDepthByClassId(classID)
  local tree = self:GetProfessionTreeByClassId(classID)
  if not tree then
    return 0
  else
    local p = tree:GetProfessDataByClassID(classID)
    if p then
      return p.depth
    end
  end
end
function ProfessionProxy:GetThisIdPreviousId(id)
  for k, v in pairs(Table_Class) do
    local advanceTable = v.AdvanceClass
    if advanceTable then
      for k1, v1 in pairs(advanceTable) do
        if id == v1 then
          return v.id
        end
      end
    end
  end
  return nil
end
function ProfessionProxy:GetThisIdJiuZhiTiaoJianLevel(id)
  local previousId = self:GetThisIdPreviousId(id)
  if id == 144 then
    return 70
  end
  if previousId then
    local thisIdData = Table_Class[id]
    local previousData = Table_Class[previousId]
    if previousData.MaxPeak ~= nil then
      local doublePreId = self:GetThisIdPreviousId(previousId)
      if doublePreId then
        return previousData.MaxPeak - previousData.MaxJobLevel + previousData.MaxJobLevel - Table_Class[doublePreId].MaxJobLevel
      else
        helplog("GetThisIdJiuZhiTiaoJianLevel(id) \230\163\128\230\159\165\233\133\141\231\189\174\232\161\168 id:" .. id .. "\t\229\146\140\232\191\153\228\184\170id\231\155\184\229\133\179\232\129\148\231\154\132\229\156\176\230\150\185\233\133\141\231\189\174\230\156\137\232\175\175\239\188\129\239\188\129\239\188\129")
      end
    else
      return thisIdData.MaxJobLevel - previousData.MaxJobLevel
    end
  else
    helplog("GetThisIdJiuZhiTiaoJianLevel(id) \230\163\128\230\159\165\233\133\141\231\189\174\232\161\168")
  end
end
function ProfessionProxy:GetThisJobLevelForClient(id, level)
  if id == 1 then
  elseif id ~= 1 then
    if id % 10 == 1 then
      return level - 10
    elseif id % 10 == 2 then
      return level - 50
    elseif id % 10 == 3 then
      return level - 90
    elseif id % 10 == 4 then
      return level - 160
    else
      helplog("\230\156\141\229\138\161\229\153\168\229\143\145\228\186\134\233\148\153\232\175\175\231\154\132\228\184\156\232\165\191\239\188\129\239\188\129")
    end
  end
  if level < 0 then
    helplog("\230\156\141\229\138\161\229\153\168\229\143\145\228\186\134\233\148\153\232\175\175\231\154\132\228\184\156\232\165\191\239\188\129\239\188\129 \232\175\183\229\144\142\231\171\175\229\164\167\228\189\172\230\163\128\230\159\165\228\187\163\231\160\129\239\188\129\239\188\129 ")
  end
  return level
end
function ProfessionProxy:GetPreviousProfess(pro)
  local p = self.professionMap[pro]
  if p then
    return p.parentProfession
  end
  return nil
end
function ProfessionProxy:RecvUpdateBranchInfoUserCmd(data)
  BranchInfoSaveProxy.Instance:RecvUpdateBranchInfoUserCmd(data)
end
function ProfessionProxy:SetCurProfessionUserInfo(data)
  self.CurProfessionUserInfo = data
end
function ProfessionProxy:GetCurProfessionUserInfo()
  return self.CurProfessionUserInfo or nil
end
function ProfessionProxy:RecvProfessionQueryUserCmd(data)
  self.ProfessionQueryUserTable = {}
  if data ~= nil and data.body ~= nil and data.body.items ~= nil then
    local items = data.body.items
    local haveFoundOriginBranch = false
    for i = 1, #items do
      local data = items[i]
      if data.isbuy == nil then
        helplog("isbuy \230\156\141\229\138\161\229\153\168\230\178\161\229\143\145\239\188\129\239\188\129\239\188\129\239\188\129")
      end
      self.ProfessionQueryUserTable[data.branch] = {}
      self.ProfessionQueryUserTable[data.branch].branch = data.branch
      self.ProfessionQueryUserTable[data.branch].profession = data.profession
      self.ProfessionQueryUserTable[data.branch].joblv = data.joblv
      self.ProfessionQueryUserTable[data.branch].isbuy = data.isbuy
      self.ProfessionQueryUserTable[data.branch].iscurrent = data.iscurrent
      if data.isbuy == false then
        haveFoundOriginBranch = true
      end
    end
    if haveFoundOriginBranch == false then
      local curId = MyselfProxy:GetMyProfession()
      local curClassData = Table_Class[curId]
      self.ProfessionQueryUserTable[curClassData.TypeBranch] = {}
      self.ProfessionQueryUserTable[curClassData.TypeBranch].branch = curClassData.TypeBranch
      self.ProfessionQueryUserTable[curClassData.TypeBranch].profession = MyselfProxy:GetMyProfession()
      self.ProfessionQueryUserTable[curClassData.TypeBranch].joblv = MyselfProxy.Instance:JobLevel()
      self.ProfessionQueryUserTable[curClassData.TypeBranch].isbuy = false
      self.ProfessionQueryUserTable[curClassData.TypeBranch].iscurrent = true
      ProfessionProxy.Instance:SetCurTypeBranch(curClassData.TypeBranch)
    end
  end
end
function ProfessionProxy:GetProfessionQueryUserTable()
  return self.ProfessionQueryUserTable or {}
end
function ProfessionProxy:GetGeneraData()
  local datas = {}
  for i = 1, #GameConfig.BaseAttrConfig do
    local data = {}
    local single = GameConfig.BaseAttrConfig[i]
    local prop = Game.Myself.data.props[single]
    local extraP = MyselfProxy.Instance.extraProps[single]
    local data = {}
    data.prop = prop
    data.extraP = extraP
    if self.attr then
      data.addData = self.attr[prop.propVO.id] or 0
      local maxProp = Game.Myself.data.props["Max" .. data.prop.propVO.name]
      maxProp = maxProp and maxProp.propVO or nil
      maxProp = maxProp and maxProp.id or -999
      data.maxAddData = self.attr[maxProp] or 0
    end
    data.type = BaseAttributeView.cellType.normal
    table.insert(datas, data)
  end
  return datas
end
function ProfessionProxy:SetCurTypeBranch(curTypeBranch)
  self.curTypeBranch = curTypeBranch
end
function ProfessionProxy:GetCurTypeBranch()
  return self.curTypeBranch
end
function ProfessionProxy:GetFixedData()
  local datas = AdventureDataProxy.Instance:GetAllFixProp()
  if #datas > 0 then
    table.sort(datas, function(l, r)
      return l.prop.propVO.id < r.prop.propVO.id
    end)
  else
  end
  return datas
end
function ProfessionProxy:IsThisIdYiJiuZhi(id)
  local curOcc = Game.Myself.data:GetCurOcc()
  self.curProfessionId = curOcc.profession
  if self.curProfessionId == id then
    return true
  end
  local curProfessionData = Table_Class[self.curProfessionId]
  local thisIdClassData = Table_Class[id]
  if curProfessionData == nil then
    return false
  end
  if thisIdClassData == nil then
    return false
  end
  local serverData = ProfessionProxy.Instance:GetProfessionQueryUserTable()[thisIdClassData.TypeBranch]
  if serverData then
    if id <= serverData.profession then
      return true
    else
      return false
    end
  else
    if id % 10 == 1 then
      local advanceClassIdTable = thisIdClassData.AdvanceClass
      for k, v in pairs(advanceClassIdTable) do
        local serverData = ProfessionProxy.Instance:GetProfessionQueryUserTable()[Table_Class[v].TypeBranch]
        if serverData and id <= serverData.profession then
          return true
        end
      end
    end
    return false
  end
  if id % 10 == 1 then
    if curProfessionData.Type == thisIdClassData.Type then
      return true
    end
  elseif id % 10 >= 2 and curProfessionData.TypeBranch == thisIdClassData.TypeBranch and id <= self.curProfessionId then
    return true
  end
  return false
end
function ProfessionProxy:IsThisIdYiGouMai(id)
  local curOcc = Game.Myself.data:GetCurOcc()
  if curOcc and curOcc.professionData and curOcc.professionData.TypeBranch then
    self.curTypeBranch = curOcc.professionData.TypeBranch
    self.curProfessionId = curOcc.profession
    local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
    for k, v in pairs(S_ProfessionDatas) do
      if v.iscurrent then
        self.curTypeBranch = v.branch
      end
    end
    if id % 10 == 1 then
      local thisIdClassData = Table_Class[id]
      for k, v in pairs(ProfessionProxy.Instance:GetProfessionQueryUserTable()) do
        local SClassData = Table_Class[v.profession]
        if SClassData and thisIdClassData.Type == SClassData.Type then
          return true
        end
      end
    elseif id % 10 >= 2 then
      local thisIdClassData = Table_Class[id]
      local thisIdBranch = thisIdClassData.TypeBranch
      local S_table = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      if S_table[thisIdBranch] ~= nil then
        return true
      end
      if self.curTypeBranch == thisIdClassData.TypeBranch then
        if self.curProfessionId % 10 == 1 then
          return false
        else
          return true
        end
      end
    end
    return false
  else
    return false
  end
end
function ProfessionProxy:IsThisIdKeGouMai(id)
  if id == 143 then
    return true
  end
  if id % 10 == 1 then
    return false
  elseif id % 10 == 2 then
    return true
  end
  return false
end
function ProfessionProxy:isOriginProfession(id)
  local thisClassData = Table_Class[id]
  if thisClassData == nil then
    return false
  end
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local isOriginProfession = false
  for k, v in pairs(S_data) do
    if v.isbuy == false then
      local sClassData = Table_Class[v.profession]
      if sClassData.Type == thisClassData.Type then
        isOriginProfession = true
        break
      end
    end
  end
  return isOriginProfession
end
function ProfessionProxy:IsMPOpen()
  if FunctionUnLockFunc.Me():CheckCanOpen(9006) == false then
    return false
  end
  local isOpen = false
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  for k, v in pairs(S_data) do
    if v.isbuy == false and v.profession % 10 >= 3 then
      isOpen = true
    end
  end
  return isOpen
end
function ProfessionProxy:GetRightMoneyNumberAndMoneyTypeForThisId(id)
  if GameConfig.SystemForbid.OpenJapanMultiJobs then
    local isOriginProfession = self:isOriginProfession(id)
    if isOriginProfession then
      local needmoney = UnionConfig.Profession.price_zeny or 10000
      return needmoney, Table_Item[100]
    elseif self:IsThisIdFirstBoughtOtherBranchId(id) then
      local needmoney = UnionConfig.Profession.price_zeny_other_first or 2000000
      local item_100 = Table_Item[100]
      return needmoney, Table_Item[100]
    else
      local needmoney = 88
      local item_151 = Table_Item[151]
      return needmoney, Table_Item[151]
    end
  end
end
function ProfessionProxy:PurchaseFunc(id)
  local mapid = Game.MapManager:GetMapID()
  local mapType = Table_Map[mapid].Type
  if mapType == 4 or mapType == 6 then
  else
    MsgManager.ShowMsgByID(25693)
    return
  end
  local isOriginProfession = self:isOriginProfession(id)
  local branch = Table_Class[id].TypeBranch
  if GameConfig.ProfessionExchangeTicket == nil then
    if ApplicationInfo.IsRunOnEditor() then
      MsgManager.FloatMsg(nil, "\231\173\150\229\136\146\230\178\161\230\156\137\228\184\138\228\188\160  GameConfig.ProfessionExchangeTicket\239\188\129\239\188\129\239\188\129\239\188\129")
    end
    return
  end
  for k, v in pairs(GameConfig.ProfessionExchangeTicket) do
    if BagProxy.Instance:GetItemNumByStaticID(k) > 0 and v == Table_Class[id].Type then
      ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
      return
    end
  end
  if 0 < BagProxy.Instance:GetItemNumByStaticID(6553) then
    ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
    return
  end
  if GameConfig.SystemForbid.OpenJapanMultiJobs then
    helplog("\230\178\161\230\168\170\229\178\151 \230\137\147\229\188\128")
    local needmoney, moneytype = self:GetRightMoneyNumberAndMoneyTypeForThisId(id)
    if isOriginProfession then
      if needmoney > MyselfProxy.Instance:GetROB() then
        local sysMsgID = 25419
        local item_100 = Table_Item[100]
        MsgManager.ShowMsgByID(sysMsgID, item_100.NameZh)
      else
        ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
      end
    elseif self:IsThisIdFirstBoughtOtherBranchId(id) then
      if needmoney > MyselfProxy.Instance:GetROB() then
        local sysMsgID = 25419
        local item_100 = Table_Item[100]
        MsgManager.ShowMsgByID(sysMsgID, item_100.NameZh)
      else
        ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
      end
    elseif needmoney > MyselfProxy.Instance:GetLottery() then
      local sysMsgID = 25419
      local item_151 = Table_Item[151]
      MsgManager.ShowMsgByID(sysMsgID, item_151.NameZh)
    else
      ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
    end
  else
    helplog("\230\156\137\230\168\170\229\178\151 \229\133\179\233\151\173")
    if isOriginProfession then
      local needmoney = GameConfig.Profession.price_zeny or 0
      if needmoney > MyselfProxy.Instance:GetROB() then
        local sysMsgID = 25419
        local item_100 = Table_Item[100]
        MsgManager.ShowMsgByID(sysMsgID, item_100.NameZh)
      else
        ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
      end
    else
      local needmoney = GameConfig.Profession.price_gold
      if needmoney > MyselfProxy.Instance:GetLottery() then
        local sysMsgID = 25419
        local item_151 = Table_Item[151]
        MsgManager.ShowMsgByID(sysMsgID, item_151.NameZh)
      else
        ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
      end
    end
  end
end
function ProfessionProxy:IsThisIdFirstBoughtOtherBranchId(id)
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local originProfession
  for k, v in pairs(S_data) do
    if v.isbuy == false then
      originProfession = v.profession
    end
  end
  if originProfession then
    for k, v in pairs(S_data) do
      if v.isbuy == true and Table_Class[originProfession].Type ~= Table_Class[v.profession].Type then
        return false
      end
    end
  else
    helplog("if originProfession == false then")
  end
  return true
end
function ProfessionProxy:NeedShowSelfData(targetBranch)
  local currentBranch = ProfessionProxy.Instance:GetCurTypeBranch()
  if currentBranch == targetBranch then
    return true
  else
    return false
  end
end
function ProfessionProxy:NeedShowSaveInfoData(targetBranch)
  local cursaveData = BranchInfoSaveProxy.Instance:GetUsersaveData(targetBranch)
  if cursaveData then
    return true
  else
    return false
  end
end
function ProfessionProxy:SetTopScrollChooseID(id)
  self.topScrollChooseID = id
end
function ProfessionProxy:GetTopScrollChooseID()
  return self.topScrollChooseID
end
function ProfessionProxy:ShouldThisIdVisible(id)
  if id == 143 or id == 144 then
    return true
  end
  local findErZhuanId = id - id % 10 + 2
  if not self:IsThisIdYiJiuZhi(findErZhuanId) and id % 10 > 2 then
    return false
  end
  return true
end
function ProfessionProxy:GetThisIdChuShiId(id)
  return Table_Class[id].Type * 10 + 1
end
function ProfessionProxy:GetThisJobIdXi(id)
  if Table_Class and Table_Class[id] then
    local result = math.modf(Table_Class[id].TypeBranch / 10 % 100)
    if result == 0 then
      helplog("\232\175\165\231\179\187\232\129\140\228\184\154" .. id .. "\t\t\229\177\133\231\132\182\228\184\1860")
    end
    return result
  else
    helplog("\230\151\160\232\175\165\231\179\187\232\129\140\228\184\154" .. id)
  end
end
function ProfessionProxy:GetTopScrollViewIconTable()
  if self.topScrollViewIconTable == nil then
    self.topScrollViewIconTable = {}
    for k, v in pairs(Table_Class) do
      if v.id % 10 == 1 and v.id ~= 1 then
        local thisXi = self:GetThisJobIdXi(v.id)
        self.topScrollViewIconTable[thisXi] = self.topScrollViewIconTable[v.Type] or {}
        self.topScrollViewIconTable[thisXi].id = v.id
        self.topScrollViewIconTable[thisXi].Type = thisXi
        self.topScrollViewIconTable[thisXi].isGrey = true
        self.topScrollViewIconTable[thisXi].order = v.Type
      end
    end
    if Table_Class and Table_Class[143] then
      local v = Table_Class[143]
      local thisXi = self:GetThisJobIdXi(v.id)
      self.topScrollViewIconTable[thisXi] = self.topScrollViewIconTable[v.Type] or {}
      self.topScrollViewIconTable[thisXi].id = v.id
      self.topScrollViewIconTable[thisXi].Type = thisXi
      self.topScrollViewIconTable[thisXi].isGrey = true
      self.topScrollViewIconTable[thisXi].order = v.Type
    else
      helplog("\232\182\133\231\186\167\229\136\157\229\191\131\232\128\133\230\178\161\233\133\141\239\188\140\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174\232\161\168")
    end
  end
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local curOcc = Game.Myself.data:GetCurOcc()
  local curProfessionId = curOcc.profession
  local chushiid = 0
  for k, v in pairs(S_data) do
    if v.isbuy == false then
      chushiid = self:GetThisIdChuShiId(v.profession)
    end
  end
  for k, v in pairs(self.topScrollViewIconTable) do
    if v.id == chushiid then
      v.order = 999999
      v.isGrey = false
    elseif self:IsThisIdYiGouMai(v.id) then
      v.isGrey = false
      v.order = 1000
    else
      v.isGrey = true
      v.order = 0
    end
  end
  table.sort(self.topScrollViewIconTable, function(l, r)
    return l.order > r.order
  end)
  return self.topScrollViewIconTable
end
function ProfessionProxy:DoesThisIdCanBuyBranch(id, branch)
  if id % 10 ~= 1 then
    helplog("GetThisIdCanBuyBranch reviewCode id:" .. id)
  end
  for k, v in pairs(Table_Class[id].AdvanceClass) do
    if Table_Class[v].TypeBranch == branch then
      return true
    end
  end
  return false
end
function ProfessionProxy:GetBoughtProfessionIdThroughBranch(branch)
  for k, v in pairs(Table_Class) do
    if v.TypeBranch == branch and v.id % 10 == 2 then
      return v.id
    end
  end
end
function ProfessionProxy:GetCurSex()
  local userData = Game.Myself.data.userdata
  if userData then
    local gender = userData:Get(UDEnum.SEX)
    if gender then
      return gender
    end
  end
  return 1
end
function ProfessionProxy:SafeSetColor(object, colorKey)
  if ColorUtil[colorKey] then
    object = ColorUtil.CareerFlag4
  else
    helplog("\231\173\150\229\136\146\233\133\141\231\189\174\232\161\168\233\151\174\233\162\152\239\188\129\239\188\129\239\188\129\232\175\183\231\173\150\229\136\146\230\163\128\230\159\165ColorUtil\239\188\129\239\188\129\239\188\129\232\161\168\228\184\173\231\188\186\228\185\143colorKey\239\188\154" .. colorKey .. "\239\188\129\239\188\129\239\188\129\239\188\129")
  end
end
function ProfessionProxy:SafeGetColorFromColorUtil(colorKey)
  if ColorUtil[colorKey] then
    return ColorUtil[colorKey]
  else
    helplog("\231\173\150\229\136\146\233\133\141\231\189\174\232\161\168\233\151\174\233\162\152\239\188\129\239\188\129\239\188\129\232\175\183\231\173\150\229\136\146\230\163\128\230\159\165ColorUtil\239\188\129\239\188\129\239\188\129\232\161\168\228\184\173\231\188\186\228\185\143colorKey\239\188\154" .. colorKey .. "\239\188\129\239\188\129\239\188\129\239\188\129")
    return Color(1, 1, 1, 1)
  end
end
ProfessionData = class("ProfessionData")
function ProfessionData:ctor(data, depth)
  self.id = data.id
  self.data = data
  self.depth = depth or 0
  self.nextProfessions = {}
  self.parentProfession = nil
end
function ProfessionData:GetNextByBranch(typeBranch)
  return self.nextProfessions[typeBranch]
end
function ProfessionData:AddNext(profession)
  profession:SetParent(self)
  profession.depth = self.depth + 1
  self.nextProfessions[profession.data.TypeBranch] = profession
end
function ProfessionData:SetParent(parent)
  self.parentProfession = parent
end
ProfessionTree = class("ProfessionTree")
function ProfessionTree:ctor(root, transferRoot)
  self.root = root
  self.transferRoot = transferRoot
end
function ProfessionTree:GetProfessDataByClassID(classID)
  if self.transferRoot then
    return self:RecurseFindClass(self.transferRoot, classID)
  end
  return nil
end
function ProfessionTree:RecurseFindClass(profess, classID)
  if profess then
    if profess.id == classID then
      return profess
    else
      local find
      for branch, profession in pairs(profess.nextProfessions) do
        find = self:RecurseFindClass(profession, classID)
        if find then
          return find
        end
      end
    end
  end
  return nil
end
function ProfessionTree:InitSkillPath(classID)
  if self.classID ~= classID then
    self.classID = classID
    self.paths = {}
    local classData = Table_Class[self.classID]
    self:RecurseParsePathByProfess(self.transferRoot, classData.TypeBranch)
    ProfessionTree.HandlePath(self.paths)
  end
end
function ProfessionTree:RecurseParsePathByProfess(data, typeBranch)
  if data then
    local skills = Table_Class[data.id].Skill
    if skills then
      ProfessionTree.ParsePath(skills, self.paths, data.id)
      for k, v in pairs(data.nextProfessions) do
        if k == typeBranch then
          self:RecurseParsePathByProfess(v, typeBranch)
        end
      end
    end
  end
end
function ProfessionTree.HandlePath(paths)
  local posData, requiredData
  for hang, hangPaths in pairs(paths) do
    local up = true
    local endlie
    for lie, data in pairs(hangPaths) do
      if data.requiredID then
        posData = ProfessionTree.GetPos(data.requiredID, data.profession) or {0, 0}
        up = endlie == nil or endlie >= posData[1]
        requiredData = hangPaths[posData[1]]
        if requiredData then
          for i = posData[1] + 1, lie - 1 do
            if hangPaths[i] then
              requiredData.between = true
              requiredData.up = up
              endlie = lie
              break
            end
          end
        end
      end
    end
  end
end
function ProfessionTree.ParsePath(skills, paths, profession)
  if skills then
    local skill, posData, path, requiredID
    for i = 1, #skills do
      skill = skills[i]
      posData = ProfessionTree.GetPos(skill, profession)
      skill = Table_Skill[skill]
      if posData then
        path = paths[posData[2]]
        if path == nil then
          path = {}
          paths[posData[2]] = path
        end
        requiredID = skill.Contidion and skill.Contidion.skillid or nil
        requiredID = requiredID and math.floor(requiredID / 1000) * 1000 + 1
        path[posData[1]] = {
          id = skill.id,
          requiredID = requiredID,
          profession = profession
        }
      end
    end
  end
end
function ProfessionTree.GetPos(skillid, profession)
  local data = Table_SkillMould[skillid]
  if data ~= nil then
    local pos = data.Pos
    if pos ~= nil and #pos > 0 then
      return pos
    end
    pos = data.ProfessionPos
    if pos ~= nil and profession ~= nil then
      return pos[profession]
    end
  end
  return nil
end
