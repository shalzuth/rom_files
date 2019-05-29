autoImport("BaseTip")
autoImport("PetInfoLabelCell")
PetAdventureHeadTip = class("PetAdventureHeadTip", BaseTip)
local SkillIconScaleSize = 0.8
local const_cellHeight = 100
function PetAdventureHeadTip:Init()
  self:FindObj()
end
function PetAdventureHeadTip:FindObj()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  local headGO = self:FindGO("PlayerHeadCell")
  self.headIconCell = PlayerFaceCell.new(headGO)
  self.headData = HeadImageData.new()
  self.namelab = self:FindComponent("Name", UILabel)
  self.friendly_valuelab = self:FindComponent("Value", UILabel, self:FindGO("Friendly"))
  self.level_valuelab = self:FindComponent("Value", UILabel, self:FindGO("Level"))
  self.friendly_slider = self:FindComponent("Friend_ExpSlider", UISlider)
  self.level_slider = self:FindComponent("Level_ExpSlider", UISlider)
  self.race = self:FindComponent("Race", UISprite)
  self.nature = self:FindComponent("Nature", UISprite)
  self.bgImg = self:FindComponent("Bg", UISprite)
  local table = self:FindComponent("skillTable", UITable)
  self.attriCtl = UIGridListCtrl.new(table, PetInfoLabelCell, "PetInfoLabelCell")
  self.bgFrame = self:FindComponent("BgFrame", UIWidget)
  self.bgInitHeight = self.bgImg.height
  PetAdventureHeadTip.super.Init(self)
end
function PetAdventureHeadTip:SetData(data)
  self.petEggData = data
  if not self.petEggData then
    return
  end
  if self.petEggData then
    local attriDatas = {}
    self.headData:TransByPetEggData(self.petEggData)
    self.headIconCell:SetData(self.headData)
    self.namelab.text = self.petEggData.name
    self.friendly_valuelab.text = "Lv " .. self.petEggData.friendlv
    self.level_valuelab.text = "Lv " .. self.petEggData.lv
    local natureIcon = self.petEggData:GetNatureIcon() or "Fire"
    local raceIcon = self.petEggData:GetRaceIcon() or "series_tianshi"
    IconManager:SetUIIcon(natureIcon, self.nature)
    IconManager:SetUIIcon(raceIcon, self.race)
    self.friendly_slider.value = self.petEggData:GetPetFriendPercent()
    local expslider_value = 0
    local nowlvConfig = Table_PetBaseLevel[self.petEggData.lv + 1]
    if nowlvConfig then
      self.level_slider.value = self.petEggData.exp / nowlvConfig.NeedExp_2
    else
      self.level_slider.value = 1
    end
    if self.petEggData.skillids and 0 < #self.petEggData.skillids then
      local skilldatas = {}
      skilldatas[1] = PetInfoLabelCell.Type.Skill
      skilldatas[2] = self.petEggData.skillids
      local length = #self.petEggData.skillids
      if length > 4 then
        self.bgImg.height = (length - 4) * const_cellHeight + self.bgInitHeight
      else
        self.bgImg.height = self.bgInitHeight
      end
      self.bgFrame:ResetAndUpdateAnchors()
      skilldatas[4] = true
      skilldatas[5] = SkillIconScaleSize
      table.insert(attriDatas, skilldatas)
    end
    self.attriCtl:ResetDatas(attriDatas)
  end
end
function PetAdventureHeadTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function PetAdventureHeadTip:CloseSelf()
  TipsView.Me():HideCurrent()
end
function PetAdventureHeadTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
