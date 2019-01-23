local PlayerLevelUpCommand = class("PlayerLevelUpCommand",pm.SimpleCommand)
function PlayerLevelUpCommand:execute(note)
	local player = note.body
	if(note.type == SceneUserEvent.JobLevelUp)then
		player:PlayJobLevelUpEffect()
	elseif(note.type == SceneUserEvent.BaseLevelUp) then
		player:PlayBaseLevelUpEffect()
		player:PlayBaseLevelUpAudio()
		if(player:GetCreatureType() == Creature_Type.Me) then
			self:MyBaseLevelUp(player.data.userdata:Get(UDEnum.ROLELEVEL))
		end
	elseif(note.type == SceneUserEvent.AppellationUp)then
		player:PlayAdventureLevelUpEffect()
	end
end

function PlayerLevelUpCommand:MyBaseLevelUp(i_level)
	FunctionItemCompare.Me():TryCompare()

	-- <RB>tyrantdb
	local level = i_level or 0
	FunctionTyrantdb.Instance:SetLevel(level)
	-- <RE>tyrantdb

	if(level == 15)then
--		UIUtil.PopUpConfirmYesNoView(ZhString.NoticeTitle,Table_Sysmsg[203].Text,function()
--			OverSeas_TW.OverSeasManager.GetInstance():StoreReview()
--		end,function ()
--		end,nil,Table_Sysmsg[203].button,Table_Sysmsg[203].buttonF)
		OverSeas_TW.OverSeasManager.GetInstance():StoreReview()
	end
end

return PlayerLevelUpCommand