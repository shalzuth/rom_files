require("Script.Main.FilePath")
require("Script.Main.Import")
require("Script.Main.init")
require("Script.Net.NetPrefix")
autoImport("protobuf")
autoImport("person_pb")
TestNetProtocolVSPb = {}
function TestNetProtocolVSPb.MessageToString(t)
  local s = ""
  if t == nil then
    return "nil"
  end
  for key, value in pairs(t) do
  end
  return s
end
function TestNetProtocolVSPb.TestPb()
  local msg = SceneUser_pb.UserSyncCmd()
  local data = SceneUser_pb.UserData()
  data.value = 213342523
  data.type = ProtoCommon_pb.EUSERDATATYPE_ROLELEVEL
  table.insert(msg.datas, data)
end
function TestNetProtocolVSPb.TestProtocol()
  Data = {
    {name = "uid", type = "uint8"},
    {name = "result", type = "uint4"},
    {name = "num", type = "uint4"},
    {
      name = "pets",
      type = {
        {name = "armpos", type = "int4"},
        {name = "guid", type = "uint8"},
        {name = "petid", type = "int4"},
        {name = "stars", type = "int4"}
      },
      lenFrom = "num"
    }
  }
  local person = {}
  person.uid = 1
  person.result = 1
  person.num = 2
  person.pets = {}
  local data1 = {}
  data1.armpos = 1
  data1.guid = 1
  data1.petid = 1
  data1.stars = 1
  table.insert(person.pets, data1)
  local data2 = {}
  data2.armpos = 1
  data2.guid = 1
  data2.petid = 1
  data2.stars = 1
  table.insert(person.pets, data2)
  local bytes, object
  local start = os.clock()
  for i = 1, 10000 do
    bytes = NetProtocol.PackStruct(Data, person)
  end
  start = os.clock()
  for i = 1, 10000 do
    _, object = NetProtocol.UnpackStruct(Data, bytes, 0)
  end
end
