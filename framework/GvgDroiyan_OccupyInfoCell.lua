local BaseCell = autoImport("BaseCell");
GvgDroiyan_OccupyInfoCell = class("GvgDroiyan_OccupyInfoCell", BaseCell);

local UI_SliderOffset = 3;

local superGvgProxy;
local robTotalValue;
function GvgDroiyan_OccupyInfoCell:Init()
	self.occupy_sps = {};
	for i=1,4 do
		self.occupy_sps[i] = self:FindComponent("Occupy_" .. i, UISprite) 
	end

	self.sliderBg = self:FindComponent("SliderBg", UISprite);

	self.slider_length = self.sliderBg.width - UI_SliderOffset * 2;

	superGvgProxy = SuperGvgProxy.Instance;
	robTotalValue = GameConfig.GvgDroiyan and GameConfig.GvgDroiyan.RobPlatform_RobValue or 1800;
end

local testMode = true;

function GvgDroiyan_OccupyInfoCell:SetData(id)
	if(id == nil)then
		self:HideSelf();
		return;
	end

	self.id = id;
	
	self:ShowSelf();
	self:Refresh();
end

function GvgDroiyan_OccupyInfoCell:Refresh()
	local id = self.id;

	if(id == nil)then
		return;
	end

	-- if(testMode)then
	-- 	self:SetOccupySlider({ 0.1, 0.2, 0.35, 0.1 });
	-- 	return;
	-- end

	local clientGvgTowerData = superGvgProxy:GetClientTowerData(id);
	if(clientGvgTowerData == nil)then
		redlog("ClientGvgTowerData Not Find!", id);
		self:HideSelf();
		return;
	end

	local robInfos = clientGvgTowerData.infos;
	if(robInfos == nil)then
		redlog("RobInfos Not Find!", id);
		self:HideSelf();
		return;
	end

	local values = ReusableTable.CreateTable()
	for k,v in pairs(robInfos)do
		local index = superGvgProxy:GetIndexByGuildId(v.guildid);
		if(index)then
			values[index] = v.value/robTotalValue;
		end
	end
	self:SetOccupySlider(values);
	ReusableTable.DestroyTable(values);
end

local tempV3 = LuaVector3();
function GvgDroiyan_OccupyInfoCell:SetOccupySlider(values)

	local total_ocuvalue = 0;
	local ocu_value;
	for i=1,4 do
		ocu_value = values[i] or 0;

		local sp = self.occupy_sps[i];
		tempV3:Set(self.slider_length * total_ocuvalue + UI_SliderOffset, 0, 0 );
		sp.transform.localPosition = tempV3;
		local width = math.ceil(ocu_value * self.slider_length);
		if(width > 2)then
			sp.gameObject:SetActive(true);
			sp.width = width;
		else
			sp.gameObject:SetActive(false);
		end
		
		total_ocuvalue = total_ocuvalue + ocu_value;
	end

end

function GvgDroiyan_OccupyInfoCell:ShowSelf()
	if(Slua.IsNull(self.gameObject))then
		return;
	end

	if(self.active == true)then
		return;
	end

	self.active = true;

	self.gameObject:SetActive(true);

	if(self.id ~= nil)then
		SuperGvgProxy.Instance:Active_QueryTowerInfo(self.id, true)
	end


	EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.Refresh, self)
	EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.Refresh, self)
end

function GvgDroiyan_OccupyInfoCell:HideSelf()
	if(Slua.IsNull(self.gameObject))then
		return;
	end
	if(self.active == false)then
		return;
	end
	
	self.active = false;

	self.gameObject:SetActive(false);

	if(self.id ~= nil)then
		SuperGvgProxy.Instance:Active_QueryTowerInfo(self.id, false)
		self.id = nil;
	end

	EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.Refresh, self)
	EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.Refresh, self)
end
