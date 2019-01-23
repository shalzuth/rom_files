autoImport("LoveLetterData")

StarProxy = class('StarProxy', pm.Proxy)
StarProxy.Instance = nil;
StarProxy.NAME = "StarProxy"

local TYPE = LoveLetterData.Type
local FROMTYPE = LoveLetterData.FromType
local panelConfig = {
	[TYPE.Valentine] = PanelConfig.ValentineView,
	[TYPE.Star] = PanelConfig.StarView,
	[TYPE.Christmas] = PanelConfig.ChristmasView,
	[TYPE.SpringActivity] = PanelConfig.SpringActivityView,
	[TYPE.Lottery] = PanelConfig.LotteryGiftView,
	[TYPE.WeddingDress] = PanelConfig.WeddingDressView,
}

function StarProxy:ctor(proxyName, data)
	self.proxyName = proxyName or StarProxy.NAME
	if StarProxy.Instance == nil then
		StarProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function StarProxy:Init()
	self.info = {}
end

function StarProxy:RecvLoveLetterNtf(servicedata)
	local data = LoveLetterData.new(servicedata)
	TableUtility.ArrayPushBack(self.info, data)

	if #self.info > 1 then
		local frontType = self:GetFrontData().from
		if frontType == FROMTYPE.Server then
			return
		end
	end

	self:JumpPanel(data.type)
end

function StarProxy:GetFrontData()
	if #self.info > 0 then
		return self.info[1]
	end

	return nil
end

function StarProxy:ShowNext()
	local lastType
	if #self.info > 0 then
		lastType = self.info[1].type
		table.remove(self.info, 1)
	end

	local front = self:GetFrontData()
	if front then
		if front.type == lastType then
			return false
		else
			self:JumpPanel(front.type)
			return true
		end
	end

	return true
end

function StarProxy:JumpPanel(datatype)
	local panel = panelConfig[datatype]
	if panel ~= nil then
		self:sendNotification(UIEvent.JumpPanel, {view = panel})
	end
end

function StarProxy:CheckShareOpen()
	local socialShareConfig = AppBundleConfig.GetSocialShareInfo()
	if socialShareConfig == nil then
		return false
	end

	if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V9) then
		return false
	end
	return true
end

function StarProxy:GetPanelConfig(type)
	return panelConfig[type]
end

function StarProxy:CacheData(data,target)
	self.itemData = data
	self.pTarget = target
end

function StarProxy:GetCachedTarget()
	return self.pTarget
end

function StarProxy:RecvCheckRelationUserCmd(data)
	if data.ret then
		local sdata = self.itemData and self.itemData.staticData;
		if sdata.UseMode ~= nil then
			FuncShortCutFunc.Me():CallByID(sdata.UseMode, data.id);
		else
			FunctionItemFunc.DoUseItem(self.itemData, self.pTarget)
		end
	end
end