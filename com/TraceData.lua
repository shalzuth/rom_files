TraceData = class("TraceData")

TraceDataType = {
	TraceDataType_ItemTrace = 1,
	TraceDataType_SealTrace = 2,
}

function TraceData:update(type,id,stepType,traceTitle,map,pos,traceInfo,params,process,whetherTrace,thumb,icon,thumbBg,titleBg,foreBg,progressBg)
	-- body
	self.id = id or 0 --追踪id （相同类型不可有相同id）
	self.orderId = id
	self.map = map
	self.type = type -- 任务类型（itemTr sealTr and so on）
	self.pos = pos  -- 位置
	self.traceInfo = traceInfo or ""  --追踪信息
	self.params = params or {}    -- 可变参数
	self.questDataStepType = stepType  -- 任务类型（visit kill and so on）
	self.process = process --  追踪进度
	self.traceTitle = traceTitle or "default title"  --追踪信息标题
	self.whetherTrace = whetherTrace--是否追踪
	self.npc = 0     --访问npc
	self.thumb = thumb 
	self.icon = icon
	self.thumbBg = thumbBg
	self.titleBg = titleBg
	self.foreBg = foreBg
	self.progressBg = progressBg
	-- printGreen(	self.id,	self.orderId,	self.map,	self.type,	self.pos,	self.traceInfo,	self.params,	self.questDataStepType,	self.process,	self.traceTitle,	self.whetherTrace,	self.npc)
end

function TraceData:setIfShowAppearAnm( b )
	-- body
	
end

function TraceData:getProcessInfo( )
	-- body
end

function TraceData:UpdateByTraceData( traceData )
	-- body
	self:update(traceData.type,traceData.id,traceData.questDataStepType,
			traceData.traceTitle,traceData.map,traceData.pos,traceData.traceInfo,traceData.params,
			traceData.process,traceData.whetherTrace,traceData.thumb,traceData.icon,traceData.thumbBg,traceData.titleBg,traceData.foreBg,traceData.progressBg)
end

function TraceData:cloneSelf(  )
	-- body
	local data = TraceData.new()
	data.id = self.id --追踪id （相同类型不可有相同id）
	data.orderId = self.id
	data.map = self.map  --地图
	data.type = self.type -- 任务类型（itemTr sealTr and so on）
	data.pos = self.pos  -- 位置
	data.traceInfo = self.traceInfo  --追踪信息
	data.params = self.params   -- 可变参数
	data.questDataStepType = self.stepType  -- 任务类型（visit kill and so on）
	data.process = self.process --  追踪进度
	data.traceTitle = self.traceTitle  --追踪信息标题
	data.whetherTrace = self.whetherTrace   --是否追踪
	data.npc = 0     --访问npc	
end

function TraceData:parseTranceInfo()
	-- body
	local result = self.traceInfo
	return result
end