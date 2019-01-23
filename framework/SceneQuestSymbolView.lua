-- 场景中npc头顶任务图标的相关逻辑
SceneQuestSymbolView = class("SceneQuestSymbolView", SubView);

function SceneQuestSymbolView:Init()
	self:MapViewListener();
end

function SceneQuestSymbolView:UpdateSingleRoleQuset(role, isRemove)
	if(not role.data)then
		return false;
	end
	
	if(not role.data:IsNpc())then
		return false;
	end

	local hasSymbol = false
	local hasAttention = false

	local questlst = QuestProxy.Instance:getDialogQuestListByNpcId(role.data.staticData.id, role.data.uniqueid);
	hasAttention = self:HandleAttention(role, questlst)
	hasSymbol = self:HandleSymbol(role, questlst)

	if(not hasSymbol)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:RemoveQuestEffectSymbol();
		end
	end
	if(not hasAttention) then
		role:DestroyGuideEffect();
	end
end

function SceneQuestSymbolView:HandleAttention(role,questlst)
	if(role.data:IsNpc() and questlst and #questlst>0)then
		local d = nil
		for i=1,#questlst do
			d = questlst[i];
			if(d.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT) then
				--如果是visit任务(这个条件，其实可以去掉)
				if(d.staticData and d.staticData.Params and d.staticData.Params.attention == "guide") then
					role:PlayGuideEffect();
					return true
				end
			end
		end
	end
	return false;
end

function SceneQuestSymbolView:HandleSymbol(role, questlst)
	questlst = QuestProxy.Instance:getSymbolDQListByNpcId(role.data.staticData.id, role.data.uniqueid, questlst)
	if(not questlst)then
		return;
	end
	local symbolType = nil;
	for i=1,#questlst do
		-- ShowSymbol为2隐藏小地图
		if(questlst[i].staticData)then
			if( questlst[i].staticData.Params.ShowSymbol~=1 and questlst[i].staticData.Params.ShowSymbol~=3)then
				local tsymbolType = QuestSymbolCheck.GetQuestSymbolByQuest(questlst[i])
				if(tsymbolType)then
					if(symbolType == nil or tsymbolType < symbolType)then
						symbolType = tsymbolType;
					end
				end
			else
				errorLog(string.format("%s Not Have StaticData", questlst[i].id));
			end
		end
	end
	-- 日常任务需要额外判定 如封印、研究所等
	if(not symbolType and QuestSymbolCheck.HasDailySymbol(role.data.staticData))then
		symbolType = QuestSymbolType.Daily;
	end
	if(symbolType)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:PlayQuestEffectSymbol(symbolType);
		end
		return true;
	end
	return false;
end


-- 公会福利
function SceneQuestSymbolView:UpdateGuildWelfareSymbol(role)
	if(role == nil)then
		return;
	end

	if(not role.data.IsNpc or not role.data:IsNpc())then
		return;
	end

	if(role.data.staticData.id ~= GuildProxy.Instance:GetWelfareNpcId())then
		return;
	end

	local sceneUI = role:GetSceneUI();
	if(sceneUI)then
		local show = GuildProxy.Instance:GetGuildWelfareState();
		if(show == true)then
			local getEffect = GameConfig.GuildBuilding.uieffect_getwelfare or "PetGift";
			sceneUI.roleTopUI:SetTopGiftSymbol(getEffect, self.GetGuildWelfare, self);

			local roleEffect = GameConfig.GuildBuilding.roleeffect_getwelfare or {""};
			role:PlayGuildWelfareEffect();
		else
			sceneUI.roleTopUI:RemoveTopGiftSymbol();
			role:DestroyGuideWelfareEffect();
		end
	end
end

-- 公会宝箱Npc领取奖励
function SceneQuestSymbolView:UpdateGuildTreasureGiftSymbol(role)
	if(role == nil)then
		return;
	end

	if(not role.data.IsNpc or not role.data:IsNpc())then
		return;
	end

	if(role.data.staticData.id ~= GuildTreasureProxy.Instance:GetTreasureNpcId())then
		return;
	end

	local sceneUI = role:GetSceneUI();
	if(sceneUI)then
		local can = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Treasure)
		local show = GuildProxy.Instance.myGuildData.gvg_treasure_count==1
		if(show and can)then
			local getEffect = GameConfig.GuildTreasure.GiftSymbol or "PetGift";
			sceneUI.roleTopUI:SetTopGiftSymbol(getEffect);
		else
			sceneUI.roleTopUI:RemoveTopGiftSymbol();
		end
	end
end

function SceneQuestSymbolView:GetGuildWelfare(creatureid)
	ServiceGuildCmdProxy.Instance:CallGetWelfareGuildCmd();
end
-- 公会福利


function SceneQuestSymbolView:MapViewListener()
	self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.HandleQuestUpdate);
	self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleQuestUpdate);
	self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleQuestUpdate);
	self:AddListenEvt(SystemUnLockEvent.NUserNewMenu, self.HandleQuestUpdate);
	self:AddListenEvt(ServiceEvent.QuestQuestList, self.HandleQuestUpdate);

	self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcRole)

	self:AddListenEvt(ServiceEvent.GuildCmdWelfareNtfGuildCmd, self.HandleGuildWelfareNtfCmd);
	self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleGuildWelfareNtfCmd);
	self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd , self.HandleGuildTreasureGiftNtfCmd);
end

-- 任务更新
function SceneQuestSymbolView:HandleQuestUpdate(note)
	local nowNpcs = NSceneNpcProxy.Instance.npcMap;
	for npcid,npcList in pairs(nowNpcs)do
		for k, role in pairs(npcList)do
			if(role.data:IsNpc())then
				self:UpdateSingleRoleQuset(role)
				self:UpdateGuildWelfareSymbol(role);
			end
		end
	end
end

-- 添加NPC头顶任务信息
function SceneQuestSymbolView:HandleAddNpcRole(note)
	local npcs = note.body;
	for _,role in pairs(npcs)do
		self:UpdateSingleRoleQuset(role);
		self:UpdateGuildWelfareSymbol(role);
		self:UpdateGuildTreasureGiftSymbol(role);
	end
end

function SceneQuestSymbolView:HandleGuildWelfareNtfCmd(note)
	if(not Game.MapManager:IsRaidMode())then
		return;
	end

	local roles_welfare = NSceneNpcProxy.Instance:FindNpcs(GuildProxy.Instance:GetWelfareNpcId())
	if(roles_welfare == nil or #roles_welfare ==0)then
		return;
	end
	self:UpdateGuildWelfareSymbol(roles_welfare[1]);
end

function SceneQuestSymbolView:HandleGuildTreasureGiftNtfCmd(note)
	local roles_welfare = NSceneNpcProxy.Instance:FindNpcs(GuildTreasureProxy.Instance:GetTreasureNpcId())
	if(roles_welfare == nil or #roles_welfare ==0)then
		return;
	end
	self:UpdateGuildTreasureGiftSymbol(roles_welfare[1]);	
end



