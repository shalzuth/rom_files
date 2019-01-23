local WebPanelProxy = class('WebPanelProxy', pm.Proxy)

autoImport("WebPanel")
WebPanelProxy.Instance = nil;

WebPanelProxy.NAME = "WebPanelProxy"

--房间数据管理
function WebPanelProxy:ctor(proxyName, data)
	self.proxyName = proxyName or WebPanelProxy.NAME
	if(WebPanelProxy.Instance == nil) then
		WebPanelProxy.Instance = self
	end
	self.gui = WebPanel.new()

	--当前界面是否显示的标记
	self.bShow = false
	-- 当前是否需要显示LIVE
	self.isInLive = false
	-- 当前的LIVE列表
	self.liveList = {}
end

function WebPanelProxy:OpenPanel()
	if not self.bShow then
		self.bShow = true
		self.gui:OpenPanel()

		self:AddEvt()
		self:Init()
	end
end

function WebPanelProxy:AddEvt()
	self.gui.closeBtn.onClick = function (go)
		SoundManager.Instance.PlayUISound(10)
		self:ClosePanel()
		HallPanelProxy.Instance:OpenPanel()
	end
end

function WebPanelProxy:ClosePanel()
	if self.bShow then
		self.bShow = false
		self:ClearCells()
		GameSysManager.SetBgmVolume(false)
		self.gui:ClosePanel()
	end
end

function WebPanelProxy:Init()
	-- 关闭bgm音量
	GameSysManager.SetBgmVolume(true)
	self:InitData()
	self:InitShow()
	-- self:ShowList()
end

function WebPanelProxy:InitData( ... )
	-- body
end

function WebPanelProxy:GetAnchor()
	if not self.gui then return end
	return self.gui.Anchor
end

function WebPanelProxy:InitShow()
	--- 填入的数据table
	if not self.liveList or #self.liveList <= 0 then return end
	self.gui.GridList:ResetDatas(self.liveList)
	self.gui.LineSprite.height = 600 - 88 * #self.liveList
	if self.liveList[1] and self.liveList[1].id then
		self:ChooseWebCell(self.liveList[1].id)
	end
end

function WebPanelProxy:RecvAddLiveActionNoticeCmd(data)
	-- print("Add直播信息")
	if not data then return end
	if self.liveList == nil then self.liveList = {} end
	if data.datas then
		for i = 1,#data.datas do
			local _id,_name,_url = data.datas[i].id,StringUtil.trim(data.datas[i].title),StringUtil.trim(data.datas[i].msg)
			if _id and _name and _url and not self:CheckIfHas(_id) then
				table.insert(self.liveList,{id = _id,liveName = _name,url = _url,
					level = data.datas[i].priority_level,inlive = data.datas[i].button_status})
			end
		end
	end
	self:SortList()
	-- self:ShowList()
	self:UpdateInLiveStatus()
end

function WebPanelProxy:RecvDelLiveActionNoticeCmd(data)
	-- print("删除直播中的信息",data.ids)
	-- self:ShowList()
	if not data or not data.ids or not self.liveList or #self.liveList <= 0 or #data.ids <= 0 then return end
	local tmplivelist = {}
	for i = 1,#self.liveList do
		local isexist = false
		for k = 1,#data.ids do
			if self.liveList[i].id == data.ids[k] then isexist = true; break end
		end
		if not isexist then table.insert(tmplivelist,self.liveList[i]) end
	end
	self.liveList = tmplivelist
	self:SortList()
	-- print("删除后显示直播信息")
	-- self:ShowList()
	self:UpdateInLiveStatus()
end

function WebPanelProxy:CheckIfHas(id)
	if not self.liveList then return false end
	for i = 1,#self.liveList do
		if id == self.liveList[i].id then return true end
	end
end

function WebPanelProxy:ChooseWebCell(id)
	local cells = self.gui.GridList:GetCells()
	if cells then
		for i=1,#cells do
			cells[i]:SelectCell(id)
		end
	end
end

function WebPanelProxy:ClearCells()
	local cells = self.gui.GridList:GetCells()
	if cells then
		for i = 1,#cells do
			cells[i]:Clear()
		end
	end
end

-- 排序条目
function WebPanelProxy:SortList()
	if not self.liveList or #self.liveList <= 0 then return end
	table.sort(self.liveList,function (lhs,rhs)
		if lhs.level > rhs.level then return true
		elseif lhs.level < rhs.level then return false 
		else return lhs.id < rhs.id end
	end)
end

function WebPanelProxy:ShowList()
	-- print("显示live数据")
	if not self.liveList or #self.liveList <= 0 then return end
	for i = 1,#self.liveList do
		print(i,self.liveList[i].id,self.liveList[i].level)
	end
end

function WebPanelProxy:UpdateInLiveStatus()
	self.isInLive = false
	if not self.liveList or #self.liveList <= 0 then return end
	for i = 1,#self.liveList do
		if not self.isInLive and self.liveList[i].inlive then
			self.isInLive = (self.liveList[i].inlive == 1)
		end
		-- print("直播中",self.isInLive)
		if self.isInLive then break end
	end
	HallPanelProxy.Instance:PlayLiveSpine()
end

function WebPanelProxy:ClearList()
	self.liveList = nil
	self.isInLive = false
end

return WebPanelProxy