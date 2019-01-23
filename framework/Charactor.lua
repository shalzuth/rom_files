Charactor = class("Charactor",ContainerView)
autoImport("AddPointPage")
autoImport("ProfessionPage")
autoImport("InfomationPage")
autoImport("BaseAttributeView")
autoImport("AttributePointSolutionView")
autoImport("ProfessionInfoViewMP")
autoImport("PlayerDetailViewMP")

Charactor.ViewType = UIViewType.NormalLayer
Charactor.PlayerHeadCellResId = ResourcePathHelper.UICell("PlayerHeadCell")

Charactor.TabName = {
	Infomation = ZhString.Charactor_Infomation,
	AddPoint = ZhString.Charactor_AddPoint,
	Profession = ZhString.Charactor_Profession,
}
Charactor.LongPressEvent = "Charactor_LongPress"

function Charactor:Init()
	-- 创建面板角色
	self:initData()
	self:InitTitle()
	self:AddPages()
	self:InitToggle();
	self:initView()
	self:AddListenerEvts()
	self:initTitleData()
end

function Charactor:initData(  )
	self.currentKey = nil	
	self:UpdateHead()
end

function Charactor.effectLoadFinish(obj, self)
	self.effectObj = obj
end

function Charactor:HasMarryed(  )
	return WeddingProxy.Instance:IsSelfMarried()
	-- return true
end

function Charactor:GetCouplePortraitData(  )
	-- local roleData = {}
	-- roleData.hairID = 1
	-- roleData.haircolor = 1
	-- local gender = 1
	-- if gender == ProtoCommon_pb.EGENDER_FEMALE then
	-- 	roleData.gender = RoleConfig.Gender.Female
	-- elseif gender == ProtoCommon_pb.EGENDER_MALE then
	-- 	roleData.gender = RoleConfig.Gender.Male
	-- end
	-- roleData.bodyID = 1
	-- roleData.headID = 1
	-- roleData.faceID = 1
	-- roleData.mouthID = 1
	-- roleData.eyeID = 1
	-- roleData.type = HeadImageIconType.Avatar
	-- if data.portrait and data.portrait > 0 then
	-- 	local itemConf = Table_HeadImage[data.portrait]
	-- 	if itemConf then
	-- 		roleData.type = HeadImageIconType.Simple
	-- 		roleData.icon = itemConf.Picture
	-- 	end
	-- end
	-- return roleData
	-- test
	-- local portrait = WeddingProxy.Instance:GetCouplePortraitInfo
	local headData = HeadImageData.new()
	headData:TransByMyself()
	return headData.iconData
end

-- function Charactor:HandleCouplePortrait(  )
-- 	 local headData = self:GetCouplePortraitData()
-- 	 if(not headData)then
-- 	 	return
-- 	 end

-- 	 if(not self.headIconCell)then
-- 		self.headIconCell = HeadIconCell.new();
-- 		self.headIconCell:CreateSelf(self.couplePortraitCt);
-- 	end
-- 	self.headIconCell:SetMinDepth(15);
-- 	self.headIconCell:SetData(headData)	
-- end

function Charactor:initCouplePortrait(  )
	self.couplesCt = self:FindGO("couplesCt")
	local couplesBg = self:FindComponent("couplesBg",UISprite)
	if(self:HasMarryed())then
		self:Show(self.couplesCt)
		self:AddClickEvent(self.couplesCt,function ( ... )
			-- body
			local infoData = WeddingProxy.Instance:GetWeddingInfo()
			if(infoData)then
				local id = infoData:GetPartnerGuid()
				local coupleData = WeddingProxy.Instance:GetPortraitInfo(id)
				local playerData = PlayerTipData.new();
				playerData:SetByWeddingcharData(coupleData,true);
				local tip = FunctionPlayerTip.Me():GetPlayerTip(couplesBg, NGUIUtil.AnchorSide.Left, {-380,60})
				local data = {
					playerData = playerData,
					funckeys = {"Wedding_CallBack","Wedding_MissYou","ShowDetail","SendMessage","InviteMember"},
				}
				tip:SetData(data)
			end
		end)
	else
		self:Hide(self.couplesCt)
	end
end

function Charactor:initView(  )
	self:AddButtonEvent("strengthBtn",function (  )
		self.baseAttributeView:clickShowBtn()
		if(self.uiPlayerSceneInfo)then
			self.uiPlayerSceneInfo:HideTitle()
		end
	end)

	local path = ResourcePathHelper.UIEffect(EffectMap.UI.FlashLight);
	Asset_Effect.PlayOn(path, self:FindGO("strengthBtn").transform, self.effectLoadFinish, self)
	-- self.effectObj = self:PlayUITrailEffect(,)
	--self.baseAttributeViewRlt = self:FindChild("attrViewHolder"):GetComponent(RelateGameObjectActive)
	self.professionInfoViewRlt = self:FindChild("professionInfoView"):GetComponent(RelateGameObjectActive)
	self.playTw = self:FindChild("strengthBtn"):GetComponent(UIPlayTween)
	local infomationLabel = self:FindChild("NameLabel",self.infomationTog):GetComponent(UILabel)
	infomationLabel.text = ZhString.Charactor_Infomation
	local addPointLabel = self:FindChild("NameLabel",self.addPointTog):GetComponent(UILabel)
	addPointLabel.text = ZhString.Charactor_AddPoint
	local professionLabel = self:FindChild("NameLabel",self.professionTog):GetComponent(UILabel)
	professionLabel.text = ZhString.Charactor_Profession
	local coupleLabel = self:FindComponent("coupleLabel",UILabel)
	coupleLabel.text = ZhString.Wedding_CharactorCoupleLabel
	-- self.baseAttributeViewRlt.enable_Call = function (  )
	-- 	-- body
	-- 	self:toggleStrengthBtn()
	-- end 
	-- self.baseAttributeViewRlt.disable_Call =function (  )
	-- 	-- body
	-- 	self:toggleStrengthBtn()
	-- end

	self.professionInfoViewRlt.disable_Call =function (  )
		-- body
		self.professionPage:unSelectedProfessionIconCell()
	end
	self:RegisterRedTip()

	self:UpdateTitleInfo()
	self:initCouplePortrait()
end

function Charactor:AddListenerEvts()
	self:AddListenEvt(MyselfEvent.MyDataChange,self.UpdateTitleInfo)
	self:AddListenEvt(MyselfEvent.JobExpChange, self.UpdateJobSlider)
	self:AddListenEvt(MyselfEvent.BaseExpChange, self.UpdateExpSlider)
	self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateMyProfession)
	self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange);	
	self:AddListenEvt(ServiceEvent.UserEventDepositCardInfo, self.UpdateMonthCardDate);	
	self:AddListenEvt(ServiceEvent.UserEventChangeTitle,self.initTitleData);
	-- self:AddListenEvt(ServiceEvent.WeddingCCmdReqPartnerInfoCCmd,self.HandleCouplePortrait);
end

function Charactor:initTitleData()
	local titleData = Table_Appellation[Game.Myself.data:GetAchievementtitle()]
	if(titleData)then
		self:Show(self.UserTitle.gameObject)
		self.UserTitle.text = "["..titleData.Name.."]"
	else
		self:Hide(self.UserTitle.gameObject)
	end
	
	--todo xde
	self.UserTitle:SetAnchor(nil)
	OverseaHostHelper:FixLabelOverV1(self.UserTitle,0,200)
end

function Charactor:toggleStrengthBtn()
	self.playTw:Play(true)
end

function Charactor:AddPages()
	local addPointPage = self:AddSubView("AddPointPage",AddPointPage)
	self.professionPage = self:AddSubView("ProfessionPage",ProfessionPage)
	self:AddSubView("InfomationPage",InfomationPage)
	self.attrSolutionView = self:AddSubView("AttributePointSolutionView",AttributePointSolutionView)
	self.attrSolutionView:AddEventListener(AttributePointSolutionView.SelectCell,addPointPage.selectAddPointSolution,addPointPage)
	self.baseAttributeView = self:AddSubView("BaseAttributeView",BaseAttributeView)	

	self.professionInfoViewMP = self:AddSubView("ProfessionInfoViewMP",ProfessionInfoViewMP)
	if self.professionInfoViewMP == nil then
		helplog("if self.professionInfoViewMP == nil then")
		do return end
	end	
	--self.professionPage:AddEventListener(ProfessionPage.ProfessionIconClick,self.professionInfoView.showInfo,self.professionInfoView)
	--这里专门处理多职业
	self.professionPage:AddEventListener(ProfessionPage.ProfessionIconClick,self.professionInfoViewMP.multiProfessionInfo,self.professionInfoViewMP)
	addPointPage:AddEventListener(AddPointPage.addPointAction,self.addPointAction,self)

	
	self.playerDetailViewMP = self:AddSubView("PlayerDetailViewMP",PlayerDetailViewMP,"PlayerDetailViewMP_1")
	self.professionInfoViewMP:AddEventListener(ProfessionInfoViewMP.LeftBtnClick,self.playerDetailViewMP.OnClickBtnFromProfessionInfoViewMP,self.playerDetailViewMP)

end



function Charactor:InitTitle()
	self.topTitle = self:FindGO("topTitle")
	self.profeName = self:FindChild("professionNamePointPage"):GetComponent(UILabel);
	self.UserTitle = self:FindChild("UserTitle"):GetComponent(UILabel);
	self.baseLevel = self:FindChild("baseLv"):GetComponent(UILabel);
	self.baseExp = self:FindChild("baseSlider"):GetComponent(UISlider);
	self.jobLevel = self:FindChild("jobLv"):GetComponent(UILabel);
	self.jobExp = self:FindChild("jobLevelSlider"):GetComponent(UISlider);
	self.battlePoint = self:FindChild("fightPowerLabel"):GetComponent(UILabel)	
	self.PlayerName = self:FindGO("PlayerName"):GetComponent(UILabel)
	self.PlayerId = self:FindGO("PlayerId"):GetComponent(UILabel)
	self.monthCardTime = self:FindGO("monthCardTime"):GetComponent(UILabel)
	local fightPowerName = self:FindGO("fightPowerName"):GetComponent(UILabel)
	fightPowerName.text = ZhString.Charactor_PingFen
end

function Charactor:InitToggle()
	local togObj = self:FindChild("toggles");
	self.addPointTog = self:FindChild("AddPoint",togObj);
	self:AddOrRemoveGuideId(self.addPointTog,5)
	self.professionTog = self:FindChild("Profession", togObj);
	self.infomationTog = self:FindGO("Infomation",togObj)
	self:AddTabChangeEvent(self.addPointTog,self:FindChild("AddPointPage"),PanelConfig.AddPointPage)
	self:AddTabChangeEvent(self.professionTog,self:FindChild("ProfessionPage"),PanelConfig.ProfessionPage)
	self:AddTabChangeEvent(self.infomationTog,self:FindChild("InfomationPage"),PanelConfig.InfomationPage)
	
	-- LongPress for TabNameTip
	local infoLongPress = self.infomationTog:GetComponent(UILongPress)
	local addLongPress = self.addPointTog:GetComponent(UILongPress)
	local profLongPress = self.professionTog:GetComponent(UILongPress)
	local longPressEvent = function (obj, state)
		self:PassEvent(Charactor.LongPressEvent, {state, obj.gameObject});
	end
	infoLongPress.pressEvent = longPressEvent
	addLongPress.pressEvent = longPressEvent
	profLongPress.pressEvent = longPressEvent
	self:AddEventListener(Charactor.LongPressEvent, self.HandleLongPress, self)
	
	-- Switch icon or text for TabNameTip
	local iconActive, nameLabelActive
	if not GameConfig.SystemForbid.TabNameTip then -- 显示图标和气泡
		iconActive=true;nameLabelActive=false;
	else -- 不显示图标和气泡
		iconActive=false;nameLabelActive=true;
	end	
	local toggleList = {self.addPointTog,self.professionTog,self.infomationTog}
	for i,v in ipairs(toggleList) do
		local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
		icon:SetActive(iconActive)
		local nameLabel = GameObjectUtil.Instance:DeepFindChild(v, "NameLabel")
		nameLabel:SetActive(nameLabelActive)
	end

	if(self.viewdata.showpage) then
		self:ShowPage(self.viewdata.showpage);
	elseif(self.viewdata.view and self.viewdata.view.tab)then
		self:TabChangeHandler(self.viewdata.view.tab)
	else
		self:TabChangeHandler(PanelConfig.InfomationPage.tab)
	end
end

function Charactor:RegisterRedTip()
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ADD_POINT,self:FindChild("Background",self.addPointTog),nil,{-11, -10})
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEW_PROFESSION,self:FindChild("Background",self.professionTog),nil,{-11, -10})
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PROFESSION_UP,self:FindChild("Background",self.professionTog),nil,{-11, -10})
end

function Charactor:OnEnter()
	self.super.OnEnter(self);
	self:CameraRotateToMe(true);
end

function Charactor:OnExit()
	self:CameraReset();	
	if(self.currentKey == PanelConfig.AddPointPage.tab)then
		RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_ADD_POINT);		
	elseif(self.currentKey == PanelConfig.ProfessionPage.tab)then
		RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_PROFESSION);
		RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_PROFESSION_UP);	
	end
	self.super.OnExit(self);
	if(self:ObjIsNil(self.effectObj))then
		GameObject.Destroy(self.effectObj)	
		self.effectObj = nil
	end
	FunctionPlayerTip.Me():CloseTip()
	-- if(self.headCellObj)then
	-- 	Game.GOLuaPoolManager:AddToUIPool(Charactor.PlayerHeadCellResId, self.headCellObj);
	-- end
end
function Charactor:ShowPage(key)
	if(key == "addPointPage")then
		self.addPointTog:GetComponent(UIToggle).startsActive = true;
	elseif(key == "professionPage")then
		self.professionTog:GetComponent(UIToggle).startsActive = true;
	else
		self.addPointTog:GetComponent(UIToggle).startsActive = true;
	end
end

function Charactor:addPointAction( addData )
	-- body
	self.baseAttributeView:showMySelf(addData)
end

function Charactor:TabChangeHandler(key)
	-- body
	if(self.currentKey ~= key)then
		local bRet = Charactor.super.TabChangeHandler(self,key)
		self.attrSolutionView:Hide()
		if(self.currentKey == PanelConfig.AddPointPage.tab)then			
			RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_ADD_POINT);	
		elseif(self.currentKey == PanelConfig.ProfessionPage.tab)then
			RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_PROFESSION);
			RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_PROFESSION_UP);	
		end	
		if(key ~= PanelConfig.AddPointPage.tab)then
			self.attrSolutionView:Hide()
			self.professionInfoViewMP:multiProfessionInfo(nil)
		end

		if(key == PanelConfig.ProfessionPage.tab)then
			self.professionPage:reShowGuidTextData()
			if(bRet)then
				self.topTitle:SetActive(false)
			end
		else
			self.professionInfoViewMP:multiProfessionInfo(nil)
			self.topTitle:SetActive(true)
		end
		
		-- Change icon color when TabNameTip
		if bRet and not GameConfig.SystemForbid.TabNameTip then
			if self.currentKey then
				local iconSp = GameObjectUtil.Instance:DeepFindChild(self.coreTabMap[self.currentKey].go, "Icon"):GetComponent(UISprite);
				iconSp.color = ColorUtil.TabColor_White
			end
			local iconSp = GameObjectUtil.Instance:DeepFindChild(self.coreTabMap[key].go, "Icon"):GetComponent(UISprite);
			iconSp.color = ColorUtil.TabColor_DeepBlue
		end

		if bRet then
			self.currentKey = key
		end
	end
end

function Charactor:AddCloseButtonEvent()
	Charactor.super.AddCloseButtonEvent(self)
	self:AddOrRemoveGuideId("CloseButton",8);
end

function Charactor:UpdateTitleInfo()
	self:UpdateExpSlider()
	self:UpdateJobSlider()
	self:UpdateHead()
	self:UpdateMyProfession()
	self:UpdateMonthCardDate()
	local data = ServiceConnProxy.Instance:getData()
	self.PlayerId.text = data and data.accid or 0
	self.PlayerName.text = Game.Myself.data:GetName()
	----[[ todo xde 防止翻译
	self.PlayerName.text = AppendSpace2Str(Game.Myself.data:GetName())
	--]]
	-- if(self.myself:IsTransformed())then
	-- 	self:Hide(self.addPointTog)
	-- 	self:Hide(self.professionTog )		
	-- else
	-- 	self:Show(self.addPointTog)
	-- 	self:Show(self.professionTog )
	-- end
	self.UserTitle.transform.localPosition = Vector3(-100 + self.PlayerName.width,60,0)
	
end

function Charactor:UpdateExpSlider()
	local userData = Game.Myself.data.userdata
	local roleExp = userData:Get(UDEnum.ROLEEXP);
	local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL);
	self.baseLevel.text = string.format("Lv%s",tostring(nowRoleLevel));  
	local referenceValue = Table_BaseLevel[nowRoleLevel+1];
	if(referenceValue == nil)then
		referenceValue = 1;
	else
		referenceValue = referenceValue.NeedExp;
	end
	self.baseExp.value = roleExp/referenceValue;
	self.battlePoint.text = tostring(userData:Get(UDEnum.BATTLEPOINT))
end

function Charactor:UpdateMonthCardDate()

	local leftDay = UIModelMonthlyVIP.Instance():GetMonthCardLeftDays()
	if(leftDay)then
		self:Show(self.monthCardTime.gameObject)
		self.monthCardTime.text = string.format(ZhString.Charactor_MonthCardTime,leftDay)
	else
		self:Hide(self.monthCardTime.gameObject)
	end
end

function Charactor:UpdateJobSlider()
	local nowJob = Game.Myself.data:GetCurOcc();  --self.myself.userData:Get(UDEnum.JOBLEVEL);
	if(nowJob == nil)then
		return;
	end

	local professionid = MyselfProxy.Instance:GetMyProfession()

	local nowJobLevel = nowJob:GetLevelText()
	local userData = Game.Myself.data.userdata
	local cur_max = userData:Get(UDEnum.CUR_MAXJOB) or 0

	local previousId = ProfessionProxy.Instance:GetThisIdPreviousId(professionid)
	if previousId then
		local previousData = Table_Class[previousId]
		if previousData.MaxPeak~=nil then
			cur_max =  cur_max - previousData.MaxPeak
		elseif 	previousData.MaxJobLevel~=nil then
			cur_max =  cur_max - previousData.MaxJobLevel
		end
	end

	if cur_max<= 0 then
		cur_max = 1;
	end
	local curlv = ProfessionProxy.Instance:GetThisJobLevelForClient(professionid,MyselfProxy.Instance:JobLevel())
	self.jobLevel.text = string.format("Lv%s/%s",tostring(curlv),cur_max);
	local referenceValue = Table_JobLevel[nowJob.level+1];
	if(referenceValue == nil)then
		referenceValue = 1;
	else
		referenceValue = referenceValue.JobExp;
	end
	self.jobExp.value = nowJob.exp/referenceValue;
end

local tempVector3 = LuaVector3.zero

function Charactor:UpdateHead(  )
	-- body
	if(not self.targetCell)then
		local headCellObj = self:FindGO("PortraitCell")			
		self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId,headCellObj)
		tempVector3:Set(0,0,0)
		self.headCellObj.transform.localPosition = tempVector3
		self.targetCell = PlayerFaceCell.new(self.headCellObj);
		self:AddClickEvent(self.headCellObj,function (  )
			if #ChangeHeadProxy.Instance:GetPortraitList() < 1 then
				MsgManager.ShowMsgByID(80)
			else
				self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ChangeHeadView})
			end
		end)
		self.targetCell:HideHpMp()
		-- self.targetCell:HideLevel()
		-- self:AddClickEvent(headCellObj,function () self:clickHeadIcon() end)
	end
	local headData = HeadImageData.new();
	headData:TransByMyself();
	-- 临时处理
	headData.frame = nil;
	headData.job = nil;
	self.targetCell:SetData(headData);
end

function Charactor:clickHeadIcon(  )
	-- body
	self:sendNotification(UIEvent.ShowUI,{viewname = "PortraitPopUp"})
end

function Charactor:UpdateMyProfession()
	local nowOcc = Game.Myself.data:GetCurOcc();
	if(nowOcc~=nil)then
		local prodata = Table_Class[nowOcc.profession];
		self.profeName.text = prodata.NameZh
	end
end

function Charactor:HandleMapChange(note)
	if(note.type == LoadSceneEvent.FinishLoad and note.body)then
		self:CameraRotateToMe();
	end
end

function Charactor:HandleLongPress(param)
	local isPressing, go = param[1], param[2];
	
	-- Show TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then
		if isPressing then
			local backgroundSp = GameObjectUtil.Instance:DeepFindChild(go, "Background"):GetComponent(UISprite);
			TipManager.Instance:TryShowHorizontalTabNameTip(Charactor.TabName[go.name], backgroundSp, NGUIUtil.AnchorSide.Left)
		else
			TipManager.Instance:CloseTabNameTipWithFadeOut()
		end
	end
end