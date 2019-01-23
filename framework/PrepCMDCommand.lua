PrepCMDCommand = class('StartUpCommand', pm.SimpleCommand)

ChangeSceneCommand = autoImport("ChangeSceneCommand")
MyselfPropCommand = autoImport("MyselfPropCommand")
RestartGameCommand = autoImport("RestartGameCommand")
ItemHandleCommand = autoImport("ItemHandleCommand")
LoginInitCommand = autoImport("LoginInitCommand")
ReconnInitCommand = autoImport("ReconnInitCommand")
AskUseSkillCommand = autoImport("AskUseSkillCommand")
PlayerLevelUpCommand = autoImport("PlayerLevelUpCommand")
LoadSceneLoadedCommand = autoImport("LoadSceneLoadedCommand")
SkillDataCommand = autoImport('SkillDataCommand')

autoImport('CreaturePropCommand')
autoImport('ServicePlayerActionCommand')
autoImport("CancelAskUseSkillCommand")
autoImport("MyselfDeathCommand")
autoImport("ServiceEffectCommand")
autoImport("UIShowCommand")
autoImport("UICloseCommand")
autoImport("PanelJumpCommand")
autoImport("EmojiCommand")
autoImport("BossCommand")
autoImport("SceneUICommand")
autoImport("AdventrueDataCommand")
autoImport("FollowCommand")
autoImport("MonsterCountUserCommand")
autoImport("ItemProduceDoneCommand")
autoImport("PlayerTeamInfoCommand")

function PrepCMDCommand:execute(notifi)
	GameFacade.Instance:registerCommand(UIEvent.ShowUI, UIShowCommand)
	GameFacade.Instance:registerCommand(UIEvent.JumpPanel, PanelJumpCommand)
	GameFacade.Instance:registerCommand(UIEvent.CloseUI, UICloseCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.PlayerMapChange, ChangeSceneCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.LoginInit, LoginInitCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.ReconnInit, ReconnInitCommand)
	--LoadScene.LoadSceneLoaded 是c#事件
	GameFacade.Instance:registerCommand(LoadScene.LoadSceneLoaded, LoadSceneLoadedCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.PlayerSAttrSyncData, MyselfPropCommand)
	GameFacade.Instance:registerCommand(GameEvent.RestartGame, RestartGameCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.ItemPackageItem, ItemHandleCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.ItemPackageUpdate, ItemHandleCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.ItemPackageSort, ItemHandleCommand)
	
	GameFacade.Instance:registerCommand(MyselfEvent.AskUseSkill, AskUseSkillCommand)
	GameFacade.Instance:registerCommand(MyselfEvent.CancelAskUseSkill, CancelAskUseSkillCommand)
	GameFacade.Instance:registerCommand(SceneUserEvent.LevelUp, PlayerLevelUpCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.SkillReqSkillData,SkillDataCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.SkillSkillUpdate,SkillDataCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.PlayerMapObjectData,CreaturePropCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.NpcChangeHp,CreaturePropCommand)

	--myself death
	GameFacade.Instance:registerCommand(MyselfEvent.DeathBegin,MyselfDeathCommand)
	GameFacade.Instance:registerCommand(MyselfEvent.DeathEnd,MyselfDeathCommand)

	--特效
	GameFacade.Instance:registerCommand(ServiceEvent.NUserEffectUserCmd,ServiceEffectCommand)
	
	--主界面

	--日常Boss
	GameFacade.Instance:registerCommand(ServiceEvent.BossCmdKillBossUserCmd, BossCommand);
	
	--表情动作
	GameFacade.Instance:registerCommand(EmojiEvent.PlayEmoji, EmojiCommand);

	GameFacade.Instance:registerCommand(ServiceEvent.SceneUserActionNtf ,ServicePlayerActionCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.NUserUserActionNtf ,ServicePlayerActionCommand)
	
	--场景UI
	GameFacade.Instance:registerCommand(SceneUserEvent.SceneAddRoles, SceneUICommand);
	GameFacade.Instance:registerCommand(SceneUserEvent.SceneRemoveRoles, SceneUICommand);
	GameFacade.Instance:registerCommand(SceneUserEvent.SceneRemoveNpcs, SceneUICommand);
	GameFacade.Instance:registerCommand(SceneUserEvent.SceneRemovePets, SceneUICommand);

	GameFacade.Instance:registerCommand(ServiceEvent.SceneManualManualUpdate, AdventrueDataCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.SceneManualQueryManualData, AdventrueDataCommand)

	-- 跟随
	GameFacade.Instance:registerCommand(FollowEvent.Follow, FollowCommand)
	GameFacade.Instance:registerCommand(FollowEvent.CancelFollow, FollowCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.NUserFollowerUser, FollowCommand)
	GameFacade.Instance:registerCommand(ServiceEvent.NUserGoMapFollowUserCmd, FollowCommand)
	-- 副本怪物数量
	GameFacade.Instance:registerCommand(ServiceEvent.FuBenCmdMonsterCountUserCmd, MonsterCountUserCommand)

	--图纸制作成功
	GameFacade.Instance:registerCommand(ServiceEvent.ItemProduceDone, ItemProduceDoneCommand)
	--队伍信息
	GameFacade.Instance:registerCommand(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, PlayerTeamInfoCommand)

end
