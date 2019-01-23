autoImport("BaseTip");
RClickTip = class("RClickTip" ,BaseTip)

autoImport("RClickFuncCell");

function RClickTip:Init()
	RClickTip.super.Init(self);
	local grid = self.gameObject:GetComponent(UIGrid);
	self.clickCtl = UIGridListCtrl.new(grid, RClickFuncCell, "RClickFuncCell");
	self.clickCtl:AddEventListener(MouseEvent.MouseClick, self.clickFunc, self);

	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.closecomp.callBack = function (go) self:CloseSelf(); end
end

function RClickTip:clickFunc(cellCtl)
	local funcData = cellCtl.data;
	if(funcData)then
		local func = RClickFunction.GetFunc(funcData.key);
		if(func)then
			func(self.playerData);
		end
		if(self.clickcallback)then
			self.clickcallback(funcData);
		end
	end
	self:CloseSelf();
end

function RClickTip:CloseSelf()
	if(self.closecallback)then
		self.closecallback();
	end
	TipsView.Me():HideCurrent();
end

-- {funckeys, playerData}
function RClickTip:SetData(data)
	self.closecomp:ClearTarget();

	if(data)then
		local funcConfigs = {};
		for i=1,#data.funckeys do
			local config = RClickFunction.FuncConfig[data.funckeys[i]];
			table.insert(funcConfigs, config);
		end
		self.clickCtl:ResetDatas(funcConfigs);

		self.playerData = data.playerData;
		self.closecallback = data.closecallback;
		self.clickcallback = data.clickcallback;
	end

	-- self.closecomp:ReCalculateBound();
end

function RClickTip:OnEnter()
end

function RClickTip:OnExit()
	return true;
end

function RClickTip:DestroySelf()
	GameObject.DestroyImmediate(self.gameObject)
end

function RClickTip:AddIgnoreBound(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end













