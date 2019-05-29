autoImport("json")
ProtocolStatistics = class("ProtocolStatistics")
local tabProtocolInfo = {}
ProtocolStatistics.time = 600
ProtocolStatistics.serverURL = "https://log-m-ro.xd.com:5050/xd.game.ro.client"
local tablePool = {}
function ProtocolStatistics:GetTableFromPool()
  for _, v in pairs(tablePool) do
    local isIdle = v.isIdle
    if isIdle then
      v.isIdle = false
      return v.tab
    end
  end
  local newTable = {}
  table.insert(tablePool, {isIdle = false, tab = newTable})
  return newTable
end
function ProtocolStatistics:TableBackToPool(pTab)
  for _, v in pairs(tablePool) do
    local tab = v.tab
    if tab == pTab then
      v.isIdle = true
      TableUtility.TableClear(tab)
      break
    end
  end
end
function ProtocolStatistics:Instance()
  if ProtocolStatistics.instance == nil then
    ProtocolStatistics.instance = ProtocolStatistics.new()
  end
  return ProtocolStatistics.instance
end
function ProtocolStatistics:Start()
  if not self.switch then
    self.switch = true
    if self.timer == nil then
      self.timer = TimeTick.new(0, ProtocolStatistics.time * 1000, self.OnTimeTick, self, 1)
    end
    self.timer:StartTick()
    self:ClearStatistics()
  end
end
function ProtocolStatistics:Stop()
  if self.switch then
    self.switch = false
    self:StopTimer()
  end
end
function ProtocolStatistics:Close()
  self.switch = false
  self:CloseTimer()
end
function ProtocolStatistics:StopTimer()
  if self.timer ~= nil then
    self.timer:Stop()
  end
end
function ProtocolStatistics:CloseTimer()
  if self.timer ~= nil then
    self.timer:ClearStick()
  end
end
local ReceiveMem = 0
function ProtocolStatistics:Receive(command1, command2, package_size, cost_time)
  local mem = collectgarbage("count")
  if self.switch then
    local tabContent = self:GetTableFromPool()
    tabContent.packageSize = package_size
    tabContent.costTime = cost_time
    if table.ContainsKey(tabProtocolInfo, command1) and tabProtocolInfo[command1] ~= nil then
      local tab1 = tabProtocolInfo[command1]
      if table.ContainsKey(tab1, command2) and tab1[command2] ~= nil then
        local tab2 = tab1[command2]
        table.insert(tab2, tabContent)
      else
        local tabContents = self:GetTableFromPool()
        table.insert(tabContents, tabContent)
        tab1[command2] = tabContents
      end
    else
      local tabCommand1Value = self:GetTableFromPool()
      local tabCommand2Value = self:GetTableFromPool()
      table.insert(tabCommand2Value, tabContent)
      tabCommand1Value[command2] = tabCommand2Value
      tabProtocolInfo[command1] = tabCommand1Value
    end
  end
  ReceiveMem = ReceiveMem + (collectgarbage("count") - mem)
end
function ProtocolStatistics:OnTimeTick()
  local mem = collectgarbage("count")
  self:MakeStatistics()
  local message = self:GetTableFromPool()
  message.protocolCount = self.protocolCount
  message.allPackageSize = self.allPackageSize
  message.allCostTime = self.allCostTime
  message.tabMinAndMax = self.tabMinAndMax
  local strMessage = json.encode(message)
  local str = "json=" .. strMessage
  local bytes = NetUtil.CharsToBytes(str, string.len(str))
  HttpRequest.Instance:HTTPPost(ProtocolStatistics.serverURL, bytes, function(www)
  end)
  self:ClearStatistics()
end
function ProtocolStatistics:ClearStatistics()
  for k, v in pairs(tabProtocolInfo) do
    local command1 = k
    local tabCommand1Value = v
    if tabCommand1Value ~= nil then
      for k, v in pairs(tabCommand1Value) do
        local command2 = k
        local tabCommand2Value = v
        if tabCommand2Value ~= nil then
          for k, v in pairs(tabCommand2Value) do
            local content = v
            if content ~= nil then
              self:TableBackToPool(content)
              tabCommand2Value[k] = nil
            end
          end
          self:TableBackToPool(tabCommand2Value)
          tabCommand1Value[command2] = nil
        end
      end
      self:TableBackToPool(tabCommand1Value)
      tabProtocolInfo[command1] = nil
    end
  end
  if self.tabMinAndMax ~= nil then
    for k, v in pairs(self.tabMinAndMax) do
      local command1 = k
      local tabCommand1Value = v
      if tabCommand1Value ~= nil then
        for k, v in pairs(tabCommand1Value) do
          local command2 = k
          local tabCommand2Value = v
          if tabCommand2Value ~= nil then
            for k, v in pairs(tabCommand2Value) do
              local content = v
              if content ~= nil then
                self:TableBackToPool(content.packageSize)
                content.packageSize = nil
                self:TableBackToPool(content.costTime)
                content.costTime = nil
              end
            end
            self:TableBackToPool(tabCommand2Value)
            tabCommand1Value[command2] = nil
          end
        end
        self:TableBackToPool(tabCommand1Value)
        tabProtocolInfo[command1] = nil
      end
    end
  end
end
function ProtocolStatistics:MakeStatistics()
  self.protocolCount = 0
  self.allPackageSize = 0
  self.allCostTime = 0
  self.tabMinAndMax = self:GetTableFromPool()
  for k, v in pairs(tabProtocolInfo) do
    local command1 = k
    local tab1 = v
    if tab1 ~= nil then
      self.tabMinAndMax[tostring(command1)] = self:GetTableFromPool()
      for k, v in pairs(tab1) do
        local command2 = k
        local tab2 = v
        if tab2 ~= nil then
          self.protocolCount = self.protocolCount + 1
          local minPackageSize = 0
          local maxPackageSize = 0
          local minCostTime = 0
          local maxCostTime = 0
          for _, v in pairs(tab2) do
            if v ~= nil then
              local packageSize = v.packageSize
              self.allPackageSize = self.allPackageSize + packageSize
              if minPackageSize > 0 then
                if minPackageSize > packageSize then
                  minPackageSize = packageSize or minPackageSize
                end
              else
                minPackageSize = packageSize
              end
              if maxPackageSize < packageSize then
                maxPackageSize = packageSize or maxPackageSize
              end
              local costTime = v.costTime
              self.allCostTime = self.allCostTime + costTime
              if minCostTime > 0 then
                if minCostTime > costTime then
                  minCostTime = costTime or minCostTime
                end
              else
                minCostTime = costTime
              end
              if maxCostTime < costTime then
                maxCostTime = costTime or maxCostTime
              end
            end
          end
          local tabPackageSize = self:GetTableFromPool()
          tabPackageSize.min = minPackageSize
          tabPackageSize.max = maxPackageSize
          local tabCostTime = self:GetTableFromPool()
          tabCostTime.min = minCostTime
          tabCostTime.max = maxCostTime
          local tabContent = self:GetTableFromPool()
          tabContent.packageSize = tabPackageSize
          tabContent.costTime = tabCostTime
          self.tabMinAndMax[tostring(command1)][tostring(command2)] = tabContent
        end
      end
    end
  end
end
