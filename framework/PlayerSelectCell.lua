autoImport("PlayerFaceCell")
local BaseCell = autoImport("BaseCell")
PlayerSelectCell = class("PlayerSelectCell", BaseCell)
function PlayerSelectCell:Init()
  PlayerSelectCell.super.Init(self)
  self.teamHead = PlayerFaceCell.new(self:FindGO("PlayerHead"))
  self.teamHead:AddIconEvent()
  self.teamHead:SetMinDepth(40)
  self.teamHead:SetHeadIconPos(false)
  self.headData = HeadImageData.new()
  self:AddCellClickEvent()
end
function PlayerSelectCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  if self.id == data.data.id then
    local props = data.data.props
    if props then
      self:UpdateHp(props.Hp:GetValue() / props.MaxHp:GetValue())
      self:UpdateMp(props.Sp:GetValue() / props.MaxSp:GetValue())
    end
  else
    self.id = data.data.id
    self.headData:Reset()
    self.headData:TransByLPlayer(data)
    self.teamHead:SetData(self.headData)
    self.teamHead.level.text = data.data.userdata:Get(UDEnum.ROLELEVEL)
    UIUtil.WrapLabel(self.teamHead.name)
  end
end
function PlayerSelectCell:UpdateHp(value)
  self.teamHead:UpdateHp(value)
end
function PlayerSelectCell:UpdateMp(value)
  self.teamHead:UpdateMp(value)
end
function PlayerSelectCell:OnRemove()
  self.teamHead:RemoveIconEvent()
end
