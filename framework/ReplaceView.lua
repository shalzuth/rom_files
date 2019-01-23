ReplaceView = class("ReplaceView", ContainerView)

ReplaceView.ViewType = UIViewType.NormalLayer

autoImport("ReplaceEquipItemCell");

function ReplaceView:Init()
	self:InitView();
	self:MapEvent();
end

function ReplaceView:InitView()
	local targetCellGO = self:FindGO("TargetCell");
	self.targetCell = BaseItemCell.new(targetCellGO)
	self.targetCell:AddEventListener(MouseEvent.MouseClick, self.clickTargetCell, self);
	self.bg = self:FindComponent("PanelBg", UISprite);

	local rmgrid = self:FindComponent("ReplaceMaterialGrid", UIGrid);
	self.materialCtl = UIGridListCtrl.new(rmgrid, ReplaceEquipItemCell, "DropItemCell");
	self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMaterial, self);

	self.replaceTitle = self:FindComponent("ReplaceTitle", UILabel);
	self.replaceTip = self:FindComponent("ReplaceTip", UILabel);
	self.zenyCost = self:FindComponent("ZenyCost", UILabel);

	local coins = self:FindChild("TopCoins");
	local usergold = self:FindGO("Gold", coins);
	self.goldLabel = self:FindComponent("Label", UILabel, usergold);
	local userRob = self:FindGO("Silver", coins);
	self.robLabel = self:FindComponent("Label", UILabel, userRob);

	self.replaceButton = self:FindGO("ReplaceBtn");
	self:AddClickEvent(self.replaceButton, function (go)
		local pos = self.nowItemData and self.nowItemData.index;
		ServiceItemProxy.Instance:CallEquipExchangeItemCmd(pos);
	end);
end

function ReplaceView:clickTargetCell(cellCtl)
	self:ShowItemTipByItemCell(cellCtl);
end

function ReplaceView:ClickMaterial(cellCtl)
	self:ShowItemTipByItemCell(cellCtl);
end

function ReplaceView:ShowItemTipByItemCell(cellCtl)
	if(self.lastCtl ~= cellCtl)then
		local callback = function ()
			self.lastCtl = nil;
		end;
		local sdata = {
			itemdata = cellCtl.data, 
			ignoreBounds = {cellCtl.gameObject},
			callback = callback,
		};
		self:ShowItemTip(sdata, self.bg, NGUIUtil.AnchorSide.Left, {-180,0});
		self.lastCtl = cellCtl;
	else
		self:ShowItemTip();
		self.lastCtl = nil;
	end
end

function ReplaceView:UpdateCoins()
	self.goldLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetGold())
	self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function ReplaceView:UpdateItemInfo()
	if(self.nowItemData)then
		self.composeId = self.nowItemData.staticData.ComposeID;
		if(self.composeId)then
			local composeData = Table_Compose[self.composeId];
			if(composeData)then
				local composeCost = composeData.BeCostItem;
				local materials = {};
				local maxNeedNum, hasNum = 0,0;
				for i=1,#composeCost do
					local itemCfg = composeCost[i];
					local itemid = itemCfg.id;
					local bagItems = BagProxy.Instance:GetItemsByStaticID(itemid);
					local searchNum = 0;
					if(bagItems)then
						for j = #bagItems,1,-1 do
							-- 强化/精炼/插过卡装备无法作为材料
							local equipInfo = bagItems[j].equipInfo;
							local equipCards = bagItems[j].equipedCardInfo
							local enchantInfo = bagItems[j].enchantInfo;
							if(equipInfo)then
								if( equipInfo.strengthlv > 0 
										or equipInfo.refinelv > 0 
										or (equipCards and #equipCards > 0)
										or (enchantInfo and enchantInfo:HasAttri()) )then
									table.remove(bagItems, j);
								end
							end
						end
					end
					
					local searchNum = bagItems and #bagItems or 0;
					hasNum = hasNum + searchNum;
					local maxNum = itemCfg.num or 0;
					maxNeedNum = maxNeedNum + maxNum;
					for k=1,maxNum do
						if(bagItems and bagItems[k])then
							table.insert(materials, bagItems[k]);
						else
							local itemData = ItemData.new("LackItem", itemCfg.id);
							table.insert(materials, itemData);
						end
					end
				end
				self.materialCtl:ResetDatas(materials);

				local cost = composeData.ROB;
				self.zenyCost.text = tostring(cost);

				self.replaceTitle.text = string.format(ZhString.ReplaceView_ReplaceTitle, hasNum, maxNeedNum);

				local toItemId = composeData.Product.id;
				if(toItemId)then
					local toItemData = ItemData.new("ToItem", toItemId);
					local toItemName = toItemData.staticData.NameZh;
					local nowItemName = self.nowItemData.staticData.NameZh;
					self.replaceTip.text = string.format(ZhString.ReplaceView_ReplaceTip, tostring(nowItemName), toItemName);
					self.targetCell:SetData(toItemData);
				end
			end
		end
	end
end

function ReplaceView:UpdateReplaceInfo()
	self:UpdateCoins();

	local viewdata = self.viewdata and self.viewdata.viewdata;
	self.nowItemData = viewdata.itemData;
	self:UpdateItemInfo();

end

function ReplaceView:MapEvent()
	self:AddListenEvt(ServiceEvent.ItemEquipExchangeItemCmd, self.HandleReplaceResult);
end

function ReplaceView:HandleReplaceResult(note)
	MsgManager.FloatMsgTableParam(nil, "Replace Success");
	self:ShowEndDialog();
	self:CloseSelf();
end

function ReplaceView:OnEnter()
	ReplaceView.super.OnEnter(self);

	self:UpdateReplaceInfo();

	self.npcdata = self.viewdata.viewdata and self.viewdata.viewdata.npcdata;
	if(self.npcdata)then
		self:CameraFocusOnNpc(self.npcdata.roleAgent.transform);
	else
		self:CameraRotateToMe();
	end	
end

function ReplaceView:OnExit()
	ReplaceView.super.OnExit(self);
	self:CameraReset();
end

function ReplaceView:ShowEndDialog()
	local viewdata = {
		viewname = "DialogView",
		dialoglist = { ZhString.ReplaceView_ReplaceSuccess },
		npcinfo = self.npcdata,
	};
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata);
end














