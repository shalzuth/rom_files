local BaseCell = autoImport("BaseCell");
RClickFuncCell = class("RClickFuncCell", BaseCell);

RClickFuncCell.RedTip = {
	ApplyList = SceneTip_pb.EREDSYS_TEAMAPPLY,
}

function RClickFuncCell:Init()
	self.bg = self.gameObject:GetComponent(UISprite);
	self.label = self:FindComponent("Label", UILabel);

	self.passEvent = true;

	self:SetEvent(self.gameObject, function ()
		if(self.passEvent)then
			self:PassEvent(MouseEvent.MouseClick, self);
		end
	end);
end

function RClickFuncCell:SetData(data)
	self.data = data;
	local key = data.key;


	if(not PlayerTipFuncConfig[key])then
		self.gameObject:SetActive(false);
		errorLog(string.format("%s Not Defined in FunctionPlayerTip", key));
		return;
	end

	self.label.text = data.otherName or PlayerTipFuncConfig[key].name;

	if(RClickFuncCell.RedTip[key] and not self.regist)then
		self.regist = true;
		RedTipProxy.Instance:RegisterUI(RClickFuncCell.RedTip[key], self.bg , 22);
	end

	self:SetState(data.state);
end

local tempColor = LuaColor.New(1,1,1,1);
function RClickFuncCell:SetState(state)
	if(state == nil or state == PlayerTipFuncState.Active)then
		self.bg.spriteName = "com_btn_1s";

		tempColor:Set(38/255, 62/255, 140/255, 1);
		self.label.effectColor = tempColor;

		tempColor:Set(1,1,1,1);
		self.bg.color = tempColor;

		self.passEvent = true;
	elseif(state == PlayerTipFuncState.Grey)then
		self.bg.spriteName = "com_btn_1s";

		tempColor:Set(177/255, 177/255, 177/255, 1);
		self.label.effectColor = tempColor;

		tempColor:Set(1/255, 2/255, 3/255, 1);
		self.bg.color = tempColor;

		self.passEvent = false;
	elseif(state == PlayerTipFuncState.Special)then
		self.bg.spriteName = "com_btn_2s";

		tempColor:Set(122/255, 62/255, 5/255, 1);
		self.label.effectColor = tempColor;

		tempColor:Set(1,1,1,1);
		self.bg.color = tempColor;

		self.passEvent = true;
	end
end

function RClickFuncCell:SetDisable()
	self:SetTextureGrey(self.gameObject);
	local boxCollider = self.gameObject:GetComponentInChildren(BoxCollider);
	boxCollider.enabled = false;
end

function RClickFuncCell:SetName(name)
	self.label.text = name;
end





















