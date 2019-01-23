SimpleGuildData = reusableClass("SimpleGuildData")

SimpleGuildData.PoolSize = 50;

function SimpleGuildData:SetData(data)
	self.id = data[1];
	self.name = data[2];
	self.job = data[4];
	local iconId = data[3];
	if(iconId == "")then
		iconId = "1";
	end
	if(iconId)then
		local sps = string.split(iconId,"_")
		iconId = sps[1]
		local cfgIconId = tonumber(iconId);
		if(sps[2])then
			self.customIconUpTime = tonumber(sps[2])
			self.picType = sps[3]
			if(self.customIconUpTime)then
				self.customIconIndex = cfgIconId
			end
			self.icon = nil;
		else
			local iconCfg = cfgIconId and Table_Guild_Icon[cfgIconId];
			self.icon = iconCfg and iconCfg.Icon or iconId;
			self.customIconIndex = nil
			self.customIconUpTime = nil 
			self.picType = nil 
		end		
		
	else
		self.icon = nil;
		self.customIconIndex = nil
		self.customIconUpTime = nil 
		self.picType = nil 
	end
	
end

-- override begin
-- data(id, name, icon, job) 
function SimpleGuildData:DoConstruct(asArray)
	self.id = nil;
	self.name = nil;
	self.icon = nil;
	self.job = nil;
	self.customIconIndex = nil
	self.customIconUpTime = nil 
	self.picType = nil 
end

function SimpleGuildData:DoDeconstruct(asArray)
	
end
-- override end