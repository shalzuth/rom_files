local baseCell = autoImport("BaseCell")
AchievementDescriptionCell = class("AchievementDescriptionCell",baseCell)

autoImport("AchievementQuestCell")
autoImport("AchievementPreQuestCell")

AchievementDescriptionCell.behaviorEnum = {
	levelup = "levelup",
	addfriend = "addfriend",
	mapmove = "mapmove",
	killmonster = "killmonster",
	killcat = "killcat",
	Commissioned = "Commissioned",
	Quest = "questfinish",
	Achieve = "achievementfinish",
}

AchievementDescriptionCell.SubAchieve = {
	Achieve = 1,
	Quest = 2
}

local tempVector3 = LuaVector3.zero
local tempArray = {}

AchievementDescriptionCell.RewardTextColor = LuaColor.New(65/255,138/255,197/255,1);
AchievementDescriptionCell.SubAchieveClick = "AchievementDescriptionCell_SubAchieveClick"

function AchievementDescriptionCell:Init()
	self:initView()
	self:AddCellClickEvent();	
	-- self:addViewEventListener()	
	-- self:addListEventListener()
end

function AchievementDescriptionCell:initView(  )
	-- body
	self.name = self:FindComponent("AchievementName",UILabel)
	self.completeDate = self:FindComponent("completeDate",UILabel)
	self.AchievementCondition = self:FindComponent("AchievementCondition",UILabel)
	self.description = self:FindComponent("description",UILabel)
	self.icon = self:FindComponent("icon",UISprite)
	self.bg = self:FindComponent("bg",UISprite)	
	self.description = self:FindComponent("description",UILabel)
	local rewardTitle = self:FindComponent("rewardTitle",UILabel)
	rewardTitle.text = ZhString.AdventureAchievePage_RewardTitle

	local rewardGrid = self:FindComponent("rewardGrid",UIGrid)
	self.rewardGrid = UIGridListCtrl.new(rewardGrid,AdvTipRewardCell,"AdvTipRewardCell")
	self.rewardGrid:AddEventListener(MouseEvent.MouseClick,self.RewardItemClick,self)
	local achievementQuestGrid = self:FindComponent("AchievementQuestGrid",UIGrid)
	self.achievementQuestGrid = UIGridListCtrl.new(achievementQuestGrid,AchievementQuestCell,"AchievementQuestCell")
	self.achievementQuestGrid:AddEventListener(MouseEvent.MouseClick,self.SubAchieveClick,self)
	
	self.completeIcon = self:FindGO("completeIcon")
	self.AchievementIcon = self:FindComponent("AchievementIcon",UISprite)
	self.collapse = self:FindGO("collapse")
	self.shareBtn = self:FindGO("shareBtn")
	self:Hide(self.shareBtn)
	self.rewardCt = self:FindGO("rewardCt")
	self.questCt = self:FindGO("questCt")

	local tipCell = self:FindGO("AdvTipRewardCell")
	self.AdvTipRewardCell = AdvTipRewardCell.new(tipCell)

	self:AddClickEvent(self.shareBtn,function (  )
		-- body
	end)

	self.addSymbol = self:FindGO("addSymbol")
	self:AddClickEvent(self.addSymbol ,function (  )
		-- body
		ServiceAchieveCmdProxy.Instance:CallRewardGetAchCmd(self.data.id)
		self:PlayUnlockEffect()
	end)
	self.content = self:FindGO("content")
	self.collRewardGrid = self:FindComponent("collRewardGrid",UITable)
	self.BufferLabel = self:FindComponent("BufferLabel",UILabel)
	self:Hide(self.BufferLabel.gameObject)
	self.effectContainer = self:FindGO("EffectContainer");
end

function AchievementDescriptionCell:SubAchieveClick( cellCtl )
	if(cellCtl.data and cellCtl.data.type == AchievementDescriptionCell.SubAchieve.Achieve)then
		self:PassEvent(AchievementDescriptionCell.SubAchieveClick , cellCtl.data);
	end
end

function AchievementDescriptionCell:RewardItemClick( cellCtl )	
	if(cellCtl.data)then
		local data = cellCtl.data.value
		if(data and type(data) == "table")then
			local newClickId = data[1]
			if(self.clickId~=newClickId)then
				self.clickId = newClickId;
				local callback = function () 
					self.clickId = 0 
				end
				local itemData = ItemData.new(nil,data[1])
				local stick = self.bg
				if(itemData.staticData.Type == 10)then
					--TODO
					local t = Table_Appellation[itemData.staticData.id]
					if(t and t.GroupID)then
						local csv = Table_Appellation[itemData.staticData.id]
						local sdata = TitleData.new(t.GroupID,csv)
						sdata.hideFlag = true
						
						local data = {
							itemdata = sdata,
						};
						if(self.data and not self.data:canGetReward(  ) and self.data:getCompleteString())then
							data.itemdata.unlocked=true
						end
						TipManager.Instance:ShowTitleTip(data,stick,nil,{200,0})
					end
				else
					local sdata = {
						itemdata = itemData,
						funcConfig = {},
						hideGetPath = true,
						callback = callback,
					};
					
					self:ShowItemTip(sdata,stick, nil, {200,0});
				end
				
			else
				self:ShowItemTip();
				self.clickId = 0;
			end
		else
			self:ShowItemTip();
			self.clickId = 0;
		end
	else
		self:ShowItemTip();
		self.clickId = 0;
	end
end

function AchievementDescriptionCell:SetData( data )
	-- body	
	self.data = data
	self:SetRewardData()	
	self.name.text = self.data.staticData.Name
	local atlas = self.data.staticData.Atlas
	atlas = UIAtlasConfig.IconAtlas[atlas]
	atlas = atlas and atlas or UIAtlasConfig.IconAtlas["uiicon"]
	local sus = IconManager:SetIcon(self.data.staticData.Icon,self.icon, atlas)
	if(sus)then
		self:Show(self.icon.gameObject)
	else
		self:Hide(self.icon.gameObject)
	end
	-- self.icon:MakePixelPerfect();
	local textData = Table_AchievementText[self.data.staticData.AchievementTextID]
	local textStr = ""
	if(textData)then
		-- if(self.data.staticData.Visibility == 1)then
		-- 	textStr = ZhString.AdventureAchievePage_InvisibleAchievePreText
		-- end
		textStr = textData.Text
	end
	self.description.text = textStr

	self:SetTraceInfo()
	self:SetAchieveQuest()
	local dateStr = data:getCompleteString()
	if(data:canGetReward())then
		self:Show(self.addSymbol)
		self:SetTextureGrey(self.icon)
		self:Hide(self.completeIcon)
	elseif(dateStr)then
		self:Hide(self.addSymbol)
		self:SetTextureWhite(self.icon)
		self:Show(self.completeDate.gameObject)
		self:Show(self.completeIcon)
		-- self:Show(self.shareBtn)
		self.completeDate.text = string.format(ZhString.AdventureAchievePage_CompleteDate,dateStr)
		local bd = NGUIMath.CalculateRelativeWidgetBounds(self.rewardCt.transform,true)
		local height = bd.size.y
		local x,y,z = LuaGameObject.GetLocalPosition(self.rewardCt.transform)
		y = y - height - 20
		local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.completeDate.transform)
		tempVector3:Set(x1,y,z1)
		self.completeDate.transform.localPosition = tempVector3
	else
		self:Hide(self.addSymbol)
		self:SetTextureGrey(self.icon)
		self:Hide(self.completeIcon)
		self:Hide(self.shareBtn)
		self:Hide(self.completeDate.gameObject)
	end
	self.isSelected = true
	self:setSelected(false)
end

function AchievementDescriptionCell:SetAchieveQuest(  )
	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.description.transform,true)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.description.transform)
	y = y - height - 20

	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.questCt.transform)
	tempVector3:Set(x1,y,z1)
	self.questCt.transform.localPosition = tempVector3

	local staticData = self.data.staticData
	local preach = staticData.behavior == AchievementDescriptionCell.behaviorEnum.Achieve and staticData.time or nil
	local quest = staticData.behavior == AchievementDescriptionCell.behaviorEnum.Quest and staticData.time or nil
	TableUtility.ArrayClear(tempArray)
	if(quest and #quest>0)then
		for i=1,#quest do
			local exsitQuestData = QuestProxy.Instance:getQuestDataByIdAndType(quest[i])
			if(not exsitQuestData)then
				exsitQuestData = QuestProxy.Instance:getQuestDataByIdAndType(quest[i],SceneQuest_pb.EQUESTLIST_SUBMIT)
			end
			local result = self:GetQuestName(quest[i])
			local preQuestS,preAccept = self:GetPreQuest(quest[i])
			local questListType = exsitQuestData and exsitQuestData.questListType or preAccept
			local data = {type = AchievementDescriptionCell.SubAchieve.Quest,content = result,questListType = questListType ,preQuestS = preQuestS}
			table.insert(tempArray,data)
		end
	end

	if(preach and #preach>0)then
		for i=1,#preach do
			local tableData = Table_Achievement[preach[i]]
			local content = ""
			if(tableData)then
				content= tableData.Name
				local data = {type = AchievementDescriptionCell.SubAchieve.Achieve,content = content,id = preach[i]}
				table.insert(tempArray,data)
			end
		end
	end

	self.achievementQuestGrid:ResetDatas(tempArray)

	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.questCt.transform,true)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.questCt.transform)
	y = y - height - 20

	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.rewardCt.transform)
	tempVector3:Set(x1,y,z1)
	self.rewardCt.transform.localPosition = tempVector3
end

function AchievementDescriptionCell:GetQuestName(questId)
	if(self.data.questDatas)then
		for i=1, #self.data.questDatas do
			local single = self.data.questDatas[i]
			if(single.id == questId)then
				return single.name
			end
		end
	end
end

function AchievementDescriptionCell:GetValidPreQuest(questId,pre)
	if(pre and #pre>0)then
		local list = {}
		local preAccept = nil
		local id = QuestProxy.Instance:getQuestID(questId)
		local questIds = {}
		local questData = {}
		for i=1,#pre do
			local single = pre[#pre - i +1]
			local preId = QuestProxy.Instance:getQuestID(single.id)
			local questData = questIds[preId] or {}
			questData[#questData +1] = single
			if(id ~= preId and not questIds[preId])then
				list[#list+1] = questData 
				questIds[preId] = questData
			else
				if(not preAccept and id == preId)then
					local exsitQuestData = QuestProxy.Instance:getQuestDataByIdAndType(single.id)
					if(exsitQuestData)then
						preAccept = SceneQuest_pb.EQUESTLIST_ACCEPT
					end
				end
			end
		end
		return list,preAccept
	end
end

function AchievementDescriptionCell:GetPreQuest(questId)
	if(self.data.questDatas)then
		for i=1, #self.data.questDatas do
			local single = self.data.questDatas[i]
			if(single.id == questId)then
				return self:GetValidPreQuest(questId,single.pre)
			end
		end
	end
end

function AchievementDescriptionCell:GetAchieveQuestTrace(questData,step)
		
end

function AchievementDescriptionCell:SetTraceInfo(  )
	-- levelup = "levelup"
	-- addfriend = "addfriend",
	-- mapmove = "mapmove",
	-- killmonster = "killmonster",
	-- killcat = "killcat",
	-- Commissioned = "Commissioned",
	local behavior = self.data.staticData.behavior
	-- if(AchievementDescriptionCell.behaviorEnum[behavior])then
		local traceText = ""
		-- if(behavior == AchievementDescriptionCell.behaviorEnum.levelup)then
		-- 	local nowRoleLevel = MyselfProxy.Instance:RoleLevel() or 0
		-- 	local currentBaseLv = tostring(nowRoleLevel) 
		-- 	local time = self.data.staticData.time and self.data.staticData.time[1] or 0
		-- 	traceText = string.format(self.data.staticData.combination,currentBaseLv,time)
		-- elseif(behavior == AchievementDescriptionCell.behaviorEnum.addfriend)then
		-- 	local time = self.data.staticData.time and self.data.staticData.time[1] or 0
		-- 	traceText = string.format(self.data.staticData.combination,self.data:getProcess(),time)
		-- elseif(behavior == AchievementDescriptionCell.behaviorEnum.mapmove)then
		-- 	traceText = self.data.staticData.combination
		-- elseif(behavior == AchievementDescriptionCell.behaviorEnum.killmonster)then
		-- 	local time = self.data.staticData.time and self.data.staticData.time[1] or 0
		-- 	traceText = string.format(self.data.staticData.combination,self.data:getProcess(),time)
		-- elseif(behavior == AchievementDescriptionCell.behaviorEnum.killcat)then
		-- 	local time = self.data.staticData.time and self.data.staticData.time[1] or 0
		-- 	traceText = string.format(self.data.staticData.combination,self.data:getProcess(),time)
		-- elseif(behavior == AchievementDescriptionCell.behaviorEnum.Commissioned)then
		-- 	local time = self.data.staticData.time and self.data.staticData.time[1] or 0
		-- 	traceText = string.format(self.data.staticData.combination,self.data:getProcess(),time)
		-- end
		traceText = string.format(self.data.staticData.combination,self.data:getProcess())
		self.AchievementCondition.text = traceText
	-- else
		-- self:Log("error,unsupport behavior!!!!!")
	-- end
end

function AchievementDescriptionCell:checkCanAddPrayCount( behavior )
	local tb = GameConfig.AchievementType_TimeReward or {}
	return TableUtility.TableFindKey(tb,behavior)
end

function AchievementDescriptionCell:SetRewardData(  )
	local staticData = self.data.staticData
	local behavior = staticData.behavior
	local RewardExp = staticData.RewardExp
	local RewardItems = staticData.RewardItems
	local RewardTimes = staticData.RewardTimes
	-- local rewards = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
	-- if(rewards and #rewards>0)then
	local advRDatas = {}
	self.noReward = true
	if(RewardExp)then
		local temp = {};
		temp.type = "AdventureValue";
		temp.value = RewardExp;
		temp.showName = true;
		temp.color = AchievementDescriptionCell.RewardTextColor;
		table.insert(advRDatas, temp);
		self.noReward = false
	end

	if(self:checkCanAddPrayCount(behavior) and RewardTimes and RewardTimes ~="")then
		local temp = {};
		temp.type = "text";
		temp.preLabelTxt = RewardTimes;
		temp.value = "";
		table.insert(advRDatas, temp);
		self.noReward = false
	end

	local titleData = nil
	local normalData = nil
	self.noReward = false
	local titleReward = false
	if(RewardItems and #RewardItems>0)then
		for i=1,#RewardItems do
			local single = RewardItems[i]
			local itemData = Table_Item[single[1]]
			if(itemData )then
				if(itemData.Type == 10)then
					titleData = itemData
					local titleStr = TitleProxy.Instance:GetPropStrByTitleId(single[1])
					if(titleStr)then
						self.BufferLabel.text = titleStr
						titleReward = true
					end
				else
					normalData = itemData
				end
				local temp = {};
				local data = {
					single[1],
					single[2]
				}
				temp.type = "item"
				temp.value = data
				temp.showName = true
				temp.color = AchievementDescriptionCell.RewardTextColor;
				temp.addbracket = true
				table.insert(advRDatas, temp);
			end
		end
	end
	if(titleReward)then
		self:Show(self.BufferLabel.gameObject)
	else
		self:Hide(self.BufferLabel.gameObject)
	end
	self.rewardGrid:ResetDatas(advRDatas)

	if(not self.data:getCompleteString() and advRDatas[1])then
		local tipData = advRDatas[1]
		tipData.showName = false
		self:Show(self.collRewardGrid.gameObject)
		self.AdvTipRewardCell:SetData(tipData)
	else
		self:Hide(self.collRewardGrid.gameObject)
	end

	if(titleData)then
		self:Show(self.AchievementIcon.gameObject)
		local atlas = RO.AtlasMap.GetAtlas("NewUI1")
		self.AchievementIcon.atlas = atlas
		self.AchievementIcon.spriteName = "Adventure_icon_badge"
	elseif(normalData)then
		self:Show(self.AchievementIcon.gameObject)
		IconManager:SetItemIcon(normalData.Icon,self.AchievementIcon)
	else
		self:Hide(self.AchievementIcon.gameObject)
	end

	if(not self.noReward)then
		self:Show(self.rewardCt)
	else		
		self:Hide(self.collRewardGrid.gameObject)
		self:Hide(self.rewardCt)
	end
	self.collRewardGrid:Reposition()
end

function AchievementDescriptionCell:setSelected(isSelected)
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
		if(isSelected)then
			-- self.bg.height = 333
			self:Show(self.collapse)
			self:Hide(self.collRewardGrid.gameObject)
		else
			-- self.bg.height = 110
			self:Hide(self.collapse)
			if(self.data and not self.noReward and not self.data:getCompleteString())then
				self:Show(self.collRewardGrid.gameObject)
			end
		end

		self.collRewardGrid:Reposition()
		local bd = NGUIMath.CalculateRelativeWidgetBounds(self.content.transform,false)
		local height = bd.size.y
		self.bg.height = height + 25

	end
	NGUITools.UpdateWidgetCollider(self.gameObject);
end

function AchievementDescriptionCell:PlayUnlockEffect()
	self:PlayUIEffect(EffectMap.UI.Activation,self.effectContainer,true)
end