autoImport("WorldMapListView")

NewExploreModeView = class("NewExploreModeView",SubView)

function NewExploreModeView:Init()
	self:InitView()
	self:FindObjs()
	self:ResetPanelDepth()
	self:AddViewListeners()
end

function NewExploreModeView:InitView()
	self.gameObject = self:FindGO("NewExploreMode")
	self.roadPathPoint = self:FindGO("RoadPathPoint")
	self.worldMapView = self:AddSubView("WorldMapListView", WorldMapListView)
	self.worldMapView.gameObject.transform.parent = self.gameObject.transform
	self.worldMapView.ig.enabled = false
	self.worldMapView:ActiveButtons(false)
	self.worldMapView:ActiveMapDetail(false)
	self.worldMapView:EnableMapClick(false)
	self.mapContainer = self:FindGO("MapContainer")
end

function NewExploreModeView:ResetPanelDepth()
	self.loadingViewDepth = self.container.loadingViewDepth
	local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.worldMapView.gameObject, UIPanel, true)
	local maxDepth = 0
	for i=1,#uipanels do
		uipanels[i].depth = uipanels[i].depth + self.loadingViewDepth
		maxDepth = math.max(maxDepth,uipanels[i].depth)
	end
	self.foreLayer.depth = maxDepth + 1
end

function NewExploreModeView:Test()
	local mine = WorldMapProxy.Instance:GetMapAreaDataByMapId(SceneProxy.Instance.currentScene.mapID)
	mine:SetActive(true)
end

function NewExploreModeView:FindObjs()
	self.foreLayer = self:FindGO("ForeLayer"):GetComponent(UIPanel)

	local bar =self:FindGO("ProgressBar",self.foreLayer.gameObject)
	self.bar = bar:GetComponent(UISlider)

	self.barWidth = 1280
	local barWidget = self.bar.gameObject:GetComponent(UIWidget)
	if(barWidget) then
		barWidget:ResetAndUpdateAnchors()
		self.barWidth = barWidget.width
		local barForeground = self:FindGO("Foreground"):GetComponent(UISprite)
		barForeground.width = self.barWidth
		self.bar.value = 0
	end

	self.foreLayer.gameObject:SetActive(false)
	self.spine = self:FindGO("Spine",self.foreLayer.gameObject)

	self:Progress(0)
end

function NewExploreModeView:AddViewListeners()
	self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded,self.ServerReceiveLoadedHandler)
end

function NewExploreModeView:OnExit()
	local mapID = SceneProxy.Instance.currentScene.mapID
	local mapArea = WorldMapProxy.Instance:GetMapAreaDataByMapId(mapID)
	if(mapArea) then
		mapArea:SetIsNew(false)
	end
	self:Progress(0)
end

function NewExploreModeView:ServerReceiveLoadedHandler(note)
	self.container:CloseSelf()
end

function NewExploreModeView:SceneFadeOut(note)
	self.foreLayer.gameObject:SetActive(false)
	self.worldMapView.gameObject:SetActive(false)
	self.container:DoFadeOut()
end

function NewExploreModeView:SceneFadeOutFinish()
	self:SetFrom()
end

function NewExploreModeView:StartLoadScene(note)
	self.foreLayer.gameObject:SetActive(true)
	self.worldMapView.gameObject:SetActive(true)
	self:MoveToNew()
end

function NewExploreModeView:Update(delta)
	self:Progress(SceneProxy.Instance:LoadingProgress())
end

function NewExploreModeView:Progress(value)
	value = math.floor(value)
	self.bar.value = value/100;
	-- self.label.text = value.."%";

	local x = value/100*self.barWidth;
	if(x >= (self.barWidth-88))then
		return
	end
	local y = self.spine.transform.localPosition.y;
	self.spine.transform.localPosition = Vector3(x,y);
end

function NewExploreModeView:MoveToNew()
	-- local mapID = 7
	local toID = SceneProxy.Instance.currentScene.mapID
	local toCell = self.worldMapView:GetMapCellByMapId(toID)
	local hasFrom,fromPos = self:SetFrom()
	if(toCell ~=nil) then
		self.cellParent = toCell.gameObject.transform.parent
		if(hasFrom) then
			local duration = 0.8
			LeanTweenUtil.moveLocal(self.worldMapView.myPosSymbol,toCell.trans.localPosition,duration):setOnComplete(function ()
				toCell:IsExplored(true)
			end)
			-- local pointGap = 35
			-- local distance = Vector3.Distance(toCell.trans.localPosition,fromPos)
			-- local num = math.floor(distance/pointGap)
			-- local gapPercent = 1.0/num
			-- -- print(distance)
			-- -- print(gapPercent)
			-- local stamp = 0
			-- LeanTween.value(self.gameObject, function(v)
			-- 	local temp = math.floor(v / gapPercent)
			-- 	if(temp>stamp) then
			-- 		-- print(temp)
			-- 		for i=stamp,temp do
			-- 			self:AddPoint(fromPos,toCell.trans.localPosition,(i+1.0)/num)
			-- 		end
			-- 		stamp = temp
			-- 	end
			-- end, 0, 1, duration)
		end
		-- LeanTween.delayedCall(self.worldMapView.myPosSymbol,0.5,function ()
			UIUtil.GetUIParticle(EffectMap.UI.WorldMapUnlock,100,toCell.gameObject)
		-- end)
	end
end

function NewExploreModeView:SetFrom(toCell)
	local fromID = SceneProxy.Instance.lastMapID
	local fromCell = self.worldMapView:GetMapCellByMapId(fromID)
	if(fromCell) then
		self.worldMapView.myPosSymbol.transform:SetParent(fromCell.trans.parent,true)
		self.worldMapView.myPosSymbol.transform.localPosition = fromCell.trans.localPosition
		return true,fromCell.trans.localPosition
	elseif(toCell) then
		self.worldMapView.myPosSymbol.transform:SetParent(toCell.trans.parent,true)
		self.worldMapView.myPosSymbol.transform.localPosition = Vector3(0,0,0)
	end
	return false
end

function NewExploreModeView:AddPoint(startPoint,endPoint,percent)
	-- printRed(percent)
	if(percent<=1) then
		local point = GameObject.Instantiate(self.roadPathPoint)
		point.transform.parent = self.mapContainer.transform
		point:SetActive(true)
		point.transform.localScale = Vector3.one
		local dir = endPoint - startPoint
		if(self.cellParent~=nil) then
			point.transform.localPosition = startPoint + dir * percent + self.cellParent.localPosition
		else
			point.transform.localPosition = startPoint + dir * percent
		end
	end
end

function NewExploreModeView:SceneFadeInFinish()
	self.container:CloseSelf()
end

function NewExploreModeView:LoadFinish()
	self.container:FireLoadFinishEvent()
end