autoImport('FuncZenyShop')

UIListItemViewControllerAdventureSkill = class("UIListItemViewControllerAdventureSkill", BaseCell)

function UIListItemViewControllerAdventureSkill:Init()
	self:GetGameObjects()
	self:RegisterItemClickEvent()
end

function UIListItemViewControllerAdventureSkill:GetGameObjects()
	if self.getGameObjectsComplete then return end
	self.goName = self:FindGO('Name')
	self.labName = self.goName:GetComponent(UILabel)
	self.goSkillPointValue = self:FindGO('LabSkillPoint')
	self.labSkillPointValue = self.goSkillPointValue:GetComponent(UILabel)
	self.goCurrency = self:FindGO('Currency')
	self.goCurrencyValue = self:FindGO("LabNeedCurrency", self.goCurrency)
	self.labCurrencyValue = self.goCurrencyValue:GetComponent(UILabel)
	self.goIcon = self:FindGO("Icon")
	self.spIcon = self.goIcon:GetComponent(UISprite)
	-- (no)self.goButtonLearn = self:FindGO("ButtonLearn")
	self.widget = self.gameObject:GetComponent(UIWidget)
	self.goRequireAdventureLevel = self:FindGO('RequireAdventureLevel')
	self.goSharedSkill = self:FindGO('SharedSkill')
	self.labRequireAdventureLevel = self.goRequireAdventureLevel:GetComponent(UILabel)
	self.getGameObjectsComplete = true
end

function UIListItemViewControllerAdventureSkill:IsClickMe(click)
	return click == self.gameObject
end

function UIListItemViewControllerAdventureSkill:SetData(adventure_skill_shop_item_data)
	self.skillShopItemData = adventure_skill_shop_item_data
	self:InitializeModelSet()
	self:LoadView()
	-----[[ todo xde 0001653: 各语言 冒险技能学习界面，技能后面的（账号共用）标示显示不完整
	self.goSharedSkill:GetComponent(UILabel).overflowMethod = 0 -- shrink content
	local w = self.goSharedSkill:GetComponent(UIWidget)
	alignWidgetToTransform_Right2(w, self.goName.transform)
	self.goSharedSkill.transform.localPosition = Vector3(self.goSharedSkill.transform.localPosition.x, -27, 0)
	--]]
end

function UIListItemViewControllerAdventureSkill:InitializeModelSet()
	self.skillPoint = AdventureDataProxy.Instance:getSkillPoint()
	self.skillPoint = self.skillPoint or 0
	local skillID = self.skillShopItemData.SkillID
	self.skillConf = Table_Skill[skillID]
	if self.skillConf == nil then
		LogUtility.Error(string.format("Can't find configure(%s) in Skill.xlsx", tostring(skillID)))
	else
		self.needSkillPointCost = self.skillConf.Cost
	end
	self.adventureLevelID = UIModelAdventureSkill.Instance():GetAdventureLevel()
	if self.adventureLevelID == nil or self.adventureLevelID <= 0 then
		LogUtility.Error(string.format('Field self.adventureLevelID is illegal'))
	end
	self.needCurrency = self.skillShopItemData.ItemCount
end

function UIListItemViewControllerAdventureSkill:LoadView()
	self.labName.text = self.skillConf.NameZh
	self.needSkillPointCost = self.needSkillPointCost or '-1'
	self.labSkillPointValue.text = string.format(ZhString.AdventureSkill_CostAdventureSkillPoint2, self.needSkillPointCost)
	local strNeedCurrency = FuncZenyShop.FormatMilComma(self.needCurrency)
	if strNeedCurrency ~= nil then
		self.labCurrencyValue.text = strNeedCurrency
	end
	-- error compatibility
	if self.skillConf ~= nil then
		IconManager:SetSkillIcon(self.skillConf.Icon, self.spIcon)
	end
	local requireAdventureLevel = UIModelAdventureSkill.Instance():GetSkillRequireAppellation(self.skillShopItemData.id)
	if requireAdventureLevel ~= nil or requireAdventureLevel > 0 then
		self.labRequireAdventureLevel.text = string.format(ZhString.AdventureSkill_NeedReachAdventureLevel, Table_Appellation[requireAdventureLevel].Name)
	end
	if self:IsReachEnoughAdventureLevelForLearn() then
		self.goRequireAdventureLevel:SetActive(false)
		-- (no)self.goButtonLearn:SetActive(true)
		self.goCurrency:SetActive(true)
		self.widget.alpha = 1
	else
		self.goRequireAdventureLevel:SetActive(true)
		-- (no)self.goButtonLearn:SetActive(false)
		self.goCurrency:SetActive(false)
		self.widget.alpha = 0.4
	end
	local sharedLabelPos = self.goSharedSkill.transform.localPosition
	sharedLabelPos.x = self.labName.transform.localPosition.x + self.labName.width

	self.goSharedSkill:GetComponent(UILabel).text = ZhString.SkillTip_Shared

	self.goSharedSkill.transform.localPosition = sharedLabelPos
	self.goSharedSkill:SetActive(self.skillConf.Share == 1)
end

function UIListItemViewControllerAdventureSkill:AddCellClickEvent()
	
end

function UIListItemViewControllerAdventureSkill:RegisterItemClickEvent()
	self:AddClickEvent(self.gameObject, function ()
		self:OnItemViewClick()
	end)
end

function UIListItemViewControllerAdventureSkill:OnItemViewClick()
	self:PassEvent(MouseEvent.MouseClick, self)
end

function UIListItemViewControllerAdventureSkill:IsReachEnoughAdventureLevelForLearn()
	local requireAdventureLevel = UIModelAdventureSkill.Instance():GetSkillRequireAppellation(self.skillShopItemData.id)
	requireAdventureLevel = requireAdventureLevel or 0
	self.adventureLevelID = self.adventureLevelID or 0
	return requireAdventureLevel <= self.adventureLevelID
end