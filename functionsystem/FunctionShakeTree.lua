FunctionShakeTree = class("FunctionShakeTree")

FunctionShakeTree.targetId = nil;

function FunctionShakeTree.DoServerShake()
	local npc = SceneCreatureProxy.FindCreature(FunctionShakeTree.targetId);
	if(npc)then
		ServiceNUserProxy.Instance:CallShakeTreeUserCmd(npc.data.id);
	else
		MsgManager.ShowMsgByIDTable(2100);
	end
end

function FunctionShakeTree.Me()
	if nil == FunctionShakeTree.me then
		FunctionShakeTree.me = FunctionShakeTree.new()
	end
	return FunctionShakeTree.me
end

function FunctionShakeTree:ctor()
end

function FunctionShakeTree:TryShakeTree(treeNpc)
	FunctionShakeTree.targetId = treeNpc.data.id;

	local treeStatus = treeNpc.data.userdata:Get(UDEnum.TREESTATUS);
	local viewdata = {
		viewname = "DialogView",
		npcinfo = treeNpc,
	};
	if(treeStatus == SceneUser2_pb.ETREESTATUS_MONSTER)then
		local Tree_Monster_DialogID = 4101;
		viewdata.dialoglist = { Tree_Monster_DialogID };

	elseif(treeStatus == SceneUser2_pb.ETREESTATUS_NORMAL)then
		local Tree_Normal_Dialog = DialogUtil.GetDialogData(4100);
		local dialogText = Tree_Normal_Dialog and Tree_Normal_Dialog.Text;
		dialogText = string.format(dialogText, treeNpc.data.staticData.NameZh);

		viewdata.dialoglist = { dialogText };

		local shakeEvent = {};
		local npcData = treeNpc.data.staticData;
		local npcfunction = npcData and npcData.NpcFunction;
		if(npcfunction)then
			local _,npcfunc = next(npcfunction);
			shakeEvent.NameZh = Table_NpcFunction[npcfunc.type].NameZh;
		end
		-- shakeEvent.closeDialog = true;
		shakeEvent.event = FunctionShakeTree.DoServerShake;
		shakeEvent.closeDialog = true;
		viewdata.addfunc = {shakeEvent};
		-- viewdata.wait = 0.2;

		viewdata.addleft = true;
	end
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata);
end

function FunctionShakeTree:AfterShakeTree(result)
	if(result == SceneUser2_pb.ETREESTATUS_MONSTER)then
		local viewdata = {
			viewname = "DialogView",
			dialoglist = {4101},
		};
		viewdata.npcinfo = SceneCreatureProxy.FindCreature(FunctionShakeTree.targetId);
		GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata);
	end
end









