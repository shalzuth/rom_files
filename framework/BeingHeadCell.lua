autoImport("PlayerFaceCell");
BeingHeadCell = class("BeingHeadCell", PlayerFaceCell);

function BeingHeadCell:Init()
	BeingHeadCell.super.Init(self);
	self.headData = HeadImageData.new();

	self.bgSp = self.gameObject:GetComponent(UIWidget);

	self:SetData(nil);
end

function BeingHeadCell:SetData(data)
	if(data)then
		self.gameObject:SetActive(true);

		self.headData:TransByBeingInfoData(data);
		BeingHeadCell.super.SetData(self, self.headData);

		self.level.text = self.headData.level;

		self.data = data;

		self:SetIconActive(data:IsAlive());

		self:UpdateBeingHp();
	else
		self.gameObject:SetActive(false);
	end
end

function BeingHeadCell:UpdateBeingHp()
	if(self.data == nil)then
		return;
	end

	local hpPct = 1;

	if(self.data:IsAlive())then
		local nbeing = NScenePetProxy.Instance:Find(self.data.guid);
		if(nbeing)then
			local props = nbeing.data.props;
			if(props)then
				local hp = props.Hp:GetValue();
				local maxhp = props.MaxHp:GetValue();
				hpPct = hp/maxhp;
			end
		end
	else
		hpPct = 0;
	end
	
	self:UpdateHp(hpPct);

	if(hpPct <= 0)then
		self:SetIconActive(false, false);
	else
		self:SetIconActive(true, true);
	end
end
