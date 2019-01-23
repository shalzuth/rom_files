autoImport("ItemTipBaseCell");
ItemTipComCell = class("ItemTipComCell", ItemTipBaseCell);

autoImport("ItemTipFuncCell");
autoImport("ItemSecendFuncBord");

local tempV3 = LuaVector3();
function ItemTipComCell:ctor(obj, index)
	ItemTipComCell.super.ctor(self, obj);
	self.index = index;
end

function ItemTipComCell:Init()
	ItemTipComCell.super.Init(self);
	
	self.bg = self:FindComponent("Bg", UISprite);
	self.tips = self:FindComponent("Tips", UILabel);
	--todo xde
	OverseaHostHelper:FixLabelOverV1(self.tips,3,320)

	self.refreshTip_GO = self:FindGO("RefreshTip");
	if(self.refreshTip_GO)then
		self.refreshTip = self:FindComponent("Label", UILabel, self.refreshTip_GO);
	end
	
	self.beforePanel = self:FindGO("BeforePanel");
	
	self.func = {};
	self.bottomBtns = self:FindGO("BottomButtons");
	--todo xde
	local btnBackground = self:FindGO("Background",self.bottomBtns):GetComponent(UISprite)
	local btnLabel = self:FindGO("Label",self.bottomBtns):GetComponent(UILabel)
	OverseaHostHelper:FixAnchor(btnBackground.leftAnchor,btnLabel.transform,0,-12)
	OverseaHostHelper:FixAnchor(btnBackground.rightAnchor,btnLabel.transform,1,12)

	local style1, style2, style3 = {},{},{};
	style1.obj = self:FindGO("Style1", self.bottomBtns);
	style2.obj = self:FindGO("Style2", self.bottomBtns);
	style3.obj = self:FindGO("Style3", self.bottomBtns);
	style3.morebg = self:FindComponent("MoreBg", UISprite,style3.obj);
	self:AddButtonEvent("FuncBtnMore");
	self:InitFuncBtnStyle(1, style1);
	self:InitFuncBtnStyle(2, style2);
	self:InitFuncBtnStyle(5, style3);
	self.func.style = {style1,style2,style3};

	self.LockRoot=self:FindGO("LockRoot");
	self.LockDes=self:FindComponent("LockMenuDes",UILabel);

	self.showfpButton = self:FindGO("ShowFPreviewButton");
	if(self.showfpButton)then
		self:AddClickEvent(self.showfpButton, function (go)
			self:PassEvent(ItemTipEvent.ShowFashionPreview, self);
		end);
	end

	self.showupButton = self:FindGO("ShowUpgradeButton");
	if(self.showupButton)then
		self.showupButton_Symbol = self:FindComponent("Symbol", UISprite, self.showupButton);
		self:AddClickEvent(self.showupButton, function ()
			self:PassEvent(ItemTipEvent.ShowEquipUpgrade, self);
		end);
	end
	
	--todo xde
	local ItemName = self:FindGO("ItemName"):GetComponent(UILabel)
	ItemName.fontSize = 23
	OverseaHostHelper:FixLabelOverV1(ItemName,3,280)
end

function ItemTipComCell:InitFuncBtnStyle(num, container)
	container.button = {};
	for i = 1,num do
		local obj = self:FindGO("FuncBtn"..i, container.obj);
		container.button[i] = ItemTipFuncCell.new(obj);
		container.button[i]:AddEventListener(MouseEvent.MouseClick, self.ClickTipFunc, self)
	end
end

function ItemTipComCell:ClickTipFunc(cellCtl)
	local data = cellCtl.data;
	if(data)then
		local childFunction = data.childFunction;
		if(childFunction)then
			self:ShowSecendFunc(childFunction, data.childFunction_Tip, self.beforePanel, cellCtl.bg);
		else
			if(data.type == "GotoUse")then
				self:PassEvent(ItemTipEvent.ShowGotoUse, self);
				return;
			end

			local count = self.chooseCount or 1;
			local callback = data.callback;
			if(callback)then
				self:UpdateCountChooseBordButton();
				callback(data.callbackParam, count);
			else
				MsgManager.FloatMsgTableParam(nil, data.type .. " Not Implement")
			end
			-- 使用功能当数量大于1不关闭功能提示 
			if(data.type == "Apply" and self.data.num>count and (not self.data.staticData.UseMode or self.data.staticData.UseMode==0))then
				return;
			end
			if(data.noClose)then
				return;
			end
			self:PassEvent(ItemTipEvent.ClickTipFuncEvent);
		end
	end
end

function ItemTipComCell:SetData(data)
	self.data = data;
	if(data)then
		self.gameObject:SetActive(true);

		ItemTipComCell.super.SetData(self, data);

		self.scrollview:ResetPosition();
		
		self.scrollview.gameObject:SetActive(false);
		self.scrollview.gameObject:SetActive(true);

		self:UpdateShowFpButton();
		-- self:UpdateShowUpButton();
	else
		self.gameObject:SetActive(false);
	end
end

function ItemTipComCell:UpdateShowFpButton()
	local data = self.data;

	if(self.showfpButton)then
		if(data:IsPic())then
			local composeId = data.staticData.ComposeID;
			local productId = composeId and Table_Compose[ composeId ] and Table_Compose[ composeId ].Product.id;
			local product = productId and ItemData.new("Product", productId);
			if(product and product:CanEquip())then
				self.showfpButton:SetActive(true);
			else
				self.showfpButton:SetActive(false);
			end
		elseif(data:EyeCanEquip())then
			self.showfpButton:SetActive(true);
		elseif(data:HairCanEquip())then
			self.showfpButton:SetActive(true);
		else
			if(data:IsFashion() or (data.equipInfo and data.equipInfo:IsWeapon()))then
				if(data:CanEquip())then
					self.showfpButton:SetActive(true);
				else
					self.showfpButton:SetActive(false);
				end
			else
				if(data.equipInfo and data.equipInfo.equipData.Type == "Shield")then
					local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION);
					if(class == 72 or class == 73 or class == 74)then
						self.showfpButton:SetActive(true);
					else
						self.showfpButton:SetActive(false);
					end
				else
					self.showfpButton:SetActive(false);
				end
			end
		end
	end
end


local SpriteBlue = Color(79/255,106/255,177/255,1);
local SpriteRed = Color(255/255,0/255,0/255,1);
function ItemTipComCell:UpdateShowUpButton()
	local data = self.data;

	if(self.showupButton)then
		if(data and data.equipInfo and data.equipInfo.upgradeData)then
			self.showupButton:SetActive(true);

			if(not data.equipInfo:CanUpgrade())then
				self.showupButton:SetActive(false);
			else
				if(data.equipInfo:CheckCanUpgradeSuccess(true))then
					self.showupButton_Symbol.color = SpriteBlue;
				else
					self.showupButton_Symbol.color = SpriteRed;
				end
			end
			
		else
			self.showupButton:SetActive(false);
		end
	end
end

function ItemTipComCell:SetDownTipText(tips)
	if(tips and tips~="")then
		self.tips.gameObject:SetActive(true);
		self.tips.text = tips;
	else
		self.tips.gameObject:SetActive(false);
	end

	self:UpdateTipFunc({});
end

function ItemTipComCell:HideGetPath()
	self:ActiveGetPath(false);
end

function ItemTipComCell:ActiveGetPath(b)
	if(self.getPathBtn)then
		self.getPathBtn.gameObject:SetActive(b);
	end
end

function ItemTipComCell:HidePreviewButton()
	if(self.showfpButton)then
		self.showfpButton.gameObject:SetActive(false);
	end
end

local StoreFuncKey = {
	["WthdrawnRepository"] = 1,
	["PersonalWthdrawnRepository"] = 1,
	["PutBackBarrow"] = 1,
	["DepositRepository"] = 1,
	["PersonalDepositRepository"] = 1,
	["PutInBarrow"] = 1,
}

function ItemTipComCell:UpdateTipFunc(config)
	config = config or {};
	local funcDatas = {};
	self.hasUseFunc = false;
	self.hasStroeFunc = false;
	local locked = false
	local UnlockPetWork = PetWorkSpaceProxy.Instance:IsFuncUnlock()
	for i=1,#config do
		local cfgid = config[i];
		local cfgdata = GameConfig.ItemFunction[cfgid];
		if(cfgdata)then
			if(self.data.staticData.id==5542)then
				if(not UnlockPetWork)then
					locked = true
				end
			end
			local state = FunctionItemFunc.Me():CheckFuncState(cfgdata.type, self.data);
			if(state == ItemFuncState.Active or state == ItemFuncState.Grey)then
				if(cfgdata.type == "Apply" or cfgdata.type == "PutFood")then
					self.hasUseFunc = true;
				elseif(StoreFuncKey[cfgdata.type])then
					self.hasStroeFunc = true;
				end
				local data = {
					itemData = self.data,
					name = cfgdata.name,
				type = cfgdata.type,
					callback = FunctionItemFunc.Me():GetFuncById(cfgid),
					callbackParam = self.data,

					childFunction = cfgdata.childFunction,
					childFunction_Tip = cfgdata.childFunction_Tip,
				};

				table.insert(funcDatas, data);
			end
		end
	end
	self:UpdateTipButtons(funcDatas);

	local d = self.data;
	if(self.hasStroeFunc)then
		self:UpdateCountChooseBord(d.staticData.MaxNum);
		self:SetChooseCount(d.num);
	else
		self:UpdateCountChooseBord();
		self:SetChooseCount(1);
	end
	self.LockRoot:SetActive(locked)
	self.LockDes.gameObject:SetActive(locked)
	if(locked)then
		self.LockDes.text = Table_Menu[1907].text
	end
end

function ItemTipComCell:UpdateTipButtons(funcDatas)
	self.funcDatas = funcDatas;
	local n = #funcDatas;
	self.hasFunc = n>0;

	if(self.hasFunc)then
		local style;
		if(n == 1)then
			style = self.func.style[1];
		elseif(n == 2)then
			style = self.func.style[2];
		elseif(n>2)then
			style = self.func.style[3];
			style.morebg.height = 60*(n-1) + 10;
		end
		for i=1,3 do
			self.func.style[i].obj:SetActive(style == self.func.style[i]);
		end
		for i=1, #style.button do
			style.button[i]:SetData(funcDatas[i]);
		end
	else
		for i=1,3 do
			self.func.style[i].obj:SetActive(false);
		end
	end

	self:UpdateBgHeight();
end

function ItemTipComCell:UpdateBgHeight()
	if(self.hasFunc or self.tips.gameObject.activeInHierarchy)then
		self.bg.height = 606;
	else
		if(self.refreshTip_GO and self.refreshTip_GO.gameObject.activeInHierarchy)then
			self.bg.height = 536;
		else
			self.bg.height = 506;
		end
	end
end

function ItemTipComCell:SetDelTimeTip(isShow)
	if(Slua.IsNull(self.bottomBtns))then
		return;
	end

	if(Slua.IsNull(self.refreshTip_GO))then
		self.refreshTip_GO.gameObject:SetActive(false);
		TimeTickManager.Me():ClearTick(self, 1);
	end

	local data = self.data;
	if(isShow and data and data.deltime and data.deltime * 1000 > ServerTime.CurServerTime())then
		tempV3:Set(0,-255,0);
		self.bottomBtns.transform.localPosition = tempV3;
		self.refreshTip_GO.gameObject:SetActive(true);
		TimeTickManager.Me():CreateTick(0, 1000, self.UpdateDelTimeTip, self, 1);
	else
		tempV3:Set(0,-240,0);
		self.bottomBtns.transform.localPosition = tempV3;
		self.refreshTip_GO.gameObject:SetActive(false);
		TimeTickManager.Me():ClearTick(self, 1);
	end

	self:UpdateBgHeight();
end

function ItemTipComCell:UpdateDelTimeTip()
	local data = self.data;
	local deltaTime = data.deltime - ServerTime.CurServerTime()/1000;
	if(deltaTime < 0)then
		self:SetDelTimeTip(false);
	else
		if(data.bagtype == BagProxy.BagType.MainBag)then
			local leftTimeTip = "";
			local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.FormatTimeBySec( deltaTime )
			if(deltaTime > 86400)then
				leftTimeTip = string.format("%s%s%s%s", 
					leftDay, 
					ZhString.ItemTip_DelRefreshTip_Day,
					leftHour,
					ZhString.ItemTip_DelRefreshTip_Hour);
			elseif(deltaTime > 3600 and deltaTime <= 86400)then
				leftTimeTip = string.format("%s%s%s%s", 
					leftHour, 
					ZhString.ItemTip_DelRefreshTip_Hour,
					leftMin,
					ZhString.ItemTip_DelRefreshTip_Min);
			elseif(deltaTime > 60 and deltaTime <= 3600)then
				leftTimeTip = string.format("%s%s%s%s", 
					leftMin, 
					ZhString.ItemTip_DelRefreshTip_Min,
					leftSec,
					ZhString.ItemTip_DelRefreshTip_Sec);
			elseif(deltaTime <= 60)then
				leftTimeTip = string.format("%s%s", 
					leftSec, 
					ZhString.ItemTip_DelRefreshTip_Sec);
			end
			self.refreshTip.text = string.format(ZhString.ItemTip_DelRefreshTip, leftTimeTip);
		elseif(data.bagtype == BagProxy.BagType.Temp)then
			local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.FormatTimeBySec( deltaTime )
			
			local leftTimeStr = string.format("%02d:%02d:%02d", leftDay * 24 + leftHour, leftMin, leftSec);
			self.refreshTip.text = string.format(ZhString.TempPackageView_RefreshTip, leftTimeStr);
		end
	end
end

function ItemTipComCell:UpdateCountChooseBord(useMaxNumber)
	if(self.countChooseBord == nil)then
		return;
	end
	if(self.data == nil)then
		return;
	end
	if(self.hasStroeFunc == true)then
		self:ActiveCountChooseBord(true, useMaxNumber);
		return;
	end
	if(self.hasUseFunc == false)then
		self:ActiveCountChooseBord(false);
		return;
	end
	if(useMaxNumber == nil)then
		local typeData = Table_ItemType[ self.data.staticData.Type ];
		useMaxNumber = typeData and typeData.UseNumber;

		if(useMaxNumber == nil)then
			local useItemData = Table_UseItem[self.data.staticData.id];
			useMaxNumber = useItemData and useItemData.UseMultiple;
		end
	end
	if(useMaxNumber and useMaxNumber > 0)then
		self:ActiveCountChooseBord(true, useMaxNumber);

		self:UpdateCountChooseBordButton();
	else
		self:ActiveCountChooseBord(false);
	end
end

function ItemTipComCell:UpdateNoneItemTipCountChooseBord(useMaxNumber)
	if(useMaxNumber and useMaxNumber > 0)then
		self:ActiveCountChooseBord(true, useMaxNumber);

		self:UpdateCountChooseBordButton();
	else
		self:ActiveCountChooseBord(false);
	end
end

function ItemTipComCell:AddTipFunc(funcname, callback, callbackParam, noClose, inactive)
	local data = {
		name = funcname,
		itemData = self.data,
		noClose = noClose,

		callback = callback,
		callbackParam = callbackParam,
		inactive = inactive,
	};

	if(self.funcDatas == nil)then
		self.funcDatas = {};		
	end
	table.insert(self.funcDatas, data);
	self:UpdateTipButtons(self.funcDatas);
end

function ItemTipComCell:ShowSecendFunc(funcConfig, title, parent, widget, side, pixelOffset)
	if(self.itemSecendFuncBord == nil)then
		self.itemSecendFuncBord = ItemSecendFuncBord.new();
		side = side or NGUIUtil.AnchorSide.TopRight;
		pixelOffset = pixelOffset or {-11, 239}
		self.itemSecendFuncBord:OnCreate(parent, widget, side, pixelOffset);

		self.itemSecendFuncBord:AddEventListener(MouseEvent.MouseClick, self.ClickSecendFunc, self);
		self.itemSecendFuncBord:AddEventListener(ItemSecendFuncEvent.Close, self.CloseSecendBord, self);
	end

	self.itemSecendFuncBord:SetData(funcConfig, self.data);
	if(title)then
		self.itemSecendFuncBord:SetTitle(title);
	end
end

function ItemTipComCell:ClickSecendFunc(data)
	local tipfunc = FunctionItemFunc.Me():GetFunc(data.type)
	if(tipfunc)then
		if(tipfunc)then
			tipfunc(self.data, self.chooseCount);
		end
		if(data.type == "Combine")then
			local maxNum, hasLeft = FunctionItemFunc._GetCombineMaxNum(self.data.staticData.id);
			if(maxNum > 1 or hasLeft)then
				self:CloseSecendBord();
				return;
			end
		elseif(data.type == "CombineMultiple")then
			local maxNum, hasLeft = FunctionItemFunc._GetCombineMaxNum(self.data.staticData.id);
			if(hasLeft)then
				self:CloseSecendBord();
				return;
			end
		end
		self:PassEvent(ItemTipEvent.ClickTipFuncEvent);
	end
end

function ItemTipComCell:CloseSecendBord()
	if(self.itemSecendFuncBord)then
		self.itemSecendFuncBord:OnDestroy();
		self.itemSecendFuncBord = nil;
	end
end

function ItemTipComCell:Exit()
	ItemTipComCell.super.Exit(self);

	self:SetDelTimeTip(false);

	self:CloseSecendBord();
end