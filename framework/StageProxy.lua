autoImport("StageBagData")
autoImport("StageBagItemIndex")
autoImport("StageInfoData")
autoImport("Asset_Role")
StageProxy = class("StageProxy", pm.Proxy)
StageProxy.Instance = nil
StageProxy.NAME = "StageProxy"
StageProxy.TabType = {EquipTab = 1, OutfitTab = 2}
StageProxy.JoinType = {Single = 0, Double = 1}
StageProxy.StageType = {
  A = 1,
  B = 2,
  C = 3
}
StageProxy.TabConfig = {
  [1] = {
    Config = GameConfig.ItemDress[1]
  },
  [2] = {
    Config = GameConfig.ItemDress[2]
  },
  [3] = {
    Config = GameConfig.ItemDress[3]
  },
  [4] = {
    Config = GameConfig.ItemDress[4]
  },
  [5] = {
    Config = GameConfig.ItemDress[5]
  },
  [6] = {
    Config = GameConfig.ItemDress[6]
  },
  [7] = {
    Config = GameConfig.ItemDress[7]
  },
  [8] = {
    Config = GameConfig.ItemDress[9]
  },
  [9] = {
    Config = GameConfig.ItemOutfit[1]
  },
  [10] = {},
  [11] = {
    Config = GameConfig.ItemOutfit[2]
  }
}
function StageProxy:ctor(proxyName, data)
  self.proxyName = proxyName or StageProxy.NAME
  if StageProxy.Instance == nil then
    StageProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.joinType = StageProxy.JoinType.Single
  self.stageReplace = nil
end
function StageProxy:InitStageData()
  local tabIndex
  self.stageBagTab = {}
  for i = 1, #StageProxy.TabConfig do
    self.stageBagTab[i] = StageBagData.new(i)
  end
  local userdata = Game.Myself.data.userdata
  local myPro = userdata:Get(UDEnum.PROFESSION)
  local mySex = userdata:Get(UDEnum.SEX)
  for k, v in pairs(StageBagItemIndex) do
    local len = #v
    for i = 1, len do
      local single = ItemData.new("StageBag", v[i])
      if StageBagData.CheckValid(single.staticData) then
        if single.equipInfo and single.equipInfo:CanUseByProfess(myPro) then
          local sexEquip = single.equipInfo.equipData.SexEquip or 0
          if sexEquip == 0 or sexEquip == mySex then
            self.stageBagTab[k]:AddItem(v[i], single)
          end
        elseif single:HairCanEquip() then
          self.stageBagTab[k]:AddItem(v[i], single)
        end
      end
    end
  end
  for k, v in pairs(Table_HairColor) do
    if StageBagData.CheckValid(v) then
      self.stageBagTab[10]:AddColor(k)
    end
  end
  for k, v in pairs(Table_Eye) do
    if mySex == v.Sex or v.Sex == 3 then
      local singleEye = ItemData.new("StageBag", v.id)
      if singleEye.staticData and StageBagData.CheckValid(singleEye.staticData) then
        self.stageBagTab[11]:AddItem(v.id, singleEye)
      end
    end
  end
end
function StageProxy:RecvStageReplce(serverdata)
  if serverdata then
    if serverdata.userid then
      local pid
      if not self.hidingMap then
        self.hidingMap = {}
      end
      for i = 1, #serverdata.userid do
        pid = serverdata.userid[i]
        self.hidingMap[pid] = pid
      end
    end
    if serverdata.stageid then
      self.currentStageid = serverdata.stageid
    end
    if serverdata.datas then
      if self.stageReplace == nil then
        self.stageReplace = {}
      end
      for i = 1, #serverdata.datas do
        local single = serverdata.datas[i]
        self.stageReplace[single.type] = single.value
      end
    end
    local stageCreature = NSceneNpcProxy.Instance:FindNpcs(self.currentStageid)
    stageCreature = stageCreature and stageCreature[1]
    if not stageCreature then
      redlog("not stageCreature")
    else
      stageCreature:ReDress()
    end
  end
end
function StageProxy:ClearStageReplaceCache()
  if self.hidingMap then
    TableUtility.TableClear(self.hidingMap)
  end
  if self.stageReplace then
    TableUtility.TableClear(self.stageReplace)
  end
  if self.currentStageid then
    local stageCreature = NSceneNpcProxy.Instance:FindNpcs(self.currentStageid)
    stageCreature = stageCreature and stageCreature[1]
    if not stageCreature then
      redlog("not stageCreature")
    else
      stageCreature:ReDress()
    end
  end
end
function StageProxy:getTabByItem(item, type)
  if item == nil then
    return
  end
  local tab
  local types = {}
  for k, v in pairs(GameConfig.ItemDress) do
    for i = 1, #v.types do
      if item.Type == v.types[i] then
        return k
      end
    end
  end
  return tab
end
function StageProxy:GetItemsByTab(tab)
  return self.stageBagTab[tab].items
end
function StageProxy:GetColorsByTab(tab)
  return self.stageBagTab[tab].colors
end
function StageProxy:TakeNpcData(nnpc)
  self.nnpc = nnpc
end
function StageProxy:RecvStageInfo(serverdata)
  if serverdata.info then
    local len = #serverdata.info
    for i = 1, len do
      local single = StageInfoData.new(serverdata.info[i])
      if not self.stageInfoMap then
        self.stageInfoMap = {}
      end
      self.stageInfoMap[single.id] = single
      self.beginTime = ServerTime.CurServerTime()
      self.showtime = single.waittime
      if len == 1 then
        self.currentStageid = single.id
      end
    end
  end
end
local members = 0
function StageProxy:ShowDialog()
  local str = ZhString.Stage_Dialog_Pre
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {str},
    addfunc = {
      [1] = {
        event = function()
          self.joinType = StageProxy.JoinType.Single
          StageProxy.Instance:ShowChooseStage()
        end,
        closeDialog = true,
        NameZh = ZhString.Stage_Dialog_Sinlge
      }
    }
  }
  viewdata.addfunc[2] = {
    event = function()
      self.joinType = StageProxy.JoinType.Double
      StageProxy.Instance:ShowChooseStage()
    end,
    closeDialog = true,
    NameZh = ZhString.Stage_Dialog_Double
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
local stagelist = GameConfig.DressUp.stageid
function StageProxy:ShowChooseStage()
  if self.joinType == StageProxy.JoinType.Double then
    if not TeamProxy.Instance:CheckImTheLeader() then
      MsgManager.ShowMsgByID(25528)
      return
    end
    members = #TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
    if members ~= 2 then
      MsgManager.ShowMsgByID(25526)
      return
    end
  end
  local subviewdata = {
    viewname = "DialogView",
    dialoglist = {
      ZhString.Stage_Dialog_Choose
    },
    addfunc = {
      [1] = {
        event = function()
          StageProxy.Instance.stageType = StageProxy.StageType.A
          self.currentStageid = stagelist[StageProxy.StageType.A]
          ServiceNUserProxy.Instance:CallQueryStageUserCmd(self.currentStageid)
          GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.JoinStagePopUp
          })
        end,
        closeDialog = true,
        NameZh = ZhString.Stage_Name_A
      }
    }
  }
  subviewdata.addfunc[2] = {
    event = function()
      StageProxy.Instance.stageType = StageProxy.StageType.B
      self.currentStageid = stagelist[StageProxy.StageType.B]
      ServiceNUserProxy.Instance:CallQueryStageUserCmd(self.currentStageid)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.JoinStagePopUp
      })
    end,
    closeDialog = true,
    NameZh = ZhString.Stage_Name_B
  }
  subviewdata.addfunc[3] = {
    event = function()
      StageProxy.Instance.stageType = StageProxy.StageType.C
      self.currentStageid = stagelist[StageProxy.StageType.C]
      ServiceNUserProxy.Instance:CallQueryStageUserCmd(self.currentStageid)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.JoinStagePopUp
      })
    end,
    closeDialog = true,
    NameZh = ZhString.Stage_Name_C
  }
  FunctionNpcFunc.ShowUI(subviewdata)
end
function StageProxy:GetCurrentStageid()
  return self.currentStageid
end
function StageProxy:IsVisible(guid)
  if not self.hidingMap then
    return nil
  end
  return self.hidingMap[guid]
end
function StageProxy:GetWaitTime()
  if self.stageInfoMap and self.stageInfoMap[self.currentStageid] then
    return self.stageInfoMap[self.currentStageid].waittime
  end
end
function StageProxy:GetStageReplace()
  return self.stageReplace
end
