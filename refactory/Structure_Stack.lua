function Structure.StackPush(array, v)
  TableUtility.ArrayPushBack(array, v)
end
function Structure.StackPop(array)
  return TableUtility.ArrayPopBack(array)
end
function Structure.StackPeek(array)
  if #array <= 0 then
    return nil
  end
  return array[#array]
end
function Structure.StackPeekByIndex(array, index)
  if not (#array > 0) or not (index <= #array) then
    return nil
  end
  return array[#array - index + 1]
end
