local baseCell = autoImport("BaseCell")
AnnounceQuestPanelTeamMemberPortrail = class("AnnounceQuestPanelCell",baseCell)
function AnnounceQuestPanelTeamMemberPortrail:Init()
	self:initView()
end

function AnnounceQuestPanelTeamMemberPortrail:initView(  )
	-- body
	local teamHead = self:FindGO("TeamHead");
	self.teamHead = PlayerFaceCell.new(teamHead);
	self.teamHead:SetMinDepth(40);
	self.headData = HeadImageData.new();
	if(self.gameObject)then
		self.gameObject.transform.localScale = Vector3.one * 0.4
	end
	-- self.teamHead:SetHeadIconPos(false);
end

function AnnounceQuestPanelTeamMemberPortrail:SetData( data )
	-- body
	self.headData:Reset();
	self.headData:TransByTeamMemberData(data);
	self.teamHead:SetData(self.headData)
end