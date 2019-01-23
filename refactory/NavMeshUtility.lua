NavMeshUtility = class("NavMeshUtility")

local NavMesh_DefaultSampleRange = 1
local NavMesh_DefaultRacastDistance = 100

function NavMeshUtility.Sample(p, range)
	local newP = p:Clone()
	return NavMeshUtility.SelfSample(newP, range)
end

function NavMeshUtility.SelfSample(p, range)
	return NavMeshUtility.Better_Sample(p, p, range)
end

function NavMeshUtility.Better_Sample(p, newP, range)
	local ret = false
	if nil == range then
		range = NavMesh_DefaultSampleRange
	end

	if(p == nil or type(p[1]) ~= "number" or type(p[2]) ~= "number" or type(p[3]) ~= "number")then
		error("NavMeshUtility P is Null");
		return false, LuaGeometry.Const_V3_zero;
	end

	ret, newP[1], newP[2], newP[3] = NavMeshUtils.SamplePositionWithRange(p, range)
	return ret, newP
end

function NavMeshUtility.RaycastDirection(p, dir, distance)
	local newP = p:Clone()
	return NavMeshUtility.SelfRaycastDirection(newP, dir, distance)
end

function NavMeshUtility.SelfRaycastDirection(p, dir, distance)
	return NavMeshUtility.Better_RaycastDirection(p, p, dir, distance)
end

function NavMeshUtility.Better_RaycastDirection(p, newP, dir, distance)
	local ret = false
	if nil == distance then
		distance = NavMesh_DefaultRacastDistance
	end

	ret, newP[1], newP[2], newP[3] = NavMeshUtils.RaycastDirection(p, dir, distance)
	return ret, newP
end

function NavMeshUtility.SampleDirection(p, dir)
	local newP = p:Clone()
	return NavMeshUtility.SelfSampleDirection(newP, dir)
end

function NavMeshUtility.SelfSampleDirection(p, dir)
	return NavMeshUtility.Better_SampleDirection(p, p, dir)
end

function NavMeshUtility.Better_SampleDirection(p, newP, dir)
	local ret = false
	ret, newP[1], newP[2], newP[3] = NavMeshUtils.SampleDirection(p, dir)
	return ret, newP
end
