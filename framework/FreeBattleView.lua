autoImport("FreeBattleDungeonCell")
FreeBattleView = class("FreeBattleView", SubView)
local freeBattleView_Path = ResourcePathHelper.UIView("FreeBattleView")
FreeBattleView.TexUp = "pvp_bg_06"
local T_PVP_TYPE
function FreeBattleView:Init()
  local roomID, pwsConfig = next(GameConfig.PvpTeamRaid_Relax)
  self.pwsConfig = pwsConfig
  self.roomID = roomID
  T_PVP_TYPE = PvpProxy.Type.FreeBattle
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end
function FreeBattleView:FindObjs()
  self:LoadSubView()
  local gridDungeon = self:FindComponent("dungeonGrid", UIGrid, self.objRoot)
  self.listDungeon = UIGridListCtrl.new(gridDungeon, FreeBattleDungeonCell, "FreeBattleDungeonCell")
  self.objBtnMatch = self:FindGO("MatchBtn", self.objRoot)
  self.colBtnMatch = self.objBtnMatch:GetComponent(BoxCollider)
  self.sprBtnMatch = self:FindComponent("BG", UISprite, self.objBtnMatch)
  self.objEnableMatchBtnLabel = self:FindGO("enableLabel", self.objBtnMatch)
  self.objDisableMatchBtnLabel = self:FindGO("disableLabel", self.objBtnMatch)
end
function FreeBattleView:LoadSubView()
  self.objRoot = self:FindGO("FreeBattleView")
  local obj = self:LoadPreferb_ByFullPath(freeBattleView_Path, self.objRoot, true)
  obj.name = "FreeBattleView"
end
function FreeBattleView:AddBtnEvts()
  self:AddClickEvent(self:FindGO("RuleBtn", self.objRoot), function()
    self:ClickButtonRule()
  end)
  self:AddClickEvent(self.objBtnMatch, function()
    self:ClickButtonMatch()
  end)
end
function FreeBattleView:AddViewEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.UpdateView)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.UpdateView)
  self.listDungeon:AddEventListener(MouseEvent.MouseClick, self.SelectDungeon, self)
end
function FreeBattleView:InitShow()
  PictureManager.Instance:SetPVP(FreeBattleView.TexUp, self:FindComponent("upTexture", UITexture, self.objRoot))
  self:UpdateView()
end
function FreeBattleView:UpdateView()
  local btnMatchEnable = true
  local matchStatus = PvpProxy.Instance:GetMatchState(T_PVP_TYPE)
  local teamPwsMatchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.TeamPws)
  if matchStatus and matchStatus.ismatch or teamPwsMatchStatus and teamPwsMatchStatus.ismatch or Game.MapManager:IsPVPMode_TeamPws() then
    btnMatchEnable = false
  end
  self.colBtnMatch.enabled = btnMatchEnable
  if btnMatchEnable then
    self:SetTextureWhite(self.sprBtnMatch)
  else
    self:SetTextureGrey(self.sprBtnMatch)
  end
  self.objEnableMatchBtnLabel:SetActive(btnMatchEnable)
  self.objDisableMatchBtnLabel:SetActive(not btnMatchEnable)
end
function FreeBattleView:InitDungeonList()
  self.listDungeon:ResetDatas(self.pwsConfig.RaidMaps)
  local cells = self.listDungeon:GetCells()
  if cells and #cells > 0 then
    self:SelectDungeon(cells[1])
  end
end
function FreeBattleView:SelectDungeon(cell)
  if self.selectCell then
    if self.selectCell.id == cell.id then
      return
    end
    self.selectCell:Select(false)
  end
  self.selectCell = cell
  self.selectCell:Select(true)
end
function FreeBattleView:ClickButtonRule()
  local panelId = PanelConfig.FreeBattleView.id
  local Desc = Table_Help[panelId] and Table_Help[panelId].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(Desc)
end
function FreeBattleView:ClickButtonMatch()
  if not self.selectCell or self.disableClick then
    return
  end
  local valid = TeamProxy.Instance:CheckMatchValid(self.pwsConfig.matchid) and PvpProxy.Instance:CheckPwsMatchValid(true, self.selectCell.id)
  if valid then
    if TeamProxy.Instance:IHaveTeam() then
      local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
      if #memberlst < GameConfig.Team.maxmember then
        MsgManager.ConfirmMsgByID(25904, function()
          self:CallMatch()
        end, nil)
        return
      end
    end
    self:CallMatch()
  end
end
function FreeBattleView:CallMatch()
  if not self.selectCell or self.disableClick then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(T_PVP_TYPE, self.selectCell.id)
  self.disableClick = true
  self.ltDisableClick = LeanTween.delayedCall(3, function()
    self.disableClick = false
    self.ltDisableClick = nil
  end)
end
function FreeBattleView:OnEnter()
  FreeBattleView.super.OnEnter(self)
  self:InitDungeonList()
  self:UpdateView()
end
function FreeBattleView:OnExit()
  PictureManager.Instance:UnLoadPVP()
  if self.ltDisableClick then
    self.ltDisableClick:cancel()
    self.ltDisableClick = nil
  end
  FreeBattleView.super.OnExit(self)
end
