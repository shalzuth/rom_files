
function Structure.QueuePush(array, v)
	TableUtility.ArrayPushBack(array, v)
end

function Structure.QueuePop(array)
	return TableUtility.ArrayPopFront(array)
end

function Structure.QueuePeek(array)
	if 0 >= #array then
		return nil
	end
	return array[1]
end

function Structure.QueuePeekByIndex(array, index)
	if not (0 < #array and #array >= index) then
		return nil
	end
	return array[index]
end