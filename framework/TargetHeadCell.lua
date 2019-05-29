autoImport("PlayerFaceCell")
TargetHeadCell = class("TargetHeadCell", PlayerFaceCell)
TargetHeadEvent = {
  CancelChoose = "TargetHeadEvent_CancelChoose"
}
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
function TargetHeadCell:Init()
  TargetHeadCell.super.Init(self)
  self.headIconCell:HideFrame()
  self.headBg = self:FindComponent("HeadBg", UISprite)
  self:SetData(nil)
  self:AddButtonEvent("CancelChoose", function(go)
    self:PassEvent(TargetHeadEvent.CancelChoose)
  end)
end
function TargetHeadCell:SetData(data)
  TargetHeadCell.super.SetData(self, data)
  if data then
    if data.isMonster then
      self:RefreshLevelColor()
    end
    if data.camp == RoleDefines_Camp.ENEMY then
      self.headBg.spriteName = "com_bg_head3"
    else
      self.headBg.spriteName = "com_bg_head2"
    end
    local boss = Table_Boss[data.id]
    if boss and boss.Type == 4 then
      self.headBg.spriteName = "com_bg_head4"
    end
  else
    self.headBg.spriteName = "com_bg_head2"
  end
  UIUtil.WrapLabel(self.name)
end
function TargetHeadCell:RefreshLevelColor()
  if self.data and self.data.level and self.level then
    local myself = Game.Myself
    local mylv = myself.data.userdata:Get(UDEnum.ROLELEVEL)
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
