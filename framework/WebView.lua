WebView = class("WebView")

function WebView:ctor()

end

-- function WebView:CreateView(go,config)
--     if self.webView or not go then return end
--     self.webView = ROWebView.CreateWebView(go)
--     self:ShouldClose(false)
-- end

-- function WebView:SetFrame(a,b,c,d)
--     if self.webView then
--         ROWebView.SetFrame(self.webView,a,b,c,d)
--     end 
-- end

-- function WebView:SetUserAgent(str)
--     if not self.webView then return end
--         ROWebView.SetUserAgent(self.webView,str)
-- end


-- function WebView:GetUserAgent()
--     if not self.webView then return end
--     ROWebView.GetUserAgent(self.webView)
-- end

-- function WebView:Load(url)
--     if not self.webView then return end
--     local _url = url
--     ROWebView.AddTrustWriteSite(self.webView,_url)
--     ROWebView.LoadUrl(self.webView,_url)
-- end

-- function WebView:AddTrustSite(url)
--     if not self.webView then return end
--     ROWebView.AddTrustWriteSite(self.webView,url)
-- end

-- function WebView:Reload()
--     if not self.webView then return end
--     ROWebView.Reload(self.webView)
-- end

-- function WebView:Show()
--     if not self.webView then return end
--     ROWebView.Show(self.webView)
-- end

-- function WebView:Hide(fade)
--     if not self.webView then return end
--     ROWebView.Hide(self.webView,fade and true or false)
-- end

-- function WebView:Close()
--     if not self.webView then return end
--     ROWebView.ClearCache(self.webView)
-- end

-- function WebView:ClearCache()
--     if not self.webView then return end
--     ROWebView.ClearCache(self.webView)
-- end

-- function WebView:ShowToolBar(_show)
--     if not self.webView then return end
--     ROWebView.SetShowToolBar(self.webView,_show and true or false,true)
-- end

-- function WebView:ShouldClose(shouldClose)
--     ROWebView.SetOnWebViewShouldClose(self.webView,function () return shouldClose and true or false end)
-- end

-- function WebView:Clear()
--     self:Close()
--     self.webView = nil
--     self.config = nil
-- end

-- function WebView:GoBack()
--     if not self.webView then return end
--     ROWebView.GoBack(self.webView)
--  end 
   
-- function WebView:GoForward()
--     if not self.webView then return end
--     ROWebView.GoForward(self.webView)
-- end

-- function WebView:SetRectTransform(rectTransform)
--     if not self.webView then return end
--     ROWebView.SetReferenceRectTransform(self.webView,rectTransform)
-- end