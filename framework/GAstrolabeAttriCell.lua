local BaseCell = autoImport("BaseCell");
GAstrolabeAttriCell = class("GAstrolabeAttriCell", BaseCell);

function GAstrolabeAttriCell:Init()
	self.name = self:FindComponent("NameLabel", UILabel);
	self.attriAdd = self:FindComponent("AttriAdd", UILabel);
end

function GAstrolabeAttriCell:SetData(data)
	if(data)then
		local pro = Game.Config_PropName[ data[1] ];
		self.name.text =  pro.PropName;	

		local config = Game.Config_PropName[ data[1] ];
		if(config ~= nil)then
			self.name.text = config.PropName;

			local str = "";
			if(data[2] > 0)then
				str = str .. " +"
			end
			if(config.IsPercent==1)then
				str = str .. data[2] * 100 .. "%";
			else
				str = str .. data[2];
			end
			self.attriAdd.text = str;
		else
			redlog("Canot Find Attri" .. attriType .. " ID:" .. data.guid);
		end
	end
end

