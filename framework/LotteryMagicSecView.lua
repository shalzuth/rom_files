autoImport("LotteryMagicView")
LotteryMagicSecView = class("LotteryMagicSecView", LotteryMagicView)
LotteryMagicSecView.ViewType = LotteryMagicView.ViewType
function LotteryMagicSecView:UpdateLotteryType()
  self.lotteryType = LotteryType.MagicSec
end
