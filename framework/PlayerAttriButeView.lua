autoImport("BaseAttributeView") 
PlayerAttriButeView = class("PlayerAttriButeView" ,BaseAttributeView)

autoImport("PlayerAttriButeCell")

function PlayerAttriButeView:Init()
	self:initView()
end

function PlayerAttriButeView:initView(  )
	self.gameObject = self:FindGO("PlayerAttriViewHolder");

	self.baseSp = self:FindGO("Base")
	self.baseGrid = self:FindGO("Grid",self.baseSp):GetComponent(UIGrid)
	self.baseGridList = UIGridListCtrl.new(self.baseGrid, PlayerAttriButeCell, "BaseAttrCell")	
	
	local lbx = self:FindGO("AbilityPolygon",self.baseSp);
	self.abilitypoint = self:FindGO("point", lbx);
	self.abilityline = self:FindGO("line", lbx);
	self.abilityPolygon = self:FindGO("PowerPolygo", lbx):GetComponent(PolygonSprite);
	local tips = self:FindGO("tips",self.baseSp);
	self.initAttiLab = {};
	for i = 1,6 do
		self.initAttiLab[i] = self:FindGO("Label"..i, tips):GetComponent(UILabel);
	end

	self.playerName = self:FindComponent("Name", UILabel);
	self.playerGender = self:FindComponent("RoleSex", UISprite);
end

function PlayerAttriButeView:SetPlayer(palerData)
	if(not self.gameObject.activeInHierarchy)then
		self:Show();
		self.abilityPolygon:ReBuildPolygon();
		self:Hide();
	else
		self.abilityPolygon:ReBuildPolygon();
	end

	self:resetData( palerData )
end

function PlayerAttriButeView:resetData( playerData )
	if(not playerData)then
		return;
	end

	self:updateGeneralData( playerData )
	self:reBuildPolygon( playerData )

	self.playerName.text = playerData.name;

	local gender = playerData.userdata:Get(UDEnum.SEX);
	self.playerGender.spriteName = gender == 2 and "friend_icon_woman" or "friend_icon_man";
end

-- 基础属性
function PlayerAttriButeView:updateGeneralData( playerData )
	local datas = {}
	for i=1,#GameConfig.BaseAttrConfig do
		local data = {}
		local single = GameConfig.BaseAttrConfig[i]
		local prop = playerData.props[single];
		local data = {}
		data.type = BaseAttributeView.cellType.normal
		data.prop = prop
		data.playerData = playerData
		table.insert(datas,data)
	end
	self.baseGridList:ResetDatas(datas)
end