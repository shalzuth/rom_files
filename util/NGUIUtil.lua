NGUIUtil = {}
NGUIUtil.AnchorSide = {
	BottomLeft=1,
	Left=2,
	TopLeft=3,
	Top=4,
	TopRight=5,
	Right=6,
	BottomRight=7,
	Bottom=8,
	Center=9,
}
function NGUIUtil.ChangeRenderQ(role,renderQ)
	GameObjectUtil.Instance:ChangeLayersRecursively (role.gameObject, "UI")
	-- change renderQ
	local r = role.gameObject:GetComponentsInChildren(Renderer)
	for i=1,#r do
		local m = r [i].sharedMaterials
		for j=1,#m do
			m[j].renderQueue = renderQ
		end
	end
end

function NGUIUtil.GetOrAddComponent(obj, comp)
	local result = obj:GetComponent(comp);
	result = obj or obj:AddComponent(comp);
	return result;
end

-- dir 0:minus 1:add
function NGUIUtil.SliderChangeValue(slider, tovalue, time ,dir)
	local nowValue = slider.value;
	if(dir == 1)then
		tovalue = tovalue<nowValue and tovalue+1 or tovalue;
	elseif(dir == 0)then
		tovalue = tovalue>nowValue and tovalue-1 or tovalue;
	end
	LeanTween.cancel(slider.gameObject);
	LeanTween.value (slider.gameObject, function (f)
		f = f<0 and f+1 or f;
		f = f>0 and f-1 or f;
		slider.value = f;
	end, nowValue, tovalue, time):setDestroyOnComplete (true);
end

function NGUIUtil.PlayUIAnim(obj, animName)
	local animator = obj:GetComponent(Animator);
	if(animator == nil) then
		error "cannot fin animator"
	end
	animator:Play (animName, -1, 0);
end

function NGUIUtil:GetCameraByLayername(layerName)
	local layer = LayerMask.NameToLayer(layerName);
	self.cameras = self.cameras or {};
	local camera = self.cameras[layerName];
	if(camera or GameObjectUtil.Instance:ObjectIsNULL(camera))then
		camera = NGUITools.FindCameraForLayer(layer);
		self.cameras[layerName] =  camera;
	end
	return camera;
end

function NGUIUtil.GetAnchorPoint(widget,anchorTarget,side,pixelOffset)
	pixelOffset = pixelOffset or {0,0}
	local pc = anchorTarget and anchorTarget.gameObject:GetComponent(UIPanel) or nil
	local relativeOffset = {0,0}
	local mRect = Rect(0,0,0,0)
	if(anchorTarget ~=nil) then
		local b = anchorTarget:CalculateBounds(anchorTarget.transform.parent);
		mRect.x = b.min.x;
		mRect.y = b.min.y;
		mRect.width = b.size.x;
		mRect.height = b.size.y;
	elseif(pc~=nil) then
	else return Vector3(0,0,0)
	end
	local Side = NGUIUtil.AnchorSide
	local cx = (mRect.xMin + mRect.xMax) * 0.5;
	local cy = (mRect.yMin + mRect.yMax) * 0.5;
	local v = Vector3(cx, cy, 0);
	if(side ~= Side.Center) then
		if (side == Side.Right or side == Side.TopRight or side == Side.BottomRight) then v.x = mRect.xMax;
		elseif (side == Side.Top or side == Side.Center or side == Side.Bottom)then v.x = cx;
		else v.x = mRect.xMin end

		if (side == Side.Top or side == Side.TopRight or side == Side.TopLeft)then v.y = mRect.yMax;
		elseif (side == Side.Left or side == Side.Center or side == Side.Right)then v.y = cy;
		else v.y = mRect.yMin end
	end
	local width = mRect.width;
	local height = mRect.height;

	v.x = v.x + pixelOffset[1] + relativeOffset[1] * width;
	v.y = v.y + pixelOffset[2] + relativeOffset[2] * height;
	v.x = Mathf.Round(v.x);
	v.y = Mathf.Round(v.y);

	if (pc ~= null) then
		v = pc.cachedTransform:TransformPoint(v);
	elseif (anchorTarget ~= null) then
		local t = anchorTarget.transform.parent;
		if (t ~= null) then v = t:TransformPoint(v) end
	end
	-- v.z = widget.transform.position.z;
	return v
end

function NGUIUtil.DrawAbilityPolygon(pObj, lObj, radiu, values)
	local resultObjs = {};
	local points = {};
	for i = 1, #values do
		points[i] = {};
		local a = (360/#values)*(#values - i + 1)+90;
		a = ((a % 360)/180)*math.pi;
		local length = radiu*values[i];
		points[i].length = length;
		points[i].point = Vector3(length * math.cos(a), length*math.sin(a), 0);
	end
	for i = 1, #points do
		if(pObj)then
			local cpyPoint = GameObject.Instantiate(pObj);
			cpyPoint:SetActive(true);
			cpyPoint.transform:SetParent(pObj.transform.parent, false);
			cpyPoint.transform.localPosition = points[i].point;
			cpyPoint.name = "p"..i;
			table.insert(resultObjs, cpyPoint);
		end
		if(lObj)then
			local cpyLine = GameObject.Instantiate(lObj);
			cpyLine:SetActive(true);
			cpyLine.transform:SetParent(lObj.transform.parent, false);
			cpyLine.transform.localPosition = points[i].point;
			local nextPIndex = (i)%6 + 1;
			local lineV3 = points[nextPIndex].point - points[i].point;
			local deg = math.acos(lineV3.x/lineV3.magnitude);
			local tempa = math.deg(deg);
			if(lineV3.y < 0)then
				tempa = 360 - tempa;
			end
			cpyLine.transform.rotation = Quaternion.Euler (0,0, tempa);
			cpyLine:GetComponent(UISprite).width = math.floor(lineV3.magnitude+2);
			cpyLine.name = "l"..i;
			table.insert(resultObjs, cpyLine);
		end
	end
	return resultObjs;
end

function NGUIUtil.AddComponent(obj,component)
	obj = obj.gameObject
	local already = obj:GetComponent(component)
	if(not already) then
		obj:AddComponent(component)
	end
end

function NGUIUtil.MaskButton(button, clickevent, color)
	local temp = {};
	local widgets = button:GetComponentsInChildren(UIWidget);
	local color = color or Color(0.5,0.5,0.5);
	temp.catchColor = {};
	local maxLv = 0;
	for i=1,#widgets do
		local v = widgets[i];
		temp.catchColor[v] = v.color;
		v.color = color;
		maxLv = math.max(maxLv, v.depth);
	end

	local mask = GameObjectUtil.Instance:DeepFind(button, "ButtonMask");
	if(not mask)then
		local rid = ResourcePathHelper.UICell("ButtonMask");
		mask = Game.AssetManager_UI:CreateAsset(rid, button);
		mask.name = "ButtonMask";
		mask.transform.localPosition = Vector3.zero;
	end
	if(clickevent)then
		UIEventListener.Get(mask).onClick = clickevent;
	end
	temp.mask = mask;
	local maskWidget = mask:GetComponent(UIWidget);
	maskWidget.depth = maxLv+1;
	local bound = NGUIMath.CalculateRelativeWidgetBounds(button.transform);
	maskWidget.width = bound.size.x;
	maskWidget.height = bound.size.y;
	NGUITools.UpdateWidgetCollider(mask);
	return temp;
end

function NGUIUtil.CheckScrollViewShouldMove(scrollView)
	local mPanel = scrollView.panel;
	local clip = mPanel.finalClipRegion;
	local b = scrollView.bounds;
	local hx = (clip.z == 0) and Screen.width or clip.z * 0.5;
	local hy = (clip.w == 0) and Screen.height or clip.w * 0.5;
	if (scrollView.canMoveHorizontally)then
		if (b.min.x < clip.x - hx)then
			return true;
		elseif(b.max.x > clip.x + hx)then
			return true;
		end
	elseif(scrollView.canMoveVertically)then
		if(b.min.y < clip.y - hy)then
			return true;
		end
		if(b.max.y > clip.y + hy)then
			return true;
		end
	end
	return false;
end

function NGUIUtil.HelpChangePageByDrag(scrollView, preEvt, nextEvt, offsetValue)
	offsetValue = offsetValue or 100;
	local startPos = nil;
	local mTrans = scrollView.transform;
	local isHorizontally = scrollView.canMoveHorizontally;
	local shouldMove = false;
	scrollView.onDragStarted = function ()
		triggerFunc = nil;
		shouldMove = NGUIUtil.CheckScrollViewShouldMove(scrollView)
	end
	scrollView.onDragFinished = function ()
		local bounds = scrollView.bounds;
		local mPanel = scrollView.panel;
		if(shouldMove)then
			local pCorners = mPanel.worldCorners;
			local topCorner = (pCorners[2]+pCorners[3])*0.5;
			topCorner = mTrans:InverseTransformPoint(topCorner);
			local preVal = isHorizontally and topCorner.x - bounds.max.x or topCorner.y - bounds.max.y;
			if(preVal >= offsetValue)then
				triggerFunc = preEvt;
			end

			local downCorner = (pCorners[1]+pCorners[4])*0.5;
			downCorner = mPanel.transform:InverseTransformPoint(downCorner);
			local nextVal = isHorizontally and bounds.min.x - downCorner.x or bounds.min.y - downCorner.y;
			if(nextVal >= offsetValue)then
				triggerFunc = nextEvt;
			end
		end
	end
	scrollView.onStoppedMoving = function ()
		if(triggerFunc~=nil)then
			triggerFunc();
			triggerFunc = nil;
		end
	end
end


EnlargeCenterCell_Control = class("EnlargeCenterCell_Control");
function EnlargeCenterCell_Control:ctor(scrollView, cellsParent, minScale, changeDis, dir)
	self.v3 = LuaVector3(0,0,0);

	self.scrollView = scrollView;
	self.scrollView_LocalPos_x, self.scrollView_LocalPos_y = LuaGameObject.GetLocalPosition( scrollView.transform );;

	self.cellsParent = cellsParent.transform;
	self.dir = dir;

	local panel = scrollView:GetComponent(UIPanel);
	local cors = panel.worldCorners;
	self.center = cors[1] + cors[2];
	panel.onClipMove = function ()

		for i=1,self.cellsParent.childCount do
			local childTrans = self.cellsParent:GetChild(i-1);
			local pos_x, pos_y = LuaGameObject.GetPosition( childTrans );
			local scale;
			if(dir == 1)then
				local delta = 360 * math.abs(self.center[1] - pos_x) * (1- minScale) / changeDis;
				scale = math.clamp(1 - delta, minScale, 1);
			elseif(dir == 2)then
				local delta = 360 * math.abs(self.center[2] - pos_y) * (1- minScale) / changeDis;
				scale = math.clamp(1 - delta, minScale, 1);
			end
			self.v3:Set(scale, scale, scale);
			childTrans.localScale = self.v3;
		end

	end

	self.centerOnChild = self.cellsParent:GetComponent(UICenterOnChild);
	if(self.centerOnChild == nil)then
		return;
	end
	scrollView.onDragFinished = function ()
		local minDelta, delta, centerTrans = changeDis;
		for i=1,self.cellsParent.childCount do
			local childTrans = self.cellsParent:GetChild(i-1);
			local pos_x, pos_y = LuaGameObject.GetPosition( childTrans );
			if(dir == 1)then
				delta = 360 * math.abs(self.center[1] - pos_x);
			elseif(dir == 2)then
				delta = 360 * math.abs(self.center[2] - pos_y);
			end
			if(delta < minDelta)then
				centerTrans = childTrans
			end
		end
		if(centerTrans == nil and self.cellsParent.childCount > 0)then
			centerTrans = self.cellsParent:GetChild(0);
		end
		if(centerTrans ~= nil)then
			self.centerOnChild:CenterOn(centerTrans);
		end
	end
	self.centerOnChild.onCenter = function (centerGO)
		self:_OnCenter(centerGO);
	end
end
function EnlargeCenterCell_Control:_OnCenter(centerGO)
	self.centerGO = centerGO;

	self.centerIndex = 0;
	local maxNum = self.cellsParent.childCount;
	for i=1,maxNum do
		local trans = self.cellsParent:GetChild(i-1);
		if(trans == centerGO.transform)then
			self.centerIndex = i;
			break;
		end
	end
	if(maxNum > 1)then
		if(self.centerIndex > 1)then
			self.preGO = self.cellsParent:GetChild(self.centerIndex - 2);
		else
			self.preGO = nil;
		end

		if(self.centerIndex < maxNum)then
			self.nextGO = self.cellsParent:GetChild(self.centerIndex);
		else
			self.nextGO = nil;
		end
	end
	if(self.preSymbol)then
		self.preSymbol:SetActive(self.preGO ~= nil);
	end
	if(self.nextSymbol)then
		self.nextSymbol:SetActive(self.nextGO ~= nil);
	end

	if (self.centerEndCall) then
		self.centerEndCall(self.centerEndCallParam, centerGO, self.centerIndex);
	end
end
function EnlargeCenterCell_Control:SetCenterCall( centerEndCall, centerEndCallParam )
	if(self.centerOnChild == nil)then
		return;
	end

	self.centerEndCall = centerEndCall;
	self.centerEndCallParam = centerEndCallParam;
end
function EnlargeCenterCell_Control:SetPreSymbol(go, addEvent)
	self.preSymbol = go;
	if(addEvent)then
		UIEventListener.Get(go).onClick = function (go)
			self.centerOnChild:CenterOn(self.preGO);
		end;
	end
end
function EnlargeCenterCell_Control:SetNextSymbol(go, addEvent)
	self.nextSymbol = go;
	if(addEvent)then
		UIEventListener.Get(go).onClick = function (go)
			self.centerOnChild:CenterOn(self.nextGO);
		end;
	end
end
function EnlargeCenterCell_Control:CenterOn(index, noTween, forceRefresh)
	if(self.centerOnChild == nil)then
		return;
	end
	
	local childTrans = self.cellsParent:GetChild(index - 1);
	if(childTrans)then
		self.scrollView:DisableSpring();
		if(noTween)then
			self.scrollView:ResetPosition();

			local pos_x, pos_y = LuaGameObject.GetLocalPosition( childTrans );

			self.v3:Set(-pos_x + self.scrollView_LocalPos_x, -pos_y + self.scrollView_LocalPos_y);
			self.scrollView.transform.localPosition = self.v3;

			self.v3:Set(pos_x, pos_y);
			self.scrollView.panel.clipOffset = self.v3;
		else
			self.centerOnChild:CenterOn(childTrans);
		end

		if(forceRefresh or self.centerGO ~= childTrans)then
			self:_OnCenter(childTrans);
		end
	end
end
function NGUIUtil.Panel_EnlargeCenterCell(scrollView, cellsParent, minScale, changeDis, dir)
	return EnlargeCenterCell_Control.new(scrollView, cellsParent, minScale, changeDis, dir);
end
