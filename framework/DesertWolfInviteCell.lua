local baseCell = autoImport("BaseCell")
DesertWolfInviteCell = class("DesertWolfInviteCell", baseCell);
local resID = ResourcePathHelper.UICell("DesertWolfInviteCell");

local replyType = PvpProxy.Type.DesertWolf

local intervalTime = GameConfig.Team.inviteovertime

local tempHeightHigh = 485
local tempHeightLow = 378

function DesertWolfInviteCell:ctor(parent, data)
	self.parent = parent;
	self.data = data;
	self:Enter()
end

function DesertWolfInviteCell:Enter()
	if(not self.gameObject)then
		self.gameObject = self:CreateObj(resID, self.parent);
		local bgGo = self:FindGO("Bg")
		self.bgImg =self:FindGO("BgImg"):GetComponent(UISprite)
		self:SetBgImgHeight()
		self.noBtn = self:FindGO("NoBtn");
		self.yesBtn = self:FindGO("YesBtn");
		self.Context = self:FindGO("Context"):GetComponent(UILabel);
		self.timeSlider = self:FindGO("TimeSlider"):GetComponent(UISlider);
		self.headGrid=self:FindGO("memberGrid",bgGo):GetComponent(UIGrid);
		self.playerTipStick = self:FindComponent("Stick", UIWidget);
		self.headCtl = UIGridListCtrl.new(self.headGrid , DesertInviteHeadCell, "DesertInviteHeadCell")
		self.headCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMember, self);
		self:AddClickEvent(self.noBtn,function (g)
			self:OnRefuse()
		end)
		self:AddClickEvent(self.yesBtn,function (g)
			self:OnConfirm()
		end)
	end

	self:SetData();
end

function DesertWolfInviteCell:ClickMember(cell)
	local memberHeadData = cell.data;
	local id = memberHeadData.iconData.id;
	if(id == Game.Myself.data.id)then
		return;
	end
	local members = self.data.members

	local targetMemberData 
	for i=1,#members do
		local teamMemberData = TeamMemberData.new(members[i])
		if(teamMemberData.id==id)then
			targetMemberData=teamMemberData
			break
		end
	end

	if(targetMemberData)then
		local playerData = PlayerTipData.new();
		playerData:SetByTeamMemberData(targetMemberData);
		if(not self.playerTipShow)then
			self.playerTipShow = true;
			local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.playerTipStick, NGUIUtil.AnchorSide.Left, {-500,0});
			local tipData = {
				playerData = playerData,
				funckeys = {"SendMessage", "AddFriend", "AddBlacklist", "ShowDetail"},
			};
			playerTip:SetData(tipData);
			playerTip.closecallback = function (go)
				self.playerTipShow = false;
			end
		else
			FunctionPlayerTip.Me():CloseTip();
			self.playerTipShow = false;
		end
	else
		redlog("not find member", tostring(id));
	end
end

function DesertWolfInviteCell:OnRefuse()
	local roomid = self.data.roomid
	ServiceMatchCCmdProxy.Instance:CallRevChallengeCCmd(replyType,roomid,nil,nil,nil,2)
	self:OnExit()
end

function DesertWolfInviteCell:OnConfirm()
	local roomid = self.data.roomid
	ServiceMatchCCmdProxy.Instance:CallRevChallengeCCmd(replyType,roomid,nil,nil,nil,1)
	self:OnExit()
end

function DesertWolfInviteCell:SetData()
	if(not self.data)then return end
	local data = self.data
	self.data = data;
	self.roomID = data.roomid
	self:RefreshTeamMemberHead()
	self.type=data.type
	local zoneid = data.challenger_zoneid % 10000
	local zoneidStr = ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
	self.Context.text =string.format(ZhString.DesertWolf_InviteChallenge,data.challenger,zoneidStr)
	self:_timeCountDown()
end

function DesertWolfInviteCell:RefreshTeamMemberHead()
	local teamData = self.data.members
	
	if(not self.headDatas)then
		self.headDatas = {};
	else
		TableUtility.ArrayClear(self.headDatas);
	end
	for i=1,#teamData do
		local headData = self.headDatas[i];
		local teamMemberData = TeamMemberData.new(teamData[i])
		if(teamMemberData)then
			if(headData == nil)then
				headData = HeadImageData.new();
				self.headDatas[i] = headData;
			end
			headData:TransByTeamMemberData(teamMemberData);
		else
			self.headDatas[i] = 0;
		end
	end
	self.headCtl:ResetDatas(self.headDatas)
	self.headGrid:Reposition()
end

function DesertWolfInviteCell:SetBgImgHeight()
	if(#self.data.members>3)then
		self.bgImg.height=tempHeightHigh
	else
		self.bgImg.height=tempHeightLow
	end
end

function DesertWolfInviteCell:_timeCountDown()
	local deltaTime, lastTime = 0;
	self.timeTick=TimeTickManager.Me():CreateTick(0, 33, function (self)
		if(lastTime)then
			deltaTime = deltaTime + (RealTime.time - lastTime);
			local rate = (intervalTime-deltaTime)/intervalTime
			self.timeSlider.value = rate;
			if(deltaTime>intervalTime)then
				self:OnExit()
			end
		end
		lastTime = RealTime.time;
	end, self, 1);
end

function DesertWolfInviteCell:_stopTick()
	TimeTickManager.Me():ClearTick(self,1)
	self.timeTick=nil;
end

function DesertWolfInviteCell:OnExit()
	self:_stopTick()
	Game.GOLuaPoolManager:AddToUIPool(resID, self.gameObject)
	self.headCtl:RemoveAll()
	self.gameObject = nil;
end




