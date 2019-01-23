autoImport("FunctionCD")

CDCtrlRefresher = class("CDCtrlRefresher",FunctionCD)

function CDCtrlRefresher:Add(obj)
	local id = obj.id
	if(not id and obj.data) then
		id = obj.data.id
	end
	if(id) then
		self.objs[obj.data.id] = obj
	else
		error("cd刷新ctrl类中的元素未找到id")
	end
end

function CDCtrlRefresher:Remove(obj)
	if(obj and obj.data and type(obj) == "table") then
		obj = obj.data.id
	end
	self.objs[obj] = nil
end

LeanTweenCDCellRefresher = class("LeanTweenCDCellRefresher",FunctionCD)

function LeanTweenCDCellRefresher:ctor( interval )
	self:Reset()
end

function LeanTweenCDCellRefresher:Add(cell)
	if(cell.gameObject) then
		local cding = self.objs[cell]
		self:RemoveLeanTween(cell.gameObject)
		if(cding) then
			self:RemoveLeanTween(cding.gameObject)
		end
		self.objs[cell] = cell
		local now = cell:GetCD()
		local max = cell:GetMaxCD()

		if(now == nil)then
			return;
		end
		if(max == nil or max == 0)then
			return;
		end
		-- print(cell:GetCD())
		LeanTween.value (cell.gameObject, function (f)
			if(cell:RefreshCD(f)) then
				self:Remove(cell)
			end
		end, now/max, 0, now):setOnComplete (function ()
			self:Remove(cell)
		end);
	else
		error("cd刷新ctrl类中的元素未找到id")
	end
end

function LeanTweenCDCellRefresher:Remove(cell)
	if(cell and cell.gameObject) then
		self:RemoveLeanTween(cell.gameObject)
		local removed = self.objs[cell]
		if(removed and removed.ClearCD) then
			self:RemoveLeanTween(removed.gameObject)
			removed:ClearCD()
		end
	end
	self.objs[cell] = nil
end

function LeanTweenCDCellRefresher:RemoveAll()
	for k,v in pairs(self.objs) do
		self:Remove(v)
	end
	LeanTweenCDCellRefresher.super.RemoveAll(self)
end

function LeanTweenCDCellRefresher:RemoveLeanTween(go)
	if(not GameObjectUtil.Instance:ObjectIsNULL(go)) then
		LeanTween.cancel(go)
	end
end

BagCDRefresher = class("BagCDRefresher",LeanTweenCDCellRefresher)
ShotCutItemCDRefresher = class("ShotCutItemCDRefresher",LeanTweenCDCellRefresher)