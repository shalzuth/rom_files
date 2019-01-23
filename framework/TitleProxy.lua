TitleProxy=class('TitleProxy',pm.Proxy)
TitleProxy.Instance = nil;
TitleProxy.NAME = "TitleProxy"

autoImport("TitleData")

local TITLETYPE = {
	NONE = UserEvent_pb.ETITLE_TYPE_MIN,
	ADVENTURE = UserEvent_pb.ETITLE_TYPE_MANNUAL,
	NORMAL = UserEvent_pb.ETITLE_TYPE_ACHIEVEMENT,
	GROUP = UserEvent_pb.ETITLE_TYPE_ACHIEVEMENT_ORDER,
}

function TitleProxy:ctor(proxyName, data)
	self.proxyName = proxyName or TitleProxy.NAME
	if(TitleProxy.Instance == nil) then
		TitleProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	-- self:_EnlargeTestCaseConfig(10)

	-- local flag = os.clock()
	self:_InitStaticData()
	-- helplog("cost",os.clock()-flag)
	-- helplog("times",times)
	self:_Test()
end

-- local count = function ()
-- 	if(times==nil) then times = 0 end
-- 	times = times + 1
-- end

-- function TitleProxy:_EnlargeTestCaseConfig(t)
-- 	local c = 0
-- 	local enlarged = {}
-- 	for k,v in pairs(Table_Appellation) do
-- 		c = c + 1
-- 		for i=1,t do
-- 			local a= {}
-- 			TableUtility.TableShallowCopy(a, v)
-- 			a.id = math.floor(v.id*(math.pow(10,i)))
-- 			if(a.PostID) then
-- 				a.PostID = math.floor(v.PostID*(math.pow(10,i)))
-- 			end
-- 			enlarged[#enlarged+1] = a
-- 		end
-- 	end
-- 	for i=1,#enlarged do
-- 		Table_Appellation[enlarged[i].id] = enlarged[i]
-- 	end
-- 	local cc = 0
-- 	for k,v in pairs(Table_Appellation) do
-- 		cc = cc + 1
-- 	end
-- 	helplog(c,cc)
-- 	helplog(Table_Appellation[12010].PostID)
-- end

local ContainsValue = function (tab, value)
	if value == nil then return false end

	if tab then
		for k, v in pairs(tab) do
		-- count()
			if v == value then
				return k
			end
		end
	end

	return false
end

function TitleProxy:_Test()
	local sb = LuaStringBuilder.new()
	for k,v in pairs(self.groupLevelTitleMap) do
		sb:Clear()
		for i=1,#v.titleDatas do
			sb:Append(v.titleDatas[i].id)
			sb:Append("-")
			sb:Append(v.titleDatas[i].levelIndex)
			sb:Append(",")
		end
		-- helplog("升级类型的称号组",k,sb:ToString())
	end
end

function TitleProxy:_InitStaticData()
	--UI用的称号列表
	self.titles = {}
	--解锁称号的属性合
	self.titleUnlockProps = {}
	self.allTitleConfig={}
	self.groupLevelTitleMap = {}
	local data
	for k,v in pairs(Table_Appellation) do
		-- count()
		if(v.GroupID==TITLETYPE.NORMAL)then
			data = self:_CreateTitleData(TITLETYPE.NORMAL,v)
			if(not data:bVisibilyAchievement())then
				self.titles[#self.titles+1] = data
			end
		elseif(v.GroupID==TITLETYPE.GROUP and self.allTitleConfig[v.id] == nil)then
			data = self:_CreateTitleData(TITLETYPE.GROUP,v)
			self:_RecursiveGetGroup(data,v)
		end
	end
end

function TitleProxy:_CreateTitleData(type,v)
	local data = TitleData.new(type,v)
	self.allTitleConfig[v.id] = data
	return data
end

local groupID = 0
function TitleProxy:_RecursiveGetGroup(titleData)
	local group = titleData.groupData
	if(group==nil) then
		local postID = titleData.config.PostID
		if(postID) then
			local nextData = self.allTitleConfig[postID]
			if(nextData == nil) then
				nextData = self:_CreateTitleData(TITLETYPE.GROUP,Table_Appellation[postID])
			end
			titleData.groupData = self:_RecursiveGetGroup(nextData)
			group = titleData.groupData
		else
			group = TitleLevelGroupData.new(groupID)
			groupID = groupID +1
			titleData.groupData = group
			self.groupLevelTitleMap[groupID] = group
		end
		group:AddTitle(titleData)
	end
	-- count()
	return group
end

function TitleProxy:SetServiceData(data)
	self.titlesChanged = true
	-- helplog("SetServiceData ")
	local titles = data

	for i=1,#titles do
		local title = titles[i]
		local titledata = self.allTitleConfig[title.id]
		local lastGroupLock = true
		if(titledata and titledata.groupData) then
			lastGroupLock = titledata.groupData.unlocked
		end
		if(titledata) then
			if(titledata:Unlock(true)) then
				if(titledata.titleType==TITLETYPE.NORMAL and titledata:bVisibilyAchievement())then
					self.titles[#self.titles+1] = titledata
				end
				local config = titledata.config
				for k,v in pairs(config.BaseProp) do
					if(self.titleUnlockProps[k]) then
						self.titleUnlockProps[k] = self.titleUnlockProps[k]+ v
					else
						self.titleUnlockProps[k]=v
					end
				end
			end
		end
		if(titledata and title.title_type == TITLETYPE.GROUP and  not lastGroupLock)then
			self.titles[#self.titles+1] = titledata.groupData
		end
	end
	for k,v in pairs(self.groupLevelTitleMap) do
		local unlockData = v.titleDatas[#v.titleDatas]
		if(not v.unlocked)then
			if(unlockData and not unlockData:bVisibilyAchievement())then
				if(not ContainsValue(self.titles,unlockData))then
					self.titles[#self.titles+1] = unlockData
				end
			end
		else
			local key = ContainsValue(self.titles,unlockData)
			if(key)then
				table.remove(self.titles,key)
			end
		end
	end
end

function TitleProxy:GetTitle()
	if(self.titlesChanged) then
		self.titlesChanged = false
		table.sort(self.titles,function (l,r)
			return self:SortTitle(l,r)
		end)
	end
	return self.titles
end

function TitleProxy:bLowerTitleGroup(id)
	for k,v in pairs(self.groupLevelTitleMap) do
		for key,value in pairs(v.titleDatas) do
			if(value.id==id and v.activeTitleData)then
				if(v.activeTitleData.id>id)then
					return v.activeTitleData
				end
			end
		end
	end
	return nil
end

-- 获得所有解锁称号显示属性总加成
function TitleProxy:GetAllTitleProp()
	return self.titleUnlockProps
end

function TitleProxy:GetCurAchievementTitle()
	local id = Game.Myself.data:GetAchievementtitle()
	local title =self.allTitleConfig[id]
	return title and title.config.Name or ""
end

function TitleProxy:SortTitle(left,right)
	if left == nil or right == nil then 
	   return false 
	end

	local lSortID = left:GetSortID()
	local rSortID = right:GetSortID()
	local lActiveID = left:GetActiveID()
	local rActiveID = right:GetActiveID()

	local curTitle = Game.Myself.data:GetAchievementtitle()
	if(lActiveID==curTitle or rActiveID==curTitle)then
		return lActiveID == curTitle;
	end
	if(left.unlocked and right.unlocked)then
		return lSortID<rSortID
	end
	if(left.unlocked or right.unlocked)then
		return left.unlocked
	end
	if(left.unlocked==false and right.unlocked==false)then
		return lSortID < rSortID;
	end
	return lSortID < rSortID;
end


local titleData = {}
function TitleProxy:ChangeTitle(type,id)
	titleData.title_type=type
	titleData.id=id;
	local charId = Game.Myself.data.id
	ServiceUserEventProxy.Instance:CallChangeTitle(titleData,charId)
end

function TitleProxy:GetPropStrByTitleId(id)
	local appellation = Table_Appellation[id]
	if(appellation)then
		local BaseProp = appellation.BaseProp
		local str = ""
		for k,v in pairs(BaseProp) do
			local prop = Game.Config_PropName[ k]
			if(str == "")then
				str = str..prop.RuneName.." +"..v
			else
				str = str.."、"..prop.RuneName.." +"..v
			end
		end
		str = "[c][1F74BF]"..str.."[-][/c]"
		return str
	end
end