ItemSecendFuncBord = class("ItemSecendFuncBord", CoreView)
autoImport("ItemFuncButtonCell")
ItemSecendFuncEvent = {
  Close = "ItemSecendFuncEvent_Close"
}
function ItemSecendFuncBord:ctor()
end
function ItemSecendFuncBord:OnCreate(parent, widget, side, pixelOffset)
  local pos = NGUIUtil.GetAnchorPoint(nil, widget, side, pixelOffset)
  self.gameObject = Game.AssetManager_UI:CreateAsset("GUI/v1/part/ItemSecendFuncBord", parent)
  if self.gameObject then
    self.gameObject.transform.position = pos
  end
  self:Init()
end
function ItemSecendFuncBord:Init()
  local grid = self:FindComponent("Grid", UIGrid)
  self.buttonCtl = UIGridListCtrl.new(grid, ItemFuncButtonCell, "ItemFuncButtonCell")
  self.buttonCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)
  self.title = self:FindComponent("Title", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.closeCheck = self:FindGO("CloseCheck")
  self:AddClickEvent(self.closeCheck, function(go)
    self:OnExit()
  end)
  self.original_Size_H = 106
  OverseaHostHelper:FixLabelOverV1(self.title, 3, 200)
  self.title.height = 40
  OverseaHostHelper:FixAnchor(self.title.topAnchor, self.bg.transform, 1, -16)
  OverseaHostHelper:FixAnchor(self.title.bottomAnchor, self.bg.transform, 1, -56)
end
function ItemSecendFuncBord:ClickButton(cell)
  self:PassEvent(MouseEvent.MouseClick, cell.data)
end
function ItemSecendFuncBord:SetTitle(title)
  self.title.text = title
end
function ItemSecendFuncBord:SetData(configs, itemdata)
  local buttonDatas = {}
  for i = 1, #configs do
    local cfgdata = GameConfig.ItemFunction[configs[i]]
    local state, otherName = FunctionItemFunc.Me():CheckFuncState(cfgdata.type, itemdata)
    if state == ItemFuncState.Active or state == ItemFuncState.Grey then
      local t = {}
      for k, v in pairs(cfgdata) do
        t[k] = v
      end
      if otherName then
        t.name = otherName
      end
      table.insert(buttonDatas, t)
    end
  end
  self.buttonCtl:ResetDatas(buttonDatas)
  local addH = 80 * #buttonDatas
  self.bg.height = addH + self.original_Size_H
end
function ItemSecendFuncBord:OnExit()
  self:PassEvent(ItemSecendFuncEvent.Close)
end
function ItemSecendFuncBord:OnDestroy()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
  end
end
