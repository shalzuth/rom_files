LayoutUtil = {}
function LayoutUtil.FitAspect(uiwidget, panelWidth, panelHeight, width, height)
  uiwidget:CreatePanel()
  if not panelWidth or not panelWidth then
    panelWidth = uiwidget.panel.width
  end
  if not panelHeight or not panelHeight then
    panelHeight = uiwidget.panel.height
  end
  if not width or not width then
    width = uiwidget.mainTexture.width
  end
  if not height or not height then
    height = uiwidget.mainTexture.height
  end
  local imgWidth = uiwidget.mainTexture.width
  local imgHeight = uiwidget.mainTexture.height
  local widgetAspect = width / height
  local imgWidgetAspect = imgWidth / imgHeight
  local panelAspect = panelWidth / panelHeight
  LogUtility.InfoFormat("width:{0} height:{1} aspect:{2}", width, height, widgetAspect)
  LogUtility.InfoFormat("panel width:{0} panel height:{1} aspect:{2}", panelWidth, panelHeight, panelAspect)
  if widgetAspect < panelAspect then
    local factor = panelHeight / height
    uiwidget.height = imgHeight * factor
    uiwidget.width = math.floor(imgWidgetAspect * uiwidget.height)
  else
    uiwidget.width = imgWidth * panelWidth / width
    uiwidget.height = math.floor(uiwidget.width / widgetAspect) * imgHeight / height
  end
end
