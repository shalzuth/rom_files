autoImport("WrapCellHelper")
autoImport("ServantRecommendCell");
autoImport("ServantRecommendToggleCell");
autoImport("PetWorkSpaceEmoji")

ServantRecommendView = class("ServantRecommendView",SubView)

ServantRecommendView.ToggleCellIcon = {
	[0] = "bag_icon_all",
	[1] = "tab_icon_09",
	[2] = "tab_icon_22",
	[3] = "tab_icon_37",
	[4] = "tab_icon_24",
	[5] = "tab_icon_21",
}

local Prefab_Path = ResourcePathHelper.UIView("ServantRecommendView");
local Recommend_TYPE = SceneUser2_pb.ESERVANT_SERVICE_RECOMMEND
local path = ResourcePathHelper.UICell("PetWorkSpaceEmoji")
-- 女仆今日推荐标签页分类
local pageTypeCfg = GameConfig.Servant and GameConfig.Servant.ServantRecommendPageType
local resID = ResourcePathHelper.UICell("ServantRecommendToggleCell")

local actionName = {"functional_action","functional_action2","functional_action3"}

function ServantRecommendView:Init()
	self:FindObjs()
	self:AddUIEvts()
	self:AddViewEvts()
	self:InitView()
end

function ServantRecommendView:InitView()
	self.finishedData = {}
	self.unfinishedData = {}
	self.chooseTypeId=0
	self:ShowUIByPage(self.chooseTypeId,true);
	self:_refreshChoose()
	self:UpdateReward()
	self.scrollViewPos = {}
end

function ServantRecommendView:FindObjs()
	self:LoadSubView()
	-- self.itemRoot = self:FindGO("ItemWrap")
	-- TODO
	-- self.effectTrans = self:FindGO("effectTrans")
	self.scrollView = self:FindComponent("ScrollView",UIScrollView)
	self.mainTable = self:FindComponent("table",UITable)
	local typeBtnRoot=self:FindGO("TypeBtnRoot")
	local ListTable = typeBtnRoot:GetComponent(UIGrid)

	self.table = self:FindComponent("ItemWrap", UITable);
	self.finishRoot = self:FindComponent("finishRoot",UITable);
	self.cellCtl = UIGridListCtrl.new(self.table, ServantRecommendCell, "ServantRecommendCell")
	self.finishCtl = UIGridListCtrl.new(self.finishRoot,ServantRecommendCell,"ServantRecommendCell")
	self.gridListCtl = UIGridListCtrl.new(ListTable,ServantRecommendToggleCell,"ServantRecommendToggleCell")
	self.gridListCtl:AddEventListener(MouseEvent.MouseClick, self._freshClickChoose, self);
	self.gridListCtl:AddEventListener(ServantRecommendToggleCell.LongPress, self.HandleLongPress, self)
	local list = {}
	for k,v in pairs(pageTypeCfg) do
		TableUtility.ArrayPushBack(list,k)
	end
	self.gridListCtl:ResetDatas(list)

	self.emojiRoot = self:FindGO("emojiRoot")
	self:Hide(self.emojiRoot)
	self.emoji = self:LoadPreferb_ByFullPath(path, self.emojiRoot);
	self.emoji.transform.localPosition = Vector3.zero
	self.spaceEmoji = PetWorkSpaceEmoji.new(self.emoji);
	self.spaceEmoji:AddEventListener(MouseEvent.MouseClick, self.OnReward, self);
	self.hideTip = self:FindComponent("HideTip",UILabel)
	self.hideTipBg = self:FindGO("HideTipBg")
	self:AddClickEvent(self.hideTipBg,function ( obj )
		local active = self.finishRoot.gameObject.activeSelf
		self.finishRoot.gameObject:SetActive(not self.finishRoot.gameObject.activeSelf)
		self.hideTip.text = active and ZhString.Servant_Recommend_ShowTip or ZhString.Servant_Recommend_HideTip
		self.finishRoot:Reposition()
		self.table:Reposition()
		self.mainTable:Reposition()
	end)
end

function ServantRecommendView:_freshClickChoose(cellctl)
	if(not cellctl or cellctl.typeID ==self.chooseTypeId)then
		return 
	end
	
	self.chooseTypeId = cellctl.typeID;
	local posCfg = self.scrollViewPos[cellctl.typeID]
	if(not posCfg or 0>=#posCfg)then
		self.scrollView:ResetPosition()
	else
		self.scrollView.panel.clipOffset = posCfg[1]
		self.scrollView.transform.localPosition = posCfg[2]
	end

	self:ShowUIByPage(self.chooseTypeId,true);
	self:_refreshChoose()
end

function ServantRecommendView:OnReward()
	self.container:PlayNpcAction(actionName[3])
	ServiceNUserProxy.Instance:CallReceiveServantUserCmd(true)
end

function ServantRecommendView:LoadSubView()
	local container = self:FindGO("recommendView")
	local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true);
	obj.name = "ServantRecommendView";
end

function ServantRecommendView:AddUIEvts()
	self.scrollView.onDragFinished = function ()
		local typeID = self.chooseTypeId
		if(nil==self.scrollViewPos[typeID])then
			self.scrollViewPos[typeID] = {}
		end
		local tempArray = ReusableTable.CreateArray()
		tempArray[1]=self.scrollView.panel.clipOffset
		tempArray[2]=self.scrollView.transform.localPosition
		self.scrollViewPos[typeID]=tempArray
		ReusableTable.DestroyAndClearArray(args)
	end
end

function ServantRecommendView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.NUserRecommendServantUserCmd, self.RecvRecommendServant);
	self:AddListenEvt(ServiceEvent.NUserServantRewardStatusUserCmd, self.RecvRewardStatus);
end

function ServantRecommendView:OnEnter()
	ServantRecommendView.super.OnEnter(self);
end

function ServantRecommendView:OnExit()
	ServantRecommendView.super.OnExit(self);
end

-- recv
local acName 
function ServantRecommendView:RecvRecommendServant(note)
	local sort=false
	local data = note and note.body
	if(data)then
		local items = data.items
		if(items)then
			if(1==#items and items[1].status == ServantRecommendProxy.STATUS.FINISHED)then
				data = items[1]
				local cfg = data.dwid and Table_Recommend[data.dwid]
				if(cfg)then
					acName = cfg.Favorability and actionName[1] or actionName[2]
					self.container:PlayNpcAction(acName)
				end
				for i=1,#self.unfinishedData do
					if(self.unfinishedData[i].id==data.dwid)then
						local needDel = Table_Recommend[items[1].dwid].NeedDel
						sort = needDel and needDel ==1
						if(sort)then
							self.unfinishedData[i]=nil
						else
							self.unfinishedData[i].status=data.status
						end
						break;
					end
				end
			else
				sort=true
				-- if(Table_Recommend[data.dwid] and Table_Recommend[data.dwid].Favorability)then
				-- 	self:PlayTrailEffect(data.dwid)
				-- end
			end
		end
	end
	self:ShowUIByPage(self.chooseTypeId,sort);
end

local item = {}
local CONST_GIFT_ID , CONST_GIFT_NUM = 700108, 1
function ServantRecommendView:RecvRewardStatus(note)
	self:UpdateReward()
end

function ServantRecommendView:UpdateReward()
	local rewardId = ServantRecommendProxy.Instance:GetFavorRewardID()
	if(rewardId)then
		self:Show(self.emojiRoot)
		local rewards = ItemUtil.GetRewardItemIdsByTeamId(rewardId);
		if(rewards)then
			if(#rewards==1)then
				item.num = rewards[1].num
				item.id = rewards[1].id
			elseif(#rewards>1)then
				item.num = CONST_GIFT_NUM
				item.id = CONST_GIFT_ID
			end
			self.spaceEmoji:SetData(item)
		end
	else
		self:Hide(self.emojiRoot)
	end
end

function ServantRecommendView:ShowUIByPage(typeID,sort)
	local classifiedData = ServantRecommendProxy.Instance:GetRecommendDataByType(typeID,sort)
	self:RefreshByType(classifiedData,sort)
end

function ServantRecommendView:RefreshByType(data,sort)
	if(not sort)then
		self.cellCtl:ResetDatas(self.unfinishedData)
		self.finishCtl:ResetDatas(self.finishedData)
	else
		TableUtility.ArrayClear(self.finishedData)
		TableUtility.ArrayClear(self.unfinishedData)
		if(data)then
			for i=1,#data do
				if(data[i].status ~= ServantRecommendProxy.STATUS.FINISHED)then
					TableUtility.ArrayPushBack(self.unfinishedData,data[i])
				else
					TableUtility.ArrayPushBack(self.finishedData,data[i])
				end
			end
		end
		if(self.unfinishedData and #self.unfinishedData>0)then
			self:Show(self.table.gameObject)
			self.cellCtl:ResetDatas(self.unfinishedData)
		else
			self:Hide(self.table.gameObject)
		end
	
		if(self.finishedData and #self.finishedData>0)then
			self:Show(self.hideTipBg)
			self.finishCtl:ResetDatas(self.finishedData)
			self:Show(self.finishRoot)
		else
			self:Hide(self.finishRoot)
			self:Hide(self.hideTipBg)
		end
	end
	self.finishRoot.gameObject:SetActive(false)
	self.hideTip.text = ZhString.Servant_Recommend_ShowTip
	self.finishRoot:Reposition()
	self.table:Reposition()
	self.mainTable:Reposition()
end

function ServantRecommendView:_refreshChoose()
	if(self.gridListCtl)then
		local childCells = self.gridListCtl:GetCells();
		for i=1,#childCells do
			local childCell = childCells[i];
			childCell:ShowChooseImg(self.chooseTypeId)
		end
	end
end

function ServantRecommendView:HandleLongPress(param)
	local isPressing, toggleCell = param[1], param[2]
	local name = pageTypeCfg[toggleCell.typeID]
	
	-- Show TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then
		if isPressing then
			TipManager.Instance:TryShowVerticalTabNameTip(name, toggleCell.chooseImg, NGUIUtil.AnchorSide.Down)
		else
			TipManager.Instance:CloseTabNameTipWithFadeOut()
		end
	end
end


-- local tempV3 = LuaVector3.zero
-- function ServantRecommendView:PlayTrailEffect(id)
-- 	if(self.finishCtl)then
-- 		local childCells = self.cellCtl:GetCells();
-- 		for i=1,#childCells do
-- 			local childCell = childCells[i];
-- 			if(childCell.id==id)then
-- 				tempV3:Set(LuaGameObject.TransformPoint(self.effectTrans.transform, tempV3))
-- 				childCell:PlayTrailEffect(tempV3)
-- 			end
-- 		end
-- 	end
-- end


