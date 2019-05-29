GuildJobChangePopUp = class("GuildJobChangePopUp", ContainerView)
GuildJobChangePopUp.ViewType = UIViewType.PopUpLayer
autoImport("GuildJobChangeCell")
function GuildJobChangePopUp:Init()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.guildMember = viewdata and viewdata.guildMember
  self:InitUI()
end
function GuildJobChangePopUp:InitUI()
  local grid = self:FindComponent("JobGrid", UIGrid)
  self.jobCtl = UIGridListCtrl.new(grid, GuildJobChangeCell, "GuildJobChangeCell")
  self.jobCtl:AddEventListener(MouseEvent.MouseClick, self.ClickJob, self)
  self:UpdateJobs()
end
function GuildJobChangePopUp:ClickJob(cellCtl)
  if self.guildMember then
    local job = cellCtl.data and cellCtl.data.id
    if job ~= self.guildMember.job then
      local myGuildMemberData = GuildProxy.Instance:GetMyGuildMemberData()
      if job == GuildJobType.Chairman then
        local canDo = GuildProxy.Instance:CanJobDoAuthority(myGuildMemberData.job, GuildAuthorityMap.ChangePresident)
        if canDo then
          MsgManager.ConfirmMsgByID(2801, function()
            ServiceGuildCmdProxy.Instance:CallExchangeChairGuildCmd(self.guildMember.id)
          end, nil, self, self.guildMember.baselevel, self.guildMember.name)
        end
      elseif job > myGuildMemberData.job then
        if job == GuildJobType.ViceChairman then
          local nowNum = #GuildProxy.Instance.myGuildData:GetViceChairmanList()
          local maxNum = GuildProxy.Instance.myGuildData:GetGuildConfig().Management
          if nowNum < maxNum then
            ServiceGuildCmdProxy.Instance:CallChangeJobGuildCmd(self.guildMember.id, job)
          else
            printRed("\229\137\175\228\188\154\233\149\191\228\186\186\230\149\176\229\183\178\230\187\161\227\128\130\227\128\130")
          end
        else
          ServiceGuildCmdProxy.Instance:CallChangeJobGuildCmd(self.guildMember.id, job)
        end
      end
    end
  end
  self:CloseSelf()
end
function GuildJobChangePopUp:UpdateJobs()
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
  table.sort(self.datas, GuildJobChangePopUp.SortJobInfo)
  self.jobCtl:ResetDatas(self.datas)
end
function GuildJobChangePopUp.SortJobInfo(a, b)
  return a.id < b.id
end
