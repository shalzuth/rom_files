LuaVector4 = class("LuaVector4")

function LuaVector4.CreateZero()
	return LuaVector.Create(0, 0, 0, 0)
end

function LuaVector4.CreateOne()
	return LuaVector.Create(1, 1, 1, 1)
end

function LuaVector4.Equal(a, b)
	return a[1] == b[1] 
		and a[2] == b[2] 
		and a[3] == b[3]
		and a[4] == b[4]
end