InviteConfirmCtl = class("InviteConfirmCtl", CoreView);

autoImport("QueueWaitCtrl");
autoImport("InviteConfirmCell");

InviteType = {
	Team = "teamInviteMap",
	Guild = "guildInviteMap",
	-- ??????????????????????????????
	Carrier = "carrierInviteMap",
	JoinHand = "carrierInviteMap", 
	-- ??????
	Dojo = "dojoInviteMap",
	-- ??????
	Augury = "auguryMap",
	
	EndlessTower = "endlessTowerInviteMap",
	FerrisWheel = "ferrisWheelMap",
	
	-- ??????
	Follow = "Follow",
	-- ??????????????????
	TmLeaderAcp = "TmLeaderAcp",

	-- ??????
	Courtship = "Courtship",
	-- ????????????
	WeddingCemoney = "WeddingCemoney",
	-- ??????
	Engage = "Engage",
	-- ????????????
	ConsentDivorce = "ConsentDivorce",

	DesertWolf ="DesertWolf",
	-- ????????????
	RaidCard = "RaidCard",

	DoubleAction = "DoubleAction",
	AltMan = "AltMan",
	
	-- PVP????????????????????????
	InviteWithMe = "InviteWithMe",

	HelpFinishQuest = "HelpFinishQuest",
}

function InviteConfirmCtl:ctor(go)
	self.gameObject = go;
	self.grid = go:GetComponent(UIGrid);
	self.queue = QueueWaitCtrl.CreateAsArray(3);

	for _,key in pairs(InviteType)do
		self[key] = {};
	end
end

-- {type, playerid, name, tip, lab, yesevt, noevt, endevt, time, agreeNoClose}
function InviteConfirmCtl:AddInvite(type, data)
	if(not self[type])then
		return;
	end

	local cellctl = self[type][data.playerid];
	if(not cellctl)then
		cellctl = InviteConfirmCell.new(self.gameObject, data);
		self[type][data.playerid] = cellctl;

		cellctl:AddEventListener(InviteConfirmEvent.Agree, function ()
			if(not data.agreeNoClose)then
				self:ClearInviteMap(type, cellctl);
			end
		end, self);

		cellctl:AddEventListener(InviteConfirmEvent.Refuse, function ()
			self:RemoveInviteCell(type, cellctl);
		end, self);

		cellctl:AddEventListener(QueueBaseCell.EXIT, function ()
			self:RemoveInviteCell(type, cellctl);
		end, self);

		self.queue:AddCell(cellctl);
	end

	self.grid:Reposition();
end

function InviteConfirmCtl:RemoveInviteById(type, id)
	local cells = self[type];
	if(cells == nil)then
		return;
	end

	if(cells[id])then
		self:RemoveInviteCell(type, cells[id]);
	end
end

function InviteConfirmCtl:RemoveInviteCell(type, cellctl)
	for k,v in pairs(self[type]) do
		if(v == cellctl)then
			self[type][k] = nil;
		end
	end

	self.grid:Reposition();
end

function InviteConfirmCtl:ClearInviteMap(type, cellctl)
	if(not self[type])then
		return;
	end

	for k,v in pairs(self[type]) do
		if(v~=cellctl)then
			v:Exit();
		end
	end
	self[type] = {};
end



