SceneAnimationPanel = class("SceneAnimationPanel", BaseView)
SceneAnimationPanel.ViewType = UIViewType.DialogLayer

function SceneAnimationPanel:Init()
	self:AddListener()
end

function SceneAnimationPanel:AddListener()
	self:AddListenEvt(ServiceEvent.PlayerMapChange,self.SceneLoadFinishHandler)
end

function SceneAnimationPanel:SceneLoadFinishHandler( note )
	if(note.type == LoadSceneEvent.StartLoad) then
		self:CloseSelf()
	end
end