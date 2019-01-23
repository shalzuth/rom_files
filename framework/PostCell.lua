PostCell = class("PostCell", ItemCell);

function PostCell:Init()

	local cellContainer = self:FindGO("ItemContainer")
	if cellContainer then
		self.cellObj = self:LoadPreferb("cell/ItemCell", cellContainer)
		self.cellObj.transform.localPosition = Vector3.zero
	end

	PostCell.super.Init(self)

	self:InitCell()
end

function PostCell:InitCell()
	local confirmButton = self:FindGO("ConfirmButton");
	self:SetEvent(confirmButton, function ()
		self:PassEvent(MouseEvent.MouseClick, self);
	end);
	self.confirmLabel = self:FindGO("Label" , confirmButton):GetComponent(UILabel)

	self.moreButton = self:FindGO("MoreButton")

	-- local itemGrid = self:FindComponent("ItemGrid", UIGrid);
	-- self.itemCtl = UIGridListCtrl.new(itemGrid, ItemCell, "ItemCell");

	-- self.rewardSymbol = self:FindComponent("RewardSymbol", UISprite);
	self.postTip = self:FindComponent("PostTip", UILabel);
	self.postName = self:FindComponent("PostName", UILabel);

	-- local panel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	-- local scrollView = self:FindComponent("ScrollView", UIPanel);

	-- scrollView.gameObject:SetActive(false);
	-- scrollView.depth = panel.depth+1;
	-- scrollView.gameObject:SetActive(true);

	self.mail = self:FindGO("Mail")
	self.time = self:FindGO("Time"):GetComponent(UILabel)
end

function PostCell:SetData(data)
	self.gameObject:SetActive(data ~= nil)

	if(data)then
		self.postName.text = data.title;
		self.postTip.text = data.msg;
		-- icon不显示bug 临时处理
		-- self.itemCtl:RemoveAll();
		-- self.itemCtl:ResetDatas(data.postItems);

		local bWarp, strOut = self.postTip:Wrap(self.postTip.text, strOut, self.postTip.height)
		self.moreButton:SetActive(not bWarp)

		if #data.postItems > 0 then

			self.mail:SetActive(false)
			self.cellObj:SetActive(true)

			self.confirmLabel.text = ZhString.Post_Receive

			PostCell.super.SetData(self,data.postItems[1])
		else
			self.mail:SetActive(true)
			self.cellObj:SetActive(false)

			self.confirmLabel.text = ZhString.Post_Delete
		end

		-- if(data.mailid and Table_Mail[data.mailid])then
		-- 	local icon = Table_Mail[data.mailid].Icon;
		-- 	self:Log("Mail Icon", icon);
		-- 	if(type(icon) == "table")then
		-- 		local _,iconConfig = next(icon);
		-- 		if(iconConfig and iconConfig.itemicon)then
		-- 			IconManager:SetItemIcon(tostring(iconConfig.itemicon), self.rewardSymbol)
		-- 		end
		-- 	end
		-- end

		self.time.text = ClientTimeUtil.GetFormatDayTimeStr(data.time)
	end

	self.data = data;
end









