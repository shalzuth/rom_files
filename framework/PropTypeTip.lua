autoImport("BaseTip")
autoImport("PropTypeCell")
PropTypeTip = class("PropTypeTip", BaseTip)
local tempVector3 = LuaVector3.zero
function PropTypeTip:Init()
  PropTypeTip.super.Init(self)
  self:initView()
  self:initData()
end
function PropTypeTip:initView()
  local grid = self:FindComponent("PropTypeGrid", UIGrid)
  self.propGrid = UIGridListCtrl.new(grid, PropTypeCell, "PropTypeCell")
  self.propGrid:AddEventListener(MouseEvent.MouseClick, self.PropClick, self)
  grid = self:FindComponent("KeywordGrid", UIGrid)
  self.keyworkGrid = UIGridListCtrl.new(grid, PropTypeCell, "PropTypeCell")
  self.keyworkGrid:AddEventListener(MouseEvent.MouseClick, self.KeyworkClick, self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  self:AddButtonEvent("ConfirmBtn", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("ResetBtn", function()
    local cells = self.propGrid:GetCells()
    for i = 1, #cells do
      cells[i]:SetIsSelect(false)
    end
    self.keyworkGrid:ResetDatas({})
    self:Show(self.emptyCt)
    if self.callback then
      self.callback(self.callbackParam)
    end
    self.PropData = nil
  end)
  self.firstContent = self:FindGO("firstContent")
  self.secondContent = self:FindGO("secondContent")
  local ResetBtnLabel = self:FindComponent("ResetBtnLabel", UILabel)
  ResetBtnLabel.text = ZhString.SetViewSecurityPage_SecurityResetBtnText
  self.ConfirmBtnLabel = self:FindComponent("ConfirmBtnLabel", UILabel)
  self.ConfirmBtnLabel.text = ZhString.CommonZhString_Close
  local firstContentTitle = self:FindComponent("firstContentTitle", UILabel)
  firstContentTitle.text = ZhString.AdventureHomePage_PropTitle
  local secondContentTitle = self:FindComponent("secondContentTitle", UILabel)
  secondContentTitle.text = ZhString.AdventureHomePage_PropKeyworkTitle
  self.ConfirmBtnBg = self:FindComponent("ConfirmBtnbg", UISprite)
  self.emptyCt = self:FindGO("emptyCt")
  local emptyDes = self:FindComponent("emptyDes", UILabel)
  emptyDes.text = ZhString.AdventureHomePage_PropKeyEmptyTitle
  self:Show(self.emptyCt)
  OverseaHostHelper:FixLabelOverV1(emptyDes, 3, 280)
end
function PropTypeTip:ChooseEvent()
  local cells = self.keyworkGrid:GetCells()
  local tb = {}
  for i = 1, #cells do
    local single = cells[i]
    if single.isSelected then
      tb[#tb + 1] = single.data
    end
  end
  if self.callback then
    self.callback(self.callbackParam, self.PropData, tb)
  end
end
function PropTypeTip:PropClick(ctr)
  if ctr and ctr.data then
    ctr:SetIsSelect(true)
    local cells = self.propGrid:GetCells()
    for i = 1, #cells do
      if cells[i] ~= ctr then
        cells[i]:SetIsSelect(false)
      end
    end
    local datas = AdventureDataProxy.Instance:getKeywords(ctr.indexInList, ctr.data)
    local result = {}
    if datas and datas.subTable then
      for k, v in pairs(datas.subTable) do
        for k1, v1 in pairs(v) do
          result[#result + 1] = v1
        end
      end
    end
    self.keyworkGrid:ResetDatas(result)
    cells = self.keyworkGrid:GetCells()
    for i = 1, #cells do
      cells[i]:SetIsSelect(false)
    end
    self:Hide(self.emptyCt)
    self.PropData = datas
    self:ChooseEvent()
    return
  end
  self:Show(self.emptyCt)
end
function PropTypeTip:KeyworkClick(ctr)
  if ctr and ctr.data then
    ctr:SetIsSelect(not ctr.isSelected)
    self:ChooseEvent()
  end
end
function PropTypeTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end
function PropTypeTip:SetData(data)
  self.callback = data.callback
  self.callbackParam = data.param
end
function PropTypeTip:initData()
  self.propGrid:ResetDatas(GameConfig.AdventurePropClassify)
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.firstContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.firstContent.transform)
  y = y - height - 30
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  tempVector3:Set(x1, y, z1)
  self.secondContent.transform.localPosition = tempVector3
end
function PropTypeTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function PropTypeTip:CloseSelf(data)
  if self.callback and data then
    local cells = self.keyworkGrid:GetCells()
    local tb = {}
    for i = 1, #cells do
      local single = cells[i]
      if single.isSelected then
        tb[#tb + 1] = single.data
      end
    end
    self.callback(self.callbackParam, data, tb)
  end
  self.PropData = nil
  TipsView.Me():HideCurrent()
end
function PropTypeTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
