autoImport("RepositoryViewBagPage")
autoImport("RepositoryViewItemPage")
RepositoryView = class("RepositoryView",ContainerView)

RepositoryView.ViewType = UIViewType.NormalLayer

RepositoryView.Tab = {
	RepositoryTab = 1,
	CommonTab = 2,
}
RepositoryView.TabName = {
	RepositoryTab = ZhString.RepositoryView_RepositoryTabName,
	CommonTab = ZhString.RepositoryView_CommonTabName
}
RepositoryView.LongPressEvent = "RepositoryView_LongPress"

function RepositoryView:Init(viewObj)
	-- 创建面板角色
	self.ListenerEvtMap = {};
	self.repositoryViewBagPage=self:AddSubView("RepositoryViewBagPage",RepositoryViewBagPage)
	self.repositoryViewItemPage=self:AddSubView("RepositoryViewItemPage",RepositoryViewItemPage)
	self.chooseEquipIndex = nil;

	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function RepositoryView:OnEnter()
	self.super.OnEnter(self);
	self:handleCameraQuestStart()

	ServiceItemProxy.Instance:CallOnOffStoreItemCmd(true)
end

function RepositoryView:handleCameraQuestStart()
	local npcData = self.viewdata.viewdata.npcdata
	if(npcData)then
		printRed("RepositoryView handleCameraQuestStart");
		self:CameraFocusOnNpc(npcData.assetRole.completeTransform);
	end
end

function RepositoryView:OnExit()

	ServiceItemProxy.Instance:CallOnOffStoreItemCmd(false)

	ServiceItemProxy.Instance:CallBrowsePackage(BagProxy.BagType.Storage)
	ServiceItemProxy.Instance:CallBrowsePackage(BagProxy.BagType.PersonalStorage)

	self:CameraReset()
	TipsView.Me():HideCurrent()

	RepositoryView.super.OnExit(self)
end

function RepositoryView:FindObjs()
	self.repositoryTab = self:FindGO("RepositoryTab"):GetComponent(UIToggle)
	self.commonTab = self:FindGO("CommonTab"):GetComponent(UIToggle)
	self.repositoryNum = self:FindGO("RepositoryNum",self.repositoryTab.gameObject):GetComponent(UILabel)
	self.commonNum = self:FindGO("CommonNum",self.commonTab.gameObject):GetComponent(UILabel)
	self.repositoryTabIconSp = GameObjectUtil.Instance:DeepFindChild(self.repositoryTab.gameObject, "Icon"):GetComponent(UISprite)
	self.commonTabIconSp = GameObjectUtil.Instance:DeepFindChild(self.commonTab.gameObject, "Icon"):GetComponent(UISprite)
end

function RepositoryView:AddEvts()
	EventDelegate.Add(self.repositoryTab.onChange, function ()
		if self.repositoryTab.value then
			self.viewTab = RepositoryView.Tab.RepositoryTab
			RepositoryViewProxy.Instance:SetViewTab( self.viewTab )

			self.repositoryViewItemPage:InitShow()
			self.repositoryViewBagPage:InitShow()
			self.repositoryTabIconSp.color = ColorUtil.TabColor_DeepBlue
			self.commonTabIconSp.color = ColorUtil.TabColor_White
		end
	end)
	EventDelegate.Add(self.commonTab.onChange, function ()
		if self.commonTab.value then
			self.viewTab = RepositoryView.Tab.CommonTab
			RepositoryViewProxy.Instance:SetViewTab( self.viewTab )

			self.repositoryViewItemPage:InitShow()
			self.repositoryViewBagPage:InitShow()
			self.repositoryTabIconSp.color = ColorUtil.TabColor_White
			self.commonTabIconSp.color = ColorUtil.TabColor_DeepBlue
		end		
	end)

	-- LongPress for TabNameTip
	local repositoryLongPress = self.repositoryTab:GetComponent(UILongPress)
	local commonLongPress = self.commonTab:GetComponent(UILongPress)
	local longPressEvent = function (obj, state)
		self:PassEvent(RepositoryView.LongPressEvent, {state, obj.gameObject});
	end
	repositoryLongPress.pressEvent = longPressEvent
	commonLongPress.pressEvent = longPressEvent
	self:AddEventListener(RepositoryView.LongPressEvent, self.HandleLongPress, self)
end

function RepositoryView:AddViewEvts()
	self:AddListenEvt(ItemEvent.ItemUpdate,self.HandleItemUpdate)
	self:AddListenEvt(ItemEvent.ItemReArrage,self.HandleItemReArrage)
	self:AddListenEvt(MyselfEvent.LevelUp, self.HandleLevelUp)
end

function RepositoryView:InitShow()
	self:UpdateNum()

	-- Switch icon or text for TabNameTip
	local iconActive, nameLabelActive
	if not GameConfig.SystemForbid.TabNameTip then -- 显示图标和气泡
		iconActive=true;nameLabelActive=false;
	else -- 不显示图标和气泡
		iconActive=false;nameLabelActive=true;
	end
	local tabList = {self.repositoryTab.gameObject, self.commonTab.gameObject}
	for i,v in ipairs(tabList) do
		local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
		icon:SetActive(iconActive)
		local label = GameObjectUtil.Instance:DeepFindChild(v, "Label")
		label:SetActive(nameLabelActive)
	end
end

function RepositoryView:HandleItemUpdate(note)
	self.repositoryViewBagPage:HandleItemUpdate(note)
	self.repositoryViewItemPage:HandleItemUpdate(note)

	self:UpdateNum()
end

function RepositoryView:HandleItemReArrage(note)
	self.repositoryViewBagPage:HandleItemReArrage(note)
	self.repositoryViewItemPage:HandleItemReArrage(note)
end

function RepositoryView:HandleLevelUp(note)
	self.repositoryViewBagPage:HandleLevelUp(note)
	self.repositoryViewItemPage:HandleLevelUp(note)
end

function RepositoryView:UpdateNum()
	local total = #BagProxy.Instance:GetPersonalRepositoryBagData():GetItems(ItemNormalList.TabConfig[1])
	local max = BagProxy.Instance:GetBagUpLimit(BagProxy.BagType.PersonalStorage)
	if total >= max then
		self.repositoryNum.gameObject:SetActive(true)
		self.repositoryNum.text = total.."/"..max
	else
		self.repositoryNum.gameObject:SetActive(false)
	end

	total = #BagProxy.Instance:GetRepositoryBagData():GetItems(ItemNormalList.TabConfig[1])
	max = BagProxy.Instance:GetBagUpLimit(BagProxy.BagType.Storage)
	if total >= max then
		self.commonNum.gameObject:SetActive(true)
		self.commonNum.text = total.."/"..max
	else
		self.commonNum.gameObject:SetActive(false)
	end
end

function RepositoryView:HandleLongPress(param)
	local isPressing, go = param[1], param[2];
	
	-- Show TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then
		if isPressing then
			local backgroundSp = go:GetComponent(UISprite);
			TipManager.Instance:TryShowHorizontalTabNameTip(RepositoryView.TabName[go.name], 
					backgroundSp, NGUIUtil.AnchorSide.Right, {210, 8})
		else
			TipManager.Instance:CloseTabNameTipWithFadeOut()
		end
	end
end
