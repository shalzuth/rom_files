local BaseCell = autoImport("BaseCell");
CommonUnlockInfo = class("CommonUnlockInfo", BaseCell);

function CommonUnlockInfo:Init()
	self.content = self:FindComponent("Content", UILabel);
	self.itemGrid = self:FindComponent("ItemGrid", UIGrid);
	self.ctl = UIGridListCtrl.new(self.itemGrid, ItemCell, "ItemCell");

	self.icon = self:FindComponent("TitleIcon", UISprite);

	self:AddClickEvent(self.gameObject, function (go)
		helplog("SystemUnLockEvent.ShowNextEvent");
		self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
	end);

	self.effectMap = {};

	self.effectMap[1] = self:FindGO("TitleEffect");
	self.effectMap[2] = self:FindGO("TitleEffect2");
end

function CommonUnlockInfo:SetData(data)
	self.data = data;
	
	local data = data and data.data;
	if(data)then
		local icontype, icon, datas, effectIndex, content = data.icontype, data.icon, data.datas, data.effectIndex, data.content;
		if(icontype == 1)then
			IconManager:SetItemIcon(icon,self.icon);
		else
			IconManager:SetUIIcon(icon,self.icon);
		end
		self.icon:MakePixelPerfect();
		
		if(content)then
			self.itemGrid.gameObject:SetActive(false);
			self.content.gameObject:SetActive(true);
			self.content.text = content;
		else
			self.itemGrid.gameObject:SetActive(true);
			self.content.gameObject:SetActive(false);
			self.ctl:ResetDatas(datas);
		end

		effectIndex = effectIndex or 1;
		for i=1,#self.effectMap do
			self.effectMap[i]:SetActive(i == effectIndex);
		end
	end
end

function CommonUnlockInfo:OnExit()
	CommonUnlockInfo.super.OnExit(self);
	self.gameObject:SetActive(false);
end