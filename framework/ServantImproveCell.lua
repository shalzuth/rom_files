local BaseCell = autoImport("BaseCell")
ServantImproveCell = class("ServantImproveCell", BaseCell)
ServantImproveCell.CellState = {
  [1] = {
    buttonString = ZhString.ServantImproveCellState_Look,
    btnSprite = "com_btn_2s",
    effectColor = LuaColor.New(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
  },
  [2] = {
    buttonString = ZhString.ServantImproveCellState_Go,
    btnSprite = "com_btn_2s",
    effectColor = LuaColor.New(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
  },
  [3] = {
    buttonString = ZhString.ServantImproveCellState_Get,
    btnSprite = "com_btn_3s",
    effectColor = LuaColor.New(0.18823529411764706, 0.5294117647058824, 0.027450980392156862, 1)
  },
  [4] = {
    buttonString = ZhString.ServantImproveCellState_Finish,
    btnSprite = "com_btn_2s",
    effectColor = LuaColor.New(1, 1, 1, 1)
  },
  [5] = {
    buttonString = ZhString.ServantImproveCellState_Next,
    btnSprite = "com_btn_1s",
    effectColor = LuaColor.New(0.1803921568627451, 0.2823529411764706, 0.5843137254901961, 1)
  },
  [6] = {
    buttonString = "",
    btnSprite = "",
    effectColor = LuaColor.New(0.1803921568627451, 0.2823529411764706, 0.5843137254901961, 1)
  }
}
function ServantImproveCell:Init()
  ServantImproveCell.super.Init(self)
  self:FindObjs()
end
function ServantImproveCell:FindObjs()
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
  self:AddCellClickEvent()
  self:AddButtonEvent("Btn", function(obj)
    if ServantRecommendProxy.CheckDateValid(self.data.staticData) then
      self:PassEvent(ServantImproveEvent.TraceBtnClick, self)
    else
      MsgManager.ShowMsgByID(5209)
    end
  end)
end
function ServantImproveCell:setSelected(isSelected)
  self.isSelected = isSelected
  if Slua.IsNull(self.expand) == false then
    self.expand:SetActive(isSelected)
    local bd = NGUIMath.CalculateRelativeWidgetBounds(self.content.transform, false)
    local height = math.max(bd.size.y, 110)
    if self.isSelected then
      self.back1.height = height + 15
      if self.hasFirst == nil then
        self.hasFirst = true
        self.back1.height = height + 40
      end
    elseif self.title2.activeSelf then
      self.back1.height = height + 9
    else
      self.back1.height = height + 25
    end
    NGUITools.UpdateWidgetCollider(self.gameObject)
  end
end
function ServantImproveCell:SetData(data)
  self.data = data
  if self.isSelected then
    self:setSelected(false)
  end
  self.btnType = 0
  self.redPoint:SetActive(false)
  self.lock:SetActive(false)
  self.finishMark:SetActive(false)
  if type(data) == "table" then
    if data.groupid then
      local groupStaticData = Table_ServantImproveGroup[data.groupid]
      if groupStaticData then
        self.cellTitle.text = groupStaticData.subtitle
        self.description.text = ZhString.ItemTip_CHSpace .. groupStaticData.desc
        local ret = IconManager:SetUIIcon(groupStaticData.icon, self.icon)
        if not ret then
          IconManager:SetItemIcon(groupStaticData.icon, self.icon)
        end
        local groupData = ServantRecommendProxy.Instance:GetImproveGroup(data.groupid)
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
        local isAllGrowthRewardGet = true
        local growthReward = GameConfig.Servant.growth_reward[groupData.groupid]
        local everRewardList = groupData.everReward
        if everRewardList and #everRewardList > 0 then
          for i = 1, #growthReward do
            isAllGrowthRewardGet = false
            local growthValue = growthReward[i].value
            for j = 1, #everRewardList do
              if growthValue == everRewardList[j] then
                isAllGrowthRewardGet = true
                break
              end
            end
            if isAllGrowthRewardGet then
            end
          end
        else
          isAllGrowthRewardGet = false
        end
        if getCount > 0 then
          self.redPoint:SetActive(true)
        end
        if finishCount == #groupData.itemList and isAllGrowthRewardGet then
          self.btnType = 5
        else
          self.btnType = 1
        end
        self.cellName.text = groupStaticData.maintitle .. " \239\188\136" .. finishCount + #groupData.finishList .. "/" .. #groupData.itemList + #groupData.finishList .. "\239\188\137"
        self.cellTitle.gameObject:SetActive(true)
        self.title2:SetActive(false)
        if groupStaticData.type == 1 then
          self.back1.spriteName = "com_bg_bottom9"
        else
          self.back1.spriteName = "com_bg_bottom8"
        end
        self:setSelected(true)
      end
    elseif data.dwid then
      self.back1.spriteName = "com_bg_bottom9"
      local itemData = Table_Growth[data.dwid]
      if itemData then
        self.gotoMode = itemData.gotomode
        self.cellName.text = itemData.maintitle
        self.cellTitle2.text = string.format(itemData.subtitle, data.finishtimes)
        self.description.text = ZhString.ItemTip_CHSpace .. itemData.desc
        self.growthCount.text = "x" .. itemData.Growth
        local ret = IconManager:SetUIIcon(itemData.icon, self.icon)
        if not ret then
          IconManager:SetItemIcon(itemData.icon, self.icon)
        end
        if itemData.Reward then
          local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(itemData.Reward)
          if rewardTeamids and #rewardTeamids > 0 then
            local item = rewardTeamids[1]
            local itemData = Table_Item[item.id]
            IconManager:SetItemIcon(itemData.Icon, self.awardItemIcon)
            self.awardItemCount.text = "x" .. item.num
          end
        end
        if data.status == SceneUser2_pb.EGROWTH_STATUS_MIN then
          self.cellTitle2.text = itemData.unlock_desc
          self.btnType = 6
        elseif data.status == SceneUser2_pb.EGROWTH_STATUS_GO then
          self.btnType = 2
        elseif data.status == SceneUser2_pb.EGROWTH_STATUS_RECEIVE then
          self.btnType = 3
        elseif data.status == SceneUser2_pb.EGROWTH_STATUS_FINISH then
          self.finishMark:SetActive(true)
        end
        self.cellTitle.gameObject:SetActive(false)
        self.title2:SetActive(true)
      end
    end
  elseif type(data) == "number" then
    self.back1.spriteName = "com_bg_bottom9"
    local functionItemData = Table_ServantUnlockFunction[data]
    if functionItemData then
      self.cellName.text = functionItemData.maintitle
      self.cellTitle.text = functionItemData.subtitle
      self.description.text = ZhString.ItemTip_CHSpace .. functionItemData.desc
      self.gotoMode = functionItemData.gotomode
    end
    self.btnType = 2
    local ret = IconManager:SetUIIcon(functionItemData.icon, self.icon)
    if not ret then
      IconManager:SetItemIcon(functionItemData.icon, self.icon)
    end
    self.cellTitle.gameObject:SetActive(true)
    self.title2:SetActive(false)
  end
  self.icon:MakePixelPerfect()
  self.icon.width = math.floor(self.icon.width * 0.9)
  self.icon.height = math.floor(self.icon.height * 0.9)
  if self.btnType == 0 then
    self.cellBtnSprite.gameObject:SetActive(false)
    ColorUtil.WhiteUIWidget(self.icon)
  elseif self.btnType == 6 then
    ColorUtil.ShaderGrayUIWidget(self.icon)
    self.lock:SetActive(true)
    self.cellBtnSprite.gameObject:SetActive(false)
  else
    ColorUtil.WhiteUIWidget(self.icon)
    self.cellBtnSprite.gameObject:SetActive(true)
    self.cellBtnSprite.spriteName = ServantImproveCell.CellState[self.btnType].btnSprite
    self.btnText.text = ServantImproveCell.CellState[self.btnType].buttonString
    self.btnText.effectColor = ServantImproveCell.CellState[self.btnType].effectColor
  end
end
