LStack = class('LStack')

function LStack:ctor()
	self:Clear()
end

function LStack:GetCount()
	return #self.list
end

function LStack:Clear()
	self.list = {}
end

function LStack:Push(obj)
	self.list[#self.list+1] = obj
end

function LStack:Pop()
	if(self:GetCount()>0) then
		return table.remove(self.list, #self.list)
	end
	return nil
end

function LStack:Peek()
	return self.list[#self.list]
end

function LStack:RemoveNum(num)
	if(num >= self:GetCount()) then
		self:Clear()
	else
		table.remove(self.list, num)
	end
end

function LStack:Remove(obj)
	return TableUtil.Remove(self.list, obj)
end

function LStack:Has(obj)
	return (self:GetDepth(obj) ~= 0)
end

function LStack:GetDepth(obj)
	return TableUtil.ArrayIndexOf(self.list,obj)
end

function LStack:GetDepthByFunc(obj,func,owner)
	for i=1,#self.list do
		if(func(owner,obj,self.list[i])) then
			return i
		end
	end
	return 0
end