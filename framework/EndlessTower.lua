autoImport("EndlessTowerCell")
autoImport("EndlessTowermemberCell")
EndlessTower = class("EndlessTower",ContainerView)

EndlessTower.ViewType = UIViewType.PopUpLayer

function EndlessTower:OnEnter()
	EndlessTower.super.OnEnter(self)
	local viewdata = self.viewdata.viewdata
	if viewdata then
		local npcData = viewdata.npcdata
		if npcData then
			self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
		end
	else
		self:CameraRotateToMe()
	end
end

function EndlessTower:OnExit()
	self:CameraReset()
	FunctionCameraEffect.Me():End(self.cft)
	self.cft = nil
	TimeTickManager.Me():ClearTick(self)
	EndlessTower.super.OnExit(self)
end

function EndlessTower:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitItemList()
	self:InitShow()
end

function EndlessTower:FindObjs()
	self.itemGrid=self:FindGO("contentGrid"):GetComponent(UIGrid)
	self.ChooseSymbolGo=self:FindGO("ChooseSymbol")
	self.ItemScrollView=self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
	self.springPanel=self.ItemScrollView:GetComponent(SpringPanel)
	self.centerOnChild=self.ItemScrollView:GetComponent(MyUICenterOnChild)
	self.cachedPanel=self.ItemScrollView:GetComponent(UIPanel)
	self.refreshtime = self:FindGO("Refreshtime"):GetComponent(UILabel)
end

function EndlessTower:AddEvts()
	self.ItemScrollView.onDragFinished = function ()
		if self.curCell then
			local pCorners = self.cachedPanel.worldCorners
			local centerCorner = (pCorners[1]+pCorners[3])*0.5
			centerCorner = self.ItemScrollView.transform:InverseTransformPoint(centerCorner)
			local curCellPos = self.curCell.gameObject.transform.localPosition
			local offset = centerCorner.y - curCellPos.y
			if offset > 0 then
				self:ScrollTower()
			end
		else
			self:ScrollTower()
		end
	end
end

function EndlessTower:AddViewEvts()
	self:AddListenEvt(ServiceEvent.InfiniteTowerTowerInfoCmd,self.RecvTowerInfoCmd)
end

function EndlessTower:InitItemList()
	self.itemList = UIGridListCtrl.new(self.itemGrid,EndlessTowerCell,"EndlessTowerCell")
	self.itemList:AddEventListener(MouseEvent.MouseClick,self.HandleClickItem,self)
end

function EndlessTower:InitShow()
	self.ItemScrollView.contentPivot=6
	local offset = 3
	local activeH = GameObjectUtil.Instance:GetUIActiveHeight(self.gameObject)
	offset = math.ceil(offset * activeH / 720)
	self.maxOffsetIndex = EndlessTowerProxy.Instance.maxlayer - offset + 1
	self.minOffsetIndex = offset

	self.selectCellData = EndlessTowerProxy.Instance:GetNextLayer()
	self:UpdateTowerInfo()
	self:SetSelectState()
	LeanTween.delayedCall(0.1 , function ()
		self:ScrollTower()
	end)

	if EndlessTowerProxy.Instance.refreshtime then
		self.refreshtime.gameObject:SetActive(true)
		TimeTickManager.Me():CreateTick(0,60000,self.UpdateRefreshtime,self)
	else
		self.refreshtime.gameObject:SetActive(false)
	end
end

local concatTable = {}
function EndlessTower:UpdateRefreshtime()
	local refreshtime = EndlessTowerProxy.Instance.refreshtime
  	local refreshDay,refreshHour,refreshMin = ClientTimeUtil.GetFormatRefreshTimeStr(refreshtime)

  	local str = ""
  	TableUtility.ArrayClear(concatTable)
  	if refreshDay ~= 0 then
  		concatTable[#concatTable + 1] = string.format(ZhString.EndlessTower_refreshDay,tostring(refreshDay))
  	end
  	if refreshHour ~= 0 then
  		concatTable[#concatTable + 1] = string.format(ZhString.EndlessTower_refreshHour,tostring(refreshHour))
  	end
  	concatTable[#concatTable + 1] = string.format(ZhString.EndlessTower_refreshTime,tostring(refreshMin))
  	str = table.concat(concatTable)

  	self.refreshtime.text = str
end

function EndlessTower:SetSelectState()
	local cells = self.itemList:GetCells()
	for i=1,#cells do
		if self.selectCellData == cells[i].data then
			self:SetChooseSymbol(cells[i].gameObject)
			self.curIndex = i
			break
		end
	end
end

function EndlessTower:SetChooseSymbol(go)
	self.ChooseSymbolGo:SetActive(true);
	self.ChooseSymbolGo.transform:SetParent(go.transform,false);
	self.ChooseSymbolGo.transform.localPosition=Vector3(0,2,0)
end

function EndlessTower:RecvTowerInfoCmd(note)
	self.selectCellData=EndlessTowerProxy.Instance:GetNextLayer()
	self:UpdateTowerInfo()
	self:SetSelectState()
end

function EndlessTower:ScrollTower()
	local centerIndex = self.curIndex
	self.curCell = self.itemList:GetCells()[centerIndex]
	if self.curIndex < self.minOffsetIndex then
		centerIndex = self.minOffsetIndex
	elseif self.curIndex > self.maxOffsetIndex then
		centerIndex = self.maxOffsetIndex
	end
	local curCell = self.itemList:GetCells()[centerIndex]
	if curCell then
		self.centerOnChild:CenterOn(curCell.gameObject.transform)
	end
end

function EndlessTower:UpdateTowerInfo()
	local datas = EndlessTowerProxy.Instance:GetTowerInfoData()
	self.itemList:ResetDatas(datas)
end

function EndlessTower:HandleClickItem(cellctl)
	local data = cellctl.data;
	local go = cellctl.gameObject;
	self.selectCellCtl=cellctl;
	self.selectCellData=data
	if(data and go)then
		self:SetChooseSymbol(go)
		self:ClickChallenge()
	end
end

function  EndlessTower:ClickChallenge(go)
	if(TeamProxy.Instance:IHaveTeam())then
		if(EndlessTowerProxy.Instance:IsTeamMembersFighting())then
			if(EndlessTowerProxy.Instance:IsCurLayerCanChallenge(self.selectCellData))then
				--if(not EndlessTowerProxy.Instance:HasChallengeThisLayer())then
					ServiceInfiniteTowerProxy.Instance:CallEnterTower(EndlessTowerProxy.Instance.curChallengeLayer
						,Game.Myself.data.id)
					self:CloseSelf()
					print("CallEnterTower,cur layer is "..EndlessTowerProxy.Instance.curChallengeLayer)
				--else
					--print("has Challenge this layer")
					--MsgManager.ShowMsgByIDTable(1303)
				--end
			else
				MsgManager.FloatMsgTableParam(nil,ZhString.EndlessTower_cantChallenge)
			end
		else
			if(TeamProxy.Instance:CheckIHaveLeaderAuthority())then
				if(EndlessTowerProxy.Instance:IsCurLayerCanChallenge(self.selectCellData))then
					self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.EndlessTowerWaitView ,  viewdata = self.selectCellData })
					ServiceInfiniteTowerProxy.Instance:CallTeamTowerInviteCmd()
					print("CallTeamTowerInviteCmd")
				else
					MsgManager.FloatMsgTableParam(nil,ZhString.EndlessTower_cantChallenge)
				end
			else
				MsgManager.ShowMsgByIDTable(1301)
			end
		end
	else
		MsgManager.ShowMsgByIDTable(1302)
	end
end