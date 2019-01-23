CharactorTestDressPage = class("CharactorTestDressPage",SubView)

function CharactorTestDressPage:Init()
	self:FindObjs()
	self:InitData();
	self:TestChangeDress();
	self:AddListenerEvts()
	self:InitShow()
end

function CharactorTestDressPage:FindObjs()
end

function CharactorTestDressPage:AddListenerEvts()
	self:AddListenEvt(ServiceEvent.PlayerChangeDress,self.HandleChangeDress)
end

function CharactorTestDressPage:InitData()
	self.roleData = self.container:GetRoleData();
end

function CharactorTestDressPage:InitShow()
end

function CharactorTestDressPage:CreateRole(parent, data)
	local roleRQ = parent:GetComponent(RenderQByUI);
	local avatar = RoleAvatar();
	local agent = RoleUtil.UpdateRoleAvatar(avatar, data);
	roleRQ:AddChild(agent.gameObject);

	agent.transform.localScale = agent.transform.localScale * 150;
	agent.transform.localRotation = Quaternion.Euler(0,180,0);
	
	return avatar,agent;
end

-- 换装测试
-- 测试用 1:翅膀 2:身体 3:武器 4:头饰 5:头发
TestHZData = {
	-- male
	wing = {8001,8003},
	body = {5,7,9,3}, 
	weapon = {1001,7003},
	accessory = {0,9001,9004},
	hair = {2,3,6},

	femaleBody = {6,38},
	femalehair = {9,16},
}

function CharactorTestDressPage:TestChangeDress()
	self.nowIndexs = {
		wing = TableUtil:FindKeyByValue(TestHZData.wing,self.roleData.wing), 
		weapon = TableUtil:FindKeyByValue(TestHZData.weapon,self.roleData.rightWeapon),
		accessory = TableUtil:FindKeyByValue(TestHZData.accessory,self.roleData.accessory),

		body = TableUtil:FindKeyByValue(TestHZData.body,self.roleData.body), 
		femaleBody = TableUtil:FindKeyByValue(TestHZData.femaleBody,self.roleData.body),

		hair = TableUtil:FindKeyByValue(TestHZData.hair,self.roleData.hair),
		femalehair = TableUtil:FindKeyByValue(TestHZData.femalehair,self.roleData.hair),
	};


	self.roleRQ2 = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "roleContainer2"):GetComponent(RenderQByUI);
	self.hzRoleAvatar,self.hzRoleAgent = self:CreateRole(self.roleRQ2.gameObject ,self.roleData);
	-- 初始化数据

	self.container:AddButtonEvent("ChangeDress_wing",function(go)
		local wid = self:HZIndexAdd("wing");
		self:UpdateRoleShow(wid);
	end);
	self.container:AddButtonEvent("ChangeDress_body",function(go)
		local key = self.roleData.sex == 1 and "body" or "femaleBody";
		local bid = self:HZIndexAdd(key);
		self:UpdateRoleShow(nil,bid);
	end);
	self.container:AddButtonEvent("ChangeDress_weapon",function(go)
		local weapid = self:HZIndexAdd("weapon");
		self:UpdateRoleShow(nil,nil,weapid);
	end);
	self.container:AddButtonEvent("ChangeDress_accessory",function(go)
		local aid = self:HZIndexAdd("accessory");
		self:UpdateRoleShow(nil,nil,nil,aid);
	end);
	self.container:AddButtonEvent("ChangeDress_hair",function(go)
		local key = self.roleData.sex == 1 and "hair" or "femalehair";
		local hid = self:HZIndexAdd(key);
		self:UpdateRoleShow(nil,nil,nil,nil,hid);
	end);

	
end

function CharactorTestDressPage:HZIndexAdd(key)
	local index = self.nowIndexs[key] or 1;
	local ids = TestHZData[key];
	index = index + 1;
	index = index>#ids and index - #ids or index;
	self.nowIndexs[key] = index;
	return ids[index];
end

function CharactorTestDressPage:UpdateRoleShow(wingID,bodyID,weaponID,accessoryID,hairID)
	local roleData = {
		hair = hairID,
		body = bodyID,
		rightWeapon = weaponID,
		accessory = accessoryID,
		wing = wingID,
	}
	RoleUtil.UpdateRoleAvatar(self.hzRoleAvatar, roleData, self.hzRoleAgent);

	self.roleRQ2.excute = false;
end

function CharactorTestDressPage:OnExit()
	-- send msg..	charid, male, body, hair, rightHand, profession, accessory, wing
	-- 测试用 1:翅膀 2:身体 3:武器 4:头饰 5:头发
	local wing = TestHZData.wing[self.nowIndexs.wing];
	
	local bodyids = self.roleData.sex == 2 and TestHZData.femaleBody or TestHZData.body;
	local body = self.roleData.sex == 1 and bodyids[self.nowIndexs.body] or bodyids[self.nowIndexs.femaleBody];
	
	local weapon = TestHZData.weapon[self.nowIndexs.weapon];
	local accessory = TestHZData.accessory[self.nowIndexs.accessory];

	local hairids = self.roleData.sex == 2 and TestHZData.femalehair or TestHZData.hair;
	local hair = self.roleData.sex == 1 and hairids[self.nowIndexs.hair] or hairids[self.nowIndexs.femalehair];

	wing = wing or self.roleData.wing;
	body = body or self.roleData.body;
	accessory = accessory or self.roleData.accessory;
	hair = hair or self.roleData.hair;
	weapon = weapon or self.roleData.rightWeapon;

	ServicePlayerProxy.Instance:CallChangeDress(self.roleData.ID, self.roleData.sex, body, hair,  weapon, 1, accessory, wing);
end

function CharactorTestDressPage:HandleChangeDress(note)
	print("---------------------------服务器返回换装成功")
end