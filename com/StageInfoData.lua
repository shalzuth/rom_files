StageInfoData = class("StageInfoData")
function StageInfoData:ctor(serverData)
  self.id = serverData.stageid
  self.usernum = serverData.usernum
  self.waittime = serverData.waittime
  self.showtime = serverData.status or 0
end
function StageInfoData:UpdateWaittime(newtime)
  self.waittime = newtime
end
