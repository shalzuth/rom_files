HitBoliView = class("HitBoliView", ContainerView)
HitBoliView.ViewType = UIViewType.NormalLayer
local BoliConfig = GameConfig.BeatPoriActivity
local ruleTip = Table_Help[BoliConfig.msg].Desc
local showingCd = BoliConfig.starting_countdown
local boliHP = BoliConfig.boli_hp
local beattime = BoliConfig.beating_time
local fadeInterval = BoliConfig.fadeInterval
local spriteName = "vr_txt_%s"
function HitBoliView:Init()
  self:FindObj()
  self:AddEvt()
  self:AddCloseButtonEvent()
  self.hitCount = 0
  self.effectFade = false
  self:ShowIntro()
end
function HitBoliView:FindObj()
  self.title = self:FindGO("title"):GetComponent(UITexture)
  self.tipContainer = self:FindGO("tip")
  self.tip = self:FindGO("TipLabel"):GetComponent(UIRichLabel)
  self.spritelabel = SpriteLabel.new(self.tip)
  self.spritelabel:SetText(ruleTip)
  self.timer = self:FindGO("timer"):GetComponent(UISprite)
  self.boliContainer = self:FindGO("BoliContainer")
  self.startBtn = self:FindGO("startBtn")
  self.tweenPosition = self.boliContainer:GetComponent(TweenPosition)
  self.tweenPosition:ResetToBeginning()
  self.tweenPosition:SetOnFinished(function()
    self:StartCountHit()
  end)
  self.healthbar = self:FindGO("healthbar"):GetComponent(UIProgressBar)
  self.healthbar.value = 1
  self.timebar = self:FindGO("timebar"):GetComponent(UILabel)
  self.hitlable = self:FindGO("hitlable"):GetComponent(UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self.tweenAlpha = self.effectContainer:GetComponent(TweenAlpha)
  self.tweenAlpha:ResetToBeginning()
  self.effectContainer:SetActive(false)
  self.timertext = self:FindGO("Texture", self.timer.gameObject):GetComponent(UITexture)
  PictureManager.Instance:SetUI("party_bg_TXT", self.title)
  PictureManager.Instance:SetUI("party_bg_time", self.timertext)
end
function HitBoliView:CreateBoli()
  self.data = {}
  self.data.name = "test boli"
  self.data.npcID = 56103
  self.data.id = ServerTime.CurServerTime()
  self.data.pos = {
    x = self.boliContainer.transform.localPosition.x,
    y = self.boliContainer.transform.localPosition.y,
    z = self.boliContainer.transform.localPosition.z
  }
  self.data.datas = {}
  self.data.attrs = {}
  self.data.mounts = {}
  local staticData = Table_Monster[56103]
  self.data.staticData = staticData
  self.data.searchrange = 0
  self.boliControl = NSceneNpcProxy.Instance:Add(self.data, NNpc)
  self.boliControl:SetForceUpdate(true)
end
function HitBoliView:ShowIntro()
  self.healthbar.gameObject:SetActive(false)
  self.timebar.gameObject:SetActive(false)
  self.title.gameObject:SetActive(true)
  self.startBtn:SetActive(true)
  self.timer.gameObject:SetActive(false)
  self.hitlable.gameObject:SetActive(false)
end
function HitBoliView:ShowBoli()
  self.boliControl:SetParent(self.boliContainer.transform)
  self.boliControl:Server_SetScaleCmd(400, true)
  self.boliControl:Client_PlayAction("wait")
  self.tweenPosition:PlayForward()
  self.healthbar.gameObject:SetActive(true)
  self.timebar.gameObject:SetActive(true)
  self.hitlable.gameObject:SetActive(false)
end
function HitBoliView:AddEvt()
  self:AddListenEvt(ServiceEvent.NUserBeatPoriUserCmd, self.RecvStartCmd)
  self:AddClickEvent(self.startBtn, function()
    self:SendStartCmd()
  end)
  self:AddClickEvent(self.boliContainer, function()
    if self.boliControl then
      if not self.isStart then
        return
      end
      self.hitCount = self.hitCount + 1
      if self.hitCount == boliHP then
        ServiceNUserProxy.Instance:CallBeatPoriUserCmd(false, true)
        self.healthbar.value = 0
        local params = Asset_Role.GetPlayActionParams(Asset_Role.ActionName.Die)
        self.boliControl:Logic_PlayAction(params)
        self.boliControl:SetDelayRemove(1)
        self.hitlable.gameObject:SetActive(false)
        if self.hittimeTick then
          TimeTickManager.Me():ClearTick(self, 13)
          self.hittimeTick = nil
        end
        self.timebar.gameObject:SetActive(false)
        self.effectContainer:SetActive(true)
        self.toClosetime = ServerTime.CurServerTime()
        if not self.closeTimetick then
          self.closeTimetick = TimeTickManager.Me():CreateTick(0, 1000, self.ToCloseSelf, self, 15)
        end
      elseif self.hitCount < boliHP then
        self.boliControl.ai:PushCommand(FactoryAICMD.GetHitCmd(false, "hit", 0), self)
        self.hitlable.text = tostring(self.hitCount)
        self.healthbar.value = 1 - self.hitCount / boliHP
        self.hitlable.gameObject:SetActive(true)
      end
    end
  end)
  self:AddClickEvent(self.gameObject, function()
    if not self.effectFade then
      self.effectFade = true
    end
  end)
end
function HitBoliView:StartActivity()
  self.startBtn:SetActive(false)
  self.title.gameObject:SetActive(false)
  self.tipContainer:SetActive(false)
end
function HitBoliView:StartShowCountdown()
  self.time = showingCd
  self.timer.gameObject:SetActive(true)
  self:CountDown()
end
function HitBoliView:CountDown()
  if self.bolitimeTick == nil then
    self.bolitimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateShowBoliTick, self, 12)
  end
end
function HitBoliView:UpdateShowBoliTick()
  if self.time > 0 then
    self.timer.spriteName = string.format(spriteName, self.time)
    self.time = self.time - 1
  else
    self.timer.gameObject:SetActive(false)
    self.startBtn:SetActive(false)
    if self.bolitimeTick then
      TimeTickManager.Me():ClearTick(self, 12)
      self.bolitimeTick = nil
    end
    self:ShowBoli()
  end
end
function HitBoliView:SendStartCmd()
  ServiceNUserProxy.Instance:CallBeatPoriUserCmd(true)
end
function HitBoliView:RecvStartCmd(note)
  if note and note.body then
    self.isStart = note.body.start
    if self.isStart and note.body.success then
      self:StartActivity()
      self:StartShowCountdown()
      self:CreateBoli()
      return
    end
  end
  self:CloseSelf()
  return
end
function HitBoliView:StartCountHit()
  self.beginTime = ServerTime.CurServerTime()
  self:HitCounting()
end
function HitBoliView:HitCounting()
  if self.hittimeTick == nil then
    self.hittimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateTimetick, self, 13)
  end
end
function HitBoliView:UpdateTimetick()
  nowTime = ServerTime.CurServerTime()
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr((nowTime - self.beginTime) / 1000)
  local rest = beattime - sec
  if rest >= 0 then
    self.timebar.text = string.format("%ss", rest)
  else
    self.isStart = false
    self.timebar.text = "0s"
    if self.hitCount < boliHP then
      local params = Asset_Role.GetPlayActionParams("walk")
      self.boliControl:Logic_PlayAction(params)
      ServiceNUserProxy.Instance:CallBeatPoriUserCmd(false, false)
    end
    if self.hittimeTick then
      TimeTickManager.Me():ClearTick(self, 13)
      self.hittimeTick = nil
    end
    self.effectFade = true
  end
end
function HitBoliView:PlayExplode()
  local effect = self:PlayUIEffect(EffectMap.UI.BoliBoom, self.effectContainer, true)
  self.beginExplodeTime = ServerTime.CurServerTime()
  if not self.explodeTimetick then
    self.explodeTimetick = TimeTickManager.Me():CreateTick(0, 100, self.UpdateExplode, self, 14)
  end
end
function HitBoliView:UpdateExplode()
  nowTime = ServerTime.CurServerTime()
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr((nowTime - self.beginExplodeTime) / 1000)
  local rest = fadeInterval - sec
  if rest >= 0 then
    if self.effectFade then
      self.tweenAlpha:PlayForward()
      if self.explodeTimetick then
        TimeTickManager.Me():ClearTick(self, 14)
        self.explodeTimetick = nil
      end
    end
  else
    self.tweenAlpha:PlayForward()
    if self.explodeTimetick then
      TimeTickManager.Me():ClearTick(self, 14)
      self.explodeTimetick = nil
    end
  end
end
function HitBoliView:ToCloseSelf()
  nowTime = ServerTime.CurServerTime()
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr((nowTime - self.toClosetime) / 1000)
  if sec > 1 then
    self:CloseSelf()
  end
end
function HitBoliView:CloseSelf()
  if self.data and self.data.id then
    NSceneNpcProxy.Instance:Remove(self.data.id)
  end
  if self.bolitimeTick then
    TimeTickManager.Me():ClearTick(self, 12)
    self.bolitimeTick = nil
  end
  if self.hittimeTick then
    TimeTickManager.Me():ClearTick(self, 13)
    self.hittimeTick = nil
  end
  if self.explodeTimetick then
    TimeTickManager.Me():ClearTick(self, 14)
    self.explodeTimetick = nil
  end
  if self.closeTimetick then
    TimeTickManager.Me():ClearTick(self, 15)
    self.closeTimetick = nil
  end
  self.super.CloseSelf(self)
end
