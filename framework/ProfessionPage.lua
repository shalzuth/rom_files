ProfessionPage = class("ProfessionPage",SubView)
autoImport("ProfessionTypeIconCell")
autoImport("ProfessionIconCell")
autoImport("MPLineCell")

ProfessionPage.ProfessionIconClick = "ProfessionPage_ProfessionIconClick"
ProfessionPage.cellRes = ResourcePathHelper.UICell("ProfessionTypeIconCell")
ProfessionPage.lineRes = ResourcePathHelper.UICell("MPLineCell")

local topScrollViewIconTable = {}
local professionTypeIconCells = {}
local IconCellTable = {}
local LineTable = {}
local multiProfessionTypeIconCells = {}
local tempVector3 = LuaVector3.zero
HeadIconState = 
{
	State1 = 1,
	State2 = 2,
	State3 = 3,
	State4 = 4,
	State5 = 5,
	State6 = 6,
	State7 = 7
}

---服务器消息处理  start----
function ProfessionPage:RecvProfessionChangeUserCmd(data)
	if data~=nil and data.body~=nil and data.body.branch~=nil and data.body.success~=nil then
		if data.body.success then 
			self:sendNotification(UIEvent.CloseUI,self.container)
			local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
			for k,v in pairs(S_ProfessionDatas) do
				if v.branch == data.body.branch then
					local classData =  Table_Class[v.profession]

					for m,n in pairs(multiProfessionTypeIconCells) do
						local id = n:GetId() or 0
						if id == self.curProfessionId then
							n:SetHeadIconState(HeadIconState.State1)
							n:UpdateState()
							break
						end	
					end

					for m,n in pairs(multiProfessionTypeIconCells) do
						local id = n:GetId() or 0
						if id == v.profession then

							n:SetHeadIconState(HeadIconState.State3)
							n:UpdateState()
							break
						end	
					end

					v.iscurrent = true
					self.curType = classData.Type
					self.curProfessionId = v.profession
					ProfessionProxy.Instance:SetCurTypeBranch(v.branch)
				
				else
					S_ProfessionDatas[v.branch].iscurrent  = false
				end	
			end	

			self:UpdateUI();
		else
			helplog("RecvProfessionChangeUserCmd Failed reviewCode")
		end	
	else
		helplog("服务器消息不对 reviewCode")
	end	
end	

function ProfessionPage:RecvProfessionBuyUserCmd(data)
	if data~=nil and data.body~=nil and data.body.branch~=nil and data.body.success~=nil then
		if data.body.success then 
			local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
			S_ProfessionDatas[data.body.branch] = {}
			S_ProfessionDatas[data.body.branch].branch  = data.body.branch
			local b =data.body.branch
			S_ProfessionDatas[data.body.branch].profession  = (b-b%10)+1
			S_ProfessionDatas[data.body.branch].joblv  = 0
			S_ProfessionDatas[data.body.branch].isbuy  = true
			S_ProfessionDatas[data.body.branch].iscurrent  = false
			self:PassEvent(ProfessionPage.ProfessionIconClick,nil)	
			self:UpdateUI();

			local SysmsgData = Table_Sysmsg[25412]
			for k,v in pairs(Table_Class) do
				if v.TypeBranch ==  data.body.branch and v.id%10 == 2 then
					MsgManager.FloatMsg(nil, string.format(SysmsgData.Text,v.NameZh))
					break
				end	
			end	
		else
			helplog("RecvProfessionBuyUserCmd Failed reviewCode")
		end	
	else
		helplog("服务器消息不对 reviewCode")
	end	
end	

function ProfessionPage:RecvProfessionQueryUserCmd(data)
	ProfessionProxy.Instance:RecvProfessionQueryUserCmd(data)
	local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
	for k,v in pairs(S_ProfessionDatas) do
		if v.iscurrent then
			ProfessionProxy.Instance:SetCurTypeBranch(v.branch)
		end	
	end	

	for k,v in pairs(S_ProfessionDatas) do
		for m,n in pairs(multiProfessionTypeIconCells) do
			local previousId,previousJoblv = n:GetPrevious()
			local nid = n:GetId()
			if previousId == v.profession then
				n:SetPreviousJob(previousId,v.joblv)
			end	
		end
	end
	self:UpdateUI()
end	

function ProfessionPage:Init()
	self:initView()	
	self:addViewEventListener()
	self:AddListenerEvts()	
	self:initData()
end

function ProfessionPage:initView(  )
	self.appBtn = self:FindGO("appBtn")
	self.gameObject = self:FindGO("ProfessionPage")
	self.bottomRegion = self:FindGO("bottomRegion")
	self.baseLvlimit = self:FindGO("BaseLevelLimit")
	self.baseLvLimitLabel =  self:FindGO("value",self.baseLvlimit):GetComponent(UILabel)
	self.baseStf = self:FindGO("satisfy",self.baseLvlimit)
	self.jobLvLimit = self:FindGO("JobLevelLimit")
	self.jobLvLimitLabel =  self:FindGO("value",self.jobLvLimit):GetComponent(UILabel)
	self.jobStf = self:FindGO("satisfy",self.jobLvLimit)
	self.moneyLimit = self:FindGO("CostmoneyLimit")
	self.moneyLimitLabel =  self:FindGO("value",self.moneyLimit):GetComponent(UILabel)
	self.moneyStf = self:FindGO("satisfy",self.moneyLimit)
	self.moneyTypeLimit =  self:FindGO("moneyType",self.moneyLimit):GetComponent(UISprite)
	self:Hide(self.moneyLimit)
	self.possibleProfession = self:FindGO("possibleProfession"):GetComponent(UILabel)
	self.oneProfessionObj = self:FindGO("oneProfession")
	self.twoProfessionObj = self:FindGO("twoProfession")
	self.maxProfessionObj = self:FindGO("maxProfession")
	local curImg = self:FindGO("currentImg")
	local obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.cellRes, curImg);
	tempVector3:Set(0,0,0)
	obj.transform.localPosition = tempVector3
	self.currentPfnTypeIconCell = ProfessionTypeIconCell.new(obj)
	table.insert(professionTypeIconCells,self.currentPfnTypeIconCell)
	self.currentPfnTypeIconCell:isShowName(false)
	self.mentor = self:FindGO("mentor"):GetComponent(UITexture)
	self.npcTextureName = "persona_bg_npc"
	PictureManager.Instance:SetUI(self.npcTextureName,self.mentor)
	multiProfessionTypeIconCells = {}
	LineTable = {}
	self.topRegion = self:FindGO("topRegion")
	self.centerRegion = self:FindGO("centerRegion")
	self.MultiJobsNode = self:FindGO("MultiJobsNode")
	self.mentor = self:FindGO("mentor")
	self.topRegion.gameObject:SetActive(false)
	self.centerRegion.gameObject:SetActive(false)
	self.bottomRegion.gameObject:SetActive(false)
	self.MultiJobsNode.gameObject:SetActive(true)
	self.mentor.gameObject:SetActive(false)
	self.MultiJobsNode = self:FindGO("MultiJobsNode")
	if self.MultiJobsNode==nil then
		helplog("if self.MultiJobsNode==nil then")
	end
	self.topScrollView = self:FindGO("topScrollView",self.MultiJobsNode)
	self.topScrollView.gameObject.transform.localPosition = Vector3(-43,303,0)
	self.JobsGrid_UIGrid = self:FindGO("JobsGrid",self.topScrollView):GetComponent(UIGrid)
	self.JobsGrid_UIGrid.cellWidth = 85
	if Table_Class==nil then
		helplog("Pif Table_Class==nil then")
	end	
	self.skillBtn = self:FindGO("mskillBtn",self.MultiJobsNode)
	self.skillBtn_UISprite =self.skillBtn:GetComponent(UISprite)
	self:AddClickEvent(self.skillBtn.gameObject,function ()
		if ProfessionProxy.Instance:IsMPOpen() then
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.CheckAllProfessionPanel, viewdata = nil})
		else
			MsgManager.ShowMsgByID(25413)
		end	
	end)
	--知道目前所在的一转职业
	local curOcc = Game.Myself.data:GetCurOcc()
	if curOcc~=nil and curOcc.profession~=nil then
		self.curType = Table_Class[curOcc.profession].Type
		--这个涉及多职业
		ProfessionProxy.Instance:SetCurTypeBranch(curOcc.professionData.TypeBranch)
		--self.curTypeBranch = curOcc.professionData.TypeBranch
		self.curProfessionId = curOcc.profession
		if self.curProfessionId == 1 then

		else	
			self:GetNextTurnTableAndShow(self.curType*10+1,nil)
			--当前的一转职业肯定不锁
			--topScrollViewIconTable[self.curType].isGrey = false
		end
	end	

	self.JobsGridList = UIGridListCtrl.new(self.JobsGrid_UIGrid,ProfessionIconCell,"ProfessionIconCell")
	local topScrollViewIconTable = ProfessionProxy.Instance:GetTopScrollViewIconTable()
	self.JobsGridList:ResetDatas(topScrollViewIconTable)
	local cells = self.JobsGridList:GetCells()
	for k,v in pairs(cells) do
		v:SetShowType(1)
		local data = v:GetData()
		if data and data.id == MyselfProxy.Instance:GetMyProfession() then
			v:setIsSelected( true )
		else
			v:setIsSelected( false )
		end	
	end

	self.JobsGridList:AddEventListener(MouseEvent.MouseClick,self.clickHandler,self)
	self:ResetHeadIconsState()
	self.JobsGrid_UIGrid:Reposition()
end

function  ProfessionPage:clickHandler(obj)
	if ProfessionProxy.Instance:IsMPOpen() == false then
		MsgManager.ShowMsgByID(25413)
		do return end
	end	

	self:PassEvent(ProfessionPage.ProfessionIconClick,nil)
	obj:setIsSelected(true)
	local cellsTable = self.JobsGridList:GetCells()
	for i = 1,#cellsTable do
		local single = cellsTable[i]
		if single~=obj then
			single:setIsSelected(false)
		else
			single:setIsSelected(true)
		end	
	end

	if obj.data.isGrey == false then

		local id = obj.data.id
		self:ResetIcons()
		self:GetNextTurnTableAndShow(id,nil)
		self:ResetHeadIconsState()
	else

		local id = obj.data.id
		self:ResetIcons()
		self:GetNextTurnTableAndShow(id,nil)
		self:ResetHeadIconsState()

	end	
end	

function ProfessionPage:ResetHeadIconsState2()
	for k,v in pairs(multiProfessionTypeIconCells) do
		local id = v:GetId() or 0
		if self.curProfessionId == id then
			v:SetHeadIconState(HeadIconState.State3)
		elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) and self:IsThisIdKeQieHuan(id) then
			v:SetHeadIconState(HeadIconState.State1)
		elseif ProfessionProxy.Instance:IsThisIdYiGouMai(id) and ProfessionProxy.Instance:IsThisIdYiJiuZhi(id)==false then
			v:SetHeadIconState(HeadIconState.State7)
			if id%10>2 then
				v:SetHeadIconState(HeadIconState.State5)
			end	
		elseif ProfessionProxy.Instance:IsThisIdYiGouMai(id) ==false and ProfessionProxy.Instance:IsThisIdKeGouMai(id) then

			if ProfessionProxy.Instance:IsMPOpen() then
				v:SetHeadIconState(HeadIconState.State6)
			else
				v:SetHeadIconState(HeadIconState.State5)
			end	
		elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) and self:IsThisIdKeQieHuan(id)==false then
			v:SetHeadIconState(HeadIconState.State2)			
		else
			--就职条件
			v:SetHeadIconState(HeadIconState.State5)	
		end		
		v:UpdateState()


		local previousId = ProfessionProxy.Instance:GetThisIdPreviousId(id)
		if previousId%10>=1 then
			for k1,v1 in pairs(multiProfessionTypeIconCells) do
				local v1_id = v1:GetId() or 0
				if previousId ==v1_id then
					v:SetPreviousCell(v1)
				end	
			end	
		end	

		if GameConfig.Profession and GameConfig.Profession.banThirdJobChange and GameConfig.Profession.banThirdJobChange ==true then
			if id%10>=4 then
				v.gameObject:SetActive(false)
			end	
		end	
	end	
end

function ProfessionPage:IsThisIdKeQieHuan(id)
	for k,v in pairs(ProfessionProxy.Instance:GetProfessionQueryUserTable()) do
		if v.profession == id then
			return true
		end		
	end
	return false
end

function ProfessionPage:ResetHeadIconsState()
	self:ResetHeadIconsState2()
	self:ResetLineState()
end

function  ProfessionPage:GetNextTurnTableAndShow(id,previousId,countOfBro,index,turnNumber)
	countOfBro = countOfBro or 1
	index = index or 0
	turnNumber = turnNumber or 1

	local nowClassData = Table_Class[id]
	if nowClassData~=nil then
		if nowClassData.IsOpen == 0 then
			return nil
		end	

		if id == nowClassData.TypeBranch then
			self:DrawHeadIcon(id,previousId,countOfBro,index,turnNumber)
			local nextTurnTable = nowClassData.AdvanceClass
			if nextTurnTable~=nil then
				local countOfBroXiuzheng = #nextTurnTable
				for k,v in pairs(nextTurnTable) do
					if Table_Class[v].IsOpen == 0 then
						countOfBroXiuzheng = countOfBroXiuzheng-1
					end	
				end	

				for k,v in pairs(nextTurnTable) do
					self:GetNextTurnTableAndShow(v,id,countOfBroXiuzheng,k,turnNumber+1)
				end	

			elseif 	nextTurnTable==nil then
				local nextId = id + 1

				if Table_Class[nextId].IsOpen == 0 then
					return nil
				end	

				self:GetNextTurnTableAndShow(nextId,id,1,1,turnNumber+1)			
			end	
		else
			self:DrawHeadIcon(id,previousId,countOfBro,index,turnNumber)
			local nextTurnTable = nowClassData.AdvanceClass
			if nextTurnTable~=nil then

				local countOfBroXiuzheng = #nextTurnTable
				for k,v in pairs(nextTurnTable) do
					if Table_Class[v].IsOpen == 0 then
						countOfBroXiuzheng = countOfBroXiuzheng-1
					end	
				end	

				for k,v in pairs(nextTurnTable) do
					self:GetNextTurnTableAndShow(v,id,countOfBroXiuzheng,k,turnNumber+1)
				end	
			elseif 	nextTurnTable==nil then
				local nextId = id + 1

				if Table_Class[nextId].IsOpen == 0 then
					return nil
				end	
				self:GetNextTurnTableAndShow(nextId,id,1,1,turnNumber+1)			
			end	
		end	
	else
	
	end
	return nil
end

function  ProfessionPage:DrawHeadIcon(id,previousId,countOfBro,index,turnNumber)
	local FirstIconY = 164.6
	local YSpace = 170.6
	if previousId == nil then
		--这个是初始职业
		tempVector3:Set(0,FirstIconY,0)
	else
		if turnNumber>=3 then
			if IconCellTable[previousId]~=nil and IconCellTable~=nil and IconCellTable[previousId]~=nil then
				tempVector3:Set(IconCellTable[previousId].transform.localPosition.x,FirstIconY-YSpace*(turnNumber-1),0)
			else
				helplog("review code!!!!")
			end	
		else	
			local x = 0
			if countOfBro == 2 then
				if index == 1 then
					x = -135
				elseif index == 2 then
					x = 135
				end	
			end	

			if countOfBro == 3 then
				if index == 1 then
					x = -135
				elseif index == 2 then
					x = 0
				elseif index == 3 then
					x = 135
				end	
			end	

			tempVector3:Set(x,FirstIconY-YSpace*(turnNumber-1),0)			
		end
	end	

	local holder = self:FindGO("centerScrollView",self.MultdsfiJobsNode)
	local obj = nil
	local pfTable1 = Table_Class[id]
	local pfnCell1 = nil

	for k,v in pairs(multiProfessionTypeIconCells) do
		if v.gameObject.name == "resetcell" then
			obj = v.gameObject
			pfnCell1 = v
			break
		end
	end	

	if obj == nil then
		obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.cellRes, holder);
		pfnCell1 = ProfessionTypeIconCell.new(obj)
		table.insert(multiProfessionTypeIconCells,pfnCell1)
		pfnCell1:AddEventListener(MouseEvent.MouseClick,self.clickMultiProfessionIcon,self)

	end	
	pfnCell1:SetData(nil)
	pfnCell1:SetPreviousJob(previousId,0)

	for k,v in pairs(ProfessionProxy.Instance:GetProfessionQueryUserTable()) do
		if v.profession == previousId then
			pfnCell1:SetPreviousJob(previousId,v.joblv)
			break
		end	
	end

	obj.gameObject.name = tostring(id)
	obj.gameObject.transform:SetParent(holder.transform,false)
	obj.transform.localPosition = tempVector3
	IconCellTable[id] = obj
	pfnCell1:SetData(pfTable1)
	pfnCell1:SetPreviousId(previousId)
	pfnCell1:isShowName(true)
	pfnCell1:SetSelectedMPActive(false)

	if GameConfig.Profession and GameConfig.Profession.banThirdJobChange and GameConfig.Profession.banThirdJobChange ==true then
		if id%10>=4 then
			pfnCell1.gameObject:SetActive(false)
		end	
	end	

	self:DrawLine(id,previousId,countOfBro,index,turnNumber)
end	

function ProfessionPage:ResetLineState()
	for k,v in pairs(LineTable) do
		local id = v:GetId() or 0
		local previousId = v:GetPreviousId() or 0
		if id%10==1 then
			local thisidClass = Table_Class[id]
			local thisac =thisidClass.AdvanceClass
			if #thisac == 2 then
				leftid = thisac[1]
				rightid = thisac[2]
				v:RootSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid),ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
			elseif #thisac == 3 then
				leftid = thisac[1]
				centerid = thisac[2]
				rightid = thisac[3]
				v:RootThreeSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid),ProfessionProxy.Instance:IsThisIdYiJiuZhi(centerid),ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
			else
				helplog("reviewCode")
			end	
		elseif id%10 == 2 then

		elseif id%10 > 2 then
			v:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(id))
			if not ProfessionProxy.Instance:ShouldThisIdVisible(id) then
				--v.gameObject:SetActive(false)
				v.gameObject.transform.localScale = Vector3(0.01,0.01,0.01)
			else
				--v.gameObject:SetActive(true)
				v.gameObject.transform.localScale = Vector3(1,1,1)
			end	 

		else
			helplog("reviewcode")
		end	
	end	
end

function  ProfessionPage:DrawLine(id,previousId,countOfBro,index,turnNumber)
	local holder = self:FindGO("centerScrollView",self.MultdsfiJobsNode)
	local obj = nil
	local lineCell = nil
	for k,v in pairs(LineTable) do
		if v.gameObject.name == "resetline" then
			obj = v.gameObject
			lineCell = v
			break
		end
	end	

	if lineCell==nil then
		obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.lineRes, holder);
		lineCell = MPLineCell.new(obj)
	end	
	obj.gameObject.name = "line"..id
	lineCell:SetId(id)
	lineCell:SetPreviousId(previousId)
	local leftid = nil
	local rightid= nil
	local centerid= nil
	if id%10==1 then
		obj.gameObject.transform.localPosition = Vector3(0,62.7,0)

		local thisidClass = Table_Class[id]
		local thisac =thisidClass.AdvanceClass

		local countOfthisacXiuzheng =  #thisac
		for k,v in pairs (thisac) do
			if Table_Class[v].IsOpen == 0 then
				countOfthisacXiuzheng = countOfthisacXiuzheng -1
			else
				centerid= v
			end	
		end	

		if countOfthisacXiuzheng == 1 then
			obj.gameObject.transform.localPosition = Vector3(0,83.3,0)
			lineCell:ShowLine(2)
			lineCell:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(centerid))
		elseif countOfthisacXiuzheng == 2 then
			lineCell:ShowLine(1)
			leftid = thisac[1]
			rightid = thisac[2]

			lineCell:RootSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid),ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
		elseif countOfthisacXiuzheng == 3 then
			lineCell:ShowLine(3)
			leftid = thisac[1]
			centerid = thisac[2]
			rightid = thisac[3]
			lineCell:RootThreeSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid),ProfessionProxy.Instance:IsThisIdYiJiuZhi(centerid),ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
		else
			helplog("reviewCode")
		end	
	elseif id%10 == 2 then
		obj.gameObject.transform.localPosition = Vector3(100000,0,0)
	elseif id%10 > 2 then
		local thisIconCell = IconCellTable[id]
		local previousIdIconCell = IconCellTable[previousId]
		local x = thisIconCell.gameObject.transform.localPosition.x
		local thisY = thisIconCell.gameObject.transform.localPosition.y
		local previousY =  previousIdIconCell.gameObject.transform.localPosition.y
		local finalY = (thisY+previousY)/2
		obj.gameObject.transform.localPosition = Vector3(x,finalY,0)
		local lineCell = MPLineCell.new(obj)
		lineCell:ShowLine(2)
		lineCell:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(id))
	else
		helplog("reviewcode")
	end	
	table.insert(LineTable,lineCell)

	if GameConfig.Profession and GameConfig.Profession.banThirdJobChange and GameConfig.Profession.banThirdJobChange ==true then
		if id%10>=4 then
			lineCell.gameObject:SetActive(false)
		end	
	end
end	

function  ProfessionPage:ResetIcons()
	for k,v in pairs(multiProfessionTypeIconCells) do
		v.gameObject.transform.localPosition = Vector3(10000,0,0)
		v.gameObject.name = "resetcell"
	end	

	for k,v in pairs(LineTable) do
		v.gameObject.transform.localPosition = Vector3(10000,0,0)
		v.gameObject.name = "resetline"
	end	
end	

function ProfessionPage:addViewEventListener()
	self:AddButtonEvent("appBtn",function (  )
		local isDead = Game.Myself:IsDead()
		if(isDead)then
			MsgManager.ShowMsgByID(2500)
			return
		end
		local tableData = Game.Myself.data:GetCurOcc().professionData
		if(tableData ~= nil)then
			FuncShortCutFunc.Me():CallByID(tableData.AdvancedTeacher)
		else
			printRed("myself curOcc is nil")
		end
		self.container:CloseSelf()
	end)
end

function ProfessionPage:ProfessionImgClick(  )
	-- body
end

function ProfessionPage:AddListenerEvts()
	self:AddListenEvt(ServiceEvent.NUserProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd);	
	self:AddListenEvt(ServiceEvent.NUserProfessionBuyUserCmd, self.RecvProfessionBuyUserCmd);	
	self:AddListenEvt(ServiceEvent.NUserProfessionChangeUserCmd, self.RecvProfessionChangeUserCmd);	
end

function ProfessionPage:UpdateUI()
	for k,v in pairs(ProfessionProxy.Instance:GetProfessionQueryUserTable()) do
		local classData = Table_Class[v.profession]
		if classData~=nil then
			local dataType =classData.Type
		end	
	end	
	local topScrollViewIconTable = ProfessionProxy.Instance:GetTopScrollViewIconTable()
	self.JobsGridList:ResetDatas(topScrollViewIconTable)

	local cells = self.JobsGridList:GetCells()
	local startid = Table_Class[MyselfProxy.Instance:GetMyProfession()].Type*10+1
	for k,v in pairs(cells) do
		v:SetShowType(1)
		local data = v:GetData()
		
		if data and data.id == startid then
			v:setIsSelected( true )
		else
			v:setIsSelected( false )
		end	
	end
	self:ResetHeadIconsState()
end

function ProfessionPage:initData(  )
	self.guidText = nil
	self.textLen = 0
	self.starIndex = 0
	self:updateAdvanceCodition()	
end

function ProfessionPage:getAdvanceLevel( professionData )
	if(professionData)then
		local id = professionData.id
		return (id - math.floor(id/10)*10)
	else
		return 0
	end
end

function ProfessionPage:updateAdvanceCodition(  )
	local nowOcc = Game.Myself.data:GetCurOcc()
	local nextClass = nowOcc.professionData.AdvanceClass
	self.currentPfnTypeIconCell:SetMyselfData()
	self.currentPfnTypeIconCell:AddEventListener(MouseEvent.MouseClick,self.clickProfessionIcon,self)
	local limitCondition =nowOcc.professionData.AdvancedOccupation	
	if(nowOcc.profession == 1)then
		return
	elseif((nextClass and #nextClass==0) or not limitCondition )then
		self:showMaxProfession()
		self:Hide(self.baseLvlimit)
		self:Hide(self.jobLvLimit)
		self:Hide(self.appBtn)
	else
		self:Show(self.baseLvlimit)
		self:Show(self.jobLvLimit)
		self.baseLvLimitLabel.text = "Lv."..tostring(limitCondition.BaseLv)	
		self.jobLvLimitLabel.text = "Lv."..Occupation.GetFixedJobLevel(nowOcc.professionData.MaxJobLevel,nowOcc.profession)
		local userdata = Game.Myself.data.userdata
		local baseLv = userdata:Get(UDEnum.ROLELEVEL)
		local jobLv = userdata:Get(UDEnum.JOBLEVEL)
		local moneyNum = MyselfProxy.Instance:GetROB()
		local canShowBtn = true
		local adLevel = self:getAdvanceLevel(nowOcc.professionData)
		if(adLevel == 1)then
			self:Show(self.baseLvlimit)
			if(limitCondition.BaseLv and baseLv >= limitCondition.BaseLv)then
				self.baseLvLimitLabel.color = Color(0,116/255,188/255,1)			
				self.Show(self.baseStf)
			else
				self.baseLvLimitLabel.color = Color(187/255,19/255,25/255,1)
				self.Hide(self.baseStf)
				canShowBtn = false
			end

			if(nowOcc.professionData.MaxJobLevel and jobLv >= nowOcc.professionData.MaxJobLevel)then
				self.jobLvLimitLabel.color = Color(0,116/255,188/255,1)	
				self.Show(self.jobStf)
			else
				self.jobLvLimitLabel.color = Color(187/255,19/255,25/255,1)
				self.Hide(self.jobStf)
				canShowBtn = false
			end
		else
			self:Hide(self.baseLvlimit)
			if(nowOcc.professionData.MaxJobLevel and jobLv >= nowOcc.professionData.MaxJobLevel)then
				self.jobLvLimitLabel.color = Color(0,116/255,188/255,1)	
				self.Show(self.jobStf)
			else
				self.jobLvLimitLabel.color = Color(187/255,19/255,25/255,1)
				self.Hide(self.jobStf)
				canShowBtn = false
			end
		end
	end		

	local text = ""
	local professionData = Table_Class[nowOcc.profession]
	if(#nextClass>1)then
		local pf1 = nextClass[1]
		local pf2 = nextClass[2]
		local pfTable1 = Table_Class[pf1]
		local pfTable2 = Table_Class[pf2]
		if(pfTable2.IsOpen ~=1)then
			pfTable2 = nil
		end
		local holder = self:FindGO("nextImg1")
		local obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.cellRes, holder);
		tempVector3:Set(0,0,0)
		obj.transform.localPosition = tempVector3
		local pfnCell1 = ProfessionTypeIconCell.new(obj)
		table.insert(professionTypeIconCells,pfnCell1)
		pfnCell1:SetData(pfTable1)
		pfnCell1:AddEventListener(MouseEvent.MouseClick,self.clickProfessionIcon,self)

		holder = self:FindGO("nextImg2")
		obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.cellRes, holder);
		tempVector3:Set(0,0,0)
		obj.transform.localPosition = tempVector3
		local pfnCell2 = ProfessionTypeIconCell.new(self:FindGO("nextImg2"))
		table.insert(professionTypeIconCells,pfnCell2)
		pfnCell2:SetData(pfTable2)
		pfnCell2:AddEventListener(MouseEvent.MouseClick,self.clickProfessionIcon,self)

		self:showTwoProfession()
		if(pfTable2 ~= nil)then
			text = string.format(ZhString.Charactor_ProfessionPageTwo,pfTable1.NameZh,pfTable2.NameZh)
		else
			text = string.format(ZhString.Charactor_ProfessionPageOne,pfTable1.NameZh)
		end
	else
		local pfTable = Table_Class[nowOcc.professionData.AdvanceClass[1]]
		local holder 
		if(pfTable == nil)then
			text = ZhString.Charactor_ProfessionPageMax
			self:showMaxProfession()
			holder = self:FindGO("nextImg",self.maxProfessionObj)
		else
			text = string.format(ZhString.Charactor_ProfessionPageOne,pfTable.NameZh)
			self:showOneProfesion()
			holder = self:FindGO("nextImg",self.oneProfessionObj)
		end
		local obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.cellRes, holder);
		tempVector3:Set(0,0,0)
		obj.transform.localPosition = tempVector3
		local pfnCell = ProfessionTypeIconCell.new(obj)
		table.insert(professionTypeIconCells,pfnCell)
		pfnCell:SetData(pfTable)
		pfnCell:AddEventListener(MouseEvent.MouseClick,self.clickProfessionIcon,self)
	end
	self.guidText = text	
	if(self.guidText)then
		self.textLen = StringUtil.getTextLen(self.guidText)
		self:reShowGuidTextData()
	end	
end

function ProfessionPage:reShowGuidTextData(  )
	local nowOcc = Game.Myself.data:GetCurOcc()
	if(nowOcc.profession == 1)then
		return
	end
	self.starIndex = 1
	self.possibleProfession.text = ""
	TimeTickManager.Me():ClearTick(self)
	TimeTickManager.Me():CreateTick(0,50,self.showGuidText,self)
end

function ProfessionPage:showGuidText(  )
	local text = StringUtil.getTextByIndex(self.guidText,self.starIndex,self.starIndex)
	self.possibleProfession.text = self.possibleProfession.text..text
	self.starIndex = self.starIndex +1
	if(self.textLen+1 == self.starIndex)then
		TimeTickManager.Me():ClearTick(self)
	end
end

function ProfessionPage:clickProfessionIcon( obj)
	local data = obj.data
	if(not obj.isSelected)then
		self:PassEvent(ProfessionPage.ProfessionIconClick,nil)	
	else
		self:PassEvent(ProfessionPage.ProfessionIconClick,data)
		obj:SetSelectedMPActive(true)
		for i=1,#professionTypeIconCells do
			local single = professionTypeIconCells[i]
			if(single ~= obj )then
				single:setIsSelected(false)
				single:SetSelectedMPActive(false)
			end
		end	
	end
end

ProfessionPage.isDebug = true

function ProfessionPage:clickMultiProfessionIcon( obj)
	local data = obj.data
	if FunctionUnLockFunc.Me():CheckCanOpen(9004,nil)  == false and ProfessionPage.isDebug== false then
		MsgManager.ShowMsgByID(25413)
		do return end
	end	

	if(not obj.isSelected)then
		self:PassEvent(ProfessionPage.ProfessionIconClick,nil)	
	else
		self:PassEvent(ProfessionPage.ProfessionIconClick,obj)
		obj:SetSelectedMPActive(true)
		for i=1,#multiProfessionTypeIconCells do
			local single = multiProfessionTypeIconCells[i]
			if(single ~= obj )then
				single:setIsSelected(false)
				single:SetSelectedMPActive(false)
			end
		end	
	end
end

function ProfessionPage:unSelectedProfessionIconCell(  )
	-- body
	for i=1,#professionTypeIconCells do
		local single = professionTypeIconCells[i]
		if(single ~= obj )then
			single:setIsSelected(false)
		end
	end

	for i=1,#multiProfessionTypeIconCells do
		local single = multiProfessionTypeIconCells[i]
		if(single ~= obj )then
			single:setIsSelected(false)
		end
	end
end

function ProfessionPage.getAdvanceIndex( profession )
	local professionData = Table_Class[profession]; 
	local sameTypes = SkillProxy.Instance.sameProfessionType[professionData.Type]	
	if(sameTypes ==nil or #sameTypes == 0)then
		print("error profession index"..profession)
		return 1
	end
	for i=1,#sameTypes do
		local single = sameTypes[i]
		if(single.id == profession)then
			return i
		end
	end
end

function ProfessionPage:showMaxProfession(  )
	self:Hide(self.twoProfessionObj)
	self:Hide(self.oneProfessionObj)
	self:Show(self.maxProfessionObj)
end

function ProfessionPage:showOneProfesion(  )
	self:Hide(self.twoProfessionObj)
	self:Hide(self.maxProfessionObj)
	self:Show(self.oneProfessionObj)
end

function ProfessionPage:showTwoProfession(  )
	self:Show(self.twoProfessionObj)
	self:Hide(self.maxProfessionObj)
	self:Hide(self.oneProfessionObj)
end

function ProfessionPage:OnEnter()
	self.super.OnEnter(self)
	ServiceNUserProxy.Instance:CallProfessionQueryUserCmd(nil) 
end

function ProfessionPage:OnExit()
	self.super.OnExit(self)
	TimeTickManager.Me():ClearTick(self)
	PictureManager.Instance:UnLoadUI(self.npcTextureName,self.mentor)
end