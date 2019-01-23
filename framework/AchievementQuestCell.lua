local baseCell = autoImport("BaseCell")
AchievementQuestCell = class("AchievementQuestCell",baseCell)

function AchievementQuestCell:Init()
	self:initView()
end

function AchievementQuestCell:initView(  )
	-- body
	self.more = self:FindGO("more")
	self.achieveDesc = self:FindComponent("achieveDesc",UILabel)
	--todo xde
	self.bg = self:FindGO("bg")
	-- self:AddClickEvent(self.gameObject,function (  )
	-- 	-- body
	-- 	if(self.data.type == AchievementDescriptionCell.SubAchieve.Achieve)then

	-- 	end
	-- end)
	self:AddCellClickEvent()
	self.preQuestCt = self:FindGO("preQuestCt")
	self.questStatus = self:FindComponent("questStatus",UILabel)
	self.statusBtn = self:FindGO("statusBtn")
	self.statusBtnSp = self:FindComponent("statusBtn",UISprite)
	self:Hide(self.preQuestCt)
	self:AddClickEvent(self.statusBtn,function ( ... )
		-- body
		-- self.preQuestCt:SetActive(not self.preQuestCt.activeSelf)
		TipManager.Instance:ShowPreQuestTip(self.data.preQuestS,self.statusBtnSp,NGUIUtil.AnchorSide.Right,{270,0})
	end)
	local grid = self:FindComponent("grid",UIGrid)
	self.preQuestGrid = UIGridListCtrl.new(grid,AchievementPreQuestCell,"AchievementPreQuestCell")
end

function AchievementQuestCell:SetData( data )
	-- body
	self.data = data
	local type = data.type
	local content = data.content
	local questListType = data.questListType
	self:Hide(self.preQuestCt)
	if(type == AchievementDescriptionCell.SubAchieve.Achieve)then
		self:Show(self.more)
		self:Hide(self.questStatus.gameObject)
		self:Hide(self.statusBtn)
		self.achieveDesc.text = string.format(ZhString.AdventureAchievePage_SubAchieveText,content)
	elseif(AchievementDescriptionCell.SubAchieve.Quest)then
		self:Hide(self.more)
		self:Show(self.questStatus.gameObject)
		self.achieveDesc.text = string.format(ZhString.AdventureAchievePage_SubQuestText,content)
		if(questListType == SceneQuest_pb.EQUESTLIST_SUBMIT)then
			self:Hide(self.statusBtn)
			self.questStatus.text = ZhString.AdventureAchievePage_Finish
		elseif(questListType == SceneQuest_pb.EQUESTLIST_ACCEPT)then
			self.questStatus.text = ZhString.AdventureAchievePage_Accept
			self:Hide(self.statusBtn)
		else
			self.questStatus.text = ZhString.AdventureAchievePage_UnAccept
			if(data.preQuestS and #data.preQuestS>0)then
				self:Show(self.statusBtn)
				-- self.preQuestGrid:ResetDatas(data.preQuestS)
				--[[ todo xde 0003360: 【翻译】面板任务中接取运送品相关任务显示中文相关
				return
				--]]
			else
				self:Hide(self.statusBtn)
			end
		end
	end
	
	--todo xde
	self.achieveDesc.transform.localPosition = Vector3(-196,-25,0)
	OverseaHostHelper:FixLabelOverV1(self.achieveDesc,3,260)
	OverseaHostHelper:FixAnchor(self.achieveDesc.leftAnchor,self.bg.transform,0,12)

	self.questStatus.transform.localPosition = Vector3(103,-25,0)
	self.questStatus.pivot = UIWidget.Pivot.Right
	OverseaHostHelper:FixLabelOverV1(self.questStatus,3,120)
	if(self.statusBtn.activeSelf) then
		-- 0003360: 【翻译】面板任务中接取运送品相关任务显示中文相关 -4 改成 -34
		OverseaHostHelper:FixAnchor(self.questStatus.rightAnchor,self.statusBtn.transform,1,-34)
	elseif(self.more.activeSelf) then
		OverseaHostHelper:FixAnchor(self.questStatus.rightAnchor,self.more.transform,1,-4)
	else
		OverseaHostHelper:FixAnchor(self.questStatus.rightAnchor,self.bg.transform,1,-12)
	end
	-- self.preQuestGrid:RemoveAll()
end