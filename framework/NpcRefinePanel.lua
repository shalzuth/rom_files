NpcRefinePanel = class("NpcRefinePanel", ContainerView)

NpcRefinePanel.ViewType = UIViewType.NormalLayer

NpcRefinePanel.PfbPath = "part/EquipRefineBord";

autoImport("EquipRefineBord");
autoImport("EquipChooseBord");

NpcRefineAction = {
	Refine = "functional_action";
}

local blackSmith;

function NpcRefinePanel:Init()
	blackSmith = BlackSmithProxy.Instance;

	self:InitView();
	self:MapEvent();
end

function NpcRefinePanel:InitView()
	local chooseContaienr = self:FindGO("ChooseContainer");
	self.chooseBord = EquipChooseBord.new(chooseContaienr);
	self.chooseBord:Hide();

	self.bord = self:FindGO("RefineParent");

	-- coins
	local coins = self:FindChild("TopCoins");
	local usergold = self:FindGO("Gold", coins);
	self.goldLabel = self:FindComponent("Label", UILabel, usergold);
	local userRob = self:FindGO("Silver", coins);
	self.robLabel = self:FindComponent("Label", UILabel, userRob);
	-- coins


	-- bord control
	self:LoadPreferb(self.PfbPath, self.bord, true);
	self.bord_Control = EquipRefineBord.new(self.bord);
	self.bord_Control:SetEmptyStyle(2);
	self.bord_Control:ActiveTitle(true);

	self.bord_Control:AddEventListener(EquipRefineBord_Event.ClickAddEquipButton, self.ClickAddEquipButtonCall, self);
	self.bord_Control:AddEventListener(EquipRefineBord_Event.ClickTargetCell, self.ClickAddEquipButtonCall, self);
	self.bord_Control:AddEventListener(EquipRefineBord_Event.DoRefine, self.DoRefineCall, self);
	self.bord_Control:AddEventListener(EquipRefineBord_Event.DoRepair, self.DoRepairCall, self);
	-- bord control


	-- leftTip Bord
	self.leftTipBord = self:FindGO("LeftTipBord");
	self.leftTipBord_tip = self:FindComponent("RefineTip", UILabel, self.leftTipBord);
	self.leftTipBord_ShareButton = self:FindGO("ShareButton", self.leftTipBord);
	
	self.leftTipBord_ShareButton:SetActive(false);
	self:AddClickEvent(self.leftTipBord_ShareButton, function ()
		local nowData = self.bord_Control:GetNowItemData();
		FloatAwardView.ShowRefineShareView(nowData)

		self.leftTipBord_ShareButton:SetActive(false);
	end);
	-- leftTip Bord

	self.colliderMask = self:FindGO("ColliderMask");

	self.effectBg = self:FindComponent("EffectBg", ChangeRqByTex, self.refineBord);
end

function NpcRefinePanel:ClickAddEquipButtonCall(control)
	local datas = blackSmith:GetRefineEquips(self.refine_equiptype_map, self.isfashion);
	self.chooseBord:ResetDatas(datas, true);
	self.chooseBord:Show(nil, function (self, data)
		self:SetTargetItem(data);
		self.chooseBord:Hide();
	end, self);

	local nowData = self.bord_Control:GetNowItemData();
	if(nowData)then
		self.chooseBord:SetChoose(nowData);
	end
	
	self.chooseBord:SetBordTitle(ZhString.NpcRefinePanel_ChooseEquip);
end

function NpcRefinePanel:SetTargetItem(data)
	self.bord_Control:SetTargetItem(data);

	self:UpdateLeftTipBord(data);
end

function NpcRefinePanel:UpdateLeftTipBord(data)
	if(data and data.equipInfo)then
		self.leftTipBord:SetActive(true);

		if(data.equipInfo.damage)then
			self.leftTipBord_tip.text = ZhString.NpcRefinePanel_RepairTip;
		else
			local maxRefineLv = blackSmith:MaxRefineLevelByData(data.staticData)
			if(self.isfashion)then
				self.leftTipBord_tip.text = string.format(ZhString.NpcRefinePanel_FashionRefineTip);
			else
				self.leftTipBord_tip.text = string.format(ZhString.NpcRefinePanel_RefineTip, maxRefineLv);
			end
		end
	else
		self.leftTipBord:SetActive(false);
	end
end

function NpcRefinePanel:RemoveLeanTween()
	if(self.lt)then
		self.lt:cancel();
	end
	self.lt = nil;
end

function NpcRefinePanel:DoRefineCall(control)
	-- 延时2s做精炼结果表现
	self:RemoveLeanTween();

	self:ActiveLock(true);

	self.wait_refresh = true;

	local delayTime = GameConfig.EquipRefine.delay_time;
	self.lt = LeanTween.delayedCall(delayTime/1000, function()
		self.wait_refresh = false;

		self:RefineEnd();
	end);

	local ncpinfo = self:GetCurNpc();
	if(ncpinfo)then
		ncpinfo:Client_PlayAction(NpcRefineAction.Refine, nil, false);
	end

	self.chooseBord:Hide();
end

function NpcRefinePanel:DoRepairCall(control)
	-- 延时2s做精炼结果表现
	self:ActiveLock(true);

	self:RemoveLeanTween();

	self.wait_refresh = true;

	self.lt = LeanTween.delayedCall(2, function ()
		self.wait_refresh = false;

		self:RepairEnd();
	end);

	local ncpinfo = self:GetCurNpc();
	if(ncpinfo)then
		ncpinfo:Client_PlayAction(NpcRefineAction.Refine, nil, false);
	end

	self.chooseBord:Hide();
end

function NpcRefinePanel:UpdateCoins()
	self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function NpcRefinePanel:ActiveLock(b)
	self.colliderMask:SetActive(b);
end

function NpcRefinePanel:RefineEnd()
	local needShare = false;
	if(self.result == SceneItem_pb.EREFINERESULT_SUCCESS)then
		needShare = true;
		AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess);
		AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess_Npc)
		MsgManager.ShowMsgByIDTable(229)
	else
		AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinefail);
		AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinefail_Npc)
		-- MsgManager.ShowMsgByIDTable(228)
	end
	self:PlayUIEffect(EffectMap.UI.ForgingSuccess, 
						self.effectBg.gameObject,
						true,
						self.ForgingSuccessEffectHandle, 
						self);

	local socialShareConfig = AppBundleConfig.GetSocialShareInfo()
	if socialShareConfig == nil then
		needShare = false;
	end
	if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V9) then
		needShare = false;
	end

	self.result = nil;

	self:RemoveLeanTween();

	self.lt = LeanTween.delayedCall(self.gameObject, 1, function ()
		self:ActiveLock(false);

		self.bord_Control:Refresh();

		self:UpdateLeftTipBord(self.bord_Control:GetNowItemData());

		-- 装备损坏提示
		local nowData = self.bord_Control:GetNowItemData();
		if(nowData and nowData.equipInfo.damage)then
			MsgManager.ShowMsgByIDTable(230)
		end

		-- refine END	
		local maxRefineLv = blackSmith:MaxRefineLevelByData(nowData.staticData)
		if(needShare)then
			local refinelv = nowData.equipInfo.refinelv;
			if(refinelv == maxRefineLv)then
				FloatAwardView.ShowRefineShareView(nowData)
				self.leftTipBord_ShareButton:SetActive(false);
			elseif(refinelv >= 9)then
				self.leftTipBord_ShareButton:SetActive(true);
			else
				self.leftTipBord_ShareButton:SetActive(false);
			end
		else
			self.leftTipBord_ShareButton:SetActive(false);
		end

		self:RemoveLeanTween();
	end):setDestroyOnComplete(true);

end

function NpcRefinePanel.ForgingSuccessEffectHandle(effectHandle, owner)
	if(owner)then
		owner.effectBg:AddChild(effectHandle.gameObject);
	end
end

function NpcRefinePanel:RepairEnd()
	local nowData = self.bord_Control:GetNowItemData();
	MsgManager.ShowMsgByIDTable(221,{ nowData.staticData.NameZh})

	self:PlayUIEffect(EffectMap.UI.ForgingSuccess, 
							self.effectBg.gameObject, 
							true, 
							self.ForgingSuccessEffectHandle, 
							self)

	local assetRole = Game.Myself.assetRole;
	assetRole:PlayEffectOneShotOn(EffectMap.Maps.ForgingSuccess, RoleDefines_EP.Top);

	self:RemoveLeanTween();

	self.lt = LeanTween.delayedCall(self.gameObject, 1, function ()
		self:ActiveLock(false);
		self.bord_Control:Refresh();

		self:UpdateLeftTipBord(self.bord_Control:GetNowItemData());

		self:RemoveLeanTween();
	end):setDestroyOnComplete(true);
	
	AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess)
end

function NpcRefinePanel:MapEvent()
	self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins)
	self:AddListenEvt(ServiceEvent.ItemEquipRefine, self.RecvUpdateRefineInfo)
	self:AddListenEvt(ServiceEvent.ItemEquipRepair,self.RecvUpdateRefineInfo)
	
	self:AddListenEvt(ItemEvent.ItemUpdate,self.RecvUpdateRefineInfo)
	self:AddListenEvt(ItemEvent.EquipUpdate,self.RecvUpdateRefineInfo)

	self:AddListenEvt(ServiceEvent.ItemEquipRefine, self.RecvRefineResult)
end

function NpcRefinePanel:RecvUpdateRefineInfo(note)
	if(self.wait_refresh == true)then
		return;
	end

	self.bord_Control:Refresh();
end

function NpcRefinePanel:RecvRefineResult(note)
	if(self.bord_Control == nil)then
		return;
	end

	local nowItem = self.bord_Control:GetNowItemData();
	if(nowItem == nil)then
		return;
	end

	self.result = note.body.eresult;
end

function NpcRefinePanel:GetCurNpc()
	if(self.npcguid)then
		return NSceneNpcProxy.Instance:Find(self.npcguid);
	end
	return nil
end

function NpcRefinePanel:InitValidRefineEquipType()
	self.refine_equiptype_map = {};

	self.isfashion = self.viewdata.viewdata and self.viewdata.viewdata.isfashion;

	if(self.isfashion)then
		local buildingData = GuildBuildingProxy.Instance:GetBuildingDataByType(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING); 
		if(buildingData)then
			local unlockParam = buildingData.staticData and buildingData.staticData.UnlockParam;

			local equipConfig = unlockParam.equip;
			if(equipConfig and equipConfig.refine_type)then
				for i=1,#equipConfig.refine_type do
					self.refine_equiptype_map[ equipConfig.refine_type[i] ] = 1;
				end
				self.bord_Control:SetMaxRefineLv(equipConfig.refinemaxlv);
			end
		end

		self.leftTipBord_tip.text = string.format(ZhString.NpcRefinePanel_FashionRefineTip);
	else
		for k, v in pairs(GameConfig.EquipType)do
			if(k ~= 8 and k ~= 9 and k ~= 10 and k ~= 11 and k ~= 13)then
				self.refine_equiptype_map[ k ] = 1;
			end
		end
	end
end

function NpcRefinePanel:OnEnter()
	NpcRefinePanel.super.OnEnter(self);

	self:InitValidRefineEquipType();

	local npcInfo = self.viewdata.viewdata.npcdata;
	self.npcguid = npcInfo and npcInfo.data.id;
	self.bord_Control:SetNpcguid(self.npcguid);

	if(npcInfo)then
		local rootTrans = npcInfo.assetRole.completeTransform;
		if(self.isfashion)then
			self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation);
		else
			self:CameraFocusOnNpc(rootTrans);
		end
	else
		self:CameraRotateToMe();
	end	

	self:UpdateCoins();

	self:SetTargetItem(nil);
end

function NpcRefinePanel:OnExit()
	NpcRefinePanel.super.OnExit(self);

	self.wait_refresh = false;
	
	self:RemoveLeanTween();

	self:CameraReset()
end