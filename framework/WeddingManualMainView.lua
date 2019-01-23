WeddingManualMainView = class("WeddingManualMainView",ContainerView)

WeddingManualMainView.ViewType = UIViewType.NormalLayer

local _PictureManager = PictureManager.Instance
local _WeddingProxy = WeddingProxy.Instance
local ModelInfo = {
	[1] = {
		position = Vector3(-2.144331,4.934041,5.171474),
		rotation = Quaternion.Euler(4.009137,-39.80121,0.5966117),
		},
	[2] = {
		position = Vector3(-2.63895,4.932941,5.072763),
		rotation = Quaternion.Euler(1.406668,-8.675812,0.8491375),
		},
}
local Color = LuaColor.New(1,1,1,0)
local backgroundName = "marry_bg_process"

local GOCameraType = Game.GameObjectType.Camera

function WeddingManualMainView:OnEnter()
	WeddingManualMainView.super.OnEnter(self)

	local weddingInfo = _WeddingProxy:GetWeddingInfo()
	if weddingInfo ~= nil then
		local charid = weddingInfo:GetPartnerGuid()
		if charid ~= nil then
			ServiceChatCmdProxy.Instance:CallQueryUserInfoChatCmd(charid, nil, ChatCmd_pb.EUSERINFOTYPE_WEDDING)
		end
	end

	ServiceWeddingCCmdProxy.Instance:CallUpdateWeddingManualCCmd()

	local camera = Game.GameObjectManagers[GOCameraType]
	if camera ~= nil then
		camera:ActiveMainCamera(false)
	end
end

function WeddingManualMainView:OnExit()
	_PictureManager:UnLoadWedding(backgroundName, self.backgroundL)
	_PictureManager:UnLoadWedding(backgroundName, self.backgroundR)
	local camera = Game.GameObjectManagers[GOCameraType]
	if camera ~= nil then
		camera:ActiveMainCamera(true)
	end
	WeddingManualMainView.super.OnExit(self)
end

function WeddingManualMainView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function WeddingManualMainView:FindObjs()
	self.backgroundL = self:FindGO("BackgroundL"):GetComponent(UITexture)
	self.backgroundR = self:FindGO("BackgroundR"):GetComponent(UITexture)
	self.roleTex = self:FindGO("RoleTexture"):GetComponent(UITexture)
	self.charNameA = self:FindGO("CharNameA"):GetComponent(UILabel)
	self.charNameB = self:FindGO("CharNameB"):GetComponent(UILabel)
	self.processInfo = self:FindGO("ProcessInfo"):GetComponent(UILabel)
	self.package = self:FindGO("Package"):GetComponent(UISprite)
	self.photograph = self:FindGO("Photograph"):GetComponent(UISprite)
	self.ring = self:FindGO("Ring"):GetComponent(UISprite)
	self.dressup = self:FindGO("Dressup"):GetComponent(UISprite)
end

function WeddingManualMainView:AddEvts()
	local detailBtn = self:FindGO("DetailBtn")
	self:AddClickEvent(detailBtn,function ()
		self:Detail()
	end)

	local goBtn = self:FindGO("GoBtn")
	self:AddClickEvent(goBtn,function ()
		self:Go()
	end)

	local inviteBtn = self:FindGO("InviteBtn")
	self:AddClickEvent(inviteBtn,function ()
		self:Invite()
	end)

	self:AddClickEvent(self.package.gameObject,function ()
		self:Package()
	end)

	self:AddClickEvent(self.photograph.gameObject,function ()
		self:Photograph()
	end)

	self:AddClickEvent(self.ring.gameObject,function ()
		self:Ring()
	end)

	self:AddClickEvent(self.dressup.gameObject,function ()
		self:Dressup()
	end)
end

function WeddingManualMainView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.ChatCmdQueryUserInfoChatCmd, self.HandleQueryUserInfo)
	self:AddListenEvt(ServiceEvent.WeddingCCmdUpdateWeddingManualCCmd, self.HanleUpdateWeddingManual)
	self:AddListenEvt(ServiceEvent.WeddingCCmdNtfWeddingInfoCCmd, self.HanleNtfWeddingInfoCCmd)
end

function WeddingManualMainView:InitShow()
	_PictureManager:SetWedding(backgroundName, self.backgroundL)
	_PictureManager:SetWedding(backgroundName, self.backgroundR)

	local weddingInfo = _WeddingProxy:GetWeddingInfo()
	if weddingInfo ~= nil then
		local starttime = weddingInfo:GetStartTimeData()
		local endtime = weddingInfo:GetEndTimeData()

		self.processInfo.text = string.format(ZhString.Wedding_ManualInfo, starttime.year, starttime.month, starttime.day, starttime.hour, endtime.hour, weddingInfo:GetZoneStr())
	end
end

function WeddingManualMainView:Detail()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.WeddingProcessView})
end

function WeddingManualMainView:Go()
	FuncShortCutFunc.Me():CallByID(1003)
end

function WeddingManualMainView:Invite()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.WeddingInviteView})
end

function WeddingManualMainView:Package()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.WeddingPackageView})
end

function WeddingManualMainView:Photograph()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.MarriageManualPicDiy})
end

function WeddingManualMainView:Ring()
	FuncShortCutFunc.Me():CallByID(4004)
end

function WeddingManualMainView:Dressup()
	FuncShortCutFunc.Me():CallByID(4003)
end

function WeddingManualMainView:UpdatePackageIcon()
	local packageList = _WeddingProxy:GetWeddingPackageList()
	if packageList ~= nil then
		local package
		for i=1,#packageList do
			local data = packageList[i]
			if data ~= nil and data.isPurchased then
				package = data
			end
		end

		if package ~= nil then
			local item = Table_Item[package.id]
			if item ~= nil then
				IconManager:SetItemIcon(item.Icon, self.package)
			end
		end
	end
end

function WeddingManualMainView:UpdateRingIcon()
	local ringid = _WeddingProxy:GetWeddingRingid()
	if ringid ~= nil then
		local item = Table_Item[ringid]
		if item ~= nil then
			IconManager:SetItemIcon(item.Icon, self.ring)
		end
	end
end

function WeddingManualMainView:HandleQueryUserInfo(note)
	local data = note.body
	if data ~= nil then
		local info = data.info
		local weddingInfo = _WeddingProxy:GetWeddingInfo()
		if weddingInfo ~= nil and weddingInfo:GetPartnerGuid() == info.charid then
			if self.playerData then
				self.playerData:Destroy()
				self.playerData = nil
			end

			self.playerData = PlayerData.CreateAsTable(info)

			local datas = info.datas
			if datas then
				for i=1,#datas do
					local celldata = datas[i]
					if celldata ~= nil then
						self.playerData.userdata:SetByID(celldata.type, celldata.value, celldata.data)
					end
				end
			end

			local _Myself = Game.Myself

			self:SetPlayerModelTex(self.playerData.userdata, 1)
			self:SetPlayerModelTex(_Myself.data.userdata, 2)

			UIMultiModelUtil.Instance:SetColor(Color)

			self.charNameA.text = info.name
			self.charNameB.text = _Myself.data.name
		end
	end
end

function WeddingManualMainView:HanleUpdateWeddingManual(note)
	self:UpdatePackageIcon()
	self:UpdateRingIcon()
end

function WeddingManualMainView:HanleNtfWeddingInfoCCmd(note)
	local data = note.body
	if data ~= nil then
		if WeddingProxy.Instance:GetWeddingInfo() == nil then
			self:CloseSelf()
		end
	end
end

function WeddingManualMainView:SetPlayerModelTex(userdata, index)
	if userdata ~= nil then
		local parts = Asset_Role.CreatePartArray()

		local partIndex = Asset_Role.PartIndex
		local partIndexEx = Asset_Role.PartIndexEx
		parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
		parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
		parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
		parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
		parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
		parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
		parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
		parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
		parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
		parts[partIndex.Mount] = 0
		parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0

		parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
		parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
		parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
		parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0

		local args = ReusableTable.CreateArray()
		args[1] = parts
		args[2] = self.roleTex
		args[3] = ModelInfo[index].position
		args[4] = ModelInfo[index].rotation
		args[5] = 1
		args[6] = ReusableTable.CreateTable()
		args[6].name = Asset_Role.ActionName.Idle
		args[7] = nil
		args[8] = nil
		args[9] = nil
		args[10] = true
		UIMultiModelUtil.Instance:SetModels(index, args)

		Asset_Role.DestroyPartArray(parts)
		ReusableTable.DestroyAndClearTable(args[6])
		ReusableTable.DestroyAndClearArray(args)
	end
end