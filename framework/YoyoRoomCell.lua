local BaseCell = autoImport("BaseCell");
YoyoRoomCell = class("YoyoRoomCell", BaseCell);

local strFormat = "%s/%s"
local grayBtn = "com_btn_13"
local normalBtn = "com_btn_2"

local configLimit = GameConfig.PVPConfig[1] and GameConfig.PVPConfig[1].PeopleLimit or 20;

function YoyoRoomCell:Init()
	YoyoRoomCell.super.Init(self)
	self:FindObjs()
	self:AddUIEvts()
end

function YoyoRoomCell:FindObjs()
	self.roomName = self:FindGO("roomName"):GetComponent(UILabel)
	self.count = self:FindGO("count"):GetComponent(UILabel)
	self.joinGo = self:FindGO("join");
	self.JoinBtn = self.joinGo:GetComponent(UISprite);
	self.JoinLabel=self:FindGO("Label",self.joinGo):GetComponent(UILabel)
end

function YoyoRoomCell:AddUIEvts()
	self:SetEvent(self.joinGo,function ()
		self:PassEvent(YoyoJoinRoomEvent.JoinRoom,self.data)
	end)
end

function YoyoRoomCell:SetData(data)
	self.data = data;
	if(self.data)then
		self.roomName.text=data.roomName;
		self.count.text=string.format(strFormat, data.playerNum, configLimit);
		self.roomID=data.roomId;
		self.raidid=data.raidid;
		if(data.playerNum==configLimit)then
			self.JoinBtn.spriteName = grayBtn
			self.count.color=ColorUtil.Red
			self.JoinLabel.effectStyle = UILabel.Effect.None
		else
			self.JoinBtn.spriteName = normalBtn
			self.count.color = ColorUtil.PVPBlackLabel
			self.JoinLabel.effectStyle = UILabel.Effect.Outline
		end
	end
end
