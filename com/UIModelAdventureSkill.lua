UIModelAdventureSkill = class("UIModelAdventureSkill")

local gReusableArray = {}

function UIModelAdventureSkill:ctor()
	
end

function UIModelAdventureSkill.Instance()
	if UIModelAdventureSkill.instance == nil then
		UIModelAdventureSkill.instance = UIModelAdventureSkill.new()
	end
	return UIModelAdventureSkill.instance
end

local tabSkillShopItemsHaveNotLearn = {}
local tabSkillShopItemsDataHaveNotLearn = {}

function UIModelAdventureSkill:GetSkillShopItemsHaveNotLearn()
	return tabSkillShopItemsHaveNotLearn
end

function UIModelAdventureSkill:PadTabSkillShopItemsHaveNotLearn(tab_skills_have_not_learn)
	if tab_skills_have_not_learn ~= nil then
		for i = 1, #tab_skills_have_not_learn do
			local skillShopItemID = tab_skills_have_not_learn[i]
			if not table.ContainsValue(tabSkillShopItemsHaveNotLearn, skillShopItemID) then
				table.insert(tabSkillShopItemsHaveNotLearn, skillShopItemID)
				local skillShopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(
					FuncAdventureSkill.iShopType,
					FuncAdventureSkill.Instance().iSerialNumber,
					skillShopItemID
				)
				table.insert(tabSkillShopItemsDataHaveNotLearn, skillShopItemData)
			end
		end
	end
end

function UIModelAdventureSkill:RemoveFromTabSkillShopItemsHaveNotLearn(i_skill_shop_item_id)
	for i = #tabSkillShopItemsHaveNotLearn, 1, -1 do
		local skillShopItemID = tabSkillShopItemsHaveNotLearn[i]
		if skillShopItemID == i_skill_shop_item_id then
			table.remove(tabSkillShopItemsHaveNotLearn, i)
			break
		end
	end
	for i = #tabSkillShopItemsDataHaveNotLearn, 1, -1 do
		local skillShopItemData = tabSkillShopItemsDataHaveNotLearn[i]
		if skillShopItemData.id == i_skill_shop_item_id then
			table.remove(tabSkillShopItemsDataHaveNotLearn, i)
		end
	end
end

function UIModelAdventureSkill:ClearTabSkillShopItemsHaveNotLearn()
	TableUtility.ArrayClear(tabSkillShopItemsHaveNotLearn)
	TableUtility.ArrayClear(tabSkillShopItemsDataHaveNotLearn)
end

function UIModelAdventureSkill:GetSkillShopItemsDataHaveNotLearn()
	return tabSkillShopItemsDataHaveNotLearn
end

function UIModelAdventureSkill:GetSkillShopItemsDataHaveNotLearn_PreSkillBeLearned()
	TableUtility.ArrayClear(gReusableArray)
	for _, v in pairs(tabSkillShopItemsDataHaveNotLearn) do
		local skillShopItemData = v
		local skillID = skillShopItemData.SkillID
		if skillID and skillID > 0 then
			local skillConf = Table_Skill[skillID]
			local filedCondition = skillConf.Contidion
			if filedCondition ~= nil then
				local preSkillID = filedCondition.skillid
				if preSkillID == nil then
					table.insert(gReusableArray, skillShopItemData)
				elseif preSkillID > 0 then
					if FuncAdventureSkill.Instance():SkillIsHaveLearned(preSkillID) then
						table.insert(gReusableArray, skillShopItemData)
					end
				end
			end
		end
	end
	return gReusableArray
end

function UIModelAdventureSkill:GetAdventureLevel()
	local appellation = MyselfProxy.Instance:GetCurManualAppellation();
	return appellation and appellation.id or 1;
end

-- need optimize
function UIModelAdventureSkill:SortFromUnlockToLock(tab_skill_shop_items_data)
	local adventureLevel = self:GetAdventureLevel()
	if adventureLevel == nil or adventureLevel <= 0 then
		LogUtility.Error(string.format('Local variable adventureLevel is illegal'))
	else
		if tab_skill_shop_items_data ~= nil and not table.IsEmpty(tab_skill_shop_items_data) then
			local lockSkillShopItems = {}
			local lockSkillShopItemsAppellation = {}
			for i = #tab_skill_shop_items_data, 1, -1 do
				local skillShopItemData = tab_skill_shop_items_data[i]
				local requireAppellation = self:GetSkillRequireAppellation(skillShopItemData.id)
				if requireAppellation > adventureLevel then
					lockSkillShopItems[skillShopItemData.id] = skillShopItemData
					table.insert(lockSkillShopItemsAppellation, {id = skillShopItemData.id, appellation = requireAppellation})
					table.remove(tab_skill_shop_items_data, i)
				end
			end
			table.sort(lockSkillShopItemsAppellation, function (x, y)
				return x.appellation < y.appellation
			end)
			local sortedLockSkillShopItems = {}
			for _, v in pairs(lockSkillShopItemsAppellation) do
				local skillShopItemID = v.id
				table.insert(sortedLockSkillShopItems, lockSkillShopItems[skillShopItemID])
			end
			for _, v in pairs(sortedLockSkillShopItems) do
				local lockSkillShopItem = v
				table.insert(tab_skill_shop_items_data, lockSkillShopItem)
			end
		end
	end
end

function UIModelAdventureSkill:SortBaseFieldShopOrder(tab_skill_shop_items_data)
	if tab_skill_shop_items_data ~= nil and not table.IsEmpty(tab_skill_shop_items_data) then
		table.sort(tab_skill_shop_items_data, function (x, y)
			return x.ShopOrder < y.ShopOrder
		end)
	end
end

function UIModelAdventureSkill:GetSkillRequireAppellation(i_shop_item_id)
	local retValue = 0
	if i_shop_item_id and i_shop_item_id > 0 then
		local skillShopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(
			FuncAdventureSkill.iShopType,
			FuncAdventureSkill.Instance().iSerialNumber,
			i_shop_item_id
		)
		local skillID = skillShopItemData.SkillID
		local skillConf = Table_Skill[skillID]
		retValue = skillConf.Contidion.riskid
	end
	return retValue
end