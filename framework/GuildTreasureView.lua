autoImport("GuildTreasureItemCell")

GuildTreasureView = class("GuildTreasureView", ContainerView)

GuildTreasureView.ViewType = UIViewType.NormalLayer

local beginVector3,endVector3 = LuaVector3.zero,LuaVector3.zero
local tweenDuration = 0.3
local tempMark = "\n"
local tempData = {}
local tempTipLabWidth = 600
local UI_FLITER = GameConfig.GuildTreasure.SceneFilter or {11,12,20,24};
local actionCsv = 
{
	showBox = "state1001",
	openBox = "state2001",
	disappear = "state3001",
}

local BtnPhase = 
{
	lottery={
		BtnSpriteName = "com_btn_1",
		costId = 151,
	},
	guildAsset = {
		BtnSpriteName = "com_btn_2",
		costId = 460,
	},
}

local GuildTreasureLimit=
{
	--逼格猫金币每周开启次数及对应的价格
	LotteryWeekLimit=
	{
		[1]=100,
		[2]=200,
		[3]=300,
		[4]=400,
	},
	--公会资金每周开启次数及对应的价格
	GuildAssetWeekLimit=
	{
		[1]=100,
		[2]=200,
		[3]=300,
	},
}

function GuildTreasureView:OnEnter()
	FunctionSceneFilter.Me():StartFilter(UI_FLITER);
	GuildTreasureView.super.OnEnter(self)
end

function GuildTreasureView:OnExit()
	FunctionSceneFilter.Me():EndFilter(UI_FLITER);
	if(self.viewType~=GuildTreasureProxy.ViewType.TreasurePreview)then
		ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil,nil,nil,GuildTreasureProxy.ActionType.FRAME_OFF)
	end
	GuildTreasureProxy.Instance:ExitUI()
	GuildTreasureView.super.OnExit(self)
	self:CameraReset()
end

function GuildTreasureView:PlayCameraEff(flag)
	local npcModel = GuildTreasureProxy.Instance:GetNpcModel()
	local npcTrans = npcModel and npcModel.completeTransform
	if(npcTrans)then
		local viewPort = flag and CameraConfig.GuildTreasure_ViewPort or CameraConfig.GuildTreasureDetail_ViewPort
		local rotation = flag and CameraConfig.GuildTreasure_Rotation or CameraConfig.GuildTreasureDetail_Rotation
		self:CameraFocusAndRotateTo(npcTrans,viewPort,rotation)
	end
end

function GuildTreasureView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function GuildTreasureView:FindObjs()
	self.openBtn = self:FindComponent("OpenBtn",UISprite)
	self.limitLab = self:FindComponent("LimitLab",UILabel)
	self.curBoxName=self:FindComponent("NameLab",UILabel)
	self.detailBtn = self:FindGO("DetailBtn")
	self.previewPos = self:FindGO("PreviewPos")
	self.mainViewTweenPos = self:FindComponent("MainViewRoot",TweenPosition)
	self.itemTweenPos = self:FindComponent("ItemRoot",TweenPosition)
	self.itemDesc = self:FindComponent("ItemDesc",UILabel)
	self.itemScrollView = self:FindComponent("ItemScrollView",UIScrollView)
	self.leftBtn = self:FindGO("LeftBtn")
	self.rightBtn = self:FindGO("RightBtn")
	self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
	self.returnBtn = self:FindGO("CloseItemBtn")
	self.costIcon = self:FindComponent("CostIcon",UISprite)
	self.CostNum = self:FindComponent("CostNum",UILabel)
	local table = self:FindComponent("previewDescTable", UITable);
	self.descPreviewCtl = UIGridListCtrl.new(table, TipLabelCell, "TipLabelCell");
	self.openLab = self:FindGO("OpenLab")
	self.scrollView=self:FindComponent("ItemScrollView",UIScrollView)
	self.pos=self:FindGO("pos")

	self.scoreLimit = self:FindComponent("ScoreLimit", UILabel);
end

function GuildTreasureView:AddEvts()
	self:AddClickEvent(self.openBtn.gameObject, function (go)
		self:OnClickOpenBtn()
	end)
	self:AddClickEvent(self.detailBtn,function (go)
		self:OnClickDetail()
	end)
	self:AddClickEvent(self.returnBtn,function (go)
		self:OnClickCloseItem()
	end)

	self:AddClickEvent(self.leftBtn,function (go)
		self:OnClickLeft()
	end)
	self:AddClickEvent(self.rightBtn,function (go)
		self:OnClickRight()
	end)
end

function GuildTreasureView:OnClickLeft()
	if(self.viewType==GuildTreasureProxy.ViewType.TreasurePreview)then
		self:_updateUIByDirection(true)
	else
		ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil,nil,nil,GuildTreasureProxy.ActionType.LEFT);
	end
end

function GuildTreasureView:_updateUIByDirection(turnLeft)
	self.curPreviewIndex=turnLeft and self.curPreviewIndex-1 or self.curPreviewIndex+1
	self:UpdateUI()
end

function GuildTreasureView:OnClickRight()
	if(self.viewType==GuildTreasureProxy.ViewType.TreasurePreview)then
		self:_updateUIByDirection(false)
	else
		ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil,nil,nil,GuildTreasureProxy.ActionType.RIGHT);
	end
end

function GuildTreasureView:OnClickDetail()
	self:PlayTweenPos(true)
	self:CameraReset()
	self:PlayCameraEff(false)
end

function GuildTreasureView:OnClickCloseItem()
	self:PlayTweenPos(false)
	self:CameraReset()
	self:PlayCameraEff(true)
end

function GuildTreasureView:InitShow()
	self.limitCsv = GameConfig.GuildTreasure or GuildTreasureLimit
	self.tipData = {}
	self.tipData.funcConfig = {}
	self.itemDesc.text = ZhString.GuildTreasure_Tip
	self.itemCtl = UIGridListCtrl.new(self.grid, GuildTreasureItemCell, "GuildTreasureItemCell")
	self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.onClickItem, self);
	self.contextDatas = {};
	if(GuildTreasureProxy.Instance:GetViewType()==GuildTreasureProxy.ViewType.TreasurePreview)then
		self:UpdateUI()
	end
end

function GuildTreasureView:onClickItem(cellctl)
	if(cellctl and cellctl.data)then
		self.tipData.itemdata = cellctl.data
		self:ShowItemTip(self.tipData , cellctl.icon , NGUIUtil.AnchorSide.Left, {-220,-30})
	end
end

function GuildTreasureView:OnClickOpenBtn()
	if(self.curTreasureID==0)then
		MsgManager.ShowMsgByID(4042)
		return
	end
	local action,totalLimit,curLimit
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(self.viewType==GuildTreasureProxy.ViewType.HoldTreasure)then
		action=GuildTreasureProxy.ActionType.OPEN_GVG
	elseif(self.viewType==GuildTreasureProxy.ViewType.GuildTreasure)then
		action=GuildTreasureProxy.ActionType.OPEN_GUILD
		if(self.data:isLotteryType())then
			if(MyselfProxy.Instance:GetQuota() < self.quotaLimit)then
				MsgManager.ShowMsgByID(25010)
				return;
			end
			curLimit = self.data.bcoin_treasure_count
			totalLimit = #self.limitCsv.LotteryWeekLimit
			if(curLimit>=totalLimit)then
				MsgManager.ShowMsgByID(4030)
				return
			end
			local money = MyselfProxy.Instance:GetLottery();
			if(money<self.curCount)then
				MsgManager.ConfirmMsgByID(3551, function ()
					self:CloseSelf()
					FuncZenyShop.Instance():OpenUI(PanelConfig.ZenyShop)
				end)
				return
			end
		else
			curLimit = self.data.guild_treasure_count
			totalLimit = #self.limitCsv.GuildAssetWeekLimit

			if(not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Treasure))then
				MsgManager.ShowMsgByID(4034)
				return
			end
			if(curLimit>=totalLimit)then
				MsgManager.ShowMsgByID(4031)
				return
			end

			if(myGuildData.asset<self.curCount)then
				MsgManager.ShowMsgByID(4032)
				return
			end
		end
	end
	TableUtility.TableClear(tempData)
	tempData.id=self.curTreasureID
	MsgManager.ConfirmMsgByID(4040, function ()
		GuildTreasureProxy.Instance:ClearLt()
		ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil,nil,nil,action,nil,tempData);
	end,nil,nil,self.data:GetName())
end

function GuildTreasureView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.GuildCmdTreasureActionGuildCmd,self.UpdateUI)
end

function GuildTreasureView:UpdateUI(note)
	self.viewType=GuildTreasureProxy.Instance:GetViewType()
	self.scoreLimit.gameObject:SetActive(self.viewType==GuildTreasureProxy.ViewType.GuildTreasure);
	if(self.viewType==GuildTreasureProxy.ViewType.TreasurePreview)then
		self.data = GuildTreasureProxy.Instance.treasurePreviewData
		if(self.data)then
			if(not self.curPreviewIndex)then
				self.curPreviewIndex=1
			end
			self.data = self.data[self.curPreviewIndex]
		end
	else
		self.data = GuildTreasureProxy.Instance:GetTreasureData()
	end
	if self.data then
		if(self.data.treasureID==0)then
			-- self:CloseSelf()
			self.curTreasureID = 0;
			self.limitLab.text=string.format(ZhString.GuildTreasure_holdTreasureCount,0)
			return
		end
		if(self.data.staticData)then
			self.npcId=self.data.staticData.NPC
			if(note and note.body)then
				local serviceData = note.body
				if (serviceData.action==GuildTreasureProxy.ActionType.OPEN_GVG or serviceData.action==GuildTreasureProxy.ActionType.OPEN_GUILD)then
					self:Hide(self.pos)
					self:clearLt()
					self.lt = LeanTween.delayedCall(2.5, function ( )
						self:Refresh()
					end);
				else
					self:Refresh()
				end
			else
				self:Refresh()
			end
		end
	end
end

function GuildTreasureView:clearLt()
	if(self.lt)then
		self.lt:cancel();
		self.lt = nil;
	end
end

local tempVector3 = LuaVector3.zero
function GuildTreasureView:Refresh()
	if(not self.pos.activeSelf)then
		self:Show(self.pos)
	end
	local data = self.data
	self.curTreasureID=data.staticData.id
	-- helplog("Refresh self.curTreasureID ： ",self.curTreasureID)
	self.curBoxName.text=data:GetName()
	if(self.viewType==GuildTreasureProxy.ViewType.HoldTreasure)then
		self:Hide(self.previewPos)
		self:Hide(self.leftBtn)
		self:Hide(self.rightBtn)
		self:Show(self.openBtn)
		self:Show(self.limitLab)
		tempVector3:Set(0,4,0)
		self:Hide(self.costIcon)
		self.openLab.transform.localPosition = tempVector3
		self.limitLab.text=string.format(ZhString.GuildTreasure_holdTreasureCount,data.gvgCount)
	elseif(self.viewType==GuildTreasureProxy.ViewType.GuildTreasure)then
		self:Hide(self.previewPos)
		self:Show(self.openBtn)
		self:Show(self.limitLab)
		self:refreshGuildTreasure(data)
		self:_updataArrowByService()
		tempVector3:Set(-50,4,0)
		self.openLab.transform.localPosition = tempVector3
		self:Show(self.costIcon)
	elseif(self.viewType==GuildTreasureProxy.ViewType.TreasurePreview)then
		self:Show(self.previewPos)
		self:_updataArrow(data)
		self:Hide(self.openBtn)
		self:Hide(self.limitLab)
		self:showPreview(data.staticData.Desc)
		GuildTreasureProxy.Instance:SetNpcId(self.data.staticData.NPC)
		GuildTreasureProxy.Instance:LoadNpc()
	end
	if(data.rewardItems)then
		self.itemCtl:ResetDatas(data.rewardItems)
	end
	self.scrollView:ResetPosition();
	if(not self.initLoad)then
		self:PlayCameraEff(true)
		self.initLoad=true
	end
end

function GuildTreasureView:showPreview(desc)
	TableUtility.TableClear(self.contextDatas);
	if(""~=desc)then
		local FuncDescTip = {};
		FuncDescTip.label = {};
		if(string.match(desc,tempMark))then
			local funcDescStrs = string.split(desc,tempMark)
			for i=1,#funcDescStrs do
				local cell = "{uiicon=tips_icon_01} "..funcDescStrs[i];
				table.insert(FuncDescTip.label, cell);
			end
		else
			local cell = "{uiicon=tips_icon_01} "..desc;
			table.insert(FuncDescTip.label, cell);
		end
		FuncDescTip.hideline = true
		FuncDescTip.isWhite = true
		FuncDescTip.labelConfig = {}
		FuncDescTip.labelConfig.labWidth=tempTipLabWidth
		self.contextDatas[#self.contextDatas+1] = FuncDescTip;
	end
	self.descPreviewCtl:ResetDatas(self.contextDatas);
end

function GuildTreasureView:refreshGuildTreasure(data)
	-- local myGuildData = GuildProxy.Instance.myGuildData;
	local treasureNum = data.guild_treasure_count or 1
	local treasureLotteryNum = data.bcoin_treasure_count or 1
	local costIconName
	local bLottery = data:isLotteryType()
	local leftCount

	if(bLottery)then
		costIconName=Table_Item[BtnPhase.lottery.costId].Icon
		leftCount=#self.limitCsv.LotteryWeekLimit-treasureLotteryNum
		self.limitLab.text=string.format(ZhString.GuildTreasure_GuildLimit,leftCount)
		self.curCount=self.limitCsv.LotteryWeekLimit[treasureLotteryNum+1] or self.limitCsv.LotteryWeekLimit[treasureLotteryNum]
	else
		leftCount=#self.limitCsv.GuildAssetWeekLimit-treasureNum
		costIconName=Table_Item[BtnPhase.guildAsset.costId].Icon
		self.limitLab.text=string.format(ZhString.GuildTreasure_GuildLimit,leftCount)
		self.curCount=self.limitCsv.GuildAssetWeekLimit[treasureNum+1] or self.limitCsv.GuildAssetWeekLimit[treasureNum]
	end
	self.scoreLimit.gameObject:SetActive(bLottery)
	IconManager:SetItemIcon(costIconName,self.costIcon)
	self.CostNum.text=self.curCount

	self.quotaLimit = self.curCount*10000
	self.scoreLimit.text = string.format(ZhString.GuildTreasure_GuildTreaSure, MyselfProxy.Instance:GetQuota(), self.quotaLimit);
end

function GuildTreasureView:_updataArrowByService()
	local d = GuildTreasureProxy.Instance.arrowPos
	local pb = GuildCmd_pb
	if(d==pb.ETREASUREPOINT_LEFT)then
		self:Show(self.leftBtn)
		self:Hide(self.rightBtn)
	elseif(d==pb.ETREASUREPOINT_RIGHT)then
		self:Hide(self.leftBtn)
		self:Show(self.rightBtn)
	elseif(d==pb.ETREASUREPOINT_NONE)then
		self:Hide(self.leftBtn)
		self:Hide(self.rightBtn)
	elseif(d==pb.ETREASUREPOINT_ALL)then
		self:Show(self.leftBtn)
		self:Show(self.rightBtn)
	end
end

function GuildTreasureView:_updataArrow(data)
	local index = GuildTreasureProxy.Instance:GetPreviewIndex(data) 
	if(index==0)then
		self:Hide(self.leftBtn)
		self:Hide(self.rightBtn)
	elseif(index==1)then
		self:Hide(self.rightBtn)
		self:Show(self.leftBtn)
	elseif(index==2)then
		self:Hide(self.leftBtn)
		self:Show(self.rightBtn)
	elseif(index==3)then
		self:Show(self.leftBtn)
		self:Show(self.rightBtn)
	end
end

function GuildTreasureView:PlayTweenPos(onCheckDetail)
	if(self.onCheckDetail==onCheckDetail)then 
		return
	end
	self.onCheckDetail = onCheckDetail
	beginVector3:Set(0,0,0)
	endVector3:Set(-226,0,0)
	self.mainViewTweenPos.enabled=true;
	self.mainViewTweenPos.from = onCheckDetail and beginVector3 or endVector3;
	self.mainViewTweenPos.to = onCheckDetail and endVector3 or beginVector3;
	self.mainViewTweenPos.duration = tweenDuration;
	self.mainViewTweenPos:ResetToBeginning()
	self.mainViewTweenPos:PlayForward();
	self.mainViewTweenPos:SetOnFinished(function ()
		self.mainViewTweenPos.enabled=false;
	end)

	beginVector3:Set(800,0,0)
	endVector3:Set(-198,0,0)
	self.itemTweenPos.enabled=true;
	self.itemTweenPos.from = onCheckDetail and beginVector3 or endVector3;
	self.itemTweenPos.to = onCheckDetail and endVector3 or beginVector3;
	self.itemTweenPos.duration = tweenDuration;
	self.itemTweenPos:ResetToBeginning()
	self.itemTweenPos:PlayForward();
	self.itemTweenPos:SetOnFinished(function ()
		self.itemTweenPos.enabled=false;
	end)
end



