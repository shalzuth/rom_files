require "Script.Main.FilePath"
require "Script.Main.Import"
require "Script.Main.init"
require "Script.Net.NetPrefix"

autoImport("protobuf")
autoImport("person_pb")

TestNetProtocolVSPb = {}

function TestNetProtocolVSPb.MessageToString(t)
	-- return ""
	local s = "" 
	if t == nil then
		return "nil"
	end

	for key, value in pairs(t) do
		print("dsadsad "..tostring(key))
		print("dsadsad "..tostring(value))

		-- if type(value) ~= "table" then	
		-- 	if value ~= nil then
		-- 		if string.len(tostring(value)) > 0 then
		-- 			s = s..tostring(key).."_"..tostring(value).."\n"
		-- 		else
		-- 			s = s..tostring(key).."_".." ".."\n"
		-- 		end
		-- 	else
		-- 		s = s..key.."_".."nil".."\n"
		-- 	end
		-- else
		-- 	s = s..key.."_"..NetProtocol.TableToString(value)
		-- end
	end
	return s
end

function TestNetProtocolVSPb.TestPb()
	print(jit and "jit on" or "jit off, pls run test with luajit")

	local msg = SceneUser_pb.UserSyncCmd()
	local data = SceneUser_pb.UserData()
	data.value = 213342523
	data.type = ProtoCommon_pb.EUSERDATATYPE_ROLELEVEL	
	table.insert(msg.datas, data)	

	print(TestNetProtocolVSPb.MessageToString(data))

	-- local str = data:SerializeToString()
	-- str = NetUtil.BytesToString(NetUtil.CharsToBytes(str, #str))



	-- msg.a = 1
	-- table.insert(msg.attrs, SceneUser_pb.UserAttr())

	-- local attr = SceneUser_pb.UserAttr()
	-- attr.type = 2
	-- table.insert(msg.attrs, attr)

	-- local d = SceneUser_pb.UserData()
	-- d.type = 2
	-- table.insert(msg.datas, d)

	-- d = SceneUser_pb.UserData()
	-- d.type = 10
	-- table.insert(msg.datas, d)

	-- str = msg:SerializeToString()
	-- print("xxxxx: "..str)


	-- local msg1 = SceneUser_pb.UserTest()
	-- msg1:ParseFromString(str)
	-- print("xxxxx: "..msg1.a)
	-- print("xxxxx: "..msg1.attrs[2].type)
	-- print("xxxxx: "..msg1.datas[1].type)
	-- print("xxxxx: "..msg1.datas[2].type)

	-- protobuf
	-- local person = person_pb.Data()
	-- person.uid = 1
	-- person.result = 1

	-- local data1 = person_pb.Data2()
	-- data1.armpos = 1
	-- data1.guid = 1
	-- data1.petid = 1
	-- data1.stars = 1
	-- table.insert(person.pets, data1)

	-- local data2 = person_pb.Data2()
	-- data2.armpos = 1
	-- data2.guid = 1
	-- data2.petid = 1
	-- data2.stars = 1
	-- table.insert(person.pets, data2)

	-- local bytes
	-- local object

	-- local start = os.clock()

	-- for i=1,10000 do
	-- 	bytes = person:SerializeToString()
	-- end
	-- print(#bytes)
	-- print(bytes)
	-- print("object to bytes : " .. (os.clock()
 -- - start))

	-- start = os.clock()

	-- for i=1,10000 do
	-- 	object = person_pb.Data()
	-- 	object:ParseFromString(bytes)
	-- end
	-- print("bytes to object : " .. (os.clock()
 -- - start))
end

function TestNetProtocolVSPb.TestProtocol()
	print(jit and "jit on" or "jit off, pls run test with luajit")
	
	Data = {
		{name="uid",type="uint8"},
		{name="result", type="uint4"},
		{name="num", type="uint4"},
		{name="pets", type={
			{name="armpos",type="int4"},
			{name="guid",type="uint8"},
			{name="petid",type="int4"},
			{name="stars",type="int4"}
		}, lenFrom="num"}
	}

	-- protocol
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

	local bytes
	local object

	local start = os.clock()

	for i=1,10000 do
		bytes = NetProtocol.PackStruct(Data, person)
	end
	print(bytes.Length)
	print("object to bytes : " .. (os.clock()
 - start))

	start = os.clock()

	for i=1,10000 do
		_, object = NetProtocol.UnpackStruct(Data, bytes, 0)
	end
	print("bytes to object : " .. (os.clock()
 - start))
end
