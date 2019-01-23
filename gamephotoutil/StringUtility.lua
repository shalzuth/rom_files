StringUtility = {}

function StringUtility.Split(str, character)
	local retValue = {}
	string.gsub(
		str,
		'[^'..character..']+',
		function(x)
			table.insert(retValue, x)
		end
	)
	return retValue
end