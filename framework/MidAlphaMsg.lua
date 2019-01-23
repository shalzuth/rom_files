MidAlphaMsg = class("MidAlphaMsg", CoreView)

MidAlphaMsg.ResID = ResourcePathHelper.UICell("MidAlphaMsg")

local pos = LuaVector3();
function MidAlphaMsg:ctor(parent)
	self.gameObject = self:CreateObj(parent)
	pos:Set(0,135,0);
	self.gameObject.transform.localPosition = pos;

	self:Init();
end

function MidAlphaMsg:CreateObj(parent)
	return Game.AssetManager_UI:CreateAsset(MidAlphaMsg.ResID, parent);
end

function MidAlphaMsg:Init()
	self.bg = self.gameObject:GetComponent(UISprite);
	self.label = self:FindComponent("Label", UILabel);
end

function MidAlphaMsg:SetData(data)
	self.label.text = data;

	self:SetDelayDestroy(1, 2, 0.5);
end

function MidAlphaMsg:SetExitCall(exitCall, exitCallParam)
	self.exitCall = exitCall;
	self.exitCallParam = exitCallParam;
end

function MidAlphaMsg:Exit()
	self:CancelTween()
	if(not Slua.IsNull(self.gameObject))then
		Game.GOLuaPoolManager:AddToSceneUIPool(MidAlphaMsg.ResID, self.gameObject)
	end
	self.gameObject = nil;

	if(self.exitCall)then
		self.exitCall(self.exitCallParam);
	end
end


-- anim begin
function MidAlphaMsg:SetDelayDestroy(fadeInTime, stayTime, fadeOutTime)
	if(self.gameObject)then
		self.bg.alpha = 0;

		self.fadeInTime = fadeInTime or 0;
		self.stayTime = stayTime or 3;
		self.fadeOutTime = fadeOutTime or 0;
		self:_FadeIn()
	end
end

function MidAlphaMsg:CancelTween()
	if(self.lt) then
		self.lt:cancel()
		self.lt = nil
	end
end

function MidAlphaMsg:_FadeIn()
	self:CancelTween()
	if(not Slua.IsNull(self.gameObject)) then
		self.lt = LeanTween.value(self.gameObject,MidAlphaMsg._AlphaTo,0,1,self.fadeInTime)
		self.lt.onUpdateParam = self
		self.lt.onCompleteObject = MidAlphaMsg._FadeOut
		self.lt.onCompleteParam = self
	end
end

function MidAlphaMsg._AlphaTo(alpha, self)
	self.bg.alpha = alpha;
end

function MidAlphaMsg:_FadeOut()
	self:CancelTween()
	if(not Slua.IsNull(self.gameObject)) then
		self.lt = LeanTween.value(self.gameObject,MidAlphaMsg._AlphaTo,1,0,self.fadeOutTime)
		self.lt.delay = self.stayTime
		self.lt.onUpdateParam = self
		self.lt.onCompleteObject = MidAlphaMsg._FadeEnd
		self.lt.onCompleteParam = self
	end
end

function MidAlphaMsg:_FadeEnd()
	self:Exit();
end
-- anim end
