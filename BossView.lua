	BossView = class("BossView", BaseView);

autoImport("BossCell");
autoImport("BaseItemCell");

BossView.ViewType = UIViewType.NormalLayer

BossFliterOptIndex = {
	All = 1,
	Mvp = 2,
	Mini = 3;
}
BossFliterOpt = {
	ZhString.BossView_All, "Mvp", "Mini"
}

function BossView:Init()
	self:FindObjs();
	self:MapViewListen();
end

local tempArgs = {};
function BossView:FindObjs()
	local miniTogGO = self:FindGO("ShowMiniTog");
	self.showMiniTog = self:FindComponent("Tog", UIToggle);
	self.showMiniTog_Collider = miniTogGO:GetComponent(BoxCollider);
	self.showMiniTog_Label = self:FindComponent("Label", UILabel, miniTogGO);
	self.showMiniTog_CheckBg = self:FindComponent("Checkmark", UISprite, miniTogGO);
	self.showMiniTog_Bg = miniTogGO:GetComponent(UISprite);

	self:AddTabEvent(miniTogGO, function (go, value)
		self:UpdateMini();
  	end);

	local bossScroll = self:FindGO("BossScroll");

	-- self.bossContainer = self:FindComponent("BossContainer", ChangeRqByTex);
	self.bossTexture = self:FindComponent("BossTexture", UITexture);
	self.bossname = self:FindComponent("BossName", UILabel);
	self.bossElement = self:FindComponent("BossElement", UISprite);

	local bossInfo = self:FindGO("BossInfo");
	self.bossPosition = self:FindComponent("position", UILabel, bossInfo);
	self.bossDesc = self:FindComponent("Desc", UILabel, bossInfo);
	self.chooseSymbol = self:FindGO("BossChooseSymbol");

	local gobutton = self:FindGO("goButton");
	self:AddClickEvent(gobutton, function (go)
		if(Game.Myself:IsDead())then
			MsgManager.ShowMsgByIDTable(2500);
		else
			if(self.chooseBoss~=nil)then
				TableUtility.TableClear(tempArgs);
				tempArgs.targetMapID = self.chooseBoss.mapid;
				
				local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove);
				if(cmd)then
					Game.Myself:Client_SetMissionCommand( cmd );	
				end
				self:CloseSelf();
			end
		end
	end);

	local container = self:FindGO("BossWrap")
	local wrapConfig = {
		wrapObj = container,
		pfbNum = 6, 
		cellName = "BossCell", 
		control = BossCell, 
		dir = 1,
	}
	self.bosslst = WrapCellHelper.new(wrapConfig)
	self.bosslst:AddEventListener(MouseEvent.MouseClick, self.ClickBossCell, self)
end

function BossView:UpdateMini()
	if(self.updateMini_InCD)then
		MsgManager.ShowMsgByIDTable(952);
		return;
	end

	self.updateMini_InCD = true;
	if(self.lt)then
		self.lt:cancel();
	end
	self.lt = LeanTween.delayedCall(5,function ()
		self.updateMini_InCD = false;
		self.lt = nil;
	end);

	self.showMiniTog.value = not self.showMiniTog.value;
	self:UpdateBossList();

	LocalSaveProxy.Instance:SetBossView_ShowMini(self.showMiniTog.value);
end

function BossView:ClickBossCell(cellctl, forceUpdate)
	local data = cellctl and cellctl.data;
	if(data)then
		self.chooseBoss = data;

		if(self.chooseId~=data.id or self.chooseMap~=data.mapid or forceUpdate == true)then
			local obj = cellctl.gameObject;
			self:UpdateBossInfo(data);

			self.chooseId = data.id;
			self.chooseMap = data.mapid;
			for _,cell in pairs(self.bossCells) do
				cell:SetChoose(self.chooseId, self.chooseMap);
			end
		else
			self.chooseId = 0;
			self.chooseMap = 0;
		end
	end
end

function BossView:UpdateBossList()
	if(self.mvplist == nil)then
		helplog("BossList is nil!");
		return;
	end

	if(self.datas == nil)then
		self.datas = {};
	else
		TableUtility.TableClear(self.datas)
	end

	self.bosslst:ResetPosition();
	
	TableUtility.ArrayShallowCopy(self.datas, self.mvplist)	

	if(self.showMiniTog.value and self.minilist)then
		for i=1,#self.minilist do
			table.insert(self.datas, self.minilist[i]);
		end
	end
	table.sort(self.datas, BossView.BossSortFunc);

	self.bosslst:UpdateInfo(self.datas);

	if(self.bossCells == nil)then
		self.bossCells = self.bosslst:GetCellCtls();
	end
	self:ClickBossCell(self.bossCells[1], true);
end

function BossView.BossSortFunc(a,b)
	local monsterA = Table_Monster[a.id];
	local monsterB = Table_Monster[b.id];

	local levela = monsterA.Level;
	local levelb = monsterB.Level;

	if(levela ~= levelb)then
		return levela<levelb;
	end

	local isAMvp = monsterA.Type == "MVP";
	local isBMvp = monsterB.Type == "MVP";
	if(isAMvp ~= isBMvp)then
		return isAMvp;
	end

	return a.id < b.id;
end

function BossView:UpdateBossInfo(data)
	local bossStaticdata = data.staticData;
	self.bossname.text = bossStaticdata.NameZh;

	local mapid = data.mapid or bossStaticdata.Map;
	local mapIds = {};
	if(type(mapid) == "number")then
		table.insert(mapIds, mapid);
	elseif(type(mapid) == "table")then
		mapIds = mapid;
	end
	local posDesc = "";
	for i=1,#mapIds do
		local id = mapIds[i];
		if(Table_Map[id])then
			posDesc = Table_Map[id].CallZh;
		end
		if(i<#mapIds)then
			posDesc = posDesc..", "
		end
	end
	self.bossPosition.text = posDesc;
	
	local mdata = Table_Monster[bossStaticdata.id];
	-- update dropitems
	local dropItems = {};
	for k,v in pairs(mdata.Dead_Reward)do
		local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(v);
		for _,data in pairs(rewardTeamids)do
			local item = ItemData.new("Reward", data.id);
			item.num = data.num;
			table.insert(dropItems, item);
		end
	end
	
	table.sort(dropItems, function (a, b) 
		if(a.staticData and b.staticData)then
			return a.staticData.Quality>b.staticData.Quality 
		else
			return false;
		end
	end);
	if(self.drop == nil)then
		local dropScrollObj = self:FindGO("DropItemScroll");
		self.dropScroll = dropScrollObj:GetComponent(UIScrollView);
		local dropGrid = self:FindGO("Grid", dropScrollObj):GetComponent(UIGrid);
		self.drop = UIGridListCtrl.new(dropGrid, BaseItemCell, "DropItemCell");
		self.drop:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self);
	end
	self.dropScroll:ResetPosition();
	self.drop:ResetDatas(dropItems);

	self.bossDesc.text = mdata.Desc;
	UIUtil.WrapLabel (self.bossDesc);
	
	self:UpdateBossAgent(mdata);

	self.bossElement.spriteName = "";
end

function BossView:ClickDropItem(cellctl)
	if(cellctl and cellctl~=self.chooseItem)then
		local data = cellctl.data;
		local stick = cellctl.gameObject:GetComponentInChildren(UISprite);
		if(data)then
			local callback = function ()
				self:CancelChoose();
			end
			local sdata = {
				itemdata = data,
				funcConfig = {},
				callback = callback,
				ignoreBounds = {cellctl.gameObject},
			};
			self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0});
		end
		self.chooseItem = cellctl;
	else
		self:CancelChoose();
	end
end

function BossView:CancelChoose()
	self.chooseItem = nil;
	self:ShowItemTip();
end

local monsterPos = LuaVector3();
function BossView:UpdateBossAgent(monsterData)
	local model = UIModelUtil.Instance:SetMonsterModelTexture(self.bossTexture, monsterData.id)

	local showPos = monsterData.LoadShowPose;
	monsterPos:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0);
	model:SetPosition(monsterPos);

	model:SetEulerAngleY(monsterData.LoadShowRotate or 0);
	local size = monsterData.LoadShowSize or 1
	model:SetScale(size);
end

function BossView:MapViewListen()
	self:AddListenEvt(ServiceEvent.BossCmdBossListUserCmd, self.HandleBosslstUpdate);
end

function BossView:HandleBosslstUpdate(note)
	local bossDatas = note.body;
	self.mvplist = bossDatas[1];
	self.minilist = bossDatas[2];
	self:UpdateBossList();
end

local tempColor = LuaColor.New(1,1,1,1);
function BossView:ActiveShowMiniTog(b)
	if(b)then
		self.showMiniTog_Collider.enabled = true;
		tempColor:Set(1,1,1,1);
		self.showMiniTog_Bg.color = tempColor;
		self.showMiniTog_CheckBg.color = tempColor;

		tempColor:Set(0,0,0,1);
		self.showMiniTog_Label.color = tempColor;
	else
		self.showMiniTog_Collider.enabled = false;
		tempColor:Set(1/255,2/255,3/255,1);
		self.showMiniTog_Bg.color = tempColor;
		self.showMiniTog_CheckBg.color = tempColor;

		tempColor:Set(157/255,157/255,157/255,1);
		self.showMiniTog_Label.color = tempColor;
	end
end

function BossView:OnEnter()
	self.super.OnEnter(self);

	local amIMonthlyVIP = UIModelMonthlyVIP.Instance():AmIMonthlyVIP()
	if(amIMonthlyVIP)then
		self:ActiveShowMiniTog(true);

		self.showMiniTog.value = LocalSaveProxy.Instance:GetBossView_ShowMini();
	else
		self:ActiveShowMiniTog(false);
		self.showMiniTog.value = false;
	end

	ServiceBossCmdProxy.Instance:CallBossListUserCmd();
end

function BossView:OnExit()
	if(self.bossCells)then
		for i=1,#self.bossCells do
			self.bossCells[i]:RemoveUpdateTime();
		end
		self.bossCells = nil;
	end

	if(self.lt)then
		self.lt:cancel();
	end
	self.super.OnExit(self);
end



