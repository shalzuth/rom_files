autoImport('UIModelKaplaTransmit')

local baseCell = autoImport("BaseCell")
UIListItemViewControllerTransmitTeammate = class('UIListItemViewControllerTransmitTeammate', baseCell)

function UIListItemViewControllerTransmitTeammate:Init()
	self:GetGameObjects()
end

function UIListItemViewControllerTransmitTeammate:SetData(data)
	self.teammateID = data
	self:GetModelSet()
	self:LoadView()
end

function UIListItemViewControllerTransmitTeammate:GetGameObjects()
	self.goName = self:FindGO('Name')
	self.labName = self.goName:GetComponent(UILabel)
	self.goStatus = self:FindGO('Status')
	self.spStatus = self.goStatus:GetComponent(UISprite)
end

function UIListItemViewControllerTransmitTeammate:GetModelSet()
	self.teammateDetail = UIModelKaplaTransmit.Ins():GetTeammateDetail(self.teammateID)
end

function UIListItemViewControllerTransmitTeammate:LoadView()
	if self.teammateDetail ~= nil then
		self.labName.text = self.teammateDetail.name
		local isFollowing = self.teammateDetail.isFollowing
		if isFollowing then
			self.spStatus.spriteName = 'com_icon_check'
		else
			self.spStatus.spriteName = 'com_icon_off'
		end
		self.spStatus:MakePixelPerfect()
	end
end