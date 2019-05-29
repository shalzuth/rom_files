TeamPwsMemberCell = class("TeamPwsMemberCell", BaseCell)
function TeamPwsMemberCell:Init()
  self:FindObjs()
  self:AddClickEvent(self.headIcon.gameObject, function()
    self:ClickHead()
  end)
end
function TeamPwsMemberCell:FindObjs()
  self.objDefault = self:FindGO("Default")
  self.objContents = self:FindGO("Contents")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self:FindGO("headContainer"))
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(1)
  self.headIcon:SetMinDepth(30)
  self.objDefaultHead = self:FindGO("DefaultHead")
  self.headData = HeadImageData.new()
  self.objProfession = self:FindGO("profession")
  self.sprProfession = self:FindComponent("Icon", UISprite, self.objProfession)
  self.sprProfessionBG = self:FindComponent("Color", UISprite, self.objProfession)
  self.labName = self:FindComponent("labName", UILabel)
  self.sprLevel = self:FindComponent("sprLevel", UISprite)
  self.labScore = self:FindComponent("labScore", UILabel)
end
function TeamPwsMemberCell:SetData(data)
  self.charID = nil
  self.data = data
  self.gameObject:SetActive(data and true or false)
  if not data then
    return
  end
  local isEmpty = data == MyselfTeamData.EMPTY_STATE
  self.objDefault:SetActive(isEmpty)
  self.objContents:SetActive(not isEmpty)
  self.sprLevel.gameObject:SetActive(false)
  self.labScore.text = string.format(ZhString.TeamPws_Score, "-")
  local pos = self.labScore.transform.localPosition
  pos.x = 43
  self.labScore.transform.localPosition = pos
  if isEmpty then
    return
  end
  self.charID = data.id
  local proData = Table_Class[data.profession]
  self.objProfession:SetActive(proData and IconManager:SetProfessionIcon(proData.icon, self.sprProfession) or false)
  if proData then
    self.sprProfessionBG.color = ColorUtil[string.format("CareerIconBg%s", proData.Type)] or ColorUtil.CareerIconBg0
  end
  self.headData:Reset()
  self.headData:TransByTeamMemberData(data)
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
  self.labName.text = data.name
end
function TeamPwsMemberCell:SetScore(data)
  self.labScore.text = string.format(ZhString.TeamPws_Score, data.score)
  local haveLevel = data.erank ~= MatchCCmd_pb.ETEAMPWSRANK_NONE
  self.sprLevel.gameObject:SetActive(haveLevel)
  if haveLevel then
    IconManager:SetUIIcon(string.format("ui_teampvp_lv%s", data.erank), self.sprLevel)
  end
  local pos = self.labScore.transform.localPosition
  pos.x = haveLevel and 89 or 43
  self.labScore.transform.localPosition = pos
end
function TeamPwsMemberCell:ClickHead()
  self:PassEvent(MouseEvent.MouseClick, self)
end
