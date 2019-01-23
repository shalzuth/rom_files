local BaseCell = autoImport("BaseCell");
autoImport("PetSpaceUnlockRewardCell")
PetSpaceDescCell = class("PetSpaceDescCell", BaseCell);

function PetSpaceDescCell:Init()
	self.desc = self:FindComponent("Desc", UILabel);
	self.tab = self:FindComponent("Tab",UITable)
	self.tabCtl = UIGridListCtrl.new(self.tab,PetSpaceUnlockRewardCell,"PetSpaceUnlockRewardCell");
end

-- Desc : 打工描述、解锁奖励、未解锁描述
function PetSpaceDescCell:SetData(data)
	self.data = data;
	if(data)then
		if(data.type=="single")then
			self:Show(self.desc.gameObject)
			self:Hide(self.tab.gameObject)
			if(data.desc)then
				self.desc.text = data.desc
			end
		elseif(data.type=="table")then
			self:Hide(self.desc.gameObject)
			self:Show(self.tab.gameObject)
			self.tabCtl:ResetDatas(data)
		end
	end
end