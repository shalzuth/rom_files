WaitEnterBord = class("WaitEnterBord", CoreView)
local EFFECT_PATH = "WaitEnter"
function WaitEnterBord:ctor(parent)
  self.gameObject = self:LoadPreferb("part/WaitEnterBord", parent, true)
  self.effectBg = self:FindComponent("EffectContainer", ChangeRqByTex)
  self.effect = self:PlayUIEffect(EFFECT_PATH, self.effectBg)
  self.effectBg.excute = false
  self:Active(false)
  self.Label = self:FindGO("Label"):GetComponent(UILabel)
  self.dotIndex = 1
  if self.timer == nil then
    self.timer = TimeTickManager.Me():CreateTick(0, 1000, self.OnTick, self, 1)
  end
  self.timer:StartTick()
end
function WaitEnterBord:OnTick()
  local dot = {
    "\227\128\130",
    "\227\128\130\227\128\130",
    "\227\128\130\227\128\130\227\128\130"
  }
  local dotStr = dot[self.dotIndex]
  local basicStr = "\228\184\150\231\149\140\227\130\146\231\175\137\227\129\143"
  self.dotIndex = self.dotIndex + 1
  if self.dotIndex > 3 then
    self.dotIndex = 1
  end
  self.Label.text = basicStr .. dotStr
end
function WaitEnterBord:OnDestroy()
  if self.timer ~= nil then
    self.timer:StopTick()
    self.timer = nil
  end
  self.effect:Destroy()
  self.effect = nil
end
function WaitEnterBord:Active(b)
  self.gameObject:SetActive(b)
end
