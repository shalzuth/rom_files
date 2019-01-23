SceneUIType = {
	PhotoFocus = {depth = 1, name = "ScenePanel_PhotoFocus"},
	RoleTopFloatMsg = {depth = 2, name = "ScenePanel_RoleTopFloatMsg"},
	RoleTopInfo = {depth = 3, name = "ScenePanel_RoleTopInfo"},
	RoleTopBoothInfo = {depth = 4, name = "ScenePanel_RoleTopBoothInfo"},

	PlayerBottomInfo = {depth = 5, name = "ScenePanel_Player_BottomInfo"},
	MonsterBottomInfo = {depth = 6, name = "ScenePanel_Monster_BottomInfo"},
	NpcBottomInfo = {depth = 7, name = "ScenePanel_Npc_BottomInfo"},

	DropItemName = {depth = 9, name = "ScenePanel_DropItemName"},
	SpeakWord = {depth = 10, name = "ScenePanel_SpeakWord"},
	Emoji = {depth = 11, name = "ScenePanel_Emoji"},
	DamageNum = {depth = 12, name = "ScenePanel_DamageNum"},
}

autoImport("StaticHurtNum");
autoImport("DynamicHurtNum");
autoImport("FMEmission")
autoImport("SceneTopFocusUI");
autoImport("PlayerSingView");
autoImport("SceneBottomHpSpCell");
autoImport("SceneBottomNameFactionCell");


SceneUIManager = class("SceneUIManager");

SceneUIManager.Instance = nil;

function SceneUIManager:ctor()
	SceneUIManager.Instance = self;

	self.sceneUIParentMap = {};
end

local tempV3, tempRot = LuaVector3(), LuaQuaternion();
function SceneUIManager:GetSceneUIContainer(sceneUIType)
	if(LuaGameObject.ObjectIsNull(self.suiContainer))then
		self.suiContainer = GameObject.Find("SceneUIContainer");
	end
	if(LuaGameObject.ObjectIsNull(self.suiContainer))then
		return;
	end

	local depth = sceneUIType.depth;
	local panelGO = self.sceneUIParentMap[depth];
	if(LuaGameObject.ObjectIsNull(panelGO))then
		panelGO = GameObject(sceneUIType.name);
		panelGO.transform.parent = self.suiContainer.transform;
		panelGO.layer = self.suiContainer.layer;

		tempV3:Set(0,0,0);
		panelGO.transform.localPosition = tempV3;
		tempRot.eulerAngles = tempV3;
		panelGO.transform.localRotation = tempRot;
		tempV3:Set(1,1,1);
		panelGO.transform.localScale = tempV3;

		local panel = panelGO:AddComponent(UIPanel);
		panel.depth = depth;

		container = panelGO;
		self.sceneUIParentMap[depth] = panelGO;
	end
	return panelGO;
end

function SceneUIManager:GetStaticHurtLabelWorker()
	return FunctionDamageNum.Me():GetStaticHurtLabelWorker();
end

function SceneUIManager:ShowDynamicHurtNum(pos, text, type, hurtNumColorType, crit)
	FunctionDamageNum.Me():ShowDynamicHurtNum(pos, text, type, hurtNumColorType, crit);
end

function SceneUIManager:RolePlayEmojiById(roleid, emojiId)
	local role = SceneCreatureProxy.FindCreature(roleid);
	if(role)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:PlayEmojiById(emojiId);
		end
	end
end

function SceneUIManager:RolePlayEmoji(roleid, name)
	local role = SceneCreatureProxy.FindCreature(roleid);
	if(role)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:PlayEmoji(name);
		end
	end
end

function SceneUIManager:PlayerSpeak(roleid, msg)
	local role = SceneCreatureProxy.FindCreature(roleid);
	if(role)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:Speak(msg);
		end
	end
end

function SceneUIManager:FloatRoleTopMsgById(roleid, msgid, param)
	local role = SceneCreatureProxy.FindCreature(roleid);
	if(role)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:FloatRoleTopMsgById(msgid, param);
		end
	end
end

function SceneUIManager:FloatRoleTopMsg(roleid, msg, param)
	local role = SceneCreatureProxy.FindCreature(roleid);
	if(role)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:FloatTopMsg(msg, param);
		end
	end
end

-- 头顶功能框 clickfunc(GameObject topobj)
function SceneUIManager:AddRoleTopFuncWords(role, icon, text, clickFunc, clickArgs)
	if(role)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:SetTopFuncFrame(text, icon, clickFunc, clickArgs, role);
		end
	end
end

function SceneUIManager:RemoveRoleTopFuncWords(role)
	if(role)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			sceneUI.roleTopUI:RemoveTopFuncFrame();
		end
	end
end

-- roleid 不传默认为自己
function SceneUIManager:PlayUIEffectOnRoleTop(effectid, roleid, once, offset, callback, callArgs)
	local role = SceneCreatureProxy.FindCreature(roleid);
	if(role)then
		local sceneUI = role:GetSceneUI();
		if(sceneUI)then
			local effect = sceneUI.roleTopUI:PlaySceneUIEffect(effectid, once, callback, callArgs);
			if(effect and offset)then
				effect:ResetLocalPosition(offset);
			end
			return effect;
		end
	end
end

function SceneUIManager:GetSceneUIBackgroundContainer()
	if(LuaGameObject.ObjectIsNull(self.suiBackgroundContainer))then
		self.suiBackgroundContainer = GameObject.Find("SceneUIBackgroundContainer");
	end
	return self.suiBackgroundContainer;
end

function SceneUIManager:ShowFlyingMessage()
	--print("FUN >>> SceneUIManager:ShowFlyingMessage")

	local camera = GameObject.FindGameObjectsWithTag("MainCamera")[1]:GetComponent("Camera");
	self.currentCameraRP1 = camera.renderingPath;
	camera.renderingPath = RenderingPath.Forward;
	camera = GameObject.Find("SceneUICamera"):GetComponent("Camera");
	self.currentCameraRP2 = camera.renderingPath;
	camera.renderingPath = RenderingPath.Forward;
	camera = GameObject.Find("SceneUIBackgroundCamera"):GetComponent("Camera");
	self.currentCameraRP3 = camera.renderingPath;
	camera.renderingPath = RenderingPath.Forward;

	if (GameObjectUtil.Instance:ObjectIsNULL(FMEmission.Ins().gameObject)) then
		FMEmission.Ins():AttachGO(GameObject.Find("FMEmission"))
	end
	FMEmission.Ins():Init()
	FMEmission.Ins():Open()
end

function SceneUIManager:HideFlyingMessage()
	if (self.currentCameraRP1 ~= nil) then
		local camera = GameObject.FindGameObjectsWithTag("MainCamera")[1]:GetComponent("Camera");
		camera.renderingPath = self.currentCameraRP1;
	end
	if (self.currentCameraRP2 ~= nil) then
		camera = GameObject.Find("SceneUICamera"):GetComponent("Camera");
		camera.renderingPath = self.currentCameraRP2;
	end
	if (self.currentCameraRP3 ~= nil) then
		camera = GameObject.Find("SceneUIBackgroundCamera"):GetComponent("Camera");
		camera.renderingPath = self.currentCameraRP3;
	end

	FMEmission.Ins():Close()
end

function SceneUIManager:ResetFlyingMessage()
	if (self.currentCameraRP1 ~= nil) then
		local camera = GameObject.FindGameObjectsWithTag("MainCamera")[1]:GetComponent("Camera");
		camera.renderingPath = self.currentCameraRP1;
	end
	if (self.currentCameraRP2 ~= nil) then
		camera = GameObject.Find("SceneUICamera"):GetComponent("Camera");
		camera.renderingPath = self.currentCameraRP2;
	end
	if (self.currentCameraRP3 ~= nil) then
		camera = GameObject.Find("SceneUIBackgroundCamera"):GetComponent("Camera");
		camera.renderingPath = self.currentCameraRP3;
	end
	
	FMEmission.Ins():Reset()
	FMEmission.ins = nil
end

function SceneUIManager:ActiveBackUIMask(b)
	if(Slua.IsNull(self.back_mask))then
		local uiRoot = UIManagerProxy.Instance.UIRoot;
		if(uiRoot == nil)then
			return;
		end
		self.back_mask = UIUtil.FindGO("Mask", uiRoot);
	end
	self.back_mask:SetActive(b);
end
