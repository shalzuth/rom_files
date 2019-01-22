local BaseCell = autoImport("BaseCell");
MainViewButtonCell = class("MainViewButtonCell", BaseCell);

MainViewButtonType = {
	Menu = 1,
	Activity = 2,
	Auction = 3,
}

MainViewButtonEvent = {
	Exit = 'MainViewButtonEvent_Exit',
	ResetPosition = "MainViewButtonEvent_ResetPosition",
}

PlatformHideMap = {
	[1] = RuntimePlatform.IPhonePlayer,
	[2] = RuntimePlatform.Android,
}

function MainViewButtonCell:Init()
	self:InitUI();	
end

function MainViewButtonCell:InitUI()
	self.sprite = self:FindComponent("Sprite", UISprite);
	self.label = self:FindComponent("Label", UILabel);
	--todo xde
	OverseaHostHelper:FixLabelOverV1(self.label,3,120)
	self:AddCellClickEvent();
end

function MainViewButtonCell:SetData(data)
	self.data = data;

	local sData = self.data.staticData;
	if(data.type == MainViewButtonType.Menu)then
		if(sData.name == "GM")then
			self.gameObject:SetActive(false);
			return;
		end
		self.label.text = sData.name;
		IconManager:SetUIIcon( sData.icon or "", self.sprite )

		----[[ todo xde ?????? facebook ??????
		local result = IconManager:SetUIIcon( sData.icon or "", self.sprite )
		local sName = tostring(sData.icon);
		if result == false then
			helplog("?????? icon ??????????????????????????????????????? sprite", sName, self.sprite.atlas)
			local atlas = self.sprite.atlas
			self.sprite.atlas = nil
			self.sprite.atlas = atlas
			self.sprite.spriteName = sName
			local spriteData = self.sprite.atlas:GetSprite(sName)
			if spriteData ~= nil then
				self.sprite.width = spriteData.width
				self.sprite.height = spriteData.height
			else
				redlog("?????? icon ??????????????????????????????????????????????????? sprite", sName, self.sprite.atlas)
			end
		else
			-- helplog('?????? icon ??????', sName)
		end
		--]]


		self.sprite:MakePixelPerfect();

		local platHide = false;
		local nowPlatform = ApplicationInfo.GetRunPlatform();
		if(type(sData.Enterhide) == "table")then
			for i=1,#sData.Enterhide do
				local platformType = sData.Enterhide[i]
				if(platformType == 0 or nowPlatform == PlatformHideMap[platformType])then
					platHide = true;
					break;
				end
			end
		end
		if(platHide)then
			self.gameObject:SetActive( false );
			return;
		end

		self.gameObject:SetActive( not self:CheckIosBranchHide() );

		-- local branchHide = false;

		-- if(nowPlatform == RuntimePlatform.Android)then
		-- 	if(BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V3))then
		-- 		self.gameObject:SetActive( false );
		-- 		MsgManager.ShowMsgByIDTable(8192);
		-- 		return;
		-- 	end
		-- end
	elseif(data.type == MainViewButtonType.Activity)then
		self.label.text = sData.Name;
		IconManager:SetUIIcon( sData.Icon or "", self.sprite )
		self.sprite:MakePixelPerfect();

		self:UpdateActivityState();
	elseif data.type == MainViewButtonType.Auction then
		self.label.text = data.Name
		IconManager:SetUIIcon( data.Icon or "", self.sprite )
		self.sprite:MakePixelPerfect()
	end
end

local EnvChannelIndex = {
	-- todo xde for run
--	[EnvChannel.ChannelConfig.Develop.Name] = 1,
--	[EnvChannel.ChannelConfig.Alpha.Name] = 2,
--	[EnvChannel.ChannelConfig.Studio.Name] = 4,
--	[EnvChannel.ChannelConfig.Gravity.Name] = 8,
--	[EnvChannel.ChannelConfig.UWA.Name] = 16,
	[EnvChannel.ChannelConfig.Release.Name] = 32,
	[EnvChannel.ChannelConfig.Oversea.Name] = 32, --todo xde
}
function MainViewButtonCell:CheckIosBranchHide()
--	local nowPlatform = ApplicationInfo.GetRunPlatform();
--	if(nowPlatform ~= RuntimePlatform.IPhonePlayer)then
--		return false;
--	end
--
--	local channelName = EnvChannel.Channel.Name;
--	local branchHide = self.data.staticData.BranchHide;
--	if(branchHide == nil)then
--		return false;
--	end
--	local index = EnvChannelIndex[channelName];
--	return branchHide and index > 0
    return false
end

function MainViewButtonCell:UpdateActivityState()
	local aType = self.data and self.data.staticData.id;
	if(aType)then
		local aData = FunctionActivity.Me():GetActivityData( aType );
		if(aData and aData.running)then
			self.gameObject:SetActive(true);
		else
			self.gameObject:SetActive(false);
		end
	else
		self.gameObject:SetActive(false);
	end
end

function MainViewButtonCell:UpdateAuction(totalSec, hour, min, sec)
	if self.data then 
		if totalSec ~= nil and hour ~= nil then
			if hour >= 24 then
				self.label.text = string.format(ZhString.Auction_CountdownDayName, hour / 24)
			else
				self.label.text = string.format(self.data.Name, hour, min, sec)
			end
		end
	end
end