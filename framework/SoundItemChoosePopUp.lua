SoundItemChoosePopUp = class("SoundItemChoosePopUp", BaseView)
SoundItemChoosePopUp.ViewType = UIViewType.PopUpLayer
autoImport("SoundItemCell")
function SoundItemChoosePopUp:Init()
  self:InitUI()
  self:MapEvent()
  self.npc = self.viewdata.viewdata.npc
end
function SoundItemChoosePopUp:InitUI()
  local grid = self:FindComponent("SoundListGrid", UIGrid)
  self.soundItemCtl = UIGridListCtrl.new(grid, SoundItemCell, "SoundItemCell")
  self.soundItemCtl:AddEventListener(SoundItemCellEvent.Play, self.ChoosePlay, self)
  self.soundItemCtl:AddEventListener(SoundItemCellEvent.Buy, self.ChooseBuy, self)
  self:UpdateSoundItems()
end
function SoundItemChoosePopUp:UpdateSoundItems()
  local soundItems = {}
  local bagProxy = BagProxy.Instance
  for _, mdata in pairs(Table_MusicBox) do
    local item = BagProxy.Instance:GetItemByStaticID(mdata.id)
    if not item and mdata.SaleChannel ~= 0 then
      item = ItemData.new("SoundItem", mdata.id)
    end
    table.insert(soundItems, item)
  end
  table.sort(soundItems, function(a, b)
    local hasA = a.id ~= "SoundItem"
    local hasB = b.id ~= "SoundItem"
    if hasA ~= hasB then
      return hasA
    end
    return a.staticData.id < b.staticData.id
  end)
  self.soundItemCtl:ResetDatas(soundItems)
end
function SoundItemChoosePopUp:ChoosePlay(cellctl)
  if cellctl.data then
    do
      local id = cellctl.data.staticData.id
      local soundName = cellctl.data.staticData.NameZh
      MsgManager.ConfirmMsgByID(821, function()
        ServiceNUserProxy.Instance:CallDemandMusic(self.npc.data.id, id)
        AudioUtil.Play2DRandomSound(AudioMap.Maps.PlayMusic)
        self:CloseSelf()
      end, nil, nil, soundName)
    end
  else
  end
end
function SoundItemChoosePopUp:ChooseBuy(cellctl)
  if cellctl.data then
    local sid = cellctl.data.staticData.id
    local musicData = Table_MusicBox[sid]
    if musicData then
      if musicData.SaleChannel == 1 then
        HappyShopProxy.Instance:BuyShopItem(shopID, count)
      elseif musicData.SaleChannel == 2 then
        FuncShortCutFunc.Me():CallByID(26)
        self:CloseSelf()
      elseif musicData.SaleChannel == 3 then
        FuncShortCutFunc.Me():CallByID(26)
        self:CloseSelf()
      end
    end
  end
end
function SoundItemChoosePopUp:MapEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateSoundItems)
end
