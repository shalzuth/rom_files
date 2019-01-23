ShowyMsg = class("ShowyMsg", CoreView)

ShowyMsg.resID = ResourcePathHelper.UICell("CountDownMsg")

function ShowyMsg:ctor(parent, resID)
	if(resID)then
		self.resID = resID;
	end

	self.gameObject = self:CreateObj(parent)
	self.gameObject.transform.localPosition = Vector3(0,20);
	
	self.widget = self.gameObject:GetComponent(UIWidget);

	self:Init();
end

function ShowyMsg:CreateObj(parent)
	return Game.AssetManager_UI:CreateAsset(self.resID, parent.transform);
end

function ShowyMsg:Init()
	self.contentlabel = self:FindComponent("Msg", UIRichLabel);
	self.bg = self:FindComponent("Bg", UISprite);
end

function ShowyMsg:SetData(data)
	self.contentlabel.text = data.text;
	self.bg.height = self.contentlabel.height + 34
end

function ShowyMsg:Enter()
	self:PlayMsgAnim();
end

function ShowyMsg:PlayMsgAnim()
	self.widget.alpha = 0;
	LeanTween.value(self.gameObject, function (v)
		self.widget.alpha = v;
	end, 0, 1, 1):setOnComplete(function ()
		LeanTween.delayedCall(self.gameObject, 2, function()
			LeanTween.value(self.gameObject, function (v)
				self.widget.alpha = v;
			end, 1, 0, 1):setOnComplete(function ()
				self:Exit();
			end);
		end);
	end);
end

function ShowyMsg:Exit()
	if(self.exitCall)then
		self.exitCall();
		self.exitCall = nil;
	end

	if(not self:ObjIsNil(self.gameObject))then
		LeanTween.cancel(self.gameObject);
		GameObject.Destroy(self.gameObject);
	end
end

function ShowyMsg:SetExitCall(func)
	self.exitCall = func;
end

