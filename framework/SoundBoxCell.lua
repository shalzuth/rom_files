local BaseCell = autoImport("BaseCell");
SoundBoxCell = class("SoundBoxCell", BaseCell);

function SoundBoxCell:Init()
	self:InitCell();
	self:AddGameObjectComp();
	self:AddCellClickEvent();
end

function SoundBoxCell:InitCell()
	self.index = self:FindComponent("Index", UILabel);
	self.playingSymbol = self:FindGO("PlayingSymbol");
	self.namelab = self:FindComponent("Name", UILabel);
	self.timelab = self:FindComponent("LeftTime", UILabel);
	self.playername = self:FindComponent("PlayerName", UILabel);
end

function SoundBoxCell:SetTimeLabel(sec)
	local s = math.floor(sec%60);
	local m = math.floor(sec/60);
	self.timelab.text = string.format("%02d:%02d", m, s);
end

function SoundBoxCell:SetData(data)
	self.data = data;
	self.namelab.text = data.staticData.MusicName;
	UIUtil.WrapLabel(self.namelab);
	self.playername.text = data.playername;
	UIUtil.WrapLabel(self.playername);
	self.index.text = data.index;

	if(data.starttime==0)then
		self:SetTimeLabel(data.staticData.MusicTim);
		self.playingSymbol:SetActive(false);
		self.index.gameObject:SetActive(true);
	else
		self:AddSoundTick();
		self.playingSymbol:SetActive(true);
		self.index.gameObject:SetActive(false);
	end
end

function SoundBoxCell:AddSoundTick()
	local pasttime = ServerTime.CurServerTime()/1000 - self.data.starttime;
	self.lefttime = self.data.staticData.MusicTim - math.floor(pasttime);
	TimeTickManager.Me():CreateTick(0, 33, function (self, deltatime)
		if(self.lastTime)then
			local rdeltaTime = RealTime.time - self.lastTime;
			if(rdeltaTime~=0)then
				if(self.lefttime)then
					self.lefttime = self.lefttime - rdeltaTime;
					if(self.lefttime>0)then
						self:SetTimeLabel(self.lefttime);
					end
				end
			end
		end
		self.lastTime = RealTime.time;
	end, self);
end

function SoundBoxCell:OnDestroy() 
	TimeTickManager.Me():ClearTick(self)
end






