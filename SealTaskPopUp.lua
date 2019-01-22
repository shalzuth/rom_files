autoImport("SimpleItemCell");
autoImport("SealMapCell")

SealTaskPopUp = class("SealTaskPopUp", ContainerView)

SealTaskPopUp.ViewType = UIViewType.PopUpLayer

function SealTaskPopUp:Init()
	self:InitView();
	self:MapEvent();
end

function SealTaskPopUp:InitView()
	self.sealInfoBord = self:FindGO("SealInfoBord");
	self.sealInfoBord:SetActive(false);

	self.selectEffect = self:FindGO("SelectEffect");

	self.dailyTime = self:FindComponent("DailyTime", UILabel);
	self.posLabel = self:FindComponent("PosName", UILabel);
	self.sealTip = self:FindComponent("SealTip", UILabel);
	
	local dropGrid = self:FindComponent("DropGrid", UIGrid);
	self.dropCtl = UIGridListCtrl.new(dropGrid ,SimpleItemCell ,"SimpleItemCell");
	self.dropCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self);

	local getBtn = self:FindGO("GetButton");
	self.getButtonSprite = getBtn:GetComponent(UISprite);
	self.getBtnLab = self:FindComponent("Label", UILabel, getBtn);
	self:AddClickEvent(getBtn, function (go) self:TakeSeal() end);

	self:InitMap();
	
	self:AddButtonEvent("CloseSealInfo", function (go) 
		self.selectData = nil;
		self.selectEffect:SetActive(false);
		self:UpdateSelectSealInfo();
	end);

	self.addCountTip = self:FindComponent("AddCountTip", UILabel);
end

function SealTaskPopUp:TakeSeal(cellctl)
	local aceptSeal = SealProxy.Instance.nowAcceptSeal;
	local imLeader = TeamProxy.Instance:CheckIHaveLeaderAuthority()
	if(TeamProxy.Instance:IHaveTeam() and imLeader)then
		local data = self.selectData;
		if(data)then
			local acceptSeal = data.acceptSeal;
			local sealData = data.sealData;
			if(acceptSeal)then
				MsgManager.ConfirmMsgByID(1609, function ()
					if(acceptSeal)then
						self.abadonSealId = sealData.id;
					else
						self.acceptSealId = sealData.id;
					end
					ServiceSceneSealProxy.Instance:CallSealAcceptCmd(sealData.id, acceptSeal);
				end, nil,nil);
			else
				if(aceptSeal and aceptSeal~=0)then
					MsgManager.ConfirmMsgByID(1609, function ()
						if(acceptSeal)then
							self.abadonSealId = sealData.id;
						else
							self.acceptSealId = sealData.id;
						end
						ServiceSceneSealProxy.Instance:CallSealAcceptCmd(sealData.id, acceptSeal);
					end, nil,nil);
				else
					if(acceptSeal)then
						self.abadonSealId = sealData.id;
					else
						self.acceptSealId = sealData.id;
					end
					ServiceSceneSealProxy.Instance:CallSealAcceptCmd(sealData.id, acceptSeal);
				end
			end
		end
	else
		MsgManager.ShowMsgByIDTable(1611);
	end
end

function SealTaskPopUp:InitMap()
	self.map = self:FindComponent("Map", UITexture);
	self.mapGrid = self:FindComponent("MapGrid", UIGrid);
	self.mapCtl = UIGridListCtrl.new(self.mapGrid, SealMapCell, "SealMapCell");
	self.mapCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMapCell, self);

	local mapSize = {x=self.map.width, y=self.map.height};
	local gridPos = Vector3(-(mapSize.x- WorldMapCellSize.x)/2, (mapSize.y- WorldMapCellSize.y)/2, 0);
	self.mapGrid.transform.localPosition = gridPos;

	local xm,ym = math.ceil(mapSize.x/WorldMapCellSize.x), math.ceil(mapSize.y/WorldMapCellSize.y);
	self.mapGrid.maxPerLine = xm;
	local sealMapDatas = {};
	for y = 1, ym do
		for x = 1, xm do
			local mapData = WorldMapProxy.Instance:GetMapAreaDataByPos(y, x);
			local sealMapData = {index = x * self.mapGrid.maxPerLine + y, mapData = data};
			table.insert(sealMapDatas, sealMapData);
		end
	end
	self.mapCtl:ResetDatas(sealMapDatas);
end

function SealTaskPopUp:ClickMapCell(cellctl)
	local data = cellctl and cellctl.data;
	if(data and data.sealData)then
		self.selectData = data;

		self.selectEffect.transform:SetParent(cellctl.gameObject.transform, false);
		self.selectEffect:SetActive(true);
	end

	self:UpdateSelectSealInfo();
end

function SealTaskPopUp:ClickDropItem(cellctl)
	local data = cellctl and cellctl.data;
	local go = cellctl and cellctl.gameObject;
	local newChooseId = data and data.staticData.id or 0;
	if(self.chooseId~=newChooseId)then
		self.chooseId = newChooseId;
		local callback = function () 
			self.chooseId = 0 
		end
		local sdata = {
			itemdata = data,
			funcConfig = {},
			ignoreBounds = {go},
			hideGetPath = true,
			callback = callback,
		};
		local stick = go:GetComponent(UIWidget);
		self:ShowItemTip(sdata, stick, nil, {200,-100});
	else
		self:ShowItemTip();
		self.chooseId = 0;
	end
end

function SealTaskPopUp:GetMapCellByMapId(mapid)
	local mapdata = WorldMapProxy.Instance:GetMapAreaDataByMapId(mapid);
	local cells = self.mapCtl:GetCells();

	local pos = mapdata and mapdata.pos;
	if(pos and pos.x and pos.y)then
		local index = (pos.x-1)*self.mapGrid.maxPerLine + pos.y;
		return cells[index];
	end
end

function SealTaskPopUp:UpdateSealTasks()
	local list = SealProxy.Instance.nowSealTasks;
	local aceptSealId, aceptSeal = SealProxy.Instance.nowAcceptSeal;
	local firstSealMap;
	for i=1,#list do
		local sealid = list[i];
		local rsdata = sealid and Table_RepairSeal[sealid];
		if(rsdata)then
			local mapid = rsdata.MapID;
			local mapCell = self:GetMapCellByMapId(mapid);
			if(mapid == 22)then
				helplog("SealTaskPopUp UpdateSealTasks", mapCell);
			end
			if(mapCell)then
				local data = mapCell.data;
				data.sealData = rsdata;
				if(rsdata.id == aceptSealId)then
					data.acceptSeal = true;
					aceptSeal = data;
				else
					data.acceptSeal = false;
				end
				mapCell:SetData(data);
				if(i == 1)then
					firstSealMap = mapCell;
				end
			end
		end
	end
	if(self.selectData == nil)then
		self:ClickMapCell(firstSealMap);
	end
end

function SealTaskPopUp:UpdateSealRepairTimes()
	-- ??????????????????
	local var = MyselfProxy.Instance:getVarByType(Var_pb.EVARTYPE_SEAL);
	local donetimes = var and var.value;
	donetimes = donetimes or 0;
	local maxtimes = GameConfig.Seal.maxSealNum;
	--todo xde ??????????????????
	donetimes = (donetimes < maxtimes) and donetimes or maxtimes
	self.dailyTime.text = donetimes.."/"..maxtimes;

	local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(AERewardType.Seal);
	local extratimes = rewardInfo and rewardInfo:GetExtraTimes() or 0;
	if(extratimes > 0)then
		self.addCountTip.gameObject:SetActive(true);
		self.addCountTip.text = string.format(ZhString.SealTaskPopUp_ExtraTimesTip, extratimes);
	else
		self.addCountTip.gameObject:SetActive(false);
	end
end

function SealTaskPopUp:UpdateSelectSealInfo()
	local data = self.selectData;
	if(not data)then
		self.sealInfoBord:SetActive(false);
		return;
	end

	self.sealInfoBord:SetActive(true);

	if(data.acceptSeal)then
		self.getBtnLab.text = ZhString.SealTaskPopUp_GiveUp;
		self.getBtnLab.effectColor = Color(207/255, 28/255, 15/255);
		self.getButtonSprite.spriteName = "com_btn_0";
	else
		self.getBtnLab.text = ZhString.SealTaskPopUp_Accept;
		self.getBtnLab.effectColor = Color(159/255, 79/255, 9/255);
		self.getButtonSprite.spriteName = "com_btn_2s";
	end
	local sealData = data.sealData;
	self.sealTip.text = sealData.Text or "";
	self.posLabel.text = data.sealData.Map;

	local reward, chooseReward = {}, {};
	if(sealData and sealData.reward)then
		for _,rewardTeamId in pairs(sealData.reward)do
			local items = ItemUtil.GetRewardItemIdsByTeamId(rewardTeamId);
			for _,item in pairs(items)do
				if(Table_Item[item.id])then
					table.insert(reward, ItemData.new("SealReward", item.id));
				end
			end
		end
	end
	table.sort(reward, function (itemA,itemB)
		local isAEquip = itemA.equipInfo~=nil;
		local isBEquip = itemB.equipInfo~=nil;
		if(isAEquip~=isBEquip)then
			return isAEquip;
		end
		local aQuality = itemA.staticData.Quality;
		local bQuality = itemB.staticData.Quality;
		if(aQuality ~= bQuality)then
			return aQuality > bQuality;
		end
		return itemA.staticData.id > itemB.staticData.id;
	end);
	for i=1,#reward do
		table.insert(chooseReward, reward[i]);
		if(#chooseReward>=3)then
			break;
		end
	end
	self.dropCtl:ResetDatas(chooseReward);
end

function SealTaskPopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.SceneSealSealQueryList, self.UpdateSealTasks);
	self:AddListenEvt(ServiceEvent.SceneSealSealAcceptCmd, self.HandleAcceptSeal);
end

function SealTaskPopUp:HandleAcceptSeal(note)
	if(self.acceptSealId)then
		local sealData = Table_RepairSeal[self.acceptSealId]
		if(sealData)then
			MsgManager.ShowMsgByIDTable(1614, sealData.Map);
		end
	elseif(self.abadonSealId)then
		local sealData = Table_RepairSeal[self.abadonSealId]
		if(sealData)then
			MsgManager.ShowMsgByIDTable(1615, sealData.Map);
		end
	end
	self.acceptSealId = nil;
	self.abadonSealId = nil;

	self:UpdateSealTasks();
	self:UpdateSelectSealInfo();
end

function SealTaskPopUp:OnEnter()
	SealTaskPopUp.super.OnEnter(self);
	
	ServiceSceneSealProxy.Instance:CallSealQueryList() 
	
	self:UpdateSealRepairTimes();
end

function SealTaskPopUp:OnExit()
	SealTaskPopUp.super.OnExit(self);
end













