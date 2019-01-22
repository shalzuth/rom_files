local baseCell = autoImport("BaseCell")
MainViewChatCell = class("MainViewChatCell",baseCell)

function MainViewChatCell:Init()
	self:FindObjs()
end

function MainViewChatCell:FindObjs()
	self.label = self.gameObject:GetComponent(UILabel)
end

function MainViewChatCell:SetData(data)
	-- todo xde ?????????????????????????????????????????????????????????
	-- [3FB953]Guild | [-] Steward Cat[3FB953]???[-][3FB953]The upgrade of Incredible Vending Machine  has started! Together, we can provide materials. Try to make it better![-]
	data = string.gsub(data, "???", ":")
	-- todo xde
	self.label.text = OverseaHostHelper:FilterLangStr(data)
end