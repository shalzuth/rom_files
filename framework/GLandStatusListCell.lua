local BaseCell = autoImport("BaseCell");
GLandStatusListCell = class("GLandStatusListCell", BaseCell);

GLandStatusList_CellEvent_Trace = "GLandStatusList_CellEvent_Trace";

autoImport("GuildHeadCell");

function GLandStatusListCell:Init()
	local guildHeadCellGO = self:FindGO("GuildHeadCell");
	self.headCell = GuildHeadCell.new(guildHeadCellGO);
	self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList);

	self.city_name = self:FindComponent("CityName", UILabel);
	self.guild_name = self:FindComponent("GuildName", UILabel);
	self.status_desc = self:FindComponent("StatusDesc", UILabel);

	self.trace_button = self:FindGO("TraceButton");

	self:AddClickEvent(self.trace_button, function (go)
		self:DoTrace();
	end);

	self.neutralSymbol = self:FindGO("NeutralSymbol");

	self:AddCellClickEvent();
end

function GLandStatusListCell:DoTrace()
	self:PassEvent(GLandStatusList_CellEvent_Trace, self);
end

-- cityid, state, guildid, name, portrait
function GLandStatusListCell:SetData(data)
	if(data == nil)then
		self.gameObject:SetActive(false);
		return;
	end

	self.gameObject:SetActive(true);

	self.data_cityid = data.cityid;
	self.data_guildid = data.guildid;

	local land_config = Table_Guild_StrongHold[ data.cityid ];
	if(land_config ~= nil)then
		self.city_name.text = land_config.Name;
	else
		self.city_name.text = "NO CONFIG LAND:" .. tostring(data.cityid);
	end

	local gland_status_desc = GameConfig.GVGConfig.gland_status_desc or _EmptyTable;
	self.status_desc.text = gland_status_desc[ data.state ] or "NO CONFIG DESC:" .. data.state;

	self.is_neutral = data.name == nil or data.name == "";
	if(self.is_neutral)then
		self.guild_name.text = "[c][6c6c6cff]------------[-][/c]";
	else
		self.guild_name.text = data.name;
	end

	if(data.portrait == "")then
		self.data_portrait = 61;
	else
		local portrait_num = tonumber(data.portrait);
		if(portrait_num == nil)then
			self.data_portrait = data.portrait;
		else
			self.data_portrait = portrait_num;
		end
	end

	self:SetGuildHeadIcon();
end

function GLandStatusListCell:GetMyGuildHeadData()
	if(self.myGuildHeadData == nil)then
		self.myGuildHeadData = GuildHeadData.new();
	end
	self.myGuildHeadData:SetBy_InfoId(self.data_portrait);
	self.myGuildHeadData:SetGuildId(self.data_guildid);

	return self.myGuildHeadData;
end

function GLandStatusListCell:SetGuildHeadIcon()
	if(self.is_neutral)then
		self.headCell:SetData(nil);
		self.neutralSymbol:SetActive(true);
		return;
	end

	self.neutralSymbol:SetActive(false);
	self.headCell:SetData(self:GetMyGuildHeadData());
end