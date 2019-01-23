AttributePointSolutionView = class("AttributePointSolutionView",SubView)
autoImport("AttributePointSolutionCell")

AttributePointSolutionView.SelectCell = "AttributePointSolutionCell_Select"

AttributePointSolutionView.config = 
{
	{textOutlineColor = Color(41/255,105/255,0,1),descColor = Color(49/255,138/255,11/255,1) ,textBg = "persona_bg_1",descBg = "persona_bg_1c",bg = "persona_bg_1b"},
	{textOutlineColor = Color(38/255,62/255,140/255,1),descColor = Color(31/255,116/255,191/255,1) ,textBg = "persona_bg_2",descBg = "persona_bg_2c",bg = "persona_bg_2b"},
	{textOutlineColor = Color(116/255,4/255,4/255,1),descColor = Color(165/255,41/255,39/255,1) ,textBg = "persona_bg_3",descBg = "persona_bg_3c",bg = "persona_bg_3b"},
}
function AttributePointSolutionView:Init()
	self:initView()
	self:addViewEventListener()
	self:resetprofession()
	self:AddListenEvts()
end

function AttributePointSolutionView:initView(  )
	-- body
	self.gameObject = self:FindChild("AttributePointSolutionView")
	local grid = self:FindChild("Grid"):GetComponent(UIGrid)
	self.gridList = UIGridListCtrl.new(grid,AttributePointSolutionCell,"AttributePointSolutionCell")	
	local titleLabel = self:FindGO("titleLabel"):GetComponent(UILabel)
	titleLabel.text = ZhString.Charactor_TitleLabel
	local tipsLabel = self:FindGO("tipsLabel"):GetComponent(UILabel)
	tipsLabel.text = ZhString.Charactor_ProfessionTipText

end

function AttributePointSolutionView:resetprofession(  )
	-- body
	local nowOcc = Game.Myself.data:GetCurOcc();
	if(nowOcc~=nil)then
		local prodata = Table_Class[nowOcc.profession]; 
		local datas = prodata.AddPointSolution
		self.gridList:ResetDatas(datas)
	end
end

function AttributePointSolutionView:AddListenEvts(  )
	-- body
	self:AddListenEvt(MyselfEvent.MyProfessionChange, self.resetprofession)	
end

function AttributePointSolutionView:addViewEventListener(  )
	-- body
	self.gridList:AddEventListener(MouseEvent.MouseClick,self.ClickHandler,self)
end

function AttributePointSolutionView:ClickHandler( obj)
	-- body
	self:PassEvent(AttributePointSolutionView.SelectCell,obj.data)
end

