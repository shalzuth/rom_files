local baseCell = autoImport("BaseCell")
BaseAttributeMoneyCell = class("BaseAttributeMoneyCell", baseCell)
function BaseAttributeMoneyCell:Init()
  self:initView()
end
function BaseAttributeMoneyCell:SetData(data)
  local itemData = Table_Item[data.id]
  if self:checkForbid(data.name) then
    self:Hide(self.gameObject)
    return
  end
  if itemData then
    local nameText = itemData.NameZh
    local value = 0
    local name = data.name
    if name then
      value = Game.Myself.data.userdata:Get(name)
      self.name.text = nameText
    else
      value = -data.num
      self.name.text = nameText .. ZhString.Charactor_Infomation_FuZhai
    end
    if name == "ZENY_DEBT" then
      if value == nil or value == 0 then
        self:Hide(self.gameObject)
      else
        self.value.text = "-" .. value
      end
    elseif name == "GARDEN" then
      value = BagProxy.Instance:GetItemNumByStaticID(data.id)
      self.value.text = value
    elseif name == "QUOTA" then
      local hasCharge = MyselfProxy.Instance:GetHasCharge()
      if hasCharge == nil or hasCharge == 0 then
        self:Hide(self.gameObject)
      else
        self.value.text = value
      end
    else
      self.value.text = value
    end
    IconManager:SetItemIcon(itemData.Icon, self.icon)
  else
    printRed("can't find itemData at id:")
  end
end
function BaseAttributeMoneyCell:initView()
  self.name = self:FindChild("name"):GetComponent(UILabel)
  self.value = self:FindChild("value"):GetComponent(UILabel)
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
end
local myBranchValue = EnvChannel.BranchBitValue[EnvChannel.Channel.Name]
function BaseAttributeMoneyCell:checkForbid(key)
  if GameConfig.Charactor_InfoShow_Forbid and GameConfig.Charactor_InfoShow_Forbid[key] and myBranchValue & GameConfig.Charactor_InfoShow_Forbid[key] > 0 then
    return true
  end
end
