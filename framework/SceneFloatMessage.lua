SceneFloatMessage = reusableClass("SceneFloatMessage")
SceneFloatMessage.PoolSize = 20
SceneFloatMessageType = {
  Text = "SceneFloatMessageType_Text",
  Exp = "SceneFloatMessageType_Exp",
  Item = "SceneFloatMessageType_Item"
}
SceneFloatMessage.LabelColor = {
  Text = {
    LuaColor.New(0.7372549019607844, 0.7372549019607844, 0.7372549019607844),
    LuaColor.New(0.11764705882352941, 0.11764705882352941, 0.11764705882352941)
  },
  Exp = {
    LuaColor.New(0.8627450980392157, 0.6352941176470588, 0.4823529411764706),
    LuaColor.New(0.23921568627450981, 0.15294117647058825, 0.09803921568627451)
  },
  Item = {
    {
      LuaColor.New(0.7372549019607844, 0.7372549019607844, 0.7372549019607844),
      LuaColor.New(0.07058823529411765, 0.10588235294117647, 0.11372549019607843)
    },
    {
      LuaColor.New(0.396078431372549, 0.9921568627450981, 0.8627450980392157),
      LuaColor.New(0.10588235294117647, 0.20784313725490197, 0.08627450980392157)
    },
    {
      LuaColor.New(0.3254901960784314, 0.7725490196078432, 1.0),
      LuaColor.New(0.10588235294117647, 0.09803921568627451, 0.21176470588235294)
    },
    {
      LuaColor.New(0.788235294117647, 0.32941176470588235, 1.0),
      LuaColor.New(0.01568627450980392, 0.08235294117647059, 0.21176470588235294)
    },
    {
      LuaColor.New(1.0, 0.7254901960784313, 0.19215686274509805),
      LuaColor.New(0.2549019607843137, 0.15294117647058825, 0.023529411764705882)
    }
  }
}
SceneFloatMessage.ResID = ResourcePathHelper.UICell("SceneFloatMessage")
local tempRot = LuaQuaternion.Euler(0, 0, 0, 0)
local tempV3 = LuaVector3()
function SceneFloatMessage:CreatePerfab(parent)
  local obj = Game.AssetManager_UI:CreateSceneUIAsset(SceneFloatMessage.ResID, parent)
  if obj then
    obj:GetComponent(Animator):Play("SceneFloatMessage", -1, 0)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    local randomZ = math.random(-10, 10)
    tempV3:Set(0, 0, randomZ)
    tempRot.eulerAngles = tempV3
    obj.transform.localRotation = tempRot
    return obj
  end
end
function SceneFloatMessage:RefreshInfo()
  if Slua.IsNull(self.msglabel) then
    return
  end
  local dtype = self.data_dtype
  local color1, color2
  if dtype and dtype == SceneFloatMessageType.Exp then
    color1 = SceneFloatMessage.LabelColor.Exp[1]
    color2 = SceneFloatMessage.LabelColor.Exp[2]
  else
    color1 = SceneFloatMessage.LabelColor.Text[1]
    color2 = SceneFloatMessage.LabelColor.Text[2]
  end
  self.msglabel.gradientBottom = color1
  self.msglabel.effectColor = color2
  local msg = self.data_msg
  local param = self.data_param
  local msgText = msg
  if type(param) == "table" then
    msgText = MsgParserProxy.Instance:TryParse(msgText, unpack(param))
  end
  self.spriteLabel:SetText(msgText, false)
end
function SceneFloatMessage:Active(b)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    self.gameObject:SetActive(b)
  end
end
function SceneFloatMessage:RemoveLeanTween()
  if self.lt then
    self.lt:cancel()
  end
  self.lt = nil
end
function SceneFloatMessage:DoConstruct(asArray, param)
  self.data_dtype = param[2]
  self.data_msg = param[3]
  self.data_param = param[4]
  self.gameObject = self:CreatePerfab(param[1])
  if not Slua.IsNull(self.gameObject) then
    self.msglabel = self.gameObject:GetComponentInChildren(UILabel)
    self.spriteLabel = SpriteLabel.new(self.msglabel, 500, 30, 30)
  end
  self:RefreshInfo()
  self:RemoveLeanTween()
  self.lt = LeanTween.delayedCall(1.5, function()
    self:Destroy()
  end)
end
function SceneFloatMessage:DoDeconstruct(asArray)
  if not Slua.IsNull(self.gameObject) then
    if self.spriteLabel then
      self.spriteLabel:Destroy()
    end
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneFloatMessage.ResID, self.gameObject)
  end
  self.gameObject = nil
  self.spriteLabel = nil
  self:RemoveLeanTween()
  self.data_dtype = nil
  self.data_msg = nil
  self.data_param = nil
end
