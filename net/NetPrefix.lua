using "RO.Net"

autoImport ("ProtobufPool")
-- some class
require "Script.Net.NetConfig"
require "Script.Net.NetProtocol"

-- protos
autoImport("protobuf")
require "Script.Net.Protos.Proto_Include"

SceneUser_pb.UserAttr.PoolNum = 600
SceneUser_pb.UserData.PoolNum = 600
SceneUser2_pb.BufferData.PoolNum = 250
