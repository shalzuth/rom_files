local BaseCell = autoImport("BaseCell")
TitleCell = class("TitleCell", BaseCell)
local choosen = "com_bg_money3"
local unChoosen = "com_bg_property"
local grayLabel = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255, 1)
local blackLabel = Color(0.17647058823529413, 0.17647058823529413, 0.17647058823529413, 1)
local usingLabel = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
local choosenLabelColor = "[1F74BF]"
local lockBtnSpriteName = "com_bg_13"
local unlockBtnSpriteName = "com_bg_2"
function TitleCell:Init()
  TitleCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end
function TitleCell:FindObjs()
  self.bgImg = self:FindComponent("bg", UISprite)
  self.titleName = self:FindComponent("title", UILabel)
  self.choosenBg = self:FindGO("chooseBg")
end
function TitleCell:ShowChooseImg(flag)
  self.bgImg.spriteName = flag and choosen or unChoosen
end
function TitleCell:SetData(data)
  if data.__cname == "TitleLevelGroupData" then
    self.data = data.activeTitleData
  else
    self.data = data
  end
  self.id = self.data.id
  self.unlocked = self.data.unlocked
  self.type = self.data.titleType
  local name = self.data.config.Name
  self.titleName.text = name
  self:SetUnlockState()
  self:UpdateChoose()
end
function TitleCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function TitleCell:UpdateChoose()
  if self.id and self.id == self.chooseId then
    self.choosenBg:SetActive(true)
  else
    self.choosenBg:SetActive(false)
  end
end
function TitleCell:SetUnlockState()
  local curID = Game.Myself.data:GetAchievementtitle()
  if curID == self.id and self.unlocked then
    self.titleName.color = usingLabel
  elseif self.unlocked then
    self.titleName.color = blackLabel
  else
    self.titleName.color = grayLabel
  end
end
