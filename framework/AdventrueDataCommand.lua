AdventrueDataCommand = class("AdventrueDataCommand",pm.SimpleCommand)

function AdventrueDataCommand:execute(note)
	if(note~=nil)then
		if(note.name == ServiceEvent.SceneManualQueryManualData) then
			self:ReInit(note)
		elseif(note.name == ServiceEvent.SceneManualManualUpdate)then
			self:Update(note)
		end
	end
end

function AdventrueDataCommand:ReInit(note)
	self:resetData(note,false)
end

function AdventrueDataCommand:Update(note)
	self:resetData(note,true)
end

function AdventrueDataCommand:resetData( note ,isUpdate)
	-- body
	local ManualData = note.body
	local type 
	if(ManualData.update)then
		type = ManualData.update.type
	elseif ManualData.item then
		type = ManualData.item.type
	end
	local bagData = AdventureDataProxy.Instance.bagMap[type]
	if(bagData ~=nil and self:NeedServerSync(type)) then
		if(isUpdate)then
			bagData:UpdateItems(ManualData.update,type)
			-- printRed("SceneManualManualUpdate")
			self.facade:sendNotification(AdventureDataEvent.SceneManualManualUpdate)
		else
			bagData:UpdateItems(ManualData.item,type)
			-- printRed("SceneManualQueryManualData")
			self.facade:sendNotification(AdventureDataEvent.SceneManualQueryManualData)
			EventManager.Me():PassEvent(AdventureDataEvent.SceneManualManualInit)
		end
	end
end

function AdventrueDataCommand:NeedServerSync(type)
	-- for i=1,#AdventureDataProxy.NoServerSyncType do
	-- 	local single = AdventureDataProxy.NoServerSyncType[i]
	-- 	if(single == type)then
	-- 		return false
	-- 	end
	-- end
	return true
end