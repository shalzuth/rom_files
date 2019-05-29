local BaseCell = autoImport("BaseCell")
ChangeCatCell = class("ChangeCatCell", BaseCell)
autoImport("PlayerFaceCell")
function ChangeCatCell:Init()
  self:InitCell()
end
function ChangeCatCell:InitCell()
  local portrait = self:FindGO("Portrait")
  self.faceCell = PlayerFaceCell.new(portrait)
  self.name = self:FindComponent("Name", UILabel)
  self.stateLab = self:FindComponent("StateLab", UILabel)
  self.stateLab.text = ZhString.TeamInviteMembCell_ExpireTime
  self.changeBtn = self:FindGO("ChangeBtn")
  self:AddClickEvent(self.changeBtn, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local changeLab = self:FindComponent("Label", UILabel, self.changeBtn)
  changeLab.text = ZhString.TeamInviteMembCell_ChangeCat
end
function ChangeCatCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    local sdata = Table_MercenaryCat[data.id]
    local npcData = Table_Npc[sdata.NPCID]
    if nil == npcData then
      redlog("NPC \232\161\168\230\156\170\233\133\141\228\189\163\229\133\181\231\140\171ID---> ", sdata.NPCID)
      return
    end
    self.name.text = npcData.NameZh
    local headImageData = HeadImageData.new()
    headImageData:TransByNpcData(npcData)
    self.faceCell:SetData(headImageData)
    self:UpdateRestTip()
  else
    self:Hide(self.gameObject)
  end
end
function ChangeCatCell:UpdateRestTip()
  local sdata = self.data
  local expiretime = sdata.expiretime
  local curtime = ServerTime.CurServerTime() / 1000
  if expiretime ~= 0 and expiretime <= curtime then
    self:Show(self.stateLab)
    self.faceCell:SetIconActive(false)
  else
    self:Hide(self.stateLab)
  end
end
