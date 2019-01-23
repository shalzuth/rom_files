autoImport('ServiceSceneFoodAutoProxy')
ServiceSceneFoodProxy = class('ServiceSceneFoodProxy', ServiceSceneFoodAutoProxy)
ServiceSceneFoodProxy.Instance = nil
ServiceSceneFoodProxy.NAME = 'ServiceSceneFoodProxy'

function ServiceSceneFoodProxy:ctor(proxyName)
	if ServiceSceneFoodProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneFoodProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSceneFoodProxy.Instance = self
	end
end

function ServiceSceneFoodProxy:RecvCookStateNtf(data) 
	-- helplog("Recv-->CookStateNtf", data.charid, data.state);
	if(data.state)then
		FunctionFood.Me():UpdateMakeState(data.charid, data.state)
	end
	self:Notify(ServiceEvent.SceneFoodCookStateNtf, data)
end

function ServiceSceneFoodProxy:RecvFoodInfoNtf(data) 
	FoodProxy.Instance:Server_SetFoodLevelInfo(data)
	self:Notify(ServiceEvent.SceneFoodFoodInfoNtf, data)
end

function ServiceSceneFoodProxy:RecvUnlockRecipeNtf(data) 
	-- helplog("Recv-->UnlockRecipeNtf", data.recipe);
	FoodProxy.Instance:UnLockRecipe(data.recipe, true);
	self:Notify(ServiceEvent.SceneFoodUnlockRecipeNtf, data)
end

function ServiceSceneFoodProxy:CallSelectCookType(cooktype) 
	-- helplog("Call-->SelectCookType", cooktype);
	ServiceSceneFoodProxy.super.CallSelectCookType(self, cooktype);
end

function ServiceSceneFoodProxy:CallStartCook(cooktype, m_guids, skipanimation, recipes) 
	local BagData = BagProxy.Instance.foodBagData;
	local briefMaterials = {};
	for i=1,#m_guids do
		local briefItemInfo = SceneFood_pb.BriefItemInfo()
		briefItemInfo.guid = m_guids[i].guid;

		local item = BagData:GetItemByGuid(m_guids[i].guid);
		local itemId = item.staticData.id
		briefItemInfo.itemid = itemId;

		briefItemInfo.num = m_guids[i].num;
		table.insert(briefMaterials, briefItemInfo)
	end

	local recipeIds = {};
	for i=1,#recipes do
		recipeIds[#recipeIds + 1] = recipes[i].recipeId
	end
	-- helplog("Call-->StartCook", cooktype, recipe, #briefMaterials, skipanimation);
	ServiceSceneFoodProxy.super.CallStartCook(self, cooktype, briefMaterials, nil, skipanimation, recipeIds);
end

function ServiceSceneFoodProxy:CallPutFood(foodguid, power, foodnum, peteat) 
	-- helplog("Call-->PutFood", foodguid, power);
	ServiceSceneFoodProxy.super.CallPutFood(self, foodguid, power, foodnum, peteat);
end

function ServiceSceneFoodProxy:CallStartEat(npcguid, petEat, eatnum) 
	helplog("Call-->StartEat", npcguid, tostring(petEat), eatnum);
	ServiceSceneFoodProxy.super.CallStartEat(self, npcguid, petEat, eatnum);
end

function ServiceSceneFoodProxy:CallEditFoodPower(npcguid, power) 
	-- helplog("Call-->EditFoodPower", npcguid, power);
	ServiceSceneFoodProxy.super.CallEditFoodPower(self, npcguid, power);
end

function ServiceSceneFoodProxy:CallQueryFoodNpcInfo(npcguid) 
	-- helplog("Call-->QueryFoodNpcInfo", npcguid);
	local msg = SceneFood_pb.QueryFoodNpcInfo()
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	self:SendProto(msg)
end

function ServiceSceneFoodProxy:RecvQueryFoodManualData(data) 
	-- helplog("Recv-->QueryFoodManualData");
	FoodProxy.Instance:Server_QueryFoodManualData(data, false)
	AdventureDataProxy.Instance:checkFoodRedTips()
	self:Notify(ServiceEvent.SceneFoodQueryFoodManualData, data)
end

function ServiceSceneFoodProxy:RecvNewFoodDataNtf(data) 
	-- helplog("Recv-->NewFoodDataNtf");
	-- items
	FoodProxy.Instance:Server_QueryFoodManualData(data, true)
	AdventureDataProxy.Instance:checkFoodRedTips()
	self:Notify(ServiceEvent.SceneFoodNewFoodDataNtf, data)
end

function ServiceSceneFoodProxy:RecvUpdateFoodInfo(data) 
	FoodProxy.Instance:Server_UpdateFoodInfo(data)	
	self:Notify(ServiceEvent.SceneFoodUpdateFoodInfo, data)
end
