SceneRoleTopSymbol = class("SceneRoleTopSymbol" , QueueBaseCell)

SceneRoleTopSymbol.Type = {
	TaskAccess,
	TaskFinish,
}

SceneRoleTopSymbol.rid = ResourcePathHelper.UICell("SceneRoleTopSymbol")

function SceneRoleTopSymbol:ctor(parent)
	self.parent = parent;

	self.offset = Vector3(0,55,0);
end

function SceneRoleTopSymbol:Enter()
	self:DestroySelf();
	self.gameObject = self:CreateObj(SceneRoleTopSymbol.rid, self.parent);
	self.gameObject.transform.localPosition = Vector3(0,10);
	self.symbol = self:FindComponent("Symbol", UISprite);
end

function SceneRoleTopSymbol:SetData(data)
	if(self.symbol)then
		if(data.symbol == 1)then
			self.symbol.spriteName = "62";
		elseif(data.symbol == 2)then
			self.symbol.spriteName = "63";
		else
			self.symbol.spriteName = data;
		end
		self.symbol:MakePixelPerfect();
	end
end

function SceneRoleTopSymbol:Exit()
	self:DestroySelf();
	SceneRoleTopSymbol.super.Exit(self);
end

function SceneRoleTopSymbol:DestroySelf()
	if(not self:ObjIsNil(self.gameObject))then
		GameObject.DestroyImmediate(self.gameObject);
		self.gameObject = nil;
	end
end
