local BaseCell = autoImport("BaseCell")
PlayerSingViewCell = reusableClass("PlayerSingViewCell", BaseCell)
PlayerSingViewCell.PoolSize = 50
PlayerSingViewCell.resId = ResourcePathHelper.UICell("PlayerSingViewCell")
local tempVector3 = LuaVector3.zero
function PlayerSingViewCell:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end
function PlayerSingViewCell:DoConstruct(asArray, args)
  self._alive = true
  local followTarget = args[1]
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(PlayerSingViewCell.resId, followTarget)
  if not self:ObjIsNil(self.gameObject) and not self:ObjIsNil(followTarget) then
    self.gameObject.transform:SetParent(followTarget.transform, false)
    tempVector3:Set(0, 0, 0)
    self.gameObject.transform.localPosition = tempVector3
    self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    tempVector3:Set(1, 1, 1)
    self.gameObject.transform.localScale = tempVector3
    self.processSlider = self:FindComponent("ProcessSlider", UISlider)
    self.playTw = self.gameObject:GetComponent(UIPlayTween)
    local widget = self.gameObject:GetComponent(UIWidget)
    widget.alpha = 1
    EventDelegate.Set(self.playTw.onFinished, function()
      self:stopProcess()
    end)
  end
end
function PlayerSingViewCell:Deconstruct(asArray)
  if self.playTw.onFinished then
    EventDelegate.Set(self.playTw.onFinished, nil)
  end
  if not self:ObjIsNil(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PlayerSingViewCell.resId, self.gameObject)
  end
  self._alive = false
end
function PlayerSingViewCell:Alive()
  return self._alive
end
function PlayerSingViewCell:SetData(creature)
  self:initData()
  self.id = creature.data.id
  self.processTime = creature.skill:GetCastTime(creature)
  self:startProcess()
end
function PlayerSingViewCell:initData()
  TimeTickManager.Me():ClearTick(self)
  self.processSlider.value = 0
  self.passTime = 0
  self.processTime = 0
end
function PlayerSingViewCell:startProcess()
  TimeTickManager.Me():CreateTick(0, 16, self.updateCdTime, self)
end
function PlayerSingViewCell:updateCdTime(deltaTime)
  self.passTime = self.passTime + deltaTime / 1000
  self.processSlider.value = self.passTime / self.processTime
  if self.passTime >= self.processTime then
    self:stopProcess()
  end
end
function PlayerSingViewCell:stopProcess()
  TimeTickManager.Me():ClearTick(self)
  local creature = SceneCreatureProxy.FindCreature(self.id)
  if not creature or not creature:GetSceneUI() then
    local sceneUI
  end
  if sceneUI then
    sceneUI.roleTopUI:DestroyTopSingUI()
  end
end
function PlayerSingViewCell:delayProcess()
  self:stopProcess()
end
