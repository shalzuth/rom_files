autoImport("DressingPage")
autoImport("WrapCellHelper")
autoImport("ClothDressingCombineItemCell");
ClothDressingPage = class("ClothDressingPage", DressingPage)

function ClothDressingPage:InitPageView()
	local staticData = ShopDressingProxy.Instance.staticData;
	if(not staticData)then 
		return
	end 
	local tableData = staticData[ShopDressingProxy.DressingType.ClothColor];
	if(not tableData)then
		return 
	end
	local newData = ShopDressingProxy.Instance:ReUniteCellData(tableData, 5);
	if(self.itemWrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.itemRoot, 
			pfbNum = 6, 
			cellName = "ClothDressingCombineItemCell", 
			control = ClothDressingCombineItemCell,
			dir = 1,
		}
		self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
		self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
	end
	self.itemWrapHelper:UpdateInfo(newData)
end

local args = {}
local defaultCount = 1
function ClothDressingPage:OnClickItem(cellctl)
	if(nil~=cellctl) then
		if(nil~= self.chooseCtl and cellctl~=self.chooseCtl) then
			self.chooseCtl:UnChoose();
		end
		if(cellctl~=self.chooseCtl) then
			self.chooseCtl = cellctl;
			self.chooseCtl:Choose();
			ShopDressingProxy.Instance.chooseData=self.chooseCtl.data;
			local data = self.chooseCtl.data;
			if(nil~=data) then
				args[1]=ShopDressingProxy.DressingType.ClothColor
				args[2]=data.id
				args[3]=defaultCount
				ShopDressingProxy.Instance:SetQueryData(args)
				self:RefreshChooseUI(data);
				self.container:RefreshModel();
			else
				self.container:DisableState();
			end
		end
	end
end

function ClothDressingPage:RefreshChooseUI(chooseData)
	self:SetDes(chooseData);
	self:SetMenuDes(chooseData,ShopDressingProxy.DressingType.ClothColor);

	local id = chooseData.id
	local menuID = chooseData.MenuID
	local moneyID = chooseData.ItemID
	local itemCount = chooseData.ItemCount
	self.container:RefreshROB(moneyID,itemCount,menuID)
end
