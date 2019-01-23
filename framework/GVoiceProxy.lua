GVoiceProxy = class('GVoiceProxy', pm.Proxy)
GVoiceProxy.Instance = nil;
GVoiceProxy.NAME = "GVoiceProxy"


TypeOfVoiceRoom = 
{
	TEAM_VOICE = 1,
	GUILD_VOICE =2 ,
}

FunctionOfVoice = 
{
	TEAM_VOICE_FUNCTION = 1,
	GUILD_VOICE_FUNCITON = 2,
}

StateOfVoiceFunctionButton =
{
	STATE_A = 1,
	STATE_B = 2,
	STATE_C = 3,
}

function GVoiceProxy:DebugLog(msg)
	-- body
	if false then
		Debug.Log("GVoiceProxy::::"..msg)
	end	
end

function GVoiceProxy:ctor(proxyName, data)
	self.proxyName = proxyName or GVoiceProxy.NAME
	if(GVoiceProxy.Instance == nil) then
		GVoiceProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
	self:AddEvts()
end

function GVoiceProxy:IsOpenByCeHua()
	if GameConfig.OpenVoice ==nil then
		Debug.Log("策划没配置 前端默认关闭")
--		return true
	--todo xde
		return false
	end

	return GameConfig.OpenVoice

end

function GVoiceProxy:Init()
	if self:IsOpenByCeHua() == false then
		do return end
	end

	if ApplicationInfo.IsRunOnEditor() then
		do return end
	end

    -- todo xde 删除语音
    do return end

	ROVoice.ChatSDKInit(0,"1003051",1,function (msg)
		self:DebugLog("ROVoice.ChatSDKInit msg:"..msg)
		self.hasInit = true
	end)


	ROVoice.ReceiveTextMessageNotify
	(
	function (msg)
		-- body
		self:DebugLog("ROVoice.ReceiveTextMessageNotify1 msg:"..msg)
	end,
	function (msg)
		self:DebugLog("ROVoice.ReceiveTextMessageNotify2 msg:"..msg)
	end,
	function (msg)
		self.uid =msg
		self:DebugLog("ROVoice.ReceiveTextMessageNotify3:"..self.uid)
	end
	)

	ROVoice.LoginNotify
	(
	function (msg)
		-- body
		self:DebugLog("ROVoice.LoginNotify msg:"..msg)
	end)

	ROVoice.LogoutNotify
	(
	function (msg)
		-- body
		self:DebugLog("ROVoice.LogoutNotify msg:"..msg)
	end
	)
end

function GVoiceProxy:AddEvts()

end

function GVoiceProxy:ChangeTeamVoiceState(teamVoiceState)
	self:ChangeVoiceState(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index,teamVoiceState)
end

function GVoiceProxy:ChangeVoiceState(voiceType,teamVoiceState)
	self:DebugLog("当前语音频道为"..self.curChannel.." voiceType："..voiceType);

	if self:IsOpenByCeHua() == false then
		do return end
	end	

	if ApplicationInfo.IsRunOnEditor() then
		self:DebugLog("编辑器模式")
		do return end
	end

	if self.curChannel ~= voiceType then
		self:DebugLog("不是相同的语音频道设置的");
		do return end
	end

	if teamVoiceState == StateOfVoiceFunctionButton.STATE_A then
		self:DebugLog("teamVoiceState状态a：为默认，关闭麦克风+关闭听")
		ROVoice.SetPausePlayRealAudio(true)
	elseif teamVoiceState == StateOfVoiceFunctionButton.STATE_B then
		ROVoice.SetPausePlayRealAudio(false)
		self:DebugLog("teamVoiceState状态b：开启听+关闭麦；")
		ROVoice.ChatMic(false,function (msg)
			self:DebugLog("ROVoice.ChatMic1 msg:"..msg)
		end)

	elseif teamVoiceState == StateOfVoiceFunctionButton.STATE_C then
		ROVoice.SetPausePlayRealAudio(false)
		self:DebugLog("teamVoiceState状态c：开启麦克风+开启听；")
		ROVoice.ChatMic(true,function (msg)
			self:DebugLog("ROVoice.ChatMic2 msg:"..msg)
		end)
	end	
end


function GVoiceProxy:ChangeGuildVoiceState(guildVoiceState)
	self:ChangeVoiceState(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index ,guildVoiceState)
end

function GVoiceProxy:RecvEnterTeam(data)
	self:DebugLog("GVoiceProxy--> RecvEnterTeam 2.玩家进行组队后，主界面出现队伍语音按钮。")
end

function GVoiceProxy:RecvExitTeam(data)

	if self:IsOpenByCeHua() == false then
		do return end
	end

	if ApplicationInfo.IsRunOnEditor() then
		MsgManager.FloatMsg(nil, "当前为编辑器 无法使用语音功能")
		self.curChannel = nil
		self.roomid=nil
		do return end
	end

	if self.curChannel ==nil then
		self:DebugLog("当前不在任何语音频道中 不用处理")
		do return end
	elseif self.curChannel ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
		--MsgManager.FloatMsg(nil, "离开队伍语音")
		MsgManager.ShowMsgByID(25489)
		ROVoice.Logout( function (msg)
			 	-- body
			 	self:DebugLog("ROVoice.Logout1 msg:"..msg)
			 	self.curChannel = nil
			 	self.roomid=nil
			end)

	elseif self.curChannel ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then	
		--MsgManager.FloatMsg(nil, "离开公会语音")
		MsgManager.ShowMsgByID(25493)
		ROVoice.Logout( function (msg)
			 	-- body
			 	self:DebugLog("ROVoice.Logout2 msg:"..msg)
			 	self.curChannel = nil
			 	self.roomid=nil
			 end)
	end
end

function GVoiceProxy:LeaveGVoiceRoomAtChannel(targetChannel)

	if self:IsOpenByCeHua() == false then
		do return end
	end

	if self.curChannel ==nil then

	elseif self.curChannel ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index and targetChannel == self.curChannel then
		--MsgManager.FloatMsg(nil, "离开队伍语音")
		MsgManager.ShowMsgByID(25489)

	elseif self.curChannel ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index and targetChannel == self.curChannel then	
		--MsgManager.FloatMsg(nil, "离开公会语音")
		MsgManager.ShowMsgByID(25493)
	end

	if self.roomid~=nil then
		self.roomid=nil
	end	
	self.curChannel = nil
end

function GVoiceProxy:GetCurChannel()
	return self.curChannel or nil
end

function GVoiceProxy:LoginRoom(data)
	if self:IsOpenByCeHua() == false then
		do return end
	end

	self.curChannel = data.channel
	self.roomid = data.id
	if data.channel ==nil then
	elseif data.channel ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
		if not TeamProxy.Instance:IHaveTeam() then
			--MsgManager.FloatMsg(nil, "当前没有进入队伍")
			Debug.Log("当前没有进入队伍")
			do return end
		end	

		--MsgManager.FloatMsg(nil, "进入队伍语音")
		MsgManager.ShowMsgByID(25488)

		if ApplicationInfo.IsRunOnEditor() then
			MsgManager.FloatMsg(nil, "当前为编辑器 无法使用语音功能")
			do return end
		end	

		if self.hasInit == true then
			 ROVoice.ChatSDKLogin( Game.Myself.data.id, self.roomid,function (msg)
			 	-- body
				 	ROVoice.ChatMic(true,function (msg)

					end)
			 end)
		else
			ROVoice.ChatSDKInit(0,"1003051",1,function (msg)
				self.hasInit = true
				if self.roomid == nil then
					self:DebugLog("if self.roomid == nil then")
					do return end
				end	
				ROVoice.ChatSDKLogin( Game.Myself.data.id, self.roomid,function (msg)
			 	-- body
			 			ROVoice.ChatMic(true,function (msg)

						end)
				 end)
			end)
		end	

	elseif data.channel ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then	
		--策划说这里是手动选择加入的
		if not GuildProxy.Instance:IHaveGuild() then
			self:DebugLog("当前没有加入工会")
			do return end
		end	
		--MsgManager.FloatMsg(nil, "进入公会语音")
		MsgManager.ShowMsgByID(25492)
		if ApplicationInfo.IsRunOnEditor() then
			MsgManager.FloatMsg(nil, "当前为编辑器 无法使用语音功能")
			do return end
		end	

		if self.hasInit == true then
			 ROVoice.ChatSDKLogin( Game.Myself.data.id, self.roomid,function (msg)

			 end)
		else
			ROVoice.ChatSDKInit(0,"1003051",1,function (msg)
				self.hasInit = true
				if self.roomid == nil then
					self:DebugLog("if self.roomid == nil then")
					do return end
				end	

				ROVoice.ChatSDKLogin( Game.Myself.data.id, self.roomid,function (msg)

				end)
			end)
		end	

	end
end	

function GVoiceProxy:RecvQueryRealtimeVoiceIDCmd(data)
	if self:IsOpenByCeHua() == false then
		do return end
	end

	self:DebugLog("GVoiceProxy:RecvQueryRealtimeVoiceIDCmd(data)")
	self:DebugLog("GVoiceProxy--> RecvQueryRealtimeVoiceIDCmd")
	self:DebugLog("data.channel"..data.channel)
	--2是队伍
	--3是公会
	self:DebugLog("data.id"..data.id)
	if self.curChannel == data.channel then
		self:DebugLog("已在同类型的房间里面")
		do return end
	elseif self.curChannel == nil then
		self:DebugLog("不在房间里面 直接登录房间")
		self:LoginRoom(data)
	elseif self.curChannel ~=nil and self.curChannel ~=  data.channel then
		self:DebugLog("换房间操作 先登出 后登入")

		if ApplicationInfo.IsRunOnEditor() then
			self:DebugLog("编辑器模式 无法使用语音")
			self.curChannel = data.channel
			do return end
		end

		ROVoice.Logout( function (msg)
			 	-- body
			 	self.curChannel = nil
			 	self.roomid=nil
			 	self:LoginRoom(data)
		 end)
	end
end

function GVoiceProxy:GetPlayerChooseToJoinGuildVoice()
	return self.ChooseToJoinGuildVoice or false
end	

function GVoiceProxy:SetPlayerChooseToJoinGuildVoice(b)
	self.ChooseToJoinGuildVoice = b
end	

function GVoiceProxy:ActiveEnterChannel(channel)

	if self.curChannel == channel then
		self:DebugLog("已在同类型的房间里")
		do return end
	end	

	Debug.Log("||||||||||||GVoiceProxy:ActiveEnterChannel(channel):"..channel)
	ServiceChatCmdProxy.Instance:CallQueryRealtimeVoiceIDCmd(channel, nil) 
end	

function GVoiceProxy:UseGVoiceInReal(channelIndex,roomid)
	if not self:HaveInitSuccess() then
		MsgManager.FloatMsg(nil, "错误代码：013")
		do return end
	end	

	if channelIndex ==nil then
		MsgManager.FloatMsg(nil, "错误代码：012")
	elseif channelIndex ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
	
	elseif channelIndex ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then	

	end
end

function GVoiceProxy:ConfirmMicState()

	if not self:IsMaiOpen() then
		self:DebugLog("关闭mic")
		return
	end	

end

function GVoiceProxy:ConfirmYangState()
	if not self:IsYangOpen() then
		self:DebugLog("关闭扬声器")
		return
	end	

end

function GVoiceProxy:HaveInitSuccess()
	if not self.haveInitSuccess then
		MsgManager.FloatMsg(nil, "错误代码：014")
		return false
	else
		return true
	end	
end

function GVoiceProxy:RecvBanRealtimeVoiceGuildCmd(data)
	self:DebugLog("GVoiceProxy--> RecvBanRealtimeVoiceGuildCmd")
end

function GVoiceProxy:RecvOpenRealtimeVoiceGuildCmd(data) 
	helplog("GVoiceProxy--> RecvOpenRealtimeVoiceGuildCmd")

end	

function GVoiceProxy:RecvGuildMemberDataUpdateGuildCmd(data)
	self:DebugLog("GVoiceProxy--> RecvGuildMemberDataUpdateGuildCmd")

	for i=1,#data.updates do
		local updateData = data.updates[i];
		if updateData.type == 27 and data.charid == self:GetMyGongHuiCharId() then
			if updateData.value == 0 then
				self:DebugLog("没被禁言")
			elseif updateData.value == 1 then
				self:DebugLog("被禁言")
			end	
		end	
	end

-- 	charid: 4294967366
-- updates {
--     value: 0
--     data: 
--     type: 27
-- }
-- type: 1
end	

function GVoiceProxy:IsMySelfGongHuiJinYan()

	if not GuildProxy.Instance:IHaveGuild() then
		self:DebugLog("没加入工会")
		return false
	end	


	local data = GuildProxy.Instance:GetMyGuildMemberData()
	if data then
		if data:IsRealtimevoice() then
			self:DebugLog("已被禁言")
			return true
		else
			self:DebugLog("没被禁言")
			return false
		end	
	else

		self:DebugLog("没读到工会数据")
		return false
	end	
	return false
end	

function GVoiceProxy:IsTeamVoiceOpen()

	return self:IsThisFuncOpen(0) 
end

function GVoiceProxy:GetBitByInt(num, index)
	return ((num >> index) & 1) == 0
end

function GVoiceProxy:IsGongHuiVoiceOpen()

	local data = GuildProxy.Instance:GetMyGuildMemberData()
	if data then
		if data:IsRealtimevoice() then
			self:DebugLog("已被禁言")
			return false
		else
			self:DebugLog("没被禁言")
			return true
		end	
	else
		self:DebugLog("没读到工会数据")
		return false
	end	
	
end

function GVoiceProxy:GetMyGongHuiCharId()
	local data = GuildProxy.Instance:GetMyGuildMemberData()
	if data then
		return data:GetCharId()
	end	

	return nil	
end

function GVoiceProxy:IsYangOpen()
	return self:IsThisFuncOpen(2) 
end

function GVoiceProxy:IsMaiOpen()
	return self:IsThisFuncOpen(3) 
end

function GVoiceProxy:IsThisFuncOpen(funcId) 
	--TODO:没判空 感觉很慌
	local setting = FunctionPerformanceSetting.Me()
	local gvoice = setting:GetSetting().gvoice
	local value = self:GetBitByInt(gvoice, funcId)
	return value
end
--玩家给予语音授权后全为勾
function GVoiceProxy:SetAllSetViewToGou() 
	local gvoice = 0
	for i=0,#self.gvoiceToggle do
		gvoice = self:GetIntByBit(gvoice, i, not true)
	end

	local setting = FunctionPerformanceSetting.Me() 
	setting:SetGVoice(gvoice)
end

function GVoiceProxy:GetIntByBit(num, index, b)
	if b then
		num = num + (1<<index)
	end
	return num
end

function GVoiceProxy:RecvEnterGuildGuildCmd(data)
	-- body
end

function GVoiceProxy:IsThisCharIdRealtimeVoiceAvailable( charid)

	if self:IsOpenByCeHua() == false then
		return false
	end

	-- body
	local myGuildData = GuildProxy.Instance.myGuildData
	if myGuildData==nil then
		return false
	end	

    local guildMemberData = myGuildData:GetMemberByGuid(charid);
    if guildMemberData==nil then
		return false
	end	

    if guildMemberData:IsRealtimevoice() then
		return true
    else
    	return false
    end	
end

function GVoiceProxy:SetCurGuildRealTimeVoiceCount(count)
	if count > GameConifg.realtime_voice_limit then
		self.curGuildRealTimeVoiceCount = 9
	else	
		self.curGuildRealTimeVoiceCount = count
	end	
end

function GVoiceProxy:GetCurGuildRealTimeVoiceCount()
	 self.curGuildRealTimeVoiceCount = 0
	return self.curGuildRealTimeVoiceCount or 0
end

return GVoiceProxy

