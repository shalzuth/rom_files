
function Game.Preprocess_Table()
	Game.Preprocess_UnionConfig()
	Game.Preprocess_BranchConfig()

	Game.Preprocess_Table_ActionAnime()
	Game.Preprocess_Table_Achievement()
	Game.Preprocess_Table_BuffState()
	Game.Preprocess_Table_BuffStateOdds()
	Game.Preprocess_Table_RoleData()
	Game.Preprocess_Table_ItemType()
	Game.Preprocess_Table_Reward()
	Game.Preprocess_Table_ActionEffect()

	Game.Preprocess_Equip();
	Game.Preprocess_Menu();
	Game.Preprocess_Pet();

	-- ????????????
	Game.Preprocess_AppleStore_Verify()
end

local function PreprocessEffectPaths(paths)
	if nil ~= paths then
		if nil == paths[2] then
			paths[2] = paths[1]
		elseif "none" == paths[2] then
			paths[2] = nil
		end
	end
	return paths
end
Game.PreprocessEffectPaths = PreprocessEffectPaths

local myBranchValue = EnvChannel.BranchBitValue[EnvChannel.Channel.Name]

local RemoveConfigByBranch = function (mapConfig,config,tablename)
	if(mapConfig and config) then
		for k,v in pairs(mapConfig) do
			if(v & myBranchValue > 0) then
				config[k] = nil
			end
		end
	end
end

local g_table
local forbidCfg = GameConfig.Forbid

-- ftype_start_end: id???   ({??????ID, ??????ID, branch}...)    
local HandleForbidByType1 = function (cfg,tab,tabName)
	if cfg and tab then
		for bit,indexCfg in pairs(cfg) do
			if type(indexCfg)~='table' or #indexCfg~=2 then
				redlog("?????????????????????ftype_start_end ??????????????????table??????,????????????ID?????????ID")
				return
			end
			if bit & myBranchValue > 0 then
				for tabKey,_ in pairs(tab) do
					if tabKey >= indexCfg[1] and tabKey<=indexCfg[2] then
						if nil==tab[tabKey] then
							redlog("??????????????????! ",tabName," ????????????ftype_start_end?????????ID: ",tabKey)
						else
							tab[tabKey]=nil
						end
					end
				end
			end
		end
	end
end

-- ftype_start: id?????? ({??????ID, branch}...)
local HandleForbidByType2 = function (cfg,tab,tabName)
	if cfg and tab then
		for bit,startID in pairs(cfg) do
			if type(startID)~='number' then
				redlog("?????????????????????ftype_start ??????????????????number????????????ID???")
				return
			end
			if bit & myBranchValue > 0 then
				for tabKey,_ in pairs(tab) do
					if tabKey >= startID then
						if nil==tab[tabKey] then
							redlog("??????????????????! ",tabName," ??????ftype_start?????????ID: ",tabKey)
						else
							tab[tabKey]=nil
						end
					end
				end
			end
		end
	end
end

-- ftype_id: ??????ID???({id, branch}...)
local HandleForbidByType3 = function (cfg,tab,tabName)
	if(cfg and tab) then
		for bit,ftab in pairs(cfg) do
			if bit & myBranchValue > 0 then
				if type(ftab)~='table' then
					redlog("?????????????????????ftype_id ??????????????????table?????????ID??????")
					return
				end
				for i=1,#ftab do
					if nil==tab[ftab[i]] then
						redlog("??????????????????! ",tabName," ??????ftype_id?????????ID: ",ftab[i])
					else
						tab[ftab[i]] = nil						
					end
				end
			end
		end
	end
end

-- ftype_params: ????????????????????????????????????
local HandleForbidByType4 = function (cfg,tab,tabName)
	if(cfg and tab) then
		local tName = "Table_"..tabName
		local exitSTab = nil~= _G[tName.. "_s"]
		tab = exitSTab and _G[tName.. "_s"] or tab
		for bit,singleCfg in pairs(cfg) do
			if bit & myBranchValue > 0 then
				for i=1,#singleCfg do
					local cfg = singleCfg[i]
					local dirtyArray = {}
					for k,v in pairs(tab) do
						dirtyArray[k]=false
					end
					for cfgK,cfgV in pairs(cfg) do
						for tabK,tabV in pairs(tab) do
							local tV = exitSTab and StrTablesManager.GetData(tName, tabK) or tabV
							if tV[cfgK]~=cfgV then
								dirtyArray[tabK]=true
							end
						end
					end
					for key,flag in pairs(dirtyArray) do
						if false == flag then
							tab[key]=nil
						end
					end
				end
			end
		end
	end
end

function Game.Preprocess_BranchConfig()
	if(GameConfig.BranchForbid) then
		local g_table
		for k,v in pairs(GameConfig.BranchForbid) do
			for tablename,t in pairs(v) do
				g_table = _G["Table_"..tablename]
				if(g_table) then
					RemoveConfigByBranch(t,g_table)
				end
			end
		end
	end
	-- ???????????????
	local forbidHandle = {}
	forbidHandle['ftype_start_end'] = HandleForbidByType1
	forbidHandle['ftype_start'] = HandleForbidByType2
	forbidHandle['ftype_id'] = HandleForbidByType3
	forbidHandle['ftype_params'] = HandleForbidByType4

	if forbidCfg then
		for tabName,forbid_cfg in pairs(forbidCfg) do
			g_table = _G["Table_"..tabName]
			if g_table then
				for ftype,v in pairs(forbid_cfg) do
					local call = forbidHandle[ftype]
					if call then
						call(v,g_table,tabName)
					else
						redlog("?????????????????????????????????",tabName,"???????????????",ftype)
					end
				end
			end
		end
	end

	-- ??????????????????
	if(GameConfig.SystemForbid) then
		for k,v in pairs(GameConfig.SystemForbid) do
			GameConfig.SystemForbid[k] = v & myBranchValue > 0 and true or false
		end
	else
		GameConfig.SystemForbid = {}
	end
end

function Game.Preprocess_Table_RoleData()
	local propNameConfig = {}
	for k,v in pairs(Table_RoleData) do
		propNameConfig[v.VarName] = v
	end
	Game.Config_PropName = propNameConfig
end

function Game.Preprocess_Table_ActionAnime()
	local actionConfig = {}
	local actionConfig_HideWeapon = {}
	for k,v in pairs(Table_ActionAnime) do
		actionConfig[v.Name] = v
	end

	Game.Config_Action = actionConfig
end

function Game.Preprocess_Table_Achievement()
	local titleAchievemnetConfig = {}
	for k,v in pairs(Table_Achievement) do
		if(v.RewardItems and v.RewardItems[1] and v.RewardItems[1][1])then
			local titleID = v.RewardItems[1][1]
			titleAchievemnetConfig[titleID]=v
		end
	end
	Game.Config_TitleAchievemnet = titleAchievemnetConfig
end

function Game.Preprocess_Table_BuffState()
	local buffConfig = {}
	for k,v in pairs(Table_BuffState) do
		local config = {
			Effect_start = PreprocessEffectPaths(StringUtil.Split(v.Effect_start, ",")),
			Effect_hit = PreprocessEffectPaths(StringUtil.Split(v.Effect_hit, ",")),
			Effect_end = PreprocessEffectPaths(StringUtil.Split(v.Effect_end, ",")),
			Effect = PreprocessEffectPaths(StringUtil.Split(v.Effect, ",")),
			Effect_around = PreprocessEffectPaths(StringUtil.Split(v.Effect_around, ",")),
			EffectGroup = PreprocessEffectPaths(StringUtil.Split(v.EffectGroup, ",")),
			EffectGroup_around = PreprocessEffectPaths(StringUtil.Split(v.EffectGroup_around, ",")),
		}
		buffConfig[k] = config
	end

	Game.Config_BuffState = buffConfig
end

function Game.Preprocess_Table_BuffStateOdds()
	local buffConfig = {}
	for k,v in pairs(Table_BuffStateOdds) do
		local config = {
			Effect = PreprocessEffectPaths(StringUtil.Split(v.Effect, ",")),
			EP = v.EP
		}
		buffConfig[k] = config
	end

	Game.Config_BuffStateOdds = buffConfig
end

local function _Preprocess_Reward_GetRewardDataByTeam( teamId,teamMap)
	-- body
	local list = {}
	local singleTeamList = teamMap[teamId]
	if(not singleTeamList)then
		redlog(string.format("Rward???????????????team???%s?????????!!!!!!!!!!!!!!!!",teamId))
		return list
	end
	for k,v in pairs(singleTeamList) do
		if(v.type == 3 or v.type == 4)then
			for _,rTeamIds in pairs(v.item) do
				local rewardItems = _Preprocess_Reward_GetRewardDataByTeam(rTeamIds.id,teamMap);
				TableUtil.InsertArray(list, rewardItems);
			end
		else
			for _,ritems in pairs(v.item)do
				local hasAdd = false
				for j=1,#list do
					local tmp = list[j]
					if(tmp.id == ritems.id)then
						tmp.num = tmp.num+ritems.num
						hasAdd = true
						break
					end
				end
				if(not hasAdd)then
					local data = {};
					data.id = ritems.id;
					data.num = ritems.num
					data.rewardType = v.type
					table.insert(list, data);
				end
			end
		end
	end
	return list
end

function Game.Preprocess_Table_Reward()
	local teamMap = {}
	-- autoImport("Table_Reward")
	for k,v in pairs(Table_Reward) do
		local list = teamMap[v.team]
		if(list==nil) then
			list = {}
			teamMap[v.team] = list
		end
		list[#list+1] = v
	end
	Game.Config_RewardTeam = {}
	for k,v in pairs(teamMap) do
		local itemList = _Preprocess_Reward_GetRewardDataByTeam(k,teamMap)
		-- if(not k or v.team == nil )then
		-- 	helplog(v.team)
		-- end
		Game.Config_RewardTeam[k] = itemList
	end
	Table_Reward  = nil
	_G["Table_Reward"] = nil
end

function Game.Preprocess_Table_ItemType()
	local types = {}
	local t
	for k,v in pairs(Table_ItemType) do
		if(v.Typegroup) then
			t = types[v.Typegroup]
			if(t==nil) then
				t= {}
				types[v.Typegroup] = t
			end
			t[#t+1] = v.id
		end
	end
	Game.Config_ItemTypeGroup = types
end

function Game.Preprocess_Table_ActionEffect()
	local actionConfig = {}
	for k,v in pairs(Table_ActionEffect) do
		local config = actionConfig[v.BodyID]
		if config == nil then
			config = {}
			actionConfig[v.BodyID] = config
		end
		config[#config + 1] = v.id
	end

	Game.Config_ActionEffect = actionConfig
end

function Game.Preprocess_AppleStore_Verify()
	if(not Game.inAppStoreReview)then
		return;
	end
	-- ??????????????? SSS ?????????????????????
	-- if(Table_Deposit)then
	-- 	local deposit_7 = Table_Deposit[7];
	-- 	if(deposit_7)then
	-- 		deposit_7.Count3 = 500000;
	-- 		deposit_7.MonthLimit = nil;
	-- 	end
	-- end

	-- if(Table_ItemTypeAdventureLog)then
	-- 	local itemTypeAdventureLog_14 = Table_ItemTypeAdventureLog[14];
	-- 	if(itemTypeAdventureLog_14)then
	-- 		itemTypeAdventureLog_14.Position = 0;
	-- 	end
	-- end

	-- if(GameConfig and GameConfig.DepositCard)then
	-- 	GameConfig.DepositCard.funcs = {8};
	-- end

	if(Table_Npc)then
		local npc_2156 = Table_Npc[2156];
		local npcFunction = npc_2156 and npc_2156.NpcFunction;
		if(npcFunction)then
			for i=#npcFunction, 1, -1 do
				if(npcFunction[i] and npcFunction[i].type == 4025)then
					table.remove(npcFunction, i);
					break;
				end
			end
		end
	end

	
end

local ImportUnionConfig = function ()
	autoImport("UnionConfig");
end
pcall(ImportUnionConfig);
function Game.Preprocess_UnionConfig()
	if(UnionConfig ~= nil)then
		for k0,v0 in pairs(UnionConfig)do
			if(GameConfig[k0])then
				for k1,v1 in pairs(v0)do
					if (GameConfig[k0][k1]) then
						GameConfig[k0][k1] = v1
					end
				end
			end
		end
	end
end

function Game.Preprocess_Equip()
	Game.Config_BodyDisplay = {};
	for k,v in pairs(Table_Equip)do
		if(v.Body and v.display and v.display > 0)then
			Game.Config_BodyDisplay[ v.Body ] = v.display;
		end
	end
end

function Game.Preprocess_Pet()
	local map = {};
	for k,v in pairs(Table_Pet)do
		if(v.EggID)then
			if(map[v.EggID] == nil)then
				map[v.EggID] = v;
			else
				redlog("One pet egg ID corresponds to multiple pet eggs", v.EggID);
			end
		end
	end
	Game.Config_EggPet = map;
end

function Game.Preprocess_Menu()
	Game.Config_UnlockActionIds = {};
	Game.Config_UnlockEmojiIds = {};
	for k,v in pairs(Table_Menu)do
		local evt = v.event;
		if(evt)then
			if(evt.type == "unlockaction")then
				if(evt.param)then
					for k1,v1 in pairs(evt.param)do
						Game.Config_UnlockActionIds[v1] = 1;
					end
				end
			elseif(evt.type == "unlockexpression")then
				if(evt.param)then
					for k1,v1 in pairs(evt.param)do
						Game.Config_UnlockEmojiIds[v1] = 1;
					end
				end
			end
		end
	end
end

function Game.Preprocess_Pet()
	local map = {};
	for k,v in pairs(Table_Pet)do
		if(v.EggID)then
			if(map[v.EggID] == nil)then
				map[v.EggID] = v;
			else
				redlog("One pet egg ID corresponds to multiple pet eggs", v.EggID);
			end
		end
	end
	Game.Config_EggPet = map;
end