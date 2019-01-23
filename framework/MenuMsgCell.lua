local BaseCell = autoImport("BaseCell");
MenuMsgCell = class("MenuMsgCell", BaseCell);

function MenuMsgCell:Init()
	self:InitUI();	
end

function MenuMsgCell:InitUI()
	-- self.icon = self:FindComponent("Icon", UISprite);
	self.tip = SpriteLabel.new(self:FindGO("MsgLabel"),nil,50,50,true)
	self.icon = self:FindGO("TitleIcon"):GetComponent(UISprite)
	self.animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer);
	self.animHelper = self.animHelper.animatorHelper;
	self:AddAnimatorEvent()
end

function MenuMsgCell:IsShowed()
	return self.isShowed
end

function MenuMsgCell:ResetAnim()
	self.isShowed = false
	LeanTween.cancel(self.gameObject)
    LeanTween.delayedCall(self.gameObject,GameConfig.ItemPopShowTimeLim,function ()
    	self.isShowed = true
	end)
end

function MenuMsgCell:PlayHide()
	if(self.isShowed) then
		self:PassEvent(SystemUnLockEvent.ShowNextEvent,self.data)
		-- self.animHelper:Play("UnLockAnim2", 1, false);
	end
end

function MenuMsgCell:AddAnimatorEvent()
	self.animHelper.loopCountChangedListener = function (state, oldLoopCount, newLoopCount)
		if(not self.isShowed)then
			self.isShowed = true;
		end
	end
end

function MenuMsgCell:SetData(data)
	self.data = data
	self:ResetAnim();
	self.tip:Reset()
	if(data.Type.isMenu) then
		local config = data.data
		local msg = config.Tip;
		if(config.event)then
			if(config.event.type == "scenery")then
				local _,viewindex = next(config.event.param);
				if(viewindex and Table_Viewspot[viewindex])then
					local pointName = Table_Viewspot[viewindex].SpotName;
					msg = string.format(msg, pointName);
				end
			elseif(config.event.type == "unlockmanual")then
				local viewindex = config.event.param[2];
				if(viewindex)then
					local mapName = Table_Map[viewindex] and Table_Map[viewindex].CallZh;
					if(mapName == nil)then
						helplog("Meun Error!!!", viewindex, config.id);
					else
						msg = string.format(msg, mapName);
					end
				end
			end
		end
		-- self.tip.text = msg
		self.tip:SetText(msg,true)
		self:SetTitleIcon(config.Icon)
	else
		local config = self.data.data
		self.tip:SetText(config.text,true)
		self:SetTitleIcon(config.title)
	end
	self.animHelper:Play("UnLockMsg1", 1, false);
	self:PlayCommonSound(AudioMap.Maps.FunctionUnlock);
end

local min = math.min
local MAX_SIZE = 100
function MenuMsgCell:SetTitleIcon(configIcon)
	local atlasStr;
	local iconStr = "";
	if(configIcon ~= nil )then
		if(type(configIcon)=="table") then
			atlasStr,iconStr= next(configIcon)
		else
			atlasStr,iconStr = MsgParserProxy.Instance:GetIconInfo(configIcon)
		end
		if(atlasStr ~=nil and iconStr~=nil) then
			self:Show(self.icon)
			if(atlasStr == "itemicon")then
				IconManager:SetItemIcon(iconStr, self.icon)
				self.icon:MakePixelPerfect()
			elseif(atlasStr == "skillicon")then
				IconManager:SetSkillIcon(iconStr, self.icon)
				self.icon:MakePixelPerfect()
			else
				IconManager:SetUIIcon(iconStr, self.icon)
				self.icon:MakePixelPerfect()
			end
			self.icon.width = min(self.icon.width,MAX_SIZE)
			self.icon.height = min(self.icon.height,MAX_SIZE)
			self.icon.transform.localScale = Vector3(1.3,1.3,1)
		else
			self:Hide(self.icon)
		end
	else
		self:Hide(self.icon)
	end
end