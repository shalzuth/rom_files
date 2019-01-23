autoImport("UIModelAdventureSkill")

FuncAdventureSkill = class("FuncAdventureSkill")

function FuncAdventureSkill:ctor()
	
end

function FuncAdventureSkill.Instance()
	if FuncAdventureSkill.instance == nil then
		FuncAdventureSkill.instance = FuncAdventureSkill.new()
	end
	return FuncAdventureSkill.instance
end

FuncAdventureSkill.iShopType = 1400
function FuncAdventureSkill:OpenUI(i_serial_number)
	self.iSerialNumber = i_serial_number
	self:RequestQueryShopItem(FuncAdventureSkill.iShopType, i_serial_number)
	local idOfSkillShopItems = {}
	local shopDatas = ShopProxy.Instance:GetConfigByType(FuncAdventureSkill.iShopType)
	for k, v in pairs(shopDatas) do
		local shopID = k
		local shopData = v
		local shopItemDatas = shopData:GetGoods()
		for k, v in pairs(shopItemDatas) do
			local itemID = k
			local shopItemData = v
			if shopID == i_serial_number then
				local skillID = shopItemData.SkillID
				if skillID and skillID > 0 then
					if not self:SkillIsHaveLearned(skillID) then
						table.insert(idOfSkillShopItems, shopItemData.id)
					end
				end
			end
		end
	end
	UIModelAdventureSkill.Instance():ClearTabSkillShopItemsHaveNotLearn()
	UIModelAdventureSkill.Instance():PadTabSkillShopItemsHaveNotLearn(idOfSkillShopItems)
	self:DoOpenUI()
end

function FuncAdventureSkill:DoOpenUI()
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AdventureSkill, viewdata = { isNpcFuncView = true, npcdata = self.npcCreature }})
end

function FuncAdventureSkill:SkillIsHaveLearned(i_skill_id)
	if i_skill_id and i_skill_id > 0 then
		local learnedSkills = SkillProxy.Instance.learnedSkills
		for k, v in pairs(learnedSkills) do
			local skills = v
			for k, v in pairs(skills) do
				local skill = v
				if skill.id == i_skill_id then
					return true
				end
			end
		end
	end
	return false
end

function FuncAdventureSkill:SetNPCCreature(npc_creature)
	self.npcCreature = npc_creature
end

function FuncAdventureSkill:GetNPCCreature()
	return self.npcCreature
end

function FuncAdventureSkill:RequestQueryShopItem(type, shop_id)
	ShopProxy.Instance:CallQueryShopConfig(type, shop_id)
end