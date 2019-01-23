local baseView = autoImport("BaseView")
GuideMaskView = class("GuideMaskView",BaseView)
GuideMaskView.ViewType = UIViewType.GuideLayer

function GuideMaskView.getInstance(  )
	-- body
	if(GuideMaskView.Instance == nil)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.GuideMaskView})
	end
	return GuideMaskView.Instance
end

function GuideMaskView:Init()
    if(GuideMaskView.Instance == nil)then
  	   GuideMaskView.Instance = self
    end 
    self:initView()
    self:initData()
    self:registListener()
end

function GuideMaskView:initData(  )
	-- body
	self.currentTriggerId = nil
	self.forbid = false
	self.objPos = nil
end

function GuideMaskView:resetData(  )
	-- body
	self.currentTriggerId = nil
	self.lastOption = nil
end

function GuideMaskView:initView()
	-- body	
	self.mask = self:FindGO("mask")
	self.maskCollider = self.mask:GetComponent(BoxCollider)
	self.resPath = ResourcePathHelper.EffectUI(EffectMap.UI.HlightBox);
	self.hlightGo = Game.AssetManager_UI:CreateAsset(self.resPath,self.gameObject);
	self.hlightGo.transform.localScale = Vector3.one
	self.hlightTexture = self:FindGO("pic_skill_uv_add",self.hlightGo)
	self.hlightTexture = self.hlightTexture:GetComponent(UIWidget)
	self.hlightTexture.depth = 3000

	self.hintCt = self:FindGO("hintTextCt")
	self.hintText = self:FindGO("hintText"):GetComponent(UILabel)

	self.hintTextPos = self.hintText.gameObject.transform.localPosition
	self.hintTextBg = self:FindGO("hintTextBg"):GetComponent(UIWidget)

	self.currentGuideId = nil
	self:Hide(self.hlightGo)
	self:Hide(self.mask)
end

function GuideMaskView:restoreParent( closeSelf  )
	-- body
	if(self.obj and self.tagParent and not GameObjectUtil.Instance:ObjectIsNULL(self.obj))then
		-- local pos = self.obj.transform.localPosition
		-- helplog("pre pos:"..pos.x..";"..pos.y)

		-- local pos = self.obj.transform.position
		-- helplog("world pos:"..pos.x..";"..pos.y)
		-- pos = self.tagParent.transform.localPosition
		-- helplog("tag pos:"..pos.x..";"..pos.y)
		self.obj.transform:SetParent(self.tagParent,true)
		if(self.objPos)then
			self.obj.transform.position = self.objPos
			self.obj.transform.localScale = self.objScale
		end
		-- local pos = self.obj.transform.localPosition
		-- helplog("aft pos:"..pos.x..";"..pos.y)
		self:Hide(self.obj)
		self:Show(self.obj)
		self.obj = nil
		self.objPos = nil
		-- self.objScale = nil
		self.tagParent = nil
		self.hintCt.transform:SetParent(self.gameObject.transform)
		self:Hide(self.hintCt)
		self:Hide(self.hlightGo)			
	end
	self:Hide(self.mask)	
	if(closeSelf)then
		self:CloseSelf()
	end
end

function GuideMaskView:playHightAnim( pos )
	-- body
	TweenScale.Begin(self.hlightGo,0.2,Vector3.one)
	TweenPosition.Begin(self.hlightGo,0.2,pos)
end

function GuideMaskView:setGuideUIActive( active )
	-- body
	if(self.hlightGo and not GameObjectUtil.Instance:ObjectIsNULL(self.hlightGo))then
		self.hlightGo:SetActive(active)
	end

	if(self.hintCt and not GameObjectUtil.Instance:ObjectIsNULL(self.hintCt))then
		local text = self.guideData.text
		if(text and text ~= "" and active)then
			self.hintCt:SetActive(active)
		else
			self.hintCt:SetActive(false)
		end
	end	
end

function GuideMaskView:OnExit()
	-- body	
	-- self:Log("GuideMaskView:OnExit")
	self:restoreParent()
	GuideMaskView.super.OnExit(self)
	Game.GOLuaPoolManager:AddToUIPool(self.resPath , self.hlightGo)
	self.resPath = nil
	GuideMaskView.Instance = nil
	self.questData = nil
	self.obj = nil
	self.tagParent = nil
	self.currentTriggerId = nil
end

function GuideMaskView:setTalkText(  )
	-- body
	local text = self.guideData.text
	if(text and text ~= "")then
		self:Show(self.hintCt)
		self.hintText.text = text
		local rotation = self.guideData.rotation
		if(rotation and rotation.x)then
			self.hintTextBg.gameObject.transform.localRotation = Quaternion.Euler(rotation.x,rotation.y,rotation.z)
		end
		-- TableUtil.Print(guideData)
		local pos = self.guideData.position	
		-- if(self.questData.params.type == QuestDataGuideType.QuestDataGuideType_force)then
		if(pos and pos.x)then
			self.hintCt.transform.localPosition = Vector3(pos.x,pos.y,1)
		end		
		-- self.hintText.gameObject.transform,true);
		self.hintTextBg.width = self.hintText.width + 50
		if(rotation.x == 180 and rotation.z ~= 180) or (rotation.z == 180 and rotation.x ~= 180) then
			self.hintText.gameObject.transform.localPosition = Vector3(self.hintTextPos.x,-3,0)
		else
			self.hintText.gameObject.transform.localPosition = self.hintTextPos
		end
		if(self.questData.params.type == QuestDataGuideType.QuestDataGuideType_unforce)then
			self.hintCt.transform:SetParent(self.hlightGo.transform.parent)
		end		
	else
		self:Hide(self.hintCt)
	end	
end

function GuideMaskView:showGuideByQuestData( questData )
	-- body
	self.questData = questData
	self.currentGuideId = questData.params.guideID
	self.guideData = Table_GuideID[self.currentGuideId]
	local tag = self.guideData.ButtonID	
	self.obj = GuideTagCollection.getGuideItemById(tag)
	local bound = NGUIMath.CalculateRelativeWidgetBounds(self.obj.transform,false);
	local guideType = questData.params.type				
	if(guideType == QuestDataGuideType.QuestDataGuideType_unforce)then					
		self.tagParent = self.gameObject.transform
		self.hlightGo.transform:SetParent(self.obj.transform)
		self.hlightGo.transform.localScale = Vector3.one
		self.hlightGo.transform.localPosition = bound.center
		lPos = self.obj.transform.localPosition		
		self.obj = self.hlightGo.gameObject
	elseif(guideType == QuestDataGuideType.QuestDataGuideType_force)then				
		self.tagParent = self.obj.transform.parent
		self.objPos = self.obj.transform.position
		self.objScale = self.obj.transform.localScale
		self.obj.transform:SetParent(self.gameObject.transform)
		lPos = self.obj.transform.localPosition	
		local pos = Vector3(lPos.x+bound.center.x,lPos.y+bound.center.y,lPos.z)
		self.hlightGo.transform.localPosition = pos	
		self.hlightGo.transform.localScale = Vector3(5,5,1)
		self.hlightGo.transform.localPosition = Vector3.zero
		self:playHightAnim(pos)
	end
	self.hlightTexture.width = bound.size.x+20
	self.hlightTexture.height = bound.size.y+20
	self:Hide(self.obj.gameObject)
	self:Show(self.obj.gameObject)
	self:setTalkText()
	self:Show(self.hlightGo)
	if(guideType == QuestDataGuideType.QuestDataGuideType_unforce)then
		self:Hide(self.mask)
	elseif(guideType == QuestDataGuideType.QuestDataGuideType_force)then
		self:Show(self.mask)
	elseif(guideType == QuestDataGuideType.QuestDataGuideType_showDialog)then
		
	end
	-- if(guideType == QuestDataGuideType.QuestDataGuideType_force)then

	-- end
end

function GuideMaskView:waitServerEvent( serverEvent,questData )
	-- body
	self.waitEvent = serverEvent
	self.delayQuestData = questData	
end
function GuideMaskView:registListener(  )
	-- body
	-- helplog("GuideMaskView:registListener(  )")
	local list = GuideProxy.Instance:getGuideListeners( )
	for i=1,#list do
		-- helplog("AddListenEvt:"..list[i])
		self:AddListenEvt(list[i],self.excuteGuide)
	end
end

function GuideMaskView:excuteGuide(  )
	-- body
	-- self:Log("function GuideMaskView:excuteGuide(  )")
	if(self.delayQuestData)then
		FunctionGuide.Me():showGuideByQuestData(self.delayQuestData)
		self.delayQuestData = nil
	end
end