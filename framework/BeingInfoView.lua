BeingInfoView = class("BeingInfoView",BaseView)

BeingInfoView.ViewType = UIViewType.NormalLayer

autoImport("PetInfoLabelCell");

function BeingInfoView:Init()
	self:InitView();
	self:MapEvent();
end

function BeingInfoView:InitView()
	local headGO = self:FindGO("PlayerHeadCell");
	self.headGO_Bg = headGO:GetComponent(UIWidget);
	self.headIconCell = PlayerFaceCell.new(headGO);
	self.headIconCell:AddEventListener(MouseEvent.MouseClick, self.HandleClickHead, self);
	self.headData = HeadImageData.new();
	self.changeSymbol = self:FindGO("ChangeBody", headGO);

	self.namelab = self:FindComponent("Name", UILabel);

	self.level_valuelab = self:FindComponent("Value", UILabel, self:FindGO("Level"));
	self.level_slider = self:FindComponent("Level_ExpSlider", UISlider);
	self.skillTipStick = self:FindComponent("SkillTipStick", UIWidget);

	local table = self:FindComponent("AttriTable", UITable);
	self.attriCtl = UIGridListCtrl.new(table , PetInfoLabelCell, "PetInfoLabelCell");
	self.attriCtl:AddEventListener(MouseEvent.MouseClick, self.ClickSkill, self);

	self.restButton = self:FindGO("RestButton");
	self:AddClickEvent(self.restButton, function (go)
		self:DoRest();
	end);
	self.resetSkillButton = self:FindGO("RestSkillButton");
	self:AddClickEvent(self.resetSkillButton, function (go)
		self:DoResetSkill();
	end);
end

function BeingInfoView:HandleClickHead(note)
	if(self.active_bodyChooseBord)then
		return;
	end

	local bodyDatas = {};
	local bodys = self.beingInfoData:GetBeingBodys();
	if(#bodys > 0)then
		for i=1,#bodys do
			local data = {};
			data[1] = self.beingInfoData.beingid;
			data[2] = bodys[i];
			data[3] = self.beingInfoData.body;
			data[4] = false;
			table.insert(bodyDatas, data);
		end
		local fashionChooseTip = TipManager.Instance:ShowPetFashionChooseTip(bodyDatas, 
			self.headGO_Bg, 
			NGUIUtil.AnchorSide.TopLeft, 
			{-226, -150},
			self.BodyChooseCloseCall,
			self);

		fashionChooseTip:SetClickEvent(self.ChooseBeingBody, self);
		fashionChooseTip:AddIgnoreBounds(self.headGO_Bg.gameObject);

		self.active_bodyChooseBord = true;

		-- RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_BEING_BODY or 300);
	end
end

function BeingInfoView:BodyChooseCloseCall()
	self.active_bodyChooseBord = false;
end

function BeingInfoView:ChooseBeingBody(data)
	if(data)then
		if(data[2] ~= self.beingInfoData.body)then
			ServiceSceneBeingProxy.Instance:CallChangeBodyBeingCmd(data[1], data[2]);
			TipManager.Instance:CloseTip();
		end
	end
end

function BeingInfoView:ClickSkill(skillCell)
	local skillData = skillCell.data;
	if(type(skillData) == "table")then
		TipManager.Instance:ShowPetSkillTip( skillCell.data, self.skillTipStick, NGUIUtil.AnchorSide.TopLeft, {-185, 0} )
	end
end

function BeingInfoView:DoRest()
	ServiceSceneBeingProxy.Instance:CallBeingOffCmd(self.beingInfoData.beingid); 

	self:CloseSelf();
end

function BeingInfoView:DoResetSkill()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.CharactorBeingSkill})
end

function BeingInfoView:UpdateBriefInfo()
	if(self.beingInfoData == nil)then
		return;
	end

	self.headData:TransByBeingInfoData(self.beingInfoData);
	self.headIconCell:SetData(self.headData);

	self.namelab.text = self.beingInfoData.name;

	local lv = self.beingInfoData.lv;
	self.level_valuelab.text = "[2875BD]Lv " .. lv .. "[-]";

	local nowlvConfig = Table_BeingBaseLevel[lv + 1];
	if(nowlvConfig)then
		self.level_slider.value = self.beingInfoData.exp/nowlvConfig.NeedExp;
	else
		self.level_slider.value = 1;
	end

	local bodys = self.beingInfoData:GetBeingBodys();
	self.changeSymbol:SetActive(#bodys > 0);
end


local PetShowAttris1 = {
	"Atk","MAtk",
	"Def","MDef",
	"AtkSpd","RestoreSpd",
}
local PetShowAttris2 = {
	"Str","Int",
	"Vit","Agi",
	"Dex","Luk",
}
function BeingInfoView:UpdateAtrtri()
	local beingNpc = self:GetCurBeingNpc();
	if(beingNpc == nil)then
		return;
	end
	
	local attriDatas = {};
	local props = beingNpc.data.props;
	if(props)then
		local hp = props.Hp:GetValue();
		local maxhp = props.MaxHp:GetValue();
		
		local hpdata = {}
		hpdata[1] = PetInfoLabelCell.Type.Attri;
		hpdata[2] = "Hp";
		hpdata[3] = hp .. "/" .. maxhp;
		table.insert(attriDatas, hpdata);

		for i=1,#PetShowAttris1 do
			local prop = props[ PetShowAttris1[i] ];
			if(prop)then
				local pdata = {};
				pdata[1] = PetInfoLabelCell.Type.Attri;
				pdata[2] = prop.propVO.displayName;
				pdata[3] = prop:GetValue();		
				table.insert(attriDatas, pdata);
			end
		end

		local skills = CreatureSkillProxy.Instance:GetCreatureLearnedSkills( beingNpc.data.id );
		if(skills and #skills>0)then
			local skilldatas = {};
			skilldatas[1] = PetInfoLabelCell.Type.Skill;
			skilldatas[3] = skills;
			table.insert(attriDatas, skilldatas);
		end

		for i=1,#PetShowAttris2 do
			local prop = props[ PetShowAttris2[i] ];
			if(prop)then
				local pdata = {};
				pdata[1] = PetInfoLabelCell.Type.Attri;
				pdata[2] = prop.propVO.displayName;
				pdata[3] = prop:GetValue();		
				table.insert(attriDatas, pdata);
			end
		end

	end
	self.attriCtl:ResetDatas(attriDatas);
end

function BeingInfoView:MapEvent()
	self:AddListenEvt(ServiceEvent.SceneBeingBeingInfoUpdate, self.UpdateBriefInfo);
	self:AddListenEvt(SceneUserEvent.SceneRemovePets, self.HandleSceneRemovePets);
end

function BeingInfoView:HandleSceneRemovePets(note)
	if(self:GetCurBeingNpc() == nil)then
		self:CloseSelf();
	end
end

function BeingInfoView:GetCurBeingNpc()
	if(self.beingInfoData == nil)then
		return;
	end

	return PetProxy.Instance:GetSceneBeingNpc(self.beingInfoData.beingid);
end

function BeingInfoView:OnEnter()
	BeingInfoView.super.OnEnter(self);

	local viewdata = self.viewdata.viewdata;
	self.beingInfoData = viewdata and viewdata.beingInfoData;

	self:UpdateBriefInfo();
	self:UpdateAtrtri();


	local scenePet = self:GetCurBeingNpc();
	if(scenePet)then
		self:CameraFaceTo(scenePet.assetRole.completeTransform, CameraConfig.NPC_FuncPanel_ViewPort);
	end
	FunctionPet.Me():SetCameraFoucus(false);

	-- self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_BEING_BODY or 300, self.headGO_Bg, 42, {-9, -9});
end

function BeingInfoView:OnExit()
	BeingInfoView.super.OnExit(self);

	FunctionPet.Me():SetCameraFoucus(true);
	self:CameraReset();
end