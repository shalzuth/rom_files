autoImport("FunctionLoginBase")
FunctionLoginTXWY = class("FunctionLoginTXWY",FunctionLoginBase)

function FunctionLoginTXWY.Me()
    if nil == FunctionLoginTXWY.me then
        FunctionLoginTXWY.me = FunctionLoginTXWY.new()
    end
    return FunctionLoginTXWY.me
end

function FunctionLoginTXWY:startSdkGameLogin(callback)
    -- body
    --TODO 登陆 重新登陆
    LogUtility.InfoFormat("startSdkGameLogin:isLogined:{0}",self:isLogined())
    local isLogined = self:isLogined()
    if(not isLogined)then
        self:startSdkLogin(function (code,msg)
            -- body
            self:SdkLoginHandler(code,msg,function (  )
                -- body
                self:startAuthAccessToken(function (  )
                    -- body
                    -- self:startGameLogin(serverData)
                    if(callback)then
                        callback()
                    end
                end)
            end)
        end)
        --登陆成功
    elseif(not self.loginData)then
        self:startAuthAccessToken(function (  )
            -- body
            -- self:startGameLogin(serverData)
            if(callback)then
                callback()
            end
        end)
    else
        if(callback)then
            callback()
        end
    end
end

function FunctionLoginTXWY:startAuthAccessToken(callback)
    -- body
--    Debug.Log('FunctionLoginTXWY startAuthAccessToken');
    GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
    self.callback = callback
    self:RequestAuthAccToken()
end


function FunctionLoginTXWY:RequestAuthAccToken()
    -- body
    OverseaHostHelper:RefreshPriceInfo()
    local sid = self:getToken()
    if(sid)then
        local version = self:getServerVersion()
        local plat = self:GetPlat()
        local clientCode = CompatibilityVersion.version
        local clientV2Code = 0
        pcall(function ()
            clientV2Code = OverseaHostHelper:getClientV2Code()
        end)
    
        pcall(function()
            -- body
            clientCode = CompatibilityVersion.overseaVersion
        end)
        local url = string.format("%s/auth?sid=%s&p=%s&sver=%s&cver=%s&lang=%s&blueberry=%s",NetConfig.NewAccessTokenAuthHost[1],sid,plat,version,clientCode,
            ApplicationInfo.GetSystemLanguage(),clientV2Code)
        local order = HttpWWWRequestOrder(url,NetConfig.HttpRequestTimeOut,nil,false,true)
        if(order) then
            order:SetCallBacks(function(response)
                GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
                self:LoginDataHandler(NetConfig.ResponseCodeOk,response.resString,self.callback)
            end,
                function ( order )
                    GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
                    self:LoginDataHandler(FunctionLogin.AuthStatus.OherError,"",self.callback)
                end,
                function ( order )
                    GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
                    self:LoginDataHandler(FunctionLogin.AuthStatus.OherError,"",self.callback)
                end)
            Game.HttpWWWRequest:RequestByOrder (order);
        end
        
    else
        MsgManager.ShowMsgByIDTable(1017,{FunctionLogin.ErrorCode.RequestAuthAccToken_NoneToken})
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    end
end