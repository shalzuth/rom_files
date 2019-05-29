autoImport("MainViewRecallCell")
MainViewRecallPage = class("MainViewRecallPage", SubView)
local _list = {}
local _mainViewRecallData = {}
function MainViewRecallPage:Init()
  self.topRightFuncGrid = self:FindGO("TopRightFunc2"):GetComponent(UIGrid)
  self.activityCtl = UIGridListCtrl.new(self.topRightFuncGrid, MainViewRecallCell, "MainViewRecallCell")
  self.activityCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)
  self:AddViewEvt()
  self:UpdateRecall()
end
function MainViewRecallPage:AddViewEvt()
  self:AddListenEvt(ServiceEvent.ActivityCmdStartGlobalActCmd, self.UpdateRecall)
end
function MainViewRecallPage:UpdateRecall()
  self:UpdateMainViewRecall(FriendProxy.Instance:CheckRecallActivity())
end
function MainViewRecallPage:UpdateMainViewRecall(isAdd)
  TableUtility.ArrayClear(_list)
  if isAdd then
    TableUtility.ArrayPushBack(_list, _mainViewRecallData)
  end
  self.activityCtl:ResetDatas(_list)
  self.topRightFuncGrid.repositionNow = true
end
function MainViewRecallPage:ClickButton()
  if #FriendProxy.Instance:GetRecallList() > 0 then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RecallContractView
    })
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RecallView
    })
  end
end
