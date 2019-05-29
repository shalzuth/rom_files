TeamPwsRankCell = class("TeamPwsRankCell", BaseCell)
function TeamPwsRankCell:Init()
  self:FindObjs()
  self:AddClickEvent(self.headIcon.gameObject, function()
    self:ClickHead()
  end)
end
function TeamPwsRankCell:FindObjs()
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self:FindGO("headContainer"))
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(1)
  self.headIcon:SetMinDepth(1)
  self.objDefaultHead = self:FindGO("DefaultHead")
  self.headData = HeadImageData.new()
  self.objProfession = self:FindGO("profession")
  self.sprProfession = self:FindComponent("Icon", UISprite, self.objProfession)
  self.sprProfessionBG = self:FindComponent("Color", UISprite, self.objProfession)
  self.labName = self:FindComponent("labName", UILabel)
  self.labRank = self:FindComponent("labRank", UILabel)
  self.sprRankBG = self:FindComponent("sprRankBG", UISprite)
  self.sprLevel = self:FindComponent("sprLevel", UISprite)
  self.labScore = self:FindComponent("labScore", UILabel)
end
function TeamPwsRankCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  local proData = Table_Class[data.profession]
  self.objProfession:SetActive(proData and IconManager:SetProfessionIcon(proData.icon, self.sprProfession) or false)
  if proData then
    self.sprProfessionBG.color = ColorUtil[string.format("CareerIconBg%s", proData.Type)] or ColorUtil.CareerIconBg0
  end
  self.headData:Reset()
  self.headData:TransByTeamPwsRankData(data)
  if self.headData.iconData then
    self.headIcon.gameObject:SetActive(true)
    self.objDefaultHead:SetActive(false)
    if self.headData.iconData.type == HeadImageIconType.Avatar then
      self.headIcon:SetData(self.headData.iconData)
    elseif self.headData.iconData.type == HeadImageIconType.Simple then
      self.headIcon:SetSimpleIcon(self.headData.iconData.icon, self.headData.iconData.frameType)
    end
  else
    self.headIcon.gameObject:SetActive(false)
    self.objDefaultHead:SetActive(true)
  end
  self.labRank.text = data.rank
  if data.rank < 4 then
    self.sprRankBG.gameObject:SetActive(true)
    self.labRank.color = LuaColor.white
    IconManager:SetUIIcon(string.format("Adventure_icon_%s", data.rank), self.sprRankBG)
  else
    self.sprRankBG.gameObject:SetActive(false)
    self.labRank.color = LuaColor.black
  end
  self.labName.text = data.name
  self.sprLevel.gameObject:SetActive(data.erank ~= MatchCCmd_pb.ETEAMPWSRANK_NONE)
  if data.erank ~= MatchCCmd_pb.ETEAMPWSRANK_NONE then
    IconManager:SetUIIcon(string.format("ui_teampvp_lv%s", data.erank), self.sprLevel)
  end
  self.labScore.text = data.score
end
function TeamPwsRankCell:ClickHead()
  self:PassEvent(MouseEvent.MouseClick, self)
end
