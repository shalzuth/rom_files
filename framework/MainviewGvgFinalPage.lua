autoImport("GvgFinalRankCell")
autoImport("SuperGvgProxy")
MainviewGvgFinalPage = class("MainviewGvgFinalPage",SubMediatorView)

local tempVector3 = LuaVector3.zero
function MainviewGvgFinalPage:Init()
	self:ReLoadPerferb("view/MainviewGvgFinalPage");
	self:initView()
	self:AddViewEvts()
	self:initData()
end

function MainviewGvgFinalPage:initData(  )
	-- body
	local secDiff = SuperGvgProxy.Instance:GetFinalFightTimeDiff()

	if secDiff < 0 then
		self.hasWarStart = true
	else
		self.hasWarStart = false
	end

	self.warStartCoundDown = secDiff
	self.warStartedTime = -secDiff

	local infos = SuperGvgProxy.Instance:GetGuildInfos()
	self.rankCtGridCells:ResetDatas(infos)
	self:UpdateCrystalPieces(infos)
	if(self.tickMg)then
		self.tickMg:ClearTick(self)
	else
		self.tickMg = TimeTickManager.Me()
	end
	self.tickMg:CreateTick(0,1000,self.updateCountTime,self)

	IconManager:SetItemIcon("item_700104", self.piecesSliderBg)
	IconManager:SetItemIcon("item_700104", self.piecesSliderFront)
end

function MainviewGvgFinalPage:SetData(  )
end

function MainviewGvgFinalPage:ResetParent( parent )
	self.trans:SetParent(parent.transform,false)
end

function MainviewGvgFinalPage:initView(  )
	-- body
	self.timeLabel = self:FindComponent("timeLabel",UILabel)
	self.piecesSliderBg = self:FindComponent("piecesSliderBg",UISprite)
	self.piecesSliderFront = self:FindComponent("piecesSliderFront",UISprite)
	local Title = self:FindComponent("Title",UILabel)
	Title.text = ZhString.MainviewGvgFinalPage_Title
	local timeDes = self:FindComponent("timeDes",UILabel)
	timeDes.text = ZhString.MainviewGvgFinalPage_TimeDes
	local rankCtGrid = self:FindComponent("topRankCt",UITable)
	self.piecesSlider = self:FindComponent("piecesSlider",UISlider)
	self.rankCtGridCells = UIGridListCtrl.new(rankCtGrid,GvgFinalRankCell,"GvgFinalRankCell")
	local clickBox = self:FindGO("taskBordFoldSymbol")
	self:AddClickEvent(clickBox,function ( go )
		GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "GVGDetailView"})
	end)
end

function MainviewGvgFinalPage:AddViewEvts()
	EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.UpdateCrystal, self);	
end

function MainviewGvgFinalPage:resizeContent(  )
	-- body
	-- if(not self.container.gameObject.activeInHierarchy)then
	-- 	return
	-- end
	-- local bd = calSize(self.content.transform,false)
	-- local height = bd.size.y
	-- self.bg.height = height+10

	-- local x,y,z = getLocalPos(self.GvgHonorTraceInfo.transform)
	-- local x1,y1,z1 = getLocalPos(self.bg.transform)
	-- tempVector3:Set(x,y1 - height - 20,z)
	-- self.GvgHonorTraceInfo.transform.localPosition = tempVector3
end

function MainviewGvgFinalPage:updateCountTime( )
	-- self:resizeContent()
	local leftTime = 0
	if(self.hasWarStart)then
		self.warStartedTime = self.warStartedTime + 1 
		leftTime = self.warStartedTime
	else
		self.warStartCoundDown = self.warStartCoundDown - 1
		leftTime = self.warStartCoundDown

		if self.warStartCoundDown == 0 then
			self.hasWarStart = true
			self.warStartedTime = 0
		end
	end

	local m = math.floor(leftTime / 60)
	local s = leftTime - m*60
	local time = string.format(ZhString.MainViewGvgPage_LeftTime,m,s)
	-- helplog("time:",time)
	self.timeLabel.text = time
end

function MainviewGvgFinalPage:UpdateCrystal()
	local infos = SuperGvgProxy.Instance:GetGuildInfos()
	
	self.rankCtGridCells:ResetDatas(infos)
	self:UpdateCrystalPieces(infos)
end

function MainviewGvgFinalPage:UpdateCrystalPieces(infos)
	local guildData = GuildProxy.Instance.myGuildData;
	for i=1,#infos do
		if(guildData.guid == infos[i].guildid) then
			if(self.piecesSlider~=nil and infos[i].crystalData.chipnum~=nil)then
				value = math.floor(infos[i].crystalData.chipnum)/4; 
				self.piecesSlider.value = value;
			else
				self.piecesSlider.value = 0;
			end
		end
	end
end

function MainviewGvgFinalPage:OnExit(  )
	-- body
	self.tickMg:ClearTick(self)
	self.tickMg = nil
	EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.UpdateCrystal, self);	
	-- helplog("ewGvgFinalPage:OnExit:")
end
