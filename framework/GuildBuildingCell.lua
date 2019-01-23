local baseCell = autoImport("BaseCell")
GuildBuildingCell = class("GuildBuildingCell", baseCell)

GuildBuildingCell.GuildBtn = "guild_btn_build"
GuildBuildingCell.UpgradeBtn = "guild_btn_upgrade"
local MAX_WIDTH = 170

function GuildBuildingCell:Init()
	self:FindObjs()
	self:AddEvts()
end

function GuildBuildingCell:FindObjs()
	self.name = self:FindGO("nameLv"):GetComponent(UILabel)
	self.icon = self:FindComponent("icon", UITexture)
	self.iconBg = self:FindComponent("iconBg",UITexture)
	self.btn = self:FindComponent("btn",UISprite)
	self.menu = self:FindGO("menu")
	self.menuDesc = self:FindComponent("menuDesc",UILabel)

	self.submitIncTag = self:FindGO("SubmitIncTag");
	self.submitIncTag_Count = self:FindComponent("SubmitIncTag_Count", UILabel, self.submitIncTag);
end

function GuildBuildingCell:AddEvts()
	self:AddClickEvent(self.btn.gameObject, function ()
		if(self.data and nil==self.data:GetCondMenu())then
			self:PassEvent(GuildBuildingEvent.OnClickBuildBtn, self)
		end
	end)
	self:AddCellClickEvent()
end

local iconBgTex = "guild_bg_05"
local tempVector3 = LuaVector3.zero
function GuildBuildingCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(nil~=data and nil~=data.staticData)
	if data and data.staticData then
		if(not data.isbuilding)then
			self.name.text=self.data.staticData.Level>0 and string.format(ZhString.GuildBuilding_Title,data.staticData.Name,data.staticData.Level) or data.staticData.Name;
			local HasAuthorization = GuildBuildingProxy.Instance:HasAuthorization()
			if(HasAuthorization)then
				self:Show(self.btn)
				self.btn.spriteName = 0==self.data.staticData.Level and GuildBuildingCell.GuildBtn or GuildBuildingCell.UpgradeBtn
				tempVector3:Set(-35,-120,0)
			else
				tempVector3:Set(0,-120,0)
				self:Hide(self.btn)
			end
		else
			tempVector3:Set(0,-120,0)
			self:Hide(self.btn)
			self.name.text = 0==self.data.staticData.Level and ZhString.GuildBuilding_isBuilding or ZhString.GuildBuilding_isUpLevel
		end
		self.name.gameObject.transform.localPosition = tempVector3
		UIUtil.FitLabelHeight(self.name,MAX_WIDTH)
		local textueName = data.staticData.Texture
		if(not textueName or ''==textueName)then
			textueName="Rewardtask_bg_06"
		end
		PictureManager.Instance:SetGuildBuilding(textueName, self.icon)
		PictureManager.Instance:SetGuildBuilding(iconBgTex,self.iconBg)

		self:UpdateSubmitIncTag();

		self.menu:SetActive(nil~=data:GetCondMenu())
		self.menuDesc.text = data:GetCondMenu() or ""
	end
end

function GuildBuildingCell:UpdateSubmitIncTag()
	local d = self.data;
	if(d == nil or d.staticData == nil)then
		self.submitIncTag:SetActive(false);
		return;
	end
	local aedata = ActivityEventProxy.Instance:GetGuildBuildingEventData();
	if(aedata == nil or not aedata:IsInActivity())then
		self.submitIncTag:SetActive(false);
		return;
	end
	if(not aedata:CheckEffectByGuildBuildingLevel(d.staticData.Level) or 
		not aedata:CheckEffectByGuildBuildingType(d.staticData.Type))then
		self.submitIncTag:SetActive(false);
		return;
	end
	local submitInc = aedata:GetSubmitInc() or 0;
	if(submitInc == 0)then
		self.submitIncTag:SetActive(false);
		return;
	end
	self.submitIncTag:SetActive(true);
	self.submitIncTag_Count.text = submitInc;
end

function GuildBuildingCell:OnDestroy()
	PictureManager.Instance:UnloadGuildBuilding()
end

