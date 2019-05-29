GuildJobEditPopUp = class("GuildJobEditPopUp", ContainerView)
GuildJobEditPopUp.ViewType = UIViewType.PopUpLayer
autoImport("GuildJobEditCell")
function GuildJobEditPopUp:Init()
  self.changeNames = {}
  self.changeAuths = {}
  self.changeEditAuths = {}
  self.filterType = GameConfig.MaskWord.GuildProfession
  self:InitUI()
end
function GuildJobEditPopUp:InitUI()
  local grid = self:FindComponent("JobGrid", UIGrid)
  self.jobCtl = UIGridListCtrl.new(grid, GuildJobEditCell, "GuildJobEditCell")
  self.jobCtl:AddEventListener(GuildJobEditEvent.NameChange, self.NameChange, self)
  self.jobCtl:AddEventListener(GuildJobEditEvent.AuthorityChange, self.AuthorityChange, self)
  self.jobCtl:AddEventListener(GuildJobEditEvent.EditAuthorityChange, self.EditAuthorityChange, self)
  self:AddButtonEvent("ConfirmButton", function(go)
    self:DoApply()
  end)
end
function GuildJobEditPopUp:NameChange(cellCtl)
  local data = cellCtl.data
  self.changeNames[data.id] = cellCtl.input.value
end
function GuildJobEditPopUp:AuthorityChange(param)
  local cellCtl, authorityType, value = param[1], param[2], param[3]
  local data = cellCtl.data
  if data then
    local job = data.id
    if self.changeAuths[job] == nil then
      self.changeAuths[job] = {}
    end
    self.changeAuths[job][authorityType] = value
  end
end
function GuildJobEditPopUp:EditAuthorityChange(param)
  local cellCtl, value = param[1], param[2]
  local data = cellCtl.data
  if data then
    if data.editauth > 0 and value == false then
      self.changeEditAuths[data.id] = false
    elseif data.editauth <= 0 and value == true then
      self.changeEditAuths[data.id] = true
    end
  end
end
function GuildJobEditPopUp:DoApply()
  local result = {}
  local hasUnvalidStr = false
  local guildProxy = GuildProxy.Instance
  local myGuildData = guildProxy.myGuildData
  for job, jobname in pairs(self.changeNames) do
    if jobname ~= myGuildData:GetJobName(job) then
      local temp = {}
      temp.job = job
      temp.name = jobname
      hasUnvalidStr = hasUnvalidStr or FunctionMaskWord.Me():CheckMaskWord(jobname, self.filterType)
      table.insert(result, temp)
    end
  end
  if #result > 0 then
    if not hasUnvalidStr then
      ServiceGuildCmdProxy.Instance:CallSetGuildOptionGuildCmd(nil, nil, nil, result)
    else
      MsgManager.ShowMsgByIDTable(2604)
    end
  end
  local hasChangeAuth = false
  for jobtype, changeAuths in pairs(self.changeAuths) do
    for changeAuth, value in pairs(changeAuths) do
      if GuildProxy.Instance:CanIEditAuthority(jobtype, changeAuth) then
        hasChangeAuth = true
        ServiceGuildCmdProxy.Instance:CallModifyAuthGuildCmd(value, GuildCmd_pb.EMODIFY_AUTH, jobtype, changeAuth)
      else
        MsgManager.ShowMsgByIDTable(2964)
      end
    end
  end
  for jobtype, value in pairs(self.changeEditAuths) do
    local auths = GuildProxy.Instance:GetJobEditAuthority(jobtype)
    if auths then
      for i = 1, #auths do
        hasChangeAuth = true
        ServiceGuildCmdProxy.Instance:CallModifyAuthGuildCmd(value, GuildCmd_pb.EMODIFY_EDITAUTH, jobtype, auths[i])
      end
    end
  end
  if hasChangeAuth then
    MsgManager.ShowMsgByIDTable(2963)
  end
  self:CloseSelf()
end
function GuildJobEditPopUp:UpdateJobInfo()
  if self.datas == nil then
    self.datas = {}
  else
    TableUtility.ArrayClear(self.datas)
  end
  local myGuildData = GuildProxy.Instance.myGuildData
  local myGuilMemberdData = myGuildData:GetMemberByGuid(Game.Myself.data.id)
  local myJobInfo = myGuildData:GetJobMap()
  for _, jobdata in pairs(myJobInfo) do
    if jobdata.id >= myGuilMemberdData.job and myGuildData.level >= jobdata.limitlv then
      table.insert(self.datas, jobdata)
    end
  end
  table.sort(self.datas, GuildJobEditPopUp.SortJobInfo)
  self.jobCtl:ResetDatas(self.datas)
end
function GuildJobEditPopUp.SortJobInfo(a, b)
  return a.id < b.id
end
function GuildJobEditPopUp:OnEnter()
  GuildJobEditPopUp.super.OnEnter(self)
  self:UpdateJobInfo()
end
function GuildJobEditPopUp:OnExit()
  self.changeNames = {}
  self.changeAuths = {}
  self.changeEditAuths = {}
  GuildJobEditPopUp.super.OnExit(self)
end
