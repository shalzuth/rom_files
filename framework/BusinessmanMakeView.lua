autoImport("MakeBaseView")

BusinessmanMakeView = class("BusinessmanMakeView", MakeBaseView)

BusinessmanMakeView.ViewType = MakeBaseView.ViewType

function BusinessmanMakeView:Init()
	self.type = BusinessmanMakeProxy.Skill.Businessman

	BusinessmanMakeView.super.Init(self)
end