MiniMapWindow = class("MiniMapWindow", CoreView);

MiniMapWindow.MiniMapSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol")

local tempV2, tempV3, tempRot = LuaVector2(), LuaVector3(), LuaQuaternion();

local GetLocalPosition = LuaGameObject.GetLocalPosition;
local GetPosition = LuaGameObject.GetPosition;

function MiniMapWindow:ctor(go)
	MiniMapWindow.super.ctor(self, go);

	self:InitDatas();
	self:InitView();
end

function MiniMapWindow:InitDatas()
	self.npcMap = {};

	self.servernpc_map = {};

	self.exitPointMap = {};
	self.teamMap = {};
	self.questMap = {};
	self.focusMap = {};
	self.focusArrowMap = {};
	self.needFocusFrameMap = {};

	self.scenicMap = {};
	self.sealMap = {};
	self.monsterMap = {};
	self.treeMap = {};

	self.playerMap = {};
	self.gvdDoriyanMap = {};

	self.monsterActive = true;
	self.lastMyPos = LuaVector3();
	self.lastMapScale = 1;
end

function MiniMapWindow:CreateSymbolsParent(parent, name)
	self.mTrans = self.gameObject.transform;

	local symbolObj = GameObject(name);
	symbolObj = symbolObj.transform;
	symbolObj:SetParent( parent.transform, false );
	tempV3:Set(0,0,0);
	symbolObj.localPosition = tempV3;
	tempRot.eulerAngles = tempV3;
	symbolObj.localRotation = tempRot;
	tempV3:Set(1,1,1);
	symbolObj.localScale = tempV3;
	return symbolObj
end

function MiniMapWindow:InitView()
	self.sPanel = self:FindComponent("Panel_S", UIPanel);
	self.dPanel = self:FindComponent("Panel_D", UIPanel);
	local panelSize = self.sPanel:GetViewSize();
	self.panelSize = { panelSize.x, panelSize.y };
	self.sPanel.onClipMove = function ()
		self.dPanel.clipOffset = self.sPanel.clipOffset;
		self.dPanel.transform.localPosition = self.sPanel.transform.localPosition;
	end

	self.mapTexture = self:FindComponent("MapTexture", UITexture, self.sPanel.gameObject);
	self.mapLabel = self:FindGO("MapLabel", self.mapTexture.gameObject);

	self.s_symbolParent = self:CreateSymbolsParent(self.mapTexture.transform, "symbolsParent");
	self.d_symbolParent = self:CreateSymbolsParent(self.dPanel, "symbolsParent");

	if(self.destTransEffect)then
		self.destTransEffect:Destroy();
		self.destTransEffect = nil;
	end
	self.destTransEffect = self:PlayUIEffect(EffectMap.UI.MapPoint, 
		self.d_symbolParent.gameObject, 
		false, 
		nil,
		self);
	self.destTransEffect:RegisterWeakObserver(self);
	self.destTransEffect:SetActive(false);

	if(self.tipTransEffect)then
		self.tipTransEffect:Destroy();
		self.tipTransEffect = nil;
	end
	self.tipTransEffect = self:PlayUIEffect(EffectMap.UI.MapPoint2, 
		self.d_symbolParent.gameObject, 
		false, 
		nil, 
		self);
	self.tipTransEffect:RegisterWeakObserver(self);
	self.tipTransEffect:SetActive(false);

	local myTransSymbol = self:GetMapSymbol("map_mypos", 100, 1, self.s_symbolParent);
	self.myTrans = myTransSymbol.transform;

	local eventManager = EventManager.Me()
	eventManager:AddEventListener(
		LoadSceneEvent.BeginLoadScene, self.OnSceneBeginChanged, self)
end

function MiniMapWindow:ObserverDestroyed(obj)
	if(obj == self.mapPoint2_Effect)then
		self.mapPoint2_Effect = nil;
	end
end

function MiniMapWindow._DestTransEffectHandle( effectHandle,self )
	if(self)then
		local tipGO = effectHandle.gameObject;
		MiniMapWindow._AdjustEffectTextureDepth(tipGO);
	end
end

function MiniMapWindow._TipTransEffectHandle( effectHandle,self )
	if(self and effectHandle)then
		local tipGO = effectHandle.gameObject;
		MiniMapWindow._AdjustEffectTextureDepth(tipGO);
	end
end

function MiniMapWindow._AdjustEffectTextureDepth(go)
	local sps = UIUtil.GetAllComponentsInChildren(go, UITexture)
	local minDepth = 50;
	for i=1,#sps do
		sps[i].depth = minDepth + sps[i].depth % 10;
	end
end

function MiniMapWindow:IsActive()
	if(Slua.IsNull(self.gameObject))then
		return false;
	end

	return self.gameObject.activeSelf;
end

function MiniMapWindow:Show()
	self.active = true;
	self.gameObject:SetActive(true);

	self:OpenCheckMyPos();

	self:PlayQuestSymbolShow();
end

function MiniMapWindow:Hide()
	self.active = false;
	self.gameObject:SetActive(false);

	self:CloseCheckMyPos();
end

function MiniMapWindow:SetLock(b)
	self.lock = b;
	self.mapTexture:GetComponent(BoxCollider).enabled = not b;
end

function MiniMapWindow:GetMapSymbol(sname, depth, scale, parent)
	local parent = parent or self.s_symbolParent;
	local result = Game.AssetManager_UI:CreateSceneUIAsset( MiniMapWindow.MiniMapSymbolPath, parent );
	-- local result = self:CopyGameObject(sel.mapSymbol, parent);
	local sprite = result:GetComponent(UISprite);
	IconManager:SetMapIcon(sname, sprite);
	sprite:MakePixelPerfect();

	scale = scale or 0.7;
	sprite.width = sprite.width * scale;
	sprite.height = sprite.height * scale;

	if(depth)then
		sprite.depth = depth;
	end

	return result;
end

function MiniMapWindow:RemoveMiniMapSymbol(obj)
	if(not self:ObjIsNil(obj))then
		Game.GOLuaPoolManager:AddToUIPool(MiniMapWindow.MiniMapSymbolPath, obj);
	end
end

function MiniMapWindow:ResetMoveCMD(cmd)
	if nil ~= self.moveCMD then
		self.moveCMD:Shutdown()
	end
	self.moveCMD = cmd
end

function MiniMapWindow:OnSceneBeginChanged()
	self:ResetMoveCMD(nil)
end

local tempArgs = {};
function MiniMapWindow:AddMapClick()
	local uiCamera = NGUIUtil:GetCameraByLayername("UI");
	self:AddClickEvent(self.mapTexture.gameObject, function (go)
		if(self.lock)then
			return;
		end

		local inputWorldPos = uiCamera:ScreenToWorldPoint(Input.mousePosition);
		tempV3[1], tempV3[2], tempV3[3] = LuaGameObject.InverseTransformPointByVector3(self.mapTexture.transform, inputWorldPos);
		local p = self:MapPosToScene(tempV3);
		if(p)then
			local currentMapID = Game.MapManager:GetMapID();
			local disableInnerTeleport = Table_Map[currentMapID].MapNavigation
			if nil ~= disableInnerTeleport and 0 ~= disableInnerTeleport then
				self:ResetMoveCMD(nil)
				Game.Myself:Client_MoveTo(p)
			else
				TableUtility.TableClear(tempArgs);
				
				tempArgs.targetMapID = currentMapID;
				tempArgs.targetPos = p;
				tempArgs.showClickGround = true
				tempArgs.allowExitPoint = true

				local x,y,z = p[1],p[2],p[3];
				tempArgs.callback = function(cmd, event)
					if MissionCommandMove.CallbackEvent.TeleportFailed == event then
						tempV3:Set(x,y,z);
						Game.Myself:Client_MoveTo( tempV3 );
					end
				end

				local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove);
				if(cmd)then
					Game.Myself:Client_SetMissionCommand( cmd );
				end
			end
		end
	end);
end

function MiniMapWindow:UpdateMapTexture(data, size, map2D)
	self.mapdata = data;
	self.map2D = map2D;
	if(map2D and data)then
		local resName = "Scene" .. data.NameEn;
		if(map2D.ID > 0)then
			resName = resName .. "_" .. map2D.ID;
		end
		PictureManager.Instance:SetMiniMap(resName, self.mapTexture);
		-- local cacheTex = map2D.CachedTexture;
		-- if(cacheTex)then
		-- 	self.mapTexture.mainTexture = map2D.CachedTexture;
		-- else
		-- 	map2D:ListenTextureIsGenerated(function ()
		-- 		self.iMoved = true;
		-- 		self.mapTexture.mainTexture = map2D.CachedTexture;
		-- 	end);
		-- end
		if(size)then
			self.mapTexture.width = size[1];
			self.mapTexture.height = size[2];
		end
		self.mapsize = {};
		self.mapsize.x = self.mapTexture.width;
		self.mapsize.y = self.mapTexture.height;
		
		self:UpdateMyPos(true);
		NGUITools.UpdateWidgetCollider (self.mapTexture.gameObject);

		-- tempV3:Set(0, 0, 0);
		-- self.mapTexture.transform.localPosition = tempV3;
	else
		self.mapTexture.mainTexture = nil;
	end
	self:UpdateNpcPoints();
	self:UpdateExitPoints();

	if(not self.emptyParama)then
		self.emptyParama = {};
	end
	self:UpdateTeamMemberSymbol(self.emptyParama, true);
	self:UpdateQuestNpcSymbol(self.emptyParama, true);
	self:UpdateSealSymbol(self.emptyParama, true);

	self.iMoved = true;
end

function MiniMapWindow:SetMapScale(scale)
	if(scale and scale~=self.lastMapScale)then
		local pct = scale/self.lastMapScale;
		local symbolPct = (scale*0.5+0.5)/(self.lastMapScale*0.5+0.5);

		self.mapsize.x = self.mapsize.x*pct;
		self.mapsize.y = self.mapsize.y*pct;
		self.mapTexture.width = self.mapsize.x;
		self.mapTexture.height = self.mapsize.y;
		NGUITools.UpdateWidgetCollider (self.mapTexture.gameObject);

		tempV3[1],tempV3[2],tempV3[3] = GetPosition(self.s_symbolParent);
		self.d_symbolParent.position = tempV3;

		for i=1,self.s_symbolParent.childCount do
			local symbol = self.s_symbolParent:GetChild(i-1);
			tempV3[1], tempV3[2], tempV3[3] = GetLocalPosition(symbol)
			symbol.localPosition = tempV3 * pct;

			-- local scalePct = pct > 1 and pct * 0.75 or pct / 0.75
			symbol.localScale = symbol.localScale * symbolPct;
		end
		for i=1,self.d_symbolParent.childCount do
			local symbol = self.d_symbolParent:GetChild(i-1);
			tempV3[1], tempV3[2], tempV3[3] = GetLocalPosition(symbol)
			symbol.localPosition = tempV3 * pct;

			-- local scalePct = pct > 1 and pct * 0.75 or pct / 0.75
			symbol.localScale = symbol.localScale * symbolPct;
		end

		self.lastMapScale = scale;
	end
end

function MiniMapWindow:MapPosToScene(pos)
	if(self.map2D)then
		local width,height = self.mapsize.x, self.mapsize.y;
		local px = (pos.x + width*0.5)/width ;
		local py = (pos.y + height*0.5)/height;
		local x,y,z = self.map2D:GetPositionByXY(px, py);
		tempV3:Set(x, y, z);
		return tempV3;
	end
end

local scenePos_mapPos = LuaVector3.zero;
function MiniMapWindow:ScenePosToMap(pos)
	if(self.map2D)then
		local mapxPct, mapyPct = self.map2D:GetCoordinate01ByXZ(pos[1], pos[3]);

		local texWidth = self.mapsize.x;
		local texHeight = self.mapsize.y;
		local x = mapxPct * texWidth - texWidth / 2;
		math.clamp(x, -texWidth/2, texWidth/2);
		
		local y = mapyPct * texHeight - texHeight / 2;
		math.clamp(y, -texHeight/2, texHeight/2);

		scenePos_mapPos:Set(x, y, 0);
		return scenePos_mapPos;
	end
end

function MiniMapWindow:SetUpdateEvent(event, owner)
	self.updateEvent = event;
	self.updateEventOwner = owner;
end

function MiniMapWindow:OpenCheckMyPos()
	TimeTickManager.Me():CreateTick(0, 33, MiniMapWindow._CheckMyPos, self, 1);
end

function MiniMapWindow._CheckMyPos(self, deltatime)
	self:UpdateMyPos();
end

function MiniMapWindow:CloseCheckMyPos()
	TimeTickManager.Me():ClearTick(self, 1);
end

function MiniMapWindow:UpdateMyPos(forceUpdate)
	local role = Game.Myself;
	if(role)then
		local nowMyPos = role:GetPosition();
		if(not nowMyPos)then
			return;
		end
		if( forceUpdate or VectorUtility.DistanceXZ(self.lastMyPos, nowMyPos) > 0.01)then
			self:HelpUpdatePos(self.myTrans, nowMyPos);

			local angleY = role:GetAngleY();
			if(angleY)then
				tempV3:Set(0,0,-angleY);
				tempRot.eulerAngles = tempV3;
				self.myTrans.rotation = tempRot;
			end

			if(self.updateEvent)then
				self.updateEvent(self.updateEventOwner, self);
			end

			self.iMoved = true;
			self.lastMyPos:Set(nowMyPos[1], 0, nowMyPos[3]);
		else
			self.iMoved = false;
		end

		self:UpdateFocusArrowPos();
	end
end

function MiniMapWindow:UpdateDestPos(destPos)
	if(self.map2D == nil)then
		return;
	end

	if(not self.destTransEffect)then
		return;
	end

	local nowMyPos = Game.Myself:GetPosition();
	if(destPos and VectorUtility.DistanceXZ(destPos, nowMyPos) > 0.01)then
		if(not self.destTransEffect:IsActive())then
			self.destTransEffect:SetActive(true);
		end

		self.destTransEffect:ResetLocalPosition(self:ScenePosToMap(destPos));
	else
		if(self.destTransEffect:IsActive())then
			self.destTransEffect:SetActive(false);
		end
	end
end

function MiniMapWindow:SetTipPos(pos)
	if(not self.tipTransEffect)then
		return;
	end

	if(pos)then
		self.tipTransEffect:SetActive(true);

		self.tipTransEffect:ResetLocalPosition(self:ScenePosToMap(pos));

		if(self.tipPosLt)then
			self.tipPosLt:cancel();
			self.tipPosLt = nil;
		end
		self.tipPosLt = LeanTween.delayedCall(3, function ()
			self.tipTransEffect:SetActive(false);
			self.tipPosLt = nil;
		end)
	else
		self.tipTransEffect:SetActive(false);
	end
end

function MiniMapWindow:HelpUpdatePos(symbol, scenePos)
	local spos = self:ScenePosToMap(scenePos);
	if(spos)then
		symbol.transform.localPosition = spos;
		return true;
	end
	return false;
end

function MiniMapWindow:CenterOnMyPos(restrictWithPanel)
	self:CenterOnTrans(self.myTrans, restrictWithPanel);
end

local cc, cp, bsize, offset = LuaVector3(), LuaVector3(), LuaVector3(), LuaVector3();
function MiniMapWindow:CenterOnTrans(trans, restrictWithPanel)
	if(not trans)then 
		return;
	end

	local sPanelTrans = self.sPanel.transform;
	cc[1], cc[2], cc[3] = LuaGameObject.InverseTransformPointByVector3(sPanelTrans, self.mTrans.position);
	cp[1], cp[2], cp[3] = LuaGameObject.InverseTransformPointByVector3(sPanelTrans, trans.position);

	if(restrictWithPanel)then
		local mBound = NGUIMath.CalculateRelativeWidgetBounds(self.mapTexture.transform);
		local mBound_Size = mBound.size;
		bsize[1] = mBound_Size.x - self.panelSize[1];
		bsize[2] = mBound_Size.y - self.panelSize[2];
		bsize[3] = 0;
		local checkBound = Bounds(mBound.center, bsize);
		if (not checkBound:Contains (cp)) then
			cp = checkBound:ClosestPoint (cp);
		end
	end
	
	LuaVector3.Better_Sub(cp, cc, offset)

	local x, y, z = GetLocalPosition(sPanelTrans);
	tempV3:Set(x - offset[1], y - offset[2], offset[3] - z);
	sPanelTrans.localPosition = tempV3;

	self.sPanel.clipOffset = self.sPanel.clipOffset + offset;
end

function MiniMapWindow:ResetMapPos()
	tempV2:Set(0, 0);
	self.sPanel.clipOffset = tempV2;

	tempV3:Set(0,0,0);
	self.sPanel.transform.localPosition = tempV3;
	self.dPanel.transform.localPosition = tempV3;
end

function MiniMapWindow:EnableDrag(b)
	local dragScrollView = self.mapTexture:GetComponent(UIDragScrollView);
	if(not dragScrollView)then
		dragScrollView = self.mapTexture:AddComponent(UIDragScrollView);
	end
	dragScrollView.enabled = b;
end

function MiniMapWindow:ShowOrHideExitInfo(b)
	for k,exitObj in pairs(self.exitPointMap)do
		if(not self:ObjIsNil(exitObj) and exitObj.transform.childCount>0)then
			local info = exitObj.transform:GetChild(0);
			if(not self:ObjIsNil(info.gameObject))then
				info.gameObject:SetActive(b);
			end
		end
	end
end

function MiniMapWindow:ActiveSymbols(b)
	self.s_symbolParent.gameObject:SetActive(b);
	self.d_symbolParent.gameObject:SetActive(b);
end

-- if no createFunc, then must SetParama("Symbol")
function MiniMapWindow:HelpUpdatePoses(cacheMap, datas, createFunc, updateFunc, removeFunc, isRemoveOther)
	for key,data in pairs(datas) do
		local symbolObj = cacheMap[key];
		if(self:ObjIsNil(symbolObj))then
			if(type(createFunc)=="function")then
				symbolObj = createFunc(self, data);
			else
				symbolObj = self:GetMapSymbol( data:GetParama("Symbol"), 5 );
			end
		else
			if(type(updateFunc)=="function")then
				symbolObj = updateFunc(self, symbolObj, data);
			end
		end
		self:HelpUpdatePos(symbolObj, data.pos);
		cacheMap[key] = symbolObj;
	end

	if(isRemoveOther == nil or isRemoveOther == true)then
		if(removeFunc)then
			for key,symbolObj in pairs(cacheMap) do
				if(not datas[key])then
					removeFunc(self, key);
					cacheMap[key] = nil;
				end
			end
		else
			for key,symbolObj in pairs(cacheMap) do
				if(not datas[key])then
					self:RemoveMiniMapSymbol(symbolObj);
					cacheMap[key] = nil;
				end
			end
		end
	end
end


-- npc and exitPoint begin
local miniMapRemoveFunc = function (data)
	data:Destroy();
end
function MiniMapWindow:_CreateExitPoint(data)
	local symbolObj = self:GetMapSymbol(data:GetParama("Symbol"), 6);
	if(not self:ObjIsNil(symbolObj))then
		symbolObj.gameObject:SetActive( data:GetParama("active") );
		local nextSceneID = data:GetParama("nextSceneID");
		if( nextSceneID )then
			local nextMapData = Table_Map[ nextSceneID ];
			if(nextMapData)then
				local info = self:CopyGameObject(self.mapLabel, symbolObj.transform);
				if(info)then
					info.name = tostring(nextSceneID);
					tempV3:Set(0, 15, 0);
					info.transform.localPosition = tempV3;
					tempV3:Set(0.75, 0.75, 0.75);
					info.transform.localScale = tempV3;
					local label = info:GetComponent(UILabel);
					label.depth = 31;
					label.text = ZhString.MiniMapWindow_Go..nextMapData.NameZh;
				end
			end
		end
	end
	return symbolObj;
end

function MiniMapWindow:_UpdateExitPoint( symbolObj, data )
	if(not self:ObjIsNil(symbolObj))then
		symbolObj.gameObject:SetActive( data:GetParama("active") );
		local sp = symbolObj.gameObject:GetComponent(UISprite);
		sp.spriteName = data:GetParama("Symbol");
		
		if(symbolObj.transform.childCount>0)then
			local info = symbolObj.transform:GetChild(0);
			local nextSceneID = data:GetParama("nextSceneID");
			if(info.name~=tostring(nextSceneID))then
				info.name = tostring(nextSceneID);
				local label = info:GetComponent(UILabel);
				local nextMapData = Table_Map[nextSceneID];
				if(label and nextMapData)then
					label.text = ZhString.MiniMapWindow_Go..nextMapData.NameZh;
				end
			end
		end
	end
	return symbolObj;
end

function MiniMapWindow:_RemoveExitPoint( key )
	if(not key)then
		return;
	end

	local exitPoint = self.exitPointMap[key];
	if(not Slua.IsNull(exitPoint))then
		if(exitPoint.transform.childCount>0)then
			local info = exitPoint.transform:GetChild(0);
			if(not Slua.IsNull(info))then
				GameObject.Destroy(info.gameObject);
			end
		end
		self:RemoveMiniMapSymbol(exitPoint);
	end
end

function MiniMapWindow:UpdateNpcPoints()
	-- npcPoint
	if(nil == self.npcMapDatas)then
		self.npcMapDatas = {};
	else
		TableUtility.TableClearByDeleter(self.npcMapDatas, miniMapRemoveFunc)
	end
	local npcList = Game.MapManager:GetNPCPointArray();
	if(npcList)then
		for i=1,#npcList do
			local v = npcList[i];
			if(v and v.ID and v.position)then
				local npcData = Table_Npc[v.ID];
				local mapIcon = npcData and npcData.MapIcon;
				if(mapIcon and mapIcon~='' and npcData.NoShowMapIcon ~= 1)then
					local isUnlock = true;
					if(npcData.MenuId ~= nil)then
						isUnlock = FunctionUnLockFunc.Me():CheckCanOpen(npcData.MenuId);
					end
					if(isUnlock)then
						local combineID = v.ID .. v.uniqueID;
						local npcMapData = self.npcMapDatas[combineID];
						if(npcMapData == nil)then
							npcMapData = MiniMapData.CreateAsTable(combineID);
							self.npcMapDatas[combineID] = npcMapData;
						end
						npcMapData:SetPos(v.position[1], v.position[2], v.position[3]);
						npcMapData:SetParama("Symbol", mapIcon);
					end
				end
			end
		end
	end
	self:HelpUpdatePoses(self.npcMap, self.npcMapDatas);
end

function MiniMapWindow:UpdateExitPoints()
	-- exitPoint
	if(nil == self.exitMapDatas)then
		self.exitMapDatas = {};
	else
		TableUtility.TableClearByDeleter(self.exitMapDatas, miniMapRemoveFunc)
	end
	local exitList = Game.MapManager:GetExitPointArray();
	if(exitList)then
		local table_Map = Table_Map;
		for i=1,#exitList do
			local v = exitList[i];
			if(v and v.ID and v.position)then
				local exitData = self.exitMapDatas[v.ID];
				if(exitData == nil)then
					exitData = MiniMapData.CreateAsTable(v.ID, v.position, parama);
				end
				exitData:SetPos(v.position[1], v.position[2], v.position[3]);

				local active = Game.AreaTrigger_ExitPoint:IsInvisible(v.ID) == false;
				exitData:SetParama("active", active);

				if(v.nextSceneID == 0)then
					exitData:SetParama("active", false);
				elseif(v.nextSceneID ~= nil)then
					exitData:SetParama("nextSceneID", v.nextSceneID);

					local nextMapData = table_Map[v.nextSceneID]
					if(nextMapData ~= nil)then
						if(nextMapData.IsDangerous)then
							exitData:SetParama("Symbol", "map_gateway1");
						else
							exitData:SetParama("Symbol", "map_gateway");
						end
					else
						exitData:SetParama("Symbol", "map_gateway");
					end
				end

				self.exitMapDatas[v.ID] = exitData;
			end
		end
	end
	self:HelpUpdatePoses(self.exitPointMap, 
		self.exitMapDatas, 
		MiniMapWindow._CreateExitPoint, 
		MiniMapWindow._UpdateExitPoint,
		MiniMapWindow._RemoveExitPoint);
end

function MiniMapWindow:UpdateNpcPointMap(datas, isRemoveOther)
	self:HelpUpdatePoses(self.npcMap,
		datas, 
		nil, 
		nil,
		nil,
		isRemoveOther);
end

function MiniMapWindow:RemoveNpcPointMap(npcid)
	if(npcid == nil)then
		return;
	end
	
	local miniMapSymbol = self.npcMap[npcid];
	if(miniMapSymbol)then
		self:RemoveMiniMapSymbol(miniMapSymbol);
		self.npcMap[npcid] = nil;
	end
end

function MiniMapWindow:UpdateNpcPointState(npcid, state)
	if(npcid and not self:ObjIsNil(self.npcMap[npcid]))then
		self.npcMap[npcid].gameObject:SetActive(state);
	end
end

function MiniMapWindow:UpdateExitPointMapState(id, state)
	if(not self:ObjIsNil(self.exitPointMap[id]))then
		self.exitPointMap[id].gameObject:SetActive(state);
	end
end

function MiniMapWindow:UpdateServerNpcPointMap(datas, isRemoveOther)
	self:HelpUpdatePoses(self.servernpc_map,
		datas, 
		nil, 
		nil,
		nil,
		isRemoveOther);
end

function MiniMapWindow:RemoveServerNpcPointMap(npcid)
	if(npcid == nil)then
		return;
	end
	
	local miniMapSymbol = self.servernpc_map[npcid];
	if(miniMapSymbol)then
		self:RemoveMiniMapSymbol(miniMapSymbol);
		self.servernpc_map[npcid] = nil;
	end
end

-- npc and exitPoint end




-- mapBoss begin
function MiniMapWindow:UpdateBossSymbol(pos)
	if(pos)then
		if(self:ObjIsNil(self.bossSymbol))then
			self.bossSymbol = self:GetMapSymbol("map_boss", 8);
		end
		self:HelpUpdatePos(self.bossSymbol, pos);
	else
		self:RemoveMiniMapSymbol(self.bossSymbol);
		self.bossSymbol = nil;
	end
end
-- mapBoss end



-- bigCat begin
function MiniMapWindow:UpdateBigCatSymbol(pos)
	if(pos)then
		if(self:ObjIsNil(self.bigCatSymbol))then
			self.bigCatSymbol = self:GetMapSymbol("map_boss", 9);
		end
		self:HelpUpdatePos(self.bigCatSymbol, pos);
	else
		self:RemoveMiniMapSymbol(self.bigCatSymbol);
		self.bigCatSymbol = nil;
	end
end
-- bigCat end



-- teamMember begin
function MiniMapWindow:UpdateTeamMemberSymbol(datas, isRemoveOther)
	self:HelpUpdatePoses(self.teamMap, datas, nil, nil, nil, isRemoveOther);
end

function MiniMapWindow:RemoveTeamMemberSymbol(key)
	local obj = self.teamMap[key];
	self:RemoveMiniMapSymbol(obj);
	self.teamMap[key] = nil;
end
-- teamMember end



-- quest begin
function MiniMapWindow:_CreateQuestNpcSymbol( data )
	local symbolType = data:GetParama("SymbolType");

	local config = QuestSymbolConfig[symbolType];
	local symbolKey = config and config.UISymbol;
	symbolKey = symbolKey or 44;
	local symbolPath = ResourcePathHelper.EffectUI(symbolKey);

	local obj = Game.AssetManager_UI:CreateAsset(symbolPath, self.d_symbolParent);
	obj.name = symbolType;

	local widget = UIUtil.GetAllComponentInChildren(obj, UIWidget)
	if(widget)then
		widget.depth = 11;
	end

	return obj;
end

function MiniMapWindow:_UpdateQuestNpcSymbol( obj, data )
	if(obj)then
		local symbolType = data:GetParama("SymbolType");
		if( obj.name ~= tostring(symbolType) )then
			self:RemoveMiniMapSymbol(obj);
			obj = self:_CreateQuestNpcSymbol( data );
		end
	end
	return obj;
end

function MiniMapWindow:_RemoveQuestNpcSymbol( id )
	local obj = self.questMap[id];
	if(not Slua.IsNull(obj))then
		local symbolType = obj.name;
		local config = QuestSymbolConfig[symbolType];
		if(config and config.UISymbol)then
			local symbolPath = ResourcePathHelper.EffectUI(config.UISymbol);
			Game.AssetManager_UI:AddToUIPool(symbolPath, obj);
		else
			GameObject.Destroy(obj);
		end
	end
end

function MiniMapWindow:UpdateQuestNpcSymbol(datas, isRemoveOther)
	if(self:IsActive())then
		self:HelpUpdatePoses(self.questMap, 
			datas, 
			MiniMapWindow._CreateQuestNpcSymbol, 
			MiniMapWindow._UpdateQuestNpcSymbol,  
			MiniMapWindow._RemoveQuestNpcSymbol,
			isRemoveOther);
	end
end

function MiniMapWindow:PlayQuestSymbolShow()
	local tempMap = {};
	for _,obj in pairs(self.questMap)do
		if(not self:ObjIsNil(obj))then
			table.insert(tempMap, obj);
		end
	end
	self:DelayShowObjLst(tempMap, 100, function (obj)
		local animator = obj:GetComponent(Animator);
		animator:Play ("map_icon_task", -1, 0);
	end);
end

function MiniMapWindow:DelayShowObjLst(objlst, spacetime, showCall)
	TimeTickManager.Me():ClearTick(self, 2);

	if(type(objlst)=="table" and #objlst>0)then
		for i=1,#objlst do
			if(not self:ObjIsNil(objlst[i]))then
				objlst[i].gameObject:SetActive(false);
			end
		end

		spacetime = spacetime or 300;
		local index = 0;
		TimeTickManager.Me():CreateTick(0, spacetime, function (self)
			index = index+1;
			if(not self:ObjIsNil(objlst[index]))then
				objlst[index].gameObject:SetActive(true);
				if(type(showCall)=="function")then
					showCall(objlst[index].gameObject);
				end
			end
			if(index>=#objlst)then
				TimeTickManager.Me():ClearTick(self, 2);
			end
		end, self, 2);
	end
end
-- quest end



-- QuestFocus begin
local QUEST_FOCUS_PATH = ResourcePathHelper.EffectUI( EffectMap.UI.MapIndicates );

function MiniMapWindow:_CreateQuestFocus( data )
	local obj = Game.AssetManager_UI:CreateAsset(QUEST_FOCUS_PATH, self.d_symbolParent);
	MiniMapWindow._AdjustEffectTextureDepth(obj);
	obj:SetActive(true);

	local questId = data:GetParama("questId")
	obj.name = tostring( questId );

	return obj;
end

function MiniMapWindow:_UpdateQuestFocus( obj, data )
	local spos = self:ScenePosToMap(data.pos);
	self:HelpUpdatePos(obj.transform, data.pos);
	return obj;
end

function MiniMapWindow:_RemoveQuestFocus( key )
	self.questFocusDirty = true;
	if(not key)then
		return;
	end

	local obj = self.focusMap[key];
	if(not Slua.IsNull(obj))then
		Game.GOLuaPoolManager:AddToUIPool(QUEST_FOCUS_PATH, obj);
	end
	self.focusMap[key] = nil;

	local arrow = self.focusArrowMap[key];
	if(not Slua.IsNull(arrow))then
		self:RemoveMiniMapSymbol(arrow);
	end
	self.focusArrowMap[key] = nil;
end

function MiniMapWindow:UpdateQuestFocuses(datas, isRemoveOther)
	self.questFocusDirty = true;
	self:HelpUpdatePoses(self.focusMap, 
		datas, 
		MiniMapWindow._CreateQuestFocus, 
		MiniMapWindow._UpdateQuestFocus,
		MiniMapWindow._RemoveQuestFocus,
		isRemoveOther);
end

function MiniMapWindow:ActiveFocusArrowUpdate(b)
	self.updateFocusArrow = b;
end

local dirV3 = LuaVector3();
function MiniMapWindow:UpdateFocusArrowPos()
	if(not self.updateFocusArrow)then
		return;
	end

	if(not self.questFocusDirty and not self.iMoved)then
		return;
	end

	self.questFocusDirty = false;

	for key,focus in pairs(self.focusMap)do
		local pHalfSize_x, pHalfSize_y = self.panelSize[1]/2, self.panelSize[2]/2;

		local focusPos_x, focusPos_y = GetLocalPosition(focus.transform);
		local myPos_x, myPos_y = GetLocalPosition(self.myTrans);
		dirV3:Set(focusPos_x - myPos_x, focusPos_y - myPos_y, 0);

		local arrow = self.focusArrowMap[key];
		if(math.abs(dirV3.x) > pHalfSize_x or 
			math.abs(dirV3.y) > pHalfSize_y)then
			if(focus.gameObject.activeSelf)then
				focus:SetActive(false);
			end

			if(Slua.IsNull(arrow))then
				arrow = self:GetMapSymbol("map_dir", 100);
				tempV3:Set(1.5, 1.5, 1.5);
				arrow.transform.localScale = tempV3;
				self.focusArrowMap[key] = arrow;
			end

			local pct = 1;
			if(math.abs(dirV3.y)/math.abs(dirV3.x) > math.abs(pHalfSize_y)/math.abs(pHalfSize_x))then
				pct = (pHalfSize_y - 10) / math.abs(dirV3.y);
			else
				pct = (pHalfSize_x - 10) / math.abs(dirV3.x);
			end
			tempV3:Set(dirV3.x * pct + myPos_x, dirV3.y * pct + myPos_y, 0);
			arrow.transform.localPosition = tempV3;

			tempV3:Set(0,1,0);
			local angle = LuaVector3.Angle(tempV3, dirV3);
			angle = dirV3.x > 0 and -angle or angle;
			tempV3:Set(0, 0, angle);
			tempRot.eulerAngles = tempV3;
			arrow.transform.localRotation = tempRot;

			if(self.needFocusFrameMap[key])then
				self:PlayFocusFrameEffect(key);
			end
		else
			if(not focus.gameObject.activeSelf)then
				focus:SetActive(true);
			end
			self:RemoveMiniMapSymbol(arrow);
			self.focusArrowMap[key] = nil;
		end
	end
end

function MiniMapWindow._PlayFocusFrameEffect(effectHandle, args)
	if(effectHandle and args)then
		tempV3:Set(args[1], args[2], args[3]);
		effectHandle.transform.position = tempV3;
		MiniMapWindow._AdjustEffectTextureDepth(effectHandle.gameObject);
	end
end

function MiniMapWindow:PlayFocusFrameEffect(id)
	local parent = FloatingPanel.Instance.gameObject;

	if(not id or Slua.IsNull(parent))then
		return;
	end

	local focus = self.focusMap[id];
	if(Slua.IsNull(focus))then
		return;
	end

	local pos_x, pos_y, pos_z;
	local focusPos_x, focusPos_y = LuaGameObject.InverseTransformPointByTransform(self.dPanel.transform, focus.transform, Space.World);
	local myPos_x, myPos_y = LuaGameObject.InverseTransformPointByTransform(self.dPanel.transform, self.mTrans.transform, Space.World);
	local pHalfSize_x, pHalfSize_y = self.panelSize[1]/2, self.panelSize[2]/2;
	if(math.abs(focusPos_x - myPos_x) > pHalfSize_x or 
			math.abs(focusPos_y - myPos_y) > pHalfSize_y)then

		local arrow = self.focusArrowMap[id];
		if(Slua.IsNull(arrow))then
			self.needFocusFrameMap[id] = true;
			return;
		else
			self.needFocusFrameMap[id] = nil;
			pos_x, pos_y, pos_z = GetPosition(arrow.transform);
		end
	else
		pos_x, pos_y, pos_z = GetPosition(focus.transform);
	end

	if(pos_x and pos_y and pos_z)then
		local args = { pos_x, pos_y, pos_z };
		self:PlayUIEffect(EffectMap.UI.MapPoint, 
					parent, 
					true, 
					MiniMapWindow._PlayFocusFrameEffect, 
					args);
	end
end

function MiniMapWindow:RemoveQuestFocusByQuestId( questId )
	self:_RemoveQuestFocus(questId);
end
-- QuestFocus end



-- sceneSpot begin
function MiniMapWindow:_CreateScenicSpot( data )
	local symbol = data:GetParama("Symbol");
	local obj = self:GetMapSymbol(symbol, 6);
	obj.name = symbol;
	return obj;
end

function MiniMapWindow:_UpdateScenicSpot( obj, data )
	if(not self:ObjIsNil(obj))then
		local symbol = data:GetParama("Symbol");
		if( symbol~=obj.name )then
			local sp = obj:GetComponent(UISprite);
			sp.spriteName = symbol;
			obj.name = symbol;
		end
	end
	return obj;
end

function MiniMapWindow:UpdateScenicSpotSymbol(datas, isRemoveOther)
	self:HelpUpdatePoses(self.scenicMap, 
		datas, 
		MiniMapWindow._CreateScenicSpot, 
		MiniMapWindow._UpdateScenicSpot, 
		nil,
		isRemoveOther);
end

function MiniMapWindow:RemoveScenicSpotSymbol(id)
	local obj = self.scenicMap[id];
	self:RemoveMiniMapSymbol(obj);
	self.scenicMap[id] = nil;
end
-- sceneSpot end



-- seal begin
function MiniMapWindow:_CreateSealSymbol(data)
	local symbol = data:GetParama("Symbol");
	local obj = self:GetMapSymbol(symbol, 8);
	obj.name = symbol;
	return obj;
end

function MiniMapWindow:_UpdateSealSymbol(obj, data)
	if(not self:ObjIsNil(obj))then
		local symbol = data:GetParama("Symbol");
		if( symbol~=obj.name )then
			local sp = obj:GetComponent(UISprite);
			sp.spriteName = symbol;
			obj.name = symbol;
		end
	end
	return obj;
end

function MiniMapWindow:UpdateSealSymbol(datas, isRemoveOther)
	self:HelpUpdatePoses(self.sealMap,
		datas,
		MiniMapWindow._CreateSealSymbol,
		MiniMapWindow._UpdateSealSymbol,
		nil,
		isRemoveOther);
end
-- seal end



-- around Monster begin
function MiniMapWindow:ActiveNearlyMonsters(b)
	self.monsterActive = b;
	for _,symbolObj in pairs(self.monsterMap)do
		if(not self:ObjIsNil(symbolObj))then
			symbolObj:SetActive(b);
		end
	end
end

local MonsterPoint_Path = ResourcePathHelper.UICell("MiniMapSymbol_Monster")
function MiniMapWindow:_CreateMonsterPoints( data )

	if(Slua.IsNull(self.gameObject))then
		return;
	end

	local go = Game.AssetManager_UI:CreateSceneUIAsset( MonsterPoint_Path, self.s_symbolParent );
	self:_UpdateMonsterPoints(go, data);

	return go;
end

local Format_MonsterObjId = function (symbol, depth, monster_icon)
	return string.format(symbol, depth or "", monster_icon or "");
end
function MiniMapWindow:_UpdateMonsterPoints( obj, data )
	if(Slua.IsNull(self.gameObject))then
		return;
	end
	if(Slua.IsNull(obj))then
		return;
	end

	local symbol = data:GetParama("Symbol") or "";
	local depth = data:GetParama("depth") or 0;
	local monsterIcon = data:GetParama("monster_icon");

	local objId = Format_MonsterObjId(symbol, depth, monsterIcon);
	if(objId == obj.name)then
		return obj;
	end

	obj.name = objId;

	local sp = obj:GetComponent(UISprite);
	IconManager:SetMapIcon(symbol, sp);
	sp.depth = depth + 22;

	local bg = self:FindGO("Bg", obj);
	if(monsterIcon ~= nil)then
		bg:SetActive(true);

		IconManager:SetFaceIcon(monsterIcon, sp)
		sp:MakePixelPerfect();
		sp.width = sp.width * 0.35
		sp.height = sp.height * 0.35
	else
		bg:SetActive(false);

		sp:MakePixelPerfect();
		sp.width = sp.width * 0.6
		sp.height = sp.height * 0.6
	end

	return obj;
end

function MiniMapWindow:_RemoveMonsterPoints(key)
	local obj = self.monsterMap[key];
	self.monsterMap[key] = nil;
	if(Slua.IsNull(obj))then
		return;
	end

	Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, obj);
end

function MiniMapWindow:UpdateMonstersPoses(datas, isRemoveOther)
	self:HelpUpdatePoses(self.monsterMap,
		datas,
		MiniMapWindow._CreateMonsterPoints,
		MiniMapWindow._UpdateMonsterPoints,
		MiniMapWindow._RemoveMonsterPoints,
		isRemoveOther);
end
-- around Monster end



-- treePoints begin
function MiniMapWindow:UpdateTreePoints(datas, isRemoveOther)
	self:HelpUpdatePoses(self.treeMap, 
		datas,
		nil,
		nil,
		nil,
		isRemoveOther);
end

function MiniMapWindow:RemoveTreePoint( key )
	local obj = self.treeMap[key];
	self:RemoveMiniMapSymbol(obj);
	self.treeMap[key] = nil;
end
-- treePoints end



-- player Map begin
function MiniMapWindow:_CreatePlayerPoints( data )
	if(not self:ObjIsNil(self.gameObject))then
		local symbolName = data:GetParama("Symbol");
		local depth = data:GetParama("depth");
		local symbol = self:GetMapSymbol(symbolName, 7, 0.7);

		symbol:GetComponent(UISprite).depth = 21 + depth;
		symbol:SetActive(self.monsterActive);
		return symbol;
	end
end

function MiniMapWindow:UpdatePlayerPoses(datas, isRemoveOther)
	self:HelpUpdatePoses(self.playerMap,
		datas,
		MiniMapWindow._CreatePlayerPoints,
		nil,
		nil,
		isRemoveOther);
end
-- player Map end



-- GVGTower begin
function MiniMapWindow:_CreateGvgDroiyanInfos(data)
	if(Slua.IsNull(self.gameObject))then
		return;
	end

	local symbolName = data:GetParama("Symbol");
	local symbol = self:GetMapSymbol(symbolName, 20+7, 0.7);

	self:_UpdateGvgDroiyanInfos(symbol, data);

	return symbol;
end

function MiniMapWindow:_UpdateGvgDroiyanInfos(obj, data)
	if(Slua.IsNull(self.gameObject) or Slua.IsNull(obj))then
		return;
	end

	local symbolName = data:GetParama("Symbol");
	local sp = obj:GetComponent(UISprite);
	if(sp.spriteName ~= symbolName)then
		sp.spriteName = symbolName;
	end
	
	local child = self:FindGO("metal_live", obj);
	if(Slua.IsNull(child))then
		child = self:GetMapSymbol("map_Empelium", 20+8, 1, obj.transform);
		child.gameObject.name = "metal_live";
	end
	local metal_live = data:GetParama("metal_live");
	if(metal_live == nil)then
		child:SetActive(false);
	else
		child:SetActive(true);

		if(metal_live == 0)then
			child:GetComponent(UISprite).color = ColorUtil.NGUIShaderGray;
		elseif(metal_live == 1)then
			child:GetComponent(UISprite).color = ColorUtil.NGUIWhite;
		end
	end

	return obj;
end

function MiniMapWindow:UpdateGvgDroiyanInfos(datas, isRemoveOther)
	self:HelpUpdatePoses(self.gvdDoriyanMap,
		datas,
		MiniMapWindow._CreateGvgDroiyanInfos,
		MiniMapWindow._UpdateGvgDroiyanInfos,
		nil,
		isRemoveOther);
end
-- GVGTower end



function MiniMapWindow:Reset()
	self:SetMapScale(1);
	self:UpdateMapTexture(nil);
end
