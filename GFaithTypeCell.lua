local BaseCell = autoImport("BaseCell");

GFaithTypeCell = class("GFaithTypeCell", BaseCell);

function GFaithTypeCell:Init()
	self.name = self:FindComponent("NameLabel", UILabel);
	self.attriAdd = self:FindComponent("AttriAdd", UILabel);
	-- self.level = self:FindComponent("Level", UILabel);
	-- todo xde fix ui
	self.bg = self:FindComponent("Bg",UISprite)
	self.bg.height = 40
	self.bg.width = 150
	self.bg.transform.localPosition = Vector3(-85,0,0)
	self.name.fontSize = 18
	self.name.transform.localPosition = Vector3(-85,0,0)
	OverseaHostHelper:FixLabelOverV1(self.name,3,150)

end

function GFaithTypeCell:SetData(data)
	if(data)then
		local sData = data.staticData;

		-- self.level.text = data.level;
		--todo xde
		if(OverSea.LangManager.Instance().CurSysLang == 'Thai') then
			self.name.text = string.format("%s%s", ZhString.GFaithTypeCell_Pray, sData.Name);
		else
			self.name.text = string.format("%s%s", sData.Name, ZhString.GFaithTypeCell_Pray);
		end
	
		
		local _, nowValue = next(GuildFun.calcGuildPrayAttr(sData.id, data.level));
		if(nowValue)then
			local floorValue = math.floor(nowValue);
			if(floorValue < nowValue)then
				self.attriAdd.text = string.format("%s +%.1f", sData.Attr, nowValue);
			else
				self.attriAdd.text = string.format("%s +%s", sData.Attr, floorValue);
			end
		end
	end
end
















