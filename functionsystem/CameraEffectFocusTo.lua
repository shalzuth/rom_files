CameraEffectFocusTo = class("CameraEffectFocusTo", CameraEffect)
function CameraEffectFocusTo:ctor(focus, viewPort, duration, listener)
  CameraEffectFocusTo.super.ctor(self)
  self.focus = focus
  self.viewPort = viewPort
  self.duration = duration
  function self.finishedListener(cameraController)
    if nil ~= listener then
      listener(cameraController)
    end
  end
end
function CameraEffectFocusTo:DoStart(cameraController)
  self.originalZoom = cameraController.zoom
  cameraController:ResetCurrentInfoByZoom(1)
  if nil ~= self.offset then
    if nil ~= self.focus then
      cameraController:FocusTo(self.focus, self.offset, self.viewPort, self.duration, self.finishedListener)
    else
      cameraController:FocusTo(self.offset, self.viewPort, self.duration, self.finishedListener)
    end
  elseif nil ~= self.focus then
    cameraController:FocusTo(self.focus, self.viewPort, self.duration, self.finishedListener)
  else
    cameraController:FocusTo(self.viewPort, self.duration, self.finishedListener)
  end
end
function CameraEffectFocusTo:DoEnd(cameraController)
  cameraController:ResetCurrentInfoByZoom(self.originalZoom)
  cameraController:RestoreDefault(self.duration, nil)
end
