autoImport("PlayerFaceCell");
PetHeadCell = class("PetHeadCell", PlayerFaceCell);

function PetHeadCell:Init()
	PetHeadCell.super.Init(self);

	self.headData = HeadImageData.new();

	self.restTip = self:FindGO("RestTip");
	self.restTime = self:FindComponent("RestTime", UILabel);

	self:SetData(nil);
end

function PetHeadCell:SetData(data)
	if(data == nil)then
		self.gameObject:SetActive(false);
		return;
	end

	self.gameObject:SetActive(true);
	
	self.headData:TransByPetInfoData(data);
	PetHeadCell.super.SetData(self, self.headData);

	self.level.text = self.headData.level;
	
	self.data = data;
	
	self:UpdateRestTip(data.relivetime);

	self:UpdateHp();
end

function PetHeadCell:UpdateRestTip(resttime)
	if(type(self.data)~="table")then
		self.restTip:SetActive(false);
		self:RemoveRestTimeTick();
		return;
	end

	resttime = resttime or 0;
	local curtime = ServerTime.CurServerTime()/1000;
	local restSec = resttime - curtime;
	if(restSec > 0)then
		self.restTip:SetActive(true);

		if(not self.restTimeTick)then
			self.restTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRestTime, self)
		end
		self:SetIconActive(false);
		self.name.gameObject:SetActive(false);
	else
		self.restTip:SetActive(false);

		self:RemoveRestTimeTick();
	end
end

function PetHeadCell:UpdateRestTime()
	if(type(self.data)~="table")then
		self.restTip:SetActive(false);
		self:RemoveRestTimeTick();
		return;
	end
	
	local resttime = self.data and self.data.relivetime;
	resttime = resttime or 0;
	local restSec = resttime - ServerTime.CurServerTime()/1000;
	if(restSec > 0)then
		local min,sec = ClientTimeUtil.GetFormatSecTimeStr( restSec )
		self.restTime.text = string.format(ZhString.TMInfoCell_RestTip, min , sec)
	else
		self:RemoveRestTimeTick();
	end
end

function PetHeadCell:RemoveRestTimeTick()
	if(self.restTimeTick)then
		TimeTickManager.Me():ClearTick(self, 1)
		self.restTimeTick = nil;

		self.restTime.text = "";
	end
	if(self.headData and self.headData.offline~=true)then
		self:SetIconActive(true, true);
	else
		self:SetIconActive(false, false);
	end
	self.name.gameObject:SetActive(true);
end

function PetHeadCell:UpdateHp()
	if(self.data == nil)then
		return;
	end

	local npet = NScenePetProxy.Instance:Find(self.data.guid);
	if(npet)then
		local props = npet.data.props;
		if(props)then
			local hp = props.Hp:GetValue();
			local maxhp = props.MaxHp:GetValue();
			self.data.hp = hp/maxhp;
		end
	end

	PetHeadCell.super.UpdateHp(self, self.data.hp);
end