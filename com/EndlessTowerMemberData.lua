EndlessTowerMemberData = class("EndlessTowerMemberData")

function EndlessTowerMemberData:ctor(data)
	self:SetData(data)
end

function EndlessTowerMemberData:SetData(data)
	self.id = data.id
	self.name = data.name

	self.canIn = data.baselv >= GameConfig.EndlessTower.limit_user_lv
	if self.canIn then
		if data.id == Game.Myself.data.id then
			self.agree = true
		end
	else
		self.agree = false
	end
end

function EndlessTowerMemberData:CanIn()
	return self.canIn
end