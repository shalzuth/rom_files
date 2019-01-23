GVGDetailViewItem = class("GVGDetailViewItem",BaseCell)

function GVGDetailViewItem:Init()
	self:GetGameObjects()
end

function GVGDetailViewItem:GetGameObjects()
	self.headIcon = self:FindComponent("guildSpriteIcon", UISprite)
	self.customPic = self:FindComponent("guildTexIcon", UITexture)
	self.professionIcon = self:FindComponent("Career", UISprite)
	self.dataLabel = {}
	for i=1,8 do
		self.dataLabel[i] = self:FindComponent("Data" .. i, UILabel)
	end
	self.maxStar = {}
	for i=2,8 do
		self.maxStar[i] = self:FindGO("IsTop" .. i)
	end
end

function GVGDetailViewItem:SetData(data)
	self.data = data.detailData
	self.call_index = call_index or UnionLogo.CallerIndex.LogoEditor;
	for i=1, 8 do
		self.dataLabel[i].text = data.detailData[i]
	end
	for i=2,8 do
		self.maxStar[i]:SetActive(false)
	end
	local config = Table_Class[data.detailData[9]]
	if config then
		IconManager:SetProfessionIcon(config.icon, self.professionIcon)
	end
	self:getGuildIcon(data.detailData[10])
end

function GVGDetailViewItem:ActiveMax( index )
	self.maxStar[index]:SetActive(true)
end

function GVGDetailViewItem:getGuildIcon(guildid)
	local guildInfo = SuperGvgProxy.Instance:GetGuildInfoByGuildId(guildid)

	if(guildInfo == nil) then
		return;
	end

	local guildHeadData = GuildHeadData.new()
	guildHeadData:SetBy_InfoId(guildInfo.icon)
	guildHeadData:SetGuildId(guildInfo.guildid)

	self.index = guildHeadData.index

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

function GVGDetailViewItem:LoadSetCustomPic(data)
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
	UnionLogo.Ins():GetOriginImage(self.call_index, 
					data.index, 
					data.time, 
					pic_type,
					nil, 
					success_callback, 
					error_callback, 
					is_keep_previous_callback, 
					is_through_personalphotocallback);
end
