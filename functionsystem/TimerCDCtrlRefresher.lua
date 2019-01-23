autoImport("FunctionCD")
-- autoImport("CDCtrlRefresher")

TimerCDCtrlRefresher = class("TimerCDCtrlRefresher",FunctionCD)

function TimerCDCtrlRefresher:ctor( interval )
	TimerCDCtrlRefresher.super.ctor(self,interval)
	self:Reset()
	self:SetEnable(true)
end

function TimerCDCtrlRefresher:Add(cell)
	if(cell.data and cell.gameObject) then
		self.objs[cell] = cell
	else
		error("cd刷新ctrl类中的元素未找到id")
	end
end

function TimerCDCtrlRefresher:Remove(cell)
	if(cell and cell.gameObject) then
		local removed = self.objs[cell]
		if(removed and removed.ClearCD) then
			removed:ClearCD()
		end
	end
	self.objs[cell] = nil
end

function TimerCDCtrlRefresher:RemoveAll()
	for k,v in pairs(self.objs) do
		self:Remove(v)
	end
	TimerCDCtrlRefresher.super.RemoveAll(self)
end

function TimerCDCtrlRefresher:Update(deltaTime)
	local now,max,f
	for k,v in pairs(self.objs) do
		now = v:GetCD()
		max = v:GetMaxCD()
		-- print(now,max)
		f=0
		if(max~=0) then
			f = now/max
		end
		if(v:RefreshCD(f) or now == 0) then
			self.objs[k] = nil
		end
	end
end

ShotCutSkillCDRefresher = class("ShotCutSkillCDRefresher",TimerCDCtrlRefresher)