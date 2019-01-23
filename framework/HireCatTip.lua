autoImport("BaseTip");
HireCatTip = class("HireCatTip", BaseTip);

autoImport("Table_MonsterOrigin");
autoImport("HeadImageData");

HireCatType = {
	Gender = 1,
	Skill = 2,
	Desc = 3,
	HirePos = 4,
	HirePrice = 5,
	LeftTime = 6,
}

function HireCatTip:Init()
	self.contextDatas = {};
	self:InitCell();
end

function HireCatTip:InitCell()
	local headContainer = self:FindGO("HeadContainer");
	self.headIconCell = HeadIconCell.new();
	self.headIconCell:CreateSelf(headContainer);
	self.headIconCell:SetMinDepth(40);
	self.headData = HeadImageData.new();

	self.catName = self:FindComponent("CatName", UILabel);
	self.profession = self:FindComponent("Profession", UILabel);

	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	local panels = self:FindComponents(UIPanel);
	for i=1,#panels do
		panels[i].depth = upPanel.depth + panels[i].depth;
	end
	local table = self:FindComponent("AttriTable", UITable);
	self.attriCtl = UIGridListCtrl.new(table, TipLabelCell, "TipLabelCell");

	self.goButton = self:FindGO("GoButton");
	self:AddClickEvent(self.goButton, function (go)
		-- TODO GO
		if(self.shortcutPowerId~=nil)then
			FuncShortCutFunc.Me():CallByID(self.shortcutPowerId)
		end
	end);

	self.lock = self:FindGO("Lock");
	self.lockTip = self:FindComponent("LockTip", UILabel);

	self.bg = self:FindComponent("Bg", UISprite);

	self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	
	EventManager.Me():AddEventListener(ServiceEvent.QuestQueryOtherData, self.UpdateHirePrice, self);
end

function HireCatTip:AddAutoCloseEvent()
	self.closeComp.callBack = function ()
		if(HireCatTip == TipsView.Me().currentTipType)then
			TipsView.Me():HideCurrent();
		end
	end
end

function HireCatTip:SetCloseCall(call, callParam)
	self.closeComp.callBack = function ()
		if(call~=nil)then
			call(callParam);
		end
	end;
end

function HireCatTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closeComp)then
		self.closeComp:AddTarget(obj.transform);
	end
end

function HireCatTip:SetData(data)
	local sData = data.staticData;
	self.catid = sData.id;

	self.masterid = data.masterid;
	self.expiretime = data.expiretime or 0;

	self.shortcutPowerId = sData.ShortcutPower;

	local monsterData = Table_Monster[sData.MonsterID];
	if(monsterData)then
		self.catName.text = monsterData.NameZh;

		self.headData:TransByMonsterData(monsterData);

		if(self.headData.iconData.type == HeadImageIconType.Avatar)then
			self.headIconCell:SetData(self.headData.iconData);
		elseif(self.headData.iconData.type == HeadImageIconType.Simple)then
			self.headIconCell:SetSimpleIcon(self.headData.iconData.icon);
		end
	end
	self.profession.text = string.format(ZhString.HireCatTip_ProfessionTip, sData.Job);

	local MenuID = sData.MenuID;
	local menuData = MenuID and Table_Menu[MenuID];
	if(menuData)then
		self.lockTip.text = tostring(menuData.Tip);
	else
		self.lockTip.text = "";
	end

	TableUtility.TableClear(self.contextDatas);
	local genderTip = {};
	genderTip.type = HireCatType.Gender;
	genderTip.label = string.format(ZhString.HireCatTip_GenderTip, sData.Gender);
	genderTip.hideline = true;
	self.contextDatas[HireCatType.Gender] = genderTip;

	local skillTip = {};
	skillTip.type = HireCatType.Skill;
	skillTip.label = string.format(ZhString.HireCatTip_SkillTip, sData.Skill);
	skillTip.hideline = true;	
	self.contextDatas[HireCatType.Skill] = skillTip;

	local descTip = {};
	descTip.type = HireCatType.Desc;
	descTip.label = string.format(ZhString.HireCatTip_DescTip, sData.Introduction);
	self.contextDatas[HireCatType.Desc] = descTip;

	if(Table_MonsterOrigin)then
		local npcId = sData.NPCID;
		local posConfigs = Table_MonsterOrigin[npcId];
		if(posConfigs and #posConfigs>0)then
			local posTip = "";
			for i=1,#posConfigs do
				local mapID = posConfigs[i].mapID;
				local mapdata = Table_Map[mapID];
				if(mapdata)then
					posTip = posTip..mapdata.NameZh;
					posTip = posTip..ZhString.HireCatTip_And;
				end
			end
			local len = StringUtil.getTextLen( posTip)
			posTip = StringUtil.getTextByIndex( posTip,1,len -1)

			local hirePosTip = {};
			hirePosTip.type = HireCatType.HirePos;
			hirePosTip.label = string.format(ZhString.HireCatTip_HirePosTip, posTip);
			hirePosTip.hideline = true;
			self.contextDatas[HireCatType.HirePos] = hirePosTip;
		end
	end		

	local hirePriceTip = {};
	hirePriceTip.type = HireCatType.HirePrice;
	hirePriceTip.label = string.format(ZhString.HireCatTip_HirePriceTip, 0);
	self.contextDatas[HireCatType.HirePrice] = hirePriceTip;

	self:AddLeftTimeCheck();

	ServiceQuestProxy.Instance:CallQueryCatPrice(sData.id, 1)
	-- self.attriCtl:ResetDatas(self.contextDatas);
end

function HireCatTip:SetLock(b)
	if(b == true)then
		self.lock:SetActive(true);
	else
		self.lock:SetActive(false);
	end
end

function HireCatTip:AddLeftTimeCheck()
	local leftTime;
	if(self.masterid ~= nil and self.masterid ~= Game.Myself.data.id)then
		leftTime = 0;
	else
		leftTime = self.expiretime - ServerTime.CurServerTime()/1000;
	end
	if(leftTime > 0)then
		if(self.masterid == nil or 
			(self.masterid == Game.Myself.data.id))then
				self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._Tick, self);
		else
			self:UpdateLeftTime(0);
		end
	else
		self:UpdateLeftTime(0);
	end
end

function HireCatTip:_Tick(deltatime)
	local leftTime = self.expiretime - ServerTime.CurServerTime()/1000;
	self:UpdateLeftTime(leftTime);
	if(leftTime <= 0)then
		self:RemoveLeftTimeCheck();
	end
end

function HireCatTip:UpdateLeftTime(leftTime)
	if(leftTime > 0)then
		local data = self.contextDatas[HireCatType.LeftTime]
		if(not self.contextDatas[HireCatType.LeftTime])then
			data = {};
			self.contextDatas[HireCatType.LeftTime] = data;
		end

		local day,hour,min,sec = ClientTimeUtil.FormatTimeBySec(leftTime);
		if(day > 0)then
			data.label = string.format(ZhString.HireCatTip_HireLeftTimeTip, day + 1);
			data.label = data.label..ZhString.HireCatTip_Day;
		else
			data.label = string.format("%02d:%02d:%02d", hour, min, sec);
			data.label = string.format(ZhString.HireCatTip_HireLeftTimeTip, data.label);
		end
		self:ActiveGoButton(false);
	else
		self.contextDatas[HireCatType.LeftTime] = nil;
		self:ActiveGoButton(true);
	end

	self.attriCtl:ResetDatas(self.contextDatas);
end

function HireCatTip:ActiveGoButton(b)
	if(b)then
		self.bg.height = 716;
		self.goButton:SetActive(true);
	else
		self.bg.height = 626;
		self.goButton:SetActive(false);
	end
end

function HireCatTip:RemoveLeftTimeCheck()
	if(self.timeTick)then
		TimeTickManager.Me():ClearTick(self)
	end
	self.timeTick = nil;
end

function HireCatTip:UpdateHirePrice(evt)
	local data = evt.data;
	local price = data.param3;
	local data = self.contextDatas[HireCatType.HirePrice];
	if(data)then
		data.label = string.format(ZhString.HireCatTip_HirePriceTip, price);
	end
	self.attriCtl:ResetDatas(self.contextDatas);
end

function HireCatTip:OnExit()
	EventManager.Me():RemoveEventListener(ServiceEvent.QuestQueryOtherData, self.UpdateHirePrice, self)
	self:RemoveLeftTimeCheck();
	self.expiretime = 0;
	self.shortcutPowerId = nil;
	return HireCatTip.super.OnExit(self);
end

function HireCatTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end	
end
