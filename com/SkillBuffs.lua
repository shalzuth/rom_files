autoImport("SkillBuffOwner")
SkillBuffs = class("SkillBuffs")
function SkillBuffs:ctor()
  self.buffOwner = {}
end
function SkillBuffs:GetOwner(buffOwner)
  local owner
  if buffOwner then
    owner = self.buffOwner[buffOwner]
    if not owner then
      owner = SkillBuffOwner.new(buffOwner)
      self.buffOwner[buffOwner] = owner
    end
  end
  return owner
end
function SkillBuffs:Add(id, buffOwner, paramType, key)
  local owner = self:GetOwner(buffOwner)
  if owner then
    owner:Add(id, paramType, key)
  end
end
function SkillBuffs:Remove(id, buffOwner, paramType, key)
  local owner = self:GetOwner(buffOwner)
  if owner then
    owner:Remove(id, paramType, key)
  end
end
function SkillBuffs:Dispose()
  self.buffOwner = nil
end
