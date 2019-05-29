FunctionNetError = class("FunctionNetError")
FunctionNetError.BackToLogin = "FunctionNetError.BackToLogin"
FunctionNetError.FeedBackType = {
  ErrorBackToLogin = 1,
  SimpleError = 2,
  ErrorBackToLogo = 3,
  ErrorNoConnectSerVer = 5
}
local ArrayPushBack = TableUtility.ArrayPushBack
function FunctionNetError.Me()
  if nil == FunctionNetError.me then
    FunctionNetError.me = FunctionNetError.new()
  end
  return FunctionNetError.me
end
function FunctionNetError:ctor()
  self.FeedbackCall = {}
  self.FeedbackCall[FunctionNetError.FeedBackType.ErrorBackToLogin] = self.ErrorBackToLogin
  self.FeedbackCall[FunctionNetError.FeedBackType.SimpleError] = self.SimpleError
  self.FeedbackCall[FunctionNetError.FeedBackType.ErrorBackToLogo] = self.ErrorBackToLogo
end
function FunctionNetError:ShowErrorById(id, params, lockreason)
  local config = Table_NetError[id]
  if config then
    local param = ReusableTable.CreateArray()
    if params ~= nil and (id == ErrorUserCmd_pb.REG_ERR_ACC_FORBID or id == ErrorUserCmd_pb.REG_ERR_FORBID_REG) and #params > 0 then
      local time = os.date("*t", params[1])
      ArrayPushBack(param, time.year)
      ArrayPushBack(param, time.month)
      ArrayPushBack(param, time.day)
    end
    self:ShowError(config.Feedback, config.CancelFeedBack, config.Sysmsg, param, lockreason)
    ReusableTable.DestroyAndClearArray(param)
  else
    self:ShowErrorMsg(2, string.format(ZhString.FunctionNetError_UnKnownError, id))
  end
end
function FunctionNetError:ShowErrorMsg(feedBackType, msg)
  MsgManager.ConfirmMsgTableParam("Error", msg, {
    confirmHandler = function()
      if self.FeedbackCall[feedBackType] ~= nil then
        self.FeedbackCall[feedBackType](self)
      end
    end
  }, nil, {})
end
function FunctionNetError:ShowError(feedBackType, cancelFeedBack, msgID, param, lockreason)
  if feedBackType == FunctionNetError.FeedBackType.ErrorBackToLogo then
    PlayerPrefs.SetInt("NeedSDKLogout", 1)
  end
  if feedBackType == FunctionNetError.FeedBackType.ErrorBackToLogin or feedBackType == FunctionNetError.FeedBackType.ErrorBackToLogo or feedBackType == FunctionNetError.FeedBackType.ErrorNoConnectSerVer then
    UIWarning.Instance:HideBord()
    self:DisConnect()
  end
  local cancelHandler
  if cancelFeedBack ~= nil then
    function cancelHandler()
      if self.FeedbackCall[cancelFeedBack] ~= nil then
        self.FeedbackCall[cancelFeedBack](self)
      end
    end
  end
  MsgManager.ShowMsgByIDTable(msgID, {
    confirmHandler = function()
      if self.FeedbackCall[feedBackType] ~= nil then
        self.FeedbackCall[feedBackType](self)
      end
    end,
    cancelHandler = cancelHandler,
    unpack(param)
  }, nil, lockreason)
end
function FunctionNetError:ErrorBackToLogo()
  if AppEnvConfig.IsTestApp then
    UIWarning.Instance:HideBord()
    return
  end
  Game.Me():BackToLogo()
end
function FunctionNetError:ErrorBackToLogin()
  if AppEnvConfig.IsTestApp then
    UIWarning.Instance:HideBord()
    return
  end
  if Application.loadedLevelName == "CharacterSelect" then
    self:DisConnect()
    Game.Me():BackToLogin()
  else
    self:ErrorBackToLogo()
  end
end
function FunctionNetError:SimpleError()
end
function FunctionNetError:DisConnect()
  ServiceConnProxy.Instance:StopHeart()
end
function FunctionNetError:Clear()
  self:ClearUI()
  self:ClearScene()
  GameObjPool.Instance:ClearAll()
end
function FunctionNetError:ClearUI()
  local ui = GameObject.Find("UIRoot")
  if ui ~= nil then
    GameObject.Destroy(ui)
  end
end
function FunctionNetError:ClearScene()
  SceneObjectProxy.ClearAll()
end
