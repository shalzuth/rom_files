MainViewInfoPage = class("MainViewInfoPage", SubView)
autoImport("BaseItemCell")
autoImport("PlayerFaceCell")
autoImport("BuffCell")
autoImport("FloatNormalTip")
local BUFFTYPE_DOUBLEEXPCARD = "MultiTime"
function MainViewInfoPage:Init()
  self:Init_RecallBuffMap()
  self:InitGvgDroiyanTriggerInfo()
  self:FindObjs()
  self:AddViewListen()
  self.buffs = {}
  self.guideList = {}
  self.weak_dialog_queue = {}
  self.isLandscapeLeft = true
end
local RECALL_BUFF_REFLECT_MAP
local RECALL_BUFF_REWARD_MAP = {}
local recall_buffmap = {}
function MainViewInfoPage:Init_RecallBuffMap()
  RECALL_BUFF_REFLECT_MAP = GameConfig.Recall.reward_buff_reflectshow or _EmptyTable
  local ZhTip_Map = {
    seal = ZhString.MainViewInfoPage_seal,
    board = ZhString.MainViewInfoPage_board,
    laboratory = ZhString.MainViewInfoPage_laboratory,
    tower = ZhString.MainViewInfoPage_tower,
    donate = ZhString.MainViewInfoPage_donate
  }
  local reward_bufflayer = GameConfig.Recall.reward_bufflayer or _EmptyTable
  for k, v in pairs(reward_bufflayer) do
    RECALL_BUFF_REWARD_MAP[v.id] = {
      v.layer,
      ZhTip_Map[k]
    }
  end
end
function MainViewInfoPage:OnEnter()
  self.super.OnEnter(self)
  EventManager.Me():AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  self:UpdateAllInfo()
end
function MainViewInfoPage:OnExit()
  self.super.OnExit(self)
  EventManager.Me():RemoveEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
end
function MainViewInfoPage:FindObjs()
  self.buffgrid = self:FindComponent("BuffGrids", UIGrid)
  self.buffCtl = UIGridListCtrl.new(self.buffgrid, BuffCell, "BuffCell")
  self.buffCtl:AddEventListener(BuffCellEvent.BuffEnd, self.RemoveTimeEndBuff, self)
  self.buffCtl:AddEventListener(MouseEvent.MouseClick, self.ClickBuffEvent, self)
  self.buffDatas = {}
  self.buffListDatas = {}
  self.sceneMapName = self:FindComponent("SceneMapName", UILabel)
  self.buffScrollView = self:FindComponent("BuffScrollView", UIScrollView)
  self.foldbord = self:FindChild("foldBord")
  self.foldSymbol = self:FindChild("foldSymbol")
  self.currentLine = self:FindComponent("CurrentLine", UILabel)
  self.currentLine.fontSize = 25
  self.objCurrentLine = self:FindGO("WorldLine")
  self.map_currentLine = self:FindComponent("Map_CurrentLine", UILabel)
  self.objMap_currentLine = self:FindGO("Map_WorldLine")
  self:InitSysInfo()
  self.endlessTower = self:FindComponent("EndLessTowerLevel", UILabel)
  self.fullProgress = self:FindGO("FullProgress")
  self:AddClickEvent(self.fullProgress, function(go)
    self:ClickFullProgress()
  end)
  self.eatFoodCount = self:FindComponent("FoodCount", UILabel)
  self.fullProgress_Icon = self:FindComponent("Icon", UISprite, self.fullProgress)
  IconManager:SetSkillIcon("Food_buff", self.fullProgress_Icon)
  self.skillAssist = self:FindGO("SkillAssist")
  self.autoBattleButton = self:FindGO("AutoBattleButton")
  self.boothBtn = self:FindGO("BoothBtn")
  self:AddClickEvent(self.boothBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.BoothMainView
    })
  end)
  self.baseBg = self:FindComponent("BaseBg", UISprite)
  self.jobBg = self:FindComponent("JobBg", UISprite)
end
function MainViewInfoPage:InitSysInfo()
  self.sysTimeLab = self:FindComponent("SysTime", UILabel)
  self.sysTimeLab.fontSize = 25
  self.sysTimeLab.transform.localPosition = Vector3(-14, -1.8, 0)
  self.batterySlider = self:FindComponent("BatteryPctSlider", UISlider)
  self.batterySlider_Foreground = self:FindComponent("Foreground", UISprite, self.batterySlider.gameObject)
  self.battery_IsCharge = self:FindGO("BatteryChargeSymbol")
  self.wifiSymbols = {}
  for i = 1, 4 do
    table.insert(self.wifiSymbols, self:FindGO("Wifi" .. i))
  end
  if ApplicationInfo.IsRunOnWindowns() then
    self.wifiSymbols[1]:SetActive(false)
    self.sysTimeLab.gameObject:SetActive(false)
    self.batterySlider.gameObject:SetActive(false)
  end
end
function MainViewInfoPage:ClickFullProgress()
  local buffProps, buffInvalidTimeList = FoodProxy.Instance:GetMyFoodBuffProps()
  local curentSeverTime = ServerTime.CurServerTime()
  local buffDesc = ""
  local buffDescTime = ""
  for i = 1, #buffProps do
    local buffData = buffProps[i]
    TableUtil.Print(buffData)
    if buffData.value > 0 then
      if buffData.propVO.isPercent then
        buffDesc = buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buffData.propVO.displayName) .. "+" .. tostring(buffData.value / 10) .. "%"
      else
        buffDesc = buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buffData.propVO.displayName) .. "+" .. tostring(buffData.value)
      end
    elseif buffData.propVO.isPercent then
      buffDesc = buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buffData.propVO.displayName) .. tostring(buffData.value / 10) .. "%"
    else
      buffDesc = buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buffData.propVO.displayName) .. tostring(buffData.value)
    end
    local lastTime = (buffInvalidTimeList[buffData.propVO.name] - curentSeverTime / 1000) / 60
    if lastTime > 0 then
      buffDescTime = buffDescTime .. math.floor(lastTime) .. ZhString.MainViewInfoPage_Min .. "\n"
    end
    if i < #buffProps then
      buffDesc = buffDesc .. "\n"
    end
  end
  TipsView.Me():ShowStickTip(EatFoodInfoTip, {desc = buffDesc, time = buffDescTime}, NGUIUtil.AnchorSide.DownRight, self.fullProgress_Icon, {30, 0})
end
function MainViewInfoPage:ClickBuffEvent(cellCtl)
  local data = cellCtl.data
  if data then
    local staticData = data and data.staticData
    local oriDec = staticData and staticData.BuffDesc or ""
    helplog(oriDec)
    TipsView.Me():ShowStickTip(FloatNormalTip, oriDec, NGUIUtil.AnchorSide.DownRight, cellCtl.icon, {30, 0})
    TipsView.Me().currentTip:SetUpdateSetText(1000, MainViewInfoPage.UpdateBuffTip, data)
  end
end
function MainViewInfoPage.UpdateBuffTip(data)
  if data == nil then
    return true, "NO DATA"
  end
  if data.storage then
    return true, MainViewInfoPage.GetStorgeDesc(data.storage)
  end
  local staticData = data.staticData
  if staticData == nil then
    return true, "No Buff StaticData"
  end
  local desc, text = staticData.BuffDesc, nil
  if data.fromname and data.fromname ~= "" then
    desc = string.format(desc, data.fromname)
  end
  if data.isRecallBuff then
    local tempArray = {}
    for id, layer in pairs(recall_buffmap) do
      local info = RECALL_BUFF_REWARD_MAP[id]
      table.insert(tempArray, {
        id,
        string.format(info[2], info[1] - layer, info[1])
      })
    end
    table.sort(tempArray, function(a, b)
      return a[1] < b[1]
    end)
    local recall_desc = ""
    for i = 1, #tempArray do
      recall_desc = recall_desc .. tempArray[i][2]
      if i < #tempArray then
        recall_desc = recall_desc .. "\n"
      end
    end
    return true, desc .. recall_desc
  end
  if data.isEquipBuff and desc ~= "" then
    desc = string.gsub(desc, "%[OffingEquipPoses%]", MainViewInfoPage.GetOffingEquipPoses())
    desc = string.gsub(desc, "%[ProtectEquipPoses%]", MainViewInfoPage.GetProtectEquipPoses())
    desc = string.gsub(desc, "%[BreakEquipPoses%]", MainViewInfoPage.GetBreakEquipPoses())
  end
  local betype = staticData.BuffEffect.type
  if betype == BUFFTYPE_DOUBLEEXPCARD then
    if data.active then
      text = staticData.BuffName .. ZhString.BuffCell_BuffActive .. [[


]]
    else
      text = staticData.BuffName .. ZhString.BuffCell_BuffInActive .. [[


]]
    end
    local leftTime = math.ceil(data.layer / 60)
    text = text .. desc .. [[


]] .. string.format(ZhString.BuffCell_DELeftTimeTip, leftTime)
  else
    if data.isalways then
      return true, desc
    end
    local curServerTime = ServerTime.CurServerTime() / 1000
    local endtime = data.endtime and data.endtime / 1000
    if endtime then
      if curServerTime > endtime then
        return true, text
      else
        local leftSec = math.floor(endtime - curServerTime)
        local leftStr = ""
        local day = math.floor(leftSec / 86400)
        if day <= 0 then
          local hour = math.floor(leftSec / 3600)
          local min = math.floor((leftSec - hour * 60 * 60) / 60)
          if hour <= 0 then
            if min <= 0 then
              leftStr = leftSec .. ZhString.MainViewInfoPage_Sec
            else
              leftStr = min .. ZhString.MainViewInfoPage_Min
            end
          else
            leftStr = hour .. ZhString.MainViewInfoPage_Hour
            leftStr = leftStr .. min .. ZhString.MainViewInfoPage_Min
          end
        else
          leftStr = day .. ZhString.MainViewInfoPage_Day
        end
        text = desc .. [[


]] .. string.format(ZhString.MainViewInfoPage_BuffLeftTimeTip, leftStr)
      end
    else
      return true, desc
    end
  end
  return false, text
end
function MainViewInfoPage.GetOffingEquipPoses()
  local offPoses = MyselfProxy.Instance:GetOffingEquipPoses()
  local resultStr = ""
  for i = 1, #offPoses do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(offPoses[i])
    if i < #offPoses then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end
function MainViewInfoPage.GetProtectEquipPoses()
  local protectPoses = MyselfProxy.Instance:GetProtectEquipPoses()
  local resultStr = ""
  for i = 1, #protectPoses do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(protectPoses[i])
    if i < #protectPoses then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end
function MainViewInfoPage.GetBreakEquipPoses()
  local breakInfos = BagProxy.Instance.roleEquip:GetBreakEquipSiteInfo()
  local resultStr = ""
  for i = 1, #breakInfos do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(breakInfos[i].index)
    if i < #breakInfos then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end
function MainViewInfoPage.GetStorgeDesc(storage)
  local desc = ""
  if storage[1] then
    local desc1 = Table_Buffer[storage[1][1]].BuffDesc
    desc1 = string.gsub(desc1, "%[HPStorage%]", storage[1][2] or 0)
    if desc ~= "" then
      desc = desc .. "\n"
    end
    desc = desc .. desc1
  end
  if storage[2] then
    local desc2 = Table_Buffer[storage[2][1]].BuffDesc
    desc2 = string.gsub(desc2, "%[SPStorage%]", storage[2][2] or 0)
    if desc ~= "" then
      desc = desc .. "\n"
    end
    desc = desc .. desc2
  end
  return desc
end
function MainViewInfoPage.GetHPStorage(data)
  return data.storage or 0
end
function MainViewInfoPage.GetSPStorage(data)
  return data.storage or 0
end
function MainViewInfoPage:UpdateAllInfo()
  self:UpdateJobSlider()
  self:UpdateExpSlider()
  self:UpdateSysInfo()
  self:UpdateCurrentLine(false)
  self:UpdateFoodCount()
  self.battlePoint = Game.Myself.data.userdata:Get(UDEnum.BATTLEPOINT)
end
function MainViewInfoPage:OnShow()
  self:UpdateBaseJobAnchors()
  local baseGrid = self:FindComponent("BaseExpGrid", UIGrid)
  baseGrid.cellWidth = (self.baseBg.width - 50) / 10
  baseGrid:Reposition()
  local jobGrid = self:FindComponent("JobExpGrid", UIGrid)
  jobGrid.cellWidth = (self.jobBg.width - 50) / 10
  jobGrid:Reposition()
end
function MainViewInfoPage:UpdateCurrentLine()
  if Game.MapManager:IsPVPMode_MvpFight() or Game.MapManager:IsPVPMode_TeamPws() then
    self.objCurrentLine:SetActive(false)
    self.objMap_currentLine:SetActive(false)
    return
  end
  self.objCurrentLine:SetActive(true)
  self.objMap_currentLine:SetActive(true)
  self.currentLine.text = ChangeZoneProxy.Instance:ZoneNumToString(MyselfProxy.Instance:GetZoneId())
  self.map_currentLine.text = ChangeZoneProxy.Instance:ZoneNumToString(MyselfProxy.Instance:GetZoneId())
end
function MainViewInfoPage:UpdateFoodCount()
  local foodList = FoodProxy.Instance:GetEatFoods()
  local effectiveFoodCount = 0
  if foodList and #foodList > 0 then
    for i = 1, #foodList do
      local food = foodList[i]
      if food.itemid ~= 551019 then
        effectiveFoodCount = effectiveFoodCount + 1
      end
    end
  end
  if effectiveFoodCount > 0 then
    self.eatFoodCount.text = effectiveFoodCount
  else
    self.eatFoodCount.text = ""
  end
  self.fullProgress:SetActive(effectiveFoodCount > 0)
end
function MainViewInfoPage:UpdateCurrentLine(isMvp)
  if isMvp == true then
    self.objCurrentLine:SetActive(false)
    self.objMap_currentLine:SetActive(false)
    return
  end
  self.objCurrentLine:SetActive(true)
  self.objMap_currentLine:SetActive(true)
  self.currentLine.text = ChangeZoneProxy.Instance:ZoneNumToString(MyselfProxy.Instance:GetZoneId())
  self.map_currentLine.text = ChangeZoneProxy.Instance:ZoneNumToString(MyselfProxy.Instance:GetZoneId())
end
function MainViewInfoPage:RemoveTimeEndBuff(buffdata)
  local id = buffdata.id
  self:RemoveRoleBuff({
    body = {id}
  })
end
function MainViewInfoPage:AddViewListen()
  self:AddListenEvt(MyselfEvent.BaseExpChange, self.UpdateExpSlider)
  self:AddListenEvt(MyselfEvent.JobExpChange, self.UpdateJobSlider)
  self:AddListenEvt(MyselfEvent.ZoneIdChange, self.UpdateCurrentLine)
  self:AddListenEvt(PVPEvent.PVP_MVPFightLaunch, self.HandleEnterMvp)
  self:AddListenEvt(PVPEvent.PVP_MVPFightShutDown, self.HandleExitMvp)
  self:AddListenEvt(ServiceEvent.SceneFoodFoodInfoNtf, self.UpdateFoodCount)
  self:AddListenEvt(ServiceEvent.SceneFoodUpdateFoodInfo, self.UpdateFoodCount)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleMapLoaded)
  self:AddListenEvt(MyselfEvent.AddBuffs, self.AddRoleBuff)
  self:AddListenEvt(MyselfEvent.RemoveBuffs, self.RemoveRoleBuff)
  self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.HandlePoringFightLaunch)
  self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.HandlePoringFightShutdown)
  self:AddListenEvt(ServiceEvent.LoginUserCmdLoginResultUserCmd, self.ClearBuffCache)
  self:AddListenEvt(BoothEvent.ShowMiniBooth, self.HandleBooth)
  self:AddListenEvt(ServiceEvent.NUserBoothReqUserCmd, self.HandleBooth)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleReconnect)
end
function MainViewInfoPage:HandleEnterMvp(note)
  self:UpdateCurrentLine(true)
end
function MainViewInfoPage:HandleExitMvp(note)
  self:UpdateCurrentLine(false)
end
function MainViewInfoPage:ClearBuffCache()
  TableUtility.ArrayClear(recall_buffmap)
  self:ResetBuffData()
end
local tempColor = LuaColor.New(1, 1, 1, 1)
function MainViewInfoPage:UpdateSysInfo()
  if ApplicationInfo.IsRunOnWindowns() then
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self.sysTimeLab.text = ClientTimeUtil.GetNowHourMinStr()
    local btvalue = ExternalInterfaces.GetSysBatteryPct() / 100
    self.batterySlider.value = btvalue
    if btvalue <= 0.1 then
      tempColor:Set(0.6784313725490196, 0 / 255, 0 / 255, 1)
      self.batterySlider_Foreground.color = tempColor
    else
      tempColor:Set(1, 1, 1, 1)
      self.batterySlider_Foreground.color = tempColor
    end
    local isCharge = ExternalInterfaces.GetSysBatteryIsCharge()
    self.battery_IsCharge:SetActive(isCharge)
  end, self, 1)
end
function MainViewInfoPage:HandleMapLoaded(note)
  self:HandleSceneMapName(note)
  if self.boothBtn.activeSelf then
    self.boothBtn:SetActive(BoothProxy.Instance:CanMapBooth())
  end
end
function MainViewInfoPage:HandleMapLoaded(note)
  self:HandleSceneMapName(note)
  if self.boothBtn.activeSelf then
    self.boothBtn:SetActive(BoothProxy.Instance:CanMapBooth())
  end
end
local MapManager = Game.MapManager
function MainViewInfoPage:HandleSceneMapName(note)
  if MapManager:IsRaidMode() then
    local mapid = MapManager:GetMapID()
    local raidData = Table_MapRaid[mapid]
    if raidData then
      if raidData.Type == FunctionDungen.EndlessTowerType then
        self:Show(self.sceneMapName)
        self.sceneMapName.text = Game.MapManager:GetMapName()
        return
      elseif raidData.Type == FunctionDungen.DojoType then
        self:Show(self.sceneMapName)
        self.sceneMapName.text = raidData.NameZh
        return
      end
    end
  end
  self:Hide(self.sceneMapName)
end
function MainViewInfoPage:UpdateExpSlider(note)
  if not self.roleSlider then
    self.roleSlider = self:FindComponent("BaseExpSlider", UISlider)
  end
  local userdata = Game.Myself.data.userdata
  local roleExp = userdata:Get(UDEnum.ROLEEXP)
  local nowrolelv = userdata:Get(UDEnum.ROLELEVEL)
  if nowrolelv then
    local upExp = 1
    if Table_BaseLevel[nowrolelv + 1] ~= nil then
      upExp = Table_BaseLevel[nowrolelv + 1].NeedExp
    end
    self.roleSlider.value = roleExp / upExp
  end
end
local tempColor = LuaColor(1, 1, 1, 1)
function MainViewInfoPage:UpdateJobSlider(note)
  if not self.jobSlider then
    self.jobSlider = self:FindComponent("JobExpSlider", UISlider)
  end
  local userdata = Game.Myself.data.userdata
  local jobExp = userdata:Get(UDEnum.JOBEXP)
  local nowJobLevel = userdata:Get(UDEnum.JOBLEVEL)
  if nowJobLevel then
    local referenceValue = Table_JobLevel[nowJobLevel + 1]
    referenceValue = referenceValue == nil and 1 or referenceValue.JobExp
    self.jobSlider.value = jobExp / referenceValue
    if not self.jobSliderSps then
      self.jobSliderSps = {}
      local jobBg = self:FindGO("JobBg")
      for i = 1, 9 do
        table.insert(self.jobSliderSps, self:FindComponent(tostring(i), UISprite, jobBg))
      end
    end
    for i = 1, #self.jobSliderSps do
      local sp = self.jobSliderSps[i]
      if self.jobSlider.value >= i * 0.1 then
        sp.color = tempColor
      else
        sp.color = tempColor
      end
    end
  end
end
function MainViewInfoPage:AddRoleBuff(note)
  local ids = note.body
  if ids == nil then
    return
  end
  for i = 1, #ids do
    self:UpdateBuffData(ids[i])
  end
  self:ResetBuffData()
end
function MainViewInfoPage:UpdateBuffData(recv_buffdata)
  local id = recv_buffdata.id
  if RECALL_BUFF_REFLECT_MAP[id] then
    self:UpdateBuffData_RecallBuffer(recv_buffdata)
    return
  end
  local configData = Table_Buffer[id]
  if configData == nil then
    return
  end
  local betype = configData.BuffEffect.type
  if betype == "HPStorage" or betype == "SPStorage" then
    self:UpdateStorageBuffer(recv_buffdata)
    return
  end
  if configData.BuffIcon == nil or configData.BuffIcon == "" then
    return
  end
  local buffData = self.buffDatas[id]
  if buffData == nil then
    buffData = {id = id, staticData = configData}
    self.buffDatas[id] = buffData
  end
  buffData.layer = recv_buffdata.layer
  buffData.fromname = recv_buffdata.fromname
  buffData.active = recv_buffdata.active
  buffData.isEquipBuff = recv_buffdata.isEquipBuff
  buffData.isalways = recv_buffdata.isalways
  if not buffData.isalways and configData.IconType and configData.IconType == 1 and recv_buffdata.time and recv_buffdata.time ~= 0 then
    if not buffData.endtime or buffData.endtime ~= recv_buffdata.time then
      buffData.starttime = ServerTime.CurServerTime()
    end
    buffData.endtime = recv_buffdata.time
  end
  self.buffDatas[id] = buffData
end
local STORAGE_FAKE_ID = "storage_fake_id"
function MainViewInfoPage:UpdateStorageBuffer(recv_buffdata)
  local id, layer = recv_buffdata.layer or recv_buffdata.id, 0
  local fakeBuff = self.buffDatas[STORAGE_FAKE_ID]
  if layer > 0 then
    if fakeBuff == nil then
      fakeBuff = {
        id = STORAGE_FAKE_ID,
        storage = {}
      }
      self.buffDatas[STORAGE_FAKE_ID] = fakeBuff
    end
    local etype = Table_Buffer[id].BuffEffect.type
    local storage
    if etype == "HPStorage" then
      storage = fakeBuff.storage[1]
      if storage == nil then
        storage = {id}
        fakeBuff.storage[1] = storage
      end
    elseif etype == "SPStorage" then
      storage = fakeBuff.storage[2]
      if storage == nil then
        storage = {id}
        fakeBuff.storage[2] = storage
      end
    end
    storage[2] = layer
  elseif fakeBuff ~= nil then
    local etype = Table_Buffer[id].BuffEffect.type
    local storage
    if etype == "HPStorage" then
      fakeBuff.storage[1] = nil
    elseif etype == "SPStorage" then
      fakeBuff.storage[2] = nil
    end
    if not next(fakeBuff.storage) then
      fakeBuff = nil
      self.buffDatas[STORAGE_FAKE_ID] = nil
    end
  end
end
function MainViewInfoPage:UpdateBuffData_RecallBuffer(recv_buffdata)
  local id, layer = recv_buffdata.id, recv_buffdata.layer
  local maxlayer = RECALL_BUFF_REWARD_MAP[id][1]
  if layer == 0 then
    recall_buffmap[id] = nil
  else
    recall_buffmap[id] = layer
  end
  self:UpdateBuffData_RecallBuffer_Reflect(RECALL_BUFF_REFLECT_MAP[id])
end
function MainViewInfoPage:UpdateBuffData_RecallBuffer_Reflect(reflectid)
  if reflectid == nil then
    return
  end
  local has_recallBuff = false
  local tk, _ = next(recall_buffmap)
  if tk ~= nil then
    has_recallBuff = true
  end
  if has_recallBuff == false then
    if self.buffDatas[reflectid] ~= nil then
      self.buffDatas[reflectid] = nil
    end
  else
    local configData = Table_Buffer[reflectid]
    if configData == nil then
      return
    end
    if self.buffDatas[reflectid] == nil then
      local reflect_buffData = {}
      reflect_buffData.id = reflectid
      reflect_buffData.staticData = configData
      reflect_buffData.isRecallBuff = true
      reflect_buffData.isalways = true
      self.buffDatas[reflectid] = reflect_buffData
    end
  end
end
function MainViewInfoPage:RemoveRoleBuff(note)
  local ids = note.body or {}
  local t_buffer = Table_Buffer
  for i = 1, #ids do
    local id = ids[i]
    if RECALL_BUFF_REFLECT_MAP[id] then
      self:UpdateBuffData_RecallBuffer_Reflect(RECALL_BUFF_REFLECT_MAP[id])
    else
      local config = t_buffer[id]
      local betype
      if config ~= nil and config.BuffEffect ~= nil then
        betype = config.BuffEffect.type
      end
      if betype == "HPStorage" or betype == "SPStorage" then
        self:UpdateStorageBuffer({id = id, layer = 0})
      else
        self.buffDatas[id] = nil
      end
    end
  end
  self:ResetBuffData()
end
function MainViewInfoPage._SortBuffData(a, b)
  if a.isalways ~= nil or b.isalways ~= nil then
    return a.isalways == true
  end
  if a.id == STORAGE_FAKE_ID or b.id == STORAGE_FAKE_ID then
    return a.id == STORAGE_FAKE_ID
  end
  local aBuffCfg = Table_Buffer[a.id]
  local bBuffCfg = Table_Buffer[b.id]
  if aBuffCfg and bBuffCfg then
    local aIsDeBuff = aBuffCfg.BuffType.isgain == 0
    local bIsDeBuff = bBuffCfg.BuffType.isgain == 0
    if aIsDeBuff ~= bIsDeBuff then
      return aIsDeBuff
    end
    if aBuffCfg.IconType and bBuffCfg.IconType then
      if aBuffCfg.IconType ~= bBuffCfg.IconType then
        return aBuffCfg.IconType > bBuffCfg.IconType
      end
      if aBuffCfg.IconType == 1 and bBuffCfg.IconType == 1 and a.endtime and b.endtime and a.endtime and b.endtime then
        return a.endtime > b.endtime
      end
    end
  end
  return a.id < b.id
end
function MainViewInfoPage:ResetBuffData()
  TableUtility.ArrayClear(self.buffListDatas)
  for _, bData in pairs(self.buffDatas) do
    table.insert(self.buffListDatas, bData)
  end
  table.sort(self.buffListDatas, MainViewInfoPage._SortBuffData)
  local limit = GameConfig.BuffMaxShowCount or 20
  if self.fullProgress.activeSelf then
    limit = limit - 1
  end
  if limit < #self.buffListDatas then
    for i = #self.buffListDatas, limit + 1, -1 do
      table.remove(self.buffListDatas, i)
    end
  end
  self.buffCtl:ResetDatas(self.buffListDatas)
  self.buffScrollView:ResetPosition()
  self.buffgrid.enabled = true
end
local PoringFight_ForbidView = {
  1,
  4,
  181,
  320,
  400,
  101,
  480,
  520,
  720,
  920,
  83,
  11,
  351,
  352,
  354
}
function MainViewInfoPage:HandlePoringFightLaunch(note)
  for i = 1, #PoringFight_ForbidView do
    UIManagerProxy.Instance:SetForbidView(PoringFight_ForbidView[i], 3606, true)
  end
  self.fullProgress:SetActive(false)
  self.skillAssist:SetActive(false)
  self.autoBattleButton:SetActive(false)
end
function MainViewInfoPage:HandlePoringFightShutdown(note)
  for i = 1, #PoringFight_ForbidView do
    UIManagerProxy.Instance:UnSetForbidView(PoringFight_ForbidView[i])
  end
  self.fullProgress:SetActive(true)
  self.skillAssist:SetActive(true)
  self.autoBattleButton:SetActive(true)
end
function MainViewInfoPage:InitGvgDroiyanTriggerInfo()
  self:AddListenEvt(TriggerEvent.Enter_GDFightForArea, self.HandleEnterGDFightforArea)
  self:AddListenEvt(TriggerEvent.Leave_GDFightForArea, self.HandleLeaveOrRemoveGDFightforArea)
  self:AddListenEvt(TriggerEvent.Remove_GDFightForArea, self.HandleLeaveOrRemoveGDFightforArea)
end
function MainViewInfoPage:GetGvgDroiyanOccupyInfoCell()
  if self.gvg_OccupyInfoCell ~= nil then
    return self.gvg_OccupyInfoCell
  end
  local obj = self:LoadPreferb("cell/GvgDroiyan_OccupyInfoCell", self.gameObject)
  if GvgDroiyan_OccupyInfoCell == nil then
    autoImport("GvgDroiyan_OccupyInfoCell")
  end
  self.gvg_OccupyInfoCell = GvgDroiyan_OccupyInfoCell.new(obj)
  return self.gvg_OccupyInfoCell
end
function MainViewInfoPage:HandleEnterGDFightforArea(note)
  local id = note.body
  if id == nil then
    return
  end
  local occupyInfoCell = self:GetGvgDroiyanOccupyInfoCell()
  occupyInfoCell:SetData(id)
end
function MainViewInfoPage:HandleLeaveOrRemoveGDFightforArea(note)
  local occupyInfoCell = self:GetGvgDroiyanOccupyInfoCell()
  occupyInfoCell:HideSelf()
end
function MainViewInfoPage:HandleBooth(note)
  local data = note.body
  if type(data) == "table" then
    self.boothBtn:SetActive(data.oper == BoothProxy.OperEnum.Open)
  else
    self.boothBtn:SetActive(data)
  end
end
function MainViewInfoPage:HandleReconnect(note)
  if Game.Myself:IsInBooth() then
    BoothProxy.Instance:ClearMyselfBooth()
  end
end
function MainViewInfoPage:HandleOrientationChange(note)
  if note.data == nil then
    return
  end
  self.isLandscapeLeft = note.data
  self:OnShow()
end
function MainViewInfoPage:UpdateBaseJobAnchors()
  if BackwardCompatibilityUtil.CompatibilityMode_V29 then
    self.baseBg:ResetAndUpdateAnchors()
    self.jobBg:ResetAndUpdateAnchors()
    return
  end
  local l, t, r, b = UIManagerProxy.Instance:GetMyMobileScreenAdaptionOffsets(self.isLandscapeLeft)
  local hasMobileScreenAdaption = l ~= nil and (l ~= 0 or r ~= 0)
  if hasMobileScreenAdaption then
    self.baseBg.leftAnchor.absolute = r
    self.jobBg.rightAnchor.absolute = -l
    local anchorDownOffset = (r - l) / 2
    self.baseBg.rightAnchor.absolute = 3 + anchorDownOffset
    self.jobBg.leftAnchor.absolute = -3 + anchorDownOffset
  end
  self.baseBg.anchorsCached = false
  self.jobBg.anchorsCached = false
  self.baseBg:Update()
  self.jobBg:Update()
  if hasMobileScreenAdaption then
    UIUtil.ResetAndUpdateAllAnchors(self.baseBg.gameObject)
    UIUtil.ResetAndUpdateAllAnchors(self.jobBg.gameObject)
  end
end
