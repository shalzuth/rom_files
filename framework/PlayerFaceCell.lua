local BaseCell = autoImport("BaseCell")
PlayerFaceCell = class("PlayerFaceCell", BaseCell)
autoImport("HeadIconCell")
autoImport("FrameCell")
PlayerFaceCell_SymbolType = {
  JoinHand = "SymbolType_JoinHand",
  Follow = "SymbolType_Follow",
  ImageCreate = "SymbolType_ImageCreate"
}
function PlayerFaceCell:Init()
  self.profession = self:FindGO("profession")
  self.proIcon = self:FindComponent("Icon", UISprite, self.profession)
  self.proColor = self:FindComponent("Color", UISprite, self.profession)
  if self.proIcon then
    self.proIcon.transform.localPosition = Vector3(0, 4.5, 0)
  end
  if self.proColor then
    self.proColor.width = 32
    self.proColor.height = 32
    self.proColor.spriteName = "com_icon_profession"
    self.proColor.transform.localPosition = Vector3(0, 4.5, 0)
  end
  self.name = self:FindComponent("name", UILabel)
  self.level = self:FindComponent("level", UILabel)
  self.vip = self:FindComponent("vip", UILabel)
  self.hp = self:FindComponent("hp", UISlider)
  self.mp = self:FindComponent("mp", UISlider)
  self.levelBg = self:FindGO("bg_head")
  self.leadsymbol1 = self:FindGO("leadsymbol1")
  self.leadsymbol2 = self:FindGO("leadsymbol2")
  self.headIconCell = HeadIconCell.new()
  self.headIconCell:CreateSelf(self.gameObject)
  self.headIconCell:SetMinDepth(3)
  self:UpdateHeadIconPos()
  local frameObj = self:FindGO("PlayerFrameCell")
  if frameObj then
    self.frame = FrameCell.new(frameObj)
  end
  self.zoneid = self:FindComponent("Zone", UILabel)
  self:InitSymbols()
  self:AddCellClickEvent()
end
function PlayerFaceCell:InitSymbols()
  self.symbols = {}
  self.symbols.rePosition = self:FindComponent("SymbolsGrid", UIGrid)
  self.symbols[PlayerFaceCell_SymbolType.ImageCreate] = self:FindComponent("ImageCreateor", UISprite)
  self.symbols[PlayerFaceCell_SymbolType.Follow] = self:FindComponent("FollowState", UISprite)
  function self.symbols.RePosition(symbols)
    if symbols.rePosition then
      symbols.rePosition:Reposition()
    end
  end
  function self.symbols.SetSprite(symbols, symbolType, spriteName)
    if symbols[symbolType] then
      symbols[symbolType].spriteName = spriteName
    end
  end
  function self.symbols.Active(symbols, symbolType, b)
    if symbols[symbolType] then
      symbols[symbolType].gameObject:SetActive(b)
      symbols:RePosition()
    end
  end
end
function PlayerFaceCell:HideHpMp()
  self:Hide(self.hp)
  self:Hide(self.mp)
  self:UpdateHeadIconPos()
end
function PlayerFaceCell:UpdateHeadIconPos()
  if self.headIconCell then
    local isUp = self.hp and self.mp and self.hp.gameObject.activeSelf and self.mp.gameObject.activeSelf
    self:SetHeadIconPos(isUp)
  end
end
function PlayerFaceCell:SetHeadIconPos(isUp)
  local avatarPars = self.headIconCell.avatarPars
  if isUp then
    avatarPars.transform.localPosition = Vector3(0, -38, 0)
  else
    avatarPars.transform.localPosition = Vector3(0, -54, 0)
  end
end
function PlayerFaceCell:HideLevel()
  self:Hide(self.level.gameObject)
  self:Hide(self.levelBg)
end
function PlayerFaceCell:SetData(data)
  self.data = data
  if nil == data then
    self:Hide()
    return
  end
  self:Show()
  if self.name then
    self.name.text = data.name or ""
    UIUtil.WrapLabel(self.name)
  end
  if self.headIconCell and data.iconData then
    if data.iconData.type == HeadImageIconType.Avatar then
      self.headIconCell:SetData(data.iconData)
    elseif data.iconData.type == HeadImageIconType.Simple then
      self.headIconCell:SetSimpleIcon(data.iconData.icon, data.iconData.frameType)
    end
    self:SetIconActive(data.offline ~= true, true)
  end
  self:SetPlayerPro(data)
  if self.level then
    self.level.text = data.level and string.format("Lv.%s", data.level) or ""
  end
  if self.vip then
    self.vip.text = data.vip and string.format("Lv.%s", data.vip) or ""
  end
  local zone = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
  if self.zoneid then
    self.zoneid.gameObject:SetActive(zone ~= "" and data.zoneid ~= MyselfProxy.Instance:GetZoneId())
    self.zoneid.text = zone
  end
  self:SetTeamLeaderSymbol(data.job)
  self:UpdateHp(data.hp)
  self:UpdateMp(data.mp)
end
function PlayerFaceCell:SetPlayerPro(data)
  if self.profession then
    if data.isMonster then
      self.profession.gameObject:SetActive(false)
      return
    end
    if type(data.profession) == "number" then
      local proData = Table_Class[data.profession]
      if proData then
        if IconManager:SetProfessionIcon(proData.icon, self.proIcon) then
          self.profession.gameObject:SetActive(true)
          local colorKey = "CareerIconBg" .. proData.Type
          self.proColorSave = ColorUtil[colorKey]
          self.proColor.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
        else
          self.profession.gameObject:SetActive(false)
        end
      else
        errorLog(string.format("%d not Config", data.profession))
      end
    elseif type(data.profession) == "string" then
      if IconManager:SetProfessionIcon(data.profession, self.proIcon) or IconManager:SetUIIcon(data.profession, self.proIcon) then
        self.profession.gameObject:SetActive(true)
      else
        self.profession.gameObject:SetActive(false)
      end
    else
      self.profession.gameObject:SetActive(false)
    end
    self.proIcon.width = 32
    self:SetGoGrey(self.profession, data.offline)
  end
end
function PlayerFaceCell:SetIconActive(b, anim)
  self.headIconCell:SetActive(b, anim)
end
function PlayerFaceCell:SetGoGrey(go, isTo)
  if isTo then
    self:SetTextureGrey(go)
  else
    local sprites = UIUtil.GetAllComponentsInChildren(go, UISprite, true)
    for i = 1, #sprites do
      if sprites[i].color == Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941) then
        sprites[i].color = Color(1, 1, 1)
      end
    end
  end
end
function PlayerFaceCell:SetGoGreyMP()
  self:SetIconActive(false, true)
  self.profession = self:FindGO("profession")
  local sprites = UIUtil.GetAllComponentsInChildren(self.profession, UISprite, true)
  for i = 1, #sprites do
    sprites[i].color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
  end
end
function PlayerFaceCell:SetGoNormalMP()
  self:SetIconActive(true, true)
  self.profession = self:FindGO("profession")
  local sprites = UIUtil.GetAllComponentsInChildren(self.profession, UISprite, true)
  for i = 1, #sprites do
    sprites[i].color = Color(1, 1, 1)
  end
  if self.proColorSave ~= nil then
    self.proColor.color = self.proColorSave
  end
end
function PlayerFaceCell:SetTeamLeaderSymbol(jobType)
  if self.leadsymbol1 then
    self.leadsymbol1:SetActive(jobType == SessionTeam_pb.ETEAMJOB_LEADER)
  end
  if self.leadsymbol2 then
    self.leadsymbol2:SetActive(jobType == SessionTeam_pb.ETEAMJOB_TEMPLEADER)
  end
end
function PlayerFaceCell:UpdateHp(value)
  if self.hp ~= nil and value ~= nil then
    value = math.floor(value * 100) / 100
    self.hp.value = value
  end
end
function PlayerFaceCell:UpdateMp(value)
  if self.mp ~= nil and value ~= nil then
    value = math.floor(value * 100) / 100
    self.mp.value = value
  end
end
function PlayerFaceCell:UpdateVoice(value)
  if not self.headIconCell or self.VoiceBan == true then
  elseif value == true then
    self.headIconCell:SetVoiceState(HeadVoiceState.Open)
  else
    self.headIconCell:SetVoiceState(HeadVoiceState.Close)
  end
end
function PlayerFaceCell:SetVoiceBan(value)
  if self.headIconCell then
    if value == true then
      self.VoiceBan = true
      self.headIconCell:SetVoiceState(HeadVoiceState.Ban)
    else
      self.VoiceBan = false
    end
  end
end
function PlayerFaceCell:AddIconEvent()
  if self.headIconCell then
    self.headIconCell:OnAdd()
  end
end
function PlayerFaceCell:RemoveIconEvent()
  if self.headIconCell then
    self.headIconCell:OnRemove()
  end
end
function PlayerFaceCell:SetMinDepth(minDepth)
  self.headIconCell:SetMinDepth(minDepth)
end
function PlayerFaceCell:HideIcon()
  self.headIconCell:Hide(self.headIconCell.avatarPars)
  self.headIconCell:Hide(self.headIconCell.simpleIcon.gameObject)
end
function PlayerFaceCell:ActiveCell(b)
  self.gameObject:SetActive(b)
end
function PlayerFaceCell:ActiveSelf()
  return self.gameObject.activeSelf
end
