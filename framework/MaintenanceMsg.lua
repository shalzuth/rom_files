MaintenanceMsg = class("MaintenanceMsg", CoreView)
MaintenanceMsg.ResID = ResourcePathHelper.UICell("MaintenanceMsg")
autoImport("MaintenanceMsgCell")
autoImport("ActivityTextureManager")
local tempV3 = LuaVector3()
function MaintenanceMsg:ctor(parent)
  self.gameObject = self:LoadPreferb("cell/MaintenanceMsg", parent.transform, true)
  tempV3:Set(0, 20, 0)
  self.gameObject.transform.localPosition = tempV3
  self:Init()
end
local function RemoveLastLineN(text)
  local textlen = string.len(text)
  local lastChar = string.sub(text, textlen, -1)
  if lastChar == "\n" then
    local subText = string.sub(text, 1, textlen - 1)
    return RemoveLastLineN(subText)
  else
    return text
  end
end
function MaintenanceMsg:Init()
  self.title = self:FindComponent("Title", UILabel)
  self.text = self:FindComponent("Text", UILabel)
  self.remarkParent = self:FindGO("RemarkParent")
  self.remark = self:FindComponent("Remark", UILabel)
  self.texture = self:FindComponent("Texture", UITexture)
  self.anoucement = self:FindGO("Anoucement")
  self.anoucementShort = self:FindGO("AnoucementShort")
  self.anoucementLong = self:FindGO("AnoucementLong")
  self.normal = self:FindGO("Normal")
  self.normalShort = self:FindGO("NormalShort")
  self.normalLong = self:FindGO("NormalLong")
  self.normalLabel = self:FindComponent("NormalLabel", UILabel)
  self.normalLabelLong = self:FindComponent("NormalLabelLong", UILabel)
  self.button = self:FindGO("Button")
  self:AddClickEvent(self.button, function()
    self:RemoveTextureCache()
    if self.confirmCall then
      self.confirmCall()
    end
    self:Exit()
  end)
  self.buttonlab = self:FindComponent("Label", UILabel, self.button)
  self.contentTableShort = self:FindComponent("ContentTableShort", UITable)
  self.contentGridCtrlShort = UIGridListCtrl.new(self.contentTableShort, MaintenanceMsgCell, "MaintenanceMsgCell")
  self.contentTableLong = self:FindComponent("ContentTableLong", UITable)
  self.contentGridCtrlLong = UIGridListCtrl.new(self.contentTableLong, MaintenanceMsgCell, "MaintenanceMsgCell")
  EventManager.Me():AddEventListener(ActivityTextureManager.ActivityPicCompleteCallbackMsg, self.picCompleteCallback, self)
end
function MaintenanceMsg._LoadMaintenanceTexture(owner, asset, path)
  owner:SetMaintenanceTexture(asset)
end
function MaintenanceMsg:SetMaintenanceTexture(asset)
  if not Slua.IsNull(asset) then
    self.texture.mainTexture = asset
    self.texture:MakePixelPerfect()
  end
end
function MaintenanceMsg:SetData(data)
  if data[1] and data[1] ~= "" then
    self.title.text = data[1]
  end
  if data[3] and data[3] ~= "" then
    self.remarkParent:SetActive(true)
    self.remark.text = data[3]
  else
    self.remarkParent:SetActive(false)
  end
  if data[2] then
    self:SetContext(data[2])
  end
  if data[4] and data[4] ~= "" then
    self.buttonlab.text = data[4]
  end
  if data[6] then
    self.confirmCall = data[6]
  end
  local texturePath = ""
  if data[5] and data[5] ~= "" then
    texturePath = data[5]
  else
    texturePath = "GUI/pic/UI/bulletin_pic_01"
  end
  if Slua.IsNull(self.texture.mainTexture) and self.textureAssetRid and self.textureAssetRid == texturePath then
    return
  end
  self:RemoveTextureCache()
  self.textureAssetRid = texturePath
  Game.AssetManager_UI:LoadAsset(self.textureAssetRid, Texture, MaintenanceMsg._LoadMaintenanceTexture, self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    self:Exit()
  end)
end
function MaintenanceMsg:SetContext(text)
  local isComplexString = string.find(text, "####")
  local convertText = {}
  if not isComplexString then
    self.anoucement:SetActive(false)
    self.normal:SetActive(true)
    if self.remarkParent.activeSelf then
      self.normalShort:SetActive(true)
      self.normalLong:SetActive(false)
      self.normalLabel.text = text
    else
      self.normalShort:SetActive(false)
      self.normalLong:SetActive(true)
      self.normalLabelLong.text = text
    end
  else
    self.normal:SetActive(false)
    self.anoucement:SetActive(true)
    local uiStringList = string.split(text, "####")
    for i = 1, #uiStringList do
      local fixedText = RemoveLastLineN(uiStringList[i])
      convertText[#convertText + 1] = fixedText
    end
    if self.remarkParent.activeSelf then
      self.anoucementShort:SetActive(true)
      self.anoucementLong:SetActive(false)
      self.contentGridCtrlShort:ResetDatas(convertText)
    else
      self.anoucementShort:SetActive(false)
      self.anoucementLong:SetActive(true)
      self.contentGridCtrlLong:ResetDatas(convertText)
    end
  end
end
function MaintenanceMsg:SetExitCall(func)
  self.exitCall = func
end
function MaintenanceMsg:RemoveTextureCache()
  if self.textureAssetRid then
    Game.AssetManager_UI:UnLoadAsset(self.textureAssetRid)
  end
  self.textureAssetRid = nil
end
function MaintenanceMsg:Exit()
  self.confirmCall = nil
  EventManager.Me():RemoveEventListener(ActivityTextureManager.ActivityPicCompleteCallbackMsg, self.picCompleteCallback, self)
  self:RemoveTextureCache()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
  if self.exitCall then
    self.exitCall()
    self.exitCall = nil
  end
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    if UIManagerProxy.Instance:GetModalPopCount() > 0 then
      helplog("close")
      UIManagerProxy.Instance:PopView()
    else
      MsgManager.ConfirmMsgByID(27000, function()
        Application.Quit()
      end, function()
      end, nil, nil)
    end
  end)
end
function MaintenanceMsg:picCompleteCallback(note)
  ActivityTextureManager.Instance():log("MaintenanceMsg:picCompleteCallback")
  local data = note.data
  local cells = {}
  if self.remarkParent.activeSelf then
    cells = self.contentGridCtrlShort:GetCells()
  else
    cells = self.contentGridCtrlLong:GetCells()
  end
  if #cells > 0 then
    for i = 1, #cells do
      cells[i]:OnDownloadComplete(data.picUrl, data.byte)
    end
  else
    ActivityTextureManager.Instance():log("MaintenanceMsg:picCompleteCallback", tostring(self.curActData), data.picUrl, self.curActData and self.curActData.pic_url)
  end
end
