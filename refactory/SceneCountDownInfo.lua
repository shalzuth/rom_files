SceneCountDownInfo = reusableClass("SceneCountDownInfo");

SceneCountDownInfo.PoolSize = 10

local PATH_PFB = ResourcePathHelper.UICell("SceneCountDownInfo");

function SceneCountDownInfo:UpdateInfo()
	if(self.label == nil)then
		return;
	end

	if(self.text == nil or self.endStamp == nil)then
		return;
	end

	self.delta = ServerTime.ServerDeltaSecondTime(self.endStamp * 1000);
	self.label.text = string.format( self.text, math.floor(self.delta) );
end

function SceneCountDownInfo:ReSetInfo(text, time)
	self.text = text;
	self.endStamp = time;
end

function SceneCountDownInfo:GetDelta()
	return self.delta;
end

function SceneCountDownInfo:DoConstruct(asArray, args)
	local parent = args[1];
	if(not LuaGameObject.ObjectIsNull(parent))then

		self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(PATH_PFB, parent.transform);
		self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero;
		self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity;
		self.gameObject.transform.localScale = LuaGeometry.Const_V3_one;

		self.label = GameObjectUtil.Instance:DeepFind(self.gameObject, "Label"):GetComponent(UILabel);

		UIUtil.ChangeLayer(self.gameObject, parent.gameObject.layer)

		self.text = args[2];
		self.endStamp = args[3];

		self:UpdateInfo();
	end
end

function SceneCountDownInfo:DoDeconstruct(asArray)
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject);
	end
	self.gameObject = nil;
	self.label = nil;
	self.endStamp = nil;
	self.delta = nil;
end