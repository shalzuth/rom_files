local BaseCell = autoImport("BaseCell");
GuildMemberCell = class("GuildMemberCell", BaseCell);
-- autoImport("ItemCell")
local MAXARTIFACT = 6

function GuildMemberCell:Init()
	self.widget = self.gameObject:GetComponent(UIWidget);

	self.name = self:FindComponent("Name", UILabel);
	self.lv = self:FindComponent("Lv", UILabel);
	self.pro = self:FindComponent("Pro", UILabel);
	self.job = self:FindComponent("Job", UILabel);
	self.weekContri = self:FindComponent("WeekContri", UILabel);
	self.contribution = self:FindComponent("Contribution", UILabel);
	self.offlineTime = self:FindComponent("OffTime", UILabel);
	self.sex = self:FindComponent("Sex", UISprite);
	self.currentline = self:FindComponent("CurrentLine", UILabel);
	self.artifactPos = self:FindGO("ArtifactPos")
	self.Voice = self:FindGO("Voice")

	if GameConfig.SystemForbid.OpenVoiceRealtime then
		self.Voice.gameObject:SetActive(false)
	else
		self.Voice.gameObject:SetActive(true)
	end	
	self:AddCellClickEvent();

	--todo xde fix ui
	local label = self:FindComponent("Label",UILabel)
	label.pivot = UIWidget.Pivot.Left;
	label.transform.localPosition = Vector3(-55,10,0)
	OverseaHostHelper:FixLabelOverV1(label,2,0)
	OverseaHostHelper:FixAnchor(self.weekContri.leftAnchor,label.transform,1,10)

	self:FindGO("Sprite"):SetActive(false)

	local label1 = self:FindComponent("Label1",UILabel)
	label1.pivot = UIWidget.Pivot.Left;
	label1.transform.localPosition = Vector3(-55,-15,0)
	OverseaHostHelper:FixLabelOverV1(label1,2,0)
	OverseaHostHelper:FixAnchor(self.contribution.leftAnchor,label1.transform,1,10)
end


function GuildMemberCell:SetData(data)
	self.data = data;
	if(data)then
		self.gameObject:SetActive(true);
		-- helplog("-------> member charID: ",data.id);
		self.artiData = ArtifactProxy.Instance:GetMemberArti(data.id)
		if(self.artiData)then
			self:Show(self.artifactPos)
			self:SetMemberArtifact(self.artiData)
		else
			self:Hide(self.artifactPos)
		end
		self.name.text = data.name;
		----[[ todo xde 不翻译玩家名字
		self.name.text = AppendSpace2Str(data.name)
		--]]
		self.lv.text = data.baselevel;
		self.pro.text = data.profession and Table_Class[data.profession] and Table_Class[data.profession].NameZh;
		self.job.text = data:GetJobName();
		self.contribution.text = data.totalcontribution or 0;
		self.weekContri.text = data.weekcontribution;
		self.sex.spriteName = data:IsBoy() and "friend_icon_man" or "friend_icon_woman"
		
		self.widget.alpha = data:IsOffline() and 0.7 or 1;

		self:UpdateTimeSymbol();

		if GVoiceProxy.Instance:IsThisCharIdRealtimeVoiceAvailable(data.id) then
			self.Voice.gameObject:SetActive(true)
		else
			self.Voice.gameObject:SetActive(false)
		end	

		if GameConfig.SystemForbid.OpenVoiceRealtime then
			self.Voice.gameObject:SetActive(false)
		else
			self.Voice.gameObject:SetActive(true)
		end

	else
		self.gameObject:SetActive(false);
	end

	--todo xde fix ui
	local label = self:FindComponent("Label",UILabel)
	label.transform.localPosition = Vector3(-55,10,0)

	local label1 = self:FindComponent("Label1",UILabel)
	label1.transform.localPosition = Vector3(-55,-15,0)
end

local baseDepth = 9
function GuildMemberCell:SetMemberArtifact(artiData)
	-- helplog("#artiData : ",#artiData,"self.id: ",self.id)
	if(not self.artifacts)then
		self.artifacts = {};
		for i=1,MAXARTIFACT do
			self.artifacts[i] = self:FindComponent("arti"..i,UISprite);
		end
	end

	for i=1,MAXARTIFACT do
		if(self.artifacts[i] and #artiData>=i)then
			self:Show(self.artifacts[i].gameObject)
			if(artiData[i] and artiData[i].itemID)then
				local icon = artiData[i].itemStaticData and artiData[i].itemStaticData.Icon or ""
				IconManager:SetItemIcon(icon, self.artifacts[i]);
			end
		else
			self:Hide(self.artifacts[i].gameObject)
		end
	end
end


function GuildMemberCell:UpdateTimeSymbol()
	local data = self.data;

	self.offlineTime.text =  ClientTimeUtil.GetFormatOfflineTimeStr(data.offlinetime);
	if(not data:IsOffline() and data.zoneid ~= MyselfProxy.Instance:GetZoneId())then
		self.currentline.gameObject:SetActive(true);
		self.offlineTime.gameObject:SetActive(false);
		
		self.currentline.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid); -- ZhString.GuildMemberCell_line
	else
		self.offlineTime.gameObject:SetActive(true);
		self.currentline.gameObject:SetActive(false);
	end

end




