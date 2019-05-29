BackwardCompatibilityUtil = class("BackwardCompatibilityUtil")
BackwardCompatibilityUtil.V6 = 6
BackwardCompatibilityUtil.V8 = 8
BackwardCompatibilityUtil.V9 = 9
BackwardCompatibilityUtil.V10 = 10
BackwardCompatibilityUtil.V11 = 11
BackwardCompatibilityUtil.V12 = 12
BackwardCompatibilityUtil.V13 = 14
BackwardCompatibilityUtil.V16 = 16
local currentVersion = CompatibilityVersion.version
local BuildVersionName = function(v)
  local v100 = math.floor(v / 100)
  v = v - v100 * 100
  local v10 = math.floor(v / 10)
  v = v - v10 * 10
  if v100 <= 0 then
    v100 = 1
  end
  return string.format("%d.%d.%d", v100, v10, v)
end
local currentVersionName = BuildVersionName(currentVersion)
function BackwardCompatibilityUtil.GetCurrentVersionName()
  return currentVersionName
end
function BackwardCompatibilityUtil.CompatibilityMode(v)
  return v >= currentVersion
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
SelfClass.CompatibilityMode_V25 = SelfClass.CompatibilityMode(25)
SelfClass.CompatibilityMode_V26 = SelfClass.CompatibilityMode(26)
SelfClass.CompatibilityMode_V27 = SelfClass.CompatibilityMode(27)
SelfClass.CompatibilityMode_V28 = SelfClass.CompatibilityMode(28)
SelfClass.CompatibilityMode_V29 = SelfClass.CompatibilityMode(29)
SelfClass.CompatibilityMode_V30 = SelfClass.CompatibilityMode(30)
SelfClass.CompatibilityMode_V31 = SelfClass.CompatibilityMode(31)
SelfClass.CompatibilityMode_V32 = SelfClass.CompatibilityMode(32)
