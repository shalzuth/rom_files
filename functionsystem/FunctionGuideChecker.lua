FunctionGuideChecker = class("FunctionGuideChecker")

function FunctionGuideChecker.Me(  )
	-- body
	if nil == FunctionGuideChecker.me then
		FunctionGuideChecker.me = FunctionGuideChecker.new()
	end
	return FunctionGuideChecker.me
end

function FunctionGuideChecker:ctor()
	self.quests = {}
	TimeTickManager.Me():CreateTick(0,1000,self.Update,self)
end

function FunctionGuideChecker:AddGuideCheck(questData)
	local id = questData.id

	self.quests[id] = questData
end

function FunctionGuideChecker.RemoveGuideCheck( id )
	-- body
	if(FunctionGuideChecker.me)then
		FunctionGuideChecker.Me():RemoveGuideCheckById(id)
	end
end

function FunctionGuideChecker:RemoveGuideCheckById(id)
	-- printRed("FunctionGuideChecker:RemoveQuestCheck(id):Update",id)

	self.quests[id] = nil
	local count = 0
	for _ in pairs(self.quests) do 
		count = count + 1 
	end
	if count <1 then
		self:stopChecker()
	end
end

function FunctionGuideChecker:stopChecker()
	TimeTickManager.Me():ClearTick(self)
	FunctionGuideChecker.me = nil
end


function FunctionGuideChecker:Update(deltaTime)	
	for _,questData in pairs(self.quests) do
		self:tryStartGuide(questData)
	end
end

function FunctionGuideChecker:tryStartGuide(questData)	
	local guideId = questData.params.guideID
	local guideData = Table_GuideID[guideId]
	if(guideData)then	
		local tag =guideData.ButtonID	
		if(tag)then			
			local tagObj = GuideTagCollection.getGuideItemById(tag)
			if(tagObj and not GameObjectUtil.Instance:ObjectIsNULL(tagObj) and tagObj.gameObject.activeInHierarchy)then
				FunctionGuide.Me():showGuideByQuestData(questData)
				self:RemoveGuideCheckById(questData.id)
			end
		else
			self:RemoveGuideCheckById(questData.id)
		end
	else
		self:RemoveGuideCheckById(questData.id)
	end
end