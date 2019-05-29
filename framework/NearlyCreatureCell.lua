local BaseCell = autoImport("BaseCell")
NearlyCreatureCell = class("NearlyCreatureCell", BaseCell)
local pos1, pos2 = LuaVector3(-80, 0, 0), LuaVector3(-64, 0, 0)
function NearlyCreatureCell:Init()
  self.playerProGO = self:FindGO("ProSymbol")
  self.playerPro = self.playerProGO:GetComponent(UISprite)
  self.playerGenderGO = self:FindGO("Gender")
  self.playerGender = self.playerGenderGO:GetComponent(UISprite)
  self.nameGO = self:FindGO("Name")
  self.name = self.nameGO:GetComponent(UILabel)
  self.symbolGO = self:FindGO("Symbol")
  self.symbol = self.symbolGO:GetComponent(UISprite)
  self.mapIndex = self:FindComponent("Map_Index", UILabel)
  self:AddCellClickEvent()
end
function NearlyCreatureCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.id = data.id
  self.gameObject:SetActive(true)
  self.playerProGO:SetActive(false)
  self.playerGenderGO:SetActive(false)
  self.mapIndex.text = ""
  self.symbol.spriteName = ""
  self.isExitPoint = data:GetParama("isExitPoint")
  if self.isExitPoint then
    self.pos = data.pos:Clone()
    local nextSceneID = data:GetParama("nextSceneID")
    if Table_Map[nextSceneID] == nil then
      self.gameObject:SetActive(false)
      return
    end
    self.name.text = Table_Map[nextSceneID].NameZh
    IconManager:SetMapIcon("map_raid", self.symbol)
    local index = data:GetParama("index")
    self.mapIndex.text = string.char(64 + index)
    self.nameGO.transform.localPosition = pos2
    return
  end
  self.nameGO.transform.localPosition = pos1
  self.creatureType = data:GetParama("creatureType")
  local name = data:GetParama("name")
  if self.creatureType == Creature_Type.Npc then
    local symbol = data:GetParama("Symbol")
    local config = symbol and QuestSymbolConfig[symbol]
    local questSymbol = config and config.UISpriteName
    if questSymbol then
      local isSuc = IconManager:SetMapIcon(questSymbol, self.symbol)
      if questSymbol == "map_icon_talk" then
        self.symbol.width = 20
        self.symbol.height = 18
      else
        self.symbol.width = 11
        self.symbol.height = 27
      end
    else
      local icon = data:GetParama("icon")
      IconManager:SetMapIcon(icon, self.symbol)
      self.symbol.width = 25
      self.symbol.height = 25
    end
    local posTip = data:GetParama("PositionTip")
    if posTip ~= "" then
      self.name.text = string.format(ZhString.NearlyCreatureCell_NameTip, posTip, name)
    else
      self.name.text = name
    end
    UIUtil.WrapLabel(self.name)
    self.pos = data.pos:Clone()
    self.npcid = data:GetParama("npcid")
    self.uniqueid = data:GetParama("uniqueid")
  elseif self.creatureType == Creature_Type.Player then
    self.playerProGO:SetActive(true)
    self.playerGenderGO:SetActive(true)
    self.name.text = string.format("[4DDEFFFF]%s[-] %s", "Lv." .. data:GetParama("level"), data:GetParama("name"))
    local playerPro = data:GetParama("Profession")
    if playerPro and Table_Class[playerPro] then
      IconManager:SetProfessionIcon(Table_Class[playerPro].icon, self.playerPro)
    end
    local gender = data:GetParama("gender")
    self.playerGender.spriteName = gender == 1 and "friend_icon_man" or "friend_icon_woman"
  else
    self.gameObject:SetActive(false)
  end
end
