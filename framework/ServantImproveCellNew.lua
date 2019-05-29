local BaseCell = autoImport("BaseCell")
ServantImproveCellNew = class("ServantImproveCellNew", BaseCell)
ServantImproveCellNew.CellState = {
  [1] = {
    buttonString = ZhString.ServantImproveCellNewState_Look,
    btnSprite = "com_btn_2s",
    effectColor = LuaColor.New(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
  },
  [2] = {
    buttonString = ZhString.ServantImproveCellNewState_Go,
    btnSprite = "com_btn_2s",
    effectColor = LuaColor.New(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
  },
  [3] = {
    buttonString = ZhString.ServantImproveCellNewState_Get,
    btnSprite = "com_btn_3s",
    effectColor = LuaColor.New(0.18823529411764706, 0.5294117647058824, 0.027450980392156862, 1)
  },
  [4] = {
    buttonString = ZhString.ServantImproveCellNewState_Finish,
    btnSprite = "com_btn_2s",
    effectColor = LuaColor.New(1, 1, 1, 1)
  },
  [5] = {
    buttonString = ZhString.ServantImproveCellNewState_Next,
    btnSprite = "com_btn_1s",
    effectColor = LuaColor.New(0.1803921568627451, 0.2823529411764706, 0.5843137254901961, 1)
  },
  [6] = {
    buttonString = "",
    btnSprite = "",
    effectColor = LuaColor.New(0.1803921568627451, 0.2823529411764706, 0.5843137254901961, 1)
  }
}
function ServantImproveCellNew:Init()
  ServantImproveCellNew.super.Init(self)
  self:FindObjs()
end
function ServantImproveCellNew:FindObjs()
  self.back1 = self:FindComponent("Back1", UISprite)
  self.expand = self:FindGO("Expand")
  self.redPoint = self:FindGO("RedPoint")
  self.lock = self:FindGO("Lock")
  self.finishMark = self:FindGO("FinishMark")
  self.description = self:FindComponent("Description", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.cellName = self:FindComponent("Name", UILabel)
  self.cellTitle = self:FindComponent("Title", UILabel)
  self.cellTitle2 = self:FindComponent("Title2Desc", UILabel)
  self.cellBtnSprite = self:FindComponent("Btn", UISprite)
  self.btnText = self:FindComponent("BtnText", UILabel)
  self.awardItemIcon = self:FindComponent("AwardItemIcon", UISprite)
  self.awardItemCount = self:FindComponent("AwardItemCount", UILabel)
  self.content = self:FindGO("Content")
  self.title2 = self:FindGO("Title2")
  self.growthCount = self:FindComponent("Award", UILabel)
  self.Node = self:FindGO("Node")
  self.Title = self:FindGO("Title", self.Node)
  self.Title_UILabel = self.Title:GetComponent(UILabel)
  self.Name = self:FindGO("Name", self.Node)
  self.Name.gameObject:SetActive(false)
  self.Name_UILabel = self.Name:GetComponent(UILabel)
  self.state1 = self:FindGO("state1", self.Node)
  self.state2 = self:FindGO("state2", self.Node)
  self.state3 = self:FindGO("state3", self.Node)
  self.state4 = self:FindGO("state4", self.Node)
  self.qianwang = self:FindGO("qianwang", self.state2)
  self.hp = self:FindGO("hp", self.state2)
  self.hp_UISlider = self.hp:GetComponent(UISlider)
  self.NameForProgress = self:FindGO("NameForProgress", self.state2)
  self.NameForProgress_UILabel = self.NameForProgress:GetComponent(UILabel)
  self.NameForProgress_UILabel.pivot = UIWidget.Pivot.Center
  OverseaHostHelper:FixLabelOverV1(self.NameForProgress_UILabel, 2, 100)
  self.NameForProgress_UILabel.transform.localPosition = Vector3(0, -195.5, 0)
  self.state4_hp = self:FindGO("hp", self.state4)
  self.state4_hp_UISlider = self.state4_hp:GetComponent(UISlider)
  self.state4_NameForProgress = self:FindGO("NameForProgress", self.state4)
  self.state4_NameForProgress_UILabel = self.state4_NameForProgress:GetComponent(UILabel)
  self.state4_NameForProgress_UILabel.pivot = UIWidget.Pivot.Center
  OverseaHostHelper:FixLabelOverV1(self.state4_NameForProgress_UILabel, 2, 100)
  self.state4_NameForProgress_UILabel.transform.localPosition = Vector3(0, -195.5, 0)
  self.state4_liwu = self:FindGO("liwu", self.state4)
  self.GiftParent = self:FindGO("GiftParent", self.state4_liwu)
  self.GiftPoint = self:FindGO("GiftPoint", self.GiftParent)
  self.GiftPoint.gameObject:SetActive(false)
  self.GiftButton = self:FindGO("GiftButton", self.GiftParent)
  self.Stick = self:FindGO("Stick", self.GiftButton)
  self.GiftButtonSprite = self:FindGO("GiftButtonSprite", self.GiftButton)
  self.GiftButtonSprite_UISprite = self.GiftButtonSprite:GetComponent(UISprite)
  self.Stick_UIWidget = self.Stick:GetComponent(UIWidget)
  self.GiftButton_TweenRotation = self.GiftButton:GetComponent(TweenRotation)
  self.GiftButton_UILongPress = self.GiftButton:GetComponent(UILongPress)
  self.black2 = self:FindGO("black2", self.Node)
  self.black2_Name = self:FindGO("Name", self.black2)
  self.black2_Name_UILabel = self.black2_Name:GetComponent(UILabel)
  self.tiaojian = self:FindGO("tiaojian", self.state3)
  self.tiaojian_UILabel = self.tiaojian:GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(self.tiaojian_UILabel, 3, 200)
  self.BG1 = self:FindGO("BG1", self.Node)
  self.BG2 = self:FindGO("BG2", self.Node)
  self.BG3 = self:FindGO("BG3", self.Node)
  self.BG3_UITexture = self.BG3:GetComponent(UITexture)
  self:AddCellClickEvent()
  self:AddClickEvent(self.qianwang, function(go)
    self:PassEvent(ServantImproveEvent.TraceBtnClick, self)
  end)
  self:AddButtonEvent("Btn", function(obj)
    if ServantRecommendProxy.CheckDateValid(self.data.staticData) then
      self:PassEvent(ServantImproveEvent.TraceBtnClick, self)
    else
      MsgManager.ShowMsgByID(5209)
    end
  end)
  function self.GiftButton_UILongPress.pressEvent(obj, state)
    self:PassEvent(MouseEvent.LongPress, {state, self})
  end
  self:AddClickEvent(self.GiftButton, function(obj)
    self:OnClickGiftBtn()
  end)
  self:AddClickEvent(self.BG3, function(obj)
    if self.state3.gameObject.activeInHierarchy then
    else
      self:PassEvent(ServantImproveEvent.TraceBtnClick, self)
    end
  end)
end
function ServantImproveCellNew:SetClickBG3Func(func)
  self:AddClickEvent(self.BG3, func)
end
function ServantImproveCellNew:OnClickGiftBtn()
  local staticData = self.groupData and self.groupData.groupid and Table_ServantImproveGroup[self.groupData.groupid]
  local valid = ServantRecommendProxy.CheckDateValid(staticData)
  if valid then
    if self.GiftButton_TweenRotation.enabled then
      ServiceNUserProxy.Instance:CallReceiveGrowthServantUserCmd(self.groupData.groupid, self.valueForServerCall)
    end
  else
    MsgManager.ShowMsgByID(5209)
  end
  local everRewardList = self.groupData.everReward
  if everRewardList and #everRewardList > 0 then
    for i = 1, #everRewardList do
      local value = everRewardList[i]
      if value == 100 then
        local groupData = Table_ServantImproveGroup[self.groupData.groupid]
        if groupData and groupData.nextid then
          ServiceNUserProxy.Instance:CallGrowthOpenServantUserCmd(self.groupData.groupid)
        else
          MsgManager.ShowMsgByID(26011)
        end
      end
    end
  end
  if self:IsOldCell() then
    self.GiftButtonSprite_UISprite.spriteName = "icon_2"
  end
  self.GiftButtonSprite_UISprite:MakePixelPerfect()
end
function ServantImproveCellNew:UpdateGiftState(groupData)
  self.groupData = groupData
  self.GiftButton_TweenRotation.enabled = false
  for i = 1, #self.growthRewardTable do
    local value = self.growthRewardTable[i].value
    local rewardid = self.growthRewardTable[i].rewardid
    local everRewardList = groupData.everReward
    local isValueExist = false
    if everRewardList and #everRewardList > 0 then
      for i = 1, #everRewardList do
        if value == everRewardList[i] then
          isValueExist = true
        end
      end
    end
    if isValueExist then
    else
      if groupData.growth == nil then
        self.GiftButton_TweenRotation.enabled = false
        break
      end
      if groupData.growth and value <= groupData.growth then
        self.GiftButton_TweenRotation.enabled = true
        self.valueForServerCall = value
        self.GiftButtonSprite_UISprite.spriteName = "icon_1"
        do break end
        break
      end
      self.GiftButton_TweenRotation.enabled = false
      self.GiftButtonSprite_UISprite.spriteName = "icon_1"
      do break end
      break
    end
    local everRewardList = self.groupData.everReward
    if everRewardList and #everRewardList > 0 then
      for i = 1, #everRewardList do
        local value = everRewardList[i]
        if value == 100 then
          local groupData = Table_ServantImproveGroup[self.groupData.groupid]
          if groupData and groupData.nextid then
            ServiceNUserProxy.Instance:CallGrowthOpenServantUserCmd(self.groupData.groupid)
            break
          else
            self.state4.gameObject:SetActive(false)
            self.state1.gameObject:SetActive(true)
          end
        end
      end
    end
  end
  if self:IsOldCell() then
    self.GiftButtonSprite_UISprite.spriteName = "icon_2"
    self:ShowState(4)
  end
  self.GiftButtonSprite_UISprite:MakePixelPerfect()
end
function ServantImproveCellNew:setSelected(isSelected)
  self.isSelected = isSelected
  if Slua.IsNull(self.expand) == false then
    self.expand:SetActive(isSelected)
    local bd = NGUIMath.CalculateRelativeWidgetBounds(self.content.transform, false)
    local height = math.max(bd.size.y, 110)
    if self.isSelected then
      self.back1.height = height + 15
    elseif self.title2.activeSelf then
      self.back1.height = height + 9
    else
      self.back1.height = height + 25
    end
    NGUITools.UpdateWidgetCollider(self.gameObject)
  end
end
function ServantImproveCellNew:ShowState(statenumber)
  if statenumber == 4 then
    self.state1.gameObject:SetActive(false)
    self.state2.gameObject:SetActive(false)
    self.state3.gameObject:SetActive(false)
    self.state4.gameObject:SetActive(true)
  end
end
function ServantImproveCellNew:SetState4Detail(fenzi, fenmu, liwuid, growthRewardTable)
  helplog("SetState4Detail")
  self.growthRewardTable = growthRewardTable
  if self:IsOldCell() then
    helplog("function ServantImproveCellNew:SetState4Detail")
    self.state1.gameObject:SetActive(false)
    self.state2.gameObject:SetActive(false)
    self.state3.gameObject:SetActive(false)
    self.state4.gameObject:SetActive(true)
    self.GiftButtonSprite_UISprite.spriteName = "icon_2"
    return
  end
  if fenmu ~= 0 then
    self.state4_hp_UISlider.value = fenzi / fenmu
    self.state4_NameForProgress_UILabel.text = fenzi .. "/" .. fenmu
  end
end
function ServantImproveCellNew:GetDataId()
  if self.data then
    return self.data.id
  else
    return nil
  end
end
function ServantImproveCellNew:SetToOldState(groupid)
  local growthReward = GameConfig.Servant.growth_reward[groupid]
  local growthRewardValue1 = growthReward[#growthReward].value
  local growthRewardValue2 = growthReward[#growthReward - 1].value
  local delta = growthRewardValue1 - growthRewardValue2
  if delta ~= 0 then
    self.state4_hp_UISlider.value = 1
    self.state4_NameForProgress_UILabel.text = delta .. "/" .. delta
    self.GiftButtonSprite_UISprite.spriteName = "icon_2"
  end
end
function ServantImproveCellNew:IsOldCell()
  local currentjinduid = ServantRecommendProxy.Instance:GetCurrentJinDuId()
  if self.data and currentjinduid > self.data.id then
    return true
  else
    return false
  end
end
function ServantImproveCellNew:SetData(data)
  self.data = data
  if data then
    self.Title_UILabel.text = data.maintitle
    self.black2_Name_UILabel.text = data.desc
    self.tiaojian_UILabel.text = data.unlock
    PictureManager.Instance:SetServantBG(data.texture, self.BG3_UITexture)
    local currentjinduid = ServantRecommendProxy.Instance:GetCurrentJinDuId()
    if currentjinduid > data.id then
      self.state1.gameObject:SetActive(true)
      self.state2.gameObject:SetActive(false)
      self.state3.gameObject:SetActive(false)
      self.state4.gameObject:SetActive(false)
    elseif data.id == currentjinduid then
      self.state1.gameObject:SetActive(false)
      self.state2.gameObject:SetActive(true)
      self.state3.gameObject:SetActive(false)
      self.state4.gameObject:SetActive(false)
    elseif currentjinduid < data.id then
      self.state1.gameObject:SetActive(false)
      self.state2.gameObject:SetActive(false)
      self.state3.gameObject:SetActive(true)
      self.state4.gameObject:SetActive(false)
    end
    local groupData = ServantRecommendProxy.Instance:GetImproveGroup(data.id)
    if groupData == nil then
      return
    end
    local finishCount = 0
    local getCount = 0
    if groupData.itemList and 0 < #groupData.itemList then
      local itemList = groupData.itemList
      for i = 1, #itemList do
        if itemList[i].status == SceneUser2_pb.EGROWTH_STATUS_FINISH then
          finishCount = finishCount + 1
        elseif itemList[i].status == SceneUser2_pb.EGROWTH_STATUS_RECEIVE then
          getCount = getCount + 1
        end
      end
    end
    local fenzi = finishCount + #groupData.finishList
    local fenmu = #groupData.itemList + #groupData.finishList
    if fenmu ~= 0 then
      self.NameForProgress_UILabel.text = fenzi .. "/" .. fenmu
      self.hp_UISlider.value = fenzi / fenmu
      if fenzi == fenmu then
        self.GiftButtonSprite_UISprite.spriteName = "icon_2"
      else
        self.GiftButtonSprite_UISprite.spriteName = "icon_1"
      end
    else
    end
    local everRewardList = groupData.everReward
    if everRewardList and #everRewardList > 0 then
      for i = 1, #everRewardList do
        local value = everRewardList[i]
        if value == 100 then
          local groupData = Table_ServantImproveGroup[groupData.groupid]
          if groupData and groupData.nextid then
          else
            self.state4.gameObject:SetActive(false)
            self.state2.gameObject:SetActive(false)
            self.state3.gameObject:SetActive(false)
            self.state1.gameObject:SetActive(true)
          end
        end
      end
    end
  end
end
