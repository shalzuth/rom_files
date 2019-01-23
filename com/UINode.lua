autoImport("EventDispatcher")
UINode = class("UINode",EventDispatcher)

function UINode:ctor(data,prefab,class,layer,needRollBack)
	self.data = data
	self.viewname = prefab or class or data.viewname
	self.layer = layer
	self.class = class
	self.needRollBack = needRollBack
	self.viewClass = UINode.GetImport( self.class or data.viewname)
	self.created = false
end

function UINode:ResetViewData(viewData)
	self.data = viewData
	if(self.viewCtrl) then
		self.viewCtrl.viewdata = self.data
	end
end

function UINode:Clone()
	local node = UINode.new(self.data,self.viewname,self.class,self.layer,self.needRollBack)
	return node
end

function UINode:Create()
	if(not self.created) then
		self.created = true
		self.gameObject = self:CreatViewPfb(self.viewname)
		self.mediator = UIMediator.new(self.data.mediatorName or self.viewname)
		if(self.layer) then
			if(not GameObjectUtil.Instance:ObjectIsNULL(self.gameObject)) then
				if(self.layer~=nil) then
					self.gameObject.transform:SetParent(self.layer.gameObject.transform,false)
				end
			end
		end
		self.viewCtrl = self.viewClass.new(self.gameObject, self.data,self.mediator)
		self.mediator:SetView(self.viewCtrl)
		self:RegisterMediator()
	end
end

function UINode.GetImport(viewname)
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

function UINode:CreatViewPfb(viewName)
	local viewBord = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView(viewName))
	-- viewBord.transform:SetParent(parent.transform, false)
	return viewBord
end

function UINode:CanCoExist(node)
	if(self.viewClass.BrotherView and self.viewClass.BrotherView == node.viewClass) then
		return true
	elseif(node.viewClass.BrotherView and node.viewClass.BrotherView == self.viewClass) then
		return true
	end
	return false
end

function UINode:SetDepth(depth)
	if(not self.settedDepth) then
		self.settedDepth = true
		local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
		table.sort(uipanels,function(l,r)
				return l.depth < r.depth
			end)
		local currentBaseDepth = uipanels[1].depth
		for i=1,#uipanels do
			--根据Prefab中panel原间隔设置新depth
			-- uipanels[i].depth = (uipanels[i].depth - currentBaseDepth) + depth
			-- depth = uipanels[i].depth
			--根据Prefab中Panel得depth直接加上layer得修正depth
			uipanels[i].depth = uipanels[i].depth + depth
		end
	end
	return depth + 1
end

--设置UI节点的layer层,UILayer
function UINode:SetLayer(layer)
	self.layer = layer
	-- if(not GameObjectUtil.Instance:ObjectIsNULL(self.gameObject)) then
	-- 	-- self.gameObject.transform:SetParent(self.layer and self.layer.gameObject.transform or nil ,false)
	-- 	if(self.layer~=nil) then
	-- 		self.gameObject.transform:SetParent(self.layer.gameObject.transform,false)
	-- 	end
	-- 	if(self.layer~=nil) then
	-- 		self.gameObject.transform.localPosition = Vector3.zero
	-- 	else
	-- 		self.gameObject.transform.localPosition = Vector3(-10000,-10000,0)
	-- 	end
	-- end
end

function UINode:MediatorReActive()
	local val = self.viewCtrl:MediatorReActive()
	if(val==nil) then
		print(string.format("%s没有MediatorReActive，回滚使用 true",self.viewname))
		val = true
	end
	return val
end

function UINode:GetShowHideMode()
	local mode
	if(self.viewCtrl~=nil) then
		mode = self.viewCtrl:GetShowHideMode()
	end
	if(mode==nil) then
		print(string.format("%s没有显示隐藏模式，回滚使用 创建销毁方式",self.viewname))
		mode = PanelShowHideMode.CreateAndDestroy
	end
	return mode
end

function UINode:Show()
	if(not GameObjectUtil.Instance:ObjectIsNULL(self.gameObject)) then
		self.gameObject:SetActive(true)
		self:OnShow()
	end
end

function UINode:OnShow()
	if(self.viewCtrl and self.viewCtrl.OnShow~=nil) then
		self.viewCtrl:OnShow()
	end
end

function UINode:Hide()
	if(not GameObjectUtil.Instance:ObjectIsNULL(self.gameObject)) then
		self.gameObject:SetActive(false)
		self:OnHide()
	end
end

function UINode:OnHide()
	if(self.viewCtrl and self.viewCtrl.OnHide~=nil) then
		self.viewCtrl:OnHide()
	end
end

function UINode:OnEnter()
	self.viewCtrl:OnEnter()
end

function UINode:OnExit()
	self.viewCtrl:OnExit()
end

function UINode:GetPanelNum()
	if(not self.panelNum) then
		local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIPanel, true);
		self.panelNum = #uipanels
	end
	return self.panelNum
end

function UINode:RegisterMediator()
	if(self.mediator) then
		GameFacade.Instance:registerMediator(self.mediator)
	end
end

function UINode:UnRegisterMediator()
	if(self.mediator) then
		self.mediator:Dispose()
	end
end

function UINode:Dispose()
	self:UnRegisterMediator()
	self.mediator = nil
	if(self.gameObject) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
end