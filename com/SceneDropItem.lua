autoImport("SceneLItem")
autoImport("SceneDropNameCell")
SceneDropItem = reusableClass('SceneDropItem',SceneLItem)
SceneDropItem.PoolSize = 20

SceneDropItem.State = {
	Wait,
	Appear,
	OnGround,
	Disappear
}

SceneDropItem.ItemResID = {}
SceneDropItem.EffectResID = {}
--玩家背包数据管理

local tempVector3 = LuaVector3.zero
function SceneDropItem:ctor()
	SceneDropItem.super.ctor(self)
end
-- function SceneDropItem:ctor(guid,staticData,equipStaticData,leftTime,pos,owners,config,sourceID)
-- 	self:ResetData(guid,staticData,equipStaticData,leftTime,pos,owners,config,sourceID)
-- end

function SceneDropItem:ResetData( guid,staticData,equipStaticData,leftTime,pos,owners,config,sourceID,refinelv)
	self.id = guid
	self.failedGetCount = 0
	self.isPicked = false
	self.onGroundFunc = nil
	self.onFlagFunc = nil
	self.onPickSuccessFunc = nil
	self:SetState(SceneDropItem.State.Wait)
	self.staticData = staticData
	self.equipStaticData = equipStaticData
	self.privateOwnLeftTime = leftTime
	self.pos = LuaVector3(pos.x,pos.y,pos.z)
	ProtolUtility.Better_S2C_Vector3(self.pos, self.pos)
	-- self.pos = NavMeshAdjustY.Adjust(PosUtil.DevideVector3(pos.x,pos.y,pos.z))
	NavMeshUtility.Better_Sample(self.pos, self.pos, 1)
	self:SetCanPickUp(false)
	self.config = config
	self.isskill = config == GameConfig.SceneDropItem.Skill
	self.sourceID = sourceID
	self.refinelv = refinelv
	self:GetConfig()
end

function SceneDropItem:SetState(state)
	self.state = state
end

function SceneDropItem:SetCanPickUp(val)
	self.iCanPickUp = val
end

function SceneDropItem:SetOnGroundCallBack(func,owner,...)
	self.onGroundFunc = ReusableTable.CreateArray()
	self.onGroundFunc[1] = func
	self.onGroundFunc[2] = owner
	self.onGroundFunc[3] = {...}
	-- self.onGroundFunc = {Func=func,Owner = owner,Param = {...}}
end

function SceneDropItem:ClearOnGroundCallBack()
	ReusableTable.DestroyAndClearArray(self.onGroundFunc)
	self.onGroundFunc = nil
end

function SceneDropItem:DropOnGround()
	self:CallBack(self.onGroundFunc)
	self:CallBack(self.onFlagFunc)
end

function SceneDropItem:CallBack(t)
	if(t~=nil) then
		if(t[3]~=nil) then
			-- print(t.Param[1])
			t[1](t[2],self,unpack(t[3]))
		else
			t[1](t[2],self)
		end
	end
end

function SceneDropItem:GetConfig()
	if(self.config==nil) then
		if(self.equipStaticData~=nil) then
			self.config = GameConfig.SceneDropItem.EquipBox
		else
			self.config = GameConfig.SceneDropItem.ItemBox
		end
	end
end

function SceneDropItem:PlayAnim(state)
	if(self.animPlayer~=nil) then
		self.animatorHelper:Play(state,1,false)
	end
end

function SceneDropItem:PlayAnimForce(state)
	if(self.animPlayer~=nil) then
		self.animatorHelper:PlayForce(state,1)
	end
end

function SceneDropItem:FailGet()
	self.failedGetCount = self.failedGetCount + 1
	self:PlayAnimForce(GameConfig.SceneDropItem.Anims.WrongItem)
end

function SceneDropItem:Pick(func,owner,...)
	if(self.isPicked==false) then
		self.isPicked = true
		self.onPickSuccessFunc = ReusableTable.CreateArray()
		self.onPickSuccessFunc[1] = func
		self.onPickSuccessFunc[2] = owner
		self.onPickSuccessFunc[3] = {...}
		self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemOpen)
		-- if(self.config.DropPerform==1) then
		-- 	self.onPickSuccessFunc = {Func=func,Owner = owner,Param = {...}}
		-- 	self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemOpen)
		-- elseif(self.config.DropPerform==2) then
		-- 	func(owner,self,...)
		-- end
	end
end

function SceneDropItem:GetEffectPoint(index)
	if(self.pointSub~=nil) then
		return self.pointSub:GetEffectPoint(index).transform.position
	else
		return self.pos
	end
end

function SceneDropItem:CreateModel()
	if(self.model==nil) then
		self.model = Game.AssetManager_SceneDropItem:CreateSceneDrop(self.config.Model)

		if(self.isskill)then
			self:SetSkillIcon();
		end

		self.model.name = "Item_"..self.id
		local configScale = self.config.Scale
		tempVector3:Set(configScale,configScale,configScale)
		self.model.transform.localScale = tempVector3
		self.model.transform.localPosition = self.pos
		self.animPlayer = self.model:GetComponent(SimpleAnimatorPlayer)
		self.animatorHelper = self.animPlayer.animatorHelper
		self.pointSub = self.model:GetComponent(PointSubject)
		self.animatorHelper.actionEventListener = function (state,eventID,eventData)
			if(eventData == GameConfig.SceneDropItem.Anims.ItemOpen) then
				self:CallBack(self.onPickSuccessFunc)
			end
		end
	end
end

local tempVector2 = LuaVector2.zero

function SceneDropItem:SetSkillIcon()
	if(self.model == nil)then
		return;
	end
	if(self.staticData == nil)then
		return;
	end

	local item_skill = GameConfig.PoliFire.item_skill;
	local skillid = item_skill[self.staticData.id];
	local icon = nil;
	if(skillid == nil)then
		icon = self.staticData.Icon;
	else
		icon = Table_Skill[skillid] and Table_Skill[skillid].Icon or "";
	end
	if(icon == nil or icon == "")then
		return;
	end

	local atlas, spriteData;
	local skillAtlas = IconManager:GetAtlasByType(UIAtlasConfig.IconAtlas.Skill);
	for i=1, #skillAtlas do
		spriteData = skillAtlas[i]:GetSprite(icon);
		if(spriteData ~= nil)then
			atlas = skillAtlas[i];
			break;
		end
	end

	if(atlas == nil or spriteData == nil)then
		return;
	end

	local texture = atlas.texture;
	local offsetX = spriteData.x/texture.width;
	local offsetY = (texture.height - spriteData.y - spriteData.height)/texture.height;
 	local scaleX = spriteData.width/texture.width;
 	local scaleY = spriteData.height/texture.height;

	local go = GameObjectUtil.Instance:DeepFindChild(self.model.gameObject, "Skill");
	local renderer = go:GetComponent(Renderer);

	renderer.material = Game.Prefab_SceneGuildIcon.sharedMaterial
	renderer.material.mainTexture = texture
	-- renderer.material.mainTexture = texture;

	if nil ~= offsetX and nil ~= offsetY then
		tempVector2:Set(offsetX, offsetY)
		renderer.material.mainTextureOffset = tempVector2
	end
	if nil ~= scaleX and nil ~= scaleY then
		tempVector2:Set(scaleX, scaleY)
		renderer.material.mainTextureScale = tempVector2
	end
end

function SceneDropItem:Appear()
	self:SetState(SceneDropItem.State.OnGround)
	self:CreateModel()
	if(self.config.DropPerform==1) then
		self:ShowQuality()
	-- elseif(self.config.DropPerform==2) then
	-- 	self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemDrop)
	end
	self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemDrop)
end

function SceneDropItem:PlayAppear()
	self:CreateModel()
	self:SetState(SceneDropItem.State.Appear)
	-- if(self.config.DropPerform==1) then
	-- 	self.model:SetActive(false)
	-- 	-- self:ShowSmoke()
	-- 	LeanTween.delayedCall(self.model,self.config.Delay/1000,function ()
	-- 		self.model:SetActive(true)
	-- 		self:ShowQuality()
	-- 		self:DropOnGround()
	-- 	end)
	-- elseif(self.config.DropPerform==2) then
	-- 	self.animPlayer.animatorHelper.loopCountChangedListener = function (state,old,new)
	-- 		if(state:IsName(GameConfig.SceneDropItem.Anims.ItemBorn) or state:IsName(GameConfig.SceneDropItem.Anims.WrongItem)) then
	-- 			self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemDrop)
	-- 		end
	-- 	end
	-- 	self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemBorn)
	-- 	self:DropOnGround()
	-- end
	self.animatorHelper.loopCountChangedListener = function (state,old,new)
		if(state:IsName(GameConfig.SceneDropItem.Anims.ItemBorn) or state:IsName(GameConfig.SceneDropItem.Anims.WrongItem)) then
			if(self.config.DropPerform==1 and state:IsName(GameConfig.SceneDropItem.Anims.ItemBorn)) then
				self:ShowQuality()
			end
			self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemDrop)
		end
	end
	self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemBorn)
	self:DropOnGround()
end

function SceneDropItem:ShowSmoke()
	Asset_Effect.PlayOneShotAt( EffectMap.Maps.ItemSmoke, p)
end

function SceneDropItem:ShowQuality()

	local effect
	if(self.isskill)then
		effect = "Common/Poring_Skill";
	else
		effect = GameConfig.SceneDropItem.Quality[self.staticData.Quality]
	end
	if(effect) then
		self.qualityEffect = Asset_Effect.PlayAt(effect,self.pos)
	end
	
end

function SceneDropItem:SetDestroyFlag(func,owner)
	if(self.onFlagFunc==nil) then
		if(self.state==SceneDropItem.State.OnGround) then
			func(owner,self)
		else
			self.onFlagFunc = ReusableTable.CreateArray()
			self.onFlagFunc[1] = func
			self.onFlagFunc[2] = owner
		end
	end
end

function SceneDropItem:SetPickUpFlag(func,owner,...)
	if(self.state==SceneDropItem.State.OnGround) then
		func(owner,self,...)
	else
		self.onFlagFunc = ReusableTable.CreateArray()
		self.onFlagFunc[1] = func
		self.onFlagFunc[2] = owner
		self.onFlagFunc[3] = ...
	end
end

function SceneDropItem:DestorySelf(dontRemoveSceneName)
	if(not dontRemoveSceneName and self.config.ShowName) then
		self:DestroyUI()
	end
	if(self.pos) then
		self.pos:Destroy()
		self.pos = nil
	end
	-- self:PlayAnimForce("Empty")
	if(self.model~=nil) then
		LeanTween.cancel(self.model)
		Game.AssetManager_SceneDropItem:DestroySceneDrop(self.config.Model,self.model)
		-- GameObject.Destroy(self.model)
		self.model = nil
	end
	if(self.qualityEffect~=nil) then
		self.qualityEffect:Destroy()
		self.qualityEffect = nil
	end
	self.animPlayer = nil
	if(self.animatorHelper) then
		self.animatorHelper.loopCountChangedListener = nil
	end
	self.animatorHelper = nil
	self.onFlagFunc = self:ClearCallFunc(self.onFlagFunc)
	self.onPickSuccessFunc = self:ClearCallFunc(self.onPickSuccessFunc)
	self:ClearOnGroundCallBack()
	self:Destroy()
end

function SceneDropItem:ClearCallFunc(funcTable)
	if(funcTable) then
		TableUtility.ArrayClear(funcTable)
		ReusableTable.DestroyArray(funcTable)
	end
	return nil
end

function SceneDropItem:Client_RegisterFollow(transform, offset, lostCallback, lostCallbackArg)
	if nil == offset then
		tempVector3:Set(0,0,0)
		offset = tempVector3
	end
	Game.TransformFollowManager:RegisterFollowPos(
		transform, 
		self.model.transform,
		offset, 
		lostCallback, 
		lostCallbackArg)
end

function SceneDropItem:ShowName()
	local ui = SceneDropNameCell.CreateAsTable(self)
	self.ui = ui
end

function SceneDropItem:ShowIcon()
	self.ui_icon = SceneDropIconCell.CreateAsTable(self);
end

function SceneDropItem:DestroyUI()
	if(self.ui) then
		self.ui:Destroy()
	end
	self.ui = nil

	if(self.ui_icon)then
		self.ui_icon:Destroy();
	end
	self.ui_icon = nil;
end

-- override begin
function SceneDropItem:DoConstruct(asArray, data)
end

function SceneDropItem:DoDeconstruct(asArray)
	self:DestroyUI()
end

function SceneDropItem:OnObserverDestroyed(k, obj)
end
-- override end