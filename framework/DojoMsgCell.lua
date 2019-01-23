local baseCell = autoImport("BaseCell")
DojoMsgCell = reusableClass("DojoMsgCell",baseCell)
DojoMsgCell.PoolSize = 10

DojoMsgCell.rid = ResourcePathHelper.UICell("DojoMsgCell")

function DojoMsgCell:Construct(asArray, args)
	self._alive = true
	self:DoConstruct(asArray, args)
end

function DojoMsgCell:Deconstruct()
	self._alive = false

	self.data = nil

	Game.GOLuaPoolManager:AddToChatPool(self.gameObject)
end

function DojoMsgCell:Alive()
	return self._alive
end

function DojoMsgCell:DoConstruct(asArray, args)
	self.cellType = args.cellType
	self.parent = args.parent

	if self.gameObject == nil then
		self:CreateSelf(self.parent)
		self:FindObjs()
	else
		self.gameObject = Game.GOLuaPoolManager:GetFromChatPool(self.gameObject,self.parent)
	end
end

function DojoMsgCell:Finalize()
	DojoMsgCell.super.ClearEvent(self)

	GameObject.Destroy(self.gameObject)
end

function DojoMsgCell:CreateSelf(parent)
	if parent then
		self.gameObject = self:CreateObj(DojoMsgCell.rid,parent)
	end
end

function DojoMsgCell:FindObjs()
	self.bg = self:FindGO("Bg"):GetComponent(UISprite)
	self.bgline = self:FindGO("Bgline"):GetComponent(UISprite)
	self.content = self:FindGO("Content"):GetComponent(UILabel)
end

function DojoMsgCell:SetData(data)
	self.data = data

	if data then
		local colorId = 1
		if data.iscompleted then
			colorId = 3
		else
			colorId = 1
		end

		local colorCfg = Table_GFaithUIColorConfig[colorId]
		if(colorCfg)then
			local hasc, rc = ColorUtil.TryParseHexString(colorCfg.bg_Color)
			self.bg.color = rc
			local hasc, rc = ColorUtil.TryParseHexString(colorCfg.bgline_Color)
			self.bgline.color = rc
		end

		local content = data.name..ZhString.Colon..data.content
		self.content.text = content

		local size = self.content.localSize
		self.bg.height = size.y + 42
		self.bgline.height = size.y + 44
	end	
end