autoImport("AERewardInfoData")
AERewardData = class("AERewardData")
AERewardData.DebugString = {
  "\231\160\148\231\169\182\230\137\128",
  "\231\156\139\230\157\191",
  "\232\163\130\233\154\153",
  "\229\183\165\228\188\154\230\141\144\232\181\160",
  "\230\151\160\233\153\144\229\161\148"
}
function AERewardData:ctor()
  self.rewardMap = {}
end
function AERewardData:SetReward(data)
  if data ~= nil then
    local rewardData = data.reward
    for i = 1, #rewardData do
      local mode = rewardData[i].mode
      local logStr = ""
      logStr = "AERewardData  --> "
      local dateFormat = "%m\230\156\136%d\230\151\165%H\231\130\185%M\229\136\134%S\231\167\146"
      local modeStr = AERewardData.DebugString[mode]
      logStr = logStr .. string.format(" | \229\138\159\232\131\189:%s | \229\188\128\229\167\139\230\151\182\233\151\180:%s | \231\187\147\230\157\159\230\151\182\233\151\180:%s | \229\189\147\229\137\141\230\151\182\233\151\180:%s | \229\165\150\229\138\177\229\128\141\230\149\176\239\188\154%s", tostring(modeStr), os.date(dateFormat, data.begintime), os.date(dateFormat, data.endtime), os.date(dateFormat, ServerTime.CurServerTime() / 1000), tostring(rewardData[i].multiplereward.multiple))
      helplog(logStr)
      if not self.rewardMap[mode] then
        self.rewardMap[mode] = {}
      end
      local single = AERewardInfoData.new(rewardData[i], data.begintime, data.endtime)
      table.insert(self.rewardMap[mode], single)
    end
  end
end
function AERewardData:GetRewardByType(type)
  if self.rewardMap[type] then
    for k, v in pairs(self.rewardMap[type]) do
      if v:IsInActivity() then
        return v
      end
    end
  end
  return nil
end
