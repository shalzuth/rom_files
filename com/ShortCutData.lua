ShortCutData = class("ShortCutData")

ShortCutData.CONFIGSKILLNUM = 6
ShortCutData.CONFIGAUTOSKILLNUM = GameConfig.SkillShort.Auto

function ShortCutData:ctor()
	self:Init()
end

function ShortCutData:Init()
	--manual
	self.skillUnlockMaxIndex = {}
	self.skillShortCuts = {}
	for k,v in pairs(ShortCutProxy.ShortCutEnum) do
		self.skillUnlockMaxIndex[v] = 0
		self.skillShortCuts[v] = {}
	end
	self.skillUnlockMaxIndex[ShortCutProxy.ShortCutEnum.ID1] = 1
	--缓存解锁，用于功能开启
	self.skillCacheShortCurs = {}
	for i=1,ShortCutData.CONFIGSKILLNUM do
		for k,v in pairs(self.skillShortCuts) do
			v[#v+1] = true
		end
		self.skillCacheShortCurs[#self.skillCacheShortCurs+1] = true
	end
	--auto
	self.autoSkillUnlockMaxIndex = 1
	self.autoSkillShortCuts = {}
	for i=1,ShortCutData.CONFIGAUTOSKILLNUM do
		self.autoSkillShortCuts[#self.autoSkillShortCuts+1] = true
	end
end

function ShortCutData:ResetSkillShortCuts()
	self:ResetExtendSkillShortCuts()
	self:ResetAutoSkillShortCuts()
end

function ShortCutData:ResetExtendSkillShortCuts()
	local _ShortCutEnum = ShortCutProxy.ShortCutEnum
	local ID1 = _ShortCutEnum.ID1
	for k,v in pairs(_ShortCutEnum) do
		if v ~= ID1 then
			local shortCut = self.skillShortCuts[v]
			for i=1,#shortCut do
				shortCut[i] = true
			end
			self.skillUnlockMaxIndex[v] = 0
		end
	end
end

function ShortCutData:ResetAutoSkillShortCuts()
	for i=1,#self.autoSkillShortCuts do
		self.autoSkillShortCuts[i] = true
	end
end

function ShortCutData:UnLockSkillShortCuts(data)
	local _ShortCutEnum = ShortCutProxy.ShortCutEnum
	local shortcutType = data.type
	if shortcutType == _ShortCutEnum.ID1 then
		self:UnLockNormalSkillShortCuts(shortcutType, data.pos)

	elseif shortcutType == _ShortCutEnum.ID2 or shortcutType == _ShortCutEnum.ID3 or shortcutType == _ShortCutEnum.ID4 then
		self:UnLockExtendSkillShortCuts(shortcutType, data.pos)

	elseif shortcutType == ShortCutProxy.SkillShortCut.Auto then
		self:UnLockAutoSkillShortCuts(data.pos)
	end
end

function ShortCutData:UnLockNormalSkillShortCuts(shortcutType, indexes)
	local unlockIndex = 1
	local shortCuts = self.skillShortCuts[shortcutType]
	if indexes ~= nil then
		local init = self.skillUnlockMaxIndex[shortcutType] == nil or self.skillUnlockMaxIndex[shortcutType] <= 1
		for i=1,#indexes do
			local pos = indexes[i]
			self.skillCacheShortCurs[pos] = false
			if init then
				shortCuts[pos] = false
			end
			unlockIndex = math.max(unlockIndex, pos)
		end
		self.skillUnlockMaxIndex[shortcutType] = unlockIndex
	else
		for i=1,#shortCuts do
			shortCuts[i] = true
		end
		self.skillUnlockMaxIndex[shortcutType] = 0
	end	
end

function ShortCutData:UnLockExtendSkillShortCuts(shortcutType, indexes)
	if indexes ~= nil then
		for i=1,#indexes do
			local pos = indexes[i]
			self.skillShortCuts[shortcutType][pos] = false
			self.skillUnlockMaxIndex[shortcutType] = math.max(self.skillUnlockMaxIndex[shortcutType], pos)
		end
	else
		self:ResetExtendSkillShortCuts()
	end	
end

function ShortCutData:UnLockAutoSkillShortCuts(indexes)
	local unlockIndex = 1
	for i=1,#indexes do
		self.autoSkillShortCuts[indexes[i]] = false
		unlockIndex = math.max(unlockIndex,indexes[i])
	end
	self.autoSkillUnlockMaxIndex = unlockIndex
end

function ShortCutData:GetUnLockSkillMaxIndex(id)
	if id == nil then
		id = ShortCutProxy.ShortCutEnum.ID1
	end
	return self.skillUnlockMaxIndex[id]
end

function ShortCutData:SetCacheListToRealList()
	local id = ShortCutProxy.ShortCutEnum.ID1
	for i=1,#self.skillCacheShortCurs do
		self.skillShortCuts[id][i] = self.skillCacheShortCurs[i]
	end
end

function ShortCutData:SkillIsLocked(index,id)
	if id == nil then
		id = ShortCutProxy.ShortCutEnum.ID1
	end
	return self.skillShortCuts[id][index]
end

function ShortCutData:AutoSkillIsLocked(index)
	if index == nil or index == 0 then
		return false
	end
	return self.autoSkillShortCuts[index]
end

function ShortCutData:ShortCutListIsEnable(id)
	local ret = self:GetUnLockSkillMaxIndex(id)
	if ret == nil then
		helplog("id:"..id.." is null")
		return false
	end	
	return self:GetUnLockSkillMaxIndex(id) > 0
end

function ShortCutData:GetAutoSkillUnlockMaxIndex()
	return self.autoSkillUnlockMaxIndex
end