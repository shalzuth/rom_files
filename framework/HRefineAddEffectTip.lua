autoImport("BaseTip");
HRefineAddEffectTip = class("HRefineAddEffectTip" ,BaseTip)

autoImport("HRefinePosTogCell");
autoImport("HRefineEffectTipCell");

function HRefineAddEffectTip:Init()
	self:InitTip();

	self.closeTip = self:FindGO("CloseAddTip");
	self:AddClickEvent(self.closeTip, function (go)
		self:CloseSelf();
	end);

	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
end

function HRefineAddEffectTip:CloseSelf()
	if(self.callback)then
		self.callback(self.callbackParam);
	end
	TipsView.Me():HideCurrent();
end

function HRefineAddEffectTip:InitTip()
	self.infoScrollView = self:FindComponent("InfoScrollView", UIScrollView);

	local effectTip = self:FindGO("HRefineEffectTip");
	self.title = self:FindComponent("Label", UILabel, effectTip);

	local posGrid = self:FindComponent("PosTogGrid", UIGrid);
	self.pogTogCtl = UIGridListCtrl.new(posGrid, HRefinePosTogCell, "HRefinePosTogCell");
	self.pogTogCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTog, self);

	local showPoses = GameConfig.HighRefine and GameConfig.HighRefine.showPoses or {{7,7}, {5,8}};
	local togDatas = {};
	for i=1,#showPoses do
		table.insert(togDatas, showPoses[i][1]);
	end

	local refineEffectGrid = self:FindComponent("HRefineInfoGrid", UIGrid);
	self.addEffectCtl = UIGridListCtrl.new(refineEffectGrid, HRefineEffectTipCell, "HRefineEffectTipCell");

	self.pogTogCtl:ResetDatas(togDatas);
	self.togCells = self.pogTogCtl:GetCells();
	self:ClickTog(self.togCells[1]);
end

function HRefineAddEffectTip:ClickTog(tog)
	self:UpdateEffectInfo(tog.data);

	local tCells = self.togCells;
	for i=1,#tCells do
		tCells[i]:SetTog(tog.data);
	end
end

function HRefineAddEffectTip:UpdateEffectInfo(pos)
	local datas = {};
	for i=1,15 do
		local effects = BlackSmithProxy.Instance:GetMyHRefineEffects(pos, nil, i);
		local data = {};
		data[1] = i;
		data[2] = effects[1];
		table.insert(datas, data)
	end
	self.addEffectCtl:ResetDatas(datas);

	self.infoScrollView:ResetPosition();

	local posName = nil;
	if(pos == 1)then
		posName = ZhString.HRefineAddEffectTip_Shield;
	else
		local gConfig = GameConfig.EquipType;
		for k,config in pairs(gConfig)do
			local sites = config.site;
			for i=1,#sites do
				if(sites[i] == pos)then
					posName = config.name;
					break;
				end
			end
		end
	end
	
	self.title.text = string.format(ZhString.PackageHighRefine_AddEffectTip, posName);
end

function HRefineAddEffectTip:SetData()
end

function HRefineAddEffectTip:DestroySelf()
	GameObject.Destroy(self.gameObject)
end
