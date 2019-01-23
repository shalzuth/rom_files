autoImport("BaseTip");
NpcScoreTip = class("NpcScoreTip" ,BaseView)

autoImport("Table_MonsterOrigin");
autoImport("UIGridListCtrl");
autoImport("TipLabelCell");
autoImport("AdvTipRewardCell");

autoImport("UIModelShowConfig");

function NpcScoreTip:ctor(parent)
	self.resID = ResourcePathHelper.UITip("NpcScoreTip")

	self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent);
	self.gameObject.transform.localPosition = Vector3.zero;
	self:Init()
end

function NpcScoreTip:Init()
	self.unlockBord = self:FindGO("UnLockBord");
	-- local dadventureScore = self:FindGO("DefaultAdventureScore");
	-- self.dascorelab = self:FindComponent("Label", UILabel, dadventureScore);

	self.FunctionIcon = self:FindComponent("FunctionIcon",UISprite);
	self.npcname = self:FindComponent("NpcName", UILabel);
	-- self.qualitybg = self:FindComponent("QualityBg", UISprite);
	-- self.typesprite = self:FindComponent("TypeSprite", UISprite);
	self.modeltexture = self:FindComponent("ModelTexture", UITexture);
	self.scrollView = self:FindComponent("ScrollView", UIScrollView);
	self.adventureValue = self:FindComponent("adventureValue",UILabel)
	-- self.adventureScore = self:FindGO("AdventureScore");
	-- self.ascorelab = self:FindComponent("Label", UILabel, self.adventureScore);
	self.table = self:FindComponent("AttriTable", UITable);
	self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "AdventureTipLabelCell");

	local modelBg = self:FindGO("ModelBg")
	self:AddDragEvent(modelBg ,function (go, delta)
		if(self.model)then
			self.model:RotateDelta( -delta.x );
		end
	end);
	self:initLockBord()
end

function NpcScoreTip:adjustPanelDepth( startDepth )
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

function NpcScoreTip:initLockBord(  )
	-- body
	local obj = self:FindGO("LockBord")
	self.lockBord = self:FindGO("LockBordHolder");
	if(not obj)then
		obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord);
		obj.name = "LockBord";
	end
	obj.transform.localPosition = Vector3.zero
	obj.transform.localScale = Vector3.one

	self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel);	
	local LockTitle = self:FindComponent("LockTitle",UILabel)
	LockTitle.text = ZhString.MonsterTip_LockTitle
	local LockReward = self:FindComponent("LockReward",UILabel)
	LockReward.text = ZhString.MonsterTip_LockReward

	self.FixAttrCt = self:FindGO("FixAttrCt")
	self:Hide(self.FixAttrCt)
	self.fixedAttrLabel = self:FindComponent("fixedAttrLabel",UILabel)
	local fixLabelCt = self:FindComponent("fixLabelCt",UILabel)
	fixLabelCt.text = ZhString.MonsterTip_FixAttrCt
	local grid = self:FindComponent("LockInfoGrid", UIGrid);
	self.advRewardCtl = UIGridListCtrl.new(grid, AdvTipRewardCell, "AdvTipRewardCell");

	-- local scoreCt = self:FindGO("scoreCt")
	-- self:Hide(scoreCt)

	self.modelBottombg = self:FindGO("modelBottombg")
end

function NpcScoreTip:OnEnable()

end

function NpcScoreTip:SetData(npcdata)
	self.data = npcdata;
	self:initData()
	self:UpdateAdvReward();
	self:SetLockState()
	self:UpdateAttriText();
	self:UpdateTopInfo();
	self:Show3DModel();
	self:adjustPanelDepth(4)
	self:adjustLockRewardPos()
end

function NpcScoreTip:initData(  )
	-- body
	if(self.data.staticData.MapIcon ~= "")then
		if(IconManager:SetMapIcon(self.data.staticData.MapIcon,self.FunctionIcon))then
			self:Show(self.FunctionIcon.gameObject)
			self.FunctionIcon:MakePixelPerfect()
		else
			self:Hide(self.FunctionIcon.gameObject)
		end
	else
		self:Hide(self.FunctionIcon.gameObject)
	end
end

function NpcScoreTip:adjustLockRewardPos(  )
	-- body
	local UnlockReward = self:FindGO("UnlockReward")
	-- if(self.isUnlock)then
		self:Hide(UnlockReward)
	-- else
	-- 	self:Show(UnlockReward)
	-- end

	-- local bound = NGUIMath.CalculateRelativeWidgetBounds(self.table.transform);
	-- local pos = self.table.transform.localPosition
	-- local y = pos.y - bound.size.y - 20
	-- -- printRed("ocalPosition",bound.)
	-- UnlockReward.transform.localPosition = Vector3(pos.x,y,pos.z)	
end

function NpcScoreTip:SetLockState()
	self.isUnlock = false;
	if(self.data)then
		self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY;
		-- if(self.data.AdventureValue and self.data.AdventureValue>0)then
		-- 	self.dascorelab.text = tostring(self.data.AdventureValue);
		-- 	self:Show(self.advScore);
		-- else
		-- 	self:Hide(self.advScore);
		-- end
		local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data,true)
		self.lockTipLabel.text = unlockCondition
	end
	self.lockBord.gameObject:SetActive(not self.isUnlock);
	if(not self.isUnlock)then
		self.npcname.text = "????";
		self:Hide(self.modelBottombg)
	else
		self:Show(self.modelBottombg)
	end
	return self.isUnlock
end

function NpcScoreTip:UpdateAdvReward()
	local advReward, advRDatas = self.data.staticData.AdventureReward, {};
	if(self.data.staticData.AdventureValue and self.data.staticData.AdventureValue>0)then
		local temp = {};
		temp.type = "AdventureValue";
		temp.value = self.data.staticData.AdventureValue;
		table.insert(advRDatas, temp);
	end
	if(type(advReward)=="table")then
		if(advReward.AdvPoints)then
			local temp = {};
			temp.type = "AdvPoints";
			temp.value = advReward.AdvPoints;
			table.insert(advRDatas, temp);
		end
		if(type(advReward.buffid)=="table")then
			if(#advReward.buffid >0)then
				self:Show(self.FixAttrCt)
			end
			local str = ""
			for i=1,#advReward.buffid do
				-- local temp = {};
				-- temp.type = "buffid";
				local value = advReward.buffid[i];
				-- table.insert(advRDatas, temp);
				str = str..(ItemUtil.getBufferDescByIdNotConfigDes(value) or "");
			end
			self.fixedAttrLabel.text = str
		end
		if(advReward.item)then
			for i=1,#advReward.item do
				local temp = {};
				temp.type = "item";
				temp.value = advReward.item[i];
				table.insert(advRDatas, temp);
			end
		end
	else
		self:Hide(self.FixAttrCt)
	end	
	self.advRewardCtl:ResetDatas(advRDatas)

	local value = 0
	if(self.data and self.data.staticData and self.data.staticData.AdventureValue)then
		value = self.data.staticData.AdventureValue
	end
	-- printRed("AdventureValue",value)
	self.adventureValue.text = value
end

function NpcScoreTip:UpdateTopInfo()
	local data = self.data;
	local sdata = data and data.staticData;
	if(sdata)then
		-- if(self.isUnlock)then
			self.npcname.text = sdata.NameZh;
		-- end
		-- self.ascorelab.text = tostring(sdata.AdventureValue);

		-- self.typesprite.gameObject:SetActive(false);
		-- if(sdata.Type)then
		-- 	local key = GameConfig.AdventureCategoryMonsterType[sdata.Type]
		-- 	if(key)then
		-- 		local typeData = Table_ItemType[key];
		-- 		if(typeData)then
		-- 			self.typesprite.gameObject:SetActive(true);
		-- 			self.typesprite.spriteName = tostring(typeData.icon);
		-- 			self.typesprite:MakePixelPerfect();
		-- 		end
		-- 	end
		-- end
		-- self.qualitybg.spriteName = "com_tips_5";
	end
end

function NpcScoreTip:Show3DModel()
	local data = self.data;
	local sdata = data and data.staticData;
	if(sdata)then
		local otherScale = 1;
		if(sdata.Shape)then
			otherScale = GameConfig.UIModelScale[sdata.Shape] or 1;
		else
			helplog(string.format("Npc:%s Not have Shape", sdata.id));
		end

		if(sdata.Scale)then
			otherScale = sdata.Scale
		end
		self.model = UIModelUtil.Instance:SetNpcModelTexture(self.modeltexture, sdata.id);

		local showPos = sdata.LoadShowPose
		if(showPos and #showPos == 3)then
			tempVector3:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
			self.model:SetPosition(tempVector3);
		end
		if(sdata.LoadShowRotate)then
			self.model:SetEulerAngleY(sdata.LoadShowRotate)
		end
		if(sdata.LoadShowSize)then
			otherScale = sdata.LoadShowSize
		end
		self.model:SetScale( otherScale );
	end
end


function NpcScoreTip:GetPropDetail(  )
	local rewards = AdventureDataProxy.Instance:getAppendRewardByTargetId(self.data.staticId,"selfie")
	if(not self.data.attrUnlock and rewards and #rewards>0)then
		local items = ItemUtil.GetRewardItemIdsByTeamId(rewards[1])
		local unlocktip = {};
		unlocktip.hideline = true;
		unlocktip.tiplabel = ZhString.MonsterTip_MonstDetail
		unlocktip.label = string.format(ZhString.MonsterTip_UnLockMonstDetail,self.data.staticData.NameZh).."{uiicon=Adventure_icon_05}x"..items[1].num
		return unlocktip
	end
end

function NpcScoreTip:GetDescription(  )
	if(self.isUnlock)then
		local sdata = self.data.staticData
		local desc = {};
		if(sdata.Desc~="")then
			desc.label = sdata.Desc;
			desc.hideline = true;
			return desc
		end
	end
end

function NpcScoreTip:GetUnlockProp(  )
	local advReward = self.data.staticData.AdventureReward
	local advalue = self.data.staticData.AdventureValue or 0
	local temp = {}
	temp.hideline = true
	temp.label = {}
	temp.tiplabel = ZhString.MonsterTip_LockReward
	local str = "%s, {uiicon=Adventure_icon_05} x%s"
	
	if(advReward.item)then
		for i=1,#advReward.item do
			str = str..","..string.format("  {itemicon=%s} x%s",advReward.item[i][1],advReward.item[i][2])
		end
	end
	
	local rewardStr = string.format(str,AdventureDataProxy.getUnlockCondition(self.data,true),advalue)
	if(not self.isUnlock)then
		rewardStr = "[c][808080ff]"..rewardStr.."[-][/c]"
		temp.tiplabel = "[c][808080ff]"..ZhString.MonsterTip_LockReward.."[-][/c]"
	end

	table.insert(temp.label,rewardStr)
	return temp
end

function NpcScoreTip:GetBelong(  )
	if(self.isUnlock)then
		local sdata = self.data.staticData
		local guild = {};
		if(sdata.Guild and sdata.Guild~="")then
			local guildTip = sdata.Guild;
			guild.label = guildTip;
			guild.tiplabel = ZhString.NpcTip_Guild
			guild.hideline = true;
			return guild
		end
	end
end

function NpcScoreTip:GetFunction(  )
	-- if(self.isUnlock)then
		-- 功能
		local sdata = self.data.staticData
		local funcConfig = sdata.NpcFunction;
		local funcs = {};
		if(#funcConfig>0)then
			local funcsTip = "";
			for i=1,#funcConfig do
				local type = funcConfig[i].type;
				local nfcfg = Table_NpcFunction[type] 
				if(nfcfg)then
					funcsTip = funcsTip..nfcfg.NameZh;
				end
				if(i<#funcConfig)then
					funcsTip = funcsTip..ZhString.Common_Comma;
				end
			end
			funcs.label = funcsTip;
			funcs.tiplabel = ZhString.NpcTip_Func  
			funcs.hideline = true;
			return funcs
		end
	-- end
end

function NpcScoreTip:GetPosition(  )
	-- body
	-- 出现地点
	local position = {};
	if(Table_MonsterOrigin)then
		local sdata = self.data.staticData
		local posConfigs = Table_MonsterOrigin[sdata.id];
		-- printRed(posConfigs);
		if(posConfigs and #posConfigs>0)then
			local posTip = "";
			-- local filterMap = {};
			for i=1,#posConfigs do
				local mapID = posConfigs[i].mapID;
				local mapdata = Table_Map[mapID];
				if(mapdata)then
					-- if(not filterMap[mapID])then
					-- 	filterMap[mapID] = 1;
						posTip = posTip..mapdata.NameZh;
						posTip = posTip..ZhString.Common_Comma;
					-- end
				end
			end
			local len = StringUtil.getTextLen( posTip)
			posTip = StringUtil.getTextByIndex( posTip,1,len -1)string.sub(posTip, 1, -2);
			position.label = posTip;
			position.tiplabel = ZhString.NpcTip_Position
			position.hideline = true;
			return position
		end
	end
end

function NpcScoreTip:UpdateAttriText()
	local data = self.data;
	local sdata = data and data.staticData;
	local contextDatas = {};
	if(data and sdata)then

		local desc = self:GetDescription()
		if(desc)then
			table.insert(contextDatas, desc);
		end

		local func = self:GetFunction( )
		if(func)then
			table.insert(contextDatas, func);
		end

		local belong = self:GetBelong()
		if(belong)then
			table.insert(contextDatas, belong);
		end
		-- 出现地点
		local position = self:GetPosition()
		if(position)then
			table.insert(contextDatas, position);
		end

		local unlockProp = self:GetUnlockProp()
		if(unlockProp)then
			table.insert(contextDatas, unlockProp);
		end
	end
	self.attriCtl:ResetDatas(contextDatas);
end

function NpcScoreTip:OnExit()
	self.attriCtl:ResetDatas()
	self.advRewardCtl:ResetDatas()
	NpcScoreTip.super.OnExit(self);
	UIModelUtil.Instance:ResetTexture( self.modeltexture )

	Game.GOLuaPoolManager:AddToUIPool(self.resID,self.gameObject)
end