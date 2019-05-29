local BaseCell = autoImport("BaseCell")
TeamMembersCell = class("TeamMembersCell", BaseCell)
autoImport("PlayerFaceCell")
function TeamMembersCell:Init()
  local portrait = self:FindGO("TeamPortrait")
  self.portraitCell = PlayerFaceCell.new(portrait)
  self.portraitCell:SetMinDepth(4)
  self.lv = self:FindComponent("Lv", UILabel)
  self.name = self:FindComponent("Name", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.GenderIcon = self:FindGO("GenderIcon"):GetComponent(UISprite)
end
function TeamMembersCell:SetData(data)
  self.data = data
  if data ~= nil then
    self.lv.text = "Lv." .. tostring(data.baselv)
    self.name.text = data.name
    if data.gender == ProtoCommon_pb.EGENDER_MALE then
      self.GenderIcon.CurrentState = 0
    elseif data.gender == ProtoCommon_pb.EGENDER_FEMALE then
      self.GenderIcon.CurrentState = 1
    end
    local headData = HeadImageData.new()
    headData:TransByTeamMemberData(data)
    self.portraitCell:SetData(headData)
    self.portraitCell.headIconCell:SetScale(0.7)
  end
end
