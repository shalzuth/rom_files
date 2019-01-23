ScenePlayerRevive = class("ScenePlayerRevive", SubView);

ScenePlayerRevive.ReviveSkillSortId = 161
ScenePlayerRevive.ExpelSkillSortId = 10151

local _MapManager;

function ScenePlayerRevive:Init()
	_MapManager = Game.MapManager;

	self.deadPlayerMap = {};
	self.reviveEffectMap = {};

	self:MapListenEvent();

end

function ScenePlayerRevive:GetReviveLeafItem()
	local playerRelive = GameConfig.PlayerRelive;
	if(playerRelive)then
		local reviveLeafId = playerRelive.deathcost[1].id;
		return BagProxy.Instance:GetItemByStaticID(reviveLeafId);
	end
	return nil;
end

function ScenePlayerRevive:GetReviveStoneItem()
	local playerRelive = GameConfig.PlayerRelive;
	if(playerRelive)then
		local reviveStoneId = playerRelive.Skillcost[1].id;
		return BagProxy.Instance:GetItemByStaticID(reviveStoneId);
	end
	return nil;
end

function ScenePlayerRevive:MapListenEvent()
	self:AddDispatcherEvt(CreatureEvent.Player_CampChange, self.HandlePlayerCampChange);

	self:AddListenEvt(PlayerEvent.DeathStatusChange, self.HandlePlayerStatusChange);
	self:AddListenEvt(SceneUserEvent.SceneAddRoles, self.HandleAddRoles)
	self:AddListenEvt(SceneUserEvent.SceneRemoveRoles, self.HandleRemoveRoles);

	self:AddListenEvt(ItemEvent.ReviveItemAdd, self.UpdatePlayersReviveState);
	self:AddListenEvt(ItemEvent.ReviveItemRemove, self.UpdatePlayersReviveState);

	self:AddListenEvt(ServiceEvent.PlayerMapChange, self.UpdatePlayersReviveState);
end

function ScenePlayerRevive:HandleAddRoles( note )
	local players = note.body;
	if(players)then
		for _,player in pairs(players)do
			if(player)then
				self:UpdatePlayerReviveState(player.data.id);
			end
		end
	end
end

function ScenePlayerRevive:HandleRemoveRoles( note )
	local playerids = note.body;
	if(playerids)then
		for _,playerid in pairs(playerids)do
			local effect = self.reviveEffectMap[playerid];
			if(effect)then
				effect:Destroy();
			end
			self.reviveEffectMap[playerid] = nil;
		end
	end
end

function ScenePlayerRevive:HandlePlayerCampChange(player)
	if(player)then
		self:UpdatePlayerReviveState(player.data.id);
	end
end

function ScenePlayerRevive:HandlePlayerStatusChange(note)
	local player = note.body;

	if(player)then
		self:UpdatePlayerReviveState(player.data.id);
	end
end

function ScenePlayerRevive:UpdatePlayersReviveState()
	for playerid,effect in pairs(self.deadPlayerMap) do
		self:UpdatePlayerReviveState(playerid);
	end	
end


function ScenePlayerRevive._ReviveBySkill(playerid, reviveItem)
	local player = NSceneUserProxy.Instance:Find(playerid);
	if(not player)then
		return;
	end

	if(player and player:IsDead())then
		local skill = SkillProxy.Instance:GetLearnedSkillBySortID(ScenePlayerRevive.ReviveSkillSortId);
		local range = nil;
		local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skill.id)
		if(skillInfo)then
			range = skillInfo:GetLaunchRange(player);
		end
		Game.Myself:Client_AccessTarget(player, skill.id , nil, AccessCustomType.ReviveBySkill, range);
	end
end

function ScenePlayerRevive._ReviveByLeaf(playerid, reviveItem)
	local myRole = Game.Myself;
	local player = NSceneUserProxy.Instance:Find(playerid);
	if(not player)then
		return;
	end
	MsgManager.ConfirmMsgByID(2508,function ()
		local player = NSceneUserProxy.Instance:Find(playerid);
		if(player and player:IsDead())then
			myRole:Client_AccessTarget(player, reviveItem, nil, AccessCustomType.UseItem);
		end
	end , nil , nil, player.data.name)
end

function ScenePlayerRevive._DoExpel(playerid)
	local player = NSceneUserProxy.Instance:Find(playerid);
	if(not player)then
		return;
	end

	if(player and player:IsDead())then
		local skillId;
		if(Game.MapManager:IsGvgMode_Droiyan())then
			skillId = GameConfig.GvgDroiyan.ExpelSkill;
		else
			skillId = GameConfig.GVGConfig.expel_skill;
		end
		Game.Myself:Client_AccessTarget(player, 
			skillId, 
			nil, 
			AccessCustomType.UseSkill, 
			1);
	end
end

function ScenePlayerRevive._CreateReviveEffect( effectHandle, args)
	if(not effectHandle)then
		return;
	end

	local self = args[1];
	local playerid = args[2];
	local reviveFunc = args[3];
	local reviveItem = args[4];

	ReusableTable.DestroyAndClearArray(args);

	local obj = effectHandle.gameObject;
	local spObj = UIUtil.GetAllComponentInChildren(obj, UIWidget)
	NGUITools.AddWidgetCollider(spObj.gameObject, true);	

	self:AddClickEvent(spObj.gameObject, function (go)
		reviveFunc(playerid, reviveItem);
	end);
end

function ScenePlayerRevive:UpdatePlayerReviveState(playerid)
	if(playerid == Game.Myself.data.id)then
		return;
	end

	local reviveEffectId, reviveFunc, reviveItem;
	if(SkillProxy.Instance:HasLearnedSkillBySort(ScenePlayerRevive.ReviveSkillSortId))then
		local reviveStone = self:GetReviveStoneItem();
		if(reviveStone and reviveStone.num > 0)then
			reviveEffectId = EffectMap.UI.Blue_Gemstone;
			reviveFunc = ScenePlayerRevive._ReviveBySkill;
			reviveItem = reviveStone;
		end
	end
	if(reviveItem == nil)then
		local reviveLeaf = self:GetReviveLeafItem();
		if(reviveLeaf and reviveLeaf.num > 0)then
			reviveEffectId = EffectMap.UI.Yggdrasilberry;
			reviveFunc = ScenePlayerRevive._ReviveByLeaf;
			reviveItem = reviveLeaf;
		end
	end
	local player = NSceneUserProxy.Instance:Find(playerid)
	if(not player)then
		self:RemoveReviveEffect(playerid);
		return false;
	end
	if(player:IsDead())then
		self.deadPlayerMap[playerid] = 1;
	else
		self.deadPlayerMap[playerid] = nil;
	end

	local hasEvent = false;

	if(self.deadPlayerMap[playerid])then
		if(player.data:GetCamp() == RoleDefines_Camp.FRIEND)then
			if(reviveItem and not player:IsInRevive())then
				hasEvent = true;

				self:RemoveReviveEffect(playerid);
				local args = ReusableTable.CreateArray();
				args[1] = self;
				args[2] = playerid;
				args[3] = reviveFunc;
				args[4] = reviveItem;

				local effect = SceneUIManager.Instance:PlayUIEffectOnRoleTop(
					reviveEffectId, 
					playerid, 
					false, 
					false,
					ScenePlayerRevive._CreateReviveEffect,
					args);
				effect:RegisterWeakObserver(self);

				self.reviveEffectMap[playerid] = effect;
			end
		elseif(player.data:GetCamp() == RoleDefines_Camp.ENEMY)then
			if(_MapManager:IsPVPMode() and 
				(_MapManager:IsPVPMode_GVGDetailed() or _MapManager:IsGvgMode_Droiyan()))then
				hasEvent = true;

				self:RemoveReviveEffect(playerid);
				local args = ReusableTable.CreateArray();
				args[1] = self;
				args[2] = playerid;
				args[3] = ScenePlayerRevive._DoExpel;

				local effect = SceneUIManager.Instance:PlayUIEffectOnRoleTop(
					EffectMap.UI.Expel,
					playerid,
					false,
					false,
					ScenePlayerRevive._CreateReviveEffect,
					args);
				effect:RegisterWeakObserver(self);

				self.reviveEffectMap[playerid] = effect;
			end
		end
	end

	if(hasEvent)then
		return true;
	end

	self:RemoveReviveEffect(playerid);

	return false;
end

function ScenePlayerRevive:RemoveReviveEffect(playerid)
	if(self.reviveEffectMap[playerid])then
		self.reviveEffectMap[playerid]:Destroy();
	end
	self.reviveEffectMap[playerid] = nil;
end

function ScenePlayerRevive:ObserverDestroyed(obj)
	for playerid,effect in pairs(self.reviveEffectMap)do
		if(effect == obj)then
			self.reviveEffectMap[playerid] = nil;
			break;
		end
	end
end




