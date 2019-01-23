FunctionTest = class("FunctionTest")

function FunctionTest.Me()
	if nil == FunctionTest.me then
		FunctionTest.me = FunctionTest.new()
	end
	return FunctionTest.me
end

function FunctionTest:ctor()
end

function FunctionTest:Reset()
end

function FunctionTest:TestNpcs()
	local testFunc = function (num)
		local map = {}
		for i=1,num do
			local data = SceneMap_pb.MapNpc()
			data.id = 12345 * 100 + i
			data.name = tostring(data.id)
			data.npcID = 1001
			map[data.id] = LNpc.new(data)
			-- map[data.id] = Creature.new(data.id,1)
			-- SceneNpcProxy.Instance:Add(data)
			-- SceneNpcProxy.Instance:Remove(data.id)
			data = nil
		end

		for k,v in pairs(map) do
			v:OnRemove()
		end
		map = {}
	end

	collectgarbage("collect")
	print(string.format("mem %0.2fKB", collectgarbage("count")))
	-- local a = {}
	-- local b = {}
	-- a["cena"] = b
	-- local limit = 1000
	-- for i = 1, limit do
	--     b[tostring(i)] = Creature.new(i,1)
	--     -- a[i] = i
	-- end

	testFunc(300)
	-- testFunc(100)
	-- testFunc(100)

	-- SceneNpcProxy.Instance:Clear()

	print(string.format("mem %0.2fKB", collectgarbage("count")))
	print("----------------------------------------")

	-- erase all its elements
	-- for k, _ in pairs(b) do
	--     b[k] = nil
	-- end

	-- -- trick to force a rehash
	-- for i = limit + 1, limit * 2 do
	--     b[i] = nil
	-- end
	-- b = nil
	-- a=nil
	collectgarbage("collect")

	print(string.format("mem %0.2fKB", collectgarbage("count")))
end