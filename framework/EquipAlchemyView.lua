EquipAlchemyView = class("EquipAlchemyView", ContainerView)

EquipAlchemyView.ViewType = UIViewType.NormalLayer

autoImport("EquipAlchemyItemCell");
autoImport("EquipAlchemyMakeCell");
autoImport("EquipAlchemyMaterialCell");

local tempV3 = LuaVector3();

function EquipAlchemyView:Init()
	self:InitView();
	self:MapEvent();
end

function EquipAlchemyView:InitView()
	-- coins
	local coins = self:FindChild("TopCoins");
	self.lottery = self:FindChild("Lottery", coins);
	self.lotterylabel = self:FindComponent("Label", UILabel, self.lottery);
	local icon = self:FindComponent("symbol", UISprite, self.lottery);
	IconManager:SetItemIcon(Table_Item[151].Icon, icon);
	self.userRob = self:FindChild("Silver", coins);
	self.robLabel = self:FindComponent("Label", UILabel, self.userRob);

	self.alchemyBord = self:FindGO("AlchemyBord");

	self.makeButton = self:FindGO("MakeBtn");

	self.costTip = self:FindGO("CostTip");
	self.makeCostLabel = self:FindComponent("Cost", UILabel);
	-- coins

	local equipalcheMy_Container = self:FindGO("EquipAlchemy_ItemContainer");
	local alchemyGO = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("EquipAlchemyItemCell"), equipalcheMy_Container);
	self.selectCell = EquipAlchemyItemCell.new(alchemyGO);
	self.selectCell:SetMinDepth(50);
	self.selectCell:AddEventListener(MouseEvent.MouseClick, self.ClickEquipAlchemyItem, self)

	self.vmSlider = self:FindComponent("VMSlider", UISlider);
	self.vmSlider_Thumb = self:FindGO("Thumb", self.vmSlider.gameObject);
	self.vmSlider_Thumb_Label = self:FindComponent("PctLabel", UILabel, self.vmSlider.gameObject);
	self.vmSlider_Foreground = self:FindComponent("Foreground", UITexture, self.vmSlider.gameObject);
	self.mmSlider = self:FindComponent("MMSlider", UISlider);
	self.mmSlider_Thumb = self:FindGO("Thumb", self.mmSlider.gameObject);
	self.mmSlider_Thumb_Label = self:FindComponent("PctLabel", UILabel, self.mmSlider.gameObject);
	self.mmSlider_Foreground = self:FindComponent("Foreground", UITexture, self.vmSlider.gameObject);

	-- ctls
	local mkContainer = self:FindGO("MKContainer");
	local mkConfig = {
		wrapObj = mkContainer, 
		pfbNum = 7, 
		cellName = "EquipAlchemyMakeCell", 
		control = EquipAlchemyMakeCell, 
		dir = 1,
	};
	self.mkCtl = WrapCellHelper.new(mkConfig);
	self.mkCells = self.mkCtl:GetCellCtls();
	self.mkCtl:AddEventListener(MouseEvent.MouseClick, self.UpdateSeleceCell, self);

	local vmWrap = self:FindGO("VMWrap");
	local vmConfig = {
		wrapObj = vmWrap, 
		pfbNum = 6, 
		cellName = "EquipAlchemyMaterialCell", 
		control = EquipAlchemyMaterialCell, 
		dir = 2,
	};
	self.vmCtl = WrapCellHelper.new(vmConfig);
	self.vmCells = self.vmCtl:GetCellCtls();
	self.vmCtl:AddEventListener(MouseEvent.MouseClick, self.AddVMaterial, self);
	self.vmCtl:AddEventListener(EquipAlchemyMaterialEvent.Remove, self.RemoveVMaterial, self);
	self.vmCtl:AddEventListener(EquipAlchemyMaterialEvent.LongPress, self.ConsAddVMaterial, self);

	local mmWrap = self:FindGO("MMWrap");
	local mmConfig = {
		wrapObj = mmWrap, 
		pfbNum = 6, 
		cellName = "EquipAlchemyMaterialCell", 
		control = EquipAlchemyMaterialCell, 
		dir = 2,
	};
	self.mmCtl = WrapCellHelper.new(mmConfig);
	self.mmCells = self.mmCtl:GetCellCtls();
	self.mmCtl:AddEventListener(MouseEvent.MouseClick, self.AddMMaterial, self);
	self.mmCtl:AddEventListener(EquipAlchemyMaterialEvent.Remove, self.RemoveMMaterial, self);
	self.mmCtl:AddEventListener(EquipAlchemyMaterialEvent.LongPress, self.ConsAddMMaterial, self);
	-- ctls

	self.effectContainer = self:FindGO("EffectContainer");

	local costTip = self:FindGO("CostTip");
	self.cost = self:FindComponent("Cost", UILabel, costTip);

	self.makeButton = self:FindGO("MakeBtn");
	self.makeButton_Collider = self.makeButton:GetComponent(BoxCollider);
	self.makeButton_Sprite = self.makeButton:GetComponent(UISprite);
	self.makeButton_Label = self:FindComponent("Label", UILabel, self.makeButton);
	self:AddClickEvent(self.makeButton, function (go)
		self:DoMake();
	end)

	self.chooseVMs = {};
	self.chooseMMs = {};

	self.normalStick = self:FindComponent("Stick", UIWidget);
end

function EquipAlchemyView:ClickEquipAlchemyItem(cell)
	local data = cell.itemData;
	if(data == nil)then
		return;
	end

	local sdata = {
		itemdata = data, 
		funcConfig = _EmptyTable,
		callback = callback,
	};

	self:ShowItemTip(sdata, self.normalStick, nil, {-170, 0});
end

function EquipAlchemyView:AddVMaterial(cell)
	local data = cell.data;
	if(data)then
		if(cell.leftNum and cell.leftNum < 1)then
			MsgManager.ShowMsgByID(252);
			return;
		end

		if(self.vmSlider.value >= 1)then
			MsgManager.ShowMsgByID(4100);
			return;
		end

		local sid = data.staticData.id;
		self:_HelpUpdateMaterial(sid, 1, self.chooseVMs, self.vmCells, self.vmSlider, self.vmSlider_Thumb, self.vmSlider_Thumb_Label, -1, self.selectData.ViceMaterial);
		self:UpdateActiveButton();
	end
end

function EquipAlchemyView:ConsAddVMaterial(param)
	local cell, open = param[1], param[2];
	if(open)then
		TimeTickManager.Me():CreateTick(0, 100, function ()
			self:AddVMaterial(cell);
		end, self, 11);
	else
		TimeTickManager.Me():ClearTick(self, 11)
	end
end

function EquipAlchemyView:RemoveVMaterial(cell)
	local data = cell.data;
	if(data)then
		local sid = data.staticData.id;
		self:_HelpUpdateMaterial(sid, -1, self.chooseVMs, self.vmCells, self.vmSlider, self.vmSlider_Thumb, self.vmSlider_Thumb_Label, -1, self.selectData.ViceMaterial);
		self:UpdateActiveButton();
	end
end

function EquipAlchemyView:AddMMaterial(cell)
	local data = cell.data;
	if(data)then
		if(cell.leftNum and cell.leftNum < 1)then
			MsgManager.ShowMsgByID(252);
			return;
		end

		if(self.mmSlider.value >= 1)then
			MsgManager.ShowMsgByID(4100);
			return;
		end

		local sid = data.staticData.id;
		self:_HelpUpdateMaterial(sid, 1, self.chooseMMs, self.mmCells, self.mmSlider, self.mmSlider_Thumb, self.mmSlider_Thumb_Label, 1, self.selectData.MainMaterial);
		self:UpdateActiveButton();
	end
end

function EquipAlchemyView:ConsAddMMaterial(param)
	local cell, open = param[1], param[2];
	if(open)then
		TimeTickManager.Me():CreateTick(0, 100, function ()
			self:AddMMaterial(cell);
		end, self, 12);
	else
		TimeTickManager.Me():ClearTick(self, 12)
	end
end

function EquipAlchemyView:RemoveMMaterial(cell)
	local data = cell.data;
	if(data)then
		local sid = data.staticData.id;
		self:_HelpUpdateMaterial(sid, -1, self.chooseMMs, self.mmCells, self.mmSlider, self.mmSlider_Thumb, self.mmSlider_Thumb_Label, 1, self.selectData.MainMaterial);
		self:UpdateActiveButton();
	end
end

function EquipAlchemyView:_HelpUpdateMaterial(sid, changeNum, chooseInfos, updateCells, slider, slider_thumb, slider_thumb_label, dir, weightMap)
	local num = chooseInfos[sid] or 0;
	num = num + changeNum;
	if(num <= 0)then
		chooseInfos[sid] = nil;
	else
		chooseInfos[sid] = num;
	end

	self:_HelpUpdateChooseInfo(chooseInfos, updateCells, slider, slider_thumb, slider_thumb_label, dir, weightMap);
end

function EquipAlchemyView:_HelpUpdateChooseInfo(chooseInfos, updateCells, slider, slider_thumb, slider_thumb_label, dir, weightMap)
	for i=1,#updateCells do
		updateCells[i]:SetChoosedInfo(chooseInfos);
	end

	local sliderValue = 0;
	local mweight = 2;
	for id, num in pairs(chooseInfos)do
		for i=1,#weightMap do
			if(weightMap[i][1] == id)then
				mweight = weightMap[i][2]/10;
				break;
			end
		end
		sliderValue = sliderValue + num * mweight;
	end
	sliderValue = math.clamp(sliderValue, 0, 100);
	slider.value = sliderValue/100;

	local x, y = LuaGameObject.GetLocalPosition(slider.transform)

	local degree = (180 * sliderValue / 100) * dir + 270
	local radAngle = math.rad(degree);
	tempV3:Set(x + math.cos(radAngle) * 135, y + math.sin(radAngle) * 135);
	slider_thumb.transform.localPosition = tempV3;

	slider_thumb_label.text = math.floor(sliderValue * 10)/10 .. "%"

	local dq = self:FindGO("Dq", slider.gameObject);
	dq.transform:LookAt(slider.transform);
end

function EquipAlchemyView:ClearVMs()
	TableUtility.TableClear(self.chooseVMs);
	self:_HelpUpdateChooseInfo(self.chooseVMs, self.vmCells, self.vmSlider, self.vmSlider_Thumb, self.vmSlider_Thumb_Label, -1);
end

function EquipAlchemyView:ClearMMs()
	TableUtility.TableClear(self.chooseMMs);
	self:_HelpUpdateChooseInfo(self.chooseMMs, self.mmCells, self.mmSlider, self.mmSlider_Thumb, self.mmSlider_Thumb_Label, 1);
end


function EquipAlchemyView:DoMake()
 	local npcInfo =	self:GetCurNpc();
 	if(npcInfo == nil)then
 		return;
 	end
 	if(self.selectData == nil)then
 		return;
 	end

	ServiceItemProxy.Instance:CallHighRefineMatComposeCmd(self.selectData.id, npcInfo.data.id, self.chooseMMs, self.chooseVMs) 
end

function EquipAlchemyView:UpdateSeleceCell(cell)
	local data = cell.data;
	if(data)then
		self.selectData = data;

		self.selectCell:SetData(data);

		local vmMalterials = {};
		for i=1,#data.ViceMaterial do
			local m = data.ViceMaterial[i];
			local item = ItemData.new("VMaterial", m[1]);
			table.insert(vmMalterials, item);
		end
		self.vmCtl:UpdateInfo(vmMalterials);
		self.vmCtl:ResetPosition();

		local mmMaterials = {};
		for i=1,#data.MainMaterial do
			local m = data.MainMaterial[i];
			local item = ItemData.new("MMaterial", m[1]);
			table.insert(mmMaterials, item)
		end
		self.mmCtl:UpdateInfo(mmMaterials);
		self.mmCtl:ResetPosition();

		self.makeCostLabel.text = data.Cost;

		for i=1,#self.mkCells do
			self.mkCells[i]:SetChooseId(data.id);
		end

		self:ClearVMs();
		self:ClearMMs();

		self:UpdateActiveButton();
	end
end

function EquipAlchemyView:UpdateActiveButton()
	self:ActiveMakeButton(self.vmSlider.value >= 1 and self.mmSlider.value >= 1);
end

function EquipAlchemyView:ActiveMakeButton(b)
	if(b)then
		self.makeButton_Sprite.color = ColorUtil.NGUIWhite;
		self.makeButton_Collider.enabled = true;
		self.makeButton_Label.effectColor = ColorUtil.ButtonLabelOrange;
	else
		self.makeButton_Sprite.color = ColorUtil.NGUIShaderGray;
		self.makeButton_Collider.enabled = false;
		self.makeButton_Label.effectColor = ColorUtil.NGUIGray;
	end
end

function EquipAlchemyView:UpdateMakeDatas(groupid)
	local hRefineDatas = BlackSmithProxy.Instance:GetHighRefineComposeData(groupid);
	self.mkCtl:UpdateInfo(hRefineDatas);
end

function EquipAlchemyView:UpdateCoins()
	self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB());
	self.lotterylabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery());
end

function EquipAlchemyView:MapEvent()
	self:AddListenEvt(MyselfEvent.MyDataChange,self.UpdateCoins);
	self:AddListenEvt(ServiceEvent.ItemHighRefineMatComposeCmd,self.HandleMakeSuccess);
	self:AddListenEvt(ItemEvent.ItemUpdate,self.RefreshSelectCell);
end

function EquipAlchemyView:HandleMakeSuccess(note)
	self:PlayUIEffect(EffectMap.UI.UltimateSuccess, self.effectContainer, true)

	self:RefreshSelectCell();
end

function EquipAlchemyView:RefreshSelectCell()
	self:ClearVMs();
	self:ClearMMs();

	self:UpdateSeleceCell(self.selectCell);
end

function EquipAlchemyView:GetCurNpc()
	if(self.npcguid)then
		return NSceneNpcProxy.Instance:Find(self.npcguid);
	end
	return nil
end

function EquipAlchemyView:OnEnter()
	EquipAlchemyView.super.OnEnter(self);

	local npcInfo = self.viewdata.viewdata.npcdata;
	self.npcguid = npcInfo and npcInfo.data.id;
	local npcinfo = self:GetCurNpc();
	if(npcinfo)then
		local rootTrans = npcinfo.assetRole.completeTransform;
		self:CameraFocusOnNpc(rootTrans);
	else
		self:CameraRotateToMe();
	end	

	self:UpdateCoins();

	local groupid = self.viewdata.viewdata.groupid;
	self:UpdateMakeDatas(groupid);
	self:UpdateSeleceCell(self.mkCells[1]);

	PictureManager.Instance:SetUI("alchemy_bg_bar", self.vmSlider_Foreground)
	PictureManager.Instance:SetUI("alchemy_bg_bar", self.mmSlider_Foreground)
end

function EquipAlchemyView:OnExit()
	self:CameraReset()

	self:ClearVMs();
	self:ClearMMs();
	
	EquipAlchemyView.super.OnExit(self);

	PictureManager.Instance:UnLoadUI("alchemy_bg_bar", self.vmSlider_Foreground)
	PictureManager.Instance:UnLoadUI("alchemy_bg_bar", self.mmSlider_Foreground)
end