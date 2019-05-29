autoImport("ProfessionBaseView")
autoImport("BaseAttributeCell")
ProfessionInfoView = class("ProfessionInfoView", ProfessionBaseView)
local tempVector3 = LuaVector3.zero
ProfessionInfoView.LeftBtnClick = "ProfessionInfoView.LeftBtnClick"
ProfessionInfoView.LeftBtnClick2 = "ProfessionInfoView.LeftBtnClick2"
ProfessionInfoView.LeftBtnClick3 = "ProfessionInfoView.LeftBtnClick3"
ProfessionInfoView.LeftBtnClick4 = "ProfessionInfoView.LeftBtnClick4"
function ProfessionInfoView:Init()
  self:initView()
  self:initData()
  self:ResetData()
  self:AddCloseButtonEvent()
end
function ProfessionInfoView:initData()
  self.currentPfn = nil
  local userData = Game.Myself.data.userdata
  self.sex = userData:Get(UDEnum.SEX)
  self.hair = userData:Get(UDEnum.HAIR)
  self.eye = userData:Get(UDEnum.EYE)
end
function ProfessionInfoView:initSelfObj()
  self.parentObj = self:FindGO("professionInfoView")
  self.gameObject = self:LoadPreferb("view/ProfessionInfoView", self.parentObj)
end
function ProfessionInfoView:initView()
  ProfessionInfoView.super.initView(self)
  local panel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel)
  local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
  local grid = self:FindGO("professionSkillGrid"):GetComponent(UIGrid)
  self.gridList = UIGridListCtrl.new(grid, ProfessionSkillCell, "ProfessionSkillCell")
  self.gridList:AddEventListener(MouseEvent.MouseClick, self.clickHandler, self)
  self.gameObject.transform.position = Vector3(0, 0, 0)
end
function ProfessionInfoView:clickHandler(target)
  local skillId = target.data
  local skillItem = SkillItemData.new(skillId)
  local tipData = {}
  tipData.data = skillItem
  TipsView.Me():ShowTip(SkillTip, tipData, "SkillTip")
  local tip = TipsView.Me().currentTip
  if tip then
    tempVector3:Set(0, 0, 0)
    tip.gameObject.transform.localPosition = tempVector3
  end
end
function ProfessionInfoView:showInfo(data)
  self.currentPfn = data
  if data == nil then
    self:Hide(self.parentObj)
    return
  end
  self:Show(self.parentObj)
  self:ResetData()
end
function ProfessionInfoView:multiProfessionInfo(obj)
  if obj == nil then
    self:Hide(self.parentObj)
    return
  end
  self.currentPfn = obj.data
  if self.currentPfn == nil then
    self:Hide(self.parentObj)
    return
  end
  self:Show(self.parentObj)
  self:ResetData()
  local state = obj:GetHeadIconState() or 0
  local branch = self.currentPfn.TypeBranch or 0
  if state == 6 and branch ~= 0 then
    self.Purchase.gameObject:SetActive(true)
    self.Switch.gameObject:SetActive(false)
    self.whitebgSP.gameObject:SetActive(false)
    self:AddClickEvent(self.PurchaseBtn.gameObject, function()
      local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      local isOriginProfession = false
      for k, v in pairs(S_data) do
        if v.isbuy == false then
          local sClassData = Table_Class[v.profession]
          local thisClassData = Table_Class[obj:GetId()]
          if sClassData.Type == thisClassData.Type then
            isOriginProfession = true
            break
          end
        end
      end
      ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
    end)
  end
  if state ~= nil then
    self.old = self:FindGO("old")
    self.old.gameObject:SetActive(true)
  end
  if state == 7 and branch ~= 0 then
    self:showShuXin()
    self.lockContent.gameObject:SetActive(false)
    self.Purchase.gameObject:SetActive(false)
    self.Switch.gameObject:SetActive(true)
    self:AddClickEvent(self.SwitchBtn.gameObject, function()
      ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
    end)
  end
  if state == 1 and branch ~= 0 then
    self:showShuXin()
    self.lockContent.gameObject:SetActive(false)
    self.Purchase.gameObject:SetActive(false)
    self.Switch.gameObject:SetActive(true)
    self:AddClickEvent(self.SwitchBtn.gameObject, function()
      ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
    end)
  end
  if state ~= 4 or branch ~= 0 then
  end
  if state ~= 5 or branch ~= 0 then
  end
  if state == 2 and branch ~= 0 then
    self.Purchase.gameObject:SetActive(false)
    self.Switch.gameObject:SetActive(false)
  end
  if state == 3 and branch ~= 0 then
    self.Purchase.gameObject:SetActive(false)
    self.Switch.gameObject:SetActive(true)
    self.whitebgSP.gameObject:SetActive(true)
    local sprites = UIUtil.GetAllComponentsInChildren(self.Switch, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    end
    self:AddClickEvent(self.SwitchBtn.gameObject, function()
    end)
  end
end
function ProfessionInfoView:showShuXin()
  local GeneraData = ProfessionProxy.Instance:GetGeneraData()
  local FixedData = ProfessionProxy.Instance:GetFixedData()
  self.whitebgSP.gameObject:SetActive(true)
  self.DownLabelsGrid.gameObject:SetActive(true)
  local iwantshowDatas = {}
  for i = 1, #GeneraData do
    local data = GeneraData[i]
    if data.prop.propVO.name == "Hp" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "Sp" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "Cri" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "AtkSpd" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "Atk" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "MAtk" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "Def" then
      table.insert(iwantshowDatas, data)
    elseif data.prop.propVO.name == "MDef" then
      table.insert(iwantshowDatas, data)
    end
  end
  self.baseGridList:ResetDatas(iwantshowDatas)
end
