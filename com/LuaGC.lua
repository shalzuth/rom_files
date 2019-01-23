LuaGC = class("LuaGC")

function LuaGC.SnapShot()
	local snapshot = require "snapshot"
	return snapshot.Call()
end

function LuaGC.CompareSnapShot(s1,s2)
	local tmp = {}
	for k,v in pairs(s2) do
		if s1[k] == nil then
			print(k,v)
		end
	end
end

function LuaGC.TakeSnapShotToCompare()
	local snap = LuaGC.SnapShot()
	if(LuaGC.lastSnapShot) then
		LuaGC.CompareSnapShot(LuaGC.lastSnapShot,snap)
	end
	LuaGC.lastSnapShot = snap
end

function LuaGC.StartLuaGC()
end

function LuaGC.CallLuaGC()
	Debug_LuaMemotry.Debug()
	collectgarbage("collect")
	LuaGC.CreatureAddCount = 0
	LuaGC.CreatureRemoveCount = 0
end
