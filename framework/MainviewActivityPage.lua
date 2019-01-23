MainviewActivityPage = class("MainviewActivityPage",SubView)
autoImport("ActivityButtonCell")
autoImport("ActivityTextureManager")

MainviewActivityPage.GetIconTexture = "MainviewActivityPage_GetIconTexture"

function MainviewActivityPage:Init()
	self:AddViewListen();
	self:initView();	
end

function MainviewActivityPage:OnEnter()
	self.super.OnEnter(self);
	self:initData()
end

function MainviewActivityPage:initData()
	self:UpdateActivityInfos(true)
end

function MainviewActivityPage:initView()
	local node = GameConfig.System.ShieldMaskDoujinshi==1 and self:FindGO("ActivityNode") or self:FindGO("DoujinshiNode")
	self.activityGrid = self:FindComponent("ContentCt", UIGrid,node);
	self.activityGridList = UIGridListCtrl.new(self.activityGrid, ActivityButtonCell,"ActivityButtonCell")
	self.activityGridList:AddEventListener(MainviewActivityPage.GetIconTexture, self.GetIconTexture, self);
	self.activityGridList:AddEventListener(MouseEvent.MouseClick, self.ActivityCellClick, self);
end

function MainviewActivityPage:ActivityCellClick(cellCtl)
	GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "ActivityDetailPanel",groupId = cellCtl.data.id})
end

function MainviewActivityPage:GetIconTexture(cellCtl)
	if(cellCtl and cellCtl.data)then
		ActivityTextureManager.Instance():AddActivityPicInfos({cellCtl.data.iconurl})
	end
end

function MainviewActivityPage:AddViewListen()
	self:AddListenEvt(ServiceEvent.SessionSocialityOperActivityNtfSocialCmd,self.HandleOperActivityNtfSocialCmd)
	self:AddListenEvt(ActivityTextureManager.ActivityPicCompleteCallbackMsg ,self.picCompleteCallback);
end

function MainviewActivityPage:picCompleteCallback( note )
	local data = note.body
	local cell = self:GetItemCellById(data.picUrl)
	if(cell)then
		cell:setTextureByBytes(data.byte)
	end
end

function MainviewActivityPage:GetItemCellById(picUrl)
	local cells = self.activityGridList:GetCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			if(cells[i].data.iconurl == picUrl)then
				return cells[i]
			end
		end
	end
end

function MainviewActivityPage:HandleOperActivityNtfSocialCmd(  )
	self:UpdateActivityInfos()
end

function MainviewActivityPage:updateActivityTime(  )
	-- body
	local cells = self.activityGridList:GetCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			cells[i]:updateTime()
		end
	end
end

function MainviewActivityPage:updateCellPosition(  )
	-- body
	local cells = self.activityGridList:GetCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			cells[i].gameObject.transform:SetAsFirstSibling()
		end
		self.activityGridList:Layout()
	end
end

function MainviewActivityPage:UpdateActivityInfos( first )
	helplog("MainviewActivityPage:UpdateActivityInfos")
	-- body
	local activitys = ActivityDataProxy.Instance:getActiveActivitys()
	if(activitys and #activitys>0)then
		self.activityGridList:ResetDatas(activitys)
		self:updateCellPosition()
		TimeTickManager.Me():CreateTick(0,1000,self.updateActivityTime,self)
		--todo xde 10 级以下不显示
		local userData = Game.Myself.data.userdata
		local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL);
		helplog(nowRoleLevel)
		if(first and nowRoleLevel >10)then
			GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "ActivityDetailPanel",groupId = activitys[1].id})
		end
	else
		TimeTickManager.Me():ClearTick(self)
		self.activityGridList:RemoveAll()
	end
end