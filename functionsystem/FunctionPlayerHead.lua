autoImport("EventDispatcher")
FunctionPlayerHead = class("FunctionPlayerHead",EventDispatcher)

FunctionPlayerHead.PlayEmojiEvent = "FunctionPlayerHead.PlayEmojiEvent"
FunctionPlayerHead.EnableBlinkEye = "FunctionPlayerHead.EnableBlinkEye"
FunctionPlayerHead.PlayDefaultEmojiEvent = "FunctionPlayerHead.PlayDefaultEmojiEvent"

FunctionPlayerHead.RollBackDefaultEmoji = 0

function FunctionPlayerHead.Me()
	if nil == FunctionPlayerHead.me then
		FunctionPlayerHead.me = FunctionPlayerHead.new()
	end
	return FunctionPlayerHead.me
end

function FunctionPlayerHead:ctor()
	self.cachedEmoji = {}
	self.blinkEnabled = false
	EventManager.Me():AddEventListener(TeamEvent.MemberExitTeam,self.MemberExitTeamHandler,self)
end

function FunctionPlayerHead:Reset()
end

function FunctionPlayerHead:MemberExitTeamHandler(event)
	if(event and event.data) then
		self:RemoveEmojiCache(event.data.id)
	end
end

function FunctionPlayerHead:RemoveEmojiCache(id)
	self.cachedEmoji[id] = nil
end

function FunctionPlayerHead:SetEmojiCache(id,emojiID)
	--始终保持的状态，需要缓存下
	if(emojiID == FunctionPlayerHead.RollBackDefaultEmoji) then
		self:RemoveEmojiCache(id)
	else
		local config = Table_Avatar[emojiID]
		if(config and config.Duration==0) then
			self.cachedEmoji[id] = emojiID
		else
			self:RemoveEmojiCache(id)
		end
	end
end

function FunctionPlayerHead:GetEmojiCache(id)
	return self.cachedEmoji[id]
end

--服务器通知播表情
function FunctionPlayerHead:PlayEmoji(sdata)
	self:SetEmojiCache(sdata.charid,sdata.expressionid)
	if(sdata.expressionid == FunctionPlayerHead.RollBackDefaultEmoji) then
		self:PassEvent(FunctionPlayerHead.PlayDefaultEmojiEvent,sdata)
	else
		self:PassEvent(FunctionPlayerHead.PlayEmojiEvent,sdata)
	end
end

function FunctionPlayerHead:EnableBlinkEye()
	self.blinkEnabled = true
	self:PassEvent(FunctionPlayerHead.EnableBlinkEye)
end