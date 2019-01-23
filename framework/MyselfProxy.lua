using "RO.RoleAvatar"
autoImport("Appellation")
autoImport("Occupation")
local MyselfProxy = class('MyselfProxy', pm.Proxy)

MyselfProxy.Instance = nil;

MyselfProxy.NAME = "MyselfProxy"

--玩家自身的管理

function MyselfProxy:ctor(proxyName, data)
	self.proxyName = proxyName or MyselfProxy.NAME
	if(MyselfProxy.Instance == nil) then
		MyselfProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end	
	self.selectAutoNormalAtk = true
end

function MyselfProxy:onRegister()
	self.myself = nil
	self.vars = nil
	self.buffers = nil
	self.buffAttr = nil
	self.buffersProps = RolePropsContainer.CreateAsTable()
	self.extraProps = RolePropsContainer.CreateAsTable()
	self:ClearProps()
	self.buffAttr = {}
	self.traceItems = {};

	self.equipPosStateTimeMap = {};

	self.unlockActionIds = {};
	self.unlockEmojiIds = {};
end

function MyselfProxy:ClearProps(  )
	-- body
	if(self.buffersProps)then
		for _, o in pairs(self.buffersProps.configs) do
			self.buffersProps:SetValueById(o.id,0)
		end
	end

	if(self.extraProps)then
		for _, o in pairs(self.extraProps.configs) do
			self.extraProps:SetValueById(o.id,0)
		end
	end
end

function MyselfProxy:CurMaxJobLevel()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CUR_MAXJOB) or 0
end

function MyselfProxy:onRemove()
	self.buffersProps:Destroy()
	self.buffersProps = nil
	self.extraProps:Destroy()
	self.extraProps = nil
end


function MyselfProxy:SetUserRolesInfo(snapShotUserInfo)
	if(self.snapShotUserInfo == nil)then
		self.snapShotUserInfo = {};
	else
		TableUtility.TableClear(self.snapShotUserInfo)
	end

	local client_datas = {};
	local server_datas = snapShotUserInfo.data;
	for i=1,#server_datas do
		local server_data = server_datas[i];

		local snapShotDataPB = {};
		snapShotDataPB.id = server_data.id;
		snapShotDataPB.baselv = server_data.baselv;
		snapShotDataPB.hair =  server_data.hair;
		snapShotDataPB.haircolor = server_data.haircolor;

		snapShotDataPB.lefthand = server_data.lefthand; 
		snapShotDataPB.righthand =  server_data.righthand;
		snapShotDataPB.body = server_data.body;
		snapShotDataPB.head = server_data.head;
		snapShotDataPB.back = server_data.back;
		snapShotDataPB.face = server_data.face;  
		snapShotDataPB.tail = server_data.tail; 
		snapShotDataPB.mount = server_data.mount; 
		snapShotDataPB.eye = server_data.eye; 
		snapShotDataPB.partnerid = server_data.partnerid; 
		snapShotDataPB.portrait = server_data.portrait; 
		snapShotDataPB.mouth = server_data.mouth;  
		snapShotDataPB.clothcolor = server_data.clothcolor;  

		snapShotDataPB.name = server_data.name; 
		snapShotDataPB.sequence = server_data.sequence;  
		snapShotDataPB.isopen = server_data.isopen; 
		snapShotDataPB.deletetime = server_data.deletetime;  

		snapShotDataPB.gender = server_data.gender;  
		snapShotDataPB.profession = server_data.profession; 

		table.insert(client_datas, snapShotDataPB);
	end
	self.snapShotUserInfo.data = client_datas;

	self.snapShotUserInfo.lastselect = snapShotUserInfo.lastselect;
	self.snapShotUserInfo.deletechar = snapShotUserInfo.deletechar;
	self.snapShotUserInfo.deletecdtime = snapShotUserInfo.deletecdtime;
	self.snapShotUserInfo.maincharid = snapShotUserInfo.maincharid;
end

function MyselfProxy:GetUserRolesInfo()
	return self.snapShotUserInfo;
end


function MyselfProxy:GetROB()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SILVER) or 0
end

function MyselfProxy:GetGold()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GOLD) or 0
end

function MyselfProxy:GetDiamond()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.DIAMOND) or 0
end

function MyselfProxy:GetGarden()
	return BagProxy.Instance:GetItemNumByStaticID(GameConfig.MoneyId.Happy)
end

function MyselfProxy:GetLaboratory()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.LABORATORY) or 0
end

function MyselfProxy:RoleLevel()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) or 0
end

function MyselfProxy:JobLevel()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.JOBLEVEL) or 0
end

function MyselfProxy:GetMyProfession()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PROFESSION) or 0
end

function MyselfProxy:GetMyProfessionType()
	local profession = self:GetMyProfession()
	profession = Table_Class[profession]
	return profession and profession.Type or 0
end

function MyselfProxy:GetMyMapID()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.MAPID) or 0
end

function MyselfProxy:GetMySex()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SEX) or 1
end

function MyselfProxy:GetZoneId()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ZONEID) or 0
end

function MyselfProxy:GetZoneString()
	return ChangeZoneProxy.Instance:ZoneNumToString(self:GetZoneId())
end

--交易所赠送额度
function MyselfProxy:GetQuota()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA) or 0
end

--冻结额度
function MyselfProxy:GetQuotaLock()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA_LOCK) or 0
end

function MyselfProxy:GetHasCharge()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.HASCHARGE) or 0
end

function MyselfProxy:GetFashionHide()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FASHIONHIDE) or 0
end

function MyselfProxy:GetPvpCoin()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PVPCOIN) or 0
end

function MyselfProxy:GetLottery()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.LOTTERY) or 0
end

function MyselfProxy:GetGuildHonor()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GUILDHONOR) or 0
end

function MyselfProxy:GetServantFavorability()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FAVORABILITY) or 0
end

function MyselfProxy:GetBoothScore()
	return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BOOTH_SCORE) or 0
end

function MyselfProxy:ResetMyBornPos(x,y,z)
	LogUtility.Info("bornPos.."..x.." "..y.." "..z)
	if(Game.Myself) then
		Game.Myself:Server_SetPosXYZCmd(x,y,z,1000)
	end
	-- Player.Me.bornID = -1
	-- Player.Me.bornPos = PosUtil.DevideVector3(x,y,z)
end

function MyselfProxy:ResetMyPos(x,y,z,isgomap)
	if(isgomap==nil) then
		isgomap = false
	end
	if(Game.Myself) then
		Game.Myself:Server_SetPosXYZCmd(x,y,z,1000)
	else
		LogUtility.Info("尝试重置位置，但未找到myself")
	end
	EventManager.Me():DispatchEvent(ServiceEvent.SceneGoToUserCmd,isgomap)
end

function MyselfProxy:SetProps(UserAttrSyncCmd,update)
	-- self.myself:SetDatas(UserAttrSyncCmd.datas,update)
	-- self.myself:HandleDirtyData()
	self:setExtraProps(UserAttrSyncCmd.pointattrs,update)
	-- self.myself:SetProps(UserAttrSyncCmd.attrs,update)
	if(Game.Myself) then
		Game.Myself:Server_SetUserDatas(UserAttrSyncCmd.datas,not update)
		Game.Myself:Server_SetAttrs(UserAttrSyncCmd.attrs)
	end
end

function MyselfProxy:InitNMyself(data)
	if(Game.Myself == nil) then
		local myData = MyselfData.CreateAsTable(data)
		Game.Myself = NMyselfPlayer.CreateAsTable(myData)
	end
	FunctionSkillEnableCheck.Me():SetMySelf(Game.Myself)
end

function MyselfProxy:SetMySelfCurRole(data)
	-- if(self.myself) then
	-- 	self.myself:Dispose()
	-- end
	if(not self.myself) then
		-- self.myself = self:InitRole(data)
		-- EventManager.Me():PassEvent(MyselfEvent.Inited,self.myself)
		-- FunctionSkillEnableCheck.Me():SetMySelf(self.myself)
		-- Player.Me.activeRoleData = self.myself.roleInfo
		--TODO
		self:InitNMyself(data)
	end
	FunctionPlayerPrefs.Me():InitUser(data.id)
	LocalSaveProxy.Instance:InitDontShowAgain()
	FunctionPerformanceSetting.Me():Load()
end

function MyselfProxy:InitRole(data)
	local p = self.myself or MySelfPlayer.new(data.id)
	p.name = data.name
	p.roleInfo.ID = data.id
	-- p.props = RolePropsContainer.new()	
	p:ResetPropToRoleInfo()
	return p
end

function MyselfProxy:SetChooseRoleId(id)
	self.chooseRoleId = id;
end

function MyselfProxy:GetChooseRoleId()
	return self.chooseRoleId;
end

function MyselfProxy:SetShortCuts(shortCuts)
	if(shortCuts ~= nil )then
		for i=1,#shortCuts do
		end
	end
end

function MyselfProxy:RecvVarUpdate( data )
	if(self.vars == nil)then
		self.vars = {};
	end

	if(data ~= nil)then
		for i=1,#data do
			local single = data[i]
			if(single)then
				local varData = self.vars[single.type];
				if(not varData)then
					varData = {
						type = single.type,
						time = single.time,
					};
					self.vars[single.type] = varData;
				end
				varData.value = single.value;
			end
		end
	end
end

function MyselfProxy:getVarByType( type )
	if self.vars == nil then
		return
	end
	return self.vars[type]
end

function MyselfProxy:getVarValueByType( type )
	if not self.vars then
		return;
	end
	return self.vars[type] and self.vars[type].value;
end

function MyselfProxy:RecvBufferUpdate( data )
	-- body
	printRed("MyselfProxy:RecvBufferUpdate( data )")
	self.buffers = self.buffers or {}
	local updateBffs = {}
	local addBffs = {}
	if(data.buff)then
		for i=1,#data.buff do
			local single = data.buff[i]			
			if(self.buffers[single.id])then
				local data = {}
				data.id = single.id
				data.oldLayer = self.buffers[single.id]
				data.newLayer = single.layer
				table.insert(updateBffs,data)
			else
				table.insert(addBffs,single)
			end
			self.buffers[single.id] = single.layer
		end
	end

	for i=1,#updateBffs do
		local single = updateBffs[i]
		local buffData = Table_Buffer[single.id]
		local effect = buffData["BuffEffect"]
		local newLayer = single.newLayer
		local oldLayer = single.oldLayer
		if(effect.type == "AttrChange")then
			for j,w in pairs(effect) do
				local prop = self.buffersProps[j]
				if(j ~= "type" and prop)then
					local oldValue = self.buffersProps:GetValueByName(j)
					local deltaValue = (newLayer - oldLayer)*w
					if(prop.propVO.isPercent)then
						deltaValue = deltaValue*1000
						oldValue = oldValue*1000
					end
					local value = oldValue + deltaValue
					self.buffersProps:SetValueByName(j,value)
					self.buffAttr[j] = value
				end
			end
		end		
	end

	for i=1,#addBffs do
		local single = addBffs[i]
		local buffData = Table_Buffer[single.id]
		local effect = buffData["BuffEffect"]
		local v = single.layer
		if(effect.type == "AttrChange")then
			for j,w in pairs(effect) do
				if(j ~= "type")then
					local oldValue = self.buffersProps:GetValueByName(j)

					local deltaValue = w*v
					local prop = self.buffersProps[j]
					if(prop.propVO.isPercent)then
						deltaValue = deltaValue*1000
						oldValue = oldValue*1000
					end
					local vl = deltaValue + oldValue
					self.buffersProps:SetValueByName(j,vl)
					self.buffAttr[j] = vl
				end
			end
		end
	end
end

function MyselfProxy:setExtraProps( props ,update )
	-- body
	if(props~=nil and #props >0)then
		for i = 1, #props do
			if props[i] ~= nil then
				-- print("prop type:"..props[i].type.."  value:"..props[i].value)
				self.extraProps:SetValueById(props[i].type,props[i].value)
			end
		end
	end
end

--profession GameConfig.AdvancedBranch 职业的一转
function MyselfProxy:checkProfessionIsOpenById( profession )
	-- body	
	self:checkProfessionIsOpenByProfessionData(Table_Class[profession])
	return false
end

function MyselfProxy:checkProfessionIsOpenByProfessionData( professionData )
	-- body
	-- local firstId = 0
	-- if(professionData)then
	-- 	local sameTList = SkillProxy.Instance.sameProfessionType[professionData.Type]
	-- 	for i=1,#sameTList do
	-- 		local single = sameTList[i]
	-- 		if(single.id == professionData.id)then
	-- 			local data = single
	-- 			while #data.AdvanceClass <= 2 
	-- 			do
	-- 				data = data.previousClasses
	-- 			end
	-- 			firstId = data.id
	-- 			break
	-- 		end
	-- 	end
	-- 	local list = GameConfig.AdvancedBranch[firstId]
	-- 	if(list and list[2] ~= 0)then
	-- 		return true
	-- 	end
	-- end
	return false
end

function MyselfProxy:initAllTitle( data )
	-- printRed("MyselfProxy:initAllTitle")
	self.appellations = {}
	local titles = data.title_datas
	for i=1,#titles do
		local title = titles[i]
		-- printRed("playerTitle:",title.id,title.title_type,title.createtime)
		local Appellation = Appellation.new(title.id,title.title_type,title.createtime)
		self.appellations[#self.appellations+1] = Appellation
	end
end

function MyselfProxy:newTitle( data )
	local titleData = data.title_data
	local id = data.charid
	if(id == Game.Myself.data.id)then
		local Appellation = Appellation.new(titleData.id,titleData.title_type,titleData.createtime)
		for i=1,#self.appellations do
			local title = self.appellations[i]
			if(title.id == Appellation.id)then
				self.appellations[i] = Appellation
				return
			end
		end	
		self.appellations[#self.appellations+1] = Appellation
	end

	if(titleData.title_type == UserEvent_pb.ETITLE_TYPE_MANNUAL)then
		--play levelup anim
		local creature = NSceneUserProxy.Instance:Find(id)
		if(creature)then
			GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, creature,SceneUserEvent.AppellationUp)
		end
	end
	-- printRed("playerTitle:",titleData.id,titleData.title_type,titleData.createtime)
	
end

function MyselfProxy:GetCurManualAppellation( )
	-- body
	local curApp = nil
	for i=1,#self.appellations do
		local title = self.appellations[i]
		if title.titleType == UserEvent_pb.ETITLE_TYPE_MANNUAL and not curApp then
			curApp = title
			break
		end
	end
	-- printRed("curApp",curApp)
	if(curApp)then		
		local nextApp = self:getAppellationById(curApp.staticData.PostID)
		-- printRed("next",nextApp)
		while(nextApp) do
			curApp = nextApp
			nextApp = self:getAppellationById(curApp.staticData.PostID)
		end
	end
	return curApp
end

function MyselfProxy:GetCurFoodCookerApl( )
	-- body
	local curApp = nil
	for i=1,#self.appellations do
		local title = self.appellations[i]
		if title.titleType == UserEvent_pb.ETITLE_TYPE_FOODCOOKER and not curApp then
			curApp = title
			break
		end
	end
	-- printRed("curApp",curApp)
	if(curApp)then		
		local nextApp = self:getAppellationById(curApp.staticData.PostID)
		-- printRed("next",nextApp)
		while(nextApp) do
			curApp = nextApp
			nextApp = self:getAppellationById(curApp.staticData.PostID)
		end
	end
	return curApp
end

function MyselfProxy:GetCurFoodTasteApl( )
	-- body
	local curApp = nil
	for i=1,#self.appellations do
		local title = self.appellations[i]
		if title.titleType == UserEvent_pb.ETITLE_TYPE_FOODTASTER and not curApp then
			curApp = title
			break
		end
	end
	-- printRed("curApp",curApp)
	if(curApp)then		
		local nextApp = self:getAppellationById(curApp.staticData.PostID)
		-- printRed("next",nextApp)
		while(nextApp) do
			curApp = nextApp
			nextApp = self:getAppellationById(curApp.staticData.PostID)
		end
	end
	return curApp
end

function MyselfProxy:getAppellationById( id )
	-- body
	if(not id)then
		return 
	end
	for i=1,#self.appellations do
		local title = self.appellations[i]
		if title.id == id then
			return title
		end
	end
end

function MyselfProxy:SetTraceItem(updates, dels)
	if(updates)then
		for i=1,#updates do
			local upItem = updates[i];
			self.traceItems[upItem.itemid] = upItem;
		end
	end
	if(dels)then
		for i=1,#dels do
			local delid = dels[i];
			self.traceItems[delid] = nil;
		end
	end
end

function MyselfProxy:GetTraceItems()
	local result = {};
	for _,item in pairs(self.traceItems)do
		table.insert(result, item);
	end
	return result;
end

function MyselfProxy:GetTraceItemByItemId(itemid)
	return self.traceItems[itemid]
end

-- My Unlock EmojiIds And ActionIdss
-- Begin
function MyselfProxy:SetUnlockActionIdMap(ids)
	-- TableUtility.TableClear(self.unlockActionIds)
	for i=1,#ids do
		local id = ids[i];
		self.unlockActionIds[id] = 1;
	end
end

function MyselfProxy:GetUnlockActionMap()
	return self.unlockActionIds;
end

function MyselfProxy:SetUnlockEmojiMap(ids)
	-- TableUtility.TableClear(self.unlockEmojiIds)
	for i=1,#ids do
		local id = ids[i];
		self.unlockEmojiIds[id] = 1;
	end
end

function MyselfProxy:GetUnlockEmojiMap()
	return self.unlockEmojiIds;
end

function MyselfProxy:HasJobBreak()
	if(GameConfig.SystemForbid.Peak) then
		return false
	end
	return FunctionUnLockFunc.Me():CheckCanOpen(450)
end

function MyselfProxy:HasMaxJobBreak()
	local hasBreak = self:HasJobBreak()
	if(hasBreak)then
		local level = self:CurMaxJobLevel()
		local profession = self:GetMyProfession()
		profession = Table_Class[profession]
		if(profession and profession.MaxPeak)then
			return level>=profession.MaxPeak
		end
	else
		return false
	end
end

function MyselfProxy:UpdateRandomFunc(array, beginIndex, endIndex)
	if nil ~= self.myself then
		self.myself:UpdateRandomFunc(array, beginIndex, endIndex)
	end
	if nil ~= Game.Myself then
		Game.Myself.data:UpdateRandomFunc(array, beginIndex, endIndex)
	end
end



function MyselfProxy:Test_SetEquipPos()
	local server_EquipPosDatas = {};
	for i=1, 3 do
		local t = {};
		t.pos = i;
		t.offstarttime = ServerTime.CurServerTime()/1000;
		t.offendtime = t.offstarttime + 60;
		t.protecttime = 0;
		t.protectalways = 1;
		table.insert(server_EquipPosDatas, t);
	end
	self:Server_SetEquipPos_StateTime(server_EquipPosDatas);
end

-- Equip Pos Begin
function MyselfProxy:Server_SetEquipPos_StateTime(server_EquipPosDatas)

	local logStr = "脱卸装备:";

	for i=1,#server_EquipPosDatas do
		local d = server_EquipPosDatas[i];
		local ld = self.equipPosStateTimeMap[d.pos];
		if(ld == nil)then
			ld = {};
			self.equipPosStateTimeMap[d.pos] = ld;
		end

		ld.offstarttime = d.offstarttime;
		ld.offendtime = d.offendtime;
		ld.offduration = d.offendtime - d.offstarttime;
		ld.protecttime = d.protecttime;
		ld.protectalways = d.protectalways;

		logStr = logStr .. string.format("部位:%s || 脱卸开始时间:%s 脱卸结束时间:%s 装备保护时间:%s 装备永久保护:%s", 
			tostring(d.pos),
			os.date("%m月%d日%H点%M分%S秒", d.offstarttime),
			os.date("%m月%d日%H点%M分%S秒", d.offendtime),
			os.date("%m月%d日%H点%M分%S秒", d.protecttime),
			tostring(d.protectalways) )

		logStr = logStr .. "\n";
	end

	helplog(logStr);

	FunctionBuff.Me():UpdateOffingEquipBuff();
	FunctionBuff.Me():UpdateProtectEquipBuff();
end

function MyselfProxy:EquipPos_UpdateBuff()
end

function MyselfProxy:GetEquipPos_StateTime(site)
	return self.equipPosStateTimeMap[site];
end

function MyselfProxy:IsEquipPosInOffing(site)
	local stateTime = self:GetEquipPos_StateTime(site);

	if(stateTime)then
		if(stateTime.offendtime and stateTime.offendtime > 0)then
			return ServerTime.ServerDeltaSecondTime(stateTime.offendtime * 1000) > 0;
		end
	end
	return false;
end

function MyselfProxy:GetOffingEquipPoses()
	local offPoses = {};
	for k,v in pairs(self.equipPosStateTimeMap)do
		if(self:IsEquipPosInOffing(k))then
			table.insert(offPoses, k);
		end
	end

	table.sort(offPoses, function (a, b)
		return a < b;
	end);
	return offPoses;
end

function MyselfProxy:IsEquipPosInProtecting(site)
	local stateTime = self:GetEquipPos_StateTime(site);

	if(stateTime)then
		if(stateTime.protectalways > 0)then
			return true;
		end
		if((stateTime.protecttime and stateTime.protecttime > 0))then
			return ServerTime.ServerDeltaSecondTime(stateTime.protecttime * 1000) > 0;
		end
	end
	return false;
end

function MyselfProxy:HandleRelieveCd(data)
	self.reliveStamp = data.time + ServerTime.CurServerTime()/1000
	self.reliveName = data.name
end

function MyselfProxy:ClearReliveCd()
	self.reliveStamp = nil
	self.reliveName = nil
end

function MyselfProxy:GetProtectEquipPoses()
	local protectPoses = {};
	for k,v in pairs(self.equipPosStateTimeMap)do
		if(self:IsEquipPosInProtecting(k))then
			table.insert(protectPoses, k);
		end
	end
	
	table.sort(protectPoses, function (a, b)
		return a < b;
	end);
	return protectPoses;

end

function MyselfProxy:IsUnlockAstrolabe()
	local panelId =  PanelConfig.AstrolabeView.id;
   	return FunctionUnLockFunc.Me():CheckCanOpenByPanelId(panelId);
end


return MyselfProxy
