PosUtil = {}
scale = 1000

function PosUtil.IsZero(pos)
	return pos.x == 0 and pos.y == 0 and pos.z == 0
end

function PosUtil.TableToPos(pos)
	return  Vector3(pos[1],pos[2],pos[3])
end

function PosUtil.ScenePosToPos(pos)
	return  Vector3(pos.x,pos.y,pos.z)
end

function PosUtil.DevideScenePosToPos(pos)
	return  Vector3(pos.x/scale,pos.y/scale,pos.z/scale)
end

function PosUtil.Devide(pos)
	return pos/1000
end

function PosUtil.DevideVector3( x,y,z )
	return Vector3(x/scale,y/scale,z/scale)
end

function PosUtil.DevideEulerToQuaternion( x,y,z )
	x = x or 0
	y = y or 0
	z = z or 0
	return Quaternion.Euler(x,y,z)
end

function PosUtil.DevideQuaternion( x,y,z,w )
	return Quaternion(x/scale,y/scale,z/scale,w/scale)
end

function PosUtil.DistanceVector3(a,b)
	local x = a.x-b.x
	local y = a.y-b.y
	local z = a.z-b.z
	return math.sqrt(x * x + y * y + z*z)
end

function PosUtil.DistanceVector2(a,b)
	local x = a.x-b.x
	local z = a.z-b.z
	return math.sqrt(x * x + z * z)
end