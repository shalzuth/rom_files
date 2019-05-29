UIMapDeathKingdomCell = class("UIMapDeathKingdomCell", BaseCell)
UIMapDeathKingdomCell.E_State = {
  Activated = 0,
  Unactivated = 1,
  Disable = 2
}
function UIMapDeathKingdomCell:Init()
  self.labName = self:FindGO("Name"):GetComponent(UILabel)
  self.objBtnTransfer = self:FindGO("BtnTransfer")
  self.sprTransferBG = self:FindGO("BG", self.objBtnTransfer):GetComponent(UISprite)
  self.labTransferTitle = self:FindGO("Title", self.objBtnTransfer):GetComponent(UILabel)
  self.objLock = self:FindGO("objLock")
  self:AddClickEvent(self.objBtnTransfer, function(go)
    self:OnButtonTransferClick()
  end)
end
function UIMapDeathKingdomCell:SetData(data)
  self.data = data
  self.id = data.id
  self.curID = data.curID
  self.state = data.state
  local npcData = Table_Npc[self.id]
  if npcData then
    self.labName.text = npcData.NameZh
  end
  self.objLock:SetActive(self.state == UIMapDeathKingdomCell.E_State.Unactivated)
  if self.state ~= UIMapDeathKingdomCell.E_State.Activated then
    self:SetTextureGrey(self.sprTransferBG)
    self.labTransferTitle.applyGradient = false
    self.labTransferTitle.effectColor = Color.gray
  end
end
function UIMapDeathKingdomCell:OnButtonTransferClick()
  if self.state == UIMapDeathKingdomCell.E_State.Activated then
    ServiceNUserProxy.Instance:CallUseDeathTransferCmd(self.curID, self.id)
    self:Notify("UIMapMapList.CloseSelf", {})
  elseif self.state == UIMapDeathKingdomCell.E_State.Unactivated then
    MsgManager.ShowMsgByIDTable(25800)
  elseif self.state == UIMapDeathKingdomCell.E_State.Disable then
    MsgManager.ShowMsgByIDTable(25801)
  end
end
