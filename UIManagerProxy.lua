autoImport("UILayer")
autoImport("UINode")
UIManagerProxy = class ("UIManagerProxy",pm.Proxy)

UIManagerProxy.Instance = nil

UIManagerProxy.iPhoneXManualHeight = 800

function UIManagerProxy:ctor()
	self.proxyName = "UIManagerProxy"
	self.UIRoot = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("UIRoot"));
	local uiroot = self.UIRoot:GetComponent(UIRoot)
	if(uiroot) then
		local screen = NGUITools.screenSize;
		local aspect = screen.x / screen.y;
		local initialAspect = uiroot.manualWidth / uiroot.manualHeight;
		if(aspect>(initialAspect + 0.1)) then
			uiroot.fitWidth = false
			uiroot.fitHeight = true
			if(ApplicationInfo.IsIphoneX()) then
				uiroot.manualHeight = UIManagerProxy.iPhoneXManualHeight
			end
		end

		self.rootSize = { math.floor(uiroot.activeHeight * aspect), uiroot.activeHeight }
	end
	GameObject.DontDestroyOnLoad(self.UIRoot);
	local speechGO = GameObject("SpeechRecognizer")
	speechGO.transform.parent = self.UIRoot.transform
	speechGO:AddComponent(AudioSource)
	self.speechRecognizer = speechGO:AddComponent(SpeechRecognizer)

	-- todo xde
	--if MicrophoneManipulate.CanSpeech() then
	--	RedefineSpeechRecognizer(self.speechRecognizer)
	--	self.microphoneManipulate = MicrophoneManipulate.new(self.speechRecognizer)
	--end

	self.layers = {}

	self.forbidview_map = {};

	UIManagerProxy.Instance = self
	self:InitLayers()
	self:InitRollBack()
	self:InitViewPop()
end

function UIManagerProxy:GetUIRootSize()
	return self.rootSize;
end

function UIManagerProxy:InitLayers()
	local layers = {}
	for k,v in pairs(UIViewType) do
		layers[#layers + 1] = v
		-- v.vname = k
		-- self.layers[k] = self:SpawnLayer(v)
	end
	table.sort(layers,function(l,r)
			return l.depth < r.depth
		end)
	for i=1,#layers do
		self.layers[layers[i].name] = self:SpawnLayer(layers[i])
	end

	self.childPopObjList = {};
end

function UIManagerProxy:InitRollBack()
	self.rollBackMap = {}
	local panelData
	local viewClass
	for i=1,#UIRollBackID do
		panelData = PanelProxy.Instance:GetData(UIRollBackID[i])
		if(panelData) then
			viewClass = self:GetImport(panelData.class)
			if(viewClass) then
				self.rollBackMap[viewClass] = 1
			end
		end
	end
end

function UIManagerProxy:SpawnLayer(data)
	local layer = UILayer.new(data,self.UIRoot)
	layer:AddEventListener(UILayer.AddChildEvent,self.LayerAddChildHandler,self)
	layer:AddEventListener(UILayer.EmptyChildEvent,self.LayerEmptyHandler,self)
	return layer
end

function UIManagerProxy:ShowUI(data,prefab,class)
	local viewid = data.view and data.view.id;
	local forbid_msg = viewid and self.forbidview_map[viewid]
	if(forbid_msg)then
		if(forbid_msg ~= -1)then
			MsgManager.ShowMsgByIDTable(forbid_msg);
		end
		return;
	end

	local viewClass = self:GetImport(class or data.viewname)
	if(viewClass) then
		local viewType = viewClass.ViewType
		local layer = self:GetLayerByType(viewType)
		if(layer) then
			return layer:CreateChild(data,prefab,class,self.rollBackMap[viewClass]~=nil)
		end
	end
	return nil
end

function UIManagerProxy:ShowUIByConfig(data)
	return self:ShowUI(data,data.view.prefab,data.view.class)
end

function UIManagerProxy:CloseUI(viewCtrl)
	if(viewCtrl) then
		local viewType = viewCtrl.ViewType
		local layer = self:GetLayerByType(viewType)
		if(layer) then
			layer:DestoryChildByCtrl(viewCtrl)
			layer:TryRollBackPrevious()
		end
	end
end

function UIManagerProxy:CloseLayerAllChildren(viewType)
	if(viewType) then
		local layer = self:GetLayerByType(viewType)
		if(layer) then
			layer:DestoryAllChildren()
			layer:TryRollBackPrevious()
		end
	end
end

function UIManagerProxy:LayerAddChildHandler(evt)
	self:AddHideOtherLayers(evt.target)
	self:CloseOtherLayers(evt.target)
end

function UIManagerProxy:LayerEmptyHandler(evt)
	self:RemoveHideOtherLayers(evt.target)
end

function UIManagerProxy:CloseOtherLayers(layer)
	local closeOthers = layer.data.closeOtherLayer
	if(closeOthers) then
		for k,v in pairs(closeOthers) do
			self:CloseLayerAllChildren(UIViewType[k])
		end
	end
end

function UIManagerProxy:AddHideOtherLayers( layer )
	if(layer.data.hideOtherLayer) then
		local hideOther = layer.data.hideOtherLayer
		local otherLayer
		local name
		for k,v in pairs(hideOther) do
			name = UIViewType[k].name
			otherLayer = self.layers[name]
			otherLayer:AddHideMasterLayer(layer)
		end
	end
end

function UIManagerProxy:RemoveHideOtherLayers( layer )
	if(layer.data.hideOtherLayer) then
		local hideOther = layer.data.hideOtherLayer
		local otherLayer
		local name
		for k,v in pairs(hideOther) do
			name = UIViewType[k].name
			otherLayer = self.layers[name]
			otherLayer:RemoveHideMasterLayer(layer)
		end
	end
end

function UIManagerProxy:GetLayerByType(viewType)
	return self.layers[viewType.name]
end

function UIManagerProxy:HasUINode(panelConfig)
	local class = self:GetImport(panelConfig.class)
	if(class ~=nil and class.ViewType~=nil) then
		local layer = self:GetLayerByType(class.ViewType)
		if(layer) then
			return layer:FindNodeByClassName(panelConfig.class)~=nil
		end
	end
	return false
end

function UIManagerProxy:GetImport(viewname)
	local viewCtrl= _G[viewname]
	if(not viewCtrl) then
		-- viewCtrl = require (FilePath.ui.."view."..viewname)
		viewCtrl = autoImport(viewname)
		if(type(viewCtrl)~="table") then
			viewCtrl= _G[viewname]
		end
	end
	return viewCtrl
end

function UIManagerProxy:InitViewPop()
	self.modalLayer = {
		UIViewType.ChatroomLayer,
		UIViewType.ChitchatLayer,
		UIViewType.TeamLayer,
		UIViewType.ChatLayer,
		UIViewType.FocusLayer,
		UIViewType.NormalLayer,
		UIViewType.PopUpLayer,
		UIViewType.ConfirmLayer,
		UIViewType.SystemOpenLayer,
		UIViewType.Show3D2DLayer,
		UIViewType.ShareLayer,
		UIViewType.Popup10Layer,
		UIViewType.TipLayer,
	}
	for i=#self.modalLayer,1,-1 do
		if(self.modalLayer[i]==nil) then
			table.remove(self.modalLayer,i)
		end
	end
	table.sort(self.modalLayer ,function ( l,r )
			return l.depth < r.depth
		end)
end

function UIManagerProxy:GetModalPopCount()
	local count = 0
	local layer
	for i=1,#self.modalLayer do
		layer = self.layers[self.modalLayer[i].name]
		if(UIViewType.TipLayer.name == layer.name and UIViewType.TipLayer.depth == layer.depth) then
			if(TipsView:Me().currentTip~=nil) then
				count = count + 1
			end
		else
			count = count + #layer.nodes
		end
	end

	local obj;
	for i=1,#self.childPopObjList do
		obj = self.childPopObjList[i][2];
		if(not Slua.IsNull(obj) and obj.activeInHierarchy)then
			count = count + 1;
		end
	end
	
	helplog("????????????",count)
	return count
end

function UIManagerProxy:PopView()
	helplog("pop ????????????")
	local layer
	local suc;
	for i=#self.modalLayer,1,-1 do
		layer = self.layers[self.modalLayer[i].name]
		if(UIViewType.TipLayer.name == layer.name and UIViewType.TipLayer.depth == layer.depth) then
			if(TipsView:Me().currentTip~=nil) then
				helplog(layer.name,layer.nodes[#layer.nodes].viewname)
				TipsView.Me():HideCurrent()
				suc = true;
				break
			end
		else
			if(#layer.nodes>0) then
				helplog(layer.name,layer.nodes[#layer.nodes].viewname)
				layer:DestoryChild(layer.nodes[#layer.nodes])
				layer:TryRollBackPrevious()
				suc = true;
				break
			end
		end
	end
	if(not suc)then
		for i=#self.childPopObjList, 1, -1 do
			local obj = self.childPopObjList[i][2];
			if(Slua.IsNull(obj))then
				table.remove(self.childPopObjList, i);
			else
				if(obj.activeInHierarchy)then
					obj:SetActive(false);
					break;
				end
			end
		end
	end
	return self:GetModalPopCount()
end

function UIManagerProxy:SetForbidView(viewid, forbidMsgid, forceClose)
	self.forbidview_map[viewid] = forbidMsgid or -1;

	if(forceClose)then
		local viewdata = PanelProxy.Instance:GetData(viewid);
		if(viewdata)then
			self:CloseLayerAllChildren(self:GetImport(viewdata.class).ViewType);
		end
	end
end

function UIManagerProxy:UnSetForbidView(viewid)
	self.forbidview_map[viewid] = nil;
end


function UIManagerProxy:RegisterChildPopObj(layer, obj)
	local length = #self.childPopObjList;
	if(length == 0)then
		table.insert(self.childPopObjList, {layer, obj});
		return;
	end

	local clayer;
	for i=1,length do
		clayer = self.childPopObjList[i][1];
		if(layer.depth < clayer.depth)then
			table.insert(self.childPopObjList, i, {layer, obj});
			inserted = true;
			break;
		else
			if(i == length)then
				table.insert(self.childPopObjList, {layer, obj});
			end
		end
	end
end

function UIManagerProxy:UnRegisterChildPopObj(layer)
	local clayer;
	for i=#self.childPopObjList, 1, -1 do
		if(clayer == layer)then
			table.remove(self.childPopObjList, i);
		end
	end
end

XDEUIEvent = {
	RoleBack = "XDERoleBack",
	CreateBack = "XDECreateBack"
}

-- todo xde
function UIManagerProxy.CSPopView()
	local count =  UIManagerProxy.Instance:GetModalPopCount()
	if count == 0 then
		if UIManagerProxy.Instance:HasUINode(PanelConfig.RolesSelect) then
			GameFacade.Instance:sendNotification(XDEUIEvent.RoleBack);
		elseif UnityEngine.GameObject.Find('CreateRoleViewV2') then
			GameFacade.Instance:sendNotification(XDEUIEvent.CreateBack);
		else
			UIUtil.PopUpConfirmYesNoView(ZhString.NoticeTitle,ZhString.STR_CONFIRM_EXIT_GAME,function()
				OverSeas_TW.OverSeasManager.GetInstance():TryKillSelf()
			end,function ()
			end,nil,ZhString.UniqueConfirmView_Confirm,ZhString.UniqueConfirmView_CanCel)
		end
	else
		UIManagerProxy.Instance:PopView()
	end
end