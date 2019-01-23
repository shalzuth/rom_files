local BaseCell = autoImport("BaseCell")
GVGResultViewItem = class("GVGResultViewItem", BaseCell);

function GVGResultViewItem:Init()
	self.headIcon = self:FindComponent("HeadIcon", UISprite)
	self.customPic = self:FindComponent("CustomPic", UITexture)
	self.guildName = self:FindComponent("guildName", UILabel)
	self.rankLabel = self:FindComponent("Rank", UILabel)
	self.chest = self:FindComponent("Background", UISprite)
	self:AddButtonEvent("RewardButton",function (  )
		-- body
		GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "RewardListView", rewardList = self.rewardList})
	end)
end

function GVGResultViewItem:SetData( rewardInfo )
	-- body
	local guildInfo = SuperGvgProxy.Instance:GetGuildInfoByGuildId(rewardInfo.guildid)
	self.guildName.text = "[" .. guildInfo.guildname .. "]"

	local guildHeadData = GuildHeadData.new()
	guildHeadData:SetBy_InfoId(guildInfo.icon)
	guildHeadData:SetGuildId(guildInfo.guildid)

	self.index = guildHeadData.index
	-- self.call_index = UnionLogo.CallerIndex.LogoEditor;

	if self.gameObject.name ~= 'GuildResultViewItem1' then
		if rewardInfo.rank == 2 then
			IconManager:SetItemIcon("item_3760", self.chest)
		elseif rewardInfo.rank == 3 then
			IconManager:SetItemIcon("item_3750", self.chest)
		elseif rewardInfo.rank == 4 then	
			IconManager:SetItemIcon("item_3740", self.chest)
		end
	end

	if self.rankLabel then
		self.rankLabel.text = rewardInfo.rank
	end

	self.rewardList = {}
	local rewardInfoItems = rewardInfo.items
	if(rewardInfoItems and #rewardInfoItems>0)then
		for i=1,#rewardInfoItems do
			local itemInfo = {}
			itemInfo.itemid = rewardInfoItems[i].itemid
			itemInfo.count = rewardInfoItems[i].count
			self.rewardList[i] = itemInfo
		end
	end

	if(guildHeadData.type == GuildHeadData_Type.Config) then
		local sdata = guildHeadData.staticData;
		if(sdata)then
			self.headIcon.gameObject:SetActive(true)
			self.customPic.gameObject:SetActive(false)
			IconManager:SetGuildIcon(sdata.Icon, self.headIcon);
			self.headIcon.width = 32;
			self.headIcon.height = 32;
			-- self.icon:MakePixelPerfect();
		end
	elseif(guildHeadData.type == GuildHeadData_Type.Custom) then
		if(self.customPic) then
			self.headIcon.gameObject:SetActive(false)
			self.customPic.gameObject:SetActive(true)
			local pic = FunctionGuild.Me():GetCustomPicCache(guildHeadData.guildid, guildHeadData.index);
			if(pic) then
				local time_name = pic.name;
				if(tonumber(time_name) == guildHeadData.time) then
					self.customPic.mainTexture = pic;
				else
					self:LoadSetCustomPic(guildHeadData, self.customPic);
				end
			else
				self:LoadSetCustomPic(guildHeadData, self.customPic);
			end
		end
	end
end

function GVGResultViewItem:LoadSetCustomPic(data)
	if(data == nil or data.type ~= GuildHeadData_Type.Custom)then
		return;
	end

	local success_callback = function (bytes, localTimestamp)
		local pic = Texture2D(128, 128, TextureFormat.RGB24, false);
		pic.name = data.time;
		local bRet = ImageConversion.LoadImage(pic, bytes)

		FunctionGuild.Me():SetCustomPicCache(data.guildid, data.index, pic);

		if(self.index == data.index)then
			if(self.customPic)then
				self.customPic.mainTexture = pic;
			end
		end
	end

	local pic_type = data.pic_type;
	if(pic_type == nil or pic_type == "")then
		pic_type = PhotoFileInfo.PictureFormat.JPG;
	end
	UnionLogo.Ins():SetUnionID(data.guildid);
	UnionLogo.Ins():GetOriginImage(1, 
					data.index, 
					data.time, 
					pic_type,
					nil, 
					success_callback, 
					error_callback, 
					is_keep_previous_callback, 
					is_through_personalphotocallback);
end

