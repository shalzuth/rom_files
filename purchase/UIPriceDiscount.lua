UIPriceDiscount = class('UIPriceDiscount')

function UIPriceDiscount.GetDiscountColor(percent)
	if percent <= 20 then
		return 0, ColorUtil.DiscountLabel_Green
	elseif percent <= 30 then
		return 1, ColorUtil.DiscountLabel_Blue
	elseif percent <= 50 then
		return 2, ColorUtil.DiscountLabel_Purple
	else
		return 3, ColorUtil.DiscountLabel_Yellow
	end
end

function UIPriceDiscount.SetDiscount(percent, sp_percent_bg, lab_percent, lab_percent_symbol)
	local mulSpriteState, color = UIPriceDiscount.GetDiscountColor(percent)
	lab_percent.text = percent
	lab_percent.effectColor = color
	lab_percent_symbol.effectColor = color
	sp_percent_bg.CurrentState = mulSpriteState
end