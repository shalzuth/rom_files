local baseCell = autoImport("BaseCell")
ShortCutSkillDragCell = class("ShortCutSkillDragCell",baseCell)

function ShortCutSkillDragCell:Init()
	self.icon = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "Icon"):GetComponent(UISprite)
	self.icon_UISpirte = self.icon
	self.lock = self:FindGO("Lock")
	self.lock_UISprite = self.lock:GetComponent(UISprite)
	self.bg = self:FindGO("Bg")
	self.bg_UISprite = self.bg:GetComponent(UISprite)
	self.level = self:FindGO("SkillLevel"):GetComponent(UILabel)
	self.level_UILabel = self.level
	self.cdTimerID = ShortCutSkill.INVALIDTIMEID
	self.container = nil
	self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
	self.dragDrop.dragDropComponent.data = self
	self.dragDrop.dragDropComponent.OnReplace = function(obj)
		if(obj~=nil) then
			self:DispatchEvent(DragDropEvent.SwapObj,{source=obj,target=self})
		end
	end
	self.dragDrop.dragDropComponent.OnDropEmpty = function(obj)
		if(obj.type == UIDragItem.DragDropType.Target or obj.type == UIDragItem.DragDropType.Both) then
			self:DispatchEvent(DragDropEvent.DropEmpty,self)
		end
	end

	self.dragDrop.dragDropComponent.GetObserved = function()
		return self
	end

	self:SetEvent(self.gameObject,function ()
		if(self.lock.activeSelf) then
			MsgManager.ShowMsgByIDTable(988)
		end
	end)
end

function ShortCutSkillDragCell:CanUseSkill()
	if(self.data ~= nil) then
		return self.data:getCdTime()==0 and not self.data.shadow
	end
end

function ShortCutSkillDragCell:UpdateDragable()
	if(self.data==nil) then
		self.dragDrop:SetDragEnable(false)
	else
		self.dragDrop:SetDragEnable((self.data:getLevel()>0 and self.data.staticData.SkillType ~= GameConfig.SkillType.Passive.type)==true)
	end
end

function ShortCutSkillDragCell:SetDragEnable(b)
	self.dragDrop:SetDragEnable(b)
end

function ShortCutSkillDragCell:IsLocked(shortcutGroupID)
	return ShortCutProxy.Instance:SkillIsLocked(self.data:GetPosInShortCutGroup(shortcutGroupID),shortcutGroupID)
end

function ShortCutSkillDragCell:SetData(obj)
	self.data = obj
	if(self.data==nil) then
		self:ResetCdEffect()
		self:SwitchShowBG(true)
	else
		if(self.data.staticData~=nil) then
			IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.icon,MyselfProxy.Instance:GetMyProfessionType(),true)
			self:SwitchShowBG(false)
		else
			self.icon.spriteName = nil
			self:SwitchShowBG(true)
		end
		
		-- self:NeedHide(ShortCutProxy.Instance:SkillIsLocked(self.data.pos))
		if(self.data.staticData) then
			self.level.text = "LV."..self.data.staticData.Level
		end
		if(self.data.staticData==nil or (self.data:HasNextID(MyselfProxy.Instance:HasJobBreak())==false and self.data.staticData.Level <= 1)) then
			self:Hide(self.level.gameObject)
		end
		self:UpdateLost()
	end
	self:UpdateDragable()
end

function ShortCutSkillDragCell:SwitchShowBG(val)
	if(val)then
		self:Show(self.bg)
		self:Hide(self.icon.gameObject)
	else
		self:Hide(self.bg)
		self:Show(self.icon.gameObject)
	end
end

function ShortCutSkillDragCell:UpdateLost()
	if(self.data and self.data.shadow) then
		ColorUtil.ShaderGrayUIWidget(self.icon)
	else
		ColorUtil.WhiteUIWidget(self.icon)
	end
end

function ShortCutSkillDragCell:NeedHide(val)
	self.icon.gameObject:SetActive(not val)
	self.level.gameObject:SetActive(not val)
	self.lock:SetActive(val)
	if(val) then
		self.dragDrop:SetDragEnable(false)
	end
	-- self.gameObject:SetActive(not val)
end

function ShortCutSkillDragCell:OnRemove()
	self:ResetCdEffect()
end

function ShortCutSkillDragCell:ResetCdEffect()
end

function ShortCutSkillDragCell:AddDepth(addDepth)
	self.icon_UISpirte.depth = self.icon_UISpirte.depth+addDepth
	self.lock_UISprite .depth = self.lock_UISprite .depth+addDepth
	self.bg_UISprite.depth = self.bg_UISprite.depth+addDepth
	self.level_UILabel.depth = self.level_UILabel.depth+addDepth
end

function ShortCutSkillDragCell:HideLock()
	self.lock_UISprite.gameObject:SetActive(false)
end

function ShortCutSkillDragCell:HideBg()
	self.bg.gameObject:SetActive(false)
end

function ShortCutSkillDragCell:SetScale(scale)
	self.gameObject.transform.localScale = scale
end

AutoShortCutSkillDragCell = class("AutoShortCutSkillDragCell",ShortCutSkillDragCell)

function AutoShortCutSkillDragCell:Init()
	self.switchWhite = true
	AutoShortCutSkillDragCell.super.Init(self)
	self.dragDrop.dragDropComponent.OnStart = function (data)
		if(self:IsLocked()) then
			self.dragDrop.dragDropComponent:StopDrag()
		end
		-- if(self.data.staticData.SkillType == GameConfig.SkillType.Passive.type) then
		-- 	self.dragDrop.dragDropComponent:StopDrag()
		-- 	MsgManager.ShowMsgByIDTable(601)
		-- end
	end
end

function AutoShortCutSkillDragCell:IsLocked()
	return self.data:IsAutoShortCutLocked()
end

function AutoShortCutSkillDragCell:SetData(obj)
	self.data = obj
	if(self.data==nil) then
		self:ResetCdEffect()
	else
		if(self.data.staticData~=nil) then
			IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.icon,MyselfProxy.Instance:GetMyProfessionType(),true)
		else
			self.icon.spriteName = nil
		end
		self:NeedHide(self.data:IsAutoShortCutLocked())
		if(self.data.staticData) then
			self.level.text = "LV."..self.data.staticData.Level
		end
		if(self.data.staticData==nil or (self.data:HasNextID(MyselfProxy.Instance:HasJobBreak())==false and self.data.staticData.Level <= 1)) then
			self:Hide(self.level.gameObject)
		end
		self:UpdateLost()
		-- print(self.data.id,self.data.autopos)
	end
	self:UpdateDragable()
end

-- value:true 原色 false 灰色
function AutoShortCutSkillDragCell:SwitchWhiteOrGray(value)
	if(self.switchWhite~=value) then
		self.switchWhite=value
		if(value) then
			ColorUtil.WhiteUIWidget(self.icon)
			ColorUtil.BlackLabel(self.level)
		else
			ColorUtil.ShaderGrayUIWidget(self.icon)
			ColorUtil.GrayUIWidget(self.level)
		end
	end
end

function AutoShortCutSkillDragCell:UpdateLost()
	if(self.data and self.data.shadow) then
		ColorUtil.ShaderGrayUIWidget(self.icon)
	elseif(self.switchWhite) then
		ColorUtil.WhiteUIWidget(self.icon)
	end
end

function AutoShortCutSkillDragCell:NeedHide(val)
	self.icon.gameObject:SetActive(not val)
	self.level.gameObject:SetActive(not val)
	if(self.data ~= nil and self.data.staticData ~= nil) then
		if(self:IsLocked()) then
			self.icon.gameObject:SetActive(true)
			self.level.gameObject:SetActive(true)
			self:SwitchWhiteOrGray(false)
		else
			self:SwitchWhiteOrGray(true)
		end
	end
	self.lock:SetActive(val)
	if(val) then
		self.dragDrop:SetDragEnable(false)
	end
	-- self.gameObject:SetActive(not val)
end


BeingAutoShortCutSkillDragCell = class("BeingAutoShortCutSkillDragCell",ShortCutSkillDragCell)

function BeingAutoShortCutSkillDragCell:SetData(data)
	self:NeedHide(false)
	BeingAutoShortCutSkillDragCell.super.SetData(self,data)
end

function BeingAutoShortCutSkillDragCell:IsLocked()
	return false
end


