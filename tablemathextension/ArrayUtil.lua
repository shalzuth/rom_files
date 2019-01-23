ArrayUtil = {}

local reusableArray1 = {}
local reusableArray2 = {}
local reuse_hashtable = {}
local TableClear = TableUtility.TableClear
local ArrayClear = TableUtility.ArrayClear
local insert = table.insert

function ArrayUtil.Intersection(arr1, arr2)
	TableClear(reuse_hashtable)
	ArrayClear(reusableArray1)
	for i = 1, #arr1 do
		reuse_hashtable[arr1[i]] = 0
	end
	for i = 1, #arr2 do
		local item = arr2[i]
		if reuse_hashtable[item] then
			insert(reusableArray1, item)
		end
	end
	return reusableArray1
end

function ArrayUtil.Complementary(arr1, arr2)
	TableClear(reuse_hashtable)
	ArrayClear(reusableArray1)
	for i = 1, #arr2 do
		reuse_hashtable[arr2[i]] = 0
	end
	for i = 1, #arr1 do
		local item = arr1[i]
		if not reuse_hashtable[item] then
			table.insert(reusableArray1, item)
		end
	end
	return reusableArray1
end

function ArrayUtil.NumberArrayIntersection(arr1, arr2)
	ArrayUtil.NumberArraySort(arr1)
	ArrayUtil.NumberArraySort(arr2)
	TableUtility.ArrayClear(reusableArray1)
	local i, j = 1, 1
	while i <= #arr1 and j <= #arr2 do
		if arr1[i] == arr2[j] then
			table.insert(reusableArray1, arr1[i])
			i = i + 1
			j = j + 1
		elseif arr1[i] > arr2[j] then
			j = j + 1
		elseif arr1[i] < arr2[j] then
			i = i + 1
		end
	end
	return reusableArray1
end

function ArrayUtil.NumberArraySort(arr)
	table.sort(arr)
end

function ArrayUtil.NumberArrayQuickSort(arr)
	for i = 2, #arr do
		if arr[i] < arr[i - 1] then
			local j = i - 1
			local temp = arr[i]
			arr[i] = arr[i - 1]
			while j > 0 and temp < arr[j] do
				arr[j + 1] = arr[j]
				j = j - 1
			end
			arr[j + 1] = temp
		end
	end
end

function ArrayUtil.NumberArrayComplementary(arr1, arr2)
	ArrayUtil.NumberArraySort(arr1)
	ArrayUtil.NumberArraySort(arr2)
	TableUtility.ArrayClear(reusableArray1)
	for i = 1, #arr1 do
		table.insert(reusableArray1, arr1[i])
	end
	local i, j = #arr1, #arr2
	while i >= 1 and j >= 1 do
		if arr1[i] == arr2[j] then
			table.remove(reusableArray1, i)
			i = i - 1
			j = j - 1
		elseif arr1[i] < arr2[j] then
			j = j - 1
		elseif arr1[i] > arr2[j] then
			i = i - 1
		end
	end
	return reusableArray1
end

function ArrayUtil.ArraySet(arr1, arr2)
	if arr2 ~= nil then
		TableUtility.ArrayClear(arr1)
		for i = 1, #arr2 do
			table.insert(arr1, arr2[i])
		end
	else
		arr1 = arr2
	end
end