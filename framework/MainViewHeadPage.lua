MainViewHeadPage = class("MainViewHeadPage", SubView)
autoImport("PlayerFaceCell")
autoImport("TargetHeadCell")
autoImport("PetHeadCell")
autoImport("BeingHeadCell")
autoImport("GuildVoiceCell")
function MainViewHeadPage:Init()
  self:InitUI()
  self:MapInterestEvent()
  self:UpdateMyHead()
  self:UpdateMyHeadTeaminfo()
  self:RegistRedTip()
end
function MainViewHeadPage:InitUI()
  local headContainer = self:FindChild("MyHeadContainer")
  self.headCellObj = self:LoadPreferb("cell/PlayerHeadCell", headContainer)
  self.headCellObj.transform.localPosition = Vector3.zero
  self:AddOrRemoveGuideId(self.headCellObj, 101)
  self.myHeadCell = PlayerFaceCell.new(self.headCellObj)
  self.myHeadCell:SetMinDepth(40)
  self.myHeadCell:AddEventListener(MouseEvent.MouseClick, self.clickMyHead, self)
  self.myHeadData = HeadImageData.new()
  local targetsBord = self:FindGO("HeadGrid")
  if targetsBord ~= nil then
    GameObject.DestroyImmediate(targetsBord)
  end
  targetsBord = self:LoadPreferb("part/MainViewHeadTargets", self:FindGO("LeftTopFuncGrid"))
  self.headGrid = self:FindComponent("MainViewHeadTargets", UIGrid)
  local chooseTarget = self:FindChild("ChooseTargets")
  local targetCellObj = self:LoadPreferb("cell/TargetHeadCell", chooseTarget)
  self.targetHeadCell = TargetHeadCell.new(targetCellObj)
  self.targetHeadCell:SetMinDepth(40)
  self.targetHeadCell:AddEventListener(TargetHeadEvent.CancelChoose, self.CancelChooseTarget, self)
  self.targetHeadCell:AddEventListener(MouseEvent.MouseClick, self.clickTargetCell, self)
  self.targetHeadCell:SetData()
  self.playerTipStick = self:FindComponent("PlayerTipStick", UIWidget)
  self.petTipStick = self:FindComponent("PetTipStick", UIWidget)
  self.petHeadActive = self:FindGO("PetHeadActive")
  self.beingHeadActive = self:FindGO("BeingHeadActive")
  local petHeadObj = self:LoadPreferb("cell/PetHeadCell", self:FindGO("PetHeadContainer", targetsBord))
  self.petHeadCell = PetHeadCell.new(petHeadObj)
  self.petHeadCell:SetMinDepth(40)
  self.petHeadCell:AddEventListener(MouseEvent.MouseClick, self.clickPetHeadCell, self)
  self.beingContainer = self:FindGO("BeingHeadContainer", targetsBord)
  local headObj = self:LoadPreferb("cell/PetHeadCell", self.beingContainer)
  self.beingHeadCell = BeingHeadCell.new(headObj)
  self.beingHeadCell:SetMinDepth(40)
  self.beingHeadCell:AddEventListener(MouseEvent.MouseClick, self.clickBeingCell, self)
  self.servantContainer = self:FindGO("ServantHeadContainer", targetsBord)
  local headObj = self:LoadPreferb("cell/TargetHeadCell", self.servantContainer)
  self.servantHeadCell = TargetHeadCell.new(headObj)
  self.servantHeadCell:SetMinDepth(40)
  local cancelchooseImg = self:FindGO("CancelChoose", headObj)
  if nil ~= cancelchooseImg then
    self:Hide(cancelchooseImg)
  end
  self.servantHeadCell:AddEventListener(MouseEvent.MouseClick, self.ClickServantHeadCell, self)
  self.VoiceGrid = self:FindGO("VoiceGrid", targetsBord)
  if self.VoiceGrid then
    self.VoiceGrid.gameObject:SetActive(false)
    self.VoiceGridVoiceCell1 = self:FindGO("VoiceCell1", self.VoiceGrid)
    self.VoiceGridVoiceCell2 = self:FindGO("VoiceCell2", self.VoiceGrid)
    self.VoiceGridVoiceCell3 = self:FindGO("VoiceCell3", self.VoiceGrid)
    self.VoiceCell1 = GuildVoiceCell.new(self.VoiceGridVoiceCell1)
    self.VoiceCell2 = GuildVoiceCell.new(self.VoiceGridVoiceCell2)
    self.VoiceCell3 = GuildVoiceCell.new(self.VoiceGridVoiceCell3)
    self.VoiceGridVoiceCell1.gameObject:SetActive(false)
    self.VoiceGridVoiceCell2.gameObject:SetActive(false)
    self.VoiceGridVoiceCell3.gameObject:SetActive(false)
    self.VoiceCellTable = {}
    table.insert(self.VoiceCellTable, self.VoiceCell1)
    table.insert(self.VoiceCellTable, self.VoiceCell2)
    table.insert(self.VoiceCellTable, self.VoiceCell3)
  end
end
function MainViewHeadPage:RegistRedTip()
  local headSprite = self:FindComponent("Frame", UISprite, self.headCellObj)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ADD_POINT, headSprite, 42, {-9, -9})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEW_PROFESSION, headSprite, 42, {-9, -9})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PROFESSION_UP, headSprite, 42, {-9, -9})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MONSTER_IMG, headSprite, 42, {-9, -9})
end
function MainViewHeadPage:clickMyHead()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.Charactor
  })
end
function MainViewHeadPage:clickTargetCell(cellctl)
  if self.targetId then
    local creature = SceneCreatureProxy.FindCreature(self.targetId)
    if creature and creature:GetCreatureType() == Creature_Type.Player then
      local playerData = PlayerTipData.new()
      playerData:SetByCreature(creature)
      if not self.playerTipShow then
        self.playerTipShow = true
        local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.playerTipStick, NGUIUtil.AnchorSide.Right, {-20, 0})
        local tipData = {playerData = playerData}
        tipData.funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(self.targetId)
        table.insert(tipData.funckeys, "Double_Action")
        table.insert(tipData.funckeys, "Booth")
        playerTip:SetData(tipData)
        function playerTip.closecallback(go)
          self.playerTipShow = false
        end
      else
        FunctionPlayerTip.Me():CloseTip()
        self.playerTipShow = false
      end
    end
  end
end
function MainViewHeadPage:CancelChooseTarget()
  if not Game.AutoBattleManager.on then
    Game.Myself:Client_LockTarget(nil)
  end
end
function MainViewHeadPage:clickPetHeadCell()
  if self.petHeadCell.restTip.activeSelf then
    return
  end
  local myPetInfo = PetProxy.Instance:GetMyPetInfoData()
  if myPetInfo then
    if not self.petTipShow then
      local playerData = PlayerTipData.new()
      playerData:SetByPetInfoData(myPetInfo)
      FunctionPet.Me():ShowPetTip(playerData, function(go)
        self.petTipShow = false
      end, self.petTipStick, NGUIUtil.AnchorSide.Right, {-20, 9})
    else
      FunctionPlayerTip.Me():CloseTip()
      self.petTipShow = false
    end
  end
end
function MainViewHeadPage:clickBeingCell(cell)
  local data = cell.data
  if data == nil then
    return
  end
  local beingid = cell.data.beingid
  local beingInfo = PetProxy.Instance:GetMySummonBeingInfo(beingid)
  if beingInfo == nil then
    return
  end
  if not self.beingNpcShow then
    self.beingNpcShow = true
    local playerData = PlayerTipData.new()
    playerData:SetByBeingInfoData(beingInfo)
    local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.bgSp, NGUIUtil.AnchorSide.TopRight, {-20, 0})
    local tipData = {playerData = playerData}
    tipData.funckeys = {
      "Pet_CallBack",
      "Pet_ShowDetail",
      "Pet_AutoFight"
    }
    playerTip:SetData(tipData)
    function playerTip.closecallback(go)
      self.beingNpcShow = false
    end
    local s1 = string.format(ZhString.MainViewHeadPage_Name, beingInfo.name)
    local s2 = string.format(ZhString.MainViewHeadPage_Master, Game.Myself.data.name)
    playerTip:SetDesc(s1, s2, "")
  else
    FunctionPlayerTip.Me():CloseTip()
    self.beingNpcShow = false
  end
end
function MainViewHeadPage:ClickServantHeadCell(cell)
  if self.servantHeadImageData == nil then
    return
  end
  local servantCreature = NScenePetProxy.Instance:Find(self.servantHeadImageData.data_id)
  if servantCreature == nil then
    return
  end
  if not self.servantTipShow then
    self.servantTipShow = true
    local playerData = PlayerTipData.new()
    playerData:SetByCreature(servantCreature)
    playerData.headData = self.servantHeadImageData
    local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headBg, NGUIUtil.AnchorSide.TopRight, {-20, 0})
    local tipData = {
      playerData = playerData,
      funckeys = {
        "ServantShop",
        "ServantHandIn",
        "ServantReset"
      }
    }
    playerTip:SetData(tipData)
    function playerTip.closecallback(go)
      self.servantTipShow = false
    end
    local s1 = string.format(ZhString.MainViewHeadPage_Name, self.servantHeadImageData.name)
    local s2 = string.format(ZhString.MainViewHeadPage_Master, Game.Myself.data.name)
    playerTip:SetDesc(s1, s2, "")
  else
    FunctionPlayerTip.Me():CloseTip()
    self.servantTipShow = false
  end
end
function MainViewHeadPage:UpdateMyHead()
  self.myHeadData:Reset()
  self.myHeadData:TransformByCreature(Game.Myself)
  self.myHeadCell:SetData(self.myHeadData)
end
function MainViewHeadPage:UpdateMyHeadTeaminfo(note)
  if TeamProxy.Instance:IHaveTeam() then
    local imageUserId = TeamProxy.Instance:GetItemImageUser()
    self.myHeadCell.symbols:Active(PlayerFaceCell_SymbolType.ImageCreate, imageUserId == Game.Myself.data.id)
    local myMemberData = TeamProxy.Instance:GetMyTeamMemberData()
    self.myHeadCell:SetTeamLeaderSymbol(myMemberData and myMemberData.job)
  else
    self.myHeadCell.symbols:Active(PlayerFaceCell_SymbolType.ImageCreate, false)
    self.myHeadCell:SetTeamLeaderSymbol(false)
  end
end
function MainViewHeadPage:UpdateTargetHeadCell(creatureId)
  self.targetId = creatureId
  local creature = SceneCreatureProxy.FindCreature(creatureId)
  if not creature then
    self.targetHeadCell:ActiveCell(false)
    return
  end
  if creature.data and creature.data.IsCatchNpc_Detail and creature.data:IsCatchNpc_Detail() then
    self.targetHeadCell:ActiveCell(false)
    return
  end
  local headData = HeadImageData.new()
  headData:TransformByCreature(creature)
  if headData.hide then
    self.targetHeadCell:ActiveCell(false)
    return
  end
  self.targetHeadCell:ActiveCell(true)
  if creature:GetCreatureType() == Creature_Type.Npc then
    if creature.data:IsMonster() then
      local monsterData = creature.data.staticData
      if monsterData.Zone ~= "EndlessTower" then
        headData.level = creature.data.userdata:Get(UDEnum.ROLELEVEL) or monsterData.Level
      end
    end
    self.targetHeadCell:SetData(headData)
  elseif creature:GetCreatureType() == Creature_Type.Pet then
    self.targetHeadCell:ActiveCell(false)
  elseif creature:GetCreatureType() == Creature_Type.Player then
    self.targetHeadCell:SetData(headData)
    ServiceNUserProxy.Instance:CallQueryUserInfoUserCmd(creature.data.id)
  end
  self.headGrid:Reposition()
end
function MainViewHeadPage:UpdatePetHeadCell()
  local myPetInfo = PetProxy.Instance:GetMyPetInfoData()
  if myPetInfo == nil then
    self.petHeadCell:SetData(nil)
    return
  end
  self.petHeadCell:SetData(myPetInfo)
  self.headGrid:Reposition()
end
function MainViewHeadPage:UpdateBeingHeadCell()
  local myBeingInfo = PetProxy.Instance:GetMySummonBeingInfo()
  self.beingContainer:SetActive(myBeingInfo ~= nil)
  self.beingHeadCell:SetData(myBeingInfo)
  self.headGrid:Reposition()
end
function MainViewHeadPage:UpdateServantHeadCell(creature)
  if creature == nil then
    self.servantHeadCell:SetData(nil)
    self.servantHeadImageData = nil
    return
  end
  if self.servantHeadImageData == nil then
    self.servantHeadImageData = HeadImageData.new()
  end
  self.servantHeadImageData:TransByNpcData(creature.data.staticData)
  self.servantHeadImageData.data_id = creature.data.id
  self.servantHeadCell:SetData(self.servantHeadImageData)
end
function MainViewHeadPage:MapInterestEvent()
  self:AddListenEvt(CreatureEvent.Name_Change, self.HandleNameChange)
  self:AddListenEvt(MyselfEvent.TransformChange, self.UpdateMyHead)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateMyHead)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateMyHeadTeaminfo)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateMyHeadTeaminfo)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
  self:AddListenEvt(ServiceEvent.NUserQueryUserInfoUserCmd, self.HandleUpdatePlayerHead)
  self:AddListenEvt(MyselfEvent.BaseExpChange, self.HandleUpdateMyHpMp)
  self:AddListenEvt(MyselfEvent.MyPropChange, self.HandleUpdateMyHpMp)
  self:AddListenEvt(SceneCreatureEvent.PropHpChange, self.HandleUpdateMyHpMp)
  self:AddListenEvt(ServiceEvent.ScenePetPetInfoUpdatePetCmd, self.UpdatePetHeadCell)
  self:AddListenEvt(ServiceEvent.ScenePetPetInfoPetCmd, self.UpdatePetHeadCell)
  self:AddListenEvt(ServiceEvent.ScenePetPetOffPetCmd, self.UpdatePetHeadCell)
  self:AddListenEvt(ServiceEvent.SceneBeingBeingInfoQuery, self.UpdateBeingHeadCell)
  self:AddListenEvt(ServiceEvent.SceneBeingBeingInfoUpdate, self.UpdateBeingHeadCell)
  self:AddListenEvt(ServiceEvent.SceneBeingBeingOffCmd, self.UpdateBeingHeadCell)
  self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.HandlePoringFightBegin)
  self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.HandlePoringFightEnd)
  self:AddListenEvt(MyselfEvent.SelectTargetChange, self.HandleTargetChange)
  EventManager.Me():AddEventListener(MyselfEvent.Pet_HpChange, self.HandlePetHpChange, self)
  EventManager.Me():AddEventListener(SceneCreatureEvent.CreatureRemove, self.HandleCreatureRemove, self)
  EventManager.Me():AddEventListener(MyselfEvent.VoiceChange, self.VoiceChange, self)
  EventManager.Me():AddEventListener(GuildEvent.VoiceChange, self.GuildEventVoiceChange, self)
  self:AddListenEvt(SceneUserEvent.SceneAddPets, self.HandleAddPets)
  self:AddListenEvt(SceneUserEvent.SceneRemovePets, self.HandleRemovePets)
end
local ServantSID_Map
local Get_ServantSID_Map = function()
  if ServantSID_Map == nil then
    ServantSID_Map = {}
    local cfg = GameConfig.Servant.description
    for k, v in pairs(cfg) do
      ServantSID_Map[v.id] = 1
    end
  end
  return ServantSID_Map
end
function MainViewHeadPage:HandleAddPets(note)
  local npcs = note.body
  if not npcs then
    return
  end
  local myId = Game.Myself.data.id
  self.myServant = nil
  for _, npc in pairs(npcs) do
    if npc.data and npc.data.staticData and npc.data.ownerID == myId and Get_ServantSID_Map()[npc.data.staticData.id] then
      self.myServant = npc
      self:delayFocus()
      break
    end
  end
  if self.myServant == nil then
    return
  end
  self:UpdateServantHeadCell(self.myServant)
end
function MainViewHeadPage:HandleRemovePets(note)
  if self.servantHeadImageData == nil then
    return
  end
  local ids = note.body
  if not ids then
    return
  end
  for _, id in pairs(ids) do
    if id == self.servantHeadImageData.data_id then
      self.myServant = nil
      self:UpdateServantHeadCell(nil)
      break
    end
  end
end
function MainViewHeadPage:VoiceChange(note)
  if note then
    self.myHeadCell:UpdateVoice(note.showMic)
  else
    self.myHeadCell:UpdateVoice(nil)
  end
end
function MainViewHeadPage:GuildEventVoiceChange(note)
  if note == nil then
    self.VoiceGrid.gameObject:SetActive(false)
    return
  end
  if not self.VoiceGrid.gameObject.activeInHierarchy then
    self.VoiceGrid.gameObject:SetActive(true)
  end
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local memberData = myGuildData:GetMemberByGuid(tonumber(note.userId))
    if memberData then
      for k, v in pairs(self.VoiceCellTable) do
        if note.showMic == true then
          if v.bVoiceOpen == false then
            v:ShowMic(memberData.name, memberData.id)
            break
          else
          end
          if v.bVoiceOpen ~= true or v.id ~= memberData.id then
            elseif v.id == memberData.id then
              v:HideMicAndDisappear()
              break
            end
          end
      end
    end
  end
end
function MainViewHeadPage:HandlePoringFightBegin(note)
  self.petHeadActive:SetActive(false)
  self.beingHeadActive:SetActive(false)
end
function MainViewHeadPage:HandlePoringFightEnd(note)
  self.petHeadActive:SetActive(true)
  self.beingHeadActive:SetActive(true)
end
function MainViewHeadPage:HandleNameChange(note)
  local creature = note.body
  if creature and creature.data.id == Game.Myself.data.id then
    self:UpdateMyHead()
  end
end
function MainViewHeadPage:HandleMyDataChange(note)
  self:UpdateMyHead()
  if self.targetId then
    self.targetHeadCell:RefreshLevelColor()
  end
end
function MainViewHeadPage:HandleUpdatePlayerHead(note)
  local playerid = note.body.charid
  if playerid and self.targetId == playerid then
    local creature = SceneCreatureProxy.FindCreature(playerid)
    local headData = HeadImageData.new()
    headData:TransformByCreature(creature)
    self.targetHeadCell:SetData(headData)
  end
end
function MainViewHeadPage:HandleUpdateMyHpMp(note)
  local props = Game.Myself.data.props
  if props ~= nil then
    local hp = props.Hp:GetValue()
    local maxhp = props.MaxHp:GetValue()
    if self.myHeadCell ~= nil then
      local value = 0
      if hp ~= 0 or maxhp ~= 0 then
        value = hp / maxhp
      end
      self.myHeadCell:UpdateHp(value)
    end
    local mp = props.Sp:GetValue()
    local maxMp = props.MaxSp:GetValue()
    if self.myHeadCell ~= nil then
      local value = 0
      if mp ~= 0 or maxMp ~= 0 then
        value = mp / maxMp
      end
      self.myHeadCell:UpdateMp(value)
    end
  end
end
function MainViewHeadPage:HandlePetHpChange(creature)
  if creature == nil then
    return
  end
  local npet = PetProxy.Instance:GetMyPetInfoData()
  if npet and creature.data.id == npet.guid then
    self.petHeadCell:UpdateHp()
    return
  end
  local being = PetProxy.Instance:GetMySummonBeingInfo()
  if being and creature.data.id == being.guid then
    self.beingHeadCell:UpdateBeingHp()
  end
end
function MainViewHeadPage:HandleTargetChange(note)
  local nowId = note.body and note.body.data.id
  if self.targetId ~= nowId then
    self:UpdateTargetHeadCell(nowId)
  end
end
function MainViewHeadPage:RemoveLeanTween()
  if self.DelayFocusTwId then
    LeanTween.cancel(self.gameObject, self.DelayFocusTwId)
    self.DelayFocusTwId = nil
  end
end
function MainViewHeadPage:delayFocus(trans)
  self:RemoveLeanTween()
  local delayTime = nil == ServantRecommendProxy.Instance:GetModelShow(self.myServant.data.staticData.id) and 2 or 0.2
  local ret = LeanTween.delayedCall(self.gameObject, delayTime, function()
    self.DelayFocusTwId = nil
    self:ShowServantEffect()
  end)
  self.DelayFocusTwId = ret.uniqueId
end
function MainViewHeadPage:ShowServantEffect()
  if self.myServant then
    local servantPos = self.myServant.assetRole.completeTransform.localPosition
    local diffpos = LuaVector3(servantPos.x, servantPos.y + 0.5, servantPos.z)
    Asset_Effect.PlayOneShotAt(EffectMap.Maps.ServantShow, diffpos)
    self.myServant.assetRole:PlayAction_PlayShow()
    ServantRecommendProxy.Instance:SetServantModelShow(self.myServant.data.staticData.id)
  end
end
function MainViewHeadPage:HandleCreatureRemove(evt)
  if evt.data and self.targetId == evt.data then
    self:UpdateTargetHeadCell(nil)
  end
end
function MainViewHeadPage:OnEnter()
  MainViewHeadPage.super.OnEnter(self)
  self.myHeadCell:AddIconEvent()
  self:UpdatePetHeadCell()
  self:UpdateBeingHeadCell()
end
function MainViewHeadPage:OnExit()
  self.myHeadCell:RemoveIconEvent()
  self.myServant = nil
  self:RemoveLeanTween()
  MainViewHeadPage.super.OnExit(self)
end
