autoImport("ChangeHeadCombineCell")

ChangeHeadView = class("ChangeHeadView", ContainerView)
ChangeHeadView.ViewType = UIViewType.PopUpLayer

function ChangeHeadView:OnExit()
	if self.choosePortrait then
		ServiceNUserProxy.Instance:CallUsePortrait(self.choosePortrait)
	end
	RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_MONSTER_IMG)
	ChangeHeadView.super.OnExit(self)
end

function ChangeHeadView:Init()
	self:AddEvts()
	self:AddViewEvts()
	self:InitView()
	
	--todo xde
	local label = self:FindGO("Label",self:FindGO("RevertBtn")):GetComponent(UILabel)
	label.fontSize = 20
	OverseaHostHelper:FixLabelOverV1(label,3,160)
end

function ChangeHeadView:AddEvts()
	local revertBtn = self:FindGO("RevertBtn")
	self:AddClickEvent(revertBtn,function ()
		self:Revert()
	end)
end

function ChangeHeadView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.NUserNewPortraitFrame , self.UpdatePortraitList)
end

function ChangeHeadView:InitView()
	local headCellObj = self:FindGO("HeadContainer")
	headCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), headCellObj);
	headCellObj.transform.localPosition = LuaVector3.zero
	self.mainHeadCell = PlayerFaceCell.new(headCellObj)
	self.mainHeadCell:HideHpMp()

	self.originalHeadData = HeadImageData.new()
	self.originalHeadData:TransByMyself()
	self.mainHeadCell:SetData(self.originalHeadData)

	local contentContainer = self:FindGO("ContentContainer")
	local wrapConfig = {
		wrapObj = contentContainer, 
		pfbNum = 6, 
		cellName = "ChangeHeadCombineCell", 
		control = ChangeHeadCombineCell, 
		dir = 1,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(ChangeHeadEvent.Select, self.HandleClickItem, self)

	self:UpdatePortraitList()

	if self.originalHeadData.iconData.type == HeadImageIconType.Simple then
		self.choosePortrait = Game.Myself.data.userdata:Get(UDEnum.PORTRAIT)
		self:SetChooseCell(true)
		self:SetChooseData(true)
	end	
end

function ChangeHeadView:Revert()
	self:SetChooseData(false)
	self:SetChooseCell(false)
	
	self:RevertMyselfHead()
	self.choosePortrait = 0
end

function ChangeHeadView:HandleClickItem(cellctl)
	if cellctl.data then
		local id = cellctl.data.id
		local staticData = Table_HeadImage[id]
		if staticData and staticData.Picture then
			self.mainHeadCell.headIconCell:SetSimpleIcon(staticData.Picture)

			self:SetChooseData(false)
			self:SetChooseCell(false)
			
			self.choosePortrait = id

			self:SetChooseData(true)
			cellctl:SetChoose(true)
		else
			errorLog(string.format("id : %s is not found in Table_HeadImage",tostring(id)))
		end
	end
end

function ChangeHeadView:UpdatePortraitList()
	local data = ChangeHeadProxy.Instance:GetPortraitList()
	local newData = self:ReUniteCellData(data, 5)
	self.itemWrapHelper:UpdateInfo(newData)
end

function ChangeHeadView:RevertMyselfHead()
	local myself = Game.Myself
	if myself then
		if myself.data:IsTransformed() then
			local monsterId = myself.data.props.TransformID:GetValue()
			local monsterIcon = monsterId and Table_Monster[monsterId].Icon
			if monsterIcon then
				self.mainHeadCell.headIconCell:SetSimpleIcon(monsterIcon)
			end
		else
			local userData = myself.data.userdata
			if(userData) then
				local hairID = userData:Get(UDEnum.HAIR) or nil
				local bodyID = userData:Get(UDEnum.BODY) or nil
				local sex = userData:Get(UDEnum.SEX) or nil
				local haircolor = userData:Get(UDEnum.HAIRCOLOR) or nil
				local headID = userData:Get(UDEnum.HEAD) or nil
				local faceID = userData:Get(UDEnum.FACE) or nil
				local mouthID = userData:Get(UDEnum.MOUTH) or nil
				local eye = userData:Get(UDEnum.EYE) or nil
				local headIcon = self.mainHeadCell.headIconCell
				headIcon:SetHairColor(hairID,haircolor)

				hairID,headID,faceID,mouthID = headIcon:ParseDisplayLogic(hairID, headID, faceID, mouthID)

				headIcon:SetHair(hairID)
				headIcon:SetHairAccessory(hairID)
				headIcon:SetBody(bodyID)
				headIcon:SetFace(sex)
				headIcon:SetHeadAccessory(headID)
				headIcon:SetFaceAccessory(faceID)
				headIcon:SetMouthAccessory(mouthID)
				headIcon:SetEye(eye)
				headIcon:Show(headIcon.avatarPars)
				headIcon:Hide(headIcon.simpleIcon.gameObject)
			end
		end
	end
end

function ChangeHeadView:SetChooseData(isChoose)
	local data = ChangeHeadProxy.Instance:GetPortraitList()
	for i=1,#data do
		if data[i].id == self.choosePortrait then
			data[i]:SetChoose(isChoose)
			break
		end
	end
end

function ChangeHeadView:SetChooseCell(isChoose)
	local cells = self.itemWrapHelper:GetCellCtls()
	for i=1,#cells do
		local cell = cells[i]
		for j=1,#cell.childrenObjs do
			local child = cell.childrenObjs[j]
			if child.data then
				if child.data.id == self.choosePortrait then
					child:SetChoose(isChoose)
					break
				end
			end
		end
	end
end

function ChangeHeadView:ReUniteCellData(datas, perRowNum)
	local newData = {}
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/perRowNum)+1;
			local i2 = math.floor((i-1)%perRowNum)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end