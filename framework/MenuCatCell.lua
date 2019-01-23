local BaseCell = autoImport("BaseCell");
MenuCatCell = class("MenuCatCell", BaseCell);

function MenuCatCell:Init()
	self:InitUI();	
end

function MenuCatCell:InitUI()
	self.container = self:FindGO("EffectContainer");
end

function MenuCatCell:SetData(data)
	self.data = data;

	local config = data.data;
	if(config)then
		if(self.effect)then
			self.effect:Destroy();
		end

		local effectName = config.event.effect;
		if(effectName)then
			self:PlayEffect(effectName);
		else
			self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
		end
	else
		self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
	end
end

function MenuCatCell:RemoveLeanTween()
	if(self.lt)then
		self.lt:cancel();
	end
	self.lt = nil;
end


function MenuCatCell:PlayEffect(effectName)
	local path = ResourcePathHelper.UIEffect(effectName)
	self.effect = Asset_Effect.PlayOneShotOn(
		path,
		self.container.transform,
		MenuCatCell._HandleMidEffectShow,
		self);

	if(self.effect)then
		self:sendNotification(MainViewEvent.ShowOrHide, false);
		self.effect:RegisterWeakObserver(self);
	else
		self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
	end
end

function MenuCatCell:ObserverDestroyed(obj)
	if(obj == self.effect)then
		self.effect = nil;
		self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
	end
end

function MenuCatCell._HandleMidEffectShow(effectHandle, owner)
	if(effectHandle and owner)then
		owner:HandleMidEffectShow(effectHandle);
	end
end

function MenuCatCell:HandleMidEffectShow(effectHandle)
	local effectGO = effectHandle.gameObject;

	local panels = UIUtil.GetAllComponentsInChildren(effectGO, UIPanel, true);
	if(#panels == 0)then
		return;
	end

	local upPanel = GameObjectUtil.Instance:FindCompInParents(effectGO, UIPanel);
	local minDepth = nil;
	for i=1,#panels do
		if(minDepth == nil)then
			minDepth = panels[i].depth;
		else
			minDepth = math.min(panels[i].depth, minDepth);
		end
	end
	local startDepth = 1;
	for i=1,#panels do
		panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth;
	end
end

function MenuCatCell:Show()
	MenuCatCell.super.Show(self);
end

function MenuCatCell:Hide()
	MenuCatCell.super.Hide(self);

	if(self.effect)then
		self.effect:Destroy();
	end
	self:sendNotification(MainViewEvent.ShowOrHide, true);
end



