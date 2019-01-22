RecallShareView = class("RecallShareView",ContainerView)

RecallShareView.ViewType = UIViewType.PopUpLayer

local _bgName = "share_bg_02"
local _activityBgName = "recall_bg_share"

local ScreenWidth = Screen.width
local ScreenHeight = Screen.height
local screenShotWidth = 820*ScreenWidth/1280
local screenShotHeight = 464*ScreenHeight/720
local screenRect = Rect(230*ScreenWidth/1280, 108*ScreenHeight/720, screenShotWidth, screenShotHeight)
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function RecallShareView:OnExit()
	PictureManager.Instance:UnLoadRecall()

	RecallShareView.super.OnExit(self)
end

function RecallShareView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function RecallShareView:FindObjs()
	self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
	self.share = self:FindGO("Share")
	self.tip = self:FindGO("Tip"):GetComponent(UILabel)
	self.firstRewardTip = self:FindGO("FirstRewardTip"):GetComponent(UILabel)
end

function RecallShareView:AddEvts()
	local tipClickUrl = self.tip.gameObject:GetComponent(UILabelClickUrl)
	tipClickUrl.callback = function (url)
		self:ShowItem(tonumber(url))
	end

	local firstRewardTipClickUrl = self.firstRewardTip.gameObject:GetComponent(UILabelClickUrl)
	firstRewardTipClickUrl.callback = function (url)
		self:ShowItem(tonumber(url))
	end

	--todo xde ??????????????????
--	local qq = self:FindGO("QQ")
--	self:AddClickEvent(qq, function ()
--		self:ClickShare(E_PlatformType.QQ, 562)
--	end)
--
--	local wechat = self:FindGO("Wechat")
--	self:AddClickEvent(wechat, function ()
--		self:ClickShare(E_PlatformType.Wechat, 561)
--	end)
--
--	local wechatMoments = self:FindGO("WechatMoments")
--	self:AddClickEvent(wechatMoments, function ()
--		self:ClickShare(E_PlatformType.WechatMoments, 561)
--	end)
--
--	local sina = self:FindGO("Sina")
--	self:AddClickEvent(sina, function ()
--		self:ClickShare(E_PlatformType.Sina, 563)
--	end)

	local share = self:FindGO("Share")
	self:AddClickEvent(share, function()
		self:FBClickShare()
	end)
end

--todo xde add fbshare
function RecallShareView:FBClickShare()
	local ui = NGUIUtil:GetCameraByLayername("UI")
	self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
	self.screenShotHelper:GetScreenShot(function (texture)
		texture:ReadPixels(screenRect, 0, 0)
		texture:Apply()

		local picName = shotName..tostring(os.time())
		local path = PathUtil.GetSavePath(PathConfig.TempShare).."/"..picName
		ScreenShot.SaveJPG(texture, path, 100)
		path = path..".jpg"
		helplog("Recall Share path", path)
		--todo xde share facebook
		local overseasManager = OverSeas_TW.OverSeasManager.GetInstance();
		overseasManager:ShareImg(path,"","","",function(msg)
			ROFileUtils.FileDelete(path)
			if(msg == "1")then
				helplog("Recall Share success")

				if self.charid ~= nil then
					ServiceSessionSocialityProxy.Instance:CallRecallFriendSocialCmd(self.charid)

					-- local isFirst = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.SocialRecall)
					-- if isFirst then
					ServiceUserEventProxy.Instance:CallGetFirstShareRewardUserEvent()
					-- end
				end
			else
				helplog("Recall Share failure")
				MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
			end
		end);
	end, ui)
end

function RecallShareView:AddViewEvts()
	
end

function RecallShareView:InitShow()
	self.tipData = {}
	self.tipData.funcConfig = {}

	local name = ""
	local data = self.viewdata.viewdata
	if data then
		name = data.name
		self.charid = data.guid
	end

	local _PictureManager = PictureManager.Instance
	local bg = self:FindGO("BgTexture"):GetComponent(UITexture)
	local activityBg = self:FindGO("ActivityTexture"):GetComponent(UITexture)
	_PictureManager:SetRecall(_bgName, bg)
	_PictureManager:SetRecall(_activityBgName, activityBg)

	local GetRewardItemIdsByTeamId = ItemUtil.GetRewardItemIdsByTeamId
	local Recall = GameConfig.Recall
	if Recall ~= nil then
		local rewardList = GetRewardItemIdsByTeamId(Recall.Reward)
		if rewardList ~= nil and #rewardList > 0 then
			local reward = rewardList[1]
			local id = reward.id
			local item = Table_Item[id]
			self.tip.text = string.format(ZhString.Friend_RecallTip, name, reward.num, id, item.NameZh, 30, "????????????")
		end

		local firstRewardList = GetRewardItemIdsByTeamId(Recall.first_share_reward)
		if firstRewardList ~= nil and #firstRewardList > 0 then

			local rewardStr = "";
			for i=1,#firstRewardList do
				local id, num = firstRewardList[i].id, firstRewardList[i].num;
				if(num > 1)then
					rewardStr = string.format("[url=%s]%sx%s[/url]", id, Table_Item[id].NameZh, num);
				else
					rewardStr = string.format("[url=%s]%s[/url]", id, Table_Item[id].NameZh);
				end
				if(i < #firstRewardList)then
					rewardStr = rewardStr .. ZhString.Friend_DunHao;
				end
			end
			self.firstRewardTip.text = ZhString.Friend_RecallFirstRewardTip .. rewardStr;

		end
	end

	self.share:SetActive(self:CheckShareOpen())
end

function RecallShareView:ShowItem(itemid)
	if itemid ~= nil then
		local itemData = ItemData.new("Recall", itemid)
		self.tipData.itemdata = itemData
		self:ShowItemTip(self.tipData, self.firstRewardTip, NGUIUtil.AnchorSide.Right, {-220,0})
	end
end

function RecallShareView:ClickShare(platform, msgid)
	local _SocialShare = SocialShare.Instance
	if _SocialShare:IsClientValid(platform) then
		local ui = NGUIUtil:GetCameraByLayername("UI")
		self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
		self.screenShotHelper:GetScreenShot(function (texture)
			texture:ReadPixels(screenRect, 0, 0)
			texture:Apply()

			local picName = shotName..tostring(os.time())
			local path = PathUtil.GetSavePath(PathConfig.TempShare).."/"..picName
			ScreenShot.SaveJPG(texture, path, 100)
			path = path..".jpg"
			helplog("Recall Share path", path)

			SocialShare.Instance:ShareImage(path, "", "", platform, function (succMsg)
				helplog("Recall Share success")
				ROFileUtils.FileDelete(path)

				if self.charid ~= nil then
					ServiceSessionSocialityProxy.Instance:CallRecallFriendSocialCmd(self.charid)

					-- local isFirst = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.SocialRecall)
					-- if isFirst then
						ServiceUserEventProxy.Instance:CallGetFirstShareRewardUserEvent()
					-- end
				end

			end,function (failCode, failMsg)
				helplog("Recall Share failure")
				ROFileUtils.FileDelete(path)

				local errorMessage = failMsg or 'error'
				if failCode ~= nil then
					errorMessage = failCode .. ', ' .. errorMessage
				end
				MsgManager.ShowMsg('', errorMessage, MsgManager.MsgType.Float)
			end,function ()
				helplog("Recall Share cancel")
				ROFileUtils.FileDelete(path)
			end)
		end, ui)
	else
		MsgManager.ShowMsgByIDTable(msgid)
	end
end

function RecallShareView:CheckShareOpen()
	local socialShareConfig = AppBundleConfig.GetSocialShareInfo()
	if socialShareConfig == nil then
		return false
	end

	if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V9) then
		return false
	end
	return true
end