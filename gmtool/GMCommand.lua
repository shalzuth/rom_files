local GMCommand = {}

function GMCommand.Execute( cmd )
	ServiceGMProxy.Instance:Call(cmd)
end

function GMCommand.ClickSkillIndex(index)
	if(index>0) then
		local skills = SkillProxy.Instance:GetCurrentEquipedSkillData(true)
		if(index<=#skills) then
			local skill = skills[index]
			if(skill.staticData~=nil) then
				FunctionSkill.Me():TryUseSkill(skill.id)
			end
		end
	end
end

return GMCommand

