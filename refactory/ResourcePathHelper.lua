ResourcePathHelper = {}
local PATH_PUBLIC = "Public/"
local PATH_GUI = "GUI"
local PATH_GUI_V1 = "GUI/v1/"
local PATH_GUI_pic_Model_Texture = "GUI/pic/Model/"
local PATH_EFFECT_ROOT = "Public/Effect/"
local PATH_EFFECT_COMMON = "Public/Effect/Common/"
local PATH_EFFECT_SKILL = "Public/Effect/Skill/"
local PATH_EFFECT_UI = "Public/Effect/UI/"
local PATH_EFFECT_WEATHER = "Public/Effect/Weather/"
local PATH_EFFECT_SPINECOMMON = "Public/SpineEffect/Common/"
local PATH_EMOJI = "Public/Emoji/"
local Path_RoleBody = "Role/Body/"
local Path_RoleHair = "Role/Hair/"
local Path_RoleHead = "Role/Head/"
local Path_RoleWeapon = "Role/Weapon/"
local Path_RoleWing = "Role/Wing/"
local Path_RoleFace = "Role/Face/"
local Path_RoleTail = "Role/Tail/"
local Path_RoleEye = "Role/Eye/"
local Path_RoleMouth = "Role/Mouth/"
local Path_RoleMount = "Role/Mount/"
local Path_StagePart = "Public/StageParts/"
local Path_AudioBGM = "Public/Audio/BGM/"
local Path_AudioBGM_HD = "Public/Audio/BGM_HD/"
local Path_AudioSE = "Public/Audio/SE/"
local Path_AudioSECommon = "Public/Audio/SE/Common/"
local Path_AudioSEUI = "Public/Audio/SE/UI/"
local Path_AudioSE_JP = "Public/Audio/SE_JP/"
local Path_BusCarrier = "Public/BusCarrier/"
local Path_Item = "Public/Item/"
local Path_BarrageAdornment = "Public/BarrageAdorment/"
local uiEffectPath = {}
function ResourcePathHelper.UIEffect(effect)
  local path = uiEffectPath[effect]
  if path == nil then
    path = "UI/" .. effect
    uiEffectPath[effect] = path
  end
  return path
end
function ResourcePathHelper.ModelMainTexture(txtureName)
  return PATH_GUI_pic_Model_Texture .. txtureName
end
function ResourcePathHelper.UIV1(name)
  return PATH_GUI_V1 .. name
end
function ResourcePathHelper.UICell(cellName)
  return "GUI/v1/cell/" .. cellName
end
function ResourcePathHelper.UITip(tipName)
  return "GUI/v1/tip/" .. tipName
end
function ResourcePathHelper.UIView(viewName)
  return "GUI/v1/view/" .. viewName
end
function ResourcePathHelper.UIPopup(viewName)
  return "GUI/v1/popup/" .. viewName
end
function ResourcePathHelper.Public(name)
  return PATH_PUBLIC .. name
end
function ResourcePathHelper.Effect(name)
  return PATH_EFFECT_ROOT .. name
end
function ResourcePathHelper.EffectCommon(name)
  return PATH_EFFECT_COMMON .. name
end
function ResourcePathHelper.EffectSkill(name)
  return PATH_EFFECT_SKILL .. name
end
function ResourcePathHelper.EffectUI(name)
  return PATH_EFFECT_UI .. name
end
function ResourcePathHelper.EffectWeather(name)
  return PATH_EFFECT_WEATHER .. name
end
function ResourcePathHelper.EffectSpineCommon(name)
  return PATH_EFFECT_SPINECOMMON .. name
end
function ResourcePathHelper.Emoji(name)
  return PATH_EMOJI .. name
end
function ResourcePathHelper.RoleBody(ID)
  return Path_RoleBody .. ID
end
function ResourcePathHelper.RoleHair(ID)
  return Path_RoleHair .. ID
end
function ResourcePathHelper.RoleHead(ID)
  return Path_RoleHead .. ID
end
function ResourcePathHelper.RoleWeapon(ID)
  return Path_RoleWeapon .. ID
end
function ResourcePathHelper.RoleWing(ID)
  return Path_RoleWing .. ID
end
function ResourcePathHelper.RoleFace(ID)
  return Path_RoleFace .. ID
end
function ResourcePathHelper.RoleTail(ID)
  return Path_RoleTail .. ID
end
function ResourcePathHelper.RoleEye(ID)
  return Path_RoleEye .. ID
end
function ResourcePathHelper.RoleMouth(ID)
  return Path_RoleMouth .. ID
end
function ResourcePathHelper.RoleMount(ID)
  return Path_RoleMount .. ID
end
function ResourcePathHelper.StagePart(ID)
  return Path_StagePart .. ID
end
function ResourcePathHelper.AudioBGM(ID)
  return Path_AudioBGM .. ID
end
function ResourcePathHelper.AudioBGM_HD(ID)
  return Path_AudioBGM_HD .. ID
end
function ResourcePathHelper.AudioSE(ID)
  return Path_AudioSE .. ID
end
function ResourcePathHelper.AudioSECommon(ID)
  return Path_AudioSECommon .. ID
end
function ResourcePathHelper.AudioSEUI(ID)
  return Path_AudioSEUI .. ID
end
function ResourcePathHelper.AudioSE_JP(ID)
  return Path_AudioSE_JP .. ID
end
function ResourcePathHelper.BusCarrier(ID)
  return Path_BusCarrier .. ID
end
function ResourcePathHelper.Item(ID)
  return Path_Item .. ID
end
function ResourcePathHelper.BarrageAdorment(name)
  return Path_BarrageAdornment .. name
end
