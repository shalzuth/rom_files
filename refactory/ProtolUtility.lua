ProtolUtility = class("ProtolUtility")

local SC_Scale = 1000.0

function ProtolUtility.S2C_Vector3(p)
	return LuaVector3.New(p.x/SC_Scale, p.y/SC_Scale, p.z/SC_Scale)
end
function ProtolUtility.Better_S2C_Vector3(p, ret)
	ret:Set(p.x/SC_Scale, p.y/SC_Scale, p.z/SC_Scale)
	return ret
end

function ProtolUtility.C2S_Vector3(p, ret)
	ret.x = math.floor(p[1] * SC_Scale)
	ret.y = math.floor(p[2] * SC_Scale)
	ret.z = math.floor(p[3] * SC_Scale)
end

function ProtolUtility.S2C_Number(v)
	return v / SC_Scale
end

function ProtolUtility.C2S_Number(v)
	return math.floor(v * SC_Scale)
end