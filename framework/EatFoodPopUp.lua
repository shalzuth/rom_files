EatFoodPopUp = class("EatFoodPopUp", BaseView)
autoImport("GainWayTip")
autoImport("ItemTipComCell")
EatFoodPopUp.ViewType = UIViewType.PopUpLayer
function EatFoodPopUp:Init()
  self:InitView()
  self:MapEvent()
end
function EatFoodPopUp:InitView()
  self.root = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIRoot)
  self.itemGO = self:FindGO("ItemTipComCell")
  self.foodCell = ItemTipComCell.new(self.itemGO)
  self.foodCell:AddEventListener(ItemTipEvent.ClickTipFuncEvent, self.HandleClickTip, self)
  self.foodCell:AddEventListener(ItemTipEvent.ShowGetPath, self.ShowGetPath, self)
  self.eatingTip = self:FindComponent("EatingTip", UILabel)
  self.gpContainer = self:FindGO("GetPathContainer")
  self.closecomp = self.itemGO:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  self.editPowerBord = self:FindGO("EditorPowerBord")
  local public_EditButton = self:FindGO("ItemFuncButtonCell1")
  self:AddClickEvent(public_EditButton, function(go)
    self:EditEatPower(SceneFood_pb.EEATPOWR_ALL)
  end)
  local team_EditButton = self:FindGO("ItemFuncButtonCell2")
  self:AddClickEvent(team_EditButton, function(go)
    self:EditEatPower(SceneFood_pb.EEATPOWR_TEAM)
  end)
  local self_EditButton = self:FindGO("ItemFuncButtonCell3")
  self:AddClickEvent(self_EditButton, function(go)
    self:EditEatPower(SceneFood_pb.EEATPOWR_SELF)
  end)
  self.editPowerButton = self:FindGO("EditPowerButton")
  self:AddClickEvent(self.editPowerButton, function(go)
    self:CloseGetPath()
    self.editPowerBord:SetActive(true)
  end)
  self.foodCell.itemcell:ShowNum()
  self.foodCell.dontUpdateCellCount = true
  local label = self:FindComponent("Label", UILabel, team_EditButton)
  OverseaHostHelper:FixLabelOverV1(label, 3, 180)
  local title = self:FindGO("Title", self.editPowerBord):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(title, 3, 200)
end
local tempV3 = LuaVector3()
function EatFoodPopUp:ShowGetPath(cell)
  if cell and cell.gameObject then
    self.editPowerBord:SetActive(false)
    if not self.bdt then
      tempV3:Set(1, 1, 1)
      self.gpContainer.transform.localScale = tempV3
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(self.gpContainer.transform)
      if x > 0 then
        tempV3:Set(lx - 210, ly + 271, 0)
      else
        tempV3:Set(lx + 210, ly + 271, 0)
      end
      self.gpContainer.transform.localPosition = tempV3
      local data = cell.data
      if data and data.staticData then
        self.bdt = GainWayTip.new(self.gpContainer)
        self.bdt:SetAnchorPos(x <= 0)
        self.bdt:SetData(data.staticData.id)
        self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
          self:CloseSelf()
        end, self)
        self.bdt:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.bdt.gameObject)
        self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
      end
    else
      self.bdt:OnExit()
    end
  end
end
function EatFoodPopUp:CloseGetPath()
  if self.bdt then
    self.bdt:OnExit()
    self.bdt = nil
  end
end
function EatFoodPopUp:GetPathCloseCall()
  self.closecomp:ReCalculateBound()
  self.bdt = nil
end
function EatFoodPopUp:EditEatPower(power)
  ServiceSceneFoodProxy.Instance:CallEditFoodPower(self.npcguid, power)
end
function EatFoodPopUp:HandleClickTip()
  self:CloseSelf()
end
function EatFoodPopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.SceneFoodQueryFoodNpcInfo, self.HandleUpdateFoodInfo)
end
function EatFoodPopUp:HandleUpdateFoodInfo(note)
  local server_data = note.body
  if server_data and server_data.npcguid == self.npcguid then
    if server_data.itemid and server_data.itemid ~= 0 and 0 < server_data.itemnum then
      local itemData = ItemData.new("Food", server_data.itemid)
      itemData:SetItemNum(server_data.itemnum)
      self.foodCell:SetData(itemData)
      self.foodCell:UpdateNoneItemTipCountChooseBord(server_data.itemnum)
      self.foodCell:ActiveGetPath(true)
      helplog("HandleUpdateFoodInfo:", server_data.itemid)
      if server_data.itemid == 551910 then
        helplog("1")
        self.foodCell:UpdateCountChooseBord(1)
      end
    end
    self.foodCell:SetReplaceInfo(string.format(ZhString.EatFoodPopUp_EatTip, server_data.eating_people))
    self.editPowerButton:SetActive(server_data.ownerid == Game.Myself.data.id)
    self.itemGO:SetActive(true)
  end
  if not self.initFunc then
    self.initFunc = true
    self.foodCell:AddTipFunc(ZhString.EatFoodPopUp_EatSelf, EatFoodPopUp.EatSelf, {
      self.npcguid,
      self.foodCell,
      self
    })
    local myPetInfo = PetProxy.Instance:GetMyPetInfoData()
    if myPetInfo ~= nil then
      self.foodCell:AddTipFunc(ZhString.EatFoodPopUp_PetEat, EatFoodPopUp.PetEat, {
        self.npcguid,
        self.foodCell
      })
    end
  end
end
function EatFoodPopUp.EatSelf(param)
  local guid, foodCell, eatPopup = param[1], param[2], param[3]
  local foodList = FoodProxy.Instance:GetEatFoods()
  local currentEatFoodCount = #foodList
  local overrideNotice = LocalSaveProxy.Instance:GetFoodBuffOverrideNoticeShow()
  local level = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
  local tasteLvInfo = Table_TasterLevel[level]
  local foodMaxCount = 3
  if tasteLvInfo then
    foodMaxCount = tasteLvInfo.AddBuffs
  end
  local itemId = foodCell and foodCell.data and foodCell.data.staticData and foodCell.data.staticData.id or 0
  if overrideNotice and foodMaxCount < currentEatFoodCount + foodCell.chooseCount and itemId ~= 551019 then
    eatPopup:CloseSelf()
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "FoodOverridePopView",
      foodNpcId = guid,
      foodItemId = itemId,
      foodCount = foodCell.chooseCount
    })
  else
    ServiceSceneFoodProxy.Instance:CallStartEat(guid, false, foodCell.chooseCount)
  end
end
function EatFoodPopUp.PetEat(param)
  local guid, foodCell = param[1], param[2]
  if foodCell.chooseCount == 1 then
    ServiceSceneFoodProxy.Instance:CallStartEat(guid, true, foodCell.chooseCount)
  else
    MsgManager.ShowMsgByID(25429)
  end
end
function EatFoodPopUp:UpdateFoodInfo()
end
function EatFoodPopUp:AddIgnoreBounds(obj)
  if self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function EatFoodPopUp:OnEnter()
  EatFoodPopUp.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.npcguid = viewdata.npcguid
    if self.npcguid then
      ServiceSceneFoodProxy.Instance:CallQueryFoodNpcInfo(self.npcguid)
    end
  end
end
function EatFoodPopUp:OnExit()
  EatFoodPopUp.super.OnExit(self)
  self.editPowerBord:SetActive(false)
end
