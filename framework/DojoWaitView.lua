autoImport("ListCtrl")
autoImport("CarrierWaitListCell")
DojoWaitView = class("DojoWaitView", ContainerView)
DojoWaitView.ViewType = UIViewType.PopUpLayer
function DojoWaitView:Init()
  self.waitCell = self:LoadPreferb("cell/WaitCell", self.gameObject)
  self.waitCell.transform.localPosition = Vector3.zero
  self:FindObjs()
  self:AddBtnEvents()
  self:AddViewEvts()
  self:InitShow()
end
function DojoWaitView:FindObjs()
  self.startBtn = self:FindGO("StartBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.waitGrid = self:FindGO("WaitList"):GetComponent(UIGrid)
  self.waitList = ListCtrl.new(self.waitGrid, CarrierWaitListCell, "CarrierWaitListCell")
end
function DojoWaitView:AddBtnEvents()
  self:AddClickEvent(self.startBtn, function(go)
    ServiceDojoProxy.Instance:CallEnterDojo(self.dojoid, Game.Myself.data.id)
    self:sendNotification(DojoEvent.EnterSuccess)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.cancelBtn, function(go)
    ServiceDojoProxy.Instance:CallDojoSponsorCmd(self.dojoid, true)
    self:CloseSelf()
  end)
end
function DojoWaitView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.DojoDojoReplyCmd, self.MemberAgree)
  self:AddListenEvt(DojoEvent.EnterSuccess, self.CloseSelf)
end
function DojoWaitView:InitShow()
  if self.viewdata.viewdata then
    self.dojoid = self.viewdata.viewdata
  end
  self:UpdateWait()
end
function DojoWaitView:UpdateWait()
  local members = DojoProxy.Instance:GetWaitData()
  self.waitList:ResetDatas(members)
end
function DojoWaitView:MemberAgree(note)
  local member = note.body
  local agree = true
  if member.eReply == Dojo_pb.EDOJOREPLY_DISAGREE then
    agree = false
  end
  local cells = self.waitList:GetCells()
  for i = 1, #cells do
    if cells[i].data.id == member.userid then
      cells[i]:Agree(agree)
      break
    end
  end
end
