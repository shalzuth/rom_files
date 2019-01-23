CreateGuildPopUp = class("CreateGuildPopUp", ContainerView)

CreateGuildPopUp.ViewType = UIViewType.PopUpLayer

function CreateGuildPopUp:Init()
	self:InitUI();
	self:MapViewEvent();
end

function CreateGuildPopUp:InitUI()
	self.nameInput = self:FindComponent("Input", UIInput);
	
	local _MaskWordType = FunctionMaskWord.MaskWordType
	self.filterType = _MaskWordType.SpecialSymbol | _MaskWordType.Chat | _MaskWordType.SpecialName
	UIUtil.LimitInputCharacter(self.nameInput, 8);

	self:AddButtonEvent("ConfirmButton", function (go)
		self:CreateGuild();
	end);
	
	--todo xde fix ui
	local cbtn = self:FindGO("ConfirmButton")
	cbtn:GetComponent(UISprite).width = 216
	local label = self:FindGO("Label",cbtn):GetComponent(UILabel)
	label.fontSize = 24

	local clbtn = self:FindGO("CloseButton")
	clbtn:GetComponent(UISprite).width = 216
	local label = self:FindGO("Label",clbtn):GetComponent(UILabel)
	label.fontSize = 24
end

function CreateGuildPopUp:CreateGuild()
	-- 人物等级满足20
	local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL);
	if(mylv < GameConfig.Guild.createbaselv)then
		MsgManager.ShowMsgByIDTable(2600);
		return;
	end
	-- 材料或者金币不足
	local needItems = GameConfig.Guild.createitem;
	for i=1,#needItems do
		local needItem = needItems[i];
		if(needItem[1] and needItem[2])then
			local sIData = Table_Item[needItem[1]];
			local tempText,hasNum = "";
			if(needItem[1] == 100)then
				hasNum = MyselfProxy.Instance:GetROB()
			elseif(needItem[1] == 105)then
				hasNum = MyselfProxy.Instance:GetGold()
			elseif(needItem[1] == 110)then
				hasNum = MyselfProxy.Instance:GetGarden()
			else
				hasNum = BagProxy.Instance:GetItemNumByStaticID(needItem[1]);
				if(hasNum<needItem[2])then
					MsgManager.ShowMsgByIDTable(2601);
					return;
				end
			end
			if(hasNum<needItem[2])then
				MsgManager.ShowMsgByIDTable(2602);
				return;
			end
		end
	end
	local name = self.nameInput.value;
	-- 名字不能为空
	if(name == "")then
		MsgManager.ShowMsgByIDTable(2603);
		return;
	end
	
	if(not FunctionMaskWord.Me():CheckMaskWord(name, self.filterType))then
		ServiceGuildCmdProxy.Instance:CallCreateGuildGuildCmd(name);
	else
		MsgManager.ShowMsgByIDTable(2604);
	end
end

function CreateGuildPopUp:MapViewEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.CloseSelf);
end