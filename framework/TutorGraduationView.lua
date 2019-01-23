autoImport("TutorItemCell")
autoImport("ConditionItem")

TutorGraduationView = class("TutorGraduationView",ContainerView)

TutorGraduationView.ViewType = UIViewType.PopUpLayer

local tipData = {}
tipData.funcConfig = {}
local  reward = {}
local rid = ResourcePathHelper.UICell("ConditionItem")
function TutorGraduationView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
	TutorProxy.Instance:RefreshState()
end

function TutorGraduationView:FindObj()
	self.receiveBtnBG = self:FindGO("GraduationBtn"):GetComponent(UIMultiSprite)
	self.scrollview = self:FindGO("ConditionScrollview"):GetComponent(UIScrollView)
	self.table = self:FindGO("Table",self.scrollview.gameObject)
	self.receiveBtnLable = self:FindGO("Label", self.receiveBtnBG.gameObject):GetComponent(UILabel)
end

function TutorGraduationView:AddButtonEvt()
	local graduationBtn = self:FindGO("GraduationBtn")
	self:AddClickEvent(graduationBtn, function ()
		self:Graduation()
	end)	
end

function TutorGraduationView:AddViewEvt()
	self:AddListenEvt(MyselfEvent.LevelUp, self.UpdateList)
	self:AddListenEvt(ServiceEvent.TutorTutorGetGrowRewardCmd, self.UpdateList)
end

function TutorGraduationView:InitShow()
	self:CreateList()
end

function TutorGraduationView:CreateList()
	local  data = TutorProxy.Instance:GetGrowthRewards()
	self.itemListTable = WrapScrollViewHelper.new(ConditionItem, rid, 
		self.scrollview.gameObject, self.table, #data)
	self:UpdateList()
end

function TutorGraduationView:UpdateList()
	local  data = TutorProxy.Instance:GetGrowthRewards()
	self.itemListTable:ResetPosition(data)
	self:UpdateLabel()
end

function TutorGraduationView:UpdateLabel()
	local gradLevel = GameConfig.Tutor.student_graduation_baselv_req
	local level = MyselfProxy.Instance:RoleLevel()
	self.canGraduation = level >= gradLevel

	self.receivedAllGrowth = true
	local  _TutorProxy = TutorProxy.Instance
	local data = _TutorProxy:GetGrowthRewards()
	local length = #data
	for i=1,length do
		if data[i].canGet ~= 2 and data[i].Type == 1 then
			self.receivedAllGrowth = false
			break
		end
	end
	if self.receivedAllGrowth then
		self.receiveBtnLable.text = ZhString.Tutor_Graduate
	else 
		self.receiveBtnLable.text = ZhString.Tutor_ReceiveReward
	end

	if _TutorProxy.needRedTip or self.canGraduation then
		self.receiveBtnBG.CurrentState = 0
		self.receiveBtnLable.effectStyle = UILabel.Effect.Outline
	else
		self.receiveBtnBG.CurrentState = 1
		self.receiveBtnLable.effectStyle = UILabel.Effect.None
	end
end

function TutorGraduationView:Graduation()
	local level = MyselfProxy.Instance:RoleLevel()
	self.canGraduation = level >= GameConfig.Tutor.student_graduation_baselv_req
	if self.receivedAllGrowth then
		if self.canGraduation then
			local myTutor = TutorProxy.Instance:GetMyTutor()
			if myTutor then
				local createtime = myTutor:GetCreatetime(SocialManager.SocialRelation.Tutor)
				if createtime ~= 0 then
					local graduationTime = GameConfig.Tutor.student_graduation_time
					local sec = ServerTime.CurServerTime()/1000 - createtime
					local day = math.floor(sec / 86400)
					if day >= graduationTime then
						FuncShortCutFunc.Me():CallByID(971)
						self:CloseSelf()
					else
						MsgManager.ShowMsgByID(3231, graduationTime)
					end
				end
			end
		else
			MsgManager.ShowMsgByID(3230)			
		end
	else
		if TutorProxy.Instance.needRedTip then
			ServiceTutorProxy.Instance:CallTutorGetGrowRewardCmd()
		else
			MsgManager.ShowMsgByID(3250)
		end
	end
end

function TutorGraduationView:ClickItem(cell)
	local data = cell.data
	if data then
		tipData.itemdata = data
		self:ShowItemTip(tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220,0})
	end
end