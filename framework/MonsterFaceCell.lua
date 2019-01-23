autoImport("PlayerFaceCell");
MonsterFaceCell = class("PlayerFaceCell", PlayerFaceCell)

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

function MonsterFaceCell:Init()
	MonsterFaceCell.super.Init(self);
end

 -- {head, level, profession, vip, hp, name, frame, leader}
function MonsterFaceCell:SetData(data)
	self.data = data;
	MonsterFaceCell.super.SetData(self, data);

	if(not self.headIcon.gameObject.activeSelf)then
		self.headIcon.gameObject:SetActive(true);
		IconManager:SetFaceIcon(Table_Monster[10001].Icon, self.headIcon);
	end

	self:RefreshLabelColor();
end

function MonsterFaceCell:RefreshLabelColor()
	if(self.data.level)then
		local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL);
		local deltalv = mylv - self.data.level;
		-- 低于角色等级20显示为灰
		if(deltalv>=MonsterTextColorConfig.Level.L)then
			self.level.color = MonsterTextColorConfig.Color.L;
			-- self.name.color = MonsterTextColorConfig.Color.L;

			self.level.effectColor = MonsterTextColorConfig.EffectColor.L;
			-- self.name.effectColor = MonsterTextColorConfig.EffectColor.L;
		-- 高于角色等级15显示为红色
		elseif(deltalv<=-1*MonsterTextColorConfig.Level.H)then
			self.level.color = MonsterTextColorConfig.Color.H;
			-- self.name.color = MonsterTextColorConfig.Color.H;

			self.level.effectColor = MonsterTextColorConfig.EffectColor.H;
			-- self.name.effectColor = MonsterTextColorConfig.EffectColor.H;
		else
			self.level.color = MonsterTextColorConfig.Color.N;
			-- self.name.color = MonsterTextColorConfig.Color.N;

			self.level.effectColor = MonsterTextColorConfig.EffectColor.N;
			-- self.name.effectColor = MonsterTextColorConfig.EffectColor.N;
		end
	end
end