FoodGetPopUp = class("FoodGetPopUp", BaseView);

FoodGetPopUp.ViewType = UIViewType.Show3D2DLayer

function FoodGetPopUp:Init()
	self:InitView();
	self:MapEvent();
	self:InitData();
end

function FoodGetPopUp:InitView()
	self.shareLab = self:FindComponent("ShareLabel", UILabel);
	self.nameLab = self:FindComponent("NameLabel", UILabel);
	self.countLab = self:FindComponent("CountLabel", UILabel);
	self.typeLab = self:FindComponent("TypeLabel", UILabel);
	self.effectLab = self:FindComponent("EffectLabel", UILabel);
	self.modelContainer = self:FindComponent("ModelContainer", ChangeRqByTex);
	self.effectContainer = self:FindGO("EffectContainer");

self.confirmButton = self:FindGO("ConfirmButton");
	self:AddClickEvent(self.confirmButton, function ()
		self:OnEnter();
	end);

	self.shareButton = self:FindGO("ShareButton");
	self:AddClickEvent(self.shareButton, function ()
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.GeneralShareView})
	end);
	
	-- local enable = FloatAwardView.ShareFunctionIsOpen();
	self.shareButton:SetActive(false);

	self.foodStars = {};
	self.foodStars[0] = self:FindGO("FoodStars");
	if(self.foodStars[0])then
		for i=1,5 do
			self.foodStars[i] = self:FindComponent(tostring(i), UISprite, self.foodStars[0]);
		end
	end
end

function FoodGetPopUp:InitData()
	local items = self.viewdata.viewdata.items;
	-- for k,v in pairs(items) do
	-- 	local sidX = v.staticData.id;
	-- 	local food_SdataX = sidX and Table_Food[sidX];
	-- 	helplog("===FoodGetPopUp:InitData>>>>>", food_SdataX.Name, food_SdataX.CookHard)
	-- end

	table.sort(items, function(x,y)
		local sidX = x.staticData.id;
		local food_SdataX = sidX and Table_Food[sidX];
		local CookHardX = food_SdataX.CookHard
		if sidX == 551019 then
			CookHardX = 0
		end

		local sidY = y.staticData.id;
		local food_SdataY = sidY and Table_Food[sidY];
		local CookHardY = food_SdataY.CookHard
		if sidY == 551019 then
			CookHardY = 0
		end
		return CookHardX < CookHardY
	end)

	-- for k,v in pairs(items) do
	-- 	local sidX = v.staticData.id;
	-- 	local food_SdataX = sidX and Table_Food[sidX];
	-- 	helplog("===FoodGetPopUp:InitData2>>>>>", food_SdataX.Name, food_SdataX.CookHard)
	-- end
end

local tempV3 = LuaVector3();
function FoodGetPopUp:UpdateFoodInfo()
	local sid = self.foodItem.staticData.id;
	local food_Sdata = sid and Table_Food[sid];
	if(sid)then
		local food_Sdata = self.foodItem:GetFoodSData();

		local npcid = food_Sdata.NpcId;
		if(npcid)then
			self:DestroyModel();

			local bodyid = Table_Npc[npcid] and Table_Npc[npcid].Body;
			self.model = Asset_RolePart.Create( Asset_Role.PartIndex.Body, bodyid, self.ModelCreateCall, self)
			self.model:ResetParent(self.modelContainer.transform);
			self.model:ResetLocalPositionXYZ(0,0,0);

			local scale = Table_Npc[ npcid ] and Table_Npc[ npcid ].Scale or 1;
			-- scale = scale * 230;
			self.model:ResetLocalScaleXYZ(scale, scale, scale);
			self.model:ResetLocalEulerAnglesXYZ(0,0,0);
			self.model:SetLayer(RO.Config.Layer.UI.Value);

			self.model:RegisterWeakObserver(self);
		end

		-- 营养价值
		local desc = ""
		local effectDesc = self.foodItem:GetFoodEffectDesc();
		if(effectDesc)then
			desc = ZhString.FoodGetPopUp_EffectTip .. effectDesc;
		end
		desc = desc .. "\n\n"

		local cacheSHP_desc = "";
		local hpStr, spStr;
		if(food_Sdata.SaveHP)then
			hpStr = string.format(ZhString.FoodGetPopUp_SavePower_Desc, "Hp", food_Sdata.SaveHP);
		end
		if(food_Sdata.SaveSP)then
			spStr = string.format(ZhString.FoodGetPopUp_SavePower_Desc, "Sp", food_Sdata.SaveSP);
		end
		if(hpStr and spStr)then
			cacheSHP_desc = hpStr .. ZhString.FoodGetPopUp_SavePower_And .. spStr;
		else
			cacheSHP_desc = hpStr and hpStr or spStr;
		end
		if(cacheSHP_desc ~= nil)then
			desc = desc .. ZhString.FoodGetPopUp_SaveHSpTip .. cacheSHP_desc;
			desc = desc .. "\n"
		end
		desc = desc .. "\n"
		self.effectLab.text = desc;

		self.nameLab.text = self.foodItem:GetName();
		if self.foodItem.num > 1 then
			self.countLab.text = "X " .. self.foodItem.num
		else
			self.countLab.text = ""
		end
		if(Game.Myself)then
			local makername = Game.Myself.data.name;
			self.shareLab.text = string.format(ZhString.FoodGetPopUp_MakeTip, makername);
		end

		local foodType = FunctionFood.Me():GetLastPotType() or 1;
		self.typeLab.text = ZhString["FoodGetPopUp_FoodType" .. foodType];

		local cookHard = food_Sdata.CookHard
		if(cookHard and cookHard > 0)then
			self.foodStars[0]:SetActive(true);
			local num = math.floor(cookHard/2)
			for i=1,5 do
				if(i<=num)then
					self.foodStars[i].gameObject:SetActive(true);
					self.foodStars[i].spriteName = "food_icon_08";
				elseif(i==num+1 and cookHard%2==1)then
					self.foodStars[i].gameObject:SetActive(true);
					self.foodStars[i].spriteName = "food_icon_09";
				else
					self.foodStars[i].gameObject:SetActive(false);
				end
			end
		else
			self.foodStars[0]:SetActive(false);
		end

		local recipeData = FunctionFood.Me():GetRecipeByFoodId(sid);
		self.effectContainer:SetActive(recipeData ~= nil and recipeData.Type ~= 4);
	end
end

function FoodGetPopUp.ModelCreateCall(rolePart, self)
	if(rolePart)then
		local nameHash = ActionUtility.GetNameHash("state1002")
		rolePart:PlayAction(nameHash, nameHash, 1, 0);
	end
end

function FoodGetPopUp:ObserverDestroyed(model)
	if(model~=nil and model == self.model)then
		model:ResetLocalScaleXYZ(1, 1, 1);
		model:ResetParent(nil);
		-- model:SetLayer(RO.Config.Layer.DEFAULT.Value);
	end
end

function FoodGetPopUp:MapEvent()
end

function FoodGetPopUp:OnEnter()
	FoodGetPopUp.super.OnEnter(self);

	local viewdata = self.viewdata.viewdata;
	local items = viewdata and viewdata.items;
	local foodTotalCount = FoodProxy.Instance.foodGetCount
	-- helplog("==FoodGetPopUp.foodTotalCount==>>", foodTotalCount)
	-- 以后扩展
	if foodTotalCount >= 1 then
		self.foodItem = items and items[foodTotalCount];
		FoodProxy.Instance.foodGetCount = foodTotalCount -1
		self:UpdateFoodInfo();
		self:sendNotification(FoodEvent.FoodGetPopUp_Enter)
	else
		self:CloseSelf()
	end
end

function FoodGetPopUp:DestroyModel()
	if(self.model)then
		self.model:Destroy();
		self.model = nil;
	end
end

function FoodGetPopUp:OnExit()
	self:DestroyModel();

	self:sendNotification(FoodEvent.FoodGetPopUp_Exit)
	FoodGetPopUp.super.OnExit(self);
end