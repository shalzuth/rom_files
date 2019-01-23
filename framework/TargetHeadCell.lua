autoImport("PlayerFaceCell");
TargetHeadCell = class("TargetHeadCell", PlayerFaceCell)

TargetHeadEvent = {
	CancelChoose = "TargetHeadEvent_CancelChoose",	
}

MonsterTextColorConfig = {
	Level = {
		H = 15,
		L = 20,
	},
	Color = {
		H = Color(252/255,41/255,52/255),
		N = Color(1,1,1),
		L = Color(1,1,1),
	},
	EffectColor = {
		H = Color(94/255,0/255,8/255),
		N =Color(116/255,154/255,196/255),
		L = Color(116/255,154/255,196/255),
	},
}

function TargetHeadCell:Init()
	TargetHeadCell.super.Init(self);
	self.headIconCell:HideFrame();
	self.headBg = self:FindComponent("HeadBg", UISprite);

	self:SetData(nil);

	self:AddButtonEvent("CancelChoose", function (go)
		self:PassEvent(TargetHeadEvent.CancelChoose);
	end);
end

function TargetHeadCell:SetData(data)
	TargetHeadCell.super.SetData(self, data);

	if(data)then
		if(data.isMonster)then
			self:RefreshLevelColor();
		end
		
		if(data.camp == RoleDefines_Camp.ENEMY)then
			self.headBg.spriteName = "com_bg_head3";
		else
			self.headBg.spriteName = "com_bg_head2";
		end
	else
		self.headBg.spriteName = "com_bg_head2";
	end

	UIUtil.WrapLabel(self.name);
end

function TargetHeadCell:RefreshLevelColor()
	if(self.data and self.data.level and self.level)then
		local myself = Game.Myself;
		local mylv = myself.data.userdata:Get(UDEnum.ROLELEVEL);
		local deltalv = mylv - self.data.level;
		-- 低于角色等级20显示为灰
		if(deltalv>=MonsterTextColorConfig.Level.L)then
			self.level.color = MonsterTextColorConfig.Color.L;
			self.level.effectColor = MonsterTextColorConfig.EffectColor.L;
		-- 高于角色等级15显示为红色
		elseif(deltalv<=-1*MonsterTextColorConfig.Level.H)then
			self.level.color = MonsterTextColorConfig.Color.H;
			self.level.effectColor = MonsterTextColorConfig.EffectColor.H;
		else
			self.level.color = MonsterTextColorConfig.Color.N;
			self.level.effectColor = MonsterTextColorConfig.EffectColor.N;
		end
	end
end


