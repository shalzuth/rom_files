local baseCell = autoImport("BaseCell");
PortraitCell = class("PortraitCell",baseCell);

function PortraitCell:Init()
	self.frame = self:FindChild("Frame");
	if(self.frame~=nil)then
		self.frame = self.frame:GetComponent(UISprite);
	end
	self.headIcon = self:FindChild("HeadIcon");
	if(self.headIcon~=nil)then
		self.headIcon = self.headIcon:GetComponent(UISprite);
	end

	self.lock = self:FindChild("Lock");
	self.newtag = self:FindGO("NewTag");

	self:AddEvent();
end

function PortraitCell:AddEvent()
	self:SetEvent(self.gameObject, function (g)
		self:PassEvent(MouseEvent.MouseClick, {obj = self.gameObject, data = self.data});
	end);
end

function PortraitCell:SetData(data)
	self.data = data;
	if(data~=nil)then
		if(data.Type == 1 or data.Type == 2)then
			if(self.headIcon~=nil)then
				local picStr = Table_Item[data.id].Icon;
				local setSuc = IconManager:SetFaceIcon(picStr, self.headIcon);
				self.headIcon.gameObject:SetActive(setSuc);
				if(not setSuc)then
					printRed(string.format("Cannot Find HeadImage: %s", data.Name));
				end
			end
		elseif(data.Type == 3)then
			if(self.frame~=nil)then
				local picStr = Table_Item[data.id].Icon;
				IconManager:SetFaceIcon(picStr, self.frame);
			end
		end
	end

	local lock = data.Lock;
	self.lock:SetActive(lock == 1);

	local pbtype = SceneTip_pb.EREDSYS_ROLE_IMG;
	if(data.Type == 2)then
		pbtype = SceneTip_pb.EREDSYS_MONSTER_IMG;
	end
	local isnew = RedTipProxy.Instance:IsNew(pbtype, data.id);
	self.newtag:SetActive(isnew);
end
