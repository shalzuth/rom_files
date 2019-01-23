
BackwardCompatibilityUtil = class("BackwardCompatibilityUtil")

-- BackwardCompatibilityUtil.V1 = 1 -- deprecated
-- BackwardCompatibilityUtil.V2 = 2 -- deprecated
-- BackwardCompatibilityUtil.V3 = 3 -- deprecated
-- BackwardCompatibilityUtil.V4 = 4 -- deprecated
-- BackwardCompatibilityUtil.V5 = 5 -- deprecated
BackwardCompatibilityUtil.V6 = 6
BackwardCompatibilityUtil.V8 = 8
BackwardCompatibilityUtil.V9 = 9
BackwardCompatibilityUtil.V10 = 10
BackwardCompatibilityUtil.V11 = 11
BackwardCompatibilityUtil.V12 = 12
BackwardCompatibilityUtil.V13 = 14
-- BackwardCompatibilityUtil.V15 = 15
BackwardCompatibilityUtil.V16 = 16 --todo xde add version
local currentVersion = CompatibilityVersion.version

local function BuildVersionName(v)
	local v100 = math.floor(v/100)
	v = v-v100*100
	local v10 = math.floor(v/10)
	v = v-v10*10
	if 0 >= v100 then
		v100 = 1
	end
	return string.format("%d.%d.%d", v100, v10, v)
end

local currentVersionName = BuildVersionName(currentVersion)

function BackwardCompatibilityUtil.GetCurrentVersionName()
	return currentVersionName
end

function BackwardCompatibilityUtil.CompatibilityMode(v)
	return currentVersion <= v
end

local SelfClass = BackwardCompatibilityUtil
SelfClass.CompatibilityMode_V9 = SelfClass.CompatibilityMode(SelfClass.V9)
SelfClass.CompatibilityMode_V10 = SelfClass.CompatibilityMode(SelfClass.V10)
SelfClass.CompatibilityMode_V11 = SelfClass.CompatibilityMode(SelfClass.V11)
SelfClass.CompatibilityMode_V12 = SelfClass.CompatibilityMode(SelfClass.V12)
SelfClass.CompatibilityMode_V13 = SelfClass.CompatibilityMode(SelfClass.V13)
SelfClass.CompatibilityMode_V15 = SelfClass.CompatibilityMode(15)
SelfClass.CompatibilityMode_V16 = SelfClass.CompatibilityMode(16)
SelfClass.CompatibilityMode_V17 = SelfClass.CompatibilityMode(17)
SelfClass.CompatibilityMode_V18 = SelfClass.CompatibilityMode(18)
SelfClass.CompatibilityMode_V19 = SelfClass.CompatibilityMode(19)
SelfClass.CompatibilityMode_V20 = SelfClass.CompatibilityMode(20)
SelfClass.CompatibilityMode_V21 = SelfClass.CompatibilityMode(21)
SelfClass.CompatibilityMode_V22 = SelfClass.CompatibilityMode(22)
SelfClass.CompatibilityMode_V23 = SelfClass.CompatibilityMode(23)
SelfClass.CompatibilityMode_V24 = SelfClass.CompatibilityMode(24)