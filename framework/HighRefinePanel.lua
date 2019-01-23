HighRefinePanel = class("HighRefinePanel", ContainerView)

autoImport("HRefinePosCell");
autoImport("HRefineTypeCell");
autoImport("MaterialItemCell");

local blackSmithProxy;
local propNameConfig;

local tempV3 = LuaVector3();

function HighRefinePanel:Init()
	blackSmithProxy = BlackSmithProxy.Instance;
	propNameConfig = Game.Config_PropName

	self:InitView();
	self:MapEvent();
end

function HighRefinePanel:MapEvent()
	self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins)
	self:AddListenEvt(ItemEvent.ItemUpdate,self.UpdateMaterials);
	self:AddListenEvt(ServiceEvent.ItemNtfHighRefineDataCmd,self.HandleHighRefineUpdate);
	self:AddListenEvt(ServiceEvent.ItemUpdateHighRefineDataCmd,self.HandleHighRefineLvUp);
end

function HighRefinePanel:HandleHighRefineUpdate(note)
	self:ChooseRefineCall(nil, self.curLevelType);
end

function HighRefinePanel:HandleHighRefineLvUp()
	self:PlayUIEffect(EffectMap.UI.UltimateLvUp, self.effectContainer, true)

	local title = self.equipName.text;
	title = "[" .. title .. "]" .. "Lv+1";
	local addtext = self.nextEffect_Name.text .. self.nextEffect_Value.text;
	tempV3:Set(LuaGameObject.GetPosition(self.effectContainer.transform));
	MsgManager.ShowEightTypeMsgByIDTable(222, {title}, tempV3,{0,10})		
	MsgManager.ShowEightTypeMsgByIDTable(223, {addtext}, tempV3,{0,10})		

	self:ChooseRefineCall(nil, self.curLevelType);
end

function HighRefinePanel:InitView()
	self.bord = self.gameObject;
	-- right Bord
	self.refineGrid = self:FindComponent("RefineGrid", UIGrid, self.bord);
	self.hRefineCtl = UIGridListCtrl.new(self.refineGrid, HRefineTypeCell, "HRefineTypeCell");

	self.centerScrollView = self:FindComponent("CenterScrollView", UIScrollView, self.bord);
 	self.centerControl = NGUIUtil.Panel_EnlargeCenterCell(self.centerScrollView, 
		self.refineGrid, 
		0.8, 
		self.refineGrid.cellWidth, 
		1)
 	self.centerControl:SetCenterCall(self.ChooseRefineCall, self);
 	local preGO = self:FindGO("PreButton", self.bord);
 	self.centerControl:SetPreSymbol(preGO, true);
 	local nextGO = self:FindGO("NextButton", self.bord);
 	self.centerControl:SetNextSymbol(nextGO, true);

	self.preButton = self:FindGO("PreButton", self.bord);
	self.nextButton = self:FindGO("NextButton", self.bord);

	self.equipName = self:FindComponent("EquipName", UILabel, self.bord);

	self.unFullBord = self:FindGO("UnFull", self.bord);
	self.nowRefineLv = self:FindComponent("NowHRefineLv", UILabel, self.bord);
	self.nowEffect_Name = self:FindComponent("NowEffect", UILabel, self.bord);
	self.nowEffect_Value = self:FindComponent("Label", UILabel, self.nowEffect_Name.gameObject);
	self.nextRefineLv = self:FindComponent("NextRefineLv", UILabel, self.unFullBord);
	self.nextEffect_Name = self:FindComponent("NextEffect", UILabel, self.unFullBord);
	self.nextEffect_Value = self:FindComponent("Label", UILabel, self.nextEffect_Name.gameObject);
	self.matGrid = self:FindComponent("MatGrid", UIGrid, self.unFullBord);
	self.hRefineMatCtl = UIGridListCtrl.new(self.matGrid, MaterialItemCell, "MaterialItemCell");
	self.hRefineMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMat, self);

	self.maxTip = self:FindGO("MaxTip", self.bord);

	self.doButton = self:FindGO("DoButton", self.bord);
	self.doButton_Collider = self.doButton:GetComponent(BoxCollider);
	self.doButton_Sprite = self.doButton:GetComponent(UISprite);
	self.doButton_Label = self:FindComponent("Label", UILabel, self.doButton);
	self:AddClickEvent(self.doButton, function (go)
		self:DoHRefine()
	end);

	self.addEffectTip = self:FindComponent("RefineModelTip", UILabel, self.bord);
	-- right Bord


	-- leftBord
	self.leftBord = self:FindGO("LeftBord", self.bord);

	self.tipStick = self:FindComponent("TipStick", UIWidget, self.bord);

	self.tipShowButton = self:FindGO("TipShowButton", self.bord);
	self:AddClickEvent(self.tipShowButton, function (go)
		TipManager.Instance:ShowHRefineAddEffectTip(self.tipStick, NGUIUtil.AnchorSide.TopRight, {-300, 0})
	end);

	self.posGrid = self:FindComponent("PosGrid", UIGrid, self.bord);
	self.hrefineEquipCtl = UIGridListCtrl.new(self.posGrid, HRefinePosCell, "HRefinePosCell");
	self.hrefineEquipCtl:AddEventListener(MouseEvent.MouseClick, self.ClickHRefineEquipCell, self);

	self.effectContainer = self:FindGO("EffectContainer", self.bord);
	-- leftBord


	-- coins
	local coins = self:FindChild("TopCoins");
	local usergold = self:FindGO("Gold", coins);
	self.goldLabel = self:FindComponent("Label", UILabel, usergold);
	local userRob = self:FindGO("Silver", coins);
	self.robLabel = self:FindComponent("Label", UILabel, userRob);
	-- coins
end

function HighRefinePanel:UpdateCoins()
	self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function HighRefinePanel:UpdateHRefineEquipPosInfo(initChoose)
	local posDatas = {};
	local showPoses = BlackSmithProxy.Instance:GetHighRefinePoses() or {5};
	for i=1,#showPoses do
		local data = { pos = showPoses[i] };
		table.insert(posDatas, data)
	end
	self.hrefineEquipCtl:ResetDatas(posDatas);

	if(initChoose)then
		self.hrefineEquipCells = self.hrefineEquipCtl:GetCells();
		
		self:ClickHRefineEquipCell(self.hrefineEquipCells[1]);
	end
end

function HighRefinePanel:ClickHRefineEquipCell(cell)
	self:SetChoosePos(cell.data.pos);
end

function HighRefinePanel:ClickMat(cell)
	local data = cell.data;
	if(data == nil)then
		return;
	end

	local sdata = {
		itemdata = data, 
		funcConfig = {},
	};
	self:ShowItemTip(sdata, self.tipStick, nil, {-190,0});
end

function HighRefinePanel:SetChoosePos(pos)
	local cells = self.hrefineEquipCells;
	for i=1,#cells do
		local data = cells[i].data;
		cells[i]:SetChoose(pos);
	end

	self.equipPos = pos;
	self:UpdateChooseHRefineEquipInfo(pos);

	local _, showlvType = BlackSmithProxy.Instance:GetShowHRefineDatas(pos)
	if(showlvType ~= 0)then
		self.centerControl:CenterOn(showlvType, true, true);
	end
end

function HighRefinePanel:DoHRefine()
	if(self.nextHRefineData)then
		if(self.materialEnough ~= true)then
			MsgManager.ShowMsgByIDTable(8); 
			return;
		end

		ServiceItemProxy.Instance:CallHighRefineCmd(self.nextHRefineData.id);
	end
end

function HighRefinePanel:UpdateChooseHRefineEquipInfo(equipPos)
	local datas = {}
	local maxType = blackSmithProxy:GetMaxHRefineTypeOrLevel(self.equipPos);
	for i=1,maxType do
		local showData = {};
		showData[1] = equipPos;
		showData[2] = i;
		table.insert(datas, showData);
	end
	self.hRefineCtl:ResetDatas(datas);
end

function HighRefinePanel:ChooseRefineCall(centerGO, centerIndex)
	self:UpdateChooseHRefineTypeInfo(centerIndex);
end

function HighRefinePanel:UpdateChooseHRefineTypeInfo(levelType)
	self.curLevelType = levelType;

	local curlv = blackSmithProxy:GetPlayerHRefineLevel(self.equipPos, levelType);
	local hRefineData = blackSmithProxy:GetHighRefineData(self.equipPos, levelType, curlv);

	self.curHRefineData = hRefineData;


	self.equipName.text = RoleEquipBagData.GetSiteNameZh(self.equipPos) .. ZhString[ "PackageHighRefine_Title_" .. levelType ];

	self.maxHRefineLevel = blackSmithProxy:GetMaxHRefineTypeOrLevel(self.equipPos, levelType);

	local nextEN_Str, nextEV_Str = "", "";

	if(curlv == self.maxHRefineLevel)then
		self.unFullBord:SetActive(false);
		self.maxTip:SetActive(true);

		self.nextHRefineData = nil;
	else
		-- typelevel, hrlevel, class, limitRefinelv
		self.nextHRefineData = blackSmithProxy:GetHighRefineData(self.equipPos, levelType, curlv + 1);

		self.maxTip:SetActive(false);
		self.unFullBord:SetActive(true);

		self.nextRefineLv.text = (curlv+1) .. "/" .. self.maxHRefineLevel;

		local effectmap = blackSmithProxy:Get_TotalHRefineEffect_Map(self.equipPos, 
							levelType, 
							curlv + 1,
							self.myclass);
		if(effectmap)then
			local proKey, proValue = next(effectmap);
			nextEN_Str = GameConfig.EquipEffect[proKey] or proKey .. " No Find";

			local config = propNameConfig[ proKey ];

			if(config == nil)then
				helplog("Not Find Config", proKey);
			end

			if(config.IsPercent == 1)then
				nextEV_Str = proValue * 100 .. "%";
			else
				nextEV_Str = proValue
			end
			if(proValue > 0)then
				nextEV_Str = "+" .. nextEV_Str;
			end
		else
			nextEN_Str = "No Effect";
			nextEV_Str = "+NULL";
		end
		self.nextEffect_Name.text = nextEN_Str .. ZhString.PackageHighRefine_colon;;
		self.nextEffect_Value.text = nextEV_Str;

		self.addEffectTip.text = string.format(ZhString.PackageHighRefine_AddEffectTip2, 
												self.nextHRefineData.RefineLv,
												RoleEquipBagData.GetSiteNameZh(self.equipPos), 
												nextEN_Str);

		self:UpdateMaterials();

		self:ActiveDoButton(self.nextHRefineData ~= nil);
	end

	self.nowRefineLv.text = curlv .. "/" .. self.maxHRefineLevel;
	local nowEN_Str, nowEV_Str = "", "";

	local fakeGet = curlv == 0;
	if(fakeGet)then
		curlv = 1;
	end
	local effectmap = blackSmithProxy:Get_TotalHRefineEffect_Map(self.equipPos, 
							levelType, 
							curlv,
							self.myclass);
	-- UI显示只放得下一个效果 如有扩展 后期改动
	if(effectmap)then
		local proKey, proValue = next(effectmap);
		if(fakeGet)then
			proValue = 0;
		end
		nowEN_Str = GameConfig.EquipEffect[proKey] or proKey .. " No Find";

		local config = propNameConfig[ proKey ];
		if(config.IsPercent == 1)then
			nowEV_Str = proValue * 100 .. "%";
		else
			nowEV_Str = proValue
		end
		if(proValue >= 0)then
			nowEV_Str = "+" .. nowEV_Str;
		end
	else
		nowEN_Str = nextEN_Str;
		nowEV_Str = "+0";
	end
	self.nowEffect_Name.text = nowEN_Str .. ZhString.PackageHighRefine_colon;
	self.nowEffect_Value.text = nowEV_Str;
end

function HighRefinePanel:UpdateMaterials()
	if(self.nextHRefineData == nil)then
		return;
	end

	self.materialEnough = true;

	local cost = self.nextHRefineData.Cost;
	local matDatas = {};
	local bagProxy = BagProxy.Instance;
	for i=1,#cost do
		local matData = ItemData.new("Mat", cost[i][1]);
		matData.num = bagProxy:GetItemNumByStaticID(cost[i][1]);
		matData.neednum = cost[i][2];
		table.insert(matDatas, matData);

		if(matData.neednum > matData.num)then
			self.materialEnough = false;
		end
	end
	self.hRefineMatCtl:ResetDatas(matDatas);
	local cells = self.hRefineMatCtl:GetCells();
	for i=1,#cells do
		cells[i]:ActiveClickTip(false);
	end
end

function HighRefinePanel:ActiveDoButton(b)
	if(b)then
		self.doButton_Sprite.color = ColorUtil.NGUIWhite;
		self.doButton_Collider.enabled = true;
		self.doButton_Label.effectColor = ColorUtil.ButtonLabelOrange;
	else
		self.doButton_Sprite.color = ColorUtil.NGUIShaderGray;
		self.doButton_Collider.enabled = false;
		self.doButton_Label.effectColor = ColorUtil.NGUIGray;
	end
end

function HighRefinePanel:OnEnter()
	HighRefinePanel.super.OnEnter(self);

	self.myclass = MyselfProxy.Instance:GetMyProfession()

	self:UpdateCoins();
	self:UpdateHRefineEquipPosInfo(true);

	local npcInfo = self.viewdata.viewdata and self.viewdata.viewdata.npcdata;
	if(npcInfo)then
		local rootTrans = npcInfo.assetRole.completeTransform;
		self:CameraFocusOnNpc(rootTrans);
	else
		self:CameraRotateToMe();
	end	
end

function HighRefinePanel:OnExit()
	HighRefinePanel.super.OnExit(self);

	self:CameraReset()
end
