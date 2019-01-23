SealTaskPage = class("SealTaskPage", SubMediatorView)

autoImport("SealTaskCell");
autoImport("DialogCell");

function SealTaskPage:Init()
	self:ReLoadPerferb("view/SealTaskPage");

	self:InitUI();
	self:MapEvents();

	self.npcinfo = self.viewdata.npcinfo;
	self.npcAgent = self.npcinfo and self.npcinfo.roleAgent;
end

function SealTaskPage:InitUI()
	self.dailyTime = self:FindComponent("DailyTime", UILabel);
	self.noneTip = self:FindGO("NoneTip");

	local grid = self:FindComponent("SealGrid", UIGrid);
	self.taskCtl = UIGridListCtrl.new(grid ,SealTaskCell ,"SealTaskCell");
	self.taskCtl:AddEventListener(MouseEvent.MouseClick,self.childClick,self)

	self:UpdateDailyTime();
end


function SealTaskPage:OnEnter()
	SealTaskPage.super.OnEnter(self);
	
	ServiceSceneSealProxy.Instance:CallSealQueryList() 
end

function SealTaskPage:OnExit()
	SealTaskPage.super.OnExit(self);
end

function SealTaskPage:childClick(cellctl)
	local aceptSeal = SealProxy.Instance.nowAcceptSeal;
	if(TeamProxy.Instance:IHaveTeam())then
		if(cellctl and cellctl.data)then
			local data = cellctl.data.staticData;
			local accept = cellctl.data.accept;
			if(accept)then
				MsgManager.ConfirmMsgByID(1609, function ()
					ServiceSceneSealProxy.Instance:CallSealAcceptCmd(data.id, accept);
				end, nil,nil);
			else
				if(aceptSeal and aceptSeal~=0)then
					MsgManager.ConfirmMsgByID(1612, function ()
						ServiceSceneSealProxy.Instance:CallSealAcceptCmd(data.id, accept);
					end, nil,nil);
				else
					ServiceSceneSealProxy.Instance:CallSealAcceptCmd(data.id, accept);
				end
			end
		end
	else
		MsgManager.ShowMsgByIDTable(1607);
	end
end

function SealTaskPage:UpdateSealTasks()
	local list = SealProxy.Instance.nowSealTasks;
	local aceptSeal = SealProxy.Instance.nowAcceptSeal;
	local sealtasks = {};
	for i=1,#list do
		if(list[i])then
			local rsdata = Table_RepairSeal[list[i]];
			if(rsdata)then
				local tempData = {};
				tempData.staticData = rsdata;
				tempData.accept = rsdata.id == aceptSeal;
				table.insert(sealtasks, tempData);
			end
		end
	end
	self.taskCtl:ResetDatas(sealtasks);
	self.noneTip:SetActive(#list == 0);
end

function SealTaskPage:UpdateDailyTime()
	-- 更新封印次数
	local var = MyselfProxy.Instance:getVarByType(Var_pb.EVARTYPE_SEAL);
	local donetimes = var and var.value;
	donetimes = donetimes or 0;
	local maxtimes = GameConfig.Seal.maxSealNum;
	self.dailyTime.text = donetimes.."/"..maxtimes;
end

function SealTaskPage:MapEvents()
	self:AddListenEvt(ServiceEvent.SceneSealSealQueryList, self.HandleSealQueryList);
	self:AddListenEvt(ServiceEvent.SceneSealSealAcceptCmd, self.HandleSealQueryList);
end

function SealTaskPage:HandleSealQueryList( note )
	self:UpdateSealTasks();
	self:UpdateDailyTime();
end



