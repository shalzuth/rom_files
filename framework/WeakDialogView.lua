WeakDialogView = class("WeakDialogView", BaseView)
WeakDialogView.ViewType = UIViewType.PopUpLayer
autoImport("WeakDialogCell")
WeakDialogView.WaitQueue = {}
function WeakDialogView.QueueLength()
  return #WeakDialogView.WaitQueue
end
function WeakDialogView.Enqueue(data)
  table.insert(WeakDialogView.WaitQueue, data)
end
function WeakDialogView.Dequeue()
  table.remove(WeakDialogView.WaitQueue, 1)
end
function WeakDialogView:PlayWeakDialog()
  local WaitQueue = WeakDialogView.WaitQueue
  if WaitQueue[1] == nil then
    return
  end
  if not self.weakDialogCell then
    local weakDialogBord = self:FindGO("WeakDialogBord")
    local obj = self:LoadPreferb("cell/WeakDialogCell", weakDialogBord)
    self.weakDialogCell = WeakDialogCell.new(obj)
    self.weakDialogCell:AddEventListener(WeakDialogEvent.Hide, self.HandleWeakDialogHide, self)
  end
  self.weakDialogCell:Show()
  self.weakDialogCell:SetData(WaitQueue[1])
end
function WeakDialogView:HandleWeakDialogHide(data)
  WeakDialogView.Dequeue()
  if WeakDialogView.QueueLength() == 0 then
    self:CloseSelf()
  else
    self:PlayWeakDialog()
  end
end
function WeakDialogView:OnEnter()
  self:PlayWeakDialog()
end
function WeakDialogView:OnExit()
  WeakDialogView.super.OnExit(self)
  if self.weakDialogCell then
    self.weakDialogCell:OnDestroy()
  end
end
