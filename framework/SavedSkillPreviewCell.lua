autoImport("ShotCutSkillTip")
autoImport("SkillSaveData")
autoImport("BaseCell")
SavedSkillPreviewCell = class("SavedSkillPreviewCell",BaseCell)

function SavedSkillPreviewCell:Init()

	self.icon = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "Icon"):GetComponent(UISprite)
	self.bg = self:FindGO("Bg")
	self.clickObj = self:FindGO("Click")
	self.clickObjBtn = self:FindGO("Click"):GetComponent(UIButton)
	self.bgSp = self.bg:GetComponent(UISprite)

	local click = function(obj)
		redlog("click")
		self:DispatchEvent(MouseEvent.MouseClick, self)
	end
	local press = function(obj,state)
		redlog("start to press")
		if state and self.data~=nil and self.data.staticData ~=nil then
			if(ShortCutProxy.Instance:GetUnLockSkillMaxIndex()-self.indexInList < 4) then
				TipsView.Me():ShowStickTip(ShotCutSkillTip,self.data,NGUIUtil.AnchorSide.TopRight,self.bgSp,{-203,-20})
			else
				TipsView.Me():ShowStickTip(ShotCutSkillTip,self.data,NGUIUtil.AnchorSide.TopLeft,self.bgSp,{205,-20})
			end
		else
			TipsView.Me():HideTip(ShotCutSkillTip)
		end
	end
	self.longPress = self.clickObj:GetComponent(UILongPress)
	self.longPress.pressEvent = press
	self:SetEvent(self.clickObj,click)
end

function SavedSkillPreviewCell:SetData(skillsavedata)
	self.data = skillsavedata
	if self.data==nil then
		self.icon.spriteName = nil
	else
		if self.data.staticData ~= nil then
			local professionType = Table_Class[self.data.profession].Type
			IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.icon,professionType,true)
		else
			self.icon.spriteName = nil
		end
	end
end