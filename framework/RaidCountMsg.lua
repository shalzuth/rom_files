
RaidCountMsg = class("RaidCountMsg",CoreView)
local resID = ResourcePathHelper.UICell("RaidCountMsg")

function RaidCountMsg:ctor(parent,data)
	self.gameObject = self:CreateObj(parent)
	self:Init()
end

function RaidCountMsg:CreateObj(parent)
	local assetUi = Game.AssetManager_UI
	return assetUi:CreateAsset(resID, parent);
end

function RaidCountMsg:Init()
	self.Msglabel = self:FindGO("msgText"):GetComponent("UILabel")
end

function RaidCountMsg:SetData(data)
	self.Msglabel.text = data
end

function RaidCountMsg:Exit()
	if(nil~=self.gameObject) then
		GameObject.Destroy(self.gameObject)
		self.gameObject=nil
	end
end