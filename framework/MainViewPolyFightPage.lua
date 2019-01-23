MainViewPolyFightPage = class("MainViewPolyFightPage",SubView)

local tempVector3 = LuaVector3.zero

MainViewPolyFightPage.CointItemId = 157
-- MainViewPolyFightPage.CointItemId = 110

function MainViewPolyFightPage:Init()
	self:AddViewEvts()
	self:initView()
	self:initData()
	self:resetData()
end

function MainViewPolyFightPage:resetData(  )
	self.player_num = nil
	self.starttime = nil
	self.score = 0
	self.tickMg:ClearTick(self)
end

function MainViewPolyFightPage:initData(  )
	-- body
	local pvpCg = GameConfig.PVPConfig and GameConfig.PVPConfig[4] or nil
	self.totalTime = pvpCg and pvpCg.Time or 300
	self.personLimit = pvpCg and pvpCg.PeopleLimit or 10
	self.tickMg = TimeTickManager.Me()
	self.score = 0
end

function MainViewPolyFightPage:Show( tarObj )
	MainViewPolyFightPage.super.Show(self,tarObj)
	if(not tarObj)then
		self:SetData()
	end
end

function MainViewPolyFightPage:Hide( tarObj )
	MainViewPolyFightPage.super.Hide(self,tarObj)
	if(not tarObj)then
		self:resetData()
	end
end

function MainViewPolyFightPage:SetData(  )
	-- body
	local fightInfo = PvpProxy.Instance:GetFightStatInfo()
	if(fightInfo.player_num ~= self.player_num )then
		self.player_num = fightInfo.player_num
		self.curPersonNum.text = string.format(ZhString.MainViewPolyFightPage_CurPersonNum,
		                                fightInfo.player_num,
		                                self.personLimit)
	end
	-- self:setScoreLabelX()
	if(fightInfo.starttime ~= self.starttime)then
		self.starttime = fightInfo.starttime
		self.tickMg:ClearTick(self)
		self.tickMg:CreateTick(0,500,self.updatePvpTime,self)
	end

	if(fightInfo.score ~= self.score)then
		self.score = fightInfo.score
		local str = ZhString.MainViewPolyFightPage_GoldAppleNum
		self.applCount:Reset()
		str = string.format(str,self.score,MainViewPolyFightPage.CointItemId)
		self.applCount:SetText(str,true)
	end	

	local str = ZhString.MainViewPolyFightPage_MyRank
	local myRank = fightInfo.myrank or "?"
	self.myRank.text = string.format(str,myRank)
	self:updateRankChangeCCmd()
end

function MainViewPolyFightPage:initView(  )
	-- body	
	self.gameObject = self:FindGO("PolyFightInfoBord")
	self.name = self:FindComponent("Title",UILabel)
	self.name.text = ZhString.MainViewPolyFightPage_Title
	self.curPersonNum = self:FindComponent("curPersonNum",UILabel)
	self.myRank = self:FindComponent("myRank",UILabel)
	self.progressLabel = self:FindComponent("progressLabel",UILabel)
	self.applCount = SpriteLabel.CreateAsTable()
	self.goldAppleNum = self:FindComponent("goldAppleNum",UIRichLabel)
	self.applCount:Init(self.goldAppleNum,nil,30,30,true)
	self.progressSlider = self:FindComponent("progress",UISlider)
	self.firstName = self:FindComponent("firstName",UILabel)
	self.secondName = self:FindComponent("secondName",UILabel)
	self.thirdName = self:FindComponent("thirdName",UILabel)
	self.rankLabels = {self.firstName,self.secondName,self.thirdName}
	self.bg = self:FindComponent("bg",UISprite)
	self.content = self:FindGO("content")
	self.bgSizeX = self.bg.width
end

function MainViewPolyFightPage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.MatchCCmdNtfFightStatCCmd, self.HandleMatchCCmdNtfFightStatCCmd)
	self:AddListenEvt(ServiceEvent.MatchCCmdNtfRankChangeCCmd, self.updateRankChangeCCmd)
	-- self:AddListenEvt(ItemEvent.ItemUpdate,self.ItemUpdate)	
end

function MainViewPolyFightPage:ItemUpdate(  )
	-- local num = BagProxy.Instance:GetItemNumByStaticID(MainViewPolyFightPage.CointItemId) or 0
	-- local str = ZhString.MainViewPolyFightPage_GoldAppleNum
	-- self.applCount:Reset()
	-- str = string.format(str,num,MainViewPolyFightPage.CointItemId)
	-- self.applCount:SetText(str,true)
end

function MainViewPolyFightPage:HandleMatchCCmdNtfFightStatCCmd( note )
	-- body
	self:SetData()
end

function MainViewPolyFightPage:setScoreLabelX(  )
	-- body
	-- local bd = NGUIMath.CalculateRelativeWidgetBounds(self.scoreLabel.transform,true)
	-- local width = bd.size.x
	-- local x,y1,z = LuaGameObject.GetLocalPosition(self.scoreLabel.transform)
	-- tempVector3:Set((self.bgSizeX - width)/2,y1,z)
	-- self.scoreLabel.transform.localPosition = tempVector3

	-- x,y,z = LuaGameObject.GetLocalPosition(self.coinCountLable.transform)
	-- tempVector3:Set(x,y1 - self.scoreLabel.height - 5,z)
	-- self.coinCountLable.transform.localPosition = tempVector3

end

-- function MainViewPolyFightPage:resizeContent(  )
-- 	-- body
-- 	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.content.transform,true)
-- 	local height = bd.size.y
-- 	self.bg.height = height +20
-- end

function MainViewPolyFightPage:updateRankChangeCCmd( )
	local fightInfo = PvpProxy.Instance:GetFightStatInfo()
	for i=1,3 do
		local label = self.rankLabels[i]
		local data = fightInfo.ranks and fightInfo.ranks[i] or nil
		label.text = data and data.name or "？？？"
	end
end

function MainViewPolyFightPage:updatePvpTime( )
	local pastTime = ServerTime.CurServerTime()/1000 - self.starttime;
	local leftTime = self.totalTime - pastTime
	if(leftTime < 0)then
		leftTime = 0
		self.tickMg:ClearTick(self)
	end
	leftTime = math.floor(leftTime)

	local m = math.floor(leftTime / 60)
	local sd = leftTime - m*60
	local leftTimeStr = string.format("%02d:%02d",m,sd)
	self.progressLabel.text = leftTimeStr
	self.progressSlider.value = leftTime/self.totalTime
end