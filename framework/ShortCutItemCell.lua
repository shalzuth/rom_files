local BaseCell = autoImport("BaseCell");
ShortCutItemCell = class("ShortCutItemCell", BaseCell)

local tempV3 = LuaVector3();

function ShortCutItemCell:Init()
	self.npcName = self:FindComponent("NpcName", UILabel);
	self.mapName = self:FindComponent("MapName", UILabel);

	self.traceButton = self:FindGO("TraceButton");
	self:AddClickEvent(self.traceButton, function ()
		self:PassEvent(MouseEvent.MouseClick, self);
	end);

	----[[ todo xde 乐园币使用
	self.npcName.width = 342
	self.npcName.overflowMethod = 3 --UILabel.Overflow.ResizeHeight
	self.npcName.fontSize = 22
	local v3 = self.mapName.transform.localPosition
	self.mapName.transform.localPosition = Vector3(v3.x, -22, v3.z)
	--]]
end

function ShortCutItemCell:SetData(data)
	if(not data)then
		return;
	end

	self.traceId = data.id;

	local event = data.Event;
	if(event)then
		if(event.npcid)then
			local npcData = Table_Npc[event.npcid];
			if(npcData)then
				if(npcData.Guild and npcData.Guild ~= "")then
					self.npcName.text = string.format("%s<%s>", npcData.NameZh, npcData.Guild);
				else
					self.npcName.text = npcData.NameZh;
				end
			else
				self.npcName.text = "";
			end
		else
			self.npcName.text = "";
		end
		if(event.mapid)then
			local mapData = Table_Map[event.mapid];
			if(mapData)then
				if(event.npcid)then
					self.mapName.text = mapData.NameZh;
				else
					self.npcName.text = mapData.NameZh;
					self.mapName.text = "";
				end
			else
				self.mapName.text = "";
			end
		else
			self.mapName.text = "";
		end

		if(self.mapName.text == "")then
			tempV3:Set(-200, 0, 0);
		else
			tempV3:Set(-200, 16, 0);
		end
		self.npcName.transform.localPosition = tempV3;
	end
end