autoImport("EventDispatcher")
ListCtrl = class("ListCtrl",EventDispatcher)

--layoutCtrl 元素展示控制组件，cellCtrl元素控制类，cellPfb元素预制件
function ListCtrl:ctor(layoutCtrl,cellCtrl,cellPfb)
	self.reverse = false
	self.layoutCtrl = layoutCtrl
	self.cellCtrl = cellCtrl
	self.cellPfb = cellPfb
	self.cells ={}
	self:Init()
end
--反转
function ListCtrl:SetReverse( val )
	self.reverse = val
end

function ListCtrl:Init()
end

function ListCtrl:SetAddCellHandler(handler,handlerowner)
	self.addCellHandler = {func=handler,owner = handlerowner}
end

function ListCtrl:AddEventListener(eventType,handler,handlerOwner)
	ListCtrl.super.AddEventListener(self,eventType,handler,handlerOwner)
	for i=1,#self.cells do
		self.cells[i]:AddEventListener(eventType,handler,handlerOwner)
	end
end

function ListCtrl:CellAddEventListener(cell)
	if(cell and self.handlers) then
		for eventType,eventHandlers in pairs(self.handlers) do
			for i=1,#eventHandlers do
				local e= eventHandlers[i]
				if(e.owners) then
					for j=1,#e.owners do
						cell:AddEventListener(eventType,e.func,e.owners[j])
					end
				end
			end
		end
	end
end

local key = {}
function ListCtrl:LoadCellPfb(cName)
	local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(self.cellPfb))
	if(cellpfb == nil) then
		error ("can not find cellpfb"..self.cellPfb);
	end
	cellpfb.transform:SetParent(self.layoutCtrl.transform,false);
	cellpfb.name = cName;
	return cellpfb;
end

function ListCtrl:SetEmptyDatas(num)
	self:RemoveAll()
	for i=1,num do
		self:AddCell(nil)
	end
end

function ListCtrl:ResetDatas(datas,removeOther,isLayOut)
	removeOther = removeOther or true
	if(isLayOut==nil) then isLayOut = true end
	local currentNum = #self.cells
	local newNum = 0
	if(datas~=nil)then
		newNum = #datas
	end
	local delta = newNum - currentNum

	if(delta>0) then
		for i=1,delta do
			self:AddCell(nil)
			-- self:AddCell(datas[i+currentNum])
		end
	elseif(delta<0 and removeOther)then
		for i=1,-delta do
			self:RemoveCell(1)
		end
	end
	
	--update
	for i=1,newNum do
		self:UpdateCell(i,datas[i])
	end
	for i=newNum+1,#self.cells do
		self:UpdateCell(i,nil,true)
	end
	if(isLayOut)then
		self:Layout()
	end

	if self.disableDragPfbNum then
		self.scrollView.enabled = newNum > self.disableDragPfbNum
	end
end

function ListCtrl:AddCell(cellData,index)
	index = index or 0
	local cell = self:LoadCellPfb(self.cellPfb.."_")
	local cellCtrl = self.cellCtrl.new(cell)
	-- cellCtrl.gameObject = cell
	if(index>0 and index < #self.cells) then
		table.insert( self.cells,index, cellCtrl )
	else
		table.insert( self.cells, cellCtrl )
	end
	-- cellCtrl:AddEventListener(MouseEvent.MouseClick,self.ClickHandler,self)
	if(cellData~=nil) then
		cellCtrl:SetData(cellData)
	end
	if(self.addCellHandler~=nil) then
		local func = self.addCellHandler.func
		local owner = self.addCellHandler.owner
		func(owner or self,cellCtrl)
	end
	self:CellAddEventListener(cellCtrl)
	return cellCtrl
end

-- function ListCtrl:ClickHandler(obj)
-- 	self:PassEvent(MouseEvent.MouseClick,obj)
-- end

function ListCtrl:RemoveCell(index)
	if(index<= #self.cells) then
		local cellCtrl = table.remove(self.cells,index)
		cellCtrl:ClearEvent()
		-- GameObject.Destroy(cellCtrl.gameObject);
		if(cellCtrl.OnRemove) then
			cellCtrl:OnRemove()
		end
		GameObject.DestroyImmediate(cellCtrl.gameObject);
		
		cellCtrl = nil
	end
	-- body
end

function ListCtrl:RemoveAll()
	for i=1,#self.cells do
		local cellCtrl = self.cells[i]
		cellCtrl:ClearEvent()
		GameObject.DestroyImmediate(cellCtrl.gameObject);
		cellCtrl = nil
	end
	self.cells = {}
end

function ListCtrl:UpdateCell(index,data,forceNewData)
	if(self.reverse) then index = #self.cells - index + 1 end
	local cellCtrl = self.cells[index]
	if(cellCtrl ~=nil) then
		if(not forceNewData and not data) then
			data = cellCtrl.data
		end
		cellCtrl.indexInList = index
		cellCtrl:SetData(data)
	end
end

function ListCtrl:GetCells()
	return self.cells
end

function ListCtrl:FindCellByData(data)
	for i=1,#self.cells do
		if(self.cells[i].data==data) then
			return self.cells[i],i
		end
	end
	return nil,0
end

function ListCtrl:UpdateCells()
	-- body
end

function ListCtrl:Layout()
	if self.layoutCtrl.Reposition then
		self.layoutCtrl:Reposition()
	end
end

function ListCtrl:SetDisableDragIfFit()
	self.scrollView = GameObjectUtil.Instance:FindCompInParents(self.layoutCtrl.gameObject, UIScrollView)
	self.panel = self.scrollView:GetComponent(UIPanel)

	if self.panel.isAnchored then
		local originalAnchor = self.panel.updateAnchors
		self.panel.updateAnchors = 0

		self.panel:ResetAndUpdateAnchors()

		self.panel.updateAnchors = originalAnchor
	end

	local size = self.panel:GetViewSize()
	local cellLength
	if self.layoutCtrl.arrangement == 1 then
		self.viewLength = size.y
		cellLength = self.layoutCtrl.cellHeight
	elseif self.layoutCtrl.arrangement == 0 then
		self.viewLength = size.x
		cellLength = self.layoutCtrl.cellWidth
	end

	if cellLength then
		self.disableDragPfbNum = math.floor(self.viewLength/cellLength)
	end
end