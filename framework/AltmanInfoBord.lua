AltmanInfoBord = class("AltmanInfoBord", CoreView)

local RES_PATH = ResourcePathHelper.UIV1("part/AltmanInfoBord");
function AltmanInfoBord:ctor(parent)
	local go = AltmanInfoBord.LoadPreferb_ByFullPath(nil, RES_PATH, parent, true);
	go.transform.localPosition = LuaGeometry.Const_V3_zero;
	
	AltmanInfoBord.super.ctor(self, go);
	self:Init();
end

local RANK_DESC = GameConfig.Altman and GameConfig.Altman.kill_rank_desc or _EmptyTable;
function AltmanInfoBord:Init()
	self.titlelab = self:FindComponent("Title", UILabel);
	self.title_icon = self:FindComponent("TitleIcon", UILabel);
	self.lefttimelab = self:FindComponent("LeftTime", UILabel);
	self.monsternumlab = self:FindComponent("MonsterNum", UILabel);

	local content2 = self:FindGO("Content2");
	self.level_array = {};
	for i=1,#RANK_DESC do
		self.level_array[i] = self:FindComponent("Level" .. i, UILabel, content2);
	end

	self.activeSelf = self.gameObject.activeInHierarchy;
end

function AltmanInfoBord:Refresh()
	local lefttime, killcount, selfkill = DungeonProxy.Instance:GetAltManRaidInfo();
	if(lefttime == nil)then
		return;
	end

	self:UpdateLeftTime(lefttime);

	self.monsternumlab.text = string.format(ZhString.AltmanInfoBord_KillCountTip, killcount);

	local choosed = false;
	for i=1,#RANK_DESC do
		local rank_desc = RANK_DESC[i];
		if(choosed == false and killcount >= rank_desc.killcount)then
			choosed = true;
			self.level_array[i].text = "[c][00ff00]" .. RANK_DESC[i].title .. "[-][/c]";
		else
			self.level_array[i].text = RANK_DESC[i].title;
		end
	end
end

function AltmanInfoBord:UpdateLeftTime(time)
	self.lefttime = time;
	local leftSec = ServerTime.ServerDeltaSecondTime(time * 1000)
	local d,h,m,s = ClientTimeUtil.FormatTimeBySec( leftSec );

	if(not self:_UpdateLeftTimeTick())then
		return;
	end

	if(self.timeUpTick ~= nil)then
		return;
	end

	self.timeUpTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateLeftTimeTick, self, 1);
end

function AltmanInfoBord:_UpdateLeftTimeTick()
	local leftSec = ServerTime.ServerDeltaSecondTime(self.lefttime * 1000)
	if(leftSec < 0)then
		self.lefttimelab.text = string.format("%02d:%02d", 0, 0);

		self:RemoveUpdateLeftTimeTick();
		return false;
	end

	local d,h,m,s = ClientTimeUtil.FormatTimeBySec( leftSec );
	self.lefttimelab.text = string.format(ZhString.AltmanInfoBord_LeftTimeTip, m, s);
	return true;
end

function AltmanInfoBord:RemoveUpdateLeftTimeTick()
	if(self.timeUpTick == nil)then
		return;
	end

	TimeTickManager.Me():ClearTick(self, 1);

	self.timeUpTick = nil;
end

function AltmanInfoBord:ShowSelf()
	if(Slua.IsNull(self.gameObject))then
		return;
	end

	if(self.activeSelf == true)then
		return;
	end

	self.activeSelf = true;

	self.gameObject:SetActive(true);
end

function AltmanInfoBord:HideSelf()
	if(Slua.IsNull(self.gameObject))then
		return;
	end

	if(self.activeSelf == false)then
		return;
	end
	
	self.activeSelf = false;

	self.gameObject:SetActive(false);
	self:RemoveUpdateLeftTimeTick();
end

-- Init Begin
function AltmanInfoBord:OnEnter()
	AltmanInfoBord.super.OnEnter(self);
end

function AltmanInfoBord:OnExit()
	AltmanInfoBord.super.OnExit(self);
	self:RemoveUpdateLeftTimeTick();
end
-- Init End
