SceneFilterProxy = class('SceneFilterProxy', pm.Proxy)

SceneFilterProxy.NAME = "SceneFilterProxy"
SceneFilterProxy.Instance = nil
--场景管理，场景的加载队列管理等

function SceneFilterProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SceneFilterProxy.NAME
	if(SceneFilterProxy.Instance == nil) then
		SceneFilterProxy.Instance = self
	end
	
	if data ~= nil then
		self:setData(data)
	end
	self.idMap = {}
	self.inVisibleLayer = RO.Config.Layer.INVISIBLE.Value
	self.handlerMap = {}
	self.handlerMap[SceneFilterDefine.Content.BloodBar] = self.BloodBarHandler
	self.handlerMap[SceneFilterDefine.Content.UINameTitleGuild] = self.NameTitleHandler
	self.handlerMap[SceneFilterDefine.Content.UIChatSkill] = self.ChatSkillHandler
	self.handlerMap[SceneFilterDefine.Content.Emoji] = self.EmojiHandler
	self.handlerMap[SceneFilterDefine.Content.TopFrame] = self.TopFrameHandler
	self.handlerMap[SceneFilterDefine.Content.Model] = self.ModelHandler
	self.handlerMap[SceneFilterDefine.Content.QuestUI] = self.QuestUIHandler
	self.handlerMap[SceneFilterDefine.Content.HurtNum] = self.HurtNumHandler
	self.handlerMap[SceneFilterDefine.Content.FloatRoleTop] = self.FloatRoleTopHandler
	self:InitConfigs()
end

function SceneFilterProxy:InitConfigs()
	self.groupConfig = {}
	for k,v in pairs(Table_ScreenFilter) do
		local group = self.groupConfig[v.Group]
		if(not group) then
			group = {}
			self.groupConfig[v.Group] = group
		end
		group[v.id] = v
	end
end

function SceneFilterProxy:Clear()
	self.idMap = {}
end

function SceneFilterProxy:GetMap(id)
	local map = self.idMap[id]
	if(not map) then
		map = {}
		self.idMap[id] = map
	end
	return map
end

function SceneFilterProxy:RemoveCreature(id)
	for k,map in pairs(self.idMap) do
		map[id] = nil
	end
end

function SceneFilterProxy:SceneFilterUnCheckById(id)
	local map = self:GetMap(id)
	local conf = Table_ScreenFilter[id]
	local creature
	local proxy = SceneCreatureProxy
	for k,v in pairs(map) do
		creature = proxy.FindCreature(k)
		if(creature) then
			self:SceneFilterUnCheck(id,creature,conf,map)
		else
			map[k] = nil
		end
	end
end

function SceneFilterProxy:SceneFilterCheck(id,creature)
	local conf = Table_ScreenFilter[id]
	if(conf) then
		local map = self:GetMap(id)
		map[creature.data.id] = creature.data.id
		for i=1,#conf.Content do
			-- print(conf.Content[i])
			self.handlerMap[conf.Content[i]](self,creature,id,true)
		end
	end
end

function SceneFilterProxy:SceneFilterUnCheck(id,creature,conf,map)
	conf = conf or Table_ScreenFilter[id]
	if(conf) then
		map = map or self:GetMap(id)
		map[creature.data.id] = nil
		for i=1,#conf.Content do
			self.handlerMap[conf.Content[i]](self,creature,id,false)
		end
	end
end

function SceneFilterProxy:BloodBarHandler(creature,reason,check)
	if(check) then
		FunctionPlayerUI.Me():MaskBloodBar(creature,reason)
	else
		FunctionPlayerUI.Me():UnMaskBloodBar(creature,reason)
	end
end

function SceneFilterProxy:NameTitleHandler(creature,reason,check)
	if(check) then
		FunctionPlayerUI.Me():MaskNameHonorFactionType(creature,reason)
	else
		FunctionPlayerUI.Me():UnMaskNameHonorFactionType(creature,reason)
	end
end

function SceneFilterProxy:ChatSkillHandler(creature,reason,check)
	if(check) then
		FunctionPlayerUI.Me():MaskChatSkill(creature,reason)
	else
		FunctionPlayerUI.Me():UnMaskChatSkill(creature,reason)
	end
end

function SceneFilterProxy:TopFrameHandler(creature,reason,check)
	if(check) then
		FunctionPlayerUI.Me():MaskTopFrame(creature,reason)
	else
		FunctionPlayerUI.Me():UnMaskTopFrame(creature,reason)
	end
end

function SceneFilterProxy:EmojiHandler(creature,reason,check)
	if(check) then
		FunctionPlayerUI.Me():MaskEmoji(creature,reason)
	else
		FunctionPlayerUI.Me():UnMaskEmoji(creature,reason)
	end
end

function SceneFilterProxy:ModelHandler(creature,reason,check)
	-- LogUtility.Info(string.format("%s ModelHandler屏蔽 %s", creature.data:GetName(),check))
	creature:SetVisible(not check,reason)
end

function SceneFilterProxy:QuestUIHandler(creature,reason,check)
	if(check) then
		FunctionPlayerUI.Me():MaskQuestUI(creature,reason)
	else
		FunctionPlayerUI.Me():UnMaskQuestUI(creature,reason)
	end
end

function SceneFilterProxy:HurtNumHandler(creature,reason,check)
	if(check) then
		FunctionPlayerUI.Me():MaskHurtNum(creature,reason)
	else
		FunctionPlayerUI.Me():UnMaskHurtNum(creature,reason)
	end
end

function SceneFilterProxy:FloatRoleTopHandler(creature,reason,check)
	if(check) then
		FunctionPlayerUI.Me():MaskFloatRoleTop(creature,reason)
	else
		FunctionPlayerUI.Me():UnMaskFloatRoleTop(creature,reason)
	end
end