ServiceEffectCommand = class("ServiceEffectCommand",pm.SimpleCommand)

function ServiceEffectCommand:execute(note)
	local proxy = NSceneEffectProxy.Instance
	local data = note.body
	local effectType = data.effecttype
	local opt = data.opt
	if(effectType == SceneUser2_pb.EEFFECTTYPE_NORMAL)then
		if(opt == SceneUser2_pb.EEFFECTOPT_PLAY) then
			if(data.charid >0) then
				proxy:Add(data)
			else
				print("服务器发来添加特效，竟然没有玩家ID？？")
			end
		elseif(opt == SceneUser2_pb.EEFFECTOPT_DELETE) then
			proxy:Remove(data)
		end
	elseif(effectType == SceneUser2_pb.EEFFECTTYPE_SCENEEFFECT)then
		if(opt == SceneUser2_pb.EEFFECTOPT_PLAY) then
			if(data.id >0) then
				proxy:Server_AddSceneEffect(data)
			else
				print("服务器发来添加场景特效，竟然没有ID？？")
			end
		elseif(opt == SceneUser2_pb.EEFFECTOPT_DELETE) then
			proxy:Remove(data)
		end
	elseif(effectType == SceneUser2_pb.EEFFECTTYPE_ACCEPTQUEST)then
		FloatingPanel.Instance:FloatingMidEffect(EffectMap.UI.accept)
	elseif(effectType == SceneUser2_pb.EEFFECTTYPE_FINISHQUEST)then
		FloatingPanel.Instance:FloatingMidEffect(EffectMap.UI.complete)
	elseif(effectType == SceneUser2_pb.EEFFECTTYPE_MVPSHOW)then
		FloatingPanel.Instance:FloatingMidEffect(EffectMap.UI.warning,function ( effect )
			effect.transform.localPosition = Vector3(0,100,0)
		end)
	end
end