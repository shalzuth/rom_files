BaseCell = autoImport("BaseCell") 
CarrierWaitListCell = class("CarrierWaitListCell", BaseCell)

function CarrierWaitListCell:Init()
	self.nameLabel = self:FindGO("Name"):GetComponent(UILabel)
	self.waitSp = self:FindGO("Wait")
	self.confirmSp = self:FindGO("Confirm"):GetComponent(UIMultiSprite)
	-- self.confirmSp.isChangeSnap = false
	self:Hide(self.confirmSp)
	-- self.nameLabel.color = ColorUtil.TeamGray
end

function CarrierWaitListCell:SetData(data)
	self.data = data;
	self.nameLabel.text = self.data.name
	---[[ todo xde 不翻译玩家名字
	self.nameLabel.text = AppendSpace2Str(self.data.name)
	--]]
	if(self.data.agree ~= nil) then
		self:Agree(self.data.agree)
	end
	-- self.confirmLabel.text = self.data.name
end

function CarrierWaitListCell:Agree(value)
	self:Show(self.confirmSp)
	self:Hide(self.waitSp)

	if(value) then
		self.confirmSp.CurrentState = 0
		-- self.nameLabel.color = ColorUtil.TeamOrange
	else
		self.confirmSp.CurrentState = 1
	end
	ColorUtil.WhiteUIWidget(self.confirmSp)
end

function CarrierWaitListCell:Leave()
	self:Show(self.confirmSp)
	self:Hide(self.waitSp)

	self.confirmSp.CurrentState = 2
	ColorUtil.ShaderGrayUIWidget(self.confirmSp)
	-- self.nameLabel.color = ColorUtil.TeamGray
end