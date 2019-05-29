Structure = class("Structure")
function Structure.Empty(array)
  return nil == array or #array <= 0
end
function Structure.Clear(array)
  TableUtility.ArrayClear(array)
end
autoImport("Structure_Stack")
autoImport("Structure_Queue")
