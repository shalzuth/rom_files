AstrolabeSaveData = class("AstrolabeSaveData")

function AstrolabeSaveData:ctor(serverdata)
	-- TableUtility.TableClear(self.pids)
	self.pids = {}
	local length = #serverdata.stars
	for i = 1,length do
		local single = serverdata.stars[i]
		table.insert(self.pids,single)
	end
end

function AstrolabeSaveData:GetActiveStars()
	return self.pids;
end