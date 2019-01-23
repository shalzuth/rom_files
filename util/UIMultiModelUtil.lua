autoImport("UIMultiModel");
UIMultiModelUtil = class("UIMultiModelUtil")

UIMultiModelUtil.Instance = nil;

function UIMultiModelUtil:ctor()
	self:Init();
	UIMultiModelUtil.Instance = self;
end

function UIMultiModelUtil:Update()
	self.multiModel:Update()
end

function UIMultiModelUtil:FindGO(name, parent)
	parent = parent or self.gameObject;
	return parent ~= nil and GameObjectUtil.Instance:DeepFind(parent, name) or nil;
end

function UIMultiModelUtil:Init()
	local path = "GUI/pic/Model/UIMultiModelCamera";
	self.gameObject = Game.AssetManager_UI:CreateAsset(path);
	GameObject.DontDestroyOnLoad(self.gameObject);
	self.multiModel = UIMultiModel.new(self.gameObject);
	TimeTickManager.Me():CreateTick(0,500,self.Update,self)
end

function UIMultiModelUtil:Reset()
	if(nil~=self.multiModel)then
		self.multiModel:Reset();
	end
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end
	self.gameObject = nil;
end

function UIMultiModelUtil:SetModels(index,args)
	if(self.multiModel)then
		self.multiModel:SetModels(index,args)
	end
end

local defaultColor = LuaColor.white
function UIMultiModelUtil:RemoveModels()
	if(self.multiModel)then
		self.multiModel:RemoveModels()
		self:SetColor(defaultColor)
	end
end

function UIMultiModelUtil:bPetModelExistByIndex(index)
	local mulModel = self.multiModel
	if(mulModel and mulModel.modelmaps)then
		local mtype = type(mulModel.modelmaps[index])
		return mtype=='table'
	end
	return false
end

function UIMultiModelUtil:PlayEffect(effect,ep)
	local mulModel = self.multiModel
	if(mulModel)then
		mulModel:AllPlayEffectOn(effect,ep)
	end
end

function UIMultiModelUtil:PlayAction(modelIndex,actionName,loop)
	if(nil~=self.multiModel)then
		self.multiModel:PlayAction(modelIndex,actionName,loop);
	end
end

function UIMultiModelUtil:ChangeMat(textureName,uiTexture)
	self.multiModel:ChangeMeshRendererMat(textureName,uiTexture)
end

function UIMultiModelUtil:SetColor(color)
	self.multiModel:SetMeshRendererColor(color)
end