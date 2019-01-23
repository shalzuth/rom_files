BaseCell = class("BaseCell", CoreView)

function BaseCell:ctor(obj)
	BaseCell.super.ctor(self, obj);
	
	self:Init();
end

function BaseCell:Init()
end

function BaseCell:AddCellClickEvent()
	self:SetEvent(self.gameObject, function ()
		self:PassEvent(MouseEvent.MouseClick, self);
	end);
end

function BaseCell:AddCellDoubleClickEvt()
	self:SetDoubleClick(self.gameObject, function ()
		self:PassEvent(MouseEvent.DoubleClick, self);
	end);
end

function BaseCell:SetData(obj)
end

function BaseCell:SetEvent(evtObj,event,hideSound)
	self:AddClickEvent(evtObj,event,hideSound);
end

function BaseCell:SetDoubleClick(evtObj, event)
	self:AddDoubleClickEvent(evtObj, event);
end

function BaseCell:SetPress(evtObj, event)
	self:AddPressEvent(evtObj, event);
end

function BaseCell:SetActive(obj, state)
	if(obj)then
		obj.gameObject:SetActive(state);
		return true;
	end
	return false;
end

function BaseCell:FindChild(name, parent)
	parent = parent or self.gameObject;
	return GameObjectUtil.Instance:DeepFindChild(parent, name);
end

function BaseCell:CreateObj(path, parent)
	if(not GameObjectUtil.Instance:ObjectIsNULL(parent))then
		local obj = Game.AssetManager_UI:CreateAsset(path, parent);
		if(not obj)then
			return;
		end
		obj:SetActive(true);
		GameObjectUtil.Instance:ChangeLayersRecursively(obj ,parent.layer);
		obj.transform.localPosition = Vector3.zero
		obj.transform.localScale = Vector3.one;
		obj.transform.localRotation = Quaternion.identity;
		return obj;
	end
end

function BaseCell:ObjIsNil(obj)
	return GameObjectUtil.Instance:ObjectIsNULL(obj);
end

function BaseCell:Notify(eventName,body,type)
	GameFacade.Instance:sendNotification(eventName,body,type);
end

return BaseCell;