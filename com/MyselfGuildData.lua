autoImport("GuildData");
MyselfGuildData = class("MyselfGuildData", GuildData)

autoImport("GuildTaskData");

function MyselfGuildData:ctor(guildData)
	self.headIcon_dirty = true;
	self.custom_icon_map = {};
	self.headIconList = {};

	self.eventList = {};

	self.challenge_task_list_dirty = true;
	self.challenge_task_list = {};
	self.challenge_task_map = {};

	MyselfGuildData.super.ctor(self, guildData);
end

function MyselfGuildData:SetData( serverData )
	MyselfGuildData.super.SetData(self, serverData);

	self:_Server_UpdateTask(serverData.challenges);
end

function MyselfGuildData:UpdateData(updateDatas)
	local cachelv,nowlv = self.level;

	MyselfGuildData.super.UpdateData(self, updateDatas);	

	nowlv = self.level;

	if(cachelv + 1 == nowlv)then
		self.headIcon_dirty = true;

		GameFacade.Instance:sendNotification(GuildEvent.GuildUpgrade);
		FunctionGuild.Me():UpgradeGuild();
	end
	
end

function MyselfGuildData:AddMember(serviceGuildMember)
	local member = MyselfGuildData.super.AddMember(self, serviceGuildMember);
	if(member and member.id~=Game.Myself.data.id)then
		local scenePlayer = NSceneUserProxy.Instance:Find(member.id);
		if(scenePlayer)then
			scenePlayer:OnAvatarPriorityChanged()
		end
	end
	return member;
end

function MyselfGuildData:RemoveMember(guid)
	local member = MyselfGuildData.super.RemoveMember(self, guid);
	if(member and member.id~=Game.Myself.data.id)then
		local scenePlayer = NSceneUserProxy.Instance:Find(member.id);
		if(scenePlayer)then
			scenePlayer:OnAvatarPriorityChanged()
		end
	end
	return member;
end


-- Guild Event Data begin
function MyselfGuildData:ResetGuildEventList()
	TableUtility.ArrayClear(self.eventList);
end

function MyselfGuildData:Server_ResetGuildEventList(serverEventlist)
	self:ResetGuildEventList();

	if(serverEventlist)then
		for i=1,#serverEventlist do
			self:Server_AddGuildEventData(serverEventlist[i]);
		end
	end
end

function MyselfGuildData:Server_AddGuildEventData(serverEventData)
	self.eventDataDirty = true;

	local data = {
		id = serverEventData.guid,
		time = serverEventData.time,
		type = serverEventData.eventid,
	};

	local param = serverEventData.param;
	if(param and #param>0)then
		data.params = {};
		for i=1, #param do
			data.params[i] = param[i];
		end
	end
	
	table.insert(self.eventList, data);
end

function MyselfGuildData:Server_RemoveGuildEventData(id)
	for i = #self.eventList, 1, -1 do
		if(self.eventList[i].id == id)then
			self.eventDataDirty = true;
			table.remove(self.eventList, i);
		end
	end
end

function MyselfGuildData.SortGuildEventDatas(ea, eb)
	if(ea and eb)then
		return ea.time > eb.time;
	end
	return false;
end

function MyselfGuildData:GetGuildEventList()
	if(self.eventDataDirty)then
		self.eventDataDirty = false; 
		table.sort(self.eventList, MyselfGuildData.SortGuildEventDatas);
	end
	return self.eventList;
end

function MyselfGuildData:ClearGuildEventList()
	TableUtility.ArrayClear(self.eventList);
	self.eventDataDirty = true;
end
-- Guild Event Data end



function MyselfGuildData:Server_SetCustomIcons(server_iconinfos, server_dels)
	self.headIcon_dirty = true;

	for i=1,#server_iconinfos do
		local info = server_iconinfos[i];

		local headData = self.custom_icon_map[info.index];
		if(headData == nil)then
			headData = GuildHeadData.new(GuildHeadData_Type.Custom, info.index);
			headData:SetGuildId(self.id);
			self.custom_icon_map[info.index] = headData;
		end
		headData:Server_SetInfo(info);
	end

	if(server_dels)then
		for i=1,#server_dels do
			local index = server_dels[i];
			self.custom_icon_map[index] = nil;
		end
	end
end

function MyselfGuildData:Server_UpdateCustomIcon(index, state, createtime, isdelete, pic_type)
	local guildHeadData = self.custom_icon_map[index];
	if(isdelete)then
		self.custom_icon_map[index] = nil;
		return;
	end

	if(guildHeadData == nil)then
		return;
	end

	guildHeadData.state = state;
	guildHeadData.createtime = createtime;
	guildHeadData.pic_type = pic_type;
end

function MyselfGuildData:GetMyHeadIcons()
	if(not self.headIcon_dirty)then
		return self.headIconList;
	end

	self.headIcon_dirty = false;

	TableUtility.TableClear(self.headIconList);

	for id, sData in pairs(Table_Guild_Icon)do
		if(nil ~= sData)then
			if(sData.GuildLevel)then
				if(sData.GuildLevel <= self.level)then
					local headData = GuildHeadData.new(GuildHeadData_Type.Config, id);
					headData:SetGuildId(self.id);
					table.insert(self.headIconList, headData);
				end
			else
				local headData = GuildHeadData.new(GuildHeadData_Type.Config, id);
				headData:SetGuildId(self.id);
				table.insert(self.headIconList, headData);
			end
		end
	end

	for k,sData in pairs(self.custom_icon_map)do
		table.insert(self.headIconList, sData);
	end

	table.sort(self.headIconList, MyselfGuildData.sortHeadIconDatas);
	return self.headIconList;
end

function MyselfGuildData:GetEmptyCustomIconIndex()
	local maxCount = GameConfig.Guild.icon_uplimit or 32;
	for i=1,maxCount do
		if(self.custom_icon_map[i] == nil)then
			return i;
		end
	end
	return nil;
end

function MyselfGuildData.sortHeadIconDatas(a, b)
	if(a.type ~= b.type)then
		return a.type > b.type;
	end

	if(a.type == GuildHeadData_Type.Custom and b.type == GuildHeadData_Type.Custom)then
		if(a.createtime ~= b.createtime)then
			return a.createtime > b.createtime;
		end
		return a.index < b.index;
	end
	
	return a.staticData.id < b.staticData.id
end

function MyselfGuildData:Server_UpdateTasks(server_updates, server_dels, server_refreshtime)
	self:_Server_DelTasks(server_dels);
	
	self:_Server_UpdateTask(server_updates);
	self:_Server_SetRefreshTime(server_refreshtime);
end

function MyselfGuildData:_Server_UpdateTask(server_updates)
	self.challenge_task_list_dirty = true;

	for i=1,#server_updates do
		local update = server_updates[i];

		local groupId = GuildTaskData.GetGroupId(update.id);
		local cachedata = self.challenge_task_map[groupId];
		if(cachedata == nil)then
			cachedata = GuildTaskData.new(groupId);
			self.challenge_task_map[groupId] = cachedata;
		end

		cachedata:AddTaskData(update);
	end
end

function MyselfGuildData:_Server_DelTasks(server_dels)
	if(server_dels and #server_dels > 0)then
		for i=1,#server_dels do
			local del = server_dels[i];
			local groupId = GuildTaskData.GetGroupId(del.id);
			local cachedata = self.challenge_task_map[groupId];

			if(cachedata)then
				cachedata:RemoveTaskData(del);

				if(cachedata.taskcount <= 0)then
					self.challenge_task_map[groupId] = nil;
				end
			end
		end
	end
end

function MyselfGuildData:_Server_SetRefreshTime(server_refreshtime)
	self.task_refreshtime = server_refreshtime;
end

function MyselfGuildData:GetChallengeTaskList()
	if(self.challenge_task_list_dirty == false)then
		return self.challenge_task_list;
	end

	self.challenge_task_list_dirty = false;

	TableUtility.ArrayClear(self.challenge_task_list);
	for id, data in pairs(self.challenge_task_map)do
		local tracedatas = data:GetTraceTaskDatas();
		if(#tracedatas > 0)then
			for i=1,#tracedatas do
				table.insert(self.challenge_task_list, tracedatas[i]);
			end
		end
	end
	table.sort(self.challenge_task_list, MyselfGuildData.SortGuildChallengeTasks);

	return self.challenge_task_list;
end

function MyselfGuildData.SortGuildChallengeTasks(a, b)
	if(a.reward ~= b.reward)then
		return a.reward == true;
	end
	if(a.finish ~= b.finish)then
		return a.finish ~= true;
	end
	return a.id < b.id;
end

-- Guild Pack begin

function MyselfGuildData:SetGuildPackItems( serverItems )
	if(serverItems)then
		if(not self.guildPack)then
			self.guildPack = {};
		end

		for i=1,#serverItems do
			local serverItem = serverItems[i].base;
			if(serverItem)then
				local guid = serverItem.guid
				local itemid = serverItem.id;
				local itemdata = self.guildPack[guid];
				if(not itemdata)then
					itemdata = ItemData.new(guid,itemid);
					self.guildPack[guid] = itemdata;
				end
				itemdata.num = serverItem.count;
			end
		end
	end
end

function MyselfGuildData:GetGuildAsset()
	local result = {}
	if(not self.guildPack)then return nil end 
	for k,v in pairs(self.guildPack) do
		result[#result+1]=v
	end
	return result
end

function MyselfGuildData:RemoveGuildPackItems( dels )
	if(not self.guildPack)then
		return;
	end
	for i=1,#dels do
		local guid = dels[i]
		if(guid)then
			if(self.guildPack[guid])then
				self.guildPack[guid] = nil;
			end
		end
	end
end

function MyselfGuildData:ClearGuildPackItems()
	if(self.guildPack)then
		TableUtility.TableClear(self.guildPack);
	end
end

function MyselfGuildData:GetGuildPackItemByItemid( itemid )
	if(self.guildPack)then
		local target = {}
		for _,v in pairs(self.guildPack) do
			if(v.staticData and v.staticData.id==itemid)then
				target[#target+1]=v
			end
		end
		return target
	end
	return nil
end

function MyselfGuildData:GetGuildPackItemNumByItemid( itemid )
	local items = self:GetGuildPackItemByItemid(itemid);
	if(items)then
		local num = 0
		for i=1,#items do
			num=num+items[i].num
		end
		return num
	end
	return 0;
end
-- Guild Pack end


function MyselfGuildData:Exit()
	self:ResetGuildEventList();
end