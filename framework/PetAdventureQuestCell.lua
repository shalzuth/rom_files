local BaseCell = autoImport("BaseCell");
PetAdventureQuestCell = class("PetAdventureQuestCell", BaseCell)

local specialColor = Color(227.0/255.0,219.0/255.0,252.0/255.0,1)

PetQuestEvent = {
	OnClickMonster = "PetQuestEvent_OnClickMonster",
}
local EStatusImg = 
{
	FINISHED="pet_icon_finish",
	UNDERWAY="pvp_icon_fighting",
}

local allMonster = 'pet_icon_all'

function PetAdventureQuestCell:Init()
	self:FindObjs();
	self:AddEvt()
	self:AddCellClickEvent();
end

function PetAdventureQuestCell:FindObjs()
	self.bgImg = self:FindGO("bg"):GetComponent(UISprite);
	self.level = self:FindGO("lv"):GetComponent(UILabel);
	self.name = self:FindGO("name"):GetComponent(UILabel);
	self.mapLab = self:FindComponent("mapLab", UILabel);
	self.chooseSymbol = self:FindGO("ChooseSymbol");
	self.stateImg = self:FindComponent("stateImg",UISprite)
	self.monsterIcon=self:FindComponent("monsterIcon",UISprite)
	self.content = self:FindGO("Content");
end

function PetAdventureQuestCell:AddEvt()
	self:AddClickEvent(self.monsterIcon.gameObject, function ()
		self:PassEvent(PetQuestEvent.OnClickMonster, self)
	end)
end

function PetAdventureQuestCell:SetData(data)
	self.data = data;
	if(data)then
		self.state = data.status
		self.content:SetActive(true);
		self:UpdateUI()
		self:UpdateChoose();
	else
		self.content:SetActive(false);
	end
end

function PetAdventureQuestCell:UpdateUI()
	local state = self.state
	local staticData = self.data.staticData
	self.name.text = staticData.NameZh
	self.monsterId = self.data.specid
	if(nil==self.monsterId or 0==self.monsterId)then
		self.mapLab.text = staticData.SmallArea
	else
		self.mapLab.text = Table_Monster[self.monsterId] and Table_Monster[self.monsterId].NameZh
	end
	self.level.text=string.format(ZhString.PetAdventure_Lv,staticData.Level)
	local bgColor = staticData.QuestType==1 and specialColor or ColorUtil.NGUIWhite
	self.bgImg.color = bgColor
	self:_setStatus(state)
	if(staticData.QuestType==1)then
		self:Hide(self.monsterIcon)
	else
		self:Show(self.monsterIcon)
		self:_setFaceIcon(self.monsterId)
	end
end

function PetAdventureQuestCell:_setFaceIcon(id)
	if(id==nil or id==0)then
		IconManager:SetUIIcon(allMonster,self.monsterIcon)	
	else
		IconManager:SetFaceIcon(Table_Monster[id].Icon, self.monsterIcon)
	end
end

function PetAdventureQuestCell:_setStatus(state)
	if(state==PetAdventureProxy.QuestPhase.UNDERWAY)then
		IconManager:SetUIIcon(EStatusImg.UNDERWAY,self.stateImg)
		self:Show(self.stateImg)
	elseif(state==PetAdventureProxy.QuestPhase.FINISHED)then
		IconManager:SetUIIcon(EStatusImg.FINISHED,self.stateImg)
		self:Show(self.stateImg)
	elseif(state==PetAdventureProxy.QuestPhase.MATCH)then
		self:Hide(self.stateImg)
	end
end

function PetAdventureQuestCell:SetChoose(chooseId)
	self.chooseId = chooseId
	self:UpdateChoose()
end

function PetAdventureQuestCell:SetChooseSpecial(monsterId)
	if(nil==monsterId)then
		self:_setFaceIcon(self.monsterId)
	else
		self.monsterId=monsterId
		self:_setFaceIcon(monsterId)
	end
end


function PetAdventureQuestCell:UpdateChoose()
	if(self.data and self.chooseId and self.data.id == self.chooseId)then
		self.chooseSymbol:SetActive(true);
	else
		self.chooseSymbol:SetActive(false);
	end
end


