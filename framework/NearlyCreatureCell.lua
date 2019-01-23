local BaseCell = autoImport("BaseCell") 
NearlyCreatureCell =  class("NearlyCreatureCell", BaseCell)

function NearlyCreatureCell:Init()
	self.playerObj = self:FindGO("Player");
	self.playerPro = self:FindComponent("ProSymbol", UISprite, self.playerObj);
	self.playerLevel = self:FindComponent("Level", UILabel, self.playerObj);
	self.playerName = self:FindComponent("Name", UILabel, self.playerObj);
	self.playerGender = self:FindComponent("Gender", UISprite, self.playerObj);

	self.npcObj = self:FindGO("NPC");
	self.npcSymbol = self:FindComponent("NpcSymbol", UISprite, self.npcObj);
	self.npcName = self:FindComponent("Name", UILabel, self.npcObj);

	self:AddCellClickEvent();
end

function NearlyCreatureCell:SetData(data)
	if(data)then
		self.id = data.id;
		self.creatureType = data:GetParama("creatureType");

		self.gameObject:SetActive(true);

		local name = data:GetParama("name");
		if(self.creatureType == Creature_Type.Npc)then
			self.playerObj:SetActive(false);
			self.npcObj:SetActive(true);

			local symbol = data:GetParama("Symbol")
			local config = symbol and QuestSymbolConfig[symbol]
			local questSymbol = config and config.UISpriteName;
			if(questSymbol)then
				local isSuc = IconManager:SetMapIcon(questSymbol, self.npcSymbol);
				if(questSymbol == "map_icon_talk")then
					self.npcSymbol.width = 20;
					self.npcSymbol.height = 18;
				else
					self.npcSymbol.width = 11;
					self.npcSymbol.height = 27;
				end
			else
				local icon = data:GetParama("icon")
				IconManager:SetMapIcon(icon, self.npcSymbol);
				self.npcSymbol.width = 25;
				self.npcSymbol.height = 25;
			end

			local posTip = data:GetParama("PositionTip");
			if(posTip~='')then
				self.npcName.text = string.format(ZhString.NearlyCreatureCell_NameTip, posTip, name);
			else
				self.npcName.text = name;
			end
			UIUtil.WrapLabel(self.npcName);

			self.pos = data.pos:Clone();
			self.npcid = data:GetParama("npcid");
			self.uniqueid = data:GetParama("uniqueid");

		elseif(self.creatureType == Creature_Type.Player)then
			self.playerObj:SetActive(true);
			self.npcObj:SetActive(false);

			local playerPro = data:GetParama("Profession");
			if(playerPro and Table_Class[playerPro])then
				IconManager:SetProfessionIcon(Table_Class[playerPro].icon, self.playerPro);
			end

			self.playerLevel.text = "Lv."..data:GetParama("level");
			self.playerName.text = data:GetParama("name");

			local gender = data:GetParama("gender");
			self.playerGender.spriteName = gender == 1 and "friend_icon_man" or "friend_icon_woman";
		else
			self.gameObject:SetActive(false);
		end
	else
		self.gameObject:SetActive(false);
	end
end