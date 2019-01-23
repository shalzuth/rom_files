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

local function clamp(v,min,max)
	return v>max and max or (v<min and min or v)
end

local function  lerpf(a,b,t)
	t=clamp(t,0,1)
	return a+(b-a)*t
end

local Matrix3x3={}
local LuaVector3

function Matrix3x3.SetAt(m,row,col,v)
	m[row*3+col+1]=v
end

function Matrix3x3.New()
	local r={1,0,0,0,1,0,0,0,1}
	setmetatable(r,Matrix3x3)
	return r
end

function Matrix3x3.__tostring(m)
	return string.format('Matrix3x3(%f,%f,%f,%f,%f,%f,%f,%f,%f)'
		,m[1],m[2],m[3]
		,m[4],m[5],m[6]
		,m[7],m[8],m[9])
end

function Matrix3x3.SetAxisAngle(m,axis,rad)
	-- This function contributed by Erich Boleyn (erich@uruk.org) */
	-- This function used from the Mesa OpenGL code (matrix.c)  */
	local s, c
	local vx, vy, vz, xx, yy, zz, xy, yz, zx, xs, ys, zs, one_c

	s = sin (rad)
	c = cos (rad)

	vx = axis[1]
	vy = axis[2]
	vz = axis[3]

	xx = vx * vx
	yy = vy * vy
	zz = vz * vz
	xy = vx * vy
	yz = vy * vz
	zx = vz * vx
	xs = vx * s
	ys = vy * s
	zs = vz * s
	one_c = 1.0 - c
	local Set=Matrix3x3.SetAt
	Set(m,0,0, (one_c * xx) + c )
	Set(m,1,0, (one_c * xy) - zs)
	Set(m,2,0, (one_c * zx) + ys)
	Set(m,0,1, (one_c * xy) + zs)
	Set(m,1,1, (one_c * yy) + c )
	Set(m,2,1, (one_c * yz) - xs)
	Set(m,0,2, (one_c * zx) - ys)
	Set(m,1,2, (one_c * yz) + xs)
	Set(m,2,2, (one_c * zz) + c )
end

function Matrix3x3.Mul(m,v)
	local res=LuaVector3.New(0,0,0)
	res[1] = m[1] * v[1] + m[4] * v[2] + m[7] * v[3]
	res[2] = m[2] * v[1] + m[5] * v[2] + m[8] * v[3]
	res[3] = m[3] * v[1] + m[6] * v[2] + m[9] * v[3]
	return res
end

function Matrix3x3:SetIdentity()
	self[1],self[2],self[3]=1,0,0
	self[4],self[5],self[6]=0,1,0
	self[7],self[8],self[9]=0,0,1
end

function Matrix3x3:SetOrthoNormal( x,y,z )
	self[1],self[2],self[3]=x[1],y[1],z[1]
	self[4],self[5],self[6]=x[2],y[2],z[2]
	self[7],self[8],self[9]=x[3],y[3],z[3]
end

LuaVector3={__typename='Vector3'}
local T=LuaVector3
local I={__typename='Vector3',__typeReuse = true}
_G['LuaVector3']=LuaVector3
local get={}
local set={}

LuaVector3.__index = function(t,k)
	local f=rawget(LuaVector3,k)
	if f then return f end
	local f=rawget(get,k)
	if f then return f(t) end
	error('Not found '..k)
end

LuaVector3.__newindex = function(t,k,v)
	local f=rawget(set,k)
	if f then return f(t,v) end
	error('Not found '..k)
end

local creator = ReusableTable.CreateVector3
LuaVector3.New=function (x,y,z)
	local v,newCreate = creator()
	if(newCreate) then
		v[1],v[2],v[3] = x or 0,y or 0,z or 0
		setmetatable(v,I)
	else
		v[1],v[2],v[3] = x or 0,y or 0,z or 0
		-- v:Set(x,y,z)
	end
	return v
end

LuaVector3.__call = function(t,x,y,z)
	return LuaVector3.New(x,y,z)
end

I.__index = function(t,k)
	local f=rawget(I,k)
	if f then return f end
	local f=rawget(get,k)
	if f then return f(t) end
	-- error('Not found '..k)
end

I.__newindex = function(t,k,v)
	local f=rawget(set,k)
	if f then return f(t,v) end
	error('Not found '..k)
end

I.__unm = function(a)
	local ca=LuaVector3.New(-a[1],-a[2],-a[3])
	return ca
end


I.__tostring = function(self)
	return string.format('LuaVector3(%f, %f, %f)',self[1],self[2],self[3])
end

I.__mul = function(a,b)
	local ta=type(a)
	local tb=type(b)
	if ta=='table' and tb=='number' then
		return LuaVector3.New(a[1]*b,a[2]*b,a[3]*b)
	elseif ta=='number' and tb=='table' then
		return LuaVector3.New(a*b[1],a*b[2],a*b[3])
	else
		error(string.format('unexpect type of arguments, got %s,%s',ta,tb))
	end
end

I.__add = function(a,b)
	return LuaVector3.New(a[1]+b[1],a[2]+b[2],a[3]+b[3])
end

I.__sub = function(a,b)
	return LuaVector3.New(a[1]-b[1],a[2]-b[2],a[3]-b[3])
end

I.__div = function(a,b)
	return LuaVector3.New(a[1]/b,a[2]/b,a[3]/b)
end

function LuaVector3.Equal(a,b)
	return abs(a[1]-b[1])<Epsilon
	 	and abs(a[2]-b[2])<Epsilon
	 	and abs(a[3]-b[3])<Epsilon
end

function I:Equal(b)
	return abs(self[1]-b[1])<Epsilon
	 	and abs(self[2]-b[2])<Epsilon
	 	and abs(self[3]-b[3])<Epsilon
end

function LuaVector3.Mul(self,b)
	self[1],self[2],self[3]=self[1]*b,self[2]*b,self[3]*b
end

function LuaVector3.Better_Mul(a,b,t)
	t[1],t[2],t[3]=a[1]*b,a[2]*b,a[3]*b
end

function I:Mul( b )
	self[1],self[2],self[3]=self[1]*b,self[2]*b,self[3]*b
end

function LuaVector3.Add(self,b)
	self[1],self[2],self[3]=self[1]+b[1],self[2]+b[2],self[3]+b[3]
end

function LuaVector3.Better_Add(a,b,t)
	t[1],t[2],t[3]=a[1]+b[1],a[2]+b[2],a[3]+b[3]
end

function I:Add( b )
	self[1],self[2],self[3]=self[1]+b[1],self[2]+b[2],self[3]+b[3]
end

function LuaVector3.Sub(self,b)
	self[1],self[2],self[3]=self[1]-b[1],self[2]-b[2],self[3]-b[3]
end

function LuaVector3.Better_Sub(a,b,t)
	t[1],t[2],t[3]=a[1]-b[1],a[2]-b[2],a[3]-b[3]
end

function I:Sub( b )
	self[1],self[2],self[3]=self[1]-b[1],self[2]-b[2],self[3]-b[3]
end

function LuaVector3.Div(self,b)
	self[1],self[2],self[3]=self[1]/b,self[2]/b,self[3]/b
end

function LuaVector3.Better_Div(a,b,t)
	t[1],t[2],t[3]=a[1]/b,a[2]/b,a[3]/b
end

function I:Div( b )
	self[1],self[2],self[3]=self[1]/b,self[2]/b,self[3]/b
end

function get.back() return LuaVector3.New(0,0,-1) end
function get.down() return LuaVector3.New(0,-1,0) end
function get.forward() return LuaVector3.New(0,0,1) end
function get.left() return LuaVector3.New(-1,0,0) end
function get.one() return LuaVector3.New(1,1,1) end
function get.right() return LuaVector3.New(1,0,0) end
function get.up() return LuaVector3.New(0,1,0) end
function get.zero() return LuaVector3.New(0,0,0) end

function get:x() return self[1] end
function get:y() return self[2] end
function get:z() return self[3] end
function set:x(v) self[1]=v end
function set:y(v) self[2]=v end
function set:z(v) self[3]=v end
function get:magnitude() return LuaVector3.Magnitude(self) end
function get:sqrMagnitude() return LuaVector3.SqrMagnitude(self) end
function get:normalized() 
	return LuaVector3.Normalize(self)
end

function I:Clone()
	return LuaVector3.New(self[1],self[2],self[3])
end

function LuaVector3:Clone()
	return LuaVector3.New(self[1],self[2],self[3])
end
	
function I:Set(x,y,z)	
	self[1],self[2],self[3]=x or 0,y or 0,z or 0
end

function I:ToString()
	return self:__tostring()
end

function LuaVector3.Angle(a,b)
	local mab = sqrt(a[1]^2+a[2]^2+a[3]^2)*sqrt(b[1]^2+b[2]^2+b[3]^2)
	return acos(clamp(a[1]*b[1]/mab + a[2]*b[2]/mab + a[3]*b[3]/mab,-1,1))*ToAngle
end

function LuaVector3.Normalized(v)
	local m = LuaVector3.Magnitude(v)
	if m==1 then
		return v
	elseif m>Epsilon then
		v[1],v[2],v[3]=v[1]/m,v[2]/m,v[3]/m
	else
		v:Set(0,0,0)
	end
end

function LuaVector3.Normalize(v)
    local v=LuaVector3.Clone(v)
    LuaVector3.Normalized(v)
    return v
end

function I:Normalize()
	LuaVector3.Normalized(self)
end

function LuaVector3.Magnitude(v)
	return sqrt(v[1]^2+v[2]^2+v[3]^2)
end

function LuaVector3.SqrMagnitude(v)
	return v[1]^2+v[2]^2+v[3]^2
end

function LuaVector3.Dot(a,b)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3]
end

function LuaVector3.Cross(a,b)
	return LuaVector3.New((a[2] * b[3]) - (a[3] * b[2])
		, (a[3] * b[1]) - (a[1] * b[3])
		, (a[1] * b[2]) - (a[2] * b[1]))
end

function LuaVector3.Better_Cross(a,b,t)
	t[1],t[2],t[3] = (a[2] * b[3]) - (a[3] * b[2]), (a[3] * b[1]) - (a[1] * b[3]), (a[1] * b[2]) - (a[2] * b[1])
	return t
end

function LuaVector3.OrthoNormalVector(n)
	local res=LuaVector3.New(0,0,0)
	if abs(n[3]) > Sqrt2 then
		local a = n[2]^2 + n[3]^2
		local k = 1 / sqrt (a)
		res[1],res[2],res[3] = 0,-n[3]*k,n[2]*k
	else
		local a = n[1]^2 + n[2]^2
		local k = 1 / sqrt (a)
		res[1],res[2],res[3] = -n[2]*k,n[1]*k,0
	end
	return res
end

local Slerp = VectorHelper.Vector3Slerp
function LuaVector3.Slerp(a,b,t)
	local x,y,z = Slerp(a,b,t,0,0,0)
	return LuaVector3(x,y,z)
end

function LuaVector3.Better_Slerp(a,b,c,t)
	c[1],c[2],c[3] = Slerp(a,b,t,0,0,0)
	return c
end

function I:SlerpTo(b,t)
	self[1],self[2],self[3] = Slerp(self,b,t,0,0,0)
end

local SlerpUnclamped = VectorHelper.Vector3SlerpUnclamped
function LuaVector3.SlerpUnclamped(a,b,t)
	local x,y,z = SlerpUnclamped(a,b,t,0,0,0)
	return LuaVector3(x,y,z)
end

function LuaVector3.Better_SlerpUnclamped(a,b,c,t)
	c[1],c[2],c[3] = SlerpUnclamped(a,b,t,0,0,0)
	return c
end

function I:SlerpUnclampedTo(b,t)
	self[1],self[2],self[3] = SlerpUnclamped(self,b,t,0,0,0)
end

function LuaVector3.Lerp(a,b,t)
	t = clamp(t,0,1)
	return LuaVector3.New(a[1]+(b[1]-a[1])*t
		,a[2]+(b[2]-a[2])*t
		,a[3]+(b[3]-a[3])*t
	)
end

function LuaVector3.Better_Lerp(a,b,c,t)
	t = clamp(t,0,1)
	c[1],c[2],c[3] = a[1]+(b[1]-a[1])*t	,a[2]+(b[2]-a[2])*t	,a[3]+(b[3]-a[3])*t
end

function I:LerpTo(b,t)
	t = clamp(t,0,1)
	self[1],self[2],self[3] = self[1]+(b[1]-self[1])*t,self[2]+(b[2]-self[2])*t,self[3]+(b[3]-self[3])*t
end

function LuaVector3.LerpUnclamped(a,b,t)
	return LuaVector3.New(a[1]+(b[1]-a[1])*t
		,a[2]+(b[2]-a[2])*t
		,a[3]+(b[3]-a[3])*t
	)
end

function LuaVector3.Better_LerpUnclamped(a,b,c,t)
	c[1],c[2],c[3] = a[1]+(b[1]-a[1])*t	,a[2]+(b[2]-a[2])*t	,a[3]+(b[3]-a[3])*t
end

function I:LerpUnclampedTo(b,t)
	self[1],self[2],self[3] = self[1]+(b[1]-self[1])*t,self[2]+(b[2]-self[2])*t,self[3]+(b[3]-self[3])*t
end

function LuaVector3.Min(a,b)
	return LuaVector3.New(min(a[1],b[1]),min(a[2],b[2]),min(a[3],b[3]))
end

function LuaVector3.Better_Min(a,b)
	c[1],c[2],c[3] = min(a[1],b[1]),min(a[2],b[2]),min(a[3],b[3])
end

function LuaVector3.Max(a,b)
	return LuaVector3.New(max(a[1],b[1]),max(a[2],b[2]),max(a[3],b[3]))
end

function LuaVector3.Better_Max(a,b)
	c[1],c[2],c[3] = max(a[1],b[1]),max(a[2],b[2]),max(a[3],b[3])
end

function LuaVector3.MoveTowards(a,b,adv)
	local v = b-a
	local m = sqrt(v[1]^2+v[2]^2+v[3]^2)
	if m>adv and m~=0 then
		v[1],v[2],v[3] = v[1]/m,v[2]/m,v[3]/m
		v[1],v[2],v[3] = v[1]*adv,v[2]*adv,v[3]*adv
		v[1],v[2],v[3] = v[1]+a[1],v[2]+a[2],v[3]+a[3]
		return v
	end
	v:Destroy()
	return LuaVector3.Clone(b)
end

local towardHelper = LuaVector3.New(0,0,0)
function LuaVector3.SelfMoveTowards(self,b,adv)
	LuaVector3.Better_Sub(b,self,towardHelper)
	local m = sqrt(towardHelper[1]^2+towardHelper[2]^2+towardHelper[3]^2)
	if m>adv and m~=0 then
		towardHelper[1],towardHelper[2],towardHelper[3] = towardHelper[1]/m,towardHelper[2]/m,towardHelper[3]/m
		towardHelper[1],towardHelper[2],towardHelper[3] = towardHelper[1]*adv,towardHelper[2]*adv,towardHelper[3]*adv
		self[1],self[2],self[3] = towardHelper[1]+self[1],towardHelper[2]+self[2],towardHelper[3]+self[3]
		return self
	end
	self[1],self[2],self[3] = b[1],b[2],b[3]
	return self
end

function LuaVector3.Better_MoveTowards(a,b,t,adv)
	LuaVector3.Better_Sub(b,a,t)
	local m = sqrt(t[1]^2+t[2]^2+t[3]^2)
	if m>adv and m~=0 then
		t[1],t[2],t[3] = t[1]/m,t[2]/m,t[3]/m
		t[1],t[2],t[3] = t[1]*adv,t[2]*adv,t[3]*adv
		t[1],t[2],t[3] = t[1]+a[1],t[2]+a[2],t[3]+a[3]
		return t
	end
	t[1],t[2],t[3] = b[1],b[2],b[3]
	return t
end

local function ClampedMove(a,b,mag)
	local delta = b-a
	if delta > 0 then
		return a + min (delta, mag)
	else
		return a - min (-delta, mag)
	end
end

local RotateTowards = VectorHelper.Vector3RotateTowards
function LuaVector3.RotateTowards(a,b,angleMove,mag)
	local x,y,z = RotateTowards(a,b,angleMove,mag,0,0,0)
	return LuaVector3(x,y,z)
end

function LuaVector3.SelfRotateTowards(self,b,angleMove,mag)
	self[1],self[2],self[3] = RotateTowards(self,b,angleMove,mag,0,0,0)
	return self
end

function LuaVector3.Better_RotateTowards(a,b,t,angleMove,mag)
	t[1],t[2],t[3] = RotateTowards(a,b,angleMove,mag,0,0,0)
	return t
end

function LuaVector3.Distance(a,b)
	local x = a[1]-b[1]
	local y = a[2]-b[2]
	local z = a[3]-b[3]
	return math.sqrt(x * x + y * y + z*z)
end

function LuaVector3.OrthoNormalize(u,v,w)
	LuaVector3.Normalized(u)

	local dot0 = LuaVector3.Dot(u,v)
	local tu=LuaVector3.Clone(u)
	LuaVector3.Mul(tu,dot0)
	LuaVector3.Sub(v,tu)
	LuaVector3.Normalized(v)

	if w then
		local dot1 = LuaVector3.Dot(v,w)
		local dot0 = LuaVector3.Dot(u,w)
		local tw=I.__mul(u,dot0)
		local tv=I.__mul(v,dot1)
		LuaVector3.Add(tv,tw)
		LuaVector3.Sub(w,tv)
		LuaVector3.Normalized(w)
	end
end

function LuaVector3.Scale(a,b)
	return LuaVector3.New(a[1]*b[1],a[2]*b[2],a[3]*b[3])
end

function LuaVector3.Better_Scale(a,b,t)
	t[1],t[2],t[3] = a[1]*b[1],a[2]*b[2],a[3]*b[3]
end

function I:Scale( self,b )
	return LuaVector3.Scale(self,b)
end

local cSmoothDamp = VectorHelper.Vector3SmoothDamp
function LuaVector3._SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	if(maxSpeed) then
		if(deltaTime) then
			return cSmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime,0,0,0,0,0,0)
		else
			return cSmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,0,0,0,0,0,0)
		end
	end
	return cSmoothDamp(current,target,currentVelocity,smoothTime,0,0,0,0,0,0)
end

local _SmoothDamp = LuaVector3._SmoothDamp
-- code copy from reflactor of UnityEgnine
function LuaVector3.SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	-- local x,y,z
	-- if(maxSpeed) then
	-- 	if(deltaTime) then
	-- 		x,y,z = cSmoothDamp(current,target,currentVelocity[1],currentVelocity[2],currentVelocity[3],smoothTime,maxSpeed,deltaTime,0,0,0)
	-- 	else
	-- 		x,y,z = cSmoothDamp(current,target,currentVelocity[1],currentVelocity[2],currentVelocity[3],smoothTime,maxSpeed,0,0,0)
	-- 	end
	-- 	return LuaVector3(x,y,z)
	-- end
	-- x,y,z = cSmoothDamp(current,target,currentVelocity[1],currentVelocity[2],currentVelocity[3],smoothTime,0,0,0)
	-- return LuaVector3(x,y,z)
	local vx,vy,vz,px,py,pz = _SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	return LuaVector3(vx,vy,vz) ,LuaVector3(px,py,pz) 
end

function LuaVector3.SelfSmoothDamp(self,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	currentVelocity[1],currentVelocity[2],currentVelocity[3],self[1],self[2],self[3] = _SmoothDamp(self,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	return self
end

function LuaVector3.Better_SmoothDamp(current,target,t,currentVelocity,smoothTime,maxSpeed,deltaTime)
	currentVelocity[1],currentVelocity[2],currentVelocity[3],t[1],t[2],t[3] = _SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
	return t
end

-- code copy from reflactor of UnityEgnine
function LuaVector3.ClampMagnitude(vector,maxLength)
    if LuaVector3.SqrMagnitude(vector) > (maxLength^2) then
        return vector.normalized * maxLength
    end
    return LuaVector3.Clone(vector)
end

function LuaVector3.Reflect(dir,nml)
	local dot=LuaVector3.Dot(nml,dir)*-2
	local v=I.__mul(nml,dot)
	LuaVector3.Add(v,dir)
	return v
end

-- code copy from reflactor of UnityEgnine
local cProjectOnPlane = VectorHelper.Vector3ProjectOnPlane
function LuaVector3.ProjectOnPlane(vector,planeNormal)
	local x,y,z = cProjectOnPlane(vector,planeNormal,0,0,0)
	return LuaVector3(x,y,z)
end

-- code copy from reflactor of UnityEgnine
local cProject = VectorHelper.Vector3Project
function LuaVector3.Project( vector,normal )
	-- local x,y,z = cProject(vector,normal,0,0,0)
	-- return LuaVector3(x,y,z)
	-- local num = LuaVector3.Dot(normal, normal)
	local num = normal[1]^2 + normal[2]^2 + normal[3]^2
    if num < Epsilon then
        return LuaVector3.zero
    end
    local res = normal * (vector[1]*normal[1] + vector[2]*normal[2] + vector[3]*normal[3])
    res[1] = res[1]/num
    res[2] = res[2]/num
    res[3] = res[3]/num
    return res
end

local destroyer = ReusableTable.DestroyVector3
function I:Destroy()
	destroyer(self)
end

setmetatable(LuaVector3,LuaVector3)