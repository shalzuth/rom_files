local BaseCell = autoImport("BaseCell")
autoImport("UnionLogo")
SceneBottomNameFactionCell = reusableClass("SceneBottomNameFactionCell", BaseCell);

SceneBottomNameFactionCell.resId = ResourcePathHelper.UICell("SceneBottomNameFactionCell")

SceneBottomNameFactionCell.npcColor = Color(1,197/255,20/255,1)
SceneBottomNameFactionCell.playerOrMstColor = Color(251/255,241/255,232/255,1)
SceneBottomNameFactionCell.playerEnemyColor = Color(1,0,0,1)

SceneBottomNameFactionCell.OpitimizedMode = false

local tempVector3 = LuaVector3.zero
SceneBottomNameFactionCell.PoolSize = 50

function SceneBottomNameFactionCell:Construct(asArray, args)	
	self:DoConstruct(asArray, args)
end

function SceneBottomNameFactionCell:DoConstruct(asArray, args)
	self._alive = true
	local gameObject = args[1]
	local creature = args[2]

	self.gameObject = gameObject
	if(creature:GetCreatureType() == Creature_Type.Me)then
		tempVector3:Set(0,-19,0)
	else
		tempVector3:Set(0,-10,0)
	end		
	self.gameObject.transform.localPosition = tempVector3
	self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
	tempVector3:Set(1,1,1)
	self.gameObject.transform.localScale = tempVector3
	self:initData(creature)
	self:initNameView()
	self:initFactionView()
	self:setNameFactionVisible(true)
	self:SetName(creature)
	self:SetFaction(creature)
end

function SceneBottomNameFactionCell:initData(creature)
	-- body
	self.ismyselfPet = self.creatureType == Creature_Type.Pet and creature:IsMyPet()
end

function SceneBottomNameFactionCell:Finalize()
	
end

function SceneBottomNameFactionCell:Deconstruct(asArray)
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		local parent = self.gameObject.transform.parent
		if(SceneBottomNameFactionCell.OpitimizedMode and not self:ObjIsNil(parent)) then
			SetParent(self.gameObject,parent.parent)
			Game.GOLuaPoolManager:AddToSceneUIMovePool(SceneBottomNameFactionCell.resId, self.gameObject)
		else
			Game.GOLuaPoolManager:AddToSceneUIPool(SceneBottomNameFactionCell.resId, self.gameObject)
		end
	end
	ReusableObject.Destroy(self.richName)
	self.gameObject = nil
	self._alive = false
end

function SceneBottomNameFactionCell:initFactionView(  )
	-- body
	self.factionIconAnchor = self:FindGO("factionIconAnchor"):GetComponent(UIWidget)
	self.factionIcon = self:FindGO("factionIcon"):GetComponent(UISprite)
	self.factionIcon_ = self:FindGO("factionIcon_"):GetComponent(UITexture)
	self.factionName = self:FindGO("factionName"):GetComponent(UILabel)
	self.factionJob = self:FindGO("factionJob"):GetComponent(UILabel)
	self.factionInfo = self:FindGO("factionInfo")
	self.factionTable = self.factionInfo:GetComponent(UITable)
	self.factionAnchor = self.factionInfo:GetComponent(UIWidget)	
end

function SceneBottomNameFactionCell:initNameView(  )
	-- body
	self.uiname = self:FindGO("playerName"):GetComponent(UILabel)
	self.PcNameCt = self:FindGO("PcNameCt")
	self.SpBloodContainer = self:FindGO("SpBloodContainer")
	self.richName = SpriteLabel.new(self.uiname,500,26,24)
	self.richName.richLabel.pivot = UIWidget.Pivot.Top
end

function SceneBottomNameFactionCell:SetName( creature )
	-- body
	local creatureData = creature.data
	local name = creatureData:GetName()
	----[[ todo xde 0002969: ?????? ?????????????????? ????????????????????? ????????????????????????????????? ??????????????????????????????????????????Yoyo	
	if creature:GetCreatureType() == Creature_Type.Pet  then
		---- todo xde  ??????????????? npc ????????????
		local isDefaultName = false
		local n = creatureData.name and creatureData.name or creatureData:GetOriginName()
		for k, v in pairs(Table_Monster) do
			if v.NameZh == OverSea.LangManager.Instance():GetLangByKey(n) then
				isDefaultName = true
				break
			end
		end
		if (isDefaultName) then
			-- xdlog('?????????????????????', n)
		else
			-- xdlog('?????????????????????', n)
			name = creatureData:GetName(true)
		end
	else
		--xdlog(name, creature:GetCreatureType(), creature.data.ownerID, Game.Myself.data.id)
	end
	--]]
	local camp = creatureData:GetCamp()
	self.richName:Reset()	
	--??????npc??????,????????????????????????
	local creatureType = creature:GetCreatureType()
	local isNpc = creatureType == Creature_Type.Npc and camp ~= RoleDefines_Camp.ENEMY	
	local isPlayerEnemy = creatureType == Creature_Type.Player and camp == RoleDefines_Camp.ENEMY
	local color = self.uiname.color
	if(isNpc)then
		if(color ~= SceneBottomNameFactionCell.npcColor)then
			self.uiname.color = SceneBottomNameFactionCell.npcColor
		end
	elseif(isPlayerEnemy)then
		if(color ~= SceneBottomNameFactionCell.playerEnemyColor)then
			self.uiname.color = SceneBottomNameFactionCell.playerEnemyColor
		end	
	else
		if(color ~= SceneBottomNameFactionCell.playerOrMstColor)then
			self.uiname.color = SceneBottomNameFactionCell.playerOrMstColor
		end		
	end

	local staticData = creatureData.staticData
	
	if(staticData and staticData.Type == "WeaponPet")then
		local masterName = TeamProxy.Instance:GetCatMasterName(creatureData:GetGuid())
		if(masterName)then
			name = string.format(ZhString.SceneNameView_MasterName,name,masterName)
		end
	end
	if(creatureData.GetAchievementtitle)then
		local titleId = creatureData:GetAchievementtitle()
		local titleData = Table_Appellation[titleId]
		if(titleData)then
			if(titleData.OrderType == 1)then
				name = name.." ["..titleData.Name.."]"
			else
				name = "["..titleData.Name.."] "..name
			end
		end
	end
	-- todo xde ???????????? xxx???????????????
	name = simpleReplace(name)
	name = AppendSpace2Str(name)
	self.richName:SetText(name)
	-- local myServantid = Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or -1
	
	-- if(staticData and staticData.id == myServantid)then
		-- self.richName:SetText("")
	-- else
		-- self.richName:SetText(name)
	-- end
end

function SceneBottomNameFactionCell:SetQuestPrefixName( creature,isShow )
	-- body	
	self.richName:Reset()	
	local name = creature.data:GetName()
	if(isShow)then
		name = string.format("{uiicon=%s}%s","icon_39",name)
	end
	-- todo xde ???????????? xxx???????????????
	name = simpleReplace(name)
	self.richName:SetText(name)
end

function SceneBottomNameFactionCell:SetFaction( creature )
	-- body
	local objNull = self:ObjIsNil(self.factionName)
	if(objNull)then
		return
	end
	local notHuSongPet = false
	local creatureType = creature:GetCreatureType()

	local ismyselfPet = creatureType == Creature_Type.Pet and creature:IsMyPet()
	local camp = creature.data:GetCamp()

	if(ismyselfPet and self.detailedType ~= NpcData.NpcDetailedType.Escort)then		
		notHuSongPet = true
	end

	--ZGBTODO
	local npcOrMonstData = creature.data.staticData

	local guildjob = ""
	local guildname = ""
	local guildicon 
	local customicon 
	local picType
	local guildData = creature.data:GetGuildData()
	if(guildData)then
		guildjob = guildData.job
		guildicon = guildData.icon
		guildname = guildData.name
		if guildData.customIconIndex and guildData.customIconIndex ~= 0 then
			customicon = guildData.customIconIndex
			picType = guildData.picType
		end

	end
	-- LogUtility.InfoFormat("SceneBottomNameFactionCell:SetFaction guildname:{0},job:{1},icon:{2}",guildname.."_"..self.uiname.text,guildjob,guildicon)
	if(npcOrMonstData and npcOrMonstData.Guild ~= "")then			
		self.factionName.text = npcOrMonstData.Guild
		self:Show(self.factionName.gameObject)
	elseif(guildname and guildname~="")then
		self.factionName.text = guildname
		self:Show(self.factionName.gameObject)
	else
		self:Hide(self.factionName.gameObject)
		-- self.factionName.text = ""
	end

	if(npcOrMonstData and npcOrMonstData.Position ~= "")then			
		self.factionJob.text = npcOrMonstData.Position
		self:Show(self.factionJob.gameObject)
	elseif(guildjob and guildjob~="")then
		self.factionJob.text = "["..'[c][FFC514FF]'..OverSea.LangManager.Instance():GetLangByKey(guildjob)..'[-][/c]'.."]" -- ????????????
		self:Show(self.factionJob.gameObject)
	else
		-- self.factionJob.text = ""
		self:Hide(self.factionJob.gameObject)
	end
	local showFc = npcOrMonstData and npcOrMonstData.GuildEmblem and npcOrMonstData.GuildEmblem ~= ""
	local lplayerFc = guildicon ~= nil
	if(showFc or lplayerFc or customicon)then
		self.factionAnchor.enabled = true
		local guildEmblem = npcOrMonstData and npcOrMonstData.GuildEmblem or nil
		local atlasOpt = npcOrMonstData and npcOrMonstData.AtlasOpt or nil
		if(lplayerFc)then
			self.factionIcon_.mainTexture = nil
			IconManager:SetGuildIcon(guildicon,self.factionIcon)
		elseif(customicon ~= nil)then
			self.factionIcon.spriteName = ""
			local texture = GuildPictureManager.Instance():GetThumbnailTexture(guildData.id,UnionLogo.CallerIndex.RoleFootDetail,customicon,guildData.customIconUpTime)
			if(texture)then
				self.factionIcon_.mainTexture = texture
			else
				self.factionIcon_.mainTexture = nil
				GuildPictureManager.Instance():AddMyThumbnailInfos({{callIndex = UnionLogo.CallerIndex.RoleFootDetail, guild = guildData.id,index = customicon,time=guildData.customIconUpTime,picType = picType}})
			end
		elseif(atlasOpt and atlasOpt ~= "" and UIAtlasConfig.IconAtlas[atlasOpt])then
			self.factionIcon_.mainTexture = nil
			IconManager:SetIcon(guildEmblem,self.factionIcon,UIAtlasConfig.IconAtlas[atlasOpt]);
		elseif(guildEmblem)then
			self.factionIcon_.mainTexture = nil
			IconManager:SetGuildIcon(guildEmblem,self.factionIcon)
		end
		self:Show(self.factionIcon.gameObject)
		self.factionAnchor:UpdateAnchors()
		self.factionIconAnchor:UpdateAnchors()
	else
		-- self.factionIcon.spriteName = ""
		self.factionAnchor.enabled = false
		tempVector3:Set(LuaGameObject.GetLocalPosition(self.factionInfo.transform))
		tempVector3.x = -(self.factionJob.width + 2)/2
		self.factionInfo.transform.localPosition = tempVector3
		self:Hide(self.factionIcon.gameObject)
		self.factionIcon_.mainTexture = nil
	end			
	if(ismyselfPet and not notHuSongPet)then		
		self.factionName.text = ZhString.PlayerBottomViewCell_Husong
		self.factionJob.text = ""
	end
	self:RefreshFactionLayout()
end

function SceneBottomNameFactionCell:setNameFactionVisible( visible )
	-- body
	local objNull = self:ObjIsNil(self.uiname)
	if(objNull)then
		return
	end
	self.gameObject:SetActive(visible)
end

function SceneBottomNameFactionCell:updateNameVisible(  )
	-- body
	local objNull = self:ObjIsNil(self.uiname)
	if(objNull)then
		return
	end

	-- if maskSettingRet or maskNameselfIndex ~= nil or maskNameHornorFactionselfIndex ~= nil or maskBNHFEIndex ~= nil then
	-- 	self.uiname.gameObject:SetActive(false)	
	-- else			
	-- 	if(not self:ObjIsNil(self.uiname))then
	-- 		self.uiname.gameObject:SetActive(visible)
	-- 		if(visible)then
	-- 			if(not self.uibloodcontainer.activeSelf)then
	-- 				tempVector3:Set(0,0,0)
	-- 				self.PcNameCt.transform.localPosition = tempVector3
	-- 			else
	-- 				tempVector3:Set(0,-22,0)
	-- 				self.PcNameCt.transform.localPosition = tempVector3
	-- 			end
	-- 		end
	-- 	end	
	-- end
end

function SceneBottomNameFactionCell:RefreshFactionLayout(  )
	-- body
	self.factionTable:Reposition()
end

function SceneBottomNameFactionCell:Alive()
	return self._alive
end