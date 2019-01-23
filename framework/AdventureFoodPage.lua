AdventureFoodPage = class("AdventureFoodPage", SubView)

autoImport("AdventureCookPage");
autoImport("AdventureTastePage");
autoImport("AdventureFoodItemCell");
autoImport("AdventureFoodPageCombineItemCell");
autoImport("FoodScoreTip");

AdventureFoodPage.Category = {
	CookPage = 1,
	TastePage = 2,
}

AdventureFoodPage.MaxCategory = { id = 99999999,value = {}}

AdventureFoodPage.CheckHashSelected = "AdventureCookPage_CheckHashSelected"

function AdventureFoodPage:Init()
	self:AddViewEvts();
	self:initView();	
end

function AdventureFoodPage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.SceneFoodNewFoodDataNtf,self.Server_NewFoodDataNtf)
end

function AdventureFoodPage:initView()
	self.gameObject = self:FindGO("AdventureFoodPage")

	self:AddTabChangeEvent(self:FindGO("categoryCook"),self:FindGO("AdventureCookPage"),AdventureFoodPage.Category.CookPage)
	self:AddTabChangeEvent(self:FindGO("categoryTaste"),self:FindGO("AdventureTastePage"),AdventureFoodPage.Category.TastePage)
	
	self.AdventureCookPage = self:AddSubView("categoryCook",AdventureCookPage)
	self.AdventureTastePage = self:AddSubView("categoryTaste",AdventureTastePage)

	local cookDes = self:FindComponent("cookDes",UILabel)
	local tasteDes = self:FindComponent("tasteDes",UILabel)
	local tasteName = self:FindComponent("tasteName",UILabel)
	local cookName = self:FindComponent("cookName",UILabel)
	cookDes.text = ZhString.AdventureFoodPage_FoodInstitul
	tasteDes.text = ZhString.AdventureFoodPage_FoodInstitul
	tasteName.text = ZhString.AdventureFoodPage_TasteTitleTitle
	cookName.text = ZhString.AdventureFoodPage_CookTitleTitle

	local itemContainer = self:FindGO("bag_itemContainer");
	local pfbNum = 7

	local wrapConfig = {
		wrapObj = itemContainer,
		pfbNum = pfbNum,		
		cellName = "AdventureBagCombineItemCell",
		control = AdventureFoodPageCombineItemCell,
		dir = 1,
		disableDragIfFit = true,
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	self.wraplist:AddEventListener(AdventureFoodPage.CheckHashSelected, self.CheckHashSelected, self);
	self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self);
	self.scrollView = self:FindComponent("CookScrollView", ROUIScrollView);
	self.scrollView.OnStop = function ()
		self:ScrollViewRevert();
	end
	self.tipHolderCt = self:FindGO("tipHolderCt")
	self.tipHolder = self:FindGO("tipHolder")
	self.profileCt = self:FindGO("profileCt")
	local TasteIcon_Sprite = self:FindComponent("TasteIcon_Sprite",UISprite)
	IconManager:SetItemIcon("task_certificate2",TasteIcon_Sprite)
	local CookIcon_Sprite = self:FindComponent("CookIcon_Sprite",UISprite)
	IconManager:SetItemIcon("task_certificate1",CookIcon_Sprite)

	self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
	self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
	EventDelegate.Add(self.itemTabs.onChange, function()
		if self.selectTabData ~= self.itemTabs.data then
			self.selectTabData = self.itemTabs.data
			self:UpdateList()
		end
	end)

	self.tasteTog = self:FindComponent("tasteTog",UIToggle)
	self.cookTog = self:FindComponent("cookTog",UIToggle)
	self.detailDesCt = self:FindGO("detailDesCt")
end

function AdventureFoodPage:Server_NewFoodDataNtf(date)
	self:updateAllCookRecipe(true)
	if(self.tobeUnlock)then
		local cell = self:GetItemCellById(self.tobeUnlock)
		if(cell)then
			self:HandleClickItem(cell,true)
			cell:PlayUnlockEffect()
		end
	end
end

function AdventureFoodPage:ScrollViewRevert(callback)
	self.revertCallBack = callback;
	self.scrollView:Revert();
end

function AdventureFoodPage:ShowSelf(viewdata)
	self:Show()
	self:initTabData()
	self:updateAllCookRecipe()
	self:UpdateList()
	self.AdventureCookPage:ResetData()
	self.AdventureTastePage:ResetData()
end

function AdventureFoodPage:updateAllCookRecipe(noResetPos)
	self:UpdateList(noResetPos)
end

function AdventureFoodPage:initTabData()
	self.itemTabs:Clear()

	local tmpData = {}
	tmpData.id = AdventureFoodPage.MaxCategory.id
	tmpData.name = ZhString.AdventureFoodPage_AllFoods
	self.itemTabs:AddItem(tmpData.name,tmpData)

	for i=1,5 do
		local single = {id = i,name = string.format(ZhString.AdventureFoodPage_FoodsTab,i)}
		self.itemTabs:AddItem(single.name,single)
	end

	self.itemTabs.value = tmpData.name
end

function AdventureFoodPage:OnEnter(  )
	-- body
	AdventureFoodPage.super.OnEnter(self)
	if(self.viewMap ~=nil) then
		for _, o in pairs(self.viewMap) do 
			o:OnEnter()
		end
	end
	TimeTickManager.Me():CreateTick(0,300,self.checkSelect,self)
	self:TabChangeHandler(AdventureFoodPage.Category.CookPage)
end


function AdventureFoodPage:checkSelect( )
	-- body
	if(self.itemTabs.isOpen)then
		self:Show(self.ItemTabsBgSelect)
	else
		self:Hide(self.ItemTabsBgSelect)
	end
end

function AdventureFoodPage:OnExit(  )
	-- body
	if(self.viewMap ~=nil) then
		for _, o in pairs(self.viewMap) do 
			o:OnExit()
		end
	end
	self.selectTabData = nil	
	local cell = self:GetItemCellById(self.chooseItemId)
	if(cell)then
		cell:setIsSelected(false)
	end
	self.chooseItemId = nil
	TimeTickManager.Me():ClearTick(self)
end

function AdventureFoodPage:handleCategoryClick( key )
	-- body
	self:handleCategorySelect(key)
	if(key == AdventureFoodPage.Category.CookPage)then
		self.AdventureCookPage:ResetData()
	elseif(key == AdventureFoodPage.Category.TastePage)then
		self.AdventureTastePage:ResetData()
	end
end

function AdventureFoodPage:handleCategorySelect( key )
	-- body	
	if(key == AdventureFoodPage.Category.CookPage)then
		
	elseif(key == AdventureFoodPage.Category.TastePage)then
		
	end
	local cell = self:GetItemCellById(self.chooseItemId)
	if(cell)then
		cell:setIsSelected(false)
	end
	self:Hide(self.tipHolderCt)

	self.chooseItemId = nil
	self:ShowItemTip(nil)
	self:Show(self.detailDesCt)
end

function AdventureFoodPage:TabChangeHandler(key)
	-- body
	if(self.currentKey ~= key)then
		self:SuperTabChangeHandler(key)
		self:handleCategoryClick(key)
		self.currentKey = key
	end
end

--标签页开始
function AdventureFoodPage:AddTabChangeEvent(obj,target,openCheck,callback)
	if(not self.coreTabMap) then self.coreTabMap = {} end
	local key = openCheck
	if(type(openCheck)=="table" and openCheck.tab) then key = openCheck.tab end
	if(not self.coreTabMap[key]) then
		local toggle; 
		if(obj)then
			local togs = GameObjectUtil.Instance:GetAllComponentsInChildren(obj,UIToggle,true);
			toggle = togs and togs[1];
		end
		self.coreTabMap[key] = {check = openCheck,go = obj,tog = toggle,tar = target}
		if(obj~=nil) then
			self:AddClickEvent(obj,self:GetToggleEvent(callback))
		end
	end
end

function AdventureFoodPage:GetToggleEvent(callback)
	if(not self.coreToggleEvent) then
		self.coreToggleEvent = function(obj)
			if(self.coreTabMap) then
				for k,v in pairs(self.coreTabMap) do
					if(v.go == obj) then
						if(self:TabChangeHandler(k) and type(callback)=="function")then
							callback();
						end
						return
					end
				end
			end
		end
	end
	return self.coreToggleEvent
end

function AdventureFoodPage:SuperTabChangeHandler(key)
	if(self.coreTabMap) then
		local tabObj = self.coreTabMap[key]
		if(type(tabObj.check)=="table" and tabObj.check.id) then
			if(not FunctionUnLockFunc.Me():CheckCanOpenByPanelId(tabObj.check.id,true)) then
				if(tabObj.tog~=nil) then
					tabObj.tog.value = false
				end
				return false
			end
		end
		if(tabObj.tog~=nil) then
			tabObj.tog.value = true
		end
		for k,v in pairs(self.coreTabMap) do
			if(v.tar) then
				v.tar.gameObject:SetActive(k==key)
			end
		end
		return true
	end
	return nil
end

function AdventureFoodPage:HandleClickItem(cellCtl,noClickSound)
	if(cellCtl and cellCtl.data)then
		local data = cellCtl.data
		self.tobeUnlock = nil
		if(data.status == SceneFood_pb.EFOODSTATUS_ADD)then
			ServiceSceneFoodProxy.Instance:CallClickFoodManualData(SceneFood_pb.EFOODDATATYPE_FOODCOOK,data.itemid)
			self:PlayUISound(AudioMap.UI.maoxianshoucedianjijiesuo)
			-- local cell = self:GetItemCellById(self.chooseItemId)
			-- if(cell)then
			-- 	cell:setIsSelected(false)
			-- end
			self.tobeUnlock = data.itemid
			return
		end
		if(data.itemid ~= self.chooseItemId) then
			local cell = self:GetItemCellById(self.chooseItemId)
			if(cell)then
				cell:setIsSelected(false)
			end
			if(not noClickSound)then
				self:PlayUISound(AudioMap.UI.Click)
			end
			
			self:Hide(self.detailDesCt)
			self.currentKey = nil
			self.tasteTog.value = false
			self.cookTog.value = false
			if(self.tip)then
				self.tip:SetData(data)
			else
				self:ShowItemTip(data);
			end
			self.chooseItemId=data.itemid
			cellCtl:setIsSelected(true)			
		end	
	end	
end

function AdventureFoodPage:ShowItemTip( data )
	-- body
	self:removeTip()
	if(not data)then
		return;
	end
	self:Show(self.tipHolderCt)
	self.tip = FoodScoreTip.new(self.tipHolder);
	self.tip:SetData(data);
end

function AdventureFoodPage:removeTip(  )
	-- body
	if(self.tipHolder.transform.childCount >0)then
		local tip = self.tipHolder.transform:GetChild(0)
		if(tip and self.tip)then
			self.tip:OnExit()
		end
	end
	self.tip = nil
end

function AdventureFoodPage:CheckHashSelected( cellCtl )
	if(cellCtl and cellCtl.data and self.chooseItemId)then
		if(self.chooseItemId == cellCtl.data.itemid)then
			cellCtl:setIsSelected(true)
		else
			cellCtl:setIsSelected(false)
		end
	else
		if(cellCtl)then
			cellCtl:setIsSelected(false)
		end
	end
end

function AdventureFoodPage:UpdateList(noResetPos)
	local food_cook_info = FoodProxy.Instance.food_cook_info
	local list = {}
	local tabId = AdventureFoodPage.MaxCategory.id
	if(self.selectTabData)then
		tabId = self.selectTabData.id
	end
	for k,v in pairs(food_cook_info) do
		if(v.itemData and v.itemData.staticData and 
			v.itemData.staticData.AdventureValue and 
			v.itemData.staticData.AdventureValue ~=0 and
			AdventureItemData.CheckValid( v.itemData.staticData ))then
			local foodData = Table_Food[k]
			local hardLv = math.floor((foodData.CookHard+1)/2)
			if(tabId == AdventureFoodPage.MaxCategory.id)then
				list[#list+1] = v
			elseif(hardLv == tabId)then
				list[#list+1] = v
			end
		end
	end

	table.sort(list,function ( l,r )
		-- body
		return l.itemid < r.itemid
	end)

	self:SetData(list, noResetPos);
end

function AdventureFoodPage:SetData(datas, noResetPos)
	local newdata = self:ReUnitData(datas, 5);
	self.wraplist:UpdateInfo(newdata);
	if(not noResetPos and self.gameObject.activeSelf)then
		self.wraplist:ResetPosition()
	end
end

function AdventureFoodPage:ReUnitData(datas, rowNum)
	if(not self.unitData)then
		self.unitData = {};
	else
		TableUtility.ArrayClear(self.unitData);
	end

	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/rowNum)+1;
			local i2 = math.floor((i-1)%rowNum)+1;
			self.unitData[i1] = self.unitData[i1] or {};
			if(datas[i] == nil)then
				self.unitData[i1][i2] = nil;
			else
				self.unitData[i1][i2] = datas[i];
			end
		end
	end
	return self.unitData;
end

function AdventureFoodPage:GetItemCellById(id)
	if(not id)then
		return 
	end
	local cells = self:GetItemCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			local single = cells[i]
			if(single.data and single.data.itemid == id)then
				return single
			end
		end
	end
end

function AdventureFoodPage:GetItemCells()
	local combineCells = self.wraplist:GetCellCtls();
	local result = {};
	for i=1,#combineCells do
		local v = combineCells[i];
		local childs = v:GetCells();
		for i=1,#childs do
			table.insert(result, childs[i]);
		end
	end
	return result;
end