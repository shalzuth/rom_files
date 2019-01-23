autoImport("FunctionCD")
AssociateRemoveFunctionCD = class("AssociateRemoveFunctionCD",FunctionCD)

function AssociateRemoveFunctionCD:ctor()
	AssociateRemoveFunctionCD.super.ctor(self)
	self.links = {}
end

function AssociateRemoveFunctionCD:Link(otherFunctionCD)
	if(otherFunctionCD.Link==nil) then
		if(TableUtil.ArrayIndexOf(self.links,otherFunctionCD)==0) then
			self.links[#self.links+1] = otherFunctionCD
		end
	end
end

function AssociateRemoveFunctionCD:UnLink(otherFunctionCD)
	if(otherFunctionCD.Link==nil) then
		TableUtil.Remove(self.links,otherFunctionCD)
	end
end

function AssociateRemoveFunctionCD:Remove( obj )
	AssociateRemoveFunctionCD.super.Remove(self,obj)
	for i=1,#self.links do
		self.links:Remove(obj)
	end
end

function AssociateRemoveFunctionCD:RemoveAll()
	AssociateRemoveFunctionCD.super.Remove(self,obj)
	for i=1,#self.links do
		self.links:Reset()
	end
end