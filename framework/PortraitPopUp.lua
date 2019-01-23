PortraitPopUp = class("PortraitPopUp", BaseView);

autoImport("PortraitCell");
autoImport("PlayerFaceCell");
autoImport("PortraitFrameCell");

PortraitPopUp.ViewType = UIViewType.PopUpLayer

function PortraitPopUp:Init()
	self:FindObjs();
	self:InitShow();
	self:RegistRedTip();
	-- self:MapViewEvents();
end

function PortraitPopUp:FindObjs()
	local manScroll = self:FindChild("ManScroll");
	local moreScroll = self:FindChild("MoreScroll");
	local frameScroll = self:FindChild("FrameScroll");
	self.mangrid = self:FindChild("Grid", manScroll):GetComponent(UIGrid);
	self.moregrid = self:FindChild("Grid", moreScroll):GetComponent(UIGrid);
	self.framegrid = self:FindChild("Grid", frameScroll):GetComponent(UIGrid);

	self.myPortraitCell = self:FindChild("HeadCell");

	self.tip = self:FindChild("PortraitTip");
	self.portraitChoose = self:FindChild("portraitChoose");
	self.frameChoose = self:FindChild("frameChoose");
end

function PortraitPopUp:RegistRedTip()
	local roleTog = self:FindGO("ManToggle");
	local moreTog = self:FindGO("MoreToggle");
	local frameTog = self:FindGO("FrameToggle");
	self:AddTabEvent(roleTog, function() self:UpdateRolePortrait() end);
	self:AddTabEvent(moreTog, function() self:UpdateMorePortrait() end);
	self:AddTabEvent(frameTog, function() self:UpdatePortraitFrame() end);
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ROLE_IMG, roleTog:GetComponentInChildren(UISprite), 50);
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MONSTER_IMG , moreTog:GetComponentInChildren(UISprite), 50);
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PHOTOFRAME , frameTog:GetComponentInChildren(UISprite), 50);
end

function PortraitPopUp:InitShow()
	self:UpdateHeadCell();
	self:UpdateRolePortrait();
end

function PortraitPopUp:SendSeeNew()
	if(self.lastSee)then
		RedTipProxy.Instance:SeenNew(self.lastSee);
	end
end

function PortraitPopUp:UpdateRolePortrait()
	self:SendSeeNew();

	local portraitData = MyselfProxy.Instance.portraitData;
	if(portraitData)then
		if(self.manPortraitlst == nil)then
			self.manPortraitlst = UIGridListCtrl.new(self.mangrid, PortraitCell, "PortraitCell");

			self.manPortraitlst:AddEventListener(MouseEvent.MouseClick,self.ClickManPortraitCell,self);
		end
		local manPortraitDatas = portraitData:GetOrderManPortraits(Game.Myself.data.userdata:Get(UDEnum.SEX));
		self.manPortraitlst:ResetDatas(manPortraitDatas);

		for k,v in pairs(self.manPortraitlst:GetCells()) do
			if(v.data and v.data.id ==  self.choosePortrait.id)then
				self.portraitChoose.transform:SetParent(v.gameObject.transform, false);
				self.portraitChoose:SetActive(true);
				break;
			end
		end
	end

	self.lastSee = SceneTip_pb.EREDSYS_ROLE_IMG;
end

function PortraitPopUp:UpdateMorePortrait()
	self:SendSeeNew();

	local portraitData = MyselfProxy.Instance.portraitData;
	if(portraitData)then
		if(self.morePortraitlst == nil)then
			self.morePortraitlst = UIGridListCtrl.new(self.moregrid, PortraitCell, "PortraitCell");

			self.morePortraitlst:AddEventListener(MouseEvent.MouseClick,self.ClickManPortraitCell,self);
		end
		local otherPortraitDatas = portraitData:GetOrderOtherPortraits()
		self.morePortraitlst:ResetDatas(otherPortraitDatas);

		for k,v in pairs(self.morePortraitlst:GetCells()) do
			if(v.data and v.data.id ==  self.choosePortrait.id)then
				self.portraitChoose.transform:SetParent(v.gameObject.transform, false);
				self.portraitChoose:SetActive(true);
				break;
			end
		end
	end

	self.lastSee = SceneTip_pb.EREDSYS_MONSTER_IMG;
end

function PortraitPopUp:InitChoosePortrait(cells)
	if(self.choosePortrait and not self.initChooseP)then
		self.initChooseP = true;
	end

	local isFindP = false;
	local manPortraitCells = self.manPortraitlst:GetCells();
	if(manPortraitCells == nil)then
		return;
	end
	for i = 1,#manPortraitCells do
		local v = manPortraitCells[i];
		if(v~=nil and v.data~=nil and v.data.id == self.choosePortrait.id)then
			self.portraitChoose.transform:SetParent(v.gameObject.transform, false);
			self.portraitChoose:SetActive(true);
			isFindP = true;
		end
	end
	if(not isFindP)then
		local morePortraitCells = self.morePortraitlst:GetCells();
		for i = 1,#morePortraitCells do
			local v = morePortraitCells[i];
			if(v~=nil and v.data.id == self.choosePortrait.id)then
				self.portraitChoose.transform:SetParent(v.gameObject.transform, false);
				self.portraitChoose:SetActive(true);
			end
		end
	end
end

function PortraitPopUp:UpdatePortraitFrame()
	self:SendSeeNew();

	local portraitData = MyselfProxy.Instance.portraitData;
	if(portraitData)then
		if(self.framePortraitlst == nil)then
			self.framePortraitlst = UIGridListCtrl.new(self.framegrid, PortraitFrameCell, "PortraitFrameCell");
			self.framePortraitlst:AddEventListener(MouseEvent.MouseClick,self.ClickFrameCell,self)
		end
		local frameDatas = portraitData:GetOrderFrames();
		self.framePortraitlst:ResetDatas(frameDatas);
	end
	if(self.chooseFrame)then
		local frameCells = self.framePortraitlst:GetCells();
		for i = 1,#frameCells do
			local v = frameCells[i];
			if(v.data and v.data.id == self.chooseFrame.id)then
				self.frameChoose.transform:SetParent(v.gameObject.transform, false);
				self.frameChoose:SetActive(true);
				break;
			end
		end
	end

	self.lastSee = SceneTip_pb.EREDSYS_PHOTOFRAME;
end

function PortraitPopUp:UpdateHeadCell(pData, fData)
	if(self.headcell == nil)then
		self.headcell = PlayerFaceCell.new(self.myPortraitCell);
	end

	self.choosePortrait = pData or MyselfProxy.Instance:GetMyPortrait();
	self.chooseFrame = fData or MyselfProxy.Instance:GetMyFrame();

	local data = {};
	if(self.choosePortrait~=nil)then
		local picData = Table_Item[self.choosePortrait.id];
		data.head = picData.Icon;
	end
	if(self.chooseFrame ~=nil)then
		local picData = Table_Item[self.chooseFrame.id];
		data.frame = picData.Icon;
	end
	data.profession = Game.Myself.data.userdata:Get(UDEnum.PROFESSION);
	self.headcell:SetData(data);
end

function PortraitPopUp:ClickManPortraitCell(body)
	local obj = body.obj;
	local data = body.data;
	if(data.Lock == 1)then
		self:ShowTip(data, obj.transform.position);
	else
		self.portraitChoose.transform:SetParent(obj.transform, false);
		self.portraitChoose:SetActive(true);
		self:UpdateHeadCell(data,self.chooseFrame);
	end
end

function PortraitPopUp:ClickFrameCell(body)
	local obj = body.obj;
	local data = body.data;
	if(data.Lock == 1)then
		self:ShowTip(data, obj.transform.position);
	else
		self.frameChoose.transform:SetParent(obj.transform, false);
		self.frameChoose:SetActive(true);
		self:UpdateHeadCell(self.choosePortrait, data);
	end
end

function PortraitPopUp:ShowTip(data, position)
	self.tip.transform.position = position;
	local lab = self:FindChild("Desc", self.tip):GetComponent(UILabel);
	lab.text = data.Text;
	self.tip:SetActive(true);
end

function PortraitPopUp:OnExit()
	-- 给服务器发送切换头像的消息
	if(self.choosePortrait~=nil)then
		local myPortrait = MyselfProxy.Instance:GetMyPortrait();
		if(myPortrait == nil or (myPortrait~=nil and myPortrait.id~=self.choosePortrait.id))then
			ServiceNUserProxy.Instance:CallUsePortrait(self.choosePortrait.id); 
		end
	end
	if(self.chooseFrame~=nil)then
		local myframe = MyselfProxy.Instance:GetMyFrame();
		if(myframe == nil or (myframe~=nil and myframe.id~=self.chooseFrame.id))then
			ServiceNUserProxy.Instance:CallUseFrame(self.chooseFrame.id); 
		end
	end
	self:SendSeeNew();
	self.super.OnExit(self);
end















