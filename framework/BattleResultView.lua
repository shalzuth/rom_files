BattleResultView = class("BattleResultView", BaseView);

BattleResultView.ViewType = UIViewType.NormalLayer;

function BattleResultView:Init()
end

function BattleResultView:FindObjs()
end

function BattleResultView:OnEnter()
	self.super.OnEnter(self);

	local boss = self:GetBossRole() or Game.Myself;
	self:WinCameraMove(boss, function ()
		self:CloseSelf();
		-- self:PlayBattleEndAnim();
	end);
end

function BattleResultView:PlayBattleEndAnim()
	local battleWin = self:FindGO("BattleWin");
	local autodestroy = battleWin:AddComponent(EffectAutoDestroy);
	autodestroy.OnFinish = function ()
		self:CloseSelf();
	end
	battleWin:SetActive(true);
end

function BattleResultView:GetBossRole()
	local mapid = SceneProxy.Instance.currentScene;
	if(mapid and Table_MapRaid[mapid])then
		local bossid = Table_MapRaid[mapid].Boss;
		if(bossid)then
			return NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), bossid);
		end
	end
end

function BattleResultView:WinCameraMove(role, callback)
	if(role)then
		self:CameraRotateToMe();

		LeanTween.delayedCall(1, function ()
			local actionName = Table_ActionAnime[39].Name;
			Game.Myself:Client_PlayAction(actionName, nil, false);
			
			if(callback)then
				callback();
			end
		end)
	else
		if(callback)then
			callback();
		end
	end
end

function BattleResultView:OnExit()
	if(self.viewdata.callback)then
		self.viewdata.callback();
	end
	self:CameraReset();
	self.super.OnExit(self);
end