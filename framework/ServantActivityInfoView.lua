autoImport("ServantActivityInfoCell")
autoImport("DotCell")
ServantActivityInfoView = class("ServantActivityInfoView", ContainerView)
ServantActivityInfoView.ViewType = UIViewType.PopUpLayer
function ServantActivityInfoView:Init()
  self:FindObj()
  self:AddEvts()
  self:AddUIEvt()
  self:InitShow()
end
function ServantActivityInfoView:InitShow()
  self.dayData = self.viewdata.viewdata
  if not self.dayData then
    return
  end
  self.allTable = self:FindComponent("Wrap", UITable)
  self.commingTable = self:FindComponent("CommingWrap", UITable)
  self.commingCellCtl = UIGridListCtrl.new(self.commingTable, ServantActivityInfoCell, "ServantActivityInfoCell")
  self.commingCellCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickCell, self)
  self.goingTable = self:FindComponent("GoingWrap", UITable)
  self.goingCellCtl = UIGridListCtrl.new(self.goingTable, ServantActivityInfoCell, "ServantActivityInfoCell")
  self.goingCellCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickCell, self)
  self.textureIndex = 1
  self:RefreshUI()
  self:SelectFirst()
  self.timeTick = TimeTickManager.Me():CreateTick(60000, 60000, self.RefreshUI, self)
end
function ServantActivityInfoView:AddEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleEvt)
  self:AddListenEvt(ServiceEvent.NUserServantReservationUserCmd, self.RefreshUI)
end
function ServantActivityInfoView:HandleEvt()
  self:CloseSelf()
end
function ServantActivityInfoView:RefreshUI()
  self.dateLab.text = self.dayData:GetUIDisplayDate()
  local acData = self.dayData:GetActiveData()
  if #acData > 0 then
    self:Show(self.uipos)
    self:Hide(self.emptyPos)
  else
    self:Hide(self.uipos)
    self:Show(self.emptyPos)
    return
  end
  local commingData = self.dayData:GetCommingActData()
  self.commingCellCtl:ResetDatas(commingData)
  self.comingBtn.gameObject:SetActive(#commingData > 0)
  self.commingTable.gameObject:SetActive(#commingData > 0)
  self.commingTable:Reposition()
  local goingData = self.dayData:GetOnGoingActData(false)
  self.goingCellCtl:ResetDatas(goingData)
  self.goingBtn.gameObject:SetActive(#goingData > 0)
  self.goingTable.gameObject:SetActive(#goingData > 0)
  self.goingTable:Reposition()
  self.allTable:Reposition()
  local bookData = self.dayData:GetBookActData()
  self.bookLab.text = string.format(ZhString.Servant_Calendar_BookDesc, #goingData, #bookData)
end
function ServantActivityInfoView:FindObj()
  self.dateLab = self:FindComponent("DateLab", UILabel)
  self.bookLab = self:FindComponent("BookDescLab", UILabel)
  self.nextBtn = self:FindGO("NextBtn")
  self.previousBtn = self:FindGO("PreviousBtn")
  self.infotable = self:FindComponent("Infotable", UITable)
  self.infoScrollView = self:FindComponent("InfoScrollView", UIScrollView)
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.fixed_startTime = self:FindComponent("StartTime", UILabel)
  self.fixed_startTime.text = ZhString.Servant_Calendar_StartTime
  self.fixed_Reward = self:FindComponent("Reward", UILabel)
  self.fixed_Reward.text = ZhString.Servant_Calendar_Reward
  self.fixed_Location = self:FindComponent("Location", UILabel)
  self.fixed_Location.text = ZhString.Servant_Calendar_Location
  self.fixed_Desc = self:FindComponent("Desc", UILabel)
  self.fixed_Desc.text = ZhString.Servant_Calendar_Desc
  self.startTimeLab = self:FindComponent("StartTimeLab", UILabel)
  self.rewardLab = self:FindComponent("RewardLab", UILabel)
  self.locationLab = self:FindComponent("LocationLab", UILabel)
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.goingBtn = self:FindComponent("GoingPos", UILabel)
  self.comingBtn = self:FindComponent("CommingPos", UILabel)
  self.goingBtn.text = ZhString.Servant_Calendar_OnGoing
  self.comingBtn.text = ZhString.Servant_Calendar_OnComming
  self.uipos = self:FindGO("Pos")
  self.emptyPos = self:FindGO("EmptyPos")
  self.emptyLab = self:FindComponent("EmptyLab", UILabel)
  self.emptyLab.text = ZhString.Servant_Calendar_EmptyActivity
  self.dotgrid = self:FindGO("DotGrid"):GetComponent(UIGrid)
  self.dotCtl = UIGridListCtrl.new(self.dotgrid, DotCell, "ChatDotCell")
  self.rightBtn = self:FindGO("RightBtn")
  self.leftBtn = self:FindGO("LeftBtn")
  self.curTexture = self:FindGO("CurTexture"):GetComponent(UITexture)
end
function ServantActivityInfoView:SetTexture()
  local textures = self.textureArray
  if _EmptyTable == textures or #textures <= 0 then
    self.dotgrid.gameObject:SetActive(false)
    self.curTexture.gameObject:SetActive(false)
    return
  end
  self.dotgrid.gameObject:SetActive(true)
  self.curTexture.gameObject:SetActive(true)
  PictureManager.Instance:SetUI(textures[self.textureIndex].texture, self.curTexture)
  self.nameLab.text = textures[self.textureIndex].desc
  self.dotCtl:ResetDatas(textures)
  local dot = self:GetSelectDotCell()
  if dot then
    dot:SetChoose(false)
  end
  dot = self.dotCtl:GetCells()[self.textureIndex]
  dot:SetChoose(true)
end
function ServantActivityInfoView:AddUIEvt()
  self:AddClickEvent(self.nextBtn, function(go)
    self:OnClickTomorrow()
  end)
  self:AddClickEvent(self.rightBtn, function(go)
    self.textureIndex = self.textureIndex + 1
    if self.textureIndex > #self.textureArray then
      self.textureIndex = 1
    end
    self:SetTexture()
  end)
  self:AddClickEvent(self.leftBtn, function(go)
    self.textureIndex = self.textureIndex - 1
    if self.textureIndex == 0 then
      self.textureIndex = #self.textureArray
    end
    self:SetTexture()
  end)
  self:AddClickEvent(self.previousBtn, function(go)
    self:OnClickYesterday()
  end)
  self:AddClickEvent(self.goingBtn.gameObject, function(go)
    self.goingTable.gameObject:SetActive(not self.goingTable.gameObject.activeSelf)
    self.goingTable:Reposition()
    self.allTable:Reposition()
  end)
  self:AddClickEvent(self.comingBtn.gameObject, function(go)
    self.commingTable.gameObject:SetActive(not self.commingTable.gameObject.activeSelf)
    self.commingTable:Reposition()
    self.allTable:Reposition()
  end)
end
function ServantActivityInfoView:ClickCell(cellCtl)
  local data = cellCtl.data
  if not data then
    return
  end
end
function ServantActivityInfoView:SelectFirst()
  local first = {}
  local goingcells = self.goingCellCtl:GetCells()
  local commingcells = self.commingCellCtl:GetCells()
  if #goingcells > 0 then
    first = goingcells[1]
  elseif #commingcells > 0 then
    first = commingcells[1]
  end
  if first then
    self:HandleClickCell(first)
  end
end
function ServantActivityInfoView:SetChooseActive(id)
  local cells = self.goingCellCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(id)
  end
  local cells = self.commingCellCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(id)
  end
end
local FORMAT = "%s-%s"
function ServantActivityInfoView:HandleClickCell(cell)
  local acData = cell.data
  if not acData then
    return
  end
  local staticData = acData.staticData
  self.infoScrollView:ResetPosition()
  self.startTimeLab.text = string.format(FORMAT, staticData.StartTime, staticData.EndTime)
  self.rewardLab.text = staticData.Reward
  self.locationLab.text = staticData.Location
  self.descLab.text = staticData.Desc
  self:SetChooseActive(staticData.id)
  self.textureArray = staticData.TextureName
  self.textureIndex = 1
  self:SetTexture()
  self.infotable:Reposition()
end
function ServantActivityInfoView:OnExit()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
function ServantActivityInfoView:OnClickTomorrow()
  local dayData = ServantCalendarProxy.Instance:GetNearlyData(self.dayData.year, self.dayData.month, self.dayData.day, true)
  if not dayData then
    MsgManager.ShowMsgByID(34001)
    return
  end
  self.dayData = dayData
  self:RefreshUI()
  self:SelectFirst()
end
function ServantActivityInfoView:OnClickYesterday()
  local dayData = ServantCalendarProxy.Instance:GetNearlyData(self.dayData.year, self.dayData.month, self.dayData.day, false)
  if dayData:IsExpired() then
    MsgManager.ShowMsgByID(34002)
    return
  end
  if not dayData then
    MsgManager.ShowMsgByID(34000)
    return
  end
  self.dayData = dayData
  self:RefreshUI()
  self:SelectFirst()
end
function ServantActivityInfoView:GetSelectDotCell()
  local cells = self.dotCtl:GetCells()
  if cells then
    local cell
    for i = 1, #cells do
      cell = cells[i]
      if cell:GetChoose() then
        return cell
      end
    end
  end
  return nil
end
