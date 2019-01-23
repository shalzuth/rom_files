UITableListCtrl = class("UITableListCtrl")

-- tableObj:uitable物体，poolName:资源池名称，sort:1顺序，-1倒序
function UITableListCtrl:ctor(tableObj,poolName,sort)
	self.table = tableObj:GetComponent(ROUITable)
	self.panel = GameObjectUtil.Instance:FindCompInParents(tableObj, UIPanel)
	self.scrollView = self.panel.gameObject:GetComponent(UIScrollView)
	-- self.table = tableObj:GetComponent(UITable)
	if sort == nil then
		sort = 1
	end
	self:SortList(sort)
	self.poolName = poolName
	self.type = {}
	self.cells = {}
	self.datas = {}
	self.events = {}
	self.lastDatasCount = 0

	self:GetTablePos()

	self.table.onInitializeItem = function (realI)
		local index = realI + 1
		local cellCtrl = self:AddCell( self.datas[index] )
		cellCtrl.gameObject.name = index

		--修复动态向table里添加项后没有自动裁剪Cliping
		-- self.table.gameObject:SetActive(not self.table.gameObject.activeInHierarchy)
		-- self.table.gameObject:SetActive(not self.table.gameObject.activeInHierarchy)

		return cellCtrl.gameObject
	end
	self.table.onRemoveItem = function (obj)
		self:RemoveCellByObj(obj)
	end
end

-- config = { cellType , cellName , control }
function UITableListCtrl:SetType(config)
	local data = {
		cellType = config.cellType,
		cellName = config.cellName,
		control = config.control
	}
	self.type[data.cellType] = data
end

function UITableListCtrl:AddCell(data)

	local config = self.type[data:GetCellType()]

	local cellCtrl
	if config.control.CreateAsTable then
		config.parent = self.table.gameObject
		cellCtrl = config.control.CreateAsTable(config)
	else
		local cellGo = self:LoadCellPfb(config.cellName)
		cellCtrl = config.control.new(cellGo)
	end
	cellCtrl.name = config.cellName
	for i=1,#self.events do
		cellCtrl:AddEventListener(self.events[i].eventType, self.events[i].handler, self.events[i].handlerOwner)
	end
		
	table.insert( self.cells, cellCtrl )
	
	if data then
		cellCtrl:SetData(data)
	end

	return cellCtrl
end

function UITableListCtrl:LoadCellPfb(cName)
	local cellpfb = self:CreateAsset(ResourcePathHelper.UICell(cName))
	if(cellpfb == nil) then
		error ("can not find cellpfb"..cName)
	end
	cellpfb.transform:SetParent(self.table.transform,false)
	cellpfb.transform.localScale = LuaVector3.one
	return cellpfb
end

-- data = { cellType , data }
local offset = LuaVector3.zero
local tempOffset = LuaVector3.zero
function UITableListCtrl:UpdateInfo(datas,isLock)

	if not self.table.gameObject.activeInHierarchy then
		return
	end

	local newNum = #datas
	local delta = newNum - self.lastDatasCount
	if delta == 0 then
		delta = 1
	end
	offset:Set(0,0,0)

	self:RemoveAll()

	self.datas = datas
	self.lastDatasCount = newNum

	for i=1,#datas do
		if self.table:IsTableInPanel() then
			local cellCtrl = self:AddCell( datas[i] )
			cellCtrl.gameObject.name = i

			if isLock and i <= delta then				
				local bound = NGUIMath.CalculateRelativeWidgetBounds(cellCtrl.gameObject.transform)
				LuaVector3.Better_Add(offset,bound.size,offset)
			end
		else
			break
		end
	end

	self.table:SetShowIndex( #datas - 1 )

	self.table:Reposition()

	if isLock then
		local offsetPos = 0
		if self.table.IsHorizontal then
			local x,y,z = LuaGameObject.GetLocalPosition(self.table.transform)
			local off = x - self.lastTablePos
			offsetPos = offset.x + self.table.padding.x * delta * 2 - off

			self.lastTablePos = x + offsetPos
			tempOffset:Set( self.lastTablePos , y , z )
			self.table.transform.localPosition = tempOffset
		else
			local x,y,z = LuaGameObject.GetLocalPosition(self.table.transform)
			local off = y - self.lastTablePos
			offsetPos = offset.y + self.table.padding.y * delta * 2 - off
		
			self.lastTablePos = y + offsetPos
			tempOffset:Set( x , self.lastTablePos , z )	
			self.table.transform.localPosition = tempOffset
		end

		if offsetPos ~= 0 then
			self:RemoveAll()

			for i=1,#datas do
				if self.table:IsTableInPanel() then
					local cellCtrl = self:AddCell( datas[i] )
					cellCtrl.gameObject.name = i
				else
					break
				end
			end
			self.table:SetShowIndex( #datas - 1 )

			self.table:Reposition()
		end
	end

	--修复动态向table里添加项后没有自动裁剪Cliping
	-- self.panel.gameObject:SetActive(not self.panel.gameObject.activeInHierarchy)
	-- self.panel.gameObject:SetActive(not self.panel.gameObject.activeInHierarchy)
end

function UITableListCtrl:RemoveAll()
	for i=1,#self.cells do
		local cellCtrl = self.cells[i]
		cellCtrl:ClearEvent()

		cellCtrl.gameObject.name = cellCtrl.name

		if cellCtrl.CreateAsTable then
			ReusableObject.Destroy(cellCtrl)
		else
			self:AddToPool(ResourcePathHelper.UICell(cellCtrl.name) , cellCtrl.gameObject)
		end
		cellCtrl = nil
	end
	TableUtility.ArrayClear(self.cells)
end

function UITableListCtrl:RemoveCell(index)
	if(index <= #self.cells) then
		local cellCtrl = table.remove(self.cells,index)
		cellCtrl:ClearEvent()

		if cellCtrl.CreateAsTable then
			ReusableObject.Destroy(cellCtrl)
		else
			self:AddToPool(ResourcePathHelper.UICell(cellCtrl.name) , cellCtrl.gameObject)
		end
		cellCtrl = nil
	end
end

function UITableListCtrl:RemoveCellByObj(obj)
	local index = 0
	for i=1,#self.cells do
		if self.cells[i].gameObject == obj then
			index = i
		end
	end

	if index ~= 0 then
		self:RemoveCell(index)
	end
end

function UITableListCtrl:SortList(sort)
	self.table.onCustomSort = function ( trans1 , trans2)
		if tonumber(trans1.name) < tonumber(trans2.name) then
			return -1 * sort
		elseif tonumber(trans1.name) > tonumber(trans2.name) then
			return 1 * sort
		else
			return 0
		end
	end
end

function UITableListCtrl:AddEventListener(eventType, handler, handlerOwner)
	local data = { eventType = eventType ,
					handler = handler ,
					handlerOwner = handlerOwner	}

	table.insert(self.events , data)
end

function UITableListCtrl:GetIsMoveToFirst()
	return self.table.mIsMoveToFirst
end

function UITableListCtrl:GetCells()
	return self.cells
end

function UITableListCtrl:CreateAsset(path,parent)
	return Game.AssetManager_UI:CreateAsset(path, parent)
end

function UITableListCtrl:AddToPool(path,go)
	Game.GOLuaPoolManager:AddToUIPool(path , go)
end

function UITableListCtrl:ResetPosition()
	self.scrollView:ResetPosition()
	self:GetTablePos()
end

function UITableListCtrl:GetTablePos()
	local x,y,z = LuaGameObject.GetLocalPosition(self.table.transform)
	if self.table.IsHorizontal then
		self.lastTablePos = x
	else
		self.lastTablePos = y
	end
end