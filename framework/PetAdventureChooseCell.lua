local BaseCell = autoImport("BaseCell");
PetAdventureChooseCell = class("PetAdventureChooseCell", BaseCell)
local inactiveAlpha = 0.5

local PHASE = {
	NONE = 0,
	MATCH = 1, 		-- 等待中
	UNDERWAY = 2,	-- 冒险中
	FIGHTING = 3,	-- 出战中
}

function PetAdventureChooseCell:Init()
	self:FindObjs();
	self:AddCellClickEvent();
	self:AddEvts()
end

function PetAdventureChooseCell:FindObjs()
	self.headTipStick = self:FindGO("headTipStick"):GetComponent(UIWidget)
	self.icon = self:FindGO("icon"):GetComponent(UISprite);
	self.level = self:FindGO("petLv"):GetComponent(UILabel);
	self.name = self:FindGO("petName"):GetComponent(UILabel);
	self.chooseSymbol = self:FindGO("ChooseSymbol");
	self.phase = PHASE.NONE
	self.stateLab=self:FindGO("petState"):GetComponent(UILabel)
	self.content = self:FindGO("Content");
	self.transparenceImg=self:FindGO("bg"):GetComponent(UISprite)
	self.limitLab=self:FindGO("limitLab"):GetComponent(UILabel)
	self.iconPrefab=self:FindGO("prefab")
	local condition1 = self:FindGO("condition1"):GetComponent(UISprite)
	local condition2 = self:FindGO("condition2"):GetComponent(UISprite)
	local condition3 = self:FindGO("condition3"):GetComponent(UISprite)
	self.conditions={condition1,condition2,condition3 }
	
	-- todo xde fix ui
	self.stateLab.pivot = UIWidget.Pivot.Right;
end

function PetAdventureChooseCell:AddEvts()
	self:AddButtonEvent("icon",function ( obj )
		self:PassEvent(PetEvent.ClickPetAdventureIcon, self)
	end)
end

function PetAdventureChooseCell:SetData(data)
	self.data = data;

	if(data)then
		local format = string.format
		self.name.text=data.name
		self.skillids=data.skillids
		local face = data:GetHeadIcon()
		IconManager:SetFaceIcon(face,self.icon)
		local lv = data.lv
		local friendly = data.friendlv
		self.level.text=format(ZhString.PetAdventure_Lv,lv)
		self.content:SetActive(true);
		
		local chooseQuestData = PetAdventureProxy.Instance:GetChooseQuestData()
		local limitLv = chooseQuestData.staticData.Level
		local limit_friendly = GameConfig.PetAdventureMinLimit.limit_friendly_lv
		if(lv<limitLv and friendly<limit_friendly)then
			self:Show(self.limitLab)
			local l = format(ZhString.PetAdventure_LevelLimited,limitLv)
			local f = format(ZhString.PetAdventure_FriendlyLvLimited,limit_friendly)
			self.limitLab.text=format(ZhString.PetAdventure_newline,l,f)
		elseif(lv<limitLv and friendly>=limit_friendly)then
			self:Show(self.limitLab)
			self.limitLab.text=format(ZhString.PetAdventure_LevelLimited,limitLv)
		elseif(lv>=limitLv and friendly<limit_friendly)then
			self:Show(self.limitLab)
			self.limitLab.text=format(ZhString.PetAdventure_FriendlyLvLimited,limit_friendly)
		else
			self:Hide(self.limitLab)
		end
		-- 设置多选的宠物
		self:UpdateUI()
		self:UpdateChoose();
	else
		self.content:SetActive(false);
	end
end

function PetAdventureChooseCell:_updateCondition()
	for i=1,#self.conditions do
		self:Hide(self.conditions[i])
	end
	local locked = PetAdventureProxy.Instance:bPetlocked(self.data)
	if(locked)then
		return 
	end
	local chooseQuestData = PetAdventureProxy.Instance:GetChooseQuestData()
	local condition = chooseQuestData.staticData.Condition
	self.conditionUnLocked={}
	for i=1,#condition do
		local conditionData = Table_Pet_AdventureCond[condition[i]]
		if(nil==conditionData)then
			helplog("Table_Pet_AdventureCond 配置错误，错误ID：",tostring(condition[i]))
			return
		end
		local conType = conditionData.TypeID
		local conParam = conditionData.Param
		local staticIcon = conditionData.Icon
		local iconData = {}
		if('PetID'==conType)then
			if(self.data.petid==conParam[1])then
				iconData.typeID="PetID"
				iconData.icon=staticIcon
				self.conditionUnLocked[#self.conditionUnLocked+1]=iconData
			end
		elseif('Skill'==conType)then
			local skillids = self.skillids
			local paramID =conParam[1]
			local paramLimit = conParam[2]
			for i=1,#skillids do
				local resultID = math.ceil(skillids[i]/1000)
				if(resultID==paramID)then
					iconData.typeID="Skill"
					iconData.icon=staticIcon
					self.conditionUnLocked[#self.conditionUnLocked+1]=iconData
				end
			end
		elseif('Friendly'==conType)then
			if(self.data.friendlv>=conParam[1])then
				iconData.typeID="Friendly"
				iconData.icon=staticIcon
				self.conditionUnLocked[#self.conditionUnLocked+1]=iconData
			end
		elseif('Nature'==conType)then
			if(Table_Monster[self.data.petid].Nature==conParam[1])then
				iconData.typeID="Nature"
				iconData.icon=staticIcon
				self.conditionUnLocked[#self.conditionUnLocked+1]=iconData
			end
		elseif('Race'==conType)then
			if(Table_Monster[self.data.petid].Race==conParam[1])then
				iconData.typeID="Race"
				iconData.icon=staticIcon
				self.conditionUnLocked[#self.conditionUnLocked+1]=iconData
			end
		end
	end
	for i=1,#self.conditionUnLocked do
		local typeid = self.conditionUnLocked[i].typeID
		local icon = self.conditionUnLocked[i].icon
		if(typeid=='PetID')then
			IconManager:SetFaceIcon(icon,self.conditions[i])
		elseif(typeid=='Skill')then
			IconManager:SetSkillIcon(icon,self.conditions[i])
		else
			IconManager:SetUIIcon(icon,self.conditions[i])
		end
		self:Show(self.conditions[i])
	end
end

function PetAdventureChooseCell:UpdateUI()
	local data = self.data
	local phase = data.phase
	self.name.text = data.name
	local PHASE = PetAdventureProxy.PETPHASE
	if(phase==PHASE.UNDERWAY)then
		self:Show(self.stateLab)
		self.stateLab.text=ZhString.PetAdventure_OnAdventure
		self:Hide(self.limitLab)
	elseif(phase==PHASE.MATCH)then
		self:Hide(self.stateLab)
	elseif(phase==PHASE.FIGHTING)then
		self:Show(self.stateLab)
		self.stateLab.text=ZhString.PetAdventure_Fighting
		self:Hide(self.limitLab)
	end
	self:SetCellState()
	self:_updateCondition()
end

function PetAdventureChooseCell:SetCellState()
	local sprite = self.transparenceImg
	local locked = PetAdventureProxy.Instance:bPetlocked(self.data)
	local alpha = not locked and 1 or inactiveAlpha
	self.transparenceImg.color = Color(sprite.color.r,sprite.color.g,sprite.color.b,alpha)
end

function PetAdventureChooseCell:UpdateChoose()
	local showChoose=false
	local multiChoose = PetAdventureProxy.Instance:GetMatchPetData()
	for i=1,#multiChoose do
		if(self.data and 0~=multiChoose[i] and multiChoose[i].guid==self.data.guid)then
			showChoose=true
			break
		end
	end
	self.chooseSymbol:SetActive(showChoose)
end


