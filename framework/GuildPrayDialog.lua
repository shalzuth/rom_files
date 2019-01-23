GuildPrayDialog = class("GuildPrayDialog", ContainerView)

autoImport("DialogCell");
autoImport("GPrayTypeCell");

GuildPrayDialog.ViewType = UIViewType.DialogLayer;

GuildCertificateId = GameConfig.Guild.praydeduction[1];

function GuildPrayDialog:Init()
	local npc = self.viewdata.viewdata.npcdata
	self.npcguid = npc.data.id;
	self:InitUI();
end

function GuildPrayDialog:GetCurNpc()
	if(self.npcguid)then
		return NSceneNpcProxy.Instance:Find(self.npcguid);
	end
end

function GuildPrayDialog:InitUI()
	self.mask = self:FindGO("Mask");
	self.title = self:FindComponent("Title",UILabel);
	self.title.text = ZhString.GuildPrayDialog_Title
	self.menuBg = self:FindComponent("MenuGg", UISprite);
	self.dialogContent = self:FindComponent("DialogContent", UILabel);
	self.sliver = self:FindComponent("Label", UILabel, self:FindGO("Silver"));
	self.contribute = self:FindComponent("Label", UILabel, self:FindGO("Contribute"));
	self.certificate = self:FindComponent("Label", UILabel, self:FindGO("Certificate"));

	local prayButton = self:FindGO("PrayButton");
	self:AddClickEvent(prayButton, function (go)
		local chooseData = self.chooseData;
		if(chooseData)then
			local chooseType = chooseData.staticData.id;
			local costMoney = chooseData.cost.Money;
			local costContri = chooseData.cost.Contribution;
			local level = chooseData.level or 1;
			local uplv = GuildProxy.Instance.myGuildData.staticData and GuildProxy.Instance.myGuildData.staticData.BeliefUL;
			if(uplv)then
				if(level >= uplv)then
					MsgManager.ShowMsgByIDTable(2625);
					return;
				end
			end
			
			if(self.nowSliver < costMoney)then
				MsgManager.ShowMsgByIDTable(1);
				return;
			end
			if(self.nowContribute < costContri)then
				MsgManager.ShowMsgByIDTable(2820);
				return;
			end
			-- temp handle
			self:ActiveLock(true);

			LeanTween.cancel(self.gameObject);
			LeanTween.delayedCall(self.gameObject, 1.5, function ()
				self:PlayPrayResultAnim();
				self:ActiveLock(false);
				self:UpdateCoins();
				self:UpdatePrayGrid();
				self:UpdateDialogContent();
			end)
			
			local npcInfo = self:GetCurNpc();
			if(npcInfo)then
				ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(npcInfo.data.id, chooseType);
			end
		end
	end);

	self.prayDialog = self:FindGO("PrayDialog");
	self.prayDialog = DialogCell.new(self.prayDialog);

	local prayGrid = self:FindComponent("PrayGrid", UIGrid);
	self.prayCtl = UIGridListCtrl.new(prayGrid, GPrayTypeCell, "GPrayTypeCell");
	self.prayCtl:AddEventListener(MouseEvent.MouseClick, self.ChoosePray, self)

	self:UpdateCoins();
	self:InitPrayGrid();
	self:ChoosePray(self.prayCtl:GetCells()[1]);

	self:ActiveLock(false);
end

function GuildPrayDialog:PlayPrayResultAnim()
	if(self.lastChoose)then
		self.lastChoose:PlayPrayEffect();
	end
end

function GuildPrayDialog:ActiveLock(b)
	self.mask:SetActive(b);
	self.lockState = b;
end

function GuildPrayDialog:ChoosePray(cellCtl)
	if(self.lastChoose)then
		self.lastChoose:SetChoose(false);
	end
	cellCtl:SetChoose(true);
	self.chooseData = cellCtl.data;
	self:UpdateDialogContent();
	if(not self.lockState)then
		self.lastChoose = cellCtl;
	end
end

function GuildPrayDialog:UpdateDialogContent()
	if(self.lockState)then
		return;
	end
	local npcInfo = self:GetCurNpc();
	if(npcInfo == nil)then
		return;
	end

	local prayDlgData = { Speaker = npcInfo.data.staticData.id, NoSpeak = true};

	local level, sData = self.chooseData.level, self.chooseData.staticData;
	local attriID, nowValue = next(GuildFun.calcGuildPrayAttr(sData.id, level));
	local _, nextValue =  next(GuildFun.calcGuildPrayAttr(sData.id, level + 1));
	if(nextValue)then
		local attrikey = Table_RoleData[attriID].VarName;
		local attriPro = UserProxy.Instance:GetPropVO(attrikey);
		local isAttriPct = attriPro.isPercent;

		local costMoney = self.chooseData.cost.Money;
		costMoney = math.floor(costMoney);
		
		local costContri = self.chooseData.cost.Contribution;
		local certificateName = Table_Item[GuildCertificateId].NameZh;
		local addvalue = nextValue - nowValue;
		if(isAttriPct)then
			addvalue = string.format("%s%%", addvalue * 100);
		end
		prayDlgData.Text = string.format(ZhString.GuildPrayDialog_PrayTip, 
			sData.Name, sData.Attr, addvalue, costMoney, certificateName, costContri);
	else
		prayDlgData.Text = string.format(ZhString.GuildPrayDialog_Pray_FullTip, sData.Name);
	end
	
	self.prayDialog:SetData(prayDlgData);
end

function GuildPrayDialog:InitPrayGrid()
	self.faithDatas = {};
	local myfaithData = Game.Myself.data.guildPray;
	for _,data in pairs(myfaithData)do
		table.insert(self.faithDatas, data);
	end
	table.sort(self.faithDatas, function (a,b)
		return a.staticData.id<b.staticData.id;
	end);
	self:UpdatePrayGrid();
end

function GuildPrayDialog:UpdatePrayGrid()
	if(self.lockState)then
		return;
	end
	self.prayCtl:ResetDatas(self.faithDatas);
end

function GuildPrayDialog:UpdateCoins()
	local rob = MyselfProxy.Instance:GetROB();
	self.nowSliver = rob;
	self.sliver.text = rob;

	local myMemberData = GuildProxy.Instance:GetMyGuildMemberData();
	if(myMemberData)then
		self.contribute.text = tostring(myMemberData.contribution);
		self.nowContribute = myMemberData.contribution;
	end

	local certificateNum = BagProxy.Instance:GetItemNumByStaticID(GuildCertificateId) or 0;
	self.certificate.text = tostring(certificateNum);
end

function GuildPrayDialog:MapEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleGuildMemberUpdate);
	self:AddListenEvt(ServiceEvent.GuildCmdGuildPrayNtfGuildCmd, self.HandleGuildMemberUpdate);

	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCoins);
	self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins);

	self:AddListenEvt(SceneGlobalEvent.Map2DChanged, self.HandleUpdateMap2d)
end

function GuildPrayDialog:HandleUpdateMap2d(note)
	self:CloseSelf();
end

function GuildPrayDialog:HandleGuildMemberUpdate(note)
	self:UpdatePrayGrid();
	self:UpdateCoins();
	self:UpdateDialogContent();
end

function GuildPrayDialog:OnEnter()
	GuildPrayDialog.super.OnEnter(self);
	local viewPort = CameraConfig.Guild_Pray_ViewPort;
	local rotation = CameraConfig.Guild_Pray_Rotation;

	local npcInfo = self:GetCurNpc();
	if(npcInfo == nil)then
		return;
	end
	local npcRootTrans = npcInfo.assetRole.completeTransform;

	self:CameraFocusAndRotateTo(npcRootTrans, viewPort, rotation)
end

function GuildPrayDialog:OnExit()
	self:CameraReset();
	GuildPrayDialog.super.OnExit(self);
end




