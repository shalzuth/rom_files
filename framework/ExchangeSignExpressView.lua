autoImport("EffectShowDataWraper")

ExchangeSignExpressView = class("ExchangeSignExpressView",ContainerView)

ExchangeSignExpressView.ViewType = UIViewType.PopUpLayer

function ExchangeSignExpressView:Init()
	self:FindObj()	
	self:AddBtnEvt()
	self:AddViewEvt()
	self:InitShow()
end

function ExchangeSignExpressView:FindObj()
	self.toName = self:FindGO("ToName"):GetComponent(UILabel)
	self.fromName = self:FindGO("FromName"):GetComponent(UILabel)
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.iconContainer = self:FindGO("IconContainer")
	self.modelContainer = self:FindGO("ModelContainer")
	self.modelRoot = self:FindGO("ModelRoot")
end

function ExchangeSignExpressView:AddBtnEvt()
	local acceptBtn = self:FindGO("AcceptBtn")
	self:AddClickEvent(acceptBtn,function ()
		self:Accept()
	end)
	local refuseBtn = self:FindGO("RefuseBtn")
	self:AddClickEvent(refuseBtn,function ()
		self:Refuse()
	end)
end

function ExchangeSignExpressView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.MapGingerBreadNpcCmd, self.HandleMapGingerBreadNpc)
end

function ExchangeSignExpressView:InitShow()
	local data = ShopMallProxy.Instance:GetExpressData()
	if data then
		self.toName.text = Game.Myself.data.name
		if not data:GetAnonymous() then
			self.fromName.text = string.format(ZhString.ShopMall_ExchangeExpressFrom , data:GetSenderName())
		end

		self.content.text = data:GetContent()

		local itemData = data:GetItemData()
		local showType = ShopMallProxy.Instance:CheckItemType(itemData)
		if showType then
			self.itemShowWraper = EffectShowDataWraper.new(itemData, nil, showType, nil)
			self:ShowItem()
		else
			self.modelRoot:SetActive(false)
			
			local obj = self:LoadPreferb("cell/ItemCell", self.iconContainer)
			obj.transform.localPosition = Vector3.zero

			local itemCell = BaseItemCell.new(obj)
			itemCell:SetData(itemData)
		end

		local bgId = data:GetBg()
		local sendMoney = GameConfig.Exchange.SendMoney
		if sendMoney[bgId] then		
			self:LoadPreferb("cell/"..sendMoney[bgId].Resourse, self.gameObject, true)

			local color = sendMoney[bgId].fontcolor
			local hasc, rc = ColorUtil.TryParseHexString(color)
			self.fromName.color = rc
			self.toName.color = rc
		end
	end	
end

function ExchangeSignExpressView:ShowItem()
	if self.itemShowWraper then	
		if self.itemShowWraper.showType == FloatAwardView.ShowType.ModelType then
			local obj = self.itemShowWraper:getModelObj(self.modelContainer)
			self:ShowItemModel(obj)
		end
	end
end

local posVec = LuaVector3.zero
local scaleVec = LuaVector3.zero
local rotationQua = LuaQuaternion.identity
function ExchangeSignExpressView:ShowItemModel(obj)
	if self.itemShowWraper.itemData.equipInfo then

		posVec:Set(0,0,0)
		rotationQua:Set(0,0,0,0)
		scaleVec:Set(1,1,1)

		local itemModelName = self.itemShowWraper.itemData.equipInfo.equipData.Model
		local modelConfig = ModelShowConfig[itemModelName]		
		if modelConfig then
			local position = modelConfig.localPosition
			posVec:Set(position[1],position[2],position[3])
			local rotation = modelConfig.localRotation
			rotationQua:Set(rotation[1],rotation[2],rotation[3],rotation[4])
			local scale = modelConfig.localScale
			scaleVec:Set(scale[1],scale[2],scale[3])
		end

		obj:ResetLocalPosition(posVec)
		obj:ResetLocalEulerAngles(rotationQua.eulerAngles)
		obj:ResetLocalScale(scaleVec)
	end
end

function ExchangeSignExpressView:Accept()
	local data = ShopMallProxy.Instance:GetExpressData()
	if data then
		local id = data:GetId()
		ServiceRecordTradeProxy.Instance:CallAcceptTradeCmd(id)
	end
	self:CloseSelf()
end

function ExchangeSignExpressView:Refuse()
	MsgManager.ConfirmMsgByID(25101, function ()
		local data = ShopMallProxy.Instance:GetExpressData()
		if data then
			local id = data:GetId()
			ServiceRecordTradeProxy.Instance:CallRefuseTradeCmd(id)
		end
		self:CloseSelf()
	end )
end

function ExchangeSignExpressView:HandleMapGingerBreadNpc(note)
	local data = note.body
	if data.isadd == false and data.userid == Game.Myself.data.id then
		local expressData = ShopMallProxy.Instance:GetExpressData()
		if expressData then
			local id = expressData:GetId()
			if id == data.data.giveid then
				self:CloseSelf()
			end
		end
	end
end