autoImport("BusinessmanMakeCombineCell")

local baseCell = autoImport("BaseCell")
BusinessmanMakeTypeCell = class("BusinessmanMakeTypeCell", baseCell)

function BusinessmanMakeTypeCell:Init()
	self:FindObjs()
	self:InitShow()
end

function BusinessmanMakeTypeCell:FindObjs()
	self.name = self.gameObject:GetComponent(UILabel)
end

function BusinessmanMakeTypeCell:InitShow()
	local grid = self:FindGO("Grid"):GetComponent(UIGrid)
	self.itemCtl = UIGridListCtrl.new(grid, BusinessmanMakeCombineCell, "BusinessmanMakeCombineCell")
	self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end

function BusinessmanMakeTypeCell:SetData(data)
	self.data = data

	if data then
		local _Category = BusinessmanMakeProxy.Category
		if data == _Category.AttributeWeapon then
			self.name.text = ZhString.Businessman_AttributeWeaponTitle
		elseif data == _Category.MagicStone then
			self.name.text = ZhString.Businessman_MagicStoneTitle
		elseif data == _Category.SharpGold then
			self.name.text = ZhString.Businessman_SharpGoldTitle
		elseif data == _Category.Medicine then
			self.name.text = ZhString.Businessman_MedicineTitle
		elseif data == _Category.Property then
			self.name.text = ZhString.Businessman_PropertyTitle
		elseif data == _Category.Runestone then
			self.name.text = ZhString.Businessman_RunestoneTitle
		end

		local list = self:ReUniteCellData(BusinessmanMakeProxy.Instance:GetItemList(data), 4)
		self.itemCtl:ResetDatas(list)
	end
end

function BusinessmanMakeTypeCell:ClickItem(cellctl)
	self:PassEvent(MouseEvent.MouseClick, cellctl)
end

function BusinessmanMakeTypeCell:GetCombineCellList()
	return self.itemCtl:GetCells()
end

function BusinessmanMakeTypeCell:ReUniteCellData(datas, perRowNum)
	local newData = {}
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/perRowNum)+1;
			local i2 = math.floor((i-1)%perRowNum)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end