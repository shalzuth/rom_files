autoImport("EventDispatcher")
autoImport("LuaQueue")
autoImport("BarrageView")
FunctionBarrage = class("FunctionBarrage",EventDispatcher)

function FunctionBarrage.Me()
	if nil == FunctionBarrage.me then
		FunctionBarrage.me = FunctionBarrage.new()
	end
	return FunctionBarrage.me
end

function FunctionBarrage:ctor()
	self.numLimit = GameConfig.Barrage.MessageCountMax
	self.tickID = 1
	self.uiroot = GameObject.Find("UIRoot")
	self:Reset()
	self.meshIsLoaded = false
end

local vec3 = LuaVector3.New(0, 0, 0)
local callbackInitializeComplete = nil
local isInitializeComplete = false
local isLaunchComplete = false
local callbackLaunchComplete = nil
local _meshSelfRotateSpeed = 0

function FunctionBarrage:Launch(meshSelfRotateSpeed, callback_launch_complete)
	if(self.running) then return end

	_meshSelfRotateSpeed = meshSelfRotateSpeed
	callbackLaunchComplete = callback_launch_complete

	self:Initialize()
end

function FunctionBarrage:Initialize()
	callbackInitializeComplete = callback_intialize_complete

	if self.transMainCamera == nil or GameObjectUtil.Instance:ObjectIsNULL(self.transMainCamera) then
		self.transMainCamera = GameObject.FindGameObjectWithTag("MainCamera").transform
	end

	if self.barrage == nil or GameObjectUtil.Instance:ObjectIsNULL(self.barrage.gameObject) then
		self.barrage = BarrageView.new(Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("Barrages"), self.uiroot));
	end
	if self.barrageCam == nil or GameObjectUtil.Instance:ObjectIsNULL(self.barrageCam) then
		self.barrageCam = GameObjectUtil.Instance:DeepFindChild(self.barrage.gameObject,"BarrageCamera"):GetComponent(CameraProjector)
	end
	self.barrageCam.sampleSize = Vector2(BarrageView.activeWidth, self.barrage:GetActiveHeight())

	if self.goMesh == nil or GameObjectUtil.Instance:ObjectIsNULL(self.goMesh) then
		self:LoadMesh()
	else
		self.barrage.gameObject:SetActive(true)
		self.goMesh:SetActive(true)
		self.running = true
		self:ResetMeshRotSpeed(_meshSelfRotateSpeed)
		if callbackLaunchComplete ~= nil then
			callbackLaunchComplete()
		end
	end
end

function FunctionBarrage:OnInitializeComplete()
	if isInitializeComplete then
		isLaunchComplete = true
		if callbackLaunchComplete ~= nil then
			callbackLaunchComplete()
		end
	end
end

function FunctionBarrage:LoadMesh()
	local posOfCamera = self.transMainCamera.position
	vec3:Set(posOfCamera.x, posOfCamera.y, posOfCamera.z)
	Asset_Effect.PlayAt(EffectMap.Maps.Barrage, vec3, function (go_mesh)
		self:OnMeshBeLoaded(go_mesh)
	end)
end

function FunctionBarrage:OnMeshBeLoaded(effect_handle)
	self.goMesh = effect_handle.gameObject

	self.barrageRotateSelf = self.goMesh:GetComponent(RotateSelf)
	self.barrageCam.targetRenderer = self.goMesh:GetComponentInChildren(MeshRenderer)

	vec3:Set(0, 0, 0)
	Game.TransformFollowManager:RegisterFollowPos(self.goMesh.transform, myselfTransform, vec3, function ()
		
	end)

	self.barrage.gameObject:SetActive(true)
	self.goMesh:SetActive(true)
	self.running = true
	self:ResetMeshRotSpeed(_meshSelfRotateSpeed)

	self.meshIsLoaded = true
	if self.meshIsLoaded then
		isInitializeComplete = true
		self:OnInitializeComplete()
	end
end

function FunctionBarrage:ShutDown()
	if(not self.running) then return end

	self:Reset()

	if(self.barrage) then
		self.barrage.gameObject:SetActive(false)
	end
	if(self.goMesh) then
		self.goMesh:SetActive(false)
	end
end

function FunctionBarrage:Reset()
	self.waitQueue = {}
	if(self.barrages~=nil) then
		for i=1,#self.barrages do
			self:RemoveBarrage(self.barrages[i])
		end
	end
	self.running = false
	self.barrages = {}
	TimeTickManager.Me():ClearTick(self,self.tickID)
end

function FunctionBarrage:ResetMeshRotSpeed(meshSelfRotateSpeed)
	self.meshSelfRotateSpeed = meshSelfRotateSpeed or 30
	self.duration = 360/self.meshSelfRotateSpeed
	if(self.barrage) then
		self.meshSpeed = BarrageView.activeWidth * (self.meshSelfRotateSpeed/360.0)
	end
	if(self.barrageRotateSelf) then
		self.barrageRotateSelf.rotateSpeed = -math.abs(self.meshSelfRotateSpeed)
	end
end

function FunctionBarrage:GetTransformOfMyself()
	return Game.Myself.assetRole.completeTransform
end

-- {id,text,speed,color,fontSize,duration, percent}
function FunctionBarrage:AddText(data)
	if(not self.running) then return end
	local barrage = self:Find(data.id)
	if(barrage==nil) then
		if(#self.barrages >= self.numLimit) then
			if(self:Find(data.id,self.waitQueue)==nil) then
				self.waitQueue[#self.waitQueue+1] = data
			end
			-- self:Remove(self.barrages[1])
		else
			self:_AddText(data)
		end
	end
end

function FunctionBarrage:_AddText(data)
	data.duration = data.duration or self.duration
	if(data.percent == nil) then
		data.percent = self:GetPercent()
	end
	self.barrages[#self.barrages+1] = data
	local go = self.barrage:AddText(data)
	go.transform.localScale = Vector3(1,BarrageView.yScale,1)
	if(data.speed<=self.meshSpeed) then
		LeanTween.delayedCall(go,data.duration,function ()
			self:Remove(data)
		end)
	else
		local deltaSpeed = data.speed - self.meshSpeed
		local deltaDistance = deltaSpeed * data.duration
		local x = go.transform.localPosition.x
		local targetX = math.max(x - deltaDistance, -BarrageView.activeWidth/2)
		LeanTween.moveLocalX(go, targetX, data.duration):setOnComplete(function ()
			self:Remove(data)
		end)
	end
end

function FunctionBarrage:Remove(data)
	local index = TableUtil.ArrayIndexOf(self.barrages,data)
	if(index>0) then
		local barrage = self.barrages[index]
		self:RemoveBarrage(barrage)
		TableUtil.Remove(self.barrages,barrage)
		if(#self.waitQueue>0) then
			self:_AddText(table.remove(self.waitQueue, 1))
		end
	end
end

function FunctionBarrage:RemoveByID(id)
	local barrage = self:Find(id)
	if(barrage) then
		self:RemoveBarrage(barrage)
		TableUtil.Remove(self.barrages,barrage)
		if(#self.waitQueue>0) then
			self:_AddText(table.remove(self.waitQueue, 1))
		end
	end
end

function FunctionBarrage:RemoveBarrage(barrage)
	local go = self.barrage:RemoveText(barrage)
	LeanTween.cancel(go)
end

function FunctionBarrage:FindIndex(id,array)
	array = array or self.barrages
	for i=1,#array do
        if id~=nil and array[i].id==id then
            return i
        end
    end
    return 0
end

function FunctionBarrage:Find(id,array)
	array = array or self.barrages
	return array[self:FindIndex(id,array)]
end

function FunctionBarrage:GetPercent()
	local y = (self.transMainCamera.localEulerAngles - self.goMesh.transform.localEulerAngles).y - 180
	-- print("euler y",y)
	y = (y<0) and 360+y or y
	return (math.abs(y))/360
end