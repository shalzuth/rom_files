local BaseCell = autoImport("BaseCell")
ItemFuncButtonCell = class("ItemFuncButtonCell", BaseCell)

function ItemFuncButtonCell:Init()
	self.bg = self:FindComponent("Background", UISprite);
	self.label = self:FindComponent("Label", UILabel);

	self:AddCellClickEvent();
	
	-- todo xde 非中文单独判断
	if (OverSea.LangManager.Instance().CurSysLang == 'English' or
			OverSea.LangManager.Instance().CurSysLang == 'Indonesian') then
		self.bg.width = self.bg.width + 60
	end
end

function ItemFuncButtonCell:SetData(data)
	if(data)then
		self.data = data;
		
		if(data.name)then
			self.label.text = tostring(data.name)
		end
	end
end