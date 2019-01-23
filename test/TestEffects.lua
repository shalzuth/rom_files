TestEffects = class("TestEffects")

function TestEffects.Me()
	if nil == TestEffects.me then
		TestEffects.me = TestEffects.new()
	end
	return TestEffects.me
end

function TestEffects:ctor()
	self.skillEffects = {
		"Angelus",
		"AngelusShield",
		"AnkleSnare",
		"ArcherAttack",
		"ArrowShower",
		"Aspersio",
		"BackSlide_attack",
		"Bleeding",
		"Blessing",
		"BowlingBash_attack",
		"BurstOperation",
		"CastSkill",
		"ClashingSpiral_attack",
		"Cloaking",
		"ColdBolt",
		"ColdBolt_1",
		"ColdBolt_10",
		"ColdBolt_2",
		"ColdBolt_3",
		"ColdBolt_4",
		"ColdBolt_5",
		"ColdBolt_6",
		"ColdBolt_7",
		"ColdBolt_8",
		"ColdBolt_9",
		"CounterAttack",
		"CrimsonRock",
		"CriticalHit",
		"Curse",
		"DarkClaw",
		"Dark_cast",
		"Dispersion",
		"Dizzy",
		"DoubleStrafe",
		"DragonBreath_hit",
		"DragonHowling_attack",
		"DrakAttributeHit",
		"DrugRoad",
		"EagleEye",
		"Eagle_hit",
		"Earth_cast",
		"Endure_cast",
		"Epiclesis",
		"FalconEyes",
		"FireAttributeHit",
		"FireHunt",
		"FireWall",
		"Fire_cast",
		"FlameShock_Boom",
		"FlameShock_Buff",
		"ForgingFailure",
		"ForgingSuccess",
		"FrostBlasting",
		"Frozen",
		"FrozenBroken",
		"GhostHit",
		"GoddessPurify",
		"Grimtooth",
		"HallucinationWalk",
		"Heal",
		"Heal_hit",
		"HolyLight",
		"HolyLight_hit",
		"Home",
		"HuntingOfFire",
		"ImpactBlade",
		"ImproveConcentration",
		"IncreaseSpeed",
		"JupitelThunder",
		"JupitelThunder_hit",
		"Keeping",
		"KyrieEleison",
		"KyrieEleisonShield",
		"LandMine",
		"LightAttributeHit",
		"LightHP",
		"LightHP_buff",
		"LightHunt",
		"Light_cast",
		"LordOfVermilion",
		"MagicFreezing",
		"MagicanAttack",
		"Magnificat",
		"MagnumBreak_attack",
		"MagnusExorcismus",
		"Mandragora_hit",
		"MudFlatDeep",
		"Parry",
		"PecoPecoRide",
		"PecoPecoRide_hit",
		"PhantomMenace",
		"PhantomOpera",
		"Pierce",
		"PoisonArrow_attack",
		"PoisonArrow_cast",
		"PoisonAttributeHit",
		"Provoke",
		"RageSpear",
		"RageSpear_buff",
		"Reading",
		"ReikiSpear",
		"RemoveHidden",
		"Renovatio",
		"Resurrection",
		"ResurrectionPrepare",
		"RollingCutter",
		"Sanctuary",
		"Sandman",
		"Silence",
		"Sleep",
		"SonicBlow",
		"SoulStrike",
		"SpearDynamo",
		"SpearPuncture_attack",
		"SpiritualShock",
		"SpreadMagic",
		"StaveCrasher",
		"Stone",
		"StoneCurse",
		"StormGust",
		"StrongBladeStrike",
		"Summon",
		"Task_Clover",
		"Task_GetWet",
		"Task_Rainbow",
		"Task_magic2",
		"Task_magic3",
		"Task_necklace",
		"Tast_magic",
		"Teleport",
		"TerrainAttributeHit",
		"ThermalLance_cast",
		"ThiefAttack",
		"Thunderstorm",
		"TurnUndead",
		"UndeadHit",
		"VenomDust",
		"VenomSplasher",
		"VitalStrike",
		"WaterAttributeHit",
		"Water_cast",
		"WateringPray",
		"WhiteImprison",
		"WindAttributeHit",
		"WindWalker",
		"Wind_cast",
		"fire_tuowei",
		"poisoning",
		"sniper",
		"sniper_hit",
		"treatment_cast",
	}

	self:Reset()
end

function TestEffects:Reset()
	if(self.effects) then
		for i=1,#self.effects do
			if(GameObjectUtil.Instance:ObjectIsNULL(self.effects[i])==false) then
				GameObject.Destroy(self.effects[i])
			end
		end
	end
	self.effects = {}
	self.index = 1
	TimeTickManager.Me():ClearTick(self)
end

function TestEffects:Switch()
	if(self.isRunning) then
		self:ShutDown()
	else
		self:Launch()
	end
end

function TestEffects:Launch()
	if(self.isRunning) then
		return
	end
	if(MyselfProxy.Instance.myself) then
		-- self.isRunning = true
		-- TimeTickManager.Me():CreateTick(0,300,function ()
		-- 	self:StepSpawnEffect()
		-- end,self)
		self.tests = {"StrongBladeStrike","Task_magic2","ArrowShower"}
		if(self.testIndex==nil) then
			self.testIndex = 1
		else
			self.testIndex = self.testIndex + 1
			if(self.testIndex>#self.tests) then
				self.testIndex = self.testIndex - #self.tests
			end
		end
		local name = self.tests[self.testIndex]

		self:SpawnEffect(name)
		LeanTween.delayedCall(0.5,function ()
			ResourceManager.Instance:UnLoad(ResourceIDHelper.IDEffectSkill(name),true)
			-- self:SpawnEffect("StrongBladeStrike")
			self.isRunning = false
		end)
	end
end

function TestEffects:SpawnEffect(effectName)
	if(effectName) then
		local myself = MyselfProxy.Instance.myself
		local ep = SkillUtils.GetEffectPointGameObject(myself.roleAgent, 1)
		local resID = ResourceIDHelper.IDEffectSkill(effectName)
		local effect = EffectHelper.PlayOneShotOn(resID,ep)
		local renders = effect:GetComponentsInChildren(Renderer)
		local mats
		for i=1,#renders do
			mats = renders[i].sharedMaterials
			for j=1,#mats do
				if(mats[j]==nil) then
					errorLog("fuck "..effectName)
				end
			end
		end
		return effect
	end
	return nil
end

function TestEffects:StepSpawnEffect()
	local effectName
	if(self.index<35) then
		effectName = self.skillEffects[self.index]
		self.index = self.index + 1
	else
		local index = math.random(1,#self.skillEffects)
		effectName = self.skillEffects[index]
		if(#self.effects>60) then
			self:RemoveEffectAt(1)
		end
	end
	if(effectName) then
		local effect = self:SpawnEffect(effectName)
		self.effects[#self.effects+1] = {effect=effect,resID = resID}
	end
end

function TestEffects:ShutDown()
	if(not self.isRunning) then
		return
	end
	self.isRunning = false
	self:Reset()
end

function TestEffects:RemoveEffectAt(index)
	if(GameObjectUtil.Instance:ObjectIsNULL(self.effects[index].effect)==false) then
		-- GameObject.Destroy(self.effects[index].effect)
		-- ResourceManager.Instance:UnLoad(self.effects[index].resID,true)
	end
	table.remove(self.effects,1)
end


-- local ProtobufPool_Get = ProtobufPool.Get
-- local ProtobufPool_Add = ProtobufPool.Add

-- local CMD = SceneUser_pb.RetMoveUserCmd
-- LogUtility.SetEnable(true)
-- LogUtility.SetTraceEnable(true)
-- local msg = SceneUser_pb.RetMoveUserCmd()
-- msg.charid =1000000000000000001
-- msg.pos.x = 100000
-- msg.pos.y = 12312312
-- msg.pos.z = 32454654
-- local test = msg:SerializeToString()

-- local msg2 = ProtobufPool_Get(CMD)
-- 	msg2:ParseFromString(test)
-- 	msg2:ParseFromString(test)
-- local count = 1000
-- local mem = collectgarbage("count")
-- local cpu = os.clock()
-- local msg2
-- for i = 1,count do
-- 	msg2 = ProtobufPool_Get(CMD)
-- 	msg2:ParseFromString(test)
-- 	ProtobufPool_Add(CMD,msg2)
-- end
-- LogUtility.InfoFormat("嵌套1 cpu:{0}  memory:{1}",(os.clock()-cpu),(collectgarbage("count")-mem))

-- local mem = collectgarbage("count")
-- local cpu = os.clock()
-- local msg3 = ProtobufPool_Get(SceneUser_pb.RetMoveUserCmd)
-- for i = 1,count do
-- 	msg3:ParseFromString(test)
-- end
-- LogUtility.InfoFormat("嵌套2 cpu:{0}  memory:{1}",(os.clock()-cpu),(collectgarbage("count")-mem))

-- --test 准确性
-- LogUtility.Info(tostring(msg3))

-- local CMD = SceneUser_pb.SkillBroadcastUserCmd
-- local msg = SceneUser_pb.SkillBroadcastUserCmd()
-- msg.charid =1000000000000000001
-- msg.skillID = 100000
-- msg.petid = 5123
-- msg.random = 11
-- msg.data.dir = 200
-- msg.data.number = 1
-- msg.data.pos.x = 1123
-- msg.data.pos.y = 1345
-- msg.data.pos.z = 1351
-- for i=1,2 do
-- 	local t = ProtobufPool_Get(SceneUser_pb.HitedTarget)
-- 	t.charid = 123231321
-- 	t.damage = 2103
-- 	t.type = 5
-- 	msg.data.hitedTargets[#msg.data.hitedTargets+1] = t
-- end
-- local test = msg:SerializeToString()

-- local mem = collectgarbage("count")
-- local cpu = os.clock()
-- local msg2
-- for i = 1,count do
-- 	msg2 = ProtobufPool_Get(CMD)
-- 	msg2:ParseFromString(test)
-- 	ProtobufPool_Add(CMD,msg2)
-- end
-- LogUtility.InfoFormat("repeat 1 cpu:{0}  memory:{1}",(os.clock()-cpu),(collectgarbage("count")-mem))

-- local mem = collectgarbage("count")
-- local cpu = os.clock()
-- local msg3 = ProtobufPool_Get(CMD)
-- for i = 1,count do
-- 	msg3:ParseFromString(test)
-- end
-- LogUtility.InfoFormat("repeat 2 cpu:{0}  memory:{1}",(os.clock()-cpu),(collectgarbage("count")-mem))


-- --test 准确性
-- LogUtility.Info(tostring(msg3))

-- local CMD = SceneMap_pb.AddMapUser
-- local CMD2 = SceneMap_pb.MapUser
-- local msg = SceneMap_pb.AddMapUser()

-- for i=1,10 do
-- 	local t = ProtobufPool_Get(SceneMap_pb.MapUser)
-- 	t.guid = i + 100000000000
-- 	t.name = tostring(i)
-- 	t.pos.x = 1123
-- 	t.pos.y = 1345
-- 	t.pos.z = 1351

-- 	t.dest.x = 5867
-- 	t.dest.y = 8908
-- 	t.dest.z = 34654

-- 	t.skillid = 9934234
-- 	t.teamid = 1
-- 	t.teamname = "haha"

-- 	for j=1,20 do
-- 		local attr = SceneUser_pb.UserAttr()
-- 		attr.type = i
-- 		attr.value = j
-- 		t.attrs[#t.attrs+1] = attr
-- 	end

-- 	for j=1,20 do
-- 		local attr = SceneUser_pb.UserData()
-- 		attr.type = i
-- 		attr.value = j
-- 		t.datas[#t.datas+1] = attr
-- 	end

-- 	msg.users[#msg.users+1] = t
-- end
-- local test = msg:SerializeToString()

-- local mem = collectgarbage("count")
-- local cpu = os.clock()
-- local msg2
-- for i = 1,count do
-- 	msg2 = ProtobufPool_Get(CMD)
-- 	msg2:ParseFromString(test)
-- 	ProtobufPool_Add(CMD,msg2)
-- end
-- LogUtility.InfoFormat("add user 1 cpu:{0}  memory:{1}",(os.clock()-cpu),(collectgarbage("count")-mem))

-- local mem = collectgarbage("count")
-- local cpu = os.clock()
-- local msg3 = ProtobufPool_Get(CMD)
-- for i = 1,count do
-- 	msg3:ParseFromString(test)
-- end
-- LogUtility.InfoFormat("add user 2 cpu:{0}  memory:{1}",(os.clock()-cpu),(collectgarbage("count")-mem))


-- --test 准确性
-- LogUtility.Info(tostring(msg3))