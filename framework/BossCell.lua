local BaseCell = autoImport("BaseCell");
BossCell = class("BossCell", BaseCell)

BossIconType = {
	Mvp = "map_mvpboss",
	Mini = "map_miniboss",
}


function BossCell:Init()
	self:FindObjs();
	self:AddCellClickEvent();
end

function BossCell:FindObjs()
	self.icon = self:FindGO("icon"):GetComponent(UISprite);
	self.level = self:FindGO("level"):GetComponent(UILabel);
	self.time = self:FindGO("time"):GetComponent(UILabel);
	self.killer = self:FindGO("killer"):GetComponent(UILabel);
	self.map = self:FindComponent("map", UILabel);
	self.icontype = self:FindComponent("icontype", UISprite);
	
	self.chooseSymbol = self:FindGO("ChooseSymbol");

	self.content = self:FindGO("Content");
end

function BossCell:SetData(data)
	self.data = data;

	if(data)then
		self.content:SetActive(true);

		local monster = Table_Monster[data.id];
		self:UpdateInfo(monster);

		if(data.killer == nil or data.killer == "")then
			self.killer.text = "--";
		else
			self.killer.text = data.killer;
		----[[ todo xde 不翻译玩家名字
			self.killer.text = AppendSpace2Str(data.killer)
			--]]
		end
		self:UpdateTime(data.time);

		local mapid = data.mapid or data.staticData.Map[1];
		if(mapid)then
			local mapdata = Table_Map[mapid];
			if(mapdata)then
				self.map.text = mapdata.CallZh;
				UIUtil.WrapLabel (self.map)
			end
		end

		if(monster.Type == "MVP")then
			self.icontype.spriteName = BossIconType.Mvp;
		elseif(monster.Type == "MINI")then
			self.icontype.spriteName = BossIconType.Mini;
		else
			self.icontype.spriteName = "";
		end

		self:UpdateChoose();
	else
		self.content:SetActive(false);
	end
end

function BossCell:UpdateInfo(monsterData)
	IconManager:SetFaceIcon(monsterData.Icon, self.icon);
	self.level.text = "Lv."..monsterData.Level;
end

function BossCell:UpdateTime(time)
	self:RemoveUpdateTime();

	self.refreshTime = time;

	if(self.timeTick == nil)then
		self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTime, self, 1)
	end
end

function BossCell:_UpdateTime()
	local time = self.refreshTime;
	if(time == nil)then
		self:RemoveUpdateTime();
		return;
	end

	local deltaTime = ServerTime.ServerDeltaSecondTime(time*1000);
	if(deltaTime <= 0)then
		self.time.text = "[5d9712]"..ZhString.Boss_Show.."[-]"
	else
		self.time.text = string.format(ZhString.Boss_RefreshTimeM, math.max(1, math.ceil(deltaTime/60)));
	end
end

function BossCell:RemoveUpdateTime()
	if(self.timeTick ~= nil)then
		TimeTickManager.Me():ClearTick(self, 1)
		self.timeTick = nil;
	end
end

function BossCell:SetChoose(chooseId, chooseMap)
	self.chooseId = chooseId;
	self.chooseMap = chooseMap;

	self:UpdateChoose();
end

function BossCell:UpdateChoose()
	if(self.data and self.chooseId and self.data.id == self.chooseId and self.chooseMap and self.data.mapid == self.chooseMap)then
		self.chooseSymbol:SetActive(true);
	else
		self.chooseSymbol:SetActive(false);
	end
end