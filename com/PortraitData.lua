PortraitData = class("PortraitData")

-- 目前只有性别会影响头像 相框
function PortraitData:ctor(sex)
	sex = sex or 1;
	self.allPortraits = {};

	self.manPortraits = {};
	self.manPortraits[1] = {}
	self.manPortraits[2] = {}
	self.otherPortraits = {};
	
	self.allFrame = {};
	for k,v in pairs(Table_HeadImage) do
		if(v.Type == 3)then
			self.allFrame[k] = v;
			v.Lock = 1;
		else
			-- if(v.sex == nil or v.sex == sex)then
				self.allPortraits[k] = v;
				v.Lock = 1;
				if(v.Type == 1)then
					if(v.sex~=nil) then
						self.manPortraits[v.sex][k] = v
					else
						self.manPortraits[1][k] = v
						self.manPortraits[2][k] = v
					end
				elseif(v.Type == 2)then
					self.otherPortraits[k] = v;
				end
			-- end
		end
	end
end

function PortraitData:UnlockPortrait(id)
	local data = self.allPortraits[id];
	if(data~=nil)then
		data.Lock = 0;
	end
end

function PortraitData:UnlockFrame(id)
	local data = self.allFrame[id];
	if(data~=nil)then
		data.Lock = 0;
	end
end

function PortraitData:GetPortrait(id)
	return self.allPortraits[id];
end

function PortraitData:GetFrame(id)
	return self.allFrame[id];
end

function PortraitData:GetManPortraits(sex)
	sex = sex or 1
	return self.manPortraits[sex]
end

function PortraitData:GetOrderManPortraits(sex)
	sex = sex or 1
	local manPortraits = self.manPortraits[sex]
	local result = {}
	for k,v in pairs(manPortraits)do
		result[#result+1] = v
	end
	table.sort(result, function (a, b)
		if(a.Lock~=b.Lock)then
			return a.Lock < b.Lock;
		end
		return a.id < b.id;
	end);
	return result;
end

function PortraitData:GetOrderOtherPortraits()
	local result = {}
	for k,v in pairs(self.otherPortraits)do
		table.insert(result, v);
	end
	table.sort(result, function (a, b)
		if(a.Lock~=b.Lock)then
			return a.Lock < b.Lock;
		end
		return a.id < b.id;
	end);
	return result;
end

function PortraitData:GetOrderFrames()
	local result = {}
	for k,v in pairs(self.allFrame)do
		table.insert(result, v);
	end
	table.sort(result, function (a, b)
		if(a.Lock~=b.Lock)then
			return a.Lock < b.Lock;
		end
		return a.id < b.id;
	end);
	return result;
end