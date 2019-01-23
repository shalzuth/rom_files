local baseCell = autoImport("BaseCell")
ChatKeywordCell = reusableClass("ChatKeywordCell",baseCell)
ChatKeywordCell.PoolSize = 15

local resID = ResourcePathHelper.UICell("ChatKeywordCell")

-- function ChatKeywordCell:Init()
-- 	self:FindObjs()
-- end

function ChatKeywordCell:FindObjs()
	self.sprite = self.gameObject:GetComponent(UISprite)
	self.tweenPosition = self.gameObject:GetComponent(TweenPosition)
end

local tempVector3 = LuaVector3.zero
function ChatKeywordCell:SetData(data)
	self.data = data

	if data then

		local corners = data.panel.worldCorners
		self.corners = corners
		for i=1,#corners do
			self.corners[i] = self.gameObject.transform:InverseTransformPoint(corners[i])
		end

		IconManager:SetKeyIcon( data.spriteName , self.sprite )

		tempVector3:Set(1,1,1)
		LuaVector3.Better_Mul(tempVector3 , data.size , tempVector3)
		self.gameObject.transform.localScale = tempVector3
		
		self.tweenPosition.duration = data.duration
		self.tweenPosition.from = Vector3(math.random( (self.corners[2].x + self.sprite.localSize.x / 2) , (self.corners[3].x - self.sprite.localSize.x / 2) ),
			(self.corners[2].y - self.sprite.localSize.y / 2) , 
			self.corners[2].z)
		self.tweenPosition.to = Vector3(math.random( (self.corners[1].x + self.sprite.localSize.x / 2 ) , (self.corners[4].x - self.sprite.localSize.x / 2) ),
			(self.corners[1].y + self.sprite.localSize.y / 2),
			self.corners[1].z)
		self.tweenPosition:ResetToBeginning()
		self.tweenPosition:PlayForward()

		self.tweenPosition:SetOnFinished(function ()
			-- self:DestroyCell()
			ReusableObject.Destroy(self)
		end)
	end
end

-- function ChatKeywordCell:DestroyCell()
-- 	Game.GOLuaPoolManager:AddToUIPool(ChatKeywordCell.rid , self.gameObject)
-- end

function ChatKeywordCell:CreateSelf(parent)
	self.gameObject = Game.AssetManager_UI:CreateChatAsset(resID,parent)
end

function ChatKeywordCell:Construct(asArray, args)
	self._alive = true
	self:DoConstruct(asArray, args)
end

function ChatKeywordCell:Deconstruct()
	self._alive = false
	self.data = nil
	Game.GOLuaPoolManager:AddToChatPool(self.gameObject)
end

function ChatKeywordCell:Alive()
	return self._alive
end

-- override begin
function ChatKeywordCell:DoConstruct(asArray, parent)
	if self.gameObject == nil then
		self:CreateSelf(parent)
		self:FindObjs()
	else
		self.gameObject = Game.GOLuaPoolManager:GetFromChatPool(self.gameObject,parent)
		tempVector3:Set(0,0,0)
		self.gameObject.transform.localPosition = tempVector3
		tempVector3:Set(1,1,1)
		self.gameObject.transform.localScale = tempVector3
	end
end

function ChatKeywordCell:Finalize()
	GameObject.Destroy(self.gameObject)
end
-- override end