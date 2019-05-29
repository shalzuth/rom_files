LuaQueue = class("LuaQueue")
function LuaQueue:ctor()
  self.container = {}
end
function LuaQueue:Empty()
  return 0 >= self:Count()
end
function LuaQueue:Count()
  return #self.container
end
function LuaQueue:Push(v)
  self.container[#self.container + 1] = v
end
function LuaQueue:Pop()
  if self:Empty() then
    return nil
  end
  local v = table.remove(self.container, 1)
  return v
end
function LuaQueue:Peek()
  if self:Empty() then
    return nil
  end
  return self.container[1]
end
