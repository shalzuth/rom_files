UIAnimMap = {
	ViewEnter = function (go,callBack)
		LeanTween.cancel(go);
		go:SetActive(true);
		local panel = go:GetComponent(UIPanel)
		panel.alpha = 0;
		LeanTweenUtil.UIAlpha(panel, 0, 1, 0.2, 0):setOnComplete(function ()
			if(callBack~=nil)then
				callBack();
			end
		end):setDestroyOnComplete(true);
	end,

	ViewExit_Destroy = function (go,callBack)
		GameObject.Destroy(go);
		if(callBack~=nil and type(callBack) == "function") then
			callBack();
		end
	end,

	ViewExit_Hide = function (go,callBack)
		go:SetAcitve(false);
		if(callBack~=nil and type(callBack) == "function") then
			callBack();
		end
	end,

	ViteEnter_ItemTipHide = function (go, callBack)
		LeanTween.cancel(go);

		local panel = go:GetComponent(UIPanel);
		go:SetActive(true);
		panel.alpha = 0;
		LeanTweenUtil.UIAlpha(panel, 0, 1, 0.3, 0):setOnComplete(function ()
			if(callBack~=nil)then
				callBack();
			end
		end):setDestroyOnComplete(true);
	end,
	--------------------------------tips显示再渐隐退出--------------------------------
	TipsShow = function (go,callBack)
		LeanTween.cancel(go);

		local panel = go:GetComponent(UIPanel);
		go:SetActive(true);
		panel.alpha = 1;
		LeanTweenUtil.UIAlpha(panel, 1, 0, 2,1):setOnComplete(function ()
			panel.alpha = 0;
			panel.gameObject:SetActive(false);
			if(callBack~=nil)then
				callBack();
			end
		end):setDestroyOnComplete(true);
	end,
}


local UIProxy = class ("UIProxy",pm.Proxy)

UIProxy.Instance = nil

function UIProxy:ctor()
	self.proxyName = "UIProxy"
	-- self.UIRoot = GameObjPool.Instance:RGet(ResourceID.Make(PfbPath.ui.."view/".."UIRoot"),"UI")
	GameObject.DontDestroyOnLoad(self.UIRoot);
	self.viewMap = {}

	UIProxy.Instance = self
end

function UIProxy:GetViewData(viewTypeName)
	if(self.viewMap[viewTypeName] == nil) then
		local d = {};
		
		d.viewObj = nil;
		d.nowView = nil;

		local tempObj = GameObject(viewTypeName);
		GameObject.DontDestroyOnLoad(tempObj);
		d.root = tempObj.transform;
		GameObjectUtil.Instance:ChangeLayersRecursively(tempObj,"UI");
		d.root:SetParent(self.UIRoot.transform,false);

		self.viewMap[viewTypeName] = d;
	end

	return self.viewMap[viewTypeName]
end

function UIProxy:SetViewData(viewTypeName,data)
	self.viewMap[viewTypeName] = data
end

return UIProxy