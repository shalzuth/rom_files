autoImport("BaseTip")
autoImport("ExchangeCombineItemCell")
FeedPetTip = class("FeedPetTip", BaseTip)
local PACKAGE_CHECK = GameConfig.PackageMaterialCheck.equipcompose
local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
function FeedPetTip:Init()
  self:FindObj()
  self:AddEvts()
  self:InitView()
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.Update, self)
end
function FeedPetTip:InitView()
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 4,
    cellName = "ExchangeCombineItemCell",
    control = ExchangeCombineItemCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
end
function FeedPetTip:FindObj()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  FeedPetTip.super.Init(self)
end
function FeedPetTip:AddEvts()
  self:AddClickEvent(self.confirmBtn, function(go)
    self:OnClickConfirm()
  end)
  self:AddClickEvent(self.cancelBtn, function(go)
    self:CloseSelf()
  end)
end
function FeedPetTip:SetData(data)
  self.data = data
  if not self.data then
    return
  end
  self.petinfoData = data.petinfoData
  self:Update()
end
function FeedPetTip:Update()
  local goods = FunctionPet.Me():GetAllHobbyItems()
  if not goods then
    return
  end
  local itemDatas = {}
  for i = 1, #goods do
    itemDatas[#itemDatas + 1] = ItemData.new("FeedPet", goods[i])
  end
  table.sort(itemDatas, function(a, b)
    local aOwned = BagProxy.Instance:GetItemNumByStaticID(a.staticData.id, PACKAGE_CHECK) > 0
    local bOwned = BagProxy.Instance:GetItemNumByStaticID(b.staticData.id, PACKAGE_CHECK) > 0
    if aOwned and bOwned then
      return a.staticData.id > b.staticData.id
    end
    if aOwned or bOwned then
      return aOwned
    end
    return a.staticData.id > b.staticData.id
  end)
  self.itemWrapHelper:ResetDatas(ReUniteCellData(itemDatas, 4))
end
function FeedPetTip:SetChoose(id)
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local single = cells[i]:GetCells()
    for j = 1, #single do
      single[j]:SetChoosen(id)
    end
  end
end
function FeedPetTip:OnClickCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  local ownCount = BagProxy.Instance:GetItemNumByStaticID(data.staticData.id, PACKAGE_CHECK)
  if not ownCount or 0 == ownCount then
    return
  end
  if data.staticData.id == self.chooseID then
    self.chooseID = nil
  else
    self.chooseID = data.staticData.id
  end
  self:SetChoose(self.chooseID)
end
function FeedPetTip:OnClickConfirm()
  if not self.chooseID then
    return
  end
  local myPetInfo = PetProxy.Instance:GetMyPetInfoData(self.petinfoData.petid)
  for i = 1, #PACKAGE_CHECK do
    local item = BagProxy.Instance:GetItemByStaticID(self.chooseID, PACKAGE_CHECK[i])
    if nil ~= item then
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(9015)
      if dont == nil then
        MsgManager.DontAgainConfirmMsgByID(9015, function()
          ServiceScenePetProxy.Instance:CallGiveGiftPetCmd(myPetInfo.petid, item.id)
        end, nil, nil, item.staticData.NameZh, myPetInfo.name)
        break
      end
      ServiceScenePetProxy.Instance:CallGiveGiftPetCmd(myPetInfo.petid, item.id)
      break
    else
    end
  end
end
function FeedPetTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.Update, self)
  TipsView.Me():HideCurrent()
end
function FeedPetTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
