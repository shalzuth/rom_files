SpriteLabel = reusableClass("SpriteLabel")
SpriteLabel.PoolSize = 10

SpriteLabel.itemPattern = "({itemicon=(%d+)})"
SpriteLabel.uiPattern = "({uiicon=(.+)})"
SpriteLabel.bufficonPattern = "({bufficon=(.+)})"

function SpriteLabel:ctor(label,width,iconWidth,iconHeight,iconCenterInLine)
	SpriteLabel.super.ctor(self)
	if(label~=nil) then
		self.iconWidth = iconWidth or 30
		self.iconHeight = iconHeight or 30
		self.richLabel = label.gameObject:GetComponent(UIRichLabel)
		if(self.richLabel==nil) then
			self.richLabel = label.gameObject:AddComponent(UIRichLabel)
		end
		self:SetIconCenterInLine(iconCenterInLine)
		self.richLabel.keepCrispWhenShrunk = UILabel.Crispness.Never
		self.richLabel.space = string.rep(" ", math.floor(self.iconWidth/(self.richLabel.defaultFontSize/4)))
		self.richLabel.iconSize = Vector2(self.iconWidth,self.iconHeight)
		self.richLabel.m_offsetX = -self.iconWidth/2
		self.trueText = nil
		self.lineWidth = width or self.richLabel.width
		self.richLabel.BASELINEWIDTH = self.lineWidth
		self:Reset()
	end
end

function SpriteLabel:Init(label,width,iconWidth,iconHeight,iconCenterInLine)
	self.iconWidth = iconWidth or 30
	self.iconHeight = iconHeight or 30
	self.richLabel = label.gameObject:GetComponent(UIRichLabel)
	if(self.richLabel==nil) then
		self.richLabel = label.gameObject:AddComponent(UIRichLabel)
	end
	self:SetIconCenterInLine(iconCenterInLine)
	self.richLabel.keepCrispWhenShrunk = UILabel.Crispness.Never
	self.richLabel.space = string.rep(" ", math.floor(self.iconWidth/(self.richLabel.defaultFontSize/4)))
	self.richLabel.iconSize = Vector2(self.iconWidth,self.iconHeight)
	self.richLabel.m_offsetX = -self.iconWidth/2
	self.trueText = nil
	self.lineWidth = width or self.richLabel.width
	self.richLabel.BASELINEWIDTH = self.lineWidth
	self:Reset()
end

function SpriteLabel:SetIconCenterInLine(value)
	if(value == nil) then value = false end
	self.iconCenterInLine = value
end

function SpriteLabel:SetText(text,autoAddSps)
	self:Reset()
	--todo xde filter
	text = OverseaHostHelper:FilterLangStr(text)
	if(string.match(text,"icon")~=nil) then
		if(autoAddSps==nil) then autoAddSps = true end
		self.trueText = text
		----[[ todo 因为不能更新 C# 代码（UIRichLabel.ParseText, 在这里临时处理）
		local needReplace = string.match(text, "'") or string.match(text, "’")
		if needReplace then
			text = text:gsub("'", "_")
			text = text:gsub("’", "_")
			helplog('临时替换', text)
		end
		--]]
		--[[ todo 临时处理正好塞进一行会多算一行的情况
		text = text:gsub("Damage %[Brazed%] meningkat 100%%", "Damage[Brazed]meningkat100%%")
		helplog('text', text)
		--]]
		text = OverseaHostHelper:SpecialProcess(text)
		local parsedText = self.richLabel:ParseText(text)
		--[[ todo 临时处理正好塞进一行会多算一行的情况
		parsedText = parsedText:gsub("Damage%[Brazed%]meningkat100%%", "Damage [Brazed] meningkat 100%%")
		--]]
		----[[ todo 因为不能更新 C# 代码（UIRichLabel.ParseText, 在这里临时处理）
		if needReplace then
			parsedText = parsedText:gsub("_", "'")
			helplog('替换后', parsedText)
		end
		----[[ todo xde 含有单引号的 lbl 计算长度会偏大，需要加入空格补足
    	if(AppBundleConfig.GetSDKLang() == 'id') then
    		local _, count = parsedText:gsub("'", "")
    		for i=1, count do
    			helplog('增加空格')
    			parsedText = parsedText:gsub('     ', '      ')
    		end
    	end
		--]]
		self:UpdateMinHeight()
		self.richLabel.text = parsedText;
		if(autoAddSps) then
			self:AddSprites()
		end
	else
		self.richLabel.text = text;
	end
end

function SpriteLabel:UpdateMinHeight()
	local lines = self.richLabel.Lines
	local height = self.richLabel:GetSpLineTotalHeight(lines)
	self.richLabel.MinHeight = height
end

function SpriteLabel:AddSprites()
	self.labelPivot = self.richLabel.pivotOffset
	local spDatas = self.richLabel.symbols
	-- if(spDatas.Count>0) then
	-- 	self.label.spacingY = self.iconHeight - self.label.defaultFontSize+2
	-- end
	self.fontSize = self.richLabel.defaultFontSize
	self.paddingY = self.richLabel.spacingY
	self.halfHeight = self.richLabel.height/2
	for i=0,spDatas.Count-1 do
		self:AddSprite(spDatas[i])
	end
end

function SpriteLabel:AddSprite(data)
	for str,id in string.gmatch(data.info, SpriteLabel.itemPattern) do		
		local icon = self:CreateSprite()
		local itemData = Table_Item[tonumber(id)];
		if(itemData)then
			IconManager:SetItemIcon(itemData.Icon, icon)
			self:SetSpritePos(icon,data.pos,self.halfHeight,data.lineWidth)
		else
			printRed("Cannot Find Item"..id);
		end
    end
    for str,name in string.gmatch(data.info, SpriteLabel.uiPattern) do
		local icon = self:CreateSprite()
		IconManager:SetUIIcon(name, icon)
		self:SetSpritePos(icon,data.pos,self.halfHeight,data.lineWidth)
    end
    
    for str,name in string.gmatch(data.info, SpriteLabel.bufficonPattern) do
		local icon = self:CreateSprite()
		IconManager:SetSkillIconByProfess(name, icon,MyselfProxy.Instance:GetMyProfessionType())
		self:SetSpritePos(icon,data.pos,self.halfHeight,data.lineWidth)
    end
end

function SpriteLabel:SetSpritePos(sp,pos,halfHeight,inLineWidth)
	if(self.iconCenterInLine) then
		pos.y = -self.richLabel:GetSpLineTotalHeight(math.floor(pos.y)) - (self.fontSize + self.iconHeight)/2
	else
		pos.y = -self.richLabel:GetSpLineTotalHeight(math.floor(pos.y)) - self.fontSize
	end
	if(self.labelPivot.y ==0.5) then
		pos.y = pos.y + halfHeight
	end
	if(self.labelPivot.x ==0) then
		pos.x = pos.x + inLineWidth/2
	end
	sp.transform.localPosition = pos
end

function SpriteLabel:CreateSprite()
	local go = GameObject()
	go.layer = self.richLabel.gameObject.layer;
	local sp = go:AddComponent(UISprite)
	sp.pivot = UIWidget.Pivot.Bottom
	sp.transform.parent = self.richLabel.transform
	sp.transform.localScale = Vector3.one
	sp.transform.localRotation = Quaternion.identity
	sp.depth = self.richLabel.depth + 1
	sp.width = self.iconWidth
	sp.height = self.iconHeight
	self.richLabel.sprites:Add(sp)
	return sp
end

function SpriteLabel:Reset()
	if(self.richLabel) then
		self.richLabel.MinHeight = 2
		self.richLabel:Reset()
		self.richLabel:RemoveSprites()
	end
end

-- override begin
function SpriteLabel:DoConstruct(asArray, data)
end

function SpriteLabel:DoDeconstruct(asArray)
	if(self.richLabel) then
		self.richLabel.pivot = UIWidget.Pivot.Center	
	end
	self:Reset()
	self.richLabel = nil
end
-- override end