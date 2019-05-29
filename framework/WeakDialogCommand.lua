WeakDialogCommand = class("WeakDialogCommand", pm.SimpleCommand)
function WeakDialogCommand:execute(note)
  local data = note.body
  local _WeakDialogView = WeakDialogView
  if _WeakDialogView == nil then
    autoImport("WeakDialogView")
    _WeakDialogView = WeakDialogView
  end
  _WeakDialogView.Enqueue(data)
  local panelConfig = PanelConfig.WeakDialogView
  if UIManagerProxy.Instance:HasUINode(panelConfig) then
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {view = panelConfig})
end
