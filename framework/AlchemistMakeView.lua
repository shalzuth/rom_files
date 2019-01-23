autoImport("MakeBaseView")

AlchemistMakeView = class("AlchemistMakeView", MakeBaseView)

AlchemistMakeView.ViewType = MakeBaseView.ViewType

function AlchemistMakeView:Init()
	self.type = BusinessmanMakeProxy.Skill.Alchemist

	AlchemistMakeView.super.Init(self)
end