FunctionPet = class("FunctionPet")

function FunctionPet.Me()
	if nil == FunctionPet.me then
		FunctionPet.me = FunctionPet.new()
	end
	return FunctionPet.me
end

function FunctionPet:ctor()
	self.cameraFocus = true;
	self.petEffectMap = {};
	
	self:MapEvent();
end

function FunctionPet:MapEvent()
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.SceneAddPets, self);
	EventManager.Me():AddEventListener(SceneUserEvent.SceneRemovePets, self.SceneRemovePets, self);

	EventManager.Me():AddEventListener(MyselfEvent.SkillGuideBegin,self.HandleStartSkill,self)
	EventManager.Me():AddEventListener(MyselfEvent.SkillGuideEnd,self.HandleStopSkill,self)
end

function FunctionPet:SceneAddPets(pets)
	if(pets)then
		for i=1,#pets do
			local nPet = pets[i];
			if(nPet:IsMyPet())then
				if(nPet.data:IsPet())then
					self:AddMyPet(nPet);
				elseif(nPet.data:IsCatchNpc_Detail())then
					self:AddMyCatchPet(nPet);
				end
			end
		end
	end
end

function FunctionPet:AddMyPet(nPet)
	if(nPet)then
		local petInfoData = PetProxy.Instance:GetMyPetInfoData();
		if(petInfoData)then
			self:RewardExpChange(petInfoData, nil, petInfoData.rewardexp);
		end
	end
end

function FunctionPet:AddMyCatchPet(nPet)
	if(nPet:IsMyPet() and nPet.data:IsCatchNpc_Detail())then
		if(self.catchPetguid ~= nil)then
			self:RemoveMyCatchPet(self.catchPetguid);
		end

		self.catchPetguid = nPet.data.id;

		local trigger = {};
		trigger.id = self.catchPetguid;
		trigger.pos = nPet:GetPosition();
		trigger.reachDis = GameConfig.Pet.CatchTip_Range or 6;
		trigger.type = AreaTrigger_Common_ClientType.CatchPet;
		Game.AreaTrigger_Common:AddCheck(trigger)

		-- QuickUseProxy.Instance:AddCatchPetData( {nPet.data.id, self.captureData} );
	end
end

function FunctionPet:SceneRemovePets(petids)
	if(petids)then
		for i=1,#petids do
			self:RemoveMyCatchPet(petids[i]);
		end
	end
end

function FunctionPet:RemoveMyCatchPet(pegguid)
	if(pegguid and pegguid == self.catchPetguid)then
		Game.AreaTrigger_Common:RemoveCheck(pegguid)
		QuickUseProxy.Instance:RemoveCatchPetData(pegguid);

		self.catchPetguid = nil;
		self.captureData = nil;
	end
end

local rot_V3 = LuaVector3();
function FunctionPet:HandleStartSkill(skill)
	if(self.cameraFocus == false)then
		return;
	end

	if(skill and skill:GetSkillType() == "TouchPet")then
		local npet = PetProxy.Instance:GetMySceneNpet();
		if(npet)then
			local trans = npet.assetRole.completeTransform
			local viewPort = CameraConfig.FoodEat_ViewPort
			rot_V3:Set(CameraConfig.FoodEat_Rotation_OffsetX, CameraConfig.FoodEat_Rotation_OffsetY, 0);

			self.cft = CameraEffectFocusAndRotateTo.new(trans, nil, viewPort, rot_V3, CameraConfig.UI_Duration);
			FunctionCameraEffect.Me():Start(self.cft);
		end
	end
end

function FunctionPet:HandleStopSkill(skill)
	if(skill and skill:GetSkillType() == "TouchPet")then
		if(self.cft)then
			FunctionCameraEffect.Me():End(self.cft);
			self.cft = nil;
		end
	end
end

function FunctionPet:SetCameraFoucus(b)
	self.cameraFocus = b;
end


local CatchEffectMap = {
	{0, "Common/catchstep1", true},
	{30, "Common/catchstep2", true},
	{60, "Common/catchstep3", true},
	{100, "Common/catchstep4", true},
}
function FunctionPet:CatchValueChange(npcguid, value, from_npcid)
	if(npcguid ~= self.catchPetguid)then
		return;
	end

	if(self.captureData == nil)then
		self.captureData = Table_Pet_Capture[from_npcid];
		QuickUseProxy.Instance:AddCatchPetData( npcguid, {npcguid, self.captureData});
	end

	local nPet = NScenePetProxy.Instance:Find(npcguid);
	if(nPet == nil)then
		helplog("CatchValueChange Nil!!!!!!!!!");
		return;
	end

	local interval_min = CatchEffectMap[1][2];
	local effectName = CatchEffectMap[1][2];
	local interval;

	local index = 1;
	for i=#CatchEffectMap, 1, -1 do
		if(value >= CatchEffectMap[i][1])then
			index = i;
			break;
		end
	end

	local effect = self.petEffectMap[npcguid];
	if(effect)then
		effect:Destroy();
	end

	if CatchEffectMap[index][3] then
		effect = nPet.assetRole:PlayEffectOn( CatchEffectMap[index][2], RoleDefines_EP.Chest);
	else
		effect = nPet.assetRole:PlayEffectOneShotOn( CatchEffectMap[index][2], RoleDefines_EP.Chest);
	end
	effect:RegisterWeakObserver(self);
	
	self.petEffectMap[npcguid] = effect;
end

function FunctionPet:ObserverDestroyed(obj)
	for k,effect in pairs(self.petEffectMap)do
		if(obj == effect)then
			self.petEffectMap[k] = nil;
			break;
		end
	end
end

function FunctionPet:DoCatch( npcguid )
	local nPet = NScenePetProxy.Instance:Find(npcguid);
	if(nPet == nil)then
		return;
	end

	if(self.captureData == nil)then
		return;
	end

	local itemData = Table_Item[ self.captureData.GiftItemID ];
	local range = itemData and itemData.ItemTarget.range or 0;

	local myPos, targetPos = Game.Myself:GetPosition(), nPet:GetPosition();
	local inRange = LuaVector3.Distance(myPos ,targetPos) <= range;

	if(not inRange)then
		Game.Myself:Client_AccessTarget(nPet, npcguid, nil, AccessCustomType.CatchPet, range);
	else
		ServiceScenePetProxy.Instance:CallCatchPetPetCmd(npcguid, false)
	end
end

function FunctionPet:CatchResult(npcguid, success)
	local nPet = NScenePetProxy.Instance:Find(npcguid);
	local result_viewdata = {
		view = PanelConfig.SlotMachineView,
		viewdata = {
			npcguid = npcguid, 
			npcid = nPet and nPet.data.staticData.id,
			success = success
		},
	};
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, result_viewdata);
end

function FunctionPet:CatchEnd(npcguid, npcid, success)
	if(self.captureData == nil)then
		return;
	end

	if(not success)then
		return;
	end

	local result_viewdata = {};
	
	local item = BagProxy.Instance:GetItemByStaticID(self.captureData.EggID);
	if(item == nil)then
		item = BagProxy.Instance:GetItemByStaticID(self.captureData.EggID, BagProxy.BagType.Temp);
	end

	if(self.captureData.PetID)then
		result_viewdata.view = PanelConfig.PetMakeNamePopUp;
		result_viewdata.viewdata = {etype = 1, item = item};
	else
		result_viewdata.view = PanelConfig.PetCatchSuccessView;
		result_viewdata.viewdata = item;
	end

	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, result_viewdata);
end

function FunctionPet:ShowPetTip(playerData, closecallback, stick, side, offset)
	local playerTip = FunctionPlayerTip.Me():GetPlayerTip(stick, side, offset);
	local tipData = { playerData = playerData };
	tipData.funckeys = { "Pet_GiveGift","Pet_Touch", "Pet_Hug", "Pet_CallBack","Pet_ShowDetail","Pet_AutoFight" };

	local handFollowerId = Game.Myself:Client_GetHandInHandFollower();
	local myPetInfo = PetProxy.Instance:GetMyPetInfoData(playerData.petid);
	if(handFollowerId~=0 and handFollowerId == myPetInfo.guid)then
		tipData.funckeys[3] = "Pet_CancelHug";
	end

	playerTip:SetData(tipData);
	playerTip.closecallback = closecallback;

	local s1 = string.format(ZhString.MainViewHeadPage_Name, playerData.name);
	local s2 = string.format(ZhString.MainViewHeadPage_Master, Game.Myself.data.name);
	local s3 = string.format(ZhString.MainViewHeadPage_Friend, playerData.friendlv);
	playerTip:SetDesc(s1, s2, s3);
end

function FunctionPet:RefreshRwardExp()
	local petInfoData = PetProxy.Instance:GetMyPetInfoData();
	if(petInfoData)then
		self:RewardExpChange(petInfoData, petInfoData.rewardexp, petInfoData.rewardexp);
	end
end

local Reward_ItemId = 5503;
function FunctionPet:RewardExpChange(petInfoData, oldvalue, newvalue)
	local giftValue = GameConfig.Pet.userpet_gift_reqvalue or 100;

	local newCan = newvalue >= giftValue;

	local dirty = false;
	if(oldvalue == nil or oldvalue == 0)then
		dirty = true;
	else
		local oldCan = oldvalue >= giftValue
		dirty = oldCan ~= newCan;
	end

	if(dirty)then
		if(newCan)then
			local limitCfg = Table_Item[Reward_ItemId].GetLimit;
			if(limitCfg.limit)then
				self.waitShow = true;
				ServiceItemProxy.Instance:CallGetCountItemCmd(Reward_ItemId, nil, ProtoCommon_pb.ESOURCE_PET);
			else
				self:PlayRewardGetEffect(true);
			end
		else
			self:PlayRewardGetEffect(false);
		end
	end
end

function FunctionPet:SetRewardItemCount(itemid, count, source)
	if(itemid == Reward_ItemId and source == ProtoCommon_pb.ESOURCE_PET)then
		self.rewardCount = count or 0;

		local limitCfg = Table_Item[Reward_ItemId].GetLimit;
		local mylv = MyselfProxy.Instance:RoleLevel();
		local limitCount = ItemData.Get_GetLimitCount(itemid);
		if(self.rewardCount >= limitCount)then
			self:PlayRewardGetEffect(false);
		else
			if(self.waitShow)then
				self.waitShow = false;
				self:PlayRewardGetEffect(true);
			end
		end
	end
end

function FunctionPet:GetPetGift(creatuerid)
	local creature = SceneCreatureProxy.FindCreature(creatuerid);
	if(creature)then
		local petid = creature.data.staticData.id;
		ServiceScenePetProxy.Instance:CallGetGiftPetCmd(petid);
	end
end

function FunctionPet:PlayRewardGetEffect(show)
	local scenePet = PetProxy.Instance:GetMySceneNpet();
	if(scenePet)then
		local sceneUI = scenePet:GetSceneUI();
		if(sceneUI)then
			if(show)then
				sceneUI.roleTopUI:SetTopGiftSymbol("PetGift", self.GetPetGift, self);
			else
				sceneUI.roleTopUI:RemoveTopGiftSymbol();
			end
		end
	end
end

function FunctionPet:DoResetSkill(itemid)
	ServiceScenePetProxy.Instance:CallResetSkillPetCmd(itemid)
end
