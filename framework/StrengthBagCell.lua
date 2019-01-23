local BaseCell = autoImport("BaseCell");
StrengthBagCell = class("StrengthBagCell", BaseCell)

function StrengthBagCell:Init()
	self:FindObjs();
	self:AddClickEvt()
end

function StrengthBagCell:AddClickEvt()
	self:SetEvent(self.bg.gameObject,function ()
		self:DispatchEvent(MouseEvent.MouseClick)
	end)
end

function StrengthBagCell:FindObjs()
	self.quality = self:FindChild("Quality"):GetComponent(UISprite);
	self.icon = self:FindChild("Icon"):GetComponent(UISprite);
	self.numLab = self:FindChild("Level"):GetComponent(UILabel);
	self.selectBg = self:FindChild("Select")
	self.bg = self:FindChild("Bg")
	local longPress = self.bg:GetComponent(UILongPress)
	if(longPress)then
		longPress.pressEvent = function ( obj,state )
			if(state)then
				TipManager.Instance:ShowItemTip(self.data,{},self.bg:GetComponent(UISprite),NGUIUtil.AnchorSide.Left,{-200,0})
			else
				TipManager.Instance:CloseItemTip()
			end
		end
	end
	self.emptyBg = self:FindChild("Empty")
end

function StrengthBagCell:Select()
	self:Show(self.selectBg.gameObject)
end

function StrengthBagCell:UnSelect()
	self:Hide(self.selectBg.gameObject)
end

function StrengthBagCell:SetData(data)
	self.data = data
	if(data == nil and self.site ~= nil)then
		self:Hide(self.quality.gameObject)
		self:Hide(self.emptyBg)
		self.numLab.text = ""
		return
	elseif(data ==nil)then
		self:Hide(self.icon.gameObject)
		self:Hide(self.quality.gameObject)		
		self.numLab.text = ""
		return
	end

	if(data.equipInfo == nil)then		
		self:Show(self.emptyBg)
		self:Hide(self.bg)
		self:Hide(self.icon.gameObject)
		self:Hide(self.quality.gameObject)
		self.numLab.text = ""
		return
	end
	if(self.emptyBg ~= nil)then
		self:Hide(self.emptyBg)
	end
	self:Show(self.bg)
	self:Show(self.icon.gameObject)
	self:Show(self.quality.gameObject)
	IconManager:SetItemIcon(self.data.staticData.Icon, self.icon)
	self.icon:MakePixelPerfect()
	self.icon.transform.localScale = Vector3(0.8,0.8,1)
	if(self.data.equipInfo.strengthlv==0) then
		self.numLab.text = ""
	else
		self.numLab.text = ""..self.data.equipInfo.strengthlv
	end
	local qInt = self.data.staticData.Quality;
	self.quality.color = CustomColor.ItemQualityColor[qInt];

end

function StrengthBagCell:SetIconType( site )
	-- body	
	self.site = site
	self.icon.spriteName = "bag_equip_"..self.site
	print("bag_equip_"..self.site)
	self.icon:MakePixelPerfect()
	self:Show(self.icon.gameObject)
	self.icon.transform.localScale = Vector3(0.8,0.8,1)
end
