
FunctionSceneItemOwnChange = class("FunctionSceneItemOwnChange")

function FunctionSceneItemOwnChange.Me()
	if nil == FunctionSceneItemOwnChange.me then
		FunctionSceneItemOwnChange.me = FunctionSceneItemOwnChange.new()
	end
	return FunctionSceneItemOwnChange.me
end

function FunctionSceneItemOwnChange:ctor()
	self:Reset()
end

function FunctionSceneItemOwnChange:Reset()
	if(self.timeTick==nil) then
		self.timeTick = TimeTickManager.Me():CreateTick(0,16,self.Tick,self)
	end
	-- self.timeTick:ClearTick()
end

function FunctionSceneItemOwnChange:AddItems(items)
	for i=1,#items do
		self:AddItem(items[i])
	end
end

function FunctionSceneItemOwnChange:AddItem(item)
	self.timeTick:StartTick()
	
	return nil
end

function FunctionSceneItemOwnChange:RemoveItems(items)
	for i=1,#items do
		self:RemoveItem(items[i])
	end
end

function FunctionSceneItemOwnChange:RemoveItem(item)
	self.timeTick:StopTick()
end

function FunctionSceneItemOwnChange:Tick(deltaTime)
	-- print("tick "..deltaTime)
end