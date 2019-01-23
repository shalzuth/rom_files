
OnGroundSceneItemCommand = class("OnGroundSceneItemCommand")

function OnGroundSceneItemCommand.Me()
	if nil == OnGroundSceneItemCommand.me then
		OnGroundSceneItemCommand.me = OnGroundSceneItemCommand.new()
	end
	return OnGroundSceneItemCommand.me
end

function OnGroundSceneItemCommand:ctor()
	self:Reset()
end

function OnGroundSceneItemCommand:Clear()
	for _, item in pairs(self.hasPickRight) do
		item:DestorySelf(true)
 	end
 	for _, item in pairs(self.noPickRight) do
		item:DestorySelf(true)
 	end
	self.hasPickRight = {}
	self.noPickRight = {}
end

function OnGroundSceneItemCommand:Reset()
	self.hasPickRight = {}
	self.noPickRight = {}
	if(self.timeTick==nil) then
		self.timeTick = TimeTickManager.Me():CreateTick(0,33,self.Tick,self)
	end
	-- self.timeTick:ClearTick()
end

function OnGroundSceneItemCommand:Removes(guids)
	local id = 0
	for i=1,#guids do
		self:Remove(guids[i])
	end
end

function OnGroundSceneItemCommand:RemoveItem(item)
	self:Remove(item.id)
end

function OnGroundSceneItemCommand:Remove(id)
	-- print("remove ground.."..id)
	local item = self.hasPickRight[id]
	if(item==nil) then
		item = self.noPickRight[id]
		self.noPickRight[id] = nil
	else
		self.hasPickRight[id] = nil
	end
	if(item ~=nil) then
		item:DestorySelf()
	end
end

function OnGroundSceneItemCommand:SetRemoveFlag(id)
	local item = self.hasPickRight[id]
	if(item==nil) then
		item = self.noPickRight[id]
	end
	if(item~=nil) then
		if(not item.isPicked) then
			self.noPickRight[id] = nil
			self.hasPickRight[id] = nil
			item:DestorySelf()
		end
	end
end

function OnGroundSceneItemCommand:Pick(itemID,creatureID)
	local item = nil
	if(type(itemID) == "number") then
		item = self.hasPickRight[itemID]
		if(item==nil) then
			item = self.noPickRight[itemID]
		end
	else
		item = itemID
	end
	if(item~=nil) then
		item:Pick(self.PickSuccess,self,creatureID)
	end
end

local tmpPos = LuaVector3.zero
function OnGroundSceneItemCommand:PickSuccess(item,creatureID)
	-- if(item.config.DropPerform==1) then
	-- 	item.animPlayer.animatorHelper.loopCountChangedListener = function (state,old,new)
	-- 		if(state:IsName(GameConfig.SceneDropItem.Anims.ItemOpen)) then
	-- 			self:Remove(item.id)
	-- 		end
	-- 	end
	-- elseif(item.config.DropPerform==2) then
	-- 	self:Remove(item.id)
	-- end
	item.animPlayer.animatorHelper.loopCountChangedListener = function (state,old,new)
		if(state:IsName(GameConfig.SceneDropItem.Anims.ItemOpen)) then
			self:Remove(item.id)
		end
	end
	local creature = SceneCreatureProxy.FindCreature(creatureID)
	-- 成功拾取
	if(creature) then
		local path = GameConfig.SceneDropItem.ItemPickBall[item.staticData.Quality]
		local pos = tmpPos
		if(item.pointSub~=nil) then
			pos[1],pos[2],pos[3] = LuaGameObject.GetPosition(item.pointSub:GetEffectPoint(RoleDefines_EP.Top).transform)
		else
			pos = item.pos
		end
		creature:PlayPickUpTrackEffect(path,pos,GameConfig.SceneDropItem.ItemPickBallSpeed,item.config.pickedAudio)
	end
end

function OnGroundSceneItemCommand:AddToHasRightPick(item)
	-- print("on ground.."..item.id)
	-- self.dropping[item.id] = nil
	self.noPickRight[item.id] = nil
	self.hasPickRight[item.id] = item
	item:SetCanPickUp(true)
	item:ClearOnGroundCallBack()
	-- print(string.format("guid:%s id:%s  can pick",item.id,item.staticData.id))
end

function OnGroundSceneItemCommand:AddToNoRightPick(item)
	-- print("on ground.."..item.id)
	-- self.dropping[item.id] = nil
	self.noPickRight[item.id] = item
	item:ClearOnGroundCallBack()
	-- print(string.format("guid:%s id:%s  is On Ground",item.id,item.staticData.id))
end

function OnGroundSceneItemCommand:Tick(deltaTime)
	for id,item in pairs(self.noPickRight) do
		if(item.iCanPickUp==false) then
			item.privateOwnLeftTime = item.privateOwnLeftTime - deltaTime
			if(item.privateOwnLeftTime<=0) then
				self:AddToHasRightPick(item)
			end
		end
	end
end