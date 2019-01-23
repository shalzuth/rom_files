autoImport("WrapScrollView")

WrapScrollViewHelper = class("WrapScrollViewHelper")

local tempVec = LuaVector3.zero

function WrapScrollViewHelper:ctor(control, cellRid, scrollViewObj, tableObj, maxShowNum, onMoveCallBack)
	self.scrollView = scrollViewObj:GetComponent(UIScrollView)
	self.table = tableObj:GetComponent(UITable)
	self.maxShowNum = maxShowNum

	self.cellCtrlMap = {}
	for i=1,maxShowNum do
		local obj = self:LoadCellPfb(cellRid)
		local cellCtrl = control.new(obj)
		local name = obj.name..i
		obj.name = name
		tempVec:Set(0, -i, 0)
		obj.transform.localPosition = tempVec

		self.cellCtrlMap[name] = cellCtrl
	end

	self.wrapScrollView = WrapScrollView.new(self.scrollView, self.table)

	local activeH = GameObjectUtil.Instance:GetUIActiveHeight(self.scrollView.gameObject)
	local topOffSetValue = 300 * activeH / 720
	local bottomOffSetValue = 600 * activeH / 720
	self.wrapScrollView:Init(maxShowNum, 0, topOffSetValue, bottomOffSetValue)
	self.wrapScrollView.onInitializeItem = function (name, index)
		local cellCtrl = self.cellCtrlMap[name]
		if cellCtrl then
			cellCtrl:SetData( self.data[index] )
		end
	end
	self.wrapScrollView.onMoveCallBack = onMoveCallBack

	-- local scrollView = self.scrollView
	-- scrollView:Init(maxShowNum, 0, tableObj.transform)
	-- scrollView.mTopOffSetValue = 300
	-- scrollView.mBottomOffSetValue = 600
	-- scrollView.onInitializeItem = function (name, index)
	-- 	local cellCtrl = self.cellCtrlMap[name]
	-- 	if cellCtrl then
	-- 		cellCtrl:SetData( self.data[index + 1] )
	-- 	end
	-- end
end

function WrapScrollViewHelper:UpdateInfo(datas, isLock)
	-- helplog("UpdateInfo")
	self.data = datas

	local lastDataCount = self.dataCount
	self.dataCount = #datas
	if not isLock then
		-- self.scrollView:RefeshPosByIndex(totalCount - 1)
		self.wrapScrollView:RefreshPosByIndex(self.dataCount)
		self.wrapScrollView:SetIndex(self.dataCount)
	elseif lastDataCount and lastDataCount ~= 0 and lastDataCount == self.dataCount then
		self.wrapScrollView:SelfMinusIndex()
	end
	-- self.scrollView.mTotalCount = totalCount
	self.wrapScrollView:SetTotalCount(self.dataCount)
end

function WrapScrollViewHelper:ResetPosition(datas)
	-- helplog("ResetPosition")
	self.data = datas

	self.dataCount = #datas
	-- local scrollView = self.scrollView
	-- scrollView:SetIndex(totalCount - 1)
	-- scrollView:RefeshByIndex(totalCount - 1)
	
	self.wrapScrollView:RefreshByIndex(self.dataCount)
	self.wrapScrollView:SetIndex(self.dataCount)
	self.wrapScrollView:SetTotalCount(self.dataCount)
	
	self.table:Reposition()
	self.scrollView:ResetPosition()
end

function WrapScrollViewHelper:AddEventListener(eventType, handler, handlerOwner)
	for k,v in pairs(self.cellCtrlMap) do
		v:AddEventListener(eventType, handler, handlerOwner)
	end
end

function WrapScrollViewHelper:GetIsMoveToFirst()
	-- local first = self.scrollView.mCurrentComList[0]
	local first = self.wrapScrollView.currentList[1]
	local cellCtrl = self.cellCtrlMap[first.gameObject.name]
	if cellCtrl then
		return cellCtrl:CheckMoveToFirst()
	end
end

function WrapScrollViewHelper:LoadCellPfb(cellRid)
	local cellpfb = Game.AssetManager_UI:CreateAsset(cellRid)
	if(cellpfb == nil) then
		error ("can not find cellpfb"..cName)
	end
	cellpfb.transform:SetParent(self.table.transform,false)
	cellpfb.transform.localScale = LuaVector3.one
	return cellpfb
end

function WrapScrollViewHelper:GetCells()
	return self.cellCtrlMap
end