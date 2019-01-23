 autoImport("BaseTip");
CollectGroupScoreTip = class("CollectGroupScoreTip" ,BaseView)

autoImport("TipLabelCell");
-- autoImport("AdvTipRewardCell");
-- autoImport("AdventureAppendCell")
-- autoImport("AdventureBaseAttrCell")
autoImport("ProfessionSkillCell")

local tempVector3 = LuaVector3.zero

CollectGroupScoreTip.BgTextureName = "com_bg_light"
function CollectGroupScoreTip:ctor(parent)
	self.resID = ResourcePathHelper.UITip("CollectGroupScoreTip")

	self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent);
	self.gameObject.transform.localPosition = Vector3.zero;
	self:Init()
end

function CollectGroupScoreTip:adjustPanelDepth( startDepth )
	-- body
	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	local panels = self:FindComponents(UIPanel);
	local minDepth = nil;
	for i=1,#panels do
		if(minDepth == nil)then
			minDepth = panels[i].depth;
		else
			minDepth = math.min(panels[i].depth, minDepth);
		end
	end
	startDepth = startDepth or 1;
	for i=1,#panels do
		panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth;
	end
end

function CollectGroupScoreTip:Init()
	self:initLockBord()
	self:initView()
end

function CollectGroupScoreTip:initView(  )
	-- self.monstername = self:FindComponent("MonsterName", UILabel);
	self.scrollView = self:FindComponent("ScrollView", UIScrollView);	
	self.modeltexture = self:FindComponent("ModelTexture", UITexture);
	self.adventureValue = self:FindComponent("adventureValue",UILabel)
	self.GroupIcon = self:FindComponent("GroupIcon",UISprite)
	self.CollectionGroupName = self:FindComponent("CollectionGroupName",UILabel)

	self.table = self:FindComponent("AttriTable", UITable);
	self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "AdventureTipLabelCell");

	self.chatacterBtn = self:FindGO("ChatacterBtn");
	local btnText = self:FindComponent("Label",UILabel,self.chatacterBtn)
	btnText.text = ZhString.CollectGroupScoreTip_EDBtn

	self:AddClickEvent(self.chatacterBtn, function (go)
		--TODO
		ServiceSceneManualProxy.Instance:CallGroupActionManualCmd(SceneManual_pb.EGROUPACTION_ENTER_END,self.data.staticData.staticId)
	end)

	local itemGrid =  self:FindComponent("ItemTable",UIGrid)
	self.gridList = UIGridListCtrl.new(itemGrid,AdventrueItemCell,"AdventureItemCell")
	self.gridList:AddEventListener(MouseEvent.MouseClick,self.clickHandler,self)
	self.effectContainer = self:FindComponent("EffectContainer",ChangeRqByTex);
	self.holderDepth = self:FindComponent("EffectContainer",UITexture).depth;
	self.mask = self:FindGO("mask")

	self.bgTexture = self:FindComponent("BgTexture", UITexture);
	PictureManager.Instance:SetUI(CollectGroupScoreTip.BgTextureName, self.bgTexture);
end

function CollectGroupScoreTip:initLockBord(  )
	-- body
	local obj = self:FindGO("13itemShine")
	self.lockBord = self:FindGO("LockBordHolder");
	if(not obj)then
		-- obj = Game.AssetManager_UI:CreateAsset("Public/Effect/UI/13itemShine",self.gameObject);
		-- local textures = UIUtil.GetAllComponentsInChildren(obj, UITexture)
		-- for i=1,#textures do
		-- 	local single = textures[i]
		-- 	single.depth = self.holderDepth + single.depth
		-- end
		-- self.effectContainer:AddChild(obj);
	end
	-- obj.transform.localPosition = Vector3.zero
	-- obj.transform.localScale = Vector3.one
	-- self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel);
	-- local LockTitle = self:FindComponent("LockTitle",UILabel)	
end

function CollectGroupScoreTip:clickHandler(target)
	local data = target.data
	if(data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
		ServiceSceneManualProxy.Instance:CallUnlock(data.type,data.staticId)
		target:PlayUnlockEffect()
		self:PlayUISound(AudioMap.UI.maoxianshoucedianjijiesuo)
	else
		local itemData = ItemData.new(nil,data.staticId)
		local sdata = {
			itemdata = itemData,
			hideItemIcon = data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK,
		};
		self:ShowItemTip(sdata,target.bg,NGUIUtil.AnchorSide.Right, {200, 0})
	end
end

function CollectGroupScoreTip:SetData(data)
	self.data = data;
	self:initData()
	self:SetLockState();
	self:adjustPanelDepth()
	self:UpdateCollections()
	self:UpdateAttriText();
end

function CollectGroupScoreTip:initData(  )
	-- body
	-- local sdata = self.data.staticData
	-- if(sdata)then		
	-- 	if(sdata.Nature)then
	-- 		local result = IconManager:SetUIIcon(sdata.Nature,self.MonstPro)
	-- 		if(not result)then
	-- 			self:Hide(self.MonstPro.gameObject)
	-- 		else
	-- 			self:Show(self.MonstPro.gameObject)
	-- 		end
	-- 	else
	-- 		self:Hide(self.MonstPro.gameObject)
	-- 	end

	-- 	if(sdata.Race)then
	-- 		local result = IconManager:SetUIIcon(sdata.Race,self.MonstRace)
	-- 		if(not result)then
	-- 			self:Hide(self.MonstRace.gameObject)
	-- 		else
	-- 			self:Show(self.MonstRace.gameObject)
	-- 		end
	-- 	else
	-- 		self:Hide(self.MonstRace.gameObject)
	-- 	end
	-- end
	IconManager:SetItemIcon(self.data.staticData.Icon,self.GroupIcon)
	self.CollectionGroupName.text = self.data.staticData.Name

	if(self.data.staticData and self.data.staticData.Ed == 1)then
		self:Show(self.chatacterBtn.gameObject)
	else
		self:Hide(self.chatacterBtn.gameObject)
	end
end

function CollectGroupScoreTip:SetLockState()
	self.isUnlock = false;
	if(self.data)then
		-- self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
		-- local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data,true)
		-- self.lockTipLabel.text = unlockCondition

		-- local sdata = self.data and self.data.staticData;
		-- if(sdata)then
		-- 	self.monstername.text = sdata.NameZh;
		-- end
		self.isUnlock = self.data:isTotalComplete()		
	end

	self.lockBord.gameObject:SetActive(not self.isUnlock)
	self.mask:SetActive(not self.isUnlock)
end

function CollectGroupScoreTip:Show3DModel()
	-- local data = self.data;
	-- local monsterData = data and data.staticData;
	-- if(monsterData)then
	-- 	self.model = UIModelUtil.Instance:SetMonsterModelTexture(self.modeltexture, monsterData.id);
	-- 	local showPos = monsterData.LoadShowPose;
	-- 	if(showPos and #showPos == 3)then
	-- 		tempVector3:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0);
	-- 		self.model:SetPosition(tempVector3);
	-- 	end

	-- 	self.model:SetEulerAngleY(monsterData.LoadShowRotate or 0);
	-- 	local size = monsterData.LoadShowSize or 1
	-- 	self.model:SetScale(size);
	-- end
	-- return false;
end

function CollectGroupScoreTip:UpdateCollections()
	local data = self.data
	if(data)then
		local collections = self.data:getCollectionData()
		self.gridList:ResetDatas(collections)
	else
		self.gridList:ResetDatas({})
	end
end

function CollectGroupScoreTip:UpdateAttriText()
	local content = {};
	local data = self.data;
	local sdata = self.data.staticData;
	if(data and sdata)then
		local transform = self.gridList.layoutCtrl.transform
		local bound = NGUIMath.CalculateRelativeWidgetBounds(transform,false)
		local pos = transform.localPosition
		local y = pos.y - bound.size.y - 20 +50
		if(bound.size.y == 0)then
			y = pos.y + 50
		end
		tempVector3:Set(-13,y,0)
		self.attriCtl.layoutCtrl.transform.localPosition = tempVector3

		-- self:Show3DModel()
		-- if(advReward.AdvPoints)then
		-- 	local temp = {}
		-- 	temp.type = "AdvPoints"
		-- 	temp.value = advReward.AdvPoints
		-- 	table.insert(advRDatas, temp)
		-- end
		
		-- if(advReward.item)then
		-- 	for i=1,#advReward.item do
		-- 		local temp = {};p
		-- 		temp.type = "item";
		-- 		temp.value = advReward.item[i];
		-- 		table.insert(advRDatas, temp);
		-- 	end
		-- end
		local rewardStr = ""
		local advReward = sdata.RewardProperty
		if(sdata.RewardStr and sdata.RewardStr ~= "" and advReward)then
			rewardStr = sdata.RewardStr
		-- else
			local tempRewardStr = ""
			for key,value in pairs(advReward)do
				local kprop = RolePropsContainer.config[key]
				if(kprop and kprop.displayName and value>0)then
					tempRewardStr = tempRewardStr..kprop.displayName.." [c][9fc33dff]+"..value.."[-][/c] ";
				end
			end
			if(advReward.AdvPoints)then				
				tempRewardStr = tempRewardStr.."{itemicon=451} x"..advReward.AdvPoints
			end
			
			if(advReward.item)then
				for i=1,#advReward.item do
					tempRewardStr = tempRewardStr..string.format("{itemicon=%d} x%s",advReward.item[i][1],advReward.item[i][2])
				end
			end
			rewardStr = string.format(rewardStr,tempRewardStr)
		end
		if(rewardStr and rewardStr ~="")then
			tipLabelCell = {}
			tipLabelCell.label = {}
			tipLabelCell.hideline = true
			desc = "[c][FF622CFF]"..ZhString.MonsterTip_LockReward.."[-][/c]"
			table.insert(tipLabelCell.label, desc)
			local currentUnlock = data:getCurrentUnlockNum()
			local total = #data.collections
			if(self.isUnlock)then
				table.insert(tipLabelCell.label, string.format(ZhString.CollectGroupScoreTip_HeadTip,currentUnlock,total, rewardStr))
			else
				table.insert(tipLabelCell.label, string.format(ZhString.CollectGroupScoreTip_HeadTip_Unlock,currentUnlock,total,rewardStr))
			end
			content[#content +1] = tipLabelCell
		end

		tipLabelCell = {};
		if(self.isUnlock)then
			tipLabelCell.label = GameConfig.ItemQualityDesc[sdata.Quality]
		else
			tipLabelCell.label = "[c][22222291]"..GameConfig.ItemQualityDesc[sdata.Quality]
		end
		tipLabelCell.hideline = true;
		tipLabelCell.tiplabel = ZhString.MonthTip_QualityRate
		content[#content +1] = tipLabelCell

		local tipLabelCell = {}		
		local desc = sdata.Desc
		if(desc ~= "")then
			tipLabelCell = {}
			tipLabelCell.label = {}
			tipLabelCell.hideline = true
			table.insert(tipLabelCell.label, "[c][FF622CFF]"..ZhString.MonsterTip_Story.."[-][/c]")
			if(self.isUnlock)then
				table.insert(tipLabelCell.label, desc)
			else
				-- table.insert(tipLabelCell.label, "[c][22222291]"..desc.."[-][/c]")
				table.insert(tipLabelCell.label, "？？？？？？？")
			end
			content[#content +1] = tipLabelCell
		end		

		-- local AdventureValue = sdata.AdventureValue or 0
		-- self.adventureValue.text = AdventureValue
		-- local unlockCondition = GameConfig.AdventureUnlockCodition[sdata.Condition] or ""
		-- local formatStr = ZhString.PetScoreTip_UnlockPet
		-- if(not self.isUnlock)then
		-- 	formatStr = "[c][22222291]"..formatStr.."[-][/c]"
		-- end
		-- desc = string.format(formatStr,unlockCondition,sdata.NameZh,AdventureValue)
		-- table.insert(tipLabelCell.label, desc)
		
	end
	self.attriCtl:ResetDatas(content);
end

function CollectGroupScoreTip:OnExit()
	self.attriCtl:ResetDatas()
	self.gridList:ResetDatas()
	CollectGroupScoreTip.super.OnExit(self);
	UIModelUtil.Instance:ResetTexture( self.modeltexture )
	Game.GOLuaPoolManager:AddToUIPool(self.resID,self.gameObject)
	PictureManager.Instance:UnLoadUI(CollectGroupScoreTip.BgTextureName,self.bgTexture);
end