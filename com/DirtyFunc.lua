DirtyFunc = class('DirtyFunc')

function DirtyFunc:ctor()
	self:Reset()
end

function DirtyFunc:Reset()
	self.maps = {}
	self.minIndex = 1
	self.maxIndex = 0
end

function DirtyFunc:MapFunc(index,fun)
	self.minIndex = math.min(index,self.minIndex)
	self.maxIndex = math.max(index,self.maxIndex)
	local map = self.maps[index]
	if(map == nil) then
		map = {[1] = false,[2] = fun}
		self.maps[index] = map
	else
		map[1] = false
		map[2] = fun
	end
end

function DirtyFunc:SetDirty(index,value)
	local data = self.maps[index]
	if(data) then
		value = value~=nil and value or true
		data[1] = value
	end
end

function DirtyFunc:DirtyCall(param)
	local data
	for i = self.minIndex,self.maxIndex do
		data = self.maps[i]
		if(data and data[1] == true) then
			data[1] = false
			data[2](param)
		end
	end
end