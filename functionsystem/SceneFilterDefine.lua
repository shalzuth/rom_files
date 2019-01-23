SceneFilterDefine = {}

SceneFilterDefine.Target = {
	Player = 1,
	Pet = 2,
	Npc = 3,
	Monster = 4,
}

SceneFilterDefine.Range = {
	NotGuildOther = 1,
	NotTeamOther = 2,
	AllOther = 3,
	NotTeam = 4,
	All = 5,
	Self = 6,
	SameTeam = 7,
	SameGuild = 8,
	--TODO
}

--sceenfilter 配置表里的定义
SceneFilterDefine.Content = {
	--血条
	BloodBar = 1,
	--人物名称，称号，公会图标
	UINameTitleGuild = 2,
	--聊天气泡，技能喊话
	UIChatSkill = 3,
	--模型
	Model = 4,
	--表情
	Emoji = 5,
	--头顶框
	TopFrame = 6,
	--任务提示
	QuestUI = 7,
	--伤害数字
	HurtNum = 8,
	--头顶飘字（base.job经验，获得物品）
	FloatRoleTop = 9,
}

