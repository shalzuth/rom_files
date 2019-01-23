AdventureCookPage = class("AdventureCookPage", SubView)

autoImport("WrapCellHelper")
autoImport("AdventureFoodRecipeCell")
autoImport("PersonalPicturCombineItemCell")
autoImport("PersonalPictureDetailPanel")

AdventureCookPage.ClickId = {
	RefreshIndicator = 1,
	CheckSelect = 2,
}

AdventureCookPage.DataType = {
	UnlockRecipe = 1,
	RecentCook = 2,
}

local tempVector3 = LuaVector3.zero

function AdventureCookPage:Init()
	self:AddViewEvts();
	self:initView();
	self:initData()
end

function AdventureCookPage:OnEnter()
	self:ResetData()
end

function AdventureCookPage:ResetData()
	self:updateCookTitle()
	self:updateUnlockRecipe()
	self:updateRecentCook()
	self:updateNextLevel()
	self.FoodPageProfileView:ResetPosition()
end

function AdventureCookPage:initData()
	self:UpdateHead()
	local UserName = self:FindComponent("UserName",UILabel)
	UserName.text = Game.Myself.data:GetName()
	self.FoodPageProfileView:ResetPosition()
end

function AdventureCookPage:UpdateHead(  )
	-- body
	if(not self.targetCell)then
		local headCellObj = self:FindGO("PortraitCell")		
		self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId,headCellObj)
		tempVector3:Set(0,0,0)
		self.headCellObj.transform.localPosition = tempVector3
		self.targetCell = PlayerFaceCell.new(self.headCellObj)

		self.targetCell:HideLevel()
		self.targetCell:HideHpMp()
	end
	local headData = HeadImageData.new();
	headData:TransByLPlayer(Game.Myself);
	-- 临时处理
	headData.frame = nil;
	headData.job = nil;
	self.targetCell:SetData(headData);
end

function AdventureCookPage:updateCookTitle()
	local apl = MyselfProxy.Instance:GetCurFoodCookerApl()
	if(apl and apl.staticData)then
		self.adventureProfileTitle.text = apl.staticData.Name
		self.foodDescriptionText.text = string.format(ZhString.AdventureFoodPage_CookDes,apl.staticData.Name)
	else
		self.foodDescriptionText.text = ""
	end

	local userData = Game.Myself.data.userdata
	if(userData)then
		local exp = userData:Get(UDEnum.COOKER_EXP) or 1
		local lv = userData:Get(UDEnum.COOKER_LV) or 1
		self.lvLabel.text = string.format(ZhString.AdventureFoodPage_CookLv,lv)
		local lvData = Table_CookerLevel[lv+1]
		if(lvData)then
			self.expLabel.text = exp.."/"..lvData.NeedExp
			self.expSlider.value = exp/lvData.NeedExp
		else
			exp = Table_CookerLevel[lv] and Table_CookerLevel[lv].NeedExp or 0
			self.expLabel.text = exp.."/"..exp
			self.expSlider.value = 1
		end
	end
end

function AdventureCookPage:updateUnlockRecipe()
	local items = FoodProxy.Instance.recipe_id_map
	local list = {}
	local dataMap = {}
	for k,v in pairs(items) do
		if(v.unlock)then
			local hardLv = math.floor((v:GetDiffLevel()+1)/2)
			local data = dataMap[hardLv]
			if(data)then
				data.count = data.count +1
			else
				data =  {lv = hardLv,count = 1}
				list [#list+1] = data
				dataMap[hardLv] = data
			end
		end
	end
	table.sort(list,function ( l,r )
		return l.lv < r.lv
	end)

	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.foodDescriptionText.transform,false)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.foodDescriptionText.transform)

	if(#list ==0)then
		self.cookProfileTitle.text = ""
		self:Hide(self.secondContent)
		y = y - height
	else
		y = y - height - 20	
		self:Show(self.secondContent)
		self.cookProfileTitle.text = ZhString.AdventureFoodPage_UnlockRecipeTitle
		self.cookProfileList:ResetDatas(list)
	end
	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
	tempVector3:Set(x1,y,z1)
	self.secondContent.transform.localPosition = tempVector3
end

function AdventureCookPage:updateRecentCook()
	local items = FoodProxy.Instance.last_cooked_foods
	local list = {}
	for i=1,#items do
		local itemData = ItemData.new(nil,items[i])
		if(itemData)then
			list[#list+1] = itemData
		end
	end

	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.secondContent.transform,false)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.secondContent.transform)	
	if(#list==0)then
		self.recentFoodTitle.text = ""
		self:Hide(self.thirdContent)
		y = y - height
	else
		y = y - height - 20
		self:Show(self.thirdContent)
		self.recentFoodTitle.text = ZhString.AdventureFoodPage_RecentCookTitle
		self.recentFoodList:ResetDatas(list)
	end
	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
	tempVector3:Set(x1,y,z1)
	self.thirdContent.transform.localPosition = tempVector3
end

function AdventureCookPage:updateNextLevel()

	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.thirdContent.transform,false)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
	y = y - height - 20

	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.fourthContent.transform)
	tempVector3:Set(x1,y,z1)
	self.fourthContent.transform.localPosition = tempVector3

	local userData = Game.Myself.data.userdata
	if(userData)then
		local lv = userData:Get(UDEnum.COOKER_LV) or 0
		local lvData = Table_CookerLevel[lv+1]
		local curLvData = Table_CookerLevel[lv]
		if(lvData)then
			local title = Table_Appellation[lvData.Title]
			local Book = Table_Item[lvData.Book]
			if(title)then
				local slot = 0
				if(curLvData)then
					slot = lvData.RewardBagSlot - curLvData.RewardBagSlot
				end
				self.nextLevelDes.text = string.format(ZhString.AdventureFoodPage_NextLevelReward,title.Name,slot,Book.NameZh,lvData.SuccessRate)
			else
				self.nextLevelDes.text = "Table_Appellation can't find data by id:"..lvData.Title
			end
		else
			self:Hide(self.fourthContent)
		end
	end
end

function AdventureCookPage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.SceneFoodUpdateFoodInfo,self.Server_UpdateFoodInfo)
	self:AddListenEvt(ServiceEvent.SceneFoodUnlockRecipeNtf,self.Server_UnlockRecipeNtf)
	self:AddListenEvt(MyselfEvent.MyDataChange,self.UpdateUserInfo)
end

function AdventureCookPage:Server_UnlockRecipeNtf()
	self:updateUnlockRecipe()
end

function AdventureCookPage:UpdateUserInfo()
	self:updateCookTitle()
	self:updateNextLevel()
end

function AdventureCookPage:Server_UpdateFoodInfo()
	self:updateRecentCook()
end

function AdventureCookPage:initView()
	self.gameObject = self:FindGO("AdventureCookPage")

	self.adventureProfileTitle = self:FindComponent("AdventureFoodTitleLabel",UILabel)
	self.expLabel = self:FindComponent("expLabel",UILabel)
	self.expSlider = self:FindComponent("expSlider",UISlider)
	self.foodDescriptionText = self:FindComponent("FoodDescriptionText",UILabel)
	self.lvLabel = self:FindComponent("lvLabel",UILabel)

	self.secondContent = self:FindGO("secondContent")
	self.cookProfileTitle = self:FindComponent("cookProfileTitle",UILabel)
	self.cookProfileTitle.text = ZhString.AdventureFoodPage_UnlockRecipeTitle
	self.cookProfileList =self:FindComponent("cookProfileList",UIGrid)
	self.cookProfileList = UIGridListCtrl.new(self.cookProfileList,AdventureFoodRecipeCell,"AdventureFoodRecipeCell")

	self.thirdContent = self:FindGO("thirdContent")
	self.recentFoodTitle = self:FindComponent("recentFoodTitle",UILabel)
	self.recentFoodTitle.text = ZhString.AdventureFoodPage_RecentCookTitle
	self.recentFoodList = self:FindComponent("recentFoodList",UIGrid)
	self.recentFoodList = UIGridListCtrl.new(self.recentFoodList,ItemCell,"RecentFoodItemCell")

	self.fourthContent = self:FindGO("fourthContent")
	self.nextLevelTitle = self:FindComponent("nextLevelTitle",UILabel)
	self.nextLevelTitle.text = ZhString.AdventureFoodPage_NextLevelTitle
	self.nextLevelDes = self:FindComponent("nextLevelDes",UILabel)
	self.FoodPageProfileView = self:FindComponent("FoodPageProfileView",UIScrollView)
end