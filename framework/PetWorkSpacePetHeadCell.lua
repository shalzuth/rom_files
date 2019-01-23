autoImport("BaseCell")
PetWorkSpacePetHeadCell = class("PetWorkSpacePetHeadCell", BaseCell)

function PetWorkSpacePetHeadCell:Init()
	self.pos = self:FindGO("content")
	self.icon = self:FindComponent("PetHead",UISprite)
	self.level = self:FindComponent("Lvl", UILabel)
	self.friendlyLvl = self:FindComponent("FriendlyLvl", UILabel)
	self.friendly = self:FindGO("Friendly")
	self.choosenFlag = self:FindGO("ChoosenFlag")
	self.workingFlag = self:FindComponent("WorkingFlag",UILabel)
	
	self.limitFlag = self:FindGO("LimitFlag")
	PetWorkSpacePetHeadCell.super.Init(self)
	self:AddCellClickEvent()
end

local tempColor = LuaColor.white
function PetWorkSpacePetHeadCell:SetData(data)
	if(data)then
		self.pos:SetActive(true)
		self.data = data
		self.guid = data.guid
		IconManager:SetFaceIcon(data:GetHeadIcon(), self.icon)
		self.level.text = string.format(ZhString.PetAdventure_Lv,data.lv)
		self.friendlyLvl.text = data.friendlv
		local state = data.state
		ColorUtil.WhiteUIWidget(self.icon)
		self:Show(self.level)
		self:Hide(self.friendly)
		self:Hide(self.limitFlag)
		if(state==PetWorkSpaceProxy.EPetStatus.EPETWORK_REJECT)then
			self:Hide(self.workingFlag)
			self:Hide(self.level)
			tempColor:Set(1.0/255.0,2.0/255.0,3.0/255.0,160/255)
			self.icon.color = tempColor
			-- ColorUtil.GrayUIWidget(self.icon)
		elseif(state==PetWorkSpaceProxy.EPetStatus.EPETWORK_FIGHT)then
			self:Show(self.workingFlag)
			self.workingFlag.text = ZhString.PetWorkSpace_WorkingFlag
		elseif(state==PetWorkSpaceProxy.EPetStatus.EPETWORK_Scene)then
			self:Show(self.workingFlag)
			self.workingFlag.text = ZhString.PetWorkSpace_Scene
		elseif(state==PetWorkSpaceProxy.EPetStatus.EPETWORK_IDLE)then
			self:Show(self.friendly)
			self:Hide(self.workingFlag)
		elseif(state==PetWorkSpaceProxy.EPetStatus.EPETWORK_SPACE_LIMITED)then
			self:Hide(self.workingFlag)
			self:Show(self.limitFlag)
		end
		self:UpdateChoose()
	else
		self.pos:SetActive(false)
	end
end

function PetWorkSpacePetHeadCell:SetChoosePetID(id)
	self.chooseID = id
	self:UpdateChoose()
end

function PetWorkSpacePetHeadCell:UpdateChoose()
	if(self.guid and self.guid==self.chooseID)then
		self.choosenFlag:SetActive(true)
	else
		self.choosenFlag:SetActive(false)
	end
end