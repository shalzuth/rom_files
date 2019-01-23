local BaseCell = autoImport("BaseCell");
SetViewHeadCell = class("SetViewHeadCell", BaseCell)

function SetViewHeadCell:Init()
	self:initView()
end

function  SetViewHeadCell:initView(  )
	-- body
	self.lockedIcon = self:FindGO("noneProfession")
	self.headCellObj = self:FindGO("PortraitCell")
	self.LevelLabel = self:FindComponent("LevelLabel",UILabel)
	self.deletingCt = self:FindGO("deletingCt")
	self.LevelCt = self:FindGO("LevelCt")
	self.deletingLabel = self:FindComponent("deletingLabel",UILabel)
	self:AddClickEvent(self.gameObject,function ()
		self:PassEvent(MouseEvent.MouseClick, self);
	end)
end

function SetViewHeadCell:SetData( data )
	-- body
	self.data = data
	if(data == nil )then
		self:Show(self.lockedIcon)
		self:Hide(self.LevelCt)
		self:Hide(self.deletingCt)		
	else
		self:Hide(self.lockedIcon)
		self:Show(self.LevelCt)
		self:SetHeadImgData()
	end

	if(data and data.deletetime ~= 0)then
		local leftTime = ServerTime.ServerDeltaSecondTime(data.deletetime * 1000)
		leftTime = math.floor(leftTime)
		self.leftTime = leftTime
		if self.tick == nil then
			self.tick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateDeleteTime, self, 1)
		end
		self:Show(self.deletingCt)
		self.LevelLabel.text = data.baselv
	elseif(data)then
		self:Hide(self.deletingCt)
		TimeTickManager.Me():ClearTick(self, 1)
		self.tick = nil
		self.LevelLabel.text = data.baselv
	end
end

function SetViewHeadCell:OnRemove(  )
	if self.tick ~= nil then
		TimeTickManager.Me():ClearTick(self, 1)
		self.tick = nil
	end
end

function SetViewHeadCell:UpdateDeleteTime(  )
	autoImport("UIListItemViewControllerRoleSlot")
	self.leftTime = self.leftTime - 1
	local hour, minutes, seconds = UIListItemViewControllerRoleSlot.ToHMS(self.leftTime)
	if hour >= 1 then
		self.deletingLabel.text = string.format(ZhString.Boss_RefreshTimeH, hour,minutes)
	else
		self.deletingLabel.text = minutes .. ':' .. seconds
	end
end

function SetViewHeadCell:SetHeadImgData(  )
	self:initHead()
	local imgData = {}
	local roleData = {}
	roleData.hairID = self.data.hair
	roleData.haircolor = self.data.haircolor
	local gender = self.data.gender
	if gender == ProtoCommon_pb.EGENDER_FEMALE then
		roleData.gender = RoleConfig.Gender.Female
	elseif gender == ProtoCommon_pb.EGENDER_MALE then
		roleData.gender = RoleConfig.Gender.Male
	end
	roleData.bodyID = self.data.body
	roleData.headID = self.data.head
	roleData.faceID = self.data.face
	roleData.mouthID = self.data.mouth
	roleData.eyeID = self.data.eye
	roleData.type = HeadImageIconType.Avatar
	imgData.profession = self.data.profession
	imgData.iconData = roleData
	if self.data.portrait and self.data.portrait > 0 then
		local itemConf = Table_HeadImage[self.data.portrait]
		if itemConf then
			roleData.type = HeadImageIconType.Simple
			roleData.icon = itemConf.Picture
		end
	end
	self.targetCell:SetData(imgData)
end

local tempVector3 = LuaVector3.zero

function SetViewHeadCell:initHead(  )
	-- body
	self:Hide(self.lockedIcon)
	local cellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), self.headCellObj);
	tempVector3:Set(0,0,0)
	cellObj.transform.localPosition = tempVector3
	self.targetCell = PlayerFaceCell.new(cellObj);
	self.targetCell:HideHpMp()
	self.targetCell:HideLevel()
	self:AddClickEvent(cellObj,function ()
		self:PassEvent(MouseEvent.MouseClick, self);
	end)
end