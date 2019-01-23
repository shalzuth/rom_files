
CreatureUIManager = class("CreatureUIManager")
local uiAssetManager
local ArrayClearWithCount = TableUtility.ArrayClearWithCount
function CreatureUIManager:ctor()
	self.waitQueue = {};

	self.frameLoadCount = 1;
	-- set global objects
	uiAssetManager = Game.AssetManager_UI
end

function CreatureUIManager:Update(time, deltaTime)
	for i=1,self.frameLoadCount do
		if(#self.waitQueue > 0)then
			local loadData = table.remove(self.waitQueue, 1);
			if(loadData)then
				self:_CreateUIAsset(loadData[2], loadData[3], loadData[4], loadData[5], loadData[6]);
				if(type(loadData[7]) == "function")then
					loadData[7]( loadData[5] );
				end
				self:DestroyArray( loadData );
			end
		end
	end
end

function CreatureUIManager:_CreateUIAsset( resourceId, parent, call, callArgs ,useMovePool)
	local asset = nil
	if(useMovePool) then
		asset = uiAssetManager:CreateSceneUIAssetOpimized(resourceId, parent);
	else
		asset = uiAssetManager:CreateSceneUIAsset(resourceId, parent);
	end
	if(call)then
		call( asset, callArgs );
	end
end

function CreatureUIManager:AsyncCreateUIAsset( creatureId, resourceId, parent, call, callArgs, argsDeleter,useMovePool)
	local data = ReusableTable.CreateArray();
	data[1] = creatureId;
	data[2] = resourceId;
	data[3] = parent;
	data[4] = call;
	data[5] = callArgs;
	if useMovePool == nil then
		useMovePool = false
	end
	data[6] = useMovePool;
	data[7] = argsDeleter;
	table.insert(self.waitQueue, data);
end

function CreatureUIManager:RemoveCreatureWaitUI( creatureId, resourceId )
	for i=#self.waitQueue, 1, -1 do
		local data = self.waitQueue[i];
		if(data)then
			if(data[1] == creatureId and data[2] == resourceId)then
				local data = table.remove(self.waitQueue, i);
				if(type(data[7]) == "function")then
					data[7]( data[5] );
				end
				self:DestroyArray( data );
			end
		end
	end
end

function CreatureUIManager:DestroyArray(arr)
	ArrayClearWithCount(arr, 7)
	ReusableTable.DestroyAndClearArray( arr );
end






