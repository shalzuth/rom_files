autoImport("EventDispatcher")
EventManager = class("EventManager",EventDispatcher)

function EventManager.Me()
	if(EventManager.me == nil) then
		EventManager.me = EventManager.new()
	end
	return EventManager.me
end