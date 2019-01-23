CDProxy = class('CDProxy', pm.Proxy)

CDProxy.Instance = nil;

CDProxy.NAME = "CDProxy"

CDProxy.CommunalSkillCDID = -1000
CDProxy.CommunalSkillCDSortID = -1

--玩家CD数据管理

function CDProxy:ctor(proxyName, data)
	self.proxyName = proxyName or CDProxy.NAME
	if(CDProxy.Instance == nil) then
		CDProxy.Instance = self
	end
	self:Init()
end

function CDProxy:Init()
	self.cdMap = {}
	self.timeStampMap = {}
	--启动cd 数据刷新
	FunctionCDCommand.Me()
end

function CDProxy:Update()
end

function CDProxy:GetCDMapByType(cdType)
	local map = self.cdMap[cdType]
	if(map == nil) then
		map = {}
		self.cdMap[cdType] = map
	end
	return map
end

function CDProxy:AddCD(cdType,id,time,cdMax,cd)
	-- print("add cd",id,time,cdMax)
	local map = self:GetCDMapByType(cdType)
	local data = map[id]
	if(data) then
		if(cdMax) then
			data.cd = cd or data.cd
			if(data.cdMax) then data.cdMax = math.max(cdMax,data.cdMax)
			else data.cdMax = cdMax end
		else
			if(data.cd and data.cd ==0) then
				data.cd = cd 
			end
		end
	else
		cd = cd or 0
		data = CdData.new(time,cd,cdMax)
		map[id] = data
	end
	return data
end

--技能传入的ID含义是技能Id除以1000 即它的技能大ID
function CDProxy:AddSkillCD(id,time,now,max)
	local sort = math.floor(id/1000)
	local cd = max
	if(cd == nil) then
		local skill = Table_Skill[id]
		if(skill) then
			cd = skill.CD
			if(time and skill.Logic_Param and skill.Logic_Param.real_cd) then
				local serverCD = math.floor((time-ServerTime.ServerTime)/1000)
				if(serverCD>cd+1) then
					cd = serverCD
					now = skill.Logic_Param.real_cd
				end
			end
		end
	end
	self:AddSkillCDBySortID(sort,time,now,cd)
	self.timeStampMap[sort] = ServerTime.ServerTime
end

function CDProxy:AddSkillCDBySortID(sort,time,now,max)
	return self:AddCD(SceneUser2_pb.CD_TYPE_SKILL,sort,time,now,max)
end

function CDProxy:AddItemCD(id,time)
	self:AddCD(SceneUser2_pb.CD_TYPE_ITEM,id,time)
end

function CDProxy:RemoveCD(cdType,id)
	local map = self:GetCDMapByType(cdType)
	map[id] = nil
end

function CDProxy:RemoveSkillCD(id)
	self:RemoveCD(SceneUser2_pb.CD_TYPE_SKILL,id)
end

function CDProxy:RemoveItemCD(id)
	self:RemoveCD(SceneUser2_pb.CD_TYPE_ITEM,id)
end

function CDProxy:IsInCD(cdType,id)
	local map = self:GetCDMapByType(cdType)
	local data = map[id]
	if(data == nil) then return false
	else
		return data:GetCd() >0
	end
	-- return map[id]~=nil
end

function CDProxy:SkillIsInCD(id)
	return self:IsInCD(SceneUser2_pb.CD_TYPE_SKILL,id) or self:IsInCD(SceneUser2_pb.CD_TYPE_SKILL,CDProxy.CommunalSkillCDSortID)
end

function CDProxy:ItemIsInCD(id)
	return self:IsInCD(SceneUser2_pb.CD_TYPE_ITEM,id)
end

function CDProxy:GetCD(cdType,id)
	local map = self:GetCDMapByType(cdType)
	return map[id]
end

function CDProxy:GetSkillInCD(id)
	return self:GetCD(SceneUser2_pb.CD_TYPE_SKILL,id)
end

function CDProxy:GetItemInCD(id)
	return self:GetCD(SceneUser2_pb.CD_TYPE_ITEM,id)
end

function CDProxy:GetSkillItemDataCD(skillitemdata)
	local cdData = self:GetSkillInCD(skillitemdata.sortID)
	local communalData = self:GetSkillInCD(CDProxy.CommunalSkillCDSortID)
	if(skillitemdata and skillitemdata.staticData and skillitemdata.staticData.id == Game.Myself.data:GetAttackSkillIDAndLevel()) then
		--普攻
		return 0
	elseif(skillitemdata.staticData) then
		if(cdData ~=nil) then
			if(communalData==nil) then
				return cdData:GetCd()
			end
			return math.max(cdData:GetCd(),communalData:GetCd())
		elseif(communalData~=nil) then
			return communalData:GetCd()
		end
	end
	return 0
end

function CDProxy:GetTimeStampMapById(id)
	return self.timeStampMap[id]
end

CdData = class("CdData")

function CdData:ctor(time,cd,cdMax)
	self.time = time or 0
	self.cd = cd or 0
	self.cdMax = cdMax or cdMax
	self.timeStamp = 0
end

function CdData:CalCd(delta)
	if(self.cd==nil) then
		self.cd = 0
	end
	self.cd = self.cd + delta
end

function CdData:GetCd()
	return self.cd or 0
end

function CdData:GetCdMax()
	return self.cdMax or 1
end