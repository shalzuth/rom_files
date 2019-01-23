MidMsg = class("MidMsg", CoreView)
MidMsg.resID = ResourcePathHelper.UICell("CountDownMsg")

local tempV3 = LuaVector3();

function MidMsg:ctor(parent, resID)
	if(resID)then
		self.resID = resID;
	end

	self.gameObject = self:CreateObj(parent)
	self:Init();
end

function MidMsg:CreateObj(parent)
	return Game.AssetManager_UI:CreateAsset(MidMsg.resID, parent);
end

function MidMsg:Init()
	self.contentlabel = self:FindComponent("Msg", UIRichLabel);
end

function MidMsg:SetData(data)
	self.contentlabel.text = data.text;
end

function MidMsg:SetLocalPos(x, y, z)
	tempV3:Set(x, y, z);
	self.gameObject.transform.localPosition = tempV3;
end

function MidMsg:SetExitCall(callBack, callBackParam)
	self.exitCall = callBack;
	self.exitCallParam = callBackParam;
end

function MidMsg:Exit()
	if(self.exitCall)then
		self.exitCall(self.exitCallParam, self);
	end
	if(not self:ObjIsNil(self.gameObject))then
		GameObject.DestroyImmediate(self.gameObject);
	end
end