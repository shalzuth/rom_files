 autoImport("CommonData")
 CommonDatas = class("CommonDatas")

function CommonDatas:ctor(T)
	self.T = T
end

function CommonDatas:Add(id,...)
	if(self.T~=nil) then
		local data = self[id]
		if(data==nil) then
			data = self.T.new(id,...)
			self[id] = data
		elseif(data.Set~=nil) then
			data:Set(...)
		end
	end
end

function CommonDatas:Remove(id)
	self[id] = nil
end