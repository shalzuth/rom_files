LayoutUtil = {}

function LayoutUtil.FitAspect(uiwidget,panelWidth,panelHeight,width,height)
	uiwidget:CreatePanel()
	panelWidth = panelWidth and panelWidth or uiwidget.panel.width
	panelHeight = panelHeight and panelHeight or uiwidget.panel.height
	width = width and width or uiwidget.mainTexture.width
	height = height and height or uiwidget.mainTexture.height
	local imgWidth = uiwidget.mainTexture.width
	local imgHeight = uiwidget.mainTexture.height
	local widgetAspect = width/height
	local imgWidgetAspect = imgWidth/imgHeight
	local panelAspect = panelWidth/panelHeight
	LogUtility.InfoFormat("width:{0} height:{1} aspect:{2}",width,height,widgetAspect)
	LogUtility.InfoFormat("panel width:{0} panel height:{1} aspect:{2}",panelWidth,panelHeight,panelAspect)
	if(widgetAspect<panelAspect) then
		--baseonHeight
		local factor = panelHeight / height
		uiwidget.height = imgHeight * factor
		uiwidget.width = math.floor(imgWidgetAspect*uiwidget.height)
	else
		--baseonWidth
		uiwidget.width = imgWidth * panelWidth / width
		uiwidget.height = math.floor(uiwidget.width/widgetAspect) * imgHeight / height
	end
end