TipManager = class("TipManager");

autoImport("BubbleTip");
autoImport("ItemFloatTip");
autoImport("ItemScoreTip");
autoImport("MonsterScoreTip");
autoImport("NpcScoreTip");
autoImport("MonthScoreTip");
autoImport("CollectScoreTip");
autoImport("PetScoreTip");
autoImport("CollectGroupScoreTip");
autoImport("NormalTip");
autoImport("ItemFormulaTip");
autoImport("RecommendPetTip")
autoImport("AstrolabeTipView");
autoImport("HireCatTip");
autoImport("TitlePropTip")
autoImport("TitleTip")
autoImport("FoodRecipeTip");
autoImport("SkipAnimationTip")
autoImport("EquipChooseTip");
autoImport("PetFashionChooseTip");
autoImport("PetSkillTip");
autoImport("TutorFindTip")
autoImport("PreQuestTip")
autoImport("GvgQuestTip")
autoImport("GvgFinalFightTip")
autoImport("HRefineAddEffectTip")
autoImport("TaskQuestTip")
autoImport("GuildBuildingTip")
autoImport("PetAdventureSpeicidTip")
autoImport("PetAdventureEffTip")
autoImport("PropTypeTip")
autoImport("PetAdventureHeadTip")
autoImport("EatFoodInfoTip")
autoImport("TabNameTip")

TipManager.Instance = nil;

function TipManager:ctor()
	self:Init();
	TipManager.Instance = self;
end

function TipManager:Init()
	self.bubbleTips = {};
end

function TipManager:ShowItemTip(data, funcConfig, stick, side, offset, tip, callback, hideGetPath)
	local sdata = {
		itemdata = data,
		tip = tip,
		callback = callback,
		hideGetPath = hideGetPath,
		funcConfig = funcConfig,
	};
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(ItemFloatTip, sdata, side, stick, offset, "ItemFloatTip");
	return TipsView.Me().currentTip;
end

function TipManager:ShowItemFloatTip(data, stick, side, offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(ItemFloatTip, data, side, stick, offset, "ItemFloatTip");
	return TipsView.Me().currentTip;
end

function TipManager:ShowSkipAnimationTip(data, stick, side, offset)
	side = side or NGUIUtil.AnchorSide.TopRight
	offset = offset or {0,0}

	local _TipsView = TipsView.Me()
	_TipsView:ShowStickTip(SkipAnimationTip, data, side, stick, offset, "SkipAnimationTip")
	return _TipsView.currentTip
end

function TipManager:ShowTutorFindTip(data, stick, side, offset)
	side = side or NGUIUtil.AnchorSide.TopRight
	offset = offset or {0,0}

	local _TipsView = TipsView.Me()
	_TipsView:ShowStickTip(TutorFindTip, data, side, stick, offset, "TutorFindTip")
	return _TipsView.currentTip
end

-- 升级／制作配方 Tips 
function TipManager:ShowFormulaTip(itemData,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	if(self.formularTip~=nil)then
		self.formularTip:CloseSelf();
	end
	local path = ResourcePathHelper.UICell("ItemFormulaTip");
	local obj = Game.AssetManager_UI:CreateAsset(path, TipsView.Me().gameObject);
	self.formularTip = ItemFormulaTip.new(obj)
	self.formularTip:SetData(itemData);
	local pos = NGUIUtil.GetAnchorPoint(nil,stick,side,offset)
	self.formularTip:SetPos(pos);
	return self.formularTip;
end

-- 推荐宠物Tips
function TipManager:ShowRecommendTip(data,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(RecommendPetTip,data,side,stick,offset,"RecommendPetTip")
	local recommendPetTip = TipsView.Me().currentTip
	return recommendPetTip
end

-- 称号属性Tips
function TipManager:ShowTitlePropTip(propdata,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(TitlePropTip,propdata,side,stick,offset,"TitlePropTip")
end

-- 称号Tips
function TipManager:ShowTitleTip(data,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(TitleTip,data,side,stick,offset,"TitleTip")

	local titleTip = TipsView.Me().currentTip;
	-- if(not Slua.IsNull(stick))then
	-- 	titleTip:AddIgnoreBounds(stick);
	-- end
	return titleTip;
end

-- 公会设施Tips
function TipManager:ShowGuildBuildingTip(data,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(GuildBuildingTip,data,side,stick,offset,"GuildBuildingTip")

	local tip = TipsView.Me().currentTip;
	return tip;
end

-- 宠物冒险选择指定魔物
function TipManager:ShowPetSpeicMonsterTip(data,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(PetAdventureSpeicidTip,data,side,stick,offset,"PetAdventureSpeicidTip")
	local tip = TipsView.Me().currentTip
	return tip
end

function TipManager:HidePetSpecTip()
	local currentTipType = TipsView.Me().currentTipType
	if(currentTipType == PetAdventureSpeicidTip)then
		TipsView.Me():HideCurrent();
	end
end

-- 宠物冒险效率值
function TipManager:ShowPetAdventureEffDetail(data,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(PetAdventureEffTip,data,side,stick,offset,"PetAdventureEffTip")
	local tip = TipsView.Me().currentTip
	return tip
end

function TipManager:HidePetEffTip()
	local currentTipType = TipsView.Me().currentTipType
	if(currentTipType == PetAdventureEffTip)then
		TipsView.Me():HideCurrent();
	end
end

function TipManager:HideTitleTip()
	local currentTipType = TipsView.Me().currentTipType
	if(currentTipType == TitleTip)then
		TipsView.Me():HideCurrent();
	end
end

-- 星盘Tips
function TipManager:ShowAstrobeTip(data,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(AstrolabeTipView,data,side,stick,offset,"AstrolabeTipView")
	return TipsView.Me().currentTip;
end

-- 最多出现三个Tips 
function TipManager:ShowCompItemTip(data, compdatas, funcConfig, stick, side, offset, callback)
	local sdata = {
		itemdata = data,
		funcConfig = funcConfig,
		compdata1 = compdatas[1],
		compdata2 = compdatas[2],
		callback = callback,
	};
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};

	TipsView.Me():ShowStickTip(ItemFloatTip, sdata, side, stick, offset, "ItemFloatTip");
	return TipsView.Me().currentTip;
end

function TipManager:ShowCatTipById(id, stick, side, offset)
	local sData = Table_MercenaryCat[id];
	local tempData = {
		staticData = sData,
	};
	return self:ShowCatTip(tempData, stick, side, offset);
end

function TipManager:ShowCatTip(data, stick, side, offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};

	TipsView.Me():ShowStickTip(HireCatTip, data, side, stick, offset, "HireCatTip");

	local hireCatTip = TipsView.Me().currentTip;
	hireCatTip:AddAutoCloseEvent();
	if(not Slua.IsNull(stick))then
		hireCatTip:AddIgnoreBounds(stick);
	end
	return hireCatTip;
end

function TipManager:HideCatTip()
	local currentTipType = TipsView.Me().currentTipType
	if(currentTipType == HireCatTip)then
		TipsView.Me():HideCurrent();
	end
end

function TipManager:DestroyChildren(obj)
	local objNil = GameObjectUtil.Instance:ObjectIsNULL(obj);
	if(not objNil)then
		local childCount = obj.transform.childCount;
		if(childCount>0)then
			for i=0,childCount-1 do
				GameObject.DestroyImmediate(obj.transform:GetChild(i).gameObject);
			end
		end
	end
	return not objNil;
end

function TipManager:ShowPicMakeTip(data)
	TipsView.Me():ShowStickTip(data);
end

function TipManager:ShowBubbleTipById(id, stick, side, offset, closecallback)	
	local cathchTip = self.bubbleTips[id];
	if(cathchTip)then
		self:CloseBubbleTip(id);
	end

	local bubbleData = Table_BubbleID[id];
	if(bubbleData and bubbleData.Offset)then
		offset = offset or {};
		offset[1] = offset[1] or 0;
		offset[2] = offset[2] or 0;
		offset[1] = offset[1] + (bubbleData.Offset[1] or 0);
		offset[2] = offset[2] + (bubbleData.Offset[2] or 0);
	end

	self.bubbleTips[id] = BubbleTip.new("BubbleTip", stick, side, offset);
	local data = {
		bubbleid = id,
		closecallback = closecallback,
	};
	self.bubbleTips[id]:SetData(data);
	self.bubbleTips[id]:OnEnter();
	return self.bubbleTips[id];
end

function TipManager:CloseBubbleTip(bubbleid)
	if(bubbleid)then
		if(self.bubbleTips[bubbleid])then
			self.bubbleTips[bubbleid]:OnExit();
			self.bubbleTips[bubbleid] = nil;
		end
	else
		for _,tip in pairs(self.bubbleTips)do
			tip:OnExit();
		end
		self.bubbleTips = {};
	end
end

function TipManager:CloseItemTip()
	TipManager.CloseTip()
end

function TipManager:ShowNormalTip(text, stick, side, offset, closecallback, ignoreBounds)
	self:CloseNormalTip();
	self.normalTip = NormalTip.new("NormalTip", stick, side, offset);
	self.normalTip:SetData(text);
	self.normalTip:OnEnter();
	
	if(ignoreBounds)then
		for _,obj in pairs(ignoreBounds)do
			self.normalTip:AddIgnoreBounds(obj);
		end
	end
	return self.normalTip;
end

function TipManager:CloseNormalTip()
	if(self.normalTip)then
		self.normalTip:OnExit();
		self.normalTip:DestroySelf();
		self.normalTip = nil;
	end
end

function TipManager:ShowEatFoodInfoTip(text, textTime, stick, side, offset, closecallback, ignoreBounds)
	self:CloseEatFoodInfoTip();
	self.eatFoodInfoTip = EatFoodInfoTip.new("EatFoodInfoTip", stick, side, offset);
	self.eatFoodInfoTip:SetData(text, textTime);
	self.eatFoodInfoTip:OnEnter();
	
	if(ignoreBounds)then
		for _,obj in pairs(ignoreBounds)do
			self.eatFoodInfoTip:AddIgnoreBounds(obj);
		end
	end
	return self.eatFoodInfoTip;
end

function TipManager:CloseEatFoodInfoTip()
	if(self.eatFoodInfoTip)then
		self.eatFoodInfoTip:OnExit();
		self.eatFoodInfoTip:DestroySelf();
		self.eatFoodInfoTip = nil;
	end
end

function TipManager:ShowRewardListTip( data, stick, side, offset )
	self:CloseRewardListTip();
	TipsView.Me():ShowStickTip(RewardListTip, data, side, stick, offset, "RewardListTip");
	
	return TipsView.Me().currentTip;
end

function TipManager:CloseRewardListTip()
	TipsView.Me():HideCurrent();
end

function TipManager:CloseTip()
	TipsView.Me():HideCurrent();
end

function TipManager:ShowFoodRecipeTip(recipeData, stick, side, offset)
	self:CloseRecipeTip();
	
	TipsView.Me():ShowStickTip(FoodRecipeTip, recipeData, side, stick, offset, "FoodRecipeTip");
	return TipsView.Me().currentTip;
end

function TipManager:CloseRecipeTip()
	TipsView.Me():HideCurrent();
end

function TipManager:ShowEquipChooseTip( datas, stick, offset, closecall, closeCallParam)
	self:CloseTip();

	TipsView.Me():ShowStickTip(EquipChooseTip, datas, side, stick, offset, "EquipChooseTip");
	
	return TipsView.Me().currentTip;
end

function TipManager:ShowPetFashionChooseTip( datas, stick, side, offset, closecall, closeCallParam)
	self:CloseTip();

	TipsView.Me():ShowStickTip(PetFashionChooseTip, datas, side, stick, offset, "PetFashionChooseTip");
	local tip = TipsView.Me().currentTip;
	tip:SetCloseCall(closecall, closeCallParam);
	
	return tip;
end

function TipManager:ShowPetSkillTip(data, stick, side, offset)
	TipsView.Me():ShowStickTip(PetSkillTip, {data=data}, side, stick, offset, "SkillTip");
	return TipsView.Me().currentTip;
end

function TipManager:ShowTaskQuestTip(stick,side,offset)
	TipsView.Me():ShowStickTip(TaskQuestTip,nil,side,stick,offset)
end

function TipManager:ShowGvgQuestTip(stick,side,offset)
	TipsView.Me():ShowStickTip(GvgQuestTip,nil,side,stick,offset)
end

function TipManager:ShowGvgFinalFightTip(stick,side,offset)
	TipsView.Me():ShowStickTip(GvgFinalFightTip,nil,side,stick,offset)
end

function TipManager:ShowPreQuestTip(preDatas,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(PreQuestTip,preDatas,side,stick,offset,"PreQuestTip")
	local titleTip = TipsView.Me().currentTip;
	return titleTip
end

function TipManager:ShowPropTypeTip(preDatas,stick,side,offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(PropTypeTip,preDatas,side,stick,offset,"PropTypeTip")
	local titleTip = TipsView.Me().currentTip;
	return titleTip
end

function TipManager:ShowPetAdventureHeadTip(data, stick, side, offset)
	side = side or NGUIUtil.AnchorSide.TopRight;
	offset = offset or {0,0};
	TipsView.Me():ShowStickTip(PetAdventureHeadTip,data,side,stick,offset,"PetAdventureHeadTip")
	local tip = TipsView.Me().currentTip;
	return tip
end

function TipManager:ShowHRefineAddEffectTip(stick, side, offset)
	TipsView.Me():ShowStickTip(HRefineAddEffectTip,nil,side,stick,offset,"HRefineAddEffectTip")
end

function TipManager:ShowTabNameTip( data, stick, side, offset )
	self:CloseTabNameTip();
	TipsView.Me():ShowStickTip(TabNameTip, data, side, stick, offset, "TabNameTip");
	
	return TipsView.Me().currentTip;
end

function TipManager:TryShowHorizontalTabNameTip(tabName, stick, side, offset)
	local fadeInDirection, fadeOutDirection
	if side == NGUIUtil.AnchorSide.Left then
		fadeInDirection = TNTFadeDirEnum.LEFT
		fadeOutDirection = TNTFadeDirEnum.RIGHT
	elseif side == NGUIUtil.AnchorSide.Right then
		fadeInDirection = TNTFadeDirEnum.RIGHT
		fadeOutDirection = TNTFadeDirEnum.LEFT
	else
		return nil
	end
	offset = offset or {-30, 8}
	
	if not GameConfig.SystemForbid.TabNameTipHorizontal then
		return self:ShowTabNameTip({tabName = tabName, fadeInDirection = fadeInDirection, fadeOutDirection = fadeOutDirection},
				stick, side, offset);
	end
	return nil
end

function TipManager:TryShowVerticalTabNameTip(tabName, stick, side, offset)
	local fadeInDirection, fadeOutDirection
	if side == NGUIUtil.AnchorSide.Down then
		fadeInDirection = TNTFadeDirEnum.DOWN
		fadeOutDirection = TNTFadeDirEnum.UP
	elseif side == NGUIUtil.AnchorSide.Up then
		fadeInDirection = TNTFadeDirEnum.UP
		fadeOutDirection = TNTFadeDirEnum.DOWN
	else
		return nil
	end
	offset = offset or {122, -58}

	self:CloseTabNameTip();
	if not GameConfig.SystemForbid.TabNameTipVertical then
		TipsView.Me():ShowStickTip(TabNameTip, {tabName = tabName, fadeInDirection = fadeInDirection, fadeOutDirection = fadeOutDirection},
				side, stick, offset, "TabNameTipVertical");
	end
	return TipsView.Me().currentTip;
end

function TipManager:CloseTabNameTip()
	if TipsView.Me().currentTipType == TabNameTip then
		TipsView.Me():HideCurrent()
	end
end

function TipManager:CloseTabNameTipWithFadeOut()
	if TipsView.Me().currentTipType == TabNameTip then
		TipsView.Me().currentTip:TryFadeOut()
	end
end