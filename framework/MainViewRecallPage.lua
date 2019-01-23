autoImport("RecallContractCell")
autoImport("MainViewRecallCell")

MainViewRecallPage = class("MainViewRecallPage",SubView)

local _bgName = "recall_bg_cat"
local _list = {}
local _mainViewRecallData = {}

function MainViewRecallPage:Init()
	self.topRightFuncGrid = self:FindGO("TopRightFunc2"):GetComponent(UIGrid)
	self.beforePanel = self:FindGO("BeforePanel")

	self:AddViewEvt()
	self:UpdateRecall()
end

function MainViewRecallPage:AddViewEvt()
	self:AddListenEvt(ServiceEvent.ActivityCmdStartGlobalActCmd, self.UpdateRecall)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.HandleSocialDataUpdate)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.HandleSocialDataUpdate)
	self:AddListenEvt(RecallEvent.Select, self.Select)
end

function MainViewRecallPage:InitRecall()
	if self.init == nil then
		ServiceSessionSocialityProxy.Instance:CallQuerySocialData()

		self.gameObject = self:LoadPreferb("view/RecallContractView", self.beforePanel, true)

		self:FindObj()
		self:AddButtonEvt()
		self:InitShow()
		self:ShowSelf(true)

		self.init = true
	end
end

function MainViewRecallPage:DestroyRecall()
	if self.init then
		PictureManager.Instance:UnLoadRecall(_bgName, self.bg)
		GameObject.DestroyImmediate(self.gameObject)

		self:UpdateMainViewRecall(false)

		self.init = nil
	end
end

function MainViewRecallPage:FindObj()
	self.bg = self:FindGO("BgTexture"):GetComponent(UITexture)
	self.contractName = self:FindGO("ContractName"):GetComponent(UILabel)
end

function MainViewRecallPage:AddButtonEvt()
	local closeBtn = self:FindGO("CloseBtn")
	self:AddClickEvent(closeBtn,function ()
		self:ShowSelf(false)
	end)

	local addBtn = self:FindGO("AddBtn")
	self:AddClickEvent(addBtn,function ()
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.RecallContractSelectView})
	end)

	local contractBtn = self:FindGO("ContractBtn")
	self:AddClickEvent(contractBtn,function ()
		if self.selectGuid ~= nil then
			local tempArray = ReusableTable.CreateArray()
			tempArray[1] = self.selectGuid
			ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Contract)
			ReusableTable.DestroyArray(tempArray)
			self:ShowSelf(false)
		else
			MsgManager.ShowMsgByID(3639)
		end
	end)
end

function MainViewRecallPage:InitShow()
	PictureManager.Instance:SetRecall(_bgName, self.bg)

	local tip = self:FindGO("Tip"):GetComponent(UILabel)
	tip.text = string.format(ZhString.Friend_RecallContractTip, #FriendProxy.Instance:GetRecallList(), GameConfig.Recall.ContractTime / (24*60*60))

	local myName = self:FindGO("MyName"):GetComponent(UILabel)
	myName.text = Game.Myself.data.name

	local rewardRoot = self:FindGO("RewardRoot"):GetComponent(UIGrid)
	self.rewardCtl = UIGridListCtrl.new(rewardRoot, RecallContractCell, "RecallContractCell")

	local rewardList = ItemUtil.GetRewardItemIdsByTeamId(GameConfig.Recall.Reward)
	if rewardList ~= nil then
		self.rewardCtl:ResetDatas(rewardList)
	end

	self.activityCtl = UIGridListCtrl.new(self.topRightFuncGrid, MainViewRecallCell, "MainViewRecallCell")
	self.activityCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)

	self:UpdateMainViewRecall(true)
end

function MainViewRecallPage:UpdateRecall()
	if FriendProxy.Instance:CheckRecallActivity() then
		if #FriendProxy.Instance:GetRecallList() > 0 then
			self:InitRecall()
		end
	else
		self:DestroyRecall()
	end
end

function MainViewRecallPage:UpdateMainViewRecall(isAdd)
	TableUtility.ArrayClear(_list)

	if isAdd then
		TableUtility.ArrayPushBack(_list, _mainViewRecallData)
	end

	self.activityCtl:ResetDatas(_list)

	self.topRightFuncGrid.repositionNow = true	
end

function MainViewRecallPage:Select(note)
	local data = note.body
	if data then
		self.selectGuid = data.guid
		self.contractName.text = data:GetName()
	end
end

function MainViewRecallPage:ClickButton()
	self:ShowSelf(true)
end

function MainViewRecallPage:HandleSocialDataUpdate()
	local _FriendProxy = FriendProxy.Instance
	if #_FriendProxy:GetContractData() > 0 then
		_FriendProxy:ClearRecallList()
		self:DestroyRecall()
	end
end

function MainViewRecallPage:ShowSelf(isShow)
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(isShow)
	self.gameObject:SetActive(isShow)
end