local BaseCell = autoImport("BaseCell");
MenuUnLockCell = class("MenuUnLockCell", BaseCell);
function MenuUnLockCell:Init()
	self:InitUI();	
end

function MenuUnLockCell:InitUI()
	self.icon = self:FindGO("Icon"):GetComponent(UISprite);
	self.tip = self:FindGO("Tip"):GetComponent(UILabel);
	self.animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer);
	self.animHelper = self.animHelper.animatorHelper;
	self:AddAnimatorEvent()
end

function MenuUnLockCell:IsShowed()
	return self.isShowed
end

function MenuUnLockCell:ResetAnim()
	self.isShowed = false
	LeanTween.cancel(self.gameObject)
    LeanTween.delayedCall(self.gameObject,GameConfig.ItemPopShowTimeLim,function ()
    	self.isShowed = true
	end)
end

function MenuUnLockCell:PlayHide()
	if(self.isShowed) then
		self.animHelper:Play("UnLockAnim2", 1, false);
	end
end

function MenuUnLockCell:AddAnimatorEvent()
	self.animHelper.loopCountChangedListener = function (state, oldLoopCount, newLoopCount)
		if(not self.isShowed)then
			-- self.isShowed = true;
		end
		if(state:IsName("UnLockAnim2"))then
			self:PassEvent(SystemUnLockEvent.ShowNextEvent,self.data)
			-- self:CloseSelf();
		end
	end
end

function MenuUnLockCell:SetData(data)
	self.data = data
	self:ResetAnim();
	local config = self.data.data
	local atlasStr;
	local iconStr = "icon_pvp";
	if(config)then
		if(config.Icon)then
			atlasStr,iconStr= next(config.Icon)
		end
	end
	if(atlasStr == "itemicon")then
		IconManager:SetItemIcon(iconStr, self.icon);
		self.icon:MakePixelPerfect();
	elseif(atlasStr == "skillicon")then
		IconManager:SetSkillIcon(iconStr, self.icon);
		self.icon:MakePixelPerfect();
	elseif(atlasStr == "uiicon")then
		IconManager:SetUIIcon(iconStr, self.icon);
		self.icon:MakePixelPerfect();
	else
		self.icon.spriteName = iconStr;
		self.icon:MakePixelPerfect();
		self.icon.width = self.icon.width * 1.2;
		self.icon.height = self.icon.height * 1.2;
	end
	
	local msg = config.Tip
	if(config.event)then
		if(config.event.type == "scenery")then
			local _,viewindex = next(config.event.parama);
			if(viewindex and Table_Viewspot[viewindex])then
				local pointName = Table_Viewspot[viewindex].SpotName;
				msg = string.format(msg, pointName);
			end
		elseif(config.event.type == "unlockmanual")then
			local viewindex = config.event.param[2];
			if(viewindex)then
				local mapName = Table_Map[viewindex].CallZh;
				msg = string.format(msg, mapName);
			end
		end
	end
	self.tip.text = msg

	self.animHelper:Play("UnLockAnim", 1, false);
	self:PlayCommonSound(AudioMap.Maps.FunctionOpen);
end


