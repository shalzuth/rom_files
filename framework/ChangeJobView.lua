ChangeJobView = class("ChangeJobView",ContainerView)

ChangeJobView.ViewType = UIViewType.MovieLayer

function ChangeJobView:Init()
	self.step = 0
	self:FindObjs()
	self:AddViewListener()
end

function ChangeJobView:FindObjs()
	self.stepBtn = self:FindGO("StepBtn"):GetComponent(UIButton)
	self.stepBtnName = self:FindGO("StepBtnName"):GetComponent(UILabel)

	self:AddClickEvent(self.stepBtn.gameObject, function ()
		self:Step()
	end);
end

function ChangeJobView:AddViewListener()
	self:AddListenEvt(MyselfEvent.ChangeJobEnd,self.HandleEnd)
	self:AddListenEvt(FunctionDungen.ShutdownEvt,self.HandleEnd)
end

local tempArgs = {};
local tempV3 = LuaVector3()
function ChangeJobView:Step()
	self.step = self.step + 1
	self:EnableBtn(false)
	local targetPos = GameConfig.ChangeJob.movePos[self.step]
	if(targetPos) then
		TableUtility.TableClear(tempArgs);
		tempV3:Set(targetPos[1] or 0, targetPos[2] or 0, targetPos[3] or 0)
		tempArgs.targetPos = tempV3
		tempArgs.distance = 0.5
		tempArgs.callback = function(callerCMD, cmdEvent)
			if MissionCommand.CallbackEvent.Shutdown == cmdEvent then
				if(GameConfig.ChangeJob.movePos[self.step+1]) then
					self:EnableBtn(true)
				end
			end
		end
		local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
		Game.Myself:Client_SetMissionCommand(cmd)
	end
	if(GameConfig.ChangeJob.movePos[self.step+1]==nil) then
		self:HideBtn()
	end
end

function ChangeJobView:HideBtn()
	self:Hide(self.stepBtn.gameObject)
	self:Hide(self.stepBtnName.gameObject)
end

function ChangeJobView:EnableBtn(val)
	self.stepBtn.isEnabled = val
	-- if(val) then
	-- 	ColorUtil.WhiteUIWidget(self.stepBtnName)
	-- else
	-- 	ColorUtil.ShaderGrayUIWidget(self.stepBtnName)
	-- end
end

function ChangeJobView:HandleEnd()
	self:CloseSelf()
end

function ChangeJobView:OnEnter()
	self.super.OnEnter(self);
	self:CameraDisable( GameConfig.ChangeJob.cameraGroup2)
	self:CameraEnable( GameConfig.ChangeJob.cameraGroup1)
end

function ChangeJobView:OnExit()
	self:CameraDisable( GameConfig.ChangeJob.cameraGroup1)
	self:CameraEnable( GameConfig.ChangeJob.cameraGroup2)
	self.super.OnExit(self);
end

function ChangeJobView:CameraEnable(grp)
	if(grp) then
		local cameraPointManager = CameraPointManager.Instance
		for i=1,#grp do
			cameraPointManager:EnableGroup(grp[i])
		end
	end
end

function ChangeJobView:CameraDisable(grp)
	if(grp) then
		local cameraPointManager = CameraPointManager.Instance
		for i=1,#grp do
			cameraPointManager:DisableGroup(grp[i])
		end
	end
end