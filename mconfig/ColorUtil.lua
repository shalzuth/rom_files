ColorUtil = {}
ColorUtil.NGUIShaderGray = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
ColorUtil.NGUILightShaderGray = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
ColorUtil.NGUIGray = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255, 1)
ColorUtil.NGUIDeepGray = Color(0.3137254901960784, 0.3137254901960784, 0.3137254901960784, 1)
ColorUtil.NGUIWhite = Color(1, 1, 1, 1)
ColorUtil.NGUIBlack = Color(0, 0, 0, 0)
ColorUtil.NGUILabelBlueBlack = Color(0.20392156862745098, 0.20392156862745098, 0.33725490196078434, 1)
ColorUtil.NGUILabelRed = Color(1.0, 0.0 / 255.0, 0.0 / 255.0, 1)
ColorUtil.TeamOrange = Color(1.0, 0.7725490196078432, 0.0784313725490196, 1)
ColorUtil.TeamGray = Color(0.8313725490196079, 0.8313725490196079, 0.8313725490196079, 1)
ColorUtil.Red = Color(1, 0.23137254901960785, 0.050980392156862744, 1)
ColorUtil.TipColor = "[FFC539]"
ColorUtil.TipLightColor = "[FFC539]"
ColorUtil.TipDarkColor = "[B8B8B8]"
ColorUtil.GrayColor_16 = "B8B8B8"
ColorUtil.CareerFlag1 = Color(1.0, 0.32941176470588235, 0.27450980392156865, 1)
ColorUtil.CareerFlag2 = Color(0.2235294117647059, 0.4470588235294118, 0.8431372549019608, 1)
ColorUtil.CareerFlag3 = Color(0.592156862745098, 0.27058823529411763, 0.6705882352941176, 1)
ColorUtil.CareerFlag4 = Color(1.0, 0.7764705882352941, 0.18823529411764706, 1)
ColorUtil.CareerFlag5 = Color(0.09411764705882353, 0.8235294117647058, 0.49411764705882355, 1)
ColorUtil.CareerFlag6 = Color(0.9764705882352941, 0.5176470588235295, 0.19607843137254902, 1)
ColorUtil.CareerIconBg0 = Color(0.615686274509804, 0.803921568627451, 0.396078431372549, 1)
ColorUtil.CareerIconBg1 = Color(0.7254901960784313, 0.1450980392156863, 0.1568627450980392, 1)
ColorUtil.CareerIconBg2 = Color(0.19607843137254902, 0.30196078431372547, 0.6549019607843137, 1)
ColorUtil.CareerIconBg3 = Color(0.42745098039215684, 0.20392156862745098, 0.5333333333333333, 1)
ColorUtil.CareerIconBg4 = Color(1.0, 0.7529411764705882, 0.0 / 255.0, 1)
ColorUtil.CareerIconBg5 = Color(0.11764705882352941, 0.5333333333333333, 0.36470588235294116, 1)
ColorUtil.CareerIconBg6 = Color(0.9137254901960784, 0.45098039215686275, 0.06666666666666667, 1)
ColorUtil.TitleBlue = Color(0.24313725490196078, 0.34901960784313724, 0.6549019607843137, 1)
ColorUtil.TitleGray = Color(0.6, 0.6, 0.6, 1)
ColorUtil.ButtonLabelOrange = Color(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
ColorUtil.ButtonLabelBlue = Color(0.14901960784313725, 0.24313725490196078, 0.5490196078431373, 1)
ColorUtil.ButtonLabelPink = Color(0.788235294117647, 0.14901960784313725, 0.45098039215686275, 1)
ColorUtil.ButtonLabelGreen = Color(0.1607843137254902, 0.4117647058823529, 0 / 255, 1)
ColorUtil.PVPBlackLabel = Color(0.2196078431372549, 0.2196078431372549, 0.2196078431372549, 1)
ColorUtil.DiscountLabel_Green = Color(0.10588235294117647, 0.5372549019607843, 0.34901960784313724, 1)
ColorUtil.DiscountLabel_Blue = Color(0.22745098039215686, 0.3411764705882353, 0.6078431372549019, 1)
ColorUtil.DiscountLabel_Purple = Color(0.5019607843137255, 0.15294117647058825, 0.8235294117647058, 1)
ColorUtil.DiscountLabel_Yellow = Color(1.0, 0.48627450980392156, 0.03137254901960784, 1)
ColorUtil.TabColor_White = Color(1, 1, 1, 1)
ColorUtil.TabColor_DeepBlue = Color(0.2784313725490196, 0.3803921568627451, 0.7137254901960784, 1)
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
  uiwidget.color = Color(0, 0, 0, 1)
end
function ColorUtil.BlueBlackLabel(uiwidget)
  uiwidget.color = ColorUtil.NGUILabelBlueBlack
end
function ColorUtil.RedLabel(uiwidget)
  uiwidget.color = ColorUtil.Red
end
function ColorUtil.ToColorList(t)
  if nil == t then
    return nil
  end
  local colorList = LuaUtils.CreateColorList()
  for i = 1, #t do
    LuaUtils.AddColorToList(colorList, t[i])
  end
  return colorList
end
function ColorUtil.TryParseFromNumber(n)
  local hexStr = string.format("#%08x", n)
  return ColorUtil.TryParseHtmlString(hexStr)
end
function ColorUtil.TryParseHexString(hexStr)
  return ColorUtil.TryParseHtmlString("#" .. hexStr)
end
function ColorUtil.TryParseHtmlString(htmlStr)
  return ColorUtility.TryParseHtmlString(htmlStr)
end
function ColorUtil.NumberTableToColorTable(t, ignoreColorNumber)
  if nil == t then
    return nil
  end
  local colorTable = {}
  for i = 1, #t do
    local cNumber = t[i]
    local color
    if nil ~= cNumber then
      if ignoreColorNumber ~= cNumber then
        local hasColor = false
        hasColor, color = ColorUtil.TryParseFromNumber(cNumber)
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
  if color then
    print("r is " .. color.r * 255)
    print("g is " .. color.g * 255)
    print("b is " .. color.b * 255)
  end
end
