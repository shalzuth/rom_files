RecallShareView = class("RecallShareView", ContainerView)
RecallShareView.ViewType = UIViewType.PopUpLayer
local _bgName = "share_bg_02"
local _activityBgName = "recall_bg_share"
local shotName = "RO_RecallShareTemp"
function RecallShareView:OnExit()
  local _PictureManager = PictureManager.Instance
  _PictureManager:UnLoadRecall(_bgName, self.bg)
  _PictureManager:UnLoadRecall(_activityBgName, self.activityBg)
  RecallShareView.super.OnExit(self)
end
function RecallShareView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function RecallShareView:FindObjs()
  self.share = self:FindGO("Share")
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
  self.firstRewardTip = self:FindGO("FirstRewardTip"):GetComponent(UILabel)
  self.bg = self:FindGO("BgTexture"):GetComponent(UITexture)
  self.activityBg = self:FindGO("ActivityTexture"):GetComponent(UITexture)
end
function RecallShareView:AddEvts()
  local tipClickUrl = self.tip.gameObject:GetComponent(UILabelClickUrl)
  function tipClickUrl.callback(url)
    self:ShowItem(tonumber(url))
  end
  local firstRewardTipClickUrl = self.firstRewardTip.gameObject:GetComponent(UILabelClickUrl)
  function firstRewardTipClickUrl.callback(url)
    self:ShowItem(tonumber(url))
  end
  local share = self:FindGO("Share")
  self:AddClickEvent(share, function()
    self:FBClickShare()
  end)
end
function RecallShareView:FBClickShare()
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    texture:ReadPixels(screenRect, 0, 0)
    texture:Apply()
    local picName = shotName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    helplog("Recall Share path", path)
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
    overseasManager:ShareImg(path, "", "", "", function(msg)
      ROFileUtils.FileDelete(path)
      if msg == "1" then
        helplog("Recall Share success")
        if self.charid ~= nil then
          ServiceSessionSocialityProxy.Instance:CallRecallFriendSocialCmd(self.charid)
          ServiceUserEventProxy.Instance:CallGetFirstShareRewardUserEvent()
        end
      else
        helplog("Recall Share failure")
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
      end
    end)
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
  _PictureManager:SetRecall(_bgName, self.bg)
  _PictureManager:SetRecall(_activityBgName, self.activityBg)
  local GetRewardItemIdsByTeamId = ItemUtil.GetRewardItemIdsByTeamId
  local Recall = GameConfig.Recall
  if Recall ~= nil then
    local rewardList = GetRewardItemIdsByTeamId(Recall.Reward)
    if rewardList ~= nil and #rewardList > 0 then
      local reward = rewardList[1]
      local id = reward.id
      local item = Table_Item[id]
      self.tip.text = string.format(ZhString.Friend_RecallTip, name, reward.num, id, item.NameZh, 15, ZhString.Oversea_Hard_Code_Client_6)
    end
    local firstRewardList = GetRewardItemIdsByTeamId(Recall.first_share_reward)
    if firstRewardList ~= nil and #firstRewardList > 0 then
      local rewardStr = ""
      for i = 1, #firstRewardList do
        local id, num = firstRewardList[i].id, firstRewardList[i].num
        if num > 1 then
          rewardStr = string.format("[url=%s]%sx%s[/url]", id, Table_Item[id].NameZh, num)
        else
          rewardStr = string.format("[url=%s]%s[/url]", id, Table_Item[id].NameZh)
        end
        if i < #firstRewardList then
          rewardStr = rewardStr .. ZhString.Friend_DunHao
        end
      end
      self.firstRewardTip.text = ZhString.Friend_RecallFirstRewardTip .. rewardStr
    end
  end
  self.share:SetActive(self:CheckShareOpen())
end
function RecallShareView:ShowItem(itemid)
  if itemid ~= nil then
    local itemData = ItemData.new("Recall", itemid)
    self.tipData.itemdata = itemData
    self:ShowItemTip(self.tipData, self.firstRewardTip, NGUIUtil.AnchorSide.Right, {-220, 0})
  end
end
function RecallShareView:ClickShare(platform, msgid)
  local _SocialShare = SocialShare.Instance
  if _SocialShare:IsClientValid(platform) then
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. shotName
    if not FileDirectoryHandler.ExistDirectory(path) then
      FileDirectoryHandler.CreateDirectory(path)
    end
    path = path .. ".jpg"
    helplog("Recall Share path", path)
    local bytes = ImageConversion.EncodeToJPG(self.activityBg.mainTexture)
    FileDirectoryHandler.WriteFile(path, bytes, function(x)
      helplog("Recall WriteFile success")
      if self.charid ~= nil then
        ServiceSessionSocialityProxy.Instance:CallRecallFriendSocialCmd(self.charid)
        ServiceUserEventProxy.Instance:CallGetFirstShareRewardUserEvent()
      end
      SocialShare.Instance:ShareImage(path, "", "", platform, function(succMsg)
        helplog("Recall Share success")
        ROFileUtils.FileDelete(path)
        if self.charid ~= nil then
          ServiceSessionSocialityProxy.Instance:CallRecallFriendSocialCmd(self.charid)
          ServiceUserEventProxy.Instance:CallGetFirstShareRewardUserEvent()
        end
      end, function(failCode, failMsg)
        helplog("Recall Share failure")
        ROFileUtils.FileDelete(path)
        local errorMessage = failMsg or "error"
        if failCode ~= nil then
          errorMessage = failCode .. ", " .. errorMessage
        end
        MsgManager.ShowMsg("", errorMessage, MsgManager.MsgType.Float)
      end, function()
        helplog("Recall Share cancel")
        ROFileUtils.FileDelete(path)
      end)
    end)
    break
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
end
