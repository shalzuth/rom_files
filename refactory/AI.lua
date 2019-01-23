
autoImport ("AI_CMD")

autoImport ("AI_Base")

autoImport ("IdleAIManager")

-- 1.
autoImport ("AI_Creature")
autoImport ("AI_CreatureFlyFollow")
autoImport ("AI_CreatureWalkFollow")
autoImport ("AI_CreatureLookAt")
-- 2. 
-- because AI_CMD_Myself_XXX used AI_CMD_XXX to be metatable
-- and AI_Myself will set AI_CMD_Myself_XXX.XXX = ?
autoImport ("AI_Myself")

autoImport ("FactoryAICMD")