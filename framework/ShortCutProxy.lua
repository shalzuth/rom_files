autoImport("ShortCutData")

ShortCutProxy = class('ShortCutProxy', pm.Proxy)

ShortCutProxy.Instance = nil;

ShortCutProxy.NAME = "ShortCutProxy"

ShortCutProxy.ShortCutEnum = {
	ID1 = SceneSkill_pb.ESKILLSHORTCUT_NORMAL,
	ID2 = SceneSkill_pb.ESKILLSHORTCUT_EXTEND,
	ID3 = SceneSkill_pb.ESKILLSHORTCUT_EXTEND_2,
	ID4 = SceneSkill_pb.ESKILLSHORTCUT_EXTEND_3,
}

ShortCutProxy.SwitchList = {
	[1] = SceneSkill_pb.ESKILLSHORTCUT_NORMAL,
	[2] = SceneSkill_pb.ESKILLSHORTCUT_EXTEND,
	[3] = SceneSkill_pb.ESKILLSHORTCUT_EXTEND_2,
	[4] = SceneSkill_pb.ESKILLSHORTCUT_EXTEND_3,
}

ShortCutProxy.SkillShortCut = {
	Auto = SceneSkill_pb.ESKILLSHORTCUT_AUTO,
	BeingAuto = SceneSkill_pb.ESKILLSHORTCUT_BEINGAUTO,
}

--玩家自身的管理

function ShortCutProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ShortCutProxy.NAME
	if(ShortCutProxy.Instance == nil) then
		ShortCutProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self.shortCutData = ShortCutData.new()
	self.itemShortMap = {};
end

function ShortCutProxy:GetUseBagTab()
	if(self.bagTab==nil) then
		self.bagTab = BagProxy.Instance.bagData:GetTab(GameConfig.ItemPage[4])
	end
	return self.bagTab
end

function ShortCutProxy:onRegister()
end

function ShortCutProxy:onRemove()
end

function ShortCutProxy:UnLockSkillShortCuts(serviceData)
	self.shortCutData:ResetSkillShortCuts()
	
	local hasExtendPos = false
	for i=1,#serviceData.shortcuts do
		local shortcut = serviceData.shortcuts[i]
		self.shortCutData:UnLockSkillShortCuts(shortcut)

		if not hasExtendPos and 
		(shortcut.type == self.ShortCutEnum.ID2 or shortcut.type == self.ShortCutEnum.ID3 or shortcut.type == self.ShortCutEnum.ID4) then
			hasExtendPos = true
		end
	end

	if hasExtendPos then
		GameFacade.Instance:sendNotification(SkillEvent.SkillUnlockPos)
	end
end

function ShortCutProxy:GetUnLockSkillMaxIndex(id)
	return self.shortCutData:GetUnLockSkillMaxIndex(id)
end

function ShortCutProxy:GetAutoUnLockSkillMaxIndex()
	return self.shortCutData:GetAutoSkillUnlockMaxIndex()
end

function ShortCutProxy:SetCacheListToRealList()
	self.shortCutData:SetCacheListToRealList()
end

function ShortCutProxy:SkillIsLocked(index,id)
	return self.shortCutData:SkillIsLocked(index,id)
end

function ShortCutProxy:AutoSkillIsLocked(index)
	return self.shortCutData:AutoSkillIsLocked(index)
end

function ShortCutProxy:SetShortCuts(shortCuts)
	if(type(shortCuts)  == "table" )then
		for i=1,#shortCuts do
			self:SetShortCut(shortCuts[i]);
		end
	end
end

function ShortCutProxy:SetShortCut(data)
	if(data)then
		local cutData = {
			pos = data.pos,
			guid = data.guid,
			type = data.type,
		};
		self.itemShortMap[cutData.pos + 1] = cutData;
		GameFacade.Instance:sendNotification(MyselfEvent.ResetHpShortCut);
	end 
end

function ShortCutProxy:GetShorCutItem(needPos)
	local result = {};
	for i=1,#self.itemShortMap do
		local data = self.itemShortMap[i];
		if(data)then
			local item = BagProxy.Instance.bagData:GetItemByGuid(data.guid);
			if(not item)then
				item = BagProxy.Instance.roleEquip:GetItemByGuid(data.guid);
				if(not item)then
					item = BagProxy.Instance.fashionEquipBag:GetItemByGuid(data.guid);
				end
			end
			if(not item and data.type and Table_Item[data.type])then
				item = ItemData.new("Shadow", data.type);
			end
			if(needPos)then
				result[data.pos+1] = item;
			else
				table.insert(result, item);
			end
		end
	end
	return result;
end

function ShortCutProxy:GetValidShortItem(staticId)
	local items = self:GetShorCutItem();
	for i=1,#items do
		local item = items[i];
		if(item.staticData.id == staticId and item:CanUse())then
			return item;
		end
	end
end

function ShortCutProxy:ShortCutListIsEnable(id)
	return self.shortCutData:ShortCutListIsEnable(id)
end