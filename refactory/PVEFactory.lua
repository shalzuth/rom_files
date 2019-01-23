PVEFactory = class("PVEFactory")


local facade = GameFacade.Instance;
local notify = function (evtname, body)
	facade:sendNotification(evtname, body);
end

local Dungeon_Handle = class("Dungeon_Handle");
function Dungeon_Handle:ctor()
end

function Dungeon_Handle:Launch()
end

function Dungeon_Handle:Update()
end

function Dungeon_Handle:Shutdown()
end




local PveCard = class("PveCard", Dungeon_Handle);
local dungeonProxyInstance;
local nSceneNpcProxyInstance;
local uIUtilFindGO;
local table_PveCard;
local pictureManagerInstance;
function PveCard:ctor()
	self.isPveCard = true;

	self.normalCardEffect_npcguid_map = {};
	self.bossCardEffect_npcguid_map = {};

	self.cardSeted_map = {};
end

function PveCard:Launch()
	notify(PVEEvent.PVE_CardLaunch)
	-- play_card_action 
	EventManager.Me():AddEventListener(ServiceEvent.PveCardUpdateProcessPveCardCmd, 
		self.HandleProgressUpdate, 
		self);

	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.SceneAddCreaturesHandler, self)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.SceneRemoveCreaturesHandler, self)

	dungeonProxyInstance = DungeonProxy.Instance;
	nSceneNpcProxyInstance = NSceneNpcProxy.Instance;
	uIUtilFindGO = UIUtil.FindGO;
	table_PveCard = Table_PveCard;
	pictureManagerInstance = PictureManager.Instance;
	helplog("dungeonProxyInstance:", dungeonProxyInstance);
end

function PveCard:HandleProgressUpdate()
	local action_config = GameConfig.CardRaid.play_card_action;
	if(action_config == nil)then
		return;
	end

	local table_ActionAnim = Table_ActionAnime;
	for npcid, actionid in pairs(action_config)do
		local npcs =  NSceneNpcProxy.Instance:FindNpcs(npcid);
		if(npcs and npcs[1])then
			local animData = table_ActionAnim[actionid];
			if(animData)then
				npcs[1]:Client_PlayAction(animData.Name, nil, false);
			end
		end
	end
end

function PveCard:SceneAddCreaturesHandler(creatures)

	-- local nextIds = dungeonProxyInstance:GetNextPlayingCardIds();
	local nowProgress = dungeonProxyInstance:GetNowProgress();
	local selectIds = dungeonProxyInstance:GetSelectCardIds();
	if(nowProgress == nil or selectIds == nil)then
		return;
	end

	for i=1,#creatures do
		local c = creatures[i];
		if(c.data)then
			if(c.data.IsPveCardEffect and c.data:IsPveCardEffect())then
				local cardid = c.data.uniqueid or 111;
				self.normalCardEffect_npcguid_map[ c.data.id ] = cardid;
			end
		end

	end
end

function PveCard:SceneRemoveCreaturesHandler(creatureids)
	for k,id in pairs(creatureids)do
		self.normalCardEffect_npcguid_map[ id ] = nil;
		self.bossCardEffect_npcguid_map[ id ] = nil;
	end
end

local UPDATE_THRESHOLD = 0.2;
local countTime = 0;
function PveCard:Update(time, deltaTime)
	if(countTime < UPDATE_THRESHOLD )then
		countTime = countTime + deltaTime;
		return;
	end
	countTime = 0;

	for npcguid,cardid in pairs(self.normalCardEffect_npcguid_map)do
		self:_SetCardEffectNpcTexture(npcguid, cardid, self.normalCardEffect_npcguid_map, "IsPveCardEffect");
	end
end

local delay_setmap = {};
function PveCard:_SetCardEffectNpcTexture( npcguid, cardid, cacheMap, checkFuncKey )
	local role = nSceneNpcProxyInstance:Find(npcguid);
	if(role == nil or role.data[checkFuncKey] == nil or not role.data[checkFuncKey](role.data))then
		return;
	end
	local go = role.assetRole.complete.gameObject;
	local quadGO = uIUtilFindGO("Quad", go);
	if(quadGO == nil)then
		quadGO = uIUtilFindGO("Quad_Boss", go);
	end
	if(quadGO == nil)then
		return;
	end
	if(delay_setmap[npcguid] == nil)then
		delay_setmap[npcguid] = 0;
	end
	-- update的执行顺序有可能在材质球的初始化之后 所以缓存住延时执行
	if(delay_setmap[npcguid] < 2)then
		delay_setmap[npcguid] = delay_setmap[npcguid] + 1
		return;
	end
	delay_setmap[npcguid] = nil;
	cacheMap[ npcguid ] = nil;

	local resStr = table_PveCard[cardid] and table_PveCard[cardid].Resource or "cardback_1";
	if(resStr == nil)then
		return;
	end

	local r = quadGO:GetComponent(Renderer);
	pictureManagerInstance:SetCard(resStr, r.material)
end

function PveCard:Shutdown()
	notify(PVEEvent.PVE_CardShutdown)
	EventManager.Me():RemoveEventListener(ServiceEvent.PveCardUpdateProcessPveCardCmd, 
		self.HandleProgressUpdate, 
		self);

	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.SceneAddCreaturesHandler, self)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.SceneRemoveCreaturesHandler, self)

	PictureManager.Instance:UnLoadCard()
end


function PVEFactory.GetPveCard()
	return PveCard.new();
end



-- altMan begin
local AltMan = class("AltMan", Dungeon_Handle);
function AltMan:ctor()
	self.isAltman = true;
end

function AltMan:Launch()
	notify(PVEEvent.Altman_Launch)
end

function AltMan:Update()

end

function AltMan:Shutdown()
	notify(PVEEvent.Altman_Shutdown)
end



function PVEFactory.GetAltMan()
	return AltMan.new();
end
-- altMan end