autoImport("PlayerFaceCell")
MonsterFaceCell = class("PlayerFaceCell", PlayerFaceCell)
MonsterTextColorConfig = {
  Level = {H = 15, L = 20},
  Color = {
    H = Color(0.9882352941176471, 0.1607843137254902, 0.20392156862745098),
    N = Color(1, 1, 1),
    L = Color(1, 1, 1)
  },
  EffectColor = {
    H = Color(0.3686274509803922, 0 / 255, 0.03137254901960784),
    N = Color(0.4549019607843137, 0.6039215686274509, 0.7686274509803922),
    L = Color(0.4549019607843137, 0.6039215686274509, 0.7686274509803922)
  }
}
function MonsterFaceCell:Init()
  MonsterFaceCell.super.Init(self)
end
function MonsterFaceCell:SetData(data)
  self.data = data
  MonsterFaceCell.super.SetData(self, data)
  if not self.headIcon.gameObject.activeSelf then
    self.headIcon.gameObject:SetActive(true)
    IconManager:SetFaceIcon(Table_Monster[10001].Icon, self.headIcon)
  end
  self:RefreshLabelColor()
end
function MonsterFaceCell:RefreshLabelColor()
  if self.data.level then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    local deltalv = mylv - self.data.level
    if deltalv >= MonsterTextColorConfig.Level.L then
      self.level.color = MonsterTextColorConfig.Color.L
      self.level.effectColor = MonsterTextColorConfig.EffectColor.L
    elseif deltalv <= -1 * MonsterTextColorConfig.Level.H then
      self.level.color = MonsterTextColorConfig.Color.H
      self.level.effectColor = MonsterTextColorConfig.EffectColor.H
    else
      self.level.color = MonsterTextColorConfig.Color.N
      self.level.effectColor = MonsterTextColorConfig.EffectColor.N
    end
  end
end
