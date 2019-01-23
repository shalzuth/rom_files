BaseTip = class("BaseTip", CoreView)

function BaseTip:ctor(prefab,parent)
	self.resID = nil
	if(prefab~=nil and type(prefab)=="string") then
		self.resID = ResourcePathHelper.UITip(prefab)
		local go = Game.AssetManager_UI:CreateAsset(self.resID, parent);
		if(go == nil) then
			error ("can not find tipPrefab "..prefab)
		end
		self.gameObject = go
	else
		self.gameObject = prefab;
	end
	self:Init()
end

function BaseTip:Init() end

function BaseTip:OnEnter()
end

function BaseTip:OnExit()
	return true
end

function BaseTip:DestroySelf()
	if(self.resID~=nil) then
		Game.GOLuaPoolManager:AddToUIPool(self.resID,self.gameObject)
	else
		GameObject.Destroy(self.gameObject)
	end	
end

function BaseTip:SetPos(pos)
	if(self.gameObject~=nil) then
		local p = self.gameObject.transform.position
		pos.z = p.z
		self.gameObject.transform.position = pos
		self.pos = self.gameObject.transform.localPosition
	else
		self.pos = pos
	end
end

function BaseTip:SetData(data)
	-- body
end