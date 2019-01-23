local SceneNameView = class("SceneNameView", ContainerView)
autoImport("LowBloodBlinkView")
autoImport("PlayerSingView")
SceneNameView.ViewType = UIViewType.SceneNameLayer

autoImport("PlayerBottomView")
autoImport("SceneQuestSymbolView")
autoImport("ScenePlayerRevive");
autoImport("SceneGuildDoor");

function SceneNameView:Init()

	self:AddSubView("PlayerSingView",PlayerSingView)
	self:AddSubView("PlayerBottomView",PlayerBottomView)
	self:AddSubView("SceneQuestSymbolView",SceneQuestSymbolView)
	self:AddSubView("ScenePlayerRevive",ScenePlayerRevive)	
	self:AddSubView("SceneGuildDoor",SceneGuildDoor)	
	
end

return SceneNameView