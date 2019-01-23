local IOPathConfig = autoImport("IOPathConfig")

FunctionChatIO = class("FunctionChatIO")

function FunctionChatIO.Me()
	if nil == FunctionChatIO.me then
		FunctionChatIO.me = FunctionChatIO.new()
	end
	return FunctionChatIO.me
end

function FunctionChatIO:ctor()
	self:Init()
	self:Reset()
end

function FunctionChatIO:Init()
	self.chatListName = "PrivateChatList.bytes"
	self.limitDayNum = 7
	self.speechFormat = ".mp3"
end

function FunctionChatIO:Reset()
	self.isLoadedContent = {}
	self.saveCacheList = {}
	self.chatList = {}
	self.isLoadChatList = false
end

function FunctionChatIO:CheckLocalFiles()
	-- 获取当前服务器时间
	-- 遍历所有 聊天目录－私聊对象id目录，若超过七天则删除聊天记录文件，若私聊对象id目录为空则删除目录

	DiskFileHandler.Ins():EnterPrivateChat()
	DiskFileHandler.Ins():EnterChat()
	self.privateChatRootPath = IOPathConfig.Paths.USER.PrivateChat
	self.chatSpeechRootPath = IOPathConfig.Paths.USER.ChatSpeech

	if ServerTime.CurServerTime() == nil then
		print("FunctionChatIO CheckLocalFiles : ServerTime.CurServerTime() is nil")
		return 
	end

	local currentServerTime = ServerTime.CurServerTime() / 1000

	local dateDirectory = FileDirectoryHandler.GetChildrenName(self.privateChatRootPath)

	if dateDirectory == nil then
		print("FunctionChatIO CheckLocalFiles : FileDirectoryHandler.GetChildrenName(self.privateChatRootPath) is nil")
		return
	end

	for i=1,#dateDirectory do
		local foldstr = string.split(dateDirectory[i], '-');	
		if(#foldstr > 1)then
			if not ClientTimeUtil.TransTimeStrToTimeTick(dateDirectory[i] , currentServerTime , self.limitDayNum ) then
				FileDirectoryHandler.DeleteDirectory(self.privateChatRootPath.."/"..dateDirectory[i])
			end
		end
	end
end

-- 添加缓存聊天记录(id,str)
function FunctionChatIO:AddSaveCache(chatId,data)	
	if data then
		print("FunctionChatIO AddSaveCache : "..chatId)
		local currentServerTime = ServerTime.CurServerTime() / 1000
		local dateTime = ClientTimeUtil.FormatTimeTick(currentServerTime,"yyyy-MM-dd-HH-mm-ss")

		local chat = ClientPrivateChatIO_pb.ChatData()
		chat.id = data:GetId()
		chat.time = currentServerTime
		chat.str = data:GetStr()
		chat.audioId = data:GetVoiceid()
		chat.audioLength = data:GetVoicetime()

		if self.saveCacheList[chatId] == nil then
			self.saveCacheList[chatId] = ClientPrivateChatIO_pb.PrivateChatDatas()
		end

		table.insert(self.saveCacheList[chatId].msgs, chat)
	end
	
end

-- 保存缓存聊天记录
function FunctionChatIO:SaveChatContent()

	local dirPath = self:GetServerTimeDirectory(self.privateChatRootPath)

	if dirPath == nil then
		return
	end

	for k,v in pairs(self.saveCacheList) do
		-- 保存到文件中
		local path = dirPath.."/"..k..".bytes"
		-- LogUtility.InfoFormat("FunctionChatIO SaveChatContent File : {0}",path)
		local str = v:SerializeToString()
		local bytes = NetUtil.GetNewBytes(#str)
		for i = 1, #str do
			NetUtil.SetByteByIndex(bytes, string.byte(str, i), i - 1)		
		end
		FileDirectoryHandler.AppendBytesToFile(path,bytes)
	end

	self.saveCacheList = {}
end

-- 保存私聊列表文件(id,unreadCount)
function FunctionChatIO:SaveChatList(datas)

	if self.privateChatRootPath == nil then
		print("FunctionChatIO SaveChatList : privateChatRootPath is nil")
		return
	end

	local path = self.privateChatRootPath.."/"..self.chatListName
	print("FunctionChatIO SaveChatList : "..path)

	local list = ClientPrivateChatIO_pb.PrivateChatList()
	for k,v in pairs(datas) do		
		local chat = ClientPrivateChatIO_pb.ListData()
		chat.id = v.id
		chat.unreadCount = v.unreadCount or 0
		table.insert(list.msgs, chat)
	end

	local str = list:SerializeToString()
	local bytes = NetUtil.GetNewBytes(#str)
	for i = 1, #str do
		NetUtil.SetByteByIndex(bytes, string.byte(str, i), i - 1)		
	end
	FileDirectoryHandler.WriteFile(path,bytes)
end

function FunctionChatIO:ReadChatContentById(chatId)

	self.isLoadedContent[chatId] = true

	if self.privateChatRootPath == nil then
		-- LogUtility.Info("FunctionChatIO ReadChatContentById : privateChatRootPath is nil")
		return
	end

	-- LogUtility.InfoFormat("FunctionChatIO ReadChatContentById : {0}",chatId)

	local dateDirectory = FileDirectoryHandler.GetChildrenName(self.privateChatRootPath)
	local content = ClientPrivateChatIO_pb.PrivateChatDatas()
	if dateDirectory then
		for i=1,#dateDirectory do
			local foldstr = string.split(dateDirectory[i], '-');	
			if(#foldstr > 1)then
				local path = self.privateChatRootPath.."/"..dateDirectory[i].."/"..chatId..".bytes"
				local bytes = FileIOHelper.ReadBytes(path)
				-- LogUtility.InfoFormat("FunctionChatIO ReadChatContentById path : {0}",path)
				if bytes then			
					for i=1,#bytes do
						local b = Slua.ToString(bytes[i])
						local datas = ClientPrivateChatIO_pb.PrivateChatDatas()
						datas:ParseFromString(b)
						for j=1,#datas.msgs do
							table.insert(content.msgs, datas.msgs[j])
						end
					end
				end
				-- LogUtility.InfoFormat("读取本地私聊content，长度{0}",#content.msgs)
			end
		end
	end
	-- printData(content.msgs)
	return content.msgs
end

function FunctionChatIO:ReadChatList()
	
	if self.privateChatRootPath == nil then
		print("FunctionChatIO ReadChatList : privateChatRootPath is nil")
		return
	end

	self.chatList = {}

	local path = self.privateChatRootPath.."/"..self.chatListName
	print("FunctionChatIO ReadChatList : "..path)

	local bytes = FileDirectoryHandler.LoadFile(path)
	if bytes then
		local b = Slua.ToString(bytes)
		local datas = ClientPrivateChatIO_pb.PrivateChatList()
		datas:ParseFromString(b)
		for i=1,#datas.msgs do
			self.chatList[datas.msgs[i].id] = datas.msgs[i]
		end
		print("读取本地私聊List，长度"..#datas.msgs)
	end
end

function FunctionChatIO:ReadChatListById(chatId)

	if self.privateChatRootPath == nil then
		print("FunctionChatIO ReadChatListById : privateChatRootPath is nil")
		return
	end

	if not self.isLoadChatList then
		self:ReadChatList()
		self.isLoadChatList = true
	end
	return self.chatList[chatId]
end

--保存私聊语音
function FunctionChatIO:SavePrivateChatSpeech(id,bytes)
	local dirPath = self:GetServerTimeDirectory(self.privateChatRootPath)

	if dirPath == nil then
		return
	end

	local path = dirPath.."/"..id..self.speechFormat
	print("FunctionChatIO SavePrivateChatSpeech File : "..path)	
	FileDirectoryHandler.WriteFile(path,bytes)

	return path
end

--保存非私聊语音（用作缓存，最大数量为10）
function FunctionChatIO:SaveChatSpeech(id,bytes)
	local dirPath = self.chatSpeechRootPath

	if dirPath == nil then
		return
	end

	local path = dirPath.."/"..id..self.speechFormat
	print("FunctionChatIO SaveChatSpeech File : "..path)

	local currentServerTime = ServerTime.CurServerTime()
	currentServerTime = currentServerTime or -1
	local b = DiskFileManager.Instance:SaveFile(path, bytes, currentServerTime / 1000)
	-- FileDirectoryHandler.WriteFile(path,bytes)

	return path
end

function FunctionChatIO:ReadChatSpeech(id,time)

	if self.privateChatRootPath == nil then
		print("FunctionChatIO ReadChatSpeech : privateChatRootPath is nil")
		return
	end

	if self.chatSpeechRootPath == nil then
		print("FunctionChatIO ReadChatSpeech : chatSpeechRootPath is nil")
		return
	end	

	if time == nil then
		time = 0
		print("FunctionChatIO ReadChatSpeech : time is nil")
	end

	local dateTime = ClientTimeUtil.FormatTimeTick(time)

	local path = self.privateChatRootPath.."/"..dateTime.."/"..id..self.speechFormat
	print("FunctionChatIO ReadChatSpeech private path: "..path)
		
	local bytes = FileDirectoryHandler.LoadFile(path)

	if bytes == nil then
		local currentServerTime = ServerTime.CurServerTime()
		currentServerTime = currentServerTime or -1
		path = self.chatSpeechRootPath.."/"..id..self.speechFormat
		print("FunctionChatIO ReadChatSpeech chat speech path: "..path)
		bytes = DiskFileManager.Instance:LoadFile(path, currentServerTime / 1000)
		-- bytes = FileDirectoryHandler.LoadFile(path)
	end

	return bytes,path
end

function FunctionChatIO:GetServerTimeDirectory(rootPath)
	if ServerTime.CurServerTime() == nil then
		return nil
	end
	if rootPath == nil then
		return nil
	end

	local currentServerTime = ServerTime.CurServerTime() / 1000
	local dateTime = ClientTimeUtil.FormatTimeTick(currentServerTime)

	local dirPath = rootPath.."/"..dateTime
	if not FileDirectoryHandler.ExistDirectory(dirPath) then
		FileDirectoryHandler.CreateDirectory(dirPath)
	end

	return dirPath
end