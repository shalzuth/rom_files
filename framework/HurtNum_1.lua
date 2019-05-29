HurtNum = class("HurtNum", ReusableObject)
HurtNumType = {
  HealNum = "HealNum",
  DamageNum = "DamageNum",
  DamageNum_U = "DamageNum_U",
  DamageNum_L = "DamageNum_L",
  DamageNum_R = "DamageNum_R",
  Miss = "Miss"
}
HurtNumColorType = {
  Combo = 1,
  Normal = 2,
  Player = 3,
  Treatment = 4,
  Normal_Sp = 5,
  Treatment_Sp = 6
}
HurtNumColorMap = {
  [1] = LuaColor.New(0.99, 0.99, 0.004, 1),
  [2] = LuaColor.New(1, 1, 1, 1),
  [3] = LuaColor.New(0.82, 0.14, 0.04, 1),
  [4] = LuaColor.New(0.078, 0.94, 0.027, 1),
  [5] = LuaColor.New(0.6352941176470588, 0.4, 0.9607843137254902, 1),
  [6] = LuaColor.New(0.42745098039215684, 0.5647058823529412, 1, 1)
}
HurtNum_CritType = {
  None = 0,
  PAtk = 1,
  MAtk = 2
}
HurtNumLimit = {
  [1] = 10,
  [2] = 50,
  [3] = 10,
  [4] = 10,
  [5] = 50,
  [6] = 10
}
function HurtNum:PlayAni(obj, aniName)
  local animator = obj:GetComponent(Animator)
  if animator == nil then
    error("cannot fin animator")
  end
  animator:Play(aniName, -1, 0)
end
function HurtNum:DoConstruct(asArray, args)
end
function HurtNum:DoDeconstruct(asArray)
end
