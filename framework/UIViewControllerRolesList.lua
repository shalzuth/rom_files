autoImport('UIModelRolesList')
autoImport('UIListItemViewControllerRoleSlot')
autoImport('UIBlackScreen')
autoImport('LoginRoleSelector')
autoImport('RoleReadyForLogin')

UIViewControllerRolesList = class('UIViewControllerRolesList', BaseView)

UIViewControllerRolesList.ViewType = UIViewType.MainLayer

local tempTable = {}

local slotCount = 5
local tailLockCount = 2

function UIViewControllerRolesList:Init()
	self:InitMergeRoleNotice();

	self:GetGameObjects()
	self:RegisterButtonClickEvent()
	self:RegisterAreaDragEvent()
	self:CloseDeleteConfirm()
	self:CloseCancelDeleteConfirm()
	self:GetModel()
	self:LoadView()
	self:Listen()

	--todo xde 中文
	self.leftOpt = 0;
	self.rightOpt = 0;
	self.leftMax = 3;
	self.rightMax = 4;
	self.rightUp = self:FindGO('rightUp', self.gameObject)
	self.leftDown = self:FindGO('leftDown', self.gameObject)
	self:AddClickEvent(self.rightUp, function ()
		helplog("self:rightUp")
		self:checkShow(1)
	end)

	self:AddClickEvent(self.leftDown, function ()
		helplog("self:leftDown")
		self:checkShow(2)
	end)
end

-- todo xde
function UIViewControllerRolesList:checkShow(option)
	if(option == 1) then
		self.rightOpt = self.rightOpt + 1;
	elseif(option == 2) then
		self.leftOpt = self.leftOpt  + 1;
	end

	if(self.rightOpt == self.rightMax and self.leftOpt == self.leftMax ) then
		if(PlayerPrefs.GetString("TestForce") ~='1') then
			UIUtil.PopUpConfirmYesNoView('提示','是否强制设为中文',function()
				PlayerPrefs.SetString("TestForce","1")
				Game.Me():BackToLogo()
			end,function ()
			end,nil,'是的','不要')
		else
			UIUtil.PopUpConfirmYesNoView('提示','已经强制中文，是否解锁',function()
				PlayerPrefs.DeleteKey("TestForce")
				Game.Me():BackToLogo()
			end,function ()
			end,nil,'是的','不要')
		end
	end
end

function UIViewControllerRolesList:InitMergeRoleNotice()
	self.noticeBord = self:FindGO("MergeRoleNotice");
	self.contentLabel = self:FindComponent("ContentLabel", UILabel, self.noticeBord);

	local helpdata = Table_Help[self.viewdata.view.id];
	if(helpdata)then
		self.contentLabel.text = helpdata.Desc;
	end
end

function UIViewControllerRolesList:UpdateMergeRoleNotice()
	self.noticeBord:SetActive(self.choosedMainRole == false);
end

function UIViewControllerRolesList:OnEnter()
	UIViewControllerRolesList.super.OnEnter(self)

	local rolesInfo = MyselfProxy.Instance:GetUserRolesInfo();
	if(rolesInfo == nil)then
		return;
	end


	if rolesInfo.deletechar then
		MsgManager.ShowMsgByID(1066)
	end


	local effective_rolecount = 0;
	for k,v in pairs(rolesInfo.data)do
		if(v.id > 0)then
			effective_rolecount = effective_rolecount + 1;
			if(effective_rolecount > 1)then
				break;
			end
		end
	end

	self.effective_rolecount = effective_rolecount;

	if(effective_rolecount <= 1)then
		self.choosedMainRole = true;
	else
		self.choosedMainRole = rolesInfo.maincharid ~= nil and rolesInfo.maincharid > 0;
	end

	if(GameConfig.SystemForbid.MultiProfession)then
		self.choosedMainRole = true;
	end

	self:UpdateMergeRoleNotice();
end

function UIViewControllerRolesList:OnExit()
	UIViewControllerRolesList.super.OnExit(self)

	self.isDestroyed = true
end

function UIViewControllerRolesList:GetGameObjects()
	self.goButtonStartGame = self:FindGO('ButtonStartGame', self.gameObject)
	self.goTitleOfButtonStartGame = self:FindGO('Title', self.goButtonStartGame)
	self.labTitleOfButtoNStartGame = self.goTitleOfButtonStartGame:GetComponent(UILabel)
	self.goNormalOfButtonStartGame = self:FindGO('Normal', self.goButtonStartGame)
	self.spNormalOfButtonStartGame = self.goNormalOfButtonStartGame:GetComponent(UISprite)
	self.goButtonBack = self:FindGO('ButtonBack', self.gameObject)
	self.goRolesList = self:FindGO('RolesList', self.gameObject)
	self.goMask = self:FindGO('Mask', self.gameObject)
	self.spMask = self.goMask:GetComponent(UISprite)
	self.goRoleDetail = self:FindGO('RoleDetail', self.gameObject)
	self.goIcon = self:FindGO('Icon', self.goRoleDetail)
	self.goProfessionIcon = self:FindGO('ProfessionIcon', self.goIcon)
	self.spProfessionIcon = self.goProfessionIcon:GetComponent(UISprite)
	self.goBG2OfProfessionIcon = self:FindGO('BG2', self.goIcon)
	self.spBG2OfProfessionIcon = self.goBG2OfProfessionIcon:GetComponent(UISprite)
	self.goName = self:FindGO('Name', self.goRoleDetail)
	self.labName = self.goName:GetComponent(UILabel)
	self.goButtonDelete = self:FindGO('ButtonDelete', self.gameObject)
	self.goBCForDrag = self:FindGO('BCForDrag', self.gameObject);
	self.goDeleteConfirm = self:FindGO('DeleteConfirm', self.gameObject)
	self.goInputField = self:FindGO('InputField', self.goDeleteConfirm)
	self.inputField = self.goInputField:GetComponent(UIInput)
	self.goCancelDeleteConfirm = self:FindGO('CancelDeleteConfirm', self.gameObject)
	self.goRoleDetailOfDeleteConfirm = self:FindGO('RoleDetail', self.goDeleteConfirm)
	self.labRoleDetailOfDeleteConfirm = self.goRoleDetailOfDeleteConfirm:GetComponent(UILabel)
	self.goRoleDetailOfCancelDeleteConfirm = self:FindGO('RoleDetail', self.goCancelDeleteConfirm)
	self.labRoleDetailOfCancelDeleteConfirm = self.goRoleDetailOfCancelDeleteConfirm:GetComponent(UILabel)
	self.goButtonYesOfDeleteConfirm = self:FindGO('ButtonYes', self.goDeleteConfirm)
	self.goButtonNoOfDeleteConfirm = self:FindGO('ButtonNo', self.goDeleteConfirm)
	self.goButtonYesOfCancelDeleteConfirm = self:FindGO('ButtonYes', self.goCancelDeleteConfirm)
	self.goButtonNoOfCancelDeleteConfirm = self:FindGO('ButtonNo', self.goCancelDeleteConfirm)

	--todo xde google back
	self:RegisterChildPopObj(self.goDeleteConfirm)

end

function UIViewControllerRolesList:GetModel()
	if self.roles ~= nil then
		TableUtility.ArrayClear(self.roles)
	end

	if self.roles == nil then
		self.roles = {}
	end

	local rolesInfo = ServiceUserProxy.Instance:GetAllRoleInfos()
	for _, v in pairs(rolesInfo) do
		local roleInfo = v
		local copyRoleInfo = {}
		copyRoleInfo.id = roleInfo.id
		copyRoleInfo.baselv = roleInfo.baselv
		copyRoleInfo.hair = roleInfo.hair
		copyRoleInfo.haircolor = roleInfo.haircolor
		copyRoleInfo.lefthand = roleInfo.lefthand
		copyRoleInfo.righthand = roleInfo.righthand
		copyRoleInfo.body = roleInfo.body
		copyRoleInfo.clothcolor = roleInfo.clothcolor;
		copyRoleInfo.head = roleInfo.head
		copyRoleInfo.back = roleInfo.back
		copyRoleInfo.face = roleInfo.face
		copyRoleInfo.tail = roleInfo.tail
		copyRoleInfo.mount = roleInfo.mount
		copyRoleInfo.eye = roleInfo.eye
		copyRoleInfo.partnerid = roleInfo.partnerid
		copyRoleInfo.gender = roleInfo.gender
		copyRoleInfo.profession = roleInfo.profession
		copyRoleInfo.name = roleInfo.name
		copyRoleInfo.sequence = roleInfo.sequence
		copyRoleInfo.isopen = roleInfo.isopen
		copyRoleInfo.deletetime = roleInfo.deletetime
		table.insert(self.roles, copyRoleInfo)
	end
end

function UIViewControllerRolesList:GetRoleInfoFromID(roleID)
	local roleInfo = nil
	for _, v in pairs(self.roles) do
		roleInfo = v
		if roleInfo.id == roleID then
			break
		end
	end
	----[[ todo xde 不翻译玩家名
	roleInfo.name = AppendSpace2Str(roleInfo.name)
	--]]
	return roleInfo
end

function UIViewControllerRolesList:LoadView()
	if self.uiGridListCtrl == nil then
		local uiGrid = self.goRolesList:GetComponent(UIGrid)
		self.uiGridListCtrl = UIGridListCtrl.new(uiGrid, UIListItemViewControllerRoleSlot, 'UIListItemViewRoleSlot')
	end

	for k, v in pairs(self.roles) do
		if v then
			local roleInfo = v
			local index = roleInfo.sequence
			local isLock = false
			if roleInfo.id > 0 then
				isLock = false
			else
				isLock = roleInfo.isopen == 0
			end
			tempTable[index] = {['roleID'] = roleInfo.id, ['lock'] = isLock, ['index'] = index, ['deletetime'] = roleInfo.deletetime}
		end
	end
	self.uiGridListCtrl:ResetDatas(tempTable)
	TableUtility.TableClear(tempTable)
	if self.listItemsViewController == nil then
		self.listItemsViewController = self.uiGridListCtrl:GetCells()
	end

	self:CancelAllSelectedIcon()

	if self:IsHaveAnyRole() then
		local isSelectHistory = false
		local selectedRole = UIModelRolesList.Ins():GetSelectedRole()
		if selectedRole > 0 then
			if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
				for _, v in pairs(self.listItemsViewController) do
					local itemViewController = v
					if itemViewController.roleID == selectedRole then
						if itemViewController:IsNormal() then
							self:SelectNormal(selectedRole)
							isSelectHistory = true
						end
						break
					end
				end
			end
		end
		if not isSelectHistory then
			self:SelectDefaultNormal()
		end
	else
		self:SelectFirst()
	end

	if self.goDeleteConfirm.activeSelf == true then
		if self.selectedRoleID ~= nil and self.selectedRoleID > 0 then
			self:OpenDeleteConfirm(self.selectedRoleID)
		end
	end
	if self.goCancelDeleteConfirm.activeSelf == true then
		if self.willCancelDeleteRoleID ~= nil and self.willCancelDeleteRoleID > 0 then
			self:OpenCancelDeleteConfirm(self.willCancelDeleteRoleID)
		end
	end
end

function UIViewControllerRolesList:OpenDeleteConfirm(roleID)
	local roleInfo = self:GetRoleInfoFromID(roleID)
	if roleInfo then
		self.goDeleteConfirm:SetActive(true)
		local profession = roleInfo.profession
		local professionConf = Table_Class[profession]
		local professionName = professionConf ~= nil and professionConf.NameZh or ''
		self.labRoleDetailOfDeleteConfirm.text = roleInfo.name .. '  ' .. ZhString.MonsterTip_Characteristic_Level .. roleInfo.baselv .. '   ' .. professionName
	end
end

function UIViewControllerRolesList:CloseDeleteConfirm()
	self.inputField.value = ''
	self.goDeleteConfirm:SetActive(false)
end

function UIViewControllerRolesList:OpenCancelDeleteConfirm(roleID)
	local roleInfo = self:GetRoleInfoFromID(roleID)
	if roleInfo then
		self.goCancelDeleteConfirm:SetActive(true)
		local profession = roleInfo.profession
		local professionConf = Table_Class[profession]
		local professionName = professionConf ~= nil and professionConf.NameZh or ''
		self.labRoleDetailOfCancelDeleteConfirm.text = roleInfo.name .. '  ' .. ZhString.MonsterTip_Characteristic_Level .. roleInfo.baselv .. '   ' .. professionName
	end
end

function UIViewControllerRolesList:CloseCancelDeleteConfirm()
	self.goCancelDeleteConfirm:SetActive(false)
end

function UIViewControllerRolesList:Close()
	self:CancelListen()

	if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
		for _, v in pairs(self.listItemsViewController) do
			local itemViewController = v
			itemViewController:CloseMyTick()
		end
	end

	UIViewControllerRolesList.super.CloseSelf(self)
end

function UIViewControllerRolesList:SelectDefaultNormal()
	if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
		for _, v in pairs(self.listItemsViewController) do
			local itemViewController = v
			if itemViewController:IsNormal() then
				itemViewController:SetSelected()
				self:DoSelectNormal(itemViewController.roleID)
				break
			end
		end
	end
end

function UIViewControllerRolesList:SelectNormal(roleID)
	if roleID > 0 then
		if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
			for _, v in pairs(self.listItemsViewController) do
				local itemViewController = v
				if itemViewController.roleID == roleID then
					itemViewController:SetSelected()
					self:DoSelectNormal(roleID)
					break
				end
			end
		end
	end
end

function UIViewControllerRolesList:DoSelectNormal(roleID)
	self.labTitleOfButtoNStartGame.text = ZhString.LoginRole_LoginRole
	self.labTitleOfButtoNStartGame.effectColor = Color(0x9e/255.0, 0x56/255.0, 0, 1)
	self.spNormalOfButtonStartGame.spriteName = 'com_btn_2s'

	local roleInfo = self:GetRoleInfoFromID(roleID)
	if roleInfo ~= nil then
		self.labName.text = roleInfo.name
		local professionConf = Table_Class[tonumber(roleInfo.profession)]
		if professionConf ~= nil then
			IconManager:SetProfessionIcon(professionConf.icon, self.spProfessionIcon)
			local colorKey = 'CareerIconBg' .. professionConf.Type;
			self.spBG2OfProfessionIcon.color = ColorUtil[colorKey]
		end
	end

	self.goRoleDetail:SetActive(true)
	self.goButtonDelete:SetActive(true)

	self.selectedRoleID = roleID
	self.willCreateRoleSlotIndex = nil
	self.willCancelDeleteRoleID = nil

	RoleReadyForLogin.Ins():Iam(roleID)
end

function UIViewControllerRolesList:SelectEmpty(index)
	if index > 0 then
		if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
			for _, v in pairs(self.listItemsViewController) do
				local itemViewController = v
				if itemViewController.index == index then
					itemViewController:SetSelected()
					break
				end
			end
		end

		self.willCreateRoleSlotIndex = index
		self.selectedRoleID = nil
		self.willCancelDeleteRoleID = nil

		self.goRoleDetail:SetActive(false)
		self.labTitleOfButtoNStartGame.text = ZhString.LoginRole_CreateRole
		self.labTitleOfButtoNStartGame.effectColor = Color(0x26/255.0, 0x3e/255.0, 0x8c/255.0, 1)
		self.spNormalOfButtonStartGame.spriteName = 'com_btn_1s'

		RoleReadyForLogin.Ins():Hide()

		UIModelRolesList.Ins():SetEmptyIndex(index)
	end
end

function UIViewControllerRolesList:SelectDelete(roleID)
	if roleID > 0 then
		if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
			for _, v in pairs(self.listItemsViewController) do
				local itemViewController = v
				if itemViewController.roleID == roleID then
					itemViewController:SetSelected()
					self:DoSetDelete(roleID)
					break
				end
			end
		end
	end
end

function UIViewControllerRolesList:DoSetDelete(roleID)
	self.labTitleOfButtoNStartGame.text = ZhString.LoginRole_CancelDelete
	self.labTitleOfButtoNStartGame.effectColor = Color(0x74/255.0, 0x04/255.0, 0x04/255.0, 1)
	self.spNormalOfButtonStartGame.spriteName = 'com_btn_0'

	local roleInfo = self:GetRoleInfoFromID(roleID)
	if roleInfo ~= nil then
		self.labName.text = roleInfo.name
		local professionConf = Table_Class[tonumber(roleInfo.profession)]
		if professionConf ~= nil then
			self.spProfessionIcon.spriteName = professionConf.icon
			local colorKey = 'CareerIconBg' .. professionConf.Type;
			self.spBG2OfProfessionIcon.color = ColorUtil[colorKey]
		end
	end

	self.goRoleDetail:SetActive(true)
	self.goButtonDelete:SetActive(false)

	self.willCancelDeleteRoleID = roleID
	self.willCreateRoleSlotIndex = nil
	self.selectedRoleID = nil

	RoleReadyForLogin.Ins():Iam(roleID)
end

function UIViewControllerRolesList:SelectFirst()
	if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
		local firstItemViewController = self.listItemsViewController[1]
		if firstItemViewController:IsNormal() then
			self:SelectNormal(firstItemViewController.roleID)
		elseif firstItemViewController:IsEmpty() then
			self:SelectEmpty(1)
		elseif firstItemViewController:IsDelete() then
			self:SelectDelete(firstItemViewController.roleID)
		end
	end
end

function UIViewControllerRolesList:RegisterButtonClickEvent()
	self:AddClickEvent(self.goButtonStartGame, function ()
		self:TryLogin();
	end, {hideClickSound = true})
	self:AddClickEvent(self.goButtonBack, function ()
		self:OnClickForButtonBack()
	end)
	self:AddClickEvent(self.goButtonDelete, function ()
		self:OnClickForButtonDelete()
	end)
	self:AddClickEvent(self.goButtonYesOfDeleteConfirm, function ()
		self:OnClickForButtonYesOfDeleteConfirm()
	end)
	self:AddClickEvent(self.goButtonNoOfDeleteConfirm, function ()
		self:OnClickForButtonNoOfDeleteConfirm()
	end)
	self:AddClickEvent(self.goButtonYesOfCancelDeleteConfirm, function ()
		self:OnClickForButtonYesOfCancelDeleteConfirm()
	end)
	self:AddClickEvent(self.goButtonNoOfCancelDeleteConfirm, function ()
		self:OnClickForButtonNoOfCancelDeleteConfirm()
	end)
end

function UIViewControllerRolesList:TryLogin()
	if(self.choosedMainRole == false)then
		if(self.effective_rolecount > 0)then
			if(self.willCreateRoleSlotIndex ~= nil)then
				MsgManager.ShowMsgByIDTable(25436);
				return;
			end
		end

		self:ChooseMainRoleConfirm( 1, self.OnClickForButtonLogin, self );
		return;
	end

	self:OnClickForButtonLogin();
end

local chooseMainRole_ConfirmMsgids = GameConfig.System.chooseMainRole_ConfirmMsgids;
function UIViewControllerRolesList:ChooseMainRoleConfirm(checkPoint, callBack, callBackParam)
	local roleInfo = self:GetRoleInfoFromID(self.selectedRoleID);
	if(self.selectedRoleID == nil or roleInfo == nil)then
		callBack(callBackParam);
		return;
	end
	if(chooseMainRole_ConfirmMsgids == nil)then
		callBack(callBackParam);
		return;
	end

	if(checkPoint > #chooseMainRole_ConfirmMsgids)then
		callBack(callBackParam);
		return;
	end

	local msgId = chooseMainRole_ConfirmMsgids[checkPoint];
	MsgManager.ConfirmMsgByID(msgId, function ()
		self:ChooseMainRoleConfirm(checkPoint + 1, callBack, callBackParam);
	end, nil, nil, self:GetMsgParam(msgId))
end
function UIViewControllerRolesList:GetMsgParam(msgid)
	if(msgid == 25415)then
		local roleInfo = self:GetRoleInfoFromID(self.selectedRoleID);
		if(roleInfo == nil)then
			return;
		end
		local baselv = roleInfo.baselv;
		local profession = roleInfo.profession;
		local className = Table_Class[profession].NameZh;
		return baselv, className;
	end
end


--todo xde add loading
function UIViewControllerRolesList:addLoadingAnim()
--	local loadingAni = self:FindGO('UILoadingAni', self.gameObject):SetActive(true)
end

function UIViewControllerRolesList:OnClickForButtonLogin()
	if self.selectedRoleID ~= nil and self.selectedRoleID > 0 then -- select exist role
		UIBlackScreen.DoFadeIn(self.spMask, 1, function ()
			self:addLoadingAnim();--todo xde add loading
			LoginRoleSelector.Ins():HideSceneAndRoles()
			LoginRoleSelector:Ins():Release()
			ServiceUserProxy.Instance:CallSelect(self.selectedRoleID)
		end)
	elseif self.willCreateRoleSlotIndex ~= nil and self.willCreateRoleSlotIndex > 0 then -- create role
		UIBlackScreen.DoFadeIn(self.spMask, 1, function ()
			self:Close()
			LoginRoleSelector.Ins():GoToCreateRole()
			LoginRoleSelector.Ins():HideSceneAndRoles()
			LoginRoleSelector.Ins():Reset()
		end)
	elseif self.willCancelDeleteRoleID ~= nil and self.willCancelDeleteRoleID > 0 then -- cancel delete role
		self:OpenCancelDeleteConfirm(self.willCancelDeleteRoleID)
	end
end

function UIViewControllerRolesList:OnClickForButtonBack()
	self:Close()
	self:sendNotification(UIEvent.ShowUI,{viewname = "StartGamePanel"})
	LoginRoleSelector.Ins():HideSceneAndRoles()
end

function UIViewControllerRolesList:OnClickForButtonDelete()
	local roleID = self:AnyRoleBeingDelete()
	if roleID > 0 then
		local roleDetail = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
		local nameOfRoleBeingDelete = roleDetail.name
		local deleteLeftHour
		local deleteLeftMinute
		local deleteLeftSecond
		if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
			for _, v in pairs(self.listItemsViewController) do
				local itemViewController = v
				if itemViewController.roleID == roleID then
					deleteLeftHour = itemViewController.leftHour
					deleteLeftMinute = itemViewController.leftMinutes
					deleteLeftSecond = itemViewController.leftSeconds
					break
				end
			end
		end
		-- local deleteNeedTime = UIModelRolesList.Ins():GetRoleDeleteNeedTime(roleID)
		-- local leftPercent = 0
		-- if deleteNeedTime > 0 then
		-- 	leftPercent = deleteLeftTime / deleteNeedTime
		-- end
		local strDeleteLeftTime = ''
		if deleteLeftHour >= 1 then
			strDeleteLeftTime = strDeleteLeftTime .. string.format(ZhString.HoursFormat, deleteLeftHour)
			strDeleteLeftTime = strDeleteLeftTime .. string.format(ZhString.MinutesFormat, deleteLeftMinute)
		else
			strDeleteLeftTime = strDeleteLeftTime .. string.format(ZhString.MinutesFormat, deleteLeftMinute)
			strDeleteLeftTime = strDeleteLeftTime .. string.format(ZhString.SecondsFormat, deleteLeftSecond)
		end
		MsgManager.ShowMsgByIDTable(1068, {nameOfRoleBeingDelete, strDeleteLeftTime})
	elseif not UIModelRolesList.Ins():IsRoleDeleteCDComplete() then
		local hours, minutes, seconds = UIModelRolesList.Ins():GetRoleDeleteCDTime()
		if hours ~= nil then
			local strCDTime = ''
			if hours >= 1 then
				strCDTime = strCDTime .. string.format(ZhString.HoursFormat, hours)
				strCDTime = strCDTime .. string.format(ZhString.MinutesFormat, minutes)
			else
				strCDTime = strCDTime .. string.format(ZhString.MinutesFormat, minutes)
				strCDTime = strCDTime .. string.format(ZhString.SecondsFormat, seconds)
			end
			MsgManager.ShowMsgByIDTable(1073, {strCDTime})
		end
	else
		FunctionSecurity.Me():DeleteFriend(function ()
			if self.selectedRoleID ~= nil and self.selectedRoleID > 0 then
				self:OpenDeleteConfirm(self.selectedRoleID)
			end
		end)
	end
end

function UIViewControllerRolesList:OnClickForButtonYesOfDeleteConfirm()
	if self.inputField.value == '' then
		MsgManager.ShowMsgByID(1070)
	elseif self.inputField.value == 'DELETE' then
		self:RequestDeleteRole(self.selectedRoleID)
		self.flagRequestDeleteRole = true
		self:CloseDeleteConfirm()
	else
		self.inputField.label.color = ColorUtil.Red
	end
end

function UIViewControllerRolesList:OnClickForButtonNoOfDeleteConfirm()
	self:CloseDeleteConfirm()
end

function UIViewControllerRolesList:OnClickForButtonYesOfCancelDeleteConfirm()
	self:RequestCancelDeleteRole(self.willCancelDeleteRoleID)
	self:CloseCancelDeleteConfirm()

	if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
		for _, v in pairs(self.listItemsViewController) do
			local itemViewController = v
			if itemViewController.roleID == self.willCancelDeleteRoleID then
				itemViewController:CloseMyTick()
				break
			end
		end
	end
end

function UIViewControllerRolesList:OnClickForButtonNoOfCancelDeleteConfirm()
	self:CloseCancelDeleteConfirm()
end

function UIViewControllerRolesList:RegisterAreaDragEvent()
	self:AddDragEvent(self.goBCForDrag, function (go,delta) self:OnDrag(go, delta) end)
end

function UIViewControllerRolesList:OnDrag(go, delta)
	local deltaAngle = - delta.x * 360 / 400
	RoleReadyForLogin.Ins():RotateDelta(deltaAngle)
end

function UIViewControllerRolesList:Listen()
	EventManager.Me():AddEventListener(LoginRoleEvent.UIRoleBeSelected, self.OnRolesListItemBeSelected, self)

	self:ListenServerResponse()
end

function UIViewControllerRolesList:RequestDeleteRole(roleID)
	ServiceLoginUserCmdProxy.Instance:CallDeleteCharUserCmd(roleID)
end

function UIViewControllerRolesList:RequestCancelDeleteRole(roleID)
	ServiceLoginUserCmdProxy.Instance:CallCancelDeleteCharUserCmd(roleID)
end

function UIViewControllerRolesList:ListenServerResponse()
	self:AddListenEvt(ServiceEvent.PlayerMapChange, self.OnMapChange)
	self:AddListenEvt(ServiceEvent.LoginUserCmdSnapShotUserCmd, self.OnReceiveRolesInfoUpdate)

	--todo xde 
	self:AddListenEvt(XDEUIEvent.RoleBack, self.OnClickForButtonBack)
end

function UIViewControllerRolesList:CancelListen()
	EventManager.Me():RemoveEventListener(LoginRoleEvent.UIRoleBeSelected, self.OnRolesListItemBeSelected, self)
end

function UIViewControllerRolesList:OnMapChange()
	UIModelRolesList.Ins():SetSelectedRole(self.selectedRoleID)
	self:Close()

	FrameRateSpeedUpChecker.Instance():Open()
end

function UIViewControllerRolesList:OnRolesListItemBeSelected(content)
	if self.isDestroyed then return end

	local itemViewController = content
	if itemViewController:IsNormal() then
		if not itemViewController.isSelected then
			self:CancelAllSelectedIcon()
		end

		self:SelectNormal(itemViewController.roleID)
	elseif itemViewController:IsEmpty() then
		if not itemViewController.isSelected then
			self:CancelAllSelectedIcon()
		end

		self:SelectEmpty(itemViewController.index)
	elseif itemViewController:IsLock() then
		-- if itemViewController.index == 4 then
			MsgManager.ShowMsgByID(1065)
		-- elseif itemViewController.index == 5 then
			-- MsgManager.ShowMsgByID(1065)
		-- end
	elseif itemViewController:IsDelete() then
		if not itemViewController.isSelected then
			self:CancelAllSelectedIcon()
		end

		self:SelectDelete(itemViewController.roleID)
	end
end

function UIViewControllerRolesList:OnReceiveRolesInfoUpdate(content)
	if self.flagRequestDeleteRole == true and self:AnyRoleBeingDelete() then
		local deleteNeedTime = UIModelRolesList.Ins():GetRoleDeleteNeedTime(self.selectedRoleID)
		if deleteNeedTime > 0 then
			MsgManager.ShowMsgByID(1071)
		end
		self.flagRequestDeleteRole = false
	end

	if content.body.deletechar then
		MsgManager.ShowMsgByID(1066)
	end
	
	self:GetModel()
	self:LoadView()
end

function UIViewControllerRolesList:IsHaveAnyRole()
	if self.roles ~= nil then
		for _, v in pairs(self.roles) do
			local roleInfo = v
			if roleInfo.id > 0 and roleInfo.deletetime == 0 then
				return true
			end
		end
	end
	return false
end

function UIViewControllerRolesList:CancelAllSelectedIcon()
	if self.listItemsViewController ~= nil then
		for _, v in pairs(self.listItemsViewController) do
			local itemViewController1 = v
			if itemViewController1.isSelected then
				itemViewController1:CancelSelected()
			end
		end
	end
end

function UIViewControllerRolesList:AnyRoleBeingDelete()
	local roleID = 0
	if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
		for _, v in pairs(self.listItemsViewController) do
			local itemViewController = v
			if itemViewController:IsDelete() then
				roleID = itemViewController.roleID
				break
			end
		end
	end
	return roleID
end