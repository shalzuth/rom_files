autoImport("QueueBaseCell")
autoImport("SpriteLabel")
FloatMessageEight = class("FloatMessageEight",QueueBaseCell)
FloatMessageEight.resID = ResourcePathHelper.UICell("FloatMessageEight")
function FloatMessageEight:ctor(parent,data,startPos,offset)
	self.parent = parent
	self.data = data
	self.startPos = startPos
	self.offset = offset
end

function FloatMessageEight:Init()
	
end

function FloatMessageEight:Enter()
	self.gameObject = self:CreatePerfab();
	if(not GameObjectUtil.Instance:ObjectIsNULL(self.gameObject))then
		self.msg = self.gameObject:GetComponentInChildren(UIRichLabel);
		self.spriteLabel = SpriteLabel.new(self.msg,500,40,40)
	end
	self.gameObject.transform.position = self.startPos
	local pos = self.gameObject.transform.localPosition
	pos.x = pos.x + self.offset[1]
	pos.y = pos.y + self.offset[2]
	self.gameObject.transform.localPosition = pos
end

function FloatMessageEight:CreatePerfab()
	local obj = self:CreateObj(FloatMessageEight.resID, self.parent);
	if(obj)then
		obj:GetComponent(Animator):Play ("qianghua", -1, 0);
		-- local autodestroy = obj:GetComponent(EffectAutoDestroy);
		-- if(not autodestroy)then
		-- 	autodestroy = obj:AddComponent(EffectAutoDestroy);
		-- 	autodestroy.OnFinish = function ()
		-- 		self:Exit();
		-- 	end
		-- end
		return obj;
	end	
end

function FloatMessageEight:SetData(data)
	data = data or self.data;
	local msgText = MsgParserProxy.Instance:TryParse(data.text, unpack(data.params));
	self:SetText(msgText)
end

function FloatMessageEight:SetText(text)
	if(self.spriteLabel) then
		self.spriteLabel:SetText(text,false)
	else
		self.msg.text = text
	end
end

function FloatMessageEight:Exit()
	if(self.spriteLabel) then
		self.spriteLabel:Reset()
		self.spriteLabel = nil
	end
end