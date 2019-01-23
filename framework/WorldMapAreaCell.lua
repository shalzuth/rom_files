local baseCell=autoImport("BaseCell");
WorldMapAreaCell = class("WorldMapAreaCell", baseCell)

autoImport("ActivityMapSymbolCell");

local tempTable = {};

function WorldMapAreaCell:Init()
	self:InitCells();
end

function WorldMapAreaCell:InitCells()
	self.mapSymbols = self:FindGO("MapSymbols");

	self.mapName = self:FindComponent("MapName", UILabel);
	self.sealSymbol = self:FindComponent("SealSymbol", UISprite);
	self.mask = self:FindGO("Mask");

	self.questSymbolGrid = self:FindComponent("QuestGrid", UIGrid);
	self.questSymbol1 = self:FindGO("Symbol1", self.questSymbolGrid.gameObject);
	self.questSymbol2 = self:FindGO("Symbol2", self.questSymbolGrid.gameObject);
	self.questSymbol3 = self:FindGO("Symbol3", self.questSymbolGrid.gameObject);

	self.memberSymbol = self:FindGO("MemberSymbol");
	self.memberNum = self:FindComponent("MemberNum", UILabel);

	self:SetEvent(self.gameObject, function ()
		if(type(self.data)=="table" and self.data.isactive)then
			self:PassEvent(MouseEvent.MouseClick, self);
			
			self:RemoveGuideGO();
		end
	end);

	local grid = self:FindComponent("ActivityGrid", UIGrid);
	self.activityCtl = UIGridListCtrl.new(grid, ActivityMapSymbolCell, "ActivityMapSymbolCell");

	self.effectContainer = self:FindComponent("EffectContainer", ChangeRqByTex);
end

function WorldMapAreaCell:SetData(data)
	self.data = data;
	
	self.index = nil;
	self.mNum = 0;
	self:Hide(self.memberSymbol);

	if(type(data)=="table" and data.isactive)then
		self.index = data.staticData.Position[1]*data.staticData.Position[2];

		self:SetCellInfoActive(true);
		self.mapName.text = data.staticData.NameZh;

		self:IsExplored(true)
	else
		self.index = data;

		self:SetCellInfoActive(false);
		self:IsExplored(false)
	end

	self:UpdateQuestSymbol();
	self:UpdateSealSymbol();
	self:UpdateMapActivitys();

	self:UpdateMapGuide();
end

function WorldMapAreaCell:UpdateQuestSymbol()
	if(type(self.data)~="table" or not self.data.isactive)then
		self.questSymbol1:SetActive(false);
		return;
	end

	if(QuestSymbolCheck.HasQuestSymbolByMap(self.data.mapid))then
		self.questSymbol1:SetActive(true);
		return;
	end

	local childMaps = self.data.childMaps;
	if(childMaps)then
		for i=1,#childMaps do
			local childid = childMaps[i] and childMaps[i].id;
			if(QuestSymbolCheck.HasQuestSymbolByMap(childid))then
				self.questSymbol1:SetActive(true);
				return;
			end
		end
	end

	self.questSymbol1:SetActive(false);
end

function WorldMapAreaCell:IsExplored(v)
	if(v) then
		if(self.data) then
			self.mapName.text = self.data.staticData.NameZh;
		end
		self:Hide(self.mask);
	else
		self.mapName.text = nil;
		self:Show(self.mask);
	end
end

local tempV3 = LuaVector3();
function WorldMapAreaCell:AddMapTeamMember()
	self.mNum = self.mNum + 1;

	self:Show(self.memberSymbol);
	self.memberNum.text = self.mNum;

	if(self.sealSymbol.gameObject.activeSelf)then
		tempV3:Set(42,0,0);
		self.sealSymbol.transform.localPosition = tempV3;
	end
end

function WorldMapAreaCell:SetCellInfoActive(isVisible)
	self.mapSymbols:SetActive(isVisible);
end

function WorldMapAreaCell:UpdateSealSymbol()
	if(type(self.data)~="table")then
		self.sealSymbol.gameObject:SetActive(false);
		return;
	end

	self.sealSymbol.gameObject:SetActive(false);
	tempV3:Set(42,42,0);
	self.sealSymbol.transform.localPosition = tempV3;
	
	local hasSeal, issealing = self:CheckHasSealByMapId(self.data.mapid);
	if(hasSeal)then
		self.sealSymbol.gameObject:SetActive(true);
		if(issealing)then
			self.sealSymbol.spriteName = "seal_icon_02";
			return;
		else
			self.sealSymbol.spriteName = "seal_icon_01";
		end
	end

	local childMaps = self.data.childMaps;
	if(type(childMaps)=="table")then
		for i=1,#childMaps do
			local childid = childMaps[i] and childMaps[i].id;
			hasSeal, issealing = self:CheckHasSealByMapId(childid);
			if(hasSeal)then
				self.sealSymbol.gameObject:SetActive(true);
				if(issealing)then
					self.sealSymbol.spriteName = "seal_icon_02";
					return;
				else
					self.sealSymbol.spriteName = "seal_icon_01";
				end
			end
		end
	end
end

function WorldMapAreaCell:CheckHasSealByMapId(mapid)
	local hasSeal, issealing = false, false;
	local sealData = SealProxy.Instance:GetSealData(mapid);
	if(sealData)then
		for _,item in pairs(sealData.itemMap)do
			hasSeal = true;
			if(item.issealing)then
				issealing = true;
				break;
			end
		end
	end
	return hasSeal, issealing;
end

function WorldMapAreaCell:GetNowAreaActivityDatas()
	if(not self.activityDatas)then
		self.activityDatas = {};
	else
		TableUtility.ArrayClear(self.activityDatas);
	end

	if(type(self.data)~="table")then
		return self.activityDatas;
	end

	TableUtility.TableClear(tempTable);

	local p_Events = FunctionActivity.Me():GetMapEvents(self.data.mapid)
	for etype,edata in pairs(p_Events)do
		if(edata.running and edata:GetMapInfo())then
			tempTable[etype] = edata;
		end
	end

	local childMaps = self.data.childMaps;
	if(childMaps)then
		for i=1,#childMaps do
			local c_Events = FunctionActivity.Me():GetMapEvents(childMaps[i].id)
			for etype,edata in pairs(c_Events)do
				if(edata.running and edata:GetMapInfo())then
					tempTable[etype] = edata;
				end
			end
		end
	end
	for etype, edata in pairs(tempTable)do
		table.insert(self.activityDatas, edata)
	end
	return self.activityDatas;
end

function WorldMapAreaCell:UpdateMapActivitys()
	self.activityCtl:ResetDatas(self:GetNowAreaActivityDatas());
end


function WorldMapAreaCell:UpdateMapGuide()
	local matched = false;

	local guideMapId = FunctionGuide.Me():GetGuildMapId();
	if(guideMapId ~= nil)then
		if(type(self.data) == "table")then
			matched = guideMapId == self.data.mapid;
			if(matched == false)then
				local childMaps = self.data.childMaps;
				if(childMaps ~= nil)then
					for i=1,#childMaps do
						if(childMaps[i].id == guideMapId)then
							matched = true;
							break;
						end
					end
				end
			end
		end
	end

	if(matched == true)then
		if(self.guildGO == nil)then
			local effectPath = ResourcePathHelper.EffectUI("57MapSelected");
			
			self.guildGO = Game.AssetManager_UI:CreateAsset(effectPath, self.gameObject);
			local go = self:FindGO("UI_daquan_alpha", self.guildGO);
			go.transform.localPosition = LuaVector3.zero;
			self.guildGO.gameObject:SetActive(true);

			self.effectContainer:AddChild(self.guildGO.gameObject);
		end
	else
		self:RemoveGuideGO();
	end
end

function WorldMapAreaCell:RemoveGuideGO()
	if(self.guildGO)then
		GameObject.Destroy(self.guildGO);
		self.guildGO = nil;
	end
end

