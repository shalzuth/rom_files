ReusableObject = class("ReusableObject")

-- factory begin
if not ReusableObject.ReusableObject_Inited then
	ReusableObject.pool = TablePool.new()

	ReusableObject.ReusableObject_Inited = true
end

-- NOTE -->
-- Must call self:CreateData() before FIRST call self:SetData(k, v), PushBackData,GetDataLength
-- Must call self:CreateWeakData() before FIRST call self:SetWeakData(k, v), PushBackWeakData, GetWeakDataLength
-- self:SetData(k, v) v must not be reueable object
-- self:SetWeakData(k, v) v must be reueable object
-- NOTE --<

-- DON'T call

local pool = ReusableObject.pool

local tempArray = {}

function ReusableObject.LogPools()
	pool:Log()
end

local instanceID = 0
local function NewInstance()
	instanceID = instanceID + 1
	return instanceID
end

local function DoCreate( Cls )
	return Cls.new()
end

function ReusableObject.Create( Cls, asArray, args )
	-- 1.
	local obj = pool:RemoveOrCreate(Cls, DoCreate)
	-- 2.
	obj.instanceID = NewInstance()
	-- 3.
	obj:Construct(asArray, args)

	return obj
end

function ReusableObject.Destroy(obj)
	-- 1.
	if not obj:Alive() then
		LogUtility.ErrorFormat("Destroy not reused obj: {0}", obj)
		return
	end
	-- 2.
	obj:Deconstruct()
	-- 4.
	if not pool:Add(obj.class, obj) and nil ~= obj.Finalize then
		obj:Finalize()
	end
end
-- factory end

function ReusableObject:ctor()
	self._alive = true
end

function ReusableObject:Alive()
	return self._alive
end

function ReusableObject:GetData(k)
	return self._data[k]
end

function ReusableObject:SetData(k, v)
	Debug_AssertFormat((type(v) ~= "table" or nil == v.Construct), "SetData({0}, {1}) v is reusable object", k, v)
	self._data[k] = v
end

-- for array
function ReusableObject:PushBackData(v)
	Debug_Assert(self._dataAsArray, "PushBackData Just For Data As Array!!!")
	Debug_AssertFormat((type(v) ~= "table" or nil == v.Construct), "PushBackData({0}, {1}) v is reusable object", k, v)
	TableUtility.ArrayPushBack(self._data, v)
end
-- for array
function ReusableObject:RemoveData(i)
	Debug_Assert(self._dataAsArray, "RemoveData Just For Data As Array!!!")
	table.remove(self._data, i)
end
-- for array
function ReusableObject:GetDataLength()
	Debug_Assert(self._dataAsArray, "GetDataLength Just For Data As Array!!!")
	return #self._data
end

function ReusableObject:CreateData()
	if nil ~= self._data then
		return
	end
	if self._dataAsArray then
		self._data = ReusableTable.CreateArray()
	else
		self._data = ReusableTable.CreateTable()
	end
end

function ReusableObject:DestroyData()
	if nil == self._data then
		return
	end
	if self._dataAsArray then
		ReusableTable.DestroyArray(self._data)
	else
		ReusableTable.DestroyTable(self._data)
	end
	self._data = nil
end

function ReusableObject:ClearData()
	if nil == self._data then
		return
	end
	if self._dataAsArray then
		TableUtility.ArrayClear(self._data)
	else
		TableUtility.TableClear(self._data)
	end
end

function ReusableObject:ClearDataByDeleter(deleter)
	if nil == self._data then
		return
	end
	if self._dataAsArray then
		TableUtility.ArrayClearByDeleter(self._data, deleter)
	else
		TableUtility.TableClearByDeleter(self._data, deleter)
	end
end

-- observer target begin

-- DON'T call
function ReusableObject:RegisterWeakObserver(obj)
	Debug_AssertFormat(nil ~= obj.ObserverDestroyed, "obj({0}) don't have function: ObserverDestroyed", obj)
	if nil == self._weakObserver then
		self._weakObserver = ReusableTable.CreateArray()
	end
	TableUtility.ArrayPushBack(self._weakObserver, obj)
end

-- DON'T call
function ReusableObject:UnregisterWeakObserver(obj)
	if nil ~= self._weakObserver then
		TableUtility.ArrayRemove(self._weakObserver, obj)
	end
end

-- DON'T call
function ReusableObject:ClearWeakObserver()
	if nil == self._weakObserver then
		return
	end
	-- 1.
	local observers = self._weakObserver
	self._weakObserver = nil

	-- 2.
	for i=1, #observers do
		observers[i]:ObserverDestroyed(self) -- TODO outside call
	end
	ReusableTable.DestroyArray(observers)
end

function ReusableObject:NotifyObserver(args)
	if nil == self._weakObserver then
		return
	end
	-- 1.
	TableUtility.ArrayShallowCopy(tempArray, self._weakObserver)
	-- 2.
	for i=1, #tempArray do
		if nil ~= tempArray[i].ObserverEvent then
			tempArray[i]:ObserverEvent(self, args)
		end
	end
	TableUtility.ArrayClear(tempArray)
end
-- observer target end

-- observer begin

-- DON'T call
function ReusableObject:ObserverDestroyed(obj)
	if nil == self._weakData then
		return
	end
	if self._dataAsArray then
		local a = self._weakData
		if 0 < #a then
			for k=1, #a do
				local v = a[k]
				if v == obj then
					TableUtility.ArrayPushBack(tempArray, k)
				end
			end
			if 0 < #tempArray then
				for i=#tempArray,1,-1 do
					local k = tempArray[i]
					table.remove(a, k)
					self:OnObserverDestroyed(k, obj) -- TODO outside call
				end
			end
		end
	else
		local t = self._weakData
		for k,v in pairs(t) do
			if v == obj then
				TableUtility.ArrayPushBack(tempArray, k)
			end
		end
		if 0 < #tempArray then
			for i=1,#tempArray do
				local k = tempArray[i]
				t[k] = nil
				self:OnObserverDestroyed(k, obj) -- TODO outside call
			end
		end
	end
	TableUtility.ArrayClear(tempArray)
end
-- observer end

function ReusableObject:GetWeakData(k)
	if nil == self._weakData then
		return nil
	end
	return self._weakData[k]
end

function ReusableObject:SetWeakData(k, v)
	-- 1.
	local oldV = self._weakData[k]
	if oldV == v then
		return
	end
	self._weakData[k] = v

	-- 2.
	if nil ~= oldV then
		oldV:UnregisterWeakObserver(self) -- TODO outside call
	end

	if nil ~= v then
		v:RegisterWeakObserver(self) -- TODO outside call
	end
end

function ReusableObject:FindWeakData(v)
	if self._dataAsArray then
		return TableUtility.ArrayFindIndex(self._weakData, v)
	else
		return TableUtility.TableFindKey(self._weakData, v)
	end
end

-- for array
function ReusableObject:PushBackWeakData(v)
	Debug_Assert(self._dataAsArray, "PushBackWeakData Just For Data As Array!!!")
	TableUtility.ArrayPushBack(self._weakData, v)
	v:RegisterWeakObserver(self) -- TODO outside call
end
-- for array
function ReusableObject:RemoveWeakData(i)
	Debug_Assert(self._dataAsArray, "RemoveWeakData Just For Data As Array!!!")
	table.remove(self._weakData, i)
end
-- for array
function ReusableObject:GetWeakDataLength()
	Debug_Assert(self._dataAsArray, "GetDataLength Just For Data As Array!!!")
	return #self._weakData
end

function ReusableObject:CreateWeakData()
	if nil ~= self._weakData then
		return
	end
	if self._dataAsArray then
		self._weakData = ReusableTable.CreateArray()
	else
		self._weakData = ReusableTable.CreateTable()
	end
end

function ReusableObject:DoClearWeakData()
	local temp = self._weakData
	self._weakData = nil
	if self._dataAsArray then
		for i=1, #temp do
			temp[i]:UnregisterWeakObserver(self) -- TODO outside call
		end
	else
		for k,v in pairs(temp) do
			v:UnregisterWeakObserver(self) -- TODO outside call
		end
	end
	self._weakData = temp
end

function ReusableObject:DestroyWeakData()
	if nil == self._weakData then
		return
	end

	self:DoClearWeakData()

	if self._dataAsArray then
		ReusableTable.DestroyArray(self._weakData)
	else
		ReusableTable.DestroyTable(self._weakData)
	end
	self._weakData = nil
end

function ReusableObject:ClearWeakData()
	if nil == self._weakData then
		return
	end
	
	self:DoClearWeakData()

	if self._dataAsArray then
		TableUtility.ArrayClear(self._weakData)
	else
		TableUtility.TableClear(self._weakData)
	end
end

function ReusableObject:ClearWeakDataByDeleter(deleter)
	if nil == self._weakData then
		return
	end
	
	self:DoClearWeakData()

	if self._dataAsArray then
		TableUtility.ArrayClearByDeleter(self._weakData, deleter)
	else
		TableUtility.TableClearByDeleter(self._weakData, deleter)
	end
end

-- DON'T call
function ReusableObject:Construct(asArray, args)
	self._alive = true
	self._dataAsArray = asArray
	self:DoConstruct(asArray, args) -- TODO outside call
end

-- DON'T call
function ReusableObject:Deconstruct()
	self:ClearWeakObserver()
	self:DoDeconstruct(self._dataAsArray) -- TODO outside call
	self:DestroyData()
	self:DestroyWeakData()
	self._dataAsArray = nil
	self._alive = false
end

-- virtual begin
function ReusableObject:DoConstruct(asArray, args)
end

function ReusableObject:DoDeconstruct(asArray)
end

function ReusableObject:Finalize()
end

function ReusableObject:OnObserverDestroyed(k, obj)
end
-- virtual end