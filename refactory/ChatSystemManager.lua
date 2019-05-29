ChatSystemManager = class("ChatSystemManager")
function ChatSystemManager:ctor()
end
function ChatSystemManager:CheckChatContent(content)
  if content == "/memo" then
    helplog("\229\173\152\229\130\168\228\184\180\230\151\182\229\130\168\229\173\152\231\130\185")
    ServiceUserEventProxy.Instance:CallSystemStringUserEvent(UserEvent_pb.ESYSTEMSTRING_MEMO)
    return true
  end
  return false
end
function ChatSystemManager:CheckCanDestroy(datas)
  for i = #datas, 1, -1 do
    if datas[i]:CanDestroy() then
      ReusableObject.Destroy(datas[i])
      table.remove(datas, i)
    end
  end
end
