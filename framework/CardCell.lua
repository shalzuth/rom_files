local BaseCell = autoImport("BaseCell");
CardCell = class("CardCell", BaseCell)

CardCell.TagConfig = {
	[1] = "",
	[2] = "icon_35",
	[3] = "icon_36",
}

function CardCell:Init()
	self:FindObjs();
	self:AddCellClickEvent();

	self:SetPress(self.gameObject, function(go, p)
		self:PassEvent(MouseEvent.MousePress, p);
	end);
end

function CardCell:FindObjs()
	self.name = self:FindComponent("Name", UILabel);
	self.quality = self:FindComponent("Quality", UISprite);
	self.icon = self:FindComponent("Icon", UISprite);
	self.position = self:FindComponent("Position", UISprite);
	self.tag = self:FindComponent("Tag", UISprite);
	self.taglabel = self:FindComponent("TagLabel", UILabel);
	self.level = self:FindComponent("Level", UILabel);
	self.num =self:FindComponent("Num", UILabel);

	self.attriBord = self:FindChild("AttriBord");
	self.attriLabel = self:FindComponent("AttirLabel", UILabel);

	self.newTag = self:FindChild("NewTag");
	
	local chipsContainer = self:FindChild("ChipIcon");
	self.chips = {};
	self.chips.Obj = chipsContainer;
	for i=1,6 do
		self.chips[i] = self:FindChild("Chip"..i, chipsContainer);
		self.chips[i] = self.chips[i]:GetComponent(UISprite);
	end
end

function CardCell:SetData(data)
	self.data = data;
	if(data and data.staticData)then
		self.gameObject:SetActive(true);

		local cardInfo = data.cardInfo;
		if(not cardInfo)then
			local id = data.staticData.id or 0;
			printRed(string.format("The Item(%d) is Not card", id));
			return;
		end
		if(self.chips.Obj)then
			if(data.cardtype == "Chip")then
				self.chips.Obj:SetActive(true);
				for i=1,#self.chips do
					self.chips[i].gameObject:SetActive(true);
				end
				self.data.canCombine = #data.fragments==6;
				for i=1,#data.fragments do
					local frag = data.fragments[i];
					pos = frag.cardInfo.Number;
					if(pos and self.chips[pos])then
						if(frag.num<1)then
							self.chips[pos].gameObject:SetActive(true);
							self.data.canCombine = false;
						else
							self.chips[pos].gameObject:SetActive(false);
						end
					else 
						printRed(string.format("cannot find pos:%s", tostring(pos)));
					end
				end
			else
				self.chips.Obj:SetActive(false);
			end
		end

		-- if(not IconManager:SetCardIcon(cardInfo.Picture, self.icon))then
		-- 	IconManager:SetCardIcon("card_10000", self.icon);
		-- end

		local showGrey = data.cardtype~="Chip" and data.num==0;
		self.icon.color = showGrey and Color(1/255,2/255,3/255,4/255) or  Color(1,1,1);
		if(self.num)then
			if(data.num>0)then
				self.num.gameObject:SetActive(true);
				self.num.text = "X "..data.num;
			else
				self.num.gameObject:SetActive(false);
			end
		end

		self.position.spriteName = CardPosIconConfig[cardInfo.Position];
		self.position:MakePixelPerfect();

		self.name.text = cardInfo.Name;
		local qInt = cardInfo.Quality;
		if(qInt and CardLabelQualityColor[qInt])then
			self.name.gradientBottom = CardLabelQualityColor[qInt][1];
			self.name.effectColor = CardLabelQualityColor[qInt][2];
			self.quality.spriteName = "card_bg_0"..qInt;
		end
	
		self.level.text = "Lv."..cardInfo.CardLv;
		self.attriLabel.text = MsgParserProxy.Instance:TryParse(cardInfo.Text);
		if(self.taglabel)then
			self.taglabel.text = self.TagConfig[cardInfo.CardType];
		end
		if(self.tag)then
			self.tag.gameObject:SetActive(cardInfo.CardType ~= 1);
			self.tag.spriteName = tostring(self.TagConfig[cardInfo.CardType]);
		end

		local isNew = (data:IsNew() or false) and data.num>0;
		self:SetActive(self.newTag, isNew);
	else
		self.gameObject:SetActive(false);
	end
end

function CardCell:ShowAttri()
	self.attriBord:SetActive(true);
end

function CardCell:HideAttri()
	self.attriBord:SetActive(false);
end