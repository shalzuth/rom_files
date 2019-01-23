local SceneUserNewCommand = class("SceneUserNewCommand",pm.SimpleCommand)
-- print("print(SkillDataCommand)")
function SceneUserNewCommand:execute(note)
	if(note~=nil)then
		if(note.name == ServiceEvent.NUserVarUpdate) then
			self:NUserVarUpdate(note)
		end
	end
end

function SceneUserNewCommand:NUserVarUpdate(note)
	SceneUserNewProxy.Instance:NUserVarUpdate(note.body)
	-- print("xxxxxxxxx-----------SceneUserNewCommand-----xxxxx----NUserVarUpdate")
end
return SceneUserNewCommand