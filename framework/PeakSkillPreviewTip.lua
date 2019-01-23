autoImport("BaseTip");
PeakSkillPreviewTip = class("PeakSkillPreviewTip",BaseTip)

function PeakSkillPreviewTip:Init()
	self.calPropAffect = true
	self:FindObjs();
	self:InitList()

	self.closecomp = self.gameObject:GetComponent(CustomTouchUpCall);
	self.closecomp.call = function (go)
		self:CloseSelf();
	end
end

function PeakSkillPreviewTip:CloseSelf()
	TipsView.Me():HideCurrent();
end

function PeakSkillPreviewTip:SetCheckClick(func)
	if(self.closecomp) then
		self.closecomp.check = function ()
			return func~=nil and func() or false
		end
	end
end

function PeakSkillPreviewTip:GetCreature()
	return Game.Myself
end

function PeakSkillPreviewTip:AddToUpdateAnchors(uirect)
	if(self.anchors ==nil) then
		self.anchors = {}
	end
	self.anchors[#self.anchors+1] = uirect
end

function PeakSkillPreviewTip:UpdateAnchors()
	if(self.anchors) then
		for i=1,#self.anchors do
			self.anchors[i]:ResetAndUpdateAnchors()
		end
	end
end

function PeakSkillPreviewTip:FindObjs()
	self.centerBg = self:FindGO("CenterBg"):GetComponent(UIWidget)
	self.scrollView = self:FindGO("ScrollView"):GetComponent(UIPanel)
	self.scroll = self:FindGO("ScrollView"):GetComponent(UIScrollView)
	self.previewTable = self:FindGO("Labels"):GetComponent(UITable)
	self.icon = self:FindGO("SkillIcon"):GetComponent(UISprite)
	self.skillName = self:FindGO("SkillName"):GetComponent(UILabel)
	self.skillInfo = self:FindGO("SkillInfo"):GetComponent(UILabel)
	self.skillInfo.text = ZhString.PealSkillTip_Info
	self:AddToUpdateAnchors(self.centerBg)
	self:AddToUpdateAnchors(self.scrollView)
end

function PeakSkillPreviewTip:InitList()
	self.list = ListCtrl.new(self.previewTable,PeakSkillPreviewCell,"PeakSkillPreviewCell")
end

function PeakSkillPreviewTip:SetList(data)
	local datas = {}

	local d = data
	local count = 1
	while(d.NextBreakID and count<=50) do
		count = count + 1
		d = Table_Skill[d.NextBreakID]
		if(d and d.PeakLevel) then
			datas[#datas+1] = d
		end
	end

	self.list:ResetDatas(datas)
	self.scroll:ResetPosition()
end

function PeakSkillPreviewTip:SetData(data)
	local staticData = data.data.staticData
	IconManager:SetSkillIconByProfess(staticData.Icon, self.icon,MyselfProxy.Instance:GetMyProfessionType(),true)
	self.skillName.text= staticData.NameZh
	self:SetList(staticData)
end

function PeakSkillPreviewTip:OnExit()
	self.list:RemoveAll()
	return true;
end


PeakSkillPreviewCell = class("PeakSkillPreviewCell",SkillTip)

function PeakSkillPreviewCell:Init()
	self.calPropAffect = true
	self:FindObjs()
end

function PeakSkillPreviewCell:FindObjs()
	self.skillName = self.gameObject:GetComponent(UILabel)
	self.label = self:FindGO("PeakInfo"):GetComponent(UILabel)
end

local sb = LuaStringBuilder.new()
function PeakSkillPreviewCell:SetData(data)
	sb:Append(data.NameZh)
	sb:Append("  LV.")
	sb:Append(data.Level)
	self.skillName.text = sb:ToString()
	sb:Clear()

	local other = self:GetCD(data)
	if(other ~= nil and other ~= "") then
		sb:AppendLine(self:GetDesc(data))
		sb:AppendLine("")
	else
		sb:Append(self:GetDesc(data))
	end
	sb:Append(other)

	self.label.text = sb:ToString()
	sb:Clear()
end