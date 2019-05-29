autoImport("BaseTip")
PlayerTip = class("PlayerTip", BaseTip)
local FindCreature = SceneCreatureProxy.FindCreature
function PlayerTip:Init()
  self:InitTip()
end
function PlayerTip:InitTip()
  local cellObj = self:FindGO("HeadFace")
  self.faceCell = PlayerFaceCell.new(cellObj)
  self.faceCell:HideHpMp()
  self.idObj = self:FindGO("Id")
  self.bg = self:FindComponent("Bg", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.guildName = self:FindComponent("GuildName", UILabel)
  self.id = self.idObj:GetComponent(UILabel)
  self.idlabel = self:FindComponent("Label", UILabel, self.idObj)
  self.labExpireTime = self:FindComponent("labExpireTime", UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  self.grid = self:FindComponent("FuncGrid", UIGrid)
  self.funcCtl = UIGridListCtrl.new(self.grid, RClickFuncCell, "PlayerTipFuncCell")
  self.funcCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)
  local sgrid = self:FindComponent("SocialGrid", UIGrid)
  self.socialCtl = UIGridListCtrl.new(sgrid, SocialIconCell, "SocialIconCell")
  self.socialCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)
  self:InitChildBord()
  self.idlabel.transform.localPosition = Vector3(28, 0, 0)
end
function PlayerTip:AcitiveIdObj(b)
  self.idObj:SetActive(b)
end
function PlayerTip:ActiveCatExpireTimeObj(b)
  self.labExpireTime.gameObject:SetActive(b)
end
function PlayerTip:ClickCell(cellCtl)
  local funcData = cellCtl.data
  if funcData == nil then
    self:CloseSelf()
    return
  end
  local key = funcData.key
  if key == "Double_Action" then
    self:ShowChildBord()
    self.closecomp:ReCalculateBound()
    return
  end
  local func = FunctionPlayerTip.Me():GetFuncByKey(key)
  if func then
    func(self.playerTipData)
  end
  if self.clickcallback then
    self.clickcallback(funcData)
  end
  self:CloseSelf()
end
function PlayerTip:CloseSelf()
  if self.closecallback then
    self.closecallback()
  end
  FunctionPlayerTip.Me():CloseTip()
end
function PlayerTip:OnEnter()
end
function PlayerTip:SetData(data)
  self.closecomp:ClearTarget()
  self:RemoveExpireTimeCheck()
  if data then
    local playerTipData = data.playerData
    if playerTipData then
      local headData = playerTipData.headData
      self.faceCell:SetData(headData)
      local level = playerTipData.level or 0
      self.name.text = string.format("Lv.%s %s", level, playerTipData.name)
      if playerTipData.cat and playerTipData.cat ~= 0 then
        self:AcitiveIdObj(false)
        self.expiretime = playerTipData.expiretime or 0
        self:AddExpireTimeCheck()
        self.guildName.text = string.format(ZhString.PlayerTip_MasterTip, playerTipData.mastername)
      else
        local showId = playerTipData.id
        if type(showId) ~= "number" then
          showId = tonumber(showId)
        end
        if type(showId) == "number" then
          self:AcitiveIdObj(true)
          local limitNum = math.floor(math.pow(10, 12))
          self.idlabel.text = string.format("%s", math.floor(showId % limitNum))
          self.id.text = "ID:"
        else
          self:AcitiveIdObj(false)
        end
        if playerTipData.guildname and playerTipData.guildname ~= "" then
          self.guildName.text = string.format(ZhString.PlayerTip_GuildTip, playerTipData.guildname)
        else
          self.guildName.text = ZhString.PlayerTip_NoGuildTip
        end
      end
      self:UpdateTipFunc(data.funckeys, playerTipData)
      self.playerTipData = playerTipData
    end
    self.closecallback = data.closecallback
  end
end
function PlayerTip:UpdateTipFunc(funckeys, playerTipData)
  funckeys = funckeys or FunctionPlayerTip.Me():GetPlayerFunckey(playerTipData.id)
  if funckeys then
    local funcDatas = {}
    local socialDatas = {}
    FunctionPlayerTip.Me():SetWhereIClickThisIcon(self:GetWhereIClickThisIcon())
    for i = 1, #funckeys do
      local config = FunctionPlayerTip.Me():GetFuncByKey()
      local state, otherName = FunctionPlayerTip.Me():CheckTipFuncStateByKey(funckeys[i], playerTipData)
      local socialState = FunctionPlayerTip.Me():CheckTipSocialStateByKey(funckeys[i], playerTipData)
      if state ~= PlayerTipFuncState.InActive and socialState == 0 then
        local tempData = {}
        tempData.key = funckeys[i]
        tempData.state = state
        tempData.playerTipData = playerTipData
        tempData.otherName = otherName
        table.insert(funcDatas, tempData)
      elseif state ~= PlayerTipFuncState.InActive and socialState ~= 0 then
        local singleData = {}
        singleData.key = funckeys[i]
        singleData.socialState = socialState
        singleData.playerTipData = playerTipData
        singleData.otherName = otherName
        table.insert(socialDatas, singleData)
        table.sort(socialDatas, function(l, r)
          local lstate = math.modf(l.socialState / 10)
          local rstate = math.modf(r.socialState / 10)
          return lstate < rstate
        end)
      end
    end
    local offset = #socialDatas ~= 0 and 1 or 0
    local x = self.grid.gameObject.transform.localPosition.x
    self.grid.gameObject.transform.localPosition = Vector3(x, -161 - 60 * offset, 0)
    self.socialCtl:ResetDatas(socialDatas)
    self.funcCtl:ResetDatas(funcDatas)
    self.bg.height = 165 + 60 * math.floor((#funcDatas + 1) / 2) + 60 * offset
  else
    self.bg.height = 165
  end
  self:ResizeChildBord()
  TipsView.Me():ConstrainCurrentTip()
end
function PlayerTip:UpdateFuncState(funcKey, state, newName)
  local keyCell = self:GetFuncCell(funcKey)
  if keyCell then
    keyCell:SetState(state)
    if newName then
      keyCell:SetName(newName)
    end
  end
end
function PlayerTip:ChangeFunc(changeKey, toKey)
  if changeKey == toKey then
    return
  end
  local keyCell = self:GetFuncCell(changeKey)
  if keyCell then
    local playerTipData = self.playerTipData
    if not playerTipData then
      return
    end
    local state = FunctionPlayerTip.Me():CheckTipFuncStateByKey(toKey, playerTipData)
    if state ~= PlayerTipFuncState.InActive then
      local tempData = {}
      tempData.key = toKey
      tempData.state = state
      tempData.playerTipData = playerTipData
      keyCell:SetData(tempData)
    end
  end
end
function PlayerTip:GetFuncCell(key)
  local keyCell
  local cells = self.funcCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    local data = cell and cell.data
    if data and data.key == key then
      keyCell = cell
      break
    end
  end
  return keyCell
end
function PlayerTip:OnExit()
  self:RemoveExpireTimeCheck()
  return true
end
function PlayerTip:DestroySelf()
  GameObject.Destroy(self.gameObject)
end
function PlayerTip:AddIgnoreBound(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function PlayerTip:SetDesc(s1, s2, s3)
  self.name.text = s1
  self.guildName.text = s2
  self.id.text = s3
  self.idlabel.text = ""
end
autoImport("UIEmojiCell")
function PlayerTip:InitChildBord()
  self.childBord = self:FindGO("ChildBord")
  self.child_Bg = self:FindComponent("CBg", UISprite, self.childBord)
  self.child_actionGrid = self:FindComponent("ActionGrid", UIGrid, self.childBord)
  self.childCtl = UIGridListCtrl.new(self.child_actionGrid, UIEmojiCell, "UIEmojiCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickActionCell, self)
end
function PlayerTip:ClickActionCell(cell)
  local data = Table_ActionAnime[cell.id]
  local d_action = data.DoubleAction
  if d_action == nil then
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  if myTeam == nil then
    return
  end
  local memberData = myTeam:GetMemberByGuid(self.playerTipData.id)
  if memberData == nil then
    return
  end
  if memberData:IsOffline() then
    MsgManager.ShowMsgByIDTable(3247)
    return
  end
  local player = FindCreature(self.playerTipData.id)
  if player == nil then
    MsgManager.ShowMsgByIDTable(27101)
    return
  end
  if player:IsInBooth() then
    MsgManager.ShowMsgByIDTable(407)
    return
  end
  local followId = Game.Myself:Client_GetFollowLeaderID()
  local isHandFollow = Game.Myself:Client_IsFollowHandInHand()
  local handFollowerId = Game.Myself:Client_GetHandInHandFollower()
  local handTargetId = isHandFollow and followId or handFollowerId
  if handTargetId and handTargetId ~= 0 then
    MsgManager.ShowMsgByIDTable(832)
    return
  end
  local bits1 = CommonFun.getBits(player.data:GetProperty("AttrEffect2"))
  if 0 < bits1[CommonFun.AttrEffect2.BeMagicMachine] then
    MsgManager.ShowMsgByIDTable(832)
    return
  end
  local bits2 = CommonFun.getBits(Game.Myself.data:GetProperty("AttrEffect2"))
  if 0 < bits2[CommonFun.AttrEffect2.BeMagicMachine] then
    MsgManager.ShowMsgByIDTable(832)
    return
  end
  local sex = memberData.gender
  local mysex = MyselfProxy.Instance:GetMySex()
  local sam = mysex == sex and 2 or 1
  if d_action & sam == 0 then
    MsgManager.ShowMsgByIDTable(27104)
    return
  end
  ServiceNUserProxy.Instance:CallTwinsActionUserCmd(self.playerTipData.id, cell.id, SceneUser2_pb.ETWINS_OPERATION_REQUEST)
  self:HideChildBord()
end
function PlayerTip:ResizeChildBord()
  self.child_Bg.height = self.bg.height
end
function PlayerTip:UpdateChildBordData()
  if not self.d_actdata then
    self.d_actdata = {}
  else
    TableUtility.ArrayClear(self.d_actdata)
  end
  local actionMap = MyselfProxy.Instance:GetUnlockActionMap()
  for _, actionData in pairs(Table_ActionAnime) do
    if actionData.DoubleAction ~= nil then
      local prefix = string.sub(actionData.Name, 1, 3)
      if prefix ~= "be_" then
        local actionCellData = {}
        actionCellData.type = UIEmojiType.Action
        actionCellData.id = actionData.id
        actionCellData.name = actionData.Name
        table.insert(self.d_actdata, actionCellData)
      end
    end
  end
  self.childCtl:ResetDatas(self.d_actdata)
end
function PlayerTip:ShowChildBord()
  self.childBord:SetActive(true)
  self:UpdateChildBordData()
end
function PlayerTip:HideChildBord()
  self.childBord:SetActive(false)
end
function PlayerTip:HideGuildInfo()
  self.guildName.gameObject:SetActive(false)
end
function PlayerTip:AddExpireTimeCheck()
  local leftTime
  if self.masterid ~= nil and self.masterid ~= Game.Myself.data.id then
    leftTime = 0
  else
    leftTime = self.expiretime - ServerTime.CurServerTime() / 1000
  end
  if leftTime > 0 then
    self:ActiveCatExpireTimeObj(true)
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._Tick, self)
  else
    self:ActiveCatExpireTimeObj(false)
  end
end
function PlayerTip:_Tick(deltatime)
  local leftTime = self.expiretime - ServerTime.CurServerTime() / 1000
  if leftTime > 0 then
    self:UpdateLeftTime(leftTime)
  else
    self:RemoveExpireTimeCheck()
  end
end
function PlayerTip:UpdateLeftTime(leftTime)
  local timeText = ""
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  if day > 0 then
    timeText = string.format(ZhString.PlayerTip_ExpireTime, day + 1)
    self.labExpireTime.text = timeText .. ZhString.PlayerTip_Day
  else
    timeText = string.format("%02d:%02d:%02d", hour, min, sec)
    self.labExpireTime.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
  end
end
function PlayerTip:RemoveExpireTimeCheck()
  self.expiretime = 0
  self:ActiveCatExpireTimeObj(false)
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
  end
  self.timeTick = nil
end
PlayerTipSource = {FromTeam = 1, FromGuild = 2}
function PlayerTip:SetWhereIClickThisIcon(where)
  helplog("=======================From FromTeam==================")
  self.whereClick = where
end
function PlayerTip:GetWhereIClickThisIcon()
  return self.whereClick or PlayerTipSource.FromTeam
end
