autoImport("PlayerFaceCell")
local BaseCell = autoImport("BaseCell")
TMInfoCell = class("TMInfoCell", BaseCell)
function TMInfoCell:Init()
  TMInfoCell.super.Init(self)
  local teamHead = self:FindGO("TeamHead")
  self.teamHead = PlayerFaceCell.new(teamHead)
  self.teamHead:AddIconEvent()
  self.teamHead:SetMinDepth(40)
  self.teamHead:SetHeadIconPos(false)
  self.headData = HeadImageData.new()
  self.emptyButton = self:FindGO("EmptyButton")
  self.emptyButton_None = self:FindGO("None", self.emptyButton)
  self.emptyButton_SearchingTeam = self:FindGO("SearchingTeam", self.emptyButton)
  self.emptyButton_InviteMember = self:FindGO("InviteMember", self.emptyButton)
  self.zoneInfo = self:FindGO("ZoneInfo")
  self.zoneId = self:FindComponent("ZoneId", UILabel)
  self.restTip = self:FindGO("RestTip")
  self.restTime = self:FindComponent("RestTime", UILabel)
  self:AddCellClickEvent()
end
function TMInfoCell:SetData(data)
  self.data = data
  if data == MyselfTeamData.EMPTY_STATE then
    self.teamHead:SetData(nil)
    self.emptyButton:SetActive(true)
    self:UpdateEmptyState()
    self:SetZoneId()
    self:RemoveRestTimeTick()
  elseif data ~= nil then
    self.id = self.data.id
    self.headData:Reset()
    self.headData:TransByTeamMemberData(data)
    self.teamHead:SetData(self.headData)
    self:UpdateFollow()
    self:UpdateImageCreator()
    self:SetZoneId(data.zoneid, data:IsOffline(), data.gender)
    self.teamHead.level.text = data.baselv
    UIUtil.WrapLabel(self.teamHead.name)
    self.emptyButton:SetActive(false)
    self:UpdateRestTip()
  else
    self.teamHead:SetData(nil)
  end
end
function TMInfoCell:UpdateEmptyState()
  if not TeamProxy.Instance:IHaveTeam() then
    self.emptyButton_InviteMember:SetActive(false)
    local isEntering = TeamProxy.Instance:IsQuickEntering()
    self.emptyButton_SearchingTeam:SetActive(isEntering)
    self.emptyButton_None:SetActive(not isEntering)
  else
    self.emptyButton_InviteMember:SetActive(true)
    self.emptyButton_SearchingTeam:SetActive(false)
    self.emptyButton_None:SetActive(false)
  end
end
function TMInfoCell:UpdateFollow()
  local data = self.data
  if data and data ~= MyselfTeamData.EMPTY_STATE then
    local followid = Game.Myself:Client_GetFollowLeaderID()
    local handFollowerId = Game.Myself:Client_GetHandInHandFollower()
    local isHanding = Game.Myself:Client_IsFollowHandInHand()
    local handTargetId = isHanding and followid or handFollowerId
    if handTargetId == data.id then
      self.teamHead.symbols:Active(PlayerFaceCell_SymbolType.Follow, true)
      self.teamHead.symbols:SetSprite(PlayerFaceCell_SymbolType.Follow, "icon_hands")
    elseif followid == data.id then
      self.teamHead.symbols:Active(PlayerFaceCell_SymbolType.Follow, true)
      self.teamHead.symbols:SetSprite(PlayerFaceCell_SymbolType.Follow, "main_icon_2")
    else
      self.teamHead.symbols:Active(PlayerFaceCell_SymbolType.Follow, false)
    end
  else
    self.teamHead.symbols:Active(PlayerFaceCell_SymbolType.Follow, false)
  end
end
function TMInfoCell:UpdateImageCreator()
  if type(self.data) == "table" then
    local imageUserId = TeamProxy.Instance:GetItemImageUser()
    self.teamHead.symbols:Active(PlayerFaceCell_SymbolType.ImageCreate, self.data.id == imageUserId)
  else
    self.teamHead.symbols:Active(PlayerFaceCell_SymbolType.ImageCreate, false)
  end
end
function TMInfoCell:SetZoneId(zoneId, offline, gender)
  if not offline and zoneId and zoneId ~= 0 then
    self.zoneInfo:SetActive(zoneId ~= MyselfProxy.Instance:GetZoneId())
    self.zoneId.text = ChangeZoneProxy.Instance:ZoneNumToString(zoneId)
  else
    self.zoneInfo:SetActive(false)
  end
end
function TMInfoCell:UpdateHp(value)
  self.teamHead:UpdateHp(value)
end
function TMInfoCell:UpdateMp(value)
  self.teamHead:UpdateMp(value)
end
function TMInfoCell:UpdateRestTip()
  if type(self.data) ~= "table" then
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    return
  end
  local expiretime = self.data.expiretime
  local curtime = ServerTime.CurServerTime() / 1000
  if expiretime ~= 0 and expiretime <= curtime then
    self.teamHead:SetIconActive(false)
    self.restTip:SetActive(true)
    self.restTime.text = ZhString.TeamInviteMembCell_ExpireTime
    self.teamHead.name.gameObject:SetActive(false)
  else
    local resttime = self.data.resttime
    resttime = resttime or 0
    local restSec = resttime - curtime
    if restSec > 0 then
      self.restTip:SetActive(true)
      if not self.restTimeTick then
        self.restTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRestTime, self)
      end
      self.teamHead:SetIconActive(false)
      self.teamHead.name.gameObject:SetActive(false)
    else
      self.restTip:SetActive(false)
      self:RemoveRestTimeTick()
    end
  end
end
function TMInfoCell:UpdateRestTime()
  if type(self.data) ~= "table" then
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    return
  end
  local resttime = self.data and self.data.resttime
  resttime = resttime or 0
  local restSec = resttime - ServerTime.CurServerTime() / 1000
  if restSec > 0 then
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(restSec)
    self.restTime.text = string.format(ZhString.TMInfoCell_RestTip, min, sec)
  else
    self:RemoveRestTimeTick()
  end
end
function TMInfoCell:RemoveRestTimeTick()
  if self.restTimeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.restTimeTick = nil
    self.restTime.text = ""
  end
  if self.headData and self.headData.offline ~= true then
    self.teamHead:SetIconActive(true, true)
  else
    self.teamHead:SetIconActive(false, false)
  end
  self.teamHead.name.gameObject:SetActive(true)
end
function TMInfoCell:UpdateMemberPos()
end
function TMInfoCell:OnRemove()
  self.teamHead:RemoveIconEvent()
  self:RemoveRestTimeTick()
end
