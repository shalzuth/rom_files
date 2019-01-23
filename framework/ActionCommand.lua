ActionCommand = class("ActionCommand", pm.SimpleCommand)

function ActionCommand:execute(note)
	local role = note.body.role;
	if(role)then
		local action = note.body.action;
		local num = note.body.num;
		local normalizedTime = note.body.normalizedTime;
		if(note.name == ActionEvent.PlayEmojiAction)then
			local data = Table_ActionAnime[action];
			if(data)then
				self:RolePlayEmojiAction(role, data);
			end
		elseif(note.name == ActionEvent.PlayStateAction)then
			self:RolePlayStateAction(role, action);
		elseif(note.name == ActionEvent.PlayNormalAction)then
			local data = Table_ActionAnime[action];
			if(data)then
				self:RolePlayNormalAction(role, data.Name, num, normalizedTime);
			end
		end
	end
end

function ActionCommand:RolePlayEmojiAction(role, data)
	if(data)then
		-- if(role~=Game.Myself)then
		-- 	RoleControllerInterface.ServerEmotionAction(role, data.Name);
		-- else
		-- 	FunctionEmotionAction.Me():Launch(data.Name)
		-- end
	end
end

function ActionCommand:RolePlayStateAction(role, id)
	if(role~=Game.Myself)then
		local statename = string.format("state%d", id);
		printOrange(string.format("player:%s State Anim:%s", tostring(role.gameObject.name), statename));
		RoleControllerInterface.ServerAction(role,statename);
	end
end

function ActionCommand:RolePlayNormalAction(role, name, num, normalizedTime)
	num = num or 1;
	normalizedTime = normalizedTime or 0;
	if(role~=Game.Myself)then
		RoleControllerInterface.ServerAction(role,name, num, normalizedTime);
	else
		role:Action(name, num, normalizedTime);
	end
end