local baseCell = autoImport("BaseCell")
autoImport("QuestData")
TaskQuestCell = class("TaskQuestCell",baseCell)

TaskQuestCell.FilterQuestStepType = {	
	QuestDataStepType.QuestDataStepType_VISIT ,
	QuestDataStepType.QuestDataStepType_KILL,
	QuestDataStepType.QuestDataStepType_COLLECT ,
	QuestDataStepType.QuestDataStepType_USE ,
	QuestDataStepType.QuestDataStepType_GATHER ,
	QuestDataStepType.QuestDataStepType_MOVE,
	QuestDataStepType.QuestDataStepType_SELFIE ,
}

local tempVector3 = LuaVector3.zero
local getlocalPos = LuaGameObject.GetLocalPosition
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local isNil = LuaGameObject.ObjectIsNull
function TaskQuestCell:Init()	
	self:initView()
	self:initData()
end

function TaskQuestCell:initData()
	-- body
	self.questType = -1
	-- self.effectObj = nil
	self.isSelected = true
	self.bgSizeChanged = false
	self:setIsSelected(false)
	self:setIsOngoing(false)
	self.type = nil
	self.titleBg = nil
 	self.iconStr = nil
 	self.thumbBgStr = nil
 	self.thumbStr = nil
end

function TaskQuestCell:AddLongPress(  )
	-- body
	-- print(self.data.type)
	local long = self.bgSprite.gameObject:GetComponent(UILongPress)
	if(long)then
		long.pressEvent = function ( obj,isPress )
			-- body
			if(not self.data or self.data.type == QuestDataType.QuestDataType_SEALTR or self.data.type == QuestDataType.QuestDataType_ITEMTR 
				or self.data.type == QuestDataType.QuestDataType_HelpTeamQuest or self.data.type == QuestDataType.QuestDataType_INVADE 
				or self.data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO)then
				return
			end
			if(isPress)then
				TipsView.Me():ShowStickTip(QuestDetailTip,self.data,NGUIUtil.AnchorSide.TopLeft,self.bgSprite,{0,0})
			else
				TipsView.Me():HideTip(QuestDetailTip)
			end
		end
	end
end

function TaskQuestCell:initView(  )
	-- body
	self.progress = self:FindGO("progress")
	if(self.progress)then
		self.slWidget = self.progress:GetComponent(UIWidget)
		self.progress = self.progress:GetComponent(UISlider)
		self.thumb = self:FindComponent("thumb",UISprite)
		self.thumbCt = self:FindGO("thumbCt")
		self.thumbBg = self:FindComponent("bg",UISprite,self.thumbCt)
		self.foreBg = self:FindComponent("forebg",UISprite,self.progress.gameObject)
		self.progressBg = self:FindComponent("bg",UISprite,self.progress.gameObject)
	end
	self.titleBgCt = self:FindGO("titleBgCt")
	self.content = self:FindGO("content")
	self.title = self:FindComponent("Title",UILabel)
	self.desc = self:FindComponent( "Desc",UIRichLabel)
	self.desc = SpriteLabel.new(self.desc,nil,20,20)
	self.icon = self:FindComponent( "Icon",UISprite)
	self.bgSprite = self:FindComponent("bg",UISprite)
	self.disLabel = self:FindComponent("currentDisLb",UILabel)

	--todo xde fix ui
	self.title.leftAnchor.target =  self.icon.gameObject.transform
	self.title.leftAnchor.relative = 1
	self.title.leftAnchor.absolute = 0
	
	-- self.foreBg = self:FindGO("foreBg"):GetComponent(UISprite)
	-- self.disSlider = self:FindGO("Distance"):GetComponent(UISlider)
	local click = function(obj)		
		-- print("questData monsterid or npcid:"..self.stepData.param1.."---quest type:"..self.stepData.type)		
		self:PassEvent(MouseEvent.MouseClick, self);
	end
	self:SetEvent(self.bgSprite.gameObject,click)

	self.closeTrace = self:FindGO("CloseTrace")
	click = function ( obj )
		-- body
		if(self.data.type == QuestDataType.QuestDataType_ITEMTR)then
			self:sendNotification(MainViewEvent.CancelItemTrace,{self.data.id})
		elseif(self.data.type == QuestDataType.QuestDataType_HelpTeamQuest)then
			self:sendNotification(QuestEvent.RemoveHelpQuest,{self.data.id})
		else
			QuestProxy.Instance:RemoveTraceCell( self.data.type,self.data.id )
		end
	end
	if(self.closeTrace)then			
		self:SetEvent(self.closeTrace,click)
	end

	-- local selector = self:FindGO("Selector")
	self.selectorSp = self:FindGO("selector"):GetComponent(UISprite)
	local press = function (obj,isPress )
		-- body
		self:setIsSelected(isPress)
	end
	self:AddPressEvent(self.bgSprite.gameObject, press);
	-- self.appearAm = self:FindGO("AppearAnm"):GetComponent(UIPlayTween)
	-- EventDelegate.Set(self.appearAm.onFinished,function (  )
 --   		-- body
 --   		self:Hide(self.appearAm.gameObject)
 --  		printRed("appearAm onFinished!")
 --  	end)
 	local objLua = self.gameObject:GetComponent(GameObjectForLua)
 	objLua.onEnable = function (  )
 		-- body
 		-- self:Log("onEnable")
 		-- LeanTween.delayedCall(0.1, function ()
 			if(QuestProxy.Instance:checkIsShowDirAndDis(self.data))then
				self:resetBgSize(true)
			else
				self:resetBgSize(false)
			end
 		-- end)
 	end
 	self.disObj = self.disLabel.gameObject
 	self.disObjTrans = self.disObj.transform
 	self.richObjTrans = self.desc.richLabel.gameObject.transform
 	self.progressObj = self.progress.gameObject
 	self:AddLongPress()
end

function TaskQuestCell:setIsSelected( isSelected )
	-- body
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
		if(isSelected)then
			self.selectorSp.color = Color(1,1,1,1)			
		else
			self.selectorSp.color = Color(1,1,1,1/255)
		end
	end
end

function TaskQuestCell:setISShowDir( value )
	-- body
	self.isShowDir = value
	if(value)then
		self:Show(self.icon.gameObject)
		if(self.data.type == QuestDataType.QuestDataType_HelpTeamQuest)then
			IconManager:SetUIIcon("Rewardtask_icon_team",self.icon)
		else
			IconManager:SetUIIcon("icon_39",self.icon)
		end
		self.icon:MakePixelPerfect()

	else
		self:Hide(self.icon.gameObject)
		local disStr = self:GetShowMap()
		self.disLabel.text = disStr
	end
end

function TaskQuestCell:GetIsShowDir(  )
	-- body
	return self.isShowDir
end

function TaskQuestCell:GetShowMap( data )
	-- body
	data = data or self.data
	local tarMap = data.map 
	if(not tarMap)then
		tarMap = Game.MapManager:GetMapID()
	end
	local mapData = Table_Map[tarMap]
	local toMap = "..."
	if(mapData)then
		toMap = mapData.CallZh
	end
	local disStr = string.format(ZhString.TaskQuestCell_Dis,tostring(toMap))
	return disStr
end

function TaskQuestCell:checkShowDisAndIcon( data )
	-- body
	-- self:Log("TaskQuestCell:checkShowDisAndIcon")
	if(QuestProxy.Instance:checkIsShowDirAndDis(data))then
		-- self:Log("TaskQuestCell:checkShowDisAndIcon1")
		self:Hide(self.icon.gameObject)
		self:Show(self.disLabel.gameObject)
		local disStr = self:GetShowMap(data)
		self.disLabel.text = disStr
		self:resetBgSize(true)
		--TODO
		-- local args = ReusableTable.CreateTable()
		-- args.questData = self.data
		-- args.owner = self
		-- args.callback = self.Update	
		-- FunctionQuestDisChecker.Me():AddQuestCheck(args)
		-- ReusableTable.DestroyTable(args)		
	else
		-- self:Log("TaskQuestCell:checkShowDisAndIcon2")
		if((data.type == QuestDataType.QuestDataType_INVADE or data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO) and data.icon)then
			if(self.iconStr ~= data.icon)then
				self:Show(self.icon.gameObject)
				IconManager:SetUIIcon(data.icon,self.icon)
				self.icon:MakePixelPerfect()
			end
		else
			self:Hide(self.icon.gameObject)
		end
		self:Hide(self.disLabel.gameObject)
		-- self:resetIcon()
		self:resetBgSize(false)
	end
end

function TaskQuestCell:setIsOngoing( isOngoing )
	-- body
	-- LogUtility.Info("<color=red>setIsOngoing(data)"..tostring(isOngoing).."</color>")
	if(self.isOngoing ~= isOngoing)then
		self.isOngoing = isOngoing
		if(isOngoing)then
			self.title.color = Color(1,197/255,20/255,1)
		else
			self.title.color = Color(1,1,1,1)
		end
	end
end

function TaskQuestCell:AdjustRelatedComp(data)
	if(data.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and (self.type ~= data.type))then
		local name = data.traceTitle
		local desStr = data:parseTranceInfo()
		self.title.pivot = UIWidget.Pivot.Left;
		tempVector3:Set(getlocalPos(self.title.transform))
		tempVector3:Set(41.5,tempVector3.y,tempVector3.z)
		self.title.transform.localPosition = tempVector3

		tempVector3:Set(getlocalPos(self.icon.transform))
		tempVector3:Set(22,tempVector3.y,tempVector3.z)
		self.icon.transform.localPosition = tempVector3

		tempVector3:Set(getlocalPos(self.desc.richLabel.transform))
		tempVector3:Set(45.6,tempVector3.y,tempVector3.z)
		self.desc.richLabel.transform.localPosition = tempVector3
		self.desc.richLabel.width = 154

		self:Hide(self.titleBgCt.gameObject)
	end

	if(self.progress )then
		if(data.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and data.type ~= QuestDataType.QuestDataType_INVADE)then
			if(self.type ~= data.type)then
				self:Hide(self.progress.gameObject)
				self:Hide(self.thumbCt.gameObject)
			end
		end
	end

	if(self.closeTrace )then
		if(data.type ~= QuestDataType.QuestDataType_HelpTeamQuest and data.type ~= QuestDataType.QuestDataType_ITEMTR)then
			if(self.type ~= data.type)then
				self:Hide(self.closeTrace)
			end
		else
			if(self.type ~= data.type)then
				self:Show(self.closeTrace)
			end
		end
	end
end

function TaskQuestCell:SetData(data)
	if(data == nil)then
		return
	end

	local name = data.traceTitle
	local desStr = data:parseTranceInfo()
	self:AdjustRelatedComp(data)
	self:setIsOngoing(false)	

	local disY = 0
	local distPos = 0
	if(data.type == QuestDataType.QuestDataType_DAILY)then
		local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
		local ratio = "0%"
		local exp = "0"
		if(dailyData)then
			ratio = dailyData.param4 * 100
			ratio = ratio.."%" 
			exp = dailyData.param3
		end
		name = string.format(name,ratio)
		desStr = string.format(desStr,exp)
	elseif data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
		self:UpActivityTraceView(data)
	elseif data.type == QuestDataType.QuestDataType_INVADE then
		self:UpInvadeTraceView(data)
	end
	self:Show(self.icon.gameObject)
	self.title.text = name
	if(StringUtil.ChLength(name)>18)then
		self.title.fontSize = 18
	else
		self.title.fontSize = 20
	end
	UIUtil.WrapLabel (self.title)
	if not desStr then
		desStr = ""
	end
	self.desc:SetText(desStr)
	self:checkShowDisAndIcon(data)
	self.data = data
	self.titleBg = data.titleBg
	self.iconStr = data.icon
	self.thumbBgStr = data.thumbBg
	self.thumbStr = data.thumb
	self.type = data.type
	-- self.foreBg.height = self.bgSprite.height	
end

function TaskQuestCell:UpActivityTraceView(data  )

	if(data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and (not self.data or self.data.type ~= data.type ))then
		self.title.pivot = UIWidget.Pivot.Center;
		tempVector3:Set(getlocalPos(self.title.transform))
		tempVector3:Set(118,tempVector3.y,tempVector3.z)
		self.title.transform.localPosition = tempVector3

		tempVector3:Set(getlocalPos(self.icon.transform))
		tempVector3:Set(35.44,tempVector3.y,tempVector3.z)
		self.icon.transform.localPosition = tempVector3

		tempVector3:Set(getlocalPos(self.desc.richLabel.transform))
		tempVector3:Set(14,tempVector3.y,tempVector3.z)
		self.desc.richLabel.transform.localPosition = tempVector3
		self.desc.richLabel.width = 185		
	end
	
	if(self.titleBgCt and data.titleBg and (self.titleBg ~= data.titleBg))then
		self:Show(self.titleBgCt)
	end
	if(self.progress and data.process and not self.progressObj.activeSelf)then
		self:Show(self.progress.gameObject)
		self:Show(self.thumbCt)
		if(self.slWidget)then
			self.slWidget:ResetAndUpdateAnchors()
		end
	end

	if(not data.process and self.progressObj.activeSelf)then
		self:Hide(self.progress.gameObject)
		self:Hide(self.thumbCt)
	end

	if(self.progress and data.process)then
		self.progress.value = data.process
		if((data.thumb and data.thumb ~="") or (data.thumbBg and data.thumbBg~="" ))then
			if(data.thumb)then
				self:Show(self.thumb.gameObject)
				if(data.thumb ~= self.thumbStr)then
					IconManager:SetUIIcon(data.thumb,self.thumb)
					self.thumb:MakePixelPerfect()
				end
			else
				self:Hide(self.thumb.gameObject)
			end

			if(data.thumbBg)then
				self:Show(self.thumbBg.gameObject)
				if (data.thumbBg ~= self.thumbBgStr)then
					IconManager:SetUIIcon(data.thumbBg,self.thumbBg)
					self.thumbBg:MakePixelPerfect()
				end
			else
				self:Hide(self.thumbBg.gameObject)
			end
		else
			self:Hide(self.thumbCt)
		end

		if(data.foreBg and data.foreBg ~="")then
			self.foreBg.spriteName = data.foreBg
		end

		if(data.progressBg and data.progressBg ~= "")then
			self.progressBg.spriteName = data.progressBg
		end
	end
end

function TaskQuestCell:UpInvadeTraceView( data )
	if(self.progress and data.process and not self.progressObj.activeSelf)then
		if(self.slWidget)then
			self.slWidget:ResetAndUpdateAnchors()
		end
		self:Show(self.progress.gameObject)
		self:Show(self.thumbCt)
	end
	if(self.progress and data.process)then
		self.progress.value = data.process
		if(data.thumb)then
			self:Show(self.thumb.gameObject)
			if(data.thumb ~= self.thumbStr)then
				IconManager:SetUIIcon(data.thumb,self.thumb)
				self.thumb:MakePixelPerfect()
			end
		else
			self:Hide(self.thumb.gameObject)
		end
		if(data.thumbBg)then
			self:Show(self.thumbBg.gameObject)
			if (data.thumbBg ~= self.thumbBgStr)then
				IconManager:SetUIIcon(data.thumbBg,self.thumbBg)
				self.thumbBg:MakePixelPerfect()
			end			
		else
			self:Hide(self.thumbBg.gameObject)
		end
	end
end

function TaskQuestCell:resetBgSize( showDistance )
	-- body
	self.bgSizeChanged = false
	if isNil(self.disLabel) then
		return
	end

	if isNil(self.disObj) then
		return
	end
	tempVector3:Set(getlocalPos(self.disObjTrans))
	local _,y,_ = getlocalPos(self.richObjTrans)
	local deshg = self.desc.richLabel.height
	y = y - deshg - 14
	tempVector3:Set(tempVector3.x,y,tempVector3.z)
	self.disObjTrans.localPosition = tempVector3
	local height = calSize(self.content.transform)
	height = height.size.y
	-- self:Log("height:",height)
	-- if(showDistance)then
	-- 	height = 73+ 20*(deshg/20-1)+self.disLabel.height+5
	-- 	self:Log("height:1",height)
	-- else
	-- 	height = 73+ 20*(deshg/20-1)
	-- 	self:Log("height:2",height)
	-- end
	height = height+4
	local originHeight = self.bgSprite.height
	if(math.abs(originHeight- height)>2)then
		self.bgSizeChanged = true
		if(self.slWidget)then
			self.slWidget:ResetAndUpdateAnchors()
		end
	end
	self.bgSprite.height = height
	height = height+8
	self.selectorSp.height = height
end

-- function TaskQuestCell:resetIcon(  )
-- 	-- body
-- 	local iconName = "icon_39"

-- 	if(self.icon.spriteName ~= iconName)then
-- 		IconManager:SetUIIcon("icon_39",self.icon)iconName
-- 		self.icon:MarkAsChanged()
-- 	end
-- end

function TaskQuestCell:Update(teleData)
	-- local spriteName = "main_icon_01"
	local distance = teleData["distance"]
	local toMap = teleData["toMap"]
	-- local indicatorPos = teleData["indicatorPos"]
	local disStr
	if(distance)then
		--当前地图
		local str = ZhString.TaskQuestCell_Dis.."M"
		disStr = string.format(str,tostring(distance))
		-- if(distance<=2)then
		-- 	spriteName = "main_icon_02"
		-- end
	else
		--非当前地图
		if(toMap)then
			disStr = string.format(ZhString.TaskQuestCell_Dis,tostring(toMap))
		else
			disStr = string.format(ZhString.TaskQuestCell_Dis,"...")
		end
	end
	if(disStr ~= "")then
		self.disLabel.text = disStr
		self:resetBgSize(true)
	end
	-- NGUITools.AddWidgetCollider(self.gameObject,true);
	-- -- self:Log("update",indicatorPos)
	-- if(indicatorPos)then
	-- 	IconManager:SetUIIcon("icon_39",self.icon)spriteName
	-- 	-- printRed("rotation",rotation)
	-- 	local rotation = FunctionQuestDisChecker.Me():getRotationByIconPosAndTarPos(self.icon,indicatorPos)
	-- 	-- printRed("rotation",rotation)
	-- 	if(not distance or distance >2)then
	-- 		tempVector3:Set(0, 0,rotation)
	-- 		tempQuaternion.eulerAngles = tempVector3
	-- 		self.icon.transform.rotation = tempQuaternion
	-- 	else
	-- 		tempVector3:Set(0, 0,0)
	-- 		tempQuaternion.eulerAngles = tempVector3
	-- 		self.icon.transform.localRotation = tempQuaternion
	-- 	end
	-- else
	-- 	tempVector3:Set(0, 0,0)
	-- 	tempQuaternion.eulerAngles = tempVector3
	-- 	self.icon.transform.localRotation = tempQuaternion
	-- 	self:resetIcon()
	-- end
end

function TaskQuestCell:OnExit(  )
	-- body
	FunctionQuestDisChecker.RemoveQuestCheck(self.data.id)
	self.type = nil
	self.titleBg = nil
	self.iconStr = nil
	self.thumbBgStr = nil
	self.thumbStr = nil
	TaskQuestCell.super.OnExit(self)
end

function TaskQuestCell:OnRemove(  )
	-- body
	FunctionQuestDisChecker.RemoveQuestCheck(self.data.id)	
end