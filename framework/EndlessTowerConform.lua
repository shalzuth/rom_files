EndlessTowerConform = class("EndlessTowerConform",CoreView)

function EndlessTowerConform:ctor(go)
	if(go)then
		EndlessTowerConform.super.ctor(self, go);
		self:Init()
	end
end

function EndlessTowerConform:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function EndlessTowerConform:FindObjs()
	self.tipLabel = self:FindGO("Tip"):GetComponent(UILabel)
	self.nobtn = self:FindGO("NoBtn")
	self.yesbtn = self:FindGO("YesBtn")
	self.yestip = self:FindGO("Label", self.yesbtn):GetComponent(UILabel)
	self.lab = self:FindGO("Context"):GetComponent(UILabel)
	self.timeSlider = self:FindGO("TimeSlider"):GetComponent(UISlider)
end

function EndlessTowerConform:AddEvts()
	self:AddClickEvent(self.yesbtn, function (go)
		self:ClickYesEvent(go);
	end)
	self:AddClickEvent(self.nobtn, function (go)
		self:ClickNoEvent(go);
	end)
end

function EndlessTowerConform:AddViewEvts()

end

function EndlessTowerConform:Show()
	self.gameObject:SetActive(true)
	TimeTickManager.Me():CreateTick(0, 33, function (self, deltatime)
			self.timeSlider.value=self.timeSlider.value-0.001
			if(self.timeSlider.value<0.001)then
				self:Hide()
				ServiceInfiniteTowerProxy.Instance:CallTeamTowerReplyCmd(2,Game.Myself.data.id)
			end
		end, 
			self, 4);
end

function EndlessTowerConform:Hide()
	self.gameObject:SetActive(false)
	TimeTickManager.Me():ClearTick(self,4)
	self.timeSlider.value=1
end

function EndlessTowerConform:InitShow()
	self:Hide()
	-- LeanTween.delayedCall (self.gameObject, 2, function ()
	-- 	self:Show()
	-- end)
end

function EndlessTowerConform:ClickYesEvent(go)
	print("ClickYesEvent")
	self:Hide()
	local nowleader = TeamProxy.Instance.myTeam:GetNowLeader();
	self:sendNotification(FollowEvent.Follow, nowleader.id);
	ServiceInfiniteTowerProxy.Instance:CallTeamTowerReplyCmd(1,Game.Myself.data.id)	
end

function EndlessTowerConform:ClickNoEvent(go)
	print("ClickNoEvent")
	self:Hide()
end

