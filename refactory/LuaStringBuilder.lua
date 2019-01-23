LuaStringBuilder = reusableClass("LuaStringBuilder")
LuaStringBuilder.PoolSize = 20
local concat = table.concat
local ArrayClear = TableUtility.ArrayClear
local quickMode = true
function LuaStringBuilder:ctor()
	self.content = {}
	self.wholeText = nil
	self.dirty = false
end

function LuaStringBuilder:Append(text)
	if(text) then
		if(quickMode or type(text) == "string" or type(text) == "number") then
			self.dirty = true
			self.content[#self.content + 1] = text
		end
	end
end

function LuaStringBuilder:AppendLine(text)
	if(text) then
		if(quickMode or type(text) == "string" or type(text) == "number") then
			self.dirty = true
			self.content[#self.content + 1] = text
			self.content[#self.content + 1] = "\n"
		end
	else
		self.content[#self.content + 1] = "\n"
	end
end

function LuaStringBuilder:RemoveLast()
	local count = #self.content
	if(count>0) then
		self.dirty = true
		self.content[count] = nil
	end
end

function LuaStringBuilder:ToString()
	if(self.dirty) then
		self.dirty = false
		self.wholeText = concat(self.content)
	end
	return self.wholeText
end

function LuaStringBuilder:Clear()
	self.dirty = false
	ArrayClear(self.content)
	self.wholeText = nil
end

function LuaStringBuilder:DoConstruct(text)
	self:Append(text)
end

function LuaStringBuilder:DoDeconstruct()
	self:Clear()
end