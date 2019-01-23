EOtherData = class("EOtherData")

function EOtherData:ctor(serverData)	
	self.data = serverData.data

	self.param1 = serverData.param1 
	self.param2 = serverData.param2
	self.param3 = serverData.param3 
	self.param4 = serverData.param4 
end