local BaseCell = autoImport("BaseCell");
WeakDialogCell = class("WeakDialogCell", BaseCell);

local headIconCell_Path = ResourcePathHelper.UICell("HeadIconCell")

WeakDialogEvent = {
	Hide = "WeakDialogEvent_Hide",
}


function WeakDialogCell:Init()
	self.weakDialogBord = self:FindGO("WeakDialogBord");

	self.voiceSymbol = self:FindGO("Voice");
	self.dialogText = self:FindComponent("Text", UILabel);

	local headGO_Container = self:FindGO("WeakDialogHeadCell");
	local headGO = self:LoadPreferb_ByFullPath(headIconCell_Path, headGO_Container);
	headGO.transform.localScale = LuaGeometry.Const_V3_one;
	self.headCell = HeadIconCell.new(headGO);
	self.headCell:SetMinDepth(40);
	self.headCell:HideFrame();

	self:AddClickEvent(self.gameObject, function ()
		if(self.lt)then
			self.lt:cancel();
			self.lt = nil;
		end
		self:Hide();
	end);

	self.tween = self.gameObject:GetComponent(TweenPosition);
end

function WeakDialogCell:Show()
	self.tween:PlayForward();
end

function WeakDialogCell:CancelHideLT()
	if(self.hidelt)then
		self.hidelt:cancel();
	end
	self.hidelt = nil;
end

function WeakDialogCell:SetData(dialogData)
	self:CancelTween();
	self:CancelHideLT();

	self.data = dialogData;
	
	if(not dialogData)then
		self:Hide();
		return;
	end

	self:Show();

	local speaker = dialogData.Speaker;
	local headImageData = HeadImageData.new()
	if(speaker == nil or speaker == 0)then
		headImageData:TransByMyself()
	else
		local npcData = Table_Npc[speaker];
		if(npcData)then
			headImageData:TransByNpcData(npcData);
		else
			local monsterData = Table_Monster[speaker];
			if(monsterData)then
				headImageData:TransByMonsterData(monsterData);
			end
		end
	end
	if(headImageData.iconData.type == HeadImageIconType.Avatar)then
		self.headCell:SetData(headImageData.iconData);
	elseif(headImageData.iconData.type == HeadImageIconType.Simple)then
		self.headCell:SetSimpleIcon(headImageData.iconData.icon);
	end

	local transText = MsgParserProxy.Instance:TryParse(tostring(dialogData.Text))
	self.textStayTime = 6;
	self.stayTime = math.ceil( StringUtil.getTextLen(transText) ) * self.textStayTime / 24 + 1;
	self:SetText( transText );

	if(dialogData.Voice~=nil and dialogData.Voice~="")then
		AudioUtil.PlayNpcVisitVocal(dialogData.Voice);
	end

	self.hidelt = LeanTween.delayedCall(self.stayTime, function ()
		self:Hide();
	end);
end

function WeakDialogCell:SetText(text)
	helplog("==WeakDialogCell:SetText==>>>>", text)
	self.dialogText.text = text;
	local newText = self.dialogText.text

	local bWarp, finalStr;
	bWarp, finalStr = self.dialogText:Wrap(newText, finalStr, self.dialogText.height);
	if(not bWarp)then
		local finallen = StringUtil.getTextLen(finalStr);
		local lastSpaceIndex = StringUtil.LastIndexOf(finalStr, " ");
		local textlen = StringUtil.getTextLen(newText);
		if(lastSpaceIndex and lastSpaceIndex < textlen)then
			self.dialogText.text = StringUtil.getTextByIndex(newText, 1, lastSpaceIndex)
			self.leftStr = StringUtil.getTextByIndex(newText, lastSpaceIndex + 1, textlen);
		elseif finallen < textlen then
			-- self.dialogText.text = StringUtil.getTextByIndex(text, 1, finallen)
			self.leftStr = StringUtil.getTextByIndex(newText, finallen + 1, textlen);
		else
			self.leftStr = "";
		end
	else
		self.leftStr = nil;
	end

	self:_FadeIn();
end

-- Text AlphaIn/Out
function WeakDialogCell:CancelTween()
	if(self.lt) then
		self.lt:cancel()
		self.lt = nil
	end
end
-- step1
function WeakDialogCell:_FadeIn()
	self:CancelTween()
	if(not Slua.IsNull(self.gameObject)) then
		self.lt = LeanTween.value(self.gameObject, WeakDialogCell._AlphaTo, 0, 1, 0.3)
		self.lt.onUpdateParam = self
		self.lt.onCompleteObject = WeakDialogCell._FadeOut
		self.lt.onCompleteParam = self
	end
end

function WeakDialogCell._AlphaTo(alpha, self)
	self.dialogText.alpha = alpha;
end

function WeakDialogCell:_FadeOut()
	self:CancelTween()
	if(not Slua.IsNull(self.gameObject)) then
		self.lt = LeanTween.value(self.gameObject,WeakDialogCell._AlphaTo, 1, 0, 0.3)
		self.lt.delay = self.textStayTime
		self.lt.onUpdateParam = self
		self.lt.onCompleteObject = WeakDialogCell._FadeEnd
		self.lt.onCompleteParam = self
	end
end

function WeakDialogCell:_FadeEnd()
	self:CancelTween()
	if(type(self.leftStr)=="string" and string.len(self.leftStr)>0)then
		self:SetText(self.leftStr);
	else
		self:Hide();
	end
end

function WeakDialogCell:Hide()
	self.tween:PlayReverse();

	self:CancelTween();
	self:CancelHideLT();

	self.leftStr = nil;
	self.stayTime = nil;
	self.textStayTime = nil;

	self:PassEvent(WeakDialogEvent.Hide, self.data);
end
