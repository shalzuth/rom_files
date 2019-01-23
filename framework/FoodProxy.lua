FoodProxy = class('FoodProxy', pm.Proxy)

FoodProxy.Instance = nil;

FoodProxy.NAME = "FoodProxy"

autoImport("RecipeData");

FoodProxy.FailFood_ItemID = 551019;

function FoodProxy:ctor(proxyName, data)
	self.proxyName = proxyName or FoodProxy.NAME
	if(FoodProxy.Instance == nil) then
		FoodProxy.Instance = self
	end
	
	if data ~= nil then
		self:setData(data)
	end

	self:Init();
end

function FoodProxy:Init()
	self:InitRecipe();
	self.last_cooked_foods = {};
	self.eating_foods = {};

	self.material_exp_info = {};
	self.food_cook_info = {};
	self.food_eat_info = {};
	self:InitManualFoodInfo();
	self.max_recent_cook = GameConfig.Food.MaxLastCooked
	self.foodGetCount = 0;
end

function FoodProxy:InitManualFoodInfo( ... )
	-- body
	for id,v in pairs(Table_Food)do
		self.food_cook_info[id] = {itemid = id,status = SceneFood_pb.EFOODSTATUS_MIN,exp = 0,itemData = ItemData.new(nil,id),level = 0}
	end

	for id,v in pairs(Table_Food)do
		self.food_eat_info[id] = {itemid = id,status = SceneFood_pb.EFOODSTATUS_MIN,exp = 0,level = 0}
	end
end

function FoodProxy:InitRecipe()
	self.recipe_id_map = {};
	self.recipe_type_map = {};

	self.unlock_recipe_map = {};

	for id,recipeData in pairs(Table_Recipe)do
		local recipeData = RecipeData.new(id);
		self.recipe_id_map[id] = recipeData;

		local rType = recipeData.staticData.Type or 1;
		if(nil == self.recipe_type_map[rType])then
			self.recipe_type_map[rType] = {};
		end
		table.insert(self.recipe_type_map[rType], self.recipe_id_map[id]);
	end

	for _, typeRecipeDatas in pairs(self.recipe_type_map)do
		table.sort(typeRecipeDatas, self._RecipeDataSortFunc);
	end
end


function FoodProxy._RecipeDataSortFunc(a,b)
	if(a.staticData.id == 129 or b.staticData.id == 129)then
		return a.staticData.id == 129;
	end
	return a.staticData.id < b.staticData.id;
end

function FoodProxy:ResetUnLockInfo()
	for id, recipeData in pairs(self.recipe_id_map)do
		recipeData:SetUnLock(false);
	end
end

function FoodProxy:UnLockRecipe(recipeid, playAnim)
	if(recipeid)then
		local data = self.recipe_id_map[recipeid];
		if(data)then
			data:SetUnLock(true);
		end
		if(playAnim)then
			FunctionFood.Me():UnLockRecipe(recipeid)
		end
	end
end

function FoodProxy:Server_SetFoodLevelInfo(server_FoodInfo)
	self:ResetUnLockInfo();
	
	TableUtility.ArrayClear(self.last_cooked_foods)
	local last_cooked_foods = server_FoodInfo.last_cooked_foods;
	-- helplog("Server_SetFoodLevelInfo size:",#last_cooked_foods)
	local foodItemId;
	for i=1,#last_cooked_foods do
		foodItemId = last_cooked_foods[i];
		-- helplog("Server_SetFoodLevelInfo:",foodItemId)
		if(#self.last_cooked_foods >= self.max_recent_cook)then
			table.remove(self.last_cooked_foods,1)			
		end
		self.last_cooked_foods[ #self.last_cooked_foods +1] = foodItemId;
	end

	TableUtility.ArrayClear(self.eating_foods);
	local foodItemInfo;
	local eat_foods = server_FoodInfo.eat_foods;
	for i=1,#eat_foods do
		foodItemInfo = eat_foods[i];
		if(foodItemInfo.itemid)then
			self.eating_foods[#self.eating_foods +1 ] = {itemid = foodItemInfo.itemid, level = foodItemInfo.level, invalidTime = foodItemInfo.invalid_time};
		end
	end
	local recipeids = server_FoodInfo.recipeids;
	for i=1,#recipeids do
		self:UnLockRecipe(recipeids[i]);
	end

end

function FoodProxy:GetRecipesByType(rtype)
	return self.recipe_type_map[rtype]
end

function FoodProxy:GetRecipeByRecipeId(recipeid)
	return self.recipe_id_map[recipeid];
end

function FoodProxy:Server_QueryFoodManualData(data, playAnim)
	self:Server_SetFoodManualDatas(data.items, playAnim)
	self.cookerexp = data.cookerexp;       
	self.cookerlv = data.cookerlv;         
	self.tasterexp = data.tasterexp;       
	self.tasterlv = data.tasterlv;  
end

function FoodProxy:Server_SetFoodManualDatas(server_items, playAnim)
	local upFunc;
	for i=1,#server_items do
		self:Server_SetFoodManualData(server_items[i], playAnim);
	end
end

function FoodProxy:Server_SetFoodManualData(server_item, playAnim)
	if(server_item.type == nil)then
		return;
	end
	
	local cacheMap, handleLvUpFunc;
	if(server_item.type == SceneFood_pb.EFOODDATATYPE_MATERIAL)then
		cacheMap = self.material_exp_info
		handleLvUpFunc = FunctionFood.Material_LvUp
	elseif(server_item.type == SceneFood_pb.EFOODDATATYPE_FOODCOOK)then
		cacheMap = self.food_cook_info
		handleLvUpFunc = FunctionFood.FoodCook_LvUp
	elseif(server_item.type == SceneFood_pb.EFOODDATATYPE_FOODTASTE)then
		cacheMap = self.food_eat_info
		handleLvUpFunc = FunctionFood.FoodEat_LvUp
	end
	if(cacheMap ~= nil)then
		for i=1,#server_item.datas do
			local data = server_item.datas[i]
			self:_UpdateFoodManualInfo(cacheMap, data.itemid, data, handleLvUpFunc, playAnim);
		end
	else
		error(server_item.type .. " not find when SetFoodManualData");
	end
	
end

function FoodProxy:_UpdateFoodManualInfo(cacheMap, sitemid, up_info, handleLvUpFunc, playAnim)
	local info = cacheMap[ sitemid ];
	if(info == nil)then
		info = { itemid = sitemid };
		cacheMap[ sitemid ] = info;
	end
	info.status = up_info.status;
	info.exp = up_info.exp;

	if(info.level and info.level == up_info.level - 1)then
		handleLvUpFunc(sitemid, up_info.level, playAnim);
	end
	info.itemData = ItemData.new(nil,sitemid)
	info.level = up_info.level;
end

-- Info (status, itemid, exp, level)
function FoodProxy:Get_MaterialExpInfo(itemid)
	return self.material_exp_info[itemid];
end

function FoodProxy:Get_FoodCookExpInfo(itemid)
	return self.food_cook_info[itemid];
end

function FoodProxy:Get_FoodEatExpInfo(itemid)
	return self.food_eat_info[itemid];
end

-- 更新最近的料理
function FoodProxy:Server_UpdateFoodInfo(data)
	local last_cooked_foods = data.last_cooked_foods
	-- helplog("Server_UpdateFoodInfo size:",#last_cooked_foods)

	for i=1,#last_cooked_foods do
		foodItemId = last_cooked_foods[i];
		if(#self.last_cooked_foods >= self.max_recent_cook)then
			table.remove(self.last_cooked_foods,1)			
		end
		self.last_cooked_foods[ #self.last_cooked_foods +1] = foodItemId;
	end

	local eat_foods = data.eat_foods
	local foodItemInfo
	for i=1,#eat_foods do
		foodItemInfo = eat_foods[i];
		if(foodItemInfo.itemid)then
			self.eating_foods[#self.eating_foods +1 ] = {itemid = foodItemInfo.itemid, invalidTime = foodItemInfo.invalid_time};
		end
	end

	local del_eat_foods = data.del_eat_foods
	for i=1,#del_eat_foods do
		self:remove_eat_food(del_eat_foods[i])
	end
end

function FoodProxy:remove_eat_food( id )
	-- body
	local foodInfo
	for i=1,#self.eating_foods do
		foodInfo = self.eating_foods[i]
		if(foodInfo.itemid == id)then
			table.remove(self.eating_foods,i)
			break
		end
	end
end

function FoodProxy:GetMyFoodBuffProps()
	local items = self.eating_foods
	local list = {}
	local bufferMap = {}
	local buffInvalidTimeMap = {}
	for i=1,#items do
		local itemData = ItemData.new(nil,items[i].itemid)
		if(itemData)then
			list[#list+1] = itemData
			local BuffEffectData = Table_Food[items[i].itemid].BuffEffect
			for j=1,#BuffEffectData do
				local count = bufferMap[BuffEffectData[j]] or 0
				count = count +1
				bufferMap[BuffEffectData[j]] = count

				-- 设置buff时间
				local oldInvalidTime = buffInvalidTimeMap[BuffEffectData[j]] or 0
				local newInvalidTime = items[i].invalidTime

				if oldInvalidTime < newInvalidTime then
					buffInvalidTimeMap[BuffEffectData[j]] = newInvalidTime
				end
			end			
		end
	end

	local props = RolePropsContainer.CreateAsTable()

	for _, o in pairs(props.configs) do
		props:SetValueById(o.id,0)
	end
	local propValue = {}
	local bufferList = {}
	local bufferInvalidTimeList = {}
	for k,v in pairs(bufferMap) do
		local buffData = Table_Buffer[k]
		local newInvalidBuffTime = buffInvalidTimeMap[k]
		local effect = buffData["BuffEffect"]
		if(effect.type == "AttrChange")then
			for j,w in pairs(effect) do
				local prop = props[j]
				local oldPropInvalidTime = bufferInvalidTimeList[j]
				if(j ~= "type" and prop)then
					local oldValue = props:GetValueByName(j)
					local deltaValue = w*v
					if(prop.propVO.isPercent)then
						deltaValue = deltaValue*1000
						oldValue = oldValue*1000
					end
					local vl = deltaValue + oldValue
					props:SetValueByName(j,vl)
					local exsit = propValue[j]
					if(not exsit)then
						bufferList[#bufferList +1] = prop
						propValue[j] = prop
					end

					if not oldPropInvalidTime then
						bufferInvalidTimeList[j] = newInvalidBuffTime
					elseif oldPropInvalidTime > newInvalidBuffTime then
						bufferInvalidTimeList[j] = newInvalidBuffTime
					end
				end
			end
		end
	end

	props:Destroy();

	-- helplog("<<<========GetMyFoodBuffProps=========>>>")
	-- TableUtil.Print(bufferList)
	-- TableUtil.Print(bufferInvalidTimeList)
	
	return bufferList, bufferInvalidTimeList;
end

function FoodProxy:GetEatFoods()
	return self.eating_foods
end