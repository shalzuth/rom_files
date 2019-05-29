autoImport("LotteryResultCell")
LotteryResultView = class("LotteryResultView", ContainerView)
LotteryResultView.ViewType = UIViewType.PopUpLayer
local tempVector3 = LuaVector3.zero
local GetLocalPosition = LuaGameObject.GetLocalPosition
function LotteryResultView:Init()
  self:FindObjs()
  self:InitShow()
  local close = self:FindGO("CloseButton", pfb)
  self:AddClickEvent(close, function()
    GameFacade.Instance:sendNotification(XDEUIEvent.LotteryAnimationEnd)
    self:CloseSelf()
  end)
end
function LotteryResultView:FindObjs()
  self.effectContainer = self:FindGO("EffectContainer")
  self.extraEffectContainer = self:FindGO("ExtraEffectContainer")
  self.specialBg = self:FindGO("SpecialBg")
end
function LotteryResultView:InitShow()
  local data = self.viewdata.viewdata
  if data then
    self.list = {}
    self.extraList = {}
    local mid = math.floor(#data / 2)
    for i = 1, mid do
      self.list[#self.list + 1] = data[i]:Clone()
    end
    for i = mid + 1, #data do
      self.extraList[#self.extraList + 1] = data[i]:Clone()
    end
    local grid = self:FindGO("Grid"):GetComponent(UIGrid)
    self.itemCtl = UIGridListCtrl.new(grid, LotteryResultCell, "LotteryResultCell")
    self.itemCtl:ResetDatas(self.list)
    local extraGrid = self:FindGO("ExtraGrid"):GetComponent(UIGrid)
    self.extraItemCtl = UIGridListCtrl.new(extraGrid, LotteryResultCell, "LotteryResultCell")
    self.extraItemCtl:ResetDatas(self.extraList)
    local itemCells = self.itemCtl:GetCells()
    for i = 1, #itemCells do
      self:SetNormal(self.effectContainer, GetLocalPosition(itemCells[i].trans))
    end
    itemCells = self.extraItemCtl:GetCells()
    for i = 1, #itemCells do
      if i == #itemCells then
        self:SetSpecial(self.extraEffectContainer, GetLocalPosition(itemCells[i].trans))
      else
        self:SetNormal(self.extraEffectContainer, GetLocalPosition(itemCells[i].trans))
      end
    end
  end
end
function LotteryResultView:SetNormal(parent, x, y, z)
  local effect = self:PlayUIEffect(EffectMap.UI.Egg10BoomB, parent, true)
  effect:ResetLocalPositionXYZ(x, y, z)
  effect = self:PlayUIEffect(EffectMap.UI.Egg10DritB, parent)
  effect:ResetLocalPositionXYZ(x, y, z)
end
function LotteryResultView:SetSpecial(parent, x, y, z)
  local effect = self:PlayUIEffect(EffectMap.UI.Egg10BoomR, parent, true)
  effect:ResetLocalPositionXYZ(x, y, z)
  effect = self:PlayUIEffect(EffectMap.UI.Egg10DritR, parent)
  effect:ResetLocalPositionXYZ(x, y, z)
  self.specialBg:SetActive(true)
  tempVector3:Set(x + 40, y + 40, z)
  self.specialBg.transform.localPosition = tempVector3
end
