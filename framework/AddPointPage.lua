AddPointPage = class("AddPointPage",SubView)
autoImport("AttributePointModifyCell")

AddPointPage.times = 
	{	"STRPOINT",
		"AGIPOINT", 
		"VITPOINT", 
 		"INTPOINT",  		    
 		"DEXPOINT", 		
 		"LUKPOINT",
	}

AddPointPage.addPointAction = "AddPointPage_addPointAction"

function AddPointPage:Init()
	self.leftPoint = {}	
	-- self.lastValues = nil
	self:initView()
	self:initData()
	self:UpdateProps();
	self:addViewEventListener()
	self:AddListenerEvts()	
end

function AddPointPage:initData(  )
	-- body
	self.leftPoint = {}
	self.leftPoint.currentLeftPoint = 0
	self.leftPoint.originLeftPoint = 0
end

function AddPointPage:initView( )
	-- body
	local centerGrid = self:FindChild("addPointPageCenterRegion"):GetComponent(UIGrid)
	self.centerGridList = UIGridListCtrl.new(centerGrid,AttributePointModifyCell,"AttributePointModifyCell")

	self.leftPointLabel = self:FindGO("leftPointLabel"):GetComponent(UILabel)

	self.solutionConfirmBtn = self:FindGO("solutionConfirmBtn")
	self.disableConfirm = self:FindGO("disableConfirm")
	self:AddOrRemoveGuideId(self.solutionConfirmBtn.gameObject, 7);
	self:disableConfirmMt(false)
end

function AddPointPage:disableConfirmMt( enable )
	-- body
	local isDead = Game.Myself:IsDead()
	if(isDead)then
		enable = false
	end
	if(enable)then
		self:Show(self.solutionConfirmBtn)
		self:Hide(self.disableConfirm)
	else
		self:Hide(self.solutionConfirmBtn)
		self:Show(self.disableConfirm)
	end
end

function AddPointPage:AddListenerEvts()
	self:AddListenEvt(MyselfEvent.MyPropChange,self.UpdateMyPropData)
	self:AddListenEvt(ServiceEvent.NUserAddAttrPoint,self.resetAttrPointDatas)
end

function AddPointPage:selectAddPointSolution( data )
	-- body
	if(not data)then
		return
	end	
	local cells = self.centerGridList:GetCells()
	local cellList = {}
	for i=1,#cells do
		local single = cells[i]
		single:resetTimeOfAdd()
		cellList[single.data.prop.propVO.name] = single
	end	
	local baseLv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) or -1;
	local pointTbData = Table_AddPoint[baseLv]
	if(not pointTbData)then
		printRed("can not find data in table:AddPoint by baseLv:"..baseLv)
		return
	end
	pointTbData = pointTbData["AddPointSolution_"..data.id]
	if(not pointTbData)then
		printRed("can not find data in addsolution in table AddPoint by solutionId:"..data.id)
		return
	end
	if(data)then
		local goOn = 0
		local count = 0
		while(goOn < 6) do
			goOn = 0
			for i=1,#data.AddPoint do
				local single = data.AddPoint[i]
				local cell = cellList[single.key]
				-- printRed(string.format("key:%s value:%s timeOfAdd:%s originTimeOfAdd:%s",single.key,single.value,cell.timeOfAdd,cell.originTimeOfAdd))
				if(cell.timeOfAdd+cell.originTimeOfAdd < pointTbData[single.key])then
					goOn = cell:addPoint(single.value) + goOn
				else
					goOn = goOn+1
				end			
			end
		end
	else
		printRed("error solutionId!!!")
	end
	for i=1,#cells do
		local single = cells[i]
		single:updateLeftPoint()
	end	
	self:updateTempData(true)
end
	
function AddPointPage:addViewEventListener()
	-- body	
	self:AddButtonEvent("solutionConfirmBtn",function ( )
		-- body
		local cells = self.centerGridList:GetCells()
		local changePoint = 0
		local mapData = {}
		for i=1,#cells do
			local single = cells[i]
			changePoint = changePoint +single.timeOfAdd
			mapData[single:GetAttrName()] = single.timeOfAdd
		end	
		if(changePoint == 0)then
			MsgManager.ShowMsgByIDTable(20)
			return
		end

		ServiceNUserProxy.Instance:CallAddAttrPoint(SceneUser2_pb.POINTTYPE_ADD,mapData["Str"], mapData["Int"], mapData["Agi"], mapData["Dex"], mapData["Vit"], mapData["Luk"]) 		
	end)
	self.centerGridList:AddEventListener(MouseEvent.MouseClick,self.updateTempData,self)
	self:AddButtonEvent("addPointSolutionBtn")
end

function AddPointPage:getPlayerData(  )
-- body
	local datas = {}
	local props 
	for i=1,#GameConfig.ClassInitialAttr do
		local single = GameConfig.ClassInitialAttr[i]
		local prop = Game.Myself.data.props[single];
		local extraP = MyselfProxy.Instance.extraProps[single]
		local data = {}
		data.prop = prop
		data.extraP = extraP
		data.timeOfAdd = Game.Myself.data.userdata:Get(AddPointPage.times[i]) or 0
		data.leftPoint = self.leftPoint
		table.insert(datas,data)
	end
	return datas
end

function AddPointPage:UpdateProps()
-- 	
	local currentProps = self:getPlayerData()
	local isResetData = false
	-- local currentValues = {}

	-- for i=1,#currentProps do
	-- 	local currentValue = currentProps[i].prop:GetValue()
	-- 	table.insert(currentValues,currentValue)		
	-- end

	-- if(self.lastValues ~= nil)then
	-- 	for i=1,#self.lastValues do			
	-- 		local value = self.lastValues[i]
	-- 		local currentValue = currentValues[i]
	-- 		local diff = currentValue - value
	-- 		if( diff ~= 0)then
	-- 			local name = currentProps[i].prop.propVO.displayName
	-- 			MsgManager.FloatMsg(nil,name.."   [87FF00]"..(diff>0 and "+" or "-")..tostring(diff).."[-]")
	-- 		end	
	-- 	end
	-- end
	local leftPt = Game.Myself.data.userdata:Get(UDEnum.TOTALPOINT) or 0
	local diff = leftPt - self.leftPoint.originLeftPoint

	if(diff ~= 0 and leftPt ~= self.leftPoint.currentLeftPoint)then
		isResetData = true
	end

	if(isResetData)then		
		self.leftPoint.currentLeftPoint = self.leftPoint.currentLeftPoint + diff		
	end	
	self.centerGridList:ResetDatas(currentProps)
	self.leftPoint.originLeftPoint = leftPt	
	-- self.lastValues = currentValues
	-- self.leftPointLabel.text = ZhString.Charactor_LeftPointLabel..self.leftPoint.currentLeftPoint;
	self.leftPointLabel.text = self.leftPoint.currentLeftPoint
end

function AddPointPage:updateTempData( fromSolution )
	-- body
	local cells = self.centerGridList:GetCells()
	local timeOfAdd = 0
	
	local addCoundMap = {}
	for i=1,#cells do
		local single = cells[i]
		timeOfAdd = timeOfAdd + single.timeOfAdd
		local countData = {}
		countData.totalCount = single.originTimeOfAdd + single.timeOfAdd
		countData.addCount = single.timeOfAdd
		-- printRed(addCount)
		-- printRed(single.timeOfAdd)
		-- printRed(single.originTimeOfAdd)
		-- print(single.data.prop.propVO.name)
		-- print(MyselfProxy.Instance:JobLevel())		
		-- local type = self.myself:GetCurOcc().professionData.Type
		-- print(type)
		-- print(single.data.prop.propVO.name)
		--calAttrPoint 计算出因六维属性而产生的成长属性即 (extra extra 属性即使成长属性)
		-- local value = CommonFun.calAttrPoint(addCount,MyselfProxy.Instance:JobLevel(),type,single.data.prop.propVO.name)
		addCoundMap[single:GetAttrName()] = countData
		-- addData[single.data.prop.propVO.id] = value	+ single.originRealPoint
		-- addData[single.data.prop.propVO.id] = value
		-- printRed("updateTempData",addData[single.data.prop.propVO.id],single.originRealPoint)
		single:updateLeftPoint()
	end

	local notifyData = {}
	notifyData.addCoundMap = nil
	notifyData.from = fromSolution
	if(timeOfAdd > 0)then
		self:disableConfirmMt(true)
		notifyData.addCoundMap = addCoundMap
	else	
		self:disableConfirmMt(false)
	end
	self:PassEvent(AddPointPage.addPointAction,notifyData)
	-- self.leftPointLabel.text = ZhString.Charactor_LeftPointLabel..self.leftPoint.currentLeftPoint;
	self.leftPointLabel.text = self.leftPoint.currentLeftPoint;
	-- if(self.leftPoint.currentLeftPoint < 2)then
		FunctionGuide.Me():attrPointCheck(self.leftPoint.currentLeftPoint)
	-- end
end

function AddPointPage:UpdateMyPropData(note)
	-- printRed("UpdateMyPropData")
	self:UpdateProps();
end

function AddPointPage:resetAttrPointDatas(  )
	-- body
	local cells = self.centerGridList:GetCells()
	for i=1,#cells do
		local single = cells[i]
		single:clearTimeOfAdd()
	end
	self:PassEvent(AddPointPage.addPointAction)
	self:disableConfirmMt(false)
end