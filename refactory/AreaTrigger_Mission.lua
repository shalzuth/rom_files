AreaTrigger_Mission = class("AreaTrigger_Mission")

AreaTrigger_Mission.UpdateInterval = 0.5

AreaTrigger_Mission.CheckType = {
	QuickUse = 1,
	CallBack = 2,
	ShowAreaEffect = 3,
}

function AreaTrigger_Mission:ctor()
	self.quests = {}
	self.nextUpdateTime = 0
end

function AreaTrigger_Mission:Launch()
	if self.running then
		return
	end
	self.running = true

end

function AreaTrigger_Mission:Shutdown()
	if not self.running then
		return
	end
	self.running = false

end

local distanceFunc = VectorUtility.DistanceXZ
function AreaTrigger_Mission:Update(time, deltaTime)
	if not self.running then
		return
	end

	if time < self.nextUpdateTime then
		return
	end
	self.nextUpdateTime = time + AreaTrigger_Mission.UpdateInterval

	local myselfPosition = Game.Myself:GetPosition()
	local currentSceneData = SceneProxy.Instance.currentScene
	-- LogUtility.Info("AreaTrigger_Mission:Update")
	for id,quest in pairs(self.quests) do
		if(currentSceneData:IsSameMapOrRaid(quest.map)and distanceFunc(myselfPosition,quest.pos)<=quest.reachDis) then
			self:EnterArea(quest)
		else
			self:ExitArea(quest)
		end
	end
end

function AreaTrigger_Mission:EnterArea(quest)
	if(quest.reached==false) then
		quest.reached = true
		if(quest.type == AreaTrigger_Mission.CheckType.CallBack) then
			-- LogUtility.InfoFormat("EnterArea {0}", quest.id)
			if(quest.onEnter) then
				quest.onEnter(quest.owner,quest.questData)
			end
		elseif(quest.type == AreaTrigger_Mission.CheckType.ShowAreaEffect)then
			NSceneEffectProxy.Instance:Client_AddSceneEffect(quest.id,quest.pos,EffectMap.Maps.GuideArea,false)
		else
			QuickUseProxy.Instance:AddQuestEnterAreaData(quest)
		end
	end
end

function AreaTrigger_Mission:ExitArea(quest)
	if(quest.reached==true) then
		quest.reached = false
		if(quest.type == AreaTrigger_Mission.CheckType.CallBack) then
			if(quest.onExit) then
				quest.onExit(quest.owner,quest.questData)
			end
		elseif(quest.type == AreaTrigger_Mission.CheckType.ShowAreaEffect)then
			NSceneEffectProxy.Instance:Client_RemoveSceneEffect(quest.id)
		else
			QuickUseProxy.Instance:RemoveQuestData(quest)
		end
	end
end

function AreaTrigger_Mission:RemoveQuestCheck(id)
	-- printRed("remove AreaTrigger_Mission--"..id)
	local quest = self.quests[id]
	if(quest~=nil and quest.type ~= AreaTrigger_Mission.CheckType.CallBack) then
		self:ExitArea(quest)
	end
	if (quest) then
		if(quest.pos~=nil) then
			quest.pos:Destroy()
			quest.pos = nil
		end
		ReusableTable.DestroyAndClearTable(quest)
	end
	self.quests[id] = nil
end

function AreaTrigger_Mission:ForceReCheck(id)
	local quest = self.quests[id]
	if(quest) then
		quest.reached = false
	end
end

function AreaTrigger_Mission:AddCheck(id,map,pos,reachDis,iconType,iconID,content,btn,questData,checkType,owner,onEnter,onExit)
	local quest = self.quests[id]
	if(quest==nil) then
		quest = ReusableTable.CreateTable()
		self.quests[id] = quest
	end
	-- printRed("add MissionAreaTrigger--"..id)
	quest.id = id
	quest.questData = questData
	quest.iconType = iconType
	quest.iconID = iconID
	quest.content = content
	quest.btn = btn
	quest.map = map
	quest.pos = pos and pos:Clone() or LuaVector3(0,0,0)
	quest.reachDis = reachDis or 9999999
	quest.reached = false
	quest.type = checkType
	quest.onEnter = onEnter
	quest.onExit = onExit
	quest.owner = owner
end

function AreaTrigger_Mission:AddQuickUseCheck(id,map,pos,reachDis,iconType,iconID,content,btn,questData)
	self:AddCheck(id,map,pos,reachDis,iconType,iconID,content,btn,questData,AreaTrigger_Mission.CheckType.QuickUse)
end

function AreaTrigger_Mission:AddCallBackCheck(id,map,pos,reachDis,questData,owner,onEnter,onExit)
	-- print(id,map,pos.x,pos.y,pos.z,reachDis)
	-- LogUtility.InfoFormat("AddCallBackCheck {0} {1} {2}", id,pos,reachDis)
	self:AddCheck(id,map,pos,reachDis,nil,nil,nil,nil,questData,AreaTrigger_Mission.CheckType.CallBack,owner,onEnter,onExit)
end

function AreaTrigger_Mission:AddShowAreaEffectCheck(id,map,pos,reachDis,questData)
	self:AddCheck(id,map,pos,reachDis,nil,nil,nil,nil,questData,AreaTrigger_Mission.CheckType.ShowAreaEffect)
end