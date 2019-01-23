autoImport("UIModelCell");
autoImport("SceneEmojiCell")
UIMultiModel = class("UIMultiModel", UIModelCell)

-- 多模型展示相机默认参数
UIMultiModel.CameraConfig=
{
	Pvp={
		position = Vector3(-1.8, 1.6, 5.47),
		rotation = Quaternion.Euler(8, 160, -0.8000183),
		fieldOfView = 60,
		ClipPlanes={0.3,10},
	},
	Pet={
		position = Vector3(-2.86, 6.11, 6.46),
		rotation = Quaternion.Euler(8, 160, -0.763366),
		fieldOfView = 67,
		ClipPlanes={0.3,13.68},
	}
}

--refactory
local cellData = {};
local tempVector3 = LuaVector3.zero
local InnerSingleModel = class("InnerSingleModel")

function InnerSingleModel:ctor()
end

function InnerSingleModel:CancelDelay()
	self.delayCall = nil
	self.delayCallArg = nil
	self.delayTimeFlag = nil
end

function InnerSingleModel:SetIndex( index ,follow)
	self.index = index
	self.follow = follow
end

function InnerSingleModel:Redress(parts)
	if(parts)then
		self.model:Redress(parts)
	end
end

function InnerSingleModel:SetParent(obj,flag)
	if(self.model)then
		self.model:SetParent(obj.transform,flag)
		self.model:SetLayer(obj.layer)
	end
end

function InnerSingleModel:DoConstruct(data)
	self.model = Asset_Role.Create(data[1]);
end

function InnerSingleModel:DoDeconstruct()
	self:CancelDelay()
	self.model:Destroy()
	self.model=nil
	self:_DestroyEmoji()
end

function InnerSingleModel:_DestroyEmoji()
	if(self.emoji) then
		self.emoji:Destroy()
		self.emoji = nil
		if(self.follow) then
			Game.RoleFollowManager:UnregisterFollow(self.follow.transform)
		end
	end
end

--delay seconds
function InnerSingleModel:DelayCall(delay,delayCall,delayCallArg)
	self:CancelDelay()
	self.delayCall = delayCall
	self.delayCallArg = delayCallArg
	self.delayTimeFlag = Time.unscaledTime + delay
end

function InnerSingleModel:Update()
	if(self.delayTimeFlag) then
		if(Time.unscaledTime>=self.delayTimeFlag) then
			if(self.delayCall~=nil) then
				self.delayCall(self.delayCallArg)
			end
			self:CancelDelay()
		end
	end
end

local oneVec = Vector3.one*3
local tempOffset = LuaGeometry.Const_V3_zero
function InnerSingleModel:PlayEmoji(emoji,rotation)
	self:_DestroyEmoji()

	if(self.follow) then

		tempVector3:Set(0,0,0) 
		Game.RoleFollowManager:RegisterFollow(
			self.follow.transform, 
			self.model.complete,
			tempVector3, 
			tempOffset,
			RoleDefines_EP.Top, 
			nil, 
			nil)
		local path = ResourcePathHelper.Emoji(emoji)

		TableUtility.ArrayClear(cellData)
		cellData[1] = self.follow;
		cellData[2] = path;
		cellData[3] = 2;
		cellData[4] = "animation";
		cellData[5] = 1;
		cellData[6] = InnerSingleModel._DestroyEmoji;
		cellData[7] = self;
		self.emoji = SceneEmojiCell.CreateAsArray(cellData)

		self.emoji.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero;
		self.emoji.gameObject.transform.localRotation = rotation or LuaGeometry.Const_Qua_identity;
		self.emoji.gameObject.transform.localScale=oneVec
		return 
	end
end

function InnerSingleModel:PlayAction( actionName,loop )
	if(not actionName or ""==actionName)then return end
	if(loop) then
		local params = Asset_Role.GetPlayActionParams(actionName)
		params[5] = true
		self.model:PlayAction(params)
	else
		self.model:PlayAction_Simple(actionName)
	end
end

function InnerSingleModel:SetPosition(pos)
	if(pos)then
		self.model:SetPosition(pos)
	end
end

function InnerSingleModel:SetRotation(rotation)
	if(rotation)then
		self.model:SetRotation(rotation)
	end
end

function InnerSingleModel:SetScale(scale)
	if(scale)then
		self.model:SetScale(scale)
	end
end

local cellData = {};


function UIMultiModel:ctor(go)
	UIMultiModel.super.ctor(self,go)
	self.modelmaps = {}
	self.singleModelPool = {}
	for i=1,5 do
		self.singleModelPool[#self.singleModelPool+1] = InnerSingleModel.new()
	end
end

function UIMultiModel:GetSingleFromPool()
	if(#self.singleModelPool>0) then
		return table.remove(self.singleModelPool,1)
	end
end

function UIMultiModel:AddSingleToPool(singleModel)
	singleModel:DoDeconstruct()
	self.singleModelPool[#self.singleModelPool + 1] = singleModel
end

function UIMultiModel:Init()
	self.camera = self:FindGO("Camera"):GetComponent(Camera);
	self.container = self:FindGO("ModelContainer");
	self.dynamicMeshRenderer = self:FindGO("dynamic_Bg"):GetComponent(MeshRenderer)
	self.staticMeshRender=self:FindGO("static_Bg"):GetComponent(MeshRenderer)
	self.emoji_Root=self:FindGO("Emoji_Root")
	self.follows = {}
	for i=1,3 do
		local follow = self:FindGO("Follow_"..tostring(i))
		follow.transform:SetParent(self.emoji_Root.transform, false);
		follow.layer = self.container.layer;
		self.follows[#self.follows+1]=follow
	end
end

function UIMultiModel:ChangeMeshRendererMat(name,uiTexture)
	self:Show(self.dynamicMeshRenderer)
	self:Hide(self.staticMeshRender)
	self.gameObject:SetActive(true)
	self.container:SetActive(true)
	self.super.SetTexture(self,uiTexture);
	if(self.dynamicMeshRenderer)then
		local materials1 = self.dynamicMeshRenderer.materials
		if(#materials1>0)then
			self.material = materials1[1]
			if(self.material)then
				PictureManager.Instance:SetPetRenderTexture(name,self.material)
			end
		end
	end
end

function UIMultiModel:SetMeshRendererColor(color)
	if self.dynamicMeshRenderer then
		local materials = self.dynamicMeshRenderer.materials
		if #materials > 0 then
			self.material = materials[1]
			if self.material then
				self.material:SetColor("_TintColor", color)
			end
		end
	end
end

function UIMultiModel:SetRenderTexPath(index)
	self.renderTexRId="GUI/pic/Model/UIModelTexture1"
end

function UIMultiModel:ShowTexture()
	self.super.SetTexture(self,uiTexture);
	self.gameObject:SetActive(true);
	self.container:SetActive(true);
end

function UIMultiModel:Reset()
	self.super.Reset(self);
	self.container:SetActive(false);
end

function UIMultiModel:ResetModel()
	--refactory
	self:RemoveModels()
	--refactory
	PictureManager.Instance:UnloadPetTexture("",self.material)
end

--refactory

function UIMultiModel:ChangeCameraConfig(params)
	self:_SetCameraConfig(params)
	if(self.camera)then
		self.camera.nearClipPlane=params.ClipPlanes[1]
		self.camera.farClipPlane=params.ClipPlanes[2]
	end
end

function UIMultiModel:Update()
	for k,v in pairs(self.modelmaps) do
		v:Update()
	end
end

function UIMultiModel:AllPlayEffectOn(effect,ep)
	for k,v in pairs(self.modelmaps) do
		if(v.model)then
			v.model:PlayEffectOneShotOn(effect,ep)
		end
	end
end

function UIMultiModel:PlayAction(index,actionName,loop)
	local smodel = self:_GetSingleModelByIndex(index)
	if(smodel) then
		smodel:PlayAction(actionName,loop)
	end
end

function UIMultiModel:PlayEmoji(index,emoji,rotation)
	local smodel = self:_GetSingleModelByIndex(index)
	if(smodel) then
		smodel:PlayEmoji(emoji,rotation)
	end
end

function UIMultiModel:PlayRandomEmoji(index,emojiArray,rotation,durationRange)
	local smodel = self:_GetSingleModelByIndex(index)
	if(smodel) then
		if(emojiArray and #emojiArray>1)then
			local emoji = emojiArray[math.random(1,#emojiArray)]
			emoji = Table_Expression[emoji] and Table_Expression[emoji].NameEn or "Emoji_heart"
			smodel:PlayEmoji(emoji,rotation)
			if(durationRange and #durationRange>1) then
				local duration = math.random(durationRange[1],durationRange[2])
				smodel:DelayCall(duration,function ()
					self:PlayRandomEmoji(index,emojiArray,rotation,durationRange)
				end)
			end
		end
	end
end

function UIMultiModel:_GetSingleModelByIndex(index)
	return self.modelmaps[index]
end

function UIMultiModel:RemoveModel(index)
	local smodel = self:_GetSingleModelByIndex(index)
	if(smodel) then
		self.modelmaps[index] = nil
		self:AddSingleToPool(smodel)
	end
end

function UIMultiModel:AddModel(index,args)
	local smodel = self:_GetSingleModelByIndex(index)
	if(smodel==nil) then
		smodel = self:_AddModel(index,args)
	end
	return smodel
end

function UIMultiModel:_AddModel(index,args)
	local smodel = self:_GetSingleModelByIndex(index)
	local model = self:GetSingleFromPool()
	model:SetIndex(index,self.follows[index])
	model:DoConstruct(args)
	model:SetParent(self.container,false)
	self.modelmaps[index] = model
	return model
end

function UIMultiModel:Redress(index,parts)
	local smodel = self:_GetSingleModelByIndex(index)
	if(smodel)then
		smodel:Redress(parts)
	end
	return smodel
end

local cameraTrans
function UIMultiModel:SetModels(index,args)
	if(args[10])then
		self:Show(self.dynamicMeshRenderer)
		self:Hide(self.staticMeshRender)
		cameraTrans=UIMultiModel.CameraConfig.Pet
	else
		self:Hide(self.dynamicMeshRenderer)
		self:Show(self.staticMeshRender)
		cameraTrans=UIMultiModel.CameraConfig.Pvp
	end
	self.super.SetTexture(self,args[2])
	self.gameObject:SetActive(true)
	self.container:SetActive(true)
	local hasModel=self:_GetSingleModelByIndex(index)
	if(not args[1])then
		self:RemoveModel(index)
	else
		local model = {}
		if(hasModel and args)then
			model = self:Redress(index,args[1])
		else
			model = self:AddModel(index,args)
		end
		model:SetPosition(args[3])
		model:SetRotation(args[4])
		model:SetScale(args[5])
		if(args[6])then
			model:PlayAction(args[6].name,args[6].loop)
		end
		self:PlayRandomEmoji(index,args[7],args[8],args[9])
	end
	self:ChangeCameraConfig(cameraTrans)
	return model
end

function UIMultiModel:RemoveModels()
	for k,v in pairs(self.modelmaps) do
		self.modelmaps[k] = nil
		self:AddSingleToPool(v)
	end
end

--refactory






