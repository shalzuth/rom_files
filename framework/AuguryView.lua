autoImport("AuguryChatView")

AuguryView = class("AuguryView",ContainerView)

AuguryView.ViewType = UIViewType.NormalLayer

AuguryView.EffectStateName = {
	HandExit = "DivineHand_1Exit",
	CrystalBallIdle = "CrystalBall1",
	CrystalBallTalk = "CrystalBall2",
	CrystalBallBomb = "CrystalBall3",
}

AuguryView.Action = {
	CatWait = "wait",
	CatTalk = "state1001",
	CatChoose = "state2001",
}

local EffectKey_PlayHandL = "EffectKey_PlayHandL"
local EffectKey_PlayHandR = "EffectKey_PlayHandR"
local EffectKey_PlayFire = "EffectKey_PlayFire"
local EffectKey_PlayCrystalBall = "EffectKey_PlayCrystalBall"

local _minMaxGradient = ParticleSystem.MinMaxGradient(ColorUtil.NGUIWhite)

function AuguryView:OnExit()
	self:CameraReset()
	self:Reset()
	ServiceSceneAuguryProxy.Instance:CallAuguryQuit()
	AuguryView.super.OnExit(self)
end

function AuguryView:Init()
	self:FindObj()
	self:AddEvt()
	self:AddViewEvt()
	self:InitShow()
end

function AuguryView:FindObj()
	self.collider = self:FindGO("Collider")

	self.dialogRoot = self:FindGO("DialogRoot")
	self.dialogContent = self:FindGO("Content" , self.dialogRoot):GetComponent(UILabel)
	self.dialogContentEffect = self.dialogContent.gameObject:GetComponent(TypewriterEffect)
	self.dialogChoose = self:FindGO("Choose" , self.dialogRoot)
	self.dialogChooseA = self:FindGO("ChooseA" , self.dialogRoot):GetComponent(UILabel)
	self.dialogChooseB = self:FindGO("ChooseB" , self.dialogRoot):GetComponent(UILabel)

	self.tipRoot = self:FindGO("TipRoot")
	self.tipContent = self:FindGO("Content" , self.tipRoot):GetComponent(UILabel)
	self.tipTitle = self:FindGO("Title" , self.tipRoot):GetComponent(UILabel)
	self.tipBg = self:FindGO("Bg", self.tipRoot):GetComponent(UISprite)
	self.tipBg1 = self:FindGO("Bg1", self.tipRoot):GetComponent(UISprite)

	self.chooseRoot = self:FindGO("ChooseRoot")
	
	--todo xde 屏蔽星座语音
	self.inputRoot = self:FindGO("InputRoot")
	self.inputRoot:SetActive(false)

	self.dialogChooseA.overflowMethod = 3
	self.dialogChooseABg = self:FindGO("bg" , self.dialogChooseA.gameObject):GetComponent(UISprite)
	self.dialogChooseABg.height = 44
	self.dialogChooseA.width = 200

	self.dialogChooseB.overflowMethod = 3
	self.dialogChooseBBg = self:FindGO("bg" , self.dialogChooseB.gameObject):GetComponent(UISprite)
	self.dialogChooseBBg.height = 44
	self.dialogChooseB.width = 200
end

function AuguryView:AddEvt()
	self:AddListenEvt(ServiceEvent.SceneAuguryAuguryTitle , self.RecvAuguryTitle)
	self:AddListenEvt(ServiceEvent.SceneAuguryAuguryAnswer , self.RecvAuguryAnswer)
	self:AddListenEvt(ServiceEvent.SceneAuguryAuguryQuit , self.RecvAuguryQuit)
end

function AuguryView:AddViewEvt()
	self:AddClickEvent( self.collider ,function ()
		self.dialogContentEffect:Finish()
		self:UpdateQuestion()
		self.collider:SetActive(false)
	end)
	local tipConfirm = self:FindGO("Confirm" , self.tipRoot)
	self:AddClickEvent( tipConfirm ,function ()
		self:CloseSelf()
	end)
	local chooseA = self:FindGO("ChooseA" , self.chooseRoot)
	self:AddClickEvent( chooseA ,function ()
		self:ChooseA()
	end)
	self:AddClickEvent( self.dialogChooseA.gameObject ,function ()
		self:ChooseA()
	end)
	local chooseB = self:FindGO("ChooseB" , self.chooseRoot)
	self:AddClickEvent( chooseB ,function ()
		self:ChooseB()
	end)
	self:AddClickEvent( self.dialogChooseB.gameObject ,function ()
		self:ChooseB()
	end)
	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton, function (go)
		MsgManager.ConfirmMsgByID(929,function ()
			self:CloseSelf()
		end )
	end)
	EventDelegate.Set(self.dialogContentEffect.onFinished, function ()
		if self.isOnFinished then
			self.collider:SetActive(true)
			self.isOnFinished = false
		end
	end)
end

function AuguryView:InitShow()
	self.chatView = self:AddSubView("AuguryChatView",AuguryChatView)

	local front = DialogUtil.GetDialogData(GameConfig.Augury.ForeWord)
	if front and front.Text then
		self.dialogContent.text = front.Text
	end

	local npcId = AuguryProxy.Instance:GetNpcId()
	if npcId then
		local npc = NSceneNpcProxy.Instance:Find(npcId)
		if npc then
			local viewPort = CameraConfig.Augury_ViewPort
			local rotation = CameraConfig.Augury_Rotation
			self:CameraFaceTo(npc.assetRole.completeTransform,viewPort,rotation)

			self.effectHandL = AuguryEffectHelper.new(npcId, EffectKey_PlayHandL, EffectMap.Maps.DivineHand, RoleDefines_EP.LeftHand)
			self.effectHandR = AuguryEffectHelper.new(npcId, EffectKey_PlayHandR, EffectMap.Maps.DivineHand, RoleDefines_EP.RightHand)
			self.effectCrystalBall = AuguryEffectHelper.new(npcId, EffectKey_PlayCrystalBall, EffectMap.Maps.CrystalBall, RoleDefines_EP.Bottom)

			self.effectCrystalBall:PlayEffect(nil, nil, true, true)
		end
	end

	self.collider:SetActive(false)
	self.isOnFinished = true

	self.tipBgWidth = 158
	self.tipContentWidth = 144
end

function AuguryView:UpdateQuestion()
	local questionId = AuguryProxy.Instance:GetQuestionId()
	if questionId then
		local tb = AuguryProxy.Instance:GetTable()
		if tb then
			local data = tb[questionId]
			if data then
				if data.Type ~= 3 then
					self:UpdateDialog(data)
					self:WaitChoose(data)
				end
			end
		end
	end
end

function AuguryView:UpdateDialog(data)
	self:SetDialogShow(true)
	self.dialogChoose.gameObject:SetActive(false)

	self.dialogContent.text = data.TitleDesc or ""
	if data.Option[1] then
		self.dialogChooseA.text = data.Option[1][1] or ""

		if data.Option[1][2] then
			local hasc, rc = ColorUtil.TryParseHexString(data.Option[1][2])
			self.chooseAColor = rc			
		end
		self.chooseAColor = self.chooseAColor or ColorUtil.ButtonLabelBlue
		self.dialogChooseA.color = self.chooseAColor
	end
	if data.Option[2] then
		self.dialogChooseB.text = data.Option[2][1] or ""

		if data.Option[2][2] then
			local hasc, rc = ColorUtil.TryParseHexString(data.Option[2][2])
			self.chooseBColor = rc			
		end
		self.chooseBColor = self.chooseBColor or ColorUtil.ButtonLabelBlue
		self.dialogChooseB.color = self.chooseBColor
	end

	self.dialogContentEffect:ResetToBeginning()
end

function AuguryView:UpdateTip(data)
	self:SetDialogShow(false)
	self.tipContent.text = data.TitleDesc or ""
	self.tipTitle.text = data.Title or ""

	local size = self.tipTitle.localSize
	local offset = size.x - self.tipContentWidth
	if offset > 0 then
		local temp = math.floor(offset / 2)
		self.tipBg.width = self.tipBgWidth + temp
		self.tipBg1.width = self.tipBgWidth + temp
	end
end

function AuguryView:SetDialogShow(isShow)
	self.dialogRoot:SetActive(isShow)
	self.tipRoot:SetActive(not isShow)
end

function AuguryView:ChooseA()
	ServiceSceneAuguryProxy.Instance:CallAuguryAnswer( AuguryProxy.Instance:GetQuestionId() , 1 )
end

function AuguryView:ChooseB()
	ServiceSceneAuguryProxy.Instance:CallAuguryAnswer( AuguryProxy.Instance:GetQuestionId() , 2 )
end

function AuguryView:RecvAuguryTitle(note)
	local data = note.body
	if data then
		if data.titleid then
			local tb = AuguryProxy.Instance:GetTable()
			if tb then
				local staticData = tb[data.titleid]
				if staticData and staticData.Type ~= 1 then
					self:Talk()
				end
			end
		end
	end
end

function AuguryView:RecvAuguryAnswer(note)
	local data = note.body
	if data.answerid == Game.Myself.data.id then
		MsgManager.ShowMsgByID(936)
		self:Choosed(data.answer)
	else
		MsgManager.ShowMsgByID(930)
	end
end

function AuguryView:RecvAuguryQuit(note)
	local questionId = AuguryProxy.Instance:GetQuestionId()
	if questionId then
		local tb = AuguryProxy.Instance:GetTable()
		if tb then
			local data = tb[questionId]
			if data then
				if data.Type == 3 then
					return
				end
			end
		end
	end

	self:CloseSelf()
end

function AuguryView:WaitChoose(data)
	local npcId = AuguryProxy.Instance:GetNpcId()
	if npcId then
		local npc = NSceneNpcProxy.Instance:Find(npcId)
		if npc then
			self:RemoveHandEffect()

			npc:Client_PlayAction(AuguryView.Action.CatChoose , nil , false)

			--配合动作，5秒后手出现两个特效
			self:CancelHandLt()
			self.effectHandLt = LeanTween.delayedCall(5, function ()
				self.effectHandLt = nil
				
				self.effectHandR:PlayEffect(nil, nil, true, true, AuguryView._ChangeColor, self.chooseAColor)
				self.effectHandL:PlayEffect(nil, nil, true, true, AuguryView._ChangeColor, self.chooseBColor)				

				self.dialogChoose.gameObject:SetActive(true)
				self.chooseRoot:SetActive(true)
			end)
			--水晶球待机
			self.effectCrystalBall:PlayEffectByName(AuguryView.EffectStateName.CrystalBallIdle)
		end
	end
end

function AuguryView:Choosed(answer)
	if self.effectHandR and self.effectHandL then
		--播放手上消失特效
		self.effectHandR:PlayEffectByName(AuguryView.EffectStateName.HandExit, 2)
		self.effectHandL:PlayEffectByName(AuguryView.EffectStateName.HandExit, 2)

		if answer == 1 then	
			--播放手上飞到水晶球特效
			local npcId = AuguryProxy.Instance:GetNpcId()
			if npcId then
				local npc = NSceneNpcProxy.Instance:Find(npcId)
				if npc then
					local effectFire = npc:PlayEffect(EffectKey_PlayFire, 
						EffectMap.Maps.DivineFire, 
						RoleDefines_EP.RightHand, 
						nil, 
						false, 
						false, 
						AuguryView._ChangeColor, 
						self.chooseAColor)
					effectFire:ResetLocalEulerAnglesXYZ(0,180,0)
				end
			end

		elseif answer == 2 then			
			local npcId = AuguryProxy.Instance:GetNpcId()
			if npcId then
				local npc = NSceneNpcProxy.Instance:Find(npcId)
				if npc then
					local effectFire = npc:PlayEffect(EffectKey_PlayFire, 
						EffectMap.Maps.DivineFire, 
						RoleDefines_EP.LeftHand, 
						nil, 
						false, 
						false, 
						AuguryView._ChangeColor, 
						self.chooseBColor)
					effectFire:ResetLocalEulerAnglesXYZ(0,0,0)
				end
			end
		end

		self.chooseRoot:SetActive(false)

		--3秒后播放水晶球爆炸效果
		self:CancelCrystalBallLt()
		self.effectCrystalBallLt = LeanTween.delayedCall(5, function ()
			self.effectCrystalBallLt = nil
			
			self.effectCrystalBall:PlayEffectByName(AuguryView.EffectStateName.CrystalBallBomb)
		end)
	end
end

function AuguryView:Talk()
	local questionId = AuguryProxy.Instance:GetQuestionId()
	if questionId then
		local tb = AuguryProxy.Instance:GetTable()
		if tb then
			local data = tb[questionId]
			if data then
				if data.Type == 3 then
					self:UpdateTip(data)
					return
				end

				local npcId = AuguryProxy.Instance:GetNpcId()
				if npcId then
					local npc = NSceneNpcProxy.Instance:Find(npcId)
					if npc then
						self:RemoveHandEffect()

						-- self.collider:SetActive(true)
						self.isOnFinished = true

						npc:Client_PlayAction(AuguryView.Action.CatTalk , nil , false)
						self.effectCrystalBall:PlayEffectByName(AuguryView.EffectStateName.CrystalBallTalk)

						self:SetDialogShow(true)
						self.dialogChoose.gameObject:SetActive(false)

						self.dialogContent.text = data.Language or "Test"
						self.dialogContentEffect:ResetToBeginning()
					end
				end
			end
		end
	end
end

function AuguryView:CancelHandLt()
	if self.effectHandLt then
		self.effectHandLt:cancel()
		self.effectHandLt = nil
	end
end

function AuguryView:CancelCrystalBallLt()
	if self.effectCrystalBallLt then
		self.effectCrystalBallLt:cancel()
		self.effectCrystalBallLt = nil
	end
end

function AuguryView:RemoveHandEffect()
	self.effectHandL:RemoveEffect()
	self.effectHandR:RemoveEffect()
end

--销毁特效
function AuguryView:DestoryEffect()
	if self.effectHandL and self.effectHandR then
		self:RemoveHandEffect()
		self.effectCrystalBall:RemoveEffect()

		self.effectHandL:Destory()
		self.effectHandR:Destory()
		self.effectCrystalBall:Destory()

		self.effectHandL = nil
		self.effectHandR = nil
		self.effectCrystalBall = nil

		self:CancelHandLt()
		self:CancelCrystalBallLt()
	end
end

--退出
function AuguryView:Reset()
	self:DestoryEffect()
	--npc待机动作
	local npcId = AuguryProxy.Instance:GetNpcId()
	if npcId then
		local npc = NSceneNpcProxy.Instance:Find(npcId)
		if npc then
			npc:Client_PlayAction(AuguryView.Action.CatWait , nil , false)
		end
	end

	AuguryProxy.Instance:SetNpcId(nil)
end

function AuguryView._ChangeColor(effectHandle,arg)
	if effectHandle then
		local particles = effectHandle.particles
		if particles then
			for i=1,#particles do
				arg = arg or ColorUtil.NGUIWhite
				_minMaxGradient.color = arg
				particles[i].main.startColor = _minMaxGradient
			end
		end
	end
end

AuguryEffectHelper = class("AuguryEffectHelper")

function AuguryEffectHelper:ctor(creatureId,key,path,epID)
	self.creatureId = creatureId
	self.key = key
	self.path = path
	self.epID = epID
end

function AuguryEffectHelper:PlayEffect(epID,offset,loop,stick,callback,callbackArg)
	self:RemoveEffect(self.key)
	self:CancelLT()
	epID = self.epID or epID
	if self.creatureId then
		local npc = NSceneNpcProxy.Instance:Find(self.creatureId)
		if npc then
			return npc:PlayEffect(self.key, self.path, epID, offset, loop, stick, callback, callbackArg)
		end
	end	
end

function AuguryEffectHelper:RemoveEffect()
	if self.creatureId then
		local npc = NSceneNpcProxy.Instance:Find(self.creatureId)
		if npc then
			npc:RemoveEffect(self.key)
		end
	end
end

--按动画名播放特效动画，只支持loop动作，并且在调用前已经存在的特效
function AuguryEffectHelper:PlayEffectByName(stateName,duration)
	if self.creatureId then
		local npc = NSceneNpcProxy.Instance:Find(self.creatureId)
		if npc then
			local effect = npc:GetEffect(self.key)
			if effect then
				local animator = effect:GetComponent(Animator)
				if animator then
					animator:Play(stateName)
					if duration then
						self.effectLt = LeanTween.delayedCall(duration, function ()
							self:RemoveEffect(self.key)
							self.effectLt = nil
						end)
					end
					return
				end
			end
			self:RemoveEffect(self.key)
		end
	end
end

function AuguryEffectHelper:CancelLT()
	if self.effectLt then
		self.effectLt:cancel()
		self.effectLt = nil
	end
end

function AuguryEffectHelper:Destory()
	self.creatureId = nil
	self.key = nil
	self.path = nil
	self.epID = nil
	self:CancelLT()
end