GvgFinalFightTip = class("GvgFinalFightTip", CoreView);
autoImport("GvgFinalMapRankCell")
autoImport("GvgFinalSectionCell")

GvgFinalFightTip.totalCaptureLen= 260
-- GvgFinalFightTip.totalCaptureValue = 180

GvgFinalFightTip.EGvgTowerType = {
	[FuBenCmd_pb.EGVGTOWERTYPE_CORE] = {name = "核心占领度",totalValue = GameConfig.GvgDroiyan.RobPlatform_RobValue or 1800},
	[FuBenCmd_pb.EGVGTOWERTYPE_WEST] = {name = "西部晶塔占领度",totalValue = GameConfig.GvgDroiyan.RobPlatform_RobValue or 1800},
	[FuBenCmd_pb.EGVGTOWERTYPE_EAST] = {name = "东部晶塔占领度",totalValue = GameConfig.GvgDroiyan.RobPlatform_RobValue or 1800},
}

GvgFinalFightTip.GuildIndex = {
	[1] = {color = "gvg_bg_red", colorName = "Red"},
	[2] = {color = "gvg_bg_blue", colorName = "Blue"},
	[3] = {color = "gvg_bg_purple", colorName = "Purple"},
	[4] = {color = "gvg_bg_green", colorName = "Green"},
	-- (归属方)
}

function GvgFinalFightTip:ctor(go)
	GvgFinalFightTip.super.ctor(self, go);
	self:Init()
end

function GvgFinalFightTip:Init()
	self:initView()
end

function GvgFinalFightTip:initView()
	-- self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.topRankCt = self:FindComponent("topRankCt",UITable)
	self.topRankCt = UIGridListCtrl.new(self.topRankCt,GvgFinalMapRankCell,"GvgFinalMapRankCell")
	self.sectionInfos = self:FindComponent("sectionInfoCt",UIGrid)
	self.sectionInfos = UIGridListCtrl.new(self.sectionInfos,GvgFinalSectionCell,"GvgFinalSectionCell")
	local Title = self:FindComponent("Title",UILabel)
	Title.text = ZhString.GvgFinalFightTip_Title
	local metalNumLabel = self:FindComponent("metalNumLabel",UILabel)
	metalNumLabel.text = ZhString.MainviewGvgFinalPage_Title

	self.timeLabel = self:FindComponent("timeLabel",UILabel)
	local timeDes = self:FindComponent("timeDes",UILabel)
	timeDes.text = ZhString.GvgFinalFightTip_TimeDes

	-- self.closecomp.callBack = function (go)
	-- 	self:CloseSelf();
	-- end

	-- self.gameObject.transform.localPosition = LuaVector3(18,0,0)

	-- local section = self:FindGO("coreSectionCt")
	-- local desLabel = self:FindComponent("desLabel",UILabel,section)
	-- desLabel.text = ZhString.GvgFinalFightTip_CoreDes
	-- self.coreOwnerName = self:FindComponent("ownerName",UILabel,section)

	-- section = self:FindGO("westSectionCt")
	-- desLabel = self:FindComponent("desLabel",UILabel,section)
	-- desLabel.text = ZhString.GvgFinalFightTip_WestDes
	-- self.westOwnerName = self:FindComponent("ownerName",UILabel,section)

	-- section = self:FindGO("eastSectionCt")
	-- desLabel = self:FindComponent("desLabel",UILabel,section)
	-- desLabel.text = ZhString.GvgFinalFightTip_EastDes
	-- self.eastOwnerName = self:FindComponent("ownerName",UILabel,section)
end

function GvgFinalFightTip:initData()
	local secDiff = SuperGvgProxy.Instance:GetFinalFightTimeDiff()

	if secDiff < 0 then
		self.hasWarStart = true
	else
		self.hasWarStart = false
	end

	self.warStartCoundDown = secDiff
	self.warStartedTime = -secDiff

	local infos = SuperGvgProxy.Instance:GetGuildInfos()
	self.topRankCt:ResetDatas(infos)
	
	local towers = SuperGvgProxy.Instance:GetTowers()
	self.sectionInfos:ResetDatas(towers)

	if(self.tickMg)then
		self.tickMg:ClearTick(self)
	else
		self.tickMg = TimeTickManager.Me()
	end
	self.tickMg:CreateTick(0,1000,self.updateCountTime,self)
end

-- function GvgFinalFightTip:SetPos(pos)
-- 	if(self.gameObject~=nil) then
-- 		local p = self.gameObject.transform.position
-- 		pos.z = p.z
-- 		self.gameObject.transform.position = pos
-- 	else
-- 		self.pos = pos
-- 	end 
-- end

function GvgFinalFightTip:OnShow()
	if self.isQurryedTowerInfo == nil or not self.isQurryedTowerInfo then
		-- helplog("<<====GvgFinalFightTip: Call====>>")
		for k,v in pairs(GvgFinalFightTip.EGvgTowerType) do
			SuperGvgProxy.Instance:Active_QueryTowerInfo(k, true)
		end
		self.isQurryedTowerInfo = true
	end

	EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.UpdateCrystal, self)
	EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.UpdateTowers, self)

	self:initData()
end

function GvgFinalFightTip:OnHide()
	if(self.callback)then
		self.callback(self.callbackParam);
	end

	if(self.tickMg)then
		self.tickMg:ClearTick(self)
		self.tickMg = nil
	end
	-- TipsView.Me():HideCurrent();
	if self.isQurryedTowerInfo then
		-- helplog("<<====GvgFinalFightTip: Close====>>")
		for k,v in pairs(GvgFinalFightTip.EGvgTowerType) do
			SuperGvgProxy.Instance:Active_QueryTowerInfo(k, false)
		end
		self.isQurryedTowerInfo = false
	end
	EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.UpdateCrystal, self)
	EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.UpdateTowers, self)
end

function GvgFinalFightTip:SetData()

end

function GvgFinalFightTip:updateCountTime()
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
	if(self.timeLabel) then
		self.timeLabel.text = time
	end
end

-- function GvgFinalFightTip:AddIgnoreBounds(obj)
-- 	if(self.gameObject and self.closecomp)then
-- 		self.closecomp:AddTarget(obj.transform);
-- 	end
-- end

function GvgFinalFightTip:CloseSelf()
	-- if(self.callback)then
	-- 	self.callback(self.callbackParam);
	-- end
	-- self.tickMg:ClearTick(self)
	-- self.tickMg = nil
	-- -- TipsView.Me():HideCurrent();
	-- for k,v in pairs(GvgFinalFightTip.EGvgTowerType) do
	-- 	ServiceFuBenCmdProxy.Instance:CallQueryGvgTowerInfoFubenCmd(k, false)
	-- end
	-- EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgCrystalUpdateFubenCmd, self.UpdateCrystal, self)
	-- EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgTowerUpdateFubenCmd, self.UpdateTowers, self)
end

function GvgFinalFightTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end	
end

function GvgFinalFightTip:UpdateCrystal()
	-- helplog("<<===MainviewGvgFinalPage:UpdateCrystal===>>")
	local infos = SuperGvgProxy.Instance:GetGuildInfos()
	
	self.topRankCt:ResetDatas(infos)
end

function GvgFinalFightTip:UpdateTowers()
	-- helplog("<<===MainviewGvgFinalPage:UpdateTowers===>>")
	local towers = SuperGvgProxy.Instance:GetTowers()
	self.sectionInfos:ResetDatas(towers)
end



