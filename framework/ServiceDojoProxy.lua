autoImport("ServiceDojoAutoProxy")
ServiceDojoProxy = class("ServiceDojoProxy", ServiceDojoAutoProxy)
ServiceDojoProxy.Instance = nil
ServiceDojoProxy.NAME = "ServiceDojoProxy"
function ServiceDojoProxy:ctor(proxyName)
  if ServiceDojoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceDojoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceDojoProxy.Instance = self
  end
end
function ServiceDojoProxy:RecvDojoPrivateInfoCmd(data)
  DojoProxy.Instance:RecvDojoPrivateInfo(data)
  self:Notify(ServiceEvent.DojoDojoPrivateInfoCmd, data)
end
function ServiceDojoProxy:RecvDojoPublicInfoCmd(data)
  DojoProxy.Instance:RecvDojoPublicInfo(data)
  self:Notify(ServiceEvent.DojoDojoPublicInfoCmd, data)
end
function ServiceDojoProxy:RecvDojoAddMsg(data)
  DojoProxy.Instance:RecvAddMsg(data)
  self:Notify(ServiceEvent.DojoDojoAddMsg, data)
end
function ServiceDojoProxy:RecvDojoQueryStateCmd(data)
  if data.state == Dojo_pb.DOJOSTATE_OPENED then
    MsgManager.ConfirmMsgByID(2905, function()
      ServiceDojoProxy.Instance:CallEnterDojo()
      self:sendNotification(DojoEvent.EnterSuccess)
      LogUtility.Info("CallEnterDojo")
    end, nil, nil)
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.DojoGroupView)
  end
  self:Notify(ServiceEvent.DojoDojoQueryStateCmd, data)
end
function ServiceDojoProxy:RecvDojoRewardCmd(data)
  LogUtility.Info("RecvDojoRewardCmd")
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "BattleResultView",
    callback = function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.DojoResultPopUp,
        viewdata = data
      })
    end
  })
  DojoProxy.Instance:RecvDojoReward(data)
  self:Notify(ServiceEvent.DojoDojoRewardCmd, data)
end
