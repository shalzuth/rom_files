Astrolabe_PointCell = class("Astrolabe_PointCell", BaseCell);

Astrolabe_PointCell.Rid = ResourcePathHelper.UICell("Astrolabe_PointCell");
Astrolabe_PointCell.Point_Mask_Path = ResourcePathHelper.UICell("Astrolabe_PointCell_mask");

Astrolabe_PlateData_Event = {
	ClickPoint = "Astrolabe_PlateData_Event_ClickPoint",
}

Astrolabe_Point_IconMap = {
	[0] = {"Rune_Locked_St", "Rune_Off_St", "Rune_On_St"},
	[1] = {"Rune_Locked_1", "Rune_Off_1", "Rune_On_1"},
	[2] = {"Rune_Locked_2", "Rune_Off_2", "Rune_On_2"},
	[3] = {"Rune_Locked_3", "Rune_Off_3", "Rune_On_3"},
	[4] = {"Rune_Locked_4", "Rune_Off_4", "Rune_On_4"},
	[5] = {"Rune_Locked_5", "Rune_Off_5", "Rune_On_5"},
	[6] = {"Rune_Locked_6", "Rune_Off_6", "Rune_On_6"},
}

local tempV3 = LuaVector3();
function Astrolabe_PointCell:ctor()
	self.gameObject = Game.AssetManager_UI:CreateAstrolabeAsset(Astrolabe_PointCell.Rid);
	self.gameObject:SetActive(false);

	self.bg = self.gameObject:GetComponent(UISprite);
	self.attriGO = self:FindGO("AttriTip");
	self.attrilabel = self.attriGO:GetComponent(UILabel);

	self:AddClickEvent(self.gameObject, function ()
		if(self.data)then
			self:PassEvent(Astrolabe_PlateData_Event.ClickPoint, self);
		end
	end, {hideClickSound = true});
end

function Astrolabe_PointCell:SetData(data, priStateMap, bordData)
	self.data = data;
	if(data)then
		tempV3:Set(data:GetLocalPos_XYZ());
		self.gameObject.transform.localPosition = tempV3;

		self.gameObject.name = "Point_" .. data.id;

		local index = data:GetIconIndex();
		
		local spName = Astrolabe_Point_IconMap[index];
		if(spName)then
			local state = priStateMap and priStateMap[data.guid];
			if(state == nil)then
				state = data:GetState();

				-- 特殊处理
				local hasValue = priStateMap and next(priStateMap);
				if(state == Astrolabe_PointData_State.Off and hasValue)then
					local isValid = false;

					local innerConnect = data:GetInnerConnect();
					local connectId, guid, pointData, nearState;
					for i=1,#innerConnect do
						connectId = innerConnect[i];
						guid = data.plateid * 10000 + connectId;
						nearState = priStateMap[guid];
						if(nearState == nil)then
							pointData = bordData:GetPointByGuid(guid);
							nearState = pointData:GetState();
						end
						if(nearState == Astrolabe_PointData_State.On)then
							isValid = true;
							break;
						end
					end

					if(isValid == false)then
						state = Astrolabe_PointData_State.Lock;
					end
				end
			end

			self.bg.spriteName = spName[state];
			self.bg:MakePixelPerfect();
		end

		local effect = data:GetEffect();
		if(effect)then
			local str = "";
			for attriType, value in pairs(effect) do
				local PropNameConfig = Game.Config_PropName

				local config = PropNameConfig[ attriType ];
				if(config ~= nil)then
					local displayName = config.RuneName ~= "" and config.RuneName or config.PropName;
					str = str .. displayName;
					if(value > 0)then
						str = str .. " +"
					end
					if(config.IsPercent==1)then
						str = str .. value * 100 .. "%";
					else
						str = str .. value;
					end
				else
					redlog("Canot Find Attri" .. attriType .. " ID:" .. data.guid);
				end
			end
			self.attrilabel.text = str;
		else
			self.attrilabel.text = "";
		end
		-- self.attrilabel.text = self.data.guid;
	end
end

local PointMask_SpriteName = {
	[1] = "xingpan_bg_chongzhi",
	[2] = "xingpan_bg_jihuo2",
	[3] = "xingpan_bg_jihuo",
}
local Special_PointMask_SpriteName = {
	[1] = "xingpan_bg_chongzhib",
	[2] = "xingpan_bg_jihuo2b",
	[3] = "xingpan_bg_jihuob",
}
function Astrolabe_PointCell:SetMaskType(type)
	if(self.data:IsActive())then
		if(type == 2 or type == 3)then
			return;
		end
	else
		if(type == 1)then
			return;
		end
	end

	if(type and PointMask_SpriteName[type])then
		if(self.mask == nil)then
			local mask = Game.AssetManager_UI:CreateAstrolabeAsset(self.Point_Mask_Path, self.gameObject.transform);
			mask.transform.localPosition = LuaGeometry.Const_V3_zero;
			mask.transform.localRotation = LuaGeometry.Const_Qua_identity;
			mask.transform.localScale = LuaGeometry.Const_V3_one;

			self.mask = mask:GetComponent(UISprite);
		end

		local index = self.data:GetIconIndex();

		if(index == 0 or index == 5 or index == 6)then
			self.mask.spriteName = Special_PointMask_SpriteName[type];
		else
			self.mask.spriteName = PointMask_SpriteName[type];
		end
		self.mask:MakePixelPerfect();
	else
		self:RemoveMask();
	end
end

function Astrolabe_PointCell:RemoveMask()
	if(not Slua.IsNull(self.mask) )then
		Game.GOLuaPoolManager:AddToAstrolabePool(self.Point_Mask_Path, self.mask.gameObject);
	end
	self.mask = nil;
end

function Astrolabe_PointCell:ActiveAttriInfo(b)
	self.attriGO:SetActive(b);
end

function Astrolabe_PointCell:IsClickMe(obj)
	if(obj == self.gameObject)then
		return true;
	end
	return false;
end

function Astrolabe_PointCell:OnAdd(parent)
	self.gameObject.transform:SetParent(parent.transform, false);

	self.gameObject.transform.localScale = LuaGeometry.Const_V3_one;
	self.gameObject:SetActive(true);
end

function Astrolabe_PointCell:OnRemove()
	self.gameObject:SetActive(false);

	self:RemoveMask();

	AstrolabeCellPool.Instance:AddToTempPool(self.gameObject);
end

function Astrolabe_PointCell:OnDestroy()
	if(not Slua.IsNull(self.gameObject))then
		self:RemoveMask();

		self.gameObject:SetActive(false);
		Game.GOLuaPoolManager:AddToAstrolabePool(Astrolabe_PointCell.Rid , self.gameObject);
	end
end