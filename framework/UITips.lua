local UITips = class("Charactor",BaseView)

-- UITips.ViewType = UIViewType.TipLayer

function UITips:Init()
	self.contentLabel = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"contentLabel"):GetComponent(UILabel);
end

function UITips:SetString(value)
	if(self.contentLabel~=nil)then
		self.contentLabel.text = tostring(value)
	end
end

return UITips