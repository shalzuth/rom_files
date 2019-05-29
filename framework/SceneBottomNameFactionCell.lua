local BaseCell = autoImport("BaseCell")
autoImport("UnionLogo")
SceneBottomNameFactionCell = reusableClass("SceneBottomNameFactionCell", BaseCell)
SceneBottomNameFactionCell.resId = ResourcePathHelper.UICell("SceneBottomNameFactionCell")
SceneBottomNameFactionCell.npcColor = Color(1, 0.7725490196078432, 0.0784313725490196, 1)
SceneBottomNameFactionCell.playerOrMstColor = Color(0.984313725490196, 0.9450980392156862, 0.9098039215686274, 1)
SceneBottomNameFactionCell.playerEnemyColor = Color(1, 0, 0, 1)
SceneBottomNameFactionCell.OpitimizedMode = false
local tempVector3 = LuaVector3.zero
SceneBottomNameFactionCell.PoolSize = 50
function SceneBottomNameFactionCell:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end
function SceneBottomNameFactionCell:DoConstruct(asArray, args)
  self._alive = true
  local gameObject = args[1]
  local creature = args[2]
  self.gameObject = gameObject
  if creature:GetCreatureType() == Creature_Type.Me then
    tempVector3:Set(0, -19, 0)
  else
    tempVector3:Set(0, -10, 0)
  end
  self.gameObject.transform.localPosition = tempVector3
  self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
  tempVector3:Set(1, 1, 1)
  self.gameObject.transform.localScale = tempVector3
  self:initData(creature)
  self:initNameView()
  self:initFactionView()
  self:setNameFactionVisible(true)
  self:SetName(creature)
  self:SetFaction(creature)
end
function SceneBottomNameFactionCell:initData(creature)
  self.ismyselfPet = self.creatureType == Creature_Type.Pet and creature:IsMyPet()
end
function SceneBottomNameFactionCell:Finalize()
end
function SceneBottomNameFactionCell:Deconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    local parent = self.gameObject.transform.parent
    ReusableObject.Destroy(self.richName)
    if SceneBottomNameFactionCell.OpitimizedMode and not self:ObjIsNil(parent) then
      SetParent(self.gameObject, parent.parent)
      Game.GOLuaPoolManager:AddToSceneUIMovePool(SceneBottomNameFactionCell.resId, self.gameObject)
    else
      Game.GOLuaPoolManager:AddToSceneUIPool(SceneBottomNameFactionCell.resId, self.gameObject)
    end
  end
  self.gameObject = nil
  self._alive = false
end
function SceneBottomNameFactionCell:initFactionView()
  self.factionIconAnchor = self:FindGO("factionIconAnchor"):GetComponent(UIWidget)
  self.factionIcon = self:FindGO("factionIcon"):GetComponent(UISprite)
  self.factionIcon_ = self:FindGO("factionIcon_"):GetComponent(UITexture)
  self.factionName = self:FindGO("factionName"):GetComponent(UILabel)
  self.factionJob = self:FindGO("factionJob"):GetComponent(UILabel)
  self.factionInfo = self:FindGO("factionInfo")
  self.factionTable = self.factionInfo:GetComponent(UITable)
  self.factionAnchor = self.factionInfo:GetComponent(UIWidget)
end
function SceneBottomNameFactionCell:initNameView()
  self.uiname = self:FindGO("playerName"):GetComponent(UILabel)
  self.PcNameCt = self:FindGO("PcNameCt")
  self.SpBloodContainer = self:FindGO("SpBloodContainer")
  self.richName = SpriteLabel.new(self.uiname, 500, 26, 24)
  self.richName.richLabel.pivot = UIWidget.Pivot.Top
end
function SceneBottomNameFactionCell:SetName(creature)
  local creatureData = creature.data
  local name = creatureData:GetName()
  local camp = creatureData:GetCamp()
  self.richName:Reset()
  local creatureType = creature:GetCreatureType()
  local isNpc = creatureType == Creature_Type.Npc and camp ~= RoleDefines_Camp.ENEMY
  local isPlayerEnemy = creatureType == Creature_Type.Player and camp == RoleDefines_Camp.ENEMY
  local color = self.uiname.color
  if isNpc then
    if color ~= SceneBottomNameFactionCell.npcColor then
      self.uiname.color = SceneBottomNameFactionCell.npcColor
    end
  elseif isPlayerEnemy then
    if color ~= SceneBottomNameFactionCell.playerEnemyColor then
      self.uiname.color = SceneBottomNameFactionCell.playerEnemyColor
    end
  elseif color ~= SceneBottomNameFactionCell.playerOrMstColor then
    self.uiname.color = SceneBottomNameFactionCell.playerOrMstColor
  end
  local staticData = creatureData.staticData
  if staticData and staticData.Type == "WeaponPet" then
    local masterName = TeamProxy.Instance:GetCatMasterName(creatureData:GetGuid())
    if masterName then
      name = string.format(ZhString.SceneNameView_MasterName, name, masterName)
    end
  end
  if creatureData.GetAchievementtitle then
    local titleId = creatureData:GetAchievementtitle()
    local titleData = Table_Appellation[titleId]
    if titleData then
      if titleData.OrderType == 1 then
        name = name .. " [" .. titleData.Name .. "]"
      else
        name = "[" .. titleData.Name .. "] " .. name
      end
    end
  end
  name = simpleReplace(name)
  self.richName:SetText(name)
end
function SceneBottomNameFactionCell:SetQuestPrefixName(creature, isShow)
  self.richName:Reset()
  local name = creature.data:GetName()
  if isShow then
    name = string.format("{uiicon=%s}%s", "icon_39", name)
  end
  name = simpleReplace(name)
  self.richName:SetText(name)
end
function SceneBottomNameFactionCell:SetFaction(creature)
  local objNull = self:ObjIsNil(self.factionName)
  if objNull then
    return
  end
  local notHuSongPet = false
  local creatureType = creature:GetCreatureType()
  local ismyselfPet = creatureType == Creature_Type.Pet and creature:IsMyPet()
  local camp = creature.data:GetCamp()
  if ismyselfPet and self.detailedType ~= NpcData.NpcDetailedType.Escort then
    notHuSongPet = true
  end
  local npcOrMonstData = creature.data.staticData
  local guildjob = ""
  local guildname = ""
  local guildicon, customicon, picType
  local guildData = creature.data:GetGuildData()
  if guildData then
    guildjob = guildData.job
    guildicon = guildData.icon
    guildname = guildData.name
    if guildData.customIconIndex and guildData.customIconIndex ~= 0 then
      customicon = guildData.customIconIndex
      picType = guildData.picType
    end
  end
  if npcOrMonstData and npcOrMonstData.Guild ~= "" then
    self.factionName.text = npcOrMonstData.Guild
    self:Show(self.factionName.gameObject)
  elseif guildname and guildname ~= "" then
    self.factionName.text = guildname
    self:Show(self.factionName.gameObject)
  else
    self:Hide(self.factionName.gameObject)
  end
  if npcOrMonstData and npcOrMonstData.Position ~= "" then
    self.factionJob.text = npcOrMonstData.Position
    self:Show(self.factionJob.gameObject)
  elseif guildjob and guildjob ~= "" then
    self.factionJob.text = "[" .. "[c][FFC514FF]" .. OverSea.LangManager.Instance():GetLangByKey(guildjob) .. "[-][/c]" .. "]"
    self:Show(self.factionJob.gameObject)
  else
    self:Hide(self.factionJob.gameObject)
  end
  local showFc = npcOrMonstData and npcOrMonstData.GuildEmblem and npcOrMonstData.GuildEmblem ~= ""
  local lplayerFc = guildicon ~= nil
  if showFc or lplayerFc or customicon then
    self.factionAnchor.enabled = true
    if not npcOrMonstData or not npcOrMonstData.GuildEmblem then
      local guildEmblem
    end
    if not npcOrMonstData or not npcOrMonstData.AtlasOpt then
      local atlasOpt
    end
    if lplayerFc then
      self.factionIcon_.mainTexture = nil
      IconManager:SetGuildIcon(guildicon, self.factionIcon)
    elseif customicon ~= nil then
      self.factionIcon.spriteName = ""
      local texture = GuildPictureManager.Instance():GetThumbnailTexture(guildData.id, UnionLogo.CallerIndex.RoleFootDetail, customicon, guildData.customIconUpTime)
      if texture then
        self.factionIcon_.mainTexture = texture
      else
        self.factionIcon_.mainTexture = nil
        GuildPictureManager.Instance():AddMyThumbnailInfos({
          {
            callIndex = UnionLogo.CallerIndex.RoleFootDetail,
            guild = guildData.id,
            index = customicon,
            time = guildData.customIconUpTime,
            picType = picType
          }
        })
      end
    elseif atlasOpt and atlasOpt ~= "" and UIAtlasConfig.IconAtlas[atlasOpt] then
      self.factionIcon_.mainTexture = nil
      IconManager:SetIcon(guildEmblem, self.factionIcon, UIAtlasConfig.IconAtlas[atlasOpt])
    elseif guildEmblem then
      self.factionIcon_.mainTexture = nil
      IconManager:SetGuildIcon(guildEmblem, self.factionIcon)
    end
    self:Show(self.factionIcon.gameObject)
    self.factionAnchor:UpdateAnchors()
    self.factionIconAnchor:UpdateAnchors()
  else
    self.factionAnchor.enabled = false
    tempVector3:Set(LuaGameObject.GetLocalPosition(self.factionInfo.transform))
    tempVector3.x = -(self.factionJob.width + 2) / 2
    self.factionInfo.transform.localPosition = tempVector3
    self:Hide(self.factionIcon.gameObject)
    self.factionIcon_.mainTexture = nil
  end
  if ismyselfPet and not notHuSongPet then
    self.factionName.text = ZhString.PlayerBottomViewCell_Husong
    self.factionJob.text = ""
  end
  self:RefreshFactionLayout()
end
function SceneBottomNameFactionCell:setNameFactionVisible(visible)
  local objNull = self:ObjIsNil(self.uiname)
  if objNull then
    return
  end
  self.gameObject:SetActive(visible)
end
function SceneBottomNameFactionCell:updateNameVisible()
  local objNull = self:ObjIsNil(self.uiname)
  if objNull then
    return
  end
end
function SceneBottomNameFactionCell:RefreshFactionLayout()
  self.factionTable:Reposition()
end
function SceneBottomNameFactionCell:Alive()
  return self._alive
end
