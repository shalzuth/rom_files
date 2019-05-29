local BaseCell = autoImport("BaseCell")
ServantRecommendCell = class("ServantRecommendCell", BaseCell)
local tmpPos = LuaVector3.zero
local OFFSET = 200
local btnStatus = {
  GO = {
    "com_btn_2s",
    ZhString.Servant_Recommend_Go,
    Color(0.6196078431372549, 0.33725490196078434, 0 / 255)
  },
  RECEIVE = {
    "com_btn_3s",
    ZhString.Servant_Recommend_Receive,
    Color(0.1607843137254902, 0.4117647058823529, 0 / 255)
  },
  RECEIVED = {
    "com_btn_3s",
    ZhString.Servant_Recommend_Received,
    Color(0.48627450980392156, 0.48627450980392156, 0.48627450980392156)
  }
}
local typeCfgColor = {
  [1] = "[ffa0bf]",
  [2] = "[6ca7ff]",
  [3] = "[ffd44f]",
  [4] = "[bde379]",
  [5] = "[dbb8ef]"
}
function ServantRecommendCell:Init()
  ServantRecommendCell.super.Init(self)
  self:FindObjs()
  self:AddUIEvts()
end
function ServantRecommendCell:FindObjs()
  self.bg = self:FindGO("Bg")
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.title = self:FindComponent("Title", UILabel)
  self.progress = self:FindComponent("Progress", UILabel)
  self.progressSlider = self:FindComponent("ProgressSlider", UISlider)
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnLab = self:FindComponent("BtnText", UILabel)
  self.finishedFlag = self:FindGO("FinishedImg")
  self.difficulty = self:FindGO("Difficulty")
  self.newRewardIcon = self:FindComponent("Reward", UISprite)
  self.newRewardNum = self:FindComponent("RewardNum", UILabel)
  self.pagePfb = self:FindGO("PagePfb")
  self.pageWidget = self:FindComponent("PageWidget", UIWidget)
  self.PageText1 = self:FindComponent("PageText1", UILabel)
  self.PageBg1 = self:FindComponent("PageBg", UISprite, self.PageText1.gameObject)
  self.PageText2 = self:FindComponent("PageText2", UILabel)
  self.PageBg2 = self:FindComponent("PageBg", UISprite, self.PageText2.gameObject)
  self.PageText3 = self:FindComponent("PageText3", UILabel)
  self.PageBg3 = self:FindComponent("PageBg", UISprite, self.PageText3.gameObject)
end
function ServantRecommendCell:AddUIEvts()
  self:AddClickEvent(self.btn.gameObject, function(obj)
    self:OnClickBtn()
  end)
end
function ServantRecommendCell:OnClickBtn()
  if ServantRecommendProxy.STATUS.GO == self.status then
    if self.data and self.data:IsActive() and not self.data.real_open then
      MsgManager.ShowMsgByID(25423)
      return
    end
    FuncShortCutFunc.Me():CallByID(self.gotoMode)
  elseif ServantRecommendProxy.STATUS.RECEIVE == self.status then
    ServiceNUserProxy.Instance:CallReceiveServantUserCmd(false, self.id)
  end
end
local reward_icon, reward_num
local CONST_GIFT_ID, CONST_GIFT_NUM, FAVOR_ICON = 700108, 1, "food_icon_10"
local tempColor = LuaColor.white
local favorCFG = GameConfig.Servant.npcFavoriteItemid or {}
function ServantRecommendCell:SetData(data)
  self.data = data
  local servantID = Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or -1
  if data then
    self.bg:SetActive(true)
    local cfg = data.staticData
    if nil == cfg then
      helplog("\229\165\179\228\187\134\228\187\138\230\151\165\230\142\168\232\141\144\229\137\141\229\144\142\231\171\175\232\161\168\228\184\141\228\184\128\232\135\180")
      return
    end
    self.id = data.id
    self.status = data.status
    self.gotoMode = cfg.GotoMode
    self.name.text = cfg.Name
    self.title.text = data.finish_time and string.format(cfg.Title, data.finish_time) or cfg.Title
    if StringUtil.IsEmpty(cfg.Progress) then
      self.progress.gameObject:SetActive(false)
    else
      self.progress.gameObject:SetActive(true)
      self.progress.text = string.format(cfg.Progress, data.finish_time)
      self.progressSlider.value = data.finish_time / tonumber(string.sub(cfg.Progress, 4))
    end
    self.difficulty:SetActive(cfg.Difficulty == 1)
    self.newRewardNum.text = "X" .. cfg.Favorability
    local cfgIcon = favorCFG[servantID] or 100
    cfgIcon = Table_Item[cfgIcon].Icon
    IconManager:SetItemIcon(cfgIcon, self.newRewardIcon)
    local exitIcon = IconManager:SetUIIcon(cfg.Icon, self.icon)
    if not exitIcon then
      exitIcon = IconManager:SetItemIcon(cfg.Icon, self.icon)
      if not exitIcon then
      end
    end
    self.icon:MakePixelPerfect()
    ColorUtil.WhiteUIWidget(self.btn)
    if ServantRecommendProxy.STATUS.FINISHED == data.status then
      self:_setBtnStatue(false)
    elseif ServantRecommendProxy.STATUS.RECEIVE == data.status then
      self:_setBtnStatue(true, btnStatus.RECEIVE)
    elseif ServantRecommendProxy.STATUS.GO == data.status then
      self:_setBtnStatue(true, btnStatus.GO)
    end
    self:SetPage(cfg)
  else
    self.bg:SetActive(false)
  end
end
local pageCFG = GameConfig.Servant.ServantRecommendPageType
local CONST_INTERVAL = 10
local tempVector3 = LuaVector3.zero
local CONST_BGWIDTH = 16
function ServantRecommendCell:SetPage(cfg)
  if cfg.PageType[1] then
    self.PageText1.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[1]].color)
    if result then
      self.PageBg1.color = value
    end
    self.PageText1.text = pageCFG[cfg.PageType[1]].name
    self.PageBg1.width = CONST_BGWIDTH + self.PageText1.width
    self.pageWidget:ResetAndUpdateAnchors()
  else
    self.PageText1.gameObject:SetActive(false)
  end
  if cfg.PageType[2] then
    self.PageText2.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[2]].color)
    if result then
      self.PageBg2.color = value
    end
    self.PageText2.text = pageCFG[cfg.PageType[2]].name
    self.PageBg2.width = CONST_BGWIDTH + self.PageText2.width
    local x = CONST_INTERVAL + self.PageBg1.width
    tempVector3:Set(x, 0, 0)
    self.PageText2.gameObject.transform.localPosition = tempVector3
  else
    self.PageText2.gameObject:SetActive(false)
  end
  if cfg.PageType[3] then
    self.PageText3.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[3]].color)
    if result then
      self.PageBg3.color = value
    end
    self.PageText3.text = pageCFG[cfg.PageType[3]].name
    self.PageBg3.width = CONST_BGWIDTH + self.PageText3.width
    local x = CONST_INTERVAL * 2 + self.PageBg2.width + self.PageBg1.width
    tempVector3:Set(x, 0, 0)
    self.PageText3.gameObject.transform.localPosition = tempVector3
  else
    self.PageText3.gameObject:SetActive(false)
  end
end
function ServantRecommendCell:_setBtnStatue(showBtn, statusCfg)
  if showBtn then
    self.btn.spriteName = statusCfg[1]
    self.btnLab.text = statusCfg[2]
    self.btnLab.effectColor = statusCfg[3]
  end
  self.btn.gameObject:SetActive(showBtn)
  self.finishedFlag:SetActive(not showBtn)
end
