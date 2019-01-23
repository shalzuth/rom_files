SceneEmojiCell = reusableClass("SceneEmojiCell");

SceneEmojiCell.PoolSize = 50

function SceneEmojiCell:Active(b)
	if(not Slua.IsNull(self.gameObject))then
		self.gameObject:SetActive(b);
	end
end

-- data (resID, animationName, endCall, depth, loopCount)
function SceneEmojiCell:PlayEmoji( animationName, loopCount, endCall, endCallArgs )
	if(Slua.IsNull(self.anim))then
		return;
	end

	self.anim = self.gameObject:GetComponent(SkeletonAnimation);
	self.anim.AnimationName = animationName;
	self.anim:Reset();
	self.anim.loop = false;

	loopCount = loopCount or 1;

	if(not self.playFunc)then
		self.playFunc =  function ()
			loopCount = loopCount - 1;
			if(loopCount > 0)then
				self:PlayEmoji( animationName, loopCount, endCall, endCallArgs );
			else
				if nil ~= endCall then
					endCall( endCallArgs );
				end
			end
		end
	end

	SpineLuaHelper.PlayAnim(self.anim, animationName, self.playFunc);
end

-- override begin
function SceneEmojiCell:DoConstruct(asArray, args)
	local parent = args[1];
	if(not LuaGameObject.ObjectIsNull(parent))then

		self.resPath = args[2];
		self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(self.resPath, parent.transform);
		self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero;
		self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity;
		self.gameObject.transform.localScale = LuaGeometry.Const_V3_one;
		UIUtil.ChangeLayer(self.gameObject, parent.gameObject.layer)

		self.anim = self.gameObject:GetComponent(SkeletonAnimation);

		local depth = args[3];
		if(type(depth) == 'number')then
			local uispine = self.gameObject:GetComponent(UISpine);
			if(uispine)then
				uispine.depth = depth;
			end
		end

		self:PlayEmoji( args[4], args[5], args[6], args[7] );
	end
end

function SceneEmojiCell:DoDeconstruct(asArray)
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		Game.GOLuaPoolManager:AddToSceneUIPool(self.resPath, self.gameObject);
	end
	self.playFunc = nil;
	self.gameObject = nil;
	self.anim = nil;
	self.resPath = nil;
end
-- override end


