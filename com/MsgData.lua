MsgData = class("MsgData")

function MsgData:ctor(title,text,params)
	self.title = title
	self.text = text
	self.params = params
	self.parsed = false
end