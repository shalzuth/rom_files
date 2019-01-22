local BaseCell = autoImport("BaseCell");
TeamApplyCell = class("TeamApplyCell", BaseCell);

autoImport("PlayerFaceCell");

function TeamApplyCell:Init()
	local portrait = self:FindGO("HeadCell");
	self.portraitCell = PlayerFaceCell.new(portrait);
	self.portraitCell:AddEventListener(MouseEvent.MouseClick,function ()
		if(self.data)then
			local ptdata = PlayerTipData.new();
			ptdata:SetByTeamMemberData(self.data);
			local tipData = {
				playerData = ptdata,
			};
			local sp = portrait:GetComponent(UIWidget);
			local playerTip = FunctionPlayerTip.Me():GetPlayerTip(sp, NGUIUtil.AnchorSide.Right);
			playerTip:SetData(tipData);
			playerTip.clickcallback = function (funcData)
				if(funcData.key == "SendMessage")then
					self.eventType = "CloseUI";
					self:PassEvent(MouseEvent.MouseClick, self);
				end
			end
		end
	end,self)

	self.name = self:FindComponent("Name", UILabel);
	self.level = self:FindComponent("Level", UILabel);
	self.profession = self:FindComponent("Profession", UILabel);

	self:AddButtonEvent("AgreeButton", function (go)
		local applyData = self.data;
		if(applyData)then
			ServiceSessionTeamProxy.Instance:CallProcessTeamApply(SessionTeam_pb.ETEAMAPPLYTYPE_AGREE, applyData.id);
		end
	end);
end

function TeamApplyCell:SetData(data)
	self.data = data;
	if(data)then
		self.name.text = data.name;
		----[[ todo xde ?????????????????????
		self.name.text = AppendSpace2Str(data.name)
		--]]
		self.level.text = "Lv."..data.baselv;
		if(Table_Class[data.profession])then
			self.profession.text = Table_Class[data.profession].NameZh;
		end

		local headData = HeadImageData.new();
		headData:TransByTeamMemberData(data);
		self.portraitCell:SetData(headData);
	end
end