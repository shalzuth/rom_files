TransSexPreView = class("TransSexPreView",SubMediatorView)

local tempVector3 = LuaVector3.zero
local pinkTop = LuaColor.New(1, 123/255, 164/255, 1)
local pinkBottom = LuaColor.New(1, 182/255, 206/255, 1)
local blueTop = LuaColor.New(94/255, 146/255, 236/255, 1)
local blueBottom = LuaColor.New(159/255, 190/255, 238/255, 1)

function TransSexPreView:Init()
	TransSexPreView.super.Init(self)
	self:InitView()
	self:SetModel()
end 

function TransSexPreView:InitView()
	-- body
	self.ctObj = self:FindGO("TransSexPreView")
	local obj = self:LoadPreferb("view/TransSexPreView",self.ctObj)
	self.gameObject = obj

	local panel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(obj, UIPanel, true)
	for i=1,#uipanels do
		uipanels[i].depth = uipanels[i].depth + panel.depth;
	end
	tempVector3:Set(0,0,0)
	obj.transform.localPosition = tempVector3	

	local playerModel = self:FindGO("PlayerModel")
	self.renderQByUI = playerModel:GetComponent(RenderQByUI);
	local playerModelContainer = self:FindGO("PlayerModelContainer")
	self.PlayerModel = self:FindGO("PlayerModel"):GetComponent(UITexture)
	self:AddDragEvent(playerModelContainer,function ( obj,delta )
		self:RotateRoleEvt(obj,delta)
	end)
	self.cancelBtn = self:FindGO("CancelBtn")
	self.confirmBtn = self:FindGO("ConfirmBtn")
	local GenderSymbol = self:FindGO("GenderSymbol")
	self.maleSymbol = self:FindGO("male",GenderSymbol.gameObject):GetComponent(GradientUISprite)
	self.femaleSymbol = self:FindGO("female",GenderSymbol.gameObject):GetComponent(GradientUISprite)
end

function TransSexPreView:RotateRoleEvt(go,delta)
	if(self.model)then
		self.model:RotateDelta( -delta.x );
	end
end

function TransSexPreView:SetModel()
	local userData = Game.Myself.data.userdata
	local sex = userData:Get(UDEnum.SEX)
	local profession = userData:Get(UDEnum.PROFESSION)
	local body = 0
	sex = 3 - sex	-- male == 1, female == 2
	local _GameConfigNewRole = GameConfig.NewRole
	local hair = 0
	local eye = 0

	if sex == 1 then
		hair = _GameConfigNewRole.default_hair.male
		eye = _GameConfigNewRole.default_eye.male
		body = Table_Class[profession].MaleBody
	elseif sex == 2 then
		hair = _GameConfigNewRole.default_hair.female
		eye = _GameConfigNewRole.default_eye.female
		body = Table_Class[profession].FemaleBody
	end
	hair = ShopDressingProxy.Instance:GetHairStyleIDByItemID(hair)

	local head = userData:Get(UDEnum.HEAD)
	-- re-calculate head
	local headData = Table_Equip[head]
	if nil ~= headData then
		local invalidHairIDs = headData.HairID
		if nil ~= invalidHairIDs and 0 < #invalidHairIDs -- hair conflicts with head dec
			and 0 < TableUtility.ArrayFindIndex(invalidHairIDs, hair) then
			head = 0
		end
		local sexEquip = headData.SexEquip or 0
		if sexEquip ~=0 and sexEquip ~= sex then
			head = 0
		end
	end
	local parts = Asset_Role.CreatePartArray()
	local _partIndex = Asset_Role.PartIndex
	local _partIndexEX = Asset_Role.PartIndexEx
	parts[_partIndex.Body] = body
	parts[_partIndex.Hair] = hair
	parts[_partIndex.Eye] = eye
	parts[_partIndex.LeftWeapon] = 0 -- hide weapon
	parts[_partIndex.RightWeapon] = 0
	parts[_partIndex.Head] = head or 0
	parts[_partIndex.Wing] = userData:Get(UDEnum.BACK) or 0
	parts[_partIndex.Face] = userData:Get(UDEnum.FACE) or 0
	parts[_partIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
	parts[_partIndex.Mount] = 0
	parts[_partIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
	parts[_partIndexEX.Gender] = sex or 0
	haircolor = Table_HairStyle[hair].DefaultColor
	parts[_partIndexEX.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR)	
	parts[_partIndexEX.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0

	self.model = UIModelUtil.Instance:SetRoleModelTexture(self.PlayerModel, parts)
	self.model:RegisterWeakObserver(self)
	if(self.model)then
		tempVector3:Set(0,-0.15,0)
		self.model:SetPosition(tempVector3)
		tempVector3:Set(-0.67,13.62,0)
		self.model:SetEulerAngleY(tempVector3)
	end
	Asset_Role.DestroyPartArray(parts)
	self:SetSymbols(sex)
end

function TransSexPreView:SetSymbols(newSex)
	if newSex == 1 then
		self.maleSymbol.gradientTop = blueTop
		self.maleSymbol.gradientBottom = blueBottom
		self.femaleSymbol.gradientTop = LuaColor.white
		self.femaleSymbol.gradientBottom = LuaColor.white
	else
		self.maleSymbol.gradientTop = LuaColor.white
		self.maleSymbol.gradientBottom = LuaColor.white
		self.femaleSymbol.gradientTop = pinkTop
		self.femaleSymbol.gradientBottom = pinkBottom
	end
end

function TransSexPreView:OnEnter(subId, dialogView)
	TransSexPreView.super.OnEnter(self)
	if not dialogView or not subId then return end
	local nowDialogData = dialogView.nowDialogData
	local optionStr = nowDialogData.Option
	local optionConfig = StringUtil.AnalyzeDialogOptionConfig(optionStr)
	for _,v in pairs(optionConfig) do
		if v.id == 7 then -- Option = '{确认,7},{取消,6}'		
			dialogView:RegisterMenuEvent(self.confirmBtn.gameObject,v.id,true)
		elseif v.id == 6 then
			dialogView:RegisterMenuEvent(self.cancelBtn.gameObject,v.id,true)
		end
	end
end

function TransSexPreView:ObserverDestroyed(obj)
	if(obj == self.model)then
		self.model = nil;
	end
end