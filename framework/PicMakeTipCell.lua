local BaseCell = autoImport("BaseCell");
PicMakeTipCell = class("PicMakeTipCell", BaseCell)
	
PicMakeTipCell.LightColor = "[FFC514]";
PicMakeTipCell.DarkColor = "[B8B8B8]";

function PicMakeTipCell:Init()
	self.lab1 = self:FindGO("Label1"):GetComponent(UILabel);
	self.lab2 = self:FindGO("Label2"):GetComponent(UILabel);
end

function PicMakeTipCell:SetData(data)
	if(data and data.neednum and data.num)then
		local color = data.neednum<=data.num and self.LightColor or self.DarkColor;
		self.lab1.text = color..data.name.."[-]";
		self.lab2.text = color..data.num.."/"..data.neednum.."[-]";
	end
end