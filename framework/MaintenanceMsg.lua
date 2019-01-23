MaintenanceMsg = class("MaintenanceMsg", CoreView)

MaintenanceMsg.ResID = ResourcePathHelper.UICell("MaintenanceMsg")

local tempV3 = LuaVector3();
function MaintenanceMsg:ctor(parent)

	self.gameObject = self:LoadPreferb("cell/MaintenanceMsg", parent.transform, true);

	tempV3:Set(0,20,0);
	self.gameObject.transform.localPosition = tempV3;

	self:Init();
end

function MaintenanceMsg:Init()
	self.title = self:FindComponent("Title", UILabel);
	self.text = self:FindComponent("Text", UILabel);
	self.remark = self:FindComponent("Remark", UILabel);
	self.texture = self:FindComponent("Texture", UITexture);

	self.button = self:FindGO("Button");
	self:AddClickEvent(self.button, function ( )
		self:RemoveTextureCache();
		if(self.confirmCall)then
			self.confirmCall();
		end
		self:Exit();
	end);

	self.buttonlab = self:FindComponent("Label", UILabel, self.button);
end

function MaintenanceMsg._LoadMaintenanceTexture(owner, asset, path)
	owner:SetMaintenanceTexture(asset);
end

function MaintenanceMsg:SetMaintenanceTexture(asset)
	if(not Slua.IsNull(asset))then
		self.texture.mainTexture = asset;
		self.texture:MakePixelPerfect();
	end
end

function MaintenanceMsg:SetData(data)
	if(data[1] and data[1]~="")then
		self.title.text = data[1];
	end
	if(data[2])then
		self:SetContext(data[2]);
	end
	if(data[3] and data[3]~="")then
		self.remark.text = data[3];
	end
	if(data[4] and data[4]~="")then
		self.buttonlab.text = data[4];
	end

	if(data[6])then
		self.confirmCall = data[6];
	end

	local texturePath = "";
	if(data[5] and data[5]~="")then
		texturePath = data[5];
	else
		texturePath = "GUI/pic/UI/bulletin_pic_01";
	end

	if( Slua.IsNull(self.texture.mainTexture) and (self.textureAssetRid and self.textureAssetRid == texturePath) )then
		return;
	end

	self:RemoveTextureCache();
	self.textureAssetRid = texturePath
	Game.AssetManager_UI:LoadAsset(
		self.textureAssetRid, 
		Texture, 
		MaintenanceMsg._LoadMaintenanceTexture, 
		self
	);
end

function MaintenanceMsg:SetContext( text )

	self.text.text = text;
	local beWrap, outText;
	beWrap, outText = self.text:Wrap(text, outText, self.text.height);

	self.text.width = 644;
	if(not beWrap)then
		self.text.overflowMethod = 3; --UILabel.Overflow.ResizeHeight;
		self.text.pivot = UIWidget.Pivot.TopLeft;

		tempV3:Set(-322, 164, 0);
		self.text.transform.localPosition = tempV3;
	else
		self.text.overflowMethod = 1; --UILabel.Overflow.ClampContent;
		self.text.pivot = UIWidget.Pivot.Left;

		self.text.height = 332;

		tempV3:Set(-322, 0, 0);
		self.text.transform.localPosition = tempV3;
	end

	self.text:ResizeCollider();
end

function MaintenanceMsg:SetExitCall(func)
	self.exitCall = func;
end

function MaintenanceMsg:RemoveTextureCache()
	if(self.textureAssetRid)then
		Game.AssetManager_UI:UnLoadAsset(self.textureAssetRid);
	end
	self.textureAssetRid = nil;
end

function MaintenanceMsg:Exit()
	self.confirmCall = nil

	self:RemoveTextureCache();

	if(not self:ObjIsNil(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end
	
	if(self.exitCall)then
		self.exitCall();
		self.exitCall = nil;
	end
end