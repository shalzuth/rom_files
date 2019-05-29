autoImport("Bat")
Atlpc = class("Atlpc", Bat)
Atlpc.NameArray = {
  "ButtonStartGame"
}
function Atlpc:Init()
  self.array = {}
end
function Atlpc:Record(name, x, y)
  local array = Atlpc.NameArray
  local inte
  for i = 1, #array do
    if name == array[i] then
      inte = AAAManager.MakeInteger(x, y)
      self.array[i] = inte
    end
  end
end
function Atlpc:Get(name)
  local array = Atlpc.NameArray
  for i = 1, #array do
    if name == array[i] then
      return self.array[i]
    end
  end
  return nil
end
function Atlpc:Clear(name)
  local array = Atlpc.NameArray
  for i = 1, #array do
    if name == array[i] then
      self.array[i] = nil
    end
  end
end
