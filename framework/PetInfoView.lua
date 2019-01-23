PetInfoView = class("PetInfoView",BaseView)

PetInfoView.ViewType = UIViewType.NormalLayer

autoImport("PetResetSkillItemCell");
autoImport("PetInfoLabelCell");

PetInfoView.EventTip = {
	adventure = ZhString.PetInfoView_Unlock_Adventure,
	body = ZhString.PetInfoView_Unlock_Fashion,
	equip = ZhString.PetInfoView_Unlock_Equip,
} 

function PetInfoView:Init()
	self:InitView();
	self:MapEvent();
end

function PetInfoView:InitView()
	local headGO = self:FindGO("PlayerHeadCell");
	self.headIconCell = PlayerFaceCell.new(headGO);
	self.headData = HeadImageData.new();

	self.namelab = self:FindComponent("Name", UILabel);

	self.mood_symbol = self:FindComponent("Symbol", UISprite, self:FindGO("Mood"));
	self.friendly_valuelab = self:FindComponent("Value", UILabel, self:FindGO("Friendly"));
	self.level_valuelab = self:FindComponent("Value", UILabel, self:FindGO("Level"));
	self.friendly_slider = self:FindComponent("Friend_ExpSlider", UISlider);
	self.level_slider = self:FindComponent("Level_ExpSlider", UISlider);
	self.skillTipStick = self:FindComponent("SkillTipStick", UIWidget);

	local table = self:FindComponent("AttriTable", UITable);
	self.attriCtl = UIGridListCtrl.new(table , PetInfoLabelCell, "PetInfoLabelCell");
	self.attriCtl:AddEventListener(MouseEvent.MouseClick, self.ClickSkill, self);

	self.touchButton = self:FindGO("TouchButton");
	self:AddClickEvent(self.touchButton, function (go)
		self:DoTouch();
	end);

	self.giftButton = self:FindGO("GiftButton");
	self:AddClickEvent(self.giftButton, function (go)
		self:DoGift();
	end);

	self.giftSprite = self.giftButton:GetComponent(UISprite);
	self.gift_num = self:FindComponent("Num", UILabel, self.giftButton);

	self.playButton = self:FindGO("PlayButton");
	self.playButton_Symbol = self.playButton:GetComponent(UISprite);
	self.playButton_Collider = self.playButton:GetComponent(BoxCollider);
	self.playButton_Lock = self:FindGO("LockTip", self.playButton);
	self:AddClickEvent(self.playButton, function (go)
		self:DoPlay();
	end);

	self.restButton = self:FindGO("RestButton");
	self:AddClickEvent(self.restButton, function (go)
		self:DoRest();
	end);
	self.resetSkillButton = self:FindGO("RestSkillButton");
	self:AddClickEvent(self.resetSkillButton, function (go)
		self:DoResetSkill();
	end);

	self.changeNameButton = self:FindGO("ChangeNameButton");
	self:AddClickEvent(self.changeNameButton, function (go)
		self:DoChangeName();
	end);

	self.petEquip1 = self:FindGO("PetEquipItem1");
	self.petEquip1Cell = ItemCell.new(self.petEquip1);
	self.petEquip1_add = self:FindGO("Add", self.petEquip1);
	self.petEquip1_add_Symbol = self.petEquip1_add:GetComponent(UISprite);
	self.petEquip1_bg = self.petEquip1:GetComponent(UIWidget);
	self:AddClickEvent(self.petEquip1, function (go)
		self:DoAddPetEquipItem1();
	end);

	self.petBody = self:FindGO("PetBody");
	self.petBody_lock = self:FindGO("Lock", self.petBody);
	self.petBody_locktip = self:FindComponent("LockTip", UILabel, self.petBody_lock);
	self.petBody_Collider = self.petBody:GetComponent(BoxCollider);
	self.petBody_bg = self:FindComponent("Background", UISprite, self.petBody);
	self.petBody_Icon = self:FindComponent("Icon_Sprite", UISprite, self.petBody);
	self:AddClickEvent(self.petBody, function (go)
		self:DoAddPetBody();
	end);

	self.skillResetBord = self:FindGO("SkillResetBord");
	local resetSkillGrid = self:FindComponent("ResetSkillGrid", UIGrid);
	self.skillResetCtl = UIGridListCtrl.new(resetSkillGrid, PetResetSkillItemCell, "PetResetSkillItemCell");
	self.skillResetCtl:AddEventListener(MouseEvent.MouseClick, self.ClickResetSkillItem, self);

	self.closeComp = self.skillResetBord:GetComponent(CloseWhenClickOtherPlace);
	self.closeComp.callBack = function (go)
		self.skillResetBord_Show = false;
	end
	
	--todo xde 
	self.skillResetBord:GetComponent(UISprite).width = 380
	self.skillResetBord.transform.localPosition = Vector3(0,-228,0)
	local scroll = self:FindGO('ScrollView',self.skillResetBord):GetComponent(UIPanel)
	scroll.baseClipRegion = Vector4(0,0,320,252)

	----[[ todo xde 0002969: 新包 在英语环境下 孵化宠物溜溜猴 输入的名称是中文溜溜猴 但孵化出来的猴子名称还是显示Yoyo
	SkipTranslation(self.namelab)
	--]]
end

function PetInfoView:ClickSkill(skillCell)
	local skillData = skillCell.data;
	if(type(skillData) == "number")then
		TipManager.Instance:ShowPetSkillTip( SkillItemData.new(skillCell.data), self.skillTipStick, NGUIUtil.AnchorSide.TopLeft, {-185,0} )
	end
end

function PetInfoView:ClickResetSkillItem(cell)
	local data = cell.data;
	if(data ~= nil)then
		local itemName = data.staticData.NameZh;
		if(data.id == "Reset_Grey")then
			MsgManager.ShowMsgByIDTable(9012, {itemName});
		else
			local dont = LocalSaveProxy.Instance:GetDontShowAgain(9011)
			if(dont == nil)then
				MsgManager.DontAgainConfirmMsgByID(9011, function ()
					FunctionPet.Me():DoResetSkill(data.staticData.id);
				end, nil, nil, itemName);
			else
				FunctionPet.Me():DoResetSkill(data.staticData.id);
			end
		end
		self.skillResetBord:SetActive(false);
	end
end

local tempParam = {};
function PetInfoView:DoTouch()
	tempParam.petid = self.petInfoData.petid;
	FunctionPlayerTip.Pet_Touch(tempParam)
end

function PetInfoView:DoGift()
	tempParam.petid = self.petInfoData.petid;
	FunctionPlayerTip.Pet_GiveGift(tempParam)
end

function PetInfoView:DoPlay()
	if(self.ishand)then
		FunctionPlayerTip.Pet_CancelHug({petid = self.petInfoData.petid})
	else
		FunctionPlayerTip.Pet_Hug({petid = self.petInfoData.petid})
	end
end

function PetInfoView:DoRest()
	ServiceScenePetProxy.Instance:CallEggRestorePetCmd(self.petInfoData.petid);
	
	self:CloseSelf();
end

function PetInfoView:DoChangeName()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.PetMakeNamePopUp, viewdata = {etype = 2, petid = self.petInfoData.petid}})
end

function PetInfoView.SortResetSkillItems( a, b )
	if(a.id ~= b.id)then
		return a.id ~= "Reset_Grey";
	end
	return a.staticData.id < b.staticData.id;
end
function PetInfoView:DoResetSkill()
	if(self.petInfoData:IsSkillPerfect())then
		MsgManager.ShowMsgByIDTable(9010);
		return;
	end

	if(self.resetSkillItems == nil)then
		self.resetSkillItems = {};
	else
		TableUtility.ArrayClear(self.resetSkillItems)
	end

	local resetSkill_Config = GameConfig.Pet.reset_skill;
	for j=1,#resetSkill_Config do
		local itemid = resetSkill_Config[j];
		local item = BagProxy.Instance:GetItemByStaticID(itemid);
		if(item == nil)then
			local itemData = ItemData.new("Reset_Grey", itemid);
			itemData.num = 1;
			table.insert(self.resetSkillItems, itemData);
		else
			local itemData = ItemData.new(item.id, itemid);
			itemData.num = 1;
			table.insert(self.resetSkillItems, itemData);
		end
	end
	table.sort(self.resetSkillItems, PetInfoView.SortResetSkillItems);

	self.skillResetCtl:ResetDatas(self.resetSkillItems);
	
	self.skillResetBord:SetActive(true);
end

local petEquipsSort = function (a,b)
	if(a.id == "NoGet" or b.id == "NoGet")then
		return a.id ~= "NoGet";
	end
	return a.staticData.id < b.staticData.id;
end
function PetInfoView:DoAddPetEquipItem1()

	local equip1Data = self.petInfoData:GetEquips()[1];
	if(equip1Data)then
		local sdata = {
			itemdata = equip1Data, 
			ignoreBounds = {self.petEquip1_bg}
		};
		local itemFloatTip = self:ShowItemTip(sdata, self.petEquip1_bg, nil, {206, 208});
		local comcell = itemFloatTip:GetCell(1);
		comcell:AddTipFunc(ZhString.PetInfoView_Unlock_Unload, self.DoUnloadPetEquip, {self, equip1Data});
		comcell:HideGetPath();
		comcell:HidePreviewButton();
	else
		local equips = self:GetPetEquips(true);
		table.sort(equips, petEquipsSort);

		local equipChooseTip = TipManager.Instance:ShowEquipChooseTip(equips, self.petEquip1_bg, {84,281});
		equipChooseTip:SetClickEvent(self.ChoosePetEquip, self);
		equipChooseTip:Set_CheckValidFunc(self.CheckEquipValid, self);
		equipChooseTip:AddIgnoreBounds(self.petEquip1);
	end
end

function PetInfoView:GetPetEquips(createNoGet)
	local itemids = self.petInfoData:GetCanEquipItemIds();

	local equips = {};
	if(itemids)then
		for i=1,#itemids do
			local items = BagProxy.Instance:GetItemsByStaticID(itemids[i]);
			if(items)then
				for j=1,#items do
					table.insert(equips, items[j]);
				end
			else
				if(createNoGet)then
					local itemData = ItemData.new("NoGet", itemids[i]);
					table.insert(equips, itemData);
				end
			end
		end
	end
	return equips;
end

function PetInfoView.DoUnloadPetEquip(param)
	local self, itemdata = param[1], param[2]
	ServiceScenePetProxy.Instance:CallEquipOperPetCmd(ScenePet_pb.EPETEQUIPOPER_OFF, self.petInfoData.petid, itemdata.id);
	TipManager.Instance:CloseTip();
end

function PetInfoView:DoAddPetBody()
	local petid = self.petInfoData.petid;
	local nowbody = self.petInfoData.body;
	if(nowbody == self.petInfoData.petid)then
		nowbody = 0;
	end
	local nowfriendlv = self.petInfoData.friendlv;

	local bodyDatas = {};

	local defaultBodyData = {};
	defaultBodyData[1] = petid;
	defaultBodyData[2] = 0;
	defaultBodyData[3] = nowbody;
	defaultBodyData[4] = false;
	table.insert(bodyDatas, defaultBodyData);

	local showBodyIds = {};
	local bodyEvents = self.petInfoData:GetUnLockBodyEvents();
	if(bodyEvents)then
		for k,v in pairs(bodyEvents)do
			local alreadyIn = false;
			for i=1,#bodyDatas do
				if(bodyDatas[2] == v[2])then
					alreadyIn = true;
					break;
				end
			end
			if(not alreadyIn)then
				local bodyData = {};
				bodyData[1] = petid;
				bodyData[2] = v[2];
				bodyData[3] = nowbody;
				bodyData[4] = nowfriendlv < v[0];
				bodyData[5] = string.format(ZhString.PetInfoView_UnlockBody, v[0]);
				table.insert(bodyDatas, bodyData);
			end
		end
	end

	local bodys = self.petInfoData:GetUnLockBodys();
	if(bodys)then
		for i=1,#bodys do
			local alreadyIn = false;
			for k, data in pairs(bodyDatas)do
				if(data[2] == bodys[i])then
					alreadyIn = true;
					break;
				end
			end
			if(not alreadyIn)then
				local bodyData = {};
				bodyData[1] = petid;
				bodyData[2] = bodys[i];
				bodyData[3] = nowbody;
				bodyData[4] = false;
				table.insert(bodyDatas, bodyData);
			end
		end
	end

	if(#bodyDatas == 1)then
		local bodyData = {};
		bodyData[1] = 0;
		table.insert(bodyDatas, bodyData);
	end

	local fashionChooseTip = TipManager.Instance:ShowPetFashionChooseTip(bodyDatas, self.petBody_bg, NGUIUtil.AnchorSide.TopLeft, {215, 150});
	fashionChooseTip:SetClickEvent(self.ChoosePetBody, self);
	fashionChooseTip:AddIgnoreBounds(self.petBody);
end

function PetInfoView:CheckEquipValid(data)
	if(data)then
		if(self.petInfoData)then
			local isvalid, unlocklv = self.petInfoData:CheckEquipIsUnlock(data.staticData.id);
			if(not isvalid)then
				return false, string.format(ZhString.PetInfoView_EquipUnlockTip, unlocklv);
			end
		end
		if(data.id == "NoGet")then
			return false, ZhString.PetInfoView_NoGet;
		end

		local myPro = MyselfProxy.Instance:GetMyProfession();
		if(data.equipInfo and data.equipInfo:CanUseByProfess(myPro))then
			return true, ZhString.PetInfoView_AttriNoEffect;
		end
	end
	return true, ZhString.PetInfoView_CanEquip;
end

function PetInfoView:ChoosePetEquip(data)
	if(data)then
		ServiceScenePetProxy.Instance:CallEquipOperPetCmd(ScenePet_pb.EPETEQUIPOPER_ON, self.petInfoData.petid, data.id);
	end
	TipManager.Instance:CloseTip();
end

function PetInfoView:ChoosePetBody(data)
	local petid, bodyid = data[1], data[2];
	if(petid == 0)then
		return;
	end
	if(bodyid ~= self.petInfoData.body)then
		ServiceScenePetProxy.Instance:CallEquipOperPetCmd(ScenePet_pb.EPETEQUIPOPER_BODY, petid, tostring(bodyid));
		TipManager.Instance:CloseTip();
	end
end

local MoodSymbolMap = {
	[0] = "pet_icon_02",
	[1] = "pet_icon_01",
	[2] = "pet_icon_03",
	[3] = "pet_icon_04",
}
function PetInfoView:UpdatePetBriefInfo()
	if(self.petInfoData)then
		self.headData:TransByPetInfoData(self.petInfoData);
		self.headIconCell:SetData(self.headData);

		self.namelab.text = self.petInfoData.name;

		self.friendly_valuelab.text = "Lv " .. self.petInfoData.friendlv;
		self.level_valuelab.text = "Lv " .. self.petInfoData.lv;

		self.friendly_slider.value = self.petInfoData:GetMyPetFriendPct();

		local moodlevel = self.petInfoData:GetMoodLevel();
		self.mood_symbol.spriteName = MoodSymbolMap[moodlevel];

		local expslider_value = 0;
		local nowlvConfig = Table_PetBaseLevel[self.petInfoData.lv + 1];
		if(nowlvConfig)then
			self.level_slider.value = self.petInfoData.exp/nowlvConfig.NeedExp_2;
		else
			self.level_slider.value = 1;
		end
		self:UpdateHandSymbol();
		self:UpdateAtrtri();
	end
end

function PetInfoView:UpdateHandSymbol()
	local handFollowerId = Game.Myself:Client_GetHandInHandFollower();
	self.ishand = handFollowerId~=0 and handFollowerId == self.petInfoData.guid or false;
	local scenePet = PetProxy.Instance:GetMySceneNpet(petid)
	self.behold = scenePet and scenePet.data:GetFeature_BeHold() or false;

	if(self.ishand)then
		if(self.behold)then
			self.playButton_Symbol.spriteName = "pet_icon_putdown";
		else
			self.playButton_Symbol.spriteName = "pet_icon_hand2";
		end
	else
		if(self.behold)then
			self.playButton_Symbol.spriteName = "pet_icon_hug";
		else
			self.playButton_Symbol.spriteName = "pet_icon_hand";
		end
	end

	if(self.petInfoData:CanHug())then
		self.playButton_Collider.enabled = true;
		self.playButton_Lock:SetActive(false);
		self.playButton_Symbol.color = ColorUtil.NGUIWhite
	else		
		self.playButton_Collider.enabled = false;
		self.playButton_Lock:SetActive(true);
		self.playButton_Symbol.color = ColorUtil.NGUIShaderGray
	end
end

function PetInfoView:UpdatePetBody()
	local unlockBodys = self.petInfoData:GetUnLockBodys();
	-- if((unlockBodys and #unlockBodys>0))then
		self.petBody_lock:SetActive(false);

		self.petBody_Collider.enabled = true;
		self.petBody_bg.color = ColorUtil.NGUIWhite;
		self.petBody_Icon.color = ColorUtil.NGUIWhite;
	-- else
	-- 	self.petBody_lock:SetActive(true);

	-- 	self.petBody_Collider.enabled = false;
	-- 	self.petBody_bg.color = ColorUtil.NGUIShaderGray;
	-- 	self.petBody_Icon.color = ColorUtil.NGUIShaderGray;
	-- end

	self.petBody_Icon.gameObject:SetActive(true);
	IconManager:SetFaceIcon(self.petInfoData:GetHeadIcon(), self.petBody_Icon)
end

function PetInfoView:GetCurNpet()
	if(self.petInfoData == nil)then
		return;
	end

	return PetProxy.Instance:GetMySceneNpet(self.petInfoData.petid);
end

local PetShowAttris1 = {
	"Atk","MAtk",
	"Def","MDef",
}
local PetShowAttris2 = {
	"Str","Int",
	"Vit","Agi",
	"Dex","Luk",
}
function PetInfoView:UpdateAtrtri()
	local npet = self:GetCurNpet();
	if(npet == nil)then
		self:CloseSelf();
		return;
	end
	
	local attriDatas = {};
	local props = npet.data.props;
	if(props)then
		local hp = props.Hp:GetValue();
		local maxhp = props.MaxHp:GetValue();
		
		local hpdata = {}
		hpdata[1] = PetInfoLabelCell.Type.Attri;
		hpdata[2] = "Hp";
		hpdata[3] = hp .. "/" .. maxhp;
		table.insert(attriDatas, hpdata);

		for i=1,#PetShowAttris1 do
			local prop = props[ PetShowAttris1[i] ];
			if(prop)then
				local pdata = {};
				pdata[1] = PetInfoLabelCell.Type.Attri;
				pdata[2] = prop.propVO.displayName;
				pdata[3] = prop:GetValue();		
				table.insert(attriDatas, pdata);
			end
		end

		if(self.petInfoData.skills and #self.petInfoData.skills>0)then
			local skilldatas = {};
			skilldatas[1] = PetInfoLabelCell.Type.Skill;
			skilldatas[2] = self.petInfoData.skills;
			table.insert(attriDatas, skilldatas);
		end

		for i=1,#PetShowAttris2 do
			local prop = props[ PetShowAttris2[i] ];
			if(prop)then
				local pdata = {};
				pdata[1] = PetInfoLabelCell.Type.Attri;
				pdata[2] = prop.propVO.displayName;
				pdata[3] = prop:GetValue();		
				table.insert(attriDatas, pdata);
			end
		end

		local petFriendRatio = self.petInfoData:GetPetFriendRatio() or _EmptyTable;
	 	local friendlyEvents = self.petInfoData:GeMyPetFriendEvents();
	 	local lastRatioValue = nil;
		for i=1,10 do
			for k,v in pairs(friendlyEvents)do
		 		local level, eventkey = v[0],v[1];
		 		if(level == i)then
 			 		local eventtip = self.EventTip[ eventkey ];
 			 		local unlocktip = {};
 			 		unlocktip[1] = PetInfoLabelCell.Type.Attri;
 				 	unlocktip[2] = string.format(ZhString.PetInfoView_UnlockTip, level, eventtip)
					table.insert(attriDatas, unlocktip);
		 		end
			end
			if(petFriendRatio[i] ~= 0 and petFriendRatio[i]~=lastRatioValue)then
				lastRatioValue = petFriendRatio[i];
		 		local unlocktip = {};
		 		unlocktip[1] = PetInfoLabelCell.Type.Attri;
				unlocktip[2] = string.format(ZhString.PetInfoView_Unlock_PetWort_MulTime, i, math.floor(petFriendRatio[i]*100));
				table.insert(attriDatas, unlocktip);
			end
		end
	end
	self.attriCtl:ResetDatas(attriDatas);
end

function PetInfoView:UpdatePetEquips()
	local equips = self.petInfoData:GetEquips();
	self.petEquip1Cell:SetData(equips[1]);

	local petEquips = self:GetPetEquips();
	if(#petEquips > 0)then
		self.petEquip1_add_Symbol.color = ColorUtil.NGUIWhite;
	else
		self.petEquip1_add_Symbol.color = ColorUtil.NGUIShaderGray;
	end
end

function PetInfoView:UpdateGiftInfo()
	local giftItems = self.petInfoData:GetGiftItems();

	local itemid;
	if(giftItems)then
		_,itemid = next(giftItems);
	end
	
	self.gift_num.text = BagProxy.Instance:GetItemNumByStaticID(itemid) or 0;

	local icon = Table_Item[itemid] and Table_Item[itemid].Icon;
	if(icon)then
		IconManager:SetItemIcon(icon,self.giftSprite)
	end
end

function PetInfoView:UpdatePetTotalInfo()
	self:UpdatePetBriefInfo();
	self:UpdatePetBody();
	self:UpdatePetEquips();
	self:UpdateGiftInfo();
end

function PetInfoView:MapEvent()
	self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate);
	self:AddListenEvt(ServiceEvent.ScenePetEquipUpdatePetCmd, self.UpdatePetEquips);
	self:AddListenEvt(ServiceEvent.ScenePetPetInfoPetCmd, self.UpdatePetTotalInfo);
	self:AddListenEvt(ServiceEvent.ScenePetPetInfoUpdatePetCmd, self.UpdatePetTotalInfo);
	self:AddListenEvt(ServiceEvent.ScenePetUnlockNtfPetCmd, self.HandlePetUnlockNtfPetCmd);
	self:AddListenEvt(ServiceEvent.ScenePetPetOffPetCmd, self.HandleScenePetPetOff);

	self:AddListenEvt(ServiceEvent.ScenePetResetSkillPetCmd, self.HandleSkillReset);

	self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd,self.UpdateHandSymbol);
	self:AddDispatcherEvt(FunctionFollowCaptainEvent.StateChanged, self.UpdateHandSymbol);

	self:AddListenEvt(SceneUserEvent.SceneRemovePets, self.HandleSceneRemovePets);
end

function PetInfoView:HandleSceneRemovePets(note)
	if(self:GetCurNpet() == nil)then
		self:CloseSelf();
	end
end

function PetInfoView:HandleItemUpdate()
	self:UpdateGiftInfo();
	self:UpdatePetEquips();
end

function PetInfoView:HandleSkillReset(note)
	local cells = self.attriCtl:GetCells();
	if(cells)then
		for i=1,#cells do
			cells[i]:PlayResetEffect();
		end
	end
end

function PetInfoView:HandlePetUnlockNtfPetCmd(note)
	self:UpdatePetEquips();
	self:UpdatePetBody();
end

function PetInfoView:HandleScenePetPetOff(note)
	local petid = note.body.petid;
	if(petid and petid == self.petInfoData.petid)then
		self:CloseSelf();
	end
end

function PetInfoView:HandleSceneRemovePets(note)
	local petids = note.body;
	if(petids)then
		for i=1,#petids do
			if(petids[i] == self.petInfoData.guid)then
				self:CloseSelf();
				break;
			end
		end
	end
end

function PetInfoView:OnEnter()
	PetInfoView.super.OnEnter(self);

	self.petInfoData = self.viewdata.viewdata.petInfoData;
	if(self.petInfoData == nil)then
		return;
	end

	local npet = self:GetCurNpet();
	if(npet)then
		self:CameraFaceTo(npet.assetRole.completeTransform, CameraConfig.NPC_FuncPanel_ViewPort);
	end
	
	self:UpdatePetTotalInfo();

	FunctionPet.Me():SetCameraFoucus(false);

	EventManager.Me():AddEventListener(MyselfEvent.Pet_HpChange, self.UpdateAtrtri, self)
end

function PetInfoView:OnExit()
	EventManager.Me():RemoveEventListener(MyselfEvent.Pet_HpChange, self.UpdateAtrtri, self)

	PetInfoView.super.OnExit(self);

	TipManager.Instance:CloseTip();

	FunctionPet.Me():SetCameraFoucus(true);

	self:CameraReset();
end