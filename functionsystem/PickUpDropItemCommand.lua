
PickUpDropItemCommand = class("PickUpDropItemCommand")

function PickUpDropItemCommand.Me()
	if nil == PickUpDropItemCommand.me then
		PickUpDropItemCommand.me = PickUpDropItemCommand.new()
	end
	return PickUpDropItemCommand.me
end

function PickUpDropItemCommand:ctor()
	self.onGroundCmd = OnGroundSceneItemCommand.Me()
	self.pickUpDis = GameConfig.SceneDropItem.pickUpRadius
	self:Reset()
end

function PickUpDropItemCommand:Reset()
	self:ClearFailGetNum()
	if(self.timeTick==nil) then
		self.timeTick = TimeTickManager.Me():CreateTick(0,GameConfig.SceneDropItem.pickUpInterval,self.TryPick,self)
	end
	-- self.timeTick:ClearTick()
end

function PickUpDropItemCommand:ClearFailGetNum()
	self.failGetMinNum= 0
end

function PickUpDropItemCommand:AddItem(item)
	self.timeTick:StartTick()
	
	return nil
end

function PickUpDropItemCommand:RemoveItems(items)
	for i=1,#items do
		self:RemoveItem(items[i])
	end
end

function PickUpDropItemCommand:StopAutoPick()
	self.timeTick:StopTick()
end

function PickUpDropItemCommand:TryPick(deltaTime)
	local pickedUp = self:GetPickUpItem(self.onGroundCmd.hasPickRight)
	if(pickedUp==nil) then
		pickedUp = self:GetPickUpItem(self.onGroundCmd.noPickRight,true)
		if(pickedUp~=nil) then
			pickedUp:FailGet()
			-- print("尝试获取.."..pickedUp.id)
		end
	else
		self:ClearFailGetNum()
		if(Game.Myself~=nil) then
			ServiceMapProxy.Instance:CallPickupItem(nil,pickedUp.id)
		else
			local t = {roleAgent=Player.Me.role}
			FunctionSceneItemCommand.Me():PickUpItem(t,pickedUp.id)
		end
		-- print("给服务器发送拾取我可以拾取的物品.."..pickedUp.id)
	end
end

function PickUpDropItemCommand:GetPickUpItem(items,calCount)
	local myselfPos
	if(Game.Myself) then
		myselfPos = Game.Myself:GetPosition()
		if(myselfPos == nil) then
			return
		end
	end
	local dis = self.pickUpDis
	local minDisItem = nil
	local minGetCountItem = nil
	local tempDis = 0
	local x,z
	for k,v in pairs(items) do
		x = math.abs(myselfPos[1] -v.pos.x)
		z =  math.abs(myselfPos[3] -v.pos.z)
		if(x<=dis and z<=dis and v.isPicked == false) then
			tempDis = math.sqrt(x * x + z * z)
			-- temps[#temps+1] = v
			if(tempDis<=dis) then
				minDisItem = v
				dis = tempDis
			end
			if(calCount) then
				if(minGetCountItem==nil) then minGetCountItem = minDisItem or v
				elseif(v.failedGetCount < minGetCountItem.failedGetCount) then 
					minGetCountItem = v
				end
			end
		end
	end
	if(minGetCountItem~=nil) then
		if(self.failGetMinNum<minGetCountItem.failedGetCount) then
			self.failGetMinNum = minGetCountItem.failedGetCount
		else
			minGetCountItem.failedGetCount = self.failGetMinNum
		end
	end
	return (minGetCountItem or minDisItem)
end