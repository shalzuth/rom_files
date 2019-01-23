local BaseCell = autoImport("BaseCell");
TempActivityCell = class("TempActivityCell", BaseCell)

TempActivityEvent = {
	ClickButton1 = "TempActivityEvent_ClickButton1",
	ClickButton2 = "TempActivityEvent_ClickButton2",
}

function TempActivityCell:Init()
	self.button1 = self:FindGO("Button1");
	self.button1lab = self:FindComponent("Label", UILabel, self.button1);
	self:AddClickEvent(self.button1, function (go)
		self:PassEvent(TempActivityEvent.ClickButton1, self);
	end);

	self.buttonGrid = self:FindComponent("ButtonGrid", UIGrid);
	self.button2 = self:FindGO("Button2");
	self.button2lab = self:FindComponent("Label", UILabel, self.button2);
	self:AddClickEvent(self.button2, function (go)
		if(self.url~=nil and self.url~="") then
			Application.OpenURL(self.url);
		end
		
		self:PassEvent(TempActivityEvent.ClickButton2, self);
	end);

	self.context = self:FindComponent("Context", UILabel);
	self.title = self:FindComponent("Title", UILabel);
end

function TempActivityCell:SetData(config)
	if(not config)then
		return;
	end
	
	self.config = config;
	local params = config.Params;
	if(params)then
		self.title.text = params.Title;
		self.context.text = params.Text;
		
		if(params.OfficialUrl)then
			self.url = params.OfficialUrl;

			self.button1:SetActive(true);
			if(type(params.Button1Str) == "string")then
				self.button1lab.text = params.Button1Str;
			end
			
			if(type(params.Button2Str) == "string")then
				self.button2lab.text = params.Button2Str;
			end
		else
			if(type(params.Button1Str) == "string")then
				self.button1:SetActive(true);
				self.button1lab.text = params.Button1Str;
			else
				self.button1:SetActive(false);
			end

			if(type(params.Button2Str) == "string")then
				self.button2lab.text = params.Button2Str;
			end
		end
		self.buttonGrid:Reposition();
	end
end

