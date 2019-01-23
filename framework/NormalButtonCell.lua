local BaseCell = autoImport("BaseCell")
NormalButtonCell = class("NormalButtonCell", BaseCell)

NormalButtonCell.ResPath = ResourcePathHelper.UICell("NormalButtonCell");

function NormalButtonCell.CreateButton(parent)
	local obj = Game.AssetManager_UI:CreateAsset(NormalButtonCell.ResPath, parent.gameObject);
	if(obj)then
		UIUtil.ChangeLayer(obj, parent.gameObject.layer)
		obj.transform.localPosition = LuaVector3.zero;
	end
	return obj;
end

function NormalButtonCell:Init()
	self.bg = self:FindComponent("Background", UILabel);
	self.label = self:FindComponent("Label", UILabel);
end

function NormalButtonCell:SetData(data)
	if(data)then
		if(data.text)then
			self.label.text = tostring(data.text)
		end
		if(data.event)then
			self:SetEvent(self.gameObject, data.event);
		end
	end
end