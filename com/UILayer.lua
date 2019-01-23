autoImport("UINode")
autoImport("LStack")
autoImport("EventDispatcher")

--UILayer是UI的层级管理者，管理UINode节点，包括他们的depth、显示隐藏、销毁
--UILayer自己也能整体显示和隐藏，并且自己的gameobject名字为-->L{层级}_{层级名字}({uinode数量})({子uipanel数量})
--每层uilayer间隔配置15 depth，如有collider垫板层的Layer,垫板层为layer最低层
UILayer = class("UILayer",EventDispatcher)
UILayer.AddChildEvent = "UILayer_AddChildEvent"
UILayer.EmptyChildEvent = "UILayer_EmptyChildEvent"

UILayer.ShowPos = Vector3.zero
UILayer.HidePos = Vector3(-10000,-10000,0)

function UILayer:ctor(data,root)
	self.data = data
	self.showHideMode = (self.data.showHideMode ~= nil and self.data.showHideMode or LayerShowHideMode.MoveOutAndMoveIn)
	self.depthGap = 15
	self.nodes = {}
	self.hideMasters = {}
	self.panelNum = 0
	self.name = data.name
	self.depth = data.depth
	self.gameObject = GameObject()
	self.panel = self.gameObject:AddComponent(UIPanel)
	self.panel.depth = self.depth * self.depthGap
	self.cachedNode = {}
	self.stack = LStack.new()
	-- GameObject.DontDestroyOnLoad(tempObj)
	self.uiRoot = root
	GameObjectUtil.Instance:ChangeLayersRecursively(self.gameObject,"UI")
	self.gameObject.transform:SetParent(self.uiRoot.transform,false)
	self:TryCreateColliderMask()
	self:Rename()
	self:InitShowHideModeCall()
end

function UILayer:StartDepth()
	return self.data.depth * self.depthGap
end

function UILayer:UINodeStartDepth()
	return self:StartDepth() + 1
end

function UILayer:TryCreateColliderMask()
	if(self.data and self.data.coliderColor and not self.colliderMask) then
		self.colliderMask = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("ColliderView")):GetComponent(UIPanel);
		self.colliderMaskContainer = GameObject("MaskContainer")
		self.colliderMaskContainer.transform:SetParent(self.gameObject.transform,false)
		self.colliderMask.transform:SetParent(self.colliderMaskContainer.transform,false)
		self.colliderMask.depth = self:StartDepth()
		local sprite = self.colliderMask.gameObject:GetComponentInChildren(UISprite)
		sprite.color = self.data.coliderColor;
		self:HideMask()
	end
end

function UILayer:Rename()
	self.gameObject.name = string.format("L%s_%s(%s)(%s)(%s)",self.depth,self.name,#self.nodes,self:GetPanelNum(),self.stack:GetCount())
end

function UILayer:AddHideMasterLayer(layer)
	if(TableUtil.ArrayIndexOf(self.hideMasters,layer)==0) then
		self.hideMasters[#self.hideMasters + 1] = layer
		self:Hide()
	end
end

function UILayer:RemoveHideMasterLayer(layer)
	if(TableUtil.Remove(self.hideMasters,layer)>0) then
		if(#self.hideMasters == 0) then
			self:Show()
		end
	end
end

function UILayer:Show()
	-- print(string.format("%s layer show",self.name))
	if(self.showHideMode == LayerShowHideMode.ActiveAndDeactive) then
		if(self.gameObject)then
			self.gameObject:SetActive(true)
		end
	else
		if(self.gameObject)then
			self.gameObject.transform.localPosition = UILayer.ShowPos
		end

		if(self.colliderMaskContainer and not self.colliderMaskContainer.activeSelf) then
			self.colliderMaskContainer:SetActive(true)
		end
	-- 	if(self.gameObject and not self.gameObject.activeSelf) then
	-- 		self.gameObject:SetActive(true)
	-- 	end
	end

	for i=1,#self.nodes do
		self.nodes[i]:OnShow()
	end
end

function UILayer:Hide()
	-- print(string.format("%s layer hide",self.name))
	if(self.showHideMode == LayerShowHideMode.ActiveAndDeactive) then
		if(self.gameObject)then
			self.gameObject:SetActive(false)
		end
	else
		if(self.gameObject)then
			self.gameObject.transform.localPosition = UILayer.HidePos
		end
		
		if(self.colliderMaskContainer and self.colliderMaskContainer.activeSelf) then
			self.colliderMaskContainer:SetActive(false)
		end
		-- if(self.gameObject and self.gameObject.activeSelf) then
		-- 	self.gameObject:SetActive(false)
		-- end
	end

	for i=1,#self.nodes do
		self.nodes[i]:OnHide()
	end
end

function UILayer:ShowMask()
	if(self.colliderMask and not self.colliderMask.gameObject.activeSelf) then
		self.colliderMask.gameObject:SetActive(true)
	end
end

function UILayer:HideMask()
	if(self.colliderMask and self.colliderMask.gameObject.activeSelf) then
		self.colliderMask.gameObject:SetActive(false)
	end
end

function UILayer:GetPanelNum()
	local num = 0
	for i=1,#self.nodes do
		num = num + self.nodes[i]:GetPanelNum()
	end
	return num
end

function UILayer:NodeCoExist(newNode)
	local can = false
	for i=1,#self.nodes do
		if(newNode~=self.nodes[i] and newNode:CanCoExist(self.nodes[i])) then
			can = true
		end
	end
	return can
end

function UILayer:FindNodeFunc(cond,param)
	for i=1,#self.nodes do
		if(cond == self.nodes[i][param]) then
			return self.nodes[i]
		end
	end
	return nil
end

function UILayer:FindNode(ctrl)
	return self:FindNodeFunc(ctrl,"viewCtrl")
end

function UILayer:FindNodeByName(ctrl)
	return self:FindNodeFunc(ctrl,"viewname")
end

function UILayer:FindNodeByClassName(class)
	return self:FindNodeFunc(class,"class")
end

function UILayer:CreateChild(data,prefab,class,needRollBack)
	local node = self:FindNodeByName(data.viewname or prefab)
	if(node and not self.data.reEntnerNotDestory) then
		self:DestoryChild(node)
		node = nil
	end
	if(not node) then
		local viewClass = UINode.GetImport( class or data.viewname)
		node = self.cachedNode[viewClass.__cname]
		if(not node) then
			node = UINode.new(data,prefab,class,self,needRollBack)
			node:Create()
		else
			node:ResetViewData(data)
			self.cachedNode[viewClass.__cname] = nil
		end
		self:AddChild(node)
	end
	return node
end

function UILayer:IndexOfSameUINode(node,compareNode)
	return node.viewClass == compareNode.viewClass
end

function UILayer:PushToStack(previous,node)
	local stackCount = self.stack:GetCount()
	if(not node.needRollBack) then
		self.stack:Clear()
	end
	if(node.needRollBack) then
		local findSameDepth = self.stack:GetDepthByFunc(node,self.IndexOfSameUINode,self)
		if(findSameDepth>0) then
			--找到相同的
			if(findSameDepth == stackCount) then
				--同个界面，忽略
				return
			else
				--清除之前的
				self.stack:RemoveNum(findSameDepth)
			end
		end
		if(previous:GetShowHideMode() == PanelShowHideMode.CreateAndDestroy) then
			previous = previous:Clone()
		end
		self.stack:Push(previous)
	end
end

function UILayer:TryRollBackPrevious()
	local previous = self.stack:Pop()
	if(previous) then
		print("返回上一级界面")
		previous:Create()
		return self:AddChild(previous,false)
	end
	return false
end

function UILayer:AddChild(node,pushStack)
	if(pushStack == nil) then
		pushStack = true
	end
	if(node and not GameObjectUtil.Instance:ObjectIsNULL(node.gameObject)) then
		if(node.layer~=self) then
			if(node.layer) then
				node.layer:RemoveChild(node)
			end
			node:SetLayer(self)
		end

		--如果新的UI节点无法与当前的共存，则销毁当前UI
		if(not self:NodeCoExist(node)) then
			if(pushStack) then
				for i=1,#self.nodes do
					self:PushToStack(self.nodes[i],node)
				end
			end
			self:DestoryAllChildren()
		end
		self.nodes[#self.nodes + 1] = node
		
		if(#self.nodes == 1) then
			self:DispatchEvent(UILayer.AddChildEvent)
		end
		self:ModeShow(node)
		node:OnEnter()
		node:SetDepth(self:UINodeStartDepth())
		self:Rename()
		--面板中可选择是否需要挡板
		if(node.data.view and node.data.view.hideCollider) then
			self:HideMask()
		else
			self:ShowMask()
		end
		return true
	else
		printRed(string.format("%s Layer想添加一个不存在的uinode",self.name))
	end
	return false
end

function UILayer:RemoveChild(node)
	if(node and TableUtil.Remove(self.nodes,node)>0) then
		node:SetLayer(nil)
		node:OnHide()
		node:OnExit()
		self:Rename()
		if(#self.nodes==0) then
			self:DispatchEvent(UILayer.EmptyChildEvent)
			self:HideMask()
		end
		return true
	end
	return false
end

function UILayer:RemoveChildByCtrl(ctrl)
	local node = self:FindNode(ctrl)
	return self:RemoveChild(node)
end

function UILayer:DestoryChildByCtrl(ctrl)
	local node = self:FindNode(ctrl)
	return self:DestoryChild(node)
end

function UILayer:DestoryChild(node)
	if(node and node.layer == self) then
		self:RemoveChild(node)
		-- self.cachedNode[node.viewClass.__cname] = node
		self:ModeHide(node)
		-- node:Dispose()
		-- node = nil
	end
end

function UILayer:DestoryAllChildren()
	for k,v in pairs(self.nodes) do
		self:DestoryChild(v)
	end
	self:DispatchEvent(UILayer.EmptyChildEvent)
	self.nodes = {}
	self:Rename()
	self:HideMask()
end

function UILayer:InitShowHideModeCall()
	self.ShowCallByMode = {}
	self.ShowCallByMode[PanelShowHideMode.CreateAndDestroy] = self.ModeCreateShow
	self.ShowCallByMode[PanelShowHideMode.ActiveAndDeactive] = self.ModeActiveShow
	self.ShowCallByMode[PanelShowHideMode.MoveOutAndMoveIn] = self.ModeMoveInShow

	self.HideCallByMode = {}
	self.HideCallByMode[PanelShowHideMode.CreateAndDestroy] = self.ModeDestroyHide
	self.HideCallByMode[PanelShowHideMode.ActiveAndDeactive] = self.ModeDeActiveHide
	self.HideCallByMode[PanelShowHideMode.MoveOutAndMoveIn] = self.ModeMoveOutHide
end

function UILayer:ModeShow(node)
	if(node) then
		local func = self.ShowCallByMode[node:GetShowHideMode()]
		if(func==nil) then
			func = self.ModeCreateShow
		end
		if(func) then
			func(self,node)
		end
	end
end

function UILayer:ModeHide(node)
	if(node) then
		local func = self.HideCallByMode[node:GetShowHideMode()]
		if(func==nil) then
			func = self.ModeDestroyHide
		end
		if(func) then
			func(self,node)
		end
	end
end

function UILayer:ModeCreateShow(node)
	if(not GameObjectUtil.Instance:ObjectIsNULL(node.gameObject) ) then
		node.gameObject.transform:SetParent(self.gameObject.transform,false)
	end
end

function UILayer:ModeActiveShow(node)
	if(not GameObjectUtil.Instance:ObjectIsNULL(node.gameObject) ) then
		if(node.gameObject.transform.parent ~= self.gameObject.transform) then
			node.gameObject.transform:SetParent(self.gameObject.transform,false)
		end
		if(node:MediatorReActive()) then
			node:RegisterMediator()
		end
		node:Show()
	end
end

function UILayer:ModeMoveInShow(node)
	if(not GameObjectUtil.Instance:ObjectIsNULL(node.gameObject) ) then
		if(node.gameObject.transform.parent ~= self.gameObject.transform) then
			node.gameObject.transform:SetParent(self.gameObject.transform,false)
		end
		if(node:MediatorReActive()) then
			node:RegisterMediator()
		end
		node.gameObject.transform.localPosition = UILayer.ShowPos
	end
end

function UILayer:ModeDestroyHide(node)
	node:Dispose()
end

function UILayer:ModeDeActiveHide(node)
	if(not GameObjectUtil.Instance:ObjectIsNULL(node.gameObject) ) then
		self.cachedNode[node.viewClass.__cname] = node
		node:Hide()
		if(node:MediatorReActive()) then
			node:UnRegisterMediator()
		end
	end
end

function UILayer:ModeMoveOutHide(node)
	if(not GameObjectUtil.Instance:ObjectIsNULL(node.gameObject) ) then
		self.cachedNode[node.viewClass.__cname] = node
		node.gameObject.transform.localPosition = UILayer.HidePos
		if(node:MediatorReActive()) then
			node:UnRegisterMediator()
		end
	end
end