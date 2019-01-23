autoImport("ItemCell")

EquipStrengthen = class("EquipStrengthen",SubView);

EquipStrengthen.PfbPath = "part/EquipStrengthen";

function EquipStrengthen:Init()
	self:Listen()
end

function EquipStrengthen:InitUI()
	local contaienr = self:FindGO("EquipStrengthen");
	self.gameObject = self:LoadPreferb(EquipStrengthen.PfbPath, contaienr, true);
	self.gameObject.transform.localPosition = Vector3.zero;

	self:CollectGO()
	self:AddButtonClickEvent()
end

function EquipStrengthen:CollectGO()
	self.previewCell = self:FindGO("ItemCell",self.leftContent)
	self.spItemIcon = self:FindGO("Icon_Sprite", self.previewCell):GetComponent(UISprite)
	self.labStrengthenLevel = self:FindGO("StrengLv", self.previewCell):GetComponent(UILabel)
	self.goCardSlot = self:FindGO("CardSlot", self.previewCell)
	self.itemPreviewCell = ItemCell.new(self.previewCell)
	self.goNowLevel = self:FindGO("Now")
	self.labNowLevelValue = self:FindGO("LevelValue", self.goNowLevel):GetComponent(UILabel)
	self.labNowAttributeTitle = self:FindGO("AttributeTitle", self.goNowLevel):GetComponent(UILabel)
	self.labNowAttributeValue = self:FindGO("AttributeValue", self.goNowLevel):GetComponent(UILabel)
	self.goNextLevel = self:FindGO("Next")
	self.labnextLevelTitle = self:FindGO("LevelTitle", self.goNextLevel):GetComponent(UILabel)
	self.labNextLevelValue = self:FindGO("LevelValue", self.goNextLevel):GetComponent(UILabel)
	self.labNextAttributeTitle = self:FindGO("AttributeTitle", self.goNextLevel):GetComponent(UILabel)
	self.labNextAttributeValue = self:FindGO("AttributeValue", self.goNextLevel):GetComponent(UILabel)
	self.goMaxLevel = self:FindGO("Max")
	self.labMaxLabel = self.goMaxLevel:GetComponent(UILabel)
	self.labEquipName = self:FindGO("EquipName",self.leftContent):GetComponent(UILabel)
	self.goCost = self:FindGO("CostDesc")
	self.labCost = self:FindGO("Cost",self.leftContent):GetComponent(UILabel)
	self.strengthOneBtn = self:FindGO("StrengthOneBtn")
	self.goLevelChangeEmpty = self:FindGO("LevelChangeEmpty")
	self.goNow = self:FindGO("Now")
	self.goNext = self:FindGO("Next")
	self.spUpgradeSymbol = self:FindGO("UpgradeSp"):GetComponent(UISprite)
	self.goItemName = self:FindGO("CurrentEquipName")
end

function EquipStrengthen:AddButtonClickEvent()
	self:AddClickEvent(self.strengthOneBtn, function (go)
		self:OnButtonStrengthOnceClick()
	end)
end

function EquipStrengthen:Listen()
	self:AddListenEvt(ServiceEvent.ItemEquipStrength, self.StrengthHandler)
	self:AddListenEvt(ItemEvent.EquipUpdate, self.OnReceiveEquipUpdate)
	self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCost)
end

function EquipStrengthen:GetItemDataFromPartIndex(index)
	-- site means part
		local equipsData = BagProxy.Instance.roleEquip.siteMap;
		return equipsData[index]
end

function EquipStrengthen:GetItemData()
	-- index means part index
	if self.index ~= nil and self.index >= 0 then
		return self:GetItemDataFromPartIndex(self.index)
	end
	return nil
end

function EquipStrengthen:UpdateInfo()
	local itemData = self:GetItemData()
	if itemData ~= nil then
		self.itemPreviewCell:SetData(itemData)
		local equipInfo = itemData.equipInfo
		local levelMax = BlackSmithProxy.Instance:MaxStrengthLevel()
		local currentLv = equipInfo.strengthlv
		local nextLv = currentLv + 1
		local strLevelValue = tostring(currentLv) .. "/" .. levelMax
		self.labNowLevelValue.text = strLevelValue
		local strAttributeName = ""
		local iAttributeValue = 0
		-- local attributes = equipInfo.equipData.Effect
		-- if attributes ~= nil then
		-- 	for k, v in pairs(attributes) do
		-- 		strAttributeName = k
		-- 		iAttributeValue = v
		-- 		break
		-- 	end
		-- end
		local iAttributeAddValue = 0
		local attributesAddition = equipInfo.equipData.EffectAdd
		if attributesAddition ~= nil then
			for k, v in pairs(attributesAddition) do
				strAttributeName = k
				iAttributeAddValue = v
				break
			end
		end
		local separator = ':'
		local strAttributeNameCN = GetAttributeNameFromAbbreviation(strAttributeName)
		self.labNowAttributeTitle.text = strAttributeNameCN .. separator
		self.labNowAttributeValue.text = tostring(0 + currentLv * iAttributeAddValue)
		local levelIsReachMax = currentLv >= levelMax
		if levelIsReachMax then
			self.levelReachMax = true
			self.labnextLevelTitle.enabled = false;
			self.labNextLevelValue.enabled = false;
			self.labNextAttributeTitle.enabled = false;
			self.labNextAttributeValue.enabled = false;
			self.goMaxLevel:SetActive(true)
		else
			self.levelReachMax = false
			self.labnextLevelTitle.enabled = true;
			self.labNextLevelValue.enabled = true;
			self.labNextAttributeTitle.enabled = true;
			self.labNextAttributeValue.enabled = true;
			self.goMaxLevel:SetActive(false)
			local strNextLevel = tostring(nextLv)
			if levelIsLimitedByConfig then
				strNextLevel = strNextLevel .. "/" .. levelMax
			end
			self.labNextLevelValue.text = strNextLevel
			self.labNextAttributeTitle.text = strAttributeNameCN .. separator
			self.labNextAttributeValue.text = tostring(0 + nextLv * iAttributeAddValue)
		end
		self.labEquipName.text = itemData:GetName() -- itemData.staticData.NameZh -- MsgParserProxy.Instance:GetItemNameWithQuality(itemData.staticData.id)
		if levelIsReachMax then
			self.goCost:SetActive(false)
		else
			self.goCost:SetActive(true)
		end
	end
end

function GetAttributeNameFromAbbreviation(str_abbreviation)
	for _, v in pairs(Table_RoleData) do
		local attributeConf = v
		if attributeConf.VarName == str_abbreviation then
			return attributeConf.PropName
		end
	end
	return nil
end

function EquipStrengthen:OnButtonStrengthOnceClick()
	local itemData = self:GetItemData()
	if itemData == nil then
		MsgManager.ShowMsgByIDTable(216)
		return
	end

	if self.levelReachMax then
		MsgManager.ShowMsgByIDTable(210)
		return
	end

	local enough,need = self:CheckCost()
	if not enough then
		MsgManager.ShowMsgByIDTable(1)
	end

	ServiceItemProxy.Instance:CallEquipStrength(itemData.id, 1, nil, nil, nil, nil, nil, SceneItem_pb.ESTRENGTHTYPE_NORMAL)
end

-- @return values
-- bool, is enough
-- int, need currency
-- int, own currency
function EquipStrengthen:CheckCost()
	local itemData = self:GetItemData()
	if itemData ~= nil then
		return CostUtil.CheckStrengthCost(itemData.staticData, itemData.equipInfo.strengthlv)
	end
	return false,0,0
end

function EquipStrengthen:UpdateCost()
	local itemData = self:GetItemData()
	if itemData == nil then return end

	local enough,need = self:CheckCost()
	need = need or 0
	need = math.floor(need)
	self.labCost.text = need
	if(enough or not itemData) then
		self.labCost.color = Color(0.4, 0.4, 0.4, 1)
	else
		self.labCost.color = Color(1, 0, 0, 1)
	end
end

function EquipStrengthen:StrengthHandler(note)
	self:RefreshSelf()
	note = note.body
	local pos = self.previewCell.transform.position
	local strengthenCount = note.count
	if(strengthenCount>0) then
		local growLv = note.newlv - note.oldlv
		local itemData = self:GetItemData()
		local addEffect = itemData.equipInfo:StrengthInfo(growLv,false)

		if(note.cricount >0)then
			self:PlayUIEffect(EffectMap.UI.upgrade_surprised,
								self.itemPreviewCell.gameObject, 
								true, 
								EquipStrengthen.Upgrade_surprisedEffectHandle, 
								self)
		else
			self:PlayUIEffect(EffectMap.UI.upgrade_success,
								self.itemPreviewCell.gameObject, 
								true, 
								EquipStrengthen.Upgrade_successEffectHandle, 
								self)
		end

		if(note.result == SceneItem_pb.ESTRENGTHRESULT_NOMATERIAL) then
			if(note.cricount>0) then
				MsgManager.ShowEightTypeMsgByIDTable(214,{note.count,note.cricount,addEffect},pos,{0,10})		
			else
				MsgManager.ShowEightTypeMsgByIDTable(215,{note.count,addEffect},pos,{0,10})	
			end
		else
			if(note.destcount == 1) then
				if(note.cricount>0) then
					MsgManager.ShowEightTypeMsgByIDTable(212,{note.count,note.cricount,addEffect},pos,{0,10})
				else
					MsgManager.ShowEightTypeMsgByIDTable(211,{growLv,addEffect},pos,{0,10})
				end
			else
				if(note.cricount>0) then
					MsgManager.ShowEightTypeMsgByIDTable(212,{note.count,note.cricount,addEffect},pos,{0,10})
				else
					MsgManager.ShowEightTypeMsgByIDTable(213,{note.count,addEffect},pos,{0,10})
				end
			end
		end
	end
end

function EquipStrengthen.Upgrade_surprisedEffectHandle( effectHandle, owner )
	NGUIUtil.ChangeRenderQ(effectHandle.gameObject, 3100)
end

function EquipStrengthen.Upgrade_successEffectHandle( effectHandle, owner )
	NGUIUtil.ChangeRenderQ(effectHandle.gameObject, 3100)
end

function EquipStrengthen:Show()
	if(not self.init)then
		self.init = true;
		self:InitUI();
	end
	self:UpdateCost();
	self.gameObject:SetActive(true)
end

function EquipStrengthen:Hide()
	if(self.init)then
		self.gameObject:SetActive(false)
	end
end

function EquipStrengthen:Refresh(index)
	local itemData = self:GetItemDataFromPartIndex(index)
	if itemData ~= nil then
		self:SetNormal()
		self.index = index
		self:UpdateInfo()
		self:UpdateCost()
	end
end

function EquipStrengthen:RefreshSelf()
	if self.index then
		self:Refresh(self.index)
	end
end

function EquipStrengthen:IsCouldStrengthen(index)
	if not GameConfig.SystemForbid.HeadwearIntensify then
		return true
	else
		return GameConfig.CouldNotStrengthenPart[index] == nil
	end
end

function EquipStrengthen:SetEmpty()
	self.spItemIcon.spriteName = ""
	self.labStrengthenLevel.text = ""
	self.goCardSlot:SetActive(false)
	self.goNow:SetActive(false)
	self.goNext:SetActive(false)
	self.goMaxLevel:SetActive(false)
	self.spUpgradeSymbol.enabled = false
	self.goLevelChangeEmpty:SetActive(true)
	self.labCost.text = ""
	self.goItemName:SetActive(false)
	self.goCost:SetActive(false)
	self.strengthOneBtn:SetActive(false)
	self.itemPreviewCell:SetData(nil)
end

function EquipStrengthen:SetNormal()
	self.goCardSlot:SetActive(true)
	self.goNow:SetActive(true)
	self.goNext:SetActive(true)
	self.goMaxLevel:SetActive(true)
	self.spUpgradeSymbol.enabled = true
	self.goLevelChangeEmpty:SetActive(false)
	self.goItemName:SetActive(true)
	self.goCost:SetActive(true)
	self.strengthOneBtn:SetActive(true)
end

function EquipStrengthen:OnReceiveEquipUpdate()
	if self.container.equipStrengthenIsShow then
		self:RefreshSelf()
	end
end

function EquipStrengthen:OnExit()
	self.super.OnExit(self)
end