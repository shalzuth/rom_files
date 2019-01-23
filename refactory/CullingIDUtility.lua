CullingIDUtility = class("CullingIDUtility")

local maxID = 1500
local startID = 1
local usedFlags = {}
for i=1,maxID do
	usedFlags[i] = false
end

function CullingIDUtility.GetID()
	local i = startID
	for j=1,maxID do
		if(i >= maxID) then
			i = 1
		end
		if(usedFlags[i] == false) then
			usedFlags[i] = true
			startID = i + 1;
			break;
		end
		if(j>=maxID) then
			errorLog("CullingIDUtility - 有效的cullingID已被用完，请扩大id池子")
			i = 0
		else
			i = i + 1
		end
	end
	-- LogUtility.InfoFormat("CullingIDUtility.GetID {0}",i)
	return i
end

function CullingIDUtility.ClearID(i)
	if(i~=nil) then
		if(usedFlags[i]) then
			usedFlags[i] = false
			startID = i
			if(i>=maxID) then
				startID = 1;
			end
			-- LogUtility.InfoFormat("CullingIDUtility.ClearID {0}",i)
		end
	end
end