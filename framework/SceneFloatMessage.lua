SceneFloatMessage = reusableClass("SceneFloatMessage");

SceneFloatMessage.PoolSize = 20;

SceneFloatMessageType = {
	Text = "SceneFloatMessageType_Text",
	Exp = "SceneFloatMessageType_Exp",
	Item = "SceneFloatMessageType_Item",
}

SceneFloatMessage.LabelColor = {
	Text = {LuaColor.New(188/255,188/255,188/255), LuaColor.New(30/255,30/255,30/255)},
	Exp ={LuaColor.New(220/255,162/255,123/255), LuaColor.New(61/255,39/255,25/255)},
	Item = {
		{LuaColor.New(188/255,188/255,188/255), LuaColor.New(18/255,27/255,29/255)},
		{LuaColor.New(101/255,253/255,220/255), LuaColor.New(27/255,53/255,22/255)},
		{LuaColor.New(83/255,197/255,255/255), LuaColor.New(27/255,25/255,54/255)},
		{LuaColor.New(201/255,84/255,255/255), LuaColor.New(4/255,21/255,54/255)},
		{LuaColor.New(255/255,185/255,49/255), LuaColor.New(65/255,39/255,6/255)},
	},
}

SceneFloatMessage.ResID = ResourcePathHelper.UICell("SceneFloatMessage")

local tempRot = LuaQuaternion.Euler(0, 0, 0, 0)
local tempV3 = LuaVector3();
function SceneFloatMessage:CreatePerfab(parent)
	local obj = Game.AssetManager_UI:CreateSceneUIAsset(SceneFloatMessage.ResID, parent);
	if(obj)then
		obj:GetComponent(Animator):Play ("SceneFloatMessage", -1, 0);
		obj.transform.localPosition = LuaGeometry.Const_V3_zero;

		local randomZ = math.random(-10, 10);
		tempV3:Set(0, 0, randomZ);
		tempRot.eulerAngles = tempV3;
		obj.transform.localRotation = tempRot;
		return obj;
	end
end

function SceneFloatMessage:RefreshInfo()
	if(Slua.IsNull(self.msglabel))then
		return;
	end

	local dtype = self.data_dtype;
	local color1, color2;
	if(dtype and dtype == SceneFloatMessageType.Exp)then
		color1 = SceneFloatMessage.LabelColor.Exp[1];
		color2 = SceneFloatMessage.LabelColor.Exp[2];
	else
		color1 = SceneFloatMessage.LabelColor.Text[1];
		color2 = SceneFloatMessage.LabelColor.Text[2];
	end
	self.msglabel.gradientBottom = color1;
	self.msglabel.effectColor = color2;

	local msg = self.data_msg;
	local param = self.data_param;
	local msgText = msg;
	if(type(param) == "table")then
		msgText = MsgParserProxy.Instance:TryParse(msgText, unpack(param));
	end
	self.spriteLabel:SetText(msgText, false)
end

function SceneFloatMessage:Active(b)
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		self.gameObject:SetActive(b);
	end
end

function SceneFloatMessage:RemoveLeanTween()
	if(self.lt)then
		self.lt:cancel();
	end
	self.lt = nil;
end

-- override begin
-- param[1] 
-- param[2] type
-- param[3] msg
-- param[4] param
function SceneFloatMessage:DoConstruct(asArray, param)
	self.data_dtype = param[2];
	self.data_msg = param[3];
	self.data_param = param[4];

	self.gameObject = self:CreatePerfab(param[1]);

	if(not Slua.IsNull(self.gameObject))then
		self.msglabel = self.gameObject:GetComponentInChildren(UILabel);
		self.spriteLabel = SpriteLabel.new(self.msglabel, 500, 30, 30);
	end

	self:RefreshInfo();

	self:RemoveLeanTween();
	self.lt = LeanTween.delayedCall(1.5, function ()
		self:Destroy();
	end);
end

function SceneFloatMessage:DoDeconstruct(asArray)
	if(not Slua.IsNull(self.gameObject))then
		if(self.spriteLabel) then
			self.spriteLabel:Destroy();
		end
		Game.GOLuaPoolManager:AddToSceneUIPool(SceneFloatMessage.ResID, self.gameObject);
	end
	self.gameObject = nil;
	self.spriteLabel = nil;

	self:RemoveLeanTween();

	self.data_dtype = nil;
	self.data_msg = nil;
	self.data_param = nil;
end
-- override end
