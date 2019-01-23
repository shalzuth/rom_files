local baseCell = autoImport("BaseCell")
NormalStageListCell = class("NormalStageListCell",baseCell)

function NormalStageListCell:Init()
	self.locked = false
	self.questNotFinish = nil
	self.bossFlag = self:FindGO("BossFlag"):GetComponent(UISprite)
	self.lockFg = self:FindGO("LockFg"):GetComponent(UISprite)
	self.enterLabel = self:FindGO("EnterLabel"):GetComponent(UILabel)
	self.stageName = self:FindGO("StageName"):GetComponent(UILabel)
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
	self.enterLock = self:FindGO("EnterLock"):GetComponent(UISprite)
	self.stars = {}
	for i=1,3 do
		self.stars[i] = self:FindGO("Star"..i):GetComponent(UISprite)
	end
	self:SetEvent(self.gameObject,function ()
		if(self.locked) then
			self:ErrorMsg()
		end
	end)
	self.btn = self:FindGO("EnterBtn"):GetComponent(UIButton)
	self:SetEvent(self.btn.gameObject,function ()
		if(self.locked) then
			self:ErrorMsg()
		else
			self:Notify(WorldMapEvent.ShowLevelDetail,self.data);
			-- ServiceFuBenCmdProxy.Instance:CallStartStageUserCmd(self.data.mainStage.id, self.data.staticData.Step, self.type)
		end
	end)
end

function NormalStageListCell:ErrorMsg( )
	if(self.questNotFinish) then
		MsgManager.ShowMsgByIDTable(101,{self.data.staticData.Quest})
	end
	if(self.data.state == SubStageData.LockState) then
		local previousSub = DungeonProxy.Instance:GetPreivousSub(self.data)
		if(previousSub~=nil) then
			MsgManager.ShowMsgByIDTable(102,{previousSub.mainStage.staticData.name,previousSub.staticData.Name})
		end
	end
end

function NormalStageListCell:SetData(data)
	self.lockReason = nil
	self.data = data
	self.stageName.text = data.staticData.Name
	for i=1,3 do
		if(data.star >=i) then
			self.stars[i].spriteName = "fb_icon_star"
		else
			self.stars[i].spriteName = "fb_icon_star2"
		end
	end
	if(data.staticData.Quest ~= nil) then
		if(QuestProxy.Instance:isMainQuestCompleteByStepId(data.staticData.Quest)==false) then
			self.questNotFinish = true
		end
	end
	self:SetLock(data.state == SubStageData.LockState or self.questNotFinish)
	self.bossFlag.gameObject:SetActive(data.staticData.Step >= data.mainStage:MaxNormalStep())
end

function NormalStageListCell:SetLock(val)
	self.locked = val
	if(val) then
		self.lockFg.gameObject:SetActive(true)
		self.enterLock.gameObject:SetActive(true)
		self.enterLabel.gameObject:SetActive(false)
	else
		self.lockFg.gameObject:SetActive(false)
		self.enterLock.gameObject:SetActive(false)
		self.enterLabel.gameObject:SetActive(true)
	end
end