Trap = reusableClass('Trap')
Trap.PoolSize = 20

local CompatibilityMode_V9 = BackwardCompatibilityUtil.CompatibilityMode_V9
local CullingIDUtility = CullingIDUtility

function Trap:Init(guid,skillID,masterID,pos)
	self.id = guid
	self.skillID = skillID
	self.masterID = masterID
	self.pos = ProtolUtility.S2C_Vector3(pos)
	local skillinfo = Game.LogicManager_Skill:GetSkillInfo(skillID)

	local masterCreature = nil
	if nil ~= masterID and 0 ~= masterID then
		masterCreature = SceneCreatureProxy.FindCreature(masterID)
	end

	self:_SpawnCullingID()
	self:_CreateEffect(skillinfo:GetTrapEffectPath(masterCreature),self.pos)
end

function Trap:_SpawnCullingID()
	if CompatibilityMode_V9 then
		self.cullingID = CullingIDUtility.GetID()
	else
		self.cullingID = self.id
	end
end

function Trap:_ClearCullingID()
	if CompatibilityMode_V9 and self.cullingID ~=nil then
		CullingIDUtility.ClearID(self.cullingID)
	end
	self.cullingID = nil
end

local function OnEffectCreated(effectHandler, trap)
	if(trap~=nil and effectHandler~=nil) then
		Game.CullingObjectManager:Register_Trap(trap, effectHandler)
	end
end

function Trap:_CreateEffect(path,pos)
	if(path) then 
		self.effect = Asset_Effect.PlayAt( path, pos ,OnEffectCreated,self)
		self.effect:SetActive(self.active)
	end
end

--visible, -- int, not 0 is true, nil if not changed
--distanceLevel, -- int base 0, nil if not changed
-- {[0] <10,[1] 10~20 ,[2] 20~50 ,[3] >50}
function Trap:CullingStateChange(visible,distanceLevel)
	if(visible~=nil) then
		local active = (visible~=0 and true or false)
		self:SetActive(active)
	end
end

function Trap:SetActive(v)
	if(self.active == v) then
		return
	end
	self.active = v
	if(self.effect~=nil) then
		self.effect:SetActive(v)
	end
end

function Trap:SetPos(x,y,z)
	self.pos:Set(x,y,z)
	if(self.effect)then
		self.effect:ResetLocalPosition(self.pos)
	end
end

function Trap:SetScale(x,y,z)
	y = y or x
	z = z or x
	-- print(self.name,"scale",x,y,z)
end

function Trap:SetRotation(y)
	self.rotation = y
	if(self.effect)then
		self.effect:ResetLocalEulerAnglesXYZ(0,self.rotation,0)
	end
end

-- override begin
function Trap:DoConstruct(asArray, serverData)
	self.active = true
end

function Trap:DoDeconstruct(asArray)
	if(self.cullingID~=nil) then
		Game.CullingObjectManager:Unregister_Trap(self)
	end
	self:_ClearCullingID()
	if(self.pos) then
		self.pos:Destroy()
		self.pos = nil
	end
	if(self.effect) then
		self.effect:Destroy()
		self.effect = nil
	end
end
-- override end