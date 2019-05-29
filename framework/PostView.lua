PostView = class("MainView", ContainerView)
PostView.ViewType = UIViewType.NormalLayer
autoImport("PostCell")
autoImport("PostItemCell")
PostView.ClickCell = "PostView_ClickCell"
PostView.ColorCfg = {
  {
    spriteName = "com_btn_0",
    effectColor = Color(0.4549019607843137, 0.01568627450980392, 0.01568627450980392, 1),
    zhstring = ZhString.Post_Delete
  },
  {
    spriteName = "com_btn_2s",
    effectColor = ColorUtil.ButtonLabelOrange,
    zhstring = ZhString.Post_Receive
  }
}
local GRAY_LABEL_COLOR = Color(0.5764705882352941, 0.5686274509803921, 0.5686274509803921, 1)
local RED_LABEL_COLOR = Color(0.4549019607843137, 0.01568627450980392, 0.01568627450980392, 1)
function PostView:Init()
  self:FindObj()
  self:AddUIEvts()
  self:InitUI()
  self:AddViewInterest()
  self:InitFilter()
  self:RefreshPostView(true)
  self:UpdateUnreadTip()
  self.postName.transform.localPosition = Vector3(200.6, 240, 0)
end
function PostView:InitFilter()
  if not self.rangeList then
    self.rangeList = PostProxy.Instance:GetFilter()
    for i = 1, #self.rangeList do
      local rangeData = GameConfig.PostFilter[self.rangeList[i]]
      self.postFilter:AddItem(rangeData, self.rangeList[i])
    end
  end
  if #self.rangeList > 0 then
    local range = self.rangeList[1]
    self.areaFilterData = range
    local rangeData = GameConfig.PostFilter[range]
    self.postFilter.value = rangeData
  end
end
function PostView:InitUI()
  self:Hide(self.delPos)
  self.unreadTip = self:FindComponent("UnreadTip", UILabel)
  self.unreadTipBg = self:FindComponent("UnreadTipBg", UIWidget)
  local postContainer = self:FindGO("PostContainer")
  local wrapConfig = {
    wrapObj = postContainer,
    cellName = "PostCell",
    control = PostCell,
    pfbNum = 5
  }
  self.postWrapHelper = WrapCellHelper.new(wrapConfig)
  self.postWrapHelper:AddEventListener(PostView.ClickCell, self.OnClickPostCell, self)
  local grid = self:FindGO("AttachGrid")
  local rewardWrap = {
    wrapObj = grid,
    cellName = "PostItemCell",
    control = PostItemCell,
    pfbNum = 6
  }
  self.attachCtl = WrapCellHelper.new(rewardWrap)
  self:DelModel(false)
end
local EMAILBG_TEX = "email_bg_02"
local EMAILLOGO_TEX = "email_bg_logo"
function PostView:FindObj()
  self.menuBtn = self:FindComponent("MenuBtn", UISprite)
  self.confirmDelBtn = self:FindGO("ConfirmDelBtn")
  self.returnBtn = self:FindGO("ReturnBtn")
  self.receiveAllBtn = self:FindComponent("ReceiveAllBtn", UISprite)
  self.receiveAllLab = self:FindComponent("Label", UIWidget, self.receiveAllBtn.gameObject)
  self.postName = self:FindComponent("PostName", UILabel)
  self.postContent = self:FindComponent("Content", UILabel)
  local postCheckObj = self:FindGO("PostCheckBtn")
  self.postCheckBtn = postCheckObj:GetComponent(UISprite)
  self.postCheckLab = self:FindComponent("Label", UILabel, postCheckObj)
  self.delPos = self:FindGO("DelPos")
  self.receiveTime = self:FindComponent("ReceiveTime", UILabel)
  self.senderName = self:FindComponent("SenderName", UILabel)
  self.attachFixedLab = self:FindComponent("AttachFixedLab", UILabel)
  self.attachFixedLab.text = ZhString.Post_AttachFixedLab
  self.infoPos = self:FindGO("InfoPos")
  self.emptyLogo = self:FindGO("EmptyLogo")
  self.viewEmptyLab = self:FindComponent("ViewEmpty", UILabel)
  self.viewEmptyLab.text = ZhString.Post_LeftEmpty
  local rightBg = self:FindComponent("RightBg", UITexture)
  local logoTexture = self:FindComponent("EmptyLogo", UITexture)
  self.contentScrollview = self:FindComponent("contentScrollView", UIScrollView)
  self.postviewScrollView = self:FindComponent("PostViewScrollView", UIScrollView)
  self.attachScrollView = self:FindComponent("AttachScrollView", UIScrollView)
  PictureManager.Instance:SetUI(EMAILBG_TEX, rightBg)
  PictureManager.Instance:SetUI(EMAILLOGO_TEX, logoTexture)
  self.postFilter = self:FindComponent("PostFilter", UIPopupList)
  self.filterPanel = self:FindGO("filterPanel")
  self.chooseAllToggle = self:FindComponent("ChooseAllToggle", UISprite)
  self.chooseAllBtn = self:FindGO("ChooseAll")
  local fixedAllLabel = self:FindComponent("FixedAllLabel", UILabel)
  fixedAllLabel.text = ZhString.Post_ChooseAll
  self.filterPanel:GetComponent(UIPanel).depth = 250
end
function PostView:SortPost(a, b)
  if a == nil or b == nil then
    return false
  end
  if a.sortID == b.sortID then
    return a.time > b.time
  else
    return a.sortID < b.sortID
  end
end
function PostView:AddUIEvts()
  self:AddClickEvent(self.receiveAllBtn.gameObject, function()
    self:OnClickReceiveAll()
  end)
  self:AddClickEvent(self.menuBtn.gameObject, function()
    self:OnClickMenuBtn()
  end)
  self:AddClickEvent(self.returnBtn, function()
    self:OnClickReturnBtn()
  end)
  self:AddClickEvent(self.confirmDelBtn, function()
    self:OnClickConfirmDel()
  end)
  self:AddClickEvent(self.postCheckBtn.gameObject, function()
    self:OnClickPostCheckBtn()
  end)
  EventDelegate.Add(self.postFilter.onChange, function()
    if not self.postFilter.data then
      return
    end
    if self.areaFilterData ~= self.postFilter.data then
      self:ResetCurPost()
      local allData = PostProxy.Instance:SetFilterData()
      local id = tonumber(self.postFilter.data)
      self.viewDatas = id == 0 and PostProxy.Instance:GetPostArray() or allData[id]
      self.areaFilterData = self.postFilter.data
      self.curFilterValue = self.postFilter.value
      PostProxy.Instance:ResetMultiChoosePosts()
      for i = 1, #self.viewDatas do
        PostProxy.Instance:SetMultiChoosePosts(self.viewDatas[i].id)
      end
      self:RefreshPostView(true)
      self.postWrapHelper:ResetPosition()
      self.postviewScrollView:ResetPosition()
    end
  end)
  self:AddClickEvent(self.chooseAllToggle.gameObject, function()
    self.chooseAllBtn:SetActive(not self.chooseAllBtn.activeSelf)
    if self.chooseAllBtn.activeSelf then
      PostProxy.Instance:ResetMultiChoosePosts()
      for i = 1, #self.viewDatas do
        PostProxy.Instance:SetMultiChoosePosts(self.viewDatas[i].id)
      end
    else
      PostProxy.Instance:ResetMultiChoosePosts()
    end
    self.postWrapHelper:ResetDatas(self.viewDatas)
  end)
end
function PostView:AddViewInterest()
  self:AddListenEvt(PostEvent.PostAdd, self.RefreshPostView)
  self:AddListenEvt(ServiceEvent.SessionMailMailUpdate, self.UpdateUnreadTip)
  self:AddListenEvt(PostEvent.PostUpdate, self.HandleUpdate)
  self:AddListenEvt(PostEvent.PostDelete, self.HandleDelPost)
end
function PostView:OnClickMenuBtn()
  local data = PostProxy.Instance:GetPostArray()
  if not data or #data <= 0 then
    return
  end
  local canDelDatas = PostProxy.Instance:GetAttachPost()
  if #canDelDatas <= 0 then
    MsgManager.ShowMsgByID(33101)
    return
  end
  self:DelModel(true)
  self:ResetCurPost()
  self:RefreshPostView(true)
  PostProxy.Instance:ResetMultiChoosePosts()
  for i = 1, #self.viewDatas do
    PostProxy.Instance:SetMultiChoosePosts(self.viewDatas[i].id)
  end
  self:RefreshChooseAllBtn()
  self.postWrapHelper:ResetDatas(self.viewDatas)
  self.postviewScrollView:ResetPosition()
end
function PostView:RefreshChooseAllBtn()
  self.chooseAllBtn:SetActive(nil ~= self.viewDatas and 0 ~= #self.viewDatas and #PostProxy.Instance.multiChoosePost == #self.viewDatas)
end
function PostView:OnClickReturnBtn()
  self:DelModel(false)
  self.postFilter.value = GameConfig.PostFilter[0]
  self:UpdateReveiveAllBtn()
end
function PostView:OnClickPostCheckBtn()
  if not self.curPost then
    return
  end
  if self.curPost:CheckAttachValid() then
    ServiceSessionMailProxy.Instance:CallGetMailAttach({
      self.curPost.id
    })
  else
    ServiceSessionMailProxy.Instance:CallMailRemove({
      self.curPost.id
    })
  end
end
function PostView:OnClickConfirmDel()
  if #PostProxy.Instance.multiChoosePost <= 0 then
    MsgManager.ShowMsgByID(33102)
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(33100)
  if nil == dont then
    MsgManager.DontAgainConfirmMsgByID(33100, function()
      PostProxy.Instance:RemovePosts()
    end, nil, nil, #PostProxy.Instance.multiChoosePost)
  else
    PostProxy.Instance:RemovePosts()
  end
end
function PostView:OnClickReceiveAll()
  if PostProxy.Instance:CheckAllReceived() or self.DEL_MOD then
    return
  end
  local mailIDlist = {}
  local postDatas = PostProxy.Instance:GetPostArray()
  for i = 1, #postDatas do
    if not postDatas[i]:IsAttachStatus() then
      mailIDlist[#mailIDlist + 1] = postDatas[i].id
    end
  end
  ServiceSessionMailProxy.Instance:CallGetMailAttach(mailIDlist)
end
function PostView:DelModel(enterDelMod)
  self.DEL_MOD = enterDelMod
  if enterDelMod then
    self.areaFilterData = nil
    self:Show(self.delPos)
    self:Hide(self.filterPanel)
    self.menuBtn.gameObject:SetActive(false)
  else
    self:Hide(self.delPos)
    self:Show(self.filterPanel)
    self.menuBtn.gameObject:SetActive(true)
    PostProxy.Instance:ResetMultiChoosePosts()
  end
  self:ResetCurPost()
  self:ShowMultiBox(enterDelMod)
end
function PostView:ResetCurPost()
  self.curPost = nil
  local cellCtls = self.postWrapHelper:GetCellCtls()
  for _, cell in pairs(cellCtls) do
    cell:SetChooseId()
  end
end
function PostView:ShowMultiBox(var)
  local cellCtls = self.postWrapHelper:GetCellCtls()
  for _, cell in pairs(cellCtls) do
    cell:ShowMultiBox(var)
  end
end
function PostView:RefreshInfoView()
  local data = self.curPost
  if not data or true == self.DEL_MOD then
    self:Hide(self.infoPos)
    self:Show(self.emptyLogo)
    return
  end
  self:Show(self.infoPos)
  self:Hide(self.emptyLogo)
  self.postName.text = data.title
  self.postContent.text = data.msg
  if data:IsRealAttach() then
    self:Show(self.receiveTime)
    self.receiveTime.text = string.format(ZhString.Post_ReceiveTime, os.date("%Y-%m-%d", data.attachtime))
  else
    self:Hide(self.receiveTime)
  end
  self.attachScrollView.gameObject:SetActive(data:HasPostItems())
  self.attachFixedLab.gameObject:SetActive(data:HasPostItems())
  self.senderName.text = data.sendername
  local cfg = data:CheckAttachValid() and PostView.ColorCfg[2] or PostView.ColorCfg[1]
  self.postCheckBtn.spriteName = cfg.spriteName
  self.postCheckLab.effectColor = cfg.effectColor
  self.postCheckLab.text = cfg.zhstring
  self.attachCtl:ResetDatas(data.postItems)
  self.attachScrollView:ResetPosition()
  self.contentScrollview:ResetPosition()
end
function PostView:RefreshPostView(sort)
  local allPost = PostProxy.Instance:GetPostArray()
  self.menuBtn.spriteName = #allPost > 0 and "iocn_quanbu" or "icon_quanbu_01"
  local allData = PostProxy.Instance:SetFilterData()
  local id = tonumber(self.postFilter.data)
  if self.DEL_MOD then
    self.viewDatas = PostProxy.Instance:GetAttachPost()
    PostProxy.Instance:ResetMultiChoosePosts()
    for i = 1, #self.viewDatas do
      PostProxy.Instance:SetMultiChoosePosts(self.viewDatas[i].id)
    end
    self:RefreshChooseAllBtn()
  else
    self.viewDatas = id == 0 and allPost or allData[id]
  end
  if sort then
    table.sort(self.viewDatas, function(a, b)
      return self:SortPost(a, b)
    end)
  end
  self.postviewScrollView.enabled = 0 < #self.viewDatas
  self.viewEmptyLab.gameObject:SetActive(0 >= #self.viewDatas)
  self.postWrapHelper:ResetDatas(self.viewDatas)
  self.postWrapHelper:ResetPosition()
  self:UpdateReveiveAllBtn()
  self:RefreshInfoView()
end
function PostView:UpdateReveiveAllBtn()
  if PostProxy.Instance:CheckAllReceived() or self.DEL_MOD then
    self.receiveAllLab.effectColor = GRAY_LABEL_COLOR
    self.receiveAllBtn.spriteName = "com_btn_13s"
  else
    self.receiveAllLab.effectColor = ColorUtil.ButtonLabelBlue
    self.receiveAllBtn.spriteName = "com_btn_1s"
  end
end
function PostView:HandleUpdate(note)
  local needSort = note.body
  if needSort then
    self:ResetCurPost()
    self:RefreshPostView(true)
  else
    self.postWrapHelper:ResetDatas(self.viewDatas)
    self:UpdateReveiveAllBtn()
    self:RefreshInfoView()
  end
end
function PostView:HandleDelPost()
  self:ResetCurPost()
  self:RefreshPostView(true)
end
local INTERVAL = GameConfig.PostClickInterval or 1
function PostView:OnClickPostCell(cellCtl)
  local now = Time.unscaledTime
  if self._refreshTime and now - self._refreshTime < INTERVAL then
    return
  else
    self._refreshTime = now
  end
  local ctlID = cellCtl.data and cellCtl.data.id
  if ctlID then
    local ctl = self.postWrapHelper:GetCellCtls()
    if self.DEL_MOD then
      PostProxy.Instance:SetMultiChoosePosts(ctlID)
      for _, cell in pairs(ctl) do
        cell:UpdateMultiChoose()
      end
      self:RefreshChooseAllBtn()
    elseif not self.curPost or self.curPost.id ~= ctlID then
      self.curPost = cellCtl.data
      for _, cell in pairs(ctl) do
        cell:SetChooseId(self.curPost.id)
      end
      self:RefreshInfoView()
      if self.curPost.unread then
        ServiceSessionMailProxy.Instance:CallMailRead(ctlID)
      end
    end
  end
end
function PostView:UpdateUnreadTip()
  local var = PostProxy.Instance:GetNewPost()
  if #var > 0 then
    self:Show(self.unreadTip)
    var = #var > 99 and "99+" or #var
    self:Show(self.unreadTip)
    self.unreadTip.text = string.format(ZhString.Post_UnreadTip, var)
    self.unreadTipBg:ResetAndUpdateAnchors()
  else
    self:Hide(self.unreadTip)
  end
end
function PostView:OnExit()
  PictureManager.Instance:UnLoadUI()
  PostView.super.OnExit(self)
end
