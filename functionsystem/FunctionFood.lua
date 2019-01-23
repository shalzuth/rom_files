FunctionFood = class("FunctionFood")

local PotEffect_Path = 
{
	[SceneFood_pb.ECOOKTYPE_JIANCHAO] = "Common/RoyalWorkTop",
	[SceneFood_pb.ECOOKTYPE_BARBECUE] = "Common/AdventureBarbecue",
	[SceneFood_pb.ECOOKTYPE_SOUP] = "Common/MagicStockpot",
	[SceneFood_pb.ECOOKTYPE_DESSERT] = "Common/RomanticTrain",
};
local PotEffect_Action = 
{
	Prepareing = "show",
	Cooking = "cook",
	Compelete_Success = "get",
	Compelete_Fail = "fail",
}
local Role_Perform = 
{
	SoundPath_Compelete_TopEP_Success = "Common/cook_get",  --"Common/24ForgingSuccess",
	SoundPath_Compelete_TopEP_Fail = "Common/cook_fail",  --"Common/25ForgingFailure",

	ActionName_Prepareing = "cook_ready",
	ActionName_Cooking = "cook_ing",
	ActionName_Compelete_Success = "cook_get",
	ActionName_Compelete_Fail = "cook_fail",
}

function FunctionFood.Me()
	if nil == FunctionFood.me then
		FunctionFood.me = FunctionFood.new()
	end
	return FunctionFood.me
end

function FunctionFood:ctor()
	self.potEffectMap = {};

	if(Table_Recipe)then
		self.recipe_Type_Map = {};
		self.recipe_totalCount_Map = {};

		local materials_totalCount;
		for id, recipeData in pairs(Table_Recipe)do
			local rtype = recipeData.Type;
			if(nil == self.recipe_Type_Map[rtype])then
				self.recipe_Type_Map[rtype] = {};
			end

			materials_totalCount = 0;
			for i=1,#recipeData.Material do
				materials_totalCount = materials_totalCount + recipeData.Material[i][3];
			end
			self.recipe_totalCount_Map[id] = materials_totalCount;

			table.insert(self.recipe_Type_Map[rtype], recipeData);
		end
		for _,recipeDatas in pairs(self.recipe_Type_Map)do
			table.sort(recipeDatas, FunctionFood.SortRecipes);
		end
	end

	EventManager.Me():AddEventListener(SkillEvent.SkillCastBegin,self.HandleStartSkill,self)
	EventManager.Me():AddEventListener(SkillEvent.SkillCastEnd,self.HandleStopSkill,self)
end

local rot_V3 = LuaVector3();
function FunctionFood:HandleStartSkill(evt)
	local creature = evt.data;
	if(creature == Game.Myself)then
		local skill = creature.skill;
		local skillId = skill and skill:GetSkillID();
		if(skillId and Table_Skill[skillId] and Table_Skill[skillId].SkillType == "Eat")then
			local myTrans = Game.Myself.assetRole.completeTransform
			local viewPort = CameraConfig.FoodEat_ViewPort
			rot_V3:Set(CameraConfig.FoodEat_Rotation_OffsetX, CameraConfig.FoodEat_Rotation_OffsetY, 0);

			self.cft = CameraEffectFocusAndRotateTo.new(myTrans, nil, viewPort, rot_V3, CameraConfig.UI_Duration);
			FunctionCameraEffect.Me():Start(self.cft);
		end
	end
end

function FunctionFood:HandleStopSkill(evt)
	local creature = evt.data;
	if(creature == Game.Myself)then
		local skill = creature.skill;
		local skillId = skill and skill:GetSkillID();
		if(skillId and Table_Skill[skillId] and Table_Skill[skillId].SkillType == "Eat")then
			if(self.cft)then
				FunctionCameraEffect.Me():End(self.cft);
				self.cft = nil;
			end
		end
	end
end

function FunctionFood.SortRecipes(a,b)
	return a.id < b.id;
end

function FunctionFood:DoMakeFood(potType, material_guids, skipAnim, recipeMap)
	self.lastPotType = potType;

	-- local guidStr = ""
	-- for i=1,#material_guids do
	-- 	guidStr = guidStr .. material_guids[i];
	-- 	if i<#material_guids then
	-- 		guidStr = guidStr .. ","
	-- 	end
	-- end
	-- helplog(string.format("DoMakeFood: PotType:%s | RecipeID:%s | material_guids = {%s} | material_itemids = {%s} | skilAnim = %s", 
	-- 	potType, recipeId, guidStr, itemidStr, skipAnim));

	ServiceSceneFoodProxy.Instance:CallStartCook(potType, material_guids, skipAnim, recipeMap);
end

function FunctionFood:GetLastPotType()
	return self.lastPotType;
end

function FunctionFood:UpdateMakeState(playerid,  server_CookStateMsg)
	local potEffectInfo = self.potEffectMap[ playerid ];

	local state = server_CookStateMsg.state;
	local scenePlayer = NSceneUserProxy.Instance:Find(playerid);
	local isMine = false;
	
	if(playerid == Game.Myself.data.id)then
		isMine = true;
		GameFacade.Instance:sendNotification(FoodEvent.MakeStateChange, server_CookStateMsg);
	else
		scenePlayer = NSceneUserProxy.Instance:Find(playerid);
	end

	if(scenePlayer == nil)then
		if(potEffectInfo ~= nil and potEffectInfo[1] ~= nil)then
			potEffectInfo[1]:Destroy();
		end
		return;
	end

	local cooktype = server_CookStateMsg.cooktype;
	if(state == SceneFood_pb.ECOOKSTATE_NONE)then
		if(potEffectInfo~=nil and potEffectInfo[1]~=nil)then
			potEffectInfo[1]:Destroy();
		end
		if(isMine)then
			GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer);
		end

		return;
	elseif(state == SceneFood_pb.ECOOKSTATE_PREPAREING)then
		if(cooktype == nil or cooktype ==0)then
			if(potEffectInfo~=nil and potEffectInfo[1]~=nil)then
				potEffectInfo[1]:Destroy();
			end
			return;
		end
	end

	if(cooktype)then
		if(potEffectInfo == nil)then
			potEffectInfo = {};
			self:PlayPotEffect(scenePlayer, cooktype, potEffectInfo);

			self.potEffectMap[playerid] = potEffectInfo;
		elseif(potEffectInfo[2] ~= cooktype)then
			potEffectInfo[1]:Destroy();
			potEffectInfo[3] = false

			self:PlayPotEffect(scenePlayer, cooktype, potEffectInfo);
			self.potEffectMap[playerid] = potEffectInfo;
		end
	end

	if(potEffectInfo == nil)then
		return;
	end

	local progress = server_CookStateMsg.progress;
	local success = server_CookStateMsg.success;

	if(state == SceneFood_pb.ECOOKSTATE_PREPAREING)then
		potEffectInfo[1]:ResetAction(PotEffect_Action.Prepareing, 0);

		if(potEffectInfo[3])then
			scenePlayer:Client_PlayAction(Role_Perform.ActionName_Prepareing, nil, false);
		else
			potEffectInfo[4] = Role_Perform.ActionName_Prepareing;
		end

		if(potEffectInfo[6])then
			potEffectInfo[6]:Destroy();
			potEffectInfo[6] = nil;
		end

	elseif(state == SceneFood_pb.ECOOKSTATE_COOKING)then
		potEffectInfo[1]:ResetAction(PotEffect_Action.Cooking, 0);

		scenePlayer:Client_PlayAction(Role_Perform.ActionName_Cooking, nil, false);

		if(potEffectInfo[6])then
			potEffectInfo[6]:Destroy();
			potEffectInfo[6] = nil;
		end
		
	elseif(state == SceneFood_pb.ECOOKSTATE_COMPLETE)then
		local actionName,soundName,parentname;
		if(success)then
			parentname = "liaoli_get";
			potEffectInfo[1]:ResetAction(PotEffect_Action.Compelete_Success, 0);
			actionName = Role_Perform.ActionName_Compelete_Success;
			soundName = Role_Perform.SoundPath_Compelete_TopEP_Success;
		else
			parentname = "liaoli_fail";
			potEffectInfo[1]:ResetAction(PotEffect_Action.Compelete_Fail, 0);
			actionName = Role_Perform.ActionName_Compelete_Fail;
			soundName = Role_Perform.SoundPath_Compelete_TopEP_Fail;
		end
		
		if(isMine)then
			AudioUtility.PlayOneShot2D_Path( ResourcePathHelper.AudioSE(soundName) );
		end
		if(actionName)then
			-- TableUtil.Print(server_CookStateMsg.foodid)
			if #server_CookStateMsg.foodid > 1 then
				local foodid = server_CookStateMsg.foodid[1];
				-- helplog("===UpdateMakeState===foodid>>>", foodid)
				local npcid = Table_Food[foodid].NpcId;

				self:DelayRolePlayAction(2, playerid, actionName, function ()
					if(potEffectInfo[6])then
						potEffectInfo[6]:Destroy();
						potEffectInfo[6] = nil;
					end

					if(potEffectInfo[1] == nil)then
						return;
					end

					local effectHandle = potEffectInfo[1]:GetEffectHandle();
					if(effectHandle)then
						local npcdata = Table_Npc[npcid];
						if(npcdata == nil)then
							return;
						end
						local parent = GameObjectUtil.Instance:DeepFind(effectHandle.gameObject, parentname);
						if(parent == nil)then
							return;
						end
						potEffectInfo[6] = Asset_RolePart.Create( Asset_Role.PartIndex.Body, npcdata.Body, self.ModelCreateCall, self)
						potEffectInfo[6]:SetLayer(parent.gameObject.layer);
						potEffectInfo[6]:ResetParent(parent.transform);
						potEffectInfo[6]:ResetLocalPositionXYZ(0,0,0);

						local scale = npcdata.Scale or 1;
						potEffectInfo[6]:ResetLocalScaleXYZ(scale*0.5, scale*0.5, scale*0.5);
						potEffectInfo[6]:ResetLocalEulerAnglesXYZ(0,0,0);

						potEffectInfo[6]:RegisterWeakObserver(self);
					end
				end);
			end
		end
	end
end

function FunctionFood.ModelCreateCall(rolePart, self)
	if(rolePart)then
		local nameHash = ActionUtility.GetNameHash("state1002")
		rolePart:PlayAction(nameHash, nameHash, 1, 0);
	end
end

function FunctionFood:DelayRolePlayAction(delaytime, playerid, actionName, callback, calbackParam)
	if(self.lt)then
		self.lt:cancel();
		self.lt = nil;
	end
	self.lt = LeanTween.delayedCall(delaytime, FunctionFood._RolePlayAction);
	self.lt.onCompleteParam = {self, playerid, actionName, callback, calbackParam};
end
function FunctionFood._RolePlayAction(onCompleteParam)
	local self, playerid, actionName, callback, calbackParam = onCompleteParam[1], onCompleteParam[2], onCompleteParam[3], onCompleteParam[4], onCompleteParam[5];
	local scenePlayer = NSceneUserProxy.Instance:Find(playerid);
	if(scenePlayer)then
		scenePlayer:Client_PlayAction(actionName, nil, false);
	end
	if(callback)then
		callback(calbackParam);
	end

	if(self.lt)then
		self.lt = nil;
	end
end

function FunctionFood:PlayPotEffect( scenePlayer, potType, effectInfo )
	-- 播放特效
	local path = PotEffect_Path[potType];
	if(path)then
		effectInfo[1] = scenePlayer.assetRole:PlayEffectOn( 
			path, 
			0,
			nil,
			FunctionFood._RealPlayPotEffect, 
			{scenePlayer, effectInfo});
		effectInfo[1]:ResetLocalPositionXYZ(0,0,1);

		effectInfo[1]:RegisterWeakObserver(self);
		effectInfo[2] = potType;
	end
end

function FunctionFood._RealPlayPotEffect(effectHandle, param)
	local scenePlayer, effectInfo = param[1], param[2];
	if(scenePlayer and effectInfo)then
		effectInfo[3] = true;

		if(effectInfo[4])then
			scenePlayer:Client_PlayAction(effectInfo[4], nil, false);
			effectInfo[4] = nil;
		end
		if(effectInfo[5])then
			
		end
	end
end

function FunctionFood:ObserverDestroyed(effect)
	for key,effectInfo in pairs(self.potEffectMap)do
		if(effectInfo[1] == effect)then
			if(effectInfo[6] ~= nil)then
				effectInfo[6]:Destroy();
				effectInfo[6] = nil;
			end
			self.potEffectMap[key] = nil;
			break;
		elseif(effectInfo[6] == effect)then
			effectInfo[6] = nil;
		end
	end
end

function FunctionFood:MatchRecipe(type, itemIdCountList)
 	local itemids
	local recipes = type and self.recipe_Type_Map[type];
	if(recipes == nil)then
		return;
	end

	local filter_Recipes = {};

	local copyItemCountlist = {};
	for i=1, #itemIdCountList do
		copyItemCountlist[#copyItemCountlist + 1] = {itemId = itemIdCountList[i].itemId, num = itemIdCountList[i].num}
	end

	local items_totalCount = 0
	for i=1,#copyItemCountlist do
		items_totalCount = items_totalCount + copyItemCountlist[i].num
	end
	local materials, materials_totalCount;
	--遍历配方，找符合要求的,种类筛选
	for i=1,#recipes do
		local recipeData = recipes[i];

		materials = recipeData.Material;
		materials_totalCount = self.recipe_totalCount_Map[ recipeData.id ];
		if(materials_totalCount and materials_totalCount<=items_totalCount)then
			local recipe = {};
			recipe[1] = recipeData.id;
			recipe[2] = 0;

			local cpyMaterial = {};
			for i=1, #materials do
				cpyMaterial[i] = {};
				TableUtility.ArrayShallowCopy(cpyMaterial[i], materials[i]);
			end
			recipe[3] = cpyMaterial;
			-- 先筛选数量
			table.insert(filter_Recipes, recipe);
		end
	end
	
	local resultRecipes = {};
	-- local itemid;
	local sData, score;
	--选出可以做的配方
	local itemsIndex = #copyItemCountlist;
	for i=1,itemsIndex do
		itemidcount = copyItemCountlist[i]; --itemid

		for j=1, #filter_Recipes do
			materials = filter_Recipes[j][3];
			if(materials)then
				local isMatched = true;
				for _, material in pairs(materials)do
					if(material[3] > 0)then
						if(material[1] == 1)then
							if(itemidcount.itemId == material[2])then
								material[3] = math.max(material[3] - itemidcount.num, 0); -- 减一定数量
								filter_Recipes[j][2] = filter_Recipes[j][2] + 10 + (itemsIndex - i);
							end
						elseif(material[1] == 2)then
							sData = Table_Item[itemidcount.itemId];
							if(sData.Type == material[2])then
								material[3] = math.max(material[3] - itemidcount.num, 0);
								filter_Recipes[j][2] = filter_Recipes[j][2] + 10 + (itemsIndex - i);
							end
						end

						if(material[3] > 0)then
							isMatched = false;
						end
					end
				end
				if(isMatched)then
					table.insert(resultRecipes, filter_Recipes[j]);
					filter_Recipes[j][3] = nil;
				end
			end
		end
	end

	--选择权重最大的
	-- local resultRecipeID;
	-- local maxWeight = 0, 0;
	-- for i=1,#resultRecipes do
	-- 	local id, weight = resultRecipes[i][1], resultRecipes[i][2], resultRecipes[i][3];
	-- 	helplog("ResultRecipe:", id, weight);
	-- 	resultRecipes[i][2]

	-- 	-- if(weight > maxWeight)then
	-- 	-- 	maxWeight = weight;
	-- 	-- 	resultRecipeID = id;
	-- 	-- end
	-- end
	table.sort(resultRecipes, function (x, y)
		return x[2] > y[2]
	end)

	--选出权重列表以后， 减去最大量
	local resultRecipeIDCountMap = {}
	for i=1,#resultRecipes do
		local totallv = 0
		local totalCount = 0
		for i=1,#copyItemCountlist do
			local itemIdCount = copyItemCountlist[i]
			totalCount = totalCount + itemIdCount.num	
			local materialInfo = FoodProxy.Instance:Get_MaterialExpInfo(itemIdCount.itemId);
			if(materialInfo)then
				totallv = materialInfo.level * itemIdCount.num + totallv
			else
				totallv = totallv + itemIdCount.num;
			end
		end

		if totalCount >0 then
			local avgmateriallv = totallv/totalCount
			local recCount = self:GetMaxRecipeCount( resultRecipes[i][1], copyItemCountlist)
			if recCount > 0 then
				resultRecipeIDCountMap[#resultRecipeIDCountMap + 1] = { recipeId = resultRecipes[i][1], num = recCount, avgMatLevel = avgmateriallv}
			end
		end
	end

	--{ recipid, recipNum}
	--每个配方单独计算概率, 食材等级 计算 概率
	return resultRecipeIDCountMap;
end

function FunctionFood:GetMaxRecipeCount( recipeId, itemCountList )
	local recipeData = Table_Recipe[recipeId]
	if recipeData then
		local materials = recipeData.Material
		local minPecipeCount = 99999999
		for _, material in pairs(materials)do
			if(material[3] > 0)then
				-- id 类型
				if(material[1] == 1)then
					for i=1, #itemCountList do
						local itemidcount = itemCountList[i]
						if(itemidcount.itemId == material[2])then
							local newRecipeCount = math.floor(itemidcount.num/material[3])
							if newRecipeCount < minPecipeCount then
								minPecipeCount = newRecipeCount
							end
						end
					end
				-- type 类型
				elseif(material[1] == 2)then
					local newRecipeCount = 0
					for i=1, #itemCountList do
						local itemidcount = itemCountList[i]
						local sData = Table_Item[itemidcount.itemId];
						if(sData.Type == material[2])then
							local matTimes = math.floor(itemidcount.num/material[3])
							newRecipeCount = newRecipeCount + matTimes
						end
					end
					if newRecipeCount < minPecipeCount then
						minPecipeCount = newRecipeCount
					end
				end
			end
		end

		if minPecipeCount == 99999999 then
			return 0;
		end

		for _, material in pairs(materials)do
			if(material[3] > 0)then
				-- id 类型
				if(material[1] == 1)then
					for i=1, #itemCountList do
						local itemidcount = itemCountList[i]
						if(itemidcount.itemId == material[2])then
							itemidcount.num = itemidcount.num - material[3] * minPecipeCount
						end
					end
				-- type 类型
				elseif(material[1] == 2)then
					local leftRecipeCount = minPecipeCount
					for i=1, #itemCountList do
						local itemidcount = itemCountList[i]
						local sData = Table_Item[itemidcount.itemId];
						if(sData.Type == material[2])then
							local matTimes = math.floor(itemidcount.num/material[3])
							itemidcount.num = itemidcount.num - material[3] * math.min(matTimes, leftRecipeCount)
							if matTimes > leftRecipeCount then
								break;
							else
								leftRecipeCount = leftRecipeCount - matTimes
							end
						end
					end
				end
			end
		end

		return minPecipeCount
	end
	return 0
end

function FunctionFood:GetRecipeByFoodId(foodid)
	if(not self.initRecipe_foodkeyMap)then
		self.initRecipe_foodkeyMap = true;

		self.recipe_foodkeyMap = {};
		for id, recipeData in pairs(Table_Recipe)do
			local productid = recipeData.Product;
			self.recipe_foodkeyMap[productid] = recipeData;
		end
	end
	return self.recipe_foodkeyMap[foodid];
end

function FunctionFood:Match_MakeNum(recipeid)
	local recipeData = Table_Recipe[recipeid];
	local material = recipeData.Material;

	local bagProxy = BagProxy.Instance;
	local resultNum;
	local items;

	for i=1,#material do
		local m = material[i];
		local num = 0;
		if(m[1] == 1)then
			num = bagProxy:GetItemNumByStaticID(m[2], BagProxy.BagType.Food);
			num = math.floor(num/m[3]);
		elseif(m[1] == 2)then
			local itype = m[2]
			items = bagProxy:GetBagItemsByType(itype, BagProxy.BagType.Food)
			for i=1,#items do
				num = num + items[i].num;
			end
			num = math.floor(num/m[3]);
		end

		if(resultNum == nil)then
			resultNum = num;
		else
			resultNum = math.min(num, resultNum);
		end
	end
	return resultNum;
end

function FunctionFood:CalculateSuccessRate()
	return 0;
end

function FunctionFood:AccessFoodNpc(target)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.EatFoodPopUp, viewdata = {npcguid = target.data.id}});
end

function FunctionFood:UnLockRecipe(recipeId)
	local recipeData = Table_Recipe[recipeId];
	if(recipeData == nil)then
		return;
	end

	local itemData = Table_Item[recipeData.Product];
	if(itemData == nil)then
		return;
	end

	local data = {};
	data.icontype = 1;
	data.icon = itemData.Icon;
	data.content = string.format(ZhString.FunctionFood_UnLockRecipe, recipeData.Name);

	GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "SystemUnLockView"})
	GameFacade.Instance:sendNotification(SystemUnLockEvent.CommonUnlockInfo, data);
end

function FunctionFood.Material_LvUp(itemid, lv, playAnim)
	-- if(not playAnim)then
	-- 	return;
	-- end

	-- GameFacade.Instance:sendNotification(FoodEvent.MaterialExp_LvUp);
	-- 	-- local icon, datas, effectIndex, content = viewdata.icon, viewdata.datas, viewdata.effectIndex, viewdata.content;
	-- local data = {};
	-- local itemData = Table_Item[itemid];
	-- data.icontype = 1;
	-- data.icon = itemData.Icon;
	-- data.content = string.format(ZhString.FunctionFood_FoodCookLvUp, itemData.NameZh, lv);

	-- GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "SystemUnLockView"})
	-- GameFacade.Instance:sendNotification(SystemUnLockEvent.CommonUnlockInfo, data);
end

function FunctionFood.FoodCook_LvUp(itemid, lv, playAnim)
	if(not playAnim)then
		return;
	end

	GameFacade.Instance:sendNotification(FoodEvent.FoodCookExp_LvUp);
	-- local icon, datas, effectIndex, content = viewdata.icon, viewdata.datas, viewdata.effectIndex, viewdata.content;
	local data = {};
	local itemData = Table_Item[itemid];
	data.icontype = 1;
	data.icon = itemData.Icon;
	data.content = string.format(ZhString.FunctionFood_FoodCookLvUp, itemData.NameZh, lv);

	GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "SystemUnLockView"})
	GameFacade.Instance:sendNotification(SystemUnLockEvent.CommonUnlockInfo, data);
end

function FunctionFood.FoodEat_LvUp(itemid, lv, playAnim)
	if(not playAnim)then
		return;
	end

	GameFacade.Instance:sendNotification(FoodEvent.FoodEatExp_LvUp);
	-- local icon, datas, effectIndex, content = viewdata.icon, viewdata.datas, viewdata.effectIndex, viewdata.content;

	local data = {};
	local itemData = Table_Item[itemid];
	data.icontype = 1;
	data.icon = itemData.Icon;
	data.content = string.format(ZhString.FunctionFood_FoodTasteLvUp, itemData.NameZh, lv);

	GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "SystemUnLockView"})
	GameFacade.Instance:sendNotification(SystemUnLockEvent.CommonUnlockInfo, data);
end

function FunctionFood.MyCookerLvChange(oldvalue, newvalue)
	if(not Table_CookerLevel[newvalue])then
		return;
	end

	AudioUtility.PlayOneShot2D_Path( ResourcePathHelper.AudioSE("Common/FoodLvUp") );
	Game.Myself.assetRole:PlayEffectOneShotOn(EffectMap.Maps.CookLvUp, RoleDefines_EP.Top);

	GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "FoodMakeLvUpPopUp", cooklv = newvalue})
end

function FunctionFood.MyTasterLvChange(oldvalue, newvalue)
	if(not Table_TasterLevel[newvalue])then
		return;
	end
	
	AudioUtility.PlayOneShot2D_Path( ResourcePathHelper.AudioSE("Common/FoodLvUp") );
	Game.Myself.assetRole:PlayEffectOneShotOn(EffectMap.Maps.EatLvUp, RoleDefines_EP.Top);

	GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "FoodTastLvUpPopUp", tasterlv = newvalue})
end
