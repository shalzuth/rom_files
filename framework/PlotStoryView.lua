autoImport("BaseView");
PlotStoryView = class("PlotStoryView", BaseView)

PlotStoryView.ViewType = UIViewType.NormalLayer

autoImport("NormalButtonCell")

local tempPos = LuaVector3();

function PlotStoryView:Init()
	self.collider = self:FindGO("Collider");
	
	self.buttonMap = {};

	self:MapEvent();
end

function PlotStoryView:OnEnter()
	PlotStoryView.super.OnEnter(self);
end

function PlotStoryView:OnExit()
	PlotStoryView.super.OnExit(self);
end

function PlotStoryView:AddButton( buttonData )
	if(not buttonData or not buttonData.clickEvent)then
		return;
	end

	local cellData = {};
	cellData.id = buttonData.id;
	cellData.event = function ()
		buttonData.clickEvent(buttonData.clickEventParam, buttonData);
		if(buttonData.removeWhenClick)then
			self:RemoveButton(cellData.id);
		end
	end
	cellData.text = buttonData.text;

	local buttonCell = self.buttonMap[buttonData.id];
	if(not buttonCell)then
		buttonCell = NormalButtonCell.new( NormalButtonCell.CreateButton(self.gameObject) );
		self.buttonMap[buttonData.id] = buttonCell;
	end
	buttonCell:SetData(cellData);

	local go = buttonCell.gameObject;
	if(buttonData.pos)then
		tempPos:Set(buttonData.pos[1], buttonData.pos[2], buttonData.pos[3]);
	else
		tempPos:Set(450, -250 , 0);
	end
	go.transform.localPosition = tempPos;
end

function PlotStoryView:RemoveButton( buttonId )
	if(not buttonId)then
		return;
	end

	local cell = self.buttonMap[buttonId];
	if(cell and not Slua.IsNull(cell.gameObject))then
		GameObject.Destroy(cell.gameObject);
	end

	self.buttonMap[buttonId] = nil;
end

function PlotStoryView:MapEvent()
	self:AddListenEvt(PlotStoryViewEvent.AddButton, self.HandleAddButton);
end

function PlotStoryView:HandleAddButton(note)
	self:AddButton( note.body );
end




