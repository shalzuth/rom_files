autoImport("DressingPage")
autoImport("WrapCellHelper")
autoImport("CutHairCombineItemCell");
HairCutPage = class("HairCutPage", DressingPage)

function HairCutPage:Init()
	self.super.Init(self)
end

function HairCutPage:InitPageView()
	local staticData = ShopDressingProxy.Instance.staticData
	if(not staticData)then return end 
	local tableData = staticData[ShopDressingProxy.DressingType.HAIR];
	if(not tableData)then
		return 
	end
	local newData = ShopDressingProxy.Instance:ReUniteCellData(tableData, 3);

	if(self.itemWrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.itemRoot, 
			pfbNum = 4, 
			cellName = "CutHairCombineItemCell", 
			control = CutHairCombineItemCell,
			dir = 1,
		}
		self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
		self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
	end
	self.itemWrapHelper:UpdateInfo(newData)
end

local args = {}
local defaultQueryCount = 1
function HairCutPage:OnClickItem(cellctl)
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
				args[1]=ShopDressingProxy.DressingType.HAIR
				args[2]=data.id
				args[3]=defaultQueryCount
				ShopDressingProxy.Instance:SetQueryData(args);
				self:RefreshChooseUI(data);
				self.container:RefreshModel();
			else
				self.container:DisableState();
			end
		end
	end
end


function HairCutPage:RefreshChooseUI(chooseData)
	self:SetDes(chooseData);
	self:SetMenuDes(chooseData,ShopDressingProxy.DressingType.HAIR);

	local pageType = self.container.pageType;
	local id = chooseData.id
	local itemid = chooseData.goodsID
	local moneyID = chooseData.ItemID;
	local itemCount = chooseData.ItemCount;
	local hairID = ShopDressingProxy.Instance:GetHairStyleIDByItemID(itemid)
	local precost = chooseData.PreCost
	self.container:RefreshSelectedROB(pageType,precost,moneyID,itemCount,hairID)
end

