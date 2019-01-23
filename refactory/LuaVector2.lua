local setmetatable=setmetatable
local getmetatable=getmetatable
local type=type
local clamp=clamp
local acos=math.acos
local sin=math.sin
local cos=math.cos
local sqrt=math.sqrt
local error=error
local min=math.min
local max=math.max
local abs=math.abs
local pow=math.pow
local Time=UnityEngine.Time

local ToAngle=57.29578
local ToRad=0.01745329
local Epsilon=0.00001
local Infinite=1/0
local Sqrt2=0.7071067811865475244008443621048490
local PI=3.14159265358979323846264338327950
local destroy = ReusableTable.DestroyVector2

local function clamp(v,min,max)
	return v>max and max or (v<min and min or v)
end

local function  lerpf(a,b,t)
	t=clamp(t,0,1)
	return a+(b-a)*t
end

local LuaVector2={__typename='Vector2'}
local T=LuaVector2
local I={__typename='Vector2',__typeReuse = true}
_G['LuaVector2']=LuaVector2
local get={}
local set={}

LuaVector2.__index = function(t,k)
	local f=rawget(LuaVector2,k)
	if f then return f end
	local f=rawget(get,k)
	if f then return f(t) end
	error('Not found '..k)
end

LuaVector2.__newindex = function(t,k,v)
	local f=rawget(set,k)
	if f then return f(t,v) end
	error('Not found '..k)
end

local creator = ReusableTable.CreateVector2
function LuaVector2.New(x,y)
	local v,newCreate = creator()
	if(newCreate) then
		v[1],v[2] = x or 0,y or 0
		setmetatable(v,I)
	else
		v:Set(x,y)
	end
	-- local v = {x or 0,y or 0}
	-- 	setmetatable(v,I)

	return v
end

LuaVector2.__call = function(t,x,y)
	return LuaVector2.New(x,y)
end

I.__tostring = function(self)
	return string.format('LuaVector2(%f, %f)',self[1],self[2])
end

I.__index = function(t,k)
	local f=rawget(I,k)
	if f then return f end
	local f=rawget(get,k)
	if f then return f(t) end
	error('Not found '..k)
end

I.__newindex = function(t,k,v)
	local f=rawget(set,k)
	if f then return f(t,v) end
	error('Not found '..k)
end

I.__add = function( a,b )
	return LuaVector2.New(a[1]+b[1],a[2]+b[2])
end

I.__sub = function( a,b )
	return LuaVector2.New(a[1]-b[1],a[2]-b[2])
end

I.__mul = function( a,b )
	return LuaVector2.New(a[1]*b,a[2]*b)
end

I.__div = function( a,b )
	return LuaVector2.New(a[1]/b,a[2]/b)
end

I.__unm = function( a )
	return LuaVector2.New(-a[1],-a[2])
end

function I:ToString()
	return self:__tostring()
end

function I:Clone()
	return LuaVector2.New(self[1],self[2])
end
	
function I:Set(x,y)	
	self[1],self[2]=x or 0,y or 0
end

function LuaVector2.Equal(a,b)
	return abs(a[1]-b[1])<Epsilon
	 	and abs(a[2]-b[2])<Epsilon
end

function I:Equal(b)
	return abs(self[1]-b[1])<Epsilon
	 	and abs(self[2]-b[2])<Epsilon
end

function LuaVector2.Mul(self,b)
	self[1],self[2]=self[1]*b,self[2]*b
end

function LuaVector2.Better_Mul(a,b,t)
	t[1],t[2]=a[1]*b,a[2]*b
end

function I:Mul(b)	
	self[1],self[2]=self[1]*b,self[2]*b
end

function LuaVector2.Add(self,b)
	self[1],self[2]=self[1]+b[1],self[2]+b[2]
end

function LuaVector2.Better_Add(a,b,t)
	t[1],t[2]=a[1]+b[1],a[2]+b[2]
end

function I:Add(b)	
	self[1],self[2]=self[1]+b[1],self[2]+b[2]
end

function LuaVector2.Sub(self,b)
	self[1],self[2]=self[1]-b[1],self[2]-b[2]
end

function LuaVector2.Better_Sub(a,b,t)
	t[1],t[2]=a[1]-b[1],a[2]-b[2]
end

function I:Sub(b)	
	self[1],self[2]=self[1]-b[1],self[2]-b[2]
end

function LuaVector2.Div(self,b)
	self[1],self[2]=self[1]/b,self[2]/b
end

function LuaVector2.Better_Div(a,b,t)
	t[1],t[2]=a[1]/b,a[2]/b
end

function I:Div(b)	
	self[1],self[2]=self[1]/b,self[2]/b
end

function LuaVector2.MulVector(self,a,b)
	self[1],self[2]=a[1]*b[1],a[2]*b[2]
end

function LuaVector2.AddVector(self,a,b)
	self[1],self[2]=a[1]+b[1],a[2]+b[2]
end

function LuaVector2.SubVector(self,a,b)
	self[1],self[2]=a[1]-b[1],a[2]-b[2]
end

function LuaVector2.DivVector(self,a,b)
	self[1],self[2]=a[1]/b[1],a[2]/b[2]
end

function get.one() return LuaVector2.New(1,1) end
function get.zero() return LuaVector2.New(0,0) end
function get.up() return LuaVector2.New(0,1) end
function get.right() return LuaVector2.New(1,0) end
function get:magnitude() return sqrt(self[1]^2+self[2]^2) end
function get:sqrMagnitude() return self[1]^2+self[2]^2 end
function get:normalized() 
	local m = self.magnitude
	return LuaVector2.New(self[1]/m,self[2]/m)
end
function get:x() return self[1] end
function get:y() return self[2] end
function set:x(v) self[1]=v	end
function set:y(v) self[2]=v	end

-- inherite(Vector2,Raw)

function LuaVector2:Clone()
	return LuaVector2.New(self[1],self[2])
end

function LuaVector2.Magnitude(v)
	return sqrt(v[1]^2+v[2]^2)
end

function LuaVector2.SqrMagnitude(v)
	return v[1]^2+v[2]^2
end

function LuaVector2.Angle(a,b)
	local mab = sqrt(a[1]^2+a[2]^2)*sqrt(b[1]^2+b[2]^2)
	return acos(clamp(a[1]*b[1]/mab + a[2]*b[2]/mab,-1,1))*ToAngle
	-- return Vector2.Angle(a,b)
end

function LuaVector2.Normalized(v)
	local m = sqrt(v[1]^2+v[2]^2)
	if m==1 then
		return v
	elseif m>Epsilon then
		v[1],v[2]=v[1]/m,v[2]/m
	else
		v:Set(0,0)
	end
	return v
end

function LuaVector2.Normalize(v)
    local v=LuaVector2.Clone(v)
    LuaVector2.Normalized(v)
    return v
end

function LuaVector2.ClampMagnitude(vector,maxLength)
    if vector.sqrMagnitude > (maxLength^2) then
        return vector.normalized * maxLength
    end
    return LuaVector2.Clone(vector)
end

function LuaVector2.ClampMagnitudeQuick(target,vector,maxLength)
    if vector.sqrMagnitude > (maxLength^2) then
    	local m = maxLength / vector.magnitude
    	target:Set(vector[1]*m,vector[2]*m)
    else
    	target:Set(vector[1],vector[2])
    end
    return target
end

function LuaVector2.Dot(a,b)
	return a[1]*b[1] + a[2]*b[2]
end

function LuaVector2.Distance(a,b)
	local x = a[1]-b[1]
	local y = a[2]-b[2]
	return math.sqrt(x ^ 2 + y ^ 2)
end

function LuaVector2.Lerp(a,b,t)
	t = clamp(t,0,1)
	return LuaVector2.New(a[1]+(b[1]-a[1])*t
		,a[2]+(b[2]-a[2])*t
	)
end

function LuaVector2.Better_Lerp(a,b,c,t)
	t = clamp(t,0,1)
	c[1],c[2] = a[1]+(b[1]-a[1])*t,a[2]+(b[2]-a[2])*t
	return c
end

function I:LerpTo(b,t)
	t = clamp(t,0,1)
	self[1],self[2]= self[1]+(b[1]-self[1])*t,self[2]+(b[2]-self[2])*t
end

function LuaVector2.LerpUnclamped(a,b,t)
	return LuaVector2.New(a[1]+(b[1]-a[1])*t
		,a[2]+(b[2]-a[2])*t
	)
end

function LuaVector2.Better_LerpUnclamped(a,b,c,t)
	c[1],c[2] = a[1]+(b[1]-a[1])*t,a[2]+(b[2]-a[2])*t
	return c
end

function I:LerpUnclampedTo(b,t)
	self[1],self[2]= self[1]+(b[1]-self[1])*t,self[2]+(b[2]-self[2])*t
end

function LuaVector2.Min(a,b)
	return LuaVector2.New(min(a[1],b[1]),min(a[2],b[2]))
end

function LuaVector2.Better_Min(a,b,c)
	c[1],c[2] = min(a[1],b[1]),min(a[2],b[2])
	return c
end

function LuaVector2.Max(a,b)
	return LuaVector2.New(max(a[1],b[1]),max(a[2],b[2]))
end

function LuaVector2.Better_Max(a,b,c)
	c[1],c[2] = max(a[1],b[1]),max(a[2],b[2])
	return c
end

function LuaVector2.MoveTowards(a,b,adv)
	local v = b - a
	local m = sqrt(v[1]^2+v[2]^2)
	if m>adv and m~=0 then
		v[1],v[2] = v[1]/m,v[2]/m
		v[1],v[2] = v[1]*adv,v[2]*adv
		v[1],v[2] = v[1]+a[1],v[2]+a[2]
		return v
	end
	return LuaVector2.Clone(b)
end

local towardHelper = LuaVector2.New(0,0,0)
function LuaVector2.SelfMoveTowards(self,b,adv)
	LuaVector2.Better_Sub(b,self,towardHelper)
	local m = sqrt(towardHelper[1]^2+towardHelper[2]^2)
	if m>adv and m~=0 then
		towardHelper[1],towardHelper[2] = towardHelper[1]/m,towardHelper[2]/m
		towardHelper[1],towardHelper[2] = towardHelper[1]*adv,towardHelper[2]*adv
		self[1],self[2] = towardHelper[1]+self[1],towardHelper[2]+self[2]
		return self
	end
	self[1],self[2] = b[1],b[2]
	return self
end

function LuaVector2.Better_MoveTowards(a,b,t,adv)
	LuaVector2.Better_Sub(b,a,t)
	local m = sqrt(t[1]^2+t[2]^2)
	if m>adv and m~=0 then
		t[1],t[2] = t[1]/m,t[2]/m
		t[1],t[2] = t[1]*adv,t[2]*adv
		t[1],t[2] = t[1]+a[1],t[2]+a[2]
		return t
	end
	t[1],t[2] = b[1],b[2]
	return t
end

local cSmoothDamp = VectorHelper.Vector2SmoothDamp
function LuaVector2._SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	if(maxSpeed) then
		if(deltaTime) then
			return cSmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime,0,0,0,0)
		else
			return cSmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,0,0,0,0)
		end
	end
	return cSmoothDamp(current,target,currentVelocity,smoothTime,0,0,0,0)
end

local _SmoothDamp = LuaVector2._SmoothDamp
function LuaVector2.SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	--may be fast
	-- local x,y 
	-- if(maxSpeed) then
	-- 	if(deltaTime) then
	-- 		x,y = cSmoothDamp(current,target,currentVelocity[1],currentVelocity[2],smoothTime,maxSpeed,deltaTime,0,0)
	-- 	else
	-- 		x,y = cSmoothDamp(current,target,currentVelocity[1],currentVelocity[2],smoothTime,maxSpeed,0,0)
	-- 	end
	-- 	return LuaVector2(x,y)
	-- end
	-- x,y = cSmoothDamp(current,target,currentVelocity[1],currentVelocity[2],smoothTime,0,0)
	-- return LuaVector2(x,y)
	return LuaVector2(_SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime))
end

function LuaVector2.SelfSmoothDamp(self,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	currentVelocity[1],currentVelocity[2],self[1],self[2] = _SmoothDamp(self,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	return self
end

function LuaVector2.Better_SmoothDamp(current,target,t,currentVelocity,smoothTime,maxSpeed,deltaTime)
	currentVelocity[1],currentVelocity[2],t[1],t[2] = _SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	return t
end

function LuaVector2.Magnitude( v )
	return sqrt(v[1]^2+v[2]^2)
end

function LuaVector2:Set( x,y )
	self[1],self[2]=x,y
end

function LuaVector2:ToString( )
	return LuaVector2.__tostring(self)
end

local destroyer = ReusableTable.DestroyVector2
function I:Destroy()
	destroyer(self)
end

setmetatable(LuaVector2,LuaVector2)