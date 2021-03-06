autoImport("BaseTip")
TitleTip = class("TitleTip", BaseTip)
local yellowEffectColor = Color(0.6313725490196078, 0.6313725490196078, 0.6313725490196078, 1)
local grayEffectColor = Color(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
local lockBtnSpriteName = "com_btn_13"
local unlockBtnSpriteName = "com_btn_2"
local standardHeight = 58
local bgStandardHeight = 103
function TitleTip:Init()
  self.titleName = self:FindComponent("titleName", UILabel)
  self.propDesLab = self:FindComponent("propDesLab", UILabel)
  self.unlockDes = self:FindComponent("unlockDes", UILabel)
  self.DesLab = self:FindComponent("DesLab", UILabel)
  self.ArrowBtn = self:FindComponent("ArrowBtn", UISprite)
  self.UseBtn = self:FindComponent("useBtn", UISprite)
  self.useBtnLab = self:FindComponent("useBtnLab", UILabel)
  self.DescFrame = self:FindComponent("Des", UISprite)
  self:_AddAnchor(self:FindComponent("useBtn", UISprite))
  self:_AddAnchor(self:FindComponent("BgButtomFrame", UISprite))
  self:_AddAnchor(self:FindComponent("bg", UISprite))
  self:AddButtonEvent("useBtn", function(obj)
    self:ClickUseBtn()
  end)
  self:AddButtonEvent("ArrowBtn", function(obj)
    self:ClickArrowBtn()
  end)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChangeTitle, self.SetUseBtnState, self)
  TitleTip.super.Init(self)
end
function TitleTip:SetData(data)
  self.callback = data.callback
  local data = data.itemdata
  self.data = data
  self.id = data.id
  self.unlocked = data.unlocked
  self.type = data.titleType
  self:SetUseBtnState()
  self:SetArrowBtnState()
  local staticData = Table_Appellation[self.id]
  if not staticData then
    return
  end
  local name = staticData.Name
  self.titleName.text = name
  local achieveId = self.data:GetAchievemnetIDByTitle(self.id)
  local unlockDes
  if achieveId and 0 ~= achieveId then
    self:Show(self.ArrowBtn)
    unlockDes = Table_Achievement[achieveId] and Table_Achievement[achieveId].Name or ""
    self.unlockDes.text = string.format(ZhString.UnlockAchievenment, unlockDes)
  else
    unlockDes = GameConfig.QuestAppellationIDs and GameConfig.QuestAppellationIDs[self.id] or ""
    self.unlockDes.text = string.format(ZhString.UnlockQuestAchievenment, unlockDes)
    self:Hide(self.ArrowBtn)
  end
  local content = Table_Item[self.id].Desc
  self.DesLab.text = content
  local prop = staticData.BaseProp
  local propDesc
  for k, v in pairs(prop) do
    if propDesc then
      propDesc = propDesc .. " , " .. tostring(k) .. "+" .. tostring(v)
    else
      propDesc = tostring(k) .. "+" .. tostring(v)
    end
  end
  self.callbackParam = data.callbackParam
  self.propDesLab.text = propDesc
  self:_CalculateBgHeight()
  self:_UpdateAnchor()
end
function TitleTip:_CalculateBgHeight()
  local labelHeight = self.DesLab.height
  local delta = labelHeight - standardHeight
  if delta > 0 then
    self.DescFrame.height = bgStandardHeight + delta
  else
    self.DescFrame.height = bgStandardHeight
  end
end
function TitleTip:_AddAnchor(uirect)
  if self.anchors == nil then
    self.anchors = {}
  end
  self.anchors[#self.anchors + 1] = uirect
end
function TitleTip:_UpdateAnchor()
  if self.anchors then
    for i = 1, #self.anchors do
      self.anchors[i]:ResetAndUpdateAnchors()
    end
  end
end
function TitleTip:SetUseBtnState()
  local curTitle = Game.Myself.data:GetAchievementtitle()
  if not self.unlocked then
    self.UseBtn.spriteName = lockBtnSpriteName
    self.useBtnLab.text = ZhString.AchievementTitle_Unlock
    self.useBtnLab.effectColor = yellowEffectColor
  elseif self.unlocked and self.id ~= curTitle then
    if TitleProxy.Instance:bLowerTitleGroup(self.id) then
      self.UseBtn.spriteName = lockBtnSpriteName
      self.useBtnLab.text = ZhString.QuickUsePopupFuncCell_UseBtn
    else
      self.UseBtn.spriteName = unlockBtnSpriteName
      self.useBtnLab.text = ZhString.QuickUsePopupFuncCell_UseBtn
    end
    self.useBtnLab.effectColor = grayEffectColor
  else
    self.UseBtn.spriteName = unlockBtnSpriteName
    self.useBtnLab.text = ZhString.AchievementTitle_unfix
    self.useBtnLab.effectColor = grayEffectColor
  end
end
function TitleTip:SetArrowBtnState()
  local bVisibily = self.data:bVisibilyAchievement()
  local unlock = FunctionUnLockFunc.Me():CheckCanOpen(23)
  if not unlock or self.data.hideFlag then
    self.ArrowBtn.gameObject:SetActive(false)
  elseif bVisibily and not self.unlocked then
    self.ArrowBtn.gameObject:SetActive(false)
  else
    self.ArrowBtn.gameObject:SetActive(true)
  end
end
function TitleTip:ClickUseBtn()
  local curTitle = Game.Myself.data:GetAchievementtitle()
  if not self.unlocked then
    return
  end
  local lowerCsv = TitleProxy.Instance:bLowerTitleGroup(self.id)
  if lowerCsv then
    local achieveName = lowerCsv.config.Name
    MsgManager.ShowMsgByIDTable(2871, achieveName)
    return
  end
  if curTitle == self.id then
    TitleProxy.Instance:ChangeTitle(2, 0)
  else
    TitleProxy.Instance:ChangeTitle(self.type, self.id)
  end
end
function TitleTip:ClickArrowBtn()
  local id = self.data:GetAchievemnetIDByTitle()
  if id and id ~= 0 then
    autoImport("AdventurePanel")
    AdventurePanel.OpenAchievePageById(id)
    self:DestroySelf()
  end
end
function TitleTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function TitleTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end
function TitleTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChangeTitle, self.SetUseBtnState, self)
    GameObject.Destroy(self.gameObject)
  end
end
