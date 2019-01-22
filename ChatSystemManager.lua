ChatSystemManager = class("ChatSystemManager")

function ChatSystemManager:ctor()
end

function ChatSystemManager:CheckChatContent(content)
	--TODO ????????????
	if(content == "/memo") then
		helplog("?????????????????????")
		ServiceUserEventProxy.Instance:CallSystemStringUserEvent(UserEvent_pb.ESYSTEMSTRING_MEMO)
		return true
	end
	return false
end

function ChatSystemManager:CheckCanDestroy(datas)
	for i = #datas, 1, -1  do
		if datas[i]:CanDestroy() then
			ReusableObject.Destroy(datas[i])
			table.remove(datas, i)
		end
	end
end