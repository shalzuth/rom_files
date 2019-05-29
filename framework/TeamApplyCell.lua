local BaseCell = autoImport("BaseCell")
TeamApplyCell = class("TeamApplyCell", BaseCell)
autoImport("PlayerFaceCell")
function TeamApplyCell:Init()
  local portrait = self:FindGO("HeadCell")
  self.portraitCell = PlayerFaceCell.new(portrait)
  self.portraitCell:AddEventListener(MouseEvent.MouseClick, function()
    if self.data then
      local ptdata = PlayerTipData.new()
      ptdata:SetByTeamMemberData(self.data)
      local tipData = {playerData = ptdata}
      local sp = portrait:GetComponent(UIWidget)
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(sp, NGUIUtil.AnchorSide.Right)
      playerTip:SetData(tipData)
      function playerTip.clickcallback(funcData)
        if funcData.key == "SendMessage" then
          self.eventType = "CloseUI"
          self:PassEvent(MouseEvent.MouseClick, self)
        end
      end
    end
  end, self)
  self.name = self:FindComponent("Name", UILabel)
  self.level = self:FindComponent("Level", UILabel)
  self.profession = self:FindComponent("Profession", UILabel)
  self:AddButtonEvent("AgreeButton", function(go)
    if Game.MapManager:IsPVPMode_TeamPws() then
      MsgManager.ShowMsgByIDTable(25930)
      return
    end
    local applyData = self.data
    if applyData then
      ServiceSessionTeamProxy.Instance:CallProcessTeamApply(SessionTeam_pb.ETEAMAPPLYTYPE_AGREE, applyData.id)
    end
  end)
  self.zoneid = self:FindComponent("Zone", UILabel)
  self.querytypeImg = self:FindComponent("querytype", UISprite)
end
function TeamApplyCell:SetData(data)
  self.data = data
  if data then
    self.name.text = data.name
    self.level.text = "Lv." .. data.baselv
    if Table_Class[data.profession] then
      self.profession.text = Table_Class[data.profession].NameZh
    end
    local headData = HeadImageData.new()
    headData:TransByTeamMemberData(data)
    self.portraitCell:SetData(headData)
    local zone = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
    self.zoneid.gameObject:SetActive(zone ~= "" and data.zoneid ~= MyselfProxy.Instance:GetZoneId())
    self.zoneid.text = zone
  end
end
local isOpen
function TeamApplyCell:SetOpenInfoFlag(data)
  if data.querytype then
    if data.querytype == SceneUser2_pb.EQUERYTYPE_ALL then
      isOpen = true
    elseif data.querytype == SceneUser2_pb.EQUERYTYPE_FRIEND then
      isOpen = FriendProxy.Instance:IsFriend(data.id)
    else
      isOpen = false
    end
  else
    isOpen = false
  end
  self.querytypeImg.spriteName = isOpen and "" or ""
end
