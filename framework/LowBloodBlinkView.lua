LowBloodBlinkView = class("LowBloodBlinkView", BaseView)
LowBloodBlinkView.ViewType = UIViewType.UIScreenEffectLayer

function LowBloodBlinkView:Init()
	self.gameObject.name = "LowBloodBlinkView"
	LowBloodBlinkView.Instance = self
	self:addListEventListener()
end

function LowBloodBlinkView:OnEnter()
	LowBloodBlinkView.super.OnEnter(self)
	self:ShowLowBloodBlink()
end

function LowBloodBlinkView:addListEventListener( )
	-- body
	-- self:AddListenEvt(SceneUIEvent.LowBloodBlinkWhenHit,self.ShowLowBloodBlinkWhenHit)
	-- self:AddListenEvt(SceneUIEvent.CloseBloodBlink,self.closeBloodBlink)
end

function LowBloodBlinkView.ShowLowBloodBlink()
	local instance = LowBloodBlinkView.getInstance()
	if(instance.bloodBlinkAnim == nil or GameObjectUtil.Instance:ObjectIsNULL(instance.bloodBlinkAnim))then
		local path = "Public/Effect/UI/7danger";
		local parent = parent or instance.gameObject;
		instance.bloodBlinkAnim = Game.AssetManager_UI:CreateAsset(path, parent);
		if(instance.bloodBlinkAnim == nil)then
			error(path);
		end
		local texture = instance:FindChild("pic_lvjing01"):GetComponent(UITexture)
		local activeHeigh = GameObjectUtil.Instance:GetUIActiveHeight(instance.gameObject);
		if ApplicationInfo.IsIphoneX() then
			texture:SetAnchor(nil)
			texture.width = 1750
		-- texture.width = 1280;
		-- 通用贴图 特设处理
			texture.height = 1520
		end
		instance.animtor = instance:FindChild("7danger"):GetComponent(Animator);
	end
	instance.animtor:Play("7danger");	
end


function LowBloodBlinkView.ShowLowBloodBlinkWhenHit()
	local instance = LowBloodBlinkView.getInstance()
	if(instance.bloodBlinkAnim == nil or GameObjectUtil.Instance:ObjectIsNULL(instance.bloodBlinkAnim))then
		local path = "Public/Effect/UI/7danger";
		local parent = parent or instance.gameObject;
		instance.bloodBlinkAnim = Game.AssetManager_UI:CreateAsset(path, parent);
		if(instance.bloodBlinkAnim == nil)then
			error(path);
		end	
		local texture = instance:FindChild("pic_lvjing01"):GetComponent(UITexture)
		if ApplicationInfo.IsIphoneX() then
			texture:SetAnchor(nil)
			texture.width = 1750
		-- texture.width = 1280;
		-- 通用贴图 特设处理
			texture.height = 1520
		end
		instance.animtor = instance:FindChild("7danger"):GetComponent(Animator);
	end
	instance.animtor:Play("7dangerhit",-1,0);	
end

function LowBloodBlinkView:OnExit(  )
	-- body
	LowBloodBlinkView.super.OnExit(self)
	LowBloodBlinkView.Instance = nil
end

function LowBloodBlinkView.getInstance(  )
	-- body
	if(LowBloodBlinkView.Instance == nil)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.LowBloodBlinkView})
	end
	return LowBloodBlinkView.Instance
end

function LowBloodBlinkView.closeBloodBlink(  )
	-- body
	if(LowBloodBlinkView.Instance ~= nil)then
		LowBloodBlinkView.Instance:CloseSelf()
	end
end