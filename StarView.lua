StarView = class("StarView",ContainerView)

StarView.ViewType = UIViewType.NormalLayer

local TYPE = LoveLetterData.Type

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function StarView:OnExit()
	PictureManager.Instance:UnLoadStar()
	StarView.super.OnExit(self)
end

function StarView:Init()
	self:FindObj()
	self:AddEvt()
	self:AddViewEvt()
	self:InitShow()
end

function StarView:FindObj()
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.from = self:FindGO("From"):GetComponent(UILabel)
	self.star = self:FindGO("Star"):GetComponent(UITexture)
	self.btnRoot = self:FindGO("BtnRoot")
	self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
	self.share = self:FindGO("Share")
	self.save = self:FindGO("Save")
end

function StarView:AddEvt()
	self:AddClickEvent(self.save, function ()
		self:ClickSave()
	end)

	self:AddClickEvent(self.share, function ()
		self:ClickShare()
	end)

	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton, function ()
		self:CloseView()
	end)
end

function StarView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.ItemSaveLoveLetterCmd , self.CloseView)
	self:AddListenEvt(ShareEvent.ClickPlatform , self.ClickPlatform)
end

function StarView:InitShow()
	self.isQueue = self.viewdata.viewdata == nil

	local isOpen = StarProxy.Instance:CheckShareOpen()
	self.share:SetActive(isOpen)

	self:UpdateView()
end

function StarView:UpdateView()
	local data
	if self.isQueue then
		data = StarProxy.Instance:GetFrontData()
	else
		data = self.viewdata.viewdata
	end
	if data then
		self:SetData(data)
	end
end

function StarView:SetData(data)
	if data then
		self.id = data.id

		local content = ""
		local letter = Table_LoveLetter[data.staticId]
		if letter and letter.Letter then
			content = letter.Letter
		end
		self.content.text = string.format(ZhString.Star_Content, Game.Myself.data.name, content)
		self.from.text = data.name
		PictureManager.Instance:SetStar(data.bg, self.star)

		self.save:SetActive(data.type == TYPE.Star)
	end

	--todo xde
	LeanTween.delayedCall(self.gameObject,0.5,function (  )
		local bg7 = self:FindGO("bg7"):GetComponent(UISprite)
		bg7:MakePixelPerfect()
		self.content.spacingY = 6
	end)
end

function StarView:ClickSave()
	if self.id then
		helplog("CallSaveLoveLetterCmd", self.id)
		ServiceItemProxy.Instance:CallSaveLoveLetterCmd(self.id)
	end
end

function StarView:ClickShare()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.GeneralShareView})
end

function StarView:ClickPlatform(note)
	local data = note.body
	if data then
		self:SharePicture(data, "", "")
	end
end

function StarView:CloseView()
	if self.isQueue then
		local isNext = StarProxy.Instance:ShowNext()
		if not isNext then
			self:UpdateView()
			return
		end
	end

	self:CloseSelf()
end

--??????
function StarView:SharePicture(platform_type, content_title, content_body)
	helplog("StarView SharePicture", platform_type)

	local gmCm = NGUIUtil:GetCameraByLayername("Default")
	local ui = NGUIUtil:GetCameraByLayername("UI")
	self.btnRoot:SetActive(false)
	self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
	self.screenShotHelper:GetScreenShot(function (texture)
		self.btnRoot:SetActive(true)

		local picName = shotName..tostring(os.time())
		local path = PathUtil.GetSavePath(PathConfig.TempShare).."/"..picName
		ScreenShot.SaveJPG(texture, path, 100)
		path = path..".jpg"
		helplog("StarView Share path", path)

		--todo xde share facebook
		local overseasManager = OverSeas_TW.OverSeasManager.GetInstance();
		overseasManager:ShareImg(path,content_title,"",content_body,function(msg)
			ROFileUtils.FileDelete(path)
			if(msg == "1")then
				MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
			else
				MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
			end
		end);
		
--		SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function (succMsg)
--			helplog("StarView Share success")
--			ROFileUtils.FileDelete(path)
--
--			if platform_type == E_PlatformType.Sina then
--				MsgManager.ShowMsgByIDTable(566)
--			end
--		end,function (failCode, failMsg)
--			helplog("StarView Share failure")
--			ROFileUtils.FileDelete(path)
--
--			local errorMessage = failMsg or 'error'
--			if failCode ~= nil then
--				errorMessage = failCode .. ', ' .. errorMessage
--			end
--			MsgManager.ShowMsg('', errorMessage, MsgManager.MsgType.Float)
--		end,function ()
--			helplog("StarView Share cancel")
--			ROFileUtils.FileDelete(path)
--		end)
	end, gmCm, ui)
end