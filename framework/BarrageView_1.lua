autoImport("CoreView")
BarrageView = class("BarrageView", CoreView)
BarrageView.yScale = 8
BarrageView.activeWidth = 1280
BarrageView.cellPath = ResourcePathHelper.UICell("MessageFlyer2D")
function BarrageView:ctor(go)
  BarrageView.super.ctor(self, go)
  self:Init()
end
function BarrageView:Init()
  self.objSysMsgText = nil
  self.cacheLabel = {}
  self.panel = self.gameObject:GetComponentInChildren(UIPanel)
end
function BarrageView:AddText(data)
  local go = Game.AssetManager_UI:CreateAsset(BarrageView.cellPath, self.panel.gameObject)
  local label = go:GetComponentInChildren(UILabel)
  label.text = data.text
  label.color = data.color
  if data.frame and data.frame ~= 0 and data.frame ~= 1 then
    FunctionBarrage.Me():CreateFrame(go, data.frame)
  elseif data.userid == Game.Myself.data.id then
  end
  local bounds = NGUIMath.CalculateRelativeWidgetBounds(go.transform, false)
  local panelWidthPer = data.percent
  local maxWidth = BarrageView.activeWidth / 2
  local maxX = maxWidth - bounds.size.x
  local minX = -maxWidth - math.min(bounds.min.x, 0)
  local x = math.clamp((panelWidthPer - 0.5) * BarrageView.activeWidth, minX, maxX)
  local height = self:GetActiveHeight()
  local minY = -height / 2 + height * GameConfig.Barrage.HeightMin + bounds.size.y * BarrageView.yScale / 2
  local maxY = height / 2 - height * (1 - GameConfig.Barrage.HeightMax) - bounds.size.y * BarrageView.yScale / 2
  local y = math.random(minY, maxY)
  go.transform.localPosition = Vector3(x, y, 0)
  self.cacheLabel[data] = go
  return go
end
function BarrageView:CreateSystemMsgText()
  local sysBrgID = BarrageProxy.Instance:GetSysBarrageID()
  local brgConfig = sysBrgID and GameConfig.Barrage.SystemBarrage[sysBrgID]
  if not brgConfig then
    self:RemoveSysMsg()
    LogUtility.Error(string.format("\230\178\161\230\156\137\230\137\190\229\136\176\231\179\187\231\187\159\229\188\185\229\185\149\239\188\154%s \231\154\132\233\133\141\231\189\174", tostring(sysBrgID)))
    return
  end
  if not self.objSysMsg then
    self.objSysMsg = Game.AssetManager_UI:CreateAsset(BarrageView.cellPath, self.panel.gameObject)
  end
  local label = self.objSysMsg:GetComponentInChildren(UILabel)
  label.text = Table_Sysmsg[brgConfig.msgid].Text
  label.fontSize = GameConfig.Barrage.SysBrgFontSize
  label.color = FunctionBarrage.Me():GetColorByName(brgConfig.color)
  local vec = self.objSysMsg.transform.localPosition
  local height = self:GetActiveHeight()
  vec.y = -height / 2 + height * brgConfig.height - label.fontSize * label.transform.localScale.y * BarrageView.yScale / 2
  self.objSysMsg.transform.localPosition = vec
  self.objSysMsg.transform.localScale = Vector3(1, BarrageView.yScale, 1)
end
function BarrageView:RemoveText(data)
  local go = self.cacheLabel[data]
  FunctionBarrage.Me():RemoveFrame(go)
  Game.GOLuaPoolManager:AddToUIPool(BarrageView.cellPath, go)
  self.cacheLabel[data] = nil
  return go
end
function BarrageView:RemoveSysMsg()
  if self.objSysMsg then
    GameObject.DestroyImmediate(self.objSysMsg)
    self.objSysMsg = nil
  end
end
function BarrageView:GetActiveHeight()
  local uiRoot = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIRoot)
  if uiRoot ~= nil then
    return uiRoot.activeHeight
  end
  return 0
end
