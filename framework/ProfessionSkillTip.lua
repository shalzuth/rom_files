autoImport("BaseTip")
ProfessionSkillTip = class("ProfessionSkillTip", BaseTip)
autoImport("ProfessionDesSkillCell")
function ProfessionSkillTip:Init()
  self:initView()
end
function ProfessionSkillTip:initView()
  self.bg = self:FindChild("BG"):GetComponent(UISprite)
  local table = self:FindChild("Tabel"):GetComponent(UITable)
  self.tableList = UIGridListCtrl.new(table, ProfessionDesSkillCell, "ProfessionDesSkillCell")
  self:closeWhenClickOther()
end
function ProfessionSkillTip:adjustZ(value)
  local position = self.gameObject.transform.localPosition
  position.z = value
  self.gameObject.transform.localPosition = position
end
function ProfessionSkillTip:closeWhenClickOther()
  self.gameObject:AddComponent(CloseWhenClickOtherPlace)
  local closeWhenClickOther = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  closeWhenClickOther.isDestroy = true
  local closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  function closecomp.callBack(go)
    self:CloseSelf()
  end
end
function ProfessionSkillTip:UpdateInfo()
  self:UpdateCurrent()
  self:UpdateNext()
end
function ProfessionSkillTip:CloseSelf()
  if self.callback then
    self.callback(self.data)
  end
  TipsView.Me():HideCurrent()
end
function ProfessionSkillTip:GetNext()
  self.nextData = BlackSmithProxy.Instance:GetNextStrengthMaster(self.data)
end
function ProfessionSkillTip:SetData(data)
  self.data = data
  self.gameObject:SetActive(true)
  self.callback = data.callback
  self.tableList:ResetDatas(data.skills)
end
function ProfessionSkillTip:OnEnter()
end
function ProfessionSkillTip:OnExit()
  self.resID = nil
  return true
end
CharactAttributeTip = class("CharactAttributeTip", BaseTip)
function CharactAttributeTip:Init()
  self:initView()
end
function CharactAttributeTip:initView()
  self.content = self:FindChild("Content"):GetComponent(UILabel)
end
function CharactAttributeTip:adjustZ(value)
  local position = self.gameObject.transform.localPosition
  position.z = value
  self.gameObject.transform.localPosition = position
end
function CharactAttributeTip:SetData(data)
  self.data = data
  local text = ""
  for i = 1, #GameConfig.AttrDesc do
    local single = GameConfig.AttrDesc[i]
    text = text .. "[32cd32]" .. single.name .. ":[-]" .. single.value .. "\n"
  end
  self.content.text = text
end
