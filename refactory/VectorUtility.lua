VectorUtility = class("VectorUtility")

local tempQuaternion = LuaQuaternion.identity
local tempQuaternion_1 = LuaQuaternion.identity
local tempQuaternion_2 = LuaQuaternion.identity
local tempVector3 = LuaVector3.zero
local tempVector2 = LuaVector2.zero
local tempVector2_1 = LuaVector2.zero

function VectorUtility.Destroy(v)
	if nil ~= v then
		v:Destroy()
	end
	return nil
end

function VectorUtility.AlmostEqual_2(v1, v2)
	for i=1, 2 do
		local diff = v1[i]-v2[i]
		if -0.01 > diff or 0.01 < diff then
			return false
		end
	end
	return true
end

function VectorUtility.AlmostEqual_3(v1, v2)
	for i=1, 3 do
		local diff = v1[i]-v2[i]
		if -0.01 > diff or 0.01 < diff then
			return false
		end
	end
	return true
end

function VectorUtility.AlmostEqual_3_XZ(v1, v2)
	for i=1, 3, 2 do
		local diff = v1[i]-v2[i]
		if -0.01 > diff or 0.01 < diff then
			return false
		end
	end
	return true
end

function VectorUtility.Asign_2(to, from)
	if nil ~= to then
		to:Set(from[1], from[2])
	else
		to = from:Clone()
	end
	return to
end
function VectorUtility.TryAsign_2(to, from)
	if nil == from then
		return to
	end
	return VectorUtility.Asign_2(to, from)
end

function VectorUtility.Asign_3(to, from)
	if nil ~= to then
		to:Set(from[1], from[2], from[3])
	else
		to = from:Clone()
	end
	return to
end
function VectorUtility.TryAsign_3(to, from)
	if nil == from then
		return to
	end
	return VectorUtility.Asign_3(to, from)
end

function VectorUtility.SetXZ_2(v, v2)
	v2[1] = v[1]
	v2[2] = v[3]
end

function VectorUtility.SetXZ_3(v, v3)
	v3[1] = v[1]
	v3[3] = v[2]
end

function VectorUtility.SubXZ_2(a, b, v2)
	v2[1] = a[1]-b[1]
	v2[2] = a[3]-b[3]
end

function VectorUtility.DistanceXZ(a, b)
	local x = a[1]-b[1]
	local z = a[3]-b[3]
	return math.sqrt(x * x + z*z)
end

function VectorUtility.Better_MoveTowardsXZ_2(p1, p2, v2, delta)
	VectorUtility.SetXZ_2(p1, tempVector2)
	VectorUtility.SetXZ_2(p2, tempVector2_1)
	LuaVector2.Better_MoveTowards(
		tempVector2, 
		tempVector2_1, 
		v2, 
		delta)
end

function VectorUtility.AngleYToVector3(angleY)
	local v = LuaVector3.forward
	return VectorUtility.SelfAngleYToVector3(v, angleY)
end

function VectorUtility.SelfAngleYToVector3(v, angleY)
	tempVector3:Set(0, angleY, 0)
	tempQuaternion.eulerAngles = tempVector3
	LuaQuaternion.Better_MulVector3(tempQuaternion, v, v)
	return v
end

function VectorUtility.SelfLookAt(v, p)
	return VectorUtility.Better_LookAt(v, v, p)
end

function VectorUtility.Better_LookAt(v, t, p)
	LuaVector3.Better_Sub(p, v, tempVector3)
	tempQuaternion:Set(0,0,0,1)
	tempQuaternion:SetLookRotation(tempVector3)
	tempQuaternion:Better_GetEulerAngles(t)
	return t
end

function VectorUtility.TryLerpAngleUnclamped_3(cur, from, to, progress)
	if nil ~= from and nil ~= to then
		tempQuaternion.eulerAngles = from
		tempQuaternion_1.eulerAngles = to
		LuaQuaternion.Better_LerpUnclamped(tempQuaternion,tempQuaternion_1,tempQuaternion_2,progress )
		tempQuaternion_2:Better_GetEulerAngles(tempVector3)
		return VectorUtility.Asign_3(cur, tempVector3)
	end
	return VectorUtility.TryAsign_3(cur, to)
end

function VectorUtility.Better_Bezier(p1, p2, p3, p, t)
	local u = 1 - t
	local tt = t * t
	local tu = 2 * t * u
	local uu = u * u
	p[1] = uu * p1[1] + tu * p2[1] + tt * p3[1]
	p[2] = uu * p1[2] + tu * p2[2] + tt * p3[2]
	p[3] = uu * p1[3] + tu * p2[3] + tt * p3[3]
	return p
end

function VectorUtility.Better_Mul_XYZ(a,x,y,z,t)
	t[1] = a[1]*x
	t[2] = a[2]*y
	t[3] = a[3]*z
end

function VectorUtility.Better_Add_XYZ(a,x,y,z,t)
	t[1] = a[1]+x
	t[2] = a[2]+y
	t[3] = a[3]+z
end