ActivityDetailPanel = class("ActivityDetailPanel", ContainerView)
autoImport("AdventureIndicatorCell")
ActivityDetailPanel.ViewType = UIViewType.NormalLayer

ActivityDetailPanel.ViewDesColor = LuaColor(0/255,32/255,154/255,1)
ActivityDetailPanel.GoColor = LuaColor(122/255,60/255,5/255,1)

ActivityDetailPanel.GetWallPicThumbnail = "ActivityDetailPanel_GetWallPicThumbnail"
function ActivityDetailPanel:Init()
	self:AddViewEvts()
	self:initView()
end

function ActivityDetailPanel:OnEnter()
	self.super.OnEnter(self);
	self:initData()
end

function ActivityDetailPanel:AddViewEvts()
	self:AddListenEvt(ActivityTextureManager.ActivityPicCompleteCallbackMsg ,self.picCompleteCallback)
	self:AddListenEvt(ServiceEvent.SessionSocialityOperActivityNtfSocialCmd,self.ResetData)
end

function ActivityDetailPanel:picCompleteCallback( note )
	ActivityTextureManager.Instance():log("ActivityDetailPanel:picCompleteCallback")
	local data = note.body
	if(self.curActData and self.curActData.pic_url == data.picUrl)then
		self:completeCallbackBytes(data.byte)
	else
		ActivityTextureManager.Instance():log("ActivityDetailPanel:picCompleteCallback",tostring(self.curActData),data.picUrl,self.curActData and self.curActData.pic_url)
	end
end

function ActivityDetailPanel:initData(  )
	self.delta = 0
	self.groupId = self.viewdata.groupId
	self.txWidth = 959
	self.txHeight = 502
	self.curShowIndex = 1
	self.subActivits = {}
	self:ResetData()
	TimeTickManager.Me():CreateTick(0,1000,self.updateActivityTime,self)
end

function ActivityDetailPanel:updateActivityTime(  )
	if(self.curActData)then
		local currentTime = ServerTime.CurServerTime()
		currentTime = math.floor(currentTime / 1000)
		local time = self.curActData.begintime
		local leftTime = time - currentTime
		local preText = ZhString.ActivityData_Start

		-- local timeStr1 = os.date("%Y-%m-%d %H:%M:%S",time)
		-- local timeStr2 = os.date("%Y-%m-%d %H:%M:%S",self.curActData.endtime)
		-- local timeStr3 = os.date("%Y-%m-%d %H:%M:%S",currentTime)
		-- LogUtility.InfoFormat("updateActivityTime startT:{0},endT:{1},curTime:{2}",timeStr1,timeStr2,timeStr3)

		if(leftTime < 0)then
			leftTime = self.curActData.endtime - currentTime
			preText = ZhString.ActivityData_Finish
		end
		if(leftTime >= 3600*24)then
			local day = math.floor(leftTime/(3600*24))
			local h = math.floor((leftTime - day*3600*24)/3600)
			self.countTimeLabel.text = string.format(ZhString.ActivityData_SubActHourDes,day,h,preText)
		else
			local h = math.floor(leftTime / 3600)
			local m = math.floor((leftTime - h*3600) / 60)
			local s = leftTime - h*3600 - m*60
			self.countTimeLabel.text = string.format(ZhString.ActivityData_SubActTimeLineDes,h,m,s,preText)
		end
	else
		self.countTimeLabel.text = ""
	end
end

function ActivityDetailPanel:ResetData(  )
	-- body
	self.curShowIndex = 1
	TableUtility.ArrayClear(self.subActivits)
	self.subActivits = ActivityDataProxy.Instance:getActiveSubActivitys(self.groupId)
	self:UpdateActivityDetail()
end

function ActivityDetailPanel:UpdateActivityDetail(  )
	if(self.subActivits and self.subActivits[self.curShowIndex])then
		local actData = self.subActivits[self.curShowIndex]
		self:ShowActivityDetail(actData)
	end
	if(self.curShowIndex > 1)then
		self:Show(self.leftIndicator)
	else
		self:Hide(self.leftIndicator)
	end
	if(self.subActivits and self.subActivits[self.curShowIndex+1])then
		self:Show(self.rightIndicator)
	else
		self:Hide(self.rightIndicator)
	end
end

function ActivityDetailPanel:SetViewBtnIsValid( result )
	if(result)then
		self.ViewDetailButtonSp.spriteName = "com_btn_1"
		self.ViewDetailLabel.effectStyle = UILabel.Effect.Outline
		self.ViewDetailLabel.effectColor = ActivityDetailPanel.ViewDesColor
		self.ViewDetailButtonCl.enabled = true
	else
		self.ViewDetailButtonCl.enabled = false
		self.ViewDetailButtonSp.spriteName = "com_btn_13"
		self.ViewDetailLabel.effectStyle = UILabel.Effect.None
	end
end

function ActivityDetailPanel:SetGoBtnIsValid( result )
	if(result)then
		self.GoButtonCl.enabled = true
		self.GoButtonSp.spriteName = "com_btn_2"
		self.GoLabel.effectStyle = UILabel.Effect.Outline
		self.GoLabel.effectColor = ActivityDetailPanel.GoColor
	else
		self.GoButtonCl.enabled = false
		self.GoButtonSp.spriteName = "com_btn_13"
		self.GoLabel.effectStyle = UILabel.Effect.None
	end
end

function ActivityDetailPanel:ShowActivityDetail( actData )
	self.curActData = actData
	self:Show(self.Loading)
	local texture = self.photo.mainTexture
	self.photo.mainTexture = nil
	Object.DestroyImmediate(texture)
	ActivityTextureManager.Instance():AddActivityPicInfos({actData.pic_url})

	local url = actData.url
	-- local url = ""
	if(url and url ~= "")then
		self:SetViewBtnIsValid(true)
	else
		self:SetViewBtnIsValid(false)
	end

	local event = actData.pathevent
	local pathtype = actData.pathtype

	-- local event = "{npcid=1509,mapid=16,uniqueid=19}"
	-- local pathtype = 1
	local tbData = TableUtil.unserialize(event)
	if(tbData and pathtype)then
		self:SetGoBtnIsValid(true)
	else
		self:SetGoBtnIsValid(false)
	end

	LogUtility.InfoFormat("evetn:{0},pathtype:{1},url:{2}",event,pathtype,url)
	local list = {}
	for i=1,#self.subActivits do
		local data = {}
		if(i == self.curShowIndex)then
			data.cur = true
		end
		table.insert(list,data)
	end
	self.indicatorGrid:ResetDatas(list)
	local bound = NGUIMath.CalculateRelativeWidgetBounds(self.indicatorGrid.layoutCtrl.transform,true);
	self.curStateBg.width = bound.size.x + 150
end

function ActivityDetailPanel:doSomeThing(  )
	-- body
	local tbData = TableUtil.unserialize(self.curActData.pathevent)
	-- local event = "{npcid=1509,mapid=16,uniqueid=19}"
	-- local tbData = TableUtil.unserialize(event)
	local pathtype = self.curActData.pathtype	
	local func = FuncShortCutFunc.Me().FuncMap[pathtype]
	if(func)then
		func(FuncShortCutFunc.Me(),{Event = tbData})
	end
end

function ActivityDetailPanel:initView(  )
	-- body
	local dragCollider = self:FindGO("dragCollider")
	self:AddDragEvent(dragCollider,function ( obj,delta )
		-- body
		if(math.abs(delta.x) > 20)then
			self.delta = delta.x
		end
	end)

	UIEventListener.Get(dragCollider).onDragEnd = function ( obj)
		-- body
		if(math.abs(self.delta) > 20)then
			self:handDrag(self.delta)
		end
	end

	self:AddButtonEvent("GoButton", function (go)
		self:doSomeThing()
	end)

	self:AddButtonEvent("ViewDetailButton", function (go)
	    local url = self.curActData.url
		local fStr = string.find(url, "%[(%w*)]")
	 	local result = url
	 	if(fStr)then
	 		local name = Game.Myself.data:GetName()
	 		name = WWW.EscapeURL(name)
		   	result = string.gsub(url,'%[(%w*)]',"")
		   	result = result..name
	 	end
		Application.OpenURL(result)

	end)

	self.leftIndicator = self:FindGO("leftIndicator")
	self.rightIndicator = self:FindGO("rightIndicator")

	self:AddClickEvent(self.leftIndicator, function (go)
		self:goLeft()
	end)

	self:AddClickEvent(self.rightIndicator, function (go)
		self:goRight()
	end)

	self.photo = self:FindComponent("photo",UITexture)
	self.GoLabel = self:FindComponent("GoLabel",UILabel)
	self.GoLabel.text = ZhString.ActivityData_GoLabelText
	self.ViewDetailLabel = self:FindComponent("ViewDetailLabel",UILabel)
	self.ViewDetailLabel.text = ZhString.ActivityData_ViewDetailLabelText
	self.Loading = self:FindGO("Loading")
	self.countTimeLabel = self:FindComponent("countTimeLabel",UILabel)
	self.ViewDetailButtonSp = self:FindComponent("ViewDetailButton",UISprite)
	self.ViewDetailButtonCl = self:FindComponent("ViewDetailButton",BoxCollider)
	self.GoButtonSp = self:FindComponent("GoButton",UISprite)
	self.GoButtonCl = self:FindComponent("GoButton",BoxCollider)
	self.indicatorGrid = self:FindComponent("indicatorGrid",UIGrid)
	self.indicatorGrid = UIGridListCtrl.new(self.indicatorGrid,AdventureIndicatorCell,"AdventureIndicatorCell")
	self.curStateBg = self:FindGO("curStateBg"):GetComponent(UISprite)
end

function ActivityDetailPanel:handDrag( delta )
	-- body
	if(delta < 0)then
		self:goRight()
	elseif(delta > 0)then
		self:goLeft()
	end
end

function ActivityDetailPanel:goLeft(  )
	-- body	
	if(self.subActivits and self.curShowIndex > 1)then
		self.curShowIndex = self.curShowIndex - 1
		self:UpdateActivityDetail()
	end
end

function ActivityDetailPanel:goRight(  )
	-- body
	if(self.subActivits and self.subActivits[self.curShowIndex+1])then
		self.curShowIndex = self.curShowIndex +1
		self:UpdateActivityDetail()
	end
end

function ActivityDetailPanel:setTexture( texture )
	-- body
	self:Hide(self.Loading)
	Object.DestroyImmediate(self.photo.mainTexture)
	self.photo.mainTexture = texture
	self.photo.width = self.txWidth
	self.photo.height = self.txHeight
end

function ActivityDetailPanel:completeCallbackBytes(bytes )
	-- body
	local texture = Texture2D(0,0,TextureFormat.RGB24,false)
	local bRet = ImageConversion.LoadImage(texture, bytes)
	if( bRet)then
		self:setTexture(texture)
	else
		ActivityTextureManager.Instance():log("ActivityDetailPanel:completeCallbackBytes LoadImage failure")
		Object.DestroyImmediate(texture)
	end
end

function ActivityDetailPanel:OnExit(  )
	-- body
	Object.DestroyImmediate(self.photo.mainTexture)
	TimeTickManager.Me():ClearTick(self)
end

-- function ActivityDetailPanel:progressCallback( progress )
-- 	-- body
-- 	self:Show(self.progress.gameObject)
-- 	progress = progress >=1 and 1 or progress
-- 	local value = progress*100
-- 	value = math.floor(value)
-- 	self.progress.text = value.."%"
-- end