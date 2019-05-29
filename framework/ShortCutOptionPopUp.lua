ShortCutOptionPopUp = class("ShortCutOptionPopUp", BaseView)
autoImport("ShortCutItemCell")
ShortCutOptionPopUp.ViewType = UIViewType.PopUpLayer
function ShortCutOptionPopUp:Init()
  local grid = self:FindComponent("Grid", UIGrid)
  self.ctl = UIGridListCtrl.new(grid, ShortCutItemCell, "ShortCutItemCell")
  self.ctl:AddEventListener(MouseEvent.MouseClick, self.ClickItemTrace, self)
  local Label = self:FindGO("Label"):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(Label, 3, 200)
end
function ShortCutOptionPopUp:ClickItemTrace(shortCutItem)
  if shortCutItem.traceId then
    FuncShortCutFunc.Me():CallByID(shortCutItem.traceId)
  end
  self:CloseSelf()
end
local datas = {}
function ShortCutOptionPopUp:OnEnter()
  ShortCutOptionPopUp.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local data = self.viewdata.viewdata.data
    TableUtility.ArrayClear(datas)
    if data then
      for i = 1, #data do
        local shortCutData = Table_ShortcutPower[data[i]]
        table.insert(datas, shortCutData)
      end
    else
      helplog("function ShortCutOptionPopUp:OnEnter() nil")
    end
    self.ctl:ResetDatas(datas)
  end
end
