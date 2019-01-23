autoImport("EngageChatView")
autoImport("EngageDateView")
autoImport("EngageDayView")

EngageMainView = class("EngageMainView",ContainerView)

EngageMainView.ViewType = UIViewType.NormalLayer

local bgName = "marry_bg_bottom"
local girlBgName = "auction_bg_Corolla"
local _WeddingProxy = WeddingProxy.Instance
local _PictureManager = PictureManager.Instance
local GOCameraType = Game.GameObjectType.Camera

function EngageMainView:OnEnter()
	EngageMainView.super.OnEnter(self)

	local camera = Game.GameObjectManagers[GOCameraType]
	if camera ~= nil then
		camera:ActiveMainCamera(false)
	end
end

function EngageMainView:OnExit()
	_PictureManager:UnLoadAuction(girlBgName, self.girlBg)
	_PictureManager:UnLoadWedding()
	local camera = Game.GameObjectManagers[GOCameraType]
	if camera ~= nil then
		camera:ActiveMainCamera(true)
	end
	EngageMainView.super.OnExit(self)
end

function EngageMainView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function EngageMainView:FindObjs()
	self.background = self:FindGO("Background"):GetComponent(UITexture)
	self.girlBg = self:FindGO("GirlBg"):GetComponent(UITexture)
	self.dialogRoot = self:FindGO("DialogRoot"):GetComponent(UISprite)
	self.dialog = self:FindGO("Dialog"):GetComponent(UILabel)
end

function EngageMainView:AddEvts()
	
end

function EngageMainView:AddViewEvts()
	
end

function EngageMainView:InitShow()
	self.viewEnum = self.viewdata.viewdata.viewEnum

	self:AddSubView("EngageChatView", EngageChatView)
	self.DateView = self:AddSubView("EngageDateView", EngageDateView)
	self.DayView = self:AddSubView("EngageDayView", EngageDayView)

	_PictureManager:SetWedding(bgName, self.background)
	_PictureManager:SetAuction(girlBgName, self.girlBg)

	self:SwitchView(true)
end

function EngageMainView:UpdateDialog(text)
	self.dialog.text = text
	self.dialogRoot.height = self.dialog.localSize.y + 75
end

function EngageMainView:SwitchView(isHomePage)
	self.DateView:ShowSelf(isHomePage)
	self.DayView:ShowSelf(not isHomePage)
end

function EngageMainView:GetCurDateData()
	return _WeddingProxy:GetDateData(self.DateView.curDateData)
end