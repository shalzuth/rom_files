ServantSubView = class("ServantSubView",SubMediatorView)

local ServantNpcId = {
	[7] = GameConfig.Servant.female,
	[8] = GameConfig.Servant.male,
}

function ServantSubView:OnEnter(subId)
	ServantSubView.super.OnEnter(self)
	self.npcid = ServantNpcId[subId]
	self:ShowNpcModel()
end

function ServantSubView:Init()
	self:InitView()
end

function ServantSubView:InitView()
	self.gameObject = self:LoadPreferb("view/ServantSubView" , nil , true)
	self.modeltexture = self:FindComponent("ModelTexture",UITexture)
	local modelBg = self:FindGO("ModelBg")
	self:AddDragEvent(modelBg ,function (go, delta)
		if(self.model)then
			self.model:RotateDelta( -delta.x );
		end
	end);
end

function ServantSubView:ShowNpcModel()
	local sdata = self.npcid and Table_Npc[self.npcid]
	if(sdata)then
		local otherScale = 1;
		if(sdata.Shape)then
			otherScale = GameConfig.UIModelScale[sdata.Shape] or 1;
		else
			helplog(string.format("Npc:%s Not have Shape", sdata.id));
		end

		if(sdata.Scale)then
			otherScale = sdata.Scale
		end
		self.model = UIModelUtil.Instance:SetNpcModelTexture(self.modeltexture, sdata.id);

		local showPos = sdata.LoadShowPose
		if(showPos and #showPos == 3)then
			tempVector3:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
			self.model:SetPosition(tempVector3);
		end
		if(sdata.LoadShowRotate)then
			self.model:SetEulerAngleY(sdata.LoadShowRotate)
		end
		if(sdata.LoadShowSize)then
			otherScale = sdata.LoadShowSize
		end
		self.model:SetScale( otherScale );
	end
end
