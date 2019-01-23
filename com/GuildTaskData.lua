GuildTaskData = class("GuildTaskData")

function GuildTaskData.GetGroupId(id)
	return math.floor(id/100);
end

function GuildTaskData:ctor(groupId)
	self.groupId = groupId;

	self.taskcount = 0;

	self.tasks = {};

	self.trace_dirty = true;
	self.traceTasks = {};
end

function GuildTaskData:AddTaskData(serverInfo)

	----[[todo xde 0003348: 无法显示当前所在的公会界面 服务器下发已经屏蔽的公会挑战 id
	if Table_GuildChallenge[serverInfo.id] == nil  then
		xdlog("serverInfo.id 有问题", serverInfo.id )
		do return end
	end
	--]]

	self.trace_dirty = true;

	local singleData = self.tasks[serverInfo.id];
	if(singleData == nil)then
		singleData = {};
		self.tasks[serverInfo.id] = singleData;

		self.taskcount = self.taskcount + 1;
	end

	singleData.id = serverInfo.id;
	singleData.reward = serverInfo.reward;
	singleData.progress = serverInfo.progress;

	local sData = Table_GuildChallenge[singleData.id];
	singleData.finish = serverInfo.progress >= sData.Target;
	singleData.target = sData.Target;

	-- helplog( string.format("GuildTaskData(id:%s Progress:%s, Target:%s, Finish:%s Reward:%s)", 
	-- 	tostring(singleData.id),
	-- 	tostring(singleData.progress), 
	-- 	tostring(singleData.target), 
	-- 	tostring(singleData.finish), 
	-- 	tostring(singleData.reward)) );
end

function GuildTaskData:GetTaskDatas()
	return self.tasks;
end

function GuildTaskData:GetTraceTaskDatas()
	if(self.trace_dirty == false)then
		return self.traceTasks;
	end

	self.trace_dirty = false;
	TableUtility.ArrayClear(self.traceTasks);

	local unfinish_task;
	for k,v in pairs(self.tasks)do
		if(v.finish)then
			table.insert(self.traceTasks, v);
		else
			if(unfinish_task == nil or v.target < unfinish_task.target)then
				unfinish_task = v;
			end
		end
	end
	if(unfinish_task ~= nil)then
		table.insert(self.traceTasks, 1, unfinish_task);
	end
	table.sort(self.traceTasks, GuildTaskData.SortTasks);

	return self.traceTasks;
end

function GuildTaskData.SortTasks( a,b )
	if(a.finish ~= b.finish)then
		return b.finish == true;
	end
	return a.id < b.id;
end

function GuildTaskData:RemoveTaskData(serverInfo)
	if(serverInfo == nil)then
		return;
	end

	local id = serverInfo.id;
	if(self.tasks[id] ~= nil)then
		self.tasks[id] = nil;

		self.taskcount = self.taskcount - 1;
	end
end