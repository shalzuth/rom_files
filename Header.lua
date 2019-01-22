
if HeaderImported then
	return
end
HeaderImported = true
using "UnityEngine"
using "UnityEngine.Rendering"
using "RO"
require ("Script.Main.Import")
autoImport ("ApplicationInfo")

GAME_FAST_MODE = not ApplicationInfo.IsRunOnEditor() or ApplicationHelper.AssetBundleLoadMode

Debug_Assert = function (condition, msg)
	-- debug mode
	if not condition then
		LogUtility.Error(msg)
	end
end

Debug_AssertFormat = function (condition, fmt, ...)
	-- debug mode
	if not condition then
		LogUtility.ErrorFormat(fmt, ...)
	end
end

autoImport ("oop")

-- config
autoImport ("StrTablesManager")
autoImport ("Table")
-- GameConfig Begin
autoImport ("GameConfig")
-- GameConfig End

autoImport ("DialogUtil")

autoImport ("CameraConfig")
autoImport ("PanelConfig")
autoImport ("LayerConfig")
autoImport ("RoleConfig")
autoImport ("PathConfig")
autoImport ("ModelShowConfig")
autoImport ("EffectMap")
autoImport ("AudioMap")
autoImport ("Table_MapInfo")
autoImport ("ObscenceLanguage")
autoImport ("ColorUtil")

-- utility
autoImport ("LogUtility")
autoImport ("TableUtility")
autoImport ("TablePool")
autoImport ("AudioUtility")
autoImport ("ActionUtility")
autoImport ("Asset_RoleUtility")
autoImport ("NumberUtility")
autoImport ("NavMeshUtility")
autoImport ("ProtolUtility")
autoImport ("CullingIDUtility")
autoImport ("ResourcePathHelper")
autoImport ("LuaQueue")
autoImport ("RandomUtil")
autoImport ("BitUtil")
autoImport ("SceneUtil")
autoImport ("LayoutUtil")
autoImport ("NpcMonsterUtility")
autoImport ("LuaGC")
autoImport ("NetMonitor")
autoImport ("TestSystem")
autoImport ("ErrorLog")
autoImport ("FilePath")
autoImport ("ServerTime")
autoImport ("CommonFunHelper")
autoImport ("CommonFun")
autoImport ("GuildFun")
autoImport ("PetFun")

autoImport ("Debug_LuaMemotry")

require (FilePath.util.."BackwardCompatibilityUtil")
require (FilePath.util.."AudioUtil")
require (FilePath.util.."TableUtil")
require (FilePath.util.."PosUtil")
require (FilePath.util.."RoleUtil")
require (FilePath.util.."NGUIUtil")
require (FilePath.util.."UIUtil")
require (FilePath.util.."PropUtil")
require (FilePath.util.."CostUtil")
require (FilePath.util.."StringUtil")
require (FilePath.util.."PathUtil")
require (FilePath.util.."ItemUtil")
require (FilePath.util.."ClientTimeUtil")
require (FilePath.util.."DateUtil")
require (FilePath.util.."ConditionUtil")
require (FilePath.util.."CameraUtil")
require (FilePath.util.."LerpUtil")
require (FilePath.config.."LuaConfig")
require (FilePath.event.."EventStr")

-- structure
autoImport ("Structure")

-- reusable
autoImport ("ReusableTable")
autoImport ("ReusableObject")

-- geometry
autoImport ("LuaGeometry")
autoImport ("VectorUtility")
autoImport ("LuaColorUtility")

-- mvc
require "Script.Net.NetPrefix"
autoImport ("LuaProfiler")
pm = pm or {}
pm.VERSION = '1.0.0'
pm.FRAMEWORK_NAME = 'puremvc lua'
pm.PACKAGE_NAME = 'Script.org.puremvc.lua.multicore'

require(pm.PACKAGE_NAME .. '.help.oop')

pm.Facade = import(pm.PACKAGE_NAME .. '.patterns.facade.Facade')
pm.Mediator = import(pm.PACKAGE_NAME .. '.patterns.mediator.Mediator')
pm.Proxy = import(pm.PACKAGE_NAME .. '.patterns.proxy.Proxy')
pm.SimpleCommand = import(pm.PACKAGE_NAME .. '.patterns.command.SimpleCommand')
pm.MacroCommand = import(pm.PACKAGE_NAME .. '.patterns.command.MacroCommand')
pm.Notifier = import(pm.PACKAGE_NAME .. '.patterns.observer.Notifier')
pm.Notification = import(pm.PACKAGE_NAME .. '.patterns.observer.Notification')

GameFacade = {}
GameFacade.Instance = pm.Facade:getInstance("Game")

autoImport ("LuaLRU")
autoImport ("LuaStringBuilder")
autoImport('ItemsWithRoleStatusChange')
autoImport ("MsgManager")
autoImport("StartUpCommand")
autoImport("PrepCMDCommand")
autoImport("UIMediator")
autoImport ("PoolManager")
autoImport ("EventManager")
autoImport ("FunctionSystem")
autoImport ("TimeTickManager")
autoImport ("LuaObjPool")
autoImport ("NpcFeatures")
autoImport ("BubbleID")
autoImport ("MapTeleport")

-- ??????import???????????????????????????????????????
autoImport("EnvChannel")
autoImport("AppBundleConfig")
autoImport("RolePropsContainer")
autoImport("TableMathExtension")
autoImport('ItemsWithRoleStatusChange')
autoImport('ProtocolStatistics')
autoImport('FunctionInteractionGrass')
autoImport('DiskFileHandler')
autoImport('FrameRateSpeedUpChecker')
autoImport('AppStorePurchase')

-- game
autoImport ("Game")

-- init
Main = {
	IGNORE_ROLE_PART_COLOR_NUMBER = 0
}
function Main.ParsePaintColorTable(t, ignoreColorNumber,prop)
	prop = prop or "PaintColor"
	if nil ~= t then
		for k,v in pairs(t) do
			v.PaintColor_Parsed = ColorUtil.NumberTableToColorTable(v[prop], ignoreColorNumber)
			if(v.PaintColor_Parsed and v.DefaultColor and type(v.DefaultColor) == "number") then
				v.PaintColor_Parsed[0] = v.PaintColor_Parsed[v.DefaultColor]
			end
		end
	end
end

Main.ParsePaintColorTable(Table_Body, Main.IGNORE_ROLE_PART_COLOR_NUMBER)
Main.ParsePaintColorTable(Table_HairStyle, Main.IGNORE_ROLE_PART_COLOR_NUMBER,"AvatarColor")

-- function Main.ParseScenicSpotsTable(t)
-- 	if nil ~= t then
-- 		for k,v in pairs(t) do
-- 			local sss = Table_Map[v.MapName].ScenicSpots
-- 			if nil == sss then
-- 				sss = {}
-- 				Table_Map[v.MapName].ScenicSpots = sss
-- 			end
-- 			sss[v.MapNum] = k
-- 		end
-- 	end
-- end
-- Main.ParseScenicSpotsTable(Table_Viewspot)

function Main.ParseShaderColorTable(t)
	if nil ~= t then
		for k,v in pairs(t) do
			local lights = {}
			for i=1, 3 do
				local light = {}
				local hasC, resultC = ColorUtil.TryParseHexString(v["LightColor"..i])
				if not hasC then
					break
				end
				light.color = resultC
				light.exposure = v["Exposure"..i]
				lights[i] = light
			end
			if 3 == #lights then
				v.lights = lights
			end
		end
	end
end
Main.ParseShaderColorTable(Table_ShaderColor)