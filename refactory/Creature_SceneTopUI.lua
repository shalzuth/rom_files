Creature_SceneTopUI = reusableClass("Creature_SceneTopUI")
Creature_SceneTopUI.PoolSize = 50


autoImport("SceneFloatMsgQueueCtrl");
autoImport("SceneFloatMessage");
autoImport("SceneSpeakCell");
autoImport("SceneEmojiCell");
autoImport("SceneCountDownInfo");
autoImport("SceneTopFuncWord");
autoImport("SceneGuildGateInfo");

local cellData = {};

--玩家场景ui：头顶框，气泡说话，吟唱条等等
function Creature_SceneTopUI:ctor()
	Creature_SceneTopUI.super.ctor(self)
	
	self.followParents = {};
	self.floatMsgArray = {};
end

-- top begin
-- top end

function Creature_SceneTopUI:Update(time, deltaTime)
	self:UpdateRoleCountDownInfo(time, deltaTime);
end

function Creature_SceneTopUI:ActiveSceneUI(maskPlayerUIType, active)
	if(maskPlayerUIType == MaskPlayerUIType.Emoji)then
		self.emojiActive = active;
		if(self.spineCell)then
			self.spineCell:Active(active);
		end
	elseif(maskPlayerUIType == MaskPlayerUIType.TopFrame)then
		self.topFuncActive = active;
		if(self.topFuncCell)then
			self.topFuncCell:Active(active);
		end
	elseif(maskPlayerUIType == MaskPlayerUIType.ChatSkillWord)then
		self.speakActive = active;
		if(self.speakCell)then
			self.speakCell:Active(active);
		end

		if(self.topSingUI)then
			if(active)then
				self.topSingUI:Show()
			else
				self.topSingUI:Hide()
			end
		end
	elseif(maskPlayerUIType == MaskPlayerUIType.QuestUI)then
		self.questSymbolActive = active;
		self:ActiveQuestSymbolEffect(active);
	elseif(maskPlayerUIType == MaskPlayerUIType.FloatRoleTop)then
		self.floatMsgActive = active;
	end
end

function Creature_SceneTopUI:ActiveQuestSymbolEffect( b )
	if(self.questEffectSymbol)then
		if(b)then
			self.questEffectSymbol:ResetLocalPositionXYZ(0,30,0);
		else
			self.questEffectSymbol:ResetLocalPositionXYZ(0,10000,0);
		end
	end
end

function Creature_SceneTopUI:PlaySceneUIEffect(id, once, callback, callArgs, creature)
	local container = self:GetSceneUITopFollow(SceneUIType.RoleTopInfo, creature);
	if(nil == container)then
		error("QuestSymbol not find container!!");
		return;
	end

	local path, resultEffect = ResourcePathHelper.UIEffect(id);
	if(once)then
		resultEffect = Asset_Effect.PlayOneShotOn( path, container.transform, callback, callArgs );
	else
		resultEffect = Asset_Effect.PlayOn( path, container.transform, callback, callArgs );
	end

	return resultEffect;
end

function Creature_SceneTopUI._CreateQuestEffectCall( effectHandle, self )

	GameObjectUtil.Instance:ChangeLayersRecursively (effectHandle.gameObject, "SceneUI")

	self:ActiveQuestSymbolEffect(self.questSymbolActive);
end

function Creature_SceneTopUI:PlayQuestEffectSymbol( symbolType )
	-- if(not self.questSymbolActive)then
	-- 	return;
	-- end

	if(not symbolType or self.symbolType == symbolType)then
		return;
	end

	self:RemoveQuestEffectSymbol();

	local config = QuestSymbolConfig[symbolType];
	local effectId = config and config.SceneSymbol;
	if(effectId)then
		local effect = self:PlaySceneUIEffect(effectId, false, Creature_SceneTopUI._CreateQuestEffectCall, self);
		if(effect)then
			-- effect:SetLayer
			effect:RegisterWeakObserver(self);
			effect:ResetLocalPositionXYZ(0,30,0);
			self.questEffectSymbol = effect;
			self.symbolType = symbolType;
		else
			helplog("QuestEffectSymbol Play Fail");
		end
	end
end

function Creature_SceneTopUI:RemoveQuestEffectSymbol()
	if(self.questEffectSymbol)then
		self.questEffectSymbol:Destroy();
		self.questEffectSymbol = nil;
	end
	self.symbolType = nil;
end

-- TopFuncFrame Begin
function Creature_SceneTopUI._CreateSceneTopFuncWord( asset, args )
	local self = args[1];
	local text = args[2];
	local icon = args[3];
	local clickFunc = args[4];
	local clickArgs = args[5];

	self.asyncCreateTopFunc = false;

	TableUtility.ArrayClear(cellData);
	cellData[1] = asset;
	cellData[2] = text;
	cellData[3] = icon;
	cellData[4] = clickFunc;
	cellData[5] = clickArgs;
	self.topFuncCell = SceneTopFuncWord.CreateAsArray(cellData);
	
	self.topFuncCell:Active(self.topFuncActive);
end

function Creature_SceneTopUI._CreateSceneTopFunc_ArgsDeleter( args )
	ReusableTable.DestroyAndClearArray(args);
end

function Creature_SceneTopUI:SetTopFuncFrame(text, icon, clickFunc, clickArgs, creature, sceneUIType)
	self:RemoveTopFuncFrame();

	sceneUIType = sceneUIType or SceneUIType.RoleTopInfo
	local follow = self:GetSceneUITopFollow(sceneUIType, creature);
	if(nil == follow)then
		return;
	end

	local args = ReusableTable.CreateArray();
	args[1] = self;
	args[2] = text;
	args[3] = icon;
	args[4] = clickFunc;
	args[5] = clickArgs;

	self.asyncCreateTopFunc = true;
	Game.CreatureUIManager:AsyncCreateUIAsset( 
		self.creatureId, 
		SceneTopFuncWord.ResID, 
		follow,
		Creature_SceneTopUI._CreateSceneTopFuncWord,
		args,
		Creature_SceneTopUI._CreateSceneTopFunc_ArgsDeleter);
end

function Creature_SceneTopUI:RemoveTopFuncFrame()
	if(self.asyncCreateTopFunc)then
		Game.CreatureUIManager:RemoveCreatureWaitUI( self.creatureId, SceneTopFuncWord.ResID );
	end

	if(self.topFuncCell)then
		self.topFuncCell:Destroy();
		self.topFuncCell = nil;
	end
end
-- TopFuncFrame End



-- RoleCountDown Begin
function Creature_SceneTopUI:SetRoleCountDownInfo(text, time)
	if(self.sceneCountDownInfo == nil)then
		local follow = self:GetSceneUITopFollow(SceneUIType.SpeakWord, creature);
		if(nil == follow)then
			return nil;
		end

		local args = ReusableTable.CreateArray();;
		args[1] = follow;
		args[2] = text;
		args[3] = time;
		self.sceneCountDownInfo = SceneCountDownInfo.CreateAsArray(args);
		ReusableTable.DestroyAndClearArray(args)
	else
		self.sceneCountDownInfo:ReSetInfo( text, time );
	end

	if(self.countDownTick == nil)then
		self.countDownTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRoleCountDownInfo, self, 111);
	end
end

function Creature_SceneTopUI:UpdateRoleCountDownInfo(time, deltatime)
	if(self.sceneCountDownInfo == nil)then
		return;
	end

	local delta = self.sceneCountDownInfo:GetDelta();

	if(delta == nil or delta < 0)then
		self:RemoveRoleCountDownInfo();
		return;
	end

	self.sceneCountDownInfo:UpdateInfo();
end

function Creature_SceneTopUI:RemoveRoleCountDownInfo()
	if(self.countDownTick)then
		TimeTickManager.Me():ClearTick(self, 111);
	end
	self.countDownTick = nil;

	if(self.sceneCountDownInfo)then
		self.sceneCountDownInfo:Destroy();
	end
	self.sceneCountDownInfo = nil;
end
-- TopFuncFrame End



-- TopGiftSymbol End
local PATH_GIFT_HELPFUNC = ResourcePathHelper.EffectUI;
local tempV3 = LuaVector3();
function Creature_SceneTopUI:SetTopGiftSymbol(symbolName, clickEvent, clickEventParam)
	if(self.giftSymbol)then
		return;
	end

	local container = self:GetSceneUITopFollow(SceneUIType.RoleTopInfo);
	self.giftPath = PATH_GIFT_HELPFUNC(symbolName);
	self.giftSymbol = Game.AssetManager_UI:CreateSceneUIAsset(self.giftPath, container.transform);
	self.giftSymbol:SetActive(true);
	tempV3:Set(-20,20);
	self.giftSymbol.transform.localPosition = tempV3;
	self.giftSymbol.transform.localRotation = LuaGeometry.Const_Qua_identity;
	self.giftSymbol.transform.localScale = LuaGeometry.Const_V3_one;

	local creatuerid = self.creatureId;
	UIEventListener.Get(self.giftSymbol).onClick = function (go)
		if(clickEvent)then
			clickEvent(clickEventParam, creatuerid);
		end
	end
end

function Creature_SceneTopUI:RemoveTopGiftSymbol()
	if(not Slua.IsNull(self.giftSymbol))then
		self.giftSymbol:SetActive(false);
		Game.GOLuaPoolManager:AddToSceneUIPool(self.giftPath, self.giftSymbol);
		self.giftSymbol = nil;
		self.giftPath = nil;
	end
end
-- TopGiftSymbol End


-- FloatMsg Begin
function Creature_SceneTopUI:ActiveSceneTopMsg(active)
end

function Creature_SceneTopUI:FloatRoleTopMsgById(msgid, param)
	if(msgid and Table_Sysmsg[msgid])then
		self:FloatTopMsg(Table_Sysmsg[msgid].Text, param);
	end
end

local floatParams = {};
local floatInterval = 0.5 * 1000;
function Creature_SceneTopUI:FloatTopMsg(msg, param)
	local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopFloatMsg);
	if(nil == follow)then
		return;
	end 

	if(not self.floatMsgQueue)then
		TableUtility.ArrayClear(floatParams);
		floatParams[1] = 20;
		floatParams[2] = floatInterval;
		floatParams[3] = self._DoFloatTopMsg;
		floatParams[4] = self;
		self.floatMsgQueue = SceneFloatMsgQueueCtrl.CreateAsArray(floatParams);
	end

	local data = {}
	data[1] = follow;
	data[2] = SceneFloatMessageType.Exp;
	data[3] = msg;
	data[4] = param;
	self.floatMsgQueue:Add(data);
end

function Creature_SceneTopUI:_DoFloatTopMsg(data)
	if(not self.floatMsgActive)then
		return;
	end
	
	local floatMsg = SceneFloatMessage.CreateAsArray(data);
	floatMsg:RegisterWeakObserver(self);
	table.insert(self.floatMsgArray, floatMsg);
end

function Creature_SceneTopUI:DestroyFloatMsgObj()
	for i=#self.floatMsgArray, 1, -1 do
		if(self.floatMsgArray[i])then
			self.floatMsgArray[i]:Destroy();
		end
	end
end
-- FloatMsg End



-- Speak Begin
function Creature_SceneTopUI:Speak(msg, creature)
	if(not self.speakActive)then
		return;
	end

	if(not self.speakCell)then
		local follow = self:GetSceneUITopFollow(SceneUIType.SpeakWord, creature);
		if(nil == follow)then
			return nil;
		end
		self.speakCell = SceneSpeakCell.CreateAsArray(follow);
	end
	self.speakCell:SetData( MsgParserProxy.Instance:DoParse(msg) );
end
-- Speak End



-- SceneGateInfo begin
function Creature_SceneTopUI:SetGuildGateInfo(level, killedbossnum, haveteamer)
	local creature = SceneCreatureProxy.FindCreature(self.creatureId);
	if(creature == nil)then
		return;
	end

	if(self.guildGateInfo)then
		self.guildGateInfo:UpdateInfo(level, killedbossnum, haveteamer);
	else
		local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopInfo, creature);
		local params = {follow, level, killedbossnum, haveteamer};
		self.guildGateInfo = SceneGuildGateInfo.CreateAsArray(params);
	end
end

function Creature_SceneTopUI:RemoveGuildGateInfo()
	if(self.guildGateInfo)then
		self.guildGateInfo:Destroy();
		self.guildGateInfo = nil;
	end
end
-- SceneGateInfo end



-- Emoji Begin
function Creature_SceneTopUI:PlayEmojiById(emojiId)
	local emojiData = Table_Expression[emojiId];
	if(emojiData)then
		self:PlayEmoji(emojiData.NameEn);
	end
end

function Creature_SceneTopUI:PlayEmoji(name, depth, loopCount, creature)
	if(not self.emojiActive)then
		return;
	end

	if(name == nil)then
		return;
	end

	loopCount = loopCount or 2;

	if(not creature)then
		creature = SceneCreatureProxy.FindCreature(self.creatureId);
	end
	if(not creature or creature.data.id~=self.creatureId)then
		return;
	end
	if(creature.data.creatureType == Creature_Type.Me)then
		depth = 2;
	else
		depth = 1;
	end

	self:PlayTopSpine(ResourcePathHelper.Emoji(name), "animation", loopCount, depth, creature);
end

function Creature_SceneTopUI.SpineAnimEnd(self)
	self:DestroySpine();
end

function Creature_SceneTopUI:PlayTopSpine(path, animationName, loopCount, depth, creature)
	if(self.spineCell)then
		self:DestroySpine();
	end
	
	local emoji_Parent = self:GetSceneUITopFollow(SceneUIType.Emoji, creature);
	TableUtility.ArrayClear(cellData)
	cellData[1] = emoji_Parent;
	cellData[2] = path;
	cellData[3] = depth;
	cellData[4] = animationName;
	cellData[5] = loopCount;
	cellData[6] = Creature_SceneTopUI.SpineAnimEnd;
	cellData[7] = self;
	self.spineCell = SceneEmojiCell.CreateAsArray(cellData)
end

function Creature_SceneTopUI:DestroySpine()
	if(self.spineCell)then
		self.spineCell:Destroy();
		self.spineCell = nil;
	end
end
	
-- Emoji end

local topFocusUIData = {}

function Creature_SceneTopUI:createOrGetTopFocusUI(  )
	-- body
	if(not self.topFocusUI)then
		local topFocusUIParent = self:GetSceneUITopFollow(SceneUIType.PhotoFocus)
		TableUtility.ArrayClear(topFocusUIData)
		topFocusUIData[1] = SceneTopFocusUI.FocusType.Creature
		topFocusUIData[2] = topFocusUIParent
		self.topFocusUI = SceneTopFocusUI.CreateAsArray(topFocusUIData)
	end
	return 	self.topFocusUI
end

function Creature_SceneTopUI:DestroyTopFocusUI()
	if(self.topFocusUI)then
		ReusableObject.Destroy(self.topFocusUI)
	end	
	self.topFocusUI = nil;
end


function Creature_SceneTopUI:createOrGetTopSingUI(  )
	-- body
	local creature = SceneCreatureProxy.FindCreature(self.creatureId);
	if(creature)then
		if(not self.topSingUI)then
			TableUtility.ArrayClear(topFocusUIData)
			-- local topSingUIParent = self:GetSceneUITopFollow(SceneUIType.RoleBottomInfo)
			local topSingUIParent;
			if(creature:GetCreatureType() == Creature_Type.Npc)then
				if(creature.data:IsMonster())then
					topSingUIParent = self:GetSceneUITopFollow(SceneUIType.MonsterBottomInfo) 
				else
					topSingUIParent = self:GetSceneUITopFollow(SceneUIType.NpcBottomInfo) 
				end
			else
				topSingUIParent = self:GetSceneUITopFollow(SceneUIType.PlayerBottomInfo) 
			end

			topFocusUIData[1] = topSingUIParent
			self.topSingUI = PlayerSingViewCell.CreateAsArray(topFocusUIData)
		end
		local sceneUI = creature:GetSceneUI() 
		local maskSingIndex = sceneUI and sceneUI:MaskByType(MaskPlayerUIType.ChatSkillWord) or nil
		local mask = maskSingIndex ~= nil
		if(mask and self.topSingUI)then
			self.topSingUI:Hide()
		else
			self.topSingUI:Show()
		end
		return 	self.topSingUI
	end	
end

function Creature_SceneTopUI:DestroyTopSingUI()
	if(self.topSingUI)then
		ReusableObject.Destroy(self.topSingUI)		
	end
	self.topSingUI = nil
end

-- Follow begin
function Creature_SceneTopUI:GetSceneUITopFollow(type, creature)
	if(not type)then
		return;
	end

	if(not self.followParents[type])then
		local container = SceneUIManager.Instance:GetSceneUIContainer(type);
		if(container)then
			creature = creature or SceneCreatureProxy.FindCreature(self.creatureId);
			if(not creature)then
				errorLog("Depand-On-Creature is Destroy!");
				return;
			end
			if(creature.data.id~=self.creatureId)then
				errorLog(string.format("creature'id is not right( %s | %s)", tostring(creature.data.id), tostring(self.creatureId)));
				return;
			end
			local name;
			if(creature:GetCreatureType() == Creature_Type.Npc)then
				name = creature.data.staticData.NameZh;
			else
				name = creature.data.name;
			end
			local follow = GameObject(string.format("RoleTopFollow_%s" ,tostring(name)));
			follow.transform:SetParent(container.transform, false);
			follow.layer = container.layer;
			creature:Client_RegisterFollow(follow.transform, nil, RoleDefines_EP.Top, nil, nil)
			self.followParents[type] = follow;
		end
	end

	return self.followParents[type];
end

function Creature_SceneTopUI:UnregisterSceneUITopFollows()
	for key,follow in pairs(self.followParents)do
		if(not LuaGameObject.ObjectIsNull(follow))then
			Game.RoleFollowManager:UnregisterFollow(follow.transform)
			GameObject.Destroy(follow);
		end
		self.followParents[key] = nil;
	end
end
-- Follow end

-- override begin
local accessFunc = function ( creatureId )
	if(Game.Myself)then
		local tCreature = SceneCreatureProxy.FindCreature(creatureId)
		Game.Myself:Client_AccessTarget(tCreature);
	end
end
function Creature_SceneTopUI:DoConstruct(asArray, creature)
	self.creatureId = creature.data.id;

	self.emojiActive = true;
	self.speakActive = true;
	self.questSymbolActive = true;
	self.topFuncActive = true;
	self.floatMsgActive = true;

	if(creature:GetCreatureType() == Creature_Type.Npc and creature.data:IsNpc())then
		local npcData = creature.data.staticData;
		if(npcData.FnDesc and npcData.FnDesc~="" and 
			npcData.FnIcon and npcData.FnIcon~="")then
			self:SetTopFuncFrame(npcData.FnDesc, npcData.FnIcon, accessFunc, self.creatureId ,creature);
		end
	end
end

function Creature_SceneTopUI:DoDeconstruct(asArray)
	if(self.speakCell)then
		self.speakCell:Destroy();
		self.speakCell = nil;
	end

	if(self.floatMsgQueue)then
		self.floatMsgQueue:Destroy();
		self.floatMsgQueue = nil;
	end

	self:DestroySpine();
	self:DestroyTopSingUI()
	self:DestroyTopFocusUI()
	self:DestroyFloatMsgObj();
	self:RemoveTopFuncFrame();
	self:RemoveTopGiftSymbol();
	self:RemoveQuestEffectSymbol();
	self:RemoveGuildGateInfo();
	self:RemoveRoleCountDownInfo();

	-- Unregist Follow
	self:UnregisterSceneUITopFollows();
end

function Creature_SceneTopUI:ObserverDestroyed(obj)
	local questEffectSymbol = self.questEffectSymbol;
	if(obj == questEffectSymbol)then
		self.questEffectSymbol = nil;
		self.symbolType = nil;
	end

	for i=#self.floatMsgArray, 1, -1 do
		if(self.floatMsgArray[i] == obj)then
			table.remove(self.floatMsgArray, i);
			break;
		end
	end

end
-- override end