autoImport("SpriteLabel")
autoImport("CoreView")
CountDownMsg = class("CountDownMsg",CoreView)
CountDownMsg.resID = ResourcePathHelper.UICell("CountDownMsg")

function CountDownMsg:ctor(parent)
	self.gameObject = self:CreateObj(parent)
	self:Init();
end

function CountDownMsg:CreateObj(parent)
	return Game.AssetManager_UI:CreateAsset(CountDownMsg.resID, parent);
end

function CountDownMsg:Init()
	self.tick = TimeTickManager.Me():CreateTick(0,33,self.RefreshTime,self,1,true)
	self.label = SpriteLabel.new(self:FindGO("Msg"):GetComponent("UILabel"))
end

function CountDownMsg:SetData(text,data)
	self.data = data
	self.tick:StartTick()
	self.text = text
	self.countTime = data.time
	self.decimal = data.decimal
	self.isHideTime = data.isHideTime
	self.factor = math.pow(10,data.decimal)
	self.time = math.floor(self:DecimalTime(data.time))
	self.label:Reset()
	self:UpdateUI()
end

function CountDownMsg:DecimalTime(time)
	return math.floor(time*self.factor) / self.factor
end

function CountDownMsg:RefreshTime(delta)
	if(self.countTime==0) then
		self.tick:ClearTick()
		self:DestroySelf()
		return
	end
	self.countTime = math.max(0,self.countTime - delta)
	local time = math.floor(self:DecimalTime(self.countTime))
	if(time~=self.time) then
		if not self.isHideTime then
			self:UpdateUI()
		end
		self.time = time
	end
end

function CountDownMsg:UpdateUI()
	--更新文字写这里
	self.label:SetText(string.format(self.text,self.time),false)
end

function CountDownMsg:DestroySelf()
	if(self.tick) then
		self.tick:ClearTick()
	end
	if(self.gameObject~=nil) then
		GameObject.Destroy(self.gameObject)
	end
	self.hasBeenDestroyed = true
end