-- client prop begin
function NCreatureWithPropUserdata:Client_NoMove(v)
	local p = self.data:AddClientProp("NoMove", v and 1 or -1)
	self.data.noMove = self.data:PlusClientProp(p)
end

function NCreatureWithPropUserdata:Client_NoAttack(v)
	local p = self.data:AddClientProp("NoAttack", v and 1 or -1)
	self.data.noAttack = self.data:PlusClientProp(p)
end

function NCreatureWithPropUserdata:Client_NoAttacked(v)
	local p = self.data:AddClientProp("NoAttacked", v and 1 or -1)
	self.data.noAttacked = self.data:PlusClientProp(p)
end
-- client prop end