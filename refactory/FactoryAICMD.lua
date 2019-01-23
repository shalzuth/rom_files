FactoryAICMD = {}

FactoryAICMD.PlaceToCmd = {AI_CMD_PlaceTo}
FactoryAICMD.MoveToCmd = {AI_CMD_MoveTo}
FactoryAICMD.SetScaleCmd = {AI_CMD_SetScale}
FactoryAICMD.SetAngleYCmd = {AI_CMD_SetAngleY}
FactoryAICMD.PlayActionCmd = {AI_CMD_PlayAction}
FactoryAICMD.HitCmd = {AI_CMD_Hit}
FactoryAICMD.DieCmd = {AI_CMD_Die}
FactoryAICMD.ReviveCmd = {AI_CMD_Revive}
FactoryAICMD.SkillCmd = {AI_CMD_Skill}
FactoryAICMD.GetOnSeatCmd = {AI_CMD_GetOnSeat}
FactoryAICMD.GetOffSeatCmd = {AI_CMD_GetOffSeat}

--Myself  begin
FactoryAICMD.Me_PlaceToCmd = {AI_CMD_Myself_PlaceTo}
FactoryAICMD.Me_MoveToCmd = {AI_CMD_Myself_MoveTo}
FactoryAICMD.Me_DirMoveCmd = {AI_CMD_Myself_DirMove}
FactoryAICMD.Me_DirMoveEndCmd = {AI_CMD_Myself_DirMoveEnd}
FactoryAICMD.Me_SetScaleCmd = {AI_CMD_Myself_SetScale}
FactoryAICMD.Me_SetAngleYCmd = {AI_CMD_Myself_SetAngleY}
FactoryAICMD.Me_AccessCmd = {AI_CMD_Myself_Access}
FactoryAICMD.Me_SkillCmd = {AI_CMD_Myself_Skill}
FactoryAICMD.Me_PlayActionCmd = {AI_CMD_Myself_PlayAction}
FactoryAICMD.Me_HitCmd = {AI_CMD_Myself_Hit}
FactoryAICMD.Me_DieCmd = {AI_CMD_Myself_Die}
--Myself  end

function FactoryAICMD.GetPlaceToCmd(pos,ignoreNavMesh)
	local cmd = FactoryAICMD.PlaceToCmd
	cmd[2] = pos
	cmd[3] = ignoreNavMesh
	return cmd
end

function FactoryAICMD.GetMoveToCmd(pos,ignoreNavMesh)
	local cmd = FactoryAICMD.MoveToCmd
	cmd[2] = pos
	cmd[3] = ignoreNavMesh
	return cmd
end

function FactoryAICMD.GetSetScaleCmd(scaleX, scaleY, scaleZ,noSmooth)
	local cmd = FactoryAICMD.SetScaleCmd
	cmd[2] = scaleX
	cmd[3] = scaleY
	cmd[4] = scaleZ
	cmd[5] = noSmooth
	return cmd
end

function FactoryAICMD.GetSetAngleYCmd(mode,arg,noSmooth)
	local cmd = FactoryAICMD.SetAngleYCmd
	cmd[2] = mode
	cmd[3] = arg
	cmd[4] = noSmooth
	return cmd
end

function FactoryAICMD.GetPlayActionCmd(name,normalizedTime,loop,fakeDead,forceDuration)
	local cmd = FactoryAICMD.PlayActionCmd
	cmd[2] = name
	cmd[3] = normalizedTime
	cmd[4] = loop
	cmd[5] = fakeDead
	cmd[6] = forceDuration
	return cmd
end

function FactoryAICMD.GetHitCmd(withColorEffect, action, stiff)
	local cmd = FactoryAICMD.HitCmd
	cmd[2] = withColorEffect
	cmd[3] = action
	cmd[4] = stiff
	return cmd
end

function FactoryAICMD.GetDieCmd(noaction)
	local cmd = FactoryAICMD.DieCmd
	cmd[2] = noaction
	return cmd
end

function FactoryAICMD.GetReviveCmd(scale)
	local cmd = FactoryAICMD.ReviveCmd
	return cmd
end

function FactoryAICMD.GetSkillCmd(phaseData)
	local cmd = FactoryAICMD.SkillCmd
	cmd[2] = phaseData
	return cmd
end

function FactoryAICMD.GetGetOnSeatCmd(seatID)
	local cmd = FactoryAICMD.GetOnSeatCmd
	cmd[2] = seatID
	return cmd
end

function FactoryAICMD.GetGetOffSeatCmd(seatID)
	local cmd = FactoryAICMD.GetOffSeatCmd
	cmd[2] = seatID
	return cmd
end

--Myself  begin
function FactoryAICMD.Me_GetPlaceToCmd(pos,ignoreNavMesh)
	local cmd = FactoryAICMD.Me_PlaceToCmd
	cmd[2] = pos
	cmd[3] = ignoreNavMesh
	return cmd
end

function FactoryAICMD.Me_GetMoveToCmd(pos,ignoreNavMesh,callback,callbackOwner,callbackCustom,range)
	local cmd = FactoryAICMD.Me_MoveToCmd
	cmd[2] = pos
	cmd[3] = ignoreNavMesh
	cmd[4] = callback
	cmd[5] = callbackOwner
	cmd[6] = callbackCustom
	cmd[7] = range
	return cmd
end

function FactoryAICMD.Me_GetDirMoveCmd(dir,ignoreNavMesh)
	local cmd = FactoryAICMD.Me_DirMoveCmd
	cmd[2] = dir
	cmd[3] = ignoreNavMesh
	return cmd
end

function FactoryAICMD.Me_GetDirMoveEndCmd()
	return FactoryAICMD.Me_DirMoveEndCmd
end

function FactoryAICMD.Me_GetSetScaleCmd(scaleX, scaleY, scaleZ,noSmooth)
	local cmd = FactoryAICMD.Me_SetScaleCmd
	cmd[2] = scaleX
	cmd[3] = scaleY
	cmd[4] = scaleZ
	cmd[5] = noSmooth
	return cmd
end

function FactoryAICMD.Me_GetSetAngleYCmd(mode,arg,noSmooth)
	local cmd = FactoryAICMD.Me_SetAngleYCmd
	cmd[2] = mode
	cmd[3] = arg
	cmd[4] = noSmooth
	return cmd
end

function FactoryAICMD.Me_GetAccessCmd(creature,ignoreNavMesh,accessRange,custom,customDeleter,customType)
	local cmd = FactoryAICMD.Me_AccessCmd
	cmd[2] = creature
	cmd[3] = ignoreNavMesh
	cmd[4] = accessRange or -1
	cmd[5] = custom
	cmd[6] = customDeleter
	cmd[7] = customType
	return cmd
end
function FactoryAICMD.Me_GetSkillCmd(skillID,targetCreature,targetPosition,ignoreNavMesh,forceTargetCreature,allowResearch, noLimit)
	local cmd = FactoryAICMD.Me_SkillCmd
	cmd[2] = skillID
	cmd[3] = targetCreature
	cmd[4] = targetPosition
	cmd[5] = ignoreNavMesh
	cmd[6] = forceTargetCreature
	cmd[7] = allowResearch
	cmd[8] = noLimit
	return cmd
end
function FactoryAICMD.Me_GetPlayActionCmd(name,normalizedTime,loop,fakeDead,forceDuration)
	local cmd = FactoryAICMD.Me_PlayActionCmd
	cmd[2] = name
	cmd[3] = normalizedTime
	cmd[4] = loop
	cmd[5] = fakeDead
	cmd[6] = forceDuration
	return cmd
end
function FactoryAICMD.Me_GetHitCmd(withColorEffect, action, stiff)
	local cmd = FactoryAICMD.Me_HitCmd
	cmd[2] = withColorEffect
	cmd[3] = action
	cmd[4] = stiff
	return cmd
end
function FactoryAICMD.Me_GetDieCmd(noaction)
	local cmd = FactoryAICMD.Me_DieCmd
	cmd[2] = noaction
	return cmd
end
--Myself  end