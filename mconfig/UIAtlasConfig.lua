UIAtlasConfig = {}
UIAtlasConfig.IconAtlas = {
  Item = {
    [1] = "GUI/atlas/preferb/Item_1",
    [2] = "GUI/atlas/preferb/Item_2",
    [3] = "GUI/atlas/preferb/hairStyle_1",
    [4] = "GUI/atlas/preferb/Item_3",
    [5] = "GUI/atlas/preferb/Item_4",
    [6] = "GUI/atlas/preferb/Item_5",
    [7] = "GUI/atlas/preferb/Item_6",
    [8] = "GUI/atlas/preferb/Item_7"
  },
  SkillProfess_0 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_3",
    [4] = "GUI/atlas/preferb/Skill_buff"
  },
  SkillProfess_1 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_buff",
    [4] = "GUI/atlas/preferb/Skill_zs",
    [5] = "GUI/atlas/preferb/Skill_szj"
  },
  SkillProfess_2 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_buff",
    [4] = "GUI/atlas/preferb/Skill_fs",
    [5] = "GUI/atlas/preferb/Skill_xz"
  },
  SkillProfess_3 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_buff",
    [4] = "GUI/atlas/preferb/Skill_dz"
  },
  SkillProfess_4 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_buff",
    [4] = "GUI/atlas/preferb/Skill_lr",
    [5] = "GUI/atlas/preferb/Skill_srwn"
  },
  SkillProfess_5 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_buff",
    [4] = "GUI/atlas/preferb/Skill_ms",
    [5] = "GUI/atlas/preferb/Skill_ws"
  },
  SkillProfess_6 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_buff",
    [4] = "GUI/atlas/preferb/Skill_sr"
  },
  SkillProfess_7 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_buff",
    [4] = "GUI/atlas/preferb/Skill_ljss"
  },
  SkillProfess_8 = {
    [1] = "GUI/atlas/preferb/Skill_1",
    [2] = "GUI/atlas/preferb/Skill_2",
    [3] = "GUI/atlas/preferb/Skill_buff",
    [4] = "GUI/atlas/preferb/Skill_lm"
  },
  Action = {
    [1] = "GUI/atlas/preferb/action"
  },
  Map = {
    [1] = "GUI/atlas/preferb/Map_1"
  },
  career = {
    [1] = "GUI/atlas/preferb/career"
  },
  face = {
    [1] = "GUI/atlas/preferb/face_1",
    [2] = "GUI/atlas/preferb/face_2",
    [3] = "GUI/atlas/preferb/face_3",
    [4] = "GUI/atlas/preferb/face_4",
    [5] = "GUI/atlas/preferb/face_5",
    [6] = "GUI/atlas/preferb/face_6",
    [7] = "GUI/atlas/preferb/face_7"
  },
  HeadAccessoryFront = {
    [1] = "GUI/atlas/preferb/Assesories_Front_1",
    [2] = "GUI/atlas/preferb/Assesories_Front_2"
  },
  HeadAccessoryBack = {
    [1] = "GUI/atlas/preferb/Assesories_Back_1"
  },
  HeadFaceMouth = {
    [1] = "GUI/atlas/preferb/Aface_1"
  },
  keyword = {
    [1] = "GUI/atlas/preferb/keyword"
  },
  hairStyle = {
    [1] = "GUI/atlas/preferb/hairStyle_1"
  },
  guild = {
    [1] = "GUI/atlas/preferb/guild"
  },
  uiicon = {
    [1] = "GUI/atlas/preferb/v2_icon",
    [2] = "GUI/atlas/preferb/v1_icon",
    [3] = "GUI/atlas/preferb/UI1",
    [4] = "GUI/atlas/preferb/UI2",
    [5] = "GUI/atlas/preferb/UI3",
    [6] = "GUI/atlas/preferb/UI4",
    [7] = "GUI/atlas/preferb/V3_icon"
  },
  HeadEye = {
    [1] = "GUI/atlas/preferb/eye_1"
  },
  ZenyShopItem = {
    [1] = "GUI/atlas/preferb/ZenyShopItem"
  },
  puzzle = {
    [1] = "GUI/atlas/preferb/pic",
    [2] = "GUI/atlas/preferb/pic_3x3",
    [3] = "GUI/atlas/preferb/pic_5x5"
  }
}
local Skills = {}
local tmp = {}
UIAtlasConfig.IconAtlas.Skill = Skills
for k, v in pairs(UIAtlasConfig.IconAtlas) do
  if string.find(k, "SkillProfess") ~= nil then
    for i = 1, #v do
      if tmp[v[i]] == nil then
        tmp[v[i]] = 1
        Skills[#Skills + 1] = v[i]
      end
    end
  end
end
