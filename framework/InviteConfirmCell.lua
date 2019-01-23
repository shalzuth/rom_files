autoImport("QueueBaseCell");
InviteConfirmCell = class("InviteConfirmCell", QueueBaseCell);

InviteConfirmCell.resID = ResourcePathHelper.UICell("InviteConfirmCell");

function InviteConfirmCell:ctor(parent, data)
	self.parent = parent;
	self.data = data;
end

function InviteConfirmCell:Enter()
	if(not self.gameObject)then
		self.gameObject = self:CreateObj(InviteConfirmCell.resID, self.parent);

		self.tipLabel = self:FindGO("Tip"):GetComponent(UILabel);
		self.loveTitle = self:FindGO("LoveTitle");
		self.nobtn = self:FindGO("NoBtn");
		self.yesbtn = self:FindGO("YesBtn");
		self.yestip = self:FindGO("Label", self.yesbtn):GetComponent(UILabel);
		self.lab = self:FindGO("Context"):GetComponent(UILabel);
		self.timeSlider = self:FindGO("TimeSlider"):GetComponent(UISlider);

		self:SetEvent(self.yesbtn, function ()
			self:ExcuteYesEvent();
		end);
		self:SetEvent(self.nobtn, function ()
			self:ExcuteNoEvent();
		end);
	end

	self:SetData();
end

function InviteConfirmCell:ExcuteYesEvent()
	if(self.yesevt)then
		self.yesevt(self.playerid);
	end
	self:PassEvent(InviteConfirmEvent.Agree, self);

	local noClose = self.data and self.data.agreeNoClose;
	if(not noClose)then
		self:Exit();
	end
end

function InviteConfirmCell:ExcuteNoEvent()
	if(self.noevt)then
		self.noevt(self.playerid);
	end
	self:PassEvent(InviteConfirmEvent.Refuse, self);

	self:Exit();
end

-- type playerid, tip, lab, yesevt, noevt, endevt, time, msgId, msgParama, agreeNoClose
function InviteConfirmCell:SetData(data)
	if(data)then
		self.data = data;
	else
		data = self.data;
	end
	if(self.data)then
		if(self.data.type == InviteType.FerrisWheel)then
			self.tipLabel.gameObject:SetActive(false);
			self.loveTitle:SetActive(true);
		else
			self.tipLabel.gameObject:SetActive(true);
			self.loveTitle:SetActive(false);
		end
		
		self.playerid = data.playerid;
		if(data.msgId)then
			local tipData = Table_Sysmsg[data.msgId];
			self.tipLabel.text = tipData.Title;
			local msgParama = data.msgParama or {};
			self.lab.text = MsgParserProxy.Instance:TryParse(tipData.Text, unpack(msgParama));
			self.yestip.text = tipData.button;
		else
			self.lab.text = data.lab;
			self.yestip.text = data.button;
		end
		self:FitCell();
		
		if(data.tip)then
			self.tipLabel.text = data.tip;
		end
		self.yesevt = data.yesevt;
		self.noevt = data.noevt;
		self.endevt = data.endevt;

		self:UpdateTime(data.time, data.time);
	end
end

local tempV3 = LuaVector3.New(0, 0, 0);
function InviteConfirmCell:FitCell()
	local lab = self.lab;

	lab.width = 280;
	lab.overflowMethod = 1;
	lab:ProcessText();

	local strContent = lab.text;
	local bWarp, strOut;
	bWarp, strOut = lab:Wrap(strContent, strOut, lab.height);
	if(not bWarp)then
		lab.overflowMethod = 2;
		lab:ProcessText();

		if(lab.width >= 1100)then
			lab.width = 1100;
			lab.overflowMethod = 0;
			lab:ProcessText();
		end
	end

	tempV3:Set(-195, 7);
	lab.transform.localPosition = tempV3;
end

function InviteConfirmCell:UpdateTime(leftTime, totalTime)
	LeanTween.cancel(self.gameObject);
	
	if(leftTime == nil or totalTime == nil)then
		self.timeSlider.gameObject:SetActive(false);
		return;
	end

	self.timeSlider.gameObject:SetActive(true);
	local value = leftTime/totalTime;
	LeanTween.value(self.gameObject, function(v)
		self.timeSlider.value = v;
	end, value, 0, leftTime):setDestroyOnComplete (true):setOnComplete(function()
		if(self.endevt)then
			self.endevt(self.playerid);
		end
		self:PassEvent(InviteConfirmEvent.TimeOver, self);

		self:Exit();
	end);
end

function InviteConfirmCell:Exit()
	LeanTween.cancel(self.gameObject);

	Game.GOLuaPoolManager:AddToUIPool(InviteConfirmCell.resID, self.gameObject)
	self.gameObject = nil;
	InviteConfirmCell.super.Exit(self);
end