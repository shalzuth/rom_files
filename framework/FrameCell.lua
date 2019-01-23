local BaseCell = autoImport("BaseCell");
FrameCell = class("FrameCell", BaseCell);

function FrameCell:Init()
	self.frame = self:FindComponent("headframe", UISprite)
	self.iconBg = self:FindComponent("bg_head", UISprite);
	self.proBg = self:FindComponent("bg_career", UISprite);
	self.hpleft = self:FindComponent("hpleft", UISprite);
	self.hpbottom = self:FindComponent("hp_bottom", UISprite);
	self:AddEvent();
end

function FrameCell:AddEvent()
	self:SetEvent(self.gameObject, function (g)
		self:PassEvent(MouseEvent.MouseClick, {obj = self.gameObject, data = self.data});
	end);
end

function FrameCell:SetData(data)
	if(data)then
		if(type(data) == "number" and Table_Item[data])then
			data = Table_Item[data].Icon;
		end
		if(self.frame)then
			local frameStr = data.."_headframe";
			IconManager:SetFrameIcon(frameStr, self.frame);
			if(data == 0)then
				self.frame.width = 116;
				self.frame.height = 118;
			else
				self.frame:MakePixelPerfect();
			end
		end
		if(self.iconBg)then
			local iconBgStr = data.."_bg_head";
			if(not IconManager:SetFrameIcon(iconBgStr, self.iconBg))then
				IconManager:SetFrameIcon("1_bg_head", self.iconBg)
			end
		end 
		if(self.proBg)then
			local proBgStr = data.."_bg_career";
			if(not IconManager:SetFrameIcon(proBgStr, self.proBg))then
				IconManager:SetFrameIcon("1_bg_career", self.proBg)
			end
		end
		if(self.hpleft)then
			local hpleftStr = data.."_hpleft";
			if(not IconManager:SetFrameIcon(hpleftStr, self.hpleft))then
				self.hpleft.spriteName = "";
			end
		end
		if(self.hpbottom)then
			local hpbottomStr = data.."_hp_bottom";
			if(not IconManager:SetFrameIcon(hpbottomStr, self.hpbottom))then
				IconManager:SetFrameIcon("1_hp_bottom", self.hpbottom)
			end
		end
	end
end




