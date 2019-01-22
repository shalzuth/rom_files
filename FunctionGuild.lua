FunctionGuild = class("FunctionGuild")

GuildFuncAuthorityMap = {
	UpgradeGuild = 7,
	DisMissGuild = 16,
	CancelDissolution = 16,
	ChangeGuildLine = 17,
	ChangeGuildName = 20,
}

autoImport("GuildHeadData");
autoImport("PhotoFileInfo")

local dialogData = {};

function FunctionGuild.Me()
	if nil == FunctionGuild.me then
		FunctionGuild.me = FunctionGuild.new()
	end

	return FunctionGuild.me
end

function FunctionGuild:ctor()
	self.customIconCache = {};
	self.cacheFlag_SetMap = {};
	
	EventManager.Me():AddEventListener(GuildPictureManager.ThumbnailDownloadCompleteCallback, self.ThumbnailDownloadCompleteCallback, self)
end

function FunctionGuild:ShowGuildDialog(npcInfo)
	local npcData = npcInfo.data.staticData;
	local npcfunction = npcData and npcData.NpcFunction;
	for i=1,#npcfunction do
		local single = npcfunction[i];
		local funcCfg = Table_NpcFunction[single.type];
		if(funcCfg)then
			if(funcCfg.NameEn == "CreateGuild" or funcCfg.NameEn == "ApplyGuild")then
				self:ShowEnterGuildDialog(npcInfo);
				break;
			elseif(funcCfg.NameEn == "UpgradeGuild" 
				or funcCfg.NameEn == "DisMissGuild" 
				or funcCfg.NameEn == "CancelDissolution" 
				or funcCfg.NameEn == "ChangeGuildName" 
				or funcCfg.NameEn == "ChangeGuildLine"
				or funcCfg.NameEn == "GiveUpGuildLand" )then
				self:ShowUpgradeGuildDialog(npcInfo);
				break;
			end
		end
	end
end

function FunctionGuild:ShowEnterGuildDialog(npcInfo)
	local dialogData = { viewname = "DialogView" };
	if(not GuildProxy.Instance:IHaveGuild())then
		local text, viceText = self:GetFormatEnterGuildText();
		dialogData.dialoglist = { {Text = text, ViceText = viceText} };
		dialogData.addconfig = npcInfo.data.staticData.NpcFunction;
	else
		local defaultDlg = npcInfo.data.staticData.DefaultDialog;
		if(defaultDlg)then
			dialogData.dialoglist = { defaultDlg };
		else
			dialogData.dialoglist = { "My lord, you had a guild..." };
		end
	end
	dialogData.npcinfo = npcInfo;
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, dialogData);
end

function FunctionGuild:GetFormatEnterGuildText()
	local text, viceText = ZhString.FunctionGuild_GuildCreateTip, "";
	local userdata = Game.Myself.data.userdata;
	local mylv = userdata:Get(UDEnum.ROLELEVEL);

	viceText = string.format(ZhString.FunctionGuild_GuildCreateLvCondition, GameConfig.Guild.createbaselv);
	if(mylv >= GameConfig.Guild.createbaselv)then
		viceText = "[00ff00]"..viceText.."[-]\n"
	else
		viceText = "[ff0000]"..viceText.."[-]\n"
	end

	local needItems = GameConfig.Guild.createitem;
	for i=1,#needItems do
		local needItem = needItems[i];
		if(needItem[1] and needItem[2])then
			local sIData = Table_Item[needItem[1]];
			local tempText,hasNum = "";
			if(needItem[1] == 100 or needItem[1] == 110)then
				tempText = string.format(ZhString.FunctionGuild_GuildCreateGoldCondition, i+1, needItem[2], sIData.NameZh); 
				hasNum = MyselfProxy.Instance:GetROB()
			elseif(needItem[1] == 105)then
				tempText = string.format(ZhString.FunctionGuild_GuildCreateGoldCondition, i+1, needItem[2], sIData.NameZh); 
				hasNum = MyselfProxy.Instance:GetGold()
			else
				tempText = string.format(ZhString.FunctionGuild_GuildCreateItemCondition, i+1, sIData.NameZh, needItem[2]); 
				hasNum = BagProxy.Instance:GetItemNumByStaticID(needItem[1]);
			end
			if(hasNum >= needItem[2])then
				viceText = viceText.."[00ff00]"..tempText.."[-]"
			else
				viceText = viceText.."[ff0000]"..tempText.."[-]"
			end
			if(i<=#needItems)then
				viceText = viceText.."\n"
			end
		else
			errorLog("Guild Create Item ErrorConfig");
		end
	end

	return text, viceText;
end

function FunctionGuild:ShowUpgradeGuildDialog(npcInfo)
	local npcData = npcInfo.data.staticData;
	local npcfunction = npcData and npcData.NpcFunction;

	local guildFunc = {};
	for i=1,#npcfunction do
		local funcType = npcfunction[i].type;
		local funcCfg = Table_NpcFunction[funcType];
		if(funcCfg == nil)then
			helplog("ERROR!!!", funcType);
		end
		local myGuildMemberData = GuildProxy.Instance:GetMyGuildMemberData()
		if(funcCfg and myGuildMemberData)then
			local canDo = true;
			if(GuildFuncAuthorityMap[funcCfg.NameEn])then
				canDo = GuildProxy.Instance:CanJobDoAuthority(myGuildMemberData.job, GuildFuncAuthorityMap[funcCfg.NameEn]);
			end
			local isDismissing = GuildProxy.Instance:IsDismissing();
			if(canDo)then
				if(funcCfg.NameEn == "DisMissGuild")then
					if(not isDismissing)then
						table.insert(guildFunc, npcfunction[i]);
					end
				elseif(funcCfg.NameEn == "CancelDissolution")then
					if(isDismissing)then
						table.insert(guildFunc, npcfunction[i]);
					end
				else
					table.insert(guildFunc, npcfunction[i]);
				end
			end
		end
	end

	TableUtility.TableClear(dialogData);
	dialogData.viewname = "DialogView";
	if(npcData.DefaultDialog)then
		dialogData.dialoglist = { npcData.DefaultDialog };
	else
		dialogData.dialoglist = { "No Default Dialog..." };
	end
	dialogData.addconfig = guildFunc;
	dialogData.npcinfo = npcInfo;

	GameFacade.Instance:sendNotification(UIEvent.ShowUI, dialogData);
end

function FunctionGuild:ShowGuildRaidDialog(npcInfo)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.GuildOpenRaidDialog, viewdata = {npcInfo = npcInfo}});
end

function FunctionGuild:ShowEnterGuildFubenDialog(npcInfo)
	TableUtility.TableClear(dialogData);
	dialogData.viewname = "DialogView";

	local timetick = 0;
	local unlockData = GuildProxy.Instance:GetGuildGateInfoByNpcId(npcInfo.data.id);
	if(unlockData)then
		timetick = unlockData.opentime;
	end

	GameFacade.Instance:sendNotification(UIEvent.ShowUI, dialogData);
end

function FunctionGuild:MakeGuildUpgrade()
	self.optUpgrade = true;
	local guildData = GuildProxy.Instance.myGuildData;
	if(not guildData)then
		return;
	end

	local upConfig = guildData:GetUpgradeConfig()
	if(not upConfig)then
		errorLog("Not UpConfig");
		return;
	end

	local assetNum = guildData.asset;
	if(assetNum and assetNum < upConfig.ReviewFund)then
		MsgManager.ShowMsgByIDTable(2617);
		return;
	end

	local upItemId, upItemNum = upConfig.DeductItem[1], upConfig.DeductItem[2];
	local upItemName = upItemId and Table_Item[upItemId] and Table_Item[upItemId].NameZh;
	local itemNum = GuildProxy.Instance:GetGuildPackItemNumByItemid( GuildItemConfig.GuildItemId )
	if(itemNum < upItemNum)then
		MsgManager.ShowMsgByIDTable(2618, {upItemName});
		return;
	end
	ServiceGuildCmdProxy.Instance:CallLevelupGuildCmd() 
end

function FunctionGuild:UpgradeGuild()
	if(self.optUpgrade)then
		self.optUpgrade = false;
		self:PlayUpgradeEffect();
	end
end

function FunctionGuild:PlayUpgradeEffect()
	FloatingPanel.Instance:PlayUIEffect(EffectMap.UI.GuildUpgrade, nil, true);
	ServiceGuildCmdProxy.Instance:CallLevelupEffectGuildCmd();
end


function FunctionGuild:ResetGuildItemQueryState()
	self.item_Queryed = false;
end

function FunctionGuild:QueryGuildItemList()
	if(self.item_Queryed == true)then
		return;
	end
	self.item_Queryed = true;

	local guildData = GuildProxy.Instance.myGuildData;
	if(guildData)then
		GuildProxy.Instance:ClearGuildPackItems()
		ServiceGuildCmdProxy.Instance:CallQueryPackGuildCmd() 
	end
end

function FunctionGuild:ResetGuildEventQueryState()
	self.event_Queryed = false;
end

function FunctionGuild:QueryGuildEventList()
	if(self.event_Queryed == true)then
		return;
	end
	self.event_Queryed = true;

	local guildData = GuildProxy.Instance.myGuildData;
	if(guildData)then
		GuildProxy.Instance:ClearGuildEventList()
		ServiceGuildCmdProxy.Instance:CallQueryEventListGuildCmd() 
	end
end

function FunctionGuild:MyGuildJobChange(old, new)
	helplog("MyGuildJobChange", old, new);
	-- local oldLetIn = GuildProxy.Instance:CanJobDoAuthority(old, GuildAuthorityMap.PermitJoin);
	-- if(oldLetIn)then
	-- 	local newLetIn = GuildProxy.Instance:CanJobDoAuthority(new, GuildAuthorityMap.PermitJoin);
	-- 	if(not newLetIn)then
	-- 		RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_GUILD_APPLY)
	-- 	end
	-- end
end

function FunctionGuild:SetGuildLandIcon(flagID, portrait, guildId)
	local flagManager = Game.GameObjectManagers[Game.GameObjectType.SceneGuildFlag];
	if(flagManager == nil)then
		return;
	end

	if(portrait == nil)then
		flagManager:SetIcon(flagID, nil);
		return;
	end

	local guildHeadData = GuildHeadData.new();
	guildHeadData:SetBy_InfoId(portrait);
	guildHeadData:SetGuildId(guildId);

	local offset_x, offset_y, scale_x, scale_y, texture;

	if(guildHeadData.type == GuildHeadData_Type.Config)then
		local guildIcon = guildHeadData and guildHeadData.staticData.Icon or nil;
		if(guildIcon == nil)then
			flagManager:SetIcon(flagID, nil);
			return;
		end

		local atlas, spriteData;

		local guildAtlas = IconManager:GetAtlasByType(UIAtlasConfig.IconAtlas.guild);
		for i=1, #guildAtlas do
			spriteData = guildAtlas[i]:GetSprite(guildIcon);
			if(spriteData ~= nil)then
				atlas = guildAtlas[i];
				break;
			end
		end

		if(atlas == nil or spriteData == nil)then
			return;
		end

		texture = atlas.texture;
		offset_x = spriteData.x/texture.width;
		offset_y = (texture.height - spriteData.y - spriteData.height)/texture.height;
	 	scale_x = spriteData.width/texture.width;
	 	scale_y = spriteData.height/texture.height;

	elseif(guildHeadData.type == GuildHeadData_Type.Custom)then
		texture = GuildPictureManager.Instance():GetThumbnailTexture(guildHeadData.guildid, 
			UnionLogo.CallerIndex.UnionFlag, 
			guildHeadData.index, 
			guildHeadData.time);
		if(texture == nil)then
			flagManager:SetIcon(flagID, nil);
			self.cacheFlag_SetMap[guildHeadData.guildid] = flagID;
			local adata = { 
				callIndex = UnionLogo.CallerIndex.UnionFlag, 
				guild = guildHeadData.guildid, 
				index = guildHeadData.index, 
				time = guildHeadData.time,
				picType = guildHeadData.pic_type, 
			};
			GuildPictureManager.Instance():AddMyThumbnailInfos({adata});

			return;
		else
			offset_x = 0;
			offset_y = 0;
		 	scale_x = 1;
		 	scale_y = 1;
		end
	end

	if(texture ~= nil)then
		flagManager:SetIcon(flagID, texture, offset_x, offset_y, scale_x, scale_y);
	end
end

function FunctionGuild:ThumbnailDownloadCompleteCallback(cdata)
	local guildid = cdata.guild;
	if(guildid == nil)then
		return;
	end
	if(self.cacheFlag_SetMap[guildid] == nil)then
		return;
	end
	local flagManager = Game.GameObjectManagers[Game.GameObjectType.SceneGuildFlag];
	if(flagManager == nil)then
		return;
	end

	local texture = GuildPictureManager.Instance():GetThumbnailTexture(guildid,  UnionLogo.CallerIndex.UnionFlag, cdata.index, cdata.time);
	if(texture ~= nil)then
		local flagID = self.cacheFlag_SetMap[guildid];
		self.cacheFlag_SetMap[guildid] = nil;

		helplog("ThumbnailDownloadCompleteCallback", flagID, texture);
		flagManager:SetIcon(flagID, texture, 0, 0, 1, 1);
	end
end


local testAssetPath = "GUI/pic/UI/Dojo_Icon_05";
function FunctionGuild:ClearCustomPicCache(guildid)
	local cache = self.customIconCache[guildid];
	if(cache ~= nil)then
		for k,v in pairs(cache)do
			if(not Slua.IsNull(v))then
				if(self.doTest)then
					Game.AssetManager_UI:UnLoadAsset(testAssetPath)
				else
					Object.Destroy(v);
				end
			end
			cache[k] = nil;
		end
	end
	self.customIconCache[guildid] = nil;
end

function FunctionGuild:SetCustomPicCache(guildid, pos, tex)
	local cache = self.customIconCache[guildid];
	if(cache == nil)then
		cache = {};
		self.customIconCache[guildid] = cache;
	end

	local oldPic = cache[pos];
	if(oldPic ~= nil and oldPic ~= tex)then
		if(self.doTest)then
			Game.AssetManager_UI:UnLoadAsset(testAssetPath)
		else
			Object.Destroy(oldPic);
		end
	end

	cache[pos] = tex;
end

function FunctionGuild:GetCustomPicCache(guildid, pos)
	local cache = self.customIconCache[guildid];
	if(cache == nil)then
		return nil;
	end

	return cache[pos];
end



function FunctionGuild:SaveAndUploadCustomGuildIcon(index, doTest)
	if(BackwardCompatibilityUtil.CompatibilityMode_V17)then
		MsgManager.ConfirmMsgByID(2649, function ()
			AppBundleConfig.JumpToAppStore()
		end)
		return;
	end

	local maxCount = GameConfig.Guild.icon_uplimit or 32;
	if(index > maxCount)then
		MsgManager.ShowMsgByIDTable(2648);
		return;
	end

	self.doTest = doTest;

	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData == nil)then
		return;
	end

	local timestamp = math.floor(ServerTime.CurServerTime()/1000);

	if(self.doTest)then
		Game.AssetManager_UI:LoadAsset(testAssetPath, Texture, function (p, tex)
			tex.name = timestamp;
			self:SetCustomPicCache(myGuildData.id, index, tex)
			local bytes = ImageConversion.EncodeToPNG(tex)
			self:UploadCustomGuildIcon(myGuildData.id, index, timestamp, bytes);
		end)
	else
		ImageCropImpl.ChooseStart(128, 128);
		ImageCropImpl.chooseDone = function (tex)
			tex.name = timestamp;
			self:SetCustomPicCache(myGuildData.id, index, tex)
			local bytes = ImageConversion.EncodeToPNG(tex)
			self:UploadCustomGuildIcon(myGuildData.id, index, timestamp, bytes);
		end
	end
end

function FunctionGuild:UploadCustomGuildIcon(guildid, index, timestamp, bytes)
	if(self.upload)then
		MsgManager.ShowMsgByIDTable(997);
		return;
	end

	self.upload = true;

	local md5 = MyMD5.HashBytes(bytes);
	GamePhoto.SetPhotoFileMD5_UnionLogo(index, md5);
	ServicePhotoCmdProxy.Instance:CallAddMd5PhotoCmd(md5);
	
	local success_callback = function ()
		self.upload = false;
		ServiceGuildCmdProxy.Instance:CallGuildIconAddGuildCmd(index, 
			nil, 
			timestamp, 
			false, 
			PhotoFileInfo.PictureFormat.PNG);

		ServicePhotoCmdProxy.Instance:CallRemoveMd5PhotoCmd(md5);
	end
	local error_callback = function (msg)
		MsgManager.ShowMsgByIDTable(995);
		self.upload = false;
		error(msg);
	end
	helplog("FunctionGuild UploadCustomGuildIcon ~~~~~~~~~~~~~~~");
	UnionLogo.Ins():SetUnionID(guildid);
	UnionLogo.Ins():SaveAndUpload(index, 
		bytes, 
		timestamp,
		PhotoFileInfo.PictureFormat.PNG,
		progress_callback, 
		success_callback, 
		error_callback);
end

function FunctionGuild:GetGuildStrongHoldPosition(id)
	local configData = Table_Guild_StrongHold[id];
	if(configData == nil)then
		helplog(1);
		return;
	end

	local mapId = configData.MapId;
	if(mapId == nil)then
		helplog(2);
		return;
	end

	local mapName = Table_Map[mapId] and Table_Map[mapId].NameEn;
	if(mapName == nil)then
		helplog(3);
		return;
	end

	local sceneInfo = autoImport("Scene_" .. mapName);
	local guildFlags = sceneInfo.GuildFlags;

	if(guildFlags == nil)then
		helplog(4, mapName);
		return;
	end

	for k,v in pairs(guildFlags)do
		if(v.strongHoldId == id)then
			return mapId, v.position;
		end
	end
end