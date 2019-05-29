function Game.DoPreprocess_ScenePartInfo(info)
  if nil == info then
    return
  end
  local map = Game.PreprocessHelper_BuildMap(info.bps, "ID")
  if nil ~= map then
    info.bpMap = map
  end
  if GameConfig.Map_BranchForbid and info.eps then
    local myBranchValue = EnvChannel.BranchBitValue[EnvChannel.Channel.Name]
    local ep, forbidBranch, fit
    for i = #info.eps, 1, -1 do
      ep = info.eps[i]
      fit = false
      if ep.nextSceneID then
        for k, v in pairs(GameConfig.Map_BranchForbid) do
          forbidBranch = v[ep.nextSceneID]
          if forbidBranch and forbidBranch & myBranchValue > 0 then
            fit = true
          end
        end
      end
      if fit then
        table.remove(info.eps, i)
      end
    end
  end
  map = Game.PreprocessHelper_BuildMap(info.eps, "ID")
  if nil ~= map then
    info.epMap = map
  end
  map = Game.PreprocessHelper_BuildMap(info.nps, "uniqueID")
  if nil ~= map then
    info.npMap = map
  end
end
function Game.DoPreprocess_SceneInfo(info)
  if nil == info then
    return
  end
  Game.DoPreprocess_ScenePartInfo(info.PVE)
  Game.DoPreprocess_ScenePartInfo(info.PVP)
  if nil ~= info.Raids then
    for k, v in pairs(info.Raids) do
      Game.DoPreprocess_ScenePartInfo(v)
    end
  end
end
function Game.Preprocess_SceneInfo()
  if nil ~= Table_Map then
    for k, v in pairs(Table_Map) do
      if nil ~= v.Type or v.Type > 0 then
        local sceneName = v.NameEn
        if nil ~= sceneName and nil == SceneInfo[sceneName] then
          SceneInfo[sceneName] = autoImport("Scene_" .. sceneName)
        end
      end
    end
  end
  for k, v in pairs(SceneInfo) do
    Game.DoPreprocess_SceneInfo(v)
  end
end
