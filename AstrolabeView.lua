Astrolabe_Handle_PointType = {
	Reset = 1,
	Active_NotCan = 2,
	Active_Can = 3,
}

autoImport("CostInfoCell");
autoImport("Astrolabe_ScreenView");
autoImport("Astrolabe_PlateCell");

autoImport("FunctionAstrolabe");

AstrolabeView = class("AstrolabeView", BaseView)
AstrolabeView.ViewType = UIViewType.NormalLayer

AstrolabeView.POINT_POOLSIZE = 30;
Astrolabe_PlateZoom_Param = 0.5;

Astrolabe_Plate_BgMap = {
	[1] = "xingpan_ditu02";
	[2] = "xingpan_ditu03";
	[3] = "xingpan_ditu04";
	[4] = "xingpan_ditu05";
}

local AstrolabeView_HandleSate = {
	None = 1,
	Active = 2,
	Reset = 3,
}

local _AstrolabeProxy

autoImport("AstrolabeCellPool");
AstrolabeCellPool.new();

local Anim_Duration = 0.5;

local tempV3 = LuaVector3();
local tempV3_1, tempV3_2 = LuaVector3(), LuaVector3();
local tempRot = LuaQuaternion();
local tempColor = LuaColor.New(1,1,1,1);
function AstrolabeView:Init()
	_AstrolabeProxy = AstrolabeProxy.Instance;

	self:MapEvent();
	self:InitView();
end

function AstrolabeView:InitView()
	self.root = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIRoot);

	local coinsGrid = self:FindComponent("TopCoins", UIGrid);
	self.coinsCtl = UIGridListCtrl.new(coinsGrid , CostInfoCell, "CostInfoCell");

	self.sliverNum = self:FindComponent("Label", UILabel, self:FindGO("Sliver"));
	self.contributeNum = self:FindComponent("Label", UILabel, self:FindGO("Contribute"));

	self.collider = self:FindGO("Collider");

	-- init Astrolabe
	self.mapBg = self:FindGO("MapBg");
	self.mapBord = self:FindGO("MapBord");
	self.centerTarget = self:FindGO("CenterTarget", self.mapBord);
	self.effectContainer = self:FindGO("EffectContainer");

	self.platePool = {};

	self.plateCellMap = {};
	self.plateBgMap = {};
	self.outerlineMap = {};
	self.animlines = {};
	self.handlePointsMap = {};
	self.handlePointsList = {};
	self.cache_PointState_GuidMap = {};

	local scrollView = self:FindComponent("ScrollView", UIScrollViewEx);
	self.screenView = Astrolabe_ScreenView.new(scrollView, self.mapBord, 9, 9);
	self.screenView:AddEventListener(Astrolabe_ScreenView_Event.RefreshDraw, self.RefreshDraw, self);
	self.scrollBound = self:FindComponent("ScrollBound", UIWidget);

	self.activeInfo = self:FindGO("ActiveInfo");
	self.activeInfo_label = self:FindComponent("Label", UILabel, self.activeInfo);
	self.activeInfo_bg = self:FindComponent("ActiveButton", UISprite, self.activeInfo);
	self.activeInfoTween = self.activeInfo:GetComponent(TweenPosition);

	self.activeInfoTween = self.activeInfo:GetComponent(UIPlayTween)

	self:AddClickEvent(self.activeInfo_bg.gameObject, function ()
		self:ClickActiveButton();
	end);

	self.attriInfoButton = self:FindGO("AttriIInfoButton");
	self.attriInfo_Label = self:FindComponent("Label", UILabel, self.attriInfoButton);
	self.attriInfo_Symbol = self:FindComponent("Symbol", UISprite, self.attriInfoButton);
	self:AddButtonEvent("AttriIInfoButton", function ()
		self:ActiveAttriInfo(not self.isAttriInfoActive);
	end);

	self.activeBord = self:FindGO("ActiveBord");
	self.activeBord_ConfirmButton = self:FindGO("ConfirmButton", self.activeBord);
	self.activeBord_ConfirmButton_Sp = self.activeBord_ConfirmButton:GetComponent(UISprite);
	self.activeBord_ConfirmButton_Collider = self.activeBord_ConfirmButton:GetComponent(BoxCollider);
	self.activeBord_ConfirmButton_Sprite = self:FindComponent("Sprite", UISprite, self.activeBord_ConfirmButton);
	self.activeBord_CancelButton = self:FindGO("CancelButton", self.activeBord);
	self.activeBord_ResetPoint = self:FindComponent("ActivePoint", UILabel, self.activeBord);
	self.activeBord_ReturnContri = self:FindComponent("CostContri", UILabel, self.activeBord);
	self.activeBord_ReturnGold = self:FindComponent("CostGold", UILabel, self.activeBord);
	local activeBord_SymbolGold = self:FindComponent("SymbolGold", UISprite);
	IconManager:SetItemIcon("item_5261",activeBord_SymbolGold,self.activeBord);
	self:AddClickEvent(self.activeBord_ConfirmButton, function ()
		self:DoServerActive();
	end);
	self:AddClickEvent(self.activeBord_CancelButton, function ()
		self:ResetHandlePointsInfo();
		self.waitCancelChooseOnect = true;
	end);

	self.resetBord = self:FindGO("ResetBord");
	self.resetBord_ConfirmButton = self:FindGO("ConfirmButton", self.resetBord);
	self.resetBord_ConfirmButton_Sp = self.resetBord_ConfirmButton:GetComponent(UISprite);
	self.resetBord_ConfirmButton_Collider = self.resetBord_ConfirmButton:GetComponent(BoxCollider);
	self.resetBord_ConfirmButton_Sprite = self:FindComponent("Sprite", UISprite, self.resetBord_ConfirmButton);
	self.resetBord_CancelButton = self:FindGO("CancelButton", self.resetBord);
	self.resetBord_ResetPoint = self:FindComponent("ResetPoint", UILabel, self.resetBord);
	self.resetBord_CostZeny = self:FindComponent("CostZeny", UILabel, self.resetBord);
	self.resetBord_ReturnContri = self:FindComponent("ReturnContri", UILabel, self.resetBord);
	self.resetBord_ReturnGold = self:FindComponent("ReturnGold", UILabel, self.resetBord);
	local resetBord_SymbolGold = self:FindComponent("SymbolGold", UISprite, self.resetBord);
	IconManager:SetItemIcon("item_5261",resetBord_SymbolGold,self.resetBord);
	self:AddClickEvent(self.resetBord_ConfirmButton, function ()
		self:DoServerReset();
	end);
	self:AddClickEvent(self.resetBord_CancelButton, function ()
		self:ResetHandlePointsInfo();
		self.waitCancelChooseOnect = true;
	end);

	self.selectEffect = self:FindGO("SelectEffect");
	local customTouchUpCall = self.selectEffect:GetComponent(CustomTouchUpCall);
	customTouchUpCall.call = function (go)
		self:CancelChoosePoint();
	end
	customTouchUpCall.check = function ()
		if(self.waitCancelChooseOnect == true)then
			self.waitCancelChooseOnect = false;
			return true;			
		end
		local click = UICamera.selectedObject
		if(click)then
			for _,plateCell in pairs(self.plateCellMap)do
				for _,pointCell in pairs(plateCell.pointMap)do
					if(pointCell:IsClickMe(click))then
						return true;
					end
				end
			end
			if(click == self.activeInfo_bg.gameObject)then
				return true;
			end
		end
		return false
	end

	self.scaleButton = self:FindGO("ScaleButton");
	self.scaleButton_Symbol = self:FindComponent("Symbol", UISprite, self.scaleButton);
	self:AddClickEvent(self.scaleButton, function (go)
		if(self.islarge)then
			self.screenView:ZoomScrollView(Astrolabe_PlateZoom_Param, 0.4 , function ()
				self.islarge = false;
				self.scaleButton_Symbol.spriteName = "com_btn_enlarge";

				if(self.isAttriInfoActive)then
					self:ActiveAttriInfo(false);
				end
			end);
		else
			self.screenView:ZoomScrollView(1, 0.4 , function ()
				self.islarge = true;
				self.scaleButton_Symbol.spriteName = "com_btn_narrow";
			end);
		end
	end);
	self.islarge = true;

	self.handleState = AstrolabeView_HandleSate.None;
	self.playingAnim = false;
end

function AstrolabeView:ClickActiveButton()
	if(self.choosePointData == nil)then
		return;
	end
	
	if(self.choosePointData:IsActive())then
		self:RefreshResetPointsInfo();
	else
		self:RefreshActivePointsInfo();
	end
end

function AstrolabeView:InitPlateDatas()
	self.screenView:InitPlateDatas( self.curBordData:GetPlateMap() );
	self.screenView:InitBgDatas( self.curBordData:GetPlateBgDatas() );
	
	self.screenView:RefreshDraw();

	self:UpdateScrollBound();
end

-- ActiveInfo
function AstrolabeView:DoServerActive()
	-- TableUtility.TableClear(self.cache_PointState_GuidMap);

	local resultIds = {};
	local pointData;
	for i=1, #self.handlePointsList do
		local id = self.handlePointsList[i];
		
		local dtype = self.handlePointsMap[id];
		if(dtype == Astrolabe_Handle_PointType.Active_Can)then
			pointData = self.curBordData:GetPointByGuid(id);
			-- self.cache_PointState_GuidMap[ pointData.guid ] = pointData:GetState();
			if(not pointData:IsActive())then
				table.insert(resultIds, id);
			end
		end
	end

	if(#resultIds>0)then
		ServiceAstrolabeCmdProxy.Instance:CallAstrolabeActivateStarCmd(resultIds);
	end
end
function AstrolabeView:RefreshActivePointsInfo()
	TableUtility.TableClear(self.handlePointsMap);
	TableUtility.ArrayClear(self.handlePointsList);

	local id = self.choosePointData and self.choosePointData.guid;
	local pointIds = id and FunctionAstrolabe.GetPath(id)
	if(pointIds)then
		local userdata = Game.Myself and Game.Myself.data.userdata;
		local left_slivernum = userdata:Get(UDEnum.SILVER) or 0;
		local left_contributenum = userdata:Get(UDEnum.CONTRIBUTE) or 0;
		local left_goldawardnum = BagProxy.Instance:GetItemNumByStaticID(5261);
		local cost_slivernum, cost_contributenum, cost_goldawardnum = 0, 0, 0;
		local pointData, cost;
		for i=1,#pointIds do
			pointData = self.curBordData:GetPointByGuid(pointIds[i]);
			if(not pointData:IsActive())then
				cost = pointData:GetCost();
				for j=1,#cost do
					if(cost[j][1] == 100)then
						left_slivernum = left_slivernum - cost[j][2];
						cost_slivernum = cost_slivernum + cost[j][2];
					elseif(cost[j][1] == 140)then
						left_contributenum = left_contributenum - cost[j][2];
						cost_contributenum = cost_contributenum + cost[j][2];
					elseif(cost[j][1] == 5261)then
						left_goldawardnum = left_goldawardnum - cost[j][2];
						cost_goldawardnum = cost_goldawardnum + cost[j][2];
					end
				end
				if(left_slivernum<0 or left_contributenum<0 or left_goldawardnum<0)then
					self.handlePointsMap[ pointIds[i] ] = Astrolabe_Handle_PointType.Active_NotCan;
				else
					self.handlePointsMap[ pointIds[i] ] = Astrolabe_Handle_PointType.Active_Can;
				end

				table.insert(self.handlePointsList, pointIds[i])
			else
				self.handlePointsMap[ pointIds[i] ] = Astrolabe_Handle_PointType.Active_Can;
			end
		end

		self.activeBord:SetActive(true);
		self.activeBord_ResetPoint.text = #pointIds - 1;

		local hasNotEnoughCost = false;
		if(left_contributenum<0)then
			hasNotEnoughCost = true;
			self.activeBord_ReturnContri.text = "[c][E92021]" .. cost_contributenum .. "[-][/c]";
		else
			self.activeBord_ReturnContri.text = cost_contributenum;
		end
		if(left_goldawardnum<0)then
			hasNotEnoughCost = true;
			self.activeBord_ReturnGold.text = "[c][E92021]" .. cost_goldawardnum .. "[-][/c]";
		else
			self.activeBord_ReturnGold.text = cost_goldawardnum;
		end

		if(hasNotEnoughCost)then
			tempColor:Set(1/255,2/255,3/255,1);
			self.activeBord_ConfirmButton_Sprite.color = tempColor;
			self.activeBord_ConfirmButton_Sp.color = tempColor;
			self.activeBord_ConfirmButton_Collider.enabled = false;
		else
			tempColor:Set(1,1,1,1);
			self.activeBord_ConfirmButton_Sprite.color = tempColor;
			self.activeBord_ConfirmButton_Sp.color = tempColor;
			self.activeBord_ConfirmButton_Collider.enabled = true;
		end

		self.activeInfoTween:Play(false);

		self.handleState = AstrolabeView_HandleSate.Active;
	else
		MsgManager.ShowMsgByIDTable(2852);
	end

	self:RedrawHandlePoints();
end
-- ActiveInfo

-- ResetInfo
function AstrolabeView:DoServerReset()
	if(self.choosePointData.guid == Astrolabe_Origin_PointID)then
		ServiceAstrolabeCmdProxy.Instance:CallAstrolabeResetCmd({Astrolabe_Origin_PointID});
		return;
	end

	local resultIds = {};
	local pointData;
	for i=1, #self.handlePointsList do
		local id = self.handlePointsList[i];

		local dtype = self.handlePointsMap[id];
		if(dtype == Astrolabe_Handle_PointType.Reset)then
			pointData = self.curBordData:GetPointByGuid(id);
			pointData:SetOldState( pointData:GetState() );

			table.insert(resultIds, id);
		end
	end
	if(#resultIds>0)then
		ServiceAstrolabeCmdProxy.Instance:CallAstrolabeResetCmd(resultIds);
	end
end
function AstrolabeView:RefreshResetPointsInfo()
	TableUtility.TableClear(self.handlePointsMap);
	TableUtility.ArrayClear(self.handlePointsList);

	local id = self.choosePointData.guid;
	local pointIds;
	if(id == Astrolabe_Origin_PointID)then
		local pointsMap = self.curBordData:GetActivePointsMap()
		pointIds = {};
		for id,_ in pairs(pointsMap) do
			local pointData = self.curBordData:GetPointByGuid(id);
			if(pointData:IsActive())then
				table.insert(pointIds, id);
			end
		end
	else
		pointIds = {};
		local pointIdMap = self.curBordData:ResetPoint(id);
		for id,_ in pairs(pointIdMap)do
			table.insert(pointIds, id);
		end
	end
	if(pointIds)then
		local return_slivernum, return_contributenum, return_goldawardnum = 0, 0, 0;
		local cost_slivernum = 0;
		local pointData, cost;

		for i=1,#pointIds do
			pointData = self.curBordData:GetPointByGuid(pointIds[i]);
			cost = pointData:GetCost();
			for j=1,#cost do
				if(cost[j][1] == 100)then
					return_slivernum = return_slivernum + cost[j][2];
				elseif(cost[j][1] == 140)then
					return_contributenum = return_contributenum + cost[j][2];
				elseif(cost[j][1] == 5261)then
					return_goldawardnum = return_goldawardnum + cost[j][2];
				end
			end
			cost = pointData:GetResetCost();
			for j=1,#cost do
				if(cost[j][1] == 100)then
					cost_slivernum = cost_slivernum + cost[j][2];
				end
			end
			self.handlePointsMap[ pointIds[i] ] = Astrolabe_Handle_PointType.Reset;

			if(pointData:IsActive())then
				table.insert(self.handlePointsList, pointIds[i])
			end
		end

		local mysliver = Game.Myself.data.userdata:Get(UDEnum.SILVER);
		cost_slivernum = math.min(cost_slivernum, 500000);

		if(cost_slivernum > mysliver)then
			self.resetBord_CostZeny.text = "[c][E92021]" .. cost_slivernum .. "[-][/c]";

			tempColor:Set(1/255,2/255,3/255,1);

			self.resetBord_ConfirmButton_Sprite.color = tempColor;
			self.resetBord_ConfirmButton_Sp.color = tempColor;
			self.resetBord_ConfirmButton_Collider.enabled = false;
		else
			self.resetBord_CostZeny.text = cost_slivernum;

			tempColor:Set(1,1,1,1);
			self.resetBord_ConfirmButton_Sprite.color = tempColor;
			self.resetBord_ConfirmButton_Sp.color = tempColor;
			self.resetBord_ConfirmButton_Collider.enabled = true;
		end
		self.resetBord_ResetPoint.text = #pointIds;
		self.resetBord_ReturnContri.text = return_contributenum;
		self.resetBord_ReturnGold.text = return_goldawardnum;
		self.resetBord:SetActive(true);

		self.activeInfoTween:Play(false);

		self.handleState = AstrolabeView_HandleSate.Reset;
	end

	self:RedrawHandlePoints();
end
-- resetInfo

function AstrolabeView:ResetHandlePointsInfo(notTweenBord)
	TableUtility.TableClear(self.handlePointsMap);
	TableUtility.ArrayClear(self.handlePointsList);
	self.activeBord:SetActive(false);
	self.resetBord:SetActive(false);
	if(notTweenBord ~= true)then
		self.activeInfoTween:Play(true);
	end

	self:RedrawHandlePoints();

	self.handleState = AstrolabeView_HandleSate.None;
end

function AstrolabeView:RedrawHandlePoints()
	for _,plateCell in pairs(self.plateCellMap)do
		plateCell:SetMaskInfo(self.handlePointsMap);
	end

	local p1_id, p2_id;
	local p1_mtype, p2_mtype;
	for _,lineCell in pairs(self.outerlineMap)do
		p1_id, p2_id = lineCell.point1.guid, lineCell.point2.guid;
		p1_mtype, p2_mtype = self.handlePointsMap[p1_id], self.handlePointsMap[p2_id];
		if(p1_mtype and p2_mtype)then
			lineCell:SetMaskType( math.min(p1_mtype, p2_mtype) );
		else
			lineCell:SetMaskType(nil);
		end
	end

	self.screenView.mPanel:SetDirty();
end


function AstrolabeView:CheckCanActive(cost)
	for i=1, #cost do
		local id,needCount = cost[i][1], cost[i][2];
		if(id == 100)then
			local userdata = Game.Myself and Game.Myself.data.userdata;
			if(userdata)then
				local num = userdata:Get(UDEnum.SILVER) or 0;
				if(num < needCount)then
					MsgManager.ShowMsgByIDTable(1);
					return false;
				end
			end
		elseif(id == 140)then
			local userdata = Game.Myself and Game.Myself.data.userdata;
			if(userdata)then
				local num = userdata:Get(UDEnum.CONTRIBUTE) or 0;
				if(num < needCount)then
					MsgManager.ShowMsgByIDTable(2820);
					return false;
				end
			end
		else
			local num = BagProxy.Instance:GetItemNumByStaticID(id)
			if(num < needCount)then
				MsgManager.ShowMsgByIDTable(8);
				return false;
			end
		end
	end
	return true;
end

function AstrolabeView:ActiveAttriInfo(active)
	if active then
		self.attriInfo_Symbol.spriteName = "com_icon_hide"
		self.attriInfo_Label.text = ZhString.AstrolabeView_infoHide;
	else
		self.attriInfo_Symbol.spriteName = "com_icon_show"
		self.attriInfo_Label.text = ZhString.AstrolabeView_infoShow;
	end

	for key, plateCell in pairs(self.plateCellMap) do
		plateCell:ActiveAttriInfo(active);
	end

	self.isAttriInfoActive = active;
end



-- plate Pool begin
function AstrolabeView:GetPolateCell_FromPool()
	local plateCell = table.remove(self.platePool, 1);
	if(plateCell == nil)then
		local obj = Game.AssetManager_UI:CreateAstrolabeAsset(ResourcePathHelper.UICell("Astrolabe_PlateCell"), self.mapBord);
		plateCell = Astrolabe_PlateCell.new(obj);
		plateCell:Hide();

		plateCell:AddEventListener(Astrolabe_PlateCell_Event.ClickPoint, self.ClickPoint, self);
	end
	plateCell:OnCreate();

	return plateCell;
end
function AstrolabeView:ClickPoint(params)
	local plateCell, pointCell = params[1], params[2];
	local plateData, pointData = plateCell.data, pointCell.data;

	if(pointData ~= self.choosePointData)then
		self.choosePointData = pointData;

		AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.SelectRune));

		self.selectEffect.gameObject:SetActive(true);
		tempV3_1:Set(pointData:GetWorldPos_XYZ());
		self.selectEffect.transform.localPosition = tempV3_1;

		-- Show Tip
		TipManager.CloseTip();
		if(pointData.guid ~= Astrolabe_Origin_PointID)then
			local bg = pointCell.bg;
			local tip = TipManager.Instance:ShowAstrobeTip(pointData, bg, NGUIUtil.AnchorSide.Left);
			if(tip)then
				local tip_width, tip_heght = tip:GetSize();

				local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, bg.gameObject.transform, Space.World)
				local anchorSide, offset_x;
				if(x > 0)then
					anchorSide = NGUIUtil.AnchorSide.Left;
					offset_x = -tip_width/2;
				else
					anchorSide = NGUIUtil.AnchorSide.Right
					offset_x = tip_width/2;
				end
				if(self.islarge == false)then
					offset_x = offset_x / Astrolabe_PlateZoom_Param;
				end
				tip:SetPos(NGUIUtil.GetAnchorPoint(nil,bg,anchorSide,{offset_x,0}));
				TipsView.Me():ConstrainCurrentTip();

				tip:SetCheckClick(self:TipClickCheck());
			end
		end

		local state = pointData:GetState();
		if(state == Astrolabe_PointData_State.Lock)then
			self.activeInfo_label.text = ZhString.AstrolabeView_Active;
		elseif(state == Astrolabe_PointData_State.On)then
			self.activeInfo_label.text = ZhString.AstrolabeView_Reset;
		elseif(state == Astrolabe_PointData_State.Off)then
			self.activeInfo_label.text = ZhString.AstrolabeView_Active;
		end

		if(self.isPreview)then
			return;
		end

		if(self.handleState == AstrolabeView_HandleSate.None)then
			-- self.activeInfoTween:ResetToBeginning();
			self.activeInfoTween:Play(true);
		end
		
	end
end
function AstrolabeView:TipClickCheck()
	if(self.tipCheck == nil) then
		self.tipCheck = function ()
			local click = UICamera.selectedObject
			if(click) then
				for _,plateCell in pairs(self.plateCellMap)do
					for _,pointCell in pairs(plateCell.pointMap)do
						if(pointCell.data and pointCell.data.guid == Astrolabe_Origin_PointID)then
							return false;
						end
						if(pointCell:IsClickMe(click))then
							return true;
						end
					end
				end
			end
			return false
		end
	end
	return self.tipCheck
end
function AstrolabeView:AddPlateCell_ToPool(plateCell)
	if(plateCell)then
		plateCell:OnDestroy();
		self.platePool[#self.platePool+1] = plateCell;
	end
end
-- plate Pool end



function AstrolabeView:RefreshDraw(param)
	-- local mem = collectgarbage("count")

	local drawPlateMap = param[1];

	for id, plateCell in pairs(self.plateCellMap)do
		if(drawPlateMap[id] == nil)then
			self:AddPlateCell_ToPool(plateCell);
			self.plateCellMap[id] = nil;
		end
	end

	for id, plateData in pairs(drawPlateMap)do
		local plateCell = self.plateCellMap[id];
		if(plateCell == nil)then
			plateCell = self:GetPolateCell_FromPool();
			self.plateCellMap[id] = plateCell;
		end
		plateCell:SetData(plateData, self.cache_PointState_GuidMap, self.curBordData);
		plateCell:ActiveAttriInfo(self.isAttriInfoActive == true);
		plateCell:SetMaskInfo(self.handlePointsMap);
	end
	
	self:RedrawPlateBg(param[2]);

	self:RedrawOuterLine();

	-- helplog("AstrolabeView RefreshDraw:", collectgarbage("count") - mem);
	-- local mem = collectgarbage("count")

end



---- draw bg begin
local Astrolabe_BgPath = ResourcePathHelper.UICell("Astrolabe_bg");
function AstrolabeView.DeleteBg(bg)
	if(not Slua.IsNull(bg))then
		bg.gameObject:SetActive(false);
		Game.GOLuaPoolManager:AddToAstrolabePool(Astrolabe_BgPath , bg.gameObject)
	end
end
function AstrolabeView:ClearBgs()
	TableUtility.TableClearByDeleter(self.plateBgMap, AstrolabeView.DeleteBg);
end
function AstrolabeView:RedrawPlateBg(drawBgMap)
	for cid, bg in pairs(self.plateBgMap)do
		if(drawBgMap[cid] == nil)then
			AstrolabeView.DeleteBg(bg);
			self.plateBgMap[cid] = nil;
		end
	end

	for cid, bgData in pairs(drawBgMap)do
		local bg = self.plateBgMap[cid];
		if(Slua.IsNull(bg))then
			bg = Game.AssetManager_UI:CreateAstrolabeAsset(Astrolabe_BgPath, self.mapBord);
			bg.name = "Bg" .. cid;

			bg.gameObject:SetActive(true);
			bg.transform.localScale = LuaGeometry.Const_V3_one;

			bg = bg:GetComponent(UISprite);

			self.plateBgMap[cid] = bg;
		end
		-- update sprite
		local iconIndex = math.floor(cid/10000) + 1;
		local sName = Astrolabe_Plate_BgMap[iconIndex] or Astrolabe_Plate_BgMap[0];
		if(sName)then
			bg.spriteName = sName;
			bg:MakePixelPerfect();
		end
		-- update trans
		tempV3_1:Set(bgData[1], bgData[2], bgData[3]);
		bg.transform.localPosition = tempV3_1;

		if(bgData[4])then
			tempV3_1:Set(bgData[4], bgData[5], bgData[6]);
		else
			tempV3_1:Set(0,0,0);
		end
		tempRot.eulerAngles = tempV3_1;
		bg.transform.localRotation = tempRot;

		if(bgData[7])then
			tempV3_1:Set(bgData[7], bgData[8], bgData[9]);
			bg.transform.localScale = tempV3_1;
		else
			bg.transform.localScale = LuaGeometry.Const_V3_one;
		end
	end
	
	
end
---- draw bg end



---- draw line begin
function AstrolabeView.DeleteLine(lineCell)
	AstrolabeCellPool.Instance:AddLineCellToPool(lineCell)
end
function AstrolabeView:ClearLines()
	TableUtility.TableClearByDeleter(self.outerlineMap, AstrolabeView.DeleteLine);
end
function AstrolabeView:RedrawOuterLine()
	self:ClearLines();

	local plateMap = self.curBordData:GetPlateMap();
	for plateid,_ in pairs(self.plateCellMap)do
		local plateData = plateMap[plateid];
		if(plateData)then
			local pointMap = plateData:GetPointMap();
			for _, pointData in pairs(pointMap)do
				local outerConnect = pointData:GetOuterConnect();
				if(outerConnect)then
					for _, outerid in pairs(outerConnect)do
						local outerPointData = self.curBordData:GetPointByGuid(outerid);
						local plateData = self.curBordData:GetPlateData(math.floor(outerid/10000));
						if(plateData:IsUnlock())then
							self:DrawOuterLineByPoint(pointData, outerPointData);
						end
					end
				end
			end
		end
	end
end
function AstrolabeView:GetOuterLine( point1, point2 )
	local lpoint, bpoint;
	if(point1.guid < point2.guid)then
		lpoint = point1;
		bpoint = point2;
	else
		lpoint = point2;
		bpoint = point1;
	end
	local cid = lpoint.guid .. "_" .. bpoint.guid;

	local lineCell = self.outerlineMap[cid];

	if(lineCell == nil)then
		lineCell = AstrolabeCellPool.Instance:GetLineCell(self.mapBord);

		local x1,y1,z1 = lpoint:GetWorldPos_XYZ();
		local x2,y2,z2 = bpoint:GetWorldPos_XYZ();
		lineCell:ReSetPos(x1,y1,z1, x2,y2,z2);

		self.outerlineMap[cid] = lineCell;
	end

	return lineCell;
end
function AstrolabeView:DrawOuterLineByPoint(point1, point2)
	if(point1 == nil or point2 == nil)then
		return;
	end

	local lineCell = self:GetOuterLine(point1, point2);
	lineCell:SetData(point1, point2, self.cache_PointState_GuidMap);

	local p1_mtype, p2_mtype = self.handlePointsMap[point1.guid], self.handlePointsMap[point2.guid];
	if(p1_mtype and p2_mtype)then
		lineCell:SetMaskType( math.min(p1_mtype, p2_mtype) );
	else
		lineCell:RemoveMask();
	end
end
---- draw line end


function AstrolabeView:UpdateScrollBound()
	local activePlates = self.curBordData:GetPlateMap();

	local min_x, max_x, min_y, max_y = 0,0,0,0; 
	for pid, pdata in pairs(activePlates)do
		if(pdata:IsUnlock())then
			min_x = math.min(min_x, pdata.min_x);
			min_y = math.min(min_y, pdata.min_y);

			max_x = math.max(max_x, pdata.max_x);
			max_y = math.max(max_y, pdata.max_y);
		end
	end

	tempV3_1:Set((min_x + max_x) * 0.5, (min_y + max_y) * 0.5);
	self.scrollBound.transform.localPosition = tempV3_1;

	self.scrollBound.width = max_x - min_x;
	self.scrollBound.height = max_y - min_y;
end

function AstrolabeView:UpdateCoins()
	local showCoins = GameConfig.Astrolabe.ShowCostInfo or {100, 140, 5260, 5261};
	self.coinsCtl:ResetDatas(showCoins);
end

function AstrolabeView:MapEvent()
	self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleProfessionChange);
	self:AddListenEvt(ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd, self.HandleActivePoints);
	self:AddListenEvt(ServiceEvent.AstrolabeCmdAstrolabeResetCmd, self.HandleResetPoints);

	self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins);
	self:AddListenEvt(MyselfEvent.ContributeChange, self.UpdateCoins);
	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCoins);

	self:AddListenEvt(AstrolabeEvent.TipClose, self.HandleTipClose);
end

function AstrolabeView:HandleProfessionChange(note)
	self:CloseSelf();
end

function AstrolabeView:HandleActivePoints(note)
	local stars = note.body.stars;
	local animDatas = {};

	local add_EffectMap = {};
	local add_SpecialEffectMap = {};
	if(stars[1] == Astrolabe_Origin_PointID)then
		local pointData = self.curBordData:GetPointByGuid(Astrolabe_Origin_PointID);
		table.insert(animDatas, pointData);
	else
		for i=1, #self.handlePointsList do
			local pointData = self.curBordData:GetPointByGuid(self.handlePointsList[i]);
			if(pointData:IsActive())then
				table.insert(animDatas, pointData);
			end

			local effect = pointData:GetEffect();
			if(effect)then
				for attriKey, value in pairs(effect)do
					if(add_EffectMap[attriKey])then
						add_EffectMap[attriKey] = add_EffectMap[attriKey] + value;
					else
						add_EffectMap[attriKey] = value;
					end
				end
			end
			local specialEffect = pointData:GetSpecialEffect();
			if(specialEffect)then
				if(add_SpecialEffectMap[specialEffect] == nil)then
					add_SpecialEffectMap[specialEffect] = 1;
				else
					add_SpecialEffectMap[specialEffect] = add_SpecialEffectMap[specialEffect] + 1;
				end
			end
		end
	end
	AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.LinkRune2));
	self:PlayHandleAnims(animDatas, "ToUnlock", function ()
		for _,cell in pairs(self.plateCellMap)do
			cell:Refresh();
		end
		self:RedrawOuterLine();
		self.curBordData:CheckNeed_DoServer_InitPlate();
	end);

	-- ?????? Show Msg
	local PropNameConfig = Game.Config_PropName
	local str = "";
	for attriType, value in pairs(add_EffectMap)do
		local config = PropNameConfig[ attriType ];
		if(config ~= nil)then
			str = config.PropName;
			if(value > 0)then
				str = str .. " +"
			end
			if(config.IsPercent==1)then
				str = str .. value * 100 .. "%";
			else
				str = str .. value;
			end
			MsgManager.ShowMsgByIDTable(2850, {str});
		end	
	end

	for specialid,addlv in pairs(add_SpecialEffectMap)do
		local specialData = Table_RuneSpecial[specialid];
		MsgManager.ShowMsgByIDTable(2850, {specialData.RuneName});
	end
	-- ?????? Show Msg

	self:ResetHandlePointsInfo(true);

	if(self.choosePointData)then
		local state = self.choosePointData:GetState();
		if(state == Astrolabe_PointData_State.Lock)then
			self.activeInfo_label.text = ZhString.AstrolabeView_Active;
		elseif(state == Astrolabe_PointData_State.On)then
			self.activeInfo_label.text = ZhString.AstrolabeView_Reset;
		elseif(state == Astrolabe_PointData_State.Off)then
			self.activeInfo_label.text = ZhString.AstrolabeView_Active;
		end
	end
end

function AstrolabeView:HandleResetPoints(note)
	local animDatas = {};
	local min_EffectMap = {};
	local min_SpecialEffectMap = {};
	for i=1, #self.handlePointsList do
		local pointData = self.curBordData:GetPointByGuid(self.handlePointsList[i]);
		if(not pointData:IsActive())then
			table.insert(animDatas, pointData);

			local effect = pointData:GetEffect();
			if(effect)then
				for attriKey, value in pairs(effect)do
					if(min_EffectMap[attriKey])then
						min_EffectMap[attriKey] = min_EffectMap[attriKey] - value;
					else
						min_EffectMap[attriKey] = -value;
					end
				end
			end
			local specialEffect = pointData:GetSpecialEffect();
			if(specialEffect)then
				if(min_SpecialEffectMap[specialEffect] == nil)then
					min_SpecialEffectMap[specialEffect] = 1;
				else
					min_SpecialEffectMap[specialEffect] = min_SpecialEffectMap[specialEffect] + 1;
				end
			end
		end
	end

	-- ?????? Show Msg
	local PropNameConfig = Game.Config_PropName
	local msg, str = "";
	for attriType, value in pairs(min_EffectMap)do
		local config = PropNameConfig[ attriType ];
		if(config ~= nil)then
			str = config.PropName;
			if(value > 0)then
				str = str .. " +"
			end
			if(config.IsPercent==1)then
				str = str .. value * 100 .. "%";
			else
				str = str .. value;
			end
			MsgManager.ShowMsgByIDTable(2851, {str});
		end	
	end
	for specialid,minlv in pairs(min_SpecialEffectMap)do
		local specialData = Table_RuneSpecial[specialid];
		MsgManager.ShowMsgByIDTable(2851, {specialData.RuneName});
	end
	-- ?????? Show Msg

	self:ResetHandlePointsInfo(true);

	AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.ResetRune));
	self:PlayHandleAnims(animDatas, "AtharReset", function ()
		for _,cell in pairs(self.plateCellMap)do
			cell:Refresh();
		end
		self:RedrawOuterLine();
		self.curBordData:CheckNeed_DoServer_InitPlate();
	end);
end


-- Show Msg
function AstrolabeView:QueueShowMsg(id, param, time)
	MsgManager.ShowMsgByIDTable(id, param);
	-- if(self.msgWaitQueue == nil)then
	-- 	self.msgWaitQueue = {};
	-- end
	-- table.insert(self.msgWaitQueue, {id, param, time});

	-- if(#self.msgWaitQueue > 0 and self.showingMsg ~= true)then
	-- 	self:_QueueShowMsg();
	-- end
end
function AstrolabeView:_QueueShowMsg()
	if(#self.msgWaitQueue>0)then
		self.showingMsg = true;

		local msgData = table.remove(self.msgWaitQueue, 1);
		MsgManager.ShowMsgByIDTable(msgData[1], msgData[2]);

		self:CancelShowMsg();
		local waittime = msgData[3] or 1;
		self.showMsglt = LeanTween.delayedCall(waittime, function ()
			self.showMsglt = nil;
			self:_QueueShowMsg();
		end);
	else
		self.showingMsg = false;
	end
end
function AstrolabeView:CancelShowMsg()
	if(self.showMsglt)then
		self.showMsglt:cancel();
		self.showMsglt = nil;
	end
	self.showingMsg = false;
end
-- Show Msg


-----anim begin
function AstrolabeView:CancelHandleAnims()
	if(self.animlt)then
		self.animlt:cancel();
		self.animlt = nil;
	end
end
function AstrolabeView:PlayHandleAnims(pointDatas, effectName, endCall, endCallParam)
	for i=1,#pointDatas do
		local plateid = pointDatas[i].plateid;
		if(plateid and self.plateCellMap[plateid])then
			self:PlayLineRuneEffect(pointDatas[i], effectName);
		end
	end

	self:CancelHandleAnims();

	self.animlt = LeanTween.delayedCall(0.5, AstrolabeView.HandleAnimEnd);
	self.animlt.onCompleteParam = {self, endCall, endCallParam};
end
function AstrolabeView.HandleAnimEnd(param)
	local self, endCall, endCallParam = param[1], param[2], param[3];
	if(endCall)then
		endCall(endCallParam);
	end
	self.animlt = nil;
end
function AstrolabeView:PlayLineRuneEffect(pointData, effectName)
	local pos = { pointData:GetWorldPos_XYZ() };
	self:PlayUIEffect(effectName, self.effectContainer, true, AstrolabeView.LineRuneHandle, pos);
end
function AstrolabeView.LineRuneHandle(effectHandle, pos)
	tempV3:Set(pos[1], pos[2], pos[3]);
	effectHandle.transform.localPosition = tempV3;
end
---anim begin

function AstrolabeView:CancelChoosePoint()
	if(self.handleState == AstrolabeView_HandleSate.None)then
		self.choosePointData = nil;
		self.selectEffect.gameObject:SetActive(false);

		self.activeInfoTween:Play(false);

		TipManager.CloseTip();
	end
end

function AstrolabeView:HandleTipClose(note)
	-- self:CancelChoosePoint();
end

function AstrolabeView:OnEnter()
	AstrolabeView.super.OnEnter(self);

	local viewdata = self.viewdata.viewdata;

	local saveInfoData
	if(viewdata)then
		if(viewdata.isFromMP)then
			saveInfoData = viewdata.saveInfoData;
		elseif(viewdata.storageId)then
			saveInfoData = SaveInfoProxy.Instance:GetUsersaveData(viewdata.storageId, SaveInfoEnum.Record);
		elseif(viewdata.saveId)then
			saveInfoData = SaveInfoProxy.Instance:GetUsersaveData(viewdata.saveId, SaveInfoEnum.Branch);
		end
	end
	self.isPreview = saveInfoData ~= nil;

	if(self.isPreview)then
		self.curBordData = _AstrolabeProxy:GetBordData_BySaveInfo(saveInfoData, viewdata.saveId~=nil);
	else
		self.curBordData = _AstrolabeProxy:GetCurBordData();
		self.curBordData:CheckNeed_DoServer_InitPlate();
	end
	FunctionAstrolabe.SetBordData(self.curBordData);

	self:InitPlateDatas();

	FunctionBGMCmd.Me():PlayUIBgm("AtharStone", 0);

	local oriPoint = self.curBordData:GetPointByGuid(Astrolabe_Origin_PointID);
	local x,y,z = oriPoint:GetWorldPos_XYZ();
	self.screenView:CenterOnLocalPos( x,y,z );

	self:UpdateCoins();

	tempV3:Set(0,0,0);
	Game.TransformFollowManager:RegisterFollowPos(self.mapBg.transform, self.mapBord.transform, tempV3, nil, nil)

	local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera];
	gOManager_Camera:ActiveMainCamera(false);
end

function AstrolabeView:OnExit()
	AstrolabeView.super.OnExit(self);

	FunctionBGMCmd.Me():StopUIBgm();

	self:ClearBgs();
	self:ClearLines();
	AstrolabeCellPool.Instance:ClearPointCellPool();
	AstrolabeCellPool.Instance:ClearLineCellPool();

	TableUtility.TableClear(self.cache_PointState_GuidMap);

	self:CancelHandleAnims();
	self:CancelShowMsg();
	self.curBordData:ClearTarjanCache();

	FunctionAstrolabe.ClearCache()
	FunctionAstrolabe.ReSetBordData();
	
	UIUtil.ClearFloatMiddleBottom()

	Game.TransformFollowManager:UnregisterFollow(self.mapBg.transform)

	local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera];
	gOManager_Camera:ActiveMainCamera(true);
end