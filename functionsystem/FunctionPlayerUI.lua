FunctionPlayerUI = class("FunctionPlayerUI")

PUIVisibleReason = {
	HidingSkill = 999999,
	CarrierWait = 999998,
	CJ = 999997,
	OutOfMyRange = 999996,
	CatLitterBox = 999995,
}

function FunctionPlayerUI.Me()
	if nil == FunctionPlayerUI.me then
		FunctionPlayerUI.me = FunctionPlayerUI.new()
	end
	return FunctionPlayerUI.me
end

function FunctionPlayerUI:ctor()
end

function FunctionPlayerUI:MaskAllUI(creature,reason,autoSend)
	self:MaskUI(creature,reason,MaskPlayerUIType.BloodType)
	self:MaskUI(creature,reason,MaskPlayerUIType.NameHonorFactionType)
	self:MaskUI(creature,reason,MaskPlayerUIType.ChatSkillWord)
	self:MaskUI(creature,reason,MaskPlayerUIType.Emoji)
	self:MaskUI(creature,reason,MaskPlayerUIType.TopFrame)
	self:MaskUI(creature,reason,MaskPlayerUIType.QuestUI)
	self:MaskUI(creature,reason,MaskPlayerUIType.HurtNum)
	self:MaskUI(creature,reason,MaskPlayerUIType.FloatRoleTop)
end

function FunctionPlayerUI:MaskUI(creature,reason,uiType,autoSend)
	creature:MaskUI(reason,uiType)
end

function FunctionPlayerUI:UnMaskAllUI(creature,reason,autoSend)
	self:UnMaskUI(creature,reason,MaskPlayerUIType.BloodType)
	self:UnMaskUI(creature,reason,MaskPlayerUIType.NameHonorFactionType)
	self:UnMaskUI(creature,reason,MaskPlayerUIType.ChatSkillWord)
	self:UnMaskUI(creature,reason,MaskPlayerUIType.Emoji)
	self:UnMaskUI(creature,reason,MaskPlayerUIType.TopFrame)
	self:UnMaskUI(creature,reason,MaskPlayerUIType.QuestUI)
	self:UnMaskUI(creature,reason,MaskPlayerUIType.HurtNum)
	self:UnMaskUI(creature,reason,MaskPlayerUIType.FloatRoleTop)
end

function FunctionPlayerUI:UnMaskUI(creature,reason,uiType,autoSend)
	creature:UnMaskUI(reason,uiType)
end

function FunctionPlayerUI:CreatureMaskBy(id,uiType)
	local creature = SceneCreatureProxy.FindCreature(id)
	if(creature and creature.sceneui) then
		return creature.sceneui:MaskByType(uiType)
	end
	return false
end

function FunctionPlayerUI:IsMaskBloodBar(id)
	return self:CreatureMaskBy(id,MaskPlayerUIType.BloodType)
end

function FunctionPlayerUI:IsMaskNameAndFaction(id)
	return self:CreatureMaskBy(id,MaskPlayerUIType.NameHonorFactionType)
end

function FunctionPlayerUI:IsMaskChatSkillWord(id)
	return self:CreatureMaskBy(id,MaskPlayerUIType.ChatSkillWord)
end

function FunctionPlayerUI:IsMaskEmoji(id)
	return self:CreatureMaskBy(id,MaskPlayerUIType.Emoji)
end

function FunctionPlayerUI:IsMaskTopFrame(id)
	return self:CreatureMaskBy(id,MaskPlayerUIType.TopFrame)
end

function FunctionPlayerUI:IsMaskQuestUI(id)
	return self:CreatureMaskBy(id,MaskPlayerUIType.QuestUI)
end

function FunctionPlayerUI:IsMaskHurtNum(id)
	return self:CreatureMaskBy(id,MaskPlayerUIType.HurtNum)
end

function FunctionPlayerUI:MaskBloodBar(creature,reason,autoSend)
	return self:MaskUI(creature,reason,MaskPlayerUIType.BloodType,autoSend)
end

function FunctionPlayerUI:UnMaskBloodBar(creature,reason,autoSend)
	return self:UnMaskUI(creature,reason,MaskPlayerUIType.BloodType,autoSend)
end

function FunctionPlayerUI:MaskNameHonorFactionType(creature,reason,autoSend)
	return self:MaskUI(creature,reason,MaskPlayerUIType.NameHonorFactionType,autoSend)
end

function FunctionPlayerUI:UnMaskNameHonorFactionType(creature,reason,autoSend)
	return self:UnMaskUI(creature,reason,MaskPlayerUIType.NameHonorFactionType,autoSend)
end

function FunctionPlayerUI:MaskChatSkill(creature,reason,autoSend)
	return self:MaskUI(creature,reason,MaskPlayerUIType.ChatSkillWord,autoSend)
end

function FunctionPlayerUI:UnMaskChatSkill(creature,reason,autoSend)
	return self:UnMaskUI(creature,reason,MaskPlayerUIType.ChatSkillWord,autoSend)
end

function FunctionPlayerUI:MaskEmoji(creature,reason,autoSend)
	return self:MaskUI(creature,reason,MaskPlayerUIType.Emoji,autoSend)
end

function FunctionPlayerUI:UnMaskEmoji(creature,reason,autoSend)
	return self:UnMaskUI(creature,reason,MaskPlayerUIType.Emoji,autoSend)
end

function FunctionPlayerUI:MaskTopFrame(creature,reason,autoSend)
	return self:MaskUI(creature,reason,MaskPlayerUIType.TopFrame,autoSend)
end

function FunctionPlayerUI:UnMaskTopFrame(creature,reason,autoSend)
	return self:UnMaskUI(creature,reason,MaskPlayerUIType.TopFrame,autoSend)
end

function FunctionPlayerUI:MaskQuestUI(creature,reason,autoSend)
	return self:MaskUI(creature,reason,MaskPlayerUIType.QuestUI,autoSend)
end

function FunctionPlayerUI:UnMaskQuestUI(creature,reason,autoSend)
	return self:UnMaskUI(creature,reason,MaskPlayerUIType.QuestUI,autoSend)
end

function FunctionPlayerUI:MaskHurtNum(creature,reason,autoSend)
	return self:MaskUI(creature,reason,MaskPlayerUIType.HurtNum,autoSend)
end

function FunctionPlayerUI:UnMaskHurtNum(creature,reason,autoSend)
	return self:UnMaskUI(creature,reason,MaskPlayerUIType.HurtNum,autoSend)
end

function FunctionPlayerUI:MaskFloatRoleTop(creature,reason,autoSend)
	return self:MaskUI(creature,reason,MaskPlayerUIType.FloatRoleTop,autoSend)
end

function FunctionPlayerUI:UnMaskFloatRoleTop(creature,reason,autoSend)
	return self:UnMaskUI(creature,reason,MaskPlayerUIType.FloatRoleTop,autoSend)
end