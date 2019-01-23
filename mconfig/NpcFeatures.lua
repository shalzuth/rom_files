--[[
怪物特性参数配置
]]
NpcFeatures = {}
-----------捡物品
NpcFeatures.PickUp = {
  PickupRange = 10,
  PickupMaxItem = 20,
}
-----------协同攻击
NpcFeatures.TeamWork={
TeamHelpRange = 7,
TeamHelpHp = 90,
TeamAttack = {range=3,responseTime=1,emoji=7},
}
-----------幽灵(闪光灯的技能应该是配置在闪光灯上面？)
NpcFeatures.Ghost={
BirthBuff={160100,160101,160104,160105,160106,160108},
DamPer=5,
}
-----------恶魔
NpcFeatures.Demon={
BuffID=150010,
DizzyVal=15,
}
-----------飞行
NpcFeatures.Flight={
ImmuneSkill={93,97,99,116,117,122},
}
-----------卖萌
NpcFeatures.ShowMoe={
BuffID=150030,
ShowMoeRange=10,
ShowMoeVal=10,
StayTime=3,
}
-----------抢镜
NpcFeatures.SceneStealing={
BuffID=150040,
Distance=15,
Pos=1,
Val=15,
}
-----------顽皮
NpcFeatures.Mischievous={
ResponseTime=1,
SkillID=10022001,
Emoji1=1,
Emoji2=5,
}
-----------机警
NpcFeatures.Alert={
FindRange=10,
Emoji=5,
ResponseTime=1,
SkillID=10022001,
SkillVal=10,
}
-----------驱逐
NpcFeatures.Expel={
FindRange=10,
Emoji=5,
ExpelVal=10,
SkillID=10021001,
}
-----------妒忌
NpcFeatures.Jealous={
FindRange=8,
Emoji=12,
}
-----------道具检索
NpcFeatures.ItemFind={
FindRange=6,
}
-----------脱离战斗
NpcFeatures.LeaveBattle={
LeaveRange=10,
LeaveTime=5,
MVPLeaveRange=15,
MVPLeaveTime=8,
}
-----------识别状态战术
NpcFeatures.TeamBattle={
  FindRange = 6,
  {status=5, skill=107},
  {status=6, skill=74},
}
-----------夜行
NpcFeatures.Night={
  Buffer = {150050}
}
-----------开霸体
NpcFeatures.Endure={
  Cd = 6,
  skill=14,
}

NpcFeatures.Servant={
  keep_distance = 4,
}

NpcFeatures.GoBack={
	buff={160200},
}

NpcFeatures.AIParams = {
  run_away_time = 2,
}
