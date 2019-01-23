ServiceSceneFoodAutoProxy = class('ServiceSceneFoodAutoProxy', ServiceProxy)

ServiceSceneFoodAutoProxy.Instance = nil

ServiceSceneFoodAutoProxy.NAME = 'ServiceSceneFoodAutoProxy'

function ServiceSceneFoodAutoProxy:ctor(proxyName)
	if ServiceSceneFoodAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneFoodAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSceneFoodAutoProxy.Instance = self
	end
end

function ServiceSceneFoodAutoProxy:Init()
end

function ServiceSceneFoodAutoProxy:onRegister()
	self:Listen(29, 1, function (data)
		self:RecvCookStateNtf(data) 
	end)
	self:Listen(29, 2, function (data)
		self:RecvPrepareCook(data) 
	end)
	self:Listen(29, 3, function (data)
		self:RecvSelectCookType(data) 
	end)
	self:Listen(29, 4, function (data)
		self:RecvStartCook(data) 
	end)
	self:Listen(29, 5, function (data)
		self:RecvPutFood(data) 
	end)
	self:Listen(29, 6, function (data)
		self:RecvEditFoodPower(data) 
	end)
	self:Listen(29, 8, function (data)
		self:RecvQueryFoodNpcInfo(data) 
	end)
	self:Listen(29, 9, function (data)
		self:RecvStartEat(data) 
	end)
	self:Listen(29, 10, function (data)
		self:RecvStopEat(data) 
	end)
	self:Listen(29, 7, function (data)
		self:RecvEatProgressNtf(data) 
	end)
	self:Listen(29, 11, function (data)
		self:RecvFoodInfoNtf(data) 
	end)
	self:Listen(29, 16, function (data)
		self:RecvUpdateFoodInfo(data) 
	end)
	self:Listen(29, 12, function (data)
		self:RecvUnlockRecipeNtf(data) 
	end)
	self:Listen(29, 13, function (data)
		self:RecvQueryFoodManualData(data) 
	end)
	self:Listen(29, 14, function (data)
		self:RecvNewFoodDataNtf(data) 
	end)
	self:Listen(29, 15, function (data)
		self:RecvClickFoodManualData(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSceneFoodAutoProxy:CallCookStateNtf(state, charid) 
	local msg = SceneFood_pb.CookStateNtf()
	if(state ~= nil )then
		if(state.state ~= nil )then
			msg.state.state = state.state
		end
	end
	if(state ~= nil )then
		if(state.cooktype ~= nil )then
			msg.state.cooktype = state.cooktype
		end
	end
	if(state ~= nil )then
		if(state.progress ~= nil )then
			msg.state.progress = state.progress
		end
	end
	if(state ~= nil )then
		if(state.success ~= nil )then
			msg.state.success = state.success
		end
	end
	if(state ~= nil )then
		if(state.foodid ~= nil )then
			for i=1,#state.foodid do 
				table.insert(msg.state.foodid, state.foodid[i])
			end
		end
	end
	if(charid ~= nil )then
		msg.charid = charid
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallPrepareCook(start) 
	local msg = SceneFood_pb.PrepareCook()
	if(start ~= nil )then
		msg.start = start
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallSelectCookType(cooktype) 
	local msg = SceneFood_pb.SelectCookType()
	if(cooktype ~= nil )then
		msg.cooktype = cooktype
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallStartCook(cooktype, material, recipe, skipanimation, recipes) 
	local msg = SceneFood_pb.StartCook()
	if(cooktype ~= nil )then
		msg.cooktype = cooktype
	end
	if( material ~= nil )then
		for i=1,#material do 
			table.insert(msg.material, material[i])
		end
	end
	if(recipe ~= nil )then
		msg.recipe = recipe
	end
	if(skipanimation ~= nil )then
		msg.skipanimation = skipanimation
	end
	if( recipes ~= nil )then
		for i=1,#recipes do 
			table.insert(msg.recipes, recipes[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallPutFood(foodguid, power, foodnum, peteat) 
	local msg = SceneFood_pb.PutFood()
	if(foodguid ~= nil )then
		msg.foodguid = foodguid
	end
	if(power ~= nil )then
		msg.power = power
	end
	if(foodnum ~= nil )then
		msg.foodnum = foodnum
	end
	if(peteat ~= nil )then
		msg.peteat = peteat
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallEditFoodPower(npcguid, power) 
	local msg = SceneFood_pb.EditFoodPower()
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	if(power ~= nil )then
		msg.power = power
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallQueryFoodNpcInfo(npcguid, eating_people, itemid, ownerid, itemnum) 
	local msg = SceneFood_pb.QueryFoodNpcInfo()
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	if(eating_people ~= nil )then
		msg.eating_people = eating_people
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	if(ownerid ~= nil )then
		msg.ownerid = ownerid
	end
	if(itemnum ~= nil )then
		msg.itemnum = itemnum
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallStartEat(npcguid, pet, eatnum) 
	local msg = SceneFood_pb.StartEat()
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	if(pet ~= nil )then
		msg.pet = pet
	end
	if(eatnum ~= nil )then
		msg.eatnum = eatnum
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallStopEat(npcguid) 
	local msg = SceneFood_pb.StopEat()
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallEatProgressNtf(progress, npcguid) 
	local msg = SceneFood_pb.EatProgressNtf()
	if(progress ~= nil )then
		msg.progress = progress
	end
	if(npcguid ~= nil )then
		msg.npcguid = npcguid
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallFoodInfoNtf(recipeids, last_cooked_foods, eat_foods) 
	local msg = SceneFood_pb.FoodInfoNtf()
	if( recipeids ~= nil )then
		for i=1,#recipeids do 
			table.insert(msg.recipeids, recipeids[i])
		end
	end
	if( last_cooked_foods ~= nil )then
		for i=1,#last_cooked_foods do 
			table.insert(msg.last_cooked_foods, last_cooked_foods[i])
		end
	end
	if( eat_foods ~= nil )then
		for i=1,#eat_foods do 
			table.insert(msg.eat_foods, eat_foods[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallUpdateFoodInfo(last_cooked_foods, eat_foods, del_eat_foods) 
	local msg = SceneFood_pb.UpdateFoodInfo()
	if( last_cooked_foods ~= nil )then
		for i=1,#last_cooked_foods do 
			table.insert(msg.last_cooked_foods, last_cooked_foods[i])
		end
	end
	if( eat_foods ~= nil )then
		for i=1,#eat_foods do 
			table.insert(msg.eat_foods, eat_foods[i])
		end
	end
	if( del_eat_foods ~= nil )then
		for i=1,#del_eat_foods do 
			table.insert(msg.del_eat_foods, del_eat_foods[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallUnlockRecipeNtf(recipe) 
	local msg = SceneFood_pb.UnlockRecipeNtf()
	if(recipe ~= nil )then
		msg.recipe = recipe
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallQueryFoodManualData(cookerexp, cookerlv, tasterexp, tasterlv, items) 
	local msg = SceneFood_pb.QueryFoodManualData()
	if(cookerexp ~= nil )then
		msg.cookerexp = cookerexp
	end
	if(cookerlv ~= nil )then
		msg.cookerlv = cookerlv
	end
	if(tasterexp ~= nil )then
		msg.tasterexp = tasterexp
	end
	if(tasterlv ~= nil )then
		msg.tasterlv = tasterlv
	end
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallNewFoodDataNtf(items) 
	local msg = SceneFood_pb.NewFoodDataNtf()
	if( items ~= nil )then
		for i=1,#items do 
			table.insert(msg.items, items[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneFoodAutoProxy:CallClickFoodManualData(type, itemid) 
	local msg = SceneFood_pb.ClickFoodManualData()
	if(type ~= nil )then
		msg.type = type
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSceneFoodAutoProxy:RecvCookStateNtf(data) 
	self:Notify(ServiceEvent.SceneFoodCookStateNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvPrepareCook(data) 
	self:Notify(ServiceEvent.SceneFoodPrepareCook, data)
end

function ServiceSceneFoodAutoProxy:RecvSelectCookType(data) 
	self:Notify(ServiceEvent.SceneFoodSelectCookType, data)
end

function ServiceSceneFoodAutoProxy:RecvStartCook(data) 
	self:Notify(ServiceEvent.SceneFoodStartCook, data)
end

function ServiceSceneFoodAutoProxy:RecvPutFood(data) 
	self:Notify(ServiceEvent.SceneFoodPutFood, data)
end

function ServiceSceneFoodAutoProxy:RecvEditFoodPower(data) 
	self:Notify(ServiceEvent.SceneFoodEditFoodPower, data)
end

function ServiceSceneFoodAutoProxy:RecvQueryFoodNpcInfo(data) 
	self:Notify(ServiceEvent.SceneFoodQueryFoodNpcInfo, data)
end

function ServiceSceneFoodAutoProxy:RecvStartEat(data) 
	self:Notify(ServiceEvent.SceneFoodStartEat, data)
end

function ServiceSceneFoodAutoProxy:RecvStopEat(data) 
	self:Notify(ServiceEvent.SceneFoodStopEat, data)
end

function ServiceSceneFoodAutoProxy:RecvEatProgressNtf(data) 
	self:Notify(ServiceEvent.SceneFoodEatProgressNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvFoodInfoNtf(data) 
	self:Notify(ServiceEvent.SceneFoodFoodInfoNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvUpdateFoodInfo(data) 
	self:Notify(ServiceEvent.SceneFoodUpdateFoodInfo, data)
end

function ServiceSceneFoodAutoProxy:RecvUnlockRecipeNtf(data) 
	self:Notify(ServiceEvent.SceneFoodUnlockRecipeNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvQueryFoodManualData(data) 
	self:Notify(ServiceEvent.SceneFoodQueryFoodManualData, data)
end

function ServiceSceneFoodAutoProxy:RecvNewFoodDataNtf(data) 
	self:Notify(ServiceEvent.SceneFoodNewFoodDataNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvClickFoodManualData(data) 
	self:Notify(ServiceEvent.SceneFoodClickFoodManualData, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SceneFoodCookStateNtf = "ServiceEvent_SceneFoodCookStateNtf"
ServiceEvent.SceneFoodPrepareCook = "ServiceEvent_SceneFoodPrepareCook"
ServiceEvent.SceneFoodSelectCookType = "ServiceEvent_SceneFoodSelectCookType"
ServiceEvent.SceneFoodStartCook = "ServiceEvent_SceneFoodStartCook"
ServiceEvent.SceneFoodPutFood = "ServiceEvent_SceneFoodPutFood"
ServiceEvent.SceneFoodEditFoodPower = "ServiceEvent_SceneFoodEditFoodPower"
ServiceEvent.SceneFoodQueryFoodNpcInfo = "ServiceEvent_SceneFoodQueryFoodNpcInfo"
ServiceEvent.SceneFoodStartEat = "ServiceEvent_SceneFoodStartEat"
ServiceEvent.SceneFoodStopEat = "ServiceEvent_SceneFoodStopEat"
ServiceEvent.SceneFoodEatProgressNtf = "ServiceEvent_SceneFoodEatProgressNtf"
ServiceEvent.SceneFoodFoodInfoNtf = "ServiceEvent_SceneFoodFoodInfoNtf"
ServiceEvent.SceneFoodUpdateFoodInfo = "ServiceEvent_SceneFoodUpdateFoodInfo"
ServiceEvent.SceneFoodUnlockRecipeNtf = "ServiceEvent_SceneFoodUnlockRecipeNtf"
ServiceEvent.SceneFoodQueryFoodManualData = "ServiceEvent_SceneFoodQueryFoodManualData"
ServiceEvent.SceneFoodNewFoodDataNtf = "ServiceEvent_SceneFoodNewFoodDataNtf"
ServiceEvent.SceneFoodClickFoodManualData = "ServiceEvent_SceneFoodClickFoodManualData"
