autoImport("SkillTip");
BeingSkillTip = class("BeingSkillTip" ,SkillTip)

local tmpCreature = {}
function BeingSkillTip:Init()
	BeingSkillTip.super.Init(self)
	self.calPropAffect = false
end

function BeingSkillTip:SetData(data)
	self.beingData = data.beingData

	if(tmpCreature.data==nil) then
		local serverData = SceneMap_pb.MapNpc()
		serverData.npcID = self.beingData.profession
		tmpCreature.data = PetData.CreateAsTable(serverData)
	else
		local d = Table_Monster[self.beingData.profession]
		if(d==nil) then
			d = Table_Npc[self.beingData.profession]
		end
		tmpCreature.data.staticData = d
	end

	BeingSkillTip.super.SetData(self,data)
end

function BeingSkillTip:GetCreature()
	return tmpCreature
end

local sb = LuaStringBuilder.new()
function BeingSkillTip:GetCondition(skillData,nextID)
	local str = BeingSkillTip.super.GetCondition(self,skillData,nextID)
	if(not self.data.learned) then
		local fitLevel,needLevel = self.beingData:CheckBeing(self)
		sb:Clear()
		sb:AppendLine(str)
		sb:Append(string.format(fitLevel and ZhString.SkillTip_FitBaseLV or ZhString.SkillTip_NeedFitBaseLV,self.beingData.beingStaticData.NameZh,needLevel))
		return sb:ToString()
	end
	return str
end

function BeingSkillTip:OnExit()
	return BeingSkillTip.super.OnExit(self)
end