PrepUICommand = class("PrepUICommand", pm.SimpleCommand)
autoImport("CoreView")
autoImport("TabView")
autoImport("BaseView")
autoImport("ContainerView")
autoImport("SubView")
autoImport("SubMediatorView")
autoImport("UIGridListCtrl")
autoImport("FloatAwardView")
autoImport("IconManager")
autoImport("QuestSymbolCheck")
autoImport("SubViewMap")
autoImport("TipManager")
autoImport("SceneUIManager")
autoImport("AAAManager")
autoImport("WrapCellHelper")
autoImport("WrapScrollViewHelper")
autoImport("FloatingPanel")
autoImport("InviteConfirmView")
autoImport("BlindMaskView")
autoImport("TipsView")
autoImport("ClickEffectView")
autoImport("UIScrollVCenterOnUtil")
autoImport("UIModelUtil")
autoImport("EnchantEquipUtil")
autoImport("CreateChatRoom")
autoImport("MediaPanel")
autoImport("VideoPanel")
autoImport("UIMultiModelUtil")
autoImport("ComboCtl")
function PrepUICommand:execute(notifi)
  QuestSymbolCheck.new()
  SubViewMap.new()
  SceneUIManager.new()
  TipManager.new()
  UIModelUtil.new()
  EnchantEquipUtil.new()
  UIMultiModelUtil.new()
  ComboCtl.new()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "SceneNameView"
  })
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "FloatingPanel"
  })
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "DragCursorPanel"
  })
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "UIWarning"})
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "InviteConfirmView"
  })
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "BlindMaskView"
  })
end
