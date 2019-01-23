
function Game.PreprocessHelper_BuildMap(array, idKey)
	if nil ~= array and 0 < #array then
		local map = {}
		for i=1, #array do
			local v = array[i]
			local vID = v[idKey]
			if nil ~= vID and 0 ~= vID then
				map[vID] = v
			end
		end
		return map
	end
	return nil
end