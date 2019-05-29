local BaseCell = autoImport("BaseCell")
ItemPopView = class("ItemPopView", BaseCell)
autoImport("PopItemCell")
local EFFECTMAP_DECOMPOSE_RESULT = {
  [SceneItem_pb.EDECOMPOSERESULT_FAIL] = "equip_tex_01",
  [SceneItem_pb.EDECOMPOSERESULT_SUCCESS] = "equip_tex_02",
  [SceneItem_pb.EDECOMPOSERESULT_SUCCESS_BIG] = "equip_tex_03",
  [SceneItem_pb.EDECOMPOSERESULT_SUCCESS_SBIG] = "equip_tex_04",
  [SceneItem_pb.EDECOMPOSERESULT_SUCCESS_FANTASY] = "equip_tex_05"
}
function ItemPopView:Init()
  self:InitUI()
end
function ItemPopView:InitUI()
  local panel = self:FindGO("ScrollView"):GetComponent(UIPanel)
  self.ScrollView = panel.gameObject:GetComponent(UIScrollView)
  local temp = self.gameObject:GetComponentInParent(UIPanel)
  if temp then
    panel.depth = temp.depth + 1
  end
  self.shadowPanel = self:FindGO("shadowPanel"):GetComponent(UIPanel)
  self.shadowPanel.depth = temp.depth + 2
  self:Show(panel.gameObject)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.grid = UIGridListCtrl.new(self.grid, PopItemCell, "PopItemCell")
  self.grid:AddEventListener(MouseEvent.MouseClick, self.itemClick, self)
  self.icon = self:FindGO("TitleIcon"):GetComponent(UISprite)
  self.uiEquipIcon = self:FindGO("EquipUIIcon"):GetComponent(UISprite)
  self.animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer)
  self.animHelper = self.animHelper.animatorHelper
  self.itemStick = self:FindGO("PopViewBg"):GetComponent(UISprite)
  self.oneItem = self:FindGO("OneItem")
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.DragCollider = self:FindGO("DragCollider")
  self:AddAnimatorEvent()
end
function ItemPopView:itemClick(child)
  local data = child.data
  local data = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(data, self.itemStick, NGUIUtil.AnchorSide.Right, {200, 0})
end
function ItemPopView:IsShowed()
  return self.isShowed
end
function ItemPopView:ResetAnim()
  self.isShowed = false
  LeanTween.cancel(self.gameObject)
  LeanTween.delayedCall(self.gameObject, GameConfig.ItemPopShowTimeLim, function()
    self.isShowed = true
  end)
end
function ItemPopView:PlayHide()
  if self.isShowed then
    self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
  end
end
function ItemPopView:AddAnimatorEvent()
  function self.animHelper.loopCountChangedListener(state, oldLoopCount, newLoopCount)
    if not self.isShowed then
    end
  end
end
local tempVector3 = LuaVector3.zero
function ItemPopView:SetData(data)
  self.data = data
  self:ResetAnim()
  self:Hide(self.oneItem)
  self.grid:RemoveAll()
  if data.data.showType == PopUp10View.ItemCoinShowType.Decompose then
    self:Hide(self.icon.gameObject)
    self:Show(self.uiEquipIcon.gameObject)
    self.uiEquipIcon.spriteName = EFFECTMAP_DECOMPOSE_RESULT[data.data.params]
    self.uiEquipIcon:MakePixelPerfect()
  else
    self:Show(self.icon.gameObject)
    self:Hide(self.uiEquipIcon.gameObject)
  end
  self:Show(self.DragCollider)
  local len = #data.data
  local changeIcon = false
  for i = 1, len do
    local single = data.data[i]
    if not changeIcon and single.source and ProtoCommon_pb.ESOURCE_CHAT and single.source == ProtoCommon_pb.ESOURCE_CHAT then
      changeIcon = true
    end
  end
  self:ChangeTitleIcon(changeIcon)
  if data.data and len == 1 then
    self:Show(self.oneItem)
    self.itemName.text = data.data[1]:GetName() .. "\195\151" .. data.data[1].num
    local itemplaceholder = self:FindGO("itemplaceholder")
    self:Hide(self.DragCollider)
    local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PopItemCell"), itemplaceholder)
    local itemCell = PopItemCell.new(obj)
    tempVector3:Set(0, 0, 0)
    obj.transform.localPosition = tempVector3
    itemCell:AddEventListener(MouseEvent.MouseClick, self.itemClick, self)
    itemCell:SetData(data.data[1])
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.oneItem.transform, true)
    local width = bound.size.x
    tempVector3:Set(LuaGameObject.GetLocalPosition(self.oneItem.transform))
    tempVector3:Set(-width / 2, tempVector3.y, tempVector3.z)
    self.oneItem.transform.localPosition = tempVector3
    return
  elseif data.data and len < 5 then
    self.ScrollView.contentPivot = UIWidget.Pivot.Center
    self.Hide(self.shadowPanel)
  else
    self.Show(self.shadowPanel)
    self.ScrollView.contentPivot = UIWidget.Pivot.Left
  end
  self.grid:ResetDatas(data.data)
  self.ScrollView:ResetPosition()
end
function ItemPopView:SetTitleIcon(configIcon)
end
function ItemPopView:SetIcon(icon)
  self.icon.spriteName = icon
end
local data1 = GameConfig.ChatRewardIcon and GameConfig.ChatRewardIcon[2]
local data2 = GameConfig.ChatRewardIcon and GameConfig.ChatRewardIcon[1]
function ItemPopView:ChangeTitleIcon(changeIcon)
  if changeIcon and data1 then
    if not IconManager:SetItemIcon(data1.sprite, self.icon) then
      IconManager:SetUIIcon(data1.sprite, self.icon)
    end
  elseif data2 then
    IconManager:SetUIIcon(data2.sprite, self.icon)
  end
end
