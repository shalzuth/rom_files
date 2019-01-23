
autoImport ("LuaVector2")
autoImport ("LuaVector3")
autoImport ("LuaVector4")
autoImport ("LuaColor")
autoImport ("LuaQuaternion")
autoImport ("LuaRect")

LuaGeometry = {}
LuaGeometry.Const_V2_zero = LuaVector2.zero
LuaGeometry.Const_V2_one = LuaVector2.one

LuaGeometry.Const_V3_zero = LuaVector3.zero
LuaGeometry.Const_V3_one = LuaVector3.one

LuaGeometry.Const_Qua_identity = LuaQuaternion.identity

LuaGeometry.Const_Col_black = LuaColor.black
LuaGeometry.Const_Col_white = LuaColor.white
LuaGeometry.Const_Col_whiteClear = LuaColor.New(1,1,1,0)
LuaGeometry.Const_Col_blue = LuaColor.blue
LuaGeometry.Const_Col_red = LuaColor.red