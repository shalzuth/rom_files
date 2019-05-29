autoImport("PlayerSelectCell")
MainViewPlayerSelectBoard = class("MainViewPlayerSelectBoard", SubView)
local tmpDataArray = {}
local vecBoardOpenPos = LuaVector3(220, 0, 0)
local vecArrowOpenEuler = LuaVector3(0, 0, 180)
function MainViewPlayerSelectBoard:Init()
  self:InitView()
  self:AddViewEvts()
  self:AddBtnEvts()
  self.playerDatas = {}
end
function MainViewPlayerSelectBoard:InitView()
  local tsfParent = self:FindGO("Anchor_DownLeft").transform
  self:ReLoadPerferb("view/MainViewPlayerSelectBoard")
  self.trans:SetParent(tsfParent, false)
  self.objMoveRoot = self:FindGO("MoveRoot")
  self.objBtnShow = self:FindGO("btnShow", self.objMoveRoot)
  self.tsfArrow = self:FindGO("Sprite", self.objBtnShow).transform
  self.listPlayers = UIGridListCtrl.new(self:FindComponent("gridPlayers", UIGrid, self.objMoveRoot), PlayerSelectCell, "PlayerSelectCell")
  self:HideView()
end
function MainViewPlayerSelectBoard:AddViewEvts()
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.ShowView)
  self:AddListenEvt(PVPEvent.TeamPws_ShutDown, self.HideView)
  self:AddListenEvt(SceneUserEvent.SceneAddRoles, self.RefreshPlayerDatas)
  self:AddListenEvt(SceneUserEvent.SceneRemoveRoles, self.RefreshPlayerDatas)
  self:AddListenEvt(ServiceEvent.NUserUserNineSyncCmd, self.RefreshPlayerDatas)
  self:AddDispatcherEvt(CreatureEvent.Player_CampChange, self.RefreshPlayerDatas)
  self:AddDispatcherEvt(CreatureEvent.Hiding_Change, self.RefreshPlayerDatas)
  self.listPlayers:AddEventListener(MouseEvent.MouseClick, self.ClickPlayerCell, self)
end
function MainViewPlayerSelectBoard:AddBtnEvts()
  self:AddClickEvent(self.objBtnShow, function()
    self:ShowBoard(not self.isBoardShow)
  end)
end
function MainViewPlayerSelectBoard:RefreshPlayerDatas()
  if Game.MapManager:IsPVPMode_TeamPws() then
    self:SetEnemyDatas()
  end
end
function MainViewPlayerSelectBoard:SetEnemyDatas()
  if not self.isBoardShow then
    return
  end
  TableUtility.ArrayClear(tmpDataArray)
  local userMap = NSceneUserProxy.Instance.userMap
  for _, player in pairs(userMap) do
    if player:GetCreatureType() == Creature_Type.Player and player.data and player.data:GetCamp() == RoleDefines_Camp.ENEMY then
      tmpDataArray[#tmpDataArray + 1] = player
    end
  end
  self:SetDatas(tmpDataArray)
end
function MainViewPlayerSelectBoard:SetDatas(datas)
  if not self.isBoardShow then
    return
  end
  TableUtility.ArrayClear(self.playerDatas)
  local myPos = Game.Myself:GetPosition()
  table.sort(datas, function(a, b)
    return Vector3.Distance(a:GetPosition(), myPos) < Vector3.Distance(b:GetPosition(), myPos)
  end)
  for i = 1, math.min(#datas, 6) do
    self.playerDatas[#self.playerDatas + 1] = datas[i]
  end
  self.listPlayers:ResetDatas(self.playerDatas)
end
function MainViewPlayerSelectBoard:ClickPlayerCell(cell)
  Game.Myself:Client_LockTarget(cell.data)
end
function MainViewPlayerSelectBoard:ShowBoard(isShow)
  if self.isBoardShow == isShow then
    return
  end
  TweenPosition.Begin(self.objMoveRoot, 0.2, isShow and vecBoardOpenPos or LuaVector3.zero).method = 2
  self.tsfArrow.localEulerAngles = isShow and vecArrowOpenEuler or LuaVector3.zero
  self.isBoardShow = isShow
  if isShow then
    self:RefreshPlayerDatas()
  end
end
function MainViewPlayerSelectBoard:ShowView()
  self.gameObject:SetActive(true)
end
function MainViewPlayerSelectBoard:HideView()
  if self.isBoardShow ~= false then
    self.objMoveRoot.transform.localPosition = LuaVector3.zero
    self.tsfArrow.localEulerAngles = LuaVector3.zero
    self.isBoardShow = false
  end
  self.gameObject:SetActive(false)
end
function MainViewPlayerSelectBoard:OnEnter()
  MainViewPlayerSelectBoard.super.OnEnter(self)
end
