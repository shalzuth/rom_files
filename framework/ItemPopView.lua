local BaseCell = autoImport("BaseCell");
ItemPopView = class("ItemPopView", BaseCell);
autoImport("PopItemCell");

local EFFECTMAP_DECOMPOSE_RESULT = 
{
	[SceneItem_pb.EDECOMPOSERESULT_FAIL] = "equip_tex_01",
	[SceneItem_pb.EDECOMPOSERESULT_SUCCESS] = "equip_tex_02",
	[SceneItem_pb.EDECOMPOSERESULT_SUCCESS_BIG] = "equip_tex_03",
	[SceneItem_pb.EDECOMPOSERESULT_SUCCESS_SBIG] = "equip_tex_04",
	[SceneItem_pb.EDECOMPOSERESULT_SUCCESS_FANTASY] = "equip_tex_05",
}

function ItemPopView:Init()
	self:InitUI();	
end

function ItemPopView:InitUI()
	-- self.icon = self:FindComponent("Icon", UISprite);
	-- self.tip = SpriteLabel.new(self:FindGO("MsgLabel"),nil,50,50,true)
	local panel = self:FindGO("ScrollView"):GetComponent(UIPanel)
	self.ScrollView = panel.gameObject:GetComponent(UIScrollView)
	local temp = self.gameObject:GetComponentInParent(UIPanel)
	-- panel.gameObject:SetActive(false)
	if(temp)then
		panel.depth = temp.depth+1
	end
	self.shadowPanel = self:FindGO("shadowPanel"):GetComponent(UIPanel)
	self.shadowPanel.depth = temp.depth+2
	-- panel.gameObject:SetActive(true)
	self:Show(panel.gameObject)

	self.grid = self:FindGO("Grid"):GetComponent(UIGrid)	
	self.grid = UIGridListCtrl.new(self.grid , PopItemCell, "PopItemCell");
	self.grid:AddEventListener(MouseEvent.MouseClick, self.itemClick, self);
	self.icon = self:FindGO("TitleIcon"):GetComponent(UISprite)
	self.uiEquipIcon = self:FindGO("EquipUIIcon"):GetComponent(UISprite)
	self.animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer);
	self.animHelper = self.animHelper.animatorHelper;
	self.itemStick = self:FindGO("PopViewBg"):GetComponent(UISprite)
	self.oneItem = self:FindGO("OneItem")
	self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
	self.DragCollider = self:FindGO("DragCollider")
	self:AddAnimatorEvent()
end

function ItemPopView:itemClick( child )
	-- body
	local data = child.data
	local data = {itemdata = data, funcConfig = {}}
	self:ShowItemTip(data,self.itemStick, NGUIUtil.AnchorSide.Right, {200, 0})
end

function ItemPopView:IsShowed()
	return self.isShowed
end

function ItemPopView:ResetAnim()
	self.isShowed = false
	LeanTween.cancel(self.gameObject)
    LeanTween.delayedCall(self.gameObject,GameConfig.ItemPopShowTimeLim,function ()
    	self.isShowed = true
	end)
end

function ItemPopView:PlayHide()
	if(self.isShowed) then
		self:PassEvent(SystemUnLockEvent.ShowNextEvent,self.data)
		-- self.animHelper:Play("UnLockAnim2", 1, false);
	end
end

function ItemPopView:AddAnimatorEvent()
	self.animHelper.loopCountChangedListener = function (state, oldLoopCount, newLoopCount)
		if(not self.isShowed)then
			-- self.isShowed = true;
		end
	end
end

local tempVector3 = LuaVector3.zero

function ItemPopView:SetData(data)
	self.data = data
	self:ResetAnim();
	self:Hide(self.oneItem)

	if(data.data.showType == PopUp10View.ItemCoinShowType.Decompose) then
		self:Hide(self.icon.gameObject)
		self:Show(self.uiEquipIcon.gameObject)
		self.uiEquipIcon.spriteName = EFFECTMAP_DECOMPOSE_RESULT[data.data.params]
		self.uiEquipIcon:MakePixelPerfect()
	else
		self:Show(self.icon.gameObject)
		self:Hide(self.uiEquipIcon.gameObject)
	end
	self:Show(self.DragCollider)
	if(data.data and #(data.data) == 1)then
		self:Show(self.oneItem)
		--todo xde 
		local itemTxt =  OverseaHostHelper:FilterLangStr(data.data[1]:GetName().." × "..data.data[1].num)
		self.itemName.text = itemTxt
		local itemplaceholder = self:FindGO("itemplaceholder")
		self:Hide(self.DragCollider)
		local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PopItemCell"), itemplaceholder);
		local itemCell = PopItemCell.new(obj)
		tempVector3:Set(0,0,0)
		obj.transform.localPosition = tempVector3
		itemCell:AddEventListener(MouseEvent.MouseClick,self.itemClick,self)
		itemCell:SetData(data.data[1])
		itemCell:Hide(itemCell.numLab)
		-- itemCell:Hide(itemCell.damageSymbol)
		-- itemCell:Hide(itemCell.strenglv)
		-- itemCell:Hide(itemCell.refinelv)
		local bound = NGUIMath.CalculateRelativeWidgetBounds(self.oneItem.transform,true)
		local width = bound.size.x
		tempVector3:Set(LuaGameObject.GetLocalPosition(self.oneItem.transform))
		tempVector3:Set(- width/2,tempVector3.y,tempVector3.z) 
		self.oneItem.transform.localPosition = tempVector3

		--todo xde fix ui
		OverseaHostHelper:FixLabelOverV1(self.itemName,3,320)
		self.itemName.pivot = UIWidget.Pivot.Center
		self.itemName.transform.localPosition = Vector3(260,0,0)
		self.oneItem.transform.localPosition = Vector3(-205,0,0)
		self.Hide(self.shadowPanel)
	
		return
	elseif(data.data and #(data.data) < 5 )then
		self.ScrollView.contentPivot = UIWidget.Pivot.Center;
		self.Hide(self.shadowPanel)
	else
		self.Show(self.shadowPanel)
		self.ScrollView.contentPivot = UIWidget.Pivot.Left;		
	end
	self.grid:ResetDatas(data.data)
	self.ScrollView:ResetPosition();
	-- self.animHelper:Play("UnLockMsg1", 1, false);
	-- self:PlayCommonSound(AudioMap.Maps.FunctionUnlock);
end

function ItemPopView:SetTitleIcon(configIcon)
	-- local atlasStr;
	-- local iconStr = "";
	-- if(configIcon ~= nil)then
	-- 	if(type(configIcon)=="table") then
	-- 		atlasStr,iconStr= next(configIcon)
	-- 	else
	-- 		atlasStr,iconStr = MsgParserProxy.Instance:GetIconInfo(configIcon)
	-- 	end
	-- 	if(atlasStr ~=nil and iconStr~=nil) then
	-- 		self:Show(self.icon)
	-- 		if(atlasStr == "itemicon")then
	-- 			IconManager:SetItemIcon(iconStr, self.icon)
	-- 			self.icon:MakePixelPerfect()
	-- 		elseif(atlasStr == "skillicon")then
	-- 			IconManager:SetSkillIcon(iconStr, self.icon)
	-- 			self.icon:MakePixelPerfect()
	-- 		else
	-- 			IconManager:SetUIIcon(iconStr, self.icon)
	-- 			self.icon:MakePixelPerfect()
	-- 		end
	-- 	end
	-- else
	-- 	self:Hide(self.icon)
	-- end
end

function ItemPopView:SetIcon(icon)
	self.icon.spriteName = icon;
end