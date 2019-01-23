BaseAttributeView = class("BaseAttributeView",SubMediatorView)
autoImport("BaseAttributeCell")

BaseAttributeView.cellType = {
	normal = 1,
	fixed = 2,
	jobBase = 3,
	saveHpSp = 4,
}

local tempVector3 = LuaVector3.zero

function BaseAttributeView:Init()
	self:initView()
	self:resetData()
	self:AddListenEvts()
	self.attr = nil
end

function BaseAttributeView:resetData(  )
	-- body	
	self:calculAttrData()
	self:updateGeneralData()
	self:updateFixedData()
	self:reBuildPolygon()
end

function BaseAttributeView:calculAttrData(  )
	-- body
	if(self.addCoundMap)then
		local calView = {}
		self.addData = {}

		local pType = Game.Myself.data:GetCurOcc().professionData.Type
		local jobLv = MyselfProxy.Instance:JobLevel()
		for k,v in pairs(self.addCoundMap) do
			local id = k
			local prop = Game.Myself.data.props[id]
			local extra = MyselfProxy.Instance.extraProps[id]
			local name = prop.propVO.name
			local value = CommonFun.calAttrPoint(v.totalCount,jobLv,pType,name)
			self.addData[prop.propVO.id] = value + prop:GetValue() - extra:GetValue()
			calView[prop.propVO.id] = v.addCount
		end

		local roleLv = MyselfProxy.Instance:RoleLevel()
		local profession = Game.Myself.data:GetCurOcc().profession
		-- local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.RoleEquip)
		-- local equipData = bagData:GetEquipBySite(7)	
		-- local equipType = equipData and equipData.staticData.Type or 0
		-- self:Log("addData:",self.addData)
		local weaponType =  Game.Myself.data:GetEquipedWeaponType()
		self.attr = CommonFun.calcUserShowAttr(calView,profession,roleLv,weaponType)
		-- self.attr = CommonFun.calcUserAttrValue(self.addData,roleLv,profession,equipType)
		-- self:Log("self.attr:",self.attr)
	end
end

-- 基础属性
function BaseAttributeView:updateGeneralData(  )
	-- body
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
	self.baseGridList:ResetDatas(datas)
	local bound = NGUIMath.CalculateRelativeWidgetBounds(self.baseGrid.gameObject.transform);
	-- self.baseSp.height = bound.size.y + 50
	local _,y = LuaGameObject.GetLocalPosition(self.baseSp.transform)
	local x,_,z = LuaGameObject.GetLocalPosition(self.fixedSp.transform)
	tempVector3:Set(x,y - bound.size.y - 51,z)
	self.fixedSp.transform.localPosition = tempVector3
	-- bound = NGUIMath.CalculateRelativeWidgetBounds(self.fixedGrid.gameObject.transform);
	-- self.fixedSp.height = bound.size.y + 5
end

function BaseAttributeView:updateFixedData(  )
	-- body
	local datas = AdventureDataProxy.Instance:GetAllFixProp()
	if(#datas >0)then
		table.sort(datas,function ( l,r )
			-- body
			return l.prop.propVO.id < r.prop.propVO.id
		end)
		self.fixedGridList:ResetDatas(datas)
		self:Show(self.fixedSp)
	else
		self:Hide(self.fixedSp)
	end
end

function BaseAttributeView:initView(  )
	-- body	
	self.gameObject = self:FindGO("attrViewHolder")
	local obj = self:LoadPreferb("view/BaseAttributeView", self.gameObject, true)
	tempVector3:Set(0,0,0)
	obj.transform.localPosition = tempVector3
	self.baseSp = self:FindGO("Base")
	self.baseGrid = self:FindGO("Grid",self.baseSp):GetComponent(UIGrid)
	self.baseGridList = UIGridListCtrl.new(self.baseGrid,BaseAttributeCell,"BaseAttrCell")	
	local lbx = self:FindGO("AbilityPolygon",self.baseSp);
	self.abilitypoint = self:FindGO("point", lbx);
	self.abilityline = self:FindGO("line", lbx);
	self.abilityPolygon = self:FindGO("PowerPolygo", lbx):GetComponent(PolygonSprite);
	local tips = self:FindGO("tips",self.baseSp);
	-- self.lifeLabel = self:FindGO("value",self:FindGO("LifeAttributeCell")):GetComponent(UILabel)
	-- self.spLabel = self:FindGO("value",self:FindGO("SpAttributeCell")):GetComponent(UILabel)	
	self.initAttiLab = {};
	for i = 1,6 do
		self.initAttiLab[i] = self:FindGO("Label"..i, tips):GetComponent(UILabel);
	end
	
	self.fixedSp = self:FindGO("Fixed")
	self.fixedGrid = self:FindGO("Grid",self.fixedSp):GetComponent(UIGrid)
	self.fixedGridList = UIGridListCtrl.new(self.fixedGrid,BaseAttributeCell,"BaseAttrCell")
	self.helpBtn = self:FindGO("HelpButton")
	local fixedAttrTitle = self:FindComponent("professionName",UILabel)
	fixedAttrTitle.text = ZhString.Charactor_BaseAttriViewFixedTitle
end

function BaseAttributeView:HideHelpBtn(  )
	-- body
	self:Hide(self.helpBtn)
end

function BaseAttributeView:reBuildPolygon( playerData )
	-- body
	playerData = not playerData and Game.Myself.data or playerData
	local initAttris = {}
	for i=1,#(GameConfig.ClassInitialAttr)do
		local single = GameConfig.ClassInitialAttr[i]
		local prop = playerData.props[single];
		table.insert(initAttris,prop)
	end
	if(self.lps~=nil)then
		for k,v in pairs(self.lps) do
			GameObject.DestroyImmediate(v);
		end
	end
	
	-- printRed("weight:"..weight)
	if(initAttris~=nil and #initAttris>0)then
		local v = {};
		for i = 1, #initAttris do
			self.initAttiLab[i].text = initAttris[i].propVO.name;
			if(self.addData)then				
				v[i] = self:getWeightByValue(self.addData[initAttris[i].propVO.id])
			else				
				v[i] = self:getWeightByValue(initAttris[i]:GetValue())
			end
			-- printRed("v:"..v[i])
			self.abilityPolygon:SetLength(i-1, v[i]*115);
		end
		-- self.lps = NGUIUtil.DrawAbilityPolygon(nil, nil, 125, v);
	end
end

function BaseAttributeView:getWeightByValue( value )
	-- body
	local A = 0
	if value >= 200 then 
		A = 100
	elseif value >= 100 then 
		A = 75 + ( value - 100 ) /100*25 
	elseif value >= 40 then 
		A = 50 + ( value - 40 )/60*25 
	elseif value >= 10 then 
		A = 25 + ( value - 10 )/30*25
	else 
		A = 10 + (value -1)*15/9 
	end

	return A/100
end

function BaseAttributeView:clickShowBtn(  )
	-- body
	local activeSelf = not self.gameObject.activeSelf
	self.gameObject:SetActive(activeSelf)
	if(activeSelf)then
		self.abilityPolygon:ReBuildPolygon();
		self:resetData()
	end
end

function BaseAttributeView:showMySelf( notifyData )
	-- body
	local from = notifyData and notifyData.from or nil
	local addCoundMap = notifyData and notifyData.addCoundMap or nil
	if(not from)then
		self:Show()
	end	

	if(addCoundMap)then		
		-- self:Log("self.attr:",self.attr)
		self.addCoundMap = addCoundMap
	else
		self.attr = nil
		self.addCoundMap = nil
		self.addData = nil
	end
	self.abilityPolygon:ReBuildPolygon();
	self:resetData()
end

function BaseAttributeView:AddListenEvts(  )
	-- body
	-- self:AddListenEvt(MyselfEvent.MyProfessionChange, self.resetprofession)
	self:AddListenEvt(MyselfEvent.MyPropChange,self.resetData)
	self:AddListenEvt(ServiceEvent.NUserBuffForeverCmd,self.updateFixedData)
end
