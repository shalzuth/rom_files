InviteConfirmCtl = class("InviteConfirmCtl", CoreView);

autoImport("QueueWaitCtrl");
autoImport("InviteConfirmCell");

InviteType = {
	Team = "teamInviteMap",
	Guild = "guildInviteMap",
	-- 载具跟牵手不可以共存
	Carrier = "carrierInviteMap",
	JoinHand = "carrierInviteMap", 
	-- 道场
	Dojo = "dojoInviteMap",
	-- 占卜
	Augury = "auguryMap",
	
	EndlessTower = "endlessTowerInviteMap",
	FerrisWheel = "ferrisWheelMap",
	
	-- 跟随
	Follow = "Follow",
	-- 看板任务接取
	TmLeaderAcp = "TmLeaderAcp",

	-- 求婚
	Courtship = "Courtship",
	-- 结婚婚礼
	WeddingCemoney = "WeddingCemoney",
	-- 订婚
	Engage = "Engage",
	-- 协议离婚
	ConsentDivorce = "ConsentDivorce",

	DesertWolf ="DesertWolf",
	-- 卡牌副本
	RaidCard = "RaidCard",

	DoubleAction = "DoubleAction",
	AltMan = "AltMan",
	
	-- PVP集结糖浆传送邀请
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



