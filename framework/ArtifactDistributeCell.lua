local BaseCell = autoImport("BaseCell")
ArtifactDistributeCell = class("ArtifactDistributeCell", BaseCell)
local btnPhase = {
  Retrieve = "com_btn_1",
  RetrieveLab = Color(0.14901960784313725, 0.24313725490196078, 0.5568627450980392),
  RetrievePhase = Color(0.3568627450980392, 0.5215686274509804, 0.796078431372549),
  RetrieveCancle = "com_btn_2",
  RetrieveCancleLab = Color(0.6196078431372549, 0.33725490196078434, 0 / 255),
  RetrieveCanclePhase = Color(0.5607843137254902, 0.5607843137254902, 0.5607843137254902),
  UnUsing = "com_btn_3",
  UnUsingLab = Color(0.1607843137254902, 0.4117647058823529, 0 / 255),
  UnUsingPhase = Color(0.5176470588235295, 0.796078431372549, 0.4666666666666667)
}
function ArtifactDistributeCell:Init()
  self:FindObj()
  self:AddEvts()
end
function ArtifactDistributeCell:FindObj()
  self.name = self:FindComponent("name", UILabel)
  self.phase = self:FindComponent("phase", UILabel)
  self.btn = self:FindComponent("btn", UISprite)
  self.btnName = self:FindComponent("btnLab", UILabel)
end
function ArtifactDistributeCell:AddEvts()
  self:AddButtonEvent("btn", function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function ArtifactDistributeCell:SetData(data)
  self.data = data
  if data then
    self.Phase = 0
    self.gameObject:SetActive(true)
    self:ClearTick()
    self.guid = data.guid
    local iconName = data.itemStaticData.Icon
    local guid = data.guid
    local id = data.itemID
    self.itemdata = ItemData.new(guid, id)
    local targetCellGO = self:FindGO("TargetCell")
    self.targetCell = BaseItemCell.new(targetCellGO)
    self.targetCell:SetData(self.itemdata)
    self.name.text = data.itemStaticData.NameZh
    local unUsing = data.ownerID == 0
    local retrieving = 0 == data.retrieveTime
    if unUsing then
      self.phase.text = ZhString.ArtifactMake_UnUsing
      self.btn.spriteName = btnPhase.UnUsing
      self.btnName.effectColor = btnPhase.UnUsingLab
      self.btnName.text = ZhString.ArtifactMake_Dist
      self.phase.color = btnPhase.UnUsingPhase
    elseif retrieving then
      self.phase.text = ZhString.ArtifactMake_Using
      self.btn.spriteName = btnPhase.Retrieve
      self.btnName.effectColor = btnPhase.RetrieveLab
      self.btnName.text = ZhString.ArtifactMake_Retrieve
      self.phase.color = btnPhase.RetrievePhase
    else
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._refreshTime, self)
      self.btn.spriteName = btnPhase.RetrieveCancle
      self.btnName.effectColor = btnPhase.RetrieveCancleLab
      self.btnName.text = ZhString.ArtifactMake_CancleRetrieve
      self.phase.color = btnPhase.RetrieveCanclePhase
    end
  else
    self.gameObject:SetActive(false)
  end
end
function ArtifactDistributeCell:_refreshTime()
  if self:ObjIsNil(self.gameObject) then
    self:ClearTick()
    return
  end
  local leftTime = self.data.retrieveTime - ServerTime.CurServerTime() / 1000
  leftTime = math.max(0, leftTime)
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  local lab = string.format("%02d:%02d:%02d", hour, min, sec)
  self.phase.text = string.format(ZhString.ArtifactMake_LeftTime, lab)
end
function ArtifactDistributeCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
  end
end
function ArtifactDistributeCell:OnDestroy()
  self:ClearTick()
end
