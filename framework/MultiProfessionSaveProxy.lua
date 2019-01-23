autoImport("UserSaveInfoData")
autoImport("UserSaveSlotData")
autoImport("AstrolMaterialData")

MultiProfessionSaveProxy = class('MultiProfessionSaveProxy', pm.Proxy)
MultiProfessionSaveProxy.Instance = nil
MultiProfessionSaveProxy.NAME = "MultiProfessionSaveProxy"

function MultiProfessionSaveProxy:ctor(proxyName, data)
	self.proxyName = proxyName or MultiProfessionSaveProxy.NAME
	if MultiProfessionSaveProxy.Instance == nil then
		MultiProfessionSaveProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self.slotDatas = {}
	self.recordDatas = {}
end

function MultiProfessionSaveProxy:RecvUpdateRecordInfoUserCmd(serverdata)
	local _records = serverdata.records
	for i = 1,#_records do
		local single = UserSaveInfoData.new(_records[i])
		self.recordDatas[single.id] = single
		local n = #self.slotDatas
		for i=1,n do			
			if self.slotDatas[i].id == single.id then
				self.slotDatas[i]:ResetRecordTime(single.recordtime)
				self.slotDatas[i]:SetRecordName(single.recordname)
			end
		end
	end
	local _slots = serverdata.slots

	local  _delete = serverdata.delete_ids
	local recordLength = #self.recordDatas
	for i=1,#_delete do
		for k,v in pairs(self.recordDatas)  do
			if _delete[i] == v.id then
				self.recordDatas[k] = nil
			end
		end
		local t = #self.slotDatas
		for k=1,t do
			if self.slotDatas[k].id == _delete[i] then
				self.slotDatas[k]:ResetRecordTime(0)
			end
		end
	end
	if #self.slotDatas ==0 then
		for i = 1,#_slots do			
			local temp = UserSaveSlotData.new(_slots[i])			
			self.slotDatas[i] = temp
			if self.recordDatas[temp.id] then
				self.slotDatas[i]:ResetRecordTime(self.recordDatas[i].recordtime)
				self.slotDatas[i]:SetRecordName(self.recordDatas[i].recordname)
			end
		end
	else
		for i = 1,#_slots do
		local temp = UserSaveSlotData.new(_slots[i])	
			for j = 1,#self.slotDatas do
				if self.slotDatas[j] and self.slotDatas[j].id == temp.id then
					self.slotDatas[j] = temp
					if self.recordDatas[temp.id] then
						self.slotDatas[j]:ResetRecordTime(self.recordDatas[temp.id].recordtime)
						self.slotDatas[j]:SetRecordName(self.recordDatas[temp.id].recordname)
					end
				end
			end
		end

	end

	self.CardExpiration = serverdata.card_expiretime
	self:CheckTimeValidation()
	-- self:SortUserSave()
	self.costMap = {}
	if serverdata.astrol_data then
		local l = #serverdata.astrol_data
		local temp 
		for i=1,l do
			temp = AstrolMaterialData.new(serverdata.astrol_data[i])
			self.costMap[temp.charid] = temp
		end
	end
end

function MultiProfessionSaveProxy:CheckTimeValidation()
	if self.slotDatas then
		local n = #self.slotDatas
		for i=1,n do
			if self.slotDatas[i].Type == SceneUser2_pb.ESLOT_MONTH_CARD then
				if self.slotDatas[i].status == 1 and self.CardExpiration == 0 then
					self.slotDatas[i].status = 0
				elseif self.slotDatas[i].status == 0 and self.CardExpiration > 0 then
					self.slotDatas[i].status = 1
				end
			end
		end
	end
end

function MultiProfessionSaveProxy:GetCardExpiration()
	return self.CardExpiration
end

function MultiProfessionSaveProxy:SortUserSave()
	table.sort(self.slotDatas,function (l,r)
		local l_status = l.status
		local r_status = r.status

		if l_status == r_status then -- Active 1, InActive 0
			if l_status == 1 then
				return l.recordTime > r.recordTime
			elseif l_status == 0 then
				if l.type == r.type then
					return l.id < r.id					
				else
					return l.type > r.type
				end
			end
		else
			return l_status > r_status
		end
		end)
end

function MultiProfessionSaveProxy:UpdateStatus(slotid,status)
	for i=1,#self.slotDatas do
		if self.slotDatas[i].id == slotid then
			self.slotDatas[i]:UpdateSlotStatus(status)
		end
	end
end

function MultiProfessionSaveProxy:GetDefaultRecord()
	return self.slotDatas[1].id
end

function MultiProfessionSaveProxy:GetCurrentSlotStatus(selectedID)
	if self.slotDatas then
		local n = #self.slotDatas
		for i=1,n do
			if self.slotDatas[i].id == selectedID then
				return self.slotDatas[i].status
			end
		end
	else
		return 0
	end
end

function MultiProfessionSaveProxy:GetProfession(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetProfession()
end

function MultiProfessionSaveProxy:GetRoleID(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id].roleid
end

function MultiProfessionSaveProxy:GetRoleName(id)
	if not self.recordDatas[id] then
		return nil 
	end
	return self.recordDatas[id].rolename
end

function MultiProfessionSaveProxy:GetUnusedSkillPoint(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetUnusedSkillPoint()
end

function MultiProfessionSaveProxy:GetProfessionSkill(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetProfessionSkill()
end

function MultiProfessionSaveProxy:GetEquipedSkills(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetEquipedSkills()
end

function MultiProfessionSaveProxy:GetEquipedAutoSkills(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetEquipedAutoSkills()
end

function MultiProfessionSaveProxy:GetBeingSkill(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetBeingSkill()
end

function MultiProfessionSaveProxy:GetBeingInfo(id, beingid)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetBeingInfo(beingid)
end

function MultiProfessionSaveProxy:GetBeingsArray(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetBeingsArray()
end

function MultiProfessionSaveProxy:GetUsedPoints(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetUsedPoints()
end

function MultiProfessionSaveProxy:GetJobLevel(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetJobLevel()
end

function MultiProfessionSaveProxy:GetFixedJobLevel(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetFixedJobLevel()
end

function MultiProfessionSaveProxy:GetProfessionType(id)
	if not self.recordDatas[id] then return nil end
	local profession = self.recordDatas[id]:GetProfession()
	profession = Table_Class[profession]
	return profession and profession.Type or 0
end

function MultiProfessionSaveProxy:GetAstrobleByID(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetAstroble()
end

function MultiProfessionSaveProxy:GetActiveStars(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetActiveStars()
end

function MultiProfessionSaveProxy:GetUserDataByID(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetUserData()

end

function MultiProfessionSaveProxy:GetProps(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetProps()
end

function MultiProfessionSaveProxy:GetUsersaveData(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]
end

function MultiProfessionSaveProxy:CheckAstrolMaterial(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:CheckAstrolMaterial(self.costMap)
end

function MultiProfessionSaveProxy:GetContribute(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetContribute()
end

function MultiProfessionSaveProxy:GetGoldMedal(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetGoldMedal()
end

function MultiProfessionSaveProxy:GetSkillData(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetSkillData()
end

function MultiProfessionSaveProxy:Clear()
	if(self.slotDatas ~= nil)then
		TableUtility.TableClear(self.slotDatas);
	end
	if(self.recordDatas ~= nil)then
		TableUtility.TableClear(self.recordDatas);
	end
end