TestScreenFilterPanel = class("TestScreenFilterPanel", BaseView);

TestScreenFilterPanel.ViewType = UIViewType.GuideLayer;

function TestScreenFilterPanel:Init()
	self:FindObjs()
	self:AddClickEvent()
end

function TestScreenFilterPanel:FindObjs()
	self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
	self.srcToggle = self:FindGO("Toggle")
end

function TestScreenFilterPanel:OnExit()
	FunctionSceneFilter.Me():ShutDownAll()
end

function TestScreenFilterPanel:AddClickEvent()
	self.toggles = {}
	self.datas = {}
	
	for k,v in pairs(Table_ScreenFilter) do
		local toggle = GameObject.Instantiate(self.srcToggle):GetComponent(UIToggle)
		self.toggles[#self.toggles + 1] = toggle
		self.datas[#self.datas + 1] = v
		toggle.transform.parent = self.grid.transform
		local label = self:FindGO("Label",toggle.gameObject):GetComponent(UILabel)
		label.text = v.Name
	end

	for i=1,#self.toggles do
		TestScreenFilterPanelCell.new(self.toggles[i],self.datas[i])
		-- self:AddClickEvent(self.toggles[i].gameObject,function (obj)
		-- 	print(self.datas[i].id,toggle.value)
		-- end)
	end

	GameObject.Destroy(self.srcToggle)
end

TestScreenFilterPanelCell = class("TestScreenFilterPanelCell");

function TestScreenFilterPanelCell:ctor(toggle,data)
	self:AddClickEvent(toggle.gameObject,function(obj)
		if(toggle.value) then
			FunctionSceneFilter.Me():StartFilter(data.id)
		else
			FunctionSceneFilter.Me():EndFilter(data.id)
		end
		print(data.id,toggle.value)
	end)
end 