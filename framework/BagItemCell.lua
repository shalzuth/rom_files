autoImport("BaseItemCell");
autoImport("PortraitFrameCell");

BagItemCell = class("BagItemCell", BaseItemCell)

BagItemEmptyType = {
	Empty = "Empty",
	Unlock = "Unlock",
	Grey = "Grey",
}

function BagItemCell:Init()
	local itemCell = self:FindGO("Common_ItemCell");
	if(not itemCell)then
		local go = self:LoadPreferb("cell/ItemCell", self.gameObject);
		go.name = "Common_ItemCell";
	end

	BagItemCell.super.Init(self);
	self.chooseSymbol = self:FindGO("ChooseSymbol");

	self.grey = self:FindGO("Grey");
	self.unlock = self:FindGO("Unlock");
	-- self.unlock_level = self:FindComponent("UnlockLevel", UILabel);
	self.emptyTip = self:FindGO("EmptyTip");
	self.petAdvDot = self:FindGO("PetAdvDot");

	self:AddCellDoubleClickEvt();
end

function BagItemCell:SetData(data)
	if(self.unlock)then
		local data = data;
		if(type(data) == "table" and data.id == BagItemEmptyType.Unlock)then
			self.unlock:SetActive(true);

			local unlockData = data.unlockData;
			-- self.unlock_level.text = "Lv." .. unlockData.id;

			BagItemCell.super.SetData(self, nil);
			self:UpdateMyselfInfo();
			
			self.empty:SetActive(false);
			
			self.data = data;
		else
			BagItemCell.super.SetData(self, data);
			self:UpdateMyselfInfo();

			self.unlock:SetActive(false);
		end
	else
		BagItemCell.super.SetData(self, data);
	end

	if(self.grey)then
		self.grey:SetActive(data == BagItemEmptyType.Grey);
	end


	if(self.emptyTip)then
		if(data == BagItemEmptyType.Empty)then
			if(self.empty)then
				self.empty:SetActive(data ~= BagItemEmptyType.Empty);
			end
			self.emptyTip:SetActive(true);
		else
			self.emptyTip:SetActive(false);
		end
	end

	self:UpdateChoose();

	self:CheckPetAdventureTip();

	self:UpdateEquipUpgradeTip();
end

function BagItemCell:SetChooseId(chooseId)
	self.chooseId = chooseId;
	self:UpdateChoose();
end

function BagItemCell:UpdateChoose()
	if(self.chooseSymbol)then
		if(self.chooseId and self.data and self.data.id == self.chooseId)then
			self.chooseSymbol:SetActive(true);
		else
			self.chooseSymbol:SetActive(false);
		end
	end
end

local petAdventureItemId = 5504
function BagItemCell:CheckPetAdventureTip()
	if(self.petAdvDot == nil)then
		return;
	end

	local d = self.data;
	if(d and d.staticData and d.staticData.id == petAdventureItemId)then
		local isInRed = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_PET_ADVENTURE)
		self.petAdvDot:SetActive(isInRed);
	else
		self.petAdvDot:SetActive(false);
	end
end
