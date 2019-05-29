local BaseCell = autoImport("BaseCell")
UIModelCell = class("UIModelCell", BaseCell)
UIModelCell.ModelType = {
  Role = "Role",
  RolePart = "RolePart",
  ModelPrefab = "ModelPrefab"
}
local tempV3 = LuaVector3()
function UIModelCell:ctor(go, index)
  UIModelCell.super.ctor(self, go)
  self.index = index
  self:SetRenderTexPath(index)
  self:Init()
end
function UIModelCell:SetRenderTexPath(index)
  self.renderTexRId = "GUI/pic/Model/UIModelTexture" .. index
end
function UIModelCell:Init()
  self.camera = self:FindGO("Camera", go):GetComponent(Camera)
  self.container = self:FindGO("ModelContainer", go)
  self.modelBack = self:FindGO("back", go)
end
function UIModelCell:LoadAndResetRenderTex()
  self:ResetRenderTexture()
  Game.AssetManager_UI:LoadAsset(self.renderTexRId, RenderTexture, UIModelCell._LoadRenderTex, self)
end
function UIModelCell._LoadRenderTex(owner, asset, path)
  owner:SetRenderTex(asset)
end
function UIModelCell:SetRenderTex(renderTex)
  if self:ObjIsNil(self.uiTexture) or self:ObjIsNil(self.camera) then
    self:ResetRenderTexture()
    return
  end
  self.renderTex = RenderTexture.Instantiate(renderTex)
  self.renderTex.width = self.uiTexture.width
  self.renderTex.height = self.uiTexture.height
  self.camera.enabled = false
  self.camera.targetTexture = self.renderTex
  self.camera.enabled = true
  self.uiTexture.mainTexture = self.renderTex
  self.uiTexture.gameObject:SetActive(true)
end
function UIModelCell:SetTexture(uiTexture)
  if self:ObjIsNil(uiTexture) then
    self:ResetRenderTexture()
    return
  else
    self.uiTexture = uiTexture
    uiTexture.gameObject:SetActive(false)
    if not self:ObjIsNil(self.renderTex) and self.renderTex.width == uiTexture.width and self.renderTex.height == uiTexture.height then
      uiTexture.mainTexture = self.renderTex
      uiTexture.gameObject:SetActive(true)
    else
      self:LoadAndResetRenderTex()
    end
    self:CheckNeedReset()
  end
end
local tempRot = LuaQuaternion()
function UIModelCell:UpdateCameraRot()
  local cameraController = CameraController.singletonInstance
  if cameraController == nil then
    return
  end
  local main_cr = cameraController.cameraRotation
  tempV3:Set(LuaGameObject.GetLocalEulerAngles(self.camera.transform))
  tempRot.eulerAngles = main_cr.eulerAngles - tempV3
  self.gameObject.transform.rotation = tempRot
end
function UIModelCell:_SetCameraConfig(cameraConfig)
  if not self:ObjIsNil(self.camera) then
    self.camera.transform.localPosition = cameraConfig.position
    self.camera.transform.localRotation = cameraConfig.rotation
    self.camera.fieldOfView = cameraConfig.fieldOfView
    self.camera.clearFlags = CameraClearFlags.SolidColor
    self.camera.backgroundColor = LuaColor.New(0.19215686274509805, 0.30196078431372547, 0.4745098039215686, 1)
    if self.modelBack then
      self.modelBack:SetActive(true)
    end
    self:UpdateCameraRot()
  end
end
function UIModelCell:SetRolePartModelTexture(uiTexture, partIndex, id, cameraConfig)
  self:SetTexture(uiTexture)
  self:ResetModel()
  self.gameObject:SetActive(true)
  self.modelType = UIModelCell.ModelType.RolePart
  self.model = Asset_RolePart.Create(partIndex, id)
  if self.model then
    self.model:ResetParent(self.container.transform)
    self.model:SetLayer(self.container.layer)
    self.model:ResetLocalPositionXYZ(0, 0, 0)
    self.model:ResetLocalScaleXYZ(1, 1, 1)
    tempV3:Set(0, 0, 0)
    self.model:ResetLocalEulerAngles(tempV3)
  end
  self:_SetCameraConfig(cameraConfig or UIModelCameraTrans.Item)
  return self.model
end
function UIModelCell:SetModelPrefabTexture(uiTexture, bodyID)
  self:SetTexture(uiTexture)
  self:ResetModel()
  self.gameObject:SetActive(true)
  self.modelType = UIModelCell.ModelType.ModelPrefab
  local resID = ResourcePathHelper.RoleBody(bodyID)
  local prefab = ResourceManager.Instance:SLoad(resID)
  self.model = GameObject.Instantiate(prefab)
  if self.model then
    self.model.transform:SetParent(self.container.transform)
    UIUtil.ChangeLayer(self.model, self.container.layer)
  end
  return self.model
end
function UIModelCell:SetRoleModelTexture(uiTexture, parts, cameraConfig, scale, isPreviewMount)
  self:SetTexture(uiTexture)
  self.gameObject:SetActive(true)
  if self.model and self.modelType == UIModelCell.ModelType.Role then
    self.model:Redress(parts)
  else
    self:ResetModel()
    self.model = Asset_Role.Create(parts)
    self.model:SetParent(self.container.transform, false)
    self.model:SetLayer(self.container.layer)
  end
  self.modelType = UIModelCell.ModelType.Role
  self.model:SetPosition(LuaVector3.zero)
  self.model:SetRotation(LuaQuaternion.identity)
  self.model:SetScale(scale or 1)
  if isPreviewMount ~= nil then
    self.model:SetMountDisplay(isPreviewMount)
  end
  self.model:PlayAction_Idle()
  self:_SetCameraConfig(cameraConfig or UIModelCameraTrans.Role)
  return self.model
end
function UIModelCell:ResetRenderTexture()
  Game.AssetManager_UI:UnLoadAsset(self.renderTexRId)
  if not self:ObjIsNil(self.camera) then
    self.camera.targetTexture = nil
  end
  if not self:ObjIsNil(self.renderTex) then
    RenderTexture.Destroy(self.renderTex)
  end
  self.renderTex = nil
end
function UIModelCell:ResetModel()
  if self.modelType == UIModelCell.ModelType.ModelPrefab then
    GameObject.Destroy(self.model)
    self.model = nil
    return
  end
  if self.model then
    self.model:Destroy()
  end
  self.model = nil
end
function UIModelCell:Reset()
  self:ResetRenderTexture()
  self:ResetModel()
  self.uiTexture = nil
  self.gameObject:SetActive(false)
end
function UIModelCell:CheckNeedReset()
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 33, function(self)
    if self:ObjIsNil(self.uiTexture) then
      self:Reset()
      TimeTickManager.Me():ClearTick(self, 1)
    end
  end, self, 1)
end
function UIModelCell:GetCacheUITexture()
  if self:ObjIsNil(self.uiTexture) then
    self.uiTexture = nil
  end
  return self.uiTexture
end
function UIModelCell:SetModelTransparent()
  self.camera.clearFlags = CameraClearFlags.SolidColor
  self.camera.backgroundColor = LuaColor.New(0, 0, 0, 0)
  self.modelBack:SetActive(false)
end
