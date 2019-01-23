ReusableTable = class("ReusableTable")

-- NOTE -->
-- Don't share reusable table(or array). It can only have one holder.
-- NOTE --<

if not ReusableTable.inited then
	ReusableTable.pool = TablePool.new()
	ReusableTable.inited = true
end

local TableCreator = TablePool.DefaultCreator
local ArrayClear = TableUtility.TableClear
local TableClear = TableUtility.TableClear

local pool = ReusableTable.pool
local arrayTag = pool:Init(1, 200)
local tableTag = pool:Init(2, 50)
local vector2Tag = pool:Init(3, 20)
local vector3Tag = pool:Init(4, 200)
local vector4Tag = pool:Init(5, 20)
local colorTag = pool:Init(6, 20)
local rolePartArrayTag = pool:Init(7, 100)
local rolePartTableTag = pool:Init(8, 200)
local quaternionTag = pool:Init(9, 20)
local searchTargetInfoTag = pool:Init(10, 100)
local innerTeleportInfoTag = pool:Init(11, 10)
local outterTeleportInfoTag = pool:Init(12, 10)
local protocolStatisticsTag = pool:Init(13, 100)

function ReusableTable.LogPools()
	pool:Log()
end

function ReusableTable.CreateArray()
	local t, newCreated = pool:RemoveOrCreateByTag(arrayTag, TableCreator)
	if not newCreated then
		ArrayClear(t)
	end
	return t, newCreated
end

function ReusableTable.DestroyArray(array)
	pool:AddByTag(arrayTag, array)
end

function ReusableTable.DestroyAndClearArray(array)
	if(array)then
		ArrayClear(array)
	end
	pool:AddByTag(arrayTag, array)
end

function ReusableTable.CreateTable()
	local t, newCreated = pool:RemoveOrCreateByTag(tableTag, TableCreator)
	if not newCreated then
		TableClear(t)
	end
	return t, newCreated
end

function ReusableTable.DestroyTable(t)
	pool:AddByTag(tableTag, t)
end

function ReusableTable.DestroyAndClearTable(t)
	if(t)then
		TableClear(t)
	end
	pool:AddByTag(tableTag, t)
end

-- custom
function ReusableTable.CreateVector2()
	local t, newCreated = pool:RemoveOrCreateByTag(vector2Tag, TableCreator)
	-- if not newCreated then
	-- 	ArrayClear(t)
	-- end
	return t, newCreated
end

function ReusableTable.DestroyVector2(v)
	pool:AddByTag(vector2Tag, v)
end

function ReusableTable.CreateVector3()
	local t, newCreated = pool:RemoveOrCreateByTag(vector3Tag, TableCreator)
	-- if not newCreated then
	-- 	ArrayClear(t)
	-- end
	return t, newCreated
end

function ReusableTable.DestroyVector3(v)
	pool:AddByTag(vector3Tag, v)
end

function ReusableTable.CreateColor()
	local t, newCreated = pool:RemoveOrCreateByTag(colorTag, TableCreator)
	-- if not newCreated then
	-- 	ArrayClear(t)
	-- end
	return t, newCreated
end

function ReusableTable.DestroyColor(v)
	pool:AddByTag(colorTag, v)
end

function ReusableTable.CreateRolePartArray()
	local t, newCreated = pool:RemoveOrCreateByTag(rolePartArrayTag, TableCreator)
	-- if not newCreated then
	-- 	ArrayClear(t)
	-- end
	return t, newCreated
end

function ReusableTable.DestroyRolePartArray(v)
	pool:AddByTag(rolePartArrayTag, v)
end

function ReusableTable.CreateRolePartTable()
	local t, newCreated = pool:RemoveOrCreateByTag(rolePartTableTag, TableCreator)
	if not newCreated then
		TableClear(t)
	end
	return t, newCreated
end

function ReusableTable.DestroyRolePartTable(v)
	pool:AddByTag(rolePartTableTag, v)
end

function ReusableTable.CreateQuaternion()
	local t, newCreated = pool:RemoveOrCreateByTag(quaternionTag, TableCreator)
	-- if not newCreated then
	-- 	ArrayClear(t)
	-- end
	return t, newCreated
end

function ReusableTable.DestroyQuaternion(v)
	pool:AddByTag(quaternionTag, v)
end

function ReusableTable.CreateSearchTargetInfo()
	local t, newCreated = pool:RemoveOrCreateByTag(searchTargetInfoTag, TableCreator)
	-- if not newCreated then
	-- 	ArrayClear(t)
	-- end
	return t, newCreated
end

function ReusableTable.DestroySearchTargetInfo(v)
	v[1] = nil -- creature
	pool:AddByTag(searchTargetInfoTag, v)
end

function ReusableTable.CreateInnerTeleportInfo()
	local t, newCreated = pool:RemoveOrCreateByTag(innerTeleportInfoTag, TableCreator)
	
	return t, newCreated
end

function ReusableTable.DestroyInnerTeleportInfo(v)
	if nil ~= v.targetPos then
		v.targetPos:Destroy()
	end
	if nil ~= v.epTargetPos then
		v.epTargetPos:Destroy()
	end
	TableClear(v)
	pool:AddByTag(innerTeleportInfoTag, v)
end

function ReusableTable.CreateOutterTeleportInfo()
	local t, newCreated = pool:RemoveOrCreateByTag(outterTeleportInfoTag, TableCreator)
	
	return t, newCreated
end

function ReusableTable.DestroyOutterTeleportInfo(v)
	if nil ~= v.targetPos then
		v.targetPos:Destroy()
	end
	TableClear(v)
	pool:AddByTag(outterTeleportInfoTag, v)
end

function ReusableTable.CreateProtocolStatistics()
	local t, newCreated = pool:RemoveOrCreateByTag(protocolStatisticsTag, TableCreator)
	if not newCreated then
		TableClear(t)
	end
	return t, newCreated
end

function ReusableTable.DestroyProtocolStatistics(t)
	pool:AddByTag(protocolStatisticsTag, t)
end