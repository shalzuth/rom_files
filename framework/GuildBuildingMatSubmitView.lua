autoImport("GuildBuildingMatSubmitCell")
GuildBuildingMatSubmitView = class("GuildBuildingMatSubmitView",ContainerView)
GuildBuildingMatSubmitView.ViewType = UIViewType.NormalLayer
local maskReason = PUIVisibleReason.CatLitterBox
local PACKAGE_MATERIAL = GameConfig.PackageMaterialCheck.guildBuilding or {1,11}
function GuildBuildingMatSubmitView:Init()
	self:FindObjs()
	self:AddEvt()
	self:MapListenEvt()
	self:InitUIView()
	self.curType=GuildBuildingProxy.Instance:GetBuildingType()
	self.limitCount=GameConfig.GuildBuilding and GameConfig.GuildBuilding.max_submit_count or 10;
end

function GuildBuildingMatSubmitView:FindObjs()
	self.rankBtn = self:FindGO("rankBtn")
	self.nameLv = self:FindComponent("NameLv",UILabel)
	self.ScrollView = self:FindComponent("ScrollView",UIScrollView)
	self.buildIcon = self:FindComponent("buildIcon",UISprite)
	self.container = self:FindGO("Container")
	self.statusLab = self:FindComponent("status",UILabel)
	self.processSlider = self:FindComponent("processSlider",UISlider)
	self.processLab = self:FindComponent("processLab",UILabel)
	self.submitCount = self:FindComponent("submitCount",UILabel)
	local go = self:_loadCellPfb("GuildBuildingMatSubmitCell")
	self.MatSubmitCell = GuildBuildingMatSubmitCell.new(go)
	self.MatSubmitCell:SetChoosed(0.9,true)
	self.MatSubmitCell.gameObject:AddComponent(CloseWhenClickOtherPlace)
	self.MatSubmitCell:AddEventListener(GuildBuildingEvent.SubmitMaterial, self.OnSubmit, self)
	local closecomp = self.MatSubmitCell.gameObject:GetComponent(CloseWhenClickOtherPlace);
	closecomp.callBack = function (go)
		self:_showClickMat(false)
	end
	self.MatSubmitCell.gameObject:SetActive(false)

	self.submitInc_Bord = self:FindGO("SubmitInc_Bord");
	self.submitInc_time = self:FindComponent("Label", UILabel, self.submitInc_Bord);
	self.submitIncValue = self:FindComponent("SubmitIncValue", UILabel, self.submitInc_Bord);
	self.rewardIncValue = self:FindComponent("RewardIncValue", UILabel, self.submitInc_Bord);
end

function GuildBuildingMatSubmitView:Update_SubmitIncBord()
	local d = self.data;
	if(d == nil or d.staticData == nil)then
		self.submitInc_Bord:SetActive(false);
		return;
	end
	local aedata = ActivityEventProxy.Instance:GetGuildBuildingEventData();
	if(aedata == nil or not aedata:IsInActivity())then
		self.submitInc_Bord:SetActive(false);
		return;
	end
	if(not aedata:CheckEffectByGuildBuildingLevel(d.staticData.Level) or 
		not aedata:CheckEffectByGuildBuildingType(d.staticData.Type))then
		self.submitInc_Bord:SetActive(false);
		return;
	end
	self.submitInc_Bord:SetActive(true);
	local submitInc = aedata:GetSubmitInc() or 0;
	local rewardInc = aedata:GetRewardInc() or 0;
	self.submitIncValue.text = string.format(ZhString.GuildBuilding_LevelUpPreview_SubmitInc, submitInc);
	self.rewardIncValue.text = string.format(ZhString.GuildBuilding_LevelUpPreview_RewardInc, rewardInc);

	self.deltaSec = ServerTime.ServerDeltaSecondTime(aedata.endTime * 1000);
	if(self.deltaSec > 0)then
		if(self.timeTick == nil)then
			self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._update_SubmitIncBord_Tick, self, 1);
		end
	end
end

function GuildBuildingMatSubmitView:_update_SubmitIncBord_Tick(interval)
	if(self.deltaSec > 0)then
		self.deltaSec = self.deltaSec - interval/1000;

		local day,hour,min,sec = ClientTimeUtil.FormatTimeBySec( self.deltaSec )
		self.submitInc_time.text = string.format(ZhString.GuildBuilding_LevelUpPreview_CountDownTime, day, hour, min);
	else
		self:_remove_SubmitIncBord_Tick();
	end
end

function GuildBuildingMatSubmitView:_remove_SubmitIncBord_Tick()
	self.submitInc_Bord:SetActive(false);
	TimeTickManager.Me():ClearTick(self, 1);
	self.timeTick = nil;
end

function GuildBuildingMatSubmitView:AddEvt()
	self:AddClickEvent(self.rankBtn, function (go)
		-- helplog("CallQueryBuildingRankGuildCmd curType: ",self.curType)
		local rankArry = GuildBuildingProxy.Instance:GetRankArray()
		if(rankArry and #rankArry>0)then
			return
		end
		ServiceGuildCmdProxy.Instance:CallQueryBuildingRankGuildCmd(self.curType)
	end)
end

function GuildBuildingMatSubmitView:MapListenEvt()
	self:AddListenEvt(ServiceEvent.GuildCmdBuildingNtfGuildCmd, self.HandleBuildingNtf)
	self:AddListenEvt(ServiceEvent.GuildCmdBuildingSubmitCountGuildCmd, self.HandleSubmitCount)
	self:AddListenEvt(ServiceEvent.GuildCmdQueryBuildingRankGuildCmd,self.HandleRank)
	self:AddListenEvt(ItemEvent.ItemUpdate,self.UpdataUI)
end

function GuildBuildingMatSubmitView:HandleRank()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.GuildBuildingRankPopUp})
end

-- 
function GuildBuildingMatSubmitView:HandleBuildingNtf()
	self:UpdataUI();
end

--recv submitCount
function GuildBuildingMatSubmitView:HandleSubmitCount(note)
	if(note and note.body)then
		local data = note.body
		GuildBuildingProxy.Instance:SetSubmitTimes(data.count)
		self.submitCount.text=string.format(ZhString.GuildBuilding_Submit_Count, data.count, self.limitCount);
		self:InitUIView()
	end
end

function GuildBuildingMatSubmitView:InitUIView()
	if(self.wrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.container, 
			pfbNum = 5, 
			cellName = "GuildBuildingMatSubmitCell", 
			control = GuildBuildingMatSubmitCell, 
			dir = 2,
		}
		self.wrapHelper = WrapCellHelper.new(wrapConfig)	
		self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.ReadyChoose, self)
	end
	self:UpdataUI()
end

function GuildBuildingMatSubmitView:ReadyChoose( cellCtl )
	local rankArry = GuildBuildingProxy.Instance:GetRankArray()
	if(rankArry and #rankArry>0)then
		return
	end
	local data = cellCtl and cellCtl.data
	if(data)then
		self:_showClickMat(false)
		self.clickCell=cellCtl.gameObject
		self:_showClickMat(true)
		self.MatSubmitCell:SetData(data,true)
	end
end

function GuildBuildingMatSubmitView:_showClickMat(flag)
	if(self.clickCell)then
		self.clickCell:SetActive(not flag)
	end
	if(self.MatSubmitCell)then
		self.MatSubmitCell.gameObject:SetActive(flag)
	end
end

function GuildBuildingMatSubmitView:OnSubmit(cellCtl)
	local curSubmit = GuildBuildingProxy.Instance.curSubmitTime
	if(curSubmit>=self.limitCount)then
		MsgManager.ShowMsgByID(3702)
		return
	end
	if(cellCtl and cellCtl.data)then
		local data = cellCtl.data
		local unitCount = data.unitCount
		local materialID = data.materials.id
		local needNum = CommonFun.calcGuildBuildingMaterialItemCount(unitCount,curSubmit+1)
		local ownCount = BagProxy.Instance:GetItemNumByStaticID(data.materials.id,PACKAGE_MATERIAL )
		if(ownCount>=needNum)then
			local queryId=data.csvID
			-- helplog("CallSubmitMaterialGuildCmd self.curType: ",self.curType,"queryId: ",queryId)
			ServiceGuildCmdProxy.Instance:CallSubmitMaterialGuildCmd(self.curType,queryId)
		else
			local lackItem= {id = materialID, count = needNum-ownCount};
			QuickBuyProxy.Instance:TryOpenView({lackItem});
			-- MsgManager.ShowMsgByID(3703)
		end
	end
end

function GuildBuildingMatSubmitView:UpdataUI()
	self.data = GuildBuildingProxy.Instance:GetBuildingDataByType(self.curType)
	if(self.data)then
		if(not self.data.isbuilding)then
			MsgManager.ShowMsgByID(3704)
			self:CloseSelf()
		end
		if(self.data.uiMatData)then
			self.wrapHelper:UpdateInfo(self.data.uiMatData)
			self.wrapHelper:ResetPosition()
			self.ScrollView:ResetPosition();
		end
		self.nameLv.text= self.data.staticData.Level==0 and self.data.staticData.Name or string.format(ZhString.GuildBuilding_Title,self.data.staticData.Name,self.data.staticData.Level)
		IconManager:SetUIIcon(self.data.staticData.Icon,self.buildIcon)
		self.statusLab.text=self.data.staticData.Level>=1 and ZhString.GuildBuilding_isUpLevel or ZhString.GuildBuilding_isBuilding
		self.processSlider.value=self.data.PartsRate
		local value = string.format("%0.1f", self.data.PartsRate*100)
		self.processLab.text=string.format(ZhString.GuildBuilding_Process,value)
		self:_showClickMat(false)

		self:Update_SubmitIncBord();
	end
end

function GuildBuildingMatSubmitView:OnEnter()
	local _FunctionPlayerUI = FunctionPlayerUI.Me()
	local roles = NSceneNpcProxy.Instance:GetAll()
	for k,v in pairs(roles) do
		_FunctionPlayerUI:MaskTopFrame(v, maskReason, false)
		_FunctionPlayerUI:MaskNameHonorFactionType(v, maskReason, false)
	end
	GuildBuildingMatSubmitView.super.OnEnter(self);
	ServiceGuildCmdProxy.Instance:CallBuildingSubmitCountGuildCmd(self.curType)
	local npcdata = GuildBuildingProxy.Instance:GetNPC()
	local npcTrans = npcdata.assetRole.completeTransform;
	local viewPort,rotation = self:_getCameraConfig(npcdata)
	if(npcTrans and viewPort and rotation)then
		if(viewPort and rotation)then
			self:CameraFocusAndRotateTo(npcTrans, viewPort, rotation);
		end
	end
end

function GuildBuildingMatSubmitView:_getCameraConfig(npcInfo)
	local viewPort,rotation 
	local npcData = npcInfo.data.staticData;
	local npcfunction = npcData and npcData.NpcFunction;
	if(#npcfunction==1)then
		local single = npcfunction[1];
		local param = single.param
		local funcCfg = Table_NpcFunction[single.type];
		if(funcCfg)then
			if(funcCfg.NameEn=="BuildingSubmitMaterial")then
				if(param==1)then
					viewPort=CameraConfig.Worker_VendMachine_ViewPort
					rotation=CameraConfig.Worker_VendMachine_Rotation
				elseif(param==2)then
					viewPort=CameraConfig.Worker_Bar_ViewPort
					rotation=CameraConfig.Worker_Bar_Rotation
				elseif(param==3)then
					viewPort=CameraConfig.Worker_CatLitterBox_ViewPort
					rotation=CameraConfig.Worker_CatLitterBox_Rotation
				elseif(param==4)then
					viewPort=CameraConfig.Worker_Sewing_ViewPort
					rotation=CameraConfig.Worker_Sewing_Rotation
				elseif(param==5)then
					viewPort=CameraConfig.Worker_HighRefine_ViewPort
					rotation=CameraConfig.Worker_HighRefine_Rotation
				elseif(param==6)then
					viewPort=CameraConfig.Worker_HeadwearArtifact_ViewPort
					rotation=CameraConfig.Worker_HeadwearArtifact_Rotation
				end
			end
		end
	elseif(#npcfunction>1)then
		for i=1,#npcfunction do
			local single = npcfunction[i];
			local funcCfg = Table_NpcFunction[single.type];
			if(funcCfg)then
				if(funcCfg.NameEn == "GuildStoreAuto")then
					viewPort=CameraConfig.Vending_Machine_LvUp_ViewPort
					rotation=CameraConfig.Vending_Machine_LvUp_Rotation
					break;
				elseif(funcCfg.NameEn=="GuildStoreCat")then
					viewPort=CameraConfig.Bar_LvUp_ViewPort
					rotation=CameraConfig.Bar_LvUp_Rotation
					break;
				elseif(funcCfg.NameEn=="CatLitterBox")then
					viewPort=CameraConfig.CatLitterBox_LvUp_ViewPort
					rotation=CameraConfig.CatLitterBox_LvUp_Rotation
					break;
				elseif(funcCfg.NameEn=="SewingStrengthen" or funcCfg.NameEn=="SewingRefine")then
					viewPort=CameraConfig.Sewing_LvUp_ViewPort
					rotation=CameraConfig.Sewing_LvUp_Rotation
					break;
				elseif(funcCfg.NameEn=="HighRefine")then
					viewPort=CameraConfig.HighRefine_ViewPort
					rotation=CameraConfig.HighRefine_Rotation
					break;
				elseif(funcCfg.NameEn == "ArtifactMake")then
					viewPort=CameraConfig.HearwearArtifact_ViewPort
					rotation=CameraConfig.HearwearArtifact_Rotation
					break;
				end
			end
		end
	end
	return viewPort,rotation
end

function GuildBuildingMatSubmitView:OnExit()
	local _FunctionPlayerUI = FunctionPlayerUI.Me()
	local roles = NSceneNpcProxy.Instance:GetAll()
	for k,v in pairs(roles) do
		_FunctionPlayerUI:UnMaskTopFrame(v, maskReason, false)
		_FunctionPlayerUI:UnMaskNameHonorFactionType(v, maskReason, false)
	end
	PictureManager.Instance:UnLoadUI()
	GuildBuildingMatSubmitView.super.OnExit(self);
	self:CameraReset();

	self:_remove_SubmitIncBord_Tick();
end

local tempVector3 = LuaVector3.zero
function GuildBuildingMatSubmitView:_loadCellPfb(cName)
	local cell = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
	if(not cell) then
		error ("can not find cellpfb"..cName)
	end
	cell.transform:SetParent(self.gameObject.transform,false)
	tempVector3:Set(0,206,0)
	cell.transform.localPosition = tempVector3
	return cell
end


