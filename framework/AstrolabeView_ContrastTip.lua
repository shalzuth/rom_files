AstrolabeView_ContrastTip = class("AstrolabeView_ContrastTip", BaseTip)
autoImport("AstrolabeView_ContrastCell")
AstrolabeView_ContrastTip.ViewType = UIViewType.PopUpLayer
local config_PropName = Game.Config_PropName
function AstrolabeView_ContrastTip:Init()
  self:InitView()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    TipsView.Me():HideCurrent()
  end
end
function AstrolabeView_ContrastTip:InitView()
  local leftBord = self:FindGO("LeftBord")
  local left_Grid = self:FindComponent("AttriGrid", UIGrid, leftBord)
  self.leftAttriCtl = UIGridListCtrl.new(left_Grid, AstrolabeView_ContrastCell, "AstrolabeView_ContrastCell")
  self.leftTotalCount = self:FindComponent("LeftTotalCount", UILabel, leftBord)
  local costGO1 = self:FindGO("CostGrid", leftBord)
  self.leftCost1 = self:FindGO("CostInfoCell1", costGO1)
  self.leftCost1_label = self:FindComponent("Label", UILabel, self.leftCost1)
  self.leftCost1_symbol = self:FindComponent("Symbol", UISprite, self.leftCost1)
  IconManager:SetItemIcon("item_140", self.leftCost1_symbol)
  self.leftCost2 = self:FindGO("CostInfoCell2", costGO1)
  self.leftCost2_label = self:FindComponent("Label", UILabel, self.leftCost2)
  self.leftCost2_symbol = self:FindComponent("Symbol", UISprite, self.leftCost2)
  IconManager:SetItemIcon("item_5261", self.leftCost2_symbol)
  self.leftNoneTip = self:FindGO("NoneTip", leftBord)
  local rightBord = self:FindGO("RightBord")
  local right_Grid = self:FindComponent("AttriGrid", UIGrid, rightBord)
  self.rightAttriCtl = UIGridListCtrl.new(right_Grid, AstrolabeView_ContrastCell, "AstrolabeView_ContrastCell")
  self.rightTotalCount = self:FindComponent("RightTotalCount", UILabel, rightBord)
  local costGO2 = self:FindGO("CostGrid", rightBord)
  self.rightCost1 = self:FindGO("CostInfoCell1", costGO2)
  self.rightCost1_label = self:FindComponent("Label", UILabel, self.rightCost1)
  self.rightCost1_symbol = self:FindComponent("Symbol", UISprite, self.rightCost1)
  IconManager:SetItemIcon("item_140", self.rightCost1_symbol)
  self.rightCost2 = self:FindGO("CostInfoCell2", costGO2)
  self.rightCost2_label = self:FindComponent("Label", UILabel, self.rightCost2)
  self.rightCost2_symbol = self:FindComponent("Symbol", UISprite, self.rightCost2)
  IconManager:SetItemIcon("item_5261", self.rightCost2_symbol)
  self.rightNoneTip = self:FindGO("NoneTip", rightBord)
  local t = self:FindGO("Title", self:FindGO("Bg")):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(t, 2, 300)
  t.transform.localPosition = Vector3(0, 277.3, 0)
end
function AstrolabeView_ContrastTip:UpdateView()
  if self.leftDatas == nil then
    self.leftDatas = {}
  else
    TableUtility.TableClear(self.leftDatas)
  end
  local totalCount, totalCost = self:_HelpUpdateAttris(self.leftAttriCtl, self.savedata, self.leftDatas, self.leftNoneTip)
  self.leftTotalCount.text = string.format(ZhString.AstrolabeView_ContrastTip_SaveTotalCount, totalCount)
  self.leftCost1_label.text = totalCost[140] or 0
  self.leftCost2_label.text = totalCost[5261] or 0
  if self.rightDatas == nil then
    self.rightDatas = {}
  else
    TableUtility.TableClear(self.rightDatas)
  end
  local totalCount, totalCost = self:_HelpUpdateAttris(self.rightAttriCtl, self.newdata, self.rightDatas, self.rightNoneTip)
  self.rightTotalCount.text = string.format(ZhString.AstrolabeView_ContrastTip_NewTotalCount, totalCount)
  self.rightCost1_label.text = totalCost[140] or 0
  self.rightCost2_label.text = totalCost[5261] or 0
end
local tempTable = {}
function AstrolabeView_ContrastTip:_HelpUpdateAttris(ctl, srcdata, destdata, noneTip)
  local totalCount, totalCost = 0, {}
  TableUtility.TableClear(tempTable)
  local pointData, effectMap, cost, cid, cv
  for pid, _ in pairs(srcdata) do
    pointData = self.bordData:GetPointByGuid(pid)
    effectMap = pointData:GetEffect()
    if effectMap == nil then
      redlog(string.format("not find effect. id:(%s)", pid))
    else
      for ectType, value in pairs(effectMap) do
        tempTable[ectType] = tempTable[ectType] or 0
        tempTable[ectType] = tempTable[ectType] + value
      end
    end
    totalCount = totalCount + 1
    cost = pointData:GetCost()
    for i = 1, #cost do
      cid, cv = cost[i][1], cost[i][2]
      totalCost[cid] = totalCost[cid] or 0
      totalCost[cid] = totalCost[cid] + cv
    end
  end
  local insertSort = TableUtility.InsertSort
  for k, v in pairs(tempTable) do
    tempTable[k] = nil
    insertSort(destdata, {k, v}, function(l, r)
      return config_PropName[l[1]].id < config_PropName[r[1]].id
    end)
  end
  ctl:ResetDatas(destdata)
  if noneTip then
    noneTip:SetActive(#destdata == 0)
  end
  return totalCount, totalCost
end
function AstrolabeView_ContrastTip:SetData(data)
  if data == nil then
    self.bordData = AstrolabeProxy.Instance:GetCurBordData()
    self.newdata = {}
    self.savedata = {}
  else
    self.bordData = data.bordData
    self.newdata = data.newdata
    self.savedata = data.savedata
  end
  self:UpdateView()
end
function AstrolabeView_ContrastTip:DestroySelf()
  GameObject.Destroy(self.gameObject)
end
