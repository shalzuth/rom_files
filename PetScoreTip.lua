 autoImport("BaseTip");
PetScoreTip = class("PetScoreTip" ,BaseView)

autoImport("TipLabelCell");
-- autoImport("AdvTipRewardCell");
-- autoImport("AdventureAppendCell")
-- autoImport("AdventureBaseAttrCell")
autoImport("ProfessionSkillCell")

local tempVector3 = LuaVector3.zero

function PetScoreTip:ctor(parent)
	self.resID = ResourcePathHelper.UITip("PetScoreTip")

	self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent);
	self.gameObject.transform.localPosition = Vector3.zero;
	self:Init()
end

function PetScoreTip:adjustPanelDepth( startDepth )
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

function PetScoreTip:Init()
	self.monstername = self:FindComponent("MonsterName", UILabel);
	self.scrollView = self:FindComponent("ScrollView", UIScrollView);	

	self.modeltexture = self:FindComponent("ModelTexture", UITexture);
	self.adventureValue = self:FindComponent("adventureValue",UILabel)

	self.table = self:FindComponent("AttriTable", UITable);
	self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "AdventureTipLabelCell");

	local modelBg = self:FindGO("ModelBg");
	self:AddDragEvent(modelBg ,function (go, delta)
		if(self.model)then
			self.model:RotateDelta( -delta.x );
		end
	end);
	
	self.chatacterBtn = self:FindGO("ChatacterBtn");
	local btnText = self:FindComponent("Label",UILabel,self.chatacterBtn)
	btnText.text = ZhString.ItemTip_BuyGetItem
	self:AddClickEvent(self.chatacterBtn, function (go)
		--TODO
		if(self.data and self.data.staticData)then
			for k,v in pairs(Table_Pet_Capture) do
				if(v.PetID ==self.data.staticId )then
					local lackItem= {id = v.GiftItemID, count = 1};
					QuickBuyProxy.Instance:TryOpenView({lackItem})
					break
					return
				end
			end
		end
	end)
	self:Hide(self.chatacterBtn)

	self:initLockBord()

	-- local LockReward = self:FindComponent("LockReward",UILabel)
	-- LockReward.text = ZhString.MonsterTip_LockReward

	local skillGrid =  self:FindComponent("PetSkillTable",UITable)
	self.gridList = UIGridListCtrl.new(skillGrid,ProfessionSkillCell,"ProfessionSkillCell")
	self.gridList:AddEventListener(MouseEvent.MouseClick,self.clickHandler,self)

	self.MonstPro = self:FindComponent("MonstPro",UISprite)
	self.MonstRace = self:FindComponent("MonstRace",UISprite)
end

function PetScoreTip:initLockBord(  )
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
	self.modelBottombg = self:FindGO("modelBottombg")
	self.getPathBtn = self:FindGO("getPathBtn");
	self.BottomCt = self:FindGO("BottomCt")
	self:Show(self.getPathBtn)

	local dropContainer = self:FindGO("DropContainer");
	self:AddClickEvent(self.getPathBtn, function (go)
		if(self.data and self.data.staticData)then
			local egg = PetProxy.Instance:GetCaptureDataByPetID(self.data.staticData.id)
			local eggId = 0
			if(egg)then
				eggId = egg.EggID
			end
			if(self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject))then
				self.gainwayCtl:OnExit();
				self.gainwayCtl = nil;
			else
				self.gainwayCtl = GainWayTip.new(dropContainer)
				self.gainwayCtl:SetData(eggId);
			end
		end
	end);
end

function PetScoreTip:clickHandler(target)
	local skillId = target.data
	local skillItem = SkillItemData.new(skillId)
	local tip = TipManager.Instance:ShowPetSkillTip(skillItem)
	if(tip)then
		tempVector3:Set(175,0,0)
		tip.gameObject.transform.localPosition = tempVector3
	end
end

function PetScoreTip:SetData(monsterData)
	self.data = monsterData;
	self:initData()
	self:SetLockState();
	self:adjustPanelDepth(4)	
	self:UpdatePetSkill()
	self:UpdateAttriText();
end

function PetScoreTip:initData(  )
	-- body
	local sdata = self.data.staticData
	if(sdata)then		
		if(sdata.Nature)then
			local result = IconManager:SetUIIcon(sdata.Nature,self.MonstPro)
			if(not result)then
				self:Hide(self.MonstPro.gameObject)
			else
				self:Show(self.MonstPro.gameObject)
			end
		else
			self:Hide(self.MonstPro.gameObject)
		end

		if(sdata.Race)then
			local result = IconManager:SetUIIcon(sdata.Race,self.MonstRace)
			if(not result)then
				self:Hide(self.MonstRace.gameObject)
			else
				self:Show(self.MonstRace.gameObject)
			end
		else
			self:Hide(self.MonstRace.gameObject)
		end

		for k,v in pairs(Table_Pet_Capture) do
			if(v.PetID ==self.data.staticId and v.GiftItemID)then
				self:Show(self.chatacterBtn)
				return
			end
		end		
	end
	self:Hide(self.chatacterBtn)
end

function PetScoreTip:SetLockState()
	self.isUnlock = false;
	if(self.data)then
		self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
		local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data,true)
		self.lockTipLabel.text = unlockCondition

		local sdata = self.data and self.data.staticData;
		if(sdata)then
			self.monstername.text = sdata.NameZh;
		end
	end

	if(self.isUnlock)then
		self:Show(self.modelBottombg)
		self:Hide(self.BottomCt)

	else
		self:Show(self.BottomCt)
		self:Hide(self.modelBottombg)
	end

	-- self.lockBord.gameObject:SetActive(not self.isUnlock)
end

function PetScoreTip:Show3DModel()
	local data = self.data;
	local monsterData = data and data.staticData;
	if(monsterData)then
		self.model = UIModelUtil.Instance:SetMonsterModelTexture(self.modeltexture, monsterData.id);
		local showPos = monsterData.LoadShowPose;
		if(showPos and #showPos == 3)then
			tempVector3:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0);
			self.model:SetPosition(tempVector3);
		end

		self.model:SetEulerAngleY(monsterData.LoadShowRotate or 0);
		local size = monsterData.LoadShowSize or 1
		self.model:SetScale(size);
	end
	return false;
end

function PetScoreTip:UpdatePetSkill()
	local contextData = {};
	local data = self.data;
	local sdata = self.data.staticData;
	if(data and sdata)then
		local sdata = self.data.staticData;
		local petData = Table_Pet[sdata.id]
		if(petData)then
			local profession = Game.Myself.data:GetCurOcc().profession			
			local id = 1
			local idStr = string.format("Skill_%d",id)
			local skillTb = petData[idStr]
			local skillId = skillTb and skillTb[1] or nil
			while(skillTb and skillId)do				
				local data = {}
				data[1] = nil
				data[2] = skillId
				contextData[#contextData+1] = data
				id = id+1
				idStr = string.format("Skill_%d",id)
				skillTb = petData[idStr]

				skillId = skillTb and skillTb[1] or nil
			end
		end
	end
	self.gridList:ResetDatas(contextData);
end

function PetScoreTip:UpdateAttriText()
	local content = {};
	local data = self.data;
	local sdata = self.data.staticData;
	if(data and sdata)then
		local transform = self.gridList.layoutCtrl.transform
		local bound = NGUIMath.CalculateRelativeWidgetBounds(transform,false)
		local pos = transform.localPosition
		local y = pos.y - bound.size.y - 50
		if(bound.size.y == 0)then
			y = pos.y - bound.size.y
		end
		tempVector3:Set(0,y,0)
		self.attriCtl.layoutCtrl.transform.localPosition = tempVector3

		self:Show3DModel()
		local tipLabelCell = {}		
		local desc = sdata.Desc
		if(desc ~= "" and self.isUnlock)then
			tipLabelCell = {}
			tipLabelCell.label = {}
			tipLabelCell.hideline = true
			table.insert(tipLabelCell.label, desc)
			content[#content +1] = tipLabelCell
		end

		tipLabelCell = {}
		tipLabelCell.label = {}
		tipLabelCell.hideline = true
		if(not self.isUnlock)then
			desc = "[c][22222291]"..ZhString.MonsterTip_LockReward.."[-][/c]"
 		else
 			desc = "[c][FF622CFF]"..ZhString.MonsterTip_LockReward.."[-][/c]"
 		end
		
		table.insert(tipLabelCell.label, desc)
		local AdventureValue = sdata.AdventureValue or 0
		self.adventureValue.text = AdventureValue
		local unlockCondition = GameConfig.AdventureUnlockCodition[sdata.Condition] or ""
		local formatStr = ZhString.PetScoreTip_UnlockPet
		if(not self.isUnlock)then
			formatStr = "[c][22222291]"..formatStr.."[-][/c]"
		end
		desc = string.format(formatStr,unlockCondition,sdata.NameZh,AdventureValue)
		--[[ todo xde ???????????????????????????????????????xxx?????????
		if (sdata.Condition == 9) then
			desc = string.format(formatStr,sdata.NameZh,' '..unlockCondition,AdventureValue)
		end
		--]]
		table.insert(tipLabelCell.label, desc)
		content[#content +1] = tipLabelCell
	end
	self.attriCtl:ResetDatas(content);
end

function PetScoreTip:OnExit()
	self.attriCtl:ResetDatas()
	self.gridList:ResetDatas()
	PetScoreTip.super.OnExit(self);
	UIModelUtil.Instance:ResetTexture( self.modeltexture )
	Game.GOLuaPoolManager:AddToUIPool(self.resID,self.gameObject)
end