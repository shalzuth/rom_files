autoImport("BaseTip");
ItemScoreTip = class("ItemScoreTip" ,BaseView)

autoImport("ItemTipModelCell");
autoImport("AdvTipRewardCell");

ItemScoreTip.LockInfoPos = {
	Fashion = Vector3(50, -235),
	Mount = Vector3(53, -160),
	Card = Vector3(50, -240),
}

local tempVector3 = LuaVector3.zero

function ItemScoreTip:ctor(parent)
	self.resID = ResourcePathHelper.UITip("ItemScoreTip")
	
	self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent);
	self.gameObject.transform.localPosition = Vector3.zero;
	self:Init()
end

function ItemScoreTip:Init()
	self:initLockBord()
	self.cell = ItemTipModelCell.new(self.gameObject);
	self.gameObject.transform.localPosition = Vector3.zero;
	
	-- local dadventureScore = self:FindGO("DefaultAdventureScore");
	-- self.dascorelab = self:FindComponent("Label", UILabel, dadventureScore);
	
	--todo xde fix ui
	local getPathBtn = self:FindGO("getPathBtn")
	local l = self:FindGO("Label",getPathBtn):GetComponent(UILabel)
	OverseaHostHelper:FixLabelOverV1(l,0,64)
end

function ItemScoreTip:adjustPanelDepth( startDepth )
	-- body
	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	local panels = self:FindComponents(UIPanel);
	local minDepth = nil;
	for i=1,#panels do
		if(minDepth == nil)then
			minDepth = panels[i].depth;
		else
			minDepth = math.min(panels[i].depth, minDepth);
		end
	end
	startDepth = startDepth or 1;
	for i=1,#panels do
		panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth;
	end
end

function ItemScoreTip:initLockBord(  )
	-- body
	local obj = self:FindGO("LockBord")
	self.lockBord = self:FindGO("LockBordHolder");
	if(not obj)then
		obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord);
		obj.name = "LockBord";
	end
	obj.transform.localPosition = Vector3.zero
	obj.transform.localScale = Vector3.one	
		
	local grid = self:FindComponent("LockInfoGrid", UIGrid);
	self.advRewardCtl = UIGridListCtrl.new(grid, AdvTipRewardCell, "AdvTipRewardCell");
	self.scrollView = self:FindComponent("ScrollView",UIScrollView)

	self.PropertyReward = self:FindComponent("PropertyReward",UILabel)
	grid = self:FindComponent("PropertyGrid",UIGrid)
	self.PropertyGrid = UIGridListCtrl.new(grid, TipLabelCell, "AdventureTipLabelCell");
	self.bottomCt = self:FindGO("BottomCt")
	-- local scoreCt = self:FindGO("scoreCt")
	-- self:Hide(scoreCt)
	self.modelBottombg = self:FindGO("modelBottombg")
	
	--todo xde
	local l = self:FindGO("ItemName",self.modelBottombg):GetComponent(UILabel)
	l.fontSize = 22
	OverseaHostHelper:FixLabelOverV1(l, 1, 340)
	----[[ todo xde 0003153: ??????????????????????????????????????????????????????????????????????????
	if(AppBundleConfig.GetSDKLang() == 'vi') then
		OverseaHostHelper:FixLabelOverV1(l, 0, 380)
	end
	--]]
end

function ItemScoreTip:SetData(data)
	self.data = data;
	self:initData()
	self:SetLockState();
	self:adjustLockRewardPos()
	self:adjustPanelDepth(4)
	self.cell:updateWidgetColor()
end

function ItemScoreTip:initData(  )
	-- body
	if(self.data)then
		self.cell:SetData(self.data);
		self:UpdateAdvReward();
	end
end

function ItemScoreTip:adjustLockRewardPos(  )
	-- body
	-- local table = self:FindComponent("AttriTable", UITable);
	-- local UnlockReward = self:FindGO("UnlockReward")
	-- self:Show(UnlockReward)
	-- local bound = NGUIMath.CalculateRelativeWidgetBounds(table.transform);
	-- local pos = table.transform.localPosition
	-- local y = pos.y - bound.size.y - 20
	-- UnlockReward.transform.localPosition = Vector3(pos.x,y,pos.z)	
end

function ItemScoreTip:SetLockState()

	self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
	if(self.isUnlock or self.data.store)then
		self.Show(self.lockBord)
		self:Hide(self.bottomCt)
		self:Show(self.modelBottombg)
	else
		self:Hide(self.modelBottombg)
		self.Show(self.lockBord)
		self.Show(self.bottomCt)
	end	

	self.cell.isUnlock = self.isUnlock
	return self.isUnlock
end

function ItemScoreTip:UpdateAdvReward()
	local advReward, advRDatas = self.data.staticData.AdventureReward, {};
	if(self.data.staticData.AdventureValue and self.data.staticData.AdventureValue>0)then
		local temp = {};
		temp.showName = true
		temp.type = "AdventureValue";
		temp.value = self.data.staticData.AdventureValue;
		table.insert(advRDatas, temp);
	end
	if(type(advReward)=="table")then
		if(advReward.AdvPoints)then
			local temp = {};
			temp.type = "AdvPoints";
			temp.value = advReward.AdvPoints;
			table.insert(advRDatas, temp);
		end		
		if(advReward.item)then
			for i=1,#advReward.item do
				local temp = {};
				temp.type = "item";
				temp.value = advReward.item[i];
				table.insert(advRDatas, temp);
			end
		end
	end

	local FixAttrCt = self:FindGO("FixAttrCt")
	local x,y,z = LuaGameObject.GetLocalPosition(FixAttrCt.transform)
	local bound = NGUIMath.CalculateRelativeWidgetBounds(FixAttrCt.transform);
	y = y - bound.size.y - 20
	local transform = self.advRewardCtl.layoutCtrl.transform
	tempVector3:Set(LuaGameObject.GetLocalPosition(transform))
	tempVector3:Set(tempVector3.x,y,tempVector3.z)
	transform.localPosition = tempVector3
	self.advRewardCtl:ResetDatas(advRDatas);
end

function ItemScoreTip:OnExit()
	self.advRewardCtl:ResetDatas()
	ItemScoreTip.super.OnExit(self);
	if(self.cell)then
		self.cell:OnExit();
	end
	Game.GOLuaPoolManager:AddToUIPool(self.resID,self.gameObject)
end