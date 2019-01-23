UIAtlasConfig = {};

-- 添加示例： [2] = "GUI/atlas/preferb/Item_2", 
UIAtlasConfig.IconAtlas = {
	-- 道具
	Item = {
		[1] = "GUI/atlas/preferb/Item_1",
		[2] = "GUI/atlas/preferb/Item_2",
		[3] = "GUI/atlas/preferb/hairStyle_1",
		[4] = "GUI/atlas/preferb/Item_3",
		[5] = "GUI/atlas/preferb/Item_4",
	},

	-- 初心者职业技能
	SkillProfess_0 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
	},
	-- 战士职业技能
	SkillProfess_1 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
		[4] = "GUI/atlas/preferb/Skill_zs",
		[5] = "GUI/atlas/preferb/Skill_szj",
                [6] = "GUI/atlas/preferb/Skill_3",
	},
	-- 法师职业技能
	SkillProfess_2 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
		[4] = "GUI/atlas/preferb/Skill_fs",
	},
	-- 盗贼职业技能
	SkillProfess_3 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
		[4] = "GUI/atlas/preferb/Skill_dz",
	},
	-- 猎人职业技能
	SkillProfess_4 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
		[4] = "GUI/atlas/preferb/Skill_lr",
	},
	-- 牧师职业技能职业技能
	SkillProfess_5 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
		[4] = "GUI/atlas/preferb/Skill_ms",
		[5] = "GUI/atlas/preferb/Skill_ws",
	},
	-- 商人职业技能职业技能
	SkillProfess_6 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
		[4] = "GUI/atlas/preferb/Skill_sr",
	},
	-- 炼金师职业技能职业技能
	SkillProfess_7 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
		[4] = "GUI/atlas/preferb/Skill_ljss",
	},
	-- 流氓职业技能职业技能
	SkillProfess_8 = {
		[1] = "GUI/atlas/preferb/Skill_1",
		[2] = "GUI/atlas/preferb/Skill_2",
		[3] = "GUI/atlas/preferb/Skill_buff",
		[4] = "GUI/atlas/preferb/Skill_lm",
	},
	-- 动作
	Action = {
		[1] = "GUI/atlas/preferb/action",
	},
	-- 小地图图标
	Map = {
		[1] = "GUI/atlas/preferb/Map_1",
	},
	-- 职业
	career = {
		[1] = "GUI/atlas/preferb/career",
	},
	-- 头像
	face = {
		[1] = "GUI/atlas/preferb/face_1",	
		[2] = "GUI/atlas/preferb/face_2",	
		[3] = "GUI/atlas/preferb/face_3",
                [4] = "GUI/atlas/preferb/face_4",
                [5] = "GUI/atlas/preferb/face_5",
                [6] = "GUI/atlas/preferb/face_6",
	},
	-- 头像头饰前
	HeadAccessoryFront = {
		[1] = "GUI/atlas/preferb/Assesories_Front_1",
		[2] = "GUI/atlas/preferb/Assesories_Front_2",
	},
	-- 头像头饰后
	HeadAccessoryBack = {
		[1] = "GUI/atlas/preferb/Assesories_Back_1",
	},
	-- 头像脸和嘴
	HeadFaceMouth = {
		[1] = "GUI/atlas/preferb/Aface_1",
	},
	-- 关键字
	keyword = {
		[1] = "GUI/atlas/preferb/keyword",
	},
	-- 头发 发型
	hairStyle = {
		[1] = "GUI/atlas/preferb/hairStyle_1",
	},
	-- 公会
	guild = {
		[1] = "GUI/atlas/preferb/guild",
	},
	-- ui用 如背包图标等等
	uiicon = {
		[1] = "GUI/atlas/preferb/v2_icon",
		[2] = "GUI/atlas/preferb/v1_icon",
	},
	-- 美瞳ui
	HeadEye = {
		[1] = "GUI/atlas/preferb/eye_1",
	},
	-- 充值档位图案
	ZenyShopItem = {
		[1] = "GUI/atlas/preferb/ZenyShopItem",
	},
}

--skill技能图标全读取处
local Skills = {}
local tmp = {}

UIAtlasConfig.IconAtlas.Skill = Skills

for k,v in pairs(UIAtlasConfig.IconAtlas) do
	if(string.find(k,"SkillProfess")~=nil) then
		for i=1,#v do
			if(tmp[v[i]]==nil) then
				tmp[v[i]] = 1
				Skills[#Skills+1] = v[i]
			end
		end
	end
end