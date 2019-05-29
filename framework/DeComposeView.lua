DeComposeView = class("DeComposeView", BaseView)
autoImport("ItemData")
autoImport("EquipChooseBord")
autoImport("DecomposeItemCell")
DeComposeView.ViewType = UIViewType.NormalLayer
local ACTION_DECOMPOSE = "functional_action"
local tempV3 = LuaVector3()
function DeComposeView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcguid = viewdata and viewdata.npcdata and viewdata.npcdata.data.id
  self:InitUI()
  self:MapEvent()
end
function DeComposeView:InitUI()
  self.decomposeBord = self:FindGO("DecomposeBord")
  self.targetBtn = self:FindGO("TargetCell", self.decomposeBord)
  self.targetCell = BaseItemCell.new(self.targetBtn)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.clickTargetCell, self)
  self.tiplabel = self:FindComponent("TipLabel2", UILabel)
  self.resultGrid = self:FindComponent("ResultGrid", UIGrid)
  self.resultCtl = UIGridListCtrl.new(self.resultGrid, DecomposeItemCell, "DecomposeItemCell")
  self.resultCtl:AddEventListener(MouseEvent.MouseClick, self.clickResultCell, self)
  self.businessTip = self:FindGO("BusinessTip")
  self.businessTip_1 = self:FindComponent("Tip1", UILabel)
  self.businessTip_2 = self:FindComponent("Tip2", UILabel)
  self.cost = self:FindComponent("Cost", UILabel)
  local coins = self:FindChild("TopCoins")
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
  self.bg = self:FindComponent("Bg", UISprite)
  self.decomoposeTip = self:FindComponent("DecomposeTipLabel", UILabel)
  self.decomoposeTip.text = ZhString.DeComposeView_DecomposeTip
  self.waittingSymbol = self:FindGO("WaittingSymbol")
  local chooseContaienr = self:FindGO("ChooseContainer")
  local chooseBordDataFunc = function()
    return self:GetDecomposeEquips()
  end
  self.chooseBord = EquipChooseBord.new(chooseContaienr, chooseBordDataFunc)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.addbord = self:FindGO("AddBord")
  self.addItemButton = self:FindGO("AddItemButton", self.addbord)
  self:AddClickEvent(self.addItemButton, function(go)
    self:clickTargetCell()
  end)
  self.colliderMask = self:FindGO("ColliderMask")
  self:AddButtonEvent("StartButton", function(go)
    if self.nowdata then
      self:DoDeCompose()
    else
      MsgManager.ShowMsgByIDTable(400)
    end
  end)
  self:AddButtonEvent("CloseChoose", function(go)
    self.chooseBord:SetActive(false)
  end)
end
function DeComposeView:OnEnter()
  DeComposeView.super.OnEnter(self)
  local npcinfo = self:GetCurNpc()
  if npcinfo then
    local npcRootTrans = npcinfo.assetRole.completeTransform
    if npcRootTrans then
      self:CameraFocusOnNpc(npcRootTrans)
    end
  end
  self:UpdateCoins()
end
function DeComposeView:OnExit()
  self:CameraReset()
  DeComposeView.super.OnExit(self)
end
function DeComposeView:GetCurNpc()
  if self.npcguid then
    return NSceneNpcProxy.Instance:Find(self.npcguid)
  end
  return nil
end
function DeComposeView:DoDeCompose()
  if not self.nowdata then
    return
  end
  FunctionSecurity.Me():NormalOperation(function()
    local npcinfo = self:GetCurNpc()
    if npcinfo then
      npcinfo:Client_PlayAction(ACTION_DECOMPOSE, nil, false)
    end
    ServiceItemProxy.Instance:CallEquipDecompose(self.nowdata.id)
  end, {
    itemData = nowData
  })
end
local _isEquipClean
function DeComposeView:GetDecomposeEquips()
  local equips = {}
  local bagEquips = BagProxy.Instance:GetBagEquipItems()
  TableUtil.InsertArray(equips, bagEquips)
  local result = {}
  for i = 1, #bagEquips do
    local equip = bagEquips[i]
    if equip.equipInfo == nil then
      error("EquipInfo is nil " .. equip.staticData.NameZh)
    end
    if equip.equipInfo.equipData.DecomposeID ~= nil and BagProxy.Instance:CheckIfFavoriteCanBeMaterial(bagEquips[i]) ~= false then
      table.insert(result, equip)
    end
  end
  if _isEquipClean == nil then
    _isEquipClean = BagProxy.CheckEquipIsClean
  end
  table.sort(result, function(a, b)
    local aNeedRecover = not _isEquipClean(a, true)
    local bNeedRecover = not _isEquipClean(b, true)
    if aNeedRecover == bNeedRecover then
      local aDeComposeId = a.equipInfo.equipData.DecomposeID
      local bDeComposeId = b.equipInfo.equipData.DecomposeID
      return aDeComposeId < bDeComposeId
    end
    return not aNeedRecover
  end)
  return result
end
function DeComposeView:clickTargetCell()
  local equipdatas = self:GetDecomposeEquips()
  if #equipdatas > 0 then
    self.chooseBord:ResetDatas(equipdatas, true)
    self.chooseBord:Show(false, nil, nil, DeComposeView.checkValidEquipFunc, nil, ZhString.DeComposeView_InvalidTip)
  else
    MsgManager.ShowMsgByIDTable(409)
    self.chooseBord:Hide()
  end
end
function DeComposeView.checkValidEquipFunc(param, data)
  if not _isEquipClean(data, true) then
    return false, ZhString.DeComposeView_InvalidTip
  end
  return true
end
function DeComposeView:clickResultCell(cell)
  if not self.ShowTip then
    local callback = function()
      self.ShowTip = false
    end
    local sdata = {
      itemdata = cell.data,
      ignoreBounds = cell.gameObject,
      callback = callback
    }
    self:ShowItemTip(sdata, self.bg, NGUIUtil.AnchorSide.Left, {-180, 0})
  else
    self:ShowItemTip()
  end
  self.ShowTip = not self.ShowTip
end
function DeComposeView:ChooseItem(itemData)
  self.nowdata = itemData
  self.targetCell:SetData(itemData)
  self.resultCtl:ResetDatas({})
  if itemData then
    self.waittingSymbol:SetActive(true)
    local decomposeID = itemData.equipInfo.equipData.DecomposeID
    local decomposeData = decomposeID and Table_EquipDecompose[decomposeID]
    if decomposeData then
      local myRob = Game.Myself.data.userdata:Get(UDEnum.SILVER)
      local decomposeCost = decomposeData.Cost or 0
      if myRob < decomposeCost then
        self.cost.text = "[c]" .. CustomStrColor.BanRed .. tostring(decomposeData.Cost) .. "[-][/c]"
      else
        self.cost.text = tostring(decomposeData.Cost)
      end
    else
      self.cost.text = 0
    end
    ServiceItemProxy.Instance:CallQueryDecomposeResultItemCmd(itemData.id)
    self.decomposeBord:SetActive(true)
    self.addbord:SetActive(false)
  else
    self.cost.text = 0
    self.decomposeBord:SetActive(false)
    self.addbord:SetActive(true)
  end
  self.chooseBord:Hide()
end
function DeComposeView:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end
function DeComposeView:MapEvent()
  self:AddListenEvt(ServiceEvent.ItemEquipDecompose, self.HandleEquipCompose)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.ItemQueryDecomposeResultItemCmd, self.HandleItemQueryDecomposeResult)
end
function DeComposeView:HandleItemQueryDecomposeResult(note)
  self.waittingSymbol:SetActive(false)
  local results = note.body.results
  if self.resultData == nil then
    self.resultData = {}
  else
    TableUtility.ArrayClear(self.resultData)
  end
  for i = 1, #results do
    local single = results[i]
    local iteminfo = single.item
    local itemData = ItemData.new("Decompose", iteminfo.id)
    itemData:ParseFromServerData({base = iteminfo})
    itemData.minrate = single.min_count / 1000
    itemData.rate = single.rate / 1000
    itemData.maxrate = single.max_count / 1000
    table.insert(self.resultData, itemData)
  end
  self.resultCtl:ResetDatas(self.resultData)
  if CommonFun.calcOrideconResearch then
    local pct = CommonFun.calcOrideconResearch(Game.Myself.data) or 0
    if pct == 0 then
      self:SetBusinessTip(false)
    else
      pct = math.floor(pct * 1000) / 10
      self:SetBusinessTip(true, pct)
    end
  else
    self:SetBusinessTip(false)
  end
end
function DeComposeView:SetBusinessTip(active, pct)
  if active then
    tempV3:Set(0, 5, 0)
    self.resultGrid.transform.localPosition = tempV3
    self.businessTip:SetActive(true)
    self.businessTip_1.text = ZhString.DecomposeView_BusinessTip1
    self.businessTip_2.text = string.format(ZhString.DecomposeView_BusinessTip2, pct)
  else
    tempV3:Set(0, -10, 0)
    self.resultGrid.transform.localPosition = tempV3
    self.businessTip:SetActive(false)
  end
end
local EFFECTMAP_DECOMPOSE_RESULT = {
  [SceneItem_pb.EDECOMPOSERESULT_FAIL] = "equip_tex_01",
  [SceneItem_pb.EDECOMPOSERESULT_SUCCESS] = "equip_tex_02",
  [SceneItem_pb.EDECOMPOSERESULT_SUCCESS_BIG] = "equip_tex_03",
  [SceneItem_pb.EDECOMPOSERESULT_SUCCESS_SBIG] = "equip_tex_04",
  [SceneItem_pb.EDECOMPOSERESULT_SUCCESS_FANTASY] = "equip_tex_05"
}
function DeComposeView:HandleEquipCompose(note)
  self.nowdata = nil
  self.targetCell:SetData(self.nowdata)
  self.resultCtl:ResetDatas({})
  self:ChooseItem()
end
