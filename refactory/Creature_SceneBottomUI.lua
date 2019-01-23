Creature_SceneBottomUI = reusableClass("Creature_SceneBottomUI")
Creature_SceneBottomUI.PoolSize = 100

--玩家场景ui：玩家脚底UI（名字，血条/蓝条，公会信息..）
function Creature_SceneBottomUI:ctor()
	Creature_SceneBottomUI.super.ctor(self)
end
-- override begin

local cellData = {}
local tempVector3 = LuaVector3.zero

function Creature_SceneBottomUI:DoConstruct(asArray, creature)
	self.id = creature.data.id
	self.followParents = {}
	self.isSelected = false
	self.isBeHit = false
	self.isDead = creature:IsDead()
	self:checkCreateHpSp(creature)
	self:checkCreateNameFaction(creature)
end

-- Follow begin
function Creature_SceneBottomUI:GetSceneUIBottomFollow(type,creature)
	if(not type)then
		return
	end
	if(not self.followParents[type])then
		local container = SceneUIManager.Instance:GetSceneUIContainer(type);
		if(container)then
			local follow = GameObject(string.format("RoleBottomFollow_%s" ,creature.data:GetName()));
			follow.transform:SetParent(container.transform, false);
			follow.layer = container.layer;
			tempVector3:Set(0,-0.20,0)
			creature:Client_RegisterFollow(follow.transform, tempVector3, 0, nil, nil)
			
			-- local cube = GameObject.CreatePrimitive(PrimitiveType.Cube)
			-- tempVector3:Set(0,0,0)
			-- creature:Client_RegisterFollow(cube.transform, tempVector3, 0, nil, nil)

			self.followParents[type] = follow;
		end
	end
	return self.followParents[type];
end

function Creature_SceneBottomUI:UnregisterSceneUITopFollows()
	for key,follow in pairs(self.followParents)do
		if(not LuaGameObject.ObjectIsNull(follow))then
			Game.RoleFollowManager:UnregisterFollow(follow.transform)
			GameObject.Destroy(follow)
		end
		self.followParents[key] = nil
	end
end

function Creature_SceneBottomUI:DoDeconstruct(asArray)
	self:DestroyBottomUI()	
	self:UnregisterSceneUITopFollows();
end

function Creature_SceneBottomUI:isHpSpVisible( creature )
	-- body
	local id = creature.data.id
	local camp = creature.data:GetCamp()
	local neutral = RoleDefines_Camp.NEUTRAL == camp

	local creatureType = creature:GetCreatureType()
	local isMyself = creatureType == Creature_Type.Me
	local isPet = creatureType == Creature_Type.Pet
	local isSelected = self.isSelected
	local isBeHit = self.isBeHit 
	local isDead = self.isDead
	local isInMyTeam = TeamProxy.Instance:IsInMyTeam(id)
	local detailedType = creature.data.detailedType
	local isMvpOrMini = detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP

	local sceneUI = creature:GetSceneUI() 
	local maskBloodIndex = sceneUI and sceneUI:MaskByType(MaskPlayerUIType.BloodType) or nil
	local maskBNHFEIndex = sceneUI and sceneUI:MaskByType(MaskPlayerUIType.BloodNameHonorFactionEmojiType) or nil

	local inEdMap = false
	local mapId = Game.MapManager:GetMapID()
	if(mapId)then
		local raidData = Table_MapRaid[mapId]
		inEdMap = raidData and raidData.Type == 11 or false
	end

	local mask = maskBloodIndex ~= nil or maskBNHFEIndex ~= nil
	
	local isSkillNpc = detailedType == NpcData.NpcDetailedType.SkillNpc

	local isInVisible = mask or inEdMap or (isPet and not isSkillNpc) or neutral or isDead

	if isInVisible then
		return false
	elseif isMyself or TeamProxy.Instance:IsInMyTeam(id) or isSkillNpc then
		return true
	elseif camp ~= RoleDefines_Camp.ENEMY then
		if(isSelected)then
			return true
		end
	else
		--对立角色被击中显示血条,血量为0隐藏(血量为零暂不处理)
		if(self.isBeHit or isMvpOrMini or isSelected)then
			return true
		end
	end
	return false
end

function Creature_SceneBottomUI:checkCreateHpSp( creature )
	-- body
	local isVisible = self:isHpSpVisible(creature)
	if(isVisible)then
		self:createHpSpCell(creature)
	end	
end

function Creature_SceneBottomUI:createHpSpCell( creature )
	-- body
	-- local parent = self:GetSceneUIBottomFollow(SceneUIType.RoleBottomInfo,creature) 
	local parent;
	if(creature:GetCreatureType() == Creature_Type.Npc)then
		if(creature.data:IsMonster())then
			parent = self:GetSceneUIBottomFollow(SceneUIType.MonsterBottomInfo,creature) 
		else
			parent = self:GetSceneUIBottomFollow(SceneUIType.NpcBottomInfo,creature) 
		end
	else
		parent = self:GetSceneUIBottomFollow(SceneUIType.PlayerBottomInfo,creature) 
	end

	local resId = SceneBottomHpSpCell.resId
	Game.CreatureUIManager:AsyncCreateUIAsset(self.id,resId,parent,self.createHpSpCellFinish,creature)
end

function Creature_SceneBottomUI.createHpSpCellFinish(obj,creature)
	-- body
	if(obj)then
		TableUtility.ArrayClear(cellData)
		cellData[1] = obj
		cellData[2] = creature		
		local sceneUI = creature and creature:GetSceneUI() or nil
		if(sceneUI)then
			local bottomUI = sceneUI.roleBottomUI
			Game.CreatureUIManager:RemoveCreatureWaitUI( bottomUI.id, SceneBottomHpSpCell.resId)
			bottomUI.hpSpCell = SceneBottomHpSpCell.CreateAsArray(cellData)

			local isVisible = bottomUI:isHpSpVisible(creature)
			bottomUI.hpSpCell:setHpSpVisible(isVisible)
		end
	end	
end

function Creature_SceneBottomUI:SetHp(ncreature)	
	if(self.hpSpCell)then
		local hp = ncreature.data.props.Hp:GetValue()
		local maxHp = ncreature.data.props.MaxHp:GetValue()
		self.hpSpCell:SetHp(hp,maxHp)
		if(hp<=0)then
			self.isDead = true
		else
			self.isDead = false
		end

		--don't set invisible at this ,tween blood end set invisible
		--need set visible at this,
		local isHpSpVisible = self:isHpSpVisible(ncreature)
		if(isHpSpVisible)then
			self.hpSpCell:setHpSpVisible(true)
		end
	end
end

function Creature_SceneBottomUI:SetSp(ncreature)	
	if(self.hpSpCell)then
		local sp = ncreature.data.props.Sp:GetValue()
		local maxSp = ncreature.data.props.MaxSp:GetValue()
		self.hpSpCell:SetSp(sp,maxSp)
	end
end

function Creature_SceneBottomUI:isNameFactionVisible( creature )
	-- body
	local id = creature.data.id
	local camp = creature.data:GetCamp()
	local neutral = RoleDefines_Camp.NEUTRAL == camp
	local creatureType = creature:GetCreatureType()
	local isMyself = creatureType == Creature_Type.Me
	local isPet = creatureType == Creature_Type.Pet
	local isMyPet = isPet and creature:IsMyPet() or false
	local isSelected = self.isSelected
	local detailedType = creature.data.detailedType

	local sceneUI = creature:GetSceneUI() 
	local maskBloodIndex = sceneUI and sceneUI:MaskByType(MaskPlayerUIType.NameType) or nil
	local maskBNHFIndex = sceneUI and sceneUI:MaskByType(MaskPlayerUIType.NameHonorFactionType) or nil
	local maskBNHFEIndex = sceneUI and sceneUI:MaskByType(MaskPlayerUIType.BloodNameHonorFactionEmojiType) or nil

	--设置
	local showName = FunctionPerformanceSetting.Me():IsShowOtherName()
	if(isMyself or isMyPet)then
		showName = true
	end

	local mask = not showName or maskBloodIndex~=nil or maskBNHFIndex~= nil or maskBNHFEIndex~=nil

		--显示规则(isMvpOrMini)
	local isPlayer = creatureType == Creature_Type.Player or creatureType == Creature_Type.Me
	local isNpc = creatureType == Creature_Type.Npc and camp ~= RoleDefines_Camp.ENEMY	
	local isCatchPet = isPet and creature.data.IsPet and creature.data:IsPet()
	local isMvpOrMini = detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP		
	local isInMyTeam = TeamProxy.Instance:IsInMyTeam(id)

	local allShowName = false -- 是否一直显示名字
	local allInVisible = false -- 是否一直不显示即使选中
	local selectShow = false --选中显示
	local staticData = creature.data.staticData
	if(staticData)then
		allShowName = staticData.ShowName == 2
		allInVisible = staticData.ShowName == 1

		selectShow = not staticData.ShowName or staticData.ShowName == 0
		selectShow = selectShow and isSelected or false
	end

	local visible = isPlayer or selectShow or isCatchPet or isMyPet or isMvpOrMini or isInMyTeam or isSelected or allShowName
	visible = visible and not allInVisible
	if mask then
		return false
	else
		return visible	
	end
end

function Creature_SceneBottomUI:checkCreateNameFaction( creature )
	-- body
	local isVisible = self:isNameFactionVisible(creature)	
	if(isVisible)then
		self:createNameFaction(creature)
	end	
end

function Creature_SceneBottomUI:createNameFaction( creature )
	-- body
	-- local parent = self:GetSceneUIBottomFollow(SceneUIType.RoleBottomInfo,creature) 
	local parent;
	if(creature:GetCreatureType() == Creature_Type.Npc)then
		if(creature.data:IsMonster())then
			parent = self:GetSceneUIBottomFollow(SceneUIType.MonsterBottomInfo,creature) 
		else
			parent = self:GetSceneUIBottomFollow(SceneUIType.NpcBottomInfo,creature) 
		end
	else
		parent = self:GetSceneUIBottomFollow(SceneUIType.PlayerBottomInfo,creature) 
	end

	local resId = SceneBottomNameFactionCell.resId
	Game.CreatureUIManager:AsyncCreateUIAsset(self.id,resId,parent,self.createNameFactionFinish,creature,nil,SceneBottomNameFactionCell.OpitimizedMode)
end

function Creature_SceneBottomUI.createNameFactionFinish(obj,creature)
	-- body
	if(obj)then
		TableUtility.ArrayClear(cellData)
		cellData[1] = obj
		cellData[2] = creature
		local sceneUI = creature:GetSceneUI()
		if(sceneUI)then
			local bottomUI = sceneUI.roleBottomUI
			Game.CreatureUIManager:RemoveCreatureWaitUI( bottomUI.id, SceneBottomNameFactionCell.resId);
			bottomUI.nameFactionCell = SceneBottomNameFactionCell.CreateAsArray(cellData)

			local isVisible = bottomUI:isNameFactionVisible(creature)
			bottomUI.nameFactionCell:setNameFactionVisible(isVisible)

			local creatureType = creature:GetCreatureType()
			local showPre = creatureType == Creature_Type.Npc
			if(showPre)then
				if(FunctionQuest.Me():checkShowMonsterNamePre(creature))then
					bottomUI.nameFactionCell:SetQuestPrefixName(creature,true)
				end
			end
		end
	end	
end

function Creature_SceneBottomUI:HandleSettingMask( creature )
	-- body
	if(self.hpSpCell)then
		local isVisible = self:isHpSpVisible(creature)
		self.hpSpCell:setHpSpVisible(isVisible)
	else
		self:checkCreateHpSp(creature)
	end

	if(self.nameFactionCell)then
		local isVisible = self:isNameFactionVisible(creature)
		self.nameFactionCell:setNameFactionVisible(isVisible)
	else
		self:checkCreateNameFaction(creature)
	end
end

function Creature_SceneBottomUI:HandlerPlayerFactionChange( creature )
	-- body
	if(self.nameFactionCell)then
		self.nameFactionCell:SetFaction(creature)
	else
		self:checkCreateNameFaction(creature)
	end
end

function Creature_SceneBottomUI:HandleChangeTitle( creature )
	-- body
	if(self.nameFactionCell)then
		self.nameFactionCell:SetName(creature)
	else
		self:checkCreateNameFaction(creature)
	end
end

function Creature_SceneBottomUI:HandlerMemberDataChange( creature )
	-- body
	if(self.hpSpCell)then
		local isVisible = self:isHpSpVisible(creature)
		self.hpSpCell:setHpSpVisible(isVisible)
	else
		self:checkCreateHpSp(creature)
	end
end

function Creature_SceneBottomUI:HandleCampChange( creature )
	-- body
	if(self.hpSpCell)then
		local isVisible = self:isHpSpVisible(creature)
		self.hpSpCell:setHpSpVisible(isVisible)
		self.hpSpCell:setCamp(creature.data:GetCamp())

	else
		self:checkCreateHpSp(creature)
	end

	if(self.nameFactionCell)then
		local isVisible = self:isNameFactionVisible(creature)
		self.nameFactionCell:setNameFactionVisible(isVisible)
		self.nameFactionCell:SetName(creature)
	else
		self:checkCreateNameFaction(creature)
	end
end

function Creature_SceneBottomUI:SetIsSelected( isSelected ,creature)
	-- body
	self.isSelected = isSelected

	if(self.hpSpCell)then
		local isVisible = self:isHpSpVisible(creature)
		self.hpSpCell:setHpSpVisible(isVisible)
	else
		self:checkCreateHpSp(creature)
	end

	if(self.nameFactionCell)then
		local isVisible = self:isNameFactionVisible(creature)
		self.nameFactionCell:setNameFactionVisible(isVisible)
	else
		self:checkCreateNameFaction(creature)
	end
end

function Creature_SceneBottomUI:SetIsBeHit( isBeHit,creature )
	-- body
	self.isBeHit = isBeHit
	if(self.hpSpCell)then
		local isVisible = self:isHpSpVisible(creature)
		self.hpSpCell:setHpSpVisible(isVisible)
	else
		self:checkCreateHpSp(creature)
	end
end

function Creature_SceneBottomUI:ActiveSpHpCell( active )
	-- body
	if(active)then
		local creature = SceneCreatureProxy.FindCreature(self.id)
		if(not creature)then
			return
		end
		if(self.hpSpCell and self:isHpSpVisible(creature))then
			self.hpSpCell:Show()
		else
			self:checkCreateHpSp(creature)
		end
	else
		if(self.hpSpCell)then
			self.hpSpCell:Hide()
		end
	end
end

function Creature_SceneBottomUI:ActiveNameFactionCell( active )
	-- body
	if(active)then
		local creature = SceneCreatureProxy.FindCreature(self.id)
		if(not creature)then
			return
		end
		if(self.nameFactionCell and self:isNameFactionVisible(creature))then
			self.nameFactionCell:Show()
		else
			self:checkCreateNameFaction(creature)
		end
	else
		if(self.nameFactionCell)then
			self.nameFactionCell:Hide()
		end
	end
end
 
function Creature_SceneBottomUI:ActiveSceneUI(maskPlayerUIType, active)
	if(maskPlayerUIType == MaskPlayerUIType.BloodType)then
		self:ActiveSpHpCell(active)
	elseif(maskPlayerUIType == MaskPlayerUIType.BloodNameHonorFactionEmojiType)then
		self:ActiveSpHpCell(active)
		self:ActiveNameFactionCell(active)
	elseif(maskPlayerUIType == MaskPlayerUIType.NameType)then
		self:ActiveNameFactionCell(active)
	elseif(maskPlayerUIType == MaskPlayerUIType.NameHonorFactionType)then
		self:ActiveNameFactionCell(active)
	end
end

function Creature_SceneBottomUI:DestroyBottomUI()
	if(self.nameFactionCell)then
		ReusableObject.Destroy(self.nameFactionCell)
	end

	if(self.hpSpCell)then
		ReusableObject.Destroy(self.hpSpCell)		
	end	

	Game.CreatureUIManager:RemoveCreatureWaitUI( self.id, SceneBottomHpSpCell.resId);
	Game.CreatureUIManager:RemoveCreatureWaitUI( self.id, SceneBottomNameFactionCell.resId );
	self.hpSpCell = nil	
	self.nameFactionCell = nil	
end

function Creature_SceneBottomUI:SetQuestPrefixVisible(creature,isShow)
	if(self.nameFactionCell)then
		self.nameFactionCell:SetQuestPrefixName(creature,isShow)
	end
end
