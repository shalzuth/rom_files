local BaseCell = autoImport("BaseCell") 
EquipUpgradeMaterialTipCell = class("EquipUpgradeMaterialTipCell", BaseCell)

function EquipUpgradeMaterialTipCell:Init()
	self.icon = self:FindComponent("Icon", UISprite);
	self.name = self:FindComponent("Name", UILabel);
end

function EquipUpgradeMaterialTipCell:SetData(data)
	if(data == nil)then
		self.gameObject:SetActive(false);
		return;
	end

	self.gameObject:SetActive(true);

	local itemid, neednum = data.id, data.num;

	local itemData = Table_Item[itemid];
	IconManager:SetItemIcon(itemData.Icon, self.icon);

	local searchnum = 0;
	if(itemid ~= 100)then
		if(ItemData.CheckIsEquip(itemid))then
			BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(itemid, nil, true, nil, EquipInfo:GetEquipCheckTypes(), function (param, itemData)
				if(itemData.id ~= self.upgrade_equipid)then
					searchnum = searchnum + itemData.num;
				end
			end);
		else
			searchItems = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, EquipInfo.GetEquipCheckTypes());
			for j=1,#searchItems do
				searchnum = searchnum + searchItems[j].num;
			end
		end
	else
		searchnum = Game.Myself.data.userdata:Get(UDEnum.SILVER);
	end

	self.name.text = string.format("%s    %s", itemData.NameZh, searchnum .. "/" .. neednum);

	if(neednum > searchnum)then
		self.lackid = itemid;
		self.lacknum = neednum - searchnum;
	else
		self.lackid = nil;
		self.lacknum = nil;
	end
end

function EquipUpgradeMaterialTipCell:GetLackMaterials()
	return self.lackid, self.lacknum;
end

function EquipUpgradeMaterialTipCell:SetUpgradeEquipId(upgrade_equipid)
	self.upgrade_equipid = upgrade_equipid;
end