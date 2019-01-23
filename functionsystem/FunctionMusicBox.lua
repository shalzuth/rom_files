FunctionMusicBox = class("FunctionMusicBox")

FunctionMusicBox.MusicBoxRange = GameConfig.System.musicrange;

function FunctionMusicBox.Me()
	if nil == FunctionMusicBox.me then
		FunctionMusicBox.me = FunctionMusicBox.new()
	end
	return FunctionMusicBox.me
end

function FunctionMusicBox:ctor()
end

function FunctionMusicBox:AddMusicBox(creature)
	if(self.musicBox == creature)then
		return;
	end
	local oldMusicBox = self.musicBox
	self.musicBox = creature
	if nil ~= oldMusicBox then
		oldMusicBox:UnregisterWeakObserver(self)
	end
	if nil ~= self.musicBox then
		self.musicBox:RegisterWeakObserver(self)
	end
	self:UpdateTimer()
end

function FunctionMusicBox:RemoveMusicBox(creature)
	if(creature == self.musicBox)then
		self.musicBox = nil;
		if nil ~= creature then
			creature:UnregisterWeakObserver(self)
		end
		self:UpdateTimer();
		self:DisPlayMusicBoxBg();
	end
end

function FunctionMusicBox:AddDJPlayer(creature)
	if(self.djPlayer == creature)then
		return;
	end
	-- 1
	self:DjDisPlay();

	-- 2
	local oldDjPlayer = self.djPlayer
	self.djPlayer = creature
	if nil ~= oldDjPlayer then
		oldDjPlayer:UnregisterWeakObserver(self)
	end
	if nil ~= self.musicBox then
		self.djPlayer:RegisterWeakObserver(self)
	end
	self:UpdateTimer();
end

function FunctionMusicBox:RemoveDJPlayer(creature)
	if(creature == self.djPlayer)then
		self.djPlayer = nil;
		if nil ~= creature then
			creature:UnregisterWeakObserver(self)
		end
		self:UpdateTimer();
	end
end

function FunctionMusicBox:ObserverDestroyed(creature)
	if self.musicBox == creature then
		self.musicBox = nil
	elseif self.djPlayer == creature then
		self.djPlayer = nil
	elseif self.djSymbolEffect == creature then
		self.djSymbolEffect = nil
	else
		return
	end
	self:UpdateTimer()
end

function FunctionMusicBox:SetMusic(musicId, startTime, playTimes)
	if(musicId == self.musicId and startTime == self.startTime and playTimes == self.playTimes)then
		return;
	end

	self.musicId = musicId;
	self.startTime = startTime;
	self.playTimes = playTimes;
	if(self:IsMusicIdValid())then
		if(self.musicPlaying)then
			self:DoPlayMusicBoxBg(playTimes);
		end
	else
		self:DisPlayMusicBoxBg();
	end
end

function FunctionMusicBox:UpdateTimer()
	if(self.musicBox)then
		self:LaunchTimer();
	else
		self:ShutDownTimer();
	end
	if(not self.musicBox or not self.djPlayer)then
		self:DjDisPlay();
	end
end

function FunctionMusicBox:LaunchTimer()
	if(not self.timeTick)then
		self:TimeTickUpdate();
		self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.TimeTickUpdate, self)
	end
end

function FunctionMusicBox:TimeTickUpdate(deltatime)
	if(self.musicBox)then
		local musicBoxPos = self.musicBox:GetPosition();
		if(not musicBoxPos)then
			return;
		end
		if(self.djPlayer)then
			local djPos = self.djPlayer:GetPosition();
			if nil == djPos then
				return
			end
			if(LuaVector3.Distance(djPos, musicBoxPos) < FunctionMusicBox.MusicBoxRange)then
				self:DjPlay();
			else
				self:DjDisPlay();
			end
		end
		local myPos = Game.Myself:GetPosition();
		if(not myPos)then
			return;
		end
		if(LuaVector3.Distance(myPos, musicBoxPos) < FunctionMusicBox.MusicBoxRange)then
			self:PlayMusicBoxBg();
		else
			self:DisPlayMusicBoxBg();
		end
	end
	
end

function FunctionMusicBox:ShutDownTimer()
	if(self.timeTick)then
		TimeTickManager.Me():ClearTick(self)
		self.timeTick = nil;
	end
end

function FunctionMusicBox:DjPlay()
	if(self.djPlaying)then
		return;
	end
	self.djPlaying = true;

	local assetRole = self.djPlayer.assetRole;
	if(assetRole)then
		self.djSymbolEffect = assetRole:PlayEffectOn(EffectMap.Maps.Headmusic, RoleDefines_EP.Top);
		if nil ~= self.djSymbolEffect then
			self.djSymbolEffect:RegisterWeakObserver(self)
		end
	end
end

function FunctionMusicBox:DjDisPlay()
	if(not self.djPlaying)then
		return;
	end
	self.djPlaying = false;

	if(self.djSymbolEffect)then
		local oldEffect = self.djSymbolEffect
		self.djSymbolEffect = nil
		oldEffect:UnregisterWeakObserver(self)
		oldEffect:Destroy();
	end
end

function FunctionMusicBox:DoPlayMusicBoxBg(playTimes)
	if(not self:IsMusicIdValid())then
		return;
	end

	local msData = Table_MusicBox[self.musicId];
	if(msData and self.startTime~=0)then
		local pasttime = math.floor((ServerTime.CurServerTime()/1000) - self.startTime);
		pasttime = math.max(0, pasttime);
		if(playTimes == 1)then
			if(pasttime<msData.MusicTim)then
				FunctionBGMCmd.Me():PlayJukeBox(msData.MusicAd, pasttime, nil);
			end
		else
			FunctionBGMCmd.Me():PlayJukeBox(msData.MusicAd, pasttime, nil, playTimes);
		end
	end
end

function FunctionMusicBox:IsMusicIdValid()
	return self.musicId and self.musicId~=0;
end

function FunctionMusicBox:PlayMusicBoxBg()
	if(self.musicPlaying)then
		return;
	end

	self.musicPlaying = true;

	self:DoPlayMusicBoxBg(self.playTimes);
end

function FunctionMusicBox:DisPlayMusicBoxBg()
	if(not self.musicPlaying)then
		return;
	end

	self.musicPlaying = false;

	FunctionBGMCmd.Me():StopJukeBox();
end














