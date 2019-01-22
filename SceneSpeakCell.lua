SceneSpeakCell = reusableClass("SceneSpeakCell");

SceneSpeakCell.PoolSize = 10

SceneSpeakCell.ResID = ResourcePathHelper.UICell("SceneSpeakCell")

function SceneSpeakCell:CreateSpeakGO()
	if(LuaGameObject.ObjectIsNull(self.parent))then
		return;
	end

	if(self.gameObject == nil or LuaGameObject.ObjectIsNull(self.gameObject))then
		self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneSpeakCell.ResID, self.parent);
		
		self.gameObject.transform:SetParent(self.parent.transform, false);
		self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity;
		self.gameObject.transform.localScale = LuaGeometry.Const_V3_one;

		self:SetOffsetY(0);

		self.widget = self.gameObject:GetComponent(UIWidget);
		self.label = GameObjectUtil.Instance:DeepFind(self.gameObject, "Label"):GetComponent(UILabel);

		-- todo xde ???????????? max lines ??????????????????????????? bug
		self.hiddenLabel = GameObjectUtil.Instance:DeepFind(self.gameObject, "HiddenLabel"):GetComponent(UILabel);
		--[[
		if (self.hiddenLabel == nil) then
			-- printData('Instantiate', 'called')
			self.hiddenLabel = GameObject.Instantiate(self.label)
			self.hiddenLabel.name = "HiddenLabel"
			self.hiddenLabel.gameObject.transform:SetParent(self.label.transform.parent, false)
			self.hiddenLabel.gameObject:SetActive(false)
			self.hiddenLabel.maxLineCount = 4
			-- printData('self.hiddenLabel', self.hiddenLabel)
			-- self.hiddenLabel = GameObjectUtil.Instance:DeepFind(self.gameObject, "HiddenLabel"):GetComponent(UILabel);
		end
		--]]
	end

	return self.gameObject;
end

local cellOffset = LuaVector3();
function SceneSpeakCell:SetOffsetY(offsetY)
	cellOffset:Set(0, 10 + offsetY, 0);
	self.gameObject.transform.localPosition = cellOffset;
end

function SceneSpeakCell:SetDelayDestroy(fadeInTime, stayTime, fadeOutTime)
	if(self.gameObject)then
		self.widget.alpha = 0;

		self.fadeInTime = fadeInTime or 0;
		self.stayTime = stayTime or 3;
		self.fadeOutTime = fadeOutTime or 0;
		self:_FadeIn()
	end
end

function SceneSpeakCell:CancelTween()
	if(self.lt) then
		self.lt:cancel()
		self.lt = nil
	end
end
-- step1
function SceneSpeakCell:_FadeIn()
	self:CancelTween()
	if(not Slua.IsNull(self.gameObject)) then
		self.lt = LeanTween.value(self.gameObject,SceneSpeakCell._AlphaTo,0,1,self.fadeInTime)
		self.lt.onUpdateParam = self
		self.lt.onCompleteObject = SceneSpeakCell._FadeOut
		self.lt.onCompleteParam = self
	end
end

function SceneSpeakCell._AlphaTo(alpha, self)
	self.widget.alpha = alpha;
end

function SceneSpeakCell:_FadeOut()
	self:CancelTween()
	if(not Slua.IsNull(self.gameObject)) then
		self.lt = LeanTween.value(self.gameObject,SceneSpeakCell._AlphaTo,1,0,self.fadeOutTime)
		self.lt.delay = self.stayTime
		self.lt.onUpdateParam = self
		self.lt.onCompleteObject = SceneSpeakCell._FadeEnd
		self.lt.onCompleteParam = self
	end
end

function SceneSpeakCell:_FadeEnd()
	self:CancelTween()
	local leftlen = StringUtil.getTextLen(self.leftStr);
	if(type(self.leftStr)=="string" and leftlen>0)then
		self:SetData(self.leftStr);
	elseif(not Slua.IsNull(self.gameObject))then
		Game.GOLuaPoolManager:AddToSceneUIPool(SceneSpeakCell.ResID, self.gameObject)
		self.gameObject = nil;
	end
end

function SceneSpeakCell:SetData(text)
	self:CreateSpeakGO();

	if(self.gameObject == nil)then
		return;
	end

	if(text and self.label)then
		-- todo xde ??????????????????????????????????????????????????????????????????
		if text == '' then
			do return end
		else
			-- helplog(text)
		end
		local newText = text
		if self.hiddenLabel ~= nil then
			text = OverSea.LangManager.Instance():GetLangByKey(text)
			-- printData('text', text)
			-- todo xde ???????????? max lines ??????????????????????????? bug
			self.hiddenLabel.text = text;
			-- printData('self.hiddenLabel.processedText', self.hiddenLabel.processedText)
			local lines = StringUtil.Split(self.hiddenLabel.processedText, '\n')
			-- printData('lines', lines)
			local line3 = nil
			if lines == nil then
				-- printData('text', text)
			end
			if (lines ~= nil and #lines == 4) then
				line3 = lines[3]
				-- printData('line3', line3)
				i, j = string.find(text, line3, 1, true)
				if (i == nil) then
					-- printData('!!!!', 'can not find line3')
				end
				if j~= nil and (text:sub(j+1, j+1) == ' ') then
					j = j+1
				else
					-- printData('text:sub(j+1, j+1)', text:sub(j+1, j+1))
				end
				newText = string.sub(text, 1, j)
				-- printData('new text', newText)
			end
		end
		-- todo xde end

		self:UpdateGameObjectActive();
		self.label.text = newText;

		UIUtil.FitLabelHeight(self.label, 230);
		-- printData('text', self.label.text)
		-- printData('processedText', self.label.processedText)
		local tmpFont = self.label.bitmapFont
		-- printData('self.label.bitmapFont', tmpFont)
		if tmpFont ~= nil then
			-- printData('tmpFont:GetInstanceID()', tmpFont:GetInstanceID())
		else
			-- redlog("??????font")
			OverSea.LangManager.Instance():ResetGameFont()
		end

		local len = StringUtil.getTextLen(self.label.processedText);
		local textlen = StringUtil.getTextLen(text);
		if(len < textlen)then
			self.leftStr = StringUtil.getTextByIndex(text, len + 1, textlen);
		else
			self.leftStr = "";
		end

		self:SetDelayDestroy(0.3, 2, 0.5);
	end
end

function SceneSpeakCell:Active(b)
	self.objActive = b;
	self:UpdateGameObjectActive();
end

function SceneSpeakCell:UpdateGameObjectActive()
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		self.gameObject:SetActive(self.objActive);
	end
end

-- override begin
function SceneSpeakCell:DoConstruct(asArray, parent)
	self.leftStr = "";
	self.objActive = true;
	self.parent = parent;
end

function SceneSpeakCell:DoDeconstruct(asArray)
	self:CancelTween();

	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		Game.GOLuaPoolManager:AddToSceneUIPool(SceneSpeakCell.ResID, self.gameObject)
	end
	self.gameObject = nil;

	self.parent = nil;
end
-- override end


