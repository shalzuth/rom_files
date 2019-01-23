local baseCell = autoImport("BaseCell")
EquipRecoverCell = class("EquipRecoverCell", baseCell)

function EquipRecoverCell:Init()
	self:FindObjs()
	self:AddEvts()
end

function EquipRecoverCell:FindObjs()
	self.desc = self.gameObject:GetComponent(UILabel)
	self.toggle = self:FindGO("Toggle"):GetComponent(UIToggle)
	self.cost = self:FindGO("Cost"):GetComponent(UILabel)
	self.costIcon = self:FindGO("Sprite", self.cost.gameObject):GetComponent(UISprite)
end

function EquipRecoverCell:AddEvts()
	EventDelegate.Add(self.toggle.onChange, function ()
		self:PassEvent(EquipRecoverEvent.Select, self)
	end)
end

function EquipRecoverCell:SetData(data)
	self.data = data
	if data then
		local currency = EquipRecoverProxy.Instance:GetCurrency()
		local _EquipRecover = GameConfig.EquipRecover

		if data == EquipRecoverProxy.RecoverType.Strength then
			self:HandleCell(ZhString.EquipRecover_Strength , _EquipRecover.Strength,true)

		elseif data == EquipRecoverProxy.RecoverType.EmptyStrength then
			self:HandleEmpty(ZhString.EquipRecover_Strength)

		elseif data == EquipRecoverProxy.RecoverType.EmptyCard then
			self:HandleEmpty(ZhString.EquipRecover_EmptyCard)

		elseif data == EquipRecoverProxy.RecoverType.Enchant then
			self:HandleCell(ZhString.EquipRecover_Enchant , _EquipRecover.Enchant,false)

		elseif data == EquipRecoverProxy.RecoverType.EmptyEnchant then
			self:HandleEmpty(ZhString.EquipRecover_Enchant)

		elseif data == EquipRecoverProxy.RecoverType.EmptyUpgrade then
			self:HandleEmpty(ZhString.EquipRecover_Upgrade)

		else
			if type(data) == "table" then
				local staticData = data.staticData
				if staticData then
					--还原卡片
					-- local card = GameConfig.EquipRecover.Card[currency]
					local card = _EquipRecover.Card
					if card then
						self:HandleCell(string.format(ZhString.EquipRecover_Card , staticData.NameZh) , card[staticData.Quality],true)
					end
				else
					self:HandleEmpty(ZhString.EquipRecover_EmptyCard)

				end
			else
				--还原升级档
				local equiplv = math.clamp(data, 1, #_EquipRecover.Upgrade)
				self:HandleCell(ZhString.EquipRecover_Upgrade.. StringUtil.IntToRoman(data), _EquipRecover.Upgrade[equiplv], false)				
			end
		end

		if currency then
			local item = Table_Item[currency]
			if item then
				IconManager:SetItemIcon(item.Icon, self.costIcon)
			end
		end
	end
end

function EquipRecoverCell:HandleEmpty(desc)
	self.desc.text = desc
	self.cost.text = 0
	self.toggle:Set(false)
	self.toggle.enabled = false
end

function EquipRecoverCell:HandleCell(desc,cost,toggle)
	self.desc.text = desc
	self.cost.text = cost
	self.toggle.enabled = true
	self.toggle:Set(toggle)
end