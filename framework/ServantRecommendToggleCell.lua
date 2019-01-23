local BaseCell = autoImport("BaseCell");
local choosenLabCol = "[365A96]"
local unChoosenLabCol = "[676767]"

ServantRecommendToggleCell = class("ServantRecommendToggleCell", BaseCell);

ServantRecommendToggleCell.LongPress = "ServantRecommend_LongPressEvent"

function ServantRecommendToggleCell:Init()
	ServantRecommendToggleCell.super.Init(self)
	self:FindObjs()
	-- self:InitCfg()
	self:AddCellClickEvent()

	local longPress = self.gameObject:GetComponent(UILongPress)
	longPress.pressEvent = function ( obj,state )
		self:PassEvent(ServantRecommendToggleCell.LongPress, {state, self});
	end

	-- Switch icon or text for TabNameTip
	local iconActive, nameLabelActive
	if not GameConfig.SystemForbid.TabNameTip then -- 显示图标和气泡
		iconActive=true;nameLabelActive=false;
	else -- 不显示图标和气泡
		iconActive=false;nameLabelActive=true;
	end
	self.iconSp.gameObject:SetActive(iconActive)
	self.typeName.gameObject:SetActive(nameLabelActive)
end

-- 女仆今日推荐标签页分类
local pageCfg = GameConfig.Servant and GameConfig.Servant.ServantRecommendPageType

function ServantRecommendToggleCell:FindObjs()
	self.chooseImg = self:FindComponent("ChooseImg",UISprite);
	self.typeName = self:FindComponent("TypeName",UILabel);
	self.iconSp = self:FindComponent("Icon",UISprite);
end

function ServantRecommendToggleCell:ShowChooseImg(typeID)
	local name = self.typeName.text
	if(typeID==self.typeID)then
		self:Show(self.chooseImg)
		self.typeName.text=string.format("[c]%s%s[-][/c]",choosenLabCol,name)
		self.iconSp.color = ColorUtil.TitleBlue
	else
		self:Hide(self.chooseImg)
		self.typeName.text=string.format("[c]%s%s[-][/c]",unChoosenLabCol,name)
		self.iconSp.color = ColorUtil.TitleGray
	end
end

function ServantRecommendToggleCell:SetData(data)
	self.typeID = data
	if(not pageCfg)then
		helplog("GameConfig.Servant.ServantRecommendPageType 未配置")
		return 
	end
	self.typeName.text = pageCfg[data] or ""
	if string.lower(self.typeName.text) == "all" then
		self.iconSp.spriteName = "bag_icon_all"
	else
		IconManager:SetUIIcon(ServantRecommendView.ToggleCellIcon[data] or "", self.iconSp)
	end
end
