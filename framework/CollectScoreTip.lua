autoImport("BaseTip");
CollectScoreTip = class("CollectScoreTip" ,BaseView)

function CollectScoreTip:ctor(parent)
	self.resID = ResourcePathHelper.UITip("CollectScoreTip")

	self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent);
	self.gameObject.transform.localPosition = Vector3.zero;
	self:Init()
end

function CollectScoreTip:adjustPanelDepth( startDepth )
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

function CollectScoreTip:Init()
	-- self.typesprite = self:FindComponent("TypeSprite", UISprite);
	self.itemName = self:FindComponent("ItemName", UILabel);

	self.scrollView = self:FindComponent("ScrollView", UIScrollView);

	self.table = self:FindComponent("AttriTable", UITable);
	self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "AdventureTipLabelCell");

	self.adventureValue = self:FindComponent("adventureValue",UILabel)
	-- self.scoreCt = self:FindGO("scoreCt")

	self.MediaPlayCt = self:FindGO("MediaPlayCt")
	self:AddButtonEvent("MediaPlay",function (  )
		-- body
		if(BackwardCompatibilityUtil.CompatibilityMode_V10)then
			MsgManager.ShowMsgByIDTable(854);
			return
		end
		VideoPanel.PlayVideo(self.mediaPath);
	end)

	self.UnlockReward = self:FindGO("UnlockReward")
	local appTb = self:FindComponent("AppendTable", UITable);
	self.appCtl = UIGridListCtrl.new(appTb, AdventureAppendCell, "AdventureAppendCell");
	self.ItemCell = self:FindGO("ItemCell")
	local UnlockReward = self:FindGO("UnlockReward")
	self:Hide(UnlockReward)
	self:initLockBord()
end

function CollectScoreTip:adjustLockRewardPos(  )
	-- body
	local bound = NGUIMath.CalculateRelativeWidgetBounds(self.table.transform);
	local pos = self.table.transform.localPosition
	local y = pos.y - bound.size.y - 20
	self.UnlockReward.transform.localPosition = Vector3(pos.x,y,pos.z)	
end

function CollectScoreTip:initLockBord(  )
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
	
	self.LockReward = self:FindComponent("LockReward",UILabel)
	self.LockReward.text = ZhString.MonsterTip_LockReward

	self.FixAttrCt = self:FindGO("FixAttrCt")
	self:Hide(self.FixAttrCt)

	self.modelBottombg = self:FindGO("modelBottombg")
end

function CollectScoreTip:SetUnlockCondition(  )
	-- body
	local str = AdventureDataProxy.getUnlockCondition(self.data)
	local rewardStr = self:getUnlockRewardStr()
	if(rewardStr and rewardStr ~= "")then
		str = str..","..rewardStr
	end
	self.lockTipLabel.text = str
end

function CollectScoreTip:getUnlockRewardStr(  )
	-- body
	local advReward = self.data.staticData.AdventureReward
	if(type(advReward)=="table" and type(advReward.buffid)=="table")then
		local str = ""
		for i=1,#advReward.buffid do
			-- local temp = {};
			-- temp.type = "buffid";
			local value = advReward.buffid[i];
			local bufferData = Table_Buffer[value]
			if bufferData then
				str = str..(bufferData.Dsc or "");
				str = str.."\n"
			end
		end
		if(str~="")then
			str = string.sub(str, 1, -2);
		end
		return str
	end
end

function CollectScoreTip:adjustDepth( obj )
	-- body
	local max = -999
	if(obj)then
		local objs = GameObjectUtil.Instance:GetAllChildren(obj)
		for i=1,#objs do
			local child = objs[i]
			local widget = child:GetComponent(UIWidget)
			if(widget)then
				widget.depth = widget.depth+50
				if(widget.depth > max)then
					max = widget.depth
				end
			end
		end
		-- NGUITools.NormalizeWidgetDepths()
	end
	return max
end

function CollectScoreTip:UpdateTopInfo()
	local data = self.data;
	local sdata = data and data.staticData;
	if(sdata)then
		self.itemName.text = sdata.NameZh;
		self.itemCellCtl = ItemCell.new(self.ItemCell)
		self.itemCellCtl:SetData(self.data)
		self.mediaPath =  sdata.MediaPath
		if(self.mediaPath and self.mediaPath ~= '')then
			self:Show(self.MediaPlayCt)
			self:Hide(self.ItemCell)
		else
			self:Show(self.ItemCell)
			self:Hide(self.MediaPlayCt)
		end
	end
end

function CollectScoreTip:SetData(monsterData)
	self.data = monsterData;
	self:SetLockState();
	self:UpdateTopInfo();	
	self:UpdateAttriText();
	self:UpdateAppendData()
	self:adjustPanelDepth(4)
	self:adjustLockRewardPos()
	self:adjustLockView()
	self:SetUnlockCondition()
end

function CollectScoreTip:adjustLockView(  )
	-- -- body	
	-- local sbg = self:FindComponent("SpriteBg",UISprite)
	-- sbg.width = 450
	-- sbg.height = 300
	-- local pos = sbg.gameObject.transform.localPosition
	-- sbg.gameObject.transform.localPosition = Vector3(pos.x,151.85,pos.y)
end

function CollectScoreTip:SetLockState()
	self.isUnlock = false;
	if(self.data)then
		self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY;
		-- if(self.data.AdventureValue and self.data.AdventureValue>0 and not self.isUnlock)then
		-- 	self.adventureValue.text = tostring(self.data.AdventureValue);
		-- 	self:Show(self.scoreCt);
		-- else
		-- 	self:Hide(self.scoreCt);
		-- end

		local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data)
		self.lockTipLabel.text = unlockCondition
	end	

	if(self.isUnlock)then
		self:Show(self.modelBottombg)
	else
		self:Hide(self.modelBottombg)
	end
	
	self.lockBord.gameObject:SetActive(not self.isUnlock);	
end

function CollectScoreTip:GetItemUnlock(  )
	local advReward, advRDatas = self.data.staticData.AdventureReward, {};
	if(self.data.staticData.AdventureValue and self.data.staticData.AdventureValue >0)then
		local temp = {}
		if(not self.isUnlock)then
			temp.label = "[c][808080ff]"..AdventureDataProxy.getUnlockCondition(self.data).."，".."{uiicon=Adventure_icon_05}x"..self.data.staticData.AdventureValue.."[-][/c]"
			temp.tiplabel = "[c][808080ff]"..ZhString.MonsterTip_LockReward.."[-][/c]"
		else
			temp.label = AdventureDataProxy.getUnlockCondition(self.data).."，".."{uiicon=Adventure_icon_05}x"..self.data.staticData.AdventureValue.."[-][/c]"
			temp.tiplabel = ZhString.MonsterTip_LockReward
		end
		temp.hideline = true
		return temp
	end	
end

function CollectScoreTip:GetItemQuality(  )
	local sdata = self.data.staticData;
	if(sdata)then
		local desc = {};
		desc.label = GameConfig.ItemQualityDesc[sdata.Quality]
		desc.hideline = true;
		desc.tiplabel = ZhString.MonthTip_QualityRate
		return desc
	end
end

function CollectScoreTip:GetItemDesc(  )
	local sdata = self.data.staticData;
	if(sdata and self.isUnlock)then
		local desc = {};
		desc.label = sdata.Desc;
		desc.hideline = true;
		return desc
	end
end

function CollectScoreTip:UpdateAttriText()
	local contextDatas = {};
	local desc = self:GetItemDesc()
	if(desc)then
		table.insert(contextDatas, desc);
	end

	local quality = self:GetItemQuality()
	if(quality)then
		table.insert(contextDatas, quality);
	end

	local unlockProp = self:GetItemUnlock()
	if(unlockProp)then
		table.insert(contextDatas, unlockProp);
	end

	self.attriCtl:ResetDatas(contextDatas);
end

function CollectScoreTip:UpdateAppendData(  )
	-- body
	if(self.isUnlock)then
		local trans = self.attriCtl.layoutCtrl.transform
		local bound = NGUIMath.CalculateRelativeWidgetBounds(trans,true)
		local pos = trans.localPosition
		pos = Vector3(pos.x,pos.y- bound.size.y,pos.z - 20)
		trans = self.appCtl.layoutCtrl.transform
		trans.localPosition = pos
		local appends = self.data:getNoRewardAppend()
		if(#appends>0)then
			self.appCtl:ResetDatas(appends)
		end
	end
end

function CollectScoreTip:OnExit()
	self.attriCtl:ResetDatas()
	self.appCtl:ResetDatas()
	CollectScoreTip.super.OnExit(self);
	Game.GOLuaPoolManager:AddToUIPool(self.resID,self.gameObject)
end