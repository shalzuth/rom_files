SoundBoxView = class("SoundBoxView", ContainerView)
SoundBoxView.ViewType = UIViewType.NormalLayer
autoImport("SoundBoxCell")
function SoundBoxView:Init()
  self.npc = self.viewdata.npcInfo
  self:MapEvent()
  self:InitView()
end
function SoundBoxView:InitView()
  local slistgrid = self:FindComponent("SoundListGrid", UIGrid)
  self.soundList = UIGridListCtrl.new(slistgrid, SoundBoxCell, "SoundBoxCell")
  self.soundList:AddEventListener(MouseEvent.MouseClick, self.ClickSoundBox, self)
  self.noneTip = self:FindGO("NoneTip")
  local label = self:FindGO("Label", self.noneTip):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(label, 3, 288)
  self.chooseButton = self:FindGO("ChooseButton")
  self:AddClickEvent(self.chooseButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SoundItemChoosePopUp,
      viewdata = {
        npc = self.npc
      }
    })
  end)
  self.recordRot = self:FindComponent("CDRecord", TweenRotation)
  self.jukeboxRot = self:FindComponent("Jukebox", TweenRotation)
  local accentGO = self:FindGO("Accents")
  self.accents = UIUtil.GetAllComponentsInChildren(accentGO, TweenRotation)
end
function SoundBoxView:ClickSoundBox(cellCtl)
  local data = cellCtl.data
  if not self.isShowTip then
    local callback = function()
      self.isShowTip = false
    end
    local txt = data.staticData.MusicName
    local sp = cellCtl.gameObject:GetComponent(UIWidget)
    TipManager.Instance:ShowNormalTip(txt, sp, NGUIUtil.AnchorSide.DownRight, {0, 0}, callback, {
      sp.gameObject
    })
  end
end
function SoundBoxView:OnEnter()
  SoundBoxView.super.OnEnter(self)
  self:FocusOnNpc()
  ServiceNUserProxy.Instance:CallQueryMusicList(self.npc.data.id)
end
function SoundBoxView:OnExit()
  ServiceNUserProxy.Instance:CallCloseMusicFrame()
  SoundBoxView.super.OnExit(self)
  self:CameraReset()
end
function SoundBoxView:FocusOnNpc()
  if self.npc then
    local npcRootTrans = self.npc.assetRole.completeTransform
    if npcRootTrans then
      self:CameraFocusOnNpc(npcRootTrans)
    end
  end
end
function SoundBoxView:UpdateSoundList(serverlist)
  local itemlist = {}
  for i = 1, #serverlist do
    local data = serverlist[i]
    local temp = {}
    temp.guid = data.guid
    temp.musicid = data.musicid
    temp.playername = data.name
    temp.staticData = Table_MusicBox[temp.musicid]
    temp.starttime = data.starttime
    temp.index = i
    table.insert(itemlist, temp)
  end
  self.soundList:ResetDatas(itemlist)
  self.noneTip:SetActive(#itemlist == 0)
  self:PlayAnim(#itemlist > 0)
end
function SoundBoxView:PlayAnim(state)
  if state ~= self.cacheState then
    if state then
      self.jukeboxRot:PlayForward()
      self.jukeboxRot:SetOnFinished(function()
        self.recordRot.enabled = true
        for _, accent in pairs(self.accents) do
          accent.enabled = true
        end
      end)
    else
      self.jukeboxRot:PlayReverse()
      self.jukeboxRot:SetOnFinished(function()
        self.recordRot.enabled = false
        for _, accent in pairs(self.accents) do
          accent.enabled = false
        end
      end)
    end
  end
  self.cacheState = state
end
function SoundBoxView:MapEvent()
  self:AddListenEvt(ServiceEvent.NUserQueryMusicList, self.HandleUpdateSList)
end
function SoundBoxView:HandleUpdateSList(note)
  self:UpdateSoundList(note.body.items)
end
