LuaTablePool = class("LuaTablePool")

function LuaTablePool:ctor(name, maxCount)
	self.name = name
	self.maxCount = maxCount or 10
	self.pool = {}
end

function LuaTablePool:Get()
	if(#self.pool>0) then
		local cacheTable = table.remove(self.pool)
		-- print("pool get one!",self.name)
		return cacheTable
	end
	-- printRed("pool get nothing "..self.name)
	return nil
end

function LuaTablePool:Put(obj)
	if(obj~=nil) then
		if(#self.pool >= self.maxCount) then
			if(obj.Dipose~=nil and type(obj.Dipose)=="function") then
				obj:Dipose()
			end
			-- print("pool max",self.name)
		else
			self.pool[#self.pool+1] = obj
			return true
		end
	end
	return false
end

