PanelJumpCommand = class("PanelJumpCommand", pm.SimpleCommand)
function PanelJumpCommand:execute(note)
  local body = note.body
  if body and body.view then
    local panelData = body.view
    if type(panelData) == "number" then
      panelData = PanelProxy.Instance:GetData(panelData)
    end
    if panelData then
      self:TryShowPanel(panelData, body.viewdata, body.force)
    end
  end
end
function PanelJumpCommand:TryShowPanel(data, vdata, force)
  if force == nil then
    force = false
  end
  LogUtility.InfoFormat("\229\176\157\232\175\149\230\137\147\229\188\128id:{0},{1}\231\149\140\233\157\162", data.id, data.name, data.prefab)
  if force or FunctionUnLockFunc.Me():CheckCanOpenByPanelId(data.id, false) then
    local uidata = {view = data, viewdata = vdata}
    UIManagerProxy.Instance:ShowUIByConfig(uidata)
  else
    self:UnOpenJump(data, vdata)
  end
end
function PanelJumpCommand:UnOpenJump(config, vdata)
  if config.unOpenJump then
    config = PanelProxy.Instance:GetData(config.unOpenJump)
    if config then
      LogUtility.InfoFormat("\231\149\140\233\157\162{0},{1}\230\156\170\229\188\128\229\144\175", config.id, config.name)
      self:TryShowPanel(config, vdata)
    end
  else
    FunctionUnLockFunc.Me():CheckCanOpenByPanelId(config.id, true)
  end
end
