autoImport("DojoRewardCell")

DojoResultPopUp = class("DojoResultPopUp", ContainerView)

DojoResultPopUp.ViewType = UIViewType.NormalLayer

function DojoResultPopUp:Init()
	local resultData = self.viewdata.viewdata
	if resultData then
		self.dojoid = resultData.dojoid
		self.passtype = resultData.passtype

		self:InitView()
	end
end

function DojoResultPopUp:InitView()
	self.name = self:FindComponent("Name", UILabel)
	self.tipName = self:FindComponent("TipName" , UILabel)
	self.countDownLabel = self:FindComponent("CountDownLabel" , UILabel)
	self.emptyTip = self:FindGO("EmptyTip")

	self.anim1 = self:FindGO("Anim1")
	self.anim2 = self:FindGO("Anim2")
	self.anim3 = self:FindGO("Anim3")

	local grid = self:FindGO("Grid"):GetComponent(UIGrid)
	self.rewardCtl = UIGridListCtrl.new(grid, DojoRewardCell, "DojoRewardCell")

	self:AddViewEvts()
	self:UpdateInfo()

	TimeTickManager.Me():CreateTick(0,1000,self.RefreshTime,self)
end

 function DojoResultPopUp:AddViewEvts()
 	self:AddListenEvt(ServiceEvent.PlayerMapChange , self.CloseSelf)
 end

function DojoResultPopUp:UpdateInfo()
	local dojoData = Table_Guild_Dojo[self.dojoid]
	if dojoData then
		if dojoData.Name then
			self.name.text = dojoData.Name
		else
			errorLog("DojoResultPopUp UpdateInfo dojoData.Name = nil")
		end

		if dojoData.Raid then
			local mapRaid = Table_MapRaid[dojoData.Raid]
			if mapRaid then
				self.endWait = mapRaid.EndWait		
			end
		else
			errorLog("DojoResultPopUp UpdateInfo dojoData.Raid = nil")
		end
	end

	local items = DojoProxy.Instance:GetReward()
	LogUtility.InfoFormat("DojoResultPopUp #items : {0}",tostring(#items))
	self.rewardCtl:ResetDatas(items)

	if self.passtype == DojoProxy.PassType.First then
		self.tipName.text = ZhString.Dojo_Reward
		self.emptyTip:SetActive(false)

	elseif self.passtype == DojoProxy.PassType.Help then
		self.tipName.text = ZhString.Dojo_HelpReward
		self.emptyTip:SetActive(false)

	elseif self.passtype == DojoProxy.PassType.Normal then
		self.tipName.text = ZhString.Dojo_Reward
		self.emptyTip:SetActive(true)
	end
end

function DojoResultPopUp:RefreshTime()
	self.countDownLabel.text = string.format(ZhString.Dojo_Secend , tostring(self.endWait))
	self.endWait = self.endWait - 1
	if self.endWait < 0 then
		self.endWait = 0
	end
end

function DojoResultPopUp:PlayAnim()
	self.anim1:SetActive(false)
	self.anim2:SetActive(false)
	self.anim3:SetActive(false)

	self.anim1Call = LeanTween.delayedCall(1.5, function ()
		self.anim1Call = nil
		self.anim1:SetActive(true)
		self.anim2Call = LeanTween.delayedCall(0.3, function ()
			self.anim2Call = nil
			self.anim2:SetActive(true)
			self.anim3Call = LeanTween.delayedCall(0.3, function ()
				self.anim3Call = nil
				self.anim3:SetActive(true)
			end)
		end)
	end)
end

function DojoResultPopUp:OnEnter()
	DojoResultPopUp.super.OnEnter(self)
	self:CameraRotateToMe()

	self:PlayAnim()
end

function DojoResultPopUp:OnExit()
	TimeTickManager.Me():ClearTick(self)
	if self.anim1Call then
		self.anim1Call:cancel()
		self.anim1Call = nil
	end
	if self.anim2Call then
		self.anim2Call:cancel()
		self.anim2Call = nil
	end
	if self.anim3Call then
		self.anim3Call:cancel()
		self.anim3Call = nil
	end
	DojoResultPopUp.super.OnExit(self)
	self:CameraReset()
end