QuestMiniMapEffectManager = class("QuestMiniMapEffectManager")

local tempVector3 = LuaVector3.zero
function QuestMiniMapEffectManager:ctor()
	self.deltaTime = 0
	self.questMap = {}
	self.effectObjs = {}
	self._effectPath = EffectMap.Maps.TaskAperture
end

function QuestMiniMapEffectManager:Launch()
	if self.running then
		return
	end
	self.running = true
end

function QuestMiniMapEffectManager.OnEffectCreated( effectHandle,map )
	map.creating = false
	map.effectObj = effectHandle.gameObject
	if(Slua.IsNull(map.effectObj) == false) then
		map.effectObj:SetActive(false)
	end
end

function QuestMiniMapEffectManager:_CreateEffect(map)
	if(Slua.IsNull(map.effectObj) and not map.creating) then
		map.creating = true
		map.effect = Asset_Effect.PlayAt(
			self._effectPath, 
			LuaGeometry.Const_V3_zero,
			self.OnEffectCreated,map
		)
	end
end

function QuestMiniMapEffectManager:RemoveQuestEffect(id)
	local map = self.questMap[id]
	if(map)then
		GameFacade.Instance:sendNotification(MainViewEvent.RemoveQuestFocus,id)
		self:HideEffect(id)
		if(not Slua.IsNull(map.effectObj)) then
			local effect = {
				["effect"] = map.effect,
				["effectObj"] = map.effectObj,
			}	
			table.insert(self.effectObjs,effect)
		end
		TableUtility.TableClear(map)	
		self.questMap[id] = nil
		return map
	end
end

function QuestMiniMapEffectManager:AddQuestEffect(id)
	-- if(self.questId)then
	-- 	GameFacade.Instance:sendNotification(MainViewEvent.RemoveQuestFocus,self.questId)
	-- end
	local map = self.questMap[id]
	if(map)then
		map.hasNotifiy = false
	else	
		map = {
			["hasNotifiy"] = false,
			["effectObj"] = nil,
			["effect"] = nil,
			["creating"] = false,
			["isShow"] = false,
		}

		if(#self.effectObjs == 0)then
			self:_CreateEffect(map)
		else
			local effect = table.remove(self.effectObjs)
			if(Slua.IsNull(effect.effectObj)) then
				self:_CreateEffect(map)
			else
				map.effectObj = effect.effectObj
				map.effect = effect.effect
			end
			if(map.effectObj)then
				map.effectObj:SetActive(false)
			end
		end
		self.questMap[id] = map
		self:Update()
	end
end

function QuestMiniMapEffectManager:Shutdown()
	if not self.running then
		return
	end
	self.running = false
	self:_DestroyEffect()
end

function QuestMiniMapEffectManager:Update(time, deltaTime)
	if not self.running then
		return
	end
	-- if(self._isShow)then
	-- 	return
	-- end
	if(not next(self.questMap))then
		return
	end
	if(self.deltaTime < 1 and deltaTime)then
		self.deltaTime = self.deltaTime +deltaTime
		return
	end
	-- helplog("time:"..tostring(time).." deltaTime:"..tostring(deltaTime))
	
	self.deltaTime = 0

	for k,v in pairs(self.questMap) do
		if(not v.hasNotifiy)then
			local id = k
			local pos,epId = FunctionQuestDisChecker.Me():getTargetPos(id)
			if(epId and pos)then
				-- helplog("pos,epId = FunctionQuestDisChecker.Me():getT",epId)
				if(not Game.AreaTrigger_ExitPoint:IsInvisible( epId ))then
					-- helplog("pos,epId = FunctionQuestDisChecker.Me()11")
					self:ShowEffect(id,pos)
				else
					-- helplog("pos,epId = FunctionQuestDisChecker.Me()22")
					self:HideEffect(id)
				end
			elseif(pos)then
				self:ShowEffect(id,pos)				
			else
				self:HideEffect(id)
			end
		end
	end
end

function QuestMiniMapEffectManager:_DestroyEffect()
	for k,v in pairs(self.questMap) do
		self:RemoveQuestEffect(k)
	end
end

function QuestMiniMapEffectManager:ShowMiniMapDirEffect(id)
	local map = self.questMap[id]
	if(map and map.isShow)then
		GameFacade.Instance:sendNotification(MiniMapEvent.ShowMiniMapDirEffect,id)
	end
	
end

function QuestMiniMapEffectManager:HideEffect(id)
	local map = self.questMap[id]
	if(map)then
		if(Slua.IsNull(map.effectObj)==false) then
			map.effectObj:SetActive(false)
		end
		map.isShow = false
		map.hasNotifiy = false
		GameFacade.Instance:sendNotification(MainViewEvent.RemoveQuestFocus,id)
	end
end

function QuestMiniMapEffectManager:ShowEffect(id,pos)
	local map = self.questMap[id]
	if(map)then

		if(Slua.IsNull(map.effectObj)) then
			self:_CreateEffect(map)
			return
		end	
		if(pos)then
			NavMeshUtility.Better_Sample(pos, tempVector3)
			map.isShow = true
			if(Slua.IsNull(map.effectObj)==false) then
				map.effectObj:SetActive(true)		
				map.effectObj.transform.localPosition = tempVector3
			end
			local array = ReusableTable.CreateArray()
			array[1] = id
			array[2] = tempVector3
			GameFacade.Instance:sendNotification(MainViewEvent.AddQuestFocus,array)
			ReusableTable.DestroyAndClearArray(array)
			map.hasNotifiy = true
		else
			self:HideEffect(id)
		end
	end	
end