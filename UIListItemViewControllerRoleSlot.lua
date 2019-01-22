autoImport('HeadIconCell')
autoImport('RoleReadyForLogin')

UIListItemViewControllerRoleSlot = class('UIListItemViewControllerRoleSlot', BaseCell)

local universalTable = {}

function UIListItemViewControllerRoleSlot:Init()
	self:GetGameObjects()
	self:RegisterClickEvent()
end

function UIListItemViewControllerRoleSlot:SetData(itemData)
	if itemData ~= nil then
		self.itemData = itemData

		self:GetModel()
		self:LoadView()
	end
end

function UIListItemViewControllerRoleSlot:GetGameObjects()
	self.goSpAdd = self:FindGO('SpAdd', self.gameObject)
	self.spAdd = self.goSpAdd:GetComponent(UISprite)
	self.goSpLock = self:FindGO('SpLock', self.gameObject)
	self.spLock = self.goSpLock:GetComponent(UISprite)
	self.goRoleIcon = self:FindGO('RoleIcon', self.gameObject)
	self.goLevel = self:FindGO('Level', self.gameObject)
	self.goLabLevel = self:FindGO('Lab', self.goLevel)
	self.labLevel = self.goLabLevel:GetComponent(UILabel)
	self.goSpSelected = self:FindGO('SpSelected', self.gameObject)
	self.spSelected = self.goSpSelected:GetComponent(UISprite)
	self.goDelete = self:FindGO('Delete', self.gameObject)
	self.goDeleteTime = self:FindGO('Time', self.goDelete)
	self.labDeleteTime = self.goDeleteTime:GetComponent(UILabel)
	self.goDeleteL = self:FindGO('SpDeleteL', self.goDelete)
	self.spDeleteL = self.goDeleteL:GetComponent(UISprite)
	self.goDeleteR = self:FindGO('SpDeleteR', self.goDelete)
	self.spDeleteR = self.goDeleteR:GetComponent(UISprite)
	self.goBG = self:FindGO('BG', self.gameObject)
	self.spBG = self.goBG:GetComponent(UISprite)
	
	--todo xde
	self.spDeleteR.depth = 100
	self.spDeleteL.depth = 100
	self.labDeleteTime.depth = 110
end

function UIListItemViewControllerRoleSlot:RegisterClickEvent()
	self:AddClickEvent(self.gameObject, function ()
		self:OnClickForView()
	end)
end

function UIListItemViewControllerRoleSlot:OnClickForView()
	EventManager.Me():PassEvent(LoginRoleEvent.UIRoleBeSelected, self)
end

function UIListItemViewControllerRoleSlot:GetModel()
	self.roleID = self.itemData.roleID
	self.index = self.itemData.index
end

function UIListItemViewControllerRoleSlot:LoadView()
	if self:IsLock() then
		self:SetLock()
	elseif self:IsNormal() then
		self:SetNormal()

		self:LoadViewOfRoleDetail()
	elseif self:IsEmpty() then
		self:SetEmpty()
	elseif self:IsDelete() then
		self:SetDelete()

		self:LoadViewOfRoleDetail()

		local roleDetail = ServiceUserProxy.Instance:GetRoleInfoById(self.roleID)
		if roleDetail ~= nil then
			local leftTime = ServerTime.ServerDeltaSecondTime(roleDetail.deletetime * 1000)
			-- local needTime = 0
			-- local configForDeleteNeedTime = GameConfig.SelectRole.RoleBeDeletedNeedTime
			-- for k, v in pairs(configForDeleteNeedTime) do
			-- 	local level = k
			-- 	if roleDetail.baselv <= level then
			-- 		needTime = v
			-- 		break
			-- 	end
			-- end
			-- needTime = needTime * 60
			leftTime = math.floor(leftTime)
			self.leftTime = leftTime
		end
		self:LoadDeleteTime()
		if self.tick == nil then
			self.tick = TimeTickManager.Me():CreateTick(0, 1000, self.OnTick, self, 1)
		end
	end
end

function UIListItemViewControllerRoleSlot.ToHMS(pSeconds)
	local hour, minutes, seconds = 0, 0, 0
	if pSeconds > 0 then
		local value = pSeconds
		while value >= 60 do
			value = value - 60
			minutes = minutes + 1
		end
		seconds = value
		value = minutes
		while value >= 60 do
			value = value - 60
			hour = hour + 1
		end
		minutes = value
	end
	return hour, minutes, seconds
end

function UIListItemViewControllerRoleSlot:LoadDeleteTime()
	local hour, minutes, seconds = UIListItemViewControllerRoleSlot.ToHMS(self.leftTime)
	if hour >= 1 then
		self.labDeleteTime.text = string.format(ZhString.Hours, hour)
	else
		self.labDeleteTime.text = minutes .. ':' .. seconds
	end

	self.leftHour = hour; self.leftMinutes = minutes; self.leftSeconds = seconds
end

function UIListItemViewControllerRoleSlot:LoadViewOfRoleDetail()
	if self.headIconCell == nil then
		self.headIconCell = HeadIconCell.new()
		self.headIconCell:CreateSelf(self.goRoleIcon)
		local bc = self.headIconCell.gameObject:GetComponent(BoxCollider)
		if bc ~= nil then
			bc.enabled = false
		end
		self.headIconCell:SetMinDepth(2)
		self.headIconCell:SetScale(0.66)
		local goFrame = self:FindGO('Frame', self.headIconCell.gameObject)
		goFrame:SetActive(false)
	end
	local roleDetail = ServiceUserProxy.Instance:GetRoleInfoById(self.roleID)
	if roleDetail.portrait and roleDetail.portrait > 0 then
		local conf = Table_HeadImage[roleDetail.portrait]
		if conf then
			self.headIconCell:SetSimpleIcon(conf.Picture)
		end
	else
		universalTable.hairID = roleDetail.hair
		universalTable.haircolor = roleDetail.haircolor
		local gender = roleDetail.gender
		if gender == ProtoCommon_pb.EGENDER_FEMALE then
			universalTable.gender = RoleConfig.Gender.Female
		elseif gender == ProtoCommon_pb.EGENDER_MALE then
			universalTable.gender = RoleConfig.Gender.Male
		end
		-- local professionID = roleDetail.profession
		-- local professionConf = Table_Class[professionID] or Table_Class[1]
		-- if gender == ProtoCommon_pb.EGENDER_FEMALE then
		-- 	universalTable.bodyID = professionConf.FemaleBody
		-- elseif gender == ProtoCommon_pb.EGENDER_MALE then
		-- 	universalTable.bodyID = professionConf.MaleBody
		-- end
		universalTable.bodyID = roleDetail.body
		universalTable.headID = roleDetail.head
		universalTable.faceID = roleDetail.face
		universalTable.mouthID = roleDetail.mouth
		universalTable.eyeID = roleDetail.eye
		self.headIconCell:SetData(universalTable)
		TableUtility.TableClear(universalTable)
	end
	self.labLevel.text = tostring(roleDetail.baselv)
end

function UIListItemViewControllerRoleSlot:SetNormal(roleID)
	self.spLock.enabled = false
	self.spAdd.enabled = false
	self.goRoleIcon:SetActive(true)
	self.goLevel:SetActive(true)
	self.goDelete:SetActive(false)

	self.spBG.depth = 1
end

function UIListItemViewControllerRoleSlot:SetEmpty()
	self.spLock.enabled = false
	self.spAdd.enabled = true
	self.goRoleIcon:SetActive(false)
	self.goLevel:SetActive(false)
	self.goDelete:SetActive(false)

	self.spBG.depth = 1
end

function UIListItemViewControllerRoleSlot:SetLock()
	self.spLock.enabled = true
	self.spAdd.enabled = false
	self.goRoleIcon:SetActive(false)
	self.goLevel:SetActive(false)
	self.goDelete:SetActive(false)

	self.spBG.depth = 1
end

function UIListItemViewControllerRoleSlot:SetDelete()
	self.spLock.enabled = false
	self.spAdd.enabled = false
	self.goRoleIcon:SetActive(true)
	self.goLevel:SetActive(true)
	self.goDelete:SetActive(true)

	self.spBG.depth = 9
end

function UIListItemViewControllerRoleSlot:SetSelected()
	if not self.isSelected then
		if not GameObjectUtil.Instance:ObjectIsNULL(self.spSelected) then
			self.spSelected.enabled = true
		end
		self.isSelected = true
	end
end

function UIListItemViewControllerRoleSlot:CancelSelected()
	if self.isSelected then
		if not GameObjectUtil.Instance:ObjectIsNULL(self.spSelected) then
			self.spSelected.enabled = false
		end
		self.isSelected = false
	end
end

function UIListItemViewControllerRoleSlot:IsEmpty()
	if self.itemData ~= nil then
		if (self.itemData.roleID <= 0) and (not self.itemData.lock) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function UIListItemViewControllerRoleSlot:IsNormal()
	if self.itemData ~= nil then
		if self.itemData.deletetime == 0 then
			return self.itemData.roleID > 0
		else
			return false
		end
	else
		return false
	end
end

function UIListItemViewControllerRoleSlot:IsLock()
	if self.itemData ~= nil then
		return self.itemData.lock == true
	else
		return false
	end
end

function UIListItemViewControllerRoleSlot:IsDelete()
	if self.itemData ~= nil then
		return not (self.itemData.deletetime == 0)
	else
		return false
	end
end

function UIListItemViewControllerRoleSlot:OnTick()
	if self.leftTime > 0 then
		self.leftTime = self.leftTime - 1
		self:LoadDeleteTime()
	else
		self:CloseMyTick()
	end
end

function UIListItemViewControllerRoleSlot:CloseMyTick()
	if self.tick ~= nil then
		TimeTickManager.Me():ClearTick(self, 1)
		self.tick = nil
	end
end