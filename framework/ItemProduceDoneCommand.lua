ItemProduceDoneCommand = class("ItemProduceDoneCommand",pm.SimpleCommand)

function ItemProduceDoneCommand:execute(note)
	local data = note.body;
	local dtype = data.type;
	local npcguid,itemid,playerid,delay = data.npcid, data.itemid, data.charid, data.delay;

	if(type(delay)=="number" and delay>0)then
		LeanTween.delayedCall(delay, function ()
			if(dtype == SceneItem_pb.EPRODUCETYPE_HEAD)then
				self:PlayFashionProduceDoneAnim(npcguid, itemid, playerid);
			elseif(dtype == SceneItem_pb.EPRODUCETYPE_EQUIP)then
				self:PlayEquipProduceDoneAnim(npcguid, itemid, playerid);
			end
		end);
	else
		if(dtype == SceneItem_pb.EPRODUCETYPE_HEAD)then
			self:PlayFashionProduceDoneAnim(npcguid, itemid, playerid);
		elseif(dtype == SceneItem_pb.EPRODUCETYPE_EQUIP)then
			self:PlayEquipProduceDoneAnim(npcguid, itemid, playerid);
		end
	end
end

local tempV3 = LuaVector3();
function ItemProduceDoneCommand._PlayUIEffect( effectHandle, itemData )
	if(effectHandle)then
		local effectGO = effectHandle.gameObject;

		tempV3:Set(0,30,0);
		effectGO.transform.localPosition = tempV3;

		local itemSprite = effectGO:GetComponentInChildren(UISprite);
		if(itemSprite)then
			IconManager:SetItemIcon(itemData.staticData.Icon, itemSprite);
		end
	end
end

function ItemProduceDoneCommand:PlayFashionProduceDoneAnim(npcguid, itemid, playerid)
	local npcRole = SceneCreatureProxy.FindCreature(npcguid);
	local itemData = ItemData.new("Temp", itemid);
	if(npcRole)then
		-- npc播特效
		local sceneUI = npcRole:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:PlaySceneUIEffect(
				GameConfig.Produce.npcSuccessEffect, 
				true,
				ItemProduceDoneCommand._PlayUIEffect,
				itemData);
		end

		-- npc播动作
		local successActionId = GameConfig.Produce.npcSuccessAction;
		local successAnimName = Table_ActionAnime[successActionId] and Table_ActionAnime[successActionId].Name;
		npcRole:Client_PlayAction(successAnimName, nil, false);

		-- npc播表情
		local npcEmojiData = {
			roleid = npcRole.data.id,
			emoji = GameConfig.Produce.npcSuccessExpression,
		};
		GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, npcEmojiData);
	end

	local playerRole = SceneCreatureProxy.FindCreature(playerid);
	if(playerRole)then
		-- 玩家播表情
		local emojiData = {
			roleid = playerRole.data.id,
			emoji = GameConfig.Produce.userSuccessExpression,
		};
		GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, emojiData);
	end

	-- show Item
	if(itemData and playerid == Game.Myself.data.id)then
		itemData = BagProxy.Instance:GetItemByStaticID(itemid);
		FloatAwardView.addItemDatasToShow({itemData});
	end
end

local params = {}
function ItemProduceDoneCommand:PlayEquipProduceDoneAnim(npcguid, itemid, playerid)
	local npcRole = SceneCreatureProxy.FindCreature(npcguid)
	local itemData = ItemData.new("Temp", itemid)
	if(npcRole)then
		-- npc播动作
		local successActionId = GameConfig.EquipMake.npc_action
		local successAnimName = Table_ActionAnime[successActionId] and Table_ActionAnime[successActionId].Name
		npcRole:Client_PlayAction(successAnimName, nil, false)

		-- npc播表情
		local npcEmojiData = {
			roleid = npcRole.data.id,
			emoji = GameConfig.EquipMake.success_emoji,
		};
		GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, npcEmojiData)
	end

	if(playerid == Game.Myself.data.id)then
		itemData = BagProxy.Instance:GetNewestItemByStaticID(itemid);
		if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
			FloatAwardView.addItemDatasToShow({itemData})
		else
			TableUtility.ArrayClear(params)
			params[1] = itemid
			params[2] = itemid
			params[3] = 1
			MsgManager.ShowMsgByIDTable(6, params)
		end
	end
end