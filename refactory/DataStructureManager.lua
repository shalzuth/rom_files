-- defines
autoImport("RoleDefines")
autoImport("SkillDefines")

autoImport("TransformData")
autoImport("CreatureData")
autoImport("PlayerData")
autoImport("NpcData")
autoImport("MyselfData")
autoImport("PetData")
autoImport("PartnerData")
autoImport("HandNpcData")
autoImport("ExpressNpcData")
DataStructureManager = class("DataStructureManager")

-- 为了提高效率，避免二次查询，某些数据结构可以提供设置自定义数据的接口。
-- 当数据结构被销毁时，通知所有自定义数据
function DataStructureManager:ctor()
	
end

function DataStructureManager:Update(time, deltaTime)
end