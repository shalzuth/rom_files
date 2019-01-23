GvGPvPPrayDialog = class("GvGPvPPrayDialog", ContainerView)

autoImport("DialogCell");
autoImport("GvGPvpPrayTypeCell");
autoImport("PrayToggleCell")
autoImport("WrapCellHelper")

GvGPvPPrayDialog.ViewType = UIViewType.DialogLayer;

GuildCertificateId = GameConfig.Guild.praydeduction[1];

-- pray page Type
GvGPvPPrayDialog.PageType = GameConfig.GvGPvP_PrayType[1].RaidMap

local toggleCsv = GameConfig.GvGPvP_PrayType

function GvGPvPPrayDialog:Init()
	local npc = self.viewdata.viewdata.npcdata
	self.npcguid = npc.data.id;
	self:InitUI();
	self:InitCoins();
	self:AddMapEvent();
end

function GvGPvPPrayDialog:GetCurNpc()
	if(self.npcguid)then
		return NSceneNpcProxy.Instance:Find(self.npcguid);
	end
end

function GvGPvPPrayDialog:InitUI()
	self.mask = self:FindGO("Mask");

	self.pageToggleRoot=self:FindGO("toggleRoot")

	local ListTable = self.pageToggleRoot:GetComponent(UIGrid)
	self.gridListCtl = UIGridListCtrl.new(ListTable,PrayToggleCell,"PrayToggleCell")
	self.gridListCtl:AddEventListener(MouseEvent.MouseClick, self._clickPageToggle, self);


	local togList = {}
	for i=1,#toggleCsv do
		table.insert(togList,toggleCsv[i])
	end
	self.gridListCtl:ResetDatas(togList)
	self:_refreshChoose()

	self.choosePageID=GuildCmd_pb.EPRAYTYPE_GVG_ATK;

	self.itemPrayRoot = self:FindGO("cutWrap")
	self.menuBg = self:FindComponent("MenuGg", UISprite);
	self.dialogContent = self:FindComponent("DialogContent", UILabel);

	self.atkLab = self:FindComponent("Label", UILabel, self:FindGO("atkIcon"));
	self.atkIcon = self:FindComponent("symbol",UISprite,self:FindGO("atkIcon"));
	self.defLab = self:FindComponent("Label", UILabel, self:FindGO("defIcon"));
	self.defIcon = self:FindComponent("symbol", UISprite, self:FindGO("defIcon"));
	self.attrCellLab = self:FindComponent("Label", UILabel, self:FindGO("attrCellIcon"));
	self.attrCellIcon = self:FindComponent("symbol", UISprite, self:FindGO("attrCellIcon"));
	
	local prayButton = self:FindGO("PrayButton");
	self:AddClickEvent(prayButton, function (go)
		local chooseData = self.chooseData;
		if(chooseData)then
			local queryID = chooseData.id
			if(not chooseData.nextPray or 0==chooseData.nextPray.lv)then
				MsgManager.ShowMsgByIDTable(2720);
				return
			end
			local ownCost = BagProxy.Instance:GetItemNumByStaticID(chooseData.nextPray.itemCost.staticData.id)
			if(ownCost<chooseData.nextPray.itemCost.num)then
				MsgManager.ShowMsgByIDTable(3554,chooseData.nextPray.itemCost.staticData.NameZh);
				return
			end
			
			-- temp handle
			self:ActiveLock(true);

			LeanTween.cancel(self.gameObject);
			LeanTween.delayedCall(self.gameObject, 1.5, function ()
				self:PlayPrayResultAnim();
				self:ActiveLock(false);
				
				self:UpdatePrayGrid();
				self:UpdateDialogContent();
			end)
			
			local npcInfo = self:GetCurNpc();
			if(npcInfo)then
				-- helplog("公会祈祷send Msg successfully.,npcID: ",npcInfo.data.id," queryID: ",queryID)
				ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(npcInfo.data.id, queryID);
			end
		end
	end);

	self.prayDialog = self:FindGO("PrayDialog");
	self.prayDialog = DialogCell.new(self.prayDialog);

	self:InitPrayGrid();

	self:ActiveLock(false);
end

function GvGPvPPrayDialog:PlayPrayResultAnim()
	if(self.lastChoose)then
		self.lastChoose:PlayPrayEffect();
	end
end

function GvGPvPPrayDialog:ActiveLock(b)
	self.mask:SetActive(b);
	self.lockState = b;
end

function GvGPvPPrayDialog:ChoosePray(cellctl)
	local data = cellctl and cellctl.data;
	if(data)then
		self.chooseData = cellctl.data;
		if(self.chooseId~=data.id )then
			self.chooseId = data.id;
			self:UpdateDialogContent();
			if(not self.lockState)then
				self.lastChoose = cellctl;
			end
			for _,cell in pairs(self.prayCells) do
				cell:SetChoose(self.chooseId, self.chooseMap);
			end
		end
	end
end

function GvGPvPPrayDialog:UpdateDialogContent()
	if(self.lockState)then return end 
	local npcInfo = self:GetCurNpc();
	if(not npcInfo)then
		return 
	end
	local prayData = self.prayData[self.choosePageID]
	for i=1,#prayData do
		if(prayData[i].id==self.chooseData.id)then
			self.chooseData=prayData[i]
		end
	end

	local prayDlgData = { Speaker = npcInfo.data.staticData.id, NoSpeak = true};
	local args = self.chooseData:GetAddAttrValue()
	if(args[1])then
		prayDlgData.Text = string.format(ZhString.GvGPvPPray_Dialog,args[2],args[4],args[5],args[6]);
	else
		prayDlgData.Text = string.format(ZhString.GvGPvPPray_DialogLimit, args[2]);
	end
	self.prayDialog:SetData(prayDlgData);
end

function GvGPvPPrayDialog:InitPrayGrid()
	self.prayData=Game.Myself.data.gvgPvpPray;
	self:ShowUIByPage(self.choosePageID);
	self:_refreshChoose()
	self:UpdatePrayGrid();
end

-- UI 刷新逻辑
function GvGPvPPrayDialog:_refreshChoose()
	if(self.gridListCtl)then
		local childCells = self.gridListCtl:GetCells();
		for i=1,#childCells do
			local childCell = childCells[i];
			childCell:ShowChooseImg(self.choosePageID)
		end
	end
end

function GvGPvPPrayDialog:DisplayPrayByType(data)
	if(self.itemWrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.itemPrayRoot, 
			pfbNum = 5, 
			cellName = "GvGPvpPrayTypeCell", 
			control = GvGPvpPrayTypeCell,
			dir = 1,
		}
		self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
		self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick,self.ChoosePray,self)
	end
	self.itemWrapHelper:UpdateInfo(data)
	self.itemWrapHelper:ResetPosition()
	self.prayCells=self.itemWrapHelper:GetCellCtls()
	self:ChoosePray(self.prayCells[1]);
end

function GvGPvPPrayDialog:_clickPageToggle(cellctl)
	if(nil~=cellctl) then
		if(cellctl.data.type ~=self.choosePageID) then
			self.choosePageID = cellctl.data.type;
			self:ShowUIByPage(self.choosePageID);
			self:_refreshChoose()
		end
	end
end

function GvGPvPPrayDialog:ShowUIByPage(type)
	local pageData = self.prayData and self.prayData[type]
	if(pageData)then
		self:DisplayPrayByType(pageData)
	end
end

function GvGPvPPrayDialog:UpdatePrayGrid()
	if(self.lockState)then
		return;
	end
	if(self.itemWrapHelper)then
		self.prayData=Game.Myself.data.gvgPvpPray;
		local data = self.prayData[self.choosePageID]
		self.itemWrapHelper:UpdateInfo(data)
	end
end

function GvGPvPPrayDialog:InitCoins()
	if(not GameConfig.GvGPvP_PrayType or #GameConfig.GvGPvP_PrayType~=3)then return end 

	self.costItem={}
	self.costItem.atk = GameConfig.GvGPvP_PrayType[1][2]
	self.costItem.def = GameConfig.GvGPvP_PrayType[2][2]
	self.costItem.cell = GameConfig.GvGPvP_PrayType[3][2]
	
	IconManager:SetItemIcon(Table_Item[self.costItem.atk].Icon,self.atkIcon)
	IconManager:SetItemIcon(Table_Item[self.costItem.def].Icon,self.defIcon)
	IconManager:SetItemIcon(Table_Item[self.costItem.cell].Icon,self.attrCellIcon)
	self:UpdateCoins();
end

function GvGPvPPrayDialog:UpdateCoins()
	self.atkLab.text=BagProxy.Instance:GetItemNumByStaticID(self.costItem.atk)
	self.defLab.text=BagProxy.Instance:GetItemNumByStaticID(self.costItem.def)
	self.attrCellLab.text=BagProxy.Instance:GetItemNumByStaticID(self.costItem.cell)
end

function GvGPvPPrayDialog:AddMapEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdGuildPrayNtfGuildCmd, self.HandlePrayUpdate);
end

function GvGPvPPrayDialog:HandlePrayUpdate(note)
	self:UpdatePrayGrid();
	self:UpdateCoins();
	self:UpdateDialogContent();
end

function GvGPvPPrayDialog:OnEnter()
	GvGPvPPrayDialog.super.OnEnter(self);
	local viewPort = CameraConfig.Guild_Pray_ViewPort;
	local rotation = CameraConfig.Guild_Pray_Rotation;
	local npcInfo = self:GetCurNpc();
	if(not npcInfo or not npcInfo.assetRole or not npcInfo.assetRole.completeTransform)then
		return;
	end
	local npcRootTrans = npcInfo.assetRole.completeTransform;
	self:CameraFocusAndRotateTo(npcRootTrans, viewPort, rotation)
end

function GvGPvPPrayDialog:OnExit()
	self.prayCells=nil
	self:CameraReset();
	GvGPvPPrayDialog.super.OnExit(self);
end




