CourageRankCell = class("CourageRankCell", BaseCell)
local color_TopNine = LuaColor(1, 1, 1, 1)
local color_Normal = LuaColor(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
function CourageRankCell:Init()
  self:FindObjs()
  self.isActive = true
end
function CourageRankCell:FindObjs()
  self.objLine = self:FindGO("objLine")
  self.objBGMyself = self:FindGO("BgMyself")
  local objRank = self:FindGO("labRank")
  local objRankBG = self:FindGO("sprRankBG", objRank)
  self.tabRank = {
    gameObject = objRank,
    label = objRank:GetComponent(UILabel),
    objBG = objRankBG,
    sprBG = objRankBG:GetComponent(UISprite)
  }
  self.labName = self:FindComponent("labName", UILabel)
  self.labLevel = self:FindComponent("labLevel", UILabel)
  self.labProfession = self:FindComponent("labProfession", UILabel)
  self.labCourage = self:FindComponent("labCourage", UILabel)
  self.labGuild = self:FindComponent("labGuild", UILabel)
end
function CourageRankCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if haveData ~= self.isActive then
    self.isActive = haveData
    self.gameObject:SetActive(self.isActive)
  end
  if not data then
    return
  end
  self.id = data.charid
  self.labName.text = data.name
  self.labLevel.text = data.level
  self.labCourage.text = data.score
  self.labGuild.text = data.guildname and data.guildname ~= "" and data.guildname or ZhString.PlayerTip_NoGuildTip
  if type(data.profession) == "number" then
    self.labProfession.text = Table_Class[data.profession].NameZh
  elseif type(data.profession) == "string" then
    for id, class in pairs(Table_Class) do
      if class.icon == data.profession then
        self.labProfession.text = class.NameZh
        break
      end
    end
  end
  self.tabRank.label.text = (data.rank > 999 or data.rank < 1) and "999+" or data.rank
  local isTopNine = data.rank < 10 and data.rank > 0
  self.tabRank.objBG:SetActive(isTopNine)
  if isTopNine then
    self.tabRank.label.color = color_TopNine
    self.tabRank.sprBG.spriteName = "Adventure_icon_" .. (data.rank < 4 and data.rank or "4-10")
  else
    self.tabRank.label.color = color_Normal
  end
end
function CourageRankCell:SetBGActive(isActive)
  self.objBGMyself:SetActive(isActive)
end
function CourageRankCell:SetLineActive(isActive)
  self.objLine:SetActive(isActive)
end
