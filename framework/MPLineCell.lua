local BaseCell = autoImport("BaseCell");
MPLineCell = class("MPLineCell", BaseCell)

--线的颜色247FC0FF
LineColor = Color(36/255,127/255,192/255,1)

function MPLineCell:Init()
	self.Root = self:FindGO("Root")
	self.Branch = self:FindGO("Branch")
	self.RootThree = self:FindGO("RootThree")
	self.Root_centershu = self:FindGO("centershu",self.Root)
	self.Root_leftshu = self:FindGO("leftshu",self.Root)
	self.Root_rightshu= self:FindGO("rightshu",self.Root)
	self.Root_rightheng = self:FindGO("rightheng",self.Root)
	self.Root_leftheng= self:FindGO("leftheng",self.Root)
	self.Root_centershu_UISprite = self.Root_centershu:GetComponent(UISprite)
	self.Root_leftshu_UISprite = self.Root_leftshu:GetComponent(UISprite)
	self.Root_rightshu_UISprite = self.Root_rightshu:GetComponent(UISprite)
	self.Root_rightheng_UISprite = self.Root_rightheng:GetComponent(UISprite)
	self.Root_leftheng_UISprite = self.Root_leftheng:GetComponent(UISprite)
	self.Branch_shu = self:FindGO("shu",self.Branch)
	self.Branch_shu_UISprite = self.Branch_shu:GetComponent(UISprite)
	self.RootThree_centerupshu = self:FindGO("centerupshu",self.RootThree)
	self.RootThree_leftshu = self:FindGO("leftshu",self.RootThree)
	self.RootThree_rightshu = self:FindGO("rightshu",self.RootThree)
	self.RootThree_leftheng = self:FindGO("leftheng",self.RootThree)
	self.RootThree_centerdownshu = self:FindGO("centerdownshu",self.RootThree)
	self.RootThree_rightheng = self:FindGO("rightheng",self.RootThree)
	self.RootThree_centerupshu_UISprite = self:FindGO("centerupshu",self.RootThree):GetComponent(UISprite)
	self.RootThree_leftshu_UISprite = self:FindGO("leftshu",self.RootThree):GetComponent(UISprite)
	self.RootThree_rightshu_UISprite = self:FindGO("rightshu",self.RootThree):GetComponent(UISprite)
	self.RootThree_leftheng_UISprite = self:FindGO("leftheng",self.RootThree):GetComponent(UISprite)
	self.RootThree_centerdownshu_UISprite = self:FindGO("centerdownshu",self.RootThree):GetComponent(UISprite)
	self.RootThree_rightheng_UISprite = self:FindGO("rightheng",self.RootThree):GetComponent(UISprite)

	self.CRoot = self:FindGO("CRootXiuZheng")

	local size = UIManagerProxy.Instance.rootSize;
	self.CRoot.gameObject.transform.localScale = Vector3(size[1]/1280,1,1)

	self.CRoot_right1s = self:FindGO("right1s",self.CRoot)
	self.CRoot_left1s = self:FindGO("left1s",self.CRoot)
	self.CRoot_left3h = self:FindGO("left3h",self.CRoot)
	self.CRoot_left1h = self:FindGO("left1h",self.CRoot)
	self.CRoot_left2h= self:FindGO("left2h",self.CRoot)
	self.CRoot_right1h = self:FindGO("right1h",self.CRoot)
	self.CRoot_right2h = self:FindGO("right2h",self.CRoot)
	self.CRoot_right3h = self:FindGO("right3h",self.CRoot)
	self.CRoot_left2s = self:FindGO("left2s",self.CRoot)
	self.CRoot_left3s = self:FindGO("left3s",self.CRoot)
	self.CRoot_right2s = self:FindGO("right2s",self.CRoot)
	self.CRoot_right3s = self:FindGO("right3s",self.CRoot)
	self.CRoot_centers = self:FindGO("centers",self.CRoot)

	self.CRoot_right1s_UISprite = self.CRoot_right1s:GetComponent(UISprite)
	self.CRoot_left1s_UISprite = self.CRoot_left1s:GetComponent(UISprite)
	self.CRoot_left3h_UISprite = self.CRoot_left3h:GetComponent(UISprite)
	self.CRoot_left1h_UISprite = self.CRoot_left1h:GetComponent(UISprite)
	self.CRoot_left2h_UISprite= self.CRoot_left2h:GetComponent(UISprite)
	self.CRoot_right1h_UISprite = self.CRoot_right1h:GetComponent(UISprite)
	self.CRoot_right2h_UISprite = self.CRoot_right2h:GetComponent(UISprite)
	self.CRoot_right3h_UISprite = self.CRoot_right3h:GetComponent(UISprite)
	self.CRoot_left2s_UISprite = self.CRoot_left2s:GetComponent(UISprite)
	self.CRoot_left3s_UISprite = self.CRoot_left3s:GetComponent(UISprite)
	self.CRoot_right2s_UISprite = self.CRoot_right2s:GetComponent(UISprite)
	self.CRoot_right3s_UISprite = self.CRoot_right3s:GetComponent(UISprite)
	self.CRoot_centers_UISprite = self.CRoot_centers:GetComponent(UISprite)

	self.CRootTwo = self:FindGO("CRootTwoXiuZheng")

	self.CRootTwo_centershu = self:FindGO("centershu",self.CRootTwo)
	self.CRootTwo_leftshu = self:FindGO("leftshu",self.CRootTwo)
	self.CRootTwo_rightshu= self:FindGO("rightshu",self.CRootTwo)
	self.CRootTwo_rightheng = self:FindGO("rightheng",self.CRootTwo)
	self.CRootTwo_leftheng= self:FindGO("leftheng",self.CRootTwo)

	self.CRootTwo_centershu_UISprite = self.CRootTwo_centershu:GetComponent(UISprite)
	self.CRootTwo_leftshu_UISprite = self.CRootTwo_leftshu:GetComponent(UISprite)
	self.CRootTwo_rightshu_UISprite = self.CRootTwo_rightshu:GetComponent(UISprite)
	self.CRootTwo_rightheng_UISprite = self.CRootTwo_rightheng:GetComponent(UISprite)
	self.CRootTwo_leftheng_UISprite = self.CRootTwo_leftheng:GetComponent(UISprite)

	self.CRootThree = self:FindGO("CRootThree")

	self.CRootThree_centerupshu = self:FindGO("centerupshu",self.CRootThree)
	self.CRootThree_leftshu = self:FindGO("leftshu",self.CRootThree)
	self.CRootThree_rightshu = self:FindGO("rightshu",self.CRootThree)
	self.CRootThree_leftheng = self:FindGO("leftheng",self.CRootThree)
	self.CRootThree_centerdownshu = self:FindGO("centerdownshu",self.CRootThree)
	self.CRootThree_rightheng = self:FindGO("rightheng",self.CRootThree)
	self.CRootThree_centerupshu_UISprite = self:FindGO("centerupshu",self.CRootThree):GetComponent(UISprite)
	self.CRootThree_leftshu_UISprite = self:FindGO("leftshu",self.CRootThree):GetComponent(UISprite)
	self.CRootThree_rightshu_UISprite = self:FindGO("rightshu",self.CRootThree):GetComponent(UISprite)
	self.CRootThree_leftheng_UISprite = self:FindGO("leftheng",self.CRootThree):GetComponent(UISprite)
	self.CRootThree_centerdownshu_UISprite = self:FindGO("centerdownshu",self.CRootThree):GetComponent(UISprite)
	self.CRootThree_rightheng_UISprite = self:FindGO("rightheng",self.CRootThree):GetComponent(UISprite)

	self.blueColor = LineColor
	self.greyColor = ColorUtil.NGUIGray

	self:ShowLine(0)
end

function MPLineCell:ShowLine(state)

	self.gameObject.transform.localScale = Vector3(1,1,1)
	self.Root.gameObject:SetActive(1==state)
	self.Branch.gameObject:SetActive(2==state)
	self.RootThree.gameObject:SetActive(3==state)

	self.CRoot.gameObject:SetActive(4==state)
	self.CRootTwo.gameObject:SetActive(5==state)
	self.CRootThree.gameObject:SetActive(6==state)
end

function MPLineCell:CRootSetState(p1,p2,p3,p4,p5,p6)
	if p1 or p2 or p3 or p4 or p5 or p6 then
		self.CRoot_centers_UISprite.color = self.blueColor
	else
		self.CRoot_centers_UISprite.color = self.greyColor
	end	

	if p1 or p2 or p3 then
		self.CRoot_left3h_UISprite.color = self.blueColor
	else
		self.CRoot_left3h_UISprite.color = self.greyColor
	end	

	if p1 or p2 then
		self.CRoot_left2h_UISprite.color = self.blueColor
	else
		self.CRoot_left2h_UISprite.color = self.greyColor
	end	

	if p4 or p5 or p6 then
		self.CRoot_right1h_UISprite.color = self.blueColor
	else
		self.CRoot_right1h_UISprite.color = self.greyColor
	end	

	if p5 or p6 then
		self.CRoot_right2h_UISprite.color = self.blueColor
	else
		self.CRoot_right2h_UISprite.color = self.greyColor
	end	


	if p1 then
		self.CRoot_left1s_UISprite.color = self.blueColor
		self.CRoot_left1h_UISprite.color = self.blueColor
	else
		self.CRoot_left1s_UISprite.color = self.greyColor
		self.CRoot_left1h_UISprite.color = self.greyColor
	end	

	if p2 then
		self.CRoot_left2s_UISprite.color = self.blueColor
	else
		self.CRoot_left2s_UISprite.color = self.greyColor
	end	

	if p3 then
		self.CRoot_left3s_UISprite.color = self.blueColor
	else
		self.CRoot_left3s_UISprite.color = self.greyColor
	end	

	if p4 then
		self.CRoot_right1s_UISprite.color = self.blueColor
	else
		self.CRoot_right1s_UISprite.color = self.greyColor
	end	

	if p5 then
		self.CRoot_right2s_UISprite.color = self.blueColor
	else
		self.CRoot_right2s_UISprite.color = self.greyColor
	end	

	if p6 then
		self.CRoot_right3s_UISprite.color = self.blueColor
		self.CRoot_right3h_UISprite.color = self.blueColor
	else
		self.CRoot_right3s_UISprite.color = self.greyColor
		self.CRoot_right3h_UISprite.color = self.greyColor
	end	
end

function MPLineCell:CRootTwoSetState(left,right)
	if left or right then
		self.CRootTwo_centershu_UISprite.color = self.blueColor
	else
		self.CRootTwo_centershu_UISprite.color = self.greyColor
	end	

	if left then
		self.CRootTwo_leftshu_UISprite.color = self.blueColor
		self.CRootTwo_leftheng_UISprite.color = self.blueColor
	else
		self.CRootTwo_leftshu_UISprite.color =self.greyColor
		self.CRootTwo_leftheng_UISprite.color = self.greyColor
	end	

	if right then
		self.CRootTwo_rightshu_UISprite.color = self.blueColor
		self.CRootTwo_rightheng_UISprite.color = self.blueColor
	else
		self.CRootTwo_rightshu_UISprite.color = self.greyColor
		self.CRootTwo_rightheng_UISprite.color =self.greyColor
	end	
end	

function MPLineCell:CRootThreeSetState(left,center,right)
	if left or center or right then
		self.CRootThree_centerupshu_UISprite.color = self.blueColor
	else
		self.CRootThree_centerupshu_UISprite.color = self.greyColor
	end	

	if left then
		self.CRootThree_leftshu_UISprite.color = self.blueColor
		self.CRootThree_leftheng_UISprite.color =self.blueColor
	else
		self.CRootThree_leftshu_UISprite.color =  self.greyColor
		self.CRootThree_leftheng_UISprite.color =  self.greyColor
	end	

	if center then
		self.CRootThree_centerdownshu_UISprite.color = self.blueColor
	else
		self.CRootThree_centerdownshu_UISprite.color =self.greyColor
	end	

	if right then
		self.CRootThree_rightshu_UISprite.color = self.blueColor
		self.CRootThree_rightheng_UISprite.color = self.blueColor
	else
		self.CRootThree_rightshu_UISprite.color =  self.greyColor
		self.CRootThree_rightheng_UISprite.color =  self.greyColor
	end	
end	

function MPLineCell:RootSetState(left,right)

	if left or right then
		self.Root_centershu_UISprite.color = self.blueColor
	else
		self.Root_centershu_UISprite.color = self.greyColor
	end	

	if left then
		self.Root_leftshu_UISprite.color = self.blueColor
		self.Root_leftheng_UISprite.color = self.blueColor
	else
		self.Root_leftshu_UISprite.color =self.greyColor
		self.Root_leftheng_UISprite.color = self.greyColor
	end	

	if right then
		self.Root_rightshu_UISprite.color = self.blueColor
		self.Root_rightheng_UISprite.color = self.blueColor
	else
		self.Root_rightshu_UISprite.color = self.greyColor
		self.Root_rightheng_UISprite.color =self.greyColor
	end	
end

function MPLineCell:BranchSetState(center)
	if center then
		self.Branch_shu_UISprite.color =self.blueColor
	else
		self.Branch_shu_UISprite.color = self.greyColor
	end	
end

function MPLineCell:RootThreeSetState(left,center,right)
	
	if left or center or right then
		self.RootThree_centerupshu_UISprite.color = self.blueColor
	else
		self.RootThree_centerupshu_UISprite.color = self.greyColor
	end	

	if left then
		self.RootThree_leftshu_UISprite.color = self.blueColor
		self.RootThree_leftheng_UISprite.color =self.blueColor
	else
		self.RootThree_leftshu_UISprite.color =  self.greyColor
		self.RootThree_leftheng_UISprite.color =  self.greyColor
	end	

	if center then
		self.RootThree_centerdownshu_UISprite.color = self.blueColor
	else
		self.RootThree_centerdownshu_UISprite.color =self.greyColor
	end	

	if right then
		self.RootThree_rightshu_UISprite.color = self.blueColor
		self.RootThree_rightheng_UISprite.color = self.blueColor
	else
		self.RootThree_rightshu_UISprite.color =  self.greyColor
		self.RootThree_rightheng_UISprite.color =  self.greyColor
	end	
end

function MPLineCell:SetId(id)
	self.id = id
end

function MPLineCell:SetPreviousId(id)
	self.previousid = id
end

function MPLineCell:GetId()
	return self.id or 0
end

function MPLineCell:GetPreviousId()
	return self.previousid or 0
end
