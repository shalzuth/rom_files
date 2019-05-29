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
  local testFunc = function(num)
    local map = {}
    for i = 1, num do
      local data = SceneMap_pb.MapNpc()
      data.id = 1234500 + i
      data.name = tostring(data.id)
      data.npcID = 1001
      map[data.id] = LNpc.new(data)
      data = nil
    end
    for k, v in pairs(map) do
      v:OnRemove()
    end
    map = {}
  end
  collectgarbage("collect")
  testFunc(300)
  collectgarbage("collect")
end
