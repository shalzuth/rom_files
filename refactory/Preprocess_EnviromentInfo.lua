function Game.Preprocess_EnviromentInfo()
  if nil ~= Table_Enviroment then
    for k, v in pairs(Table_Map) do
      if nil == EnviromentInfo[k] then
        EnviromentInfo[k] = autoImport("Enviroment_" .. k)
      end
    end
  end
end
