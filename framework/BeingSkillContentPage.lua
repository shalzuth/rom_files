autoImport("SubView")
autoImport("BeingSkillTip")
autoImport("SkillCell")
autoImport("SkillBeingHeadCell")
BeingSkillContentPage = class("BeingSkillContentPage",SubView)

local tmpPos = LuaVector3.zero
function BeingSkillContentPage:Init()
	-- self.isEditMode = false
	self.tipdata = {}
	self.cellHeight = 0
	self.cellWidth = 0
	self:FindObjs()
	self:InitBeingList()
	self:InitShortCuts()
	self:InitProfessSkill()
	self:AddViewListener()
end

function BeingSkillContentPage:PanelWholeWidth()
	return self.beingsPanel.width + self.beingsSkillPanel.width
end

function BeingSkillContentPage:OnEnter()
end

function BeingSkillContentPage:OnExit()
	self:Switch(false)
end

function BeingSkillContentPage:AddViewListener()
	self:AddListenEvt(CreatureSkillProxy.BeingEnableEvent,self.UpdateBeings)
	self:AddListenEvt(SkillSimulate.HasNoModifiedSkills,self.NoModifiedHandler)
	self:AddListenEvt(ServiceEvent.SceneBeingBeingSkillUpdate,self.RefreshSkills)
end

function BeingSkillContentPage:UpdateBeings()
	self.beingList:ResetDatas(self:GetBeings())
end

function BeingSkillContentPage:InitBeings()
	self:UpdateBeings()
	self:SelectBeing(self:GetCell(self:GetSelectSkillBeingData()))
	self:RefreshEditMode()
end

function BeingSkillContentPage:InitShortCuts()
	self.shortCutList = UIGridListCtrl.new(self.shortCutGrid,BeingAutoShortCutSkillDragCell,"ShortCutSkillDragCell")
	self.shortCutList:AddEventListener(DragDropEvent.SwapObj,self.SwapSkill,self)
	self.shortCutList:AddEventListener(DragDropEvent.DropEmpty,self.TakeOffSkill,self)
end

function BeingSkillContentPage:InitProfessSkill()
	self.skillList = ListCtrl.new(self.beingSkillsGrid,SkillCell,"SkillCell")
	self.skillList:AddEventListener(MouseEvent.MouseClick,self.ShowTipHandler,self)
	self.skillList:AddEventListener(SkillCell.SimulationUpgrade,self.SimulationUpgradeHandler,self)
	self.skillList:AddEventListener(SkillCell.SimulationDowngrade,self.SimulationDowngradeHandler,self)
end

function BeingSkillContentPage:FindObjs()
	local BottomLeft = self:FindGO("BottomLeft")
	local BottomRight = self:FindGO("BottomRight")
	local Right = self:FindGO("RightBtns")
	self.bottomleftMines = self:FindGO("Beings",BottomLeft)
	self.bottomrightBeings = self:FindGO("Beings",Right)
	self.beingContent = self:FindGO("BeingContent")
	self.beingsPanel = self:FindComponent("BeingContentLeft",UIPanel,self.beingContent)
	self.beingsSkillPanel = self:FindComponent("BeingsSkillsContent",UIPanel,self.beingContent)
	self.beingGridScroll = self:FindComponent("BeingGridScroll",UIWidget,self.beingContent)
	self.beingGrids = self:FindComponent("BeingGrid",UIGrid,self.beingContent)
	self.beingSkillsGrid = self:FindGO("SkillGrid",self.beingContent)

	local scrollArea = self:FindGO("ScrollArea")
	self.scrollAreaBeings = self:FindGO("Beings",scrollArea)
	self.contentBeings = self:FindGO("Beings",self:FindGO("Contents"))
	self.beingGridScroll:ResetAndUpdateAnchors()
	self.beingsSkillPanel:ResetAndUpdateAnchors()
	self.beingsPanel:ResetAndUpdateAnchors()

	self.cellWidth = 75
	self.cellHeight = self.beingsSkillPanel.height/5 - 3
	local beingCellHeight = self.beingsPanel.height/3
	self.beingGrids.cellHeight = beingCellHeight

	self.shortCutGrid = self:FindGO("BeingShortCutGrid"):GetComponent(UIGrid)

	self.points = self:FindComponent("SkillPoints",UILabel,self.beingGridScroll.gameObject)

	self.confirmBtn = self:FindGO("BeingsConfirmBtn"):GetComponent(UIButton)
	self.cancelBtn = self:FindGO("BeingsCancelBtn"):GetComponent(UIButton)

	self:AddClickEvent(self.cancelBtn.gameObject,function ()
		self:CancelSimulate()
	end)

	self:AddClickEvent(self.confirmBtn.gameObject,function ()
		local data = self:GetSelectSkillBeingData()
		local skillIDs = data.simulate:GetModifiedSkills()
		ServiceSceneBeingProxy.Instance:CallBeingSkillLevelUp(data.profession,skillIDs)
	end)
end

function BeingSkillContentPage:InitBeingList()
	self.beingList = ListCtrl.new(self.beingGrids,SkillBeingHeadCell,"SkillBeingHeadCell")
	self.beingList:AddEventListener(MouseEvent.MouseClick,self.SelectBeing,self)
end

function BeingSkillContentPage:Switch(val)
	if(self.switch~=val) then
		self.switch = val
		if(val) then
			self:Show(self.bottomleftMines)
			self:Show(self.beingContent)
			self:Show(self.scrollAreaBeings)
			self:Show(self.contentBeings)
			self:Show(self.bottomrightBeings)
		else
			self:Hide(self.bottomleftMines)
			self:Hide(self.beingContent)
			self:Hide(self.scrollAreaBeings)
			self:Hide(self.contentBeings)
			self:Hide(self.bottomrightBeings)
		end
	end
end

function BeingSkillContentPage:GetCell(data)
	if(data) then
		local cells = self.beingList:GetCells()
		for index, cell in pairs(cells) do
	        if cell.beingData == data then
	            return cell
	        end
	    end
	end
	return nil
end

function BeingSkillContentPage:ConfirmEditMode(toDo,owner,param)
	local data = self:GetSelectSkillBeingData()
	if(data:GetIsEditMode()) then
		MsgManager.ConfirmMsgByID( 602,function()
			self:CancelSimulate()
			toDo(owner,param)
		end)
	else
		toDo(owner,param)
	end
end

function BeingSkillContentPage:_ChangeSelect(cell)
	local data = self:GetSelectSkillBeingData()
	local lastCell
	if(data) then
		lastCell = self:GetCell(data)
	end
	self:SetSelectSkillBeingData(cell.beingData)
	cell:SetSelect(cell.beingData.isSelect)
	if(lastCell) then
		lastCell:SetSelect(data.isSelect)
	end
	self:UpdateShortCuts(cell.beingData)

	self:RefreshPoints()

	self:SetBeingSkills(cell.beingData,true)
end

function BeingSkillContentPage:SelectBeing(cell)
	local data = self:GetSelectSkillBeingData()
	if(data~=cell.data) then
		self:ConfirmEditMode(self._ChangeSelect,self,cell)
	end
end

function BeingSkillContentPage:UpdateShortCuts(beingData)
	self.shortCutList:ResetDatas(beingData:GetEquipedSkills())

	if self.container.multiSaveId ~= nil then
		local cells = self.shortCutList:GetCells()
		for i=1,#cells do
			local cell = cells[i]
			if cell then
				cell.dragDrop:SetDragEnable(false)
			end
		end
	end
end

function BeingSkillContentPage:GetShotCutType(class)
	if(class == BeingAutoShortCutSkillDragCell) then
		return ShortCutProxy.SkillShortCut.BeingAuto
	else
		return SceneSkill_pb.ESKILLSHORTCUT_MIN
	end
end

function BeingSkillContentPage:SwapSkill(obj)
	local source = obj.data.source
	local target = obj.data.target
	-- helplog("swap",source.data.id,target.data.pos)
	-- helplog("swap",source.data.pos,target.data.pos)
	local currentBeingData = self:GetSelectSkillBeingData()
	if(currentBeingData:GetIsEditMode()) then
		if(source.class == SkillCell) then
			MsgManager.ShowMsgByIDTable(608)
			return
		end
	end
	local beingAuto = ShortCutProxy.SkillShortCut.BeingAuto
	if source ~= nil and target ~= nil and source.data:GetPosInShortCutGroup(beingAuto) ~= target.data:GetPosInShortCutGroup(beingAuto) then
		local targetType = self:GetShotCutType(target.class)
		local sourceType = self:GetShotCutType(source.class)
		local targetPos = nil
		if targetType == beingAuto then
			targetPos = target.data:GetPosInShortCutGroup(targetType)
		end
		-- helplog("SwapSkill",source.data.id,targetPos)
		-- helplog("SwapSkill",sourceType,targetType)
		-- helplog("SwapSkill",currentBeingData.profession)
		ServiceSkillProxy.Instance:CallEquipSkill(source.data.id,targetPos,source.data.sourceId,sourceType,targetType,currentBeingData.profession)
	end
end

function BeingSkillContentPage:TakeOffSkill(obj)
	local data = obj.data
	if(data~=nil) then
		local currentBeingData = self:GetSelectSkillBeingData()
		ServiceSkillProxy.Instance:TakeOffSkill(data.data.id,data.data.sourceId,self:GetShotCutType(data.class),currentBeingData.profession)
	end
end

function BeingSkillContentPage:ShowTipHandler(cell)
	local camera =  NGUITools.FindCameraForLayer (cell.gameObject.layer);
	if(camera) then
		local viewPos = camera:WorldToViewportPoint(cell.gameObject.transform.position)
		local data = cell.data
		local currentBeingData = self:GetSelectSkillBeingData()
		if(currentBeingData:GetIsEditMode()) then
			data = currentBeingData.simulate:GetSimulateSkillItemData(data.sortID)
		end
		self.tipdata.data = data
		self.tipdata.beingData = currentBeingData
		TipsView.Me():ShowTip(BeingSkillTip,self.tipdata,"SkillTip")
		local tip = TipsView.Me().currentTip
		if(tip) then
			tip:SetCheckClick(self:TipClickCheck())
			if(viewPos.x <=0.5) then
				tmpPos[1],tmpPos[2],tmpPos[3] = self:PanelWholeWidth()/4,0,0
			else
				tmpPos[1],tmpPos[2],tmpPos[3] = -self:PanelWholeWidth()/4,0,0
			end
			tip.gameObject.transform.localPosition = tmpPos
		end
	end
end

function BeingSkillContentPage:TipClickCheck()
	if(self.tipCheck == nil) then
		self.tipCheck = function ()
			local click = UICamera.selectedObject
			if(click) then
				local cells = self.skillList:GetCells()
				if(self:CheckIsClickCell(cells,click)) then
					return true
				end
			end
			return false
		end
	end
	return self.tipCheck
end

function BeingSkillContentPage:CheckIsClickCell(cells,clickedObj)
	for i=1,#cells do
		if(cells[i]:IsClickMe(clickedObj)) then
			return true
		end
	end
	return false
end

function BeingSkillContentPage:SimulationUpgradeHandler(cell)
	local currentBeingData = self:GetSelectSkillBeingData()
	if(currentBeingData.simulate:Upgrade(cell,self.skillList:GetCells())) then
		self:RefreshEditMode()
		self:RefreshPoints()
	end
end

function BeingSkillContentPage:SimulationDowngradeHandler(cell)
	local currentBeingData = self:GetSelectSkillBeingData()
	currentBeingData.simulate:Downgrade(cell,self.skillList:GetCells())
	self:RefreshPoints()
end

function BeingSkillContentPage:NoModifiedHandler(note)
	self:RefreshEditMode()
end

function BeingSkillContentPage:RefreshSkills(note)
	self:CancelSimulate(true)
	self:UpdateShortCuts(self:GetSelectSkillBeingData())
end

function BeingSkillContentPage:QuitProfess(toDo,owner)
	if(self.isEditMode)then
		MsgManager.ConfirmMsgByID( 602,function()
			self:CancelSimulate()
			toDo(owner)
		end)
	else
		toDo(owner)
	end
end

function BeingSkillContentPage:CancelSimulate(layout)
	local currentBeingData = self:GetSelectSkillBeingData()
	currentBeingData.simulate:RollBack()
	self:RefreshEditMode()
	self:SetBeingSkills(currentBeingData,layout)
	self:RefreshPoints()
end

function BeingSkillContentPage:SetBeingSkills(beingData,needLayout)
	if(beingData~=nil) then
		self.skillList:ResetDatas(beingData.skills,true,false)

		if self.container.multiSaveId == nil then
			beingData.simulate:ScallAllDatas(self.skillList:GetCells())
		else
			local cells = self.skillList:GetCells()
			for i=1,#cells do
				local cell = cells[i]
				if cell then
					cell:ShowUpgrade(false)
					cell:SetDragEnable(false)
				end
			end
		end

		if(needLayout) then
			self:LayOutProfessSkills(beingData)
			-- self.proContentScroll:ResetPosition()
		end
	end
end

function BeingSkillContentPage:LayOutProfessSkills(beingData)
	local paths = beingData.paths
	local cells = self.skillList:GetCells()
	local firstCell
	local cell
	local x,y
	local minCell = {x=1000,y=1000}
	local config
	local sortMap = {}
	local requiringCells = {}
	for i=1,#cells do
		cell = cells[i]
		sortMap[cell.data.sortID] = cell
		if(cell.data.requiredSkillID) then
			requiringCells[#requiringCells+1] = cell
		else
			cell:RemoveLink()
		end
		x,y = cell:GetGridXY()
		minCell.x = math.min(minCell.x,x)
		if(x == minCell.x) then
			minCell.y = math.min(minCell.y,y)
			if(y == minCell.y) then firstCell = cell end
		end
		tmpPos:Set(self:GetX(x),-(y-3)*self.cellHeight,0)
		cell.gameObject.transform.localPosition = tmpPos
		 -- + self.comContentPanel.height/2 + 70
	end
	local requiredSkill
	local requiredSort
	for i=1,#requiringCells do
		cell = requiringCells[i]
		requiredSort = math.floor(cell.data.requiredSkillID/1000)
		requiredSkill = sortMap[requiredSort]
		-- print(cell.data.sortID,"需要 技能",requiredSort)
		if(requiredSkill) then
			local x,y = requiredSkill:GetGridXY()
			local path = paths[y][x]
			requiredSkill:DrawLink(cell,path.between,path.up)
		end
	end
end

function BeingSkillContentPage:GetX(x)
	return x*self.cellWidth - self.beingsSkillPanel.width/2 + self.beingsPanel.width/2
end

function BeingSkillContentPage:RefreshEditMode()
	local currentBeingData = self:GetSelectSkillBeingData()
	if(currentBeingData:GetIsEditMode()) then
		self:Show(self.confirmBtn.gameObject)
		self:Show(self.cancelBtn.gameObject)
	else
		self:Hide(self.confirmBtn.gameObject)
		self:Hide(self.cancelBtn.gameObject)
	end
end

function BeingSkillContentPage:RefreshPoints( )
	local currentBeingData = self:GetSelectSkillBeingData()
	local points = currentBeingData.leftPoints
	if(currentBeingData:GetIsEditMode()) then
		points = currentBeingData.simulate.leftPoints
	end
	self.points.text = string.format(ZhString.SkillView_LeftSkillPointText,points)
end

function BeingSkillContentPage:SetSelectSkillBeingData(skillBeingData)
	local multiSaveId = self.container.multiSaveId
	if multiSaveId == nil then
		CreatureSkillProxy.Instance:SetSelectSkillBeingData(skillBeingData)
	else
		local map = SaveInfoProxy.Instance:GetBeingSkill(multiSaveId, self.container.multiSaveType)
		for k,v in pairs(map) do
			if v.isSelect then
				v:SetSelect(false)
				break
			end
		end
		skillBeingData:SetSelect(true)
	end
end

function BeingSkillContentPage:GetSelectSkillBeingData()
	local multiSaveId = self.container.multiSaveId
	if multiSaveId == nil then
		return CreatureSkillProxy.Instance:GetSelectSkillBeingData()
	else
		local map = SaveInfoProxy.Instance:GetBeingSkill(multiSaveId, self.container.multiSaveType)
		for k,v in pairs(map) do
			if v.isSelect then
				return v
			end
		end
	end
end

function BeingSkillContentPage:GetBeings()
	local multiSaveId = self.container.multiSaveId
	if multiSaveId == nil then
		return CreatureSkillProxy.Instance:GetBeingsArray()
	else
		return SaveInfoProxy.Instance:GetBeingsArray(multiSaveId, self.container.multiSaveType)
	end
end