AI_CMD_Myself_DirMoveEnd = {}
function AI_CMD_Myself_DirMoveEnd:Construct(args)
  return 0
end
function AI_CMD_Myself_DirMoveEnd:Deconstruct()
end
function AI_CMD_Myself_DirMoveEnd:Start(time, deltaTime, creature)
  return false
end
function AI_CMD_Myself_DirMoveEnd:End(time, deltaTime, creature)
end
function AI_CMD_Myself_DirMoveEnd:Update(time, deltaTime, creature)
end
function AI_CMD_Myself_DirMoveEnd.ToString()
  return "AI_CMD_Myself_DirMoveEnd", AI_CMD_Myself_DirMoveEnd
end
