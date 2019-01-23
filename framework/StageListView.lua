autoImport("NormalStageListCell")
autoImport("EliteStageListCell")
StageListView = class("StageListView",SubView)

function StageListView:Init()
	self.gameObject = self:FindChild("StageListView")
	self:AddButtonEvent("StageListCloseButton", function (go)
		self.gameObject:SetActive(false)
	end)
	self:InitView()
	self:MapViewListener();
	self.gameObject:SetActive(false)
end

function StageListView:MapViewListener()
	self:AddListenEvt(ServiceEvent.FuBenCmdStageStepUserCmd, self.UpdateData);
	self:AddListenEvt(ServiceEvent.FuBenCmdGetRewardStageUserCmd, self.UpdateView);
end

function StageListView:InitView()
	self:InitNormalPage()
	self:InitElitePage()
end

function StageListView:InitNormalPage()
	self.normalStarProgress = self:FindChild("NormalStageStarBar"):GetComponent(UIProgressBar)
	self.normalStarNum = self:FindChild("NormalStageStar"):GetComponent(UILabel)
	self.rewardBtns = {}
	self.rewardSprites = {}
	self.rewardStars = {}
	for i=1,3 do
		self.rewardSprites[i] = self:FindChild("Box"..i.."Btn"):GetComponent(UISprite)
		self.rewardStars[i] = self:FindChild("Box"..i.."Star"):GetComponent(UISprite)
		self.rewardBtns[i] = self:FindChild("Box"..i.."Btn"):GetComponent(UIButton)
		self:AddButtonEvent("Box"..i.."Btn", function (go)
			local needStar = self.data.staticData["rewardsValue"..i]
			if(self.rewardSprites[i].spriteName == "ui_9") then
				print("已领取")
			else
				if(needStar<=self.data.currentStars) then
					ServiceFuBenCmdProxy.Instance:CallGetRewardStageUserCmd(self.data.id,needStar)
				else
					MsgManager.ShowMsgByIDTable(106)
				end
			end
		end)
	end
	self.normalGrid = self:FindChild("NormalStageGrid"):GetComponent(UIGrid)
	self.normalList = UIGridListCtrl.new(self.normalGrid,NormalStageListCell,"NormalStageListCell")
end

function StageListView:InitElitePage()
	self.eliteGrid = self:FindChild("EliteStageGrid"):GetComponent(UIGrid)
	self.eliteList = UIGridListCtrl.new(self.eliteGrid,EliteStageListCell,"EliteStageListCell")
end

function StageListView:UpdateData(note)
	self.gameObject:SetActive(true)
	self:SetData(note.body)
end

function StageListView:UpdateView(note)
	self:SetData(self.data)
end

function StageListView:SetData(mainStageData)
	self.data = mainStageData
	self.normalStarNum.text = mainStageData.currentStars.."/15"
	self.normalStarProgress.value = mainStageData.currentStars/15.0
	for i=1,3 do
		self:UpdateNormalStar(i)
	end
	self.normalList:ResetDatas(self.data.normalSubStage)
	self.eliteList:ResetDatas(self.data.eliteSubStage)
end

function StageListView:UpdateNormalStar(index)
	local needStar = self.data.staticData["rewardsValue"..index]
	if(self.data.currentStars >= needStar) then
		self.rewardStars[index].spriteName = "fb_icon_star"
	else
		self.rewardStars[index].spriteName = "fb_icon_star2"
	end
	if(TableUtil.ArrayIndexOf(self.data.rewardGetList,needStar)~=0) then
		self.rewardSprites[index].spriteName = "ui_9"
		self.rewardBtns[index].normalSprite = "ui_9"
	else
		self.rewardSprites[index].spriteName = "ui_8"
		self.rewardBtns[index].normalSprite = "ui_8"
	end
end