autoImport("PersonalListPage")
autoImport("SceneryListPage")
PersonalPicturePanel = class("PersonalPicturePanel", ContainerView)

PersonalPicturePanel.GetPersonPicThumbnail = "PersonalPicturePanel_GetPersonPicThumbnail"
PersonalPicturePanel.ReplacePersonPicThumbnail = "PersonalPicturePanel_ReplacePersonPicThumbnail"
PersonalPicturePanel.ReUploadingPersonPicThumbnail = "PersonalPicturePanel_ReUploadingPersonPicThumbnail"
PersonalPicturePanel.DelPersonPicThumbnail = "PersonalPicturePanel_DelPersonPicThumbnail"
PersonalPicturePanel.CancelPersonPicThumbnail = "PersonalPicturePanel_CancelPersonPicThumbnail"

PersonalPicturePanel.Album = {
	PersonalAlbum = 1,
	SceneryAlbum = 2,
}

PersonalPicturePanel.ViewType = UIViewType.Lv4PopUpLayer

PersonalPicturePanel.ShowMode = {
	ReplaceMode = 1,
	EditorMode = 2,
	NormalMode = 3,
}

function PersonalPicturePanel:Init()
	-- body
	self:initView()
	self:initData()
end

function PersonalPicturePanel:OnEnter( ... )
	-- body
	local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
	manager_Camera:ActiveMainCamera(false);
end

function PersonalPicturePanel:OnExit(  )
	-- body
	local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
	manager_Camera:ActiveMainCamera(true);
end

function PersonalPicturePanel:initData(  )
	ServicePhotoCmdProxy.Instance:CallQueryUserPhotoListPhotoCmd() 
	if(self.viewdata.viewdata)then
		self.showMode = self.viewdata.viewdata.ShowMode
		self.callback = self.viewdata.viewdata.callback
	end
	self.showMode = self.showMode and self.showMode or PersonalPicturePanel.ShowMode.NormalMode
	if(self.showMode == PersonalPicturePanel.ShowMode.ReplaceMode)then
		self:Hide(self:FindGO("SceneryTab"))
	else
		self.SceneryListPage = self:AddSubView("SceneryListPage",SceneryListPage)
	end
end

function PersonalPicturePanel:initView(  )
	-- body
	self:AddTabChangeEvent(self:FindGO("PersonalTab"),self:FindGO("PersonalListPage"),PersonalPicturePanel.Album.PersonalAlbum)
	self:AddTabChangeEvent(self:FindGO("SceneryTab"),self:FindGO("SceneryListPage"),PersonalPicturePanel.Album.SceneryAlbum)
	
	self.PersonalListPage = self:AddSubView("PersonalListPage",PersonalListPage)

	self.PersonalTabLabel = self:FindComponent("PersonalTabLabel",UILabel)
	self.SceneryTabLabel = self:FindComponent("SceneryTabLabel",UILabel)
	self:TabChangeHandler(PersonalPicturePanel.Album.PersonalAlbum)
end

local tempColor = LuaColor(38/255,72/255,148/255)
function PersonalPicturePanel:handleCategoryClick( key )
	-- body
	self:handleCategorySelect(key)
	if(key == PersonalPicturePanel.Album.PersonalAlbum)then
		self.PersonalTabLabel.effectStyle = UILabel.Effect.Outline8
		self.PersonalTabLabel.effectColor = tempColor
		self.SceneryTabLabel.effectStyle = UILabel.Effect.None
	elseif(key == PersonalPicturePanel.Album.SceneryAlbum)then
		self.PersonalTabLabel.effectStyle = UILabel.Effect.None
		self.SceneryTabLabel.effectColor = tempColor
		self.SceneryTabLabel.effectStyle = UILabel.Effect.Outline8
	end
end

function PersonalPicturePanel:handleCategorySelect( key )
	-- body	
	if(key == PersonalPicturePanel.Album.PersonalAlbum)then
		
	elseif(key == PersonalPicturePanel.Album.SceneryAlbum)then
		if(self.SceneryListPage)then
			self.SceneryListPage:ResetPosition()
		end
	end
end

function PersonalPicturePanel:TabChangeHandler(key)
	-- body
	if(self.currentKey ~= key)then
		PersonalPicturePanel.super.TabChangeHandler(self,key)	
		self:handleCategoryClick(key)		
		self.currentKey = key
	end
end


