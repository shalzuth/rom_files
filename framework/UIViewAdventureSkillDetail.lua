autoImport('FuncZenyShop')

UIViewAdventureSkillDetail = class("UIViewAdventureSkillDetail", BaseTip)

function UIViewAdventureSkillDetail:Init()
	self:GetGameObjects()
	self:RegisterButtonClickEvent()
	self:Tutorial()
end

function UIViewAdventureSkillDetail:SetData(data)
	self.tipData = data
	self:InitializeModelSet()
	self:LoadView()
end

function UIViewAdventureSkillDetail:GetGameObjects()
	self.goIcon = self:FindGO("Icon")
	self.spIcon = self.goIcon:GetComponent(UISprite)
	self.goName = self:FindGO("Name")
	self.labName = self.goName:GetComponent(UILabel)
	self.goType = self:FindGO("Type")
	self.labType = self.goType:GetComponent(UILabel)
	self.goDescription = self:FindGO("Description")
	self.labDescription = self.goDescription:GetComponent(UILabel)
	self.goCondition = self:FindGO("Condition")
	self.goPreSkill = self:FindGO("PreSkill", self.goCondition)
	self.goPreSkillValue = self:FindGO("Value", self.goPreSkill)
	self.labPreSkillValue = self.goPreSkillValue:GetComponent(UILabel)
	self.goRequireAdventureLevel = self:FindGO("RequireAdventureLevel", self.goCondition)
	self.labRequireAdventureLevel = self.goRequireAdventureLevel:GetComponent(UILabel)
	self.goSkillPointCost1 = self:FindGO("SkillPointCost1", self.goCondition)
	self.labSkillPointCost1 = self.goSkillPointCost1:GetComponent(UILabel)
	self.goSkillPointCost2 = self:FindGO('SkillPointCost2')
	self.labSkillPointCost2 = self:FindGO('Lab', self.goSkillPointCost2):GetComponent(UILabel)
	self.goCurrency = self:FindGO('Currency')
	self.labCurrency = self:FindGO('Lab', self.goCurrency):GetComponent(UILabel)
	self.goButtonCancel = self:FindGO('ButtonCancel')
	self.goButtonLearn = self:FindGO('ButtonLearn')
	self.goButtonLearnNormal = self:FindGO('Normal', self.goButtonLearn)
	self.spButtonLearnNormal = self.goButtonLearnNormal:GetComponent(UISprite)
	self.goButtonLearnTitle = self:FindGO('Title', self.goButtonLearn)
	self.labButtonLearnTitle = self.goButtonLearnTitle:GetComponent(UILabel)
end

function UIViewAdventureSkillDetail:LoadView()
	self.labName.text = self.skillConf.NameZh
	IconManager:SetSkillIcon(self.skillConf.Icon, self.spIcon)
	self.labType.text = ZhString.AdventureSkill_AdventureSkill .. '(' .. GameConfig.SkillType[self.skillConf.SkillType].name .. ')'
	local skillConfDescFieldValue = self.skillConf.Desc
	if skillConfDescFieldValue ~= nil and not table.IsEmpty(skillConfDescFieldValue) then
		local skillDescriptionID = skillConfDescFieldValue[1].id
		local skillDescriptionConf = Table_SkillDesc[skillDescriptionID]
		if skillDescriptionConf == nil then
			LogUtility.Error(string.format("Can't find configure(%s) in SkillDesc.xlsx", skillDescriptionID))
		else
			local params = skillConfDescFieldValue[1].params
			self.labDescription.text = string.format(skillDescriptionConf.Desc, unpack(params))
		end
	end
	local skillConfConditionFieldValue = self.skillConf.Contidion
	if skillConfConditionFieldValue ~= nil and not table.IsEmpty(skillConfConditionFieldValue) then
		local preSkillID = skillConfConditionFieldValue.skillid
		if preSkillID == nil then
			self.labPreSkillValue.text = ZhString.MonsterTip_None
		else
			local preSkillConf = Table_Skill[preSkillID]
			self.labPreSkillValue.text = preSkillConf.NameZh
		end
	else
		LogUtility.Error(string.format("Field(Contidion, %d) in Skill.xlsx is illegal.", tostring(self.skillConf.id)))
	end
	local requireAdventureLevel = UIModelAdventureSkill.Instance():GetSkillRequireAppellation(self.skillShopItemData.id)
	requireAdventureLevel = requireAdventureLevel or 0
	if requireAdventureLevel ~= nil and requireAdventureLevel then
		self.labRequireAdventureLevel.text = string.format(ZhString.AdventureSkill_AdventureLevelCanLearn, Table_Appellation[requireAdventureLevel].Name)
	else
		LogUtility.Error(string.format('Local variable requireAdventureLevel is illegal.'))
	end
	self.labSkillPointCost1.text = string.format(ZhString.AdventureSkill_CostAdventureSkillPoint1, self.needSkillPointCost)
	self.labSkillPointCost2.text = tostring(self.needSkillPointCost)
	local strNeedCurrency = FuncZenyShop.FormatMilComma(self.needCurrency)
	if strNeedCurrency ~= nil then
		self.labCurrency.text = strNeedCurrency
	end
	if self.isReachEnoughAdventureLevelForLearn then
		self:EnableButtonLearn()
	else
		self:DisableButtonLearn()
	end
end

function UIViewAdventureSkillDetail:InitializeModelSet()
	self.skillShopItemData = self.tipData.skillShopItemData
	self.skillConf = self.tipData.skillConf
	self.adventureLevelID = UIModelAdventureSkill.Instance():GetAdventureLevel()
	self.needSkillPointCost = self.skillConf.Cost
	self.needCurrency = self.skillShopItemData.ItemCount
	self.shopItemID = self.skillShopItemData.id
	self.skillPoint = AdventureDataProxy.Instance:getSkillPoint() or 0
	self.isReachEnoughAdventureLevelForLearn = self.tipData.isReachEnoughAdventureLevelForLearn
end

function UIViewAdventureSkillDetail:RegisterButtonClickEvent()
	self:AddClickEvent(self.goButtonCancel, function (go)
		self:OnButtonCancelClick()
	end)
	self:AddClickEvent(self.goButtonLearn, function (go)
		self:OnButtonLearnClick()
	end)
end

function UIViewAdventureSkillDetail:OnButtonCancelClick()
	TipsView.Me():HideCurrent()
end

function UIViewAdventureSkillDetail:OnButtonLearnClick()
	if self.buttonLearrnIsEnable and self:IsHaveEnoughCostForLearn() then
		if not self.skillShopItemData:CheckCanRemove() then
			self:RequestLearnSkill()
		end
	end
end

function UIViewAdventureSkillDetail:IsHaveEnoughCostForLearn()
	local rob = MyselfProxy.Instance:GetROB()
	if self.skillPoint < self.needSkillPointCost then
		local sysMsgID = 554
		MsgManager.ShowMsgByID(sysMsgID)
		return false
	elseif rob < self.needCurrency then
		local sysMsgID = 1
		MsgManager.ShowMsgByID(sysMsgID)
		return false
	else
		return true
	end
end

function UIViewAdventureSkillDetail:RequestLearnSkill()
	ServiceSessionShopProxy.Instance:CallBuyShopItem(self.shopItemID, 1)
end

function UIViewAdventureSkillDetail:DisableButtonLearn()
	self.spButtonLearnNormal.color = Color(1.0/255.0,2.0/255.0,3.0/255.0,1)
	self.labButtonLearnTitle.effectColor = Color(75/255, 75/255, 75/255, 1)
	self.buttonLearrnIsEnable = false
end

function UIViewAdventureSkillDetail:EnableButtonLearn()
	self.spButtonLearnNormal.color = Color(255/255, 255/255, 255/255, 1)
	self.labButtonLearnTitle.effectColor = Color(149/255, 63/255, 0/255, 1)
	self.buttonLearrnIsEnable = true
end

function UIViewAdventureSkillDetail:Tutorial()
	self:AddOrRemoveGuideId(self.goButtonLearn)
	self:AddOrRemoveGuideId(self.goButtonLearn, 38);
end