autoImport("EventDispatcher")
autoImport("LuaQueue")
autoImport("BarrageView")
FunctionBarrage = class("FunctionBarrage", EventDispatcher)
FunctionBarrage.framePath = ResourcePathHelper.UICell("MessageFlyer2D_Frame")
function FunctionBarrage.Me()
  if nil == FunctionBarrage.me then
    FunctionBarrage.me = FunctionBarrage.new()
  end
  return FunctionBarrage.me
end
function FunctionBarrage:ctor()
  self.numLimit = GameConfig.Barrage.MessageCountMax
  self.tickID = 1
  self.uiroot = GameObject.Find("UIRoot")
  self:Reset()
  self.meshIsLoaded = false
end
local vec3 = LuaVector3.New(0, 0, 0)
local callbackInitializeComplete
local isInitializeComplete = false
local isLaunchComplete = false
local callbackLaunchComplete
local _meshSelfRotateSpeed = 0
function FunctionBarrage:Launch(meshSelfRotateSpeed, callback_launch_complete)
  if self.running then
    return
  end
  _meshSelfRotateSpeed = meshSelfRotateSpeed
  callbackLaunchComplete = callback_launch_complete
  self:Initialize()
end
function FunctionBarrage:Initialize()
  callbackInitializeComplete = callback_intialize_complete
  if self.transMainCamera == nil or GameObjectUtil.Instance:ObjectIsNULL(self.transMainCamera) then
    self.transMainCamera = GameObject.FindGameObjectWithTag("MainCamera").transform
  end
  if self.barrage == nil or GameObjectUtil.Instance:ObjectIsNULL(self.barrage.gameObject) then
    self.barrage = BarrageView.new(Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("Barrages"), self.uiroot))
  end
  if self.barrageCam == nil or GameObjectUtil.Instance:ObjectIsNULL(self.barrageCam) then
    self.barrageCam = GameObjectUtil.Instance:DeepFindChild(self.barrage.gameObject, "BarrageCamera"):GetComponent(CameraProjector)
  end
  self.barrageCam.sampleSize = Vector2(BarrageView.activeWidth, self.barrage:GetActiveHeight())
  if self.goMesh == nil or GameObjectUtil.Instance:ObjectIsNULL(self.goMesh) then
    self:LoadMesh()
  else
    self.barrage.gameObject:SetActive(true)
    self.goMesh:SetActive(true)
    self.running = true
    self:ResetMeshRotSpeed(_meshSelfRotateSpeed)
    if callbackLaunchComplete ~= nil then
      callbackLaunchComplete()
    end
    self:CreateSystemMsgText()
  end
end
function FunctionBarrage:OnInitializeComplete()
  if isInitializeComplete then
    isLaunchComplete = true
    if callbackLaunchComplete ~= nil then
      callbackLaunchComplete()
    end
  end
end
function FunctionBarrage:LoadMesh()
  local posOfCamera = self.transMainCamera.position
  vec3:Set(posOfCamera.x, posOfCamera.y, posOfCamera.z)
  Asset_Effect.PlayAt(EffectMap.Maps.Barrage, vec3, function(go_mesh)
    self:OnMeshBeLoaded(go_mesh)
  end)
end
function FunctionBarrage:OnMeshBeLoaded(effect_handle)
  self.goMesh = effect_handle.gameObject
  self.barrageRotateSelf = self.goMesh:GetComponent(RotateSelf)
  self.barrageCam.targetRenderer = self.goMesh:GetComponentInChildren(MeshRenderer)
  vec3:Set(0, 0, 0)
  Game.TransformFollowManager:RegisterFollowPos(self.goMesh.transform, myselfTransform, vec3, function()
  end)
  self.barrage.gameObject:SetActive(true)
  self.goMesh:SetActive(true)
  self.running = true
  self:ResetMeshRotSpeed(_meshSelfRotateSpeed)
  self.meshIsLoaded = true
  if self.meshIsLoaded then
    isInitializeComplete = true
    self:OnInitializeComplete()
  end
  self:CreateSystemMsgText()
end
function FunctionBarrage:ShutDown()
  if not self.running then
    return
  end
  self:Reset()
  if self.barrage then
    self.barrage.gameObject:SetActive(false)
  end
  if self.goMesh then
    self.goMesh:SetActive(false)
  end
end
function FunctionBarrage:Reset()
  self.waitQueue = {}
  if self.barrages ~= nil then
    for i = 1, #self.barrages do
      self:RemoveBarrage(self.barrages[i])
    end
  end
  if self.barrage then
    self.barrage:RemoveSysMsg()
  end
  self.running = false
  self.barrages = {}
  TimeTickManager.Me():ClearTick(self, self.tickID)
end
function FunctionBarrage:ResetMeshRotSpeed(meshSelfRotateSpeed)
  self.meshSelfRotateSpeed = meshSelfRotateSpeed or 30
  self.duration = 360 / self.meshSelfRotateSpeed
  local rotateSpeed = -math.abs(self.meshSelfRotateSpeed)
  local curRotateY = rotateSpeed * (ServerTime.CurServerTime() / 1000 % self.duration)
  local vec = self.goMesh.transform.localEulerAngles
  vec.y = curRotateY
  self.goMesh.transform.localEulerAngles = vec
  if self.barrage then
    self.meshSpeed = BarrageView.activeWidth * (self.meshSelfRotateSpeed / 360.0)
  end
  if self.barrageRotateSelf then
    self.barrageRotateSelf.rotateSpeed = rotateSpeed
  end
end
function FunctionBarrage:GetTransformOfMyself()
  return Game.Myself.assetRole.completeTransform
end
function FunctionBarrage:AddText(data)
  if not self.running then
    return
  end
  local barrage = self:Find(data.id)
  if barrage == nil then
    if #self.barrages >= self.numLimit then
      if self:Find(data.id, self.waitQueue) == nil then
        self.waitQueue[#self.waitQueue + 1] = data
      end
    else
      self:_AddText(data)
    end
  end
end
function FunctionBarrage:CreateSystemMsgText()
  if not self.running then
    return
  end
  self.barrage:CreateSystemMsgText()
end
function FunctionBarrage:_AddText(data)
  data.duration = data.duration or self.duration
  if data.percent == nil then
    data.percent = self:GetPercent()
  end
  self.barrages[#self.barrages + 1] = data
  local go = self.barrage:AddText(data)
  local scale = GameConfig.Barrage.BarrageScale or 1
  go.transform.localScale = Vector3(scale, scale * BarrageView.yScale, 1)
  if data.speed <= self.meshSpeed then
    LeanTween.delayedCall(go, data.duration, function()
      self:Remove(data)
    end)
  else
    local deltaSpeed = data.speed - self.meshSpeed
    local deltaDistance = deltaSpeed * data.duration
    local bounds = NGUIMath.CalculateRelativeWidgetBounds(go.transform, false)
    local minX = -BarrageView.activeWidth / 2 - math.min(bounds.min.x, 0)
    local targetX = math.max(go.transform.localPosition.x - deltaDistance, minX)
    LeanTween.moveLocalX(go, targetX, data.duration):setOnComplete(function()
      self:Remove(data)
    end)
  end
  if data.duration > 0.3 then
    LeanTween.delayedCall(go, data.duration - 0.3, function()
      TweenAlpha.Begin(go, 0.3, 0)
    end)
  end
end
function FunctionBarrage:Remove(data)
  local index = TableUtil.ArrayIndexOf(self.barrages, data)
  if index > 0 then
    local barrage = self.barrages[index]
    self:RemoveBarrage(barrage)
    TableUtil.Remove(self.barrages, barrage)
    if 0 < #self.waitQueue then
      self:_AddText(table.remove(self.waitQueue, 1))
    end
  end
end
function FunctionBarrage:RemoveByID(id)
  local barrage = self:Find(id)
  if barrage then
    self:RemoveBarrage(barrage)
    TableUtil.Remove(self.barrages, barrage)
    if #self.waitQueue > 0 then
      self:_AddText(table.remove(self.waitQueue, 1))
    end
  end
end
function FunctionBarrage:RemoveBarrage(barrage)
  local go = self.barrage:RemoveText(barrage)
  LeanTween.cancel(go)
  local tween = go:GetComponent(TweenAlpha)
  if tween then
    tween.enabled = false
  end
  go:GetComponent(UIWidget).alpha = 1
end
function FunctionBarrage:FindIndex(id, array)
  array = array or self.barrages
  for i = 1, #array do
    if id ~= nil and array[i].id == id then
      return i
    end
  end
  return 0
end
function FunctionBarrage:Find(id, array)
  array = array or self.barrages
  return array[self:FindIndex(id, array)]
end
function FunctionBarrage:GetPercent()
  local y = (self.transMainCamera.localEulerAngles - self.goMesh.transform.localEulerAngles).y - 180
  if y < 0 then
    y = 360 + y or y
  end
  return math.abs(y) / 360
end
function FunctionBarrage:GetColorByName(colorName)
  local color
  if colorName == "white" then
    color = Color(0.6784313725490196, 0.6784313725490196, 0.6784313725490196)
  elseif colorName == "green" then
    color = Color(0 / 255, 1.0, 0 / 255)
  elseif colorName == "blue" then
    color = Color(0 / 255, 0 / 255, 1.0)
  elseif colorName == "red" then
    color = Color(1.0, 0 / 255, 0 / 255)
  elseif colorName == "yellow" then
    color = Color(1.0, 1.0, 0 / 255)
  elseif colorName == "pink" then
    color = Color(1.0, 0.4117647058823529, 0.7058823529411765)
  elseif colorName == "purple" then
    color = Color(0.5411764705882353, 0.16862745098039217, 0.8862745098039215)
  end
  return color
end
function FunctionBarrage:CreateFrame(go, frameid)
  self:RemoveFrame(go)
  local frameConfig = Table_BarrageFrame and Table_BarrageFrame[frameid]
  if not frameConfig then
    LogUtility.Error(string.format("\230\178\161\230\156\137\230\137\190\229\136\176\229\188\185\229\185\149\232\190\185\230\161\134\233\133\141\231\189\174\239\188\154%s", tostring(frameid)))
    return
  end
  local bounds = NGUIMath.CalculateRelativeWidgetBounds(go.transform, false)
  local objFrame = Game.AssetManager_UI:CreateAsset(FunctionBarrage.framePath, go)
  objFrame.name = "BarrageFrame_Clone"
  objFrame.transform.localPosition = bounds.center
  objFrame.transform.localScale = Vector3.one
  bounds:Expand(Vector3(48, 22, 0))
  local sprFrame = objFrame.transform:Find("sprFrame"):GetComponent(UISprite)
  sprFrame.width = bounds.size.x
  sprFrame.height = bounds.size.y
  sprFrame.spriteName = frameConfig.SpriteName
  local objAdorments = objFrame.transform:Find("Adorments").gameObject
  if frameConfig.UpLeft and frameConfig.UpLeft ~= "" then
    self:CreateFrameAdorment(frameConfig.UpLeft, objAdorments, bounds.min.x - bounds.center.x, bounds.max.y - bounds.center.y)
  end
  if frameConfig.UpRight and frameConfig.UpRight ~= "" then
    self:CreateFrameAdorment(frameConfig.UpRight, objAdorments, bounds.max.x - bounds.center.x, bounds.max.y - bounds.center.y)
  end
  if frameConfig.DownLeft and frameConfig.DownLeft ~= "" then
    self:CreateFrameAdorment(frameConfig.DownLeft, objAdorments, bounds.min.x - bounds.center.x, bounds.min.y - bounds.center.y)
  end
  if frameConfig.DownRight and frameConfig.DownRight ~= "" then
    self:CreateFrameAdorment(frameConfig.DownRight, objAdorments, bounds.max.x - bounds.center.x, bounds.min.y - bounds.center.y)
  end
end
function FunctionBarrage:CreateFrameAdorment(name, parent, posX, posY)
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.BarrageAdorment(name), parent)
  if not obj then
    LogUtility.Error(string.format("\229\136\155\229\187\186\229\188\185\229\185\149\232\190\185\230\161\134\232\163\133\233\165\176\239\188\154%s \229\164\177\232\180\165\239\188\129", tostring(name)))
    return
  end
  local vecPos = obj.transform.localPosition
  vecPos.x = posX
  vecPos.y = posY
  obj.transform.localPosition = vecPos
  obj.transform.localScale = Vector3.one
  obj.name = name
end
function FunctionBarrage:RemoveFrame(objBarrage)
  local transFrame = objBarrage.transform:Find("BarrageFrame_Clone")
  if not transFrame then
    return
  end
  local transAdorments = transFrame:Find("Adorments")
  for i = 0, transAdorments.childCount - 1 do
    local obj = transAdorments:GetChild(i).gameObject
    Game.GOLuaPoolManager:AddToUIPool(ResourcePathHelper.BarrageAdorment(obj.name), obj)
  end
  Game.GOLuaPoolManager:AddToUIPool(FunctionBarrage.framePath, transFrame.gameObject)
end
