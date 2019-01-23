PostView = class("MainView",ContainerView)

PostView.ViewType = UIViewType.NormalLayer

autoImport("PostCell");

function PostView:Init()
	self:InitUI();
	self:AddViewInterest();
	
	self:UpdatePost();
end

function PostView:OnEnter()
	PostView.super.OnEnter(self);

end

function PostView:InitUI()

	local contentContainer = self:FindGO("ContentContainer")
	local wrapConfig = {
		wrapObj = contentContainer, 
		pfbNum = 6, 
		cellName = "PostCell", 
		control = PostCell, 
		dir = 1,
	}
	self.wrapHelper = WrapCellHelper.new(wrapConfig)
	self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickPostCell, self)

	local tip = self:FindGO("Tip"):GetComponent(UILabel)
	tip.text = string.format(ZhString.Post_Tip , GameConfig.System.sysmail_overtime)
end

function PostView:ClickPostCell(cellCtl)
	
	if(cellCtl.data and cellCtl.data.id)then
		ServiceSessionMailProxy.Instance:CallGetMailAttach(cellCtl.data.id);
	else
		printRed("data cannot be null!!");
		-- -----------------------------Test---------------------------------------
		-- for i=1,#self.testRewards do
		-- 	if(cellCtl.data == self.testRewards[i])then
		-- 		table.remove(self.testRewards, i);
		-- 		break;
		-- 	end
		-- end
		-- self:UpdatePost();
		-- ------------------------------------------------------------------------
	end
end

function PostView:UpdatePost()
	printOrange("PostView:UpdatePost")
	local postDatas = PostProxy.Instance:GetPostList();
	if(#postDatas>0)then
		self.wrapHelper:UpdateInfo(postDatas)
	else
		self:CloseSelf();
	end
	-- -----------------------------Test---------------------------------------
	-- if(#postDatas==0)then
	-- 	if(not self.testRewards)then
	-- 		self.testRewards = {};
	-- 		for i=1,5 do
	-- 			local tempD = PostData.new();
	-- 			tempD:SetTestData();
	-- 			table.insert(self.testRewards, tempD);
	-- 		end
	-- 	end
	-- 	self.rewardCtl:ResetDatas(self.testRewards);
	-- end
	-- ------------------------------------------------------------------------
end

function PostView:AddViewInterest()
	self:AddListenEvt(ServiceEvent.SessionMailMailUpdate, self.UpdatePost);
	self:AddListenEvt(ServiceEvent.SessionMailQueryAllMail, self.UpdatePost);
end