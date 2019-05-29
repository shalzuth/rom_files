autoImport("RecommendPetTipCell")
RecommendPetTip = class("RecommendPetTip", BaseTip)
function RecommendPetTip:Init()
  self.title = self:FindComponent("title", UILabel)
  self.title.text = ZhString.PetAdventure_RecommendPet
  self.Des = self:FindComponent("desc", UILabel)
  self.Des.text = ZhString.PetAdventure_RecommendPetDes
  self.recommendTable = self:FindComponent("ctl", UITable)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.scrollview = self:FindComponent("sv", UIScrollView)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  self:InitView()
  TitleTip.super.Init(self)
end
function RecommendPetTip:InitView()
  self.Ctl = UIGridListCtrl.new(self.recommendTable, RecommendPetTipCell, "RecommendPetTipCell")
  self.recommendPetData = {}
end
function RecommendPetTip:SetData(data)
  self.callback = data.callback
  self:ShowTip(data)
end
function RecommendPetTip:ShowTip(data)
  if data then
    self.Ctl:ResetDatas(data)
    self.scrollview:ResetPosition()
    self.recommendTable:Reposition()
  end
end
function RecommendPetTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end
function RecommendPetTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
