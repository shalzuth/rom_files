autoImport("OnGroundSceneItemCommand")
DropSceneItemCommand = class("DropSceneItemCommand")

function DropSceneItemCommand.Me()
	if nil == DropSceneItemCommand.me then
		DropSceneItemCommand.me = DropSceneItemCommand.new()
	end
	return DropSceneItemCommand.me
end

function DropSceneItemCommand:ctor()
	self.onGroundCmd = OnGroundSceneItemCommand.Me()
	self.configPrivateOwnTime = GameConfig.SceneDropItem.privateOwnTime
	self:Reset()
end

function DropSceneItemCommand:Reset()
	self.waiting = {}
	self.dropping = {}
	if(self.timeTick==nil) then
		self.timeTick = TimeTickManager.Me():CreateTick(0,33,self.Tick,self)
	end
end

function DropSceneItemCommand:Clear()
	for _, item in pairs(self.waiting) do
		item:DestorySelf(true)
 	end
 	for _, item in pairs(self.dropping) do
		item:DestorySelf(true)
 	end
	self.waiting = {}
	self.dropping = {}
end

function DropSceneItemCommand:AddItems(items)
	for i=1,#items do
		self:AddItem(items[i])
	end
end

function DropSceneItemCommand:AddItem(item)
	-- print("掉落物的专属拥有时间"..item.privateOwnLeftTime)
	if(item.privateOwnLeftTime<self.configPrivateOwnTime) then
		item:Appear()
		self:DropOnGround(item,item.privateOwnLeftTime<=0 or item.iCanPickUp)
	else
		self:AddToWaitDrop(item)
	end
	return nil
end

function DropSceneItemCommand:AddToWaitDrop(item)
	self.waiting[item.id] = item
end

function DropSceneItemCommand:AddToDropping(item)
	self.waiting[item.id] = nil
	self.dropping[item.id] = item
	item.privateOwnLeftTime = self.configPrivateOwnTime
	item:SetOnGroundCallBack(self.DropOnGround,self,item.iCanPickUp)
	item:PlayAppear()
end

function DropSceneItemCommand:DropOnGround(item,hasRight)
	self.dropping[item.id] = nil
	if(item.config.ShowName) then
		item:ShowName()
	end
	if(hasRight) then
		self.onGroundCmd:AddToHasRightPick(item)
	else
		self.onGroundCmd:AddToNoRightPick(item)
	end
end

-- function DropSceneItemCommand:SetRemoveFlags(guids)
-- 	local id = 0
-- 	for i=1,#guids do
-- 		id = guids[i]
-- 		self:SetRemoveFlag(id)
-- 	end
-- end

function DropSceneItemCommand:SetRemoveFlag(id)
	if(self:RemoveWaitDrop(id)==false) then
		if(self:RemoveDropping(id)==false) then
			self.onGroundCmd:SetRemoveFlag(id)
		end
	end
end

function DropSceneItemCommand:RemoveWaitDrop(guid)
	local dropItem = self.waiting[guid]
	if(dropItem~=nil) then
		-- print("remove waiting.."..guid)
		dropItem:DestorySelf()
		self.waiting[guid] = nil
		return true
	end
	return false
end

function DropSceneItemCommand:ForceRemove(item)
	if(item~=nil) then
		-- print("remove Dropping.."..item.id)
		item:DestorySelf()
		self.dropping[item.id] = nil
	end
end

function DropSceneItemCommand:RemoveDropping(guid,force)
	local dropItem = self.dropping[guid]
	if(dropItem~=nil) then
		if(force) then
			self:ForceRemove(dropItem)
		else
			-- print("delay remove Dropping.."..guid)
			dropItem:SetDestroyFlag(self.ForceRemove,self)
		end
		return true
	end
	return false
end

function DropSceneItemCommand:PickUpDropping(creature,guid)
	local dropItem = self.dropping[guid]
	if(dropItem~=nil) then
		dropItem:SetPickUpFlag(self.onGroundCmd.Pick,self.onGroundCmd,creature.data.id)
		return true
	end
	return false
end

function DropSceneItemCommand:RemoveItems(items)
	for i=1,#items do
		self:RemoveItem(items[i])
	end
end

function DropSceneItemCommand:RemoveItem(item)
	self.waiting[item.id] = nil
	self.dropping[item.id] = nil
	item:DestorySelf()
end

function DropSceneItemCommand:Tick(deltaTime)
	self:TickWaiting(deltaTime)
end

function DropSceneItemCommand:TickWaiting(deltaTime)
	for id,item in pairs(self.waiting) do
		item.privateOwnLeftTime = item.privateOwnLeftTime - deltaTime
		if(item.privateOwnLeftTime<=self.configPrivateOwnTime) then
			self:AddToDropping(item)
		end
	end
end