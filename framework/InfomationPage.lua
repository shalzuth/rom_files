InfomationPage = class("InfomationPage",SubView)
autoImport("BaseAttributeMoneyCell")
autoImport("ProfessionInfoCell")
autoImport("XDECharBaseAttributeCell")
InfomationPage.addPointAction = "AddPointPage_addPointAction"


InfomationPage.CheckHasSelected = "InfomationPage_CheckHasSelected"
InfomationPage.HasSelectedChange = "InfomationPage_HasSelectedChange"

function InfomationPage:Init()
	self:initView()
	self:initData()
	self:UpdateUserInfo();
	self:addViewEventListener()
	self:AddListenerEvts()
end

function InfomationPage:initData(  )
	-- body
	self:AddOrRemoveGuideId("skillBtn", 9);
end

function InfomationPage:removeInfomations( name )
	for i=1,#self.infomations do
		if(name == self.infomations[i])then
			table.remove(self.infomations,i)
			break
		end
	end
end

function InfomationPage:initView( )
	-- body
	self.infomations = {unpack(GameConfig.InfoPageConfigs)}
	-- self.profeName = self:FindChild("professionNamePointPage"):GetComponent(UILabel);
	-- self.baseLevel = self:FindChild("baseLv"):GetComponent(UILabel);
	-- self.baseExp = self:FindChild("baseSlider"):GetComponent(UISlider);
	-- self.jobLevel = self:FindChild("jobLv"):GetComponent(UILabel);
	-- self.jobExp = self:FindChild("jobLevelSlider"):GetComponent(UISlider);
	self.leftPointLabel = self:FindChild("leftPointLabel"):GetComponent(UILabel)
	-- self.battlePoint = self:FindChild("fightPowerLabel"):GetComponent(UILabel)
	-- self.PlayerName = self:FindGO("PlayerName"):GetComponent(UILabel)
	-- self.PlayerId = self:FindGO("PlayerId"):GetComponent(UILabel)

	-- self.hpValue = self:FindGO("value",self:FindGO("HP")):GetComponent(UILabel)
	-- self.mpvalue = self:FindGO("value",self:FindGO("SP")):GetComponent(UILabel)

	self.attriGrid = self:FindGO("attriGrid"):GetComponent(UIGrid)

	self.attrList =  UIGridListCtrl.new(self.attriGrid,XDECharBaseAttributeCell,"BaseAttributeCell")
	self.attrList:AddEventListener(InfomationPage.CheckHasSelected, self.CheckHasSelected, self);
	self.attrList:AddEventListener(InfomationPage.HasSelectedChange, self.HasSelectedChange, self);
	if(not FunctionUnLockFunc.Me():CheckCanOpen(75))then
		-- self:removeInfomations("SaveHp")
		-- self:removeInfomations("SaveHpDes")
		-- self:removeInfomations("SaveSp")
		-- self:removeInfomations("SaveSpDes")
		-- self:removeInfomations("SlimHeight")
		-- self:removeInfomations("SlimWeight")
		-- self:removeInfomations("Satiety")
	end
	self.attrList:SetEmptyDatas(#self.infomations+2)
	self.line = self:FindGO("attriGridLine")
	self.line2 = self:FindGO("line2")
	self:Hide(self.line2)

	local infoGridCp = self:FindGO("infoGrid"):GetComponent(UIGrid)
	self.infoGridCt = self:FindGO("infoGridCt")	
	self.infoGrid =  UIGridListCtrl.new(infoGridCp ,BaseAttributeMoneyCell,"BaseAttributeMoneyCell")

	local grid = self:FindGO("professionGrid"):GetComponent(UIGrid)
	self.professionInfoGrid = UIGridListCtrl.new(grid,ProfessionInfoCell,"ProfessionInfoCell")
	
	-- self.professionInfoGrid:SetEmptyDatas(12)
	local skillBtnLabel = self:FindGO("skillBtnLabel"):GetComponent(UILabel)
	self.skillBtn = self:FindGO("skillBtn")
	skillBtnLabel.text = ZhString.Charactor_ViewSkill
	self:RegistRedTip();
end

local tempVector3 = LuaVector3.zero

function InfomationPage:CheckHasSelected(cellCtr)
	if(cellCtr and cellCtr.data)then
		local data = cellCtr.data
		local userData = Game.Myself.data.userdata
		if(userData)then
			local opt = userData:Get(UDEnum.OPTION) or 0
			local optType 
			local desCell
			if (data.prop.propVO.name == "SaveHp")then
				optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP
				desCell = self:getCellByCellName("SaveHpDes")
			elseif (data.prop.propVO.name == "SaveSp")then
				optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP
				desCell = self:getCellByCellName("SaveSpDes")
			end
			if(opt and BitUtil.band(opt,optType)>0)then
				cellCtr:setIsSelected(true)
			else
				cellCtr:setIsSelected(false)
			end	
		end
	end
end

function InfomationPage:CheckDesColor()
	local cells = self.attrList:GetCells()
	local userData = Game.Myself.data.userdata
	local opt = userData:Get(UDEnum.OPTION) or 0
	for i=1,#cells do
		local cellCtr = cells[i]
		if(cellCtr.data)then
			local data = cellCtr.data
			local optType 
			if (data.name == "SaveHpDes")then
				optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP
				local ret = BitUtil.band(opt,optType)
				if(ret>0)then
					cellCtr:whiteValueText()
				else
					cellCtr:greyValueText()
				end	
			elseif (data.name == "SaveSpDes")then
				optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP
				local ret = BitUtil.band(opt,optType)
				if(ret>0)then
					cellCtr:whiteValueText()
				else
					cellCtr:greyValueText()
				end
			end
		end
	end
end

function InfomationPage:getCellByCellName(name)
	local cells = self.attrList:GetCells()
	for i=1,#cells do
		local single = cells[i]
		if(single.data and single.data.name and single.data.name == name)then
			return single	
		end
	end
end

function InfomationPage:HasSelectedChange(cellCtr)
	if(cellCtr and cellCtr.data)then
		local ret = cellCtr:IsSelected()
		local data = cellCtr.data
		local optType
		if (data.prop.propVO.name == "SaveHp")then
			optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP
		elseif (data.prop.propVO.name == "SaveSp")then
			optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP
		end

		if(ret)then
			ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(optType, 0) 
		else
			ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(optType, 1) 
		end
	end
end

function InfomationPage:AddListenerEvts()
	self:AddListenEvt(MyselfEvent.MyPropChange,self.UpdateUserInfo)
	self:AddListenEvt(MyselfEvent.MyDataChange,self.UpdateUserInfo)
	-- self:AddListenEvt(MyselfEvent.JobExpChange, self.UpdateJobSlider)
	-- self:AddListenEvt(MyselfEvent.BaseExpChange, self.UpdateExpSlider)
	self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateMyProfession)
end
	
function InfomationPage:addViewEventListener()
	-- body		
	self:AddButtonEvent("skillBtn",function ( obj )
		-- body
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.CharactorProfessSkill})
	end)
end

function InfomationPage:RegistRedTip()
	local portraitObj = self:FindGO("PlayerHeadCell");
	if(portraitObj)then
		self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ROLE_IMG, portraitObj ,nil,{-15, -15});
		self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MONSTER_IMG , portraitObj ,nil,{-15, -15});
		self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PHOTOFRAME , portraitObj ,nil,{-15, -15});
	end
end

function InfomationPage:UpdateMyProfession()
	-- printRed("InfomationPage UpdateMyProfession")
	-- self.container:UpdateJobSlider()
	-- local ps = Game.Myself.data.occupations
	-- -- local cells = self.professionInfoGrid:GetCells()
	-- local list = {}
	-- for i=1,#ps do
	-- 	local single = ps[i]
	-- 	if(single.profession ~= 1)then
	-- 		table.insert(list,single)
	-- 	end
	-- end
	-- if(list~=nil)then
	-- 	self.professionInfoGrid:ResetDatas(list)
	-- end	
end

function InfomationPage:UpdateUserInfo()
	-- self:UpdateExpSlider();
	-- self:UpdateJobSlider();
	-- self:UpdateHead();
	self:UpdateProps()
	self:UpdateMyProfession();	
end

function InfomationPage:UpdateProps(  )
	-- -- body
	-- helplog("UpdateProps")
	-- self.PlayerId.text = ZhString.Charactor_PlayerID..self.myself.id
	-- self.PlayerId.text = self.myself.id
	-- self.PlayerName.text = self.myself.name
	local cells = self.attrList:GetCells()
	local userData = Game.Myself.data.userdata

	for i=1,#self.infomations do
		local single = self.infomations[i]		
		local data = {}
		if(single == "SaveHpDes")then
			data.type = BaseAttributeView.cellType.saveHpSp
			data.value = ZhString.Charactor_HPEnergyDes
			data.name = single
			local cell = cells[i]
			cell:SetData(data)
			cell:Hide(cell.line)
		elseif(single == "SaveSpDes")then
			data.type = BaseAttributeView.cellType.saveHpSp
			data.value = ZhString.Charactor_SPEnergyDes
			data.name = single
			local cell = cells[i]
			cell:SetData(data)
			cell:Hide(cell.line)
		elseif(single == "Satiety")then
			local foods = FoodProxy.Instance:GetEatFoods()
			local cur = foods and #foods or 0
			local curLv = userData:Get(UDEnum.TASTER_LV) or 0
			local tbData = Table_TasterLevel[curLv]
			local progress = 1
			if(tbData)then
				progress = tbData.AddBuffs
			else
				progress = GameConfig.Food.MaxSatiety_Default or 80
				----[[ todo xde 0002153: 料理功能未解锁时，角色信息界面下料理有效堆叠层数显示最大80层
				progress = GameConfig.Food.MaxLimitFood_Default or 80
				--]]
			end

			data.type = BaseAttributeView.cellType.jobBase
			data.value = cur.."/"..progress
			data.name = ZhString.Charactor_SatieTyDes
			local cell = cells[i]
			cell:SetData(data)
			cell:Hide(cell.line)
		else			
			local prop = Game.Myself.data.props[single]
			local extra = MyselfProxy.Instance.extraProps[single]
			data.prop = prop
			data.extraP = extra
			data.type = BaseAttributeView.cellType.normal
			local cell = cells[i]
			cell:SetData(data)
			cell:Hide(cell.line)
		end
	end
	local baseCell = cells[#self.infomations+1]
	local data = {}	
	local userData = Game.Myself.data.userdata
	local roleExp = userData:Get(UDEnum.ROLEEXP) or 0;
	local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL) or 0;
	local referenceValue = Table_BaseLevel[nowRoleLevel+1];
	if(referenceValue == nil)then
		referenceValue = roleExp;
	else
		referenceValue = referenceValue.NeedExp;
	end
	data.type = BaseAttributeView.cellType.jobBase
	data.value = roleExp.."/"..referenceValue
	data.name = "Base";
	baseCell:SetData(data)

	baseCell = cells[#self.infomations+2] 

	local nowJob = Game.Myself.data:GetCurOcc();  --self.myself.userData:Get(UDEnum.JOBLEVEL);
	if(nowJob == nil)then
		return;
	end
	referenceValue = Table_JobLevel[nowJob.level+1];
	if(referenceValue == nil)then
		referenceValue = nowJob.exp;
	else
		referenceValue = referenceValue.JobExp;
	end
	data.type = BaseAttributeView.cellType.jobBase
	data.value = nowJob.exp.."/"..referenceValue
	data.name = "Job";
	baseCell:SetData(data)

	self.attrList:Layout()
	local bound = NGUIMath.CalculateRelativeWidgetBounds(self.attriGrid.transform,true);
	tempVector3:Set(LuaGameObject.GetLocalPosition(self.attriGrid.transform))
	local y = tempVector3.y - bound.size.y
	tempVector3:Set(LuaGameObject.GetLocalPosition(self.infoGridCt.transform))
	tempVector3:Set(tempVector3.x,y - 5,tempVector3.z)
	self.infoGridCt.transform.localPosition = tempVector3
	self.infoGrid:ResetDatas(GameConfig.Charactor_InfoShow)

	-- bound = NGUIMath.CalculateRelativeWidgetBounds(self.infoGridCp.transform,true);
	-- tempVector3:Set(LuaGameObject.GetLocalPosition(self.infoGridCp.transform))
	-- y = tempVector3.y - bound.size.y
	-- tempVector3:Set(LuaGameObject.GetLocalPosition(self.line2.transform))
	-- tempVector3:Set(tempVector3.x,y,tempVector3.z)
	-- self.line2.transform.localPosition = tempVector3
	-- tempVector3:Set(LuaGameObject.GetLocalPosition(self.professionInfoGrid.layoutCtrl.transform))
	-- local _,posY = LuaGameObject.GetLocalPosition(self.line2.transform)
	-- y = posY - 33
	-- tempVector3:Set(tempVector3.x,y,tempVector3.z)
	-- self.professionInfoGrid.layoutCtrl.transform.localPosition = tempVector3

	-- if(self.myself:IsTransformed())then
	-- 	self:Hide(self.skillBtn)
	-- else
	-- 	self:Show(self.skillBtn)
	-- end
	FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.Charactor.id, self.skillBtn);
	self:CheckDesColor()
	-- local curHp = MyselfProxy.Instance.myself.props.Hp:GetValue()
	-- local maxHp = MyselfProxy.Instance.myself.props.MaxHp:GetValue()

	-- local curSp = self.myself.props["Sp"]:GetValue() 
	-- local maxSp = self.myself.props["MaxSp"]:GetValue()

	-- self.hpValue.text = curHp.."/"..maxHp
	-- self.mpvalue.text = curSp.."/"..maxSp	
end
