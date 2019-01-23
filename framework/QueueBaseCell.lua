local baseCell = autoImport("BaseCell")
QueueBaseCell = class("QueueBaseCell", baseCell);

QueueBaseCell.EXIT = "QueueBaseCell.EXIT";

QueueBaseCell.offset = Vector3(0,0);

function QueueBaseCell:Init()
end

function QueueBaseCell:Enter()
end

function QueueBaseCell:Exit()
	self:PassEvent(QueueBaseCell.EXIT, self);
end

function QueueBaseCell:Move()
end

function QueueBaseCell:SetPos(pos)
	if(self.gameObject and pos)then
		local x = pos.x or pos[1];
		x = x or 0;
		local y = pos.y or pos[2];
		y = y or 0;
		local z = pos.z or pos[3];
		z = z or 0;
		self.gameObject.transform.localPosition = Vector3(x,y,z);
	end
end
