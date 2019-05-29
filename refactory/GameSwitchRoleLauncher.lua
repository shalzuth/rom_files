require("Script.Refactory.Header")
if nil == g_Game then
  g_Game = Game.Me(Game.Param_SwitchRole)
  Debug_LuaMemotry.Start()
end
return Game
