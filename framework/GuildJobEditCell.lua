local BaseCell = autoImport("BaseCell");
GuildJobEditCell = class("GuildJobEditCell", BaseCell);

GuildJobEditCell.GuildNameChange = "GuildJobEditCell_GuildNameChange";

GuildJobEditEvent = {
	NameChange = "GuildJobEditCell_GuildNameChange",
	AuthorityChange = "GuildJobEditEvent_AuthorityChange",
	EditAuthorityChange = "GuildJobEditEvent_EditAuthorityChange",
}

GuildJobEditType = {
	GuildAuthorityMap.InviteJoin,
	GuildAuthorityMap.KickMember,
--	GuildAuthorityMap.EditPicture, --todo xde
}

function GuildJobEditCell:Init()
	self.input = self:FindComponent("Input", UIInput);
	self.input_boxcollider = self.input:GetComponent(BoxCollider);
	self.input_sp = self.input:GetComponent(UISprite);

	self.authInfoMap = {};
	for i=1,#GuildJobEditType do
		local authorityType = GuildJobEditType[i];

		local authInfo = {};
		authInfo.symbol = self:FindComponent("Auth_" .. authorityType, UISprite);
		authInfo.tog = self:FindComponent("Auth_Tog_" .. authorityType, UIToggle);
		authInfo.value = false;
		self.authInfoMap[authorityType] = authInfo;

		self:AddClickEvent(authInfo.tog.gameObject, function (go)
			local param = {};
			param[1] = self;
			param[2] = authorityType;
			param[3] = authInfo.tog.value;
			self:PassEvent(GuildJobEditEvent.AuthorityChange, param);
		end);
	end

	self.editAuthInfo = {};
	self.editAuthInfo.symbol = self:FindComponent("Auth_Edit", UISprite);
	self.editAuthInfo.tog = self:FindComponent("Auth_Tog_Edit", UIToggle);
	self.editAuthInfo.value = false;

	self:AddClickEvent(self.editAuthInfo.tog.gameObject, function (go)
		self:PassEvent(GuildJobEditEvent.EditAuthorityChange, {self, self.editAuthInfo.tog.value});
	end);

	EventDelegate.Set(self.input.onChange, function ()
		self:PassEvent(GuildJobEditEvent.NameChange, self);
	end);

	UIUtil.LimitInputCharacter(self.input, 5);
	
	--todo xde
	self.editAuthInfo.symbol.transform.localPosition = Vector3(238,0,0)
	self.editAuthInfo.tog.transform.localPosition = Vector3(238,0,0)
end

function GuildJobEditCell:SetData(data)
	self.data = data;
	if(data)then
		-- todo xde 翻译变更公会的职位名称
		data.name = OverSea.LangManager.Instance():GetLangByKey(data.name)
		self.input.value = data.name;
		local canEditName = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.SetJobname);
		self.input_boxcollider.enabled = canEditName;
		self.input_sp.enabled = canEditName;

		self:UpdateAuthoritys();
		self:UpdateEditSymbol();
	end
end

function GuildJobEditCell:UpdateAuthoritys()
	local guildProxy = GuildProxy.Instance;
	for authorityType, authInfo in pairs(self.authInfoMap)do
		local canedit = guildProxy:CanIEditAuthority(self.data.id, authorityType);
		local cando = guildProxy:CanJobDoAuthority(self.data.id, authorityType);
		authInfo.value = cando;
		if(canedit)then
			authInfo.tog.gameObject:SetActive(true);
			authInfo.symbol.gameObject:SetActive(false);

			authInfo.tog.value = cando;
		else
			authInfo.tog.gameObject:SetActive(false);
			authInfo.symbol.gameObject:SetActive(true);

			authInfo.symbol.spriteName = authInfo.value and "com_icon_check" or "com_icon_off";
			authInfo.symbol:MakePixelPerfect();
		end
	end
end

function GuildJobEditCell:UpdateEditSymbol()
	local authInfo = self.editAuthInfo;

	local isChairMan = GuildProxy.Instance:ImGuildChairman()
	if(isChairMan and self.data.id == GuildJobType.ViceChairman)then
		authInfo.tog.gameObject:SetActive(true);
		authInfo.symbol.gameObject:SetActive(false);

		authInfo.tog.value = self.data.editauth > 0;
	else
		authInfo.tog.gameObject:SetActive(false);
		authInfo.symbol.gameObject:SetActive(true);

		authInfo.symbol.spriteName = self.data.editauth > 0 and "com_icon_check" or "com_icon_off";
		authInfo.symbol:MakePixelPerfect();
	end
end
