
autoImport("Table_Rune");

local table_Rune = Table_Rune;
local cost = {};
Astrolabe_GetPointCost = function (guid)
	local sData = table_Rune[ guid ];
	if(sData == nil)then
		return;
	end

	TableUtility.ArrayClear(cost);

	local costCfg = sData.Cost;
	for i=1,#costCfg do
		if(costCfg[i][2] > 0)then
			table.insert(cost, costCfg[i]);
		end
	end
	return cost;
end

Astrolabe_GetPointResetCost = function (guid)
	local sData = table_Rune[ guid ];
	if(sData == nil)then
		return;
	end

	TableUtility.ArrayClear(cost);

	local costCfg = sData.ResetCost;
	for i=1,#costCfg do
		if(costCfg[i][2] > 0)then
			table.insert(cost, costCfg[i]);
		end
	end
	return cost;
end


-------------------------------------------------------------------
Astrolabe_PointData = class("Astrolabe_PointData")

Astrolabe_PointData_State = {
	Lock = 1,
	Off = 2,
	On = 3,
}

local Astrolabe_DirMap = { 
	{0, 1, 0}, 
	{-0.8660254, 0.5, 0}, 
	{-0.8660254, -0.5, 0}, 
	{0, -1, 0}, 
	{0.8660254, -0.5, 0}, 
	{0.8660254, 0.5, 0} 
}


-- PreHandle Table_Rune

-- PreHandle Table_Rune


function Astrolabe_PointData:ctor(plateid, pointid, bordData)
	self.plateid = plateid;
	self.id = pointid;
	self:SetStaticData();
	self.bordData = bordData;

	self.guid = self.plateid * 10000 + pointid;

	self:SetState(Astrolabe_PointData_State.Lock);
end


-- posInfo begin
function Astrolabe_PointData:ReInitPosData(connectData, originPos)
	self.connectData = connectData;
	self.originPos = originPos;

	if(self.id == 0)then
		self.pos_Width = 0;

		self.pos_x = 0;
		self.pos_y = 0;
		self.pos_z = 0;
	else
		self.pos_Width = math.floor((self.id-1)/6) + 1;

		local index = self.id % 6;
		index = index == 0 and 6 or index;
		local dir = Astrolabe_DirMap[index];
		
		self.pos_x = dir[1] * self.pos_Width * AstrolabeProxy_Plate_Length;
		self.pos_y = dir[2] * self.pos_Width * AstrolabeProxy_Plate_Length;
		self.pos_z = dir[3] * self.pos_Width * AstrolabeProxy_Plate_Length;
	end
end

function Astrolabe_PointData:GetLocalPos_XYZ()
	return self.pos_x, self.pos_y, self.pos_z;
end

function Astrolabe_PointData:GetWorldPos_XYZ()
	return self.originPos[1] + self.pos_x, self.originPos[2] + self.pos_y, self.originPos[3] + self.pos_z;
end

function Astrolabe_PointData:GetInnerConnect()
	if(self.connectData)then
		return self.connectData[1];
	end
end

function Astrolabe_PointData:GetOuterConnect()
	if(self.connectData)then
		return self.connectData[2];
	end
end
-- posInfo end




-- pro data begin
function Astrolabe_PointData:UpdateLockState(bordData)
	if(self.state == Astrolabe_PointData_State.On)then
		return;
	end

	local isOff = false;
	if(self.connectData)then
		local innerConnect = self.connectData[1];
		for i=1,#innerConnect do
			local id = self.plateid * 10000 + innerConnect[i];
			local pointData = bordData:GetPointByGuid(id);
			if(pointData:IsActive())then
				isOff = true;
				break;
			end
		end
		if(isOff ~= true)then
			local outerConnect = self.connectData[2];
			for i=1,#outerConnect do
				local pointData = bordData:GetPointByGuid(outerConnect[i]);
				if(pointData:IsActive())then
					isOff = true;
					break;
				end
			end
		end
		if(isOff)then
			self:SetState(Astrolabe_PointData_State.Off);
			return;
		end
	end
	
	self:SetState(Astrolabe_PointData_State.Lock);
end

function Astrolabe_PointData:SetPropData(pData)
	self.propData = pData;
end

function Astrolabe_PointData:SetStaticData(sData)
	self.staticData = sData;
end

function Astrolabe_PointData:GetCost()
	return Astrolabe_GetPointCost(self.guid);
end

function Astrolabe_PointData:GetResetCost()
	return Astrolabe_GetPointResetCost(self.guid);
end

function Astrolabe_PointData:GetPropData()
	return self.propData;
end

function Astrolabe_PointData:SetState(state)
	self.state = state;

	if(self.bordData)then
		self.bordData:RefreshPointState(self.guid, state);
	end
end

function Astrolabe_PointData:SetOldState(state)
	self.oldstate = state;
end

function Astrolabe_PointData:GetState(isold)
	if(isold)then
		return self.oldstate;
	end
	return self.state;
end

function Astrolabe_PointData:SetActive(b)
	if(b)then
		self:SetState(Astrolabe_PointData_State.On);
	else
		self:SetState(Astrolabe_PointData_State.Lock);
	end
end

function Astrolabe_PointData:IsActive(isold)
	if(isold and self.oldstate~=nil)then
		return self.oldstate == Astrolabe_PointData_State.On;
	end
	return self.state == Astrolabe_PointData_State.On;
end

function Astrolabe_PointData:GetName()
	if(self.propData)then
		return self.propData[2];
	end
end

function Astrolabe_PointData:GetIconIndex()
	if(self.propData)then
		return self.propData[3] or 1;
	end
end

function Astrolabe_PointData:GetEffect()
	if(self.propData)then
		return self.propData[4];
	end
end

function Astrolabe_PointData:GetSpecialEffect()
	if(self.propData)then
		return self.propData[5];
	end
end
-- pro data end
