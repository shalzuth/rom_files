local BaseCell = autoImport("BaseCell");
GuildHeadCell = class("GuildHeadCell", BaseCell);


function GuildHeadCell:Init()
	self.bg = self:FindComponent("Bg", UISprite);
	self.icon = self:FindComponent("HeadIcon", UISprite);
	self.customPic = self:FindComponent("CustomPic", UITexture);
	self.choose = self:FindGO("ChooseSymbol");
	self.examineSymbol = self:FindGO("ExamineSymbol");
	if(self.examineSymbol)then
		self.examineSymbol_label = self:FindComponent("Label", UILabel, self.examineSymbol);
	end
	self.addSymbol = self:FindGO("AddSymbol");

	self:AddCellClickEvent();

	self:SetCallIndex();
end

function GuildHeadCell:DeleteGO(key)
	if(not Slua.IsNull(self[key]))then
		GameObject.DestroyImmediate(self[key].gameObject);
		self[key] = nil;
	end
end

function GuildHeadCell:SetCallIndex(call_index)
	self.call_index = call_index or UnionLogo.CallerIndex.LogoEditor;
end

function GuildHeadCell:SetData(data)
	self.data = data;
	if(data)then
		self.gameObject:SetActive(true);

		self.icon.gameObject:SetActive(data.type == GuildHeadData_Type.Config);
		self.customPic.gameObject:SetActive(data.type == GuildHeadData_Type.Custom);

		if(self.addSymbol)then
			self.addSymbol:SetActive(data.type == GuildHeadData_Type.Add);
		end

		if(self.examineSymbol)then
			if(data.type == GuildHeadData_Type.Custom)then
				if(data.state == GuildCmd_pb.EICON_INIT)then
					self.examineSymbol_label.text = ZhString.GuildHeadCell_Examine
				elseif(data.state == GuildCmd_pb.EICON_FORBID)then
					self.examineSymbol_label.text = ZhString.GuildHeadCell_Forbid
				end
				self.examineSymbol:SetActive(data.state ~= GuildCmd_pb.EICON_PASS);
			else
				self.examineSymbol:SetActive(false);
			end
		end

		if(data.type == GuildHeadData_Type.Config)then
			local sdata = data.staticData;
			if(sdata)then
				IconManager:SetGuildIcon(sdata.Icon, self.icon);
				self.icon.width = 32;
				self.icon.height = 32;
				-- self.icon:MakePixelPerfect();
			end
		elseif(data.type == GuildHeadData_Type.Custom)then
			if(self.customPic)then
				local pic = FunctionGuild.Me():GetCustomPicCache(data.guildid, data.index);
				if(pic)then
					local time_name = pic.name;
					if(tonumber(time_name) == data.time)then
						self.customPic.mainTexture = pic;
					else
						self:LoadSetCustomPic();
					end
				else
					self:LoadSetCustomPic();
				end
			end
		end

		if(self.choose)then
			if(self.chooseData and self.chooseData.type == data.type and self.chooseData.id == data.id)then
				self.choose:SetActive(true);
			else
				self.choose:SetActive(false);
			end
		end
	else
		self.gameObject:SetActive(false);
	end
end

function GuildHeadCell:LoadSetCustomPic()
	local data = self.data;
	if(data == nil or data.type ~= GuildHeadData_Type.Custom)then
		return;
	end

	local success_callback = function (bytes, localTimestamp)
		local pic = Texture2D(128, 128, TextureFormat.RGB24, false);
		pic.name = data.time;
		local bRet = ImageConversion.LoadImage(pic, bytes)

		FunctionGuild.Me():SetCustomPicCache(data.guildid, data.index, pic);

		if(self.data and self.data.index == data.index)then
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

function GuildHeadCell:SetChoose(chooseData)
	if(self.choose == nil)then
		return;
	end

	self.chooseData = chooseData;

	if(chooseData == nil)then
		self.choose:SetActive(false);
		return;
	end

	if(self.data and self.data.type == chooseData.type and self.data.id == chooseData.id)then
		self.choose:SetActive(true);
	else
		self.choose:SetActive(false);
	end
end