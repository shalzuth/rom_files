local Notifier = import("..observer.Notifier")
local MacroCommand = class("MacroCommand", Notifier)
function MacroCommand:ctor()
  MacroCommand.super.ctor(self)
  self.subCommands = {}
  self:initializeMacroCommand()
end
function MacroCommand:initializeMacroCommand()
end
function MacroCommand:addSubCommand(commandClassRef)
  table.insert(self.subCommands, commandClassRef)
end
function MacroCommand:execute(note)
  while #self.subCommands > 0 do
    local ref = table.remove(self.subCommands, 1)
    local cmd = ref.new()
    cmd:initializeNotifier(self.multitonKey)
    cmd:execute(note)
  end
end
return MacroCommand
