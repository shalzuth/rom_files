autoImport("ArtifactMakeMaterialCell")
autoImport("ArtifactMakeCell")

ArtifactMakeView = class("ArtifactMakeView", ContainerView)

ArtifactMakeView.ViewType = UIViewType.NormalLayer

local typeConfig=
{
  [0]="所有神器",
  [450]="长矛",
  [451]="剑",
  [452]="法杖",
  [453]="拳刃",
  [454]="弓",
  [455]="锤子",
  [456]="斧头",
  [457]="匕首",
  [458]="拳套",
  [459]="乐器",
  [460]="鞭子",
}

local stateName = 
{
	"state1001","state2001","state3001"
}

local cameraDuration = 0

function ArtifactMakeView:OnEnter()
	ServiceGuildCmdProxy.Instance:CallQueryGQuestGuildCmd()
	ArtifactMakeView.super.OnEnter(self)
	self:ResetCamera()
	self:CallGuildItemList()
	ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(true);
end

function ArtifactMakeView:ResetCamera()
	local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata;
	self.npcTrans = npcData and npcData.assetRole.completeTransform;
	if(self.npcTrans)then
		local viewPort = CameraConfig.ArtifactNpc_ViewPort or Vector3(0.5,0.2,9) 
		local rotation = CameraConfig.ArtifactNpc_Rotation or Vector3(0,-80,0)
		self:CameraFocusAndRotateTo(self.npcTrans,viewPort,rotation,0)
	end
end

function ArtifactMakeView:OnExit()
	self:_destroyModel()
	if(self.npcTrans and not self.npcTrans.gameObject.activeSelf)then
		self.npcTrans.gameObject:SetActive(true)
	end
	self:SetChooseMakeData(false)
	ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(false);
	ArtifactMakeView.super.OnExit(self)
	self:CameraReset()
end

function ArtifactMakeView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
	self:InitFilter()
end

function ArtifactMakeView:FindObjs()
	self.makeTitle = self:FindGO("MakeTitle"):GetComponent(UILabel)
	self.emptyTip = self:FindComponent("EmptyTip",UILabel)
	self.makeTitleObj = self:FindGO("MakeInfo")
	self.makeBtn = self:FindGO("MakeBtn"):GetComponent(UISprite)

	self.typeFilter = self:FindComponent("typeFilter",UIPopupList)
	self.curTypeName=self:FindComponent("curfilterType",UILabel)
	self.makeBord = self:FindGO("MakeBord")
	self.equipMakePos = self:FindGO("EquipMake")
	self.filterPos = self:FindGO("filterPanel")
	self.noDataTip = self:FindComponent("NoDataTip",UILabel)
	self.noDataTip.text=ZhString.ArtifactMake_NoData
end

function ArtifactMakeView:_ShowEmpty(flag)
	self.noDataTip.gameObject:SetActive(flag)
	self.filterPos:SetActive(not flag)
	self.equipMakePos:SetActive(not flag)
	self.makeBord:SetActive(not flag)
end

function ArtifactMakeView:AddEvts()
	self:AddClickEvent(self.makeBtn.gameObject, function (go)
		self:OnClickMakeBtn()
	end)

	EventDelegate.Add(self.typeFilter.onChange, function()
		if not self.typeFilter.data then
			return
		end
		if self.typeFilterData ~= self.typeFilter.data then
			local allIDs = self:_setTypeData()
			local typeid = tonumber(self.typeFilter.data)
			local typeData
			
			local dataList  = ArtifactProxy.Instance:GetMakeList()
			if(typeid==0)then
				typeData=dataList
			else
				typeData = allIDs[typeid]
			end
			if(#typeData>0)then
				self.typeFilterData = self.typeFilter.data
				self:UpdateMakeList(typeData)
				self.itemWrapHelper:ResetPosition()
				self:UpdateEmpty()
				self:Show(self.emptyTip)
				self.curTypeValue=self.typeFilter.value
			else
				self.curTypeName.text=self.curTypeValue
				MsgManager.ShowMsgByID(3789)
			end
		end
	end)
end

function ArtifactMakeView:_setTypeData()
	local dataList  = ArtifactProxy.Instance:GetMakeList()
	local result = {}
	for k,v in pairs(self.filterConfig) do
		local data = {}
		for _,id in pairs(dataList) do
			local t = Table_Item[id] and Table_Item[id].Type
			if(t)then
				local typeID = Table_ItemType[t].id
				if(typeID)then
					if(k==typeID)then
						data[#data+1]=id
					end
				end
			end
		end
		result[k]=data
	end
	return result
end

function ArtifactMakeView:InitFilter()
	if(not self.rangeList)then
		self.rangeList = ArtifactProxy.Instance:GetAreaFilter(self.filterConfig)
		for i=1,#self.rangeList do
			local rangeData = self.filterConfig[self.rangeList[i]]
			self.typeFilter:AddItem(rangeData , self.rangeList[i])
		end
	end
	if #self.rangeList > 0 then
		local range = self.rangeList[1]
		self.typeFilterData = range
		local rangeData = self.filterConfig[range]
		self.typeFilter.value = rangeData
		self.curTypeValue=rangeData
	end
end

function ArtifactMakeView:OnClickMakeBtn()
	if(not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.ArtifactProduce))then
		MsgManager.ShowMsgByID(4019)
		return
	end
	if self.curArtifactId == nil then
		return
	end
	if(self.total - self.need<0)then
		MsgManager.ShowMsgByID(8)
		return
	end
	local makeData = ArtifactProxy.Instance:GetMakeData(self.curArtifactId)
	local limitFlag = ArtifactProxy.Instance:IsOverLimitCount(makeData.staticData)
	if(1==limitFlag)then
		local tName = self.filterConfig[makeType] or "神器"
		MsgManager.ShowMsgByIDTable(3785,tName)
		return
	elseif(2==limitFlag)then
		MsgManager.ShowMsgByID(3784)
		return
	end
	-- 上限拦截
	ServiceGuildCmdProxy.Instance:CallArtifactProduceGuildCmd(self.curArtifactId);
end

function ArtifactMakeView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.GuildCmdQueryGQuestGuildCmd,self.RefreshUI)
	self:AddListenEvt(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, self.QueryQuest)
	self:AddListenEvt(ItemEvent.ItemUpdate,self.UpdateItem)
	self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd,self.UpdateItem)
	self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd,self.UpdateItem)
	self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd , self.CallGuildItemList)
	self:AddListenEvt(ServiceEvent.GuildCmdArtifactProduceGuildCmd,self.PlayAnimation)
end

function ArtifactMakeView:CallGuildItemList()
	FunctionGuild.Me():QueryGuildItemList()
end

function ArtifactMakeView:PlayAnimation(note)
	local id = note and note.body and note.body.id
	if(id)then
		ArtifactProxy.Instance:ShowFloatAward(id)
	end
end

function ArtifactMakeView:InitShow()
	local param = ArtifactProxy.Instance:GetArtifactType()
	self.filterConfig=GameConfig.ArtifactType[param]
	self.NpcIdCsv=GameConfig.Artifact and GameConfig.Artifact.NpcIDByType or ArtifactProxy.NpcIDByType

	self.tipData = {}
	self.tipData.funcConfig = {}

	local targetCellGO = self:FindGO("TargetCell")
	self.targetCell = BaseItemCell.new(targetCellGO)
	self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)

	local makeMaterialGrid = self:FindGO("MakeMaterialGrid"):GetComponent(UIGrid)
	self.makeMatCtl = UIGridListCtrl.new(makeMaterialGrid, ArtifactMakeMaterialCell, "MakeMaterialCell")
	self.makeMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMakeMaterialItem, self)

	local makeListContainer = self:FindGO("MakeListContainer")
	local wrapConfig = {
		wrapObj = makeListContainer, 
		pfbNum = 6, 
		cellName = "ArtifactMakeCell", 
		control = ArtifactMakeCell, 
		dir = 1,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickMakeCell, self)
	self:RefreshUI()
end

function ArtifactMakeView:QueryQuest()
	ServiceGuildCmdProxy.Instance:CallQueryGQuestGuildCmd()
end

function ArtifactMakeView:RefreshUI(note)
	local data = ArtifactProxy.Instance:GetMakeList()
	self:UpdateMakeList(data)
	self.itemWrapHelper:ResetPosition()
	self:_ShowEmpty(not data or #data<=0)
	self:UpdateEmpty()
	self:Show(self.emptyTip)
end

local weaponTypeLimited = 10
function ArtifactMakeView:ClickMakeCell(cellctl)
	local data = cellctl and cellctl.data
	if data then
		local dType = Table_Artifact[data] and Table_Artifact[data].Type
		if(dType)then
			local viewPort=CameraConfig.Artifact_ViewPort and CameraConfig.Artifact_ViewPort[dType] and  CameraConfig.Artifact_ViewPort[dType].ViewPort or Vector3(0.25,-0.35,4) 
			local rotation=CameraConfig.Artifact_ViewPort and CameraConfig.Artifact_ViewPort[dType] and CameraConfig.Artifact_ViewPort[dType].Rotation or Vector3(0,278,0)
			local npcId = self.NpcIdCsv[dType]
			local virtualNpc = dType>weaponTypeLimited and self.NpcIdCsv[weaponTypeLimited] or npcId
			if(npcId)then
				local npcs = NSceneNpcProxy.Instance:FindNpcs(virtualNpc)
				if(npcs and #npcs>0)then
					local npcdata = npcs[1]
					self.npcTrans=npcdata.assetRole.completeTransform
					if(self.npcTrans)then
						self:CameraReset()
						self:CameraFocusAndRotateTo(self.npcTrans,viewPort,rotation,cameraDuration)
						if(dType>weaponTypeLimited)then
							self.npcTrans.gameObject:SetActive(false)
							self:_resetNpc(npcId,self.npcTrans.position,stateName[Table_Artifact[data].Level])
						end
					end
				end
			end
		end
		-- helplog("ClickMakeCell. ---> data: ",data)
		if self.curArtifactId and self.curArtifactId ~= data then
			self:SetChooseMakeData(false)
			self:SetChooseCell(false)
		end
		self.curArtifactId = data
		self:SetChooseMakeData(true)
		cellctl:SetChoose(true)
		self:UpdateTargetCell()
		self:UpdateItem()
	end
end


function ArtifactMakeView:_destroyModel()
	if(self.npcModel)then
		self.npcModel:Destroy()
		self.npcModel=nil
	end
end

function ArtifactMakeView:_resetNpc(npcid,position,actionName)
	local parts = Asset_RoleUtility.CreateNpcRoleParts(npcid);
	if(self.npcModel)then
		self.npcModel:Redress(parts)
	else
		self.npcModel = Asset_Role.Create(parts)	
	end
	self.npcModel:SetPosition(position)
	self.npcModel:PlayAction_Simple(actionName)
end

function ArtifactMakeView:ClickTargetCell(cellctl)
	if(cellctl and cellctl.data)then
		self.tipData.itemdata = cellctl.data
		self:ShowItemTip(self.tipData , cellctl.icon , NGUIUtil.AnchorSide.Left, {-170,0})
	end
end

function ArtifactMakeView:ClickMakeMaterialItem(cellctl)
	if(cellctl and cellctl.itemData)then
		self.tipData.itemdata = cellctl.itemData
		self:ShowItemTip(self.tipData , cellctl.icon , NGUIUtil.AnchorSide.Left, {-220,0})
	end
end

function ArtifactMakeView:UpdateMakeList(data)
	self.itemWrapHelper:UpdateInfo(data)

	local isEmpty = #data == 0	
	if isEmpty then
		self:UpdateEmpty()
	end
	self.emptyTip.gameObject:SetActive(isEmpty)

	return isEmpty
end

function ArtifactMakeView:UpdateMakeMaterial()
	local data = Table_Artifact[self.curArtifactId]
	if(not data)then
		return
	end
	local curType = data.Type
	local matCsv = data and data.Material
	local produceCount = ArtifactProxy.Instance:GetProduceCount(curType)
	local materialDatas = {}
	if(matCsv)then
		for type,materials in pairs(matCsv) do
			for i=1,#materials do
				local cellMat = {}
				local csvNum = materials[i].num
				local id = materials[i].id
				local num = CommonFun.calcArtifactMaterialItemCount(type,csvNum,produceCount)
				cellMat.id=id
				cellMat.num=num
				materialDatas[#materialDatas+1]=cellMat
			end
		end
	end
	self.makeMatCtl:ResetDatas(materialDatas)
end

function ArtifactMakeView:UpdateTargetCell()
	local makeData = ArtifactProxy.Instance:GetMakeData(self.curArtifactId)
	if makeData then
		self:Hide(self.emptyTip.gameObject)
		self:Show(self.makeBtn.gameObject)
		self:Show(self.targetCell.nameLab.gameObject)
		self:Show(self.makeTitleObj)
		self.targetCell:SetData(makeData.itemData)
	else
		self:Show(self.emptyTip.gameObject)
		self:Hide(self.makeBtn.gameObject)
		self:Hide(self.targetCell.nameLab.gameObject)
		self:Hide(self.targetCell.normalItem)
		self:Hide(self.makeTitleObj)
	end
end

function ArtifactMakeView:UpdateMakeTitle()
	local cells = self.makeMatCtl:GetCells()
	self.need = #cells
	self.total = 0
	for i=1,self.need do
		local cell = cells[i]
		if cell:IsEnough() then
			self.total = self.total + 1
		end
	end
	self.makeTitle.text = string.format(ZhString.ArtifactMake_Title , self.total , self.need)
end


function ArtifactMakeView:UpdateItem()
	self:UpdateMakeMaterial()
	self:UpdateMakeTitle()
end

function ArtifactMakeView:SetChooseMakeData(isChoose)
	local makeData = ArtifactProxy.Instance:GetMakeData(self.curArtifactId)
	if makeData then
		makeData:SetChoose(isChoose)
	end	
end

function ArtifactMakeView:SetChooseCell(isChoose)
	local cells = self.itemWrapHelper:GetCellCtls()
	for i=1,#cells do
		if cells[i].data == self.curArtifactId then
			cells[i]:SetChoose(isChoose)
			break
		end
	end
end

function ArtifactMakeView:UpdateEmpty()
	if self.curArtifactId then
		self:SetChooseMakeData(false)
		self:SetChooseCell(false)
	end
	self.curArtifactId = nil
	self:UpdateTargetCell()
	self:UpdateItem()
end



