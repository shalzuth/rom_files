ProfessionBaseView = class("ProfessionBaseView", SubMediatorView)
autoImport("ProfessionInfoPanelCell")
local tempVector3 = LuaVector3.zero
local tempTable = {}
function ProfessionBaseView:Init()
  self:initView()
  self:initData()
  self:AddCloseButtonEvent()
end
function ProfessionBaseView:initData()
  self.currentPfn = nil
  local userData = Game.Myself.data.userdata
  TableUtility.TableClear(tempTable)
  tempTable.sex = userData:Get(UDEnum.SEX)
  tempTable.hair = userData:Get(UDEnum.HAIR)
  tempTable.eye = userData:Get(UDEnum.EYE)
  tempTable.eyeColorIndex = userData:Get(UDEnum.EYECOLOR)
  tempTable.hairColorIndex = userData:Get(UDEnum.HAIRCOLOR)
  self:ResetData(tempTable)
end
function ProfessionBaseView:initSelfObj()
end
function ProfessionBaseView:initView()
  self:initSelfObj()
  local panel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel)
  local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
  tempVector3:Set(0, 0, 0)
  self.gameObject.transform.localPosition = tempVector3
  self.professionIcon = self:FindComponent("professionIcon", UISprite)
  self.professionSpc = self:FindComponent("professionSpc", UILabel)
  self.propGridView = self:FindComponent("propGrid", UIGrid)
  self.propGrid = UIGridListCtrl.new(self.propGridView, ProfessionInfoPanelCell, "ProfessionInfoPanelCell")
  local propDes = self:FindComponent("propDes", UILabel)
  local str = ZhString.ProfessionInfoPanel_PropDes
  if propDes then
    propDes.text = str
  end
  self.professionName = self:FindComponent("profLabel", UILabel)
  self.professionNameEn = self:FindComponent("profLabelEng", UILabel)
  self.professionBg = self:FindComponent("profFlagBg", UISprite)
  self.profBg = self:FindComponent("profBg", UISprite)
  local playerModelContainer = self:FindGO("PlayerModelContainer")
  self.PlayerModel = self:FindComponent("PlayerModel", UITexture)
  if playerModelContainer then
    self:AddDragEvent(playerModelContainer, function(obj, delta)
      self:RotateRoleEvt(obj, delta)
    end)
  end
  if self:FindGO("ScrollView") then
    self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  end
end
function ProfessionBaseView:RotateRoleEvt(go, delta)
  if self.model then
    self.model:RotateDelta(-delta.x)
  end
end
function ProfessionBaseView:showRoleModel(agentData)
  if agentData == nil then
    agentData = {
      hair = self.hair,
      body = self.sex == 1 and self.currentPfn.MaleBody or self.currentPfn.FemaleBody,
      sex = self.sex,
      eye = self.eye
    }
  end
  local parts = Asset_Role.CreatePartArray()
  parts[Asset_Role.PartIndex.Body] = agentData.body or 0
  parts[Asset_Role.PartIndex.Hair] = agentData.hair or 0
  parts[Asset_Role.PartIndex.Eye] = agentData.eye or 0
  parts[Asset_Role.PartIndexEx.HairColorIndex] = agentData.hairColorIndex or 0
  parts[Asset_Role.PartIndexEx.EyeColorIndex] = agentData.eyeColorIndex or 0
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.PlayerModel, parts)
  if self.model then
    tempVector3:Set(-0.67, 0.09, 0)
    self.model:SetPosition(tempVector3)
    tempVector3:Set(-0.67, 13.62, 0)
    self.model:SetEulerAngleY(tempVector3)
  end
  Asset_Role.DestroyPartArray(parts)
end
function ProfessionBaseView:showInfo(data)
end
function ProfessionBaseView:AddCloseButtonEvent()
  local buttonobj = self:FindGO("CloseButton", self.parentObj)
  if buttonobj ~= nil then
    self:AddClickEvent(buttonobj, function(go)
      self:Hide(self.parentObj)
    end)
  end
end
local tempArray = {}
function ProfessionBaseView:ResetData(agentData)
  if self.currentPfn == nil or self.currentPfn.id == 1 then
    return
  end
  if self.currentPfn ~= nil then
    self.professionName.text = self.currentPfn.NameZh
    self.professionNameEn.text = self.currentPfn.NameEn
    self.professionBg.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(string.format("CareerFlag%d", self.currentPfn.Type))
    self.profBg.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(string.format("CareerFlag%d", self.currentPfn.Type))
    IconManager:SetProfessionIcon(self.currentPfn.icon, self.professionIcon)
    local valusStr = ""
    local job = self.currentPfn.TypeBranch
    local id = self.currentPfn.id
    local num = id - math.floor(id / 10) * 10
    local joblv = num * 40 + 10
    if num >= 3 then
      joblv = joblv + 30
    end
    local list = {}
    if self.currentPfn.Explain then
      for i = 1, #GameConfig.ClassInitialAttr do
        local single = GameConfig.ClassInitialAttr[i]
        local prop = Game.Myself.data.props[single]
        local value = CommonFun.calProfessionPropValue(joblv, job, single)
        if value > 0 then
          local data = {}
          data.name = prop.propVO.displayName .. prop.propVO.name
          data.value = value
          table.insert(list, data)
        end
      end
      self.propGrid:ResetDatas(list)
      local _, y = LuaGameObject.GetLocalPosition(self.propGridView.transform)
      local bound = NGUIMath.CalculateRelativeWidgetBounds(self.propGridView.transform, true)
      local height = bound.size.y
      local x, _, z = LuaGameObject.GetLocalPosition(self.professionSpc.transform)
      tempVector3:Set(x, y - height, z)
      self.professionSpc.text = string.format(ZhString.Charactor_ProfessionInfoSpc, self.currentPfn.Explain)
    end
    TableUtility.ArrayClear(tempArray)
    local skills = self.currentPfn.Skill
    if skills then
      for i = 1, #skills do
        local data = {}
        data[1] = self.currentPfn.id
        data[2] = skills[i]
        tempArray[#tempArray + 1] = data
      end
      self.gridList:ResetDatas(tempArray)
    end
    self.scrollView:ResetPosition()
  end
  self:showRoleModel(agentData)
end
