AdventureTastePage = class("AdventureTastePage", SubView)

autoImport("WrapCellHelper")
autoImport("AdventureFoodBufferCell")
autoImport("PersonalPicturCombineItemCell")
autoImport("PersonalPictureDetailPanel")

local tempVector3 = LuaVector3.zero

function AdventureTastePage:Init()
	self:AddViewEvts();
	self:initView();
	self:initData()
end

function AdventureTastePage:ResetData()
	self:updateTasteTitle()
	self:updateRecentTaste()
	self:updateNextLevel()
	self.FoodPageProfileView:ResetPosition()
end

function AdventureTastePage:OnEnter()
	self:ResetData()
end

function AdventureTastePage:initData()
	self:UpdateHead()
	local UserName = self:FindComponent("UserName",UILabel)
	UserName.text = Game.Myself.data:GetName()
	self.FoodPageProfileView:ResetPosition()
end

function AdventureTastePage:UpdateHead(  )
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

function AdventureTastePage:updateTasteTitle()
	local apl = MyselfProxy.Instance:GetCurFoodTasteApl()
	if(apl and apl.staticData)then
		self.adventureProfileTitle.text = apl.staticData.Name		
	end
	local userData = Game.Myself.data.userdata
	if(userData)then
		local exp = userData:Get(UDEnum.TASTER_EXP) or 1
		local lv = userData:Get(UDEnum.TASTER_LV) or 1
		self.lvLabel.text = string.format(ZhString.AdventureFoodPage_TasteLv,lv)
		if(apl and apl.staticData)then
			local userData = Game.Myself.data.userdata
			local foods = FoodProxy.Instance:GetEatFoods()
			local cur = foods and #foods or 0
			local curLv = userData:Get(UDEnum.TASTER_LV) or 0
			local tbData = Table_TasterLevel[curLv]
			local progress = 1
			if(tbData)then
				progress = tbData.AddBuffs
			else
				progress = GameConfig.Food.MaxSatiety_Default or 80
			end
			local satiety = cur.."/"..progress
			self.foodDescriptionText.text = string.format(ZhString.AdventureFoodPage_TasteDes,apl.staticData.Name,progress,satiety)
		end
		local lvData = Table_TasterLevel[lv+1]
		if(lvData)then
			self.expLabel.text = exp.."/"..lvData.NeedExp
			self.expSlider.value = exp/lvData.NeedExp			
		else
			exp = Table_TasterLevel[lv] and Table_TasterLevel[lv].NeedExp or 0
			self.expLabel.text = exp.."/"..exp
			self.expSlider.value = 1
		end
	end
end

function AdventureTastePage:updateRecentTaste()
	local items = FoodProxy.Instance.eating_foods
	local list = {}
	for i=1,#items do
		local itemData = ItemData.new(nil,items[i].itemid)
		if(itemData)then
			list[#list+1] = itemData
		end
	end
	local bufferList = FoodProxy.Instance:GetMyFoodBuffProps()

	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.foodDescriptionText.transform,true)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.foodDescriptionText.transform)
	if(#list==0)then
		self.recentFoodTitle.text = ""
		self:Hide(self.secondContent)
		y = y - height
	else
		y = y - height - 20
		self:Show(self.secondContent)
		self.recentFoodTitle.text = ZhString.AdventureFoodPage_RecentTasteState
		self.recentFoodList:ResetDatas(list)

		local bd = NGUIMath.CalculateRelativeWidgetBounds(self.recentFoodListGrid.transform,true)
		local gridHeight = bd.size.y
		local x,gridY,z = LuaGameObject.GetLocalPosition(self.recentFoodListGrid.transform)

		local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.recentFoodBufferListGrid.transform)
		tempVector3:Set(x1,gridY - gridHeight,z1)
		self.recentFoodBufferListGrid.transform.localPosition = tempVector3

		self.recentFoodBufferList:ResetDatas(bufferList)
	end
	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
	tempVector3:Set(x1,y,z1)
	self.secondContent.transform.localPosition = tempVector3
end

function AdventureTastePage:updateNextLevel()

	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.secondContent.transform,false)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.secondContent.transform)
	y = y - height - 20

	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
	tempVector3:Set(x1,y,z1)
	self.thirdContent.transform.localPosition = tempVector3

	local userData = Game.Myself.data.userdata
	if(userData)then
		local lv = userData:Get(UDEnum.TASTER_LV) or 0
		local lvData = Table_TasterLevel[lv+1]
		if(lvData)then
			local title = Table_Appellation[lvData.Title]
			if(title)then
				self.nextLevelDes.text = string.format(ZhString.AdventureFoodPage_NextTasteLevelReward,title.Name,lvData.AddBuffs)
			else
				self.nextLevelDes.text = "Table_Appellation can't find data by id:"..lvData.Title
			end
		else
			self:Hide(self.thirdContent)
		end
	end
end

function AdventureTastePage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.SceneFoodUpdateFoodInfo,self.Server_UpdateFoodInfo)
	self:AddListenEvt(MyselfEvent.MyDataChange,self.UpdateUserInfo)
end

function AdventureTastePage:Server_UpdateFoodInfo()
	self:updateRecentTaste()
end

function AdventureTastePage:UpdateUserInfo()
	self:updateTasteTitle()
	self:updateNextLevel()
end

function AdventureTastePage:initView()
	self.gameObject = self:FindGO("AdventureTastePage")

	self.adventureProfileTitle = self:FindComponent("AdventureFoodTitleLabel",UILabel)
	self.expLabel = self:FindComponent("expLabel",UILabel)
	self.expSlider = self:FindComponent("expSlider",UISlider)
	self.foodDescriptionText = self:FindComponent("FoodDescriptionText",UILabel)
	self.lvLabel = self:FindComponent("lvLabel",UILabel)

	self.secondContent = self:FindGO("secondContent")
	self.recentFoodTitle = self:FindComponent("recentFoodTitle",UILabel)
	self.recentFoodTitle.text = ZhString.AdventureFoodPage_RecentTasteState
	self.recentFoodListGrid = self:FindComponent("recentFoodList",UIGrid)
	self.recentFoodList = UIGridListCtrl.new(self.recentFoodListGrid,ItemCell,"RecentFoodItemCell")
 
	self.recentFoodBufferListGrid =self:FindComponent("recentFoodBufferList",UIGrid)
	self.recentFoodBufferList = UIGridListCtrl.new(self.recentFoodBufferListGrid,AdventureFoodBufferCell,"AdventureFoodRecipeCell")

	self.thirdContent = self:FindGO("thirdContent")
	self.nextLevelTitle = self:FindComponent("nextLevelTitle",UILabel)
	self.nextLevelTitle.text = ZhString.AdventureFoodPage_NextLevelTitle
	self.nextLevelDes = self:FindComponent("nextLevelDes",UILabel)
	self.FoodPageProfileView = self:FindComponent("FoodPageProfileView",UIScrollView)
end