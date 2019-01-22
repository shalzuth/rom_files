--?????????????????????ID????????????????????????????????????????????????????????????
UserData = reusableClass("UserData")
UserData.PoolSize = 100

autoImport("ProtoCommon_pb")

local TableClear = TableUtility.TableClear

if(UserData.CacheEUSERkey==nil) then 
	UserData.CacheEUSERkey = {}
end

local GetKey = function (attribute)
	local key = UserData.CacheEUSERkey[attribute]
	if(key==nil) then
		key = ProtoCommon_pb["EUSERDATATYPE_"..attribute]
		UserData.CacheEUSERkey[attribute] = key
	end
	return key
end

function UserData:ctor()
	UserData.super.ctor(self)
	self.hasDirtyDatas = false
	self.datas = {}
	self.bytes = {}
	self.dirtyIDs = {}
end

function UserData:Reset()
	self.hasDirtyDatas = false
	TableClear(self.dirtyIDs)
	TableClear(self.datas)
	TableClear(self.bytes)
end

-- etc, id=ProtoCommon_pb.EUSERDATATYPE_ACCESSORY
function UserData:GetById(id)
	return self.datas[id]
end

function UserData:Get(attribute)
	return self.datas[GetKey(attribute)]
end

function UserData:GetBytes(attribute)
	return self.bytes[GetKey(attribute)]
end

function UserData:Set(attribute,value,bytes)
	self:SetByID(GetKey(attribute),value,bytes)
end

-- etc, id=ProtoCommon_pb.EUSERDATATYPE_ACCESSORY
function UserData:SetByID(id,value,bytes)
	-- print("set",id,value)
	self.datas[id] = value
	self.bytes[id] = bytes
end

function UserData:Update(attribute,value,bytes)
	local id = GetKey(attribute)
	self:UpdateByID(id,value,bytes)
end

function UserData:DirtyUpdateByID(id,value,bytes)
	local old = self.datas[id]
	if(old~=value) then
		self.datas[id] = value
		if(self.dirtyIDs[id]==nil) then
			self.dirtyIDs[id] = old or value
		end
		self.hasDirtyDatas = true
	end
end

-- etc, id=ProtoCommon_pb.EUSERDATATYPE_ACCESSORY
function UserData:UpdateByID(id,value,bytes)
	-- print("update",id,value)
	if(id == 53)then
		printRed("Update Follow :"..tostring(value));
	end
	local old = self.datas[id]
	self.datas[id] = value
	self.bytes[id] = bytes
	return old
end

-- override begin
function UserData:DoConstruct(asArray, parts)
end

function UserData:DoDeconstruct(asArray)
	self:Reset()
end
-- override end

UDEnum = {
	NAME = "NAME",
	ADDICT = "ADDICT",
	AGIPOINT = "AGIPOINT",
	BODY = "BODY",
	DEXPOINT = "DEXPOINT",
	HAIR = "HAIR",
	EYE = "EYE",
  	MOUNT = "MOUNT",
  	MOUTH = "MOUTH",
	INTPOINT = "INTPOINT",
	JOBEXP = "JOBEXP",
	JOBLEVEL = "JOBLEVEL",
	LUKPOINT = "LUKPOINT",
	MAPID = "MAPID",
	MAX = "MAX",
	MIN = "MIN",
	OFFLINETIME = "OFFLINETIME",
	ONLINETIME = "ONLINETIME",
	PACKAGE = "PACKAGE",
	PROFESSION = "PROFESSION",
	LEFTHAND = "LEFTHAND",
	RIGHTHAND = "RIGHTHAND",
	ROLEEXP = "ROLEEXP",
	ROLELEVEL = "ROLELEVEL",
	SEX = "SEX",
	STRPOINT = "STRPOINT",
	TOTALPOINT = "TOTALPOINT",
	USERDATA = "USERDATA",
	VITPOINT = "VITPOINT",
	-- WING = "WING",
	DIAMOND = "DIAMOND",
  	SILVER = "SILVER",
  	GOLD  = "GOLD",
  	GARDEN = "GARDEN",
	MORA = "MORA",
  	LABORATORY="LABORATORY",
  	SKILL_POINT ="SKILL_POINT",
  	NORMAL_SKILL = "NORMAL_SKILL",
  	COLLECT_SKILL = "COLLECT_SKILL",
  	TRANS_SKILL = "TRANS_SKILL",
  	STATUS = "STATUS",
  	DESTPROFESSION = "DESTPROFESSION",
  	BODYSCALE = "BODYSCALE",
  	EQUIPMASTER = "EQUIPMASTER",
  	REFINEMASTER = 'REFINEMASTER',
  	HAIRCOLOR = "HAIRCOLOR",
  	EYECOLOR = "EYECOLOR",
	CLOTHCOLOR = "CLOTHCOLOR",
	PORTRAIT = "PORTRAIT",
	FRAME = "FRAME",
	HEAD = "HEAD",
	FACE = "FACE",
	BACK = "BACK",
	TAIL = "TAIL",
	BATTLEPOINT = "BATTLEPOINT",
	RAIDID = "RAIDID",
	PET_PARTNER = "PET_PARTNER",
	ANGLE = "ANGLE",
	FOLLOWID = "FOLLOWID",
	SAVEMAP = "SAVEMAP",

	MUSIC_CURID = "MUSIC_CURID",
	MUSIC_START = "MUSIC_START",
	MUSIC_LOOP = "MUSIC_LOOP",
	MUSIC_DEMAND = "MUSIC_DEMAND",
	
	GIFTPOINT = "GIFTPOINT",
	KILLERNAME = "KILLERNAME",
	DROPBASEEXP = "DROPBASEEXP",
	HANDID = "HANDID",
	TWINS_ACTIONID = "TWINS_ACTIONID",
	HASCHARGE = "HASCHARGE",
	-- PRAY_LIFE = "PRAY_LIFE",
	-- PRAY_FIGHT = "PRAY_FIGHT",
	-- PRAY_HUNT = "PRAY_HUNT",
	-- PRAY_INT = "PRAY_INT",

	SHADERCOLOR = "SHADERCOLOR",

	QUERYTYPE = "QUERYTYPE",

	TREESTATUS = "TREESTATUS",

	ZONEID = "ZONEID",
	FRIENDSHIP = "FRIENDSHIP",
	ALPHA = "ALPHA",
	QUOTA = "QUOTA",
	QUOTA_LOCK = "QUOTA_LOCK",
	PVP_COLOR = "PVP_COLOR",
	NORMALSKILL_OPTION = "NORMALSKILL_OPTION",
	FASHIONHIDE = "FASHIONHIDE",
	CONTRIBUTE = "CONTRIBUTE",
	PVPCOIN = "PVPCOIN",
	LOTTERY = "LOTTERY",
	TUTOR_PROFIC = "TUTOR_PROFIC",
	PEAK_EFFECT = "PEAK_EFFECT",
	
	-- Food
	COOKER_EXP = "COOKER_EXP",
	COOKER_LV = "COOKER_LV",
	TASTER_EXP = "TASTER_EXP",
	TASTER_LV = "TASTER_LV", 
	SATIETY = "SATIETY",
	OPTION = "OPTION",
	GUILDHONOR = "GUILDHONOR",

	EQUIP_OFF = "EQUIP_OFF",
	EQUIP_BREAK = "EQUIP_BREAK",
	CUR_MAXJOB = "CUR_MAXJOB",
	JOY = "JOY",
	MARITAL = "MARITAL",
	QUERYWEDDINGTYPE = "QUERYWEDDINGTYPE",
	DIVORCE_ROLLERCOASTER = "DIVORCE_ROLLERCOASTER",
	EQUIPED_WEAPON = "EQUIPED_WEAPON",
	
	-- servant
	SERVANTID = "SERVANTID",
	FAVORABILITY = "FAVORABILITY",
	BOOTH_SCORE = "BOOTH_SCORE",
  
	SELLDISCOUNT = "SELLDISCOUNT",
}