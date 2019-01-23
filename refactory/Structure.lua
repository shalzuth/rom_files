
Structure = class("Structure")

function Structure.Empty(array)
	return nil == array or 0 >= #array
end

function Structure.Clear(array)
	TableUtility.ArrayClear(array)
end

autoImport ("Structure_Stack")
autoImport ("Structure_Queue")