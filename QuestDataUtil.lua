
QuestDataUtil = {}

QuestDataUtil.KeyValuePair = {
	{name = "id",type = "string",stepType = "illustration"},
	{name = "type",type = "string",stepType = "carrier"},
	{name = "button",type = "number",stepType = "guide"},
	{name = "pos",type = "table"},
	{name = "tarpos",type = "table"},
	{name = "dialog",type = "table"},
	{name = "method",type = "string"},
	{name = "GM",type = "string"},
	{name = "attention",type = "string"},
	{name = "itemIcon",type = "string"},
	{name = "name",type = "string"},
	{name = "button",type = "string"},
	{name = "text",type = "string"},
	{name = "guide_quest_symbol",type = "string"},
	{name = "teleMap",type = "table"},
}
function QuestDataUtil.getTypeBykeyAndStepType(key,stepType )
	-- body
	-- LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost address url:{0}:{1}",key,stepType)

	for i=1,#QuestDataUtil.KeyValuePair do
		local single = QuestDataUtil.KeyValuePair[i]
		if(single.stepType and stepType == single.stepType and single.name == key)then
			return single.type
		elseif(key == single.name and single.stepType == nil)then
			return single.type
		end
	end
end

--ITem 
function QuestDataUtil.getMethod( valueType )
	if(valueType == "string")then
		return tostring
	elseif(valueType == "number")then
		return tonumber
	end
end

function QuestDataUtil.parseParams( params,stepType )
	local param = {}
	if(params and #params>0)then
		for i=1,#params do
			local key = params[i].key
			local valueType = QuestDataUtil.getTypeBykeyAndStepType(key,stepType)
			local valueMethod = QuestDataUtil.getMethod(valueType)
			local value = params[i].value
			local items = params[i].items
			if(key == "npc")then
				if(items and #items > 0)then
					local table = QuestDataUtil.getLuaNumTable(items[1].items)
					param.npc = table
				else
					param.npc = tonumber(value)
				end
			elseif(key == "item" or key == "telePath")then
				if(items and items[1] and items[1].items and items[1].items[1] and items[1].items[1].items)then
					local data = {}
					local tempTb = items[1].items
					for j= 1,#tempTb do
						local item = tempTb[j]

						local childKey = item.key
						local childValues = item.items
						local table = {}
						for k=1,#childValues do
							local childchildKey = childValues[k].key
							local childchildValue = childValues[k].value
							table[childchildKey] = tonumber(childchildValue)
						end
						data[tonumber(childKey)] = table					
					end
					param.item = data
				end
			elseif(valueType and valueMethod)then
				if(value)then					
					param[key] = valueMethod(value)
				end
			elseif(valueType)then
				if(items and items[1] and items[1].items)then
					local table = QuestDataUtil.getLuaNumTable(items[1].items)
					param[key] = table
				end			
			else
				if(value)then					
					param[key] = tonumber(value)
				end
			end

		end
	end
	return param
end



function QuestDataUtil.getLuaNumTable(items)
	local table = {}
	for j=1,#items do
		local single = items[j]
		local key = single.key
		local value = single.value
		table[tonumber(key)] = tonumber(value)
	end
	return table
end

function QuestDataUtil.getLuaStringTable(items)
	local table = {}
	for j=1,#items do
		local single = items[j]
		local key = single.key
		local value = single.value
		table[tonumber(key)] = tostring(value)
	end
	return table
end

function QuestDataUtil.getTranceInfoTable(questData,data,questType,process)
	-- body
	local table = {}
	if(data == nil)then
		return table
	end
	local process = process and process or questData.process
	local questType = questType or questData.questDataStepType
	if( questType == QuestDataStepType.QuestDataStepType_VISIT)then
		local npc = data.npc
		local id = 0
		if(type(npc) == "table")then
			id = npc[1]
		else
			id = npc
		end
		local infoTable = Table_Npc[id]
		if(infoTable == nil)then
			infoTable = Table_Monster[id]
		end

		if(infoTable ~= nil)then
			table = {
					param2 = nil,
					npcName = infoTable.NameZh,
				}
			-- table = {
			-- 	param2 = nil,
			-- 	npcName = '[32cd32]'..infoTable.NameZh..'[-]',
			-- }
		else
			errorLog("invalid visit questType:. npcId:")
			errorLog(id)
		end
		if(questData.names)then
			local itemName = questData.names[1]
			table.itemName = itemName
		end
	elseif(questType == QuestDataStepType.QuestDataStepType_KILL)then		
		local id = data.monster
		local groupId = data.groupId
		local totalNum = data.num
		local infoTable = Table_Monster[id]
		if(infoTable == nil)then
			infoTable = Table_Npc[id]
		end
		if(infoTable ~= nil)then
			table = {				
					num = process..'/'..totalNum,
					monsterName = infoTable.NameZh,
				}
		elseif(groupId)then
			table = {			
					num = process..'/'..totalNum,
				}
		else
			errorLog("invalid kill or collect questType:. id:"..questData.id)
		end
	elseif(questType == QuestDataStepType.QuestDataStepType_COLLECT)then
		local id = data.monster
		local totalNum = data.num
		local infoTable = Table_Monster[id]
		if(infoTable == nil)then
			infoTable = Table_Npc[id]
		end
		if(infoTable ~= nil)then
			table = {				
					num = process..'/'..totalNum,
					monsterName = infoTable.NameZh,
				}
		else
			errorLog("invalid kill or collect questType:. id:"..questData.id)
		end
	elseif(questType == QuestDataStepType.QuestDataStepType_GATHER)then

		local items = ItemUtil.GetRewardItemIdsByTeamId(data.reward)
		if(not items or not items[1])then
			helplog("questId:"..questData.id.."rewardId:"..(data.reward or 0).." ?????????????????????????????????")
			return
		end
		
		local itemId = 	items[1].id
		local totalNum = data.num
		local infoTable = Table_Item[tonumber(itemId)]
		if(infoTable ~= nil)then
			table = {				
					num = process..'/'..totalNum,
					itemName = infoTable.NameZh,
				}
		else
			helplog("invalid itemId:"..itemId)
		end	
	elseif(questType == QuestDataStepType.QuestDataStepType_ITEM)then

		-- local id = data.monster
		-- local groupId = data.groupId
		local item = data.item and data.item[1]
		local itemId = item and item.id or 0
		local totalNum = item and item.num or 0
		
		local infoTable = Table_Item[tonumber(itemId)]
		if(infoTable and infoTable.Type == 160)then
			process = BagProxy.Instance:GetItemNumByStaticID(itemId,BagProxy.BagType.Quest) or 0
		else
			process = BagProxy.Instance:GetItemNumByStaticID(itemId) or 0
		end
		
		itemName = infoTable and infoTable.NameZh or nil
		table = {				
				num = process..'/'..totalNum,
				itemName = itemName,
			}
		
	elseif(questType == QuestDataStepType.QuestDataStepType_ADVENTURE)then
		local totalNum = data.num and data.num or 0
		-- local manual_type = data.manual_type
		-- local status = data.status
		-- if(manual_type == SceneManual_pb.EMANUALTYPE_MONSTER)then
		-- 	local monster_type = data.monster_type
			-- local process = AdventureDataProxy.Instance:getUnLockMonsterByType(QuestData.MonsterType[monster_type],status)
			table = {				
				num = process..'/'..totalNum
			}
		-- else
		-- 	table = {}
		-- end
	elseif(questType == QuestDataStepType.QuestDataStepType_CHECKPROGRESS)then
		local id = data.monster
		local groupId = data.groupId
		local totalNum = data.num and data.num or 0
		local infoTable = Table_Monster[id]
		if(infoTable == nil)then
			infoTable = Table_Npc[id]
		end
		if(infoTable ~= nil)then
			table = {				
					num = process..'/'..totalNum,
					monsterName = infoTable.NameZh,
				}
		elseif(groupId)then
			table = {			
					num = process..'/'..totalNum,
				}
		else
			errorLog("invalid check_progress questType:. id:"..questData.id)
		end
	elseif(questType == QuestDataStepType.QuestDataStepType_MONEY)then

		-- local id = data.monster
		-- local groupId = data.groupId
		local itemType = data.moneytype
		local totalNum = data.num
		if(itemType == ProtoCommon_pb.EMONEYTYPE_FRIENDSHIP)then
			process = BagProxy.Instance:GetItemNumByStaticID(itemType)
		elseif( itemType == ProtoCommon_pb.EMONEYTYPE_GARDEN)then
			process = BagProxy.Instance:GetItemNumByStaticID(GameConfig.MoneyId.Happy)
		else
			local enum = QuestDataUtil.getUserDataEnum(itemType)
			process = Game.Myself.data.userdata:Get(enum)
		end
		process = process and process or 0
		table = {				
				num = process..'/'..totalNum,
			}
	elseif(questType == QuestDataStepType.QuestDataStepType_ITEM_USE or
		questType == QuestDataStepType.QuestDataStepType_MUSIC or
		questType == QuestDataStepType.QuestDataStepType_HAND or 
		questType == QuestDataStepType.QuestDataStepType_PHOTO or
		questType == QuestDataStepType.QuestDataStepType_CARRIER )then

		process = process and process or 0
	
		table = {
				num = process,
			}
		if(questData.names)then
			local name = questData.names[1]
			table.name = name
		end
	elseif(questType == QuestDataStepType.QuestDataStepType_BATTLE) then
		process = process and process or 0
		local monsterName
		local id = data.monster

		local infoTable = Table_Monster[id]
		if(infoTable == nil)then
			infoTable = Table_Npc[id]
		end
		if(infoTable ~= nil)then
			monsterName = infoTable.NameZh
		end
		table = {
				num = process,
				monsterName = monsterName
			}
		if(questData.names)then
			local name = questData.names[1]
			table.name = name
		end
	else
		table = {}
	end
	return table
end

function QuestDataUtil.getUserDataEnum( moneyType)
	-- body
	if(moneyType==ProtoCommon_pb.EMONEYTYPE_DIAMOND)then
		--todo
		return UDEnum.DIAMOND
	elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_SILVER)then
		return UDEnum.SILVER
	elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_GOLD)then
		return UDEnum.GOLD
	elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_GARDEN)then
		return UDEnum.GARDEN
	elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_FRIENDSHIP)then
		return UDEnum.FRIENDSHIP
	end
end


function QuestDataUtil.parseWantedQuestTranceInfo( questData,wantedData )
	-- body
	local params = wantedData.Params
	local tableValue = QuestDataUtil.getTranceInfoTable(questData,params,wantedData.Content)
	if(tableValue == nil)then
		return "parse table text is nil:"..wantedData.Target
	end
	-- printRed(wantedData.Target)
	local result = string.gsub(wantedData.Target,'%[(%w+)]',tableValue)

	local index = 1
	result = string.gsub(result,'%[(%w+)]',function ( str )
		-- body
		local value = self.names[index]
		index = index + 1
		return value
	end)
	return result
end