local baseCell = autoImport("BaseCell")
ActivityButtonCell = class("ActivityButtonCell", baseCell)
function ActivityButtonCell:Init()
  self:initView()
  self.iconWidth = 80
  self.iconHeight = 80
end
function ActivityButtonCell:initView()
  self:ResetDepth()
  self.activity_texture = self:FindComponent("activity_texture", UITexture)
  self.activity_label = self:FindComponent("activity_label", UILabel)
  self.holderSp = self:FindGO("holderSp")
  self:AddCellClickEvent()
end
function ActivityButtonCell:ResetDepth()
  local _UISprite = self.gameObject:GetComponent(UISprite)
  local activity_texture = self:FindGO("activity_texture")
  local activity_label = self:FindGO("activity_label")
  local holderSp = self:FindGO("holderSp")
  local activity_texture_UITexture = activity_texture:GetComponent(UITexture)
  local activity_label_UILabel = activity_label:GetComponent(UILabel)
  local holderSp_UISprite = holderSp:GetComponent(UISprite)
  _UISprite.depth = _UISprite.depth + 30
  activity_texture_UITexture.depth = activity_texture_UITexture.depth + 30
  activity_label_UILabel.depth = activity_label_UILabel.depth + 30
  holderSp_UISprite.depth = holderSp_UISprite.depth + 30
end
function ActivityButtonCell:SetData(data)
  self:Show(self.holderSp)
  local texture = self.activity_texture.mainTexture
  self.activity_texture.mainTexture = nil
  Object.DestroyImmediate(texture)
  self.data = data
  self:updateTime()
  self:PassEvent(MainviewActivityPage.GetIconTexture, self)
end
function ActivityButtonCell:updateTime()
  local data = self.data
  if data.countdown then
    local subActs = data.sub_activity
    if subActs and #subActs > 0 then
      local subActs = data.sub_activity
      local currentTime = ServerTime.CurServerTime()
      currentTime = math.floor(currentTime / 1000)
      local time = subActs[1].begintime
      local leftTime = time - currentTime
      local preText = ZhString.ActivityData_Start
      if leftTime < 0 then
        leftTime = subActs[1].endtime - currentTime
        preText = ZhString.ActivityData_Finish
      end
      if leftTime >= 86400 then
        local day = math.floor(leftTime / 86400)
        local h = math.floor((leftTime - day * 3600 * 24) / 3600)
        self.activity_label.text = string.format(ZhString.ActivityData_HourDes, data.name, day, h, preText)
      else
        local h = math.floor(leftTime / 3600)
        local m = math.floor((leftTime - h * 3600) / 60)
        local s = leftTime - h * 3600 - m * 60
        self.activity_label.text = string.format(ZhString.ActivityData_TimeLineDes, data.name, h, m, s, preText)
      end
    else
      self.activity_label.text = data.name
    end
  else
    self.activity_label.text = data.name
  end
end
function ActivityButtonCell:OnRemove()
  Object.DestroyImmediate(self.activity_texture.mainTexture)
end
function ActivityButtonCell:setTextureByBytes(bytes)
  local texture = Texture2D(2, 2, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self:setTexture(texture)
  else
    Object.DestroyImmediate(texture)
  end
end
function ActivityButtonCell:setTexture(texture)
  if texture then
    self:Hide(self.holderSp)
    Object.DestroyImmediate(self.activity_texture.mainTexture)
    self.activity_texture.mainTexture = texture
    self.activity_texture:MakePixelPerfect()
  end
end
