RaidEnterWaitView = class("RaidEnterWaitView",ContainerView)

RaidEnterWaitView.ViewType = UIViewType.PopUpLayer

autoImport("CarrierWaitListCell");

local evts = {};
function RaidEnterWaitView.SetListenEvent( evtname, evt )
	evts[evtname] = evt;
end
local startFunc;
function RaidEnterWaitView.SetStartFunc(func)
	startFunc = func;
end
local cancelFunc;
function RaidEnterWaitView.SetCancelFunc(func)
	cancelFunc = func;
end


function RaidEnterWaitView:Init()
	self.cache_value = {};

	self:InitView();
	self:MapEvent();
end

function RaidEnterWaitView:InitView()
	self.waitCell = self:LoadPreferb("cell/WaitCell", self.gameObject);
	self.waitCell.transform.localPosition = LuaVector3.zero;

	local waitGrid = self:FindGO("WaitList"):GetComponent(UIGrid)
	self.waitList = ListCtrl.new(waitGrid, CarrierWaitListCell, "CarrierWaitListCell")

	self.startBtn = self:FindGO("StartBtn")
	self.cancelBtn = self:FindGO("CancelBtn")

	local startBtn = self:FindGO("StartBtn")
	self:AddClickEvent(startBtn, function(go)
		if(startFunc)then
			startFunc(self)
		end
	end)

	local cancelBtn = self:FindGO("CancelBtn")
	self:AddClickEvent(cancelBtn,function(go)
		if(cancelFunc)then
			cancelFunc(self)
		end
	end)
end

function RaidEnterWaitView:MapEvent()
	self:AddListenEvt(TeamEvent.MemberEnterTeam, self.UpdateWaitList);
	self:AddListenEvt(TeamEvent.MemberExitTeam, self.UpdateWaitList);

	if(evts == nil)then
		return;
	end

	for k, v in pairs(evts)do
		local func = function(view_self, note)
			v(view_self, note)
		end
		self:AddListenEvt(k, func);
	end
end

function RaidEnterWaitView:UpdateWaitList(defaultValue)
	if(defaultValue == nil)then
		defaultValue = false;
	end

	local myTeam = TeamProxy.Instance.myTeam;
	if(myTeam == nil)then
		return;
	end
	
	local members = myTeam:GetPlayerMemberList(true, true);
	self.datas = {};

	local myid = Game.Myself.data.id;

	local m;
	for i=1,#members do
		m = members[i];

		local tdata = {};
		tdata.name = m.name;

		if(self.cache_value[m.id] == nil)then
			if(myid == m.id)then
				tdata.agree = true;
			else
				tdata.agree = defaultValue;
			end
		else
			tdata.agree = self.cache_value[m.id];
		end
		table.insert(self.datas, tdata)
	end
	self.waitList:ResetDatas(self.datas);
end

function RaidEnterWaitView:UpdateMemberEnterState(memberid, state)
	self.cache_value[memberid] = state;
end

function RaidEnterWaitView:OnEnter()
	RaidEnterWaitView.super.OnEnter(self);

	self:UpdateWaitList();
end

function RaidEnterWaitView:OnExit()
	RaidEnterWaitView.super.OnExit(self);

	TableUtility.TableClear(self.cache_value);
end