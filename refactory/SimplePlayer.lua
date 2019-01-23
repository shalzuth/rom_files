SimplePlayer = class('SimplePlayer')

function SimplePlayer:ctor(id)
	self.id = id;

	self.userData = UserData.CreateAsTable()
	self.props = RolePropsContainer.new()

end

function SimplePlayer:SetName(name)
	self.name = name;
end

function SimplePlayer:SetGuildInfo(guildid, guildname, guildiconid, guildjob)
	local change = false;
	if(guildid and self.guildid~=guildid)then
		change = true;
		self.guildid = guildid;
	end
	if(guildname and self.guildname~=guildname)then
		change = true;
		self.guildname = guildname;
	end
	if(not self.guildid or self.guildid == 0)then
		self.guildicon = nil;
	else
		if(guildiconid and guildiconid~=self.guildiconid)then
			change = true;
			guildiconid = tonumber(guildiconid);
			guildiconid = guildiconid or 1;
			self.guildicon = Table_Guild_Icon[guildiconid].Icon;
		end
		if(not self.guildicon)then
			self.guildicon = Table_Guild_Icon[1].Icon;
		end
	end
	if(guildjob and self.guildjob~=guildjob)then
		change = true;
		self.guildjob = guildjob;
	end
end

function SimplePlayer:SetDatas( userData ,update)
	update = update or false
	for i = 1, #userData do
		if userData[i] ~= nil then
			if(update) then
				self.userData:UpdateByID(userData[i].type,userData[i].value,userData[i].data)
			else
				self.userData:SetByID(userData[i].type,userData[i].value,userData[i].data)
			end
		end
	end
end

function SimplePlayer:SetProps( props ,update)
	local printStr = "";
	for i = 1, #props do
		if props[i] ~= nil then
			self.props:SetValueById(props[i].type,props[i].value)

			-- local prop = self.props:GetPropByID(props[i].type);
			-- printStr = string.format(" %s | type:%s value:%s", printStr, prop.propVO.displayName, prop:GetValue());
		end
	end
	-- printRed("SimplePlayer Props:"..printStr);
end

















