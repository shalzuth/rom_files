autoImport("ChangeZoneCombineCell")
ChangeZoneView = class("ChangeZoneView", ContainerView)
ChangeZoneView.ViewType = UIViewType.NormalLayer
function ChangeZoneView:OnEnter()
  ChangeZoneView.super.OnEnter(self)
  if self.npc then
    local viewPort = CameraConfig.HappyShop_ViewPort
    local rotation = CameraConfig.HappyShop_Rotation
    self:CameraFaceTo(self.npc.assetRole.completeTransform, viewPort, rotation)
  end
end
function ChangeZoneView:OnExit()
  self:CameraReset()
  ChangeZoneView.super.OnExit(self)
end
function ChangeZoneView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function ChangeZoneView:FindObjs()
  self.silverLabel = self:FindGO("SilverLabel"):GetComponent(UILabel)
  self.currentZone = self:FindGO("CurrentZone"):GetComponent(UILabel)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
  self.statusTip = self:FindGO("StatusTip"):GetComponent(UILabel)
  self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
  self.submitSprite = self:FindGO("SubmitSprite")
  self.emptyRecent = self:FindGO("EmptyRecent")
  self.costLabel = self:FindGO("Cost"):GetComponent(UILabel)
  self.costSprite = self:FindGO("CostSprite"):GetComponent(UISprite)
  self.costInfo = self:FindGO("CostInfo")
  self.costTip = self:FindGO("CostTip")
  self.changeBtn = self:FindGO("ChangeBtn")
  self.changeBtnLabel = self:FindGO("Label", self.changeBtn):GetComponent(UILabel)
  self.targetZoneAni = self:FindGO("TargetZoneBg"):GetComponent(Animator)
end
function ChangeZoneView:AddEvts()
  self:AddClickEvent(self.changeBtn, function()
    self:ClickChangeBtn()
  end)
  EventDelegate.Set(self.contentInput.onChange, function()
    if self.contentInput.value == "" then
      if self.contentInput.label.fontSize ~= 22 then
        self.contentInput.label.fontSize = 22
      end
      if self.submitSprite.activeInHierarchy then
        self.submitSprite:SetActive(false)
      end
      self:UpdateTips(true)
      self.targetZoneAni.enabled = true
    else
      if self.contentInput.label.fontSize ~= 36 then
        self.contentInput.label.fontSize = 36
      end
      if not self.submitSprite.activeInHierarchy then
        self.submitSprite:SetActive(true)
      end
      self:UpdateCost(ChangeZoneProxy.Instance:ZoneStringToNum(self.contentInput.value))
      self:UpdateTip()
      self.targetZoneAni.enabled = false
    end
  end)
end
function ChangeZoneView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.NUserQueryZoneStatusUserCmd, self.UpdateRecent)
end
function ChangeZoneView:InitShow()
  self.npc = self.viewdata.viewdata
  self.tip.text = string.format(ZhString.ChangeZone_Tip)
  local recentZoneGrid = self:FindGO("RecentZoneGrid"):GetComponent(UIGrid)
  self.recentCtl = UIGridListCtrl.new(recentZoneGrid, ChangeZoneCombineCell, "ChangeZoneCombineCell")
  self.recentCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRecentZoneItem, self)
  self:UpdateCoins()
  self:UpdateCurrentZone()
  self:UpdateRecent()
  self:UpdateCost()
  self:UpdateChangeBtn()
end
function ChangeZoneView:UpdateCoins()
  self.silverLabel.text = MyselfProxy.Instance:GetROB()
end
function ChangeZoneView:UpdateCurrentZone()
  self.currentZone.text = MyselfProxy.Instance:GetZoneString()
end
function ChangeZoneView:UpdateRecent()
  local data = ChangeZoneProxy.Instance:GetRecents()
  if #data > 0 then
    self.emptyRecent:SetActive(false)
  else
    self.emptyRecent:SetActive(true)
  end
  local newData = self:ReUniteCellData(data, 2)
  self.recentCtl:ResetDatas(newData)
end
function ChangeZoneView:UpdateCost(zoneid)
  self.cost = nil
  if MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_FIRST_EXCHANGEZONE) == 1 then
    self.costTip:SetActive(false)
    local data = ChangeZoneProxy.Instance:GetInfos(zoneid)
    if data then
      if GuildProxy.Instance:IHaveGuild() then
        if zoneid ~= GuildProxy.Instance.myGuildData.zoneid then
          self:SetCost(data)
        else
          self.costInfo:SetActive(false)
        end
      else
        self:SetCost(data)
      end
    else
      self.costInfo:SetActive(false)
    end
  else
    self.costInfo:SetActive(false)
    self.costTip:SetActive(true)
  end
  if self.cost then
    for i = 1, #self.cost do
      local cost = self.cost[i]
      local itemData = Table_Item[cost[1]]
      IconManager:SetItemIcon(itemData.Icon, self.costSprite)
      self.costLabel.text = tostring(cost[2])
    end
  end
end
function ChangeZoneView:SetCost(data)
  if not self.costInfo.activeInHierarchy then
    self.costInfo:SetActive(true)
  end
  if data.status == ZoneData.ZoneStatus.Free then
    self.cost = GameConfig.Zone.free.cost
  elseif data.status == ZoneData.ZoneStatus.Busy then
    self.cost = GameConfig.Zone.busy.cost
  elseif data.status == ZoneData.ZoneStatus.VeryBusy then
    self.cost = GameConfig.Zone.verybusy.cost
  end
end
function ChangeZoneView:UpdateChangeBtn()
  self.changeBtnLabel.text = ZhString.ChangeZone_ChangeLine
end
function ChangeZoneView:UpdateTip()
  local value = self.contentInput.value
  local num = ChangeZoneProxy.Instance:ZoneStringToNum(value)
  local data = ChangeZoneProxy.Instance:GetInfos(num)
  if data then
    local colorId
    if data.status == ZoneData.ZoneStatus.Free then
      self:UpdateTips(false)
      self.statusTip.text = string.format(ZhString.ChangeZone_FreeTip, value)
      colorId = ZoneData.ZoneColor.Free
    elseif data.status == ZoneData.ZoneStatus.Busy then
      self:UpdateTips(false)
      self.statusTip.text = string.format(ZhString.ChangeZone_BusyTip, value)
      colorId = ZoneData.ZoneColor.Busy
    elseif data.status == ZoneData.ZoneStatus.VeryBusy then
      self:UpdateTips(false)
      self.statusTip.text = string.format(ZhString.ChangeZone_VeryBusyTip, value)
      colorId = ZoneData.ZoneColor.VeryBusy
    else
      self:UpdateTips(true)
    end
    if colorId then
      local colorData = Table_GFaithUIColorConfig[colorId]
      if colorData then
        local hasc, rc = ColorUtil.TryParseHexString(colorData.name_Color)
        self.statusTip.color = rc
      end
    end
  else
    self:UpdateTips(true)
  end
end
function ChangeZoneView:UpdateTips(isShow)
  self.tip.gameObject:SetActive(isShow)
  self.statusTip.gameObject:SetActive(not isShow)
end
function ChangeZoneView:ClickRecentZoneItem(cellctl)
  if cellctl.data then
    self.currentZoneId = cellctl.data
    self.contentInput.value = ChangeZoneProxy.Instance:ZoneNumToString(self.currentZoneId)
    self:UpdateCost(self.currentZoneId)
  end
end
function ChangeZoneView:ClickChangeBtn()
  local value = self.contentInput.value
  if value == "" then
    MsgManager.ShowMsgByID(3087)
    return
  end
  if value == self.currentZone.text then
    MsgManager.ShowMsgByID(3084)
    return
  end
  local num = ChangeZoneProxy.Instance:ZoneStringToNum(value)
  local info = ChangeZoneProxy.Instance:GetInfos(num)
  if info == nil then
    MsgManager.ShowMsgByID(3088)
    return
  end
  if self.cost then
    for i = 1, #self.cost do
      local cost = self.cost[i]
      if MyselfProxy.Instance:GetROB() < cost[2] then
        MsgManager.ShowMsgByID(1)
        return
      end
    end
  end
  if self.npc and self.npc.data then
    ServiceNUserProxy.Instance:CallJumpZoneUserCmd(self.npc.data.id, num)
    LogUtility.InfoFormat("CallJumpZoneUserCmd : {0}", value)
  end
  self:CloseSelf()
end
local newData = {}
function ChangeZoneView:ReUniteCellData(datas, perRowNum)
  TableUtility.TableClear(newData)
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
