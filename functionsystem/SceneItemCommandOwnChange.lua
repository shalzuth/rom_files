
SceneItemCommandOwnChange = class("SceneItemCommandOwnChange")

function SceneItemCommandOwnChange.Me()
	if nil == SceneItemCommandOwnChange.me then
		SceneItemCommandOwnChange.me = SceneItemCommandOwnChange.new()
	end
	return SceneItemCommandOwnChange.me
end

function SceneItemCommandOwnChange:ctor()
	self:Reset()
end

function SceneItemCommandOwnChange:Reset()
	self:Clear()
	if(self.timeTick==nil) then
		self.timeTick = TimeTickManager.Me():CreateTick(0,16,self.Tick,self)
	end
	-- self.timeTick:ClearTick()
end

function SceneItemCommandOwnChange:Clear()
	self.canPickItems = {}
	self.canPickItems = {}
end

-- function SceneItemCommandOwnChange:AddItems(items)
-- 	for i=1,#items do
-- 		self:AddItem(items[i])
-- 	end
-- end

function SceneItemCommandOwnChange:AddItem(item)
	self.timeTick:StartTick()
	
	return nil
end

function SceneItemCommandOwnChange:RemoveItems(items)
	for i=1,#items do
		self:RemoveItem(items[i])
	end
end

function SceneItemCommandOwnChange:RemoveItem(item)
	self.timeTick:StopTick()
end

function SceneItemCommandOwnChange:Tick(deltaTime)
	-- print("tick "..deltaTime)
end