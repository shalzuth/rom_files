ColorUtil = {}

ColorUtil.NGUIShaderGray = Color(1.0/255.0,2.0/255.0,3.0/255.0,1)
ColorUtil.NGUILightShaderGray = Color(1.0/255.0,2.0/255.0,3.0/255.0,160/255)
ColorUtil.NGUIGray = Color(128.0/255.0,128.0/255.0,128.0/255.0,1)
ColorUtil.NGUIDeepGray = Color(80.0/255.0,80.0/255.0,80.0/255.0,1)
ColorUtil.NGUIWhite = Color(1,1,1,1)
ColorUtil.NGUIBlack = Color(0,0,0,0)
ColorUtil.NGUILabelBlueBlack = Color(52.0/255.0,52.0/255.0,86.0/255.0,1)
ColorUtil.NGUILabelRed = Color(255.0/255.0,0.0/255.0,0.0/255.0,1)

ColorUtil.TeamOrange = Color(255.0/255.0,197.0/255.0,20.0/255.0,1)
ColorUtil.TeamGray = Color(212.0/255.0,212.0/255.0,212.0/255.0,1)

ColorUtil.Red = Color(1,59/255.0,13/255.0,1)

ColorUtil.TipColor = "[FFC539]";
ColorUtil.TipLightColor = "[FFC539]";
ColorUtil.TipDarkColor = "[B8B8B8]";
--
ColorUtil.GrayColor_16 = "B8B8B8"

ColorUtil.CareerFlag1 = Color(255.0/255.0,84.0/255.0,70.0/255.0,1)
ColorUtil.CareerFlag2 = Color(57.0/255.0,114.0/255.0,215.0/255.0,1)
ColorUtil.CareerFlag3 = Color(151.0/255.0,69.0/255.0,171.0/255.0,1)
ColorUtil.CareerFlag4 = Color(255.0/255.0,198.0/255.0,48.0/255.0,1)
ColorUtil.CareerFlag5 = Color(24.0/255.0,210.0/255.0,126.0/255.0,1)
ColorUtil.CareerFlag6 = Color(249.0/255.0,132.0/255.0,50.0/255.0,1)


ColorUtil.CareerIconBg0 = Color(157.0/255.0,205.0/255.0,101.0/255.0,1)
ColorUtil.CareerIconBg1 = Color(185.0/255.0,37.0/255.0,40.0/255.0,1)
ColorUtil.CareerIconBg2 = Color(50.0/255.0,77.0/255.0,167.0/255.0,1)
ColorUtil.CareerIconBg3 = Color(109.0/255.0,52.0/255.0,136.0/255.0,1)
ColorUtil.CareerIconBg4 = Color(255.0/255.0,192.0/255.0,0.0/255.0,1)
ColorUtil.CareerIconBg5 = Color(30.0/255.0,136.0/255.0,93.0/255.0,1)
ColorUtil.CareerIconBg6 = Color(233.0/255.0,115.0/255.0,17.0/255.0,1)

--交易所 商店 标题label
ColorUtil.TitleBlue = Color(62/255,89/255,167/255,1)
ColorUtil.TitleGray = Color(153/255,153/255,153/255,1)

ColorUtil.ButtonLabelOrange = Color(158/255,86/255,0/255,1)
ColorUtil.ButtonLabelBlue = Color(38/255,62/255,140/255,1)
ColorUtil.ButtonLabelPink = Color(201/255,38/255,115/255,1)
ColorUtil.ButtonLabelGreen = Color(41/255,105/255,0/255,1)

ColorUtil.PVPBlackLabel= Color(56.0/255.0,56.0/255.0,56.0/255.0,1)

-- 打折标签文字
ColorUtil.DiscountLabel_Green = Color(27/255,137/255,89/255,1)
ColorUtil.DiscountLabel_Blue = Color(58/255,87/255,155/255,1)
ColorUtil.DiscountLabel_Purple = Color(128/255,39/255,210/255,1)
ColorUtil.DiscountLabel_Yellow = Color(255/255,124/255,8/255,1)

-- Tab Name Tip
ColorUtil.TabColor_White = Color(1,1,1,1)
ColorUtil.TabColor_DeepBlue = Color(71/255,97/255,182/255,1)

function ColorUtil.ShaderGrayUIWidget(uiwidget)
    uiwidget.color = ColorUtil.NGUIShaderGray
end

function ColorUtil.ShaderLightGrayUIWidget(uiwidget)
    uiwidget.color = ColorUtil.NGUILightShaderGray
end

function ColorUtil.GrayUIWidget(uiwidget)
    uiwidget.color = ColorUtil.NGUIGray
end

function ColorUtil.DeepGrayUIWidget(uiwidget)
    uiwidget.color = ColorUtil.NGUIDeepGray
end

function ColorUtil.WhiteUIWidget(uiwidget)
    uiwidget.color = ColorUtil.NGUIWhite
end

function ColorUtil.BlackLabel(uiwidget)
    uiwidget.color = Color(0,0,0,1)
end

function ColorUtil.BlueBlackLabel(uiwidget)
    uiwidget.color = ColorUtil.NGUILabelBlueBlack
end

function ColorUtil.RedLabel(uiwidget)
    uiwidget.color = ColorUtil.Red
end

-- return sucessOrFailed, color
function ColorUtil.ToColorList(t)
    if nil == t then
		return nil
	end
	local colorList = LuaUtils.CreateColorList()
	for i=1,#t do
		LuaUtils.AddColorToList(colorList, t[i])
	end
	return colorList
end

function ColorUtil.TryParseFromNumber(n)
    local hexStr = string.format("#%08x", n)
    return ColorUtil.TryParseHtmlString(hexStr)
end

function ColorUtil.TryParseHexString(hexStr)
	return ColorUtil.TryParseHtmlString("#"..hexStr)
end

function ColorUtil.TryParseHtmlString(htmlStr)
	return ColorUtility.TryParseHtmlString(htmlStr)
end

function ColorUtil.NumberTableToColorTable(t, ignoreColorNumber)
	if nil == t then
		return nil
	end
	local colorTable = {}
	for i=1,#t do
		local cNumber = t[i]
		local color = nil

		if nil ~= cNumber then
			if ignoreColorNumber ~= cNumber then
				local hasColor = false
				hasColor,color = ColorUtil.TryParseFromNumber(cNumber)
			end
		else
			color = Color.clear
			errorLog(string.format("<color=red>NumberTableToColorTable t[%d] is nil</color>", i))
		end
		table.insert(colorTable, color)
	end
	return colorTable
end

function ColorUtil.Print(color)
	if(color)then
		print("r is "..color.r*255)
		print("g is "..color.g*255)
		print("b is "..color.b*255)
	end
end
