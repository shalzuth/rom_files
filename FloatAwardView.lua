FloatAwardView = class("FloatAwardView",BaseView)
autoImport("EffectShowDataWraper")
-- FloatAwardView.Instance = nil
FloatAwardView.ViewType = UIViewType.Show3D2DLayer

--value ????????????????????????????????????????????????????????????
FloatAwardView.ShowType = {
	ModelType = 1,	
	CardType = 2,
	IconType = 3,
	ItemType = 4,
}

FloatAwardView.EffectPath={
	EffectType_1 = "Public/Effect/UI/13itemShine",
}

--???????????? ????????????????????? ????????? ????????????
FloatAwardView.EffectFromType = 
{
	AwardType = 1,
	GMType = 2,
	RefineType = 3,
}

FloatAwardView.TimeTickType = 
{
	CheckAnim = 1,
	ShowIconOneByOne = 2,
}

local tempVector3 = LuaVector3.zero
local tempVector3_scale = LuaVector3.zero
local tempQuaternion = LuaQuaternion.identity
function FloatAwardView:Init()
  if(FloatAwardView.Instance == nil)then
  	  FloatAwardView.Instance = self
  end 
  self:initView()
  self:addViewListener()
  self:initData()
end

function FloatAwardView:initView(  )
	-- body	
	self.effectContainer = self:FindGO("EffectContainer"):GetComponent(ChangeRqByTex);
	self.propertyContainer = self:FindGO("propertyContainer")
	self:Hide(self.propertyContainer)
	tempVector3:Set(LuaGameObject.GetLocalPosition(self.propertyContainer.transform))
	tempVector3:Set(tempVector3.x,tempVector3.y,-200)
	self.propertyContainer.transform.localPosition = tempVector3
	self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
	self.itemNameCt = self:FindGO("itemNameCt")
	self.intoPackBtn = self:FindGO("intoPackBtn")
	self.intoPackLabel = self:FindGO("intoPackLabel"):GetComponent(UILabel)
	self.equipBtn = self:FindGO("equipBtn")
	self.equipLabel = self:FindComponent("Label",UILabel,self.equipBtn)
	self.modelShow = self:FindGO("modelShow")
	self.shareBtnCt = self:FindGO("shareBtnCt")
	self.skipBtn = self:FindGO("skipBtn")
	self.nameBg = self:FindGO("nameBg")
	self:Hide(self.nameBg)
	self:AddClickEvent(self.shareBtnCt,function (  )
		-- body
		self:Log("shareBtnCt AddClickEvent")
		local data = self.currentShowData:clone()
		if(data.itemData and data.itemData.staticData and self.checkIsKFCAct(data.itemData.staticData.id))then
			self:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.KFCActivityShowView, viewdata = data});
			return 
		end
		self:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ShareAwardView, viewdata = data});
	end)
	self:AddClickEvent(self.skipBtn,function (  )
		-- body
		self:Log("skipBtn AddClickEvent")
		self:CloseSelf()
	end)

	----[[ todo xde ??????????????????
	local widget = self.shareBtnCt:GetComponent(UIWidget)
	alignWidgetToTransform_Right(widget, self.itemName.transform, 10)
	--]]
end

function FloatAwardView:IsShowNameBg( isShow )
	self.isShowN = isShow
	if(isShow)then
		self:Show(self.nameBg)
	else
		self:Hide(self.nameBg)
	end
end

function FloatAwardView:addViewListener( )
	-- body
	self:AddClickEvent(self.intoPackBtn,function (  )
		-- body
		if(not self.isProcessEffectEnd)then
			self:showEffectEnd()
		end
		if(self.currentShowData and self.currentShowData.callback) then
			self.currentShowData.callback()
		end
	end)

	self:AddClickEvent(self.equipBtn,function (  )
		-- body
		if(not self.isProcessEffectEnd)then
			local itemData = self.currentShowData.itemData
			-- local oper =  SceneItem_pb.EEQUIPOPER_ON
			if(itemData == nil or itemData.id == nil or itemData.id == 0)then
				-- MsgManager.FloatMsg(nil,"??????guid ??????")
				printRed("error! ??????guid ??????")
			elseif(self.currentShowData.btnText)then
			else
				-- ServiceItemProxy.Instance:CallEquip(oper,nil,tostring(itemData.id))
				FunctionItemFunc.CallEquipEvt(itemData)
			end
			self:showEffectEnd()
		end
	end)
end

function FloatAwardView:initData(  )
	-- body
	self.currentShowType = nil
	self.currentEffectPath = nil
	self.animator = nil
	self.isShowIng = false
	self.showListWithType = {}
	self.effectGo = nil  
	self.currentShowData = nil
	self.animEndName = "model3"	
	self.animStartName = "model1"
	self.isAnimChanging = false
	self.isShowIngIconAnim = false
	self.currentProfession = MyselfProxy.Instance:GetMyProfession()
	self.showTypeList = {}
	self.items = {}
	self.disableMsg = false
	for k,v in pairs(FloatAwardView.ShowType) do
		table.insert(self.showTypeList,v)
		self.showListWithType[v] = 	{}
	end
	table.sort(self.showTypeList,function(l,r) return l < r end)
	-- local itemDataList = self.viewdata.itemData	
	-- self:addItemDatasToShow(itemDataList)
	self.noShareFunction = not FloatAwardView.ShareFunctionIsOpen(  )
end

function FloatAwardView.ShareFunctionIsOpen(  )
	local socialShareConfig = AppBundleConfig.GetSocialShareInfo()
	if socialShareConfig == nil then
		return false
	end

	if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V9) then
		return false
	end
	return true
end

function FloatAwardView:checkIsPlayIngStartOrEndAnim(  )
	-- body
	if(self.animator)then
		local animState = self.animator:GetCurrentAnimatorStateInfo(0)
		local complete = animState.normalizedTime >= 1
		local isPlaying = animState:IsName(self.animEndName) or animState:IsName(self.animStartName)
		if(not complete and isPlaying or self.isShowIngIconAnim)then
			return true
		end
	end
end

function FloatAwardView.checkEffectType( itemData )
	-- body
	if(itemData.staticData)then
		if( BagProxy.CheckIs3DTypeItem(itemData.staticData.Type))then
			return FloatAwardView.ShowType.ModelType				
		elseif(BagProxy.CheckIsCardTypeItem(itemData.staticData.Type))then
			return FloatAwardView.ShowType.CardType
		else
			return FloatAwardView.ShowType.ItemType
		end
	end
	-- printOrange("2D item type :"..itemData.staticData.Type)
	return FloatAwardView.ShowType.IconType
end

function FloatAwardView.checkIsKFCAct( id )
	local tb = GameConfig.KFCItems or {}
	return TableUtility.ArrayFindIndex(tb,id) > 0
end

function FloatAwardView.checkIfCanEquip( itemData )
	-- body
	-- return FunctionItemCompare.Me():CompareItem(itemData)
	local bRet = false
	if(itemData and itemData.staticData)then
		if(QuickUseProxy.Instance:ContainsEquip(itemData))then
			bRet = true
		end

		if(QuickUseProxy.Instance:ContainsFashion(itemData.staticData.id))then
			bRet = true
		end
	end
	return bRet
end

function FloatAwardView.ShowRefineShareView( itemData )
	local showType = FloatAwardView.checkEffectType(itemData)
	if(showType and FloatAwardView.ShareFunctionIsOpen(  ))then
		local showData = EffectShowDataWraper.new(itemData,nil,FloatAwardView.ShowType.ItemType,FloatAwardView.EffectFromType.RefineType)
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ShareAwardView, viewdata = showData})
	end
end

function FloatAwardView.checkEffectPath( itemData )
	-- body
	return FloatAwardView.EffectPath.EffectType_1
end

function FloatAwardView.getInstance(  )
	-- body
	if(FloatAwardView.Instance == nil)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.FloatAwardView})
	end
	return FloatAwardView.Instance
end

function FloatAwardView:checkStartAnim(  )
	-- body
	if(not self:checkIsPlayIngStartOrEndAnim())then
		TimeTickManager.Me():ClearTick(self,FloatAwardView.TimeTickType.CheckAnim)
		self:changeBtnState()
		-- printRed("no isplaying start anim!!!")
	else
		-- printRed("isplaying start anim!!!")
	end
end

--data ?????????????????????ItemData
function FloatAwardView.addItemDataToShow( data,callback,btnText)
	-- body	
	local instance = FloatAwardView.getInstance()
	local showType = FloatAwardView.checkEffectType(data)
	if(showType)then
		local effectPath = FloatAwardView.checkEffectPath(data)	
		local showData = EffectShowDataWraper.new(data,effectPath,showType,FloatAwardView.EffectFromType.AwardType,callback)
		showData.btnText = btnText
		showType = showData.showType
		table.insert(instance.showListWithType[showType],showData)
	else
		LogUtility.Warning("error!!! incorrect item type!")
	end
end

--datas ??????????????????ItemData??????
function FloatAwardView.addItemDatasToShow( datas ,callback, btnText,disableMsg)
	-- body
	local instance = FloatAwardView.getInstance()
	for i=1,#datas do
		local single = datas[i]
		local id = Game.Myself.data.id
		local params = {}
		params[1] = single.staticData.id
		params[2] = single.num or 1
		if(single.num ==nil or single.num ==0)then
			FloatAwardView.addItemDataToShow(single,callback,btnText)
			instance.items[#instance.items+1] = {single.staticData.id,1}
		else
			-- MsgManager.ShowMsgByIDTable(11,params,id)
			instance.items[#instance.items+1] = {single.staticData.id,single.num}
			for i=1,single.num do
				FloatAwardView.addItemDataToShow(single,callback,btnText)
			end	
		end
	end
	instance.disableMsg = disableMsg
	instance:checkStart()
end

function FloatAwardView.gmAddItemDataToShow( data )
	-- body
	local instance = FloatAwardView.getInstance()
	local showType = FloatAwardView.ShowType.IconType
	local effectPath = FloatAwardView.checkEffectPath(data)
	-- stack("gmAddItemDataToShow")
	-- printRed(data.data)
	-- printRed(showType)
	-- printRed(data.type)
	local tb = TableUtil.unserialize(data.data)
	if(tb)then  
		local showData = EffectShowDataWraper.new(data,effectPath,showType,FloatAwardView.EffectFromType.GMType)
		table.insert(instance.showListWithType[showType],showData)
	end
end

function FloatAwardView.gmAddItemDatasToShow( list )
	-- body
	for i=1,#list do
		local single = list[i]
		FloatAwardView.gmAddItemDataToShow(single)			
	end
	local instance = FloatAwardView.getInstance()
	instance:checkStart()
end

function FloatAwardView:showEffectEnd( )
	-- bod	
	self.isProcessEffectEnd = true	
	if(self.animator and self.isShowIng)then		
		self.animator:Play(self.animEndName,-1,0);
		self.checkAnimTimerId = LuaTimer.Add(0,16,function ( )
			-- body
			if(self.animator)then
				local animState = self.animator:GetCurrentAnimatorStateInfo(0)
				local complete = animState.normalizedTime >= 1
				local isPlaying = animState:IsName(self.animEndName)
				if(complete and isPlaying)then
					if(self.checkAnimTimerId)then					
						LuaTimer.Delete(self.checkAnimTimerId)
					end
					self.checkAnimTimerId = nil
					self:HandleEffectEnd()
					self.isProcessEffectEnd = false	
				end
			else
				if(self.checkAnimTimerId)then					
					LuaTimer.Delete(self.checkAnimTimerId)
				end
			end
		end)
	else
		self:HandleEffectEnd()
		self.isProcessEffectEnd = false
	end	
end

function FloatAwardView:HandleEffectEnd(  )
	-- body
	self:startShow()
end

function FloatAwardView:checkStart(  )
	-- body
	if(not self.isShowIng)then
		self:startShow()
	end
end

function FloatAwardView:isShowSkipBtn(  )
	local num = 0
	for i=1,#self.showTypeList do
		local single = self.showTypeList[i]
		num  = num + #self.showListWithType[single]
	end
	return num > 0
end

function FloatAwardView:startShow(  )
	-- body	
	printRed("startShow")
	local showType = self:nextShowType()
	-- printRed(showType)
	if(showType)then
		self:PlayCommonSound(AudioMap.Maps.FunctionOpen);
		self.isShowIng = true
		local showData = self.showListWithType[showType][1]
		if(showType == FloatAwardView.ShowType.ModelType)then
			-- printRed("show model type item")			
			self:showModelEffect(showData)
			-- printRed("showData.itemData"..showData.itemData.staticData.NameZh)
			table.remove(self.showListWithType[showType],1)
			-- printRed(#self.showListWithType[showType])
		elseif(showType == FloatAwardView.ShowType.CardType)then
			-- printRed(showType)				
			self:showIconEffect(showData)
			table.remove(self.showListWithType[showType],1)	
		elseif(showType == FloatAwardView.ShowType.IconType)then			
			-- printRed(showType)
			self:showIconEffect(showData)
			table.remove(self.showListWithType[showType],1)	
		elseif(showType == FloatAwardView.ShowType.ItemType)then			
			-- printRed(showType)
			self:showIconEffect(showData)
			table.remove(self.showListWithType[showType],1)	
		end	
		self:changeShowMode(showData)
		if(self:isShowSkipBtn())then
			self:Show(self.skipBtn)
		else
			self:Hide(self.skipBtn)
		end
		-- TimeTickManager.Me():CreateTick(0,16,self.checkStartAnim,self,FloatAwardView.TimeTickType.CheckAnim)			
	else
		-- printRed("CloseSelf")
		self:CloseSelf()
	end
end

function FloatAwardView:changeShowMode( showData )
	-- body
	local type = showData.showType
	local canEquip = FloatAwardView.checkIfCanEquip(showData.itemData)
	tempVector3:Set(LuaGameObject.GetLocalPosition(self.intoPackBtn.transform))
	local effectFromType = showData.effectFromType
	if(effectFromType == FloatAwardView.EffectFromType.AwardType)then
		self.equipLabel.text = ZhString.FloatAwardView_Equip
		self.intoPackBtn:SetActive(true)
		if(showData.btnText)then
			self.intoPackLabel.text = showData.btnText
		else
			self.intoPackLabel.text = ZhString.FloatAwardView_IntoPackage
		end
		
		if(canEquip)then
			self:Show(self.equipBtn)
			tempVector3:Set(-92,tempVector3.y,tempVector3.z)
			self.intoPackBtn.transform.localPosition = tempVector3
		elseif(showData.btnText)then
			self.equipLabel.text = ZhString.FloatAwardView_Confirm
			self:Show(self.equipBtn)
			tempVector3:Set(-92,tempVector3.y,tempVector3.z)
			self.intoPackBtn.transform.localPosition = tempVector3
		else
			self:Hide(self.equipBtn)
			tempVector3:Set(0,tempVector3.y,tempVector3.z)
			self.intoPackBtn.transform.localPosition = tempVector3
		end

		if(type == FloatAwardView.ShowType.ModelType)then			
			self:Show(self.modelShow)
		elseif(type == FloatAwardView.ShowType.CardType)then
			self:Hide(self.modelShow)
		end
	elseif(effectFromType == FloatAwardView.EffectFromType.GMType)then
		self.intoPackLabel.text = ZhString.FloatAwardView_Confirm
		self:Hide(self.equipBtn)
		tempVector3:Set(0,tempVector3.y,tempVector3.z)
		self.intoPackBtn.transform.localPosition = tempVector3
		self.modelShow:SetActive(false)
	end

	if(showData:canBeShared() and not self.noShareFunction)then
		self:Show(self.shareBtnCt)
	else
		self:Hide(self.shareBtnCt)
	end
end

function FloatAwardView:changeBtnState(  )
	local canEquip = FloatAwardView.checkIfCanEquip(self.currentShowData.itemData)
	tempVector3:Set(LuaGameObject.GetLocalPosition(self.intoPackBtn.transform))
	local effectFromType = self.currentShowData.effectFromType
	if(effectFromType == FloatAwardView.EffectFromType.AwardType)then
		self.intoPackBtn:SetActive(true)
		if(canEquip)then
			self.equipBtn:SetActive(true)		
			tempVector3:Set(-92,tempVector3.y,tempVector3.z)
			self.intoPackBtn.transform.localPosition = tempVector3	
		else		
			self.equipBtn:SetActive(false)
			tempVector3:Set(0,tempVector3.y,tempVector3.z)
			self.intoPackBtn.transform.localPosition = tempVector3
		end
	else
		tempVector3:Set(0,tempVector3.y,tempVector3.z)
		self.intoPackBtn.transform.localPosition = tempVector3
	end
end


function FloatAwardView:nextShowType(  )
	-- body
	if(self.currentShowType and #self.showListWithType[self.currentShowType]>1)then
		return self.currentShowType
	else
		for i=1,#self.showTypeList do
			local single = self.showTypeList[i]
			if(#self.showListWithType[single]>0)then
				return single
			end
		end
	end
end

function FloatAwardView:showCardEffect(showData)

end

function FloatAwardView:showIconEffect(showData)
	-- printRed("showIconEffect")
	-- print(#showDatas)
	if(self.currentShowData)then
		self.currentShowData:Exit()
	end	
	local effectPath = showData.effectPath
	local showType = showData.showType
	self:initEffectModel(effectPath)
	local effectIcon = self:FindGO("icon",self:FindGO("13itemShine"))

	-- if(showType == FloatAwardView.ShowType.CardType)then
	-- 	self:Hide(self.itemNameCt)
	-- else
	-- 	self.Show(self.itemNameCt)
	-- end	
	showData:getModelObj(effectIcon)		
	self.itemName.text = showData.dataName
	
	-- if(#showDatas > 10 or #showDatas <= 5)then
	-- 	self.tableCpn.maxPerLine = 5
	-- else		
	-- 	self.tableCpn.maxPerLine = math.ceil(#showDatas/2)
	-- end
	-- self.tableCpn:Reposition()
	self.currentEffectPath = effectPath
	self.currentShowType = showType
	self.currentShowData = showData
	-- self.iconShowIndex = 1 
	-- for i=1,#self.iconShowObj do
	-- 	local single = self.iconShowObj[i]
	-- 	single:SetActive(false)
	-- end
	self.animator:Play(self.animStartName,-1,0);
	self.isShowIngIconAnim = true
	-- TimeTickManager.Me():CreateTick(0,200,self.showIconOneByOne,self,FloatAwardView.TimeTickType.ShowIconOneByOne)
end

-- function FloatAwardView:showIconOneByOne(  )
-- 	-- body
-- 	local single = self.iconShowObj[self.iconShowIndex]
-- 	if(single)then
-- 		single:SetActive(true)
-- 	end
-- 	if(#self.iconShowObj >10 and self.iconShowIndex >=10)then
-- 		TimeTickManager.Me():ClearTick(self,FloatAwardView.TimeTickType.ShowIconOneByOne)
-- 		self.isShowIngIconAnim = false
-- 		for i=self.iconShowIndex+1,#self.iconShowObj do
-- 			local single = self.iconShowObj[i]
-- 			single:SetActive(true)
-- 		end
-- 	elseif(not single)then
-- 		TimeTickManager.Me():ClearTick(self,FloatAwardView.TimeTickType.ShowIconOneByOne)
-- 		self.isShowIngIconAnim = false	
-- 	else
-- 		self.iconShowIndex = 1 + self.iconShowIndex
-- 	end
-- end

--ZGBTODO
function FloatAwardView:showModelEffect(showData)
	-- body	
	if(self.currentShowData)then
		self.currentShowData:Exit()
	end	

	self:initEffectModel(showData.effectPath)	
	if(showData.itemData.equipInfo)then
		local itemModelName = showData.itemData.equipInfo.equipData.Model
		local modelConfig = ModelShowConfig[itemModelName]
		tempVector3:Set(0,0,0)
		tempQuaternion:Set(0,0,0,0)
		tempVector3_scale:Set(1,1,1)
		if(modelConfig)then	
			local position = modelConfig.localPosition
			tempVector3:Set(position[1],position[2],position[3])
			local rotation = modelConfig.localRotation
			tempQuaternion:Set(rotation[1],rotation[2],rotation[3],rotation[4])
			local scale = modelConfig.localScale
			tempVector3_scale:Set(scale[1],scale[2],scale[3])
		elseif(showData.itemData:IsMount())then
			tempVector3:Set(0,0,0)
			tempQuaternion.eulerAngles = tempVector3
			tempVector3:Set(0,-0.17,0)
			tempVector3_scale:Set(0.3,0.3,0.3)
		else
			printRed("can't find "..itemModelName.." in ModelShowConfig")
			tempVector3:Set(0,0,0)
			tempQuaternion.eulerAngles = tempVector3
			tempVector3_scale:Set(1,1,1)
		end

		local model = self:FindGO("model",self.effectGo)
		local itemModel = showData:getModelObj(model)
		if(itemModel == nil)then
			-- MsgManager.ShowMsgByIDTable(20)
			-- MsgManager.FloatMsg(nil,"?????????????????????")
			printRed("error! ?????????????????????")
		else
			itemModel:ResetLocalPosition(tempVector3)
			itemModel:ResetLocalEulerAngles(tempQuaternion.eulerAngles)
			itemModel:ResetLocalScale(tempVector3_scale)
		end
		local name = showData.dataName
		self.Show(self.itemNameCt)
		self.itemName.text = name
		--TODO
		-- self:Hide(self.propertyLabel.gameObject)
		local property = showData.itemData.equipInfo:BasePropStr()
		if(not property or property == "")then
			local buff = showData.itemData.equipInfo.equipData.UniqueEffect.buff
			buff = buff and buff[1] or nil
			if(buff)then
				buff = Table_Buffer[buff]
				if(buff and buff.Dsc ~= "")then
					-- self.propertyLabel.text = buff.Dsc
					-- self:Show(self.propertyLabel.gameObject)
				end
			end
		else
			-- self:Show(self.propertyLabel.gameObject)
		end
		
		self.animator:Play(self.animStartName,-1,0);
		self.currentShowType = showData.showType
		self.currentShowData = showData
		self.currentEffectPath = showData.effectPath
	else
		printRed("equipInfo is nil!!!")
	end
end

function FloatAwardView:initEffectModel( effectPath )
	-- body
	if(self.currentEffectPath ~= effectPath and self.effectGo)then
		Game.GOLuaPoolManager:AddToUIPool(self.currentEffectPath,self.effectGo)
		self.effectGo = nil
	end

	if(not self.effectGo)then		
		self.effectGo = Game.AssetManager_UI:CreateAsset(effectPath,self.gameObject);
		self.effectContainer:AddChild(self.effectGo);
		tempVector3:Set(1,1,1)
		self.effectGo.transform.localScale = tempVector3
		tempVector3:Set(0,0,0)
		self.effectGo.transform.localRotation = tempVector3
		self.effectGo.transform.localPosition = tempVector3
		self.animator = self.effectGo:GetComponent(Animator)			
	end	
end

function FloatAwardView:OnExit()
	-- body	
	FloatAwardView.super.OnExit(self)
	if(self.currentShowData)then
		self.currentShowData:Exit()
	end
	self.currentShowType = nil
	self.currentShowData = nil
	self.currentEffectPath = nil
	self.isShowIngIconAnim = false
	self.isShowIng = false
	if(self.checkAnimTimerId)then
		LuaTimer.Delete(self.checkAnimTimerId)
	end
	TimeTickManager.Me():ClearTick(self)
	self.checkAnimTimerId = nil
	FloatAwardView.Instance = nil
	self.animator = nil
	self.effectGo = nil
	FloatAwardView.Instance = nil

	local id = Game.Myself.data.id
	if(self.disableMsg)then
		return
	end
	if(self.items and #self.items>0)then
		for i=1,#self.items do
			local single = self.items[i]
			MsgManager.ShowMsgByIDTable(11,single,id)
		end
	end
	--ZGBTODO

	-- local emoji = math.random(#GameConfig.RandomExpressionAfterAward)
	-- local emojiId = GameConfig.RandomExpressionAfterAward[emoji]
	-- local actionId = 10003

	-- local myself = MyselfProxy.Instance.myself.roleAgent

	-- if(myself.idle)then
	-- 	if(myself:IsCurrentIdleAI(nil))then		
	-- 		self:sendNotification(EmojiEvent.PlayEmoji, {roleid = MyselfProxy.Instance.myself.id, emoji = emojiId});
	-- 	end
	-- end
end

function FloatAwardView:handleEffectStart(  )
	-- body
end