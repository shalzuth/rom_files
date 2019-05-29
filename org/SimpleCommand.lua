local Notifier = import("..observer.Notifier")
local SimpleCommand = class("SimpleCommand", Notifier)
function SimpleCommand:ctor()
  SimpleCommand.super.ctor(self)
end
function SimpleCommand:execute(notification)
end
return SimpleCommand
