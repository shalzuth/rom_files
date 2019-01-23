CountDownView = class("CountDownView",SubView)

function CountDownView:Init()
	self:FindObjs()
	self:AddViewEvts()
	self:initData()
end

function CountDownView:initData()
	local data = DojoProxy.Instance:GetCountdownUserCmd()
	self:ReceiveTickData(data)
end

function CountDownView:FindObjs()	
	self.gameObject = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("CountDownView"), self.gameObject);
	self.gameObject.transform.localPosition = Vector3(0,35,0)
	self.gameObject.name = "CountDownView";	
	self.content = self:FindComponent("Content",UILabel)
	self:Hide()
end

function CountDownView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.FuBenCmdCountdownUserCmd , self.FuBenCmdCountdownUserCmd)
end

function CountDownView:FuBenCmdCountdownUserCmd( note )
	-- body
	-- printRed("CountDownView:FuBenCmdCountdownUserCmd( note )")
	self:ReceiveTickData(note.body)
end

function CountDownView:ReceiveTickData( data )
	-- body
	self:stopTick()
	self.data = data
	if self.data and self.data.tick and self.data.tick ~= 0 then
		self:startTick()
	else
		self:stopTick()
	end
end

function CountDownView:OnExit( ... )
	-- body
	self:stopTick()
end

function CountDownView:stopTick(  )
	-- body
	self:Hide()
	TimeTickManager.Me():ClearTick(self)
end

function CountDownView:startTick()
	self:Show()
	self.tick = self.data.tick
	self.content.text = string.format(ZhString.CountDownTip , tostring(self.tick))
	TimeTickManager.Me():CreateTick(0,1000,self.UpdateTip,self)
end

function CountDownView:UpdateTip()
	if(self.tick <= 0)then
		self:stopTick()
		return
	end
	self.content.text = string.format(ZhString.CountDownTip , tostring(self.tick))
	self.tick = self.tick - 1
end