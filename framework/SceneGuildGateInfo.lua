SceneGuildGateInfo = reusableClass("SceneGuildGateInfo")

SceneGuildGateInfo.PoolSize = 50

SceneGuildGateInfo.ResID = ResourcePathHelper.UICell("SceneGuildGateInfo")

function SceneGuildGateInfo:Init()
	self.level = GameObjectUtil.Instance:DeepFind(self.gameObject, "Level"):GetComponent(UILabel);
	self.bossMap = {};
	for i=1,5 do
		local bossSymbol = GameObjectUtil.Instance:DeepFind(self.gameObject, "BossSymbol"..i);
		self.bossMap[i] = GameObjectUtil.Instance:DeepFind(bossSymbol, "Finish");
	end
	self.teamSymbol = GameObjectUtil.Instance:DeepFind(self.gameObject, "TeamSymbol");
	self.bg = GameObjectUtil.Instance:DeepFind(self.gameObject, "Bg"):GetComponent(UISprite);
end

function SceneGuildGateInfo:UpdateInfo( level, killedbossnum ,haveteamer)
	if(level ~= nil)then
		self.level.text = "Lv." .. tostring(level);
	end

	for i=1,#self.bossMap do
		self.bossMap[i]:SetActive(i<=killedbossnum);
	end
	if(haveteamer)then
		self.teamSymbol:SetActive(true);
		self.bg.width = 286
	else
		self.teamSymbol:SetActive(false);
		self.bg.width = 246
	end
end

-- override begin
-- args { gameObject, text icon clickFunc }
function SceneGuildGateInfo:DoConstruct(asArray, args)
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
		self.gameObject = nil;
	end

	local parent = args[1];
	if(not Slua.IsNull(parent))then
		self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(self.ResID, parent.transform);
		self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero;
		self:Init();
		
		self:UpdateInfo(args[2], args[3], args[4]);
	end
end

function SceneGuildGateInfo:DoDeconstruct(asArray)
	if(not Slua.IsNull(self.gameObject))then
		Game.GOLuaPoolManager:AddToSceneUIPool(self.ResID, self.gameObject);
	end
	self.gameObject = nil;

end
-- override end