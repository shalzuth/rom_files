autoImport("MakeBaseView")

KnightMakeView = class("KnightMakeView", MakeBaseView)

KnightMakeView.ViewType = MakeBaseView.ViewType

function KnightMakeView:Init()
	self.type = BusinessmanMakeProxy.Skill.Knight

	KnightMakeView.super.Init(self)
end