autoImport("EventDispatcher")
local baseCell = autoImport("BaseCell")
PushBaseCell = class("PushBaseCell",baseCell)

function PushBaseCell:ctor(parent)
end

function PushBaseCell:GetY()
end

function PushBaseCell:GetH()
end

function PushBaseCell:SetPrevious(p)
	self.previous = p
	if(self.previous~=nil and self.previous.SetFollow ~=nil) then
		self.previous:SetFollow(self)
	end
end

function PushBaseCell:SetData(obj)
	self.data = obj
end

function PushBaseCell:SetFollow(n)
	self.follow = n
end

function PushBaseCell:Parsed()
	return true
end

function PushBaseCell:NextToPush()
	-- body
end