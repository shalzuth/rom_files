require("Script.Refactory.Header")
if nil == g_Game then
  g_Game = Game.Me()
  Debug_LuaMemotry.Start()
end
return Game
