local baseCell = autoImport("BaseCell")
ChatBarrageCell = reusableClass("ChatBarrageCell",baseCell)
ChatBarrageCell.PoolSize = 12

local resID = ResourcePathHelper.UICell("ChatBarrageCell")
local tmpPos = LuaVector3(0,0,0)

function ChatBarrageCell:FindObjs()
	self.label = self.gameObject:GetComponent(UILabel)
	self.tweenPosition = self.gameObject:GetComponent(TweenPosition)
end

function ChatBarrageCell:SetData(data)
	if data then
		self.label.text = data.name..ZhString.Colon..data.text
		self.label.fontSize = math.random(GameConfig.Barrage.ScreenMin, GameConfig.Barrage.ScreenMax)

		local h = math.random(self:GetMinH(), self:GetMaxH())

		self.tweenPosition.duration = math.random(GameConfig.Barrage.DurationMin, GameConfig.Barrage.DurationMax)
		tmpPos:Set(640, 
					h , 
					0)
		self.tweenPosition.from = tmpPos
		tmpPos:Set(-640 - self.label.localSize.x, 
					h , 
					0)
		self.tweenPosition.to = tmpPos
		self.tweenPosition:ResetToBeginning()
		self.tweenPosition:PlayForward()

		self.tweenPosition:SetOnFinished(function ()
			ReusableObject.Destroy(self)
		end)
	end
end

function ChatBarrageCell:SetMaxH(maxH)
	self.maxH = maxH
end

function ChatBarrageCell:GetMaxH()
	if self.maxH == nil then
		local activeH = GameObjectUtil.Instance:GetUIActiveHeight(self.gameObject)
		self.maxH = activeH / 2
	end

	return self.maxH
end

function ChatBarrageCell:SetMinH(minH)
	self.minH = minH
end

function ChatBarrageCell:GetMinH()
	if self.minH == nil then
		self.minH = self.label.localSize.y
	end

	return self.minH
end

function ChatBarrageCell:CreateSelf(parent)
	self.gameObject = Game.AssetManager_UI:CreateChatAsset(resID,parent)
end

function ChatBarrageCell:Construct(asArray, args)
	self._alive = true
	self:DoConstruct(asArray, args)
end

function ChatBarrageCell:Deconstruct()
	self._alive = false
	self.data = nil
	self.maxH = nil
	self.minH = nil
	Game.GOLuaPoolManager:AddToChatPool(self.gameObject)
end

function ChatBarrageCell:Alive()
	return self._alive
end

-- override begin
function ChatBarrageCell:DoConstruct(asArray, parent)
	if self.gameObject == nil then
		self:CreateSelf(parent)
		self:FindObjs()
	else
		self.gameObject = Game.GOLuaPoolManager:GetFromChatPool(self.gameObject,parent)
	end
end

function ChatBarrageCell:Finalize()
	GameObject.Destroy(self.gameObject)
end
-- override end