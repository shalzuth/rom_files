autoImport("Table_Question")

WeddingQuestionView = class("WeddingQuestionView",ContainerView)

WeddingQuestionView.ViewType = UIViewType.NormalLayer

local _WeddingProxy = WeddingProxy.Instance

function WeddingQuestionView:OnExit()
	self:CameraReset()
	ServiceWeddingCCmdProxy.Instance:CallWeddingSwitchQuestionCCmd(false)
	WeddingQuestionView.super.OnExit(self)
end

function WeddingQuestionView:Init()
	self:FindObj()
	self:AddEvt()
	self:AddViewEvt()
	self:InitShow()
end

function WeddingQuestionView:FindObj()
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.contentEffect = self.content.gameObject:GetComponent(TypewriterEffect)
	self.collider = self:FindGO("Dialog"):GetComponent(BoxCollider)
	self.choose = self:FindGO("Choose")
	self.chooseA = self:FindGO("ChooseA", self.choose):GetComponent(UILabel)
	self.chooseB = self:FindGO("ChooseB", self.choose):GetComponent(UILabel)	
end

function WeddingQuestionView:AddEvt()
	self:AddClickEvent(self.collider.gameObject, function ()
		if self.canAnswer then
			self.contentEffect:Finish()
			if self.questionid ~= nil then
				ServiceWeddingCCmdProxy.Instance:CallAnswerWeddingCCmd(self.questionid, 1)
			end
			self.collider.enabled = false

			self.canAnswer = false
		end
	end)
	self:AddClickEvent(self.chooseA.gameObject, function ()
		if self.canAnswer and self.questionid ~= nil then
			ServiceWeddingCCmdProxy.Instance:CallAnswerWeddingCCmd(self.questionid, 1)

			self.canAnswer = false
		end
	end)

	self:AddClickEvent(self.chooseB.gameObject, function ()
		if self.canAnswer and self.questionid ~= nil then
			ServiceWeddingCCmdProxy.Instance:CallAnswerWeddingCCmd(self.questionid, 2)

			self.canAnswer = false
		end
	end)
	EventDelegate.Set(self.contentEffect.onFinished, function ()
		self.canAnswer = true
	end)
end

function WeddingQuestionView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.WeddingCCmdQuestionWeddingCCmd, self.HandleQuestion)
	self:AddListenEvt(ServiceEvent.WeddingCCmdWeddingSwitchQuestionCCmd, self.HandleSwitchQuestion)
end

function WeddingQuestionView:InitShow()
	self.collider.enabled = false

	self.canAnswer = false
end

function WeddingQuestionView:HandleQuestion(note)
	local data = note.body
	if data ~= nil then
		self.questionid = data.questionid
		helplog("HandleQuestion",self.questionid)
		local staticData = Table_Question[self.questionid]
		if staticData ~= nil then
			local question = staticData.Title

			if self:CheckCanAnswer(data.charids) then
				if self.questionid == 11 then
					question = string.format(question, Game.Myself.data.name, _WeddingProxy:GetPartnerName())
				end

				local isShowOption = #staticData.Option > 0
				self.choose:SetActive(isShowOption)
				self.collider.enabled = not isShowOption
				if isShowOption then
					local optionA = staticData.Option[1]
					if optionA ~= nil then
						self.chooseA.text = optionA.content
					end

					local optionB = staticData.Option[2]
					if optionB ~= nil then
						self.chooseB.text = optionB.content
					end
				end
			else
				if self.questionid == 11 then
					question = string.format(question, _WeddingProxy:GetPartnerName(), Game.Myself.data.name)
				end

				self.choose:SetActive(false)
				self.collider.enabled = false
			end

			self.content.text = question

			self.contentEffect:ResetToBeginning()
		end
	end
end

function WeddingQuestionView:HandleSwitchQuestion(note)
	local data = note.body
	if data ~= nil then
		if data.onoff == true then
			local npcId = data.npcguid
			if npcId ~= nil then
				local npc = NSceneNpcProxy.Instance:Find(npcId)
				if npc ~= nil then
					local viewPort = CameraConfig.WeddingQuestion_ViewPort
					local rotation = CameraConfig.WeddingQuestion_Rotation
					self:CameraFaceTo(npc.assetRole.completeTransform,viewPort,rotation)
				end
			end
		else
			self:CloseSelf()
		end
	end
end

function WeddingQuestionView:CheckCanAnswer(charids)
	for i=1,#charids do
		if charids[i] == Game.Myself.data.id then
			return true
		end
	end

	return false
end