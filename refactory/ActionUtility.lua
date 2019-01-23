ActionUtility = class("ActionUtility")

if not ActionUtility.ActionUtility_inited then
	ActionUtility.ActionUtility_inited = true

	ActionUtility.nameHashMap = {}
	ActionUtility.nameWithPrefixMap = {}
	ActionUtility.nameWithSuffixMap = {}
	ActionUtility.nameWithPrefixSuffixMap = {}

	ActionUtility.NameSeparator = "_"
end

local tempArray = {}

function ActionUtility.GetNameHash(name)
	local nameHash = ActionUtility.nameHashMap[name]
	if nil == nameHash then
		nameHash = Animator.StringToHash(name)
		ActionUtility.nameHashMap[name] = nameHash
	end
	return nameHash
end

function ActionUtility._BuildName_1(name, prefix)
	local tempArray = tempArray
	tempArray[1] = prefix
	tempArray[2] = name
	return table.concat(tempArray, ActionUtility.NameSeparator, 1, 2)
end

function ActionUtility._BuildName_2(name, suffix)
	local tempArray = tempArray
	tempArray[1] = name
	tempArray[2] = suffix
	return table.concat(tempArray, ActionUtility.NameSeparator, 1, 2)
end

function ActionUtility._BuildName_3(name, prefix, suffix)
	local tempArray = tempArray
	tempArray[1] = prefix
	tempArray[2] = name
	tempArray[3] = suffix
	return table.concat(tempArray, ActionUtility.NameSeparator, 1, 3)
end

-- !!!MUST use origin name(or make a large RAM used)
function ActionUtility.BuildName(name, prefix, suffix)
	if nil ~= prefix and nil ~= suffix then
		local map = ActionUtility.nameWithPrefixSuffixMap
		local info = map[name]
		if nil ~= info then
			local subInfo = info[prefix]
			if nil ~= subInfo then
				local fullName = subInfo[suffix]
				if nil == fullName then
					fullName = ActionUtility._BuildName_3(name, prefix, suffix)
					subInfo[suffix] = fullName
				end
				return fullName
			else
				subInfo = {}
				local fullName = ActionUtility._BuildName_3(name, prefix, suffix)
				subInfo[suffix] = fullName
				info[prefix] = subInfo
				return fullName
			end
		else
			local subInfo = {}
			local fullName = ActionUtility._BuildName_3(name, prefix, suffix)
			subInfo[suffix] = fullName

			info = {}
			info[prefix] = subInfo
			map[name] = info
			return fullName
		end
	elseif nil ~= prefix then
		local map = ActionUtility.nameWithPrefixMap
		local info = map[name]
		if nil ~= info then
			local fullName = info[prefix]
			if nil == fullName then
				fullName = ActionUtility._BuildName_1(name, prefix)
				info[prefix] = fullName
			end
			return fullName
		else
			info = {}
			local fullName = ActionUtility._BuildName_1(name, prefix)
			info[prefix] = fullName
			map[name] = info
			return fullName
		end
	elseif nil ~= suffix then
		local map = ActionUtility.nameWithSuffixMap
		local info = map[name]
		if nil ~= info then
			local fullName = info[suffix]
			if nil == fullName then
				fullName = ActionUtility._BuildName_2(name, suffix)
				info[suffix] = fullName
			end
			return fullName
		else
			info = {}
			local fullName = ActionUtility._BuildName_2(name, suffix)
			info[suffix] = fullName
			map[name] = info
			return fullName
		end
	end
	return name
end
