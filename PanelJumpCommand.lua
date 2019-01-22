PanelJumpCommand = class("PanelJumpCommand",pm.SimpleCommand)

function PanelJumpCommand:execute(note)
	-- UIManagerProxy.Instance:ShowUI(note.body)
	local body = note.body
	if(body and body.view) then
		local panelData = body.view
		if(type(panelData)=="number") then
			panelData = PanelProxy.Instance:GetData(panelData)
		end
		if(panelData) then
			self:TryShowPanel(panelData,body.viewdata,body.force)
		end
	end
end

function PanelJumpCommand:TryShowPanel( data ,vdata,force)
	if(force==nil) then force = false end
	LogUtility.InfoFormat("????????????id:{0},{1}??????",data.id,data.name,data.prefab)
	if(force or FunctionUnLockFunc.Me():CheckCanOpenByPanelId(data.id, false)) then
		local uidata = {view=data,viewdata = vdata}
		UIManagerProxy.Instance:ShowUIByConfig(uidata)
	else
		self:UnOpenJump(data ,vdata)
	end
end

--???????????????????????????????????????????????????????????????????????????
function PanelJumpCommand:UnOpenJump(config,vdata)
	if(config.unOpenJump) then
		config = PanelProxy.Instance:GetData(config.unOpenJump)
		if(config) then
			LogUtility.InfoFormat("??????{0},{1}?????????",config.id,config.name)
			self:TryShowPanel(config,vdata)
		end
	else
		FunctionUnLockFunc.Me():CheckCanOpenByPanelId(config.id, true)
	end
end