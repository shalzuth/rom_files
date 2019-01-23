SceneUICommand = class("SceneUICommand", pm.SimpleCommand)

function SceneUICommand:execute(note)
	if(note.name == SceneUserEvent.SceneAddRoles)then
		if(note.body and type(note.body) == "table")then
			for k,v in pairs(note.body)do
			end
		end
	elseif(note.name == SceneUserEvent.SceneRemoveRoles or
			note.name == SceneUserEvent.SceneRemoveNpcs or
			note.name == SceneUserEvent.SceneRemovePets)then
		if(note.body and type(note.body) == "table")then
			for k,v in pairs(note.body)do
				
			end
		end
	end
end
