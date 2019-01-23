local baseCell = autoImport("BaseCell")
GuildBuildingMatSubmitCell = class("GuildBuildingMatSubmitCell", baseCell)

local cellPath = ResourcePathHelper.UICell("GuildBuildingMatSubmitCell");
local textureName = 'guild_bg_06'
local scaleRate = 0.5
local PACKAGE_MATERIAL = GameConfig.PackageMaterialCheck.guildBuilding or {1,11}
function GuildBuildingMatSubmitCell:Init()
	self:FindObjs()
	self:AddCellClickEvent()
	self:SetChoosed(scaleRate,false)
end

function GuildBuildingMatSubmitCell:FindObjs()
	self.name = self:FindGO("name"):GetComponent(UILabel)
	self.icon = self:FindComponent("icon", UISprite)
	self.texture = self:FindComponent("tex",UITexture)
	self.choosedImg = self:FindGO("choosedImg")
	self.rewardIcon = self:FindComponent("rewardIcon",UISprite)
	self.rewardCount = self:FindComponent("rewardCount",UILabel)
	self.content = self:FindGO("Content");
	self:AddButtonEvent("submitBtn",function (  )
		self:PassEvent(GuildBuildingEvent.SubmitMaterial, self)
	end)
	self:AddButtonEvent("tex",function (  )
		self:PassEvent(MouseEvent.MouseClick, self)
	end)
	self:AddCellClickEvent()
end

function GuildBuildingMatSubmitCell:InitTexture()
	PictureManager.Instance:SetGuildBuilding(textureName, self.texture)
end

function GuildBuildingMatSubmitCell:SetChoosed(scale,showBg)
	if(self.gameObject)then
		self.gameObject.transform.localScale = Vector3.one * scale
		self.choosedImg:SetActive(showBg)
	end
end

function GuildBuildingMatSubmitCell:SetData(data,flag)
	self.data = data
	if(data)then
		self.content:SetActive(true);
		self:InitTexture()
		if data.materials and data.materials.id and data.unitCount then
			IconManager:SetItemIcon(Table_Item[data.materials.id].Icon,self.icon);
			local ownCount = BagProxy.Instance:GetItemNumByStaticID(data.materials.id,PACKAGE_MATERIAL)
			local curSubmitTime = GuildBuildingProxy.Instance.curSubmitTime or 0
			local num = CommonFun.calcGuildBuildingMaterialItemCount(data.unitCount,curSubmitTime+1)
			self.name.text = flag and string.format(ZhString.GuildBuilding_Submit_Name,Table_Item[data.materials.id].NameZh,ownCount,num) or string.format(ZhString.GuildBuilding_Submit_MatNum,ownCount,num)
		end
		local teamId = data.rewardData
		if(teamId)then
			local items = ItemUtil.GetRewardItemIdsByTeamId(teamId)
			if(items and items[1])then
				local singleItem = items[1]
				local rewardIconName = Table_Item[singleItem.id] and Table_Item[singleItem.id].Icon or "item_100"
				IconManager:SetItemIcon(rewardIconName,self.rewardIcon)

				self:UpdateRewardCount(singleItem.num);
			end
		end
	else
		self.content:SetActive(false);
	end
end

function GuildBuildingMatSubmitCell:UpdateRewardCount( num )
	local d = self.data;
	if(d == nil)then
		self.rewardCount.text=num
		return;
	end
	local aedata = ActivityEventProxy.Instance:GetGuildBuildingEventData();
	if(aedata == nil or not aedata:IsInActivity())then
		self.rewardCount.text=num
		return;
	end
	if(not aedata:CheckEffectByGuildBuildingLevel(d.building_level) or 
		not aedata:CheckEffectByGuildBuildingType(d.building_type))then
		self.rewardCount.text=num
		return;
	end
	local rewardInc = aedata:GetRewardInc() or 0;
	if(rewardInc == 0)then
		self.rewardCount.text=num
		return;
	end
	self.rewardCount.text="[c][FFA10CFF]" .. math.floor(num*(1+rewardInc/100)) .. "[-][/c]";
end

function GuildBuildingMatSubmitCell:OnDestroy()
	PictureManager.Instance:UnloadGuildBuilding()
end




