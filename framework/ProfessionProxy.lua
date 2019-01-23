ProfessionProxy = class('ProfessionProxy', pm.Proxy)
ProfessionProxy.Instance = nil;
ProfessionProxy.NAME = "ProfessionProxy"

--玩家背包数据管理
function ProfessionProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ProfessionProxy.NAME
	if(ProfessionProxy.Instance == nil) then
		ProfessionProxy.Instance = self
	end
	-- self.enableLog = true
	self.professionMap = {}
	self:ParseProfession()
end

function ProfessionProxy:print( ... )
	if(self.enableLog) then
		print(...)
	end
end
--解析职业树关系
--
function ProfessionProxy:ParseProfession()
	self.professTreeByTypes = {}
	--初心者
	local rootID = 1
	local rootClass = Table_Class[rootID]
	self.rootProfession = ProfessionData.new(rootClass)
	if(rootClass) then
		self.professionMap[rootID] = self.rootProfession
		local class
		local profession
		local tree
		for i=1,#rootClass.AdvanceClass do
			class = Table_Class[rootClass.AdvanceClass[i]]
			profession = ProfessionData.new(class,1)
			self.professionMap[class.id] = profession
			tree = ProfessionTree.new(self.rootProfession,profession)
			self:print("-----开始解析二转职业",class.id)
			self:ParseNextProfession(tree,profession)
			self.professTreeByTypes[class.Type] = tree
		end
	else
		error(string.format("解析职业表出错，未找到id %d的初心者",rootID))
	end
end

function ProfessionProxy:ParseNextProfession(tree,profession)
	local parentClass = profession.data
	local class
	local p
	if(parentClass.AdvanceClass) then
		for i=1,#parentClass.AdvanceClass do
			class = Table_Class[parentClass.AdvanceClass[i]]
			self:print("-----",class.id)
			p = ProfessionData.new(class)
			self.professionMap[class.id] = p
			profession:AddNext(p)
			self:ParseNextProfession(tree,p)
		end
	end
end

function ProfessionProxy:GetProfessionTreeByType(t)
	if(t ==	0) then
		return nil
	else
		return self.professTreeByTypes[t]
	end
end

--返回Nil的话，为初心者（也或者没找到）
function ProfessionProxy:GetProfessionTreeByClassId(classID)
	local class = Table_Class[classID]
	return class and self:GetProfessionTreeByType(class.Type) or nil
end

function ProfessionProxy:GetDepthByClassId(classID)
	local tree = self:GetProfessionTreeByClassId(classID)
	if(not tree) then
		return 0
	else
		local p = tree:GetProfessDataByClassID(classID)
		if(p) then
			return p.depth
		end
	end
end

function ProfessionProxy:GetThisIdPreviousId(id)
	for k,v in pairs(Table_Class) do
		local advanceTable =  v.AdvanceClass
		if advanceTable then
			for k1,v1 in pairs(advanceTable) do
				if id == v1 then
					return v.id
				end	
			end	
		end
	end	

	return nil
end	

function ProfessionProxy:GetThisIdJiuZhiTiaoJianLevel(id)
	local previousId = self:GetThisIdPreviousId(id)
	if previousId then
		local thisIdData =Table_Class[id]
		local previousData = Table_Class[previousId]

		if previousData.MaxPeak~=nil then
			local doublePreId = self:GetThisIdPreviousId(previousId)
			if doublePreId then
				return previousData.MaxPeak - previousData.MaxJobLevel + previousData.MaxJobLevel - Table_Class[doublePreId].MaxJobLevel
			else
				helplog("GetThisIdJiuZhiTiaoJianLevel(id) 检查配置表")
			end	
		else
			return  thisIdData.MaxJobLevel - previousData.MaxJobLevel
		end	
	else
		helplog("GetThisIdJiuZhiTiaoJianLevel(id) 检查配置表")
	end	
end	

function ProfessionProxy:GetThisJobLevelForClient(id,level)
	local returnLevel = level or 0
	local previousId = self:GetThisIdPreviousId(id) or 0

	if level>Table_Class[id].MaxJobLevel and Table_Class[id].MaxPeak==nil then
	   --这里会发一个id：11 level130过来 实际上id 11 只能达到40
	   level = Table_Class[id].MaxJobLevel or 0
	elseif  Table_Class[id].MaxPeak~=nil and level>Table_Class[id].MaxPeak then
		level = Table_Class[id].MaxPeak or 0
	end	

	if previousId and previousId~=0 then
		local previousData = Table_Class[previousId]
		if previousData.MaxPeak~=nil then
			returnLevel =  level - previousData.MaxPeak
		elseif 	previousData.MaxJobLevel~=nil then
			returnLevel =  level - previousData.MaxJobLevel
		end
	end

	if returnLevel<0 then
		helplog("gm")
		returnLevel = 1;
	end	

	return returnLevel
end	

function ProfessionProxy:GetPreviousProfess(pro)
	local p = self.professionMap[pro]
	if(p) then
		return p.parentProfession
	end
	return nil
end

function ProfessionProxy:RecvUpdateBranchInfoUserCmd(data)
	BranchInfoSaveProxy.Instance:RecvUpdateBranchInfoUserCmd(data)
end

function ProfessionProxy:SetCurProfessionUserInfo(data)
	self.CurProfessionUserInfo = data
end

function ProfessionProxy:GetCurProfessionUserInfo()
	return self.CurProfessionUserInfo or nil
end

function ProfessionProxy:RecvProfessionQueryUserCmd(data)
	self.ProfessionQueryUserTable={}
	if data~=nil and data.body~=nil and data.body.items~=nil then
		local items = data.body.items

		local haveFoundOriginBranch = false

		for i = 1 ,#items do
			local data  = items[i]
				if data.isbuy== nil then
					helplog("isbuy 服务器没发！！！！")
				end	
				self.ProfessionQueryUserTable[data.branch] = {}
				self.ProfessionQueryUserTable[data.branch].branch = data.branch
				self.ProfessionQueryUserTable[data.branch].profession = data.profession
				self.ProfessionQueryUserTable[data.branch].joblv = data.joblv
				self.ProfessionQueryUserTable[data.branch].isbuy = data.isbuy
				self.ProfessionQueryUserTable[data.branch].iscurrent  = data.iscurrent
				if  data.isbuy == false then
					haveFoundOriginBranch = true
				end	
		end	

		if haveFoundOriginBranch== false then
			local curId = MyselfProxy:GetMyProfession()
			local curClassData = Table_Class[curId]
			self.ProfessionQueryUserTable[curClassData.TypeBranch]={}
			self.ProfessionQueryUserTable[curClassData.TypeBranch].branch =curClassData.TypeBranch
			self.ProfessionQueryUserTable[curClassData.TypeBranch].profession = MyselfProxy:GetMyProfession()
			self.ProfessionQueryUserTable[curClassData.TypeBranch].joblv = MyselfProxy.Instance:JobLevel()
			self.ProfessionQueryUserTable[curClassData.TypeBranch].isbuy = false
			self.ProfessionQueryUserTable[curClassData.TypeBranch].iscurrent  = true
			ProfessionProxy.Instance:SetCurTypeBranch(curClassData.TypeBranch)
		end	
	end	
end

function ProfessionProxy:GetProfessionQueryUserTable()
	return self.ProfessionQueryUserTable or {}
end

function ProfessionProxy:GetGeneraData()
	local datas = {}
	for i=1,#GameConfig.BaseAttrConfig do
		local data = {}
		local single = GameConfig.BaseAttrConfig[i]
		local prop = Game.Myself.data.props[single];
		local extraP = MyselfProxy.Instance.extraProps[single]
		local data = {}
		data.prop = prop
		data.extraP = extraP
		if(self.attr)then
			data.addData = self.attr[prop.propVO.id] or 0
			local maxProp = Game.Myself.data.props["Max"..data.prop.propVO.name]
			maxProp = maxProp and maxProp.propVO or nil
			maxProp = maxProp and maxProp.id or -999
			data.maxAddData = self.attr[maxProp] or 0
		end
		data.type = BaseAttributeView.cellType.normal
		table.insert(datas,data)
	end
	return datas
end

function ProfessionProxy:SetCurTypeBranch(curTypeBranch)
	self.curTypeBranch = curTypeBranch
end

function ProfessionProxy:GetCurTypeBranch()
	return self.curTypeBranch 
end


function ProfessionProxy:GetFixedData()
	local datas = AdventureDataProxy.Instance:GetAllFixProp()
	if(#datas >0)then
		table.sort(datas,function ( l,r )
			-- body
			return l.prop.propVO.id < r.prop.propVO.id
		end)
	else
	end
	return datas
end

function ProfessionProxy:IsThisIdYiJiuZhi(id)
	local curOcc = Game.Myself.data:GetCurOcc()
	self.curProfessionId = curOcc.profession
	local curProfessionData = Table_Class[self.curProfessionId]
	local thisIdClassData  = Table_Class[id]
	if curProfessionData==nil then
		return false
	end	
	if thisIdClassData==nil then
		return false
	end	

	local serverData = ProfessionProxy.Instance:GetProfessionQueryUserTable()[thisIdClassData.TypeBranch]
	if serverData then
		if serverData.profession>=id then
			return true
		else
			return false
		end	
	else
	--这里还差一个判断条件如果
		if id%10 == 1 then
			local advanceClassIdTable = thisIdClassData.AdvanceClass
			for k,v in pairs(advanceClassIdTable) do
				local serverData = ProfessionProxy.Instance:GetProfessionQueryUserTable()[Table_Class[v].TypeBranch]
				if serverData and serverData.profession>=id then
					return true
				end
			end	
		end	

		return false
	end	
 
	if id%10==1 then
		if curProfessionData.Type == thisIdClassData.Type then
			return true
		end	
	elseif 	id%10>=2 then
		if curProfessionData.TypeBranch == thisIdClassData.TypeBranch then
			if  id<=self.curProfessionId then
				return true
			end
		end	
	end

	return false
end

function ProfessionProxy:IsThisIdYiGouMai(id)
	local curOcc = Game.Myself.data:GetCurOcc()
	self.curTypeBranch = curOcc.professionData.TypeBranch
	self.curProfessionId = curOcc.profession

	--防止买了一个停在另一个职业的分支
	local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
	for k,v in pairs(S_ProfessionDatas) do
		if v.iscurrent then
			self.curTypeBranch = v.branch
		end	
	end	

	if id%10 == 1 then
		local thisIdClassData  = Table_Class[id]
		for k,v in pairs(ProfessionProxy.Instance:GetProfessionQueryUserTable()) do
			local SClassData =  Table_Class[v.profession]
			if SClassData then
				if thisIdClassData.Type == 	SClassData.Type then
					return true
				end	
			end	
		end

	elseif id%10>=2 then	
		local thisIdClassData  = Table_Class[id]
		local thisIdBranch = thisIdClassData.TypeBranch
		local S_table = ProfessionProxy.Instance:GetProfessionQueryUserTable()

		if S_table[thisIdBranch]~=nil then
			return true
		end	

		if self.curTypeBranch == thisIdClassData.TypeBranch then
			if self.curProfessionId %10==1 then
				return false
			else	
				return true
			end
		end	
	end	
	return false
end	

function ProfessionProxy:IsThisIdKeGouMai(id)
	if id%10 == 1 then
		return false
	elseif id%10==2 then	
		return true
	end	
	return false
end	

function ProfessionProxy:isOriginProfession(id)
	local thisClassData = Table_Class[id]
	if thisClassData == nil then
		return false
	end	

	local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
	local isOriginProfession = false
	for k,v in pairs(S_data) do
		if v.isbuy == false then
			local sClassData = Table_Class[v.profession]

			if sClassData.Type == thisClassData.Type then
				isOriginProfession = true
				break
			end	
		end	
	end	


	return isOriginProfession
end

--多职业代码重构-
function ProfessionProxy:IsMPOpen()

	if FunctionUnLockFunc.Me():CheckCanOpen(9006) == false then
		return false
	end	

	local isOpen = false
	local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()

	for k,v in pairs(S_data) do 
		if v.isbuy == false and v.profession %10>=3 then
			isOpen = true
		end	
	end	

	return isOpen
end

function ProfessionProxy:PurchaseFunc(id)
	local mapid = Game.MapManager:GetMapID()
	local mapType = Table_Map[mapid].Type
	if mapType == 4 or mapType==6 then
	else
		MsgManager.FloatMsg(nil, ZhString.Oversea_Hard_Code_Client_7)
		do return end
	end	

	local isOriginProfession = self:isOriginProfession(id)
	local branch = Table_Class[id].TypeBranch	
	---有职业优惠券优先用券

	if GameConfig.ProfessionExchangeTicket== nil then
		if ApplicationInfo.IsRunOnEditor() then
			MsgManager.FloatMsg(nil, "策划没有上传  GameConfig.ProfessionExchangeTicket！！！！")
		end	
		do return end
	end	

	for k,v in pairs(GameConfig.ProfessionExchangeTicket) do
		if BagProxy.Instance:GetItemNumByStaticID(k)>0 and v == Table_Class[id].Type then
			ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true) 
			do return end
		end	
	end	

	if isOriginProfession then
		local needmoney = GameConfig.Profession.price_zeny or 0
		if needmoney>MyselfProxy.Instance:GetROB() then
			local sysMsgID = 25419
			local item_100 = Table_Item[100]
			MsgManager.ShowMsgByID(sysMsgID,item_100.NameZh)
		else
			ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true) 
		end	
	else
		local needmoney = GameConfig.Profession.price_gold
		if needmoney>MyselfProxy.Instance:GetLottery() then
			local sysMsgID = 25419
			local item_151 = Table_Item[151]
			MsgManager.ShowMsgByID(sysMsgID,item_151.NameZh)
		else
			ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true) 
		end	
	end	
end

function ProfessionProxy:NeedShowSelfData(targetBranch)
	local currentBranch = ProfessionProxy.Instance:GetCurTypeBranch()
	if currentBranch == targetBranch then
		return true
	else
		return false
	end	
end	

function ProfessionProxy:NeedShowSaveInfoData(targetBranch)
	local cursaveData = BranchInfoSaveProxy.Instance:GetUsersaveData(targetBranch)
	if cursaveData then
		return true
	else
		return false
	end	
end	

function ProfessionProxy:SetTopScrollChooseID(id)
	self.topScrollChooseID = id
end	

function ProfessionProxy:GetTopScrollChooseID()
	return self.topScrollChooseID 
end	

function ProfessionProxy:ShouldThisIdVisible(id)
	local findErZhuanId = (id-id%10)+2
	if not self:IsThisIdYiJiuZhi(findErZhuanId) and id%10>2 then
		return false
	end	
	return true;
end	

function ProfessionProxy:GetThisIdChuShiId(id)
	return Table_Class[id].Type*10+1
end	

function ProfessionProxy:GetTopScrollViewIconTable()
	if self.topScrollViewIconTable==nil then
		self.topScrollViewIconTable = {}
		for k,v in pairs(Table_Class) do 
			if v.id %10==1 and v.id~=1 then
				self.topScrollViewIconTable[v.Type] = self.topScrollViewIconTable[v.Type] or {}
				self.topScrollViewIconTable[v.Type].id = v.id
				self.topScrollViewIconTable[v.Type].Type = v.Type
				self.topScrollViewIconTable[v.Type].isGrey = true
				self.topScrollViewIconTable[v.Type].order = v.Type
			end	
		end	
	end	
	---再次排序
	local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()

	local curOcc = Game.Myself.data:GetCurOcc()
	local curProfessionId = curOcc.profession

	local chushiid = 0
	for k,v in pairs(S_data) do
		if v.isbuy == false then
			chushiid = self:GetThisIdChuShiId(v.profession)
		end				
	end 

	for k,v in pairs(self.topScrollViewIconTable) do
		if v.id == chushiid then
			v.order = 999999
			v.isGrey = false
		else	
			if self:IsThisIdYiGouMai(v.id) then
				v.isGrey = false
				v.order = 1000
			else	
				v.isGrey = true
				v.order = 0
			end
		end	
	end	

	table.sort(self.topScrollViewIconTable,
		function(l,r)
			return l.order>r.order
		end	
	)
	
	return self.topScrollViewIconTable
end

function ProfessionProxy:DoesThisIdCanBuyBranch(id,branch)
	if not (id%10 == 1) then
		helplog("GetThisIdCanBuyBranch reviewCode id:"..id)
	end	


	for k,v in pairs(Table_Class[id].AdvanceClass) do 
		if Table_Class[v].TypeBranch == branch then
			return true
		end	
	end	

	return false
end

function ProfessionProxy:GetBoughtProfessionIdThroughBranch(branch)
	for k,v in pairs (Table_Class) do
		if v.TypeBranch == branch and v.id%10==2 then
			return v.id
		end
	end
end

ProfessionData = class("ProfessionData")

function ProfessionData:ctor(data,depth)
	self.id = data.id
	self.data = data
	self.depth = (depth or 0)
	--typebranch为key
	self.nextProfessions = {}
	self.parentProfession = nil
end

function ProfessionData:GetNextByBranch(typeBranch)
	return self.nextProfessions[typeBranch]
end

function ProfessionData:AddNext(profession)
	profession:SetParent(self)
	profession.depth = self.depth + 1
	self.nextProfessions[profession.data.TypeBranch] = profession
end

function ProfessionData:SetParent(parent)
	self.parentProfession = parent
end

ProfessionTree = class("ProfessionTree")

function ProfessionTree:ctor(root,transferRoot)
	self.root = root
	self.transferRoot = transferRoot
end

function ProfessionTree:GetProfessDataByClassID(classID)
	if(self.transferRoot) then
		return self:RecurseFindClass(self.transferRoot,classID)
	end
	return nil
end

function ProfessionTree:RecurseFindClass(profess,classID)
	if(profess) then
		if(profess.id == classID) then
			return profess
		else
			local find
			for branch,profession in pairs(profess.nextProfessions) do
				find = self:RecurseFindClass(profession,classID)
				if(find) then
					return find
				end
			end
		end
	end
	return nil
end

function ProfessionTree:InitSkillPath(classID)
	if(self.classID ~= classID) then
		self.classID = classID
		self.paths = {}
		--递归以行列为键值，map数据
		local classData = Table_Class[self.classID]
		self:RecurseParsePathByProfess(self.transferRoot,classData.TypeBranch)
		ProfessionTree.HandlePath(self.paths)
	end
end

function ProfessionTree:RecurseParsePathByProfess(data,typeBranch)
	if(data) then
		local skills = Table_Class[data.id].Skill
		if(skills) then
			ProfessionTree.ParsePath(skills,self.paths)
			for k,v in pairs(data.nextProfessions) do
				if(k == typeBranch) then
					self:RecurseParsePathByProfess(v,typeBranch)
				end
			end
		end
	end
end

function ProfessionTree.HandlePath(paths)
	local posData
	local requiredData
	for hang,hangPaths in pairs(paths) do
		local up = true
		local endlie
		for lie,data in pairs(hangPaths) do
			if(data.requiredID) then
				--解析下，哪些技能连线中间有其他技能，并且线段需要上下走，不能打架
				posData = Table_SkillMould[data.requiredID]
				if(posData) then
					posData = posData.Pos or {0,0}
					up = endlie == nil or endlie>=posData[1]
					requiredData = hangPaths[posData[1]]
					if(requiredData) then
						for i=posData[1]+1,lie-1 do
							if(hangPaths[i]) then
								requiredData.between = true
								requiredData.up = up
								endlie = lie
								break
							end
						end
					end
				end
			end
		end
	end
end

function ProfessionTree.ParsePath(skills,paths)
	if(skills) then
		local skill
		local posData
		local path
		local requiredID
		for i=1,#skills do
			skill = skills[i]
			posData = Table_SkillMould[skill]
			skill = Table_Skill[skill]
			if(posData) then
				posData = posData.Pos
				if(posData) then
					path = paths[posData[2]]
					if(path==nil) then
						path = {}
						paths[posData[2]] = path
					end
					requiredID = skill.Contidion and skill.Contidion.skillid or nil
					if(requiredID) then
						requiredID = math.floor(requiredID/1000)*1000 + 1
					end
					path[posData[1]] = {id=skill.id,requiredID = requiredID}
				end
			end
		end
	end
end

