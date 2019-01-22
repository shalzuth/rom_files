local baseCell = autoImport("BaseCell")
BaseAttributeMoneyCell = class("BaseAttributeMoneyCell",baseCell)


function BaseAttributeMoneyCell:Init(  )
	-- body
	self:initView()
end

function BaseAttributeMoneyCell:SetData( data )
	-- body
	-- self.icon.spriteName = data.icon
	local itemData = Table_Item[data.id]
	if(self:checkForbid(data.name))then
		self:Hide(self.gameObject)
		return
	end
	if(itemData)then
		self.name.text = itemData.NameZh
		local value = Game.Myself.data.userdata:Get(data.name)
		if(data.name == "ZENY_DEBT")then
			if(value == nil or value == 0)then
				self:Hide(self.gameObject)
			else
				self.value.text = "-"..value
			end
		elseif(data.name == "GARDEN")then
			value = BagProxy.Instance:GetItemNumByStaticID(data.id)
			self.value.text = value
		elseif(data.name == "QUOTA")then
			local hasCharge = MyselfProxy.Instance:GetHasCharge()
			if(hasCharge == nil or hasCharge == 0)then
				self:Hide(self.gameObject)
			else
				self.value.text = value
			end
		else
			self.value.text = value
		end
		IconManager:SetItemIcon(itemData.Icon,self.icon)
	else
		printRed("can't find itemData at id:")
	end
end

function BaseAttributeMoneyCell:initView(  )
	-- body
	self.name = self:FindChild("name"):GetComponent(UILabel)
	self.value = self:FindChild("value"):GetComponent(UILabel)
	self.icon = self:FindGO("icon"):GetComponent(UISprite)
end

--local branchBitValue = {
--	[EnvChannel.ChannelConfig.Develop.Name] = 1,
--	[EnvChannel.ChannelConfig.Studio.Name] = 2,
--	[EnvChannel.ChannelConfig.Alpha.Name] = 4,
--	[EnvChannel.ChannelConfig.Release.Name] = 8,
--}
--local myBranchValue = branchBitValue[EnvChannel.Channel.Name]
-- todo xde ?????? ???????????????????????????????????????????????????????????????
local myBranchValue = EnvChannel.BranchBitValue[EnvChannel.Channel.Name]

function BaseAttributeMoneyCell:checkForbid( key )
	if(GameConfig.Charactor_InfoShow_Forbid and GameConfig.Charactor_InfoShow_Forbid[key])then
		if(myBranchValue & GameConfig.Charactor_InfoShow_Forbid[key] > 0)then
			return true
		end
	end
end
