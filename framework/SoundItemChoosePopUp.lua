SoundItemChoosePopUp = class("SoundItemChoosePopUp", BaseView)

SoundItemChoosePopUp.ViewType = UIViewType.PopUpLayer

autoImport("SoundItemCell");

function SoundItemChoosePopUp:Init()
	self:InitUI();
	self:MapEvent();

	self.npc = self.viewdata.viewdata.npc;
end

function SoundItemChoosePopUp:InitUI()
	local grid = self:FindComponent("SoundListGrid", UIGrid);
	self.soundItemCtl = UIGridListCtrl.new(grid , SoundItemCell, "SoundItemCell");
	self.soundItemCtl:AddEventListener(SoundItemCellEvent.Play, self.ChoosePlay, self);
	self.soundItemCtl:AddEventListener(SoundItemCellEvent.Buy, self.ChooseBuy, self);

	self:UpdateSoundItems();
	
	--todo xde
	local label = self:FindGO("Label"):GetComponent(UILabel)
	local label1 = self:FindGO("Label (1)"):GetComponent(UILabel)
	local label2 = self:FindGO("Label (2)"):GetComponent(UILabel)
	OverseaHostHelper:FixLabelOverV1(label,3,140)
	OverseaHostHelper:FixLabelOverV1(label1,3,140)
	OverseaHostHelper:FixLabelOverV1(label2,3,140)
end

function SoundItemChoosePopUp:UpdateSoundItems()
	local soundItems = {};
	local bagProxy = BagProxy.Instance;
	for _,mdata in pairs(Table_MusicBox) do
		local item = BagProxy.Instance:GetItemByStaticID(mdata.id);
		if(not item)then
			item = ItemData.new("SoundItem", mdata.id);
		end
		table.insert(soundItems, item);
	end
	table.sort(soundItems, function (a,b)
		local hasA = a.id ~= "SoundItem";
		local hasB = b.id ~= "SoundItem";
		if(hasA~=hasB)then
			return hasA;
		end
		return a.staticData.id<b.staticData.id;
	end)
	self.soundItemCtl:ResetDatas(soundItems);
end


function SoundItemChoosePopUp:ChoosePlay(cellctl)
	if(cellctl.data)then
		local id = cellctl.data.staticData.id;
		local soundName = cellctl.data.staticData.NameZh;
		MsgManager.ConfirmMsgByID(821, function ()
			ServiceNUserProxy.Instance:CallDemandMusic(self.npc.data.id, id);
			AudioUtil.Play2DRandomSound(AudioMap.Maps.PlayMusic);
			self:CloseSelf();
		end, nil,nil, soundName);
	end
end

function SoundItemChoosePopUp:ChooseBuy(cellctl)
	if(cellctl.data)then
		-- ServiceSessionShopProxy.Instance:CallBuyShopItem(item.id,count)
		local sid = cellctl.data.staticData.id;
		local musicData = Table_MusicBox[sid];
		if(musicData)then
			if(musicData.SaleChannel == 1)then
				HappyShopProxy.Instance:BuyShopItem(shopID,count)
			elseif(musicData.SaleChannel == 2)then
				-- self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ShopMallMainView,
				-- 			viewdata = {searchId = sid}});
				FuncShortCutFunc.Me():CallByID(26);
				self:CloseSelf();
			elseif(musicData.SaleChannel == 3)then
				FuncShortCutFunc.Me():CallByID(26);
				self:CloseSelf();
			end
		end
	end
end

function SoundItemChoosePopUp:MapEvent()
	self:AddListenEvt(ItemEvent.ItemUpdate,self.UpdateSoundItems);
end


