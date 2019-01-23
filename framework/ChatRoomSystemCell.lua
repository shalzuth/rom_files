local baseCell = autoImport("BaseCell")
ChatRoomSystemCell = reusableClass("ChatRoomSystemCell",baseCell)
ChatRoomSystemCell.PoolSize = 60

ChatRoomSystemCell.rid = ResourcePathHelper.UICell("ChatRoomSystemCell")

function ChatRoomSystemCell:Construct(asArray, args)
	self._alive = true
	self:DoConstruct(asArray, args)
end

function ChatRoomSystemCell:Deconstruct()
	self._alive = false

	self.data = nil

	Game.GOLuaPoolManager:AddToChatPool(self.gameObject)
end

function ChatRoomSystemCell:Alive()
	return self._alive
end

-- override begin
function ChatRoomSystemCell:DoConstruct(asArray, args)
	self.parent = args

	if self.gameObject == nil then
		self:CreateSelf(self.parent)
		self:FindObjs()
	else
		self.gameObject = Game.GOLuaPoolManager:GetFromChatPool(self.gameObject,self.parent)
	end
end

function ChatRoomSystemCell:Finalize()
	ChatRoomSystemCell.super.ClearEvent(self)

	GameObject.Destroy(self.gameObject)
end

function ChatRoomSystemCell:ClearEvent()

end
-- override end

function ChatRoomSystemCell:CreateSelf(parent)
	if parent then
		self.gameObject = self:CreateObj(ChatRoomSystemCell.rid,parent)
	end	
end

function ChatRoomSystemCell:FindObjs()
	self.SystemMessage = self.gameObject:GetComponent(UILabel)
	self.top = self:FindGO("Top"):GetComponent(UIWidget)
end

local text,contents
function ChatRoomSystemCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data ~= nil then
		-- local params = data:GetStr().params
		-- local content = data:GetStr().content
		-- local text = params and MsgParserProxy.Instance:TryParse(content,unpack(params)) or content

		--todo xde
		text = OverseaHostHelper:FilterLangStr(data:GetStr()) --MsgParserProxy.Instance:ReplaceIconInfo(data:GetStr())
	
		contents = text.."\n"
		local color = ChatRoomProxy.Instance.channelColor[data:GetChannel()]
		if color then
			contents = color..text.."[-]\n"
		end

		self.SystemMessage.text = contents
	end
end