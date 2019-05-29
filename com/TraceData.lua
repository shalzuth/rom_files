TraceData = class("TraceData")
TraceDataType = {TraceDataType_ItemTrace = 1, TraceDataType_SealTrace = 2}
function TraceData:update(type, id, stepType, traceTitle, map, pos, traceInfo, params, process, whetherTrace, thumb, icon, thumbBg, titleBg, foreBg, progressBg)
  self.id = id or 0
  self.orderId = id
  self.map = map
  self.type = type
  self.pos = pos
  self.traceInfo = traceInfo or ""
  self.params = params or {}
  self.questDataStepType = stepType
  self.process = process
  self.traceTitle = traceTitle or "default title"
  self.whetherTrace = whetherTrace
  self.npc = 0
  self.thumb = thumb
  self.icon = icon
  self.thumbBg = thumbBg
  self.titleBg = titleBg
  self.foreBg = foreBg
  self.progressBg = progressBg
end
function TraceData:setIfShowAppearAnm(b)
end
function TraceData:getProcessInfo()
end
function TraceData:UpdateByTraceData(traceData)
  self:update(traceData.type, traceData.id, traceData.questDataStepType, traceData.traceTitle, traceData.map, traceData.pos, traceData.traceInfo, traceData.params, traceData.process, traceData.whetherTrace, traceData.thumb, traceData.icon, traceData.thumbBg, traceData.titleBg, traceData.foreBg, traceData.progressBg)
end
function TraceData:cloneSelf()
  local data = TraceData.new()
  data.id = self.id
  data.orderId = self.id
  data.map = self.map
  data.type = self.type
  data.pos = self.pos
  data.traceInfo = self.traceInfo
  data.params = self.params
  data.questDataStepType = self.stepType
  data.process = self.process
  data.traceTitle = self.traceTitle
  data.whetherTrace = self.whetherTrace
  data.npc = 0
end
function TraceData:parseTranceInfo()
  local result = self.traceInfo
  return result
end
