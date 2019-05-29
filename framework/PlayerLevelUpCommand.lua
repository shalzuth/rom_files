local PlayerLevelUpCommand = class("PlayerLevelUpCommand", pm.SimpleCommand)
function PlayerLevelUpCommand:execute(note)
  local player = note.body
  if note.type == SceneUserEvent.JobLevelUp then
    player:PlayJobLevelUpEffect()
  elseif note.type == SceneUserEvent.BaseLevelUp then
    player:PlayBaseLevelUpEffect()
    player:PlayBaseLevelUpAudio()
    if player:GetCreatureType() == Creature_Type.Me then
      self:MyBaseLevelUp(player.data.userdata:Get(UDEnum.ROLELEVEL))
    end
  elseif note.type == SceneUserEvent.AppellationUp then
    player:PlayAdventureLevelUpEffect()
  end
end
function PlayerLevelUpCommand:MyBaseLevelUp(i_level)
  FunctionItemCompare.Me():TryCompare()
  local level = i_level or 0
  FunctionTyrantdb.Instance:SetLevel(level)
  if level % 10 == 0 then
    local evntName = "\227\131\151\227\131\172\227\130\164\227\131\164\227\131\188Base\227\131\172\227\131\153\227\131\171" .. level
    OverseaHostHelper:AFTrack(evntName)
  end
end
return PlayerLevelUpCommand
