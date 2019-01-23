QueueWaitCtrl = reusableClass("QueueWaitCtrl");

QueueWaitCtrl.PoolSize = 20;

autoImport("QueueBaseCell");

function QueueWaitCtrl:AddCell(cell, delay)
	cell:AddEventListener(QueueBaseCell.EXIT, self.CellExit, self);

	if(#self.excutequeue < self.maxNum)then
		delay = delay or 0;
		if(#self.excutequeue~=0)then
			self:DelayCall(delay, function ()
				self:CellEnter(cell);
			end);
		else
			self:CellEnter(cell);
		end
	else
		table.insert(self.waitqueue, cell);
	end
end

function QueueWaitCtrl:CellEnter(cell)
	for k,v in pairs(self.excutequeue) do
		v:Move();
	end
	table.insert(self.excutequeue, cell);
	cell:Enter();
	cell:SetData()
end

function QueueWaitCtrl:CellExit()
	table.remove(self.excutequeue, 1);

	if(#self.waitqueue>0)then
		local cell = self.waitqueue[1];
		table.remove(self.waitqueue, 1);

		self:CellEnter(cell);
	end
end

function QueueWaitCtrl:DelayCall(time, func)
	if(time and func)then
		table.insert(self.delayqueue, {time, func} );
	end

	if(#self.delayqueue == 0)then
		return;
	end

	if(not self.waitting)then
		local delayData = table.remove(self.delayqueue, 1);
		if(delayData[1] > 0)then
			self.waitting = true;
			self.lt = LeanTween.delayedCall(delayData[1], function ()
				if(delayData[2])then
					delayData[2]();
				end

				self:RemoveLeanTween();
				self:DelayCall();
			end)
		elseif(delayData[1] == 0)then
			delayData[2]();
			self:DelayCall();
		end
	end
end

function QueueWaitCtrl:RemoveLeanTween()
	if(self.lt)then
		self.lt:cancel();
	end
	self.lt = nil;
	self.waitting = false;
end

function QueueWaitCtrl:Clear()
	TableUtility.TableClear(self.waitqueue);
	TableUtility.TableClear(self.excutequeue);
	TableUtility.TableClear(self.delayqueue);

	self:RemoveLeanTween();
end

-- override begin
function QueueWaitCtrl:DoConstruct(asArray, maxNum)
	self.maxNum = maxNum;

	self.waitqueue = {};
	self.excutequeue = {};
	self.delayqueue = {};
end

function QueueWaitCtrl:DoDeconstruct(asArray)
	self.maxNum = 0;

	self:Clear();
end
-- override end


TimeTickQueueExcuteCtrl = reusableClass("TimeTickQueueExcuteCtrl");

TimeTickQueueExcuteCtrl.PoolSize = 20;

function TimeTickQueueExcuteCtrl:CreateTimeTick()
	TimeTickManager.Me():CreateTick(0,self.args[2],self.Tick,self,1)
end

local tableRemove = table.remove
function TimeTickQueueExcuteCtrl:Tick(deltaTime)
	local excutequeue = self.excutequeue
	if(#excutequeue>0) then
		self.isBusy = true
		local data = tableRemove(excutequeue,1)
		self.args[3](data,self.args[4])
	else
		self.isBusy = false
	end
end

function TimeTickQueueExcuteCtrl:Add(data)
	self.excutequeue[#self.excutequeue+1] = data
	if(not self.isBusy) then
		self:Tick(0)
	end
end

-- override begin
--params[1] maxnum
--params[2] interval
--params[3] excuteCall
--params[4] callParam1
function TimeTickQueueExcuteCtrl:DoConstruct(asArray, params)
	self.args = {}
	self.args[1] = params[1]
	self.args[2] = params[2]
	self.args[3] = params[3]
	self.args[4] = params[4]
	Debug_Assert(self.args[3]~=nil, "TimeTickQueueExcuteCtrl excuteFunc CANNOT be nil!!!")
	self.isBusy = false

	self.excutequeue = {};

	self:CreateTimeTick()
end

function TimeTickQueueExcuteCtrl:DoDeconstruct(asArray)
	self.args[1] = nil
	self.args[2] = nil
	self.args[3] = nil
	self.args[4] = nil
	self.isBusy = false

	self:Clear();

	TimeTickManager.Me():ClearTick(self,1)
end
-- override end

function TimeTickQueueExcuteCtrl:Clear()
	TableUtility.TableClear(self.excutequeue);
end