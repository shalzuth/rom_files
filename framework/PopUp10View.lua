autoImport("MenuUnLockCell")
autoImport("MenuMsgCell")
autoImport("SystemUnLockView")
PopUp10View = class("PopUp10View", SystemUnLockView);

PopUp10View.ViewType =  UIViewType.Popup10Layer;

PopUp10View.NUserNewMenu = "PopUp10View.NUserNewMenu"

PopUp10View.ItemCoinShowType = {
	Common = 1,
	Decompose = 2,
}

function PopUp10View:Init()
	self.data = self.viewdata.data;
	self:MapViewInterests()
	self:FindObjs();
	self:InitDatas()
	self:InitClickEvent();
end

function PopUp10View:MapViewInterests()
	self:AddListenEvt(PopUp10View.NUserNewMenu, self.HandleNewMenu);
	self:AddListenEvt(SystemMsgEvent.MenuMsg, self.HandleMenuMsg);
	self:AddListenEvt(SystemMsgEvent.MenuCoinPop, self.HandleMenuCoinPop);
	self:AddListenEvt(SystemMsgEvent.MenuItemPop, self.HandleMenuItemPop);
end

function PopUp10View:HandleMenuCoinPop( note )
	-- body
	printGreen("HandleMenuCoinPop")
	local data = note.body
	self:AddToWait({ Type = SystemUnLockView.TypeEnum.MenuCoinPop,class = CoinPopView ,data = data})
	self:TryShowCell();
end

function PopUp10View:HandleMenuItemPop( note )
	-- body
	printGreen("HandleMenuItemPop")
	local data = note.body
	self:AddToWait({ Type = SystemUnLockView.TypeEnum.MenuItemPop,class = ItemPopView ,data = data})
	self:TryShowCell();
end

function PopUp10View:HandleNewMenu(note)
	local list = note.body.list;
	self.animplay = note.body.animplay;
	self.unlocklist = self.unlocklist or {};
	local config
	for i=1,#list do
		local v = list[i];
		config = Table_Menu[v]
		if(config)then
			if(config.type == 3) then
				self:AddToWait({ Type = SystemUnLockView.TypeEnum.MenuMsg,id = v,class = MenuMsgCell ,data = nil})
			end
		else
			self:LogError("Can Not Find "..v.." in Table_Menu");
		end
		
	end
	self:TryShowCell();
end

function PopUp10View:HandleEnd(data)
	PopUp10View.super.HandleEnd(self,data)
	if(data.Type==SystemUnLockView.TypeEnum.MenuCoinPop or data.Type == SystemUnLockView.TypeEnum.MenuItemPop) then 
		self:_HandleFloatMsg(data)
	end
end

function PopUp10View:_HandleFloatMsg(data)
	local itemDatas = data.data
	if(itemDatas)then
		for i=1,#itemDatas do
			local single = itemDatas[i]
			local params = {}
			params[1] = single.staticData.id
			params[2] = single.staticData.id
			params[3] = single.num
			MsgManager.ShowMsgByIDTable(6, params,Game.Myself.data.id)
		end
	end
end