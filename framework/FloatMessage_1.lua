autoImport("PushBaseCell")
autoImport("SpriteLabel")
FloatMessage = class("FloatMessage", PushBaseCell)
FloatMessage.resID = ResourcePathHelper.UICell("FloatMessage")
function FloatMessage:ctor(parent)
  self.speed = 300
  self.previous = nil
  self.follow = nil
  self.floating = false
  self.targetY = 0
  self.gameObject = self:CreateObj(parent)
  self:Init()
end
function FloatMessage:Init()
  self.msg = self:FindGO("MessageContent"):GetComponent(UILabel)
  self.spriteLabel = SpriteLabel.CreateAsTable()
  self.spriteLabel:Init(self.msg, nil, 30, 30)
  self.bg = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "Bg"):GetComponent(UISprite)
end
function FloatMessage:CreateObj(parent)
  return Game.AssetManager_UI:CreateAsset(FloatMessage.resID, parent)
end
function FloatMessage:Destroy()
  self.data = nil
  if self.spriteLabel then
    self.spriteLabel:Destroy()
    self.spriteLabel = nil
  end
  Game.GOLuaPoolManager:AddToUIPool(FloatMessage.resID, self.gameObject)
end
function FloatMessage:SetY(y)
  local pos = self.gameObject.transform.localPosition
  pos.y = y
  self.gameObject.transform.localPosition = pos
end
function FloatMessage:GetY()
  local x, y, z = LuaGameObject.GetLocalPosition(self.gameObject.transform)
  return y
end
function FloatMessage:GetH()
  return self.bg.height
end
function FloatMessage:_SetText(text)
  text = simpleReplace(text)
  if self.spriteLabel then
    self.spriteLabel:SetText(text, false)
  else
    self.msg.text = text
  end
end
function FloatMessage:_AddSprites()
  if self.spriteLabel then
    self.spriteLabel:AddSprites()
  end
  self:ResetBgWidthHeight()
end
function FloatMessage:SetMsg(text)
  self:_SetText(text)
  UIUtil.FitLabelLine(self.msg)
  self:_AddSprites()
end
function FloatMessage:SetMsgCenterAlign(text)
  self:_SetText(text)
  UIUtil.CenterLabelLine(self.msg)
  self:_AddSprites()
end
function FloatMessage:ResetBgWidthHeight()
  self.bg.width = self.msg.width + 78
  self.bg.height = self.msg.height + 57
end
function FloatMessage:Parsed()
  return self.data == nil or self.data.parsed == true
end
function FloatMessage:NextToPush()
  self.data.parsed = true
  if self.data.params ~= nil and type(self.data.params) == "table" then
    self.data.text = MsgParserProxy.Instance:TryParse(self.data.text, unpack(self.data.params))
  else
    self.data.text = MsgParserProxy.Instance:TryParse(self.data.text, self.data.params)
  end
  self:SetMsg(self.data.text)
end
