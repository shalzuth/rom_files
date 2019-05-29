EmojiCommand = class("EmojiCommand", pm.SimpleCommand)
function EmojiCommand:execute(note)
  if note.name == EmojiEvent.PlayEmoji then
    do
      local roleid = note.body.roleid
      local emoji = note.body.emoji
      if roleid and emoji then
        if nil ~= note.body.delay and note.body.delay > 0 then
          LeanTween.delayedCall(note.body.delay / 1000, function()
            if nil == SceneCreatureProxy.FindCreature(roleid) then
              return
            end
            SceneUIManager.Instance:RolePlayEmojiById(roleid, emoji)
          end)
        else
          SceneUIManager.Instance:RolePlayEmojiById(roleid, emoji)
        end
      end
    end
  else
  end
end
