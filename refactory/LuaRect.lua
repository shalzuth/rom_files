LuaRect = class("LuaRect")

function LuaRect:ctor(x,y,width,height)
	self.m_XMin = 0
	self.m_YMin = 0
	self.m_Width = 0
	self.m_Height = 0

	self.xMax = 0
	self.yMax = 0

	self:SetPos_XY(x,y)
	self:SetSize_WH(width,height)
end

function LuaRect:SetPos_XY(x,y)
	self.m_XMin = x;
	self.m_YMin = y;
	self:_ResetXYMax()
end

function LuaRect:SetPos(vector2)
	self:SetPos_XY(vector2[1],vector2[2])
end

function LuaRect:SetSize_WH(width,height)
	self.m_Width = width;
	self.m_Height = height;
	self:_ResetXYMax()
end

function LuaRect:SetSize(vector2)
	self:SetSize_WH(vector2[1],vector2[2])
end

function LuaRect:_ResetXYMax()
	self.xMax = self.m_Width + self.m_XMin
	self.yMax = self.m_Height + self.m_YMin
end

function LuaRect:Contains_3(vector3)
	if(vector3[1] >= self.m_XMin and vector3[1] < self.xMax and vector3[3] >= self.m_YMin and vector3[3] < self.yMax) then
		return true
	end
	return false
end

function LuaRect:Contains_2(vector2)
	if(vector2[1] >= self.m_XMin and vector2[1] < self.xMax and vector2[2] >= self.m_YMin and vector2[2] < self.yMax) then
		return true
	end
	return false
end

function LuaRect:Overlaps(other)
	if(other.xMax > self.m_XMin and other.m_XMin < self.xMax and other.yMax > self.m_YMin and other.m_YMin < self.yMax) then
		return true
	end
	return false
end