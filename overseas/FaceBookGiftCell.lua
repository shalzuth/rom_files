autoImport("BaseCell")
FaceBookGiftCell = class("FaceBookGiftCell", BaseCell)
function FaceBookGiftCell:Init()
  FaceBookGiftCell.super.Init(self)
  self.resultObj = self:FindGO("Result")
  self.actBtn = self:FindGO("ActionBtn")
  self.targetLabel = self:FindGO("TargetLabel"):GetComponent(UILabel)
  self.awardObj = self:FindGO("A1")
  self:AddClickEvent(self.actBtn, function(go)
    ServiceOverseasTaiwanCmdProxy.Instance:CallTaiwanFbLikeUserRedeemCmd(self.data.id)
  end)
end
function FaceBookGiftCell:SetData(data)
  FaceBookGiftCell.super.SetData(self, data)
  self.data = data
  self.resultObj:SetActive(false)
  self.actBtn:SetActive(false)
  local id = data.id
  local target = data.target
  local isUnlocked = data.isUnlocked
  local userRedeemed = data.userRedeemed
  local init = data.init
  self.targetLabel.text = string.format("%s\239\188\140\231\141\178\229\143\150\231\141\142\229\139\181", target)
  local itemData = Table_Item[tonumber(data.itemId)]
  if itemData ~= nil then
    local itemName = itemData.NameZh
    local labelStr = "{itemicon=" .. data.itemId .. "}" .. itemName
    local spriteLabel = SpriteLabel.new(self.awardObj, 370, 38, 38, true)
    spriteLabel:SetText(labelStr, true)
    self.awardObj:GetComponent(UILabel).spacingY = -6
  end
  if not init then
    if not isUnlocked then
      self.resultObj:SetActive(true)
      local awardSprite = self.resultObj:GetComponent(UISprite)
      awardSprite.spriteName = "like_icon_02"
    elseif not userRedeemed then
      self.actBtn:SetActive(true)
    else
      self.resultObj:SetActive(true)
      local awardSprite = self.resultObj:GetComponent(UISprite)
      awardSprite.spriteName = "like_icon_01"
    end
  end
end
function FaceBookGiftCell:number_format(num, deperator)
  local str1 = ""
  local str = tostring(num)
  local strLen = string.len(str)
  if deperator == nil then
    deperator = ","
  end
  deperator = tostring(deperator)
  for i = 1, strLen do
    str1 = string.char(string.byte(str, strLen + 1 - i)) .. str1
    if math.fmod(i, 3) == 0 and strLen - i ~= 0 then
      str1 = "," .. str1
    end
  end
  return str1
end
