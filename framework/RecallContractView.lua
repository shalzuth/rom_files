autoImport("RecallItemCell")
RecallContractView = class("RecallContractView", ContainerView)
RecallContractView.ViewType = UIViewType.NormalLayer
local _bgName = "recall_bg_cat"
local _tipData = {}
_tipData.funcConfig = {}
function RecallContractView:OnExit()
  PictureManager.Instance:UnLoadRecall(_bgName, self.bg)
  RecallContractView.super.OnExit(self)
end
function RecallContractView:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end
function RecallContractView:FindObj()
  self.bg = self:FindGO("BgTexture"):GetComponent(UITexture)
  self.contractName = self:FindGO("ContractName"):GetComponent(UILabel)
end
function RecallContractView:AddButtonEvt()
  local addBtn = self:FindGO("AddBtn")
  self:AddClickEvent(addBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RecallContractSelectView
    })
  end)
  local contractBtn = self:FindGO("ContractBtn")
  self:AddClickEvent(contractBtn, function()
    if self.selectGuid ~= nil then
      local tempArray = ReusableTable.CreateArray()
      tempArray[1] = self.selectGuid
      ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Contract)
      ReusableTable.DestroyArray(tempArray)
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(3639)
    end
  end)
end
function RecallContractView:AddViewEvt()
  self:AddListenEvt(RecallEvent.Select, self.Select)
end
function RecallContractView:InitShow()
  PictureManager.Instance:SetRecall(_bgName, self.bg)
  local _GameConfigRecall = GameConfig.Recall
  local tip = self:FindGO("Tip", self.contractRoot):GetComponent(UILabel)
  tip.text = string.format(ZhString.Friend_RecallContractTip, #FriendProxy.Instance:GetRecallList(), _GameConfigRecall.ContractTime / 86400)
  local myName = self:FindGO("MyName"):GetComponent(UILabel)
  myName.text = Game.Myself.data.name
  local rewardRoot = self:FindGO("RewardRoot", self.contractRoot):GetComponent(UIGrid)
  local rewardCtl = UIGridListCtrl.new(rewardRoot, RecallItemCell, "RecallItemCell")
  rewardCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  local rewardList = ItemUtil.GetRewardItemIdsByTeamId(_GameConfigRecall.Reward)
  if rewardList ~= nil then
    rewardCtl:ResetDatas(rewardList)
  end
  ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
end
function RecallContractView:Select(note)
  local data = note.body
  if data then
    self.selectGuid = data.guid
    self.contractName.text = data:GetName()
  end
end
function RecallContractView:ClickItem(cell)
  local data = cell.data
  if data then
    _tipData.itemdata = data
    self:ShowItemTip(_tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
