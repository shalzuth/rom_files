UIModelCameraTrans = {
  Role = {
    position = Vector3(1.28, 1.18, -2.34),
    rotation = Quaternion.Euler(7.12, -28.5, 0),
    fieldOfView = 45
  },
  Item = {
    position = Vector3(0.8, 0.57, -1.5),
    rotation = Quaternion.Euler(7.119995, -28.5, -0.8000488),
    fieldOfView = 61
  },
  Team = {
    position = Vector3(1.06, 1.12, -1.93),
    rotation = Quaternion.Euler(7.119996, -28.5, -0.8000793),
    fieldOfView = 61
  }
}
autoImport("UIModelCell")
UIModelUtil = class("UIModelUtil")
UIModelUtil.Instance = nil
function UIModelUtil:ctor()
  self:Init()
  UIModelUtil.Instance = self
end
function UIModelUtil:FindGO(name, parent)
  parent = parent or self.gameObject
  return parent ~= nil and GameObjectUtil.Instance:DeepFind(parent, name) or nil
end
function UIModelUtil:Init()
  local path = "GUI/pic/Model/UIModelCamera"
  self.gameObject = Game.AssetManager_UI:CreateAsset(path)
  GameObject.DontDestroyOnLoad(self.gameObject)
  self.uiModelMap = {}
  for i = 1, 6 do
    local uiModelCell = {}
    local go = self:FindGO("Model" .. i, self.gameObject)
    local uiModelCell = UIModelCell.new(go, i)
    table.insert(self.uiModelMap, uiModelCell)
  end
end
function UIModelUtil:GetUIModelCell(uiTexture)
  local result
  for i = 1, #self.uiModelMap do
    local cell = self.uiModelMap[i]
    if cell:GetCacheUITexture() == uiTexture and result == nil then
      result = cell
      break
    end
  end
  if not result then
    for i = 1, #self.uiModelMap do
      local cell = self.uiModelMap[i]
      if cell:GetCacheUITexture() == nil then
        result = cell
        break
      end
    end
  end
  return result
end
function UIModelUtil:Reset()
  for i = 1, #self.uiModelMap do
    local cell = self.uiModelMap[i]
    cell:Reset()
  end
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
  self.gameObject = nil
end
function UIModelUtil:SetMountModelTexture(uiTexture, mountId)
  local cell = self:GetUIModelCell(uiTexture)
  if cell then
    return cell:SetRolePartModelTexture(uiTexture, Asset_Role.PartIndex.Mount, mountId, UIModelCameraTrans.Role)
  end
end
function UIModelUtil:SetRolePartModelTexture(uiTexture, partIndex, id)
  local cell = self:GetUIModelCell(uiTexture)
  if cell then
    return cell:SetRolePartModelTexture(uiTexture, partIndex, id, UIModelCameraTrans.Item)
  end
end
function UIModelUtil:SetModelPrefabTexture(uiTexture, bodyID)
  local cell = self:GetUIModelCell(uiTexture)
  if cell then
    return cell:SetModelPrefabTexture(uiTexture, bodyID)
  end
end
function UIModelUtil:SetCellTransparent(uiTexture)
  local cell = self:GetUIModelCell(uiTexture)
  if cell then
    cell:SetModelTransparent()
  end
end
function UIModelUtil:SetNpcModelTexture(uiTexture, npcid, cameraConfig)
  local parts = Asset_RoleUtility.CreateNpcRoleParts(npcid)
  if parts == nil then
    parts = Asset_RoleUtility.CreateNpcRoleParts(1001)
  end
  local model = self:SetRoleModelTexture(uiTexture, parts, cameraConfig)
  Asset_Role.DestroyPartArray(parts)
  return model
end
local tempVector3 = LuaVector3()
function UIModelUtil:SetMonsterModelTexture(uiTexture, monsterid, cameraConfig, setConfigTrans)
  local parts = Asset_RoleUtility.CreateMonsterRoleParts(monsterid)
  if parts == nil then
    parts = Asset_RoleUtility.CreateMonsterRoleParts(10001)
  end
  local model = self:SetRoleModelTexture(uiTexture, parts, cameraConfig)
  Asset_Role.DestroyPartArray(parts)
  if model ~= nil and setConfigTrans then
    local monsterData = Table_Monster[monsterid]
    if monsterData ~= nil then
      local showPos = monsterData.LoadShowPose
      if showPos and #showPos == 3 then
        tempVector3:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
        model:SetPosition(tempVector3)
      end
      model:SetEulerAngleY(monsterData.LoadShowRotate or 0)
      local size = monsterData.LoadShowSize or 1
      model:SetScale(size)
    end
  end
  return model
end
function UIModelUtil:SetRoleModelTexture(uiTexture, parts, cameraConfig, scale, isPreviewMount)
  local cell = self:GetUIModelCell(uiTexture)
  if cell then
    return cell:SetRoleModelTexture(uiTexture, parts, cameraConfig, scale, isPreviewMount)
  end
end
function UIModelUtil:ResetTexture(uiTexture)
  for i = 1, #self.uiModelMap do
    local cell = self.uiModelMap[i]
    if cell:GetCacheUITexture() == uiTexture then
      cell:Reset()
      break
    end
  end
end
function UIModelUtil:ChangeBGMeshRenderer(name, uiTexture)
  if not self.bgRender then
    self.bgRender = self:FindGO("back"):GetComponent(MeshRenderer)
  end
  if self.bgRender then
    local materials1 = self.bgRender.materials
    if #materials1 > 0 then
      self.material = materials1[1]
      if self.material then
        PictureManager.Instance:SetPetRenderTexture(name, self.material)
      end
    end
  end
end
