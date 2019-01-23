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
local DoubleToAngle = ToAngle * 2
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

local LuaQuaternion={__typename='Quaternion'}
local I={__typename='Quaternion',__typeReuse = true}
_G['LuaQuaternion']=LuaQuaternion
local get={}
local set={}

LuaQuaternion.__index = function(t,k)
	local f=rawget(LuaQuaternion,k)
	if f then return f end
	local f=rawget(get,k)
	if f then return f(t) end
	error('Not found '..k)
end

LuaQuaternion.__newindex = function(t,k,v)
	local f=rawget(set,k)
	if f then return f(t,v) end
	error('Not found '..k)
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

I.__tostring = function(self)
	return string.format('LuaQuaternion(%f, %f, %f, %f)',self[1],self[2],self[3],self[4])
end

I.__div = function(a,b)
	return LuaQuaternion.New(a[1]/b,a[2]/b,a[3]/b,a[4]/b)
end

-- reflector code
I.__mul = function(a,b,target)
	if getmetatable(b).__typename=='Vector3' then
		    local vector=LuaVector3.New(0,0,0)
		    local num = a[1] * 2
		    local num2 = a[2] * 2
		    local num3 = a[3] * 2
		    local num4 = a[1] * num
		    local num5 = a[2] * num2
		    local num6 = a[3] * num3
		    local num7 = a[1] * num2
		    local num8 = a[1] * num3
		    local num9 = a[2] * num3
		    local num10 = a[4] * num
		    local num11 = a[4] * num2
		    local num12 = a[4] * num3
		    vector[1] = (((1 - (num5 + num6)) * b[1]) + ((num7 - num12) * b[2])) + ((num8 + num11) * b[3])
		    vector[2] = (((num7 + num12) * b[1]) + ((1 - (num4 + num6)) * b[2])) + ((num9 - num10) * b[3])
		    vector[3] = (((num8 - num11) * b[1]) + ((num9 + num10) * b[2])) + ((1 - (num4 + num5)) * b[3])
		    return vector
	else
		local x,y,z,w =
			(((a[4] * b[1]) + (a[1] * b[4])) + (a[2] * b[3])) - (a[3] * b[2]),
		 	(((a[4] * b[2]) + (a[2] * b[4])) + (a[3] * b[1])) - (a[1] * b[3]),
		 	(((a[4] * b[3]) + (a[3] * b[4])) + (a[1] * b[2])) - (a[2] * b[1]),
		 	(((a[4] * b[4]) - (a[1] * b[1])) - (a[2] * b[2])) - (a[3] * b[3])

		 if target then
		 	target[1],target[2],target[3],target[4]=x,y,z,w
		 else
		 	return LuaQuaternion.New(x,y,z,w)
		 end
	end
end

function LuaQuaternion.Better_MulVector3(q,v,t)
	local num = q[1] * 2
    local num2 = q[2] * 2
    local num3 = q[3] * 2
    local num4 = q[1] * num
    local num5 = q[2] * num2
    local num6 = q[3] * num3
    local num7 = q[1] * num2
    local num8 = q[1] * num3
    local num9 = q[2] * num3
    local num10 = q[4] * num
    local num11 = q[4] * num2
    local num12 = q[4] * num3
    local v1,v2,v3 = v[1],v[2],v[3]
    t[1] = (((1 - (num5 + num6)) * v1) + ((num7 - num12) * v2)) + ((num8 + num11) * v3)
    t[2] = (((num7 + num12) * v1) + ((1 - (num4 + num6)) * v2)) + ((num9 - num10) * v3)
    t[3] = (((num8 - num11) * v1) + ((num9 + num10) * v2)) + ((1 - (num4 + num5)) * v3)
end

function LuaQuaternion.Mul(a,b)
	return I.__mul(a,b,a)
end

-- reflector code
function LuaQuaternion.Equal(a,b)
	return LuaQuaternion.Dot(a,b)>0.999999
end

function I:Equal(b)
	return LuaQuaternion.Dot(self,b)>0.999999
end

local creator = ReusableTable.CreateQuaternion
function LuaQuaternion.New(x,y,z,w)
	local q,newCreate = creator()
	if(newCreate) then
		q[1],q[2],q[3],q[4] = x or 0,y or 0,z or 0,w or 0
		setmetatable(q,I)
	else
		q:Set(x,y,z,w)
	end
	-- local q={x or 0,y or 0,z or 0,w or 0}
	-- setmetatable(q,I)
	return q
end

function LuaQuaternion.__call(t,x,y,z,w)
	return LuaQuaternion.New(x,y,z,w)
end

function get.identity() return LuaQuaternion.New(0,0,0,1)	end
function get:x() return self[1]	end
function get:y() return self[2]	end
function get:z() return self[3]	end
function get:w() return self[4]	end
function set:x(v) self[1]=v	end
function set:y(v) self[2]=v	end
function set:z(v) self[3]=v	end
function set:w(v) self[4]=v	end

local QuaternionGetEulerAngles = VectorHelper.QuaternionGetEulerAngles
function get:eulerAngles()
	return LuaVector3(QuaternionGetEulerAngles(self))
end
local QuaternionSetEulerAngles = VectorHelper.QuaternionSetEulerAngles
function set:eulerAngles(v) 
	self[1],self[2],self[3],self[4] = QuaternionSetEulerAngles(self,v)
end

function I:Better_GetEulerAngles(v)
	v:Set(QuaternionGetEulerAngles(self))
end

function I:Set(x,y,z,w)
	self[1],self[2],self[3],self[4]=x,y,z,w
end

function I:Clone()
	return LuaQuaternion.New(self[1],self[2],self[3],self[4])
end

function LuaQuaternion.Clone(q)
	return LuaQuaternion.New(q[1],q[2],q[3],q[4])
end

local QuaternionAngleAxis = VectorHelper.QuaternionAngleAxis
function LuaQuaternion.AngleAxis(angle,axis)
	return LuaQuaternion(QuaternionAngleAxis(angle,axis))
end

function I:AngleAxis(angle,axis)
	self[1],self[2],self[3],self[4] = QuaternionAngleAxis(angle,axis)
end

local QuaternionToAngleAxis = VectorHelper.QuaternionToAngleAxis
-- function I:ToAngleAxis()
-- 	local angle,x,y,z = QuaternionToAngleAxis(self)
-- 	return angle,LuaVector3(x,y,z)
-- end

function I:ToAngleAxis()
	local angle = acos(self[4])*2
	if abs(angle-0)<Epsilon then
		angle = angle * ToAngle
		return angle,LuaVector3.New(1,0,0)
	end
	angle = angle * ToAngle
	local div = 1/sqrt(1-self[4]^2)
	return angle,LuaVector3.New(self[1]*div,self[2]*div,self[3]*div)
end

local QuaternionInverse = VectorHelper.QuaternionInverse
function LuaQuaternion.Inverse(q)
	return LuaQuaternion(QuaternionInverse(q))
end

function I:Inverse()
	self[1],self[2],self[3],self[4] = QuaternionInverse(q)
end

local SetFromToRotation = VectorHelper.QuaternionSetFromToRotation
function I:SetFromToRotation(from,to)
	self[1],self[2],self[3],self[4] = SetFromToRotation(self,from,to)
end

function LuaQuaternion.FromToRotation(from,to)
	local q = LuaQuaternion.identity
	q:SetFromToRotation(from,to)
	return q
end

function LuaQuaternion.Better_FromToRotation(from,to,target)
	target:SetFromToRotation(from,to)
	return target
end

local SetLookRotation = VectorHelper.QuaternionSetLookRotation
local lookRotUp = LuaVector3.up
function I:SetLookRotation(view,up)
	up = up or lookRotUp
	self[1],self[2],self[3],self[4] = SetLookRotation(self,view,up)
end

function LuaQuaternion.LookRotation(forward,up)
	local q = LuaQuaternion.identity
	q:SetLookRotation(forward,up)
	return q
end

function LuaQuaternion.Better_LookRotation(forward,up,target)
	target:SetLookRotation(forward,up)
	return target
end

local QuaternionEuler = VectorHelper.QuaternionEuler
function LuaQuaternion.Euler( x,y,z )
	return LuaQuaternion(QuaternionEuler(x,y,z))
end

function LuaQuaternion.Better_Euler( q,x,y,z )
	q[1],q[2],q[3],q[4] = QuaternionEuler(q,x,y,z)
end

function LuaQuaternion.EulerTable(euler)
	return LuaQuaternion(QuaternionEuler(euler[1],euler[2],euler[3]))
end

function LuaQuaternion.Angle( a,b )
	-- local f = Quaternion.Dot (a, b);
	return acos (min (abs (a[1]*b[1]+a[2]*b[2]+a[3]*b[3]+a[4]*b[4]), 1)) * DoubleToAngle
end

-- code from reflector unityengine
function LuaQuaternion.Dot( a,b )
	return a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
end

function LuaQuaternion.Normalize(q)
	q=q:Clone()
	local m=LuaQuaternion.Dot(q,q)
	q[1],q[2],q[3],q[4]=q[1]/m,q[2]/m,q[3]/m,q[4]/m
	return q
end

function LuaQuaternion.Normalized(q)
	local m=LuaQuaternion.Dot(q,q)
	q[1],q[2],q[3],q[4]=q[1]/m,q[2]/m,q[3]/m,q[4]/m
	return q
end

function LuaQuaternion.InnerLerpXYZW(q1,q2,t)
	local q1X,q1Y,q1Z,q1W = q1[1],q1[2],q1[3],q1[4]
	local q2X,q2Y,q2Z,q2W = q2[1],q2[2],q2[3],q2[4]
	local dot = q1X * q2X + q1Y * q2Y + q1Z * q2Z + q1W * q2W
	local x,y,z,w
	if dot < 0 then
		x,y,z,w = q1X + t * (-q2X - q1X),
		            q1Y + t * (-q2Y - q1Y),
		            q1Z + t * (-q2Z - q1Z),
		            q1W + t * (-q2W - q1W)
	else
		x,y,z,w = q1X + t * (q2X - q1X),
		            q1Y + t * (q2Y - q1Y),
		            q1Z + t * (q2Z - q1Z),
		            q1W + t * (q2W - q1W)
	end
	dot = x^2 + y^2 + z^2+ w^2
	return x/dot,y/dot,z/dot,w/dot
end

local InnerLerpXYZW = LuaQuaternion.InnerLerpXYZW
function LuaQuaternion.Lerp( q1,q2,t )
	t = clamp(t,0,1)
	return LuaQuaternion(InnerLerpXYZW(q1,q2,t))
end

function LuaQuaternion.Better_Lerp( q1,q2,q3,t )
	t = clamp(t,0,1)
	q3[1],q3[2],q3[3],q3[4] = InnerLerpXYZW(q1,q2,t)
	return q3
end

function I:LerpTo(q2,t)
	t = clamp(t,0,1)
	self[1],self[2],self[3] = InnerLerpXYZW(q1,q2,t)
end

function LuaQuaternion.LerpUnclamped( q1,q2,t )
	return LuaQuaternion(InnerLerpXYZW(q1,q2,t))
end

function LuaQuaternion.Better_LerpUnclamped( q1,q2,q3,t )
	q3[1],q3[2],q3[3],q3[4] = InnerLerpXYZW(q1,q2,t)
	return q3
end

function I:LerpUnclampedTo(q2,t)
	self[1],self[2],self[3] = InnerLerpXYZW(q1,q2,t)
end

local QuaternionSlerp = VectorHelper.QuaternionSlerp
function LuaQuaternion.Slerp( q1,q2,t )
	return LuaQuaternion(QuaternionSlerp(q1,q2,t))
end

function LuaQuaternion.Better_Slerp( q1,q2,q3,t )
	q3[1],q3[2],q3[3],q3[4] = QuaternionSlerp(q1,q2,t)
	return q3
end

function I:SLerpTo(q2,t)
	self[1],self[2],self[3],self[4] = QuaternionSlerp(q1,q2,t)
end

local QuaternionSlerpUnclamped = VectorHelper.QuaternionSlerpUnclamped
function LuaQuaternion.SlerpUnclamped( q1,q2,t )
	return LuaQuaternion(QuaternionSlerpUnclamped(q1,q2,t))
end

function LuaQuaternion.Better_SlerpUnclamped( q1,q2,t )
	q3[1],q3[2],q3[3],q3[4] = QuaternionSlerpUnclamped(q1,q2,t)
	return q3
end

function I:SlerpUnclamped(q2,t)
	self[1],self[2],self[3],self[4] = QuaternionSlerpUnclamped(q1,q2,t)
end

local QuaternionRotateTowards = VectorHelper.QuaternionRotateTowards
function LuaQuaternion.RotateTowards( from,to,maxDegreesDelta )
	return LuaQuaternion(QuaternionRotateTowards(from,to,maxDegreesDelta))
end

function LuaQuaternion.Better_RotateTowards( from,to,target,maxDegreesDelta )
	target[1],target[2],target[3],target[4] = QuaternionRotateTowards(from,to,maxDegreesDelta)
	return target
end

function I:RotateTowards(to,maxDegreesDelta )
	self[1],self[2],self[3],self[4] = QuaternionRotateTowards(self,to,maxDegreesDelta)
end

local destroyer = ReusableTable.DestroyQuaternion
function I:Destroy()
	destroyer(self)
end

setmetatable(LuaQuaternion,LuaQuaternion)