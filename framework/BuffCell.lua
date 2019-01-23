local BaseCell = autoImport("BaseCell");
BuffCell = class("BuffCell", BaseCell)

BuffCellEvent = {
	BuffEnd = "BuffCellEvent_BuffEnd",	
}

local BUFFTYPE_DOUBLEEXPCARD = "MultiTime";

function BuffCell:Init()
	self.mask = self:FindComponent("Mask", UISprite);
	self.icon = self:FindComponent("Icon", UISprite);
	self.layer = self:FindComponent("Layer", UILabel);

	self:AddCellClickEvent();
end

function BuffCell:SetData(data)
	self.data = data;
	if(data)then
		self.gameObject:SetActive(true);
		local staticData = self.data.staticData;

		-- 存储data
		if(staticData == nil)then
			local storage = self.data.storage;
			if(storage ~= nil)then
				for k,v in pairs(storage)do
					staticData = Table_Buffer[v[1]];
					break;
				end
			end
		end

		if(staticData)then
			IconManager:SetSkillIcon(staticData.BuffIcon, self.icon)
			self.icon.width = 28;
			if(data.isalways)then
				TimeTickManager.Me():ClearTick(self, 1);
				self.mask.fillAmount = 0;
			elseif(data.starttime and data.endtime)then
				self:UpdateCDTime();
			else
				TimeTickManager.Me():ClearTick(self, 1);
				self.mask.fillAmount = 0;
			end
			if(not self:ObjIsNil(self.layer))then
				if(data.layer and data.layer>1 and 
					staticData.BuffEffect.type ~= BUFFTYPE_DOUBLEEXPCARD)then
					self.layer.gameObject:SetActive(true);
					self.layer.text = data.layer;
				else
					self.layer.gameObject:SetActive(false);
				end
			else
				-- errorLog("BuffCell Error (Not Find GameObject)");
			end
		else
			self.gameObject:SetActive(false);
		end
	else
		TimeTickManager.Me():ClearTick(self, 1);
		self.gameObject:SetActive(false);
	end
end

function BuffCell:OnRemove()
	TimeTickManager.Me():ClearTick(self, 1);

	TipManager.Instance:CloseNormalTip()
end

function BuffCell:UpdateCDTime(timetick)
	if(not self.data)then
		return;
	end
	local starttime,endtime = self.data.starttime, self.data.endtime;
	if(starttime and endtime)then
		local totalDeltaTime = endtime - starttime;
		if(totalDeltaTime<=0)then
			self:PassEvent(BuffCellEvent.BuffEnd, self.data);
			return;
		end
		TimeTickManager.Me():ClearTick(self, 1);
		TimeTickManager.Me():CreateTick(0, 33, function (self, deltatime)
			local nowDelteTime = math.max(ServerTime.CurServerTime() - starttime, 0);
			local fillAmount = nowDelteTime/totalDeltaTime;
			if(fillAmount<1)then
				self.mask.fillAmount = fillAmount;
			else
				self:PassEvent(BuffCellEvent.BuffEnd, self.data);
				TimeTickManager.Me():ClearTick(self, 1);
			end
		end, self, 1);
	end
end
