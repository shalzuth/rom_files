MainViewFightPage = class("MainViewFightPage",SubView)

local tempVector3 = LuaVector3.zero

MainViewFightPage.TickType ={
	DesertWolfPvpCountDown = 1,
	GorgeousMetalPvpCount = 2,
}

MainViewFightPage.DouCointItemId = 150

function MainViewFightPage:Init()		
	self:AddViewEvts()
	self:initView()
	self:initData()
	self:resetData()
end

function MainViewFightPage:resetData(  )
	self.my_teamscore = nil
	self.enemy_teamscore = nil
	self.remain_hp = nil
	self.player_num = nil
	self.score = nil
	self.type = nil
	self.starttime = nil
	self.tickMg:ClearTick(self)
end

function MainViewFightPage:initData(  )
	-- body
	local pvpCg = GameConfig.PVPConfig and GameConfig.PVPConfig[1] or nil
	self.yoyoPvpToalNumPl = pvpCg and pvpCg.PeopleLimit or 999

	pvpCg =  GameConfig.PVPConfig and GameConfig.PVPConfig[2] or nil
	self.DesertWolfPvpTotalScore = pvpCg and pvpCg.MaxScore or 999
	self.DesertWolfPvpTotalTime = pvpCg and pvpCg.Time or 999

	pvpCg =  GameConfig.PVPConfig and GameConfig.PVPConfig[3] or nil
	self.GorgeousMetalPvpTotalTime = pvpCg and pvpCg.Time or 999

	self.tickMg = TimeTickManager.Me()
end

function MainViewFightPage:Show( tarObj )
	MainViewFightPage.super.Show(self,tarObj)
	if(not tarObj)then
		self:SetData()		
	end
end

function MainViewFightPage:Hide( tarObj )
	MainViewFightPage.super.Hide(self,tarObj)
	if(not tarObj)then
		self:resetData()
	end
end

function MainViewFightPage:SetData(  )
	-- body
	local fightInfo = PvpProxy.Instance:GetFightStatInfo()
	if(fightInfo)then
		local type = fightInfo.pvp_type
		self:changeUIByPvpType(type)
		if(type  == PvpProxy.Type.Yoyo)then
			self:SetYoyoData(fightInfo)
		elseif(type  == PvpProxy.Type.DesertWolf)then
			self:SetDesertWolfData(fightInfo)
		elseif(type  == PvpProxy.Type.GorgeousMetal)then
			self:SetGorgeousMetalData(fightInfo)			
		end
		NGUITools.UpdateWidgetCollider (self.bg.gameObject)
		self:resizeContent()
	end
end

function MainViewFightPage:initView(  )
	-- body	
	self.gameObject = self:FindGO("FightInfoBord")
	self.name = self:FindComponent("Title",UILabel)
	self.countDownLabel = self:FindComponent("CountDownLabel",UILabel)
	self.scoreLabel = self:FindComponent("score",UILabel)
	self.coinCount = SpriteLabel.CreateAsTable()
	self.coinCountLable = self:FindComponent("coinCount",UIRichLabel)
	self.coinCount:Init(self.coinCountLable,nil,20,20)
	self.bg = self:FindComponent("bg",UISprite)
	self.content = self:FindGO("content")
	self.bgSizeX = self.bg.width
end

function MainViewFightPage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.MatchCCmdNtfFightStatCCmd, self.HandleMatchCCmdNtfFightStatCCmd)
	self:AddListenEvt(MyselfEvent.MyDataChange, self.ItemUpdate)

	-- local eventManager = EventManager.Me()
	-- eventManager:AddEventListener(MyselfEvent.SceneGoToUserCmdHanded, self.SceneGoToUserCmd, self)
end

function MainViewFightPage:ItemUpdate( note )
	local userdata = Game.Myself and Game.Myself.data.userdata;
	local num = 0
	if(userdata)then
		num = userdata:Get(UDEnum.PVPCOIN) or 0
	end
	local str = "{itemicon=%s}%s:%s"
	self.coinCount:Reset()
	-- local 
	local itemData = Table_Item[MainViewFightPage.DouCointItemId]
	str = string.format(str,MainViewFightPage.DouCointItemId,itemData.NameZh,num)
	self.coinCount:SetText(str,true)
end

function MainViewFightPage:HandleMatchCCmdNtfFightStatCCmd( note )
	-- body
	self:SetData()
end

function MainViewFightPage:changeUIByPvpType( type )
	-- body
	if(type ~= self.pvpType)then
		self.pvpType = type
		local x,y,z = LuaGameObject.GetLocalPosition(self.scoreLabel.transform)
		if(type  == PvpProxy.Type.Yoyo)then
			self:Hide(self.countDownLabel)
			self.name.text = ZhString.MainViewFightPage_YoyoPvpName
			tempVector3:Set(x,-52,z)
			self.scoreLabel.transform.localPosition = tempVector3

			-- x,y,z = LuaGameObject.GetLocalPosition(self.coinCountLable.transform)
			-- tempVector3:Set(x,-52 - self.scoreLabel.height - 5,z)
			-- self.coinCountLable.transform.localPosition = tempVector3

		elseif(type  == PvpProxy.Type.DesertWolf)then
			self:Show(self.countDownLabel)
			tempVector3:Set(x,-82,z)
			self.scoreLabel.transform.localPosition = tempVector3
			self.name.text = ZhString.MainViewFightPage_DesertWolfPvpName


		elseif(type  == PvpProxy.Type.GorgeousMetal)then
			self:Show(self.countDownLabel)
			tempVector3:Set(x,-82,z)
			self.scoreLabel.transform.localPosition = tempVector3
			self.name.text = ZhString.MainViewFightPage_GorgeousMetalPvpName

			-- x,y,z = LuaGameObject.GetLocalPosition(self.coinCountLable.transform)
			-- tempVector3:Set(x,-82 - self.scoreLabel.height - 5,z)
			-- self.coinCountLable.transform.localPosition = tempVector3

		else
			helplog("error unknow pvp type!!!",type)
		end		
	end
end

function MainViewFightPage:SetYoyoData( fightInfo )
	-- body
	if(fightInfo.player_num ~= self.player_num or fightInfo.score ~= self.score)then
		self.player_num = fightInfo.player_num
		self.score = fightInfo.score
		local score = self.score
		if(score > 999)then
			score = "999+"
		end
		-- helplog(ZhString.MainViewFightPage_YoyoPvpScore,
		--                                 fightInfo.player_num,
		--                                 self.yoyoPvpToalNumPl,
		--                                 fightInfo.score)
		self.scoreLabel.text = string.format(ZhString.MainViewFightPage_YoyoPvpScore,
		                                fightInfo.player_num,
		                                self.yoyoPvpToalNumPl,
		                                score)
	end
	self:setScoreLabelX()
end

function MainViewFightPage:setScoreLabelX(  )
	-- body
	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.scoreLabel.transform,true)
	local width = bd.size.x
	local x,y1,z = LuaGameObject.GetLocalPosition(self.scoreLabel.transform)
	tempVector3:Set((self.bgSizeX - width)/2,y1,z)
	self.scoreLabel.transform.localPosition = tempVector3

	x,y,z = LuaGameObject.GetLocalPosition(self.coinCountLable.transform)
	tempVector3:Set(x,y1 - self.scoreLabel.height - 5,z)
	self.coinCountLable.transform.localPosition = tempVector3

end

function MainViewFightPage:resizeContent(  )
	-- body
	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.content.transform,true)
	local height = bd.size.y
	self.bg.height = height +20
end

function MainViewFightPage:SetDesertWolfData( fightInfo )
	-- body
	if(fightInfo.my_teamscore ~= self.my_teamscore or fightInfo.enemy_teamscore ~= self.enemy_teamscore)then
		self.my_teamscore = fightInfo.my_teamscore
		self.enemy_teamscore = fightInfo.enemy_teamscore
		local my_teamscoreStr = self.my_teamscore
		if(my_teamscoreStr > 999)then
			my_teamscoreStr = "999+"
		end

		local enemy_teamscoreStr = self.enemy_teamscore
		if(enemy_teamscoreStr > 999)then
			enemy_teamscoreStr = "999+"
		end
		-- helplog(ZhString.MainViewFightPage_DesertWolfPvpScore,
		--                                 fightInfo.my_teamscore,
		--                                 self.DesertWolfPvpTotalScore,
		--                                 fightInfo.enemy_teamscore,
		--                                 self.DesertWolfPvpTotalScore)
		self.scoreLabel.text = string.format(ZhString.MainViewFightPage_DesertWolfPvpScore,
		                                my_teamscoreStr,
		                                self.DesertWolfPvpTotalScore,
		                                enemy_teamscoreStr,
		                                self.DesertWolfPvpTotalScore)
	end
	self:setScoreLabelX()
	if(fightInfo.starttime ~= self.starttime)then
		self.starttime = fightInfo.starttime
		self.tickMg:ClearTick(self)
		self.tickMg:CreateTick(0,500,self.updateDesertWolfTime,self,MainViewFightPage.TickType.DesertWolfPvpCountDown)
	end
end

function MainViewFightPage:SetGorgeousMetalData( fightInfo )
	-- body
	if(fightInfo.remain_hp ~= self.remain_hp)then
		self.remain_hp = fightInfo.remain_hp
		self.scoreLabel.text = string.format(ZhString.MainViewFightPage_GorgeousMetalPvpScore,
		                                fightInfo.remain_hp)
	end
	self:setScoreLabelX()
	if(fightInfo.starttime ~= self.starttime)then
		self.starttime = fightInfo.starttime
		self.tickMg:ClearTick(self)
		self.tickMg:CreateTick(0,500,self.updateGorgeousMetalTime,self,MainViewFightPage.TickType.GorgeousMetalPvpCount)
	end
end

function MainViewFightPage:updatePvpTime( totalTime,type )
	local pastTime = ServerTime.CurServerTime()/1000 - self.starttime;
	local leftTime = totalTime - pastTime
	if(leftTime < 0)then
		leftTime = 0
		self.tickMg:ClearTick(self,type)
	end
	leftTime = math.floor(leftTime)

	local m = math.floor(leftTime / 60)
	local mStr = m
	if(m < 10 and m > 0) then
		mStr = "0"..m
	elseif(m == 0)then
		mStr = "00"
	end

	local sd = leftTime - m*60
	local sdStr = sd
	if(sd < 10 and sd > 0) then
		sdStr = "0"..sd
	elseif(sd == 0)then
		sdStr = "00"
	end
	leftTime = string.format("%s:%s",mStr,sdStr)
	self.countDownLabel.text = leftTime
end

function MainViewFightPage:updateGorgeousMetalTime(  )
	self:updatePvpTime(self.GorgeousMetalPvpTotalTime,MainViewFightPage.TickType.GorgeousMetalPvpCount)
end

function MainViewFightPage:updateDesertWolfTime(  )
	self:updatePvpTime(self.DesertWolfPvpTotalTime,MainViewFightPage.TickType.DesertWolfPvpCountDown)
end