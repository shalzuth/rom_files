

function Structure.StackPush(array, v)
	TableUtility.ArrayPushBack(array, v)
end

function Structure.StackPop(array)
	return TableUtility.ArrayPopBack(array)
end

function Structure.StackPeek(array)
	if 0 >= #array then
		return nil
	end
	return array[#array]
end

function Structure.StackPeekByIndex(array, index)
	if not (0 < #array and #array >= index) then
		return nil
	end
	return array[#array-index+1]
end