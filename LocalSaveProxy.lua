LocalSaveProxy = class('LocalSaveProxy', pm.Proxy)
LocalSaveProxy.Instance = nil;
LocalSaveProxy.NAME = "LocalSaveProxy"

LocalSaveProxy.SAVE_KEY = {
	DontShowAgain = "DontShowAgain",
	ExchangeSearchHistory = "ExchangeSearchHistory",
	PhotoFilterSetting = "PhotographPanelFilters_%d",
	LastTraceQuestId = "LastTraceQuestId",
	Setting = "Setting",
	MainViewChatTweenLevel = "MainViewChatTweenLevel",	--?????????????????????????????????
	MainViewAutoAimMonster = "MainViewAutoAimMonster",	--??????????????????????????????

	BossView_ShowMini = "BossView_ShowMini",

	SkipAnimation = "SkipAnimation",	--????????????
	FashionPreviewTip_ShowOtherPart = "FashionPreviewTip_ShowOtherPart",
	FoodBuffOverrideNoticeShow = "FoodBuffOverrideNoticeShow"
}

function LocalSaveProxy:ctor(proxyName, data)
	self.proxyName = proxyName or LocalSaveProxy.NAME
	if(LocalSaveProxy.Instance == nil) then
		LocalSaveProxy.Instance = self
	end
end

--"??????????????????????????????.DontShowAgain??????id?????????DontShowAgain_id????????????????????????"
function LocalSaveProxy:InitDontShowAgain()
	local serverTime = ServerTime.CurServerTime()
	if(self.dontShowAgains==nil and FunctionPlayerPrefs.Me():IsInited() and serverTime~=nil) then
		-- FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.DontShowAgain)
		self.dontShowAgains = {}
		local dirty
		local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.DontShowAgain,"")
		-- print(str)
		-- print(FunctionPlayerPrefs.Me().user)
		local t = loadstring("return {"..str.."}")()
		local id,timeStamp
		local ids = ""
		for i=1,#t do
			id = t[i]
			if(id~=nil and id~="") then
				str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.DontShowAgain.."_"..id,"")
				timeStamp = tonumber(str)
				if(timeStamp==0 or timeStamp>serverTime) then
					self.dontShowAgains[id] = timeStamp
					-- print(id,timeStamp)
					ids = ids~="" and (ids..","..id) or id
				else
					dirty = true
					-- print("??????",id,timeStamp)
					FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.DontShowAgain.."_"..id)
				end
			end
		end

		self.dontShowAgains.ids = ids
		if(dirty) then
			--???????????????ID???
			FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.DontShowAgain,self.dontShowAgains.ids)
			FunctionPlayerPrefs.Me():Save()
		end
	end
end

function LocalSaveProxy:AddDontShowAgain(id,days)
	local find = self:GetDontShowAgain(id)
	if(find==nil) then
		local timeStamp = (days~=0 and ServerTime.CurServerTime() + 24*3600*1000*days or 0)
		--ID???????????????
		FunctionPlayerPrefs.Me():AppendString(LocalSaveProxy.SAVE_KEY.DontShowAgain,id,",")
		FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.DontShowAgain.."_"..id,timeStamp)
		FunctionPlayerPrefs.Me():Save()
		self.dontShowAgains[id] = timeStamp
	end
end

function LocalSaveProxy:GetDontShowAgain(id)
	return self.dontShowAgains and self.dontShowAgains[id] or nil
end

function LocalSaveProxy:InitExchangeSearchHistory()
	if FunctionPlayerPrefs.Me():IsInited() then
		self.exchangeSearchHistory = {}
		
		local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.ExchangeSearchHistory , "")
		local history = string.split(str, "_")
		for i=1,#history do
			if history[i] ~= "" then
				table.insert(self.exchangeSearchHistory , tonumber(history[i]) )
			end
		end

		-- print("LocalSaveProxy InitExchangeSearchHistory")
		-- TableUtil.Print(self.exchangeSearchHistory)
	end
end

function LocalSaveProxy:AddExchangeSearchHistory(itemId)
	-- print("LocalSaveProxy AddExchangeSearchHistory")
	if not self:IsInExchangeSearchHistory(itemId) then
	
		if #self.exchangeSearchHistory >= GameConfig.Exchange.MaxSearchLog then
			local offset = #self.exchangeSearchHistory - GameConfig.Exchange.MaxSearchLog + 1
			for i = offset , 1 , -1 do
				table.remove(self.exchangeSearchHistory , i)
			end
		end

		table.insert(self.exchangeSearchHistory , itemId )
		local str = tostring(self.exchangeSearchHistory[1])
		for i=2,#self.exchangeSearchHistory do
			str = str.."_"..tostring(self.exchangeSearchHistory[i])
		end
		FunctionPlayerPrefs.Me():SetString( LocalSaveProxy.SAVE_KEY.ExchangeSearchHistory , str)
		FunctionPlayerPrefs.Me():Save()
	end
end

function LocalSaveProxy:IsInExchangeSearchHistory(itemId)
	for i=1,#self.exchangeSearchHistory do
		if self.exchangeSearchHistory[i] == itemId then
			return true
		end
	end

	return false
end

function LocalSaveProxy:GetExchangeSearchHistory()

	if self.exchangeSearchHistory == nil then
		self:InitExchangeSearchHistory()
	end

	return self.exchangeSearchHistory
end

function LocalSaveProxy:savePhotoFilterSetting(list)
	local key = LocalSaveProxy.SAVE_KEY.PhotoFilterSetting
	for j=1,#list do
		local single = list[j]
		-- printRed("filtersid:",single.data.id,single:getIsSelect())
		FunctionPlayerPrefs.Me():SetBool(string.format(key,single.id),single.isSelect)
	end
	FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:getPhotoFilterSetting(cells)
	local key = LocalSaveProxy.SAVE_KEY.PhotoFilterSetting
	local list = {}
	for j=1,#cells do
		local id = cells[j].data.id
		-- printRed("filtersid:",single.data.id,single:getIsSelect())
		local bFilter = FunctionPlayerPrefs.Me():GetBool(string.format(key,id),true)
		list[id] = bFilter
	end
	return list	
end

function LocalSaveProxy:getLastTraceQuestId()
	local key = LocalSaveProxy.SAVE_KEY.LastTraceQuestId
	return FunctionPlayerPrefs.Me():GetInt(key,-1)
	
end

function LocalSaveProxy:setLastTraceQuestId(value)
	if(value)then
		local key = LocalSaveProxy.SAVE_KEY.LastTraceQuestId
		FunctionPlayerPrefs.Me():SetInt(key,value)
		-- FunctionPlayerPrefs.Me():Save()
	end
end

function LocalSaveProxy:SaveSetting(setting)

	if not FunctionPlayerPrefs.Me():IsInited() then
		print("FunctionPlayerPrefs have not inited")
		return
	end

	FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.Setting)

	for k,v in pairs(setting) do
		local str
		if type(v) == "table" then
			str = k.."={"
			if #v == 0 then
				str = str.."}"
			end
			for i=1,#v do
				if i ~= #v then
					str = str..v[i]..","
				else
					str = str..v[i].."}"
				end
			end
		else
			str = k.."="..tostring(v)
		end
		FunctionPlayerPrefs.Me():AppendString(LocalSaveProxy.SAVE_KEY.Setting , str ,",")
	end

	FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:LoadSetting()
	local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.Setting,"")
	local t = loadstring("return {"..str.."}")()
	return t
end

function LocalSaveProxy:GetMainViewChatTweenLevel()
	local key = LocalSaveProxy.SAVE_KEY.MainViewChatTweenLevel
	return FunctionPlayerPrefs.Me():GetInt(key,2)
end

function LocalSaveProxy:SetMainViewChatTweenLevel(value)
	if value then
		local key = LocalSaveProxy.SAVE_KEY.MainViewChatTweenLevel
		FunctionPlayerPrefs.Me():SetInt(key,value)
		FunctionPlayerPrefs.Me():Save()
	end
end

function LocalSaveProxy:GetMainViewAutoAimMonster()
	local key = LocalSaveProxy.SAVE_KEY.MainViewAutoAimMonster
	return FunctionPlayerPrefs.Me():GetString(key,"")
end

function LocalSaveProxy:SetMainViewAutoAimMonster(value)
	if value then
		local key = LocalSaveProxy.SAVE_KEY.MainViewAutoAimMonster
		FunctionPlayerPrefs.Me():SetString(key,value)
		FunctionPlayerPrefs.Me():Save()
	end
end

function LocalSaveProxy:SetBossView_ShowMini(value)
	FunctionPlayerPrefs.Me():SetBool(LocalSaveProxy.SAVE_KEY.BossView_ShowMini, value == true)
	FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetBossView_ShowMini()
	return FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.BossView_ShowMini, true)
end

function LocalSaveProxy:SetSkipAnimation(type, value)
	if type then
		local key = LocalSaveProxy.SAVE_KEY.SkipAnimation.."_"..type
		FunctionPlayerPrefs.Me():SetBool(key, value)
		FunctionPlayerPrefs.Me():Save()
	end
end

function LocalSaveProxy:GetSkipAnimation(type)
	return FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.SkipAnimation.."_"..type, false)
end

function LocalSaveProxy:SetFashionPreviewTip_ShowOtherPart(value)
	FunctionPlayerPrefs.Me():SetBool(LocalSaveProxy.SAVE_KEY.FashionPreviewTip_ShowOtherPart, value == true)
	FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetFashionPreviewTip_ShowOtherPart(value)
	return FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.FashionPreviewTip_ShowOtherPart, true)
end

function LocalSaveProxy:SetFoodBuffOverrideNoticeShow(value)
	FunctionPlayerPrefs.Me():SetBool(LocalSaveProxy.SAVE_KEY.FoodBuffOverrideNoticeShow, value == true)
	FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetFoodBuffOverrideNoticeShow(value)
	return FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.FoodBuffOverrideNoticeShow, true)
end
