autoImport("GainWayTip")
autoImport("SystemUnLockView")
autoImport("TeamPwsMatchPopUp")
autoImport("MatchPreparePopUp")
MainViewMenuPage = class("MainViewMenuPage", SubView)
autoImport("MainViewButtonCell")
autoImport("PersonalPicturePanel")
autoImport("DoujinshiButtonCell")
function MainViewMenuPage:Init()
  self:InitUI()
  self:MapViewInterests()
end
function MainViewMenuPage:InitUI()
  self.moreBtn = self:FindGO("MoreButton")
  self.moreBord = self:FindGO("MoreBord")
  self.moreGrid = self:FindComponent("Grid", UIGrid, self.moreBord)
  self.topRFuncGrid = self:FindComponent("TopRightFunc", UIGrid)
  self.topRFuncGrid2 = self:FindComponent("TopRightFunc2", UIGrid)
  self.rewardBtn = self:FindGO("RewardButton")
  self.newMail = self:FindComponent("NewMail", UISprite)
  self.tempAlbumButton = self:FindGO("TempAlbumButton")
  self.exchangeShopPos = self:FindGO("ExchangeShopPos")
  self.exchangeShopButton = self:FindGO("ExchangeShopBtn")
  self.exchangeShopEffCtn = self:FindGO("exchangeBtnEffectContainer")
  self.exchangeShopLabel = self:FindGO("Label", self.exchangeShopButton):GetComponent(UILabel)
  self.exchangeShopLabel.text = ZhString.MainviewMenu_ExchangeShop
  local exchangeImg = self:FindGO("Sprite", self.exchangeShopButton):GetComponent(UISprite)
  IconManager:SetUIIcon("Kafra_shop", exchangeImg)
  self.bagBtn = self:FindGO("BagButton")
  self.autoBattleButton = self:FindGO("AutoBattleButton")
  self.glandStatusButton = self:FindGO("GlandStatusButton")
  self:AddClickEvent(self.glandStatusButton, function(go)
    self:ToView(PanelConfig.GLandStatusListView)
  end)
  self:InitEmojiButton()
  self:InitVoiceButton()
  self:InitMenuButton()
  self:InitActivityButton()
  self:InitTeamPwsMatchButton()
  self:InitMoroccSealButton()
  self:InitSignInButton()
  self:AddClickEvent(self.rewardBtn, function(go)
    self:ToView(PanelConfig.PostView)
  end)
  self:AddClickEvent(self.tempAlbumButton, function(go)
    self:ToView(PanelConfig.TempPersonalPicturePanel)
  end)
  self:AddClickEvent(self.exchangeShopButton, function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ExchangeShopView
    })
  end)
  self:AddButtonEvent("CloseMore", nil, {hideClickSound = true})
  self:AddButtonEvent("CloseMap", nil, {hideClickSound = true})
  self:AddButtonEvent("BagButton", function()
    self:ToView(PanelConfig.Bag)
  end)
  self:AddOrRemoveGuideId(self.moreBtn, 102)
  self:AddOrRemoveGuideId(self.bagBtn, 103)
  self.tempBagButton = self:FindGO("TempBagButton")
  self.tempBagWarning = self:FindGO("Warning", self.tempBagButton)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PACK_TEMP, self.tempBagButton, 42)
  self:AddClickEvent(self.tempBagButton, function(go)
    self:ToView(PanelConfig.TempPackageView)
  end)
  local hkBtn = self:FindGO("HouseKeeperButton")
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_GROWTH, hkBtn, 42)
  RedTipProxy.Instance:RegisterUIByGroupID(11, hkBtn, 42)
  local hkLabel = self:FindComponent("Label", UILabel, hkBtn)
  hkLabel.text = ZhString.MainviewMenu_HouseKeeper
  local data = FunctionUnLockFunc.Me():GetMenuDataByPanelID(1620, MenuUnlockType.View)
  if data then
    FunctionUnLockFunc.Me():RegisteEnterBtn(FunctionUnLockFunc.Me():GetMenuId(data), hkBtn)
  end
  self:AddButtonEvent("HouseKeeperButton", function()
    if Game.InteractNpcManager:IsMyselfOnNpc() then
      MsgManager.ShowMsgByID(25417)
      return
    end
    local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
    local currentMapID = Game.MapManager:GetMapID()
    local isRaid = Game.MapManager:IsRaidMode() and currentMapID ~= 10001 or curImageId > 0
    if isRaid then
      MsgManager.ShowMsgByID(25417)
      return
    end
    local myServantid = Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or 0
    if myServantid ~= 0 then
      self:ToView(PanelConfig.ServantNewMainView)
    else
      MsgManager.ConfirmMsgByID(25405, function()
        FuncShortCutFunc.Me():CallByID(1005)
      end)
    end
  end)
  self:InitActivityBtn()
  self:InitBooth()
  self.worldBossBtn = self:FindGO("WorldBossBtn")
  self.worldBossTipAnchor = self:FindGO("WorldbossTipAnchor"):GetComponent(UIWidget)
  self.str = ""
  self.worldBossMap = ""
  self.time = self:FindGO("worldBossCd"):GetComponent(UILabel)
  self.worldBossTime = 0
  self:InitKFC()
  self:InitPocketLottery()
  if self:CheckPuzzleValidation() then
    if not self.puzzletimeTick then
      self.puzzletimeTick = TimeTickManager.Me():CreateTick(0, 30000, self.RefreshActivityPuzzleRedTip, self, 30)
    end
  elseif self.puzzletimeTick then
    TimeTickManager.Me():ClearTick(self, 30)
    self.puzzletimeTick = nil
  end
  self:UpdateReservationTick()
end
function MainViewMenuPage:UpdateReservationTick()
  if ServantCalendarProxy.Instance:CheckReservationDateValid() then
    if not self.reservationTimeTick then
      self.reservationTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateDialogForServation, self, 31)
    end
  elseif self.reservationTimeTick then
    TimeTickManager.Me():ClearTick(self, 31)
    self.reservationTimeTick = nil
  end
end
local TIMESTAMP = GameConfig.Servant.playNpcTalkTimeStamp or 120
local SERVANT_NPC_TALK_DIALOG = GameConfig.Servant.npcTalkDialogID
local SERVANT_VOICE = GameConfig.Servant.StefanieReservationVoice
local weakDialog = {}
function MainViewMenuPage:UpdateDialogForServation()
  if not SERVANT_NPC_TALK_DIALOG then
    return
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  local bookData = ServantCalendarProxy.Instance:GetBookingData()
  for timeKey, acts in pairs(bookData) do
    for i = 1, #acts do
      local year = tonumber(os.date("%Y", timeKey))
      local month = tonumber(os.date("%m", timeKey))
      local day = tonumber(os.date("%d", timeKey))
      local actData = CalendarActivityData.new(acts[i], year, month, day)
      local starttimestamp = actData:GetStartTimeStamp()
      local actName = actData:GetActName()
      if starttimestamp - math.floor(curServerTime) == TIMESTAMP then
        local servantID = Game.Myself.data.userdata:Get(UDEnum.SERVANTID)
        local dialogID = SERVANT_NPC_TALK_DIALOG[servantID]
        local dialog = DialogUtil.GetDialogData(dialogID)
        if dialog then
          TableUtility.TableClear(weakDialog)
          weakDialog.Speaker = dialog.Speaker
          weakDialog.Text = string.format(dialog.Text, actName)
          self:sendNotification(MyselfEvent.AddWeakDialog, weakDialog)
          if not StringUtil.IsEmpty(SERVANT_VOICE) then
            AudioUtil.PlayNpcVisitVocal(SERVANT_VOICE)
          end
        end
      end
    end
  end
end
function MainViewMenuPage:ResetDepth(gameObject)
  local _UISprite = gameObject:GetComponent(UISprite)
  local activity_texture = self:FindGO("activity_texture", gameObject)
  local activity_label = self:FindGO("activity_label", gameObject)
  local holderSp = self:FindGO("holderSp", gameObject)
  local activity_texture_UITexture = activity_texture:GetComponent(UITexture)
  local activity_label_UILabel = activity_label:GetComponent(UILabel)
  local holderSp_UISprite = holderSp:GetComponent(UISprite)
  _UISprite.depth = _UISprite.depth + 30
  activity_texture_UITexture.depth = activity_texture_UITexture.depth + 30
  activity_label_UILabel.depth = activity_label_UILabel.depth + 30
  holderSp_UISprite.depth = holderSp_UISprite.depth + 30
end
function MainViewMenuPage:InitActivityBtn()
  self.TopRightFunc = self:FindGO("TopRightFunc")
  self.DoujinshiButton = self:FindGO("DoujinshiButton", self.TopRightFunc)
  self.ActivityNode = self:FindGO("ActivityNode", self.TopRightFunc)
  local closeWhenNotClickUIComp = self.ActivityNode:GetComponent("CloseWhenNotClickUI")
  closeWhenNotClickUIComp.enabled = false
  if GameConfig.System.ShieldMaskDoujinshi == 1 then
    self:Hide(self.DoujinshiButton)
    self:Show(self.ActivityNode)
    return
  else
    self:Hide(self.ActivityNode)
    self:Show(self.DoujinshiButton)
  end
  self.DoujinshiSprite_UISpirte = self:FindGO("Sprite", self.DoujinshiButton):GetComponent(UISprite)
  IconManager:SetUIIcon("Community", self.DoujinshiSprite_UISpirte)
  local menuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.NoviceCommunity or 9
  FunctionUnLockFunc.Me():RegisteEnterBtn(menuid, self.DoujinshiButton)
  self.Label_UILabel = self:FindGO("Label", self.DoujinshiButton):GetComponent(UILabel)
  self.Label_UILabel.text = ZhString.MainviewMenu_ChuXinSheQu
  self.DoujinshiNode = self:FindGO("DoujinshiNode")
  self.DoujinshiNode.gameObject:SetActive(false)
  self.doujinshiGrid = self:FindComponent("ContentCt", UIGrid, self.DoujinshiNode)
  self.doujinshiGridBg = self:FindComponent("bg", UISprite, self.DoujinshiNode)
  self.activityButtonCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ActivityButtonCell"))
  self.activityButtonCellObj.transform:SetParent(self.doujinshiGrid.transform, false)
  self.activityButtonCellObj.transform.localScale = LuaVector3(1, 1, 1)
  self:ResetDepth(self.activityButtonCellObj)
  self.activityPuzzleCt = DoujinshiButtonCell.new(self.activityButtonCellObj)
  local puzzlfCfg = GameConfig.ActivityPuzzle
  if puzzlfCfg then
    local puzzleData = {
      name = puzzlfCfg.labelText,
      icon = puzzlfCfg.iconSprite
    }
    self.activityPuzzleCt:SetData(puzzleData)
  end
  self:AddClickEvent(self.activityButtonCellObj, function(go)
    if self:CheckPuzzleValidation() then
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "ActivityPuzzleView"
      })
    else
      MsgManager.ShowMsgByID(25832)
    end
  end)
  self:RegisterRedTipCheck(45, self.activityButtonCellObj, 39)
  self:RegisterRedTipCheck(45, self.DoujinshiButton, 17)
  self:RefreshActivityPuzzleRedTip()
  local temp = 0
  self:AddClickEvent(self.DoujinshiButton, function(go)
    self:RefreshActivityPuzzleRedTip()
    if not self:CheckPuzzleValidation() then
      self.activityButtonCellObj:SetActive(false)
      temp = 1
    else
      self.activityButtonCellObj:SetActive(true)
      temp = 0
    end
    if self.DoujinshiNode.gameObject.activeInHierarchy then
      self.DoujinshiNode.gameObject:SetActive(false)
    else
      self.DoujinshiNode.gameObject:SetActive(true)
      self.doujinshiGridBg.width = 50 + 105 * (self.doujinshiGrid.transform.childCount - temp)
    end
    self.doujinshiGrid:Reposition()
  end)
  self.DoujinshiWorkBtnButton = self:FindGO("DoujinshiWorkBtnButton", self.DoujinshiNode)
  self.DoujinshiWorkBtnButtonSprite_UISprite = self:FindGO("Sprite", self.DoujinshiWorkBtnButton):GetComponent(UISprite)
  IconManager:SetUIIcon("Fellow", self.DoujinshiWorkBtnButtonSprite_UISprite)
  self.Label_UILabel = self:FindGO("Label", self.DoujinshiWorkBtnButton):GetComponent(UILabel)
  self.Label_UILabel.text = ZhString.MainviewMenu_TongRen
  self:AddClickEvent(self.DoujinshiWorkBtnButton, function(go)
    self.DoujinshiNode.gameObject:SetActive(false)
    if ApplicationInfo.IsIOSVersionUnder8() then
      MsgManager.ShowMsgByID(25717)
      return
    end
    if ApplicationInfo.IsWindows() then
      local url = "https://rotr.xd.com"
      local functionSdk = FunctionLogin.Me():getFunctionSdk()
      if functionSdk and functionSdk:getToken() then
        helplog("\230\138\147\229\136\176token")
        helplog("functionSdk:getToken():" .. functionSdk:getToken())
        local finalurl = string.format("https://api.xd.com/v1/user/get_login_url?access_token=%s&redirect=https://rotr.xd.com", functionSdk:getToken())
        Game.WWWRequestManager:SimpleRequest(finalurl, 5, function(www)
          local content = www.text
          local jsonRequest = json.decode(content)
          if jsonRequest and jsonRequest.login_url then
            url = jsonRequest.login_url
            Application.OpenURL(url)
          else
            url = "https://rotr.xd.com"
            Application.OpenURL(url)
          end
        end, function(www, error)
          url = "https://rotr.xd.com"
          Application.OpenURL(url)
        end, function(www)
          url = "https://rotr.xd.com"
          Application.OpenURL(url)
        end)
      else
        helplog("\230\178\161\230\156\137\230\138\147\229\136\176token")
        url = "https://rotr.xd.com"
        Application.OpenURL(url)
        break
      end
    else
      local functionSdk = FunctionLogin.Me():getFunctionSdk()
      if functionSdk and functionSdk:getToken() then
        helplog("\230\138\147\229\136\176token")
        helplog("functionSdk:getToken():" .. functionSdk:getToken())
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.WebviewPanel,
          viewdata = {
            token = functionSdk:getToken()
          }
        })
      else
        helplog("\230\178\161\230\156\137\230\138\147\229\136\176token")
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.WebviewPanel,
          viewdata = {token = nil}
        })
      end
    end
  end)
  self.doujinshiGrid:Reposition()
end
function MainViewMenuPage:InitMenuButton()
  self.menuCtl = UIGridListCtrl.new(self.moreGrid, MainViewButtonCell, "MainViewButtonCell")
  self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)
  self.menuCtl:AddEventListener(MainViewButtonEvent.ResetPosition, self.ResetMenuButtonPosition, self)
  self:UpdateMenuDatas()
end
function MainViewMenuPage:InitEmojiButton()
  local emojiButton = self:FindGO("EmojiButton")
  FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.ChatEmojiView.id, emojiButton)
  self:AddClickEvent(emojiButton, function()
    if not self.isEmojiShow then
      self:ToView(PanelConfig.ChatEmojiView)
    else
      self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
    end
  end)
end
function MainViewMenuPage:InitSetView()
  self.SetView_CloseButton = self:FindGO("CloseButton", self.SetView)
  self.SetView_MainBoard = self:FindGO("MainBoard", self.SetView)
  self.SetView_MainBoard_MainPage = self:FindGO("MainPage", self.SetView_MainBoard)
  self.SetView_MainBoard_MainPage_CloseBtn = self:FindGO("CloseBtn", self.SetView_MainBoard_MainPage)
  self.TeamChannelToggle = self:FindGO("TeamChannelToggle")
  self.TeamChannelToggle_UIToggle = self:FindGO("TeamChannelToggle"):GetComponent(UIToggle)
  self.GuildChannelToggle = self:FindGO("GuildChannelToggle")
  self.GuildChannelToggle_UIToggle = self:FindGO("GuildChannelToggle"):GetComponent(UIToggle)
  self.GuildChannel = self:FindGO("GuildChannel")
  self.GuildChannel_UILabel = self:FindGO("GuildChannel"):GetComponent(UILabel)
  self.GuildChannel_UILabel.text = ZhString.VoiceString.GuildChannel
  self:AddClickEvent(self.SetView_CloseButton, function()
    self.SetView.gameObject:SetActive(false)
  end)
  self:AddClickEvent(self.SetView_MainBoard_MainPage_CloseBtn, function()
    self.SetView.gameObject:SetActive(false)
  end)
  self:AddClickEvent(self.TeamChannelToggle_UIToggle.gameObject, function(obj)
    if self.LastToggleIsTeamToggle == true then
      return
    end
    self.LastToggleIsTeamToggle = true
    GVoiceProxy.Instance:SwitchChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
  end)
  self:AddClickEvent(self.GuildChannelToggle_UIToggle.gameObject, function(obj)
    if self.LastToggleIsTeamToggle == false then
      return
    end
    self.LastToggleIsTeamToggle = false
    GVoiceProxy.Instance:SwitchChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
  end)
end
function MainViewMenuPage:InitVoiceButton()
  self.SetView = self:FindGO("SetView")
  if self.SetView then
    self.SetView.gameObject:SetActive(false)
    self:InitSetView()
    self.ButtonGrid = self:FindGO("ButtonGrid")
    self.ButtonGrid_UIGrid = self:FindGO("ButtonGrid"):GetComponent(UIGrid)
    self.TeamVoice = self:FindGO("TeamVoice", self.ButtonGrid)
    self.GuildVoice = self:FindGO("GuildVoice", self.ButtonGrid)
    self.VoiceFunc = self:FindGO("VoiceFunc", self.ButtonGrid)
    self.TeamVoiceSprite_UISprite = self:FindGO("Sprite", self.TeamVoice):GetComponent(UISprite)
    self.GuildVoiceSprite_UISprite = self:FindGO("Sprite", self.GuildVoice):GetComponent(UISprite)
    self.TeamVoice_VoiceOption = self:FindGO("VoiceOption", self.TeamVoice)
    self.GuildVoice_VoiceOption = self:FindGO("VoiceOption", self.GuildVoice)
    self.VoiceFunc_VoiceOption = self:FindGO("VoiceOption", self.VoiceFunc)
    self.VoiceFunc_VoiceOption.gameObject:SetActive(false)
    self.TeamVoice_VoiceOption_State_a = self:FindGO("State_a", self.TeamVoice_VoiceOption)
    self.TeamVoice_VoiceOption_State_b = self:FindGO("State_b", self.TeamVoice_VoiceOption)
    self.TeamVoice_VoiceOption_State_c = self:FindGO("State_c", self.TeamVoice_VoiceOption)
    self.TeamVoice_VoiceOption_State_d = self:FindGO("State_d", self.TeamVoice_VoiceOption)
    self.GuildVoice_VoiceOption_State_a = self:FindGO("State_a", self.GuildVoice_VoiceOption)
    self.GuildVoice_VoiceOption_State_b = self:FindGO("State_b", self.GuildVoice_VoiceOption)
    self.GuildVoice_VoiceOption_State_c = self:FindGO("State_c", self.GuildVoice_VoiceOption)
    self.GuildVoice_VoiceOption_State_d = self:FindGO("State_d", self.GuildVoice_VoiceOption)
    self.VoiceFunc_VoiceOption_State_a = self:FindGO("State_a", self.VoiceFunc_VoiceOption)
    self.VoiceFunc_VoiceOption_State_b = self:FindGO("State_b", self.VoiceFunc_VoiceOption)
    self.VoiceFunc_VoiceOption_State_c = self:FindGO("State_c", self.VoiceFunc_VoiceOption)
    self.VoiceFunc_VoiceOption_State_d = self:FindGO("State_d", self.VoiceFunc_VoiceOption)
    self.TeamVoiceSprite_UISprite.spriteName = "ui_microphone_a_JM"
    self.GuildVoiceSprite_UISprite.spriteName = "ui_microphone_a_JM"
    self.VoiceFunc.gameObject:SetActive(false)
    self.TeamVoice.gameObject:SetActive(false)
    self.GuildVoice.gameObject:SetActive(false)
    helplog("setfalse1")
  else
    helplog("setfalse2")
  end
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid:Reposition()
  end
  self.TeamVoice_VoiceOption = self:FindGO("VoiceOption", self.TeamVoice)
  self.GuildVoice_VoiceOption = self:FindGO("VoiceOption", self.GuildVoice)
  self.VoiceFunc_VoiceOption = self:FindGO("VoiceOption", self.VoiceFunc)
  self.VoiceFunc_VoiceOption.gameObject:SetActive(false)
  self.TeamVoice_VoiceOption_State_a = self:FindGO("State_a", self.TeamVoice_VoiceOption)
  self.TeamVoice_VoiceOption_State_b = self:FindGO("State_b", self.TeamVoice_VoiceOption)
  self.TeamVoice_VoiceOption_State_c = self:FindGO("State_c", self.TeamVoice_VoiceOption)
  self.TeamVoice_VoiceOption_State_d = self:FindGO("State_d", self.TeamVoice_VoiceOption)
  self.GuildVoice_VoiceOption_State_a = self:FindGO("State_a", self.GuildVoice_VoiceOption)
  self.GuildVoice_VoiceOption_State_b = self:FindGO("State_b", self.GuildVoice_VoiceOption)
  self.GuildVoice_VoiceOption_State_c = self:FindGO("State_c", self.GuildVoice_VoiceOption)
  self.GuildVoice_VoiceOption_State_d = self:FindGO("State_d", self.GuildVoice_VoiceOption)
  self.VoiceFunc_VoiceOption_State_a = self:FindGO("State_a", self.VoiceFunc_VoiceOption)
  self.VoiceFunc_VoiceOption_State_a_Sprite1 = self:FindGO("Sprite1", self.VoiceFunc_VoiceOption_State_a)
  self.VoiceFunc_VoiceOption_State_a_Sprite2 = self:FindGO("Sprite2", self.VoiceFunc_VoiceOption_State_a)
  self.VoiceFunc_VoiceOption_State_a_quan = self:FindGO("quan", self.VoiceFunc_VoiceOption_State_a)
  self.VoiceFunc_VoiceOption_State_b = self:FindGO("State_b", self.VoiceFunc_VoiceOption)
  self.VoiceFunc_VoiceOption_State_b_Sprite1 = self:FindGO("Sprite1", self.VoiceFunc_VoiceOption_State_b)
  self.VoiceFunc_VoiceOption_State_b_Sprite2 = self:FindGO("Sprite2", self.VoiceFunc_VoiceOption_State_b)
  self.VoiceFunc_VoiceOption_State_b_quan = self:FindGO("quan", self.VoiceFunc_VoiceOption_State_b)
  self.VoiceFunc_VoiceOption_State_c = self:FindGO("State_c", self.VoiceFunc_VoiceOption)
  self.VoiceFunc_VoiceOption_State_c_Sprite1 = self:FindGO("Sprite1", self.VoiceFunc_VoiceOption_State_c)
  self.VoiceFunc_VoiceOption_State_c_Sprite2 = self:FindGO("Sprite2", self.VoiceFunc_VoiceOption_State_c)
  self.VoiceFunc_VoiceOption_State_c_quan = self:FindGO("quan", self.VoiceFunc_VoiceOption_State_c)
  self.VoiceFunc_VoiceOption_State_d = self:FindGO("State_d", self.VoiceFunc_VoiceOption)
  self.VoiceFunc_VoiceOption_State_d_Sprite1 = self:FindGO("Sprite1", self.VoiceFunc_VoiceOption_State_d)
  self.VoiceFunc_VoiceOption_State_d_Sprite2 = self:FindGO("Sprite2", self.VoiceFunc_VoiceOption_State_d)
  self.VoiceFunc_VoiceOption_State_d_quan = self:FindGO("quan", self.VoiceFunc_VoiceOption_State_d)
  self.VoiceFunc_VoiceOption_State_a_UISprite = self:FindGO("State_a", self.VoiceFunc_VoiceOption):GetComponent(UISprite)
  self.VoiceFunc_VoiceOption_State_b_UISprite = self:FindGO("State_b", self.VoiceFunc_VoiceOption):GetComponent(UISprite)
  self.VoiceFunc_VoiceOption_State_c_UISprite = self:FindGO("State_c", self.VoiceFunc_VoiceOption):GetComponent(UISprite)
  self.VoiceFunc_VoiceOption_State_d_UISprite = self:FindGO("State_d", self.VoiceFunc_VoiceOption):GetComponent(UISprite)
  if self.VoiceFunc_VoiceOption_State_b_Sprite1 then
  end
  self.boothBtn = self:FindGO("BoothShoppingBtn")
  self.boothBtn:SetActive(false)
  self.topRFuncGrid2:Reposition()
end
function MainViewMenuPage:UpdateWorldBossTip(note)
  if note and note.body then
    local worldBossData = note.body
    if not worldBossData.open then
      self.worldBossBtn:SetActive(false)
    else
      local menuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.DeadBoss or 9
      local menuOpen = FunctionUnLockFunc.Me():CheckCanOpen(menuid)
      if menuOpen then
        self.worldBossBtn:SetActive(true)
        if worldBossData.mapid and Table_Map[worldBossData.mapid] then
          self.worldBossMap = Table_Map[worldBossData.mapid].NameZh
        end
        self.str = string.format(ZhString.MVP_WorldBoss_Tip, self.worldBossMap)
        self:AddClickEvent(self.worldBossBtn, function()
          self.normalTip = TipManager.Instance:ShowNormalTip(self.str, self.worldBossTipAnchor, NGUIUtil.AnchorSide.Center, {-135, 62})
        end)
        if worldBossData.time then
          self.worldBossTime = worldBossData.time
          if self.bosstimeTick == nil then
            self.bosstimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateWorldbossTick, self, 11)
          end
        end
      end
    end
    self.topRFuncGrid2:Reposition()
  end
end
function MainViewMenuPage:UpdateWorldbossTick()
  local time = self.worldBossTime
  if time == 0 then
    if self.bosstimeTick ~= nil then
      TimeTickManager.Me():ClearTick(self, 11)
      self.bosstimeTick = nil
      self.time.text = ZhString.Boss_Show
    end
    return
  end
  local deltaTime = ServerTime.ServerDeltaSecondTime(time * 1000)
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(deltaTime)
  if deltaTime <= 0 then
    if self.bosstimeTick ~= nil then
      TimeTickManager.Me():ClearTick(self, 11)
      self.bosstimeTick = nil
      self.time.text = ZhString.Boss_Show
    end
  else
    self.time.text = string.format("%02d:%02d", min, sec)
  end
end
function MainViewMenuPage:ResetWorldBossTip()
  self.worldBossBtn:SetActive(false)
end
function MainViewMenuPage:EnterVoiceChannel(data)
  if self.VoiceFuncSprite1_UISprite then
    if GVoiceProxy.Instance.LastMicState_IsMicOpen == false then
      self.VoiceFuncSprite1_UISprite.spriteName = "ui_microphone_b_JM"
    else
      self.VoiceFuncSprite1_UISprite.spriteName = "ui_microphone_c_JM"
    end
    if GVoiceProxy.Instance.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
      self.VoiceFuncSprite2_UISprite.spriteName = "com_txt2_voice2"
      self.VoiceFuncSprite2_UISprite.gameObject:SetActive(true)
    elseif GVoiceProxy.Instance.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then
      self.VoiceFuncSprite2_UISprite.spriteName = "com_txt_voice2"
      self.VoiceFuncSprite2_UISprite.gameObject:SetActive(true)
    else
      self.VoiceFuncSprite2_UISprite.gameObject:SetActive(false)
    end
  end
end
function MainViewMenuPage:InitActivityButton()
  self.activityCtl = UIGridListCtrl.new(self.moreGrid, MainViewButtonCell, "MainViewButtonCell")
  self.activityCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)
  self.activityCtl:AddEventListener(MainViewButtonEvent.ResetPosition, self.ResetMenuButtonPosition, self)
  self:UpdateActivityDatas()
end
function MainViewMenuPage:InitBooth()
  self.boothBtn = self:FindGO("BoothShoppingBtn")
  self.boothSprite = self:FindGO("Sprite", self.boothBtn):GetComponent(UIMultiSprite)
  local menuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.BoothShopping or 9
  local unlock = FunctionUnLockFunc.Me():CheckCanOpen(menuid)
  if not unlock then
    self:_StartBooth(0)
  end
  self:AddClickEvent(self.boothBtn, function()
    if self:_TryGetMainViewBooth() == 1 then
      local id = 25821
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
      if dont == nil then
        MsgManager.DontAgainConfirmMsgByID(id, function()
          self:_StartBooth(0)
        end)
      else
        self:_StartBooth(0)
      end
    else
      self:_StartBooth(1)
    end
  end)
  local _Booth = GameConfig.Booth
  FunctionSceneFilter.Me():StartFilter(_Booth.booth_screenFilterID)
  local currentState, time = self:_TryGetMainViewBooth()
  if currentState ~= 1 and ServerTime.CurServerTime() > time + _Booth.shoppingMode_reset then
    LocalSaveProxy.Instance:SetMainViewBooth(1)
  end
  self:UpdateBoothInfo()
end
function MainViewMenuPage:InitKFC()
  self.KFCBtn = self:FindGO("KFCBtn")
  if KFCARCameraProxy.Instance:CheckDateValidByBranch() or KFCARCameraProxy.Instance:SelfTest() then
    self.KFCBtn.gameObject:SetActive(true)
  else
    self.KFCBtn.gameObject:SetActive(false)
    helplog("KFC\228\184\141\229\156\168\230\180\187\229\138\168\230\151\182\233\151\180")
  end
  self:AddClickEvent(self.KFCBtn, function()
    KFCARCameraProxy.Instance:JumpPanel()
  end)
end
function MainViewMenuPage:InitPocketLottery()
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return
  end
  self:InitAddCreditButton()
  self:PocketLotteryChangeLocationOfButtons()
  self:InitPocketLotteryEntrance()
end
function MainViewMenuPage:InitAddCreditButton()
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return
  end
  helplog(" MainViewMenuPage:InitAddCreditButton")
  self.addCreditButton = self:CopyGameObject(self.DoujinshiButton, self.topRFuncGrid)
  self.addCreditButton.name = "AddCreditButton"
  self.addCreditButton:SetActive(true)
  self.addCreditButton.transform:SetSiblingIndex(0)
  self:SetSpriteAndLabel(self.addCreditButton, "Recharge_gold", ZhString.PocketLottery_AddCredit)
  self.addCreditNode = self:FindGO("DoujinshiNode", self.addCreditButton)
  self.addCreditNode.name = "AddCreditNode"
  self.addCreditGrid = self:FindComponent("ContentCt", UIGrid, self.addCreditNode)
  self.addCreditGridBg = self:FindComponent("bg", UISprite, self.addCreditNode)
  local childCount = self.addCreditGrid.transform.childCount
  if childCount > 0 then
    for i = childCount - 1, 0, -1 do
      GameObject.DestroyImmediate(self.addCreditGrid.transform:GetChild(i).gameObject)
    end
  end
  self:AddClickEvent(self.addCreditButton, function()
    self:SetAddCreditNodeActive(not self.addCreditNode.activeSelf)
  end)
  self.addCreditButton:SetActive(true)
end
function MainViewMenuPage:PocketLotteryChangeLocationOfButtons()
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return
  end
  local cells = self.menuCtl:GetCells()
  for i = 1, #cells do
    local cdata = cells[i].data
    local staticData = cdata.staticData
    if cdata.type == MainViewButtonType.Menu and staticData and staticData.panelid == Table_MainViewButton[11].panelid then
      local depositGO = cells[i].gameObject
      depositGO.name = "Deposit"
      depositGO.transform:SetParent(self.addCreditGrid.transform, false)
      self:ResetPocketLotteryButtonDepth(depositGO)
      break
    end
  end
  self.DoujinshiButton.transform:SetParent(self.moreGrid.transform, false)
  self.ActivityNode.transform:SetParent(self.moreGrid.transform, false)
  local doujinshiBgSprite = self.DoujinshiButton:GetComponent(UISprite)
  doujinshiBgSprite.depth = 6
  self:UnLockMenuButton()
end
function MainViewMenuPage:InitPocketLotteryEntrance()
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return
  end
  self.pocketLotteryButton = self:CreatePocketLotteryButton(ZhString.PocketLottery_Lottery, "Lotterybody_S")
  self:AddClickEvent(self.pocketLotteryButton, function()
    self:ToView(PanelConfig.PocketLotteryView)
    self:SetAddCreditNodeActive(false)
  end)
  self.addCreditGrid:Reposition()
  self:SetupPocketMagicLotteryEntrance()
end
function MainViewMenuPage:SetupPocketMagicLotteryEntrance()
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return
  end
  local activityInfo = LotteryProxy.Instance:GetLotteryActivityInfo()
  local activityExists = activityInfo ~= nil and next(activityInfo) ~= nil
  if activityExists and not self.pocketLotteryMagicButton then
    self.pocketLotteryMagicButton = self:CreatePocketLotteryButton(ZhString.PocketLottery_LotteryMagic, "Lotterybody_B")
    self:AddClickEvent(self.pocketLotteryMagicButton, function()
      self:ToView(PanelConfig.PocketLotteryView, true)
      self:SetAddCreditNodeActive(false)
    end)
  end
  if self.pocketLotteryMagicButton then
    self.pocketLotteryMagicButton:SetActive(activityExists)
  end
  self:SetAddCreditNodeActive(false)
end
local ZenyID = 999
local isValid
local forbidFlag = FuncZenyShop.isWindowsZenyShopForbid()
function MainViewMenuPage:UpdateMenuDatas()
  self.mainButtonDatas = {}
  for k, v in pairs(Table_MainViewButton) do
    isValid = v.id ~= ZenyID or not forbidFlag
    if isValid then
      local data = {}
      data.type = MainViewButtonType.Menu
      data.staticData = v
      table.insert(self.mainButtonDatas, data)
    end
  end
  table.sort(self.mainButtonDatas, function(a, b)
    return a.staticData.id < b.staticData.id
  end)
  self.menuCtl:ResetDatas(self.mainButtonDatas)
  local cells = self.menuCtl:GetCells()
  for i = 1, #cells do
    local cdata = cells[i].data
    if cdata.type == MainViewButtonType.Menu then
      local go = cells[i].gameObject
      local data = cdata.staticData
      if data then
        if data.redtiptype and #data.redtiptype > 0 then
          self:RegisterRedTipCheckByIds(data.redtiptype, self.moreBtn, 42)
          self:RegisterRedTipCheckByIds(data.redtiptype, go, 42)
        end
        if data.GroupID and 0 < #data.GroupID then
          for i = 1, #data.GroupID do
            local groupId = data.GroupID[i]
            RedTipProxy.Instance:RegisterUIByGroupID(groupId, self.moreBtn, 42)
            RedTipProxy.Instance:RegisterUIByGroupID(groupId, go, 42)
          end
        end
        FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(data.panelid, go)
        local guideId = data.guideiconID
        if guideId then
          self:AddOrRemoveGuideId(go, guideId)
        end
      end
    end
  end
  self:ResetMenuButtonPosition()
end
function MainViewMenuPage:UpdateActivityDatas()
  self.activityDatas = {}
  for _, aData in pairs(Table_OperationActivity) do
    if aData.Type == 1 then
      local data = {}
      data.type = MainViewButtonType.Activity
      data.staticData = aData
      table.insert(self.activityDatas, data)
    end
  end
  self.activityCtl:ResetDatas(self.activityDatas)
  self:ResetMenuButtonPosition()
end
function MainViewMenuPage:ClickButton(cellctl)
  local data = cellctl.data
  if data then
    if data.type == MainViewButtonType.Menu then
      local sData = data.staticData
      if sData.panelid == PanelConfig.PhotographPanel.id then
        if self.isEmojiShow then
          self.isEmojiShow = false
          self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
        end
        self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid))
      elseif sData.panelid == PanelConfig.CreateChatRoom.id then
        local handed, handowner = Game.Myself:IsHandInHand()
        if handed and not handowner then
          MsgManager.ShowMsgByIDTable(824)
          return
        end
        if Game.Myself:IsInBooth() then
          MsgManager.ShowMsgByID(25708)
          return
        end
        self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid))
      elseif sData.panelid == PanelConfig.PvpMainView.id then
        if PvpProxy.Instance:IsSelfInPvp() then
          MsgManager.ShowMsgByID(951)
        elseif PvpProxy.Instance:IsSelfInGuildBase() then
          MsgManager.ShowMsgByID(983)
        elseif Game.Myself:IsDead() then
          MsgManager.ShowMsgByID(2500)
        elseif Game.Myself:IsInBooth() then
          MsgManager.ShowMsgByID(25708)
        else
          self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
        end
      else
        self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
      end
      self:Hide(self.moreBord)
    elseif data.type == MainViewButtonType.Activity then
      local sData = data.staticData
      self:ToView(PanelConfig.TempActivityView, {Config = sData})
    end
  end
end
function MainViewMenuPage:ResetMenuButtonPosition()
  self.moreGrid.repositionNow = true
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid.repositionNow = true
  end
end
function MainViewMenuPage:HandleUpdatetemScene()
  local bRet = AdventureDataProxy.Instance:HasTempSceneryExsit()
  if bRet then
    self:Show(self.tempAlbumButton)
  else
    self:Hide(self.tempAlbumButton)
  end
end
function MainViewMenuPage:HandleExchangeShopBtnEffect()
  self.exchangeShopPos:SetActive(ExchangeShopProxy.Instance:CanOpen())
  self.topRFuncGrid2.repositionNow = true
end
function MainViewMenuPage:UpdateRewardButton()
  if not self.rewardBtn.activeSelf then
    self.rewardBtn:SetActive(true)
  end
  local newpost = PostProxy.Instance:GetNewPost()
  self.newMail.gameObject:SetActive(#newpost > 0)
  self.newMail:MakePixelPerfect()
  self.topRFuncGrid2:Reposition()
end
function MainViewMenuPage:UpdateBagNum()
  if not self.bagNum then
    self.bagNum = self:FindComponent("BagNum", UILabel, self.bagBtn)
    self.bagNum.fontSize = 14
    self.bagNum.spacingX = 0
  end
  local bagData = BagProxy.Instance.bagData
  local bagItems = bagData:GetItems()
  local uplimit = bagData:GetUplimit()
  if uplimit > 0 and uplimit <= #bagItems then
    self.bagNum.gameObject:SetActive(true)
    self.bagNum.text = #bagItems .. "/" .. uplimit
  else
    self.bagNum.gameObject:SetActive(false)
  end
end
function MainViewMenuPage:UpdateTempBagButton()
  local tempBagdatas = BagProxy.Instance.tempBagData:GetItems()
  local hasDelWarnning = false
  for i = 1, #tempBagdatas do
    if tempBagdatas[i]:GetDelWarningState() then
      hasDelWarnning = true
      break
    end
  end
  self.tempBagWarning:SetActive(hasDelWarnning)
  self.tempBagButton:SetActive(#tempBagdatas > 0)
end
function MainViewMenuPage:HandleTowerSummaryCmd(note)
  if EndlessTowerProxy.Instance:IsTeamMembersFighting() then
    MsgManager.ConfirmMsgByID(1312, function()
      ServiceInfiniteTowerProxy.Instance:CallEnterTower(0, Game.Myself.data.id)
    end, nil, nil)
  else
    self:ToView(PanelConfig.EndlessTower)
  end
end
function MainViewMenuPage:HandleEnterTower(note)
  ServiceInfiniteTowerProxy.Instance:CallEnterTower(note.body.layer, Game.Myself.data.id)
end
function MainViewMenuPage:HandleTowerInfo(note)
  self:ToView(PanelConfig.EndlessTower)
end
function MainViewMenuPage:ToView(viewconfig, viewdata)
  if viewconfig and viewconfig.id == 83 then
    PersonalPicturePanel.ViewType = UIViewType.NormalLayer
  end
  self:sendNotification(UIEvent.JumpPanel, {view = viewconfig, viewdata = viewdata})
end
function MainViewMenuPage:MapViewInterests()
  self:AddListenEvt(MainViewEvent.EmojiViewShow, self.HandleEmojiShowSync)
  self:AddListenEvt(ServiceEvent.InfiniteTowerTeamTowerSummaryCmd, self.HandleTowerSummaryCmd)
  self:AddListenEvt(MyselfEvent.DeathStatus, self.HandleDeathBegin)
  self:AddListenEvt(MyselfEvent.ReliveStatus, self.HandleReliveStatus)
  self:AddListenEvt(ServiceEvent.InfiniteTowerEnterTower, self.HandleEnterTower)
  self:AddListenEvt(ServiceEvent.InfiniteTowerTowerInfoCmd, self.HandleTowerInfo)
  self:AddListenEvt(ServiceEvent.SessionMailQueryAllMail, self.UpdateRewardButton)
  self:AddListenEvt(ServiceEvent.SessionMailMailUpdate, self.UpdateRewardButton)
  self:AddListenEvt(ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd, self.HandleUpdatetemScene)
  self:AddListenEvt(UIMenuEvent.UnRegisitButton, self.UnLockMenuButton)
  self:AddListenEvt(ServiceEvent.NUserNewMenu, self.HandleNewMenu)
  self:AddListenEvt(ItemEvent.TempBagUpdate, self.UpdateTempBagButton)
  self:AddListenEvt(TempItemEvent.TempWarnning, self.UpdateTempBagButton)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBagNum)
  self:AddListenEvt(ServiceEvent.ItemPackSlotNtfItemCmd, self.UpdateBagNum)
  self:AddListenEvt(MainViewEvent.MenuActivityOpen, self.HandleUpdateActivity)
  self:AddListenEvt(MainViewEvent.MenuActivityClose, self.HandleUpdateActivity)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleUpdateMatchInfo)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.HandleUpdateMatchInfo)
  self:AddListenEvt(MainViewEvent.UpdateMatchBtn, self.HandleUpdateMatchInfo)
  self:AddListenEvt(PVPEvent.PVP_MVPFightLaunch, self.CloseMatchInfo)
  self:AddListenEvt(PVPEvent.PVP_MVPFightShutDown, self.HandleUpdateMatchInfo)
  self:AddListenEvt(ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd, self.HandleUpdateMatchInfo)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.CloseTeamPwsInfo)
  self:AddListenEvt(PVPEvent.TeamPws_ShutDown, self.HandleUpdateMatchInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdatePublishTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdatePublishTeamInfo)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleMapLoaded)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgOpenFireGuildCmd, self.HandleGvgOpenFireGuildCmd)
  self:AddListenEvt(GVGEvent.GVG_FinalFightLaunch, self.UpdateGvgOpenFireButton)
  self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.UpdateGvgOpenFireButton)
  self:AddListenEvt(MainViewEvent.UpdateTutorMatchBtn, self.UpdateTutorMatchInfo)
  self:AddListenEvt(ServiceEvent.ChatCmdQueryRealtimeVoiceIDCmd, self.RecvChatCmdQueryRealtimeVoiceIDCmd)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.RecvSessionTeamExitTeam)
  self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.RecvGuildCmdExitGuildGuildCmd)
  self:AddListenEvt(ServiceEvent.BossCmdWorldBossNtf, self.UpdateWorldBossTip)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.ResetWorldBossTip)
  self:AddListenEvt(ExchangeShopEvent.ExchangeShopShow, self.HandleExchangeShopBtnEffect)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateExchangeShopData, self.HandleExchangeShopBtnEffect)
  self:AddListenEvt(ServiceEvent.SessionShopResetExchangeShopDataShopCmd, self.HandleExchangeShopBtnEffect)
  self:AddListenEvt(ServiceEvent.PuzzleCmdPuzzleItemNtf, self.RefreshActivityPuzzleRedTip)
  self:AddListenEvt(MoroccTimeEvent.ActivityOpen, self.HandleOpenMoroccAct)
  self:AddListenEvt(MoroccTimeEvent.ActivityClose, self.HandleCloseMoroccAct)
  self:AddListenEvt(MoroccTimeEvent.NoNextActivity, self.HandleNoNextMoroccAct)
  self:AddListenEvt(ServiceEvent.NUserSignInNtfUserCmd, self.HandleSignInNotify)
  self:AddListenEvt(NewServerSignInEvent.MapViewFromCatClose, self.HandleTryShowSignInHint)
  self:AddListenEvt(NewServerSignInEvent.MapViewClose, self.HandleTryShowFarewellSignInAnim)
  self:AddListenEvt(ServiceEvent.ItemLotteryActivityNtfCmd, self.SetupPocketMagicLotteryEntrance)
  self:AddListenEvt(ServiceEvent.NUserServantReservationUserCmd, self.UpdateReservationTick)
  self:AddListenEvt(UIMenuEvent.UnlockMenu, self.HandleUnlockMenu)
  self:AddListenEvt(XDEUIEvent.CreditNodeBack, function()
    self:SetAddCreditNodeActive(not self.addCreditNode.activeSelf)
  end)
end
function MainViewMenuPage:HandleNewMenu(note)
  if TableUtility.TableFindKey(note.body.list, GameConfig.SystemOpen_MenuId.BoothShopping) then
    self:_StartBooth(1)
  end
end
function MainViewMenuPage:HandleUnlockMenu()
  self:UpdateMatchInfo()
end
function MainViewMenuPage:RecvGuildCmdExitGuildGuildCmd(data)
end
function MainViewMenuPage:RecvSessionTeamExitTeam(data)
  self.TeamVoice.gameObject:SetActive(false)
  self:UpdatePublishTeamInfo()
end
function MainViewMenuPage:RecvChatCmdQueryRealtimeVoiceIDCmd(data)
end
function MainViewMenuPage:HandleMapLoaded(note)
  self:UpdateMatchInfo()
  self:UpdateTutorMatchInfo()
  self:UpdateBoothInfo()
  if self.matchInfo_cancelBord == nil then
    return
  end
  self.matchInfo_cancelBord:SetActive(false)
end
function MainViewMenuPage:HandleGvgOpenFireGuildCmd(note)
  self:UpdateGvgOpenFireButton()
end
function MainViewMenuPage:UpdateGvgOpenFireButton()
  self.glandStatusButton:SetActive(false)
  self.topRFuncGrid2:Reposition()
end
local tempV3 = LuaVector3()
function MainViewMenuPage:InitMatchInfo()
  if self.matchInfoButton == nil then
    self.matchInfoButton = self:FindGO("MatchInfoButton")
    self.matchInfoIcon = self:FindComponent("Sprite", UISprite, self.matchInfoButton)
    self.inMatchLabel = self:FindGO("Label", self.matchInfoButton):GetComponent(UILabel)
    self.matchInfo_cancelBord = self:FindGO("CancelBord")
    self.matchInfo_cancelBord_Bg = self:FindComponent("Bg", UISprite, self.matchInfo_cancelBord)
    self.matchInfo_cancelBord = self:FindGO("CancelBord")
    self:AddClickEvent(self.matchInfoButton, function()
      local etype, matchStatus = PvpProxy.Instance:GetNowMatchInfo()
      local isMatching, isfighting
      if etype == PvpProxy.Type.MvpFight or etype == PvpProxy.Type.PoringFight then
        isMatching = matchStatus.ismatch
        isfighting = matchStatus.isfighting
      end
      if isMatching then
        tempV3:Set(LuaGameObject.GetPosition(self.matchInfoButton.transform))
        self.matchInfo_cancelBord.transform.position = tempV3
        tempV3:Set(LuaGameObject.GetLocalPosition(self.matchInfo_cancelBord.transform))
        tempV3:Set(tempV3[1], tempV3[2] - 115, tempV3[3])
        self.matchInfo_cancelBord.transform.localPosition = tempV3
        self.matchInfo_cancelBord:SetActive(true)
        self.inMatchLabel.gameObject:SetActive(true)
        self.inMatchLabel.text = ZhString.MVPMatch_InMatch
      elseif isfighting then
        ServiceMatchCCmdProxy.Instance:CallJoinFightingCCmd(PvpProxy.Type.MvpFight)
        self.inMatchLabel.gameObject:SetActive(true)
        self.inMatchLabel.text = ZhString.MVPMatch_JoinTeam
      else
        self.matchInfo_cancelBord:SetActive(false)
        self.inMatchLabel.gameObject:SetActive(false)
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.MvpMatchView
        })
      end
    end)
    self.matchInfo_cancelButton = self:FindGO("CancelMatchButton", self.matchInfo_cancelBord)
    self:AddClickEvent(self.matchInfo_cancelButton, function(go)
      self:ClickCancelMatch()
    end)
    self.matchInfo_gotoButton = self:FindGO("GotoButton", self.matchInfo_cancelBord)
    self:AddClickEvent(self.matchInfo_gotoButton, function(go)
      self:ClickMatchGotoButton()
    end)
  end
end
local descArgs = {}
local TEAM_LV_FORMAT = "Lv.%s~Lv.%s"
local TEAM_PUBLISH_ARGS_FORMAT = [[
%s
%s
%s]]
function MainViewMenuPage:UpdatePublishTeamInfo()
  if nil == self.publishInfoButton then
    self.publishInfoButton = self:FindGO("PublishInfoButton")
    self.publishIcon = self:FindComponent("Sprite", UISprite, self.publishInfoButton)
    self.publishLab = self:FindGO("Label", self.publishInfoButton):GetComponent(UILabel)
    self.publishLab.text = ZhString.TeamMemberListPopUp_Publish
    self.publishContainer = self:FindGO("PublishContainer")
    self.cancelPublishBtn = self:FindGO("CancelPublish")
    self.publishDesc = self:FindComponent("PublishDescLab", UILabel)
    self:AddClickEvent(self.publishInfoButton, function(go)
      if self.publishContainer.activeSelf then
        self:Hide(self.publishContainer)
      else
        self:Show(self.publishContainer)
      end
    end)
    self:AddClickEvent(self.cancelPublishBtn, function()
      if not TeamProxy.Instance:CheckImTheLeader() then
        MsgManager.ShowMsgByID(374)
        return
      end
      local changeOption = {}
      local teamStateOption = {
        type = SessionTeam_pb.ETEAMDATA_STATE,
        value = SessionTeam_pb.ETEAMSTATE_FREE
      }
      table.insert(changeOption, teamStateOption)
      ServiceSessionTeamProxy.Instance:CallSetTeamOption(nil, changeOption)
    end)
  end
  local myTeam = TeamProxy.Instance.myTeam
  if not myTeam or myTeam.state ~= SessionTeam_pb.ETEAMSTATE_PUBLISH then
    self:Hide(self.publishInfoButton)
    self.topRFuncGrid2:Reposition()
    return
  end
  self:Show(self.publishInfoButton)
  self:Hide(self.publishContainer)
  descArgs[1] = Table_TeamGoals[myTeam.type].NameZh
  local pickUpMode = myTeam.pickupmode or 0
  if pickUpMode == 0 then
    descArgs[2] = ZhString.TeamMemberListPopUp_FreePick
  elseif pickUpMode == 1 then
    descArgs[2] = ZhString.TeamMemberListPopUp_RandomPick
  end
  descArgs[3] = string.format(TEAM_LV_FORMAT, tostring(myTeam.minlv), tostring(myTeam.maxlv))
  self.publishDesc.text = string.format(TEAM_PUBLISH_ARGS_FORMAT, descArgs[1], descArgs[2], descArgs[3])
  self.topRFuncGrid2:Reposition()
end
local Match_CancelMsgId_Map = {
  [PvpProxy.Type.PoringFight] = 3610,
  [PvpProxy.Type.MvpFight] = 7311
}
function MainViewMenuPage:InitTeamPwsMatchButton()
  self.teamPwsMatchButton = self:FindGO("TeamPwsMatchBtn")
  self.labTeamPwsMatchBtn = self:FindComponent("Label", UILabel, self.teamPwsMatchButton)
  OverseaHostHelper:FixLabelOverV1(self.labTeamPwsMatchBtn, 3, 70)
  self.sprTeamPwsPreCountDown = self:FindComponent("CountDownCircle", UISprite, self.teamPwsMatchButton)
  TeamPwsMatchPopUp.Anchor = self.teamPwsMatchButton.transform
  MatchPreparePopUp.Anchor = self.teamPwsMatchButton.transform
  self:AddClickEvent(self.teamPwsMatchButton, function()
    self:OnClickTeamPwsMatchBtn()
  end)
end
function MainViewMenuPage:OnClickTeamPwsMatchBtn()
  local status, etype = PvpProxy.Instance:GetCurMatchStatus()
  if status then
    if status.isprepare then
      MatchPreparePopUp.Show(etype)
    elseif status.ismatch then
      TeamPwsMatchPopUp.Show(etype)
    end
  else
    LogUtility.Error("\230\156\170\230\137\190\229\136\176\229\140\185\233\133\141\231\138\182\230\128\129\228\191\161\230\129\175\239\188\129")
    self:CloseTeamPwsInfo()
  end
end
function MainViewMenuPage:InitMoroccSealButton()
  self.moroccSealButton = self:FindGO("MoroccSealButton")
  local isMorrocTime = MoroccTimeProxy.Instance:IsInMorrocTime()
  self.moroccSealButton:SetActive(isMorrocTime)
  if not isMorrocTime then
    return
  end
  local moroccSealButtonLabel = self:FindComponent("Label", UILabel, self.moroccSealButton)
  moroccSealButtonLabel.text = ZhString.MoroccSeal_ButtonLabel
  local moroccTimeData = MoroccTimeProxy.Instance:GetCurrentMoroccTimeData()
  self:SetMoroccSealButtonState(moroccTimeData ~= nil)
  self:AddClickEvent(self.moroccSealButton, function()
    self:ToView(PanelConfig.MoroccTimePopUp)
  end)
  self.topRFuncGrid2:Reposition()
end
function MainViewMenuPage:SetMoroccSealButtonState(isOpen)
  local sprite = self:FindComponent("Sprite", UISprite, self.moroccSealButton)
  sprite.spriteName = isOpen and "Mrc_open" or "Mrc_close"
  local hintEffectGO = self:FindGO("GlowHint4", self.moroccSealButton)
  if not hintEffectGO then
    local hintResPath = ResourcePathHelper.EffectUI(EffectMap.UI.GlowHint4)
    hintEffectGO = Game.AssetManager_UI:CreateAsset(hintResPath, self.moroccSealButton)
    hintEffectGO.transform.localScale = LuaVector3.one
  end
  hintEffectGO:SetActive(isOpen)
end
function MainViewMenuPage:HandleOpenMoroccAct()
  if self.moroccSealButton and not self.moroccSealButton.activeSelf then
    self:InitMoroccSealButton()
  else
    self:SetMoroccSealButtonState(true)
  end
end
function MainViewMenuPage:HandleCloseMoroccAct()
  self:SetMoroccSealButtonState(false)
end
function MainViewMenuPage:HandleNoNextMoroccAct()
  self.moroccSealButton:SetActive(false)
  self.topRFuncGrid2:Reposition()
end
function MainViewMenuPage:InitSignInButton()
  self.signInButton = self:FindGO("SignInButton")
  local signInButtonLabel = self:FindComponent("Label", UILabel, self.signInButton)
  OverseaHostHelper:FixLabelOverV1(signInButtonLabel, 3, 70)
  signInButtonLabel.text = ZhString.NewServerSignIn_ButtonLabel
  local isShow = NewServerSignInProxy.Instance:IsSignInNotifyReceived()
  self.signInButton:SetActive(isShow)
  self.signInButtonEnabled = isShow
  if isShow then
    self:TryRegisterSignInRedTipCheck()
  end
  self:AddClickEvent(self.signInButton, function(go)
    if not self.signInButtonEnabled then
      return
    end
    if self.signInHintEffectGO and self.signInHintEffectGO.activeInHierarchy then
      GameObject.Destroy(self.signInHintEffectGO)
      self.signInHintEffectGO = nil
    end
    self:ToView(PanelConfig.NewServerSignInMapView)
  end)
  self.topRFuncGrid2:Reposition()
  local menuId = GameConfig.SystemOpen_MenuId.NewSignIn
  if menuId then
    FunctionUnLockFunc.Me():RegisteEnterBtn(menuId, self.signInButton)
  end
end
function MainViewMenuPage:TryRegisterSignInRedTipCheck()
  if not NewServerSignInProxy.Instance.isTodaySigned then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SIGNIN_DAY, self.signInButton, 29)
  end
end
function MainViewMenuPage:ClickCancelMatch()
  if self.matchType == nil then
    return
  end
  local msgId = Match_CancelMsgId_Map[self.matchType]
  if msgId == nil then
    return
  end
  MsgManager.ConfirmMsgByID(msgId, function()
    ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(self.matchType)
  end, nil, nil)
  self.matchInfo_cancelBord:SetActive(false)
end
function MainViewMenuPage:ClickMatchGotoButton()
  local actData = FunctionActivity.Me():GetActivityData(GameConfig.PoliFire.PoringFight_ActivityId or 111)
  if actData then
    FuncShortCutFunc.Me():CallByID(actData.traceId)
  end
  self.matchInfo_cancelBord:SetActive(false)
end
function MainViewMenuPage:HandleUpdateMatchInfo(note)
  self:UpdateMatchInfo()
end
function MainViewMenuPage:CloseMatchInfo()
  self.matchInfoButton:SetActive(false)
end
function MainViewMenuPage:CloseTeamPwsInfo()
  TimeTickManager.Me():ClearTick(self, 1)
  self.teamPwsMatchButton:SetActive(false)
  self.topRFuncGrid2:Reposition()
  PvpProxy.Instance:ClearTeamPwsPreInfo()
  PvpProxy.Instance:ClearTeamPwsMatchInfo()
end
local MatchInfoSprite_Map = {
  [PvpProxy.Type.PoringFight] = "main_icon_chaos",
  [PvpProxy.Type.MvpFight] = "main_icon_mvp2"
}
function MainViewMenuPage:UpdateMatchInfo(activityType)
  TimeTickManager.Me():ClearTick(self, 1)
  if Game.MapManager:IsPVPMode_MvpFight() or Game.MapManager:IsPVEMode_ExpRaid() then
    self.matchInfoButton:SetActive(false)
    self.topRFuncGrid2:Reposition()
    return
  end
  if Game.MapManager:IsPVPMode_TeamPws() then
    self.teamPwsMatchButton:SetActive(false)
    self.topRFuncGrid2:Reposition()
    return
  end
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    local btnActive
    if etype ~= PvpProxy.Type.MvpFight and etype ~= PvpProxy.Type.PoringFight then
      btnActive = matchStatus.ismatch or matchStatus.isprepare
    else
      btnActive = false
    end
    if self.teamPwsMatchButton.activeSelf ~= btnActive then
      self.teamPwsMatchButton:SetActive(btnActive)
    end
    self.sprTeamPwsPreCountDown.gameObject:SetActive(matchStatus.isprepare or false)
    self.labTeamPwsMatchBtn.text = matchStatus.isprepare and ZhString.TeamPws_Preparing or ZhString.TeamPws_InMatch
    if matchStatus.isprepare then
      self.maxTeamPwsPrepareTime = GameConfig.teamPVP.Countdown
      self.teamPwsStartPrepareTime = PvpProxy.Instance:GetTeamPwsPreStartTime()
      if self.teamPwsStartPrepareTime then
        TimeTickManager.Me():CreateTick(0, 33, self.UpdateTeamPwsPrepareTime, self, 1)
      else
        self.sprTeamPwsPreCountDown.fillAmount = 0
      end
    end
  else
    self:CloseTeamPwsInfo()
  end
  self:UpdateMVP_PoringInfo()
end
function MainViewMenuPage:UpdateMVP_PoringInfo()
  local etype, matchStatus
  etype, matchStatus = PvpProxy.Instance:GetNowMatchInfo()
  local active, isfighting
  if matchStatus then
    active = matchStatus.ismatch
    isfighting = matchStatus.isfighting
    redlog("matchStatus", matchStatus.ismatch, matchStatus.isfighting)
  else
    redlog("matchStatus nil")
  end
  self.matchType = etype
  self:InitMatchInfo()
  self.matchInfoIcon.spriteName = MatchInfoSprite_Map[etype] or ""
  local mvpActData
  local menuId = GameConfig.SystemOpen_MenuId.MVPBattle
  if menuId then
    if FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
      mvpActData = FunctionActivity.Me():GetActivityData(GameConfig.MvpBattle.ActivityID)
    end
  else
    mvpActData = FunctionActivity.Me():GetActivityData(GameConfig.MvpBattle.ActivityID)
  end
  local pollyActData = FunctionActivity.Me():GetActivityData(GameConfig.PoliFire.PoringFight_ActivityId)
  local actIsOpen = mvpActData or pollyActData
  local isInMatch = self.matchType == PvpProxy.Type.MvpFight or self.matchType == PvpProxy.Type.PoringFight
  isInMatch = isInMatch and (active or isfighting)
  if actIsOpen and isInMatch then
    self.matchInfoIcon.spriteName = MatchInfoSprite_Map[etype] or ""
    self.matchInfoButton:SetActive(true)
  elseif mvpActData then
    self.matchInfoButton:SetActive(true)
    self.matchInfoIcon.spriteName = "main_icon_mvp2"
  else
    self.matchInfoButton:SetActive(false)
    self.topRFuncGrid2:Reposition()
    return
  end
  self:Show(self.inMatchLabel)
  if etype == PvpProxy.Type.MvpFight or etype == PvpProxy.Type.PoringFight then
    if active then
      self.inMatchLabel.text = ZhString.MVPMatch_InMatch
    elseif isfighting then
      self.inMatchLabel.text = ZhString.MVPMatch_JoinTeam
    else
      self:Hide(self.inMatchLabel)
    end
  else
    self:Hide(self.inMatchLabel)
  end
  if etype == PvpProxy.Type.MvpFight then
    self.matchInfo_gotoButton:SetActive(false)
    self.matchInfo_cancelBord_Bg.height = 106
  else
    self.matchInfo_gotoButton:SetActive(true)
    self.matchInfo_cancelBord_Bg.height = 166
  end
  self.topRFuncGrid2:Reposition()
end
function MainViewMenuPage:UpdateTeamPwsPrepareTime()
  local curTime = (ServerTime.CurServerTime() - self.teamPwsStartPrepareTime) / 1000
  local leftTime = math.max(self.maxTeamPwsPrepareTime - curTime, 0)
  self.sprTeamPwsPreCountDown.fillAmount = leftTime / self.maxTeamPwsPrepareTime
  if leftTime == 0 then
    TimeTickManager.Me():ClearTick(self, 1)
  end
end
function MainViewMenuPage:HandleUpdateActivity(note)
  local activityType = note.body
  if not activityType then
    return
  end
  local cells = self.activityCtl:GetCells()
  for i = 1, #cells do
    local data = cells[i].data
    if data.type == MainViewButtonType.Activity and data.staticData.id == activityType then
      cells[i]:UpdateActivityState()
      break
    end
  end
  self:ResetMenuButtonPosition()
end
function MainViewMenuPage:GetSkillButton()
  if not self.skillButton then
    local buttons = self.activityCtl:GetCells()
    for i = 1, #buttons do
      local buttonData = buttons[i].data
      if buttonData.panelid == PanelConfig.CharactorProfessSkill.id then
        self.skillButton = buttons[i].gameObject
      end
    end
  end
  return self.skillButton
end
function MainViewMenuPage:HandleDeathBegin(note)
  self:SetTextureGrey(self.bagBtn)
  self.bagBtn:GetComponent(BoxCollider).enabled = false
  local skillButton = self:GetSkillButton()
  if skillButton then
    self:SetTextureGrey(skillButton)
    skillButton:GetComponent(BoxCollider).enabled = false
  end
end
function MainViewMenuPage:HandleReliveStatus(note)
  self:SetTextureColor(self.bagBtn, Color(1, 1, 1), true)
  self.bagBtn:GetComponent(BoxCollider).enabled = true
  self:FindComponent("Label", UILabel, self.bagBtn).effectColor = Color(0.03529411764705882, 0.10588235294117647, 0.35294117647058826)
  local skillButton = self:GetSkillButton()
  if skillButton then
    self:SetTextureColor(skillButton, Color(1, 1, 1), true)
    skillButton:GetComponent(BoxCollider).enabled = true
    self:FindComponent("Label", UILabel, skillButton).effectColor = Color(0.03529411764705882, 0.10588235294117647, 0.35294117647058826)
  end
end
function MainViewMenuPage:HandleEmojiShowSync(note)
  self.isEmojiShow = note.body
end
function MainViewMenuPage:UnLockMenuButton(id)
  self.moreGrid.repositionNow = true
  self.topRFuncGrid.repositionNow = true
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid:Reposition()
    self.ButtonGrid_UIGrid.repositionNow = true
  end
  self:InitSignInButton()
  self:UpdateMatchInfo()
  self:UpdateBoothInfo()
end
function MainViewMenuPage:OnEnter()
  MainViewMenuPage.super.OnEnter(self)
  self:UpdateRewardButton()
  self:UpdateTempBagButton()
  self:UpdateBagNum()
  self:RegisterPetAdvRedTip()
  self:HandleUpdatetemScene()
  self:HandleSignInNotify()
  self:UpdateMatchInfo()
  self:UpdatePublishTeamInfo()
  self:UpdateGvgOpenFireButton()
  self:HandleExchangeShopBtnEffect()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    if self.moreBord.gameObject.activeInHierarchy then
      self.moreBord.gameObject:SetActive(false)
    elseif UIManagerProxy.Instance:GetModalPopCount() > 0 then
      helplog("close")
      UIManagerProxy.Instance:PopView()
    else
      MsgManager.ConfirmMsgByID(27000, function()
        Application.Quit()
      end, function()
      end, nil, nil)
    end
  end)
end
function MainViewMenuPage:OnShow()
  self.topRFuncGrid2:Reposition()
end
function MainViewMenuPage:RegisterPetAdvRedTip()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PET_ADVENTURE, self.bagBtn, 42)
  self:RegisterRedTipCheck(FunctionTempItem.UseIntervalRedTip, self.bagBtn, 42)
end
function MainViewMenuPage:OnExit()
  if self.puzzletimeTick then
    TimeTickManager.Me():ClearTick(self, 30)
    self.puzzletimeTick = nil
  end
  MainViewMenuPage.super.OnExit(self)
end
function MainViewMenuPage:UpdateTutorMatchInfo()
  if not self.tutorMatchInfoBtn then
    self.tutorMatchInfoBtn = self:FindGO("TutorMatchInfoBtn")
  end
  if not self.tutorMatchInfoBtn then
    return
  end
  local status = TutorProxy.Instance:GetTutorMatStatus()
  if status == TutorProxy.TutorMatchStatus.Start then
    self.tutorMatchInfoBtn:SetActive(true)
  else
    self.tutorMatchInfoBtn:SetActive(false)
  end
  self.topRFuncGrid2:Reposition()
  self:AddClickEvent(self.tutorMatchInfoBtn, function()
    if TutorProxy.Instance:CanAsStudent() then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TutorMatchView,
        viewdata = TutorType.Tutor
      })
    elseif TutorProxy.Instance:CanAsTutor() then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TutorMatchView,
        viewdata = TutorType.Student
      })
    end
  end)
end
function MainViewMenuPage:UpdateBoothInfo()
end
function MainViewMenuPage:_TryGetMainViewBooth()
  local info = LocalSaveProxy.Instance:GetMainViewBooth()
  local split = string.split(info, "_")
  if #split > 1 then
    return tonumber(split[1]), tonumber(split[2])
  end
  return 1, ServerTime.CurServerTime()
end
function MainViewMenuPage:_StartBooth(currentState)
  LocalSaveProxy.Instance:SetMainViewBooth(currentState)
  self:UpdateBoothInfo()
end
function MainViewMenuPage:RefreshActivityPuzzleRedTip()
  local isRedPointNeedShow = ActivityPuzzleProxy.Instance:IsRedTipNeedToShow()
  if isRedPointNeedShow then
    RedTipProxy.Instance:UpdateRedTip(45)
  else
    RedTipProxy.Instance:RemoveWholeTip(45)
  end
end
function MainViewMenuPage:CheckPuzzleValidation()
  local serverTime = ServerTime.CurServerTime() / 1000
  if Table_ActivityInfo then
    for k, v in pairs(Table_ActivityInfo) do
      if serverTime > v.StartTimeStamp and serverTime < v.EndTimeStamp then
        return true
      end
    end
  end
  return false
end
function MainViewMenuPage:HandleSignInNotify()
  if self.signInHintEffectGO then
    GameObject.Destroy(self.signInHintEffectGO)
    self.signInHintEffectGO = nil
  end
  self:TryRegisterSignInRedTipCheck()
end
function MainViewMenuPage:HandleTryShowSignInHint()
  local signedCount, isTodaySigned = self:GetSignInInfo()
  if signedCount == 0 or signedCount == 1 and isTodaySigned then
    self:CreateSignInHintAsset()
  end
end
function MainViewMenuPage:HandleTryShowFarewellSignInAnim()
  local signedCount = self:GetSignInInfo()
  if signedCount >= NewServerSignInProxy.Instance.maxDayCount then
    self.signInButtonEnabled = false
    self:CreateSignInHintAsset()
    local ta = TweenAlpha.Begin(self.signInButton, 1.5, 0)
    ta.delay = 0.2
    ta:SetOnFinished(function()
      self.signInButton:SetActive(false)
      self.topRFuncGrid2:Reposition()
      NewServerSignInProxy.Instance:SetSignInNotifyNeverReceived()
    end)
  end
end
function MainViewMenuPage:GetSignInInfo()
  local signInInstance = NewServerSignInProxy.Instance
  return signInInstance.signedCount, signInInstance.isTodaySigned
end
function MainViewMenuPage:CreateSignInHintAsset()
  local hintResPath = ResourcePathHelper.EffectUI(EffectMap.UI.GlowHint4)
  self.signInHintEffectGO = Game.AssetManager_UI:CreateAsset(hintResPath, self.signInButton)
  self.signInHintEffectGO.transform.localScale = LuaVector3.one
end
function MainViewMenuPage:CreatePocketLotteryButton(name, spriteName)
  local button = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("MainViewButtonCell"))
  button.transform:SetParent(self.addCreditGrid.transform, false)
  self:SetSpriteAndLabel(button, spriteName, name)
  self:ResetPocketLotteryButtonDepth(button)
  return button
end
function MainViewMenuPage:SetSpriteAndLabel(cellGO, spriteName, labelText)
  local sprite = self:FindComponent("Sprite", UISprite, cellGO)
  if sprite then
    IconManager:SetUIIcon(spriteName, sprite)
  end
  local label = self:FindComponent("Label", UILabel, cellGO)
  if label then
    label.text = labelText
  end
end
function MainViewMenuPage:ResetPocketLotteryButtonDepth(cellGO)
  local bgSprite = cellGO:GetComponent(UISprite)
  bgSprite.depth = 37
  local sprite = self:FindComponent("Sprite", UISprite, cellGO)
  sprite.depth = 38
  local label = self:FindComponent("Label", UILabel, cellGO)
  label.depth = 39
end
function MainViewMenuPage:SetAddCreditNodeActive(isActive)
  isActive = isActive or false
  self.addCreditNode:SetActive(isActive)
  if self.addCreditNode.activeInHierarchy then
    local activeChildren = self.addCreditGrid:GetComponentsInChildren(UIButton, false)
    if not activeChildren or type(activeChildren) ~= "table" then
      return
    end
    self.addCreditGridBg.width = 50 + 105 * #activeChildren
    self.addCreditGrid:Reposition()
  end
end
