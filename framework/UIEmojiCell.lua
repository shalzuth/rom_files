local BaseCell = autoImport("BaseCell") 
UIEmojiCell = class("UIEmojiCell", BaseCell)

UIEmojiType = {
	Action = 1,
	Emoji = 2,
}

function UIEmojiCell:Init()
	self.actionObj = self:FindGO("Action");
	self.actionSymbol = self:FindComponent("Symbol", UISprite);
	self:AddCellClickEvent();
end

function UIEmojiCell:SetData(data)
	if(not data)then
		return;
	end

	self.id = data.id;
	self.type = data.type;
	self.name = data.name;

	self:UnloadEmoji();
	if(data.type == UIEmojiType.Action)then
		self.actionObj:SetActive(true)
		self:SetAction(data.name);
	elseif(data.type == UIEmojiType.Emoji)then
		self.actionObj:SetActive(false)
		self:LoadEmoji(data.name);
	end
end

local tempV3 = LuaVector3();
function UIEmojiCell:LoadEmoji(name)
	local resID = ResourcePathHelper.Emoji( name );
	if(resID == self.resID and not Slua.IsNull(self.emoji) )then
		return;
	end

	self.resID = resID;

	self.emoji = Game.AssetManager_UI:CreateSceneUIAsset(resID, self.gameObject);
	tempV3:Set(0,0,0);
	self.emoji.transform.localPosition = tempV3;
	UIUtil.ChangeLayer(self.emoji, self.gameObject.layer)
	tempV3:Set(1,1,1);
	self.emoji.transform.localScale = tempV3;
	self.emoji.transform.localRotation = LuaQuaternion.identity;
	self.emoji.gameObject:SetActive(true);
	self.emoji.name = name;

	local anim = self.emoji:GetComponent(SkeletonAnimation);
	anim.AnimationName = "ui_animation";
	anim:Reset();
	anim.loop = true;

	SpineLuaHelper.PlayAnim(anim, "ui_animation", nil);

	local uispine = self.emoji:GetComponent(UISpine)
	uispine.depth = 10;
end

function UIEmojiCell:UnloadEmoji()
	if( self.resID and not Slua.IsNull(self.emoji) )then
		Game.GOLuaPoolManager:AddToSceneUIPool(self.resID, self.emoji);
	end
	self.resID = nil;
	self.emoji = nil;
end

function UIEmojiCell:SetAction( name )
	if(self.actionSymbol)then
		if(IconManager:SetActionIcon(name, self.actionSymbol))then
			self.actionSymbol:MakePixelPerfect();
		end
	end
end

function UIEmojiCell:OnRemove(depth)
	self:UnloadEmoji();
end

local tempColor = LuaColor(1,1,1,1);
function UIEmojiCell:Forbid(state)
	self.forbidState = state;

	if(state == 1)then
		if(self.type == UIEmojiType.Action)then
			tempColor:Set(1/255,2/255,3/255);
			self:SetTextureColor(self.actionObj, tempColor, true)
		end
	elseif(state == 2)then
		if(self.type == UIEmojiType.Emoji)then

		end
	else
		tempColor:Set(1,1,1,1);
		self:SetTextureColor(self.actionObj, tempColor, true)
	end
end





