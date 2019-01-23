ItemSecendFuncBord = class("ItemSecendFuncBord",CoreView)

autoImport("ItemFuncButtonCell");

ItemSecendFuncEvent = {
	Close = "ItemSecendFuncEvent_Close",
}

function ItemSecendFuncBord:ctor()
end

function ItemSecendFuncBord:OnCreate(parent, widget, side, pixelOffset)
	local pos = NGUIUtil.GetAnchorPoint(nil,widget,side,pixelOffset)

	self.gameObject = Game.AssetManager_UI:CreateAsset("GUI/v1/part/ItemSecendFuncBord", parent);
	if(self.gameObject)then
		self.gameObject.transform.position = pos;
	end

	self:Init();
end

function ItemSecendFuncBord:Init()
	local grid = self:FindComponent("Grid", UIGrid);
 	self.buttonCtl = UIGridListCtrl.new(grid, ItemFuncButtonCell, "ItemFuncButtonCell");
 	self.buttonCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self);

 	self.title = self:FindComponent("Title", UILabel);
 	self.bg = self:FindComponent("Bg", UISprite);

 	self.closeCheck = self:FindGO("CloseCheck");
 	self:AddClickEvent(self.closeCheck, function (go)
 		self:OnExit();
 	end);

 	self.original_Size_H = 106;
	
end

function ItemSecendFuncBord:ClickButton(cell)
	self:PassEvent(MouseEvent.MouseClick, cell.data);
end

function ItemSecendFuncBord:SetTitle(title)
	self.title.text = title;

	-- todo xde 非中文单独判断
	local offset = self.title.width - 192 <= 0 and 0 or self.title.width - 192
	self.bg.width = self.bg.width + offset 
	local bgPos = self.bg.gameObject.transform.localPosition
	local titlePos = self.title.gameObject.transform.localPosition
	self.bg.gameObject.transform.localPosition  = Vector3(bgPos.x + offset/2,
		bgPos.y,bgPos.z)
	self.title.gameObject.transform.localPosition  = Vector3(titlePos.x - offset/2,
		titlePos.y,titlePos.z)
end

function ItemSecendFuncBord:SetData(configs, itemdata)
	local buttonDatas = {};
	for i=1,#configs do
		local cfgdata = GameConfig.ItemFunction[ configs[i] ];
		local state, otherName = FunctionItemFunc.Me():CheckFuncState(cfgdata.type, itemdata);
		if(state == ItemFuncState.Active or state == ItemFuncState.Grey)then
			local t = {};
			for k,v in pairs(cfgdata)do
				t[k] = v;
			end
			if(otherName)then
				t.name = otherName;
			end
			table.insert(buttonDatas, t);
		end
	end

	self.buttonCtl:ResetDatas(buttonDatas);

	local addH = 80 * #buttonDatas;
	self.bg.height = addH + self.original_Size_H;
end

function ItemSecendFuncBord:OnExit()
	self:PassEvent(ItemSecendFuncEvent.Close);
end

function ItemSecendFuncBord:OnDestroy()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
		self.gameObject = nil;
	end
end