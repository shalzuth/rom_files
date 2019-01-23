GuildHeadData = class("GuildHeadData")

GuildHeadData_Type = 
{
	Add = 0,
	Config = 1,
	Custom = 2,	
}

function GuildHeadData:ctor(gtype, id)
	self.type = gtype;
	
	self.id = id;
	if(gtype == GuildHeadData_Type.Config)then
		self.staticData = Table_Guild_Icon[id];
	end
end

function GuildHeadData:SetGuildId(guildid)
	self.guildid = guildid;
end

function GuildHeadData:SetBy_InfoId(infoid)
	if(type(infoid) == "number")then
		self.type = GuildHeadData_Type.Config;
		self.staticData = Table_Guild_Icon[infoid];
	elseif(type(infoid) == "string")then
		local infos = string.split(infoid, "_")

		self.id = tonumber(infos[1]);
		if(self.id == nil)then
			self.type = GuildHeadData_Type.Add;
			return;
		end
		if(infos[2])then
			helplog("SetBy_InfoId infoid:", infoid);
			self.type = GuildHeadData_Type.Custom;
			self.index = self.id;
			self.state = GuildCmd_pb.EICON_PASS;
			self.time = tonumber(infos[2]);
			
			self.pic_type = infos[3];
		else
			self.type = GuildHeadData_Type.Config;
			self.staticData = Table_Guild_Icon[self.id] or Table_Guild_Icon[1];
		end
	end
end

function GuildHeadData:Server_SetInfo(server_iconinfo)
	-- helplog("Server_SetInfo:", server_iconinfo.index, server_iconinfo.state, server_iconinfo.time);
	self.index = server_iconinfo.index;
	self.state = server_iconinfo.state or 0;
	self.time = server_iconinfo.time;
	self.pic_type = server_iconinfo.type;
end

function GuildHeadData:GetInfoId()
	if(self.type == GuildHeadData_Type.Custom)then
		if(self.pic_type and self.pic_type~="")then
			return string.format("%s_%s_%s", tostring(self.index), tostring(self.time), tostring(self.pic_type));
		else
			return string.format("%s_%s", tostring(self.index), tostring(self.time));
		end
	elseif(self.type == GuildHeadData_Type.Config)then
		return self.id;
	end
end