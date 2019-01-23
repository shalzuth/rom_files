ServicePlayerActionCommand = class("ServicePlayerActionCommand",pm.SimpleCommand)

function ServicePlayerActionCommand:execute(note)
	local data = note.body
	if(data ~=nil) then
		-- helplog(string.format("PlayAction: playeid:%s, type:%s, value:%s, delay:%s", 
		-- 	tostring(data.charid), tostring(data.type) , tostring(data.value), tostring(data.delay)));
		local type = data.type;
		local value = data.value;
		local delay = data.delay and tonumber(data.delay);

		if(delay and delay > 0)then
			LeanTween.delayedCall(delay/1000, function ()
				self:DoServerPlayerBeheavior( data.charid, type, value );
			end)
		else
			self:DoServerPlayerBeheavior( data.charid, type, value );
		end
	end
end

function ServicePlayerActionCommand:DoServerPlayerBeheavior( playerid, type, value )
	local player;
	if 0 == playerid then
		player = Game.Myself
	else
		player = SceneCreatureProxy.FindCreature(playerid)
	end
	if(not player)then
		return;
	end

	if(type == SceneUser2_pb.EUSERACTIONTYPE_ADDHP) then

		player:PlayHpUp()
		if(player == Game.Myself) then
			local trans = player.assetRole:GetEPOrRoot(RoleDefines_EP.Chest)
			local pos = LuaVector3.zero

			pos:Set(LuaGameObject.GetPosition(trans))
			SkillLogic_Base.ShowDamage_Single(
				CommonFun.DamageType.Normal, 
				value, 
				pos, 
				HurtNumType.HealNum, 
				HurtNumColorType.Treatment, 
				player)

			pos:Destroy()
		end
		GameFacade.Instance:sendNotification(SceneUserEvent.EatHp, value);

	elseif(type == SceneUser2_pb.EUSERACTIONTYPE_EXPRESSION)then

		local emojiLength = #Table_Expression;
		local emojiId = tonumber(value);
		if(emojiId)then
			if(Table_Expression[emojiId] == nil)then
				if(emojiId>700)then
					emojiId = emojiId - 700;
				end
				if(emojiId > emojiLength)then
					emojiId = emojiId % emojiLength;
					if(emojiId <= 0)then
						emojiId = 1;
					end
				end
			end
			GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, { emoji = emojiId, roleid = player.data.id });
		end

	elseif(type ==  SceneUser2_pb.EUSERACTIONTYPE_MOTION)then

		local actionid = tonumber(value);
		if(actionid and Table_ActionAnime[actionid])then
			local actionName = Table_ActionAnime[actionid].Name;
			player:Server_PlayActionCmd(actionName, nil, true);
		end

	elseif(type ==  SceneUser2_pb.EUSERACTIONTYPE_NORMALMOTION)then
		
		local actionid = tonumber(value);
		if(actionid and Table_ActionAnime[actionid])then
			local actionName = Table_ActionAnime[actionid].Name;
			player:Server_PlayActionCmd(actionName, nil, false);
		end

	elseif(type ==  SceneUser2_pb.EUSERACTIONTYPE_GEAR_ACTION)then

		local actionid = tonumber(value);
		if(actionid)then
			local actionName = string.format("state%d", actionid);
			player:Server_PlayActionCmd(actionName, nil, false);
		end
	elseif(type == SceneUser2_pb.EUSERACTIONTYPE_DIALOG)then
		if(playerid == Game.Myself.data.id)then
			GameFacade.Instance:sendNotification(MyselfEvent.AddWeakDialog, DialogUtil.GetDialogData(value));
		end
	end
end


