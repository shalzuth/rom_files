local Notification = reusableClass("Notification")
Notification.PoolSize = 25
function Notification:ctor(name, body, type)
  Notification.super.ctor(self)
  self.name = name
  self.body = body
  self.type = type
end
function Notification:getName()
  return self.name
end
function Notification:setBody(body)
  self.body = body
end
function Notification:getBody()
  return self.body
end
function Notification:setType(type)
  self.type = type
end
function Notification:getType()
  return self.type
end
function Notification:toString()
  local msg = "Notification Name: " .. self:getName()
  msg = msg .. [[

Body: ]] .. tostring(self:getBody())
  msg = msg .. [[

Type: ]] .. self:getType()
  return msg
end
function Notification:DoConstruct(asArray, data)
end
function Notification:DoDeconstruct(asArray)
  self.name = nil
  self.type = nil
  self.body = nil
end
return Notification
