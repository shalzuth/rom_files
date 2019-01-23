autoImport("BaseTip");
autoImport("SkillSpecialCell");
SkillTip = class("SkillTip" ,BaseTip)

SkillTip.MinHeight = 250
SkillTip.MaxHeight = 512

local tmpPos = LuaVector3(0,0,0)
local sb = LuaStringBuilder.new()
function SkillTip:Init()
	self.calPropAffect = true
	self:FindObjs();

	self.closecomp = self.gameObject:GetComponent(CustomTouchUpCall);
	self.closecomp.call = function (go)
		self:CloseSelf();
	end
end

function SkillTip:SetCheckClick(func)
	if(self.closecomp) then
		self.closecomp.check = function ()
			return func~=nil and func() or false
		end
	end
end

function SkillTip:GetCreature()
	return Game.Myself
end

function SkillTip:FindObjs()
	self.topAnchor = self:FindGO("Top"):GetComponent(UIWidget)
	self.centerBg = self:FindGO("CenterBg"):GetComponent(UIWidget)
	self.scrollView = self:FindGO("ScrollView"):GetComponent(UIPanel)
	self.scroll = self:FindGO("ScrollView"):GetComponent(UIScrollView)
	self:AddToUpdateAnchors(self:FindGO("TopBound"):GetComponent(UIWidget))
	self:AddToUpdateAnchors(self:FindGO("BottomBound"):GetComponent(UIWidget))
	self:AddToUpdateAnchors(self.topAnchor)
	self:AddToUpdateAnchors(self.centerBg)
	self:AddToUpdateAnchors(self.scrollView)
	self:FindTitleUI()
	self:FindCurrentUI()
	self:FindNextUI()
	self:FindFunc()
end

function SkillTip:AddToUpdateAnchors(uirect)
	if(self.anchors ==nil) then
		self.anchors = {}
	end
	self.anchors[#self.anchors+1] = uirect
end

function SkillTip:UpdateAnchors()
	if(self.anchors) then
		for i=1,#self.anchors do
			self.anchors[i]:ResetAndUpdateAnchors()
		end
	end
end

function SkillTip:FindTitleUI()
	self.container = self:FindGO("Container")
	self.bg = self:FindGO("Bg"):GetComponent(UISprite)
	self.labelContainer = self:FindGO("Labels")
	self.icon = self:FindGO("SkillIcon"):GetComponent(UISprite)
	self.skillName = self:FindGO("SkillName"):GetComponent(UILabel)
	self.skillLevel = self:FindGO("SkillLevel"):GetComponent(UILabel)
	self.skillType = self:FindGO("SkillType"):GetComponent(UILabel)
end

function SkillTip:FindCurrentUI()
	self.currentInfo = self:FindGO("CurrentInfo"):GetComponent(UILabel)
	local specialInfoGO = self:FindGO("SpecialInfo")
	if(specialInfoGO) then
		self.specialInfo = specialInfoGO:GetComponent(UILabel)
	end
	self.currentCD = self:FindGO("CurrentCD"):GetComponent(UILabel)
	self.useCount = self:FindGO("UsedCount"):GetComponent(UILabel)
	self.labels = self.labels or {}
	local padding = 15
	self.labels[#self.labels+1] = {label=self.currentInfo,paddingY = padding}
	if(self.specialInfo) then
		self.labels[#self.labels+1] = {label=self.specialInfo,paddingY = padding}
	end
	self.labels[#self.labels+1] = {label=self.useCount,paddingY = 0}
	self.labels[#self.labels+1] = {label=self.currentCD,paddingY = padding}
end

function SkillTip:FindNextUI()
	self.sperator = self:FindGO("Sperate"):GetComponent(UILabel)
	self.condition = self:FindGO("Condition"):GetComponent(UILabel)
	self.nextInfo = self:FindGO("NextInfo"):GetComponent(UILabel)
	self.nextCD = self:FindGO("NextCD"):GetComponent(UILabel)
	self.labels = self.labels or {}
	local padding = 15
	self.labels[#self.labels+1] = {label=self.sperator,paddingY = 0}
	self.labels[#self.labels+1] = {label=self.condition,paddingY = padding}
	self.labels[#self.labels+1] = {label=self.nextInfo,paddingY = padding}
	self.labels[#self.labels+1] = {label=self.nextCD,paddingY = 0}
end

function SkillTip:FindFunc()
	self.funcGO = self:FindGO("Func")
	if(self.funcGO) then
		self.downBg = self:FindGO("DownBg"):GetComponent(UISprite)
		self.funcWidget = self.funcGO:GetComponent(UIWidget)
		self:AddToUpdateAnchors(self.funcWidget)
		self.funcLable = self:FindGO("FuncLabel",self.funcGO):GetComponent(UILabel)
		self.funcCheck = self:FindGO("FuncCheckMark",self.funcGO)
		self:AddButtonEvent("FuncCheck",function ()
			if not SkillProxy.Instance:IsMultiSave() then
				self.funcCheck:SetActive(not self.funcCheck.activeSelf)
			end
		end)

		self.specialBg = self:FindGO("DownBg2"):GetComponent(UISprite)
		self.specialLabel = self:FindGO("RuneSpecialTitle",self.funcGO):GetComponent(UILabel)
		self.specialLabel.text = ZhString.SkillTip_RuneSpecialEnabelTitle
		self.specialCheck = self:FindGO("SpecialCheckMark",self.funcGO)
		self:AddButtonEvent("SpecialCheck",function ()
			if not SkillProxy.Instance:IsMultiSave() then
				self.specialCheck:SetActive(not self.specialCheck.activeSelf)
				self:_HandleSpecialCellsEnable()
				self:_HandleSpecials()
			end
		end)

		self.specialGrid = self:FindGO("Specials"):GetComponent(UIGrid)
		self.specialList = ListCtrl.new(self.specialGrid,SkillSpecialCell,"SkillSpecialCell")
		self.specialList:AddEventListener(MouseEvent.MouseClick,self.ClickSpecialEffect,self)

		self.optionBg = self:FindGO("DownBg3"):GetComponent(UISprite)
		self.optionGrid = self:FindGO("Options"):GetComponent(UIGrid)
		self.optionList = ListCtrl.new(self.optionGrid,SkillSpecialCell,"SkillSpecialCell")
		self.optionList:AddEventListener(MouseEvent.MouseClick,self.ClickSelectOption,self)
	end
end

-- function SkillTip:NormalSkillOptionChangeHandler()
-- 	if(self.funcCheck) then
-- 		self.funcCheck:SetActive(MyselfProxy.Instance.selectAutoNormalAtk)
-- 	end
-- end

function SkillTip:_HandleSpecialCellsEnable()
	local enabled = self.specialCheck.activeSelf
	local cells = self.specialList:GetCells()
	if(cells) then
		for i=1,#cells do
			cells[i]:SetEnable(enabled)
		end
	end
end

function SkillTip:_GetSelectedSpecialCell(id)
	return self:_GetSelectedCell(self.specialList,id)
end

function SkillTip:_GetSelectedOptionCell(id)
	return self:_GetSelectedCell(self.optionList,id)
end

function SkillTip:_GetSelectedCell(list,id)
	local cells = list:GetCells()
	if(cells) then
		for i=1,#cells do
			if(cells[i]:IsSelect() or id == cells[i].data.id) then
				return cells[i]
			end
		end
	end
	return nil
end

function SkillTip:ClickSpecialEffect(cell)
	local previousSelect = self:_GetSelectedSpecialCell()
	if(previousSelect==nil or cell.data.id~=previousSelect.data.id) then
		if(previousSelect) then
			previousSelect:UnSelect()
		end
		cell:Select()
		self:_HandleSpecials()
	end
end

function SkillTip:ClickSelectOption(cell)
	local previousSelect = self:_GetSelectedOptionCell()
	if(previousSelect==nil or cell.data.id~=previousSelect.data.id) then
		if(previousSelect) then
			previousSelect:UnSelect()
		end
		cell:Select()
	end
end

function SkillTip:_HandleSpecials()
	local specialText = self:HandleRunSpecials()
	if(specialText==nil) then
		self:Hide(self.specialInfo.gameObject)
	else
		self:Show(self.specialInfo.gameObject)
		self.specialInfo.text = specialText
	end
end

function SkillTip:CloseSelf()
	TimeTickManager.Me():ClearTick(self)
	TipsView.Me():HideCurrent();
end

function SkillTip:GetCondition(skillData,nextID)
	return ConditionUtil.GetSkillConditionStr(not self.data.learned and skillData or Table_Skill[nextID],true)
end

function SkillTip:SetData(data)
	if(self.data~=nil) then
		self:_CheckSpecialModified()
	end
	self.data = data.data
	local skillData = self.data:GetExtraStaticData() or self.data.staticData
	self:UpdateCurrentInfo(skillData)
	self:ShowHideFunc()
	local nextID = self.data:GetNextID(MyselfProxy.Instance:HasJobBreak(),skillData)
	if(nextID and self.data.profession ~= 1 or not self.data.learned) then
		self:Show(self.condition.gameObject)
		if(self.data.learned) then
			self.sperator.text = ZhString.SkillTip_NextLevelSperator
			self:Show(self.sperator.gameObject)
			self:Show(self.nextInfo.gameObject)
			self:Show(self.nextCD.gameObject)
			local nextData = Table_Skill[nextID]
			self.nextInfo.text = self:GetDesc(nextData)
			self.nextCD.text = self:GetCD(nextData)
		else
			self:Hide(self.nextInfo.gameObject)
			self:Hide(self.nextCD.gameObject)
			self:Hide(self.sperator.gameObject)
		end
		
		self.condition.text = self:GetCondition(skillData,nextID)
	else
		self:Hide(self.sperator.gameObject)
		self:Hide(self.nextInfo.gameObject)
		self:Hide(self.nextCD.gameObject)
		self:Show(self.condition.gameObject)
		if(skillData.Cost==0 or self.data.profession == 1) then
			self.condition.text = ZhString.SkillTip_CannotLevelUpSperator
		else
			self.condition.text = ZhString.SkillTip_LevelMaxSperator
		end
	end
	if(self.condition.text=="" or self.condition.text ==nil) then
		-- self:Hide(self.condition.gameObject)
	end
	local layoutHeight = self:Layout()
	local height = math.max(math.min(layoutHeight+190,SkillTip.MaxHeight),SkillTip.MinHeight)
	self.bg.height = height
	self:UpdateAnchors()
	self.scroll:ResetPosition()
	self.skillInfo = nil
	self.closecomp.enabled = false
	self.closecomp.enabled = true
end

local none_opt = 0
local normalAtkCheck_opt = 1
local skillautoQueue_opt = 2
function SkillTip:ShowHideFunc()
	local bg1Height = self:_ShowHideNormalFunc()
	bg1Height = self:_ShowHideOptions(bg1Height)
	self:_ShowHideRuneFunc(bg1Height)
end

function SkillTip:_ShowHideNormalFunc()
	local bg1Height = 0
	local func = self.downBg
	--TODO
	self.funcCheck_opt = none_opt
	if(self.data) then
		if(self.data.id == Game.Myself.data:GetAttackSkillIDAndLevel()) then
			self.funcCheck_opt = normalAtkCheck_opt
			if(self.funcLable) then
				self.funcLable.text = ZhString.SkillTip_NormalAtkLabel
			end
		elseif(GameConfig.SkillAutoQueueID and self.data.id == GameConfig.SkillAutoQueueID[1]) then
			self.funcCheck_opt = skillautoQueue_opt
			if(self.funcLable) then
				self.funcLable.text = GameConfig.SkillAutoQueueID[2]
			end
		end
	end
	if self.data:CheckFuncOpen(SkillItemData.FuncType.Normal) then
		if(func) then
			bg1Height = 55
			func.gameObject:SetActive(true)
		end
	else
		if(func) then
			func.gameObject:SetActive(false)
		end
	end

	if(self.funcCheck) then
		if(self.funcCheck_opt == normalAtkCheck_opt) then
			self.funcCheck:SetActive(MyselfProxy.Instance.selectAutoNormalAtk)
		elseif(self.funcCheck_opt == skillautoQueue_opt)then
			self.funcCheck:SetActive(Game.SkillOptionManager:GetSkillOption_AutoQueue() == 0)
		end
	end
	return bg1Height
end

function SkillTip:_ShowHideOptions(bg1Height)
	if(self.data) then
		-- summon beings
		local downBg3 = self.optionBg
		if self.data:CheckFuncOpen(SkillItemData.FuncType.Option) then
			local datas
			local being = self.data.staticData.Logic_Param.being_ids
			if being then
				datas = {}
				for i=1,#being do
					local data = {id=being[i]}
					data.RuneName = string.format(ZhString.SkillTip_OptionSummon,Table_Being[data.id].Name)
					datas[#datas+1] = data
				end
			end
			if(downBg3) then
				downBg3.gameObject:SetActive(true)
			end
			local height = 53
			height = height + (#datas * 40)
			downBg3.height = height
			tmpPos:Set(0,(height+bg1Height)/2-20,0)
			self.container.transform.localPosition = tmpPos
			local x,y,z = LuaGameObject.GetLocalPosition(downBg3.transform)
			tmpPos:Set(x,35 - bg1Height,z)
			downBg3.transform.localPosition = tmpPos
			self.optionList:ResetDatas(datas)
			--初始化选中
			local beingID = Game.SkillOptionManager:GetSkillOption_SummonBeing()
			if(beingID==0) then
				beingID = datas[1].id
			end
			local cell = self:_GetSelectedOptionCell(beingID)
			if(cell) then
				cell:Select()
			end
		else
			if(downBg3) then
				downBg3.gameObject:SetActive(false)
			end
		end
	end
	return bg1Height
end

function SkillTip:_ShowHideRuneFunc(bg1Height)
	if(self.data) then
		local downBg2 = self.specialBg
		if self.data:CheckFuncOpen(SkillItemData.FuncType.Rune) then
			if(self.specialCheck) then
				self.specialCheck:SetActive(self.data:GetEnableSpecialEffect())
			end
			if(downBg2) then
				downBg2.gameObject:SetActive(true)
			end
			local height = 93
			local selectSpecials = self.data:GetRuneSelectSpecials()
			height = height + (#selectSpecials * 40)
			downBg2.height = height
			tmpPos:Set(0,(height+bg1Height)/2-20,0)
			self.container.transform.localPosition = tmpPos
			local x,y,z = LuaGameObject.GetLocalPosition(downBg2.transform)
			tmpPos:Set(x,35 - bg1Height,z)
			downBg2.transform.localPosition = tmpPos
			self.specialList:ResetDatas(selectSpecials)
			--初始化选中
			local cell = self:_GetSelectedSpecialCell(self.data:GetSpecialID())
			if(cell) then
				cell:Select()
			end
			self:_HandleSpecialCellsEnable()
		else
			if(downBg2) then
				downBg2.gameObject:SetActive(false)
			end
		end
		self:_HandleSpecials()
	end
end

function SkillTip:UpdateCurrentInfo(skillData)
	skillData = skillData or self.data.staticData
	IconManager:SetSkillIconByProfess(skillData.Icon, self.icon,MyselfProxy.Instance:GetMyProfessionType(),true)
	self.skillName.text = skillData.NameZh
	UIUtil.WrapLabel(self.skillName)
	local infoData = skillData
	sb:Clear()
	if(self.data and skillData.SkillType == SkillType.Function and self.data:GetReplaceID() and self.data:GetReplaceID()>0) then
		infoData = Table_Skill[self.data:GetReplaceID()]
		sb:Append(infoData.NameZh)
		sb:Append("  Lv.")
		sb:AppendLine(infoData.Level)
	end
	sb:Append(self:GetDesc(infoData))
	self.currentInfo.text = sb:ToString()
	self.currentCD.text = self:GetCD(infoData)
	if(self.data.learned) then
		if(self.data:GetExtraLevel()==0) then
			self.skillLevel.text = "Lv."..skillData.Level
		else
			self.skillLevel.text = string.format(ZhString.SkillView_LevelExtra,self.data.level, self.data:GetExtraLevel())
		end
	else
		if(self.data:GetExtraLevel()==0) then
			self.skillLevel.text = "Lv.1"
		else
			self.skillLevel.text = string.format(ZhString.SkillView_LevelExtra,1, self.data:GetExtraLevel())
		end
	end
	self.skillLevel:UpdateAnchors()
	if(self.data.maxTimes and self.data.maxTimes>0) then
		self:Show(self.useCount.gameObject)
		self:UpdateUseTimes()
		if(self.data.leftTimes<self.data.maxTimes) then
			TimeTickManager.Me():CreateTick(0,1000,self.UpdateUseTimes,self)
		else
			TimeTickManager.Me():ClearTick(self)
		end
	else
		TimeTickManager.Me():ClearTick(self)
		self:Hide(self.useCount.gameObject)
	end
	self.skillType.text = GameConfig.SkillType[skillData.SkillType].name
end

function SkillTip:UpdateUseTimes()
	local deltaTime = ServerTime.ServerDeltaSecondTime(self.data.timeRecoveryStamp)
	if(deltaTime>0 and self.data.leftTimes< self.data.maxTimes) then
		self.useCount.text = string.format(ZhString.SkillTip_LeftValuesRefresh,self.data.leftTimes,self.data.maxTimes,DateUtil.ParseHHMMSSBySeconds(deltaTime).."秒")
	else
		self.useCount.text = string.format(ZhString.SkillTip_LeftValues,self.data.leftTimes,self.data.maxTimes)
	end
end

function SkillTip:GetCD(skillData)
	self.skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillData.id)
	local strArr = {}
	local str = ""
	local range = self:GetSkillParam(skillData,"Launch_Range",nil,self.skillInfo.GetLaunchRange,ZhString.SkillTip_LaunchRange)
	if(range) then
		strArr[#strArr+1] = range
	end
	strArr[#strArr+1] = self:GetCastTime(skillData)
	--CD时间
	local realcd = self.skillInfo:GetCD(self:GetCreature())
	if(realcd) then
		if(skillData.Logic_Param and skillData.Logic_Param.real_cd) then
			strArr[#strArr+1] = self:GetSkillParam(skillData,"Logic_Param","real_cd",self.skillInfo.GetLogicRealCD,ZhString.SkillTip_CDTime)
		else
			strArr[#strArr+1] = self:GetSkillParam(skillData,"CD",nil,self.skillInfo.GetCD,ZhString.SkillTip_CDTime)
		end
	end
	--公共延迟
	local realDelayCD = self.skillInfo:GetDelayCD(self:GetCreature())
	if(realDelayCD) then
		strArr[#strArr+1] = self:GetSkillParam(skillData,"DelayCD",nil,self.skillInfo.GetDelayCD,ZhString.SkillTip_DelayCDTime,nil)
	end
	local cost = self:GetCost(skillData)
	if(cost~="") then
		strArr[#strArr+1] = cost
	end
	for i=1,#strArr do
		str = str..strArr[i]..(i~=#strArr and "\n" or "")
	end
	return str
end

function SkillTip:GetDynamicSkillInfo(id)
	return self:GetCreature().data:GetDynamicSkillInfo(id)
end

local itemCostTmp = {}
function SkillTip:GetCost(skillData)
	sb:Clear()
	self.skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillData.id)
	local costStr
	local spcost,hpcost
	--sp
	local realSp = self.skillInfo:GetSP(self:GetCreature())
	if(realSp) then
		spcost = self:GetSkillParam(skillData,"SkillCost","sp",self.skillInfo.GetSP,ZhString.SkillTip_SPCost,0)
	end
	if(spcost) then
		sb:AppendLine(spcost)
	end
	--hp
	local realHp = self.skillInfo:GetHP(self:GetCreature())
	if(realHp) then
		hpcost = self:GetSkillParam(skillData,"SkillCost","hp",self.skillInfo.GetHP,ZhString.SkillTip_HPCost,0)
	end
	if(hpcost) then
		sb:AppendLine(hpcost)
	end
	local dynamicSkillInfo = self:GetDynamicSkillInfo(skillData.id)
	local costs = skillData.SkillCost
	local needItem = ""
	TableUtility.TableClear(itemCostTmp)
	if(#costs>0) then
		local item,buff
		local specialCost
		for i=1,#costs do
			specialCost = costs[i]
			if(specialCost.itemID) then
				itemCostTmp[specialCost.itemID] = 1
				needItem = self:_FormatItemCostDesc(needItem,specialCost.itemID,dynamicSkillInfo,specialCost.num)
			end
			if(specialCost.buffID) then
				buff = Table_Buffer[specialCost.buffID]
				if(buff) then
					local msg
					msg = string.format(ZhString.SkillTip_BuffCost.normal,buff.BuffName,specialCost.num)
					if(needItem=="") then
						needItem = msg
					else
						needItem = needItem..ZhString.SkillTip_NeedSpecialSplit..msg
					end
				end
			end
		end
		if(dynamicSkillInfo~=nil) then
			if(dynamicSkillInfo:HasItemCostChange()) then
				for k,v in pairs(dynamicSkillInfo.costs) do
					if(itemCostTmp[k]==nil) then
						needItem = self:_FormatItemCostDesc(needItem,k,dynamicSkillInfo,0)
					end
				end
			end
		end
		sb:AppendLine(string.format(ZhString.SkillTip_NeedSpecialCost,needItem))
	elseif(dynamicSkillInfo~=nil) then
		if(dynamicSkillInfo:HasItemCostChange()) then
			local handled = false
			for k,v in pairs(dynamicSkillInfo.costs) do
				if(itemCostTmp[k]==nil) then
					handled = true
					needItem = self:_FormatItemCostDesc(needItem,k,dynamicSkillInfo,0)
				end
			end
			if(handled) then
				sb:AppendLine(string.format(ZhString.SkillTip_NeedSpecialCost,needItem))
			end
		end
	end
	sb:RemoveLast()
	costStr = sb:ToString()
	sb:Clear()
	return costStr
end

function SkillTip:_FormatItemCostDesc(str,itemID,dynamicSkillInfo,originNum)
	local item = Table_Item[itemID]
	if(item) then
		local changed = originNum
		if(dynamicSkillInfo) then
			changed = dynamicSkillInfo:GetItemNewCost(item.id,changed)
		end

		local msg
		if(changed == originNum) then
			msg = string.format(ZhString.SkillTip_ItemCost.normal,item.NameZh,originNum)
		else
			local delta = changed- originNum
			if(delta<0) then
				msg = ZhString.SkillTip_ItemCost.buff
			else
				msg = ZhString.SkillTip_ItemCost.debuff
				delta = "+"..tostring(delta)
			end
			msg = string.format(msg,item.NameZh,originNum,delta)
		end

		if(str=="") then
			str = msg
		else
			str = str..ZhString.SkillTip_NeedSpecialSplit..msg
		end
	end
	return str
end

local roundOff = function (num, n)
    if n > 0 then
        local scale = math.pow(10, n-1)
        return math.floor(num / scale + 0.5) * scale
    elseif n < 0 then
        local scale = math.pow(10, n)
        return math.floor(num / scale + 0.5) * scale
    elseif n == 0 then
        return num
    end
end

local fact = 1000
function SkillTip:_Float1(value,_fact)
	-- helplog("_Float1",value)
	local res = math.abs(value)
	res = roundOff(res,1)/_fact
	res = math.floor( res * 10 )/10
	-- helplog("_Float1",res)
	if(value<0) then
		return -res
	end
	return res
end

--skillData:技能静态数据Table_Skill ,orignParam:技能数据中得字段名 ,fixFunc:计算公式函数要求两个参数第一个为RoleAgent第二个为技能数据
--originZhString 默认数值的字符串 , fixedZhString有修正数据的字符串,floatX几位小数默认1位小数
function SkillTip:GetSkillParam(skillData,orignParam1,orignParam2,fixFunc,originZhString,floatX)
	local originValue = skillData[orignParam1]
	if(floatX==nil) then
		floatX = 1
	end
	local aroundZero = 1/(math.pow(10,floatX))
	if(orignParam2 and originValue) then
		originValue = originValue[orignParam2]
	end

	local realValue
	if(fixFunc~=nil and self.calPropAffect) then
		realValue = fixFunc(self.skillInfo,self:GetCreature())
	else
		realValue = originValue
	end
	if(originValue or realValue) then
		originValue = originValue or 0
		if(realValue>0 or originValue>0) then
			if(floatX >0) then
				originValue = roundOff(originValue,-3)
				realValue = roundOff(realValue,-3)
			end
			local fixed = realValue-originValue
			-- helplog(realValue,originValue,fixed)
			if(originValue==realValue or math.abs(fixed)<aroundZero) then
				return string.format(originZhString.normal,originValue)
			else
				fixed = realValue*fact-originValue*fact
				local signal = ""
				local msg = originZhString.buff
				if(fixed<0 and (fixed/fact + originValue)<0) then
					msg = originZhString.buff
					--如果算出来的修正值为负数，并且修正值的绝对值比原值大，则修正值如下处理
					fixed = -originValue
				elseif(fixed>0) then
					msg = originZhString.debuff
					signal = "+"
				end
				return string.format(msg,originValue,signal, self:_Float1(fixed,fact))
			end
		end
	end
	return nil
end

function SkillTip:GetCastTime(skillData)
	--吟唱时间（法系）
	self.skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillData.id)
	local leadType = skillData.Lead_Type
	if(leadType and leadType.type and leadType.type ==SkillCastType.Magic) then
		local castTime = leadType.CCT + leadType.FCT
		local realCastTime = self.skillInfo:GetCastInfo(self:GetCreature())
		if(not self.calPropAffect) then
			realCastTime = castTime
		end
		castTime = roundOff(castTime,-3)
		realCastTime = roundOff(realCastTime,-3)
		local delta = realCastTime-castTime
		if(realCastTime==castTime or math.abs(delta)<0.1) then
			return string.format(ZhString.SkillTip_CastTime.normal,castTime)
		else
			local signal = ""
			local msg
			delta = realCastTime*fact-castTime*fact
			if(delta>0) then 
				msg = ZhString.SkillTip_CastTime.debuff
				signal = "+"
			else
				msg = ZhString.SkillTip_CastTime.buff
			end
			return string.format(msg,castTime,signal,self:_Float1(delta,fact))
		end
	end
end

function SkillTip:Layout()
	local label,lastLabel
	lastLabel = self.labels[1]
	local height = lastLabel.label.height
	local pos
	local labelHeight = height
	local lastLabelHeight
	for i=2,#self.labels do
		if(self.labels[i-1].label.gameObject.activeSelf) then
			lastLabel = self.labels[i-1]
			pos = lastLabel.label.transform.localPosition
			lastLabelHeight = labelHeight
		end
		label = self.labels[i]
		if(label.label.gameObject.activeSelf) then
			label.label.transform.localPosition = Vector3(pos.x,pos.y - lastLabelHeight - lastLabel.paddingY,pos.z)
			labelHeight = label.label.height
			if(label.label.text == "" or label.label.text == nil) then
				labelHeight = 0
			end
			height = height + labelHeight + lastLabel.paddingY
		end
	end
	return height
end

function SkillTip:OnEnter()
-- 	LeanTween.cancel(self.gameObject);
-- 	local colliders = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, BoxCollider, true);
-- 	for k,v in pairs(colliders) do
-- 		v.enabled = false;
-- 	end
-- 	self.closecomp.enabled = false;
-- 	LeanTween.delayedCall (self.gameObject, 0.3, function ()
-- 		self.closecomp.enabled = true;
-- 		for k,v in pairs(colliders) do
-- 			v.enabled = true;
-- 		end
-- 	end):setDestroyOnComplete(true);
end

function SkillTip:OnExit()
	self:_CheckSpecialModified()
	-- LeanTween.cancel(self.gameObject);
	return true;
end

function SkillTip:_CheckSpecialModified()
	if(self.funcGO and self.funcGO.activeSelf) then
		if(self.funcCheck_opt == normalAtkCheck_opt) then
			if(MyselfProxy.Instance.selectAutoNormalAtk~= self.funcCheck.activeSelf) then
				if(self.funcCheck.activeSelf) then
					ServiceNUserProxy.Instance:CallSetNormalSkillOptionUserCmd(1)
				else
					ServiceNUserProxy.Instance:CallSetNormalSkillOptionUserCmd(0)
				end
			end
		elseif(self.funcCheck_opt == skillautoQueue_opt) then
			local nowQueue = Game.SkillOptionManager:GetSkillOption_AutoQueue() == 0
			if(nowQueue ~= self.funcCheck.activeSelf) then
				if(self.funcCheck.activeSelf) then
					Game.SkillOptionManager:SetSkillOption_AutoQueue(true)
				else
					Game.SkillOptionManager:SetSkillOption_AutoQueue(false)
				end
			end
		end
		if(self.data:GetEnableSpecialEffect()~=self.specialCheck.activeSelf) then
			local currentBeingData = CreatureSkillProxy.Instance:GetSelectSkillBeingData()
			ServiceSkillProxy.Instance:CallSelectRuneSkillCmd(self.data.id,0,self.specialCheck.activeSelf,currentBeingData and currentBeingData.id or 0)
		end
		local cell = self:_GetSelectedSpecialCell()
		if(cell and cell.data.id ~= self.data:GetSpecialID()) then
			local currentBeingData = CreatureSkillProxy.Instance:GetSelectSkillBeingData()
			ServiceSkillProxy.Instance:CallSelectRuneSkillCmd(self.data.id,cell.data.id,self.specialCheck.activeSelf,currentBeingData and currentBeingData.id or 0)
		end

		local cell = self:_GetSelectedOptionCell()
		if(cell and cell.data.id ~= Game.SkillOptionManager:GetSkillOption_SummonBeing()) then
			Game.SkillOptionManager:SetSkillOption_SummonBeing(cell.data.id)
		end
	end
end

-- function SkillTip:SetPos(pos)
-- 	SkillTip.super.SetPos(self, pos);
-- 	self.grid:Reposition();
-- end

function SkillTip:DestroySelf()
	GameObject.DestroyImmediate(self.gameObject)
end

function SkillTip:GetDesc(data)
	local desc = ""
	local config
	for i=1,#data.Desc do
		config = data.Desc[i]
		if(Table_SkillDesc[config.id] and Table_SkillDesc[config.id].Desc)then
			if(config.params) then
				desc = desc..string.format(Table_SkillDesc[config.id].Desc,unpack(config.params))..(i~=#data.Desc and "\n" or "")
			else
				desc = desc..Table_SkillDesc[config.id].Desc..(i~=#data.Desc and "\n" or "")
			end
		end
	end
	return desc
end

local groupSpecials = {}
local debug = false
function SkillTip:HandleRunSpecials(selectID)
	local ReusableTable = ReusableTable
	-- helplog("sortID",self.data.sortID)
	local sb
	local specials = AstrolabeProxy.Instance:GetSkill_SpecialEffect(self.data.sortID)
	if(specials) then
		local config
		local selectEnable
		if(self.specialCheck) then
			selectEnable = self.specialCheck.activeSelf
		else
			selectEnable = self.data:GetEnableSpecialEffect()
		end
		if(selectID==nil) then
			local selectCell = self:_GetSelectedSpecialCell()
			if(selectCell) then
				selectID = selectCell.data.id
			end
		end
		TableUtility.TableClear(groupSpecials)
		local sameGrp
		local notselect
		for k,v in pairs(specials) do
			config = Table_RuneSpecial[k]
			if(config) then
				if(config.Type~=3) then
					notselect = not selectEnable or selectID~=k
					if(sb==nil) then
						sb = LuaStringBuilder.CreateAsTable()
					end
					if(config.Group==nil or config.Type == 2) then
						self:_HandleSameSpecialEffect(sb,config,v,notselect)
					else
						sameGrp = groupSpecials[config.Group]
						if(sameGrp==nil) then
							sameGrp = ReusableTable.CreateArray()
							groupSpecials[config.Group] = sameGrp
							sameGrp[1] = config
							sameGrp[2] = ReusableTable.CreateArray()
							TableUtility.ArrayShallowCopy(sameGrp[2], config.SkillTipParm)
							local params = sameGrp[2]
							for i=1,#params do
								params[i] = params[i] * v
							end
						else
							local params = sameGrp[2]
							for i=1,#params do
								params[i] = params[i] + config.SkillTipParm[i] * v
							end
						end
					end
				end
			end
		end

		for k,v in pairs(groupSpecials) do
			if(sb==nil) then
				sb = LuaStringBuilder.CreateAsTable()
			end
			self:_HandleSameGroupSpecialEffect(sb,v[1],v[2],notselect)
			ReusableTable.DestroyArray(v[2])
			ReusableTable.DestroyArray(v)
			groupSpecials[k] = nil
		end

		if(debug) then
			if(sb) then
				sb:AppendLine("\n下面是旧的\n")
			end

			for k,v in pairs(specials) do
				config = Table_RuneSpecial[k]
				local Runetip = config.Runetip
				if(Table_RuneSpecialDesc) then
					Runetip = Table_RuneSpecialDesc[Runetip].Text
				end
				if(config) then
					-- helplog(k,v)
					if(sb==nil) then
						sb = LuaStringBuilder.CreateAsTable()
					end
					if(config.Type==1) then	
						--永久
						sb:AppendLine(config.RuneName.."：")
						sb:AppendLine(self:_GetRuneSpecialDes(Runetip,config.SkillTipParm,v))
					elseif(config.Type == 2) then
						--携带
						if(not selectEnable or selectID~=k) then
							sb:Append("[c][b2b2b2]")
						end
						sb:AppendLine(config.RuneName.."：")
						sb:AppendLine(self:_GetRuneSpecialDes(Runetip,config.SkillTipParm,v))
						if(not selectEnable or selectID~=k) then
							sb:Append("[-][/c]")
						end
					end
				end
			end
		end
	end
	if(sb) then
		sb:RemoveLast()
		local str = sb:ToString()
		-- helplog(str)
		sb:Destroy()
		return str
	end
	return nil
end

function SkillTip:_HandleSameSpecialEffect(sb,config,count,notselect)
	local Runetip = config.Runetip
	if(Table_RuneSpecialDesc) then
		Runetip = Table_RuneSpecialDesc[Runetip].Text
	end
	if(config.Type==1) then
		--永久
		sb:AppendLine(config.RuneName.."：")
		sb:AppendLine(self:_GetRuneSpecialDes(Runetip,config.SkillTipParm,count))
	elseif(config.Type == 2) then
		--携带
		if(notselect) then
			sb:Append("[c][b2b2b2]")
		end
		sb:AppendLine(config.RuneName.."：")
		sb:AppendLine(self:_GetRuneSpecialDes(Runetip,config.SkillTipParm,count))
		if(notselect) then
			sb:Append("[-][/c]")
		end
	end
end

function SkillTip:_HandleSameGroupSpecialEffect(sb,config,params,notselect)
	local Runetip = config.Runetip
	if(Table_RuneSpecialDesc) then
		Runetip = Table_RuneSpecialDesc[Runetip].Text
	end
	if(config.Type==1) then
		--永久
		sb:AppendLine(config.RuneName.."：")
		sb:AppendLine(string.format(Runetip,unpack(params)))
	elseif(config.Type == 2) then
		--携带
		if(notselect) then
			sb:Append("[c][b2b2b2]")
		end
		sb:AppendLine(config.RuneName.."：")
		sb:AppendLine(string.format(Runetip,unpack(params)))
		if(notselect) then
			sb:Append("[-][/c]")
		end
	end
end

local tmpParamArray = {}
function SkillTip:_GetRuneSpecialDes(str,param,count)
	if(param) then
		if(count==nil) then
			count = 1
		end
		for i=1,#param do
			tmpParamArray[i] = param[i] * count
		end
		str = string.format(str,unpack(tmpParamArray))
		TableUtility.ArrayClear(tmpParamArray)
	end
	return str
end