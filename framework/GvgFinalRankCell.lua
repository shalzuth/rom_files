local BaseCell = autoImport("BaseCell")
GvgFinalRankCell = class("GvgFinalRankCell", BaseCell)
function GvgFinalRankCell:Init()
  self:initView()
  self:initData()
end
function GvgFinalRankCell:initView()
  self.invalidCt = self:FindGO("invalidCt")
  self.rankNum = self:FindGO("rankNum", self.gameObject):GetComponent(UILabel)
  self.customPic = self:FindComponent("guildIcon", UITexture)
  self.headIcon = self:FindComponent("default", UISprite)
  self.progress = self:FindComponent("progress", UISlider)
  self.guildIconBack = self:FindComponent("guildIconBack", UISprite)
end
function GvgFinalRankCell:initData()
end
function GvgFinalRankCell:SetData(data)
  self.data = data
  if data.crystalData.rank then
    if data.crystalData.rank == 0 then
      self.rankNum.text = "-."
    else
      self.rankNum.text = data.crystalData.rank .. "."
    end
  end
  self.call_index = UnionLogo.CallerIndex.LogoEditor
  if not data then
    self:Show(self.invalidCt)
    self:Hide(self.progress.gameObject)
  else
    self:Hide(self.invalidCt)
    self:Show(self.progress.gameObject)
    self.progress.value = (data.crystalData.crystalnum or 0) / 5
    self.guildIconBack.spriteName = GvgFinalFightTip.GuildIndex[data.index].color
    self:getGuildIcon(data)
  end
  if data.crystalData.rank then
    self.gameObject.transform:SetSiblingIndex(data.crystalData.rank - 1)
  end
end
function GvgFinalRankCell:getGuildIcon(guildData)
  local guildInfo = SuperGvgProxy.Instance:GetGuildInfoByGuildId(guildData.guildid)
  if guildInfo == nil then
    return
  end
  local guildHeadData = GuildHeadData.new()
  guildHeadData:SetBy_InfoId(guildInfo.icon)
  guildHeadData:SetGuildId(guildInfo.guildid)
  self.index = guildHeadData.index
  if guildHeadData.type == GuildHeadData_Type.Config then
    local sdata = guildHeadData.staticData
    if sdata then
      self.headIcon.gameObject:SetActive(true)
      self.customPic.gameObject:SetActive(false)
      IconManager:SetGuildIcon(sdata.Icon, self.headIcon)
      self.headIcon.width = 32
      self.headIcon.height = 32
    end
  elseif guildHeadData.type == GuildHeadData_Type.Custom and self.customPic then
    self.headIcon.gameObject:SetActive(false)
    self.customPic.gameObject:SetActive(true)
    local pic = FunctionGuild.Me():GetCustomPicCache(guildHeadData.guildid, guildHeadData.index)
    if pic then
      local time_name = pic.name
      if tonumber(time_name) == guildHeadData.time then
        self.customPic.mainTexture = pic
      else
        self:LoadSetCustomPic(guildHeadData, self.customPic)
      end
    else
      self:LoadSetCustomPic(guildHeadData, self.customPic)
    end
  end
end
function GvgFinalRankCell:LoadSetCustomPic(data)
  if data == nil or data.type ~= GuildHeadData_Type.Custom then
    return
  end
  local success_callback = function(bytes, localTimestamp)
    local pic = Texture2D(128, 128, TextureFormat.RGB24, false)
    pic.name = data.time
    local bRet = ImageConversion.LoadImage(pic, bytes)
    FunctionGuild.Me():SetCustomPicCache(data.guildid, data.index, pic)
    if self.index == data.index and self.customPic then
      self.customPic.mainTexture = pic
    end
  end
  local pic_type = data.pic_type
  if pic_type == nil or pic_type == "" then
    pic_type = PhotoFileInfo.PictureFormat.JPG
  end
  UnionLogo.Ins():SetUnionID(data.guildid)
  UnionLogo.Ins():GetOriginImage(self.call_index, data.index, data.time, pic_type, nil, success_callback, error_callback, is_keep_previous_callback, is_through_personalphotocallback)
end
