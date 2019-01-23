SceneDropNameCell = reusableClass("SceneDropNameCell");

SceneDropNameCell.PoolSize = 20;

SceneDropNameCell.ResID = ResourcePathHelper.UICell("SceneDropNameCell")

-- override begin
local offset = LuaVector3();
local Vector3One = LuaGeometry.Const_V3_one
local Qua_identity = LuaGeometry.Const_Qua_identity
function SceneDropNameCell:DoConstruct(asArray, item)
	local container = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.DropItemName);
	self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneDropNameCell.ResID, container);
	
	self.gameObject.transform.localRotation = Qua_identity;
	self.gameObject.transform.localScale = Vector3One;

	offset:Set(0, -0.17, 0);
	item:Client_RegisterFollow(self.gameObject.transform, offset);

	local namelab = GameObjectUtil.Instance:DeepFind(self.gameObject, "Name"):GetComponent(UILabel);
	local refinelv = item.refinelv;
	local sdata = item.staticData;
	if(sdata)then
		if(refinelv and refinelv>0)then
			namelab.text = string.format("%s+%s%s[-]", ItemQualityColor[sdata.Quality], refinelv, sdata.NameZh);
		else
			namelab.text = string.format("%s%s[-]", ItemQualityColor[sdata.Quality], sdata.NameZh);
		end
	end
end

function SceneDropNameCell:DoDeconstruct(asArray)
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		Game.TransformFollowManager:UnregisterFollow(self.gameObject.transform)
		Game.GOLuaPoolManager:AddToSceneUIPool(SceneDropNameCell.ResID, self.gameObject)
	end
	self.gameObject = nil;
end
-- override end
