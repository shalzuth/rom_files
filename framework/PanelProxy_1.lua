PanelProxy = class("PanelProxy", pm.Proxy)
PanelProxy.Instance = nil
PanelProxy.NAME = "PanelProxy"
function PanelProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PanelProxy.NAME
  if PanelProxy.Instance == nil then
    PanelProxy.Instance = self
  end
  self:Parse()
end
function PanelProxy:Parse()
  self.panelMap = {}
  for k, v in pairs(PanelConfig) do
    self.panelMap[v.id] = v
  end
end
function PanelProxy:GetData(id)
  return self.panelMap[id]
end
function PanelProxy:GetViewType(id)
  local data = self:GetData(id)
  if data == nil then
    return
  end
  local cls = UIManagerProxy.Instance:GetImport(data.class)
  return cls.ViewType
end
