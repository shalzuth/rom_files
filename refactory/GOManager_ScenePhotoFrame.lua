GOManager_ScenePhotoFrame = class("GOManager_ScenePhotoFrame")
local FramePhotoWidth = 822
local FramePhotoHeight = 462
local FramePhotoAspect = FramePhotoWidth / FramePhotoHeight
local FramePhotoAspectReverse = FramePhotoHeight / FramePhotoWidth
local tempVector3 = LuaVector3.zero
function GOManager_ScenePhotoFrame:ctor()
  self.objects = {}
  self.renderers = {}
end
function GOManager_ScenePhotoFrame:Clear()
  TableUtility.TableClear(self.objects)
  TableUtility.TableClear(self.renderers)
end
function GOManager_ScenePhotoFrame:SetPhoto(frameID, photo, photoWidth, photoHeight, angleZ)
  local obj = self.objects[frameID]
  if nil == obj then
    return
  end
  local renderer = self.renderers[frameID]
  if nil == renderer then
    if nil == photo then
      return
    end
    renderer = obj:GetComponentProperty(0)
    self.renderers[frameID] = renderer
  elseif nil == photo then
    renderer.material = nil
    renderer.materials = _EmptyTable
    self.renderers[frameID] = nil
    return
  end
  renderer.material = Game.Prefab_ScenePhoto.sharedMaterial
  renderer.material.mainTexture = photo
  tempVector3:Set(LuaGameObject.GetLocalEulerAngles(renderer.transform))
  local frameDir = Table_ScenePhotoFrame[frameID].Dir
  local frameAspect
  local scaleX = 1
  local scaleY = 1
  if 0 == frameDir then
    frameAspect = FramePhotoAspect
  elseif angleZ >= 45 and angleZ <= 135 then
    tempVector3[3] = 270
    frameAspect = FramePhotoAspect
    scaleX = FramePhotoAspect
    scaleY = FramePhotoAspectReverse
  elseif angleZ >= 225 and angleZ <= 315 then
    tempVector3[3] = 90
    frameAspect = FramePhotoAspect
    scaleX = FramePhotoAspect
    scaleY = FramePhotoAspectReverse
  else
    frameAspect = FramePhotoAspectReverse
  end
  renderer.transform.localEulerAngles = tempVector3
  tempVector3:Set(LuaGameObject.GetLocalScale(renderer.transform))
  local aspect = photoWidth / photoHeight
  if frameAspect > aspect then
    tempVector3[1] = scaleX
    tempVector3[2] = scaleY * (frameAspect / aspect)
    renderer.material:SetFloat("_CutX", 0)
    renderer.material:SetFloat("_CutY", (1 - aspect / frameAspect) * 0.5)
  else
    tempVector3[1] = scaleX * (aspect / frameAspect)
    tempVector3[2] = scaleY
    renderer.material:SetFloat("_CutX", (1 - frameAspect / aspect) * 0.5)
    renderer.material:SetFloat("_CutY", 0)
  end
  renderer.transform.localScale = tempVector3
end
function GOManager_ScenePhotoFrame:SetPhotoFrame(obj, ID)
  self.objects[ID] = obj
  if nil ~= obj then
    local renderer = obj:GetComponentProperty(0)
    renderer.material = nil
    renderer.materials = _EmptyTable
  else
    self.renderers[ID] = nil
  end
end
function GOManager_ScenePhotoFrame:OnClick(obj)
  local renderer = self.renderers[obj.ID]
  if nil ~= renderer then
    Game.PictureWallManager:ClickFrame(obj.ID, renderer)
  else
    Game.PictureWallManager:ClickFrame(obj.ID, obj)
  end
end
function GOManager_ScenePhotoFrame:ClearPhotoFrame(obj)
  local objID = obj.ID
  local testObj = self.objects[objID]
  if nil ~= testObj and testObj == obj then
    self:SetPhotoFrame(nil, objID)
    return true
  end
  return false
end
function GOManager_ScenePhotoFrame:RegisterGameObject(obj)
  local objID = obj.ID
  Debug_AssertFormat(objID > 0, "RegisterScenePhotoFrame({0}) invalid id: {1}", obj, objID)
  self:SetPhotoFrame(obj, objID)
  return true
end
function GOManager_ScenePhotoFrame:UnregisterGameObject(obj)
  if not self:ClearPhotoFrame(obj) then
    Debug_AssertFormat(false, "UnregisterScenePhotoFrame({0}) failed: {1}", obj, obj.ID)
    return false
  end
  return true
end
