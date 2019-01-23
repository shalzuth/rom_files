SlotMachineView = class("SlotMachineView", BaseView);

SlotMachineView.ViewType = UIViewType.NormalLayer

function SlotMachineView:Init()
	self:InitView();
end

function SlotMachineView:InitView()
	self.scrollView1 = self:FindComponent("ScrollView1", UIScrollView);
	self.scrollView2 = self:FindComponent("ScrollView2", UIScrollView);
	self.scrollView3 = self:FindComponent("ScrollView3", UIScrollView);

	local pConers1 = self.scrollView1.panel.worldCorners;
	local pCenter1 = (pConers1[1] + pConers1[3]) * 0.5;
	self.scrollView1_centerY = pCenter1.y;

	local pConers2 = self.scrollView2.panel.worldCorners;
	local pCenter2 = (pConers2[1] + pConers2[3]) * 0.5;
	self.scrollView2_centerY = pCenter2.y;

	local pConers3 = self.scrollView3.panel.worldCorners;
	local pCenter3 = (pConers3[1] + pConers3[3]) * 0.5;
	self.scrollView3_centerY = pCenter3.y;

	self.wrap_1 = self:FindGO("Wrap", self.scrollView1.gameObject);
	self.centerOnChild_1 = self.wrap_1:GetComponent(UICenterOnChild);

	self.wrap_2 = self:FindGO("Wrap", self.scrollView2.gameObject);
	self.centerOnChild_2 = self.wrap_2:GetComponent(UICenterOnChild);

	self.wrap_3 = self:FindGO("Wrap", self.scrollView3.gameObject);
	self.centerOnChild_3 = self.wrap_3:GetComponent(UICenterOnChild);

	self.lagan = self:FindComponent("pet_bg_rocker3", Animator);

	self.pullRod = self:FindGO("Stop");
	self:AddClickEvent(self.pullRod, function (go)
		if(not self.stopAnim)then
			self.stopAnim = true;

			self:StopAnim();
			ServiceScenePetProxy.Instance:CallCatchPetPetCmd(self.npcguid, true);
		end
	end);
end

local totaltime = 0;
function SlotMachineView:DoAnim()
	if(self.animTick)then
		self.animTick = nil;
		TimeTickManager.Me():ClearTick(self, 1)
	end

	totaltime = 0;
	self.animTick = TimeTickManager.Me():CreateTick(0, 33, self._DoAnim, self, 1);
end

function SlotMachineView:_DoAnim(deltatime)
	totaltime = totaltime + deltatime;

	self.scrollView1:Scroll(1);

	if(totaltime > 250)then
		self.scrollView2:Scroll(1);
	end

	if(totaltime > 500)then
		self.scrollView3:Scroll(1);
	end

	self.lagan:Play ("laba_move", -1, 0);
end

local stopIndex = 0;
function SlotMachineView:StopAnim()
	if(self.animTick)then
		self.animTick = nil;
		TimeTickManager.Me():ClearTick(self, 1)
	end

	stopIndex = 0;
	self.animTick = TimeTickManager.Me():CreateTick(0, 33, self._StopAnim, self, 1);
end

function SlotMachineView:_StopAnim(deltatime)
	if(stopIndex == 0)then
		local cTrans = self.centerOnChild_1.transform:GetChild(self.stopIndex[1]-1);
		local _, y, _ = LuaGameObject.GetPosition(cTrans);
		if(math.abs(self.scrollView1_centerY - y) < 0.1)then
			self.centerOnChild_1:CenterOn(cTrans);
			stopIndex = stopIndex + 1;
		else
			self.scrollView1:Scroll(0.5);
		end

		self.scrollView2:Scroll(0.5);
		self.scrollView3:Scroll(0.5);

	elseif(stopIndex == 1)then
		local cTrans = self.centerOnChild_2.transform:GetChild(self.stopIndex[2]-1);
		local _, y, _ = LuaGameObject.GetPosition(cTrans);
		if(math.abs(self.scrollView2_centerY - y) < 0.1)then
			self.centerOnChild_2:CenterOn(cTrans);
			stopIndex = stopIndex + 1;
		else
			self.scrollView2:Scroll(0.5);
		end

		self.scrollView3:Scroll(0.5);

	elseif(stopIndex == 2)then
		local cTrans = self.centerOnChild_3.transform:GetChild(self.stopIndex[3]-1);
		local _, y, _ = LuaGameObject.GetPosition(cTrans);
		if(math.abs(self.scrollView3_centerY - y) < 0.1)then
			self.centerOnChild_3:CenterOn(cTrans);
			stopIndex = stopIndex + 1;
		else
			self.scrollView3:Scroll(0.5);
		end
	else
		self.animTick = nil;
		TimeTickManager.Me():ClearTick(self, 1);

		self.animTick = TimeTickManager.Me():CreateTick(1000, 0, self.CloseSelf, self, 1);
	end
end

function SlotMachineView:OnEnter()
	SlotMachineView.super.OnEnter(self);

	local viewdata = self.viewdata.viewdata;
	self.success = viewdata.success;
	self.npcguid = viewdata.npcguid;
	self.npcid = viewdata.npcid;

	if(self.success)then
		self.stopIndex = {1,1,1}
	else
		self.stopIndex = {};
		for i=1,3 do
			self.stopIndex[i] = math.random(1,3);
		end
		if(self.stopIndex[1] == self.stopIndex[2] 
			and self.stopIndex[1] == self.stopIndex[3])then
			self.stopIndex[3] = (self.stopIndex[3]+1)%3 + 1;
		end
	end


	self:DoAnim();

	-- 关闭老虎机的保护时间
	if(self.closelt)then
		self.closelt:cancel();
		self.closelt = nil;
	end

	local maxCatchCartoonTime = GameConfig.Pet.maxCatchCartoonTime or 5;
	self.closelt = LeanTween.delayedCall(maxCatchCartoonTime, function ()
		self.closelt = nil;
		self:StopAnim();
	end)

	Game.Myself:Client_PauseIdleAI();
	FunctionSystem.WeakInterruptMyself(true);
end

function SlotMachineView:OnExit()
	if(self.closelt)then
		self.closelt:cancel();
		self.closelt = nil;
	end

	if(self.animTick)then
		self.animTick = nil;
		TimeTickManager.Me():ClearTick(self, 1);
	end

	FunctionPet.Me():CatchEnd(self.npcguid, self.npcid, self.success);

	self.stopAnim = false;

	SlotMachineView.super.OnExit(self);

	Game.Myself:Client_ResumeIdleAI();
end