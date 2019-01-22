autoImport("ItemCell");
BaseItemCell = class("BaseItemCell", ItemCell)

function BaseItemCell:Init()
	BaseItemCell.super.Init(self);

	self.cdCtrl = FunctionCDCommand.Me():GetCDProxy(BagCDRefresher)
	self:AddCellClickEvent();
end

function BaseItemCell:SetData(data)
	BaseItemCell.super.SetData(self, data);

	if(self.bebreaked)then
		self.bebreaked.gameObject:SetActive(false);
	end

	if(self.cdCtrl) then
		if(self:GetCD()>0)then
			self.cdCtrl:Add(self)
		else
			self.cdCtrl:Remove(self)
		end
	end
end

function BaseItemCell:GetCD()
	local data = self.data;

	if(data)then
		local equipInfo = data.equipInfo;
		if(equipInfo and equipInfo.breakendtime and equipInfo.breakendtime > 0)then
			return math.max(0, ServerTime.ServerDeltaSecondTime(equipInfo.breakendtime * 1000));
		end

		if(data.cdTime)then
			return data.cdTime;
		end
	end

	return 0;

end

function BaseItemCell:GetMaxCD()
	local data = self.data;

	if(data)then
		local equipInfo = data.equipInfo;
		if(equipInfo and equipInfo.breakduration)then
			return equipInfo.breakduration;
		end

		if(data:GetCdConfigTime())then
			return data:GetCdConfigTime();
		end
	end

	return 0;
end

function BaseItemCell:RefreshCD(f)
	local data = self.data;

	if(data) then
		-- ????????????CD
		local equipInfo = data.equipInfo;
		if(equipInfo and equipInfo.breakendtime and equipInfo.breakendtime > 0)then
			self.coldDown.fillAmount = f;

			local lefttime = ServerTime.ServerDeltaSecondTime(equipInfo.breakendtime * 1000);

			if(self.bebreaked)then
				self.bebreaked.gameObject:SetActive(lefttime > 0);
			end
			if(lefttime <= 0)then
				return true;
			end
			return false;
		end
		-- ????????????CD

		if(self.bebreaked)then
			self.bebreaked.gameObject:SetActive(false);
		end

		self.coldDown.fillAmount = f

		if(data.cdTime<=0) then
			return true
		end
	else

		if(self.bebreaked)then
			self.bebreaked.gameObject:SetActive(true);
		end

		return true
	end
end

function BaseItemCell:ClearCD()
	self.coldDown.fillAmount = 0
end
