autoImport("CSharpObjectForLogin")
autoImport("RoleReadyForLogin")
LoginRoleSelector = class("LoginRoleSelector")
LoginRoleSelector.ins = nil
function LoginRoleSelector.Ins()
  if LoginRoleSelector.ins == nil then
    LoginRoleSelector.ins = LoginRoleSelector.new()
  end
  return LoginRoleSelector.ins
end
function LoginRoleSelector:Initialize()
  if not self.isInitialized then
    self.isShowSceneAndRoles = false
    self.isInitialized = true
  end
end
function LoginRoleSelector:Reset()
  self:Release()
end
function LoginRoleSelector:Release()
  CSharpObjectForLogin.Ins():Release()
  RoleReadyForLogin.Ins():Release()
end
function LoginRoleSelector:HideSceneAndRoles()
  if self.isShowSceneAndRoles then
    local transCamera = CSharpObjectForLogin.Ins():GetTransCamera()
    local posCamera = transCamera.position
    posCamera.y = posCamera.y + 10000
    transCamera.position = posCamera
    self.isShowSceneAndRoles = false
  end
end
function LoginRoleSelector:ShowSceneAndRoles()
  if not self.isShowSceneAndRoles then
    local transCamera = CSharpObjectForLogin.Ins():GetTransCamera()
    local posCamera = transCamera.position
    posCamera.y = posCamera.y - 10000
    transCamera.position = posCamera
    self.isShowSceneAndRoles = true
  end
end
function LoginRoleSelector:GoToCreateRole(index)
  FunctionPreload.Me():PreloadMakeRole()
  ResourceManager.Instance:SLoadScene("CharacterSelect")
  SceneUtil.SyncLoad("CharacterSelect")
  LeanTween.delayedCall(3, function()
    FunctionPreload.Me():ClearMakeRole()
    ResourceManager.Instance:SUnLoadScene("CharacterSelect", false)
  end):setUseFrames(true)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "CreateRoleViewV2",
    index = index
  })
end
