local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
autoImport("SceneUser_pb")
local SceneUser_pb = SceneUser_pb
autoImport("ProtoCommon_pb")
local ProtoCommon_pb = ProtoCommon_pb
autoImport("Var_pb")
local Var_pb = Var_pb
autoImport("SessionSociality_pb")
local SessionSociality_pb = SessionSociality_pb
autoImport("SceneSkill_pb")
local SceneSkill_pb = SceneSkill_pb
autoImport("SceneBeing_pb")
local SceneBeing_pb = SceneBeing_pb
autoImport("AstrolabeCmd_pb")
local AstrolabeCmd_pb = AstrolabeCmd_pb
module("SceneUser2_pb")
USER2PARAM = protobuf.EnumDescriptor()
USER2PARAM_USER2PARAM_GOCITY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SYSMSG_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NPCDATASYNC_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_USERNINESYNC_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_ACTION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_BUFFERSYNC_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_EXIT_POS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_RELIVE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_VAR_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_TALKINFO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVERTIME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NEWTRANSMAP_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_EFFECT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_MENU_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NEWMENU_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_TEAMINFONINE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_USEPORTRAIT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_USEFRAME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NEWPORTRAITFRAME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERYPORTRAITLIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_ADDATTRPOINT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERYSHOPGOTITEM_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UPDATESHOPGOTITEM_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_USEDRESSING_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NEWDRESSING_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DRESSINGLIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_OPENUI_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DBGSYSMSG_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_FOLLOWTRANSFER_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NPCFUNC_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_MODELSHOW_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SOUNDEFFECT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_PRESETCHATMSG_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CHANGEBGM_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERYFIGHTERINFO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_GAMETIME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CDTIME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_STATECHANGE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_PHOTO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SHAKESCREEN_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERYSHORTCUT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_PUTSHORTCUT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NPCANGLE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CAMERAFOCUS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_GOTO_LIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_GOTO_GEAR_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_FOLLOWER_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_LABORATORY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_EXCHANGEPROFESSION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_GOTO_LABORATORY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SCENERY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_GOMAP_QUEST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_GOMAP_FOLLOW_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_AUTOHIT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UPLOAD_SCENERY_PHOTO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERY_MAPAREA_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NEW_MAPAREA_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_FOREVER_BUFF_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_INVITE_JOIN_HANDS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_BREAK_UP_HANDS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERY_ACTION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_MUSIC_LIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_MUSIC_DEMAND_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_MUSIC_CLOSE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UPLOAD_OK_SCENERY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_JOIN_HANDS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERY_TRACE_LIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UPDATE_TRACE_LIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SET_DIRECTION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DOWNLOAD_SCENERY_PHOTO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_BATTLE_TIMELEN_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SETOPTION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERYUSERINFO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_COUNTDOWN_TICK_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_ITEM_MUSIC_NTF_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SHAKETREE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_TREELIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_ACTIVITY_NTF_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERY_ZONESTATUS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_JUMP_ZONE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_ITEMIMAGE_USER_NTF_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_HANDSTATUS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_BEFOLLOW_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_INVITEFOLLOW_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CHANGENAME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CHARGEPLAY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_REQUIRENPCFUNC_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CHECK_SEAT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NTF_SEAT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SET_NORMALSKILL_OPTION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UNSOLVED_SCENERY_NTF_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NTF_VISIBLENPC_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NEW_SET_OPTION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UPYUN_AUTHORIZATION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_TRANSFORM_PREDATA_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_USER_RENAME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_ENTER_CAPRA_ACTIVITY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_BUY_ZENY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CALL_TEAMER_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CALL_TEAMER_JOIN_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_YOYO_SEAT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SHOW_SEAT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SPECIAL_EFFECT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_REPLY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UPLOAD_WEDDING_PHOTO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_SUCCESS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_INVITEE_WEDDING_START_NTF_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_SHOW_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_REPLACE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_SERVICE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_RECOMMEND_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_RECEIVE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_REWARD_STATUS_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_KFC_SHARE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_TWINS_ACTION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CHECK_RELATION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_PROFESSION_QUERY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_PROFESSION_BUY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_PROFESSION_CHANGE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UPDATE_RECORD_INFO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SAVE_RECORD_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_LOAD_RECORD_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CHANGE_RECORD_NAME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_BUY_RECORD_SLOT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DELETE_RECORD_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UPDATE_BRANCH_INFO_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_GOTO_FUNCMAP_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_INVITE_WITH_ME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERY_ALTMAN_KILL_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_USER_BOOTH_REQ_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_BOOTH_INFO_SYNC_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DRESSUP_MODEL_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DRESSUP_HEAD_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_QUERY_STAGE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DRESSUP_LINEUP_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DRESSUP_STAGE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_DEATH_TRANSFER_LIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_NEW_DEATH_TRANSFER_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_TRANSFER_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_GROWTH_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_RECEIVE_GROWTH_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_GROWTH_OPEN_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CHEAT_TAG_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CHEAT_TAG_STAT_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_CLICK_POS_LIST_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_BEAT_PORI_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_UNLOCK_FRAME_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_KFC_ENROLL_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_KFC_ENROLL_REPLY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_KFC_HAS_ENROLLED_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_KFC_ENROLL_QUERY_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_KFC_ENROLL_CODE_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SIGNIN_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SIGNIN_NTF_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_ALTMAN_REWARD_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_REQ_RESERVATION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_RESERVATION_ENUM = protobuf.EnumValueDescriptor()
USER2PARAM_USER2PARAM_SERVANT_REC_EQUIP_ENUM = protobuf.EnumValueDescriptor()
EMESSAGETYPE = protobuf.EnumDescriptor()
EMESSAGETYPE_EMESSAGETYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EMESSAGETYPE_EMESSAGETYPE_FRAME_ENUM = protobuf.EnumValueDescriptor()
EMESSAGETYPE_EMESSAGETYPE_GETEXP_ENUM = protobuf.EnumValueDescriptor()
EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_ENUM = protobuf.EnumValueDescriptor()
EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_NOT_CLEAR_ENUM = protobuf.EnumValueDescriptor()
EMESSAGETYPE_EMESSAGETYPE_MIDDLE_SHOW_ENUM = protobuf.EnumValueDescriptor()
EMESSAGETYPE_EMESSAGETYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EMESSAGEACTOPT = protobuf.EnumDescriptor()
EMESSAGEACTOPT_EMESSAGEACT_ADD_ENUM = protobuf.EnumValueDescriptor()
EMESSAGEACTOPT_EMESSAGEACT_DEL_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE = protobuf.EnumDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_ADDHP_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_REFINE_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_EXPRESSION_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_MOTION_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_GEAR_ACTION_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_NORMALMOTION_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_DIALOG_ENUM = protobuf.EnumValueDescriptor()
EUSERACTIONTYPE_EUSERACTIONTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
ERELIVETYPE = protobuf.EnumDescriptor()
ERELIVETYPE_ERELIVETYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
ERELIVETYPE_ERELIVETYPE_RETURN_ENUM = protobuf.EnumValueDescriptor()
ERELIVETYPE_ERELIVETYPE_MONEY_ENUM = protobuf.EnumValueDescriptor()
ERELIVETYPE_ERELIVETYPE_RAND_ENUM = protobuf.EnumValueDescriptor()
ERELIVETYPE_ERELIVETYPE_RETURNSAVE_ENUM = protobuf.EnumValueDescriptor()
ERELIVETYPE_ERELIVETYPE_SKILL_ENUM = protobuf.EnumValueDescriptor()
ERELIVETYPE_ERELIVETYPE_TOWER_ENUM = protobuf.EnumValueDescriptor()
ERELIVETYPE_ERELIVETYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EEFFECTOPT = protobuf.EnumDescriptor()
EEFFECTOPT_EEFFECTOPT_PLAY_ENUM = protobuf.EnumValueDescriptor()
EEFFECTOPT_EEFFECTOPT_STOP_ENUM = protobuf.EnumValueDescriptor()
EEFFECTOPT_EEFFECTOPT_DELETE_ENUM = protobuf.EnumValueDescriptor()
EEFFECTTYPE = protobuf.EnumDescriptor()
EEFFECTTYPE_EEFFECTTYPE_NORMAL_ENUM = protobuf.EnumValueDescriptor()
EEFFECTTYPE_EEFFECTTYPE_ACCEPTQUEST_ENUM = protobuf.EnumValueDescriptor()
EEFFECTTYPE_EEFFECTTYPE_FINISHQUEST_ENUM = protobuf.EnumValueDescriptor()
EEFFECTTYPE_EEFFECTTYPE_MVPSHOW_ENUM = protobuf.EnumValueDescriptor()
EEFFECTTYPE_EEFFECTTYPE_SCENEEFFECT_ENUM = protobuf.EnumValueDescriptor()
EDRESSTYPE = protobuf.EnumDescriptor()
EDRESSTYPE_EDRESSTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EDRESSTYPE_EDRESSTYPE_HAIR_ENUM = protobuf.EnumValueDescriptor()
EDRESSTYPE_EDRESSTYPE_HAIRCOLOR_ENUM = protobuf.EnumValueDescriptor()
EDRESSTYPE_EDRESSTYPE_EYE_ENUM = protobuf.EnumValueDescriptor()
EDRESSTYPE_EDRESSTYPE_CLOTH_ENUM = protobuf.EnumValueDescriptor()
EDRESSTYPE_EDRESSTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
POINTTYPE = protobuf.EnumDescriptor()
POINTTYPE_POINTTYPE_ADD_ENUM = protobuf.EnumValueDescriptor()
POINTTYPE_POINTTYPE_RESET_ENUM = protobuf.EnumValueDescriptor()
EDBGMSGTYPE = protobuf.EnumDescriptor()
EDBGMSGTYPE_EDBGMSGTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EDBGMSGTYPE_EDBGMSGTYPE_TEST_ENUM = protobuf.EnumValueDescriptor()
GAMETIMEOPT = protobuf.EnumDescriptor()
GAMETIMEOPT_EGAMETIMEOPT_SYNC_ENUM = protobuf.EnumValueDescriptor()
GAMETIMEOPT_EGAMETIMEOPT_ADJUST_ENUM = protobuf.EnumValueDescriptor()
CD_TYPE = protobuf.EnumDescriptor()
CD_TYPE_CD_TYPE_SKILL_ENUM = protobuf.EnumValueDescriptor()
CD_TYPE_CD_TYPE_ITEM_ENUM = protobuf.EnumValueDescriptor()
CD_TYPE_CD_TYPE_SKILLDEALY_ENUM = protobuf.EnumValueDescriptor()
EGOTOGEARTYPE = protobuf.EnumDescriptor()
EGOTOGEARTYPE_EGOTOGEARTYPE_SINGLE_ENUM = protobuf.EnumValueDescriptor()
EGOTOGEARTYPE_EGOTOGEARTYPE_HAND_ENUM = protobuf.EnumValueDescriptor()
EGOTOGEARTYPE_EGOTOGEARTYPE_TEAM_ENUM = protobuf.EnumValueDescriptor()
EGOTOGEARTYPE_EGOTOGEARTYPE_FREE_ENUM = protobuf.EnumValueDescriptor()
EFOLLOWTYPE = protobuf.EnumDescriptor()
EFOLLOWTYPE_EFOLLOWTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EFOLLOWTYPE_EFOLLOWTYPE_HAND_ENUM = protobuf.EnumValueDescriptor()
EFOLLOWTYPE_EFOLLOWTYPE_BREAK_ENUM = protobuf.EnumValueDescriptor()
EFOLLOWTYPE_EFOLLOWTYPE_TWINSACTION_ENUM = protobuf.EnumValueDescriptor()
EFOLLOWTYPE_EFOLLOWTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EALBUMTYPE = protobuf.EnumDescriptor()
EALBUMTYPE_EALBUMTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EALBUMTYPE_EALBUMTYPE_SCENERY_ENUM = protobuf.EnumValueDescriptor()
EALBUMTYPE_EALBUMTYPE_PHOTO_ENUM = protobuf.EnumValueDescriptor()
EALBUMTYPE_EALBUMTYPE_GUILD_ICON_ENUM = protobuf.EnumValueDescriptor()
EALBUMTYPE_EALBUMTYPE_WEDDING_ENUM = protobuf.EnumValueDescriptor()
EALBUMTYPE_EALBUMTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EBATTLESTATUS = protobuf.EnumDescriptor()
EBATTLESTATUS_EBATTLESTATUS_EASY_ENUM = protobuf.EnumValueDescriptor()
EBATTLESTATUS_EBATTLESTATUS_TIRED_ENUM = protobuf.EnumValueDescriptor()
EBATTLESTATUS_EBATTLESTATUS_HIGHTIRED_ENUM = protobuf.EnumValueDescriptor()
EQUERYTYPE = protobuf.EnumDescriptor()
EQUERYTYPE_EQUERYTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUERYTYPE_EQUERYTYPE_ALL_ENUM = protobuf.EnumValueDescriptor()
EQUERYTYPE_EQUERYTYPE_FRIEND_ENUM = protobuf.EnumValueDescriptor()
EQUERYTYPE_EQUERYTYPE_CLOSE_ENUM = protobuf.EnumValueDescriptor()
EQUERYTYPE_EQUERYTYPE_WEDDING_ALL_ENUM = protobuf.EnumValueDescriptor()
EQUERYTYPE_EQUERYTYPE_WEDDING_FRIEND_ENUM = protobuf.EnumValueDescriptor()
EQUERYTYPE_EQUERYTYPE_WEDDING_CLOSE_ENUM = protobuf.EnumValueDescriptor()
EQUERYTYPE_EQUERYTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EFASHIONHIDETYPE = protobuf.EnumDescriptor()
EFASHIONHIDETYPE_EFASHIONHIDETYPE_HEAD_ENUM = protobuf.EnumValueDescriptor()
EFASHIONHIDETYPE_EFASHIONHIDETYPE_BACK_ENUM = protobuf.EnumValueDescriptor()
EFASHIONHIDETYPE_EFASHIONHIDETYPE_FACE_ENUM = protobuf.EnumValueDescriptor()
EFASHIONHIDETYPE_EFASHIONHIDETYPE_TAIL_ENUM = protobuf.EnumValueDescriptor()
EFASHIONHIDETYPE_EFASHIONHIDETYPE_MOUTH_ENUM = protobuf.EnumValueDescriptor()
EFASHIONHIDETYPE_EFASHIONHIDETYPE_BODY_ENUM = protobuf.EnumValueDescriptor()
EFASHIONHIDETYPE_EFASHIONHIDETYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
ECOUNTDOWNTYPE = protobuf.EnumDescriptor()
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_DOJO_ENUM = protobuf.EnumValueDescriptor()
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_TOWER_ENUM = protobuf.EnumValueDescriptor()
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_ALTMAN_ENUM = protobuf.EnumValueDescriptor()
ETREESTATUS = protobuf.EnumDescriptor()
ETREESTATUS_ETREESTATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
ETREESTATUS_ETREESTATUS_NORMAL_ENUM = protobuf.EnumValueDescriptor()
ETREESTATUS_ETREESTATUS_MONSTER_ENUM = protobuf.EnumValueDescriptor()
ETREESTATUS_ETREESTATUS_REWARD_ENUM = protobuf.EnumValueDescriptor()
ETREESTATUS_ETREESTATUS_DEAD_ENUM = protobuf.EnumValueDescriptor()
ETREESTATUS_ETREESTATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
EZONESTATUS = protobuf.EnumDescriptor()
EZONESTATUS_EZONESTATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EZONESTATUS_EZONESTATUS_FREE_ENUM = protobuf.EnumValueDescriptor()
EZONESTATUS_EZONESTATUS_BUSY_ENUM = protobuf.EnumValueDescriptor()
EZONESTATUS_EZONESTATUS_VERYBUSY_ENUM = protobuf.EnumValueDescriptor()
EZONESTATUS_EZONESTATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
EZONESTATE = protobuf.EnumDescriptor()
EZONESTATE_EZONESTATE_MIN_ENUM = protobuf.EnumValueDescriptor()
EZONESTATE_EZONESTATE_FULL_ENUM = protobuf.EnumValueDescriptor()
EZONESTATE_EZONESTATE_NOFULL_ENUM = protobuf.EnumValueDescriptor()
EZONESTATE_EZONESTATE_MAX_ENUM = protobuf.EnumValueDescriptor()
EJUMPZONE = protobuf.EnumDescriptor()
EJUMPZONE_EJUMPZONE_MIN_ENUM = protobuf.EnumValueDescriptor()
EJUMPZONE_EJUMPZONE_GUILD_ENUM = protobuf.EnumValueDescriptor()
EJUMPZONE_EJUMPZONE_TEAM_ENUM = protobuf.EnumValueDescriptor()
EJUMPZONE_EJUMPZONE_USER_ENUM = protobuf.EnumValueDescriptor()
EJUMPZONE_EJUMPZONE_MAX_ENUM = protobuf.EnumValueDescriptor()
SEATSHOWTYPE = protobuf.EnumDescriptor()
SEATSHOWTYPE_SEAT_SHOW_VISIBLE_ENUM = protobuf.EnumValueDescriptor()
SEATSHOWTYPE_SEAT_SHOW_INVISIBLE_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE = protobuf.EnumDescriptor()
EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_HP_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_SP_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_USE_SLIM_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_HEAD_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_EQUIP_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_CARD_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_GIVE_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_USE_PETTALK_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_2_ENUM = protobuf.EnumValueDescriptor()
EOPTIONTYPE_EOPTIONTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
ERENAMEERRCODE = protobuf.EnumDescriptor()
ERENAMEERRCODE_ERENAME_SUCCESS_ENUM = protobuf.EnumValueDescriptor()
ERENAMEERRCODE_ERENAME_CD_ENUM = protobuf.EnumValueDescriptor()
ERENAMEERRCODE_ERENAME_CONFLICT_ENUM = protobuf.EnumValueDescriptor()
EPROPOSALREPLY = protobuf.EnumDescriptor()
EPROPOSALREPLY_EPROPOSALREPLY_YES_ENUM = protobuf.EnumValueDescriptor()
EPROPOSALREPLY_EPROPOSALREPLY_NO_ENUM = protobuf.EnumValueDescriptor()
EPROPOSALREPLY_EPROPOSALREPLY_OUTRANGE_ENUM = protobuf.EnumValueDescriptor()
EPROPOSALREPLY_EPROPOSALREPLY_CANCEL_ENUM = protobuf.EnumValueDescriptor()
SHARETYPE = protobuf.EnumDescriptor()
SHARETYPE_ESHARETYPE_KFC_SHARE_ENUM = protobuf.EnumValueDescriptor()
SHARETYPE_ESHARETYPE_KFC_ARPHOTO_SHARE_ENUM = protobuf.EnumValueDescriptor()
SHARETYPE_ESHARETYPE_CONCERT_ENUM = protobuf.EnumValueDescriptor()
ENROLLRESULT = protobuf.EnumDescriptor()
ENROLLRESULT_EENROLLRESULT_SUCCESS_ENUM = protobuf.EnumValueDescriptor()
ENROLLRESULT_EENROLLRESULT_CHARID_EXISTED_ENUM = protobuf.EnumValueDescriptor()
ENROLLRESULT_EENROLLRESULT_PHONE_EXISTED_ENUM = protobuf.EnumValueDescriptor()
ENROLLRESULT_EENROLLRESULT_CODE_INCORRECT_ENUM = protobuf.EnumValueDescriptor()
ENROLLRESULT_EENROLLRESULT_CODE_INVALID_ENUM = protobuf.EnumValueDescriptor()
ENROLLRESULT_EENROLLRESULT_CODE_TOOFAST_ENUM = protobuf.EnumValueDescriptor()
ENROLLRESULT_EENROLLRESULT_ERROR_ENUM = protobuf.EnumValueDescriptor()
ETWINSOPERATION = protobuf.EnumDescriptor()
ETWINSOPERATION_ETWINS_OPERATION_MIN_ENUM = protobuf.EnumValueDescriptor()
ETWINSOPERATION_ETWINS_OPERATION_SPONSOR_ENUM = protobuf.EnumValueDescriptor()
ETWINSOPERATION_ETWINS_OPERATION_REQUEST_ENUM = protobuf.EnumValueDescriptor()
ETWINSOPERATION_ETWINS_OPERATION_AGREE_ENUM = protobuf.EnumValueDescriptor()
ETWINSOPERATION_ETWINS_OPERATION_DISAGREE_ENUM = protobuf.EnumValueDescriptor()
ETWINSOPERATION_ETWINS_OPERATION_COMMIT_ENUM = protobuf.EnumValueDescriptor()
ESERVANTSERVICE = protobuf.EnumDescriptor()
ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_ENUM = protobuf.EnumValueDescriptor()
ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_THREE_ENUM = protobuf.EnumValueDescriptor()
ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_SEVEN_ENUM = protobuf.EnumValueDescriptor()
ESERVANTSERVICE_ESERVANT_SERVICE_UPGRADE_ENUM = protobuf.EnumValueDescriptor()
ESERVANTSERVICE_ESERVANT_SERVICE_SPECIAL_ENUM = protobuf.EnumValueDescriptor()
ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_REFRESH_ENUM = protobuf.EnumValueDescriptor()
ESERVANTSERVICE_ESERVANT_SERVICE_INVITE_HAND_ENUM = protobuf.EnumValueDescriptor()
ESERVANTSERVICE_ESERVANT_SERVICE_BREAK_HAND_ENUM = protobuf.EnumValueDescriptor()
ERECOMMENDSTATUS = protobuf.EnumDescriptor()
ERECOMMENDSTATUS_ERECOMMEND_STATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
ERECOMMENDSTATUS_ERECOMMEND_STATUS_GO_ENUM = protobuf.EnumValueDescriptor()
ERECOMMENDSTATUS_ERECOMMEND_STATUS_RECEIVE_ENUM = protobuf.EnumValueDescriptor()
ERECOMMENDSTATUS_ERECOMMEND_STATUS_FINISH_ENUM = protobuf.EnumValueDescriptor()
EPROFRESSIONDATATYPE = protobuf.EnumDescriptor()
EPROFRESSIONDATATYPE_ETYPEADVANCE_ENUM = protobuf.EnumValueDescriptor()
EPROFRESSIONDATATYPE_ETYPEBRANCH_ENUM = protobuf.EnumValueDescriptor()
EPROFRESSIONDATATYPE_ETYPERECORD_ENUM = protobuf.EnumValueDescriptor()
ESLOTTYPE = protobuf.EnumDescriptor()
ESLOTTYPE_ESLOT_DEFAULT_ENUM = protobuf.EnumValueDescriptor()
ESLOTTYPE_ESLOT_BUY_ENUM = protobuf.EnumValueDescriptor()
ESLOTTYPE_ESLOT_MONTH_CARD_ENUM = protobuf.EnumValueDescriptor()
EBOOTHOPER = protobuf.EnumDescriptor()
EBOOTHOPER_EBOOTHOPER_OPEN_ENUM = protobuf.EnumValueDescriptor()
EBOOTHOPER_EBOOTHOPER_CLOSE_ENUM = protobuf.EnumValueDescriptor()
EBOOTHOPER_EBOOTHOPER_UPDATE_ENUM = protobuf.EnumValueDescriptor()
EBOOTHSIGN = protobuf.EnumDescriptor()
EBOOTHSIGN_EBOOTHSIGN_WHITE_ENUM = protobuf.EnumValueDescriptor()
EBOOTHSIGN_EBOOTHSIGN_GREEN_ENUM = protobuf.EnumValueDescriptor()
EBOOTHSIGN_EBOOTHSIGN_BLUE_ENUM = protobuf.EnumValueDescriptor()
EBOOTHSIGN_EBOOTHSIGN_PURPLE_ENUM = protobuf.EnumValueDescriptor()
EBOOTHSIGN_EBOOTHSIGN_ORANGE_ENUM = protobuf.EnumValueDescriptor()
EBOOTHSIGN_EBOOTHSIGN_PINK_ENUM = protobuf.EnumValueDescriptor()
EDRESSUPSTATUS = protobuf.EnumDescriptor()
EDRESSUPSTATUS_EDRESSUP_MIN_ENUM = protobuf.EnumValueDescriptor()
EDRESSUPSTATUS_EDRESSUP_WAIT_ENUM = protobuf.EnumValueDescriptor()
EDRESSUPSTATUS_EDRESSUP_SHOW_ENUM = protobuf.EnumValueDescriptor()
EFUNCMAPTYPE = protobuf.EnumDescriptor()
EFUNCMAPTYPE_EFUNCMAPTYPE_POLLY_ENUM = protobuf.EnumValueDescriptor()
EGROWTHSTATUS = protobuf.EnumDescriptor()
EGROWTHSTATUS_EGROWTH_STATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EGROWTHSTATUS_EGROWTH_STATUS_GO_ENUM = protobuf.EnumValueDescriptor()
EGROWTHSTATUS_EGROWTH_STATUS_RECEIVE_ENUM = protobuf.EnumValueDescriptor()
EGROWTHSTATUS_EGROWTH_STATUS_FINISH_ENUM = protobuf.EnumValueDescriptor()
EGROWTHTYPE = protobuf.EnumDescriptor()
EGROWTHTYPE_EGROWTH_TYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EGROWTHTYPE_EGROWTH_TYPE_STEP_ENUM = protobuf.EnumValueDescriptor()
EGROWTHTYPE_EGROWTH_TYPE_EP_ENUM = protobuf.EnumValueDescriptor()
EGROWTHTYPE_EGROWTH_TYPE_TIME_LIMIT_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON = protobuf.EnumDescriptor()
EMONITORBUTTON_EMONITORBUTTON_AUTO_BATTLE_BUTTON_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL1_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL2_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_NEARLY_BUTTON_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_NPC_TOG_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_NEARLY_CREATURE_CELL2_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_CLICK_MVP_MINI_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_AUTO_CLICK_MVP_MINI_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_CLICK_NPC_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_MAP_CLICK_NPC_ENUM = protobuf.EnumValueDescriptor()
EMONITORBUTTON_EMONITORBUTTON_MAX_ENUM = protobuf.EnumValueDescriptor()
EREWARDSTATUS = protobuf.EnumDescriptor()
EREWARDSTATUS_EREWEARD_STATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EREWARDSTATUS_EREWEARD_STATUS_CAN_GET_ENUM = protobuf.EnumValueDescriptor()
EREWARDSTATUS_EREWEARD_STATUS_GET_ENUM = protobuf.EnumValueDescriptor()
EREWARDSTATUS_EREWEARD_STATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
ERESERVATIONTYPE = protobuf.EnumDescriptor()
ERESERVATIONTYPE_ERESERVATIONTYPE_CONFIG_ENUM = protobuf.EnumValueDescriptor()
ERESERVATIONTYPE_ERESERVATIONTYPE_CONSOLE_ENUM = protobuf.EnumValueDescriptor()
GOCITY = protobuf.Descriptor()
GOCITY_CMD_FIELD = protobuf.FieldDescriptor()
GOCITY_PARAM_FIELD = protobuf.FieldDescriptor()
GOCITY_MAPID_FIELD = protobuf.FieldDescriptor()
MSGLANGPARAM = protobuf.Descriptor()
MSGLANGPARAM_LANGUAGE_FIELD = protobuf.FieldDescriptor()
MSGLANGPARAM_PARAM_FIELD = protobuf.FieldDescriptor()
MSGPARAM = protobuf.Descriptor()
MSGPARAM_PARAM_FIELD = protobuf.FieldDescriptor()
MSGPARAM_SUBPARAMS_FIELD = protobuf.FieldDescriptor()
MSGPARAM_LANGPARAMS_FIELD = protobuf.FieldDescriptor()
SYSMSG = protobuf.Descriptor()
SYSMSG_CMD_FIELD = protobuf.FieldDescriptor()
SYSMSG_PARAM_FIELD = protobuf.FieldDescriptor()
SYSMSG_ID_FIELD = protobuf.FieldDescriptor()
SYSMSG_TYPE_FIELD = protobuf.FieldDescriptor()
SYSMSG_PARAMS_FIELD = protobuf.FieldDescriptor()
SYSMSG_ACT_FIELD = protobuf.FieldDescriptor()
SYSMSG_DELAY_FIELD = protobuf.FieldDescriptor()
NPCDATASYNC = protobuf.Descriptor()
NPCDATASYNC_CMD_FIELD = protobuf.FieldDescriptor()
NPCDATASYNC_PARAM_FIELD = protobuf.FieldDescriptor()
NPCDATASYNC_GUID_FIELD = protobuf.FieldDescriptor()
NPCDATASYNC_ATTRS_FIELD = protobuf.FieldDescriptor()
NPCDATASYNC_DATAS_FIELD = protobuf.FieldDescriptor()
USERNINESYNCCMD = protobuf.Descriptor()
USERNINESYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
USERNINESYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USERNINESYNCCMD_GUID_FIELD = protobuf.FieldDescriptor()
USERNINESYNCCMD_DATAS_FIELD = protobuf.FieldDescriptor()
USERNINESYNCCMD_ATTRS_FIELD = protobuf.FieldDescriptor()
USERACTIONNTF = protobuf.Descriptor()
USERACTIONNTF_CMD_FIELD = protobuf.FieldDescriptor()
USERACTIONNTF_PARAM_FIELD = protobuf.FieldDescriptor()
USERACTIONNTF_CHARID_FIELD = protobuf.FieldDescriptor()
USERACTIONNTF_VALUE_FIELD = protobuf.FieldDescriptor()
USERACTIONNTF_TYPE_FIELD = protobuf.FieldDescriptor()
USERACTIONNTF_DELAY_FIELD = protobuf.FieldDescriptor()
BUFFERDATA = protobuf.Descriptor()
BUFFERDATA_ID_FIELD = protobuf.FieldDescriptor()
BUFFERDATA_LAYER_FIELD = protobuf.FieldDescriptor()
BUFFERDATA_TIME_FIELD = protobuf.FieldDescriptor()
BUFFERDATA_ACTIVE_FIELD = protobuf.FieldDescriptor()
BUFFERDATA_FROMNAME_FIELD = protobuf.FieldDescriptor()
BUFFERDATA_FROMID_FIELD = protobuf.FieldDescriptor()
BUFFERDATA_LEVEL_FIELD = protobuf.FieldDescriptor()
USERBUFFNINESYNCCMD = protobuf.Descriptor()
USERBUFFNINESYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
USERBUFFNINESYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USERBUFFNINESYNCCMD_GUID_FIELD = protobuf.FieldDescriptor()
USERBUFFNINESYNCCMD_UPDATES_FIELD = protobuf.FieldDescriptor()
USERBUFFNINESYNCCMD_DELS_FIELD = protobuf.FieldDescriptor()
EXITPOSUSERCMD = protobuf.Descriptor()
EXITPOSUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
EXITPOSUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
EXITPOSUSERCMD_POS_FIELD = protobuf.FieldDescriptor()
EXITPOSUSERCMD_EXITID_FIELD = protobuf.FieldDescriptor()
EXITPOSUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
RELIVE = protobuf.Descriptor()
RELIVE_CMD_FIELD = protobuf.FieldDescriptor()
RELIVE_PARAM_FIELD = protobuf.FieldDescriptor()
RELIVE_TYPE_FIELD = protobuf.FieldDescriptor()
VARUPDATE = protobuf.Descriptor()
VARUPDATE_CMD_FIELD = protobuf.FieldDescriptor()
VARUPDATE_PARAM_FIELD = protobuf.FieldDescriptor()
VARUPDATE_VARS_FIELD = protobuf.FieldDescriptor()
VARUPDATE_ACCVARS_FIELD = protobuf.FieldDescriptor()
TALKINFO = protobuf.Descriptor()
TALKINFO_CMD_FIELD = protobuf.FieldDescriptor()
TALKINFO_PARAM_FIELD = protobuf.FieldDescriptor()
TALKINFO_GUID_FIELD = protobuf.FieldDescriptor()
TALKINFO_TALKID_FIELD = protobuf.FieldDescriptor()
TALKINFO_TALKMESSAGE_FIELD = protobuf.FieldDescriptor()
TALKINFO_PARAMS_FIELD = protobuf.FieldDescriptor()
SERVERTIME = protobuf.Descriptor()
SERVERTIME_CMD_FIELD = protobuf.FieldDescriptor()
SERVERTIME_PARAM_FIELD = protobuf.FieldDescriptor()
SERVERTIME_TIME_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD = protobuf.Descriptor()
EFFECTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_EFFECTTYPE_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_CHARID_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_EFFECTPOS_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_POS_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_EFFECT_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_MSEC_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_TIMES_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_INDEX_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_OPT_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_POSBIND_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_EPBIND_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_DELAY_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_ID_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_DIR_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_SKILLID_FIELD = protobuf.FieldDescriptor()
EFFECTUSERCMD_IGNORENAVMESH_FIELD = protobuf.FieldDescriptor()
MENULIST = protobuf.Descriptor()
MENULIST_CMD_FIELD = protobuf.FieldDescriptor()
MENULIST_PARAM_FIELD = protobuf.FieldDescriptor()
MENULIST_LIST_FIELD = protobuf.FieldDescriptor()
MENULIST_DELLIST_FIELD = protobuf.FieldDescriptor()
NEWMENU = protobuf.Descriptor()
NEWMENU_CMD_FIELD = protobuf.FieldDescriptor()
NEWMENU_PARAM_FIELD = protobuf.FieldDescriptor()
NEWMENU_ANIMPLAY_FIELD = protobuf.FieldDescriptor()
NEWMENU_LIST_FIELD = protobuf.FieldDescriptor()
TEAMINFONINE = protobuf.Descriptor()
TEAMINFONINE_CMD_FIELD = protobuf.FieldDescriptor()
TEAMINFONINE_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMINFONINE_USERID_FIELD = protobuf.FieldDescriptor()
TEAMINFONINE_ID_FIELD = protobuf.FieldDescriptor()
TEAMINFONINE_NAME_FIELD = protobuf.FieldDescriptor()
USEPORTRAIT = protobuf.Descriptor()
USEPORTRAIT_CMD_FIELD = protobuf.FieldDescriptor()
USEPORTRAIT_PARAM_FIELD = protobuf.FieldDescriptor()
USEPORTRAIT_ID_FIELD = protobuf.FieldDescriptor()
USEFRAME = protobuf.Descriptor()
USEFRAME_CMD_FIELD = protobuf.FieldDescriptor()
USEFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
USEFRAME_ID_FIELD = protobuf.FieldDescriptor()
NEWPORTRAITFRAME = protobuf.Descriptor()
NEWPORTRAITFRAME_CMD_FIELD = protobuf.FieldDescriptor()
NEWPORTRAITFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
NEWPORTRAITFRAME_PORTRAIT_FIELD = protobuf.FieldDescriptor()
NEWPORTRAITFRAME_FRAME_FIELD = protobuf.FieldDescriptor()
QUERYPORTRAITLISTUSERCMD = protobuf.Descriptor()
QUERYPORTRAITLISTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD = protobuf.FieldDescriptor()
USEDRESSING = protobuf.Descriptor()
USEDRESSING_CMD_FIELD = protobuf.FieldDescriptor()
USEDRESSING_PARAM_FIELD = protobuf.FieldDescriptor()
USEDRESSING_ID_FIELD = protobuf.FieldDescriptor()
USEDRESSING_CHARID_FIELD = protobuf.FieldDescriptor()
USEDRESSING_TYPE_FIELD = protobuf.FieldDescriptor()
NEWDRESSING = protobuf.Descriptor()
NEWDRESSING_CMD_FIELD = protobuf.FieldDescriptor()
NEWDRESSING_PARAM_FIELD = protobuf.FieldDescriptor()
NEWDRESSING_TYPE_FIELD = protobuf.FieldDescriptor()
NEWDRESSING_DRESSIDS_FIELD = protobuf.FieldDescriptor()
DRESSINGLISTUSERCMD = protobuf.Descriptor()
DRESSINGLISTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
DRESSINGLISTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DRESSINGLISTUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
DRESSINGLISTUSERCMD_DRESSIDS_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT = protobuf.Descriptor()
ADDATTRPOINT_CMD_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT_PARAM_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT_TYPE_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT_STRPOINT_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT_INTPOINT_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT_AGIPOINT_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT_DEXPOINT_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT_VITPOINT_FIELD = protobuf.FieldDescriptor()
ADDATTRPOINT_LUKPOINT_FIELD = protobuf.FieldDescriptor()
SHOPGOTITEM = protobuf.Descriptor()
SHOPGOTITEM_ID_FIELD = protobuf.FieldDescriptor()
SHOPGOTITEM_COUNT_FIELD = protobuf.FieldDescriptor()
QUERYSHOPGOTITEM = protobuf.Descriptor()
QUERYSHOPGOTITEM_CMD_FIELD = protobuf.FieldDescriptor()
QUERYSHOPGOTITEM_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYSHOPGOTITEM_ITEMS_FIELD = protobuf.FieldDescriptor()
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD = protobuf.FieldDescriptor()
QUERYSHOPGOTITEM_LIMITITEMS_FIELD = protobuf.FieldDescriptor()
UPDATESHOPGOTITEM = protobuf.Descriptor()
UPDATESHOPGOTITEM_CMD_FIELD = protobuf.FieldDescriptor()
UPDATESHOPGOTITEM_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATESHOPGOTITEM_ITEM_FIELD = protobuf.FieldDescriptor()
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD = protobuf.FieldDescriptor()
UPDATESHOPGOTITEM_LIMITITEM_FIELD = protobuf.FieldDescriptor()
OPENUI = protobuf.Descriptor()
OPENUI_CMD_FIELD = protobuf.FieldDescriptor()
OPENUI_PARAM_FIELD = protobuf.FieldDescriptor()
OPENUI_ID_FIELD = protobuf.FieldDescriptor()
OPENUI_UI_FIELD = protobuf.FieldDescriptor()
DBGSYSMSG = protobuf.Descriptor()
DBGSYSMSG_CMD_FIELD = protobuf.FieldDescriptor()
DBGSYSMSG_PARAM_FIELD = protobuf.FieldDescriptor()
DBGSYSMSG_TYPE_FIELD = protobuf.FieldDescriptor()
DBGSYSMSG_CONTENT_FIELD = protobuf.FieldDescriptor()
FOLLOWTRANSFERCMD = protobuf.Descriptor()
FOLLOWTRANSFERCMD_CMD_FIELD = protobuf.FieldDescriptor()
FOLLOWTRANSFERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
FOLLOWTRANSFERCMD_TARGETID_FIELD = protobuf.FieldDescriptor()
CALLNPCFUNCCMD = protobuf.Descriptor()
CALLNPCFUNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
CALLNPCFUNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CALLNPCFUNCCMD_TYPE_FIELD = protobuf.FieldDescriptor()
CALLNPCFUNCCMD_FUNPARAM_FIELD = protobuf.FieldDescriptor()
MODELSHOW = protobuf.Descriptor()
MODELSHOW_CMD_FIELD = protobuf.FieldDescriptor()
MODELSHOW_PARAM_FIELD = protobuf.FieldDescriptor()
MODELSHOW_TYPE_FIELD = protobuf.FieldDescriptor()
MODELSHOW_DATA_FIELD = protobuf.FieldDescriptor()
SOUNDEFFECTCMD = protobuf.Descriptor()
SOUNDEFFECTCMD_CMD_FIELD = protobuf.FieldDescriptor()
SOUNDEFFECTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SOUNDEFFECTCMD_SE_FIELD = protobuf.FieldDescriptor()
SOUNDEFFECTCMD_POS_FIELD = protobuf.FieldDescriptor()
SOUNDEFFECTCMD_MSEC_FIELD = protobuf.FieldDescriptor()
SOUNDEFFECTCMD_TIMES_FIELD = protobuf.FieldDescriptor()
SOUNDEFFECTCMD_DELAY_FIELD = protobuf.FieldDescriptor()
PRESETMSG = protobuf.Descriptor()
PRESETMSG_MSGID_FIELD = protobuf.FieldDescriptor()
PRESETMSG_MSG_FIELD = protobuf.FieldDescriptor()
PRESETMSGCMD = protobuf.Descriptor()
PRESETMSGCMD_CMD_FIELD = protobuf.FieldDescriptor()
PRESETMSGCMD_PARAM_FIELD = protobuf.FieldDescriptor()
PRESETMSGCMD_MSGS_FIELD = protobuf.FieldDescriptor()
CHANGEBGMCMD = protobuf.Descriptor()
CHANGEBGMCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHANGEBGMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHANGEBGMCMD_BGM_FIELD = protobuf.FieldDescriptor()
CHANGEBGMCMD_PLAY_FIELD = protobuf.FieldDescriptor()
CHANGEBGMCMD_TIMES_FIELD = protobuf.FieldDescriptor()
CHANGEBGMCMD_TYPE_FIELD = protobuf.FieldDescriptor()
FIGHTERINFO = protobuf.Descriptor()
FIGHTERINFO_DATAS_FIELD = protobuf.FieldDescriptor()
FIGHTERINFO_ATTRS_FIELD = protobuf.FieldDescriptor()
QUERYFIGHTERINFO = protobuf.Descriptor()
QUERYFIGHTERINFO_CMD_FIELD = protobuf.FieldDescriptor()
QUERYFIGHTERINFO_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYFIGHTERINFO_FIGHTERS_FIELD = protobuf.FieldDescriptor()
GAMETIMECMD = protobuf.Descriptor()
GAMETIMECMD_CMD_FIELD = protobuf.FieldDescriptor()
GAMETIMECMD_PARAM_FIELD = protobuf.FieldDescriptor()
GAMETIMECMD_OPT_FIELD = protobuf.FieldDescriptor()
GAMETIMECMD_SEC_FIELD = protobuf.FieldDescriptor()
GAMETIMECMD_SPEED_FIELD = protobuf.FieldDescriptor()
CDTIMEITEM = protobuf.Descriptor()
CDTIMEITEM_ID_FIELD = protobuf.FieldDescriptor()
CDTIMEITEM_TIME_FIELD = protobuf.FieldDescriptor()
CDTIMEITEM_TYPE_FIELD = protobuf.FieldDescriptor()
CDTIMEUSERCMD = protobuf.Descriptor()
CDTIMEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CDTIMEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CDTIMEUSERCMD_LIST_FIELD = protobuf.FieldDescriptor()
STATECHANGE = protobuf.Descriptor()
STATECHANGE_CMD_FIELD = protobuf.FieldDescriptor()
STATECHANGE_PARAM_FIELD = protobuf.FieldDescriptor()
STATECHANGE_STATUS_FIELD = protobuf.FieldDescriptor()
PHOTO = protobuf.Descriptor()
PHOTO_CMD_FIELD = protobuf.FieldDescriptor()
PHOTO_PARAM_FIELD = protobuf.FieldDescriptor()
PHOTO_GUID_FIELD = protobuf.FieldDescriptor()
SHAKESCREEN = protobuf.Descriptor()
SHAKESCREEN_CMD_FIELD = protobuf.FieldDescriptor()
SHAKESCREEN_PARAM_FIELD = protobuf.FieldDescriptor()
SHAKESCREEN_MAXAMPLITUDE_FIELD = protobuf.FieldDescriptor()
SHAKESCREEN_MSEC_FIELD = protobuf.FieldDescriptor()
SHAKESCREEN_SHAKETYPE_FIELD = protobuf.FieldDescriptor()
SHORTCUTITEM = protobuf.Descriptor()
SHORTCUTITEM_GUID_FIELD = protobuf.FieldDescriptor()
SHORTCUTITEM_TYPE_FIELD = protobuf.FieldDescriptor()
SHORTCUTITEM_POS_FIELD = protobuf.FieldDescriptor()
QUERYSHORTCUT = protobuf.Descriptor()
QUERYSHORTCUT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYSHORTCUT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYSHORTCUT_LIST_FIELD = protobuf.FieldDescriptor()
PUTSHORTCUT = protobuf.Descriptor()
PUTSHORTCUT_CMD_FIELD = protobuf.FieldDescriptor()
PUTSHORTCUT_PARAM_FIELD = protobuf.FieldDescriptor()
PUTSHORTCUT_ITEM_FIELD = protobuf.FieldDescriptor()
NPCCHANGEANGLE = protobuf.Descriptor()
NPCCHANGEANGLE_CMD_FIELD = protobuf.FieldDescriptor()
NPCCHANGEANGLE_PARAM_FIELD = protobuf.FieldDescriptor()
NPCCHANGEANGLE_GUID_FIELD = protobuf.FieldDescriptor()
NPCCHANGEANGLE_TARGETID_FIELD = protobuf.FieldDescriptor()
NPCCHANGEANGLE_ANGLE_FIELD = protobuf.FieldDescriptor()
CAMERAFOCUS = protobuf.Descriptor()
CAMERAFOCUS_CMD_FIELD = protobuf.FieldDescriptor()
CAMERAFOCUS_PARAM_FIELD = protobuf.FieldDescriptor()
CAMERAFOCUS_TARGETS_FIELD = protobuf.FieldDescriptor()
GOTOLISTUSERCMD = protobuf.Descriptor()
GOTOLISTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GOTOLISTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GOTOLISTUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
GOTOGEARUSERCMD = protobuf.Descriptor()
GOTOGEARUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GOTOGEARUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GOTOGEARUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
GOTOGEARUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
GOTOGEARUSERCMD_OTHERIDS_FIELD = protobuf.FieldDescriptor()
NEWTRANSMAPCMD = protobuf.Descriptor()
NEWTRANSMAPCMD_CMD_FIELD = protobuf.FieldDescriptor()
NEWTRANSMAPCMD_PARAM_FIELD = protobuf.FieldDescriptor()
NEWTRANSMAPCMD_MAPID_FIELD = protobuf.FieldDescriptor()
DEATHTRANSFERLISTCMD = protobuf.Descriptor()
DEATHTRANSFERLISTCMD_CMD_FIELD = protobuf.FieldDescriptor()
DEATHTRANSFERLISTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DEATHTRANSFERLISTCMD_NPCID_FIELD = protobuf.FieldDescriptor()
NEWDEATHTRANSFERCMD = protobuf.Descriptor()
NEWDEATHTRANSFERCMD_CMD_FIELD = protobuf.FieldDescriptor()
NEWDEATHTRANSFERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
NEWDEATHTRANSFERCMD_NPCID_FIELD = protobuf.FieldDescriptor()
USEDEATHTRANSFERCMD = protobuf.Descriptor()
USEDEATHTRANSFERCMD_CMD_FIELD = protobuf.FieldDescriptor()
USEDEATHTRANSFERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USEDEATHTRANSFERCMD_FROMNPCID_FIELD = protobuf.FieldDescriptor()
USEDEATHTRANSFERCMD_TONPCID_FIELD = protobuf.FieldDescriptor()
FOLLOWERUSER = protobuf.Descriptor()
FOLLOWERUSER_CMD_FIELD = protobuf.FieldDescriptor()
FOLLOWERUSER_PARAM_FIELD = protobuf.FieldDescriptor()
FOLLOWERUSER_USERID_FIELD = protobuf.FieldDescriptor()
FOLLOWERUSER_ETYPE_FIELD = protobuf.FieldDescriptor()
BEFOLLOWUSERCMD = protobuf.Descriptor()
BEFOLLOWUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
BEFOLLOWUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BEFOLLOWUSERCMD_USERID_FIELD = protobuf.FieldDescriptor()
BEFOLLOWUSERCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
LABORATORYUSERCMD = protobuf.Descriptor()
LABORATORYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
LABORATORYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LABORATORYUSERCMD_ROUND_FIELD = protobuf.FieldDescriptor()
LABORATORYUSERCMD_CURSCORE_FIELD = protobuf.FieldDescriptor()
LABORATORYUSERCMD_MAXSCORE_FIELD = protobuf.FieldDescriptor()
GOTOLABORATORYUSERCMD = protobuf.Descriptor()
GOTOLABORATORYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GOTOLABORATORYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GOTOLABORATORYUSERCMD_FUNID_FIELD = protobuf.FieldDescriptor()
EXCHANGEPROFESSION = protobuf.Descriptor()
EXCHANGEPROFESSION_CMD_FIELD = protobuf.FieldDescriptor()
EXCHANGEPROFESSION_PARAM_FIELD = protobuf.FieldDescriptor()
EXCHANGEPROFESSION_GUID_FIELD = protobuf.FieldDescriptor()
EXCHANGEPROFESSION_DATAS_FIELD = protobuf.FieldDescriptor()
EXCHANGEPROFESSION_ATTRS_FIELD = protobuf.FieldDescriptor()
EXCHANGEPROFESSION_POINTATTRS_FIELD = protobuf.FieldDescriptor()
EXCHANGEPROFESSION_TYPE_FIELD = protobuf.FieldDescriptor()
SCENERY = protobuf.Descriptor()
SCENERY_SCENERYID_FIELD = protobuf.FieldDescriptor()
SCENERY_ANGLEZ_FIELD = protobuf.FieldDescriptor()
SCENERY_CHARID_FIELD = protobuf.FieldDescriptor()
SCENERYUSERCMD = protobuf.Descriptor()
SCENERYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SCENERYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SCENERYUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
SCENERYUSERCMD_SCENERYS_FIELD = protobuf.FieldDescriptor()
GOMAPQUESTUSERCMD = protobuf.Descriptor()
GOMAPQUESTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GOMAPQUESTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GOMAPQUESTUSERCMD_QUESTID_FIELD = protobuf.FieldDescriptor()
GOMAPFOLLOWUSERCMD = protobuf.Descriptor()
GOMAPFOLLOWUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GOMAPFOLLOWUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GOMAPFOLLOWUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
GOMAPFOLLOWUSERCMD_CHARID_FIELD = protobuf.FieldDescriptor()
USERAUTOHITCMD = protobuf.Descriptor()
USERAUTOHITCMD_CMD_FIELD = protobuf.FieldDescriptor()
USERAUTOHITCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USERAUTOHITCMD_CHARID_FIELD = protobuf.FieldDescriptor()
UPLOADSCENERYPHOTOUSERCMD = protobuf.Descriptor()
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD = protobuf.FieldDescriptor()
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD = protobuf.FieldDescriptor()
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD = protobuf.FieldDescriptor()
UPYUNURL = protobuf.Descriptor()
UPYUNURL_TYPE_FIELD = protobuf.FieldDescriptor()
UPYUNURL_CHAR_URL_FIELD = protobuf.FieldDescriptor()
UPYUNURL_ACC_URL_FIELD = protobuf.FieldDescriptor()
DOWNLOADSCENERYPHOTOUSERCMD = protobuf.Descriptor()
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD = protobuf.FieldDescriptor()
QUERYMAPAREA = protobuf.Descriptor()
QUERYMAPAREA_CMD_FIELD = protobuf.FieldDescriptor()
QUERYMAPAREA_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYMAPAREA_AREAS_FIELD = protobuf.FieldDescriptor()
NEWMAPAREANTF = protobuf.Descriptor()
NEWMAPAREANTF_CMD_FIELD = protobuf.FieldDescriptor()
NEWMAPAREANTF_PARAM_FIELD = protobuf.FieldDescriptor()
NEWMAPAREANTF_AREA_FIELD = protobuf.FieldDescriptor()
BUFFFOREVERCMD = protobuf.Descriptor()
BUFFFOREVERCMD_CMD_FIELD = protobuf.FieldDescriptor()
BUFFFOREVERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BUFFFOREVERCMD_BUFF_FIELD = protobuf.FieldDescriptor()
INVITEJOINHANDSUSERCMD = protobuf.Descriptor()
INVITEJOINHANDSUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
INVITEJOINHANDSUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITEJOINHANDSUSERCMD_CHARID_FIELD = protobuf.FieldDescriptor()
INVITEJOINHANDSUSERCMD_MASTERID_FIELD = protobuf.FieldDescriptor()
INVITEJOINHANDSUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD = protobuf.FieldDescriptor()
INVITEJOINHANDSUSERCMD_SIGN_FIELD = protobuf.FieldDescriptor()
BREAKUPHANDSUSERCMD = protobuf.Descriptor()
BREAKUPHANDSUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
BREAKUPHANDSUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
HANDSTATUSUSERCMD = protobuf.Descriptor()
HANDSTATUSUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
HANDSTATUSUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
HANDSTATUSUSERCMD_BUILD_FIELD = protobuf.FieldDescriptor()
HANDSTATUSUSERCMD_MASTERID_FIELD = protobuf.FieldDescriptor()
HANDSTATUSUSERCMD_FOLLOWID_FIELD = protobuf.FieldDescriptor()
HANDSTATUSUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
QUERYSHOW = protobuf.Descriptor()
QUERYSHOW_CMD_FIELD = protobuf.FieldDescriptor()
QUERYSHOW_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYSHOW_ACTIONID_FIELD = protobuf.FieldDescriptor()
QUERYSHOW_EXPRESSION_FIELD = protobuf.FieldDescriptor()
MUSICITEM = protobuf.Descriptor()
MUSICITEM_CHARID_FIELD = protobuf.FieldDescriptor()
MUSICITEM_DEMANDTIME_FIELD = protobuf.FieldDescriptor()
MUSICITEM_MAPID_FIELD = protobuf.FieldDescriptor()
MUSICITEM_NPCID_FIELD = protobuf.FieldDescriptor()
MUSICITEM_MUSICID_FIELD = protobuf.FieldDescriptor()
MUSICITEM_STARTTIME_FIELD = protobuf.FieldDescriptor()
MUSICITEM_ENDTIME_FIELD = protobuf.FieldDescriptor()
MUSICITEM_STATUS_FIELD = protobuf.FieldDescriptor()
MUSICITEM_NAME_FIELD = protobuf.FieldDescriptor()
QUERYMUSICLIST = protobuf.Descriptor()
QUERYMUSICLIST_CMD_FIELD = protobuf.FieldDescriptor()
QUERYMUSICLIST_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYMUSICLIST_NPCID_FIELD = protobuf.FieldDescriptor()
QUERYMUSICLIST_ITEMS_FIELD = protobuf.FieldDescriptor()
DEMANDMUSIC = protobuf.Descriptor()
DEMANDMUSIC_CMD_FIELD = protobuf.FieldDescriptor()
DEMANDMUSIC_PARAM_FIELD = protobuf.FieldDescriptor()
DEMANDMUSIC_NPCID_FIELD = protobuf.FieldDescriptor()
DEMANDMUSIC_MUSICID_FIELD = protobuf.FieldDescriptor()
CLOSEMUSICFRAME = protobuf.Descriptor()
CLOSEMUSICFRAME_CMD_FIELD = protobuf.FieldDescriptor()
CLOSEMUSICFRAME_PARAM_FIELD = protobuf.FieldDescriptor()
UPLOADOKSCENERYUSERCMD = protobuf.Descriptor()
UPLOADOKSCENERYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPLOADOKSCENERYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD = protobuf.FieldDescriptor()
UPLOADOKSCENERYUSERCMD_STATUS_FIELD = protobuf.FieldDescriptor()
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD = protobuf.FieldDescriptor()
UPLOADOKSCENERYUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
JOINHANDSUSERCMD = protobuf.Descriptor()
JOINHANDSUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
JOINHANDSUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
JOINHANDSUSERCMD_MASTERID_FIELD = protobuf.FieldDescriptor()
JOINHANDSUSERCMD_SIGN_FIELD = protobuf.FieldDescriptor()
JOINHANDSUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
TRACEITEM = protobuf.Descriptor()
TRACEITEM_ITEMID_FIELD = protobuf.FieldDescriptor()
TRACEITEM_MONSTERID_FIELD = protobuf.FieldDescriptor()
QUERYTRACELIST = protobuf.Descriptor()
QUERYTRACELIST_CMD_FIELD = protobuf.FieldDescriptor()
QUERYTRACELIST_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYTRACELIST_ITEMS_FIELD = protobuf.FieldDescriptor()
UPDATETRACELIST = protobuf.Descriptor()
UPDATETRACELIST_CMD_FIELD = protobuf.FieldDescriptor()
UPDATETRACELIST_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATETRACELIST_UPDATES_FIELD = protobuf.FieldDescriptor()
UPDATETRACELIST_DELS_FIELD = protobuf.FieldDescriptor()
SETDIRECTION = protobuf.Descriptor()
SETDIRECTION_CMD_FIELD = protobuf.FieldDescriptor()
SETDIRECTION_PARAM_FIELD = protobuf.FieldDescriptor()
SETDIRECTION_DIR_FIELD = protobuf.FieldDescriptor()
BATTLETIMELENUSERCMD = protobuf.Descriptor()
BATTLETIMELENUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
BATTLETIMELENUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BATTLETIMELENUSERCMD_TIMELEN_FIELD = protobuf.FieldDescriptor()
BATTLETIMELENUSERCMD_TOTALTIME_FIELD = protobuf.FieldDescriptor()
BATTLETIMELENUSERCMD_MUSICTIME_FIELD = protobuf.FieldDescriptor()
BATTLETIMELENUSERCMD_TUTORTIME_FIELD = protobuf.FieldDescriptor()
BATTLETIMELENUSERCMD_ESTATUS_FIELD = protobuf.FieldDescriptor()
SETOPTIONUSERCMD = protobuf.Descriptor()
SETOPTIONUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SETOPTIONUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SETOPTIONUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
SETOPTIONUSERCMD_FASHIONHIDE_FIELD = protobuf.FieldDescriptor()
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD = protobuf.FieldDescriptor()
QUERYUSERINFOUSERCMD = protobuf.Descriptor()
QUERYUSERINFOUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYUSERINFOUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYUSERINFOUSERCMD_CHARID_FIELD = protobuf.FieldDescriptor()
QUERYUSERINFOUSERCMD_TEAMID_FIELD = protobuf.FieldDescriptor()
QUERYUSERINFOUSERCMD_BLINK_FIELD = protobuf.FieldDescriptor()
COUNTDOWNTICKUSERCMD = protobuf.Descriptor()
COUNTDOWNTICKUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
COUNTDOWNTICKUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
COUNTDOWNTICKUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
COUNTDOWNTICKUSERCMD_TICK_FIELD = protobuf.FieldDescriptor()
COUNTDOWNTICKUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
COUNTDOWNTICKUSERCMD_SIGN_FIELD = protobuf.FieldDescriptor()
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD = protobuf.FieldDescriptor()
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD = protobuf.FieldDescriptor()
ITEMMUSICNTFUSERCMD = protobuf.Descriptor()
ITEMMUSICNTFUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
ITEMMUSICNTFUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ITEMMUSICNTFUSERCMD_ADD_FIELD = protobuf.FieldDescriptor()
ITEMMUSICNTFUSERCMD_URI_FIELD = protobuf.FieldDescriptor()
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD = protobuf.FieldDescriptor()
SHAKETREEUSERCMD = protobuf.Descriptor()
SHAKETREEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SHAKETREEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SHAKETREEUSERCMD_NPCID_FIELD = protobuf.FieldDescriptor()
SHAKETREEUSERCMD_RESULT_FIELD = protobuf.FieldDescriptor()
TREE = protobuf.Descriptor()
TREE_ID_FIELD = protobuf.FieldDescriptor()
TREE_TYPEID_FIELD = protobuf.FieldDescriptor()
TREE_POS_FIELD = protobuf.FieldDescriptor()
TREELISTUSERCMD = protobuf.Descriptor()
TREELISTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
TREELISTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TREELISTUSERCMD_UPDATES_FIELD = protobuf.FieldDescriptor()
TREELISTUSERCMD_DELS_FIELD = protobuf.FieldDescriptor()
ACTIVITYNTFUSERCMD = protobuf.Descriptor()
ACTIVITYNTFUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
ACTIVITYNTFUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ACTIVITYNTFUSERCMD_ID_FIELD = protobuf.FieldDescriptor()
ACTIVITYNTFUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
ACTIVITYNTFUSERCMD_ENDTIME_FIELD = protobuf.FieldDescriptor()
ACTIVITYNTFUSERCMD_PROGRESS_FIELD = protobuf.FieldDescriptor()
ZONEINFO = protobuf.Descriptor()
ZONEINFO_ZONEID_FIELD = protobuf.FieldDescriptor()
ZONEINFO_MAXBASELV_FIELD = protobuf.FieldDescriptor()
ZONEINFO_STATUS_FIELD = protobuf.FieldDescriptor()
ZONEINFO_STATE_FIELD = protobuf.FieldDescriptor()
RECENTZONEINFO = protobuf.Descriptor()
RECENTZONEINFO_TYPE_FIELD = protobuf.FieldDescriptor()
RECENTZONEINFO_ZONEID_FIELD = protobuf.FieldDescriptor()
QUERYZONESTATUSUSERCMD = protobuf.Descriptor()
QUERYZONESTATUSUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYZONESTATUSUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYZONESTATUSUSERCMD_INFOS_FIELD = protobuf.FieldDescriptor()
QUERYZONESTATUSUSERCMD_RECENTS_FIELD = protobuf.FieldDescriptor()
JUMPZONEUSERCMD = protobuf.Descriptor()
JUMPZONEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
JUMPZONEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
JUMPZONEUSERCMD_NPCID_FIELD = protobuf.FieldDescriptor()
JUMPZONEUSERCMD_ZONEID_FIELD = protobuf.FieldDescriptor()
ITEMIMAGEUSERNTFUSERCMD = protobuf.Descriptor()
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD = protobuf.FieldDescriptor()
INVITEFOLLOWUSERCMD = protobuf.Descriptor()
INVITEFOLLOWUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
INVITEFOLLOWUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITEFOLLOWUSERCMD_CHARID_FIELD = protobuf.FieldDescriptor()
INVITEFOLLOWUSERCMD_FOLLOW_FIELD = protobuf.FieldDescriptor()
CHANGENAMEUSERCMD = protobuf.Descriptor()
CHANGENAMEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHANGENAMEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHANGENAMEUSERCMD_NAME_FIELD = protobuf.FieldDescriptor()
CHARGEPLAYUSERCMD = protobuf.Descriptor()
CHARGEPLAYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHARGEPLAYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD = protobuf.FieldDescriptor()
REQUIRENPCFUNCUSERCMD = protobuf.Descriptor()
REQUIRENPCFUNCUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
REQUIRENPCFUNCUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
REQUIRENPCFUNCUSERCMD_NPCID_FIELD = protobuf.FieldDescriptor()
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD = protobuf.FieldDescriptor()
CHECKSEATUSERCMD = protobuf.Descriptor()
CHECKSEATUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHECKSEATUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHECKSEATUSERCMD_SEATID_FIELD = protobuf.FieldDescriptor()
CHECKSEATUSERCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
NTFSEATUSERCMD = protobuf.Descriptor()
NTFSEATUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
NTFSEATUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
NTFSEATUSERCMD_CHARID_FIELD = protobuf.FieldDescriptor()
NTFSEATUSERCMD_SEATID_FIELD = protobuf.FieldDescriptor()
NTFSEATUSERCMD_ISSEATDOWN_FIELD = protobuf.FieldDescriptor()
YOYOSEATUSERCMD = protobuf.Descriptor()
YOYOSEATUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
YOYOSEATUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
YOYOSEATUSERCMD_GUID_FIELD = protobuf.FieldDescriptor()
SHOWSEATUSERCMD = protobuf.Descriptor()
SHOWSEATUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SHOWSEATUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SHOWSEATUSERCMD_SEATID_FIELD = protobuf.FieldDescriptor()
SHOWSEATUSERCMD_SHOW_FIELD = protobuf.FieldDescriptor()
SETNORMALSKILLOPTIONUSERCMD = protobuf.Descriptor()
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD = protobuf.FieldDescriptor()
NEWSETOPTIONUSERCMD = protobuf.Descriptor()
NEWSETOPTIONUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
NEWSETOPTIONUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
NEWSETOPTIONUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
NEWSETOPTIONUSERCMD_FLAG_FIELD = protobuf.FieldDescriptor()
UNSOLVEDSCENERYNTFUSERCMD = protobuf.Descriptor()
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD = protobuf.FieldDescriptor()
VISIBLENPC = protobuf.Descriptor()
VISIBLENPC_NPCID_FIELD = protobuf.FieldDescriptor()
VISIBLENPC_POS_FIELD = protobuf.FieldDescriptor()
VISIBLENPC_UNIQUEID_FIELD = protobuf.FieldDescriptor()
NTFVISIBLENPCUSERCMD = protobuf.Descriptor()
NTFVISIBLENPCUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
NTFVISIBLENPCUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
NTFVISIBLENPCUSERCMD_NPCS_FIELD = protobuf.FieldDescriptor()
NTFVISIBLENPCUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
UPYUNAUTHORIZATIONCMD = protobuf.Descriptor()
UPYUNAUTHORIZATIONCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPYUNAUTHORIZATIONCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD = protobuf.FieldDescriptor()
TRANSFORMPREDATACMD = protobuf.Descriptor()
TRANSFORMPREDATACMD_CMD_FIELD = protobuf.FieldDescriptor()
TRANSFORMPREDATACMD_PARAM_FIELD = protobuf.FieldDescriptor()
TRANSFORMPREDATACMD_DATAS_FIELD = protobuf.FieldDescriptor()
USERRENAMECMD = protobuf.Descriptor()
USERRENAMECMD_CMD_FIELD = protobuf.FieldDescriptor()
USERRENAMECMD_PARAM_FIELD = protobuf.FieldDescriptor()
USERRENAMECMD_NAME_FIELD = protobuf.FieldDescriptor()
USERRENAMECMD_CODE_FIELD = protobuf.FieldDescriptor()
BUYZENYCMD = protobuf.Descriptor()
BUYZENYCMD_CMD_FIELD = protobuf.FieldDescriptor()
BUYZENYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BUYZENYCMD_BCOIN_FIELD = protobuf.FieldDescriptor()
BUYZENYCMD_ZENY_FIELD = protobuf.FieldDescriptor()
BUYZENYCMD_RET_FIELD = protobuf.FieldDescriptor()
CALLTEAMERUSERCMD = protobuf.Descriptor()
CALLTEAMERUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CALLTEAMERUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CALLTEAMERUSERCMD_MASTERID_FIELD = protobuf.FieldDescriptor()
CALLTEAMERUSERCMD_SIGN_FIELD = protobuf.FieldDescriptor()
CALLTEAMERUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
CALLTEAMERUSERCMD_USERNAME_FIELD = protobuf.FieldDescriptor()
CALLTEAMERUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
CALLTEAMERUSERCMD_POS_FIELD = protobuf.FieldDescriptor()
CALLTEAMERREPLYUSERCMD = protobuf.Descriptor()
CALLTEAMERREPLYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CALLTEAMERREPLYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD = protobuf.FieldDescriptor()
CALLTEAMERREPLYUSERCMD_SIGN_FIELD = protobuf.FieldDescriptor()
CALLTEAMERREPLYUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
CALLTEAMERREPLYUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
CALLTEAMERREPLYUSERCMD_POS_FIELD = protobuf.FieldDescriptor()
SPECIALEFFECTCMD = protobuf.Descriptor()
SPECIALEFFECTCMD_CMD_FIELD = protobuf.FieldDescriptor()
SPECIALEFFECTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SPECIALEFFECTCMD_DRAMAID_FIELD = protobuf.FieldDescriptor()
SPECIALEFFECTCMD_STARTTIME_FIELD = protobuf.FieldDescriptor()
SPECIALEFFECTCMD_TIMES_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALCMD = protobuf.Descriptor()
MARRIAGEPROPOSALCMD_CMD_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALCMD_MASTERID_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALCMD_ITEMID_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALCMD_TIME_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALCMD_SIGN_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALREPLYCMD = protobuf.Descriptor()
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD = protobuf.FieldDescriptor()
UPLOADWEDDINGPHOTOUSERCMD = protobuf.Descriptor()
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD = protobuf.FieldDescriptor()
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD = protobuf.FieldDescriptor()
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALSUCCESSCMD = protobuf.Descriptor()
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD = protobuf.FieldDescriptor()
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD = protobuf.FieldDescriptor()
INVITEEWEDDINGSTARTNTFUSERCMD = protobuf.Descriptor()
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD = protobuf.FieldDescriptor()
KFCSHAREUSERCMD = protobuf.Descriptor()
KFCSHAREUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
KFCSHAREUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
KFCSHAREUSERCMD_SHARETYPE_FIELD = protobuf.FieldDescriptor()
KFCENROLLUSERCMD = protobuf.Descriptor()
KFCENROLLUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
KFCENROLLUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
KFCENROLLUSERCMD_PHONE_FIELD = protobuf.FieldDescriptor()
KFCENROLLCODEUSERCMD = protobuf.Descriptor()
KFCENROLLCODEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
KFCENROLLCODEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
KFCENROLLCODEUSERCMD_CODE_FIELD = protobuf.FieldDescriptor()
KFCENROLLCODEUSERCMD_DISTRICT_FIELD = protobuf.FieldDescriptor()
KFCENROLLREPLYUSERCMD = protobuf.Descriptor()
KFCENROLLREPLYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
KFCENROLLREPLYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
KFCENROLLREPLYUSERCMD_RESULT_FIELD = protobuf.FieldDescriptor()
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD = protobuf.FieldDescriptor()
KFCENROLLREPLYUSERCMD_INDEX_FIELD = protobuf.FieldDescriptor()
KFCENROLLQUERYUSERCMD = protobuf.Descriptor()
KFCENROLLQUERYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
KFCENROLLQUERYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
KFCHASENROLLEDUSERCMD = protobuf.Descriptor()
KFCHASENROLLEDUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
KFCHASENROLLEDUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD = protobuf.FieldDescriptor()
CHECKRELATIONUSERCMD = protobuf.Descriptor()
CHECKRELATIONUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHECKRELATIONUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHECKRELATIONUSERCMD_CHARID_FIELD = protobuf.FieldDescriptor()
CHECKRELATIONUSERCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
CHECKRELATIONUSERCMD_RET_FIELD = protobuf.FieldDescriptor()
TWINSACTIONUSERCMD = protobuf.Descriptor()
TWINSACTIONUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
TWINSACTIONUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TWINSACTIONUSERCMD_USERID_FIELD = protobuf.FieldDescriptor()
TWINSACTIONUSERCMD_ACTIONID_FIELD = protobuf.FieldDescriptor()
TWINSACTIONUSERCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
TWINSACTIONUSERCMD_SPONSOR_FIELD = protobuf.FieldDescriptor()
SHOWSERVANTUSERCMD = protobuf.Descriptor()
SHOWSERVANTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SHOWSERVANTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SHOWSERVANTUSERCMD_SHOW_FIELD = protobuf.FieldDescriptor()
REPLACESERVANTUSERCMD = protobuf.Descriptor()
REPLACESERVANTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
REPLACESERVANTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
REPLACESERVANTUSERCMD_REPLACE_FIELD = protobuf.FieldDescriptor()
REPLACESERVANTUSERCMD_SERVANT_FIELD = protobuf.FieldDescriptor()
SERVANTSERVICE = protobuf.Descriptor()
SERVANTSERVICE_CMD_FIELD = protobuf.FieldDescriptor()
SERVANTSERVICE_PARAM_FIELD = protobuf.FieldDescriptor()
SERVANTSERVICE_TYPE_FIELD = protobuf.FieldDescriptor()
RECOMMENDITEMINFO = protobuf.Descriptor()
RECOMMENDITEMINFO_DWID_FIELD = protobuf.FieldDescriptor()
RECOMMENDITEMINFO_FINISHTIMES_FIELD = protobuf.FieldDescriptor()
RECOMMENDITEMINFO_STATUS_FIELD = protobuf.FieldDescriptor()
RECOMMENDITEMINFO_REALOPEN_FIELD = protobuf.FieldDescriptor()
RECOMMENDSERVANTUSERCMD = protobuf.Descriptor()
RECOMMENDSERVANTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
RECOMMENDSERVANTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
RECEIVESERVANTUSERCMD = protobuf.Descriptor()
RECEIVESERVANTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
RECEIVESERVANTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD = protobuf.FieldDescriptor()
RECEIVESERVANTUSERCMD_DWID_FIELD = protobuf.FieldDescriptor()
FAVORABILITYSTATUS = protobuf.Descriptor()
FAVORABILITYSTATUS_FAVORABILITY_FIELD = protobuf.FieldDescriptor()
FAVORABILITYSTATUS_STATUS_FIELD = protobuf.FieldDescriptor()
SERVANTREWARDSTATUSUSERCMD = protobuf.Descriptor()
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD = protobuf.FieldDescriptor()
PROFESSIONINFO = protobuf.Descriptor()
PROFESSIONINFO_BRANCH_FIELD = protobuf.FieldDescriptor()
PROFESSIONINFO_PROFESSION_FIELD = protobuf.FieldDescriptor()
PROFESSIONINFO_JOBLV_FIELD = protobuf.FieldDescriptor()
PROFESSIONINFO_ISCURRENT_FIELD = protobuf.FieldDescriptor()
PROFESSIONINFO_ISBUY_FIELD = protobuf.FieldDescriptor()
PROFESSIONQUERYUSERCMD = protobuf.Descriptor()
PROFESSIONQUERYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
PROFESSIONQUERYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
PROFESSIONQUERYUSERCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
PROFESSIONBUYUSERCMD = protobuf.Descriptor()
PROFESSIONBUYUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
PROFESSIONBUYUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
PROFESSIONBUYUSERCMD_BRANCH_FIELD = protobuf.FieldDescriptor()
PROFESSIONBUYUSERCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD = protobuf.FieldDescriptor()
PROFESSIONCHANGEUSERCMD = protobuf.Descriptor()
PROFESSIONCHANGEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
PROFESSIONCHANGEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD = protobuf.FieldDescriptor()
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
ASTROLABEPROFESSIONDATA = protobuf.Descriptor()
ASTROLABEPROFESSIONDATA_STARS_FIELD = protobuf.FieldDescriptor()
ATTRPROFESSIONDATA = protobuf.Descriptor()
ATTRPROFESSIONDATA_ATTRS_FIELD = protobuf.FieldDescriptor()
ATTRPROFESSIONDATA_DATAS_FIELD = protobuf.FieldDescriptor()
EQUIPINFO = protobuf.Descriptor()
EQUIPINFO_POS_FIELD = protobuf.FieldDescriptor()
EQUIPINFO_TYPE_ID_FIELD = protobuf.FieldDescriptor()
EQUIPINFO_GUID_FIELD = protobuf.FieldDescriptor()
EQUIPPACKDATA = protobuf.Descriptor()
EQUIPPACKDATA_TYPE_FIELD = protobuf.FieldDescriptor()
EQUIPPACKDATA_DATAS_FIELD = protobuf.FieldDescriptor()
SKILLVALIDPOSDATA = protobuf.Descriptor()
SKILLVALIDPOSDATA_POS_FIELD = protobuf.FieldDescriptor()
SKILLVALIDPOSDATA_AUTOPOS_FIELD = protobuf.FieldDescriptor()
SKILLVALIDPOSDATA_EXTENDPOS_FIELD = protobuf.FieldDescriptor()
SKILLPROFESSIONDATA = protobuf.Descriptor()
SKILLPROFESSIONDATA_LEFT_POINT_FIELD = protobuf.FieldDescriptor()
SKILLPROFESSIONDATA_DATAS_FIELD = protobuf.FieldDescriptor()
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD = protobuf.FieldDescriptor()
SKILLPROFESSIONDATA_BEINGS_FIELD = protobuf.FieldDescriptor()
SKILLPROFESSIONDATA_CURBEINGID_FIELD = protobuf.FieldDescriptor()
SKILLPROFESSIONDATA_BEINGINFOS_FIELD = protobuf.FieldDescriptor()
SKILLPROFESSIONDATA_SKILLPOS_FIELD = protobuf.FieldDescriptor()
SKILLPROFESSIONDATA_SHORTCUT_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO = protobuf.Descriptor()
PROFESSIONUSERINFO_ID_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_PROFESSION_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_JOBLV_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_JOBEXP_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_TYPE_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_RECORDNAME_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_RECORDTIME_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_CHARID_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_CHARNAME_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_ATTR_DATA_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_EQUIP_DATA_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_SKILL_DATA_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_ISFIRST_FIELD = protobuf.FieldDescriptor()
PROFESSIONUSERINFO_ISBUY_FIELD = protobuf.FieldDescriptor()
SLOTINFO = protobuf.Descriptor()
SLOTINFO_ID_FIELD = protobuf.FieldDescriptor()
SLOTINFO_TYPE_FIELD = protobuf.FieldDescriptor()
SLOTINFO_ACTIVE_FIELD = protobuf.FieldDescriptor()
SLOTINFO_COSTID_FIELD = protobuf.FieldDescriptor()
SLOTINFO_COSTNUM_FIELD = protobuf.FieldDescriptor()
USERASTROLMATERIALDATA = protobuf.Descriptor()
USERASTROLMATERIALDATA_CHARID_FIELD = protobuf.FieldDescriptor()
USERASTROLMATERIALDATA_MATERIALS_FIELD = protobuf.FieldDescriptor()
UPDATERECORDINFOUSERCMD = protobuf.Descriptor()
UPDATERECORDINFOUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATERECORDINFOUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATERECORDINFOUSERCMD_SLOTS_FIELD = protobuf.FieldDescriptor()
UPDATERECORDINFOUSERCMD_RECORDS_FIELD = protobuf.FieldDescriptor()
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD = protobuf.FieldDescriptor()
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD = protobuf.FieldDescriptor()
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD = protobuf.FieldDescriptor()
SAVERECORDUSERCMD = protobuf.Descriptor()
SAVERECORDUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SAVERECORDUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SAVERECORDUSERCMD_SLOTID_FIELD = protobuf.FieldDescriptor()
SAVERECORDUSERCMD_RECORD_NAME_FIELD = protobuf.FieldDescriptor()
LOADRECORDUSERCMD = protobuf.Descriptor()
LOADRECORDUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
LOADRECORDUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LOADRECORDUSERCMD_SLOTID_FIELD = protobuf.FieldDescriptor()
CHANGERECORDNAMEUSERCMD = protobuf.Descriptor()
CHANGERECORDNAMEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHANGERECORDNAMEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD = protobuf.FieldDescriptor()
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD = protobuf.FieldDescriptor()
BUYRECORDSLOTUSERCMD = protobuf.Descriptor()
BUYRECORDSLOTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
BUYRECORDSLOTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BUYRECORDSLOTUSERCMD_SLOTID_FIELD = protobuf.FieldDescriptor()
DELETERECORDUSERCMD = protobuf.Descriptor()
DELETERECORDUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
DELETERECORDUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DELETERECORDUSERCMD_SLOTID_FIELD = protobuf.FieldDescriptor()
UPDATEBRANCHINFOUSERCMD = protobuf.Descriptor()
UPDATEBRANCHINFOUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD = protobuf.FieldDescriptor()
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD = protobuf.FieldDescriptor()
ENTERCAPRAACTIVITYCMD = protobuf.Descriptor()
ENTERCAPRAACTIVITYCMD_CMD_FIELD = protobuf.FieldDescriptor()
ENTERCAPRAACTIVITYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITEWITHMEUSERCMD = protobuf.Descriptor()
INVITEWITHMEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
INVITEWITHMEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITEWITHMEUSERCMD_SENDID_FIELD = protobuf.FieldDescriptor()
INVITEWITHMEUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
INVITEWITHMEUSERCMD_REPLY_FIELD = protobuf.FieldDescriptor()
INVITEWITHMEUSERCMD_SIGN_FIELD = protobuf.FieldDescriptor()
QUERYALTMANKILLUSERCMD = protobuf.Descriptor()
QUERYALTMANKILLUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYALTMANKILLUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BOOTHINFO = protobuf.Descriptor()
BOOTHINFO_NAME_FIELD = protobuf.FieldDescriptor()
BOOTHINFO_SIGN_FIELD = protobuf.FieldDescriptor()
BOOTHREQUSERCMD = protobuf.Descriptor()
BOOTHREQUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
BOOTHREQUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BOOTHREQUSERCMD_NAME_FIELD = protobuf.FieldDescriptor()
BOOTHREQUSERCMD_OPER_FIELD = protobuf.FieldDescriptor()
BOOTHREQUSERCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
BOOTHINFOSYNCUSERCMD = protobuf.Descriptor()
BOOTHINFOSYNCUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
BOOTHINFOSYNCUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BOOTHINFOSYNCUSERCMD_CHARID_FIELD = protobuf.FieldDescriptor()
BOOTHINFOSYNCUSERCMD_OPER_FIELD = protobuf.FieldDescriptor()
BOOTHINFOSYNCUSERCMD_INFO_FIELD = protobuf.FieldDescriptor()
DRESSUPMODELUSERCMD = protobuf.Descriptor()
DRESSUPMODELUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
DRESSUPMODELUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DRESSUPMODELUSERCMD_STAGEID_FIELD = protobuf.FieldDescriptor()
DRESSUPMODELUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
DRESSUPMODELUSERCMD_VALUE_FIELD = protobuf.FieldDescriptor()
DRESSUPHEADUSERCMD = protobuf.Descriptor()
DRESSUPHEADUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
DRESSUPHEADUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DRESSUPHEADUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
DRESSUPHEADUSERCMD_VALUE_FIELD = protobuf.FieldDescriptor()
DRESSUPHEADUSERCMD_PUTON_FIELD = protobuf.FieldDescriptor()
STAGEINFO = protobuf.Descriptor()
STAGEINFO_STAGEID_FIELD = protobuf.FieldDescriptor()
STAGEINFO_USERNUM_FIELD = protobuf.FieldDescriptor()
STAGEINFO_WAITTIME_FIELD = protobuf.FieldDescriptor()
STAGEINFO_STATUS_FIELD = protobuf.FieldDescriptor()
QUERYSTAGEUSERCMD = protobuf.Descriptor()
QUERYSTAGEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYSTAGEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYSTAGEUSERCMD_STAGEID_FIELD = protobuf.FieldDescriptor()
QUERYSTAGEUSERCMD_INFO_FIELD = protobuf.FieldDescriptor()
DRESSUPLINEUPUSERCMD = protobuf.Descriptor()
DRESSUPLINEUPUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
DRESSUPLINEUPUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DRESSUPLINEUPUSERCMD_STAGEID_FIELD = protobuf.FieldDescriptor()
DRESSUPLINEUPUSERCMD_MODE_FIELD = protobuf.FieldDescriptor()
DRESSUPLINEUPUSERCMD_ENTER_FIELD = protobuf.FieldDescriptor()
STAGEUSERDATATYPE = protobuf.Descriptor()
STAGEUSERDATATYPE_TYPE_FIELD = protobuf.FieldDescriptor()
STAGEUSERDATATYPE_VALUE_FIELD = protobuf.FieldDescriptor()
DRESSUPSTAGEUSERCMD = protobuf.Descriptor()
DRESSUPSTAGEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
DRESSUPSTAGEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DRESSUPSTAGEUSERCMD_USERID_FIELD = protobuf.FieldDescriptor()
DRESSUPSTAGEUSERCMD_STAGEID_FIELD = protobuf.FieldDescriptor()
DRESSUPSTAGEUSERCMD_DATAS_FIELD = protobuf.FieldDescriptor()
GOTOFUNCTIONMAPUSERCMD = protobuf.Descriptor()
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
GROWTHCURINFO = protobuf.Descriptor()
GROWTHCURINFO_TYPE_FIELD = protobuf.FieldDescriptor()
GROWTHCURINFO_GROUPID_FIELD = protobuf.FieldDescriptor()
GROWTHITEMINFO = protobuf.Descriptor()
GROWTHITEMINFO_DWID_FIELD = protobuf.FieldDescriptor()
GROWTHITEMINFO_FINISHTIMES_FIELD = protobuf.FieldDescriptor()
GROWTHITEMINFO_STATUS_FIELD = protobuf.FieldDescriptor()
GROWTHVALUEINFO = protobuf.Descriptor()
GROWTHVALUEINFO_GROUPID_FIELD = protobuf.FieldDescriptor()
GROWTHVALUEINFO_GROWTH_FIELD = protobuf.FieldDescriptor()
GROWTHVALUEINFO_EVERREWARD_FIELD = protobuf.FieldDescriptor()
GROWTHGROUPINFO = protobuf.Descriptor()
GROWTHGROUPINFO_ITEMS_FIELD = protobuf.FieldDescriptor()
GROWTHGROUPINFO_VALUEITEMS_FIELD = protobuf.FieldDescriptor()
GROWTHSERVANTUSERCMD = protobuf.Descriptor()
GROWTHSERVANTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GROWTHSERVANTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GROWTHSERVANTUSERCMD_DATAS_FIELD = protobuf.FieldDescriptor()
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD = protobuf.FieldDescriptor()
RECEIVEGROWTHSERVANTUSERCMD = protobuf.Descriptor()
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD = protobuf.FieldDescriptor()
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD = protobuf.FieldDescriptor()
GROWTHOPENSERVANTUSERCMD = protobuf.Descriptor()
GROWTHOPENSERVANTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD = protobuf.FieldDescriptor()
CHEATTAGUSERCMD = protobuf.Descriptor()
CHEATTAGUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHEATTAGUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHEATTAGUSERCMD_INTERVAL_FIELD = protobuf.FieldDescriptor()
CHEATTAGUSERCMD_FRAME_FIELD = protobuf.FieldDescriptor()
BUTTONTHRESHOLD = protobuf.Descriptor()
BUTTONTHRESHOLD_BUTTON_FIELD = protobuf.FieldDescriptor()
BUTTONTHRESHOLD_THRESHOLD_FIELD = protobuf.FieldDescriptor()
CHEATTAGSTATUSERCMD = protobuf.Descriptor()
CHEATTAGSTATUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHEATTAGSTATUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHEATTAGSTATUSERCMD_CHEATED_FIELD = protobuf.FieldDescriptor()
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD = protobuf.FieldDescriptor()
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD = protobuf.FieldDescriptor()
CLICKPOSLIST = protobuf.Descriptor()
CLICKPOSLIST_CMD_FIELD = protobuf.FieldDescriptor()
CLICKPOSLIST_PARAM_FIELD = protobuf.FieldDescriptor()
CLICKPOSLIST_CLICKBUTTONPOS_FIELD = protobuf.FieldDescriptor()
CLICKBUTTONPOS = protobuf.Descriptor()
CLICKBUTTONPOS_BUTTON_FIELD = protobuf.FieldDescriptor()
CLICKBUTTONPOS_POS_FIELD = protobuf.FieldDescriptor()
CLICKBUTTONPOS_COUNT_FIELD = protobuf.FieldDescriptor()
SIGNINUSERCMD = protobuf.Descriptor()
SIGNINUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SIGNINUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SIGNINUSERCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
SIGNINNTFUSERCMD = protobuf.Descriptor()
SIGNINNTFUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SIGNINNTFUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SIGNINNTFUSERCMD_COUNT_FIELD = protobuf.FieldDescriptor()
SIGNINNTFUSERCMD_ISSIGN_FIELD = protobuf.FieldDescriptor()
SIGNINNTFUSERCMD_ISSHOWED_FIELD = protobuf.FieldDescriptor()
BEATPORIUSERCMD = protobuf.Descriptor()
BEATPORIUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
BEATPORIUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BEATPORIUSERCMD_START_FIELD = protobuf.FieldDescriptor()
BEATPORIUSERCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
UNLOCKFRAMEUSERCMD = protobuf.Descriptor()
UNLOCKFRAMEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
UNLOCKFRAMEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD = protobuf.FieldDescriptor()
REWARDITEM = protobuf.Descriptor()
REWARDITEM_REWARDID_FIELD = protobuf.FieldDescriptor()
REWARDITEM_STATUS_FIELD = protobuf.FieldDescriptor()
ALTMANREWARDUSERCMD = protobuf.Descriptor()
ALTMANREWARDUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
ALTMANREWARDUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ALTMANREWARDUSERCMD_PASSTIME_FIELD = protobuf.FieldDescriptor()
ALTMANREWARDUSERCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
ALTMANREWARDUSERCMD_GETREWARDID_FIELD = protobuf.FieldDescriptor()
SERVANTRESERVATIONITEM = protobuf.Descriptor()
SERVANTRESERVATIONITEM_DATE_FIELD = protobuf.FieldDescriptor()
SERVANTRESERVATIONITEM_ACTIDS_FIELD = protobuf.FieldDescriptor()
SERVANTRESERVATIONITEM_TYPE_FIELD = protobuf.FieldDescriptor()
SERVANTREQRESERVATIONUSERCMD = protobuf.Descriptor()
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD = protobuf.FieldDescriptor()
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD = protobuf.FieldDescriptor()
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD = protobuf.FieldDescriptor()
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
SERVANTRESERVATIONUSERCMD = protobuf.Descriptor()
SERVANTRESERVATIONUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SERVANTRESERVATIONUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SERVANTRESERVATIONUSERCMD_DATAS_FIELD = protobuf.FieldDescriptor()
SERVANTRESERVATIONUSERCMD_OPT_FIELD = protobuf.FieldDescriptor()
SERVANTEQUIPITEM = protobuf.Descriptor()
SERVANTEQUIPITEM_ID_FIELD = protobuf.FieldDescriptor()
SERVANTEQUIPITEM_EQUIPID_FIELD = protobuf.FieldDescriptor()
SERVANTRECEQUIPUSERCMD = protobuf.Descriptor()
SERVANTRECEQUIPUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SERVANTRECEQUIPUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SERVANTRECEQUIPUSERCMD_DATAS_FIELD = protobuf.FieldDescriptor()
USER2PARAM_USER2PARAM_GOCITY_ENUM.name = "USER2PARAM_GOCITY"
USER2PARAM_USER2PARAM_GOCITY_ENUM.index = 0
USER2PARAM_USER2PARAM_GOCITY_ENUM.number = 1
USER2PARAM_USER2PARAM_SYSMSG_ENUM.name = "USER2PARAM_SYSMSG"
USER2PARAM_USER2PARAM_SYSMSG_ENUM.index = 1
USER2PARAM_USER2PARAM_SYSMSG_ENUM.number = 2
USER2PARAM_USER2PARAM_NPCDATASYNC_ENUM.name = "USER2PARAM_NPCDATASYNC"
USER2PARAM_USER2PARAM_NPCDATASYNC_ENUM.index = 2
USER2PARAM_USER2PARAM_NPCDATASYNC_ENUM.number = 3
USER2PARAM_USER2PARAM_USERNINESYNC_ENUM.name = "USER2PARAM_USERNINESYNC"
USER2PARAM_USER2PARAM_USERNINESYNC_ENUM.index = 3
USER2PARAM_USER2PARAM_USERNINESYNC_ENUM.number = 4
USER2PARAM_USER2PARAM_ACTION_ENUM.name = "USER2PARAM_ACTION"
USER2PARAM_USER2PARAM_ACTION_ENUM.index = 4
USER2PARAM_USER2PARAM_ACTION_ENUM.number = 5
USER2PARAM_USER2PARAM_BUFFERSYNC_ENUM.name = "USER2PARAM_BUFFERSYNC"
USER2PARAM_USER2PARAM_BUFFERSYNC_ENUM.index = 5
USER2PARAM_USER2PARAM_BUFFERSYNC_ENUM.number = 6
USER2PARAM_USER2PARAM_EXIT_POS_ENUM.name = "USER2PARAM_EXIT_POS"
USER2PARAM_USER2PARAM_EXIT_POS_ENUM.index = 6
USER2PARAM_USER2PARAM_EXIT_POS_ENUM.number = 7
USER2PARAM_USER2PARAM_RELIVE_ENUM.name = "USER2PARAM_RELIVE"
USER2PARAM_USER2PARAM_RELIVE_ENUM.index = 7
USER2PARAM_USER2PARAM_RELIVE_ENUM.number = 8
USER2PARAM_USER2PARAM_VAR_ENUM.name = "USER2PARAM_VAR"
USER2PARAM_USER2PARAM_VAR_ENUM.index = 8
USER2PARAM_USER2PARAM_VAR_ENUM.number = 9
USER2PARAM_USER2PARAM_TALKINFO_ENUM.name = "USER2PARAM_TALKINFO"
USER2PARAM_USER2PARAM_TALKINFO_ENUM.index = 9
USER2PARAM_USER2PARAM_TALKINFO_ENUM.number = 10
USER2PARAM_USER2PARAM_SERVERTIME_ENUM.name = "USER2PARAM_SERVERTIME"
USER2PARAM_USER2PARAM_SERVERTIME_ENUM.index = 10
USER2PARAM_USER2PARAM_SERVERTIME_ENUM.number = 11
USER2PARAM_USER2PARAM_NEWTRANSMAP_ENUM.name = "USER2PARAM_NEWTRANSMAP"
USER2PARAM_USER2PARAM_NEWTRANSMAP_ENUM.index = 11
USER2PARAM_USER2PARAM_NEWTRANSMAP_ENUM.number = 12
USER2PARAM_USER2PARAM_EFFECT_ENUM.name = "USER2PARAM_EFFECT"
USER2PARAM_USER2PARAM_EFFECT_ENUM.index = 12
USER2PARAM_USER2PARAM_EFFECT_ENUM.number = 14
USER2PARAM_USER2PARAM_MENU_ENUM.name = "USER2PARAM_MENU"
USER2PARAM_USER2PARAM_MENU_ENUM.index = 13
USER2PARAM_USER2PARAM_MENU_ENUM.number = 15
USER2PARAM_USER2PARAM_NEWMENU_ENUM.name = "USER2PARAM_NEWMENU"
USER2PARAM_USER2PARAM_NEWMENU_ENUM.index = 14
USER2PARAM_USER2PARAM_NEWMENU_ENUM.number = 16
USER2PARAM_USER2PARAM_TEAMINFONINE_ENUM.name = "USER2PARAM_TEAMINFONINE"
USER2PARAM_USER2PARAM_TEAMINFONINE_ENUM.index = 15
USER2PARAM_USER2PARAM_TEAMINFONINE_ENUM.number = 17
USER2PARAM_USER2PARAM_USEPORTRAIT_ENUM.name = "USER2PARAM_USEPORTRAIT"
USER2PARAM_USER2PARAM_USEPORTRAIT_ENUM.index = 16
USER2PARAM_USER2PARAM_USEPORTRAIT_ENUM.number = 18
USER2PARAM_USER2PARAM_USEFRAME_ENUM.name = "USER2PARAM_USEFRAME"
USER2PARAM_USER2PARAM_USEFRAME_ENUM.index = 17
USER2PARAM_USER2PARAM_USEFRAME_ENUM.number = 19
USER2PARAM_USER2PARAM_NEWPORTRAITFRAME_ENUM.name = "USER2PARAM_NEWPORTRAITFRAME"
USER2PARAM_USER2PARAM_NEWPORTRAITFRAME_ENUM.index = 18
USER2PARAM_USER2PARAM_NEWPORTRAITFRAME_ENUM.number = 20
USER2PARAM_USER2PARAM_QUERYPORTRAITLIST_ENUM.name = "USER2PARAM_QUERYPORTRAITLIST"
USER2PARAM_USER2PARAM_QUERYPORTRAITLIST_ENUM.index = 19
USER2PARAM_USER2PARAM_QUERYPORTRAITLIST_ENUM.number = 24
USER2PARAM_USER2PARAM_ADDATTRPOINT_ENUM.name = "USER2PARAM_ADDATTRPOINT"
USER2PARAM_USER2PARAM_ADDATTRPOINT_ENUM.index = 20
USER2PARAM_USER2PARAM_ADDATTRPOINT_ENUM.number = 21
USER2PARAM_USER2PARAM_QUERYSHOPGOTITEM_ENUM.name = "USER2PARAM_QUERYSHOPGOTITEM"
USER2PARAM_USER2PARAM_QUERYSHOPGOTITEM_ENUM.index = 21
USER2PARAM_USER2PARAM_QUERYSHOPGOTITEM_ENUM.number = 22
USER2PARAM_USER2PARAM_UPDATESHOPGOTITEM_ENUM.name = "USER2PARAM_UPDATESHOPGOTITEM"
USER2PARAM_USER2PARAM_UPDATESHOPGOTITEM_ENUM.index = 22
USER2PARAM_USER2PARAM_UPDATESHOPGOTITEM_ENUM.number = 23
USER2PARAM_USER2PARAM_USEDRESSING_ENUM.name = "USER2PARAM_USEDRESSING"
USER2PARAM_USER2PARAM_USEDRESSING_ENUM.index = 23
USER2PARAM_USER2PARAM_USEDRESSING_ENUM.number = 25
USER2PARAM_USER2PARAM_NEWDRESSING_ENUM.name = "USER2PARAM_NEWDRESSING"
USER2PARAM_USER2PARAM_NEWDRESSING_ENUM.index = 24
USER2PARAM_USER2PARAM_NEWDRESSING_ENUM.number = 26
USER2PARAM_USER2PARAM_DRESSINGLIST_ENUM.name = "USER2PARAM_DRESSINGLIST"
USER2PARAM_USER2PARAM_DRESSINGLIST_ENUM.index = 25
USER2PARAM_USER2PARAM_DRESSINGLIST_ENUM.number = 27
USER2PARAM_USER2PARAM_OPENUI_ENUM.name = "USER2PARAM_OPENUI"
USER2PARAM_USER2PARAM_OPENUI_ENUM.index = 26
USER2PARAM_USER2PARAM_OPENUI_ENUM.number = 29
USER2PARAM_USER2PARAM_DBGSYSMSG_ENUM.name = "USER2PARAM_DBGSYSMSG"
USER2PARAM_USER2PARAM_DBGSYSMSG_ENUM.index = 27
USER2PARAM_USER2PARAM_DBGSYSMSG_ENUM.number = 30
USER2PARAM_USER2PARAM_FOLLOWTRANSFER_ENUM.name = "USER2PARAM_FOLLOWTRANSFER"
USER2PARAM_USER2PARAM_FOLLOWTRANSFER_ENUM.index = 28
USER2PARAM_USER2PARAM_FOLLOWTRANSFER_ENUM.number = 32
USER2PARAM_USER2PARAM_NPCFUNC_ENUM.name = "USER2PARAM_NPCFUNC"
USER2PARAM_USER2PARAM_NPCFUNC_ENUM.index = 29
USER2PARAM_USER2PARAM_NPCFUNC_ENUM.number = 33
USER2PARAM_USER2PARAM_MODELSHOW_ENUM.name = "USER2PARAM_MODELSHOW"
USER2PARAM_USER2PARAM_MODELSHOW_ENUM.index = 30
USER2PARAM_USER2PARAM_MODELSHOW_ENUM.number = 34
USER2PARAM_USER2PARAM_SOUNDEFFECT_ENUM.name = "USER2PARAM_SOUNDEFFECT"
USER2PARAM_USER2PARAM_SOUNDEFFECT_ENUM.index = 31
USER2PARAM_USER2PARAM_SOUNDEFFECT_ENUM.number = 35
USER2PARAM_USER2PARAM_PRESETCHATMSG_ENUM.name = "USER2PARAM_PRESETCHATMSG"
USER2PARAM_USER2PARAM_PRESETCHATMSG_ENUM.index = 32
USER2PARAM_USER2PARAM_PRESETCHATMSG_ENUM.number = 36
USER2PARAM_USER2PARAM_CHANGEBGM_ENUM.name = "USER2PARAM_CHANGEBGM"
USER2PARAM_USER2PARAM_CHANGEBGM_ENUM.index = 33
USER2PARAM_USER2PARAM_CHANGEBGM_ENUM.number = 37
USER2PARAM_USER2PARAM_QUERYFIGHTERINFO_ENUM.name = "USER2PARAM_QUERYFIGHTERINFO"
USER2PARAM_USER2PARAM_QUERYFIGHTERINFO_ENUM.index = 34
USER2PARAM_USER2PARAM_QUERYFIGHTERINFO_ENUM.number = 38
USER2PARAM_USER2PARAM_GAMETIME_ENUM.name = "USER2PARAM_GAMETIME"
USER2PARAM_USER2PARAM_GAMETIME_ENUM.index = 35
USER2PARAM_USER2PARAM_GAMETIME_ENUM.number = 40
USER2PARAM_USER2PARAM_CDTIME_ENUM.name = "USER2PARAM_CDTIME"
USER2PARAM_USER2PARAM_CDTIME_ENUM.index = 36
USER2PARAM_USER2PARAM_CDTIME_ENUM.number = 41
USER2PARAM_USER2PARAM_STATECHANGE_ENUM.name = "USER2PARAM_STATECHANGE"
USER2PARAM_USER2PARAM_STATECHANGE_ENUM.index = 37
USER2PARAM_USER2PARAM_STATECHANGE_ENUM.number = 42
USER2PARAM_USER2PARAM_PHOTO_ENUM.name = "USER2PARAM_PHOTO"
USER2PARAM_USER2PARAM_PHOTO_ENUM.index = 38
USER2PARAM_USER2PARAM_PHOTO_ENUM.number = 44
USER2PARAM_USER2PARAM_SHAKESCREEN_ENUM.name = "USER2PARAM_SHAKESCREEN"
USER2PARAM_USER2PARAM_SHAKESCREEN_ENUM.index = 39
USER2PARAM_USER2PARAM_SHAKESCREEN_ENUM.number = 45
USER2PARAM_USER2PARAM_QUERYSHORTCUT_ENUM.name = "USER2PARAM_QUERYSHORTCUT"
USER2PARAM_USER2PARAM_QUERYSHORTCUT_ENUM.index = 40
USER2PARAM_USER2PARAM_QUERYSHORTCUT_ENUM.number = 47
USER2PARAM_USER2PARAM_PUTSHORTCUT_ENUM.name = "USER2PARAM_PUTSHORTCUT"
USER2PARAM_USER2PARAM_PUTSHORTCUT_ENUM.index = 41
USER2PARAM_USER2PARAM_PUTSHORTCUT_ENUM.number = 48
USER2PARAM_USER2PARAM_NPCANGLE_ENUM.name = "USER2PARAM_NPCANGLE"
USER2PARAM_USER2PARAM_NPCANGLE_ENUM.index = 42
USER2PARAM_USER2PARAM_NPCANGLE_ENUM.number = 49
USER2PARAM_USER2PARAM_CAMERAFOCUS_ENUM.name = "USER2PARAM_CAMERAFOCUS"
USER2PARAM_USER2PARAM_CAMERAFOCUS_ENUM.index = 43
USER2PARAM_USER2PARAM_CAMERAFOCUS_ENUM.number = 50
USER2PARAM_USER2PARAM_GOTO_LIST_ENUM.name = "USER2PARAM_GOTO_LIST"
USER2PARAM_USER2PARAM_GOTO_LIST_ENUM.index = 44
USER2PARAM_USER2PARAM_GOTO_LIST_ENUM.number = 51
USER2PARAM_USER2PARAM_GOTO_GEAR_ENUM.name = "USER2PARAM_GOTO_GEAR"
USER2PARAM_USER2PARAM_GOTO_GEAR_ENUM.index = 45
USER2PARAM_USER2PARAM_GOTO_GEAR_ENUM.number = 52
USER2PARAM_USER2PARAM_FOLLOWER_ENUM.name = "USER2PARAM_FOLLOWER"
USER2PARAM_USER2PARAM_FOLLOWER_ENUM.index = 46
USER2PARAM_USER2PARAM_FOLLOWER_ENUM.number = 53
USER2PARAM_USER2PARAM_LABORATORY_ENUM.name = "USER2PARAM_LABORATORY"
USER2PARAM_USER2PARAM_LABORATORY_ENUM.index = 47
USER2PARAM_USER2PARAM_LABORATORY_ENUM.number = 54
USER2PARAM_USER2PARAM_EXCHANGEPROFESSION_ENUM.name = "USER2PARAM_EXCHANGEPROFESSION"
USER2PARAM_USER2PARAM_EXCHANGEPROFESSION_ENUM.index = 48
USER2PARAM_USER2PARAM_EXCHANGEPROFESSION_ENUM.number = 56
USER2PARAM_USER2PARAM_GOTO_LABORATORY_ENUM.name = "USER2PARAM_GOTO_LABORATORY"
USER2PARAM_USER2PARAM_GOTO_LABORATORY_ENUM.index = 49
USER2PARAM_USER2PARAM_GOTO_LABORATORY_ENUM.number = 57
USER2PARAM_USER2PARAM_SCENERY_ENUM.name = "USER2PARAM_SCENERY"
USER2PARAM_USER2PARAM_SCENERY_ENUM.index = 50
USER2PARAM_USER2PARAM_SCENERY_ENUM.number = 58
USER2PARAM_USER2PARAM_GOMAP_QUEST_ENUM.name = "USER2PARAM_GOMAP_QUEST"
USER2PARAM_USER2PARAM_GOMAP_QUEST_ENUM.index = 51
USER2PARAM_USER2PARAM_GOMAP_QUEST_ENUM.number = 59
USER2PARAM_USER2PARAM_GOMAP_FOLLOW_ENUM.name = "USER2PARAM_GOMAP_FOLLOW"
USER2PARAM_USER2PARAM_GOMAP_FOLLOW_ENUM.index = 52
USER2PARAM_USER2PARAM_GOMAP_FOLLOW_ENUM.number = 60
USER2PARAM_USER2PARAM_AUTOHIT_ENUM.name = "USER2PARAM_AUTOHIT"
USER2PARAM_USER2PARAM_AUTOHIT_ENUM.index = 53
USER2PARAM_USER2PARAM_AUTOHIT_ENUM.number = 61
USER2PARAM_USER2PARAM_UPLOAD_SCENERY_PHOTO_ENUM.name = "USER2PARAM_UPLOAD_SCENERY_PHOTO"
USER2PARAM_USER2PARAM_UPLOAD_SCENERY_PHOTO_ENUM.index = 54
USER2PARAM_USER2PARAM_UPLOAD_SCENERY_PHOTO_ENUM.number = 62
USER2PARAM_USER2PARAM_QUERY_MAPAREA_ENUM.name = "USER2PARAM_QUERY_MAPAREA"
USER2PARAM_USER2PARAM_QUERY_MAPAREA_ENUM.index = 55
USER2PARAM_USER2PARAM_QUERY_MAPAREA_ENUM.number = 63
USER2PARAM_USER2PARAM_NEW_MAPAREA_ENUM.name = "USER2PARAM_NEW_MAPAREA"
USER2PARAM_USER2PARAM_NEW_MAPAREA_ENUM.index = 56
USER2PARAM_USER2PARAM_NEW_MAPAREA_ENUM.number = 64
USER2PARAM_USER2PARAM_FOREVER_BUFF_ENUM.name = "USER2PARAM_FOREVER_BUFF"
USER2PARAM_USER2PARAM_FOREVER_BUFF_ENUM.index = 57
USER2PARAM_USER2PARAM_FOREVER_BUFF_ENUM.number = 66
USER2PARAM_USER2PARAM_INVITE_JOIN_HANDS_ENUM.name = "USER2PARAM_INVITE_JOIN_HANDS"
USER2PARAM_USER2PARAM_INVITE_JOIN_HANDS_ENUM.index = 58
USER2PARAM_USER2PARAM_INVITE_JOIN_HANDS_ENUM.number = 67
USER2PARAM_USER2PARAM_BREAK_UP_HANDS_ENUM.name = "USER2PARAM_BREAK_UP_HANDS"
USER2PARAM_USER2PARAM_BREAK_UP_HANDS_ENUM.index = 59
USER2PARAM_USER2PARAM_BREAK_UP_HANDS_ENUM.number = 68
USER2PARAM_USER2PARAM_QUERY_ACTION_ENUM.name = "USER2PARAM_QUERY_ACTION"
USER2PARAM_USER2PARAM_QUERY_ACTION_ENUM.index = 60
USER2PARAM_USER2PARAM_QUERY_ACTION_ENUM.number = 69
USER2PARAM_USER2PARAM_MUSIC_LIST_ENUM.name = "USER2PARAM_MUSIC_LIST"
USER2PARAM_USER2PARAM_MUSIC_LIST_ENUM.index = 61
USER2PARAM_USER2PARAM_MUSIC_LIST_ENUM.number = 70
USER2PARAM_USER2PARAM_MUSIC_DEMAND_ENUM.name = "USER2PARAM_MUSIC_DEMAND"
USER2PARAM_USER2PARAM_MUSIC_DEMAND_ENUM.index = 62
USER2PARAM_USER2PARAM_MUSIC_DEMAND_ENUM.number = 71
USER2PARAM_USER2PARAM_MUSIC_CLOSE_ENUM.name = "USER2PARAM_MUSIC_CLOSE"
USER2PARAM_USER2PARAM_MUSIC_CLOSE_ENUM.index = 63
USER2PARAM_USER2PARAM_MUSIC_CLOSE_ENUM.number = 72
USER2PARAM_USER2PARAM_UPLOAD_OK_SCENERY_ENUM.name = "USER2PARAM_UPLOAD_OK_SCENERY"
USER2PARAM_USER2PARAM_UPLOAD_OK_SCENERY_ENUM.index = 64
USER2PARAM_USER2PARAM_UPLOAD_OK_SCENERY_ENUM.number = 73
USER2PARAM_USER2PARAM_JOIN_HANDS_ENUM.name = "USER2PARAM_JOIN_HANDS"
USER2PARAM_USER2PARAM_JOIN_HANDS_ENUM.index = 65
USER2PARAM_USER2PARAM_JOIN_HANDS_ENUM.number = 74
USER2PARAM_USER2PARAM_QUERY_TRACE_LIST_ENUM.name = "USER2PARAM_QUERY_TRACE_LIST"
USER2PARAM_USER2PARAM_QUERY_TRACE_LIST_ENUM.index = 66
USER2PARAM_USER2PARAM_QUERY_TRACE_LIST_ENUM.number = 75
USER2PARAM_USER2PARAM_UPDATE_TRACE_LIST_ENUM.name = "USER2PARAM_UPDATE_TRACE_LIST"
USER2PARAM_USER2PARAM_UPDATE_TRACE_LIST_ENUM.index = 67
USER2PARAM_USER2PARAM_UPDATE_TRACE_LIST_ENUM.number = 76
USER2PARAM_USER2PARAM_SET_DIRECTION_ENUM.name = "USER2PARAM_SET_DIRECTION"
USER2PARAM_USER2PARAM_SET_DIRECTION_ENUM.index = 68
USER2PARAM_USER2PARAM_SET_DIRECTION_ENUM.number = 77
USER2PARAM_USER2PARAM_DOWNLOAD_SCENERY_PHOTO_ENUM.name = "USER2PARAM_DOWNLOAD_SCENERY_PHOTO"
USER2PARAM_USER2PARAM_DOWNLOAD_SCENERY_PHOTO_ENUM.index = 69
USER2PARAM_USER2PARAM_DOWNLOAD_SCENERY_PHOTO_ENUM.number = 80
USER2PARAM_USER2PARAM_BATTLE_TIMELEN_USER_CMD_ENUM.name = "USER2PARAM_BATTLE_TIMELEN_USER_CMD"
USER2PARAM_USER2PARAM_BATTLE_TIMELEN_USER_CMD_ENUM.index = 70
USER2PARAM_USER2PARAM_BATTLE_TIMELEN_USER_CMD_ENUM.number = 82
USER2PARAM_USER2PARAM_SETOPTION_ENUM.name = "USER2PARAM_SETOPTION"
USER2PARAM_USER2PARAM_SETOPTION_ENUM.index = 71
USER2PARAM_USER2PARAM_SETOPTION_ENUM.number = 83
USER2PARAM_USER2PARAM_QUERYUSERINFO_ENUM.name = "USER2PARAM_QUERYUSERINFO"
USER2PARAM_USER2PARAM_QUERYUSERINFO_ENUM.index = 72
USER2PARAM_USER2PARAM_QUERYUSERINFO_ENUM.number = 84
USER2PARAM_USER2PARAM_COUNTDOWN_TICK_ENUM.name = "USER2PARAM_COUNTDOWN_TICK"
USER2PARAM_USER2PARAM_COUNTDOWN_TICK_ENUM.index = 73
USER2PARAM_USER2PARAM_COUNTDOWN_TICK_ENUM.number = 85
USER2PARAM_USER2PARAM_ITEM_MUSIC_NTF_ENUM.name = "USER2PARAM_ITEM_MUSIC_NTF"
USER2PARAM_USER2PARAM_ITEM_MUSIC_NTF_ENUM.index = 74
USER2PARAM_USER2PARAM_ITEM_MUSIC_NTF_ENUM.number = 86
USER2PARAM_USER2PARAM_SHAKETREE_ENUM.name = "USER2PARAM_SHAKETREE"
USER2PARAM_USER2PARAM_SHAKETREE_ENUM.index = 75
USER2PARAM_USER2PARAM_SHAKETREE_ENUM.number = 87
USER2PARAM_USER2PARAM_TREELIST_ENUM.name = "USER2PARAM_TREELIST"
USER2PARAM_USER2PARAM_TREELIST_ENUM.index = 76
USER2PARAM_USER2PARAM_TREELIST_ENUM.number = 88
USER2PARAM_USER2PARAM_ACTIVITY_NTF_ENUM.name = "USER2PARAM_ACTIVITY_NTF"
USER2PARAM_USER2PARAM_ACTIVITY_NTF_ENUM.index = 77
USER2PARAM_USER2PARAM_ACTIVITY_NTF_ENUM.number = 89
USER2PARAM_USER2PARAM_QUERY_ZONESTATUS_ENUM.name = "USER2PARAM_QUERY_ZONESTATUS"
USER2PARAM_USER2PARAM_QUERY_ZONESTATUS_ENUM.index = 78
USER2PARAM_USER2PARAM_QUERY_ZONESTATUS_ENUM.number = 91
USER2PARAM_USER2PARAM_JUMP_ZONE_ENUM.name = "USER2PARAM_JUMP_ZONE"
USER2PARAM_USER2PARAM_JUMP_ZONE_ENUM.index = 79
USER2PARAM_USER2PARAM_JUMP_ZONE_ENUM.number = 92
USER2PARAM_USER2PARAM_ITEMIMAGE_USER_NTF_ENUM.name = "USER2PARAM_ITEMIMAGE_USER_NTF"
USER2PARAM_USER2PARAM_ITEMIMAGE_USER_NTF_ENUM.index = 80
USER2PARAM_USER2PARAM_ITEMIMAGE_USER_NTF_ENUM.number = 93
USER2PARAM_USER2PARAM_HANDSTATUS_ENUM.name = "USER2PARAM_HANDSTATUS"
USER2PARAM_USER2PARAM_HANDSTATUS_ENUM.index = 81
USER2PARAM_USER2PARAM_HANDSTATUS_ENUM.number = 95
USER2PARAM_USER2PARAM_BEFOLLOW_ENUM.name = "USER2PARAM_BEFOLLOW"
USER2PARAM_USER2PARAM_BEFOLLOW_ENUM.index = 82
USER2PARAM_USER2PARAM_BEFOLLOW_ENUM.number = 96
USER2PARAM_USER2PARAM_INVITEFOLLOW_ENUM.name = "USER2PARAM_INVITEFOLLOW"
USER2PARAM_USER2PARAM_INVITEFOLLOW_ENUM.index = 83
USER2PARAM_USER2PARAM_INVITEFOLLOW_ENUM.number = 97
USER2PARAM_USER2PARAM_CHANGENAME_ENUM.name = "USER2PARAM_CHANGENAME"
USER2PARAM_USER2PARAM_CHANGENAME_ENUM.index = 84
USER2PARAM_USER2PARAM_CHANGENAME_ENUM.number = 98
USER2PARAM_USER2PARAM_CHARGEPLAY_ENUM.name = "USER2PARAM_CHARGEPLAY"
USER2PARAM_USER2PARAM_CHARGEPLAY_ENUM.index = 85
USER2PARAM_USER2PARAM_CHARGEPLAY_ENUM.number = 99
USER2PARAM_USER2PARAM_REQUIRENPCFUNC_ENUM.name = "USER2PARAM_REQUIRENPCFUNC"
USER2PARAM_USER2PARAM_REQUIRENPCFUNC_ENUM.index = 86
USER2PARAM_USER2PARAM_REQUIRENPCFUNC_ENUM.number = 100
USER2PARAM_USER2PARAM_CHECK_SEAT_ENUM.name = "USER2PARAM_CHECK_SEAT"
USER2PARAM_USER2PARAM_CHECK_SEAT_ENUM.index = 87
USER2PARAM_USER2PARAM_CHECK_SEAT_ENUM.number = 101
USER2PARAM_USER2PARAM_NTF_SEAT_ENUM.name = "USER2PARAM_NTF_SEAT"
USER2PARAM_USER2PARAM_NTF_SEAT_ENUM.index = 88
USER2PARAM_USER2PARAM_NTF_SEAT_ENUM.number = 102
USER2PARAM_USER2PARAM_SET_NORMALSKILL_OPTION_ENUM.name = "USER2PARAM_SET_NORMALSKILL_OPTION"
USER2PARAM_USER2PARAM_SET_NORMALSKILL_OPTION_ENUM.index = 89
USER2PARAM_USER2PARAM_SET_NORMALSKILL_OPTION_ENUM.number = 103
USER2PARAM_USER2PARAM_UNSOLVED_SCENERY_NTF_ENUM.name = "USER2PARAM_UNSOLVED_SCENERY_NTF"
USER2PARAM_USER2PARAM_UNSOLVED_SCENERY_NTF_ENUM.index = 90
USER2PARAM_USER2PARAM_UNSOLVED_SCENERY_NTF_ENUM.number = 104
USER2PARAM_USER2PARAM_NTF_VISIBLENPC_ENUM.name = "USER2PARAM_NTF_VISIBLENPC"
USER2PARAM_USER2PARAM_NTF_VISIBLENPC_ENUM.index = 91
USER2PARAM_USER2PARAM_NTF_VISIBLENPC_ENUM.number = 105
USER2PARAM_USER2PARAM_NEW_SET_OPTION_ENUM.name = "USER2PARAM_NEW_SET_OPTION"
USER2PARAM_USER2PARAM_NEW_SET_OPTION_ENUM.index = 92
USER2PARAM_USER2PARAM_NEW_SET_OPTION_ENUM.number = 106
USER2PARAM_USER2PARAM_UPYUN_AUTHORIZATION_ENUM.name = "USER2PARAM_UPYUN_AUTHORIZATION"
USER2PARAM_USER2PARAM_UPYUN_AUTHORIZATION_ENUM.index = 93
USER2PARAM_USER2PARAM_UPYUN_AUTHORIZATION_ENUM.number = 107
USER2PARAM_USER2PARAM_TRANSFORM_PREDATA_ENUM.name = "USER2PARAM_TRANSFORM_PREDATA"
USER2PARAM_USER2PARAM_TRANSFORM_PREDATA_ENUM.index = 94
USER2PARAM_USER2PARAM_TRANSFORM_PREDATA_ENUM.number = 108
USER2PARAM_USER2PARAM_USER_RENAME_ENUM.name = "USER2PARAM_USER_RENAME"
USER2PARAM_USER2PARAM_USER_RENAME_ENUM.index = 95
USER2PARAM_USER2PARAM_USER_RENAME_ENUM.number = 109
USER2PARAM_USER2PARAM_ENTER_CAPRA_ACTIVITY_ENUM.name = "USER2PARAM_ENTER_CAPRA_ACTIVITY"
USER2PARAM_USER2PARAM_ENTER_CAPRA_ACTIVITY_ENUM.index = 96
USER2PARAM_USER2PARAM_ENTER_CAPRA_ACTIVITY_ENUM.number = 110
USER2PARAM_USER2PARAM_BUY_ZENY_ENUM.name = "USER2PARAM_BUY_ZENY"
USER2PARAM_USER2PARAM_BUY_ZENY_ENUM.index = 97
USER2PARAM_USER2PARAM_BUY_ZENY_ENUM.number = 111
USER2PARAM_USER2PARAM_CALL_TEAMER_ENUM.name = "USER2PARAM_CALL_TEAMER"
USER2PARAM_USER2PARAM_CALL_TEAMER_ENUM.index = 98
USER2PARAM_USER2PARAM_CALL_TEAMER_ENUM.number = 112
USER2PARAM_USER2PARAM_CALL_TEAMER_JOIN_ENUM.name = "USER2PARAM_CALL_TEAMER_JOIN"
USER2PARAM_USER2PARAM_CALL_TEAMER_JOIN_ENUM.index = 99
USER2PARAM_USER2PARAM_CALL_TEAMER_JOIN_ENUM.number = 113
USER2PARAM_USER2PARAM_YOYO_SEAT_ENUM.name = "USER2PARAM_YOYO_SEAT"
USER2PARAM_USER2PARAM_YOYO_SEAT_ENUM.index = 100
USER2PARAM_USER2PARAM_YOYO_SEAT_ENUM.number = 114
USER2PARAM_USER2PARAM_SHOW_SEAT_ENUM.name = "USER2PARAM_SHOW_SEAT"
USER2PARAM_USER2PARAM_SHOW_SEAT_ENUM.index = 101
USER2PARAM_USER2PARAM_SHOW_SEAT_ENUM.number = 115
USER2PARAM_USER2PARAM_SPECIAL_EFFECT_ENUM.name = "USER2PARAM_SPECIAL_EFFECT"
USER2PARAM_USER2PARAM_SPECIAL_EFFECT_ENUM.index = 102
USER2PARAM_USER2PARAM_SPECIAL_EFFECT_ENUM.number = 116
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_ENUM.name = "USER2PARAM_MARRIAGE_PROPOSAL"
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_ENUM.index = 103
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_ENUM.number = 117
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_REPLY_ENUM.name = "USER2PARAM_MARRIAGE_PROPOSAL_REPLY"
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_REPLY_ENUM.index = 104
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_REPLY_ENUM.number = 118
USER2PARAM_USER2PARAM_UPLOAD_WEDDING_PHOTO_ENUM.name = "USER2PARAM_UPLOAD_WEDDING_PHOTO"
USER2PARAM_USER2PARAM_UPLOAD_WEDDING_PHOTO_ENUM.index = 105
USER2PARAM_USER2PARAM_UPLOAD_WEDDING_PHOTO_ENUM.number = 119
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_SUCCESS_ENUM.name = "USER2PARAM_MARRIAGE_PROPOSAL_SUCCESS"
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_SUCCESS_ENUM.index = 106
USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_SUCCESS_ENUM.number = 120
USER2PARAM_USER2PARAM_INVITEE_WEDDING_START_NTF_ENUM.name = "USER2PARAM_INVITEE_WEDDING_START_NTF"
USER2PARAM_USER2PARAM_INVITEE_WEDDING_START_NTF_ENUM.index = 107
USER2PARAM_USER2PARAM_INVITEE_WEDDING_START_NTF_ENUM.number = 121
USER2PARAM_USER2PARAM_SERVANT_SHOW_ENUM.name = "USER2PARAM_SERVANT_SHOW"
USER2PARAM_USER2PARAM_SERVANT_SHOW_ENUM.index = 108
USER2PARAM_USER2PARAM_SERVANT_SHOW_ENUM.number = 122
USER2PARAM_USER2PARAM_SERVANT_REPLACE_ENUM.name = "USER2PARAM_SERVANT_REPLACE"
USER2PARAM_USER2PARAM_SERVANT_REPLACE_ENUM.index = 109
USER2PARAM_USER2PARAM_SERVANT_REPLACE_ENUM.number = 123
USER2PARAM_USER2PARAM_SERVANT_SERVICE_ENUM.name = "USER2PARAM_SERVANT_SERVICE"
USER2PARAM_USER2PARAM_SERVANT_SERVICE_ENUM.index = 110
USER2PARAM_USER2PARAM_SERVANT_SERVICE_ENUM.number = 124
USER2PARAM_USER2PARAM_SERVANT_RECOMMEND_ENUM.name = "USER2PARAM_SERVANT_RECOMMEND"
USER2PARAM_USER2PARAM_SERVANT_RECOMMEND_ENUM.index = 111
USER2PARAM_USER2PARAM_SERVANT_RECOMMEND_ENUM.number = 125
USER2PARAM_USER2PARAM_SERVANT_RECEIVE_ENUM.name = "USER2PARAM_SERVANT_RECEIVE"
USER2PARAM_USER2PARAM_SERVANT_RECEIVE_ENUM.index = 112
USER2PARAM_USER2PARAM_SERVANT_RECEIVE_ENUM.number = 126
USER2PARAM_USER2PARAM_SERVANT_REWARD_STATUS_ENUM.name = "USER2PARAM_SERVANT_REWARD_STATUS"
USER2PARAM_USER2PARAM_SERVANT_REWARD_STATUS_ENUM.index = 113
USER2PARAM_USER2PARAM_SERVANT_REWARD_STATUS_ENUM.number = 127
USER2PARAM_USER2PARAM_KFC_SHARE_ENUM.name = "USER2PARAM_KFC_SHARE"
USER2PARAM_USER2PARAM_KFC_SHARE_ENUM.index = 114
USER2PARAM_USER2PARAM_KFC_SHARE_ENUM.number = 128
USER2PARAM_USER2PARAM_TWINS_ACTION_ENUM.name = "USER2PARAM_TWINS_ACTION"
USER2PARAM_USER2PARAM_TWINS_ACTION_ENUM.index = 115
USER2PARAM_USER2PARAM_TWINS_ACTION_ENUM.number = 129
USER2PARAM_USER2PARAM_CHECK_RELATION_ENUM.name = "USER2PARAM_CHECK_RELATION"
USER2PARAM_USER2PARAM_CHECK_RELATION_ENUM.index = 116
USER2PARAM_USER2PARAM_CHECK_RELATION_ENUM.number = 130
USER2PARAM_USER2PARAM_PROFESSION_QUERY_ENUM.name = "USER2PARAM_PROFESSION_QUERY"
USER2PARAM_USER2PARAM_PROFESSION_QUERY_ENUM.index = 117
USER2PARAM_USER2PARAM_PROFESSION_QUERY_ENUM.number = 131
USER2PARAM_USER2PARAM_PROFESSION_BUY_ENUM.name = "USER2PARAM_PROFESSION_BUY"
USER2PARAM_USER2PARAM_PROFESSION_BUY_ENUM.index = 118
USER2PARAM_USER2PARAM_PROFESSION_BUY_ENUM.number = 132
USER2PARAM_USER2PARAM_PROFESSION_CHANGE_ENUM.name = "USER2PARAM_PROFESSION_CHANGE"
USER2PARAM_USER2PARAM_PROFESSION_CHANGE_ENUM.index = 119
USER2PARAM_USER2PARAM_PROFESSION_CHANGE_ENUM.number = 133
USER2PARAM_USER2PARAM_UPDATE_RECORD_INFO_ENUM.name = "USER2PARAM_UPDATE_RECORD_INFO"
USER2PARAM_USER2PARAM_UPDATE_RECORD_INFO_ENUM.index = 120
USER2PARAM_USER2PARAM_UPDATE_RECORD_INFO_ENUM.number = 134
USER2PARAM_USER2PARAM_SAVE_RECORD_ENUM.name = "USER2PARAM_SAVE_RECORD"
USER2PARAM_USER2PARAM_SAVE_RECORD_ENUM.index = 121
USER2PARAM_USER2PARAM_SAVE_RECORD_ENUM.number = 135
USER2PARAM_USER2PARAM_LOAD_RECORD_ENUM.name = "USER2PARAM_LOAD_RECORD"
USER2PARAM_USER2PARAM_LOAD_RECORD_ENUM.index = 122
USER2PARAM_USER2PARAM_LOAD_RECORD_ENUM.number = 136
USER2PARAM_USER2PARAM_CHANGE_RECORD_NAME_ENUM.name = "USER2PARAM_CHANGE_RECORD_NAME"
USER2PARAM_USER2PARAM_CHANGE_RECORD_NAME_ENUM.index = 123
USER2PARAM_USER2PARAM_CHANGE_RECORD_NAME_ENUM.number = 137
USER2PARAM_USER2PARAM_BUY_RECORD_SLOT_ENUM.name = "USER2PARAM_BUY_RECORD_SLOT"
USER2PARAM_USER2PARAM_BUY_RECORD_SLOT_ENUM.index = 124
USER2PARAM_USER2PARAM_BUY_RECORD_SLOT_ENUM.number = 138
USER2PARAM_USER2PARAM_DELETE_RECORD_ENUM.name = "USER2PARAM_DELETE_RECORD"
USER2PARAM_USER2PARAM_DELETE_RECORD_ENUM.index = 125
USER2PARAM_USER2PARAM_DELETE_RECORD_ENUM.number = 139
USER2PARAM_USER2PARAM_UPDATE_BRANCH_INFO_ENUM.name = "USER2PARAM_UPDATE_BRANCH_INFO"
USER2PARAM_USER2PARAM_UPDATE_BRANCH_INFO_ENUM.index = 126
USER2PARAM_USER2PARAM_UPDATE_BRANCH_INFO_ENUM.number = 140
USER2PARAM_USER2PARAM_GOTO_FUNCMAP_ENUM.name = "USER2PARAM_GOTO_FUNCMAP"
USER2PARAM_USER2PARAM_GOTO_FUNCMAP_ENUM.index = 127
USER2PARAM_USER2PARAM_GOTO_FUNCMAP_ENUM.number = 141
USER2PARAM_USER2PARAM_INVITE_WITH_ME_ENUM.name = "USER2PARAM_INVITE_WITH_ME"
USER2PARAM_USER2PARAM_INVITE_WITH_ME_ENUM.index = 128
USER2PARAM_USER2PARAM_INVITE_WITH_ME_ENUM.number = 142
USER2PARAM_USER2PARAM_QUERY_ALTMAN_KILL_ENUM.name = "USER2PARAM_QUERY_ALTMAN_KILL"
USER2PARAM_USER2PARAM_QUERY_ALTMAN_KILL_ENUM.index = 129
USER2PARAM_USER2PARAM_QUERY_ALTMAN_KILL_ENUM.number = 143
USER2PARAM_USER2PARAM_USER_BOOTH_REQ_ENUM.name = "USER2PARAM_USER_BOOTH_REQ"
USER2PARAM_USER2PARAM_USER_BOOTH_REQ_ENUM.index = 130
USER2PARAM_USER2PARAM_USER_BOOTH_REQ_ENUM.number = 144
USER2PARAM_USER2PARAM_BOOTH_INFO_SYNC_ENUM.name = "USER2PARAM_BOOTH_INFO_SYNC"
USER2PARAM_USER2PARAM_BOOTH_INFO_SYNC_ENUM.index = 131
USER2PARAM_USER2PARAM_BOOTH_INFO_SYNC_ENUM.number = 145
USER2PARAM_USER2PARAM_DRESSUP_MODEL_ENUM.name = "USER2PARAM_DRESSUP_MODEL"
USER2PARAM_USER2PARAM_DRESSUP_MODEL_ENUM.index = 132
USER2PARAM_USER2PARAM_DRESSUP_MODEL_ENUM.number = 146
USER2PARAM_USER2PARAM_DRESSUP_HEAD_ENUM.name = "USER2PARAM_DRESSUP_HEAD"
USER2PARAM_USER2PARAM_DRESSUP_HEAD_ENUM.index = 133
USER2PARAM_USER2PARAM_DRESSUP_HEAD_ENUM.number = 147
USER2PARAM_USER2PARAM_QUERY_STAGE_ENUM.name = "USER2PARAM_QUERY_STAGE"
USER2PARAM_USER2PARAM_QUERY_STAGE_ENUM.index = 134
USER2PARAM_USER2PARAM_QUERY_STAGE_ENUM.number = 148
USER2PARAM_USER2PARAM_DRESSUP_LINEUP_ENUM.name = "USER2PARAM_DRESSUP_LINEUP"
USER2PARAM_USER2PARAM_DRESSUP_LINEUP_ENUM.index = 135
USER2PARAM_USER2PARAM_DRESSUP_LINEUP_ENUM.number = 149
USER2PARAM_USER2PARAM_DRESSUP_STAGE_ENUM.name = "USER2PARAM_DRESSUP_STAGE"
USER2PARAM_USER2PARAM_DRESSUP_STAGE_ENUM.index = 136
USER2PARAM_USER2PARAM_DRESSUP_STAGE_ENUM.number = 150
USER2PARAM_USER2PARAM_DEATH_TRANSFER_LIST_ENUM.name = "USER2PARAM_DEATH_TRANSFER_LIST"
USER2PARAM_USER2PARAM_DEATH_TRANSFER_LIST_ENUM.index = 137
USER2PARAM_USER2PARAM_DEATH_TRANSFER_LIST_ENUM.number = 151
USER2PARAM_USER2PARAM_NEW_DEATH_TRANSFER_ENUM.name = "USER2PARAM_NEW_DEATH_TRANSFER"
USER2PARAM_USER2PARAM_NEW_DEATH_TRANSFER_ENUM.index = 138
USER2PARAM_USER2PARAM_NEW_DEATH_TRANSFER_ENUM.number = 152
USER2PARAM_USER2PARAM_TRANSFER_ENUM.name = "USER2PARAM_TRANSFER"
USER2PARAM_USER2PARAM_TRANSFER_ENUM.index = 139
USER2PARAM_USER2PARAM_TRANSFER_ENUM.number = 153
USER2PARAM_USER2PARAM_SERVANT_GROWTH_ENUM.name = "USER2PARAM_SERVANT_GROWTH"
USER2PARAM_USER2PARAM_SERVANT_GROWTH_ENUM.index = 140
USER2PARAM_USER2PARAM_SERVANT_GROWTH_ENUM.number = 154
USER2PARAM_USER2PARAM_SERVANT_RECEIVE_GROWTH_ENUM.name = "USER2PARAM_SERVANT_RECEIVE_GROWTH"
USER2PARAM_USER2PARAM_SERVANT_RECEIVE_GROWTH_ENUM.index = 141
USER2PARAM_USER2PARAM_SERVANT_RECEIVE_GROWTH_ENUM.number = 155
USER2PARAM_USER2PARAM_SERVANT_GROWTH_OPEN_ENUM.name = "USER2PARAM_SERVANT_GROWTH_OPEN"
USER2PARAM_USER2PARAM_SERVANT_GROWTH_OPEN_ENUM.index = 142
USER2PARAM_USER2PARAM_SERVANT_GROWTH_OPEN_ENUM.number = 156
USER2PARAM_USER2PARAM_CHEAT_TAG_ENUM.name = "USER2PARAM_CHEAT_TAG"
USER2PARAM_USER2PARAM_CHEAT_TAG_ENUM.index = 143
USER2PARAM_USER2PARAM_CHEAT_TAG_ENUM.number = 157
USER2PARAM_USER2PARAM_CHEAT_TAG_STAT_ENUM.name = "USER2PARAM_CHEAT_TAG_STAT"
USER2PARAM_USER2PARAM_CHEAT_TAG_STAT_ENUM.index = 144
USER2PARAM_USER2PARAM_CHEAT_TAG_STAT_ENUM.number = 158
USER2PARAM_USER2PARAM_CLICK_POS_LIST_ENUM.name = "USER2PARAM_CLICK_POS_LIST"
USER2PARAM_USER2PARAM_CLICK_POS_LIST_ENUM.index = 145
USER2PARAM_USER2PARAM_CLICK_POS_LIST_ENUM.number = 159
USER2PARAM_USER2PARAM_BEAT_PORI_ENUM.name = "USER2PARAM_BEAT_PORI"
USER2PARAM_USER2PARAM_BEAT_PORI_ENUM.index = 146
USER2PARAM_USER2PARAM_BEAT_PORI_ENUM.number = 160
USER2PARAM_USER2PARAM_UNLOCK_FRAME_ENUM.name = "USER2PARAM_UNLOCK_FRAME"
USER2PARAM_USER2PARAM_UNLOCK_FRAME_ENUM.index = 147
USER2PARAM_USER2PARAM_UNLOCK_FRAME_ENUM.number = 161
USER2PARAM_USER2PARAM_KFC_ENROLL_ENUM.name = "USER2PARAM_KFC_ENROLL"
USER2PARAM_USER2PARAM_KFC_ENROLL_ENUM.index = 148
USER2PARAM_USER2PARAM_KFC_ENROLL_ENUM.number = 162
USER2PARAM_USER2PARAM_KFC_ENROLL_REPLY_ENUM.name = "USER2PARAM_KFC_ENROLL_REPLY"
USER2PARAM_USER2PARAM_KFC_ENROLL_REPLY_ENUM.index = 149
USER2PARAM_USER2PARAM_KFC_ENROLL_REPLY_ENUM.number = 163
USER2PARAM_USER2PARAM_KFC_HAS_ENROLLED_ENUM.name = "USER2PARAM_KFC_HAS_ENROLLED"
USER2PARAM_USER2PARAM_KFC_HAS_ENROLLED_ENUM.index = 150
USER2PARAM_USER2PARAM_KFC_HAS_ENROLLED_ENUM.number = 166
USER2PARAM_USER2PARAM_KFC_ENROLL_QUERY_ENUM.name = "USER2PARAM_KFC_ENROLL_QUERY"
USER2PARAM_USER2PARAM_KFC_ENROLL_QUERY_ENUM.index = 151
USER2PARAM_USER2PARAM_KFC_ENROLL_QUERY_ENUM.number = 167
USER2PARAM_USER2PARAM_KFC_ENROLL_CODE_ENUM.name = "USER2PARAM_KFC_ENROLL_CODE"
USER2PARAM_USER2PARAM_KFC_ENROLL_CODE_ENUM.index = 152
USER2PARAM_USER2PARAM_KFC_ENROLL_CODE_ENUM.number = 168
USER2PARAM_USER2PARAM_SIGNIN_ENUM.name = "USER2PARAM_SIGNIN"
USER2PARAM_USER2PARAM_SIGNIN_ENUM.index = 153
USER2PARAM_USER2PARAM_SIGNIN_ENUM.number = 164
USER2PARAM_USER2PARAM_SIGNIN_NTF_ENUM.name = "USER2PARAM_SIGNIN_NTF"
USER2PARAM_USER2PARAM_SIGNIN_NTF_ENUM.index = 154
USER2PARAM_USER2PARAM_SIGNIN_NTF_ENUM.number = 165
USER2PARAM_USER2PARAM_ALTMAN_REWARD_ENUM.name = "USER2PARAM_ALTMAN_REWARD"
USER2PARAM_USER2PARAM_ALTMAN_REWARD_ENUM.index = 155
USER2PARAM_USER2PARAM_ALTMAN_REWARD_ENUM.number = 170
USER2PARAM_USER2PARAM_SERVANT_REQ_RESERVATION_ENUM.name = "USER2PARAM_SERVANT_REQ_RESERVATION"
USER2PARAM_USER2PARAM_SERVANT_REQ_RESERVATION_ENUM.index = 156
USER2PARAM_USER2PARAM_SERVANT_REQ_RESERVATION_ENUM.number = 171
USER2PARAM_USER2PARAM_SERVANT_RESERVATION_ENUM.name = "USER2PARAM_SERVANT_RESERVATION"
USER2PARAM_USER2PARAM_SERVANT_RESERVATION_ENUM.index = 157
USER2PARAM_USER2PARAM_SERVANT_RESERVATION_ENUM.number = 172
USER2PARAM_USER2PARAM_SERVANT_REC_EQUIP_ENUM.name = "USER2PARAM_SERVANT_REC_EQUIP"
USER2PARAM_USER2PARAM_SERVANT_REC_EQUIP_ENUM.index = 158
USER2PARAM_USER2PARAM_SERVANT_REC_EQUIP_ENUM.number = 173
USER2PARAM.name = "User2Param"
USER2PARAM.full_name = ".Cmd.User2Param"
USER2PARAM.values = {
  USER2PARAM_USER2PARAM_GOCITY_ENUM,
  USER2PARAM_USER2PARAM_SYSMSG_ENUM,
  USER2PARAM_USER2PARAM_NPCDATASYNC_ENUM,
  USER2PARAM_USER2PARAM_USERNINESYNC_ENUM,
  USER2PARAM_USER2PARAM_ACTION_ENUM,
  USER2PARAM_USER2PARAM_BUFFERSYNC_ENUM,
  USER2PARAM_USER2PARAM_EXIT_POS_ENUM,
  USER2PARAM_USER2PARAM_RELIVE_ENUM,
  USER2PARAM_USER2PARAM_VAR_ENUM,
  USER2PARAM_USER2PARAM_TALKINFO_ENUM,
  USER2PARAM_USER2PARAM_SERVERTIME_ENUM,
  USER2PARAM_USER2PARAM_NEWTRANSMAP_ENUM,
  USER2PARAM_USER2PARAM_EFFECT_ENUM,
  USER2PARAM_USER2PARAM_MENU_ENUM,
  USER2PARAM_USER2PARAM_NEWMENU_ENUM,
  USER2PARAM_USER2PARAM_TEAMINFONINE_ENUM,
  USER2PARAM_USER2PARAM_USEPORTRAIT_ENUM,
  USER2PARAM_USER2PARAM_USEFRAME_ENUM,
  USER2PARAM_USER2PARAM_NEWPORTRAITFRAME_ENUM,
  USER2PARAM_USER2PARAM_QUERYPORTRAITLIST_ENUM,
  USER2PARAM_USER2PARAM_ADDATTRPOINT_ENUM,
  USER2PARAM_USER2PARAM_QUERYSHOPGOTITEM_ENUM,
  USER2PARAM_USER2PARAM_UPDATESHOPGOTITEM_ENUM,
  USER2PARAM_USER2PARAM_USEDRESSING_ENUM,
  USER2PARAM_USER2PARAM_NEWDRESSING_ENUM,
  USER2PARAM_USER2PARAM_DRESSINGLIST_ENUM,
  USER2PARAM_USER2PARAM_OPENUI_ENUM,
  USER2PARAM_USER2PARAM_DBGSYSMSG_ENUM,
  USER2PARAM_USER2PARAM_FOLLOWTRANSFER_ENUM,
  USER2PARAM_USER2PARAM_NPCFUNC_ENUM,
  USER2PARAM_USER2PARAM_MODELSHOW_ENUM,
  USER2PARAM_USER2PARAM_SOUNDEFFECT_ENUM,
  USER2PARAM_USER2PARAM_PRESETCHATMSG_ENUM,
  USER2PARAM_USER2PARAM_CHANGEBGM_ENUM,
  USER2PARAM_USER2PARAM_QUERYFIGHTERINFO_ENUM,
  USER2PARAM_USER2PARAM_GAMETIME_ENUM,
  USER2PARAM_USER2PARAM_CDTIME_ENUM,
  USER2PARAM_USER2PARAM_STATECHANGE_ENUM,
  USER2PARAM_USER2PARAM_PHOTO_ENUM,
  USER2PARAM_USER2PARAM_SHAKESCREEN_ENUM,
  USER2PARAM_USER2PARAM_QUERYSHORTCUT_ENUM,
  USER2PARAM_USER2PARAM_PUTSHORTCUT_ENUM,
  USER2PARAM_USER2PARAM_NPCANGLE_ENUM,
  USER2PARAM_USER2PARAM_CAMERAFOCUS_ENUM,
  USER2PARAM_USER2PARAM_GOTO_LIST_ENUM,
  USER2PARAM_USER2PARAM_GOTO_GEAR_ENUM,
  USER2PARAM_USER2PARAM_FOLLOWER_ENUM,
  USER2PARAM_USER2PARAM_LABORATORY_ENUM,
  USER2PARAM_USER2PARAM_EXCHANGEPROFESSION_ENUM,
  USER2PARAM_USER2PARAM_GOTO_LABORATORY_ENUM,
  USER2PARAM_USER2PARAM_SCENERY_ENUM,
  USER2PARAM_USER2PARAM_GOMAP_QUEST_ENUM,
  USER2PARAM_USER2PARAM_GOMAP_FOLLOW_ENUM,
  USER2PARAM_USER2PARAM_AUTOHIT_ENUM,
  USER2PARAM_USER2PARAM_UPLOAD_SCENERY_PHOTO_ENUM,
  USER2PARAM_USER2PARAM_QUERY_MAPAREA_ENUM,
  USER2PARAM_USER2PARAM_NEW_MAPAREA_ENUM,
  USER2PARAM_USER2PARAM_FOREVER_BUFF_ENUM,
  USER2PARAM_USER2PARAM_INVITE_JOIN_HANDS_ENUM,
  USER2PARAM_USER2PARAM_BREAK_UP_HANDS_ENUM,
  USER2PARAM_USER2PARAM_QUERY_ACTION_ENUM,
  USER2PARAM_USER2PARAM_MUSIC_LIST_ENUM,
  USER2PARAM_USER2PARAM_MUSIC_DEMAND_ENUM,
  USER2PARAM_USER2PARAM_MUSIC_CLOSE_ENUM,
  USER2PARAM_USER2PARAM_UPLOAD_OK_SCENERY_ENUM,
  USER2PARAM_USER2PARAM_JOIN_HANDS_ENUM,
  USER2PARAM_USER2PARAM_QUERY_TRACE_LIST_ENUM,
  USER2PARAM_USER2PARAM_UPDATE_TRACE_LIST_ENUM,
  USER2PARAM_USER2PARAM_SET_DIRECTION_ENUM,
  USER2PARAM_USER2PARAM_DOWNLOAD_SCENERY_PHOTO_ENUM,
  USER2PARAM_USER2PARAM_BATTLE_TIMELEN_USER_CMD_ENUM,
  USER2PARAM_USER2PARAM_SETOPTION_ENUM,
  USER2PARAM_USER2PARAM_QUERYUSERINFO_ENUM,
  USER2PARAM_USER2PARAM_COUNTDOWN_TICK_ENUM,
  USER2PARAM_USER2PARAM_ITEM_MUSIC_NTF_ENUM,
  USER2PARAM_USER2PARAM_SHAKETREE_ENUM,
  USER2PARAM_USER2PARAM_TREELIST_ENUM,
  USER2PARAM_USER2PARAM_ACTIVITY_NTF_ENUM,
  USER2PARAM_USER2PARAM_QUERY_ZONESTATUS_ENUM,
  USER2PARAM_USER2PARAM_JUMP_ZONE_ENUM,
  USER2PARAM_USER2PARAM_ITEMIMAGE_USER_NTF_ENUM,
  USER2PARAM_USER2PARAM_HANDSTATUS_ENUM,
  USER2PARAM_USER2PARAM_BEFOLLOW_ENUM,
  USER2PARAM_USER2PARAM_INVITEFOLLOW_ENUM,
  USER2PARAM_USER2PARAM_CHANGENAME_ENUM,
  USER2PARAM_USER2PARAM_CHARGEPLAY_ENUM,
  USER2PARAM_USER2PARAM_REQUIRENPCFUNC_ENUM,
  USER2PARAM_USER2PARAM_CHECK_SEAT_ENUM,
  USER2PARAM_USER2PARAM_NTF_SEAT_ENUM,
  USER2PARAM_USER2PARAM_SET_NORMALSKILL_OPTION_ENUM,
  USER2PARAM_USER2PARAM_UNSOLVED_SCENERY_NTF_ENUM,
  USER2PARAM_USER2PARAM_NTF_VISIBLENPC_ENUM,
  USER2PARAM_USER2PARAM_NEW_SET_OPTION_ENUM,
  USER2PARAM_USER2PARAM_UPYUN_AUTHORIZATION_ENUM,
  USER2PARAM_USER2PARAM_TRANSFORM_PREDATA_ENUM,
  USER2PARAM_USER2PARAM_USER_RENAME_ENUM,
  USER2PARAM_USER2PARAM_ENTER_CAPRA_ACTIVITY_ENUM,
  USER2PARAM_USER2PARAM_BUY_ZENY_ENUM,
  USER2PARAM_USER2PARAM_CALL_TEAMER_ENUM,
  USER2PARAM_USER2PARAM_CALL_TEAMER_JOIN_ENUM,
  USER2PARAM_USER2PARAM_YOYO_SEAT_ENUM,
  USER2PARAM_USER2PARAM_SHOW_SEAT_ENUM,
  USER2PARAM_USER2PARAM_SPECIAL_EFFECT_ENUM,
  USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_ENUM,
  USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_REPLY_ENUM,
  USER2PARAM_USER2PARAM_UPLOAD_WEDDING_PHOTO_ENUM,
  USER2PARAM_USER2PARAM_MARRIAGE_PROPOSAL_SUCCESS_ENUM,
  USER2PARAM_USER2PARAM_INVITEE_WEDDING_START_NTF_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_SHOW_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_REPLACE_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_SERVICE_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_RECOMMEND_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_RECEIVE_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_REWARD_STATUS_ENUM,
  USER2PARAM_USER2PARAM_KFC_SHARE_ENUM,
  USER2PARAM_USER2PARAM_TWINS_ACTION_ENUM,
  USER2PARAM_USER2PARAM_CHECK_RELATION_ENUM,
  USER2PARAM_USER2PARAM_PROFESSION_QUERY_ENUM,
  USER2PARAM_USER2PARAM_PROFESSION_BUY_ENUM,
  USER2PARAM_USER2PARAM_PROFESSION_CHANGE_ENUM,
  USER2PARAM_USER2PARAM_UPDATE_RECORD_INFO_ENUM,
  USER2PARAM_USER2PARAM_SAVE_RECORD_ENUM,
  USER2PARAM_USER2PARAM_LOAD_RECORD_ENUM,
  USER2PARAM_USER2PARAM_CHANGE_RECORD_NAME_ENUM,
  USER2PARAM_USER2PARAM_BUY_RECORD_SLOT_ENUM,
  USER2PARAM_USER2PARAM_DELETE_RECORD_ENUM,
  USER2PARAM_USER2PARAM_UPDATE_BRANCH_INFO_ENUM,
  USER2PARAM_USER2PARAM_GOTO_FUNCMAP_ENUM,
  USER2PARAM_USER2PARAM_INVITE_WITH_ME_ENUM,
  USER2PARAM_USER2PARAM_QUERY_ALTMAN_KILL_ENUM,
  USER2PARAM_USER2PARAM_USER_BOOTH_REQ_ENUM,
  USER2PARAM_USER2PARAM_BOOTH_INFO_SYNC_ENUM,
  USER2PARAM_USER2PARAM_DRESSUP_MODEL_ENUM,
  USER2PARAM_USER2PARAM_DRESSUP_HEAD_ENUM,
  USER2PARAM_USER2PARAM_QUERY_STAGE_ENUM,
  USER2PARAM_USER2PARAM_DRESSUP_LINEUP_ENUM,
  USER2PARAM_USER2PARAM_DRESSUP_STAGE_ENUM,
  USER2PARAM_USER2PARAM_DEATH_TRANSFER_LIST_ENUM,
  USER2PARAM_USER2PARAM_NEW_DEATH_TRANSFER_ENUM,
  USER2PARAM_USER2PARAM_TRANSFER_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_GROWTH_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_RECEIVE_GROWTH_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_GROWTH_OPEN_ENUM,
  USER2PARAM_USER2PARAM_CHEAT_TAG_ENUM,
  USER2PARAM_USER2PARAM_CHEAT_TAG_STAT_ENUM,
  USER2PARAM_USER2PARAM_CLICK_POS_LIST_ENUM,
  USER2PARAM_USER2PARAM_BEAT_PORI_ENUM,
  USER2PARAM_USER2PARAM_UNLOCK_FRAME_ENUM,
  USER2PARAM_USER2PARAM_KFC_ENROLL_ENUM,
  USER2PARAM_USER2PARAM_KFC_ENROLL_REPLY_ENUM,
  USER2PARAM_USER2PARAM_KFC_HAS_ENROLLED_ENUM,
  USER2PARAM_USER2PARAM_KFC_ENROLL_QUERY_ENUM,
  USER2PARAM_USER2PARAM_KFC_ENROLL_CODE_ENUM,
  USER2PARAM_USER2PARAM_SIGNIN_ENUM,
  USER2PARAM_USER2PARAM_SIGNIN_NTF_ENUM,
  USER2PARAM_USER2PARAM_ALTMAN_REWARD_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_REQ_RESERVATION_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_RESERVATION_ENUM,
  USER2PARAM_USER2PARAM_SERVANT_REC_EQUIP_ENUM
}
EMESSAGETYPE_EMESSAGETYPE_MIN_ENUM.name = "EMESSAGETYPE_MIN"
EMESSAGETYPE_EMESSAGETYPE_MIN_ENUM.index = 0
EMESSAGETYPE_EMESSAGETYPE_MIN_ENUM.number = 0
EMESSAGETYPE_EMESSAGETYPE_FRAME_ENUM.name = "EMESSAGETYPE_FRAME"
EMESSAGETYPE_EMESSAGETYPE_FRAME_ENUM.index = 1
EMESSAGETYPE_EMESSAGETYPE_FRAME_ENUM.number = 1
EMESSAGETYPE_EMESSAGETYPE_GETEXP_ENUM.name = "EMESSAGETYPE_GETEXP"
EMESSAGETYPE_EMESSAGETYPE_GETEXP_ENUM.index = 2
EMESSAGETYPE_EMESSAGETYPE_GETEXP_ENUM.number = 2
EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_ENUM.name = "EMESSAGETYPE_TIME_DOWN"
EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_ENUM.index = 3
EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_ENUM.number = 3
EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_NOT_CLEAR_ENUM.name = "EMESSAGETYPE_TIME_DOWN_NOT_CLEAR"
EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_NOT_CLEAR_ENUM.index = 4
EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_NOT_CLEAR_ENUM.number = 4
EMESSAGETYPE_EMESSAGETYPE_MIDDLE_SHOW_ENUM.name = "EMESSAGETYPE_MIDDLE_SHOW"
EMESSAGETYPE_EMESSAGETYPE_MIDDLE_SHOW_ENUM.index = 5
EMESSAGETYPE_EMESSAGETYPE_MIDDLE_SHOW_ENUM.number = 5
EMESSAGETYPE_EMESSAGETYPE_MAX_ENUM.name = "EMESSAGETYPE_MAX"
EMESSAGETYPE_EMESSAGETYPE_MAX_ENUM.index = 6
EMESSAGETYPE_EMESSAGETYPE_MAX_ENUM.number = 6
EMESSAGETYPE.name = "EMessageType"
EMESSAGETYPE.full_name = ".Cmd.EMessageType"
EMESSAGETYPE.values = {
  EMESSAGETYPE_EMESSAGETYPE_MIN_ENUM,
  EMESSAGETYPE_EMESSAGETYPE_FRAME_ENUM,
  EMESSAGETYPE_EMESSAGETYPE_GETEXP_ENUM,
  EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_ENUM,
  EMESSAGETYPE_EMESSAGETYPE_TIME_DOWN_NOT_CLEAR_ENUM,
  EMESSAGETYPE_EMESSAGETYPE_MIDDLE_SHOW_ENUM,
  EMESSAGETYPE_EMESSAGETYPE_MAX_ENUM
}
EMESSAGEACTOPT_EMESSAGEACT_ADD_ENUM.name = "EMESSAGEACT_ADD"
EMESSAGEACTOPT_EMESSAGEACT_ADD_ENUM.index = 0
EMESSAGEACTOPT_EMESSAGEACT_ADD_ENUM.number = 1
EMESSAGEACTOPT_EMESSAGEACT_DEL_ENUM.name = "EMESSAGEACT_DEL"
EMESSAGEACTOPT_EMESSAGEACT_DEL_ENUM.index = 1
EMESSAGEACTOPT_EMESSAGEACT_DEL_ENUM.number = 2
EMESSAGEACTOPT.name = "EMessageActOpt"
EMESSAGEACTOPT.full_name = ".Cmd.EMessageActOpt"
EMESSAGEACTOPT.values = {
  EMESSAGEACTOPT_EMESSAGEACT_ADD_ENUM,
  EMESSAGEACTOPT_EMESSAGEACT_DEL_ENUM
}
EUSERACTIONTYPE_EUSERACTIONTYPE_MIN_ENUM.name = "EUSERACTIONTYPE_MIN"
EUSERACTIONTYPE_EUSERACTIONTYPE_MIN_ENUM.index = 0
EUSERACTIONTYPE_EUSERACTIONTYPE_MIN_ENUM.number = 0
EUSERACTIONTYPE_EUSERACTIONTYPE_ADDHP_ENUM.name = "EUSERACTIONTYPE_ADDHP"
EUSERACTIONTYPE_EUSERACTIONTYPE_ADDHP_ENUM.index = 1
EUSERACTIONTYPE_EUSERACTIONTYPE_ADDHP_ENUM.number = 1
EUSERACTIONTYPE_EUSERACTIONTYPE_REFINE_ENUM.name = "EUSERACTIONTYPE_REFINE"
EUSERACTIONTYPE_EUSERACTIONTYPE_REFINE_ENUM.index = 2
EUSERACTIONTYPE_EUSERACTIONTYPE_REFINE_ENUM.number = 2
EUSERACTIONTYPE_EUSERACTIONTYPE_EXPRESSION_ENUM.name = "EUSERACTIONTYPE_EXPRESSION"
EUSERACTIONTYPE_EUSERACTIONTYPE_EXPRESSION_ENUM.index = 3
EUSERACTIONTYPE_EUSERACTIONTYPE_EXPRESSION_ENUM.number = 3
EUSERACTIONTYPE_EUSERACTIONTYPE_MOTION_ENUM.name = "EUSERACTIONTYPE_MOTION"
EUSERACTIONTYPE_EUSERACTIONTYPE_MOTION_ENUM.index = 4
EUSERACTIONTYPE_EUSERACTIONTYPE_MOTION_ENUM.number = 4
EUSERACTIONTYPE_EUSERACTIONTYPE_GEAR_ACTION_ENUM.name = "EUSERACTIONTYPE_GEAR_ACTION"
EUSERACTIONTYPE_EUSERACTIONTYPE_GEAR_ACTION_ENUM.index = 5
EUSERACTIONTYPE_EUSERACTIONTYPE_GEAR_ACTION_ENUM.number = 5
EUSERACTIONTYPE_EUSERACTIONTYPE_NORMALMOTION_ENUM.name = "EUSERACTIONTYPE_NORMALMOTION"
EUSERACTIONTYPE_EUSERACTIONTYPE_NORMALMOTION_ENUM.index = 6
EUSERACTIONTYPE_EUSERACTIONTYPE_NORMALMOTION_ENUM.number = 6
EUSERACTIONTYPE_EUSERACTIONTYPE_DIALOG_ENUM.name = "EUSERACTIONTYPE_DIALOG"
EUSERACTIONTYPE_EUSERACTIONTYPE_DIALOG_ENUM.index = 7
EUSERACTIONTYPE_EUSERACTIONTYPE_DIALOG_ENUM.number = 7
EUSERACTIONTYPE_EUSERACTIONTYPE_MAX_ENUM.name = "EUSERACTIONTYPE_MAX"
EUSERACTIONTYPE_EUSERACTIONTYPE_MAX_ENUM.index = 8
EUSERACTIONTYPE_EUSERACTIONTYPE_MAX_ENUM.number = 8
EUSERACTIONTYPE.name = "EUserActionType"
EUSERACTIONTYPE.full_name = ".Cmd.EUserActionType"
EUSERACTIONTYPE.values = {
  EUSERACTIONTYPE_EUSERACTIONTYPE_MIN_ENUM,
  EUSERACTIONTYPE_EUSERACTIONTYPE_ADDHP_ENUM,
  EUSERACTIONTYPE_EUSERACTIONTYPE_REFINE_ENUM,
  EUSERACTIONTYPE_EUSERACTIONTYPE_EXPRESSION_ENUM,
  EUSERACTIONTYPE_EUSERACTIONTYPE_MOTION_ENUM,
  EUSERACTIONTYPE_EUSERACTIONTYPE_GEAR_ACTION_ENUM,
  EUSERACTIONTYPE_EUSERACTIONTYPE_NORMALMOTION_ENUM,
  EUSERACTIONTYPE_EUSERACTIONTYPE_DIALOG_ENUM,
  EUSERACTIONTYPE_EUSERACTIONTYPE_MAX_ENUM
}
ERELIVETYPE_ERELIVETYPE_MIN_ENUM.name = "ERELIVETYPE_MIN"
ERELIVETYPE_ERELIVETYPE_MIN_ENUM.index = 0
ERELIVETYPE_ERELIVETYPE_MIN_ENUM.number = 0
ERELIVETYPE_ERELIVETYPE_RETURN_ENUM.name = "ERELIVETYPE_RETURN"
ERELIVETYPE_ERELIVETYPE_RETURN_ENUM.index = 1
ERELIVETYPE_ERELIVETYPE_RETURN_ENUM.number = 1
ERELIVETYPE_ERELIVETYPE_MONEY_ENUM.name = "ERELIVETYPE_MONEY"
ERELIVETYPE_ERELIVETYPE_MONEY_ENUM.index = 2
ERELIVETYPE_ERELIVETYPE_MONEY_ENUM.number = 2
ERELIVETYPE_ERELIVETYPE_RAND_ENUM.name = "ERELIVETYPE_RAND"
ERELIVETYPE_ERELIVETYPE_RAND_ENUM.index = 3
ERELIVETYPE_ERELIVETYPE_RAND_ENUM.number = 3
ERELIVETYPE_ERELIVETYPE_RETURNSAVE_ENUM.name = "ERELIVETYPE_RETURNSAVE"
ERELIVETYPE_ERELIVETYPE_RETURNSAVE_ENUM.index = 4
ERELIVETYPE_ERELIVETYPE_RETURNSAVE_ENUM.number = 4
ERELIVETYPE_ERELIVETYPE_SKILL_ENUM.name = "ERELIVETYPE_SKILL"
ERELIVETYPE_ERELIVETYPE_SKILL_ENUM.index = 5
ERELIVETYPE_ERELIVETYPE_SKILL_ENUM.number = 5
ERELIVETYPE_ERELIVETYPE_TOWER_ENUM.name = "ERELIVETYPE_TOWER"
ERELIVETYPE_ERELIVETYPE_TOWER_ENUM.index = 6
ERELIVETYPE_ERELIVETYPE_TOWER_ENUM.number = 6
ERELIVETYPE_ERELIVETYPE_MAX_ENUM.name = "ERELIVETYPE_MAX"
ERELIVETYPE_ERELIVETYPE_MAX_ENUM.index = 7
ERELIVETYPE_ERELIVETYPE_MAX_ENUM.number = 7
ERELIVETYPE.name = "EReliveType"
ERELIVETYPE.full_name = ".Cmd.EReliveType"
ERELIVETYPE.values = {
  ERELIVETYPE_ERELIVETYPE_MIN_ENUM,
  ERELIVETYPE_ERELIVETYPE_RETURN_ENUM,
  ERELIVETYPE_ERELIVETYPE_MONEY_ENUM,
  ERELIVETYPE_ERELIVETYPE_RAND_ENUM,
  ERELIVETYPE_ERELIVETYPE_RETURNSAVE_ENUM,
  ERELIVETYPE_ERELIVETYPE_SKILL_ENUM,
  ERELIVETYPE_ERELIVETYPE_TOWER_ENUM,
  ERELIVETYPE_ERELIVETYPE_MAX_ENUM
}
EEFFECTOPT_EEFFECTOPT_PLAY_ENUM.name = "EEFFECTOPT_PLAY"
EEFFECTOPT_EEFFECTOPT_PLAY_ENUM.index = 0
EEFFECTOPT_EEFFECTOPT_PLAY_ENUM.number = 1
EEFFECTOPT_EEFFECTOPT_STOP_ENUM.name = "EEFFECTOPT_STOP"
EEFFECTOPT_EEFFECTOPT_STOP_ENUM.index = 1
EEFFECTOPT_EEFFECTOPT_STOP_ENUM.number = 2
EEFFECTOPT_EEFFECTOPT_DELETE_ENUM.name = "EEFFECTOPT_DELETE"
EEFFECTOPT_EEFFECTOPT_DELETE_ENUM.index = 2
EEFFECTOPT_EEFFECTOPT_DELETE_ENUM.number = 3
EEFFECTOPT.name = "EEffectOpt"
EEFFECTOPT.full_name = ".Cmd.EEffectOpt"
EEFFECTOPT.values = {
  EEFFECTOPT_EEFFECTOPT_PLAY_ENUM,
  EEFFECTOPT_EEFFECTOPT_STOP_ENUM,
  EEFFECTOPT_EEFFECTOPT_DELETE_ENUM
}
EEFFECTTYPE_EEFFECTTYPE_NORMAL_ENUM.name = "EEFFECTTYPE_NORMAL"
EEFFECTTYPE_EEFFECTTYPE_NORMAL_ENUM.index = 0
EEFFECTTYPE_EEFFECTTYPE_NORMAL_ENUM.number = 1
EEFFECTTYPE_EEFFECTTYPE_ACCEPTQUEST_ENUM.name = "EEFFECTTYPE_ACCEPTQUEST"
EEFFECTTYPE_EEFFECTTYPE_ACCEPTQUEST_ENUM.index = 1
EEFFECTTYPE_EEFFECTTYPE_ACCEPTQUEST_ENUM.number = 2
EEFFECTTYPE_EEFFECTTYPE_FINISHQUEST_ENUM.name = "EEFFECTTYPE_FINISHQUEST"
EEFFECTTYPE_EEFFECTTYPE_FINISHQUEST_ENUM.index = 2
EEFFECTTYPE_EEFFECTTYPE_FINISHQUEST_ENUM.number = 3
EEFFECTTYPE_EEFFECTTYPE_MVPSHOW_ENUM.name = "EEFFECTTYPE_MVPSHOW"
EEFFECTTYPE_EEFFECTTYPE_MVPSHOW_ENUM.index = 3
EEFFECTTYPE_EEFFECTTYPE_MVPSHOW_ENUM.number = 4
EEFFECTTYPE_EEFFECTTYPE_SCENEEFFECT_ENUM.name = "EEFFECTTYPE_SCENEEFFECT"
EEFFECTTYPE_EEFFECTTYPE_SCENEEFFECT_ENUM.index = 4
EEFFECTTYPE_EEFFECTTYPE_SCENEEFFECT_ENUM.number = 5
EEFFECTTYPE.name = "EEffectType"
EEFFECTTYPE.full_name = ".Cmd.EEffectType"
EEFFECTTYPE.values = {
  EEFFECTTYPE_EEFFECTTYPE_NORMAL_ENUM,
  EEFFECTTYPE_EEFFECTTYPE_ACCEPTQUEST_ENUM,
  EEFFECTTYPE_EEFFECTTYPE_FINISHQUEST_ENUM,
  EEFFECTTYPE_EEFFECTTYPE_MVPSHOW_ENUM,
  EEFFECTTYPE_EEFFECTTYPE_SCENEEFFECT_ENUM
}
EDRESSTYPE_EDRESSTYPE_MIN_ENUM.name = "EDRESSTYPE_MIN"
EDRESSTYPE_EDRESSTYPE_MIN_ENUM.index = 0
EDRESSTYPE_EDRESSTYPE_MIN_ENUM.number = 0
EDRESSTYPE_EDRESSTYPE_HAIR_ENUM.name = "EDRESSTYPE_HAIR"
EDRESSTYPE_EDRESSTYPE_HAIR_ENUM.index = 1
EDRESSTYPE_EDRESSTYPE_HAIR_ENUM.number = 1
EDRESSTYPE_EDRESSTYPE_HAIRCOLOR_ENUM.name = "EDRESSTYPE_HAIRCOLOR"
EDRESSTYPE_EDRESSTYPE_HAIRCOLOR_ENUM.index = 2
EDRESSTYPE_EDRESSTYPE_HAIRCOLOR_ENUM.number = 2
EDRESSTYPE_EDRESSTYPE_EYE_ENUM.name = "EDRESSTYPE_EYE"
EDRESSTYPE_EDRESSTYPE_EYE_ENUM.index = 3
EDRESSTYPE_EDRESSTYPE_EYE_ENUM.number = 3
EDRESSTYPE_EDRESSTYPE_CLOTH_ENUM.name = "EDRESSTYPE_CLOTH"
EDRESSTYPE_EDRESSTYPE_CLOTH_ENUM.index = 4
EDRESSTYPE_EDRESSTYPE_CLOTH_ENUM.number = 4
EDRESSTYPE_EDRESSTYPE_MAX_ENUM.name = "EDRESSTYPE_MAX"
EDRESSTYPE_EDRESSTYPE_MAX_ENUM.index = 5
EDRESSTYPE_EDRESSTYPE_MAX_ENUM.number = 5
EDRESSTYPE.name = "EDressType"
EDRESSTYPE.full_name = ".Cmd.EDressType"
EDRESSTYPE.values = {
  EDRESSTYPE_EDRESSTYPE_MIN_ENUM,
  EDRESSTYPE_EDRESSTYPE_HAIR_ENUM,
  EDRESSTYPE_EDRESSTYPE_HAIRCOLOR_ENUM,
  EDRESSTYPE_EDRESSTYPE_EYE_ENUM,
  EDRESSTYPE_EDRESSTYPE_CLOTH_ENUM,
  EDRESSTYPE_EDRESSTYPE_MAX_ENUM
}
POINTTYPE_POINTTYPE_ADD_ENUM.name = "POINTTYPE_ADD"
POINTTYPE_POINTTYPE_ADD_ENUM.index = 0
POINTTYPE_POINTTYPE_ADD_ENUM.number = 1
POINTTYPE_POINTTYPE_RESET_ENUM.name = "POINTTYPE_RESET"
POINTTYPE_POINTTYPE_RESET_ENUM.index = 1
POINTTYPE_POINTTYPE_RESET_ENUM.number = 2
POINTTYPE.name = "PointType"
POINTTYPE.full_name = ".Cmd.PointType"
POINTTYPE.values = {
  POINTTYPE_POINTTYPE_ADD_ENUM,
  POINTTYPE_POINTTYPE_RESET_ENUM
}
EDBGMSGTYPE_EDBGMSGTYPE_MIN_ENUM.name = "EDBGMSGTYPE_MIN"
EDBGMSGTYPE_EDBGMSGTYPE_MIN_ENUM.index = 0
EDBGMSGTYPE_EDBGMSGTYPE_MIN_ENUM.number = 0
EDBGMSGTYPE_EDBGMSGTYPE_TEST_ENUM.name = "EDBGMSGTYPE_TEST"
EDBGMSGTYPE_EDBGMSGTYPE_TEST_ENUM.index = 1
EDBGMSGTYPE_EDBGMSGTYPE_TEST_ENUM.number = 1
EDBGMSGTYPE.name = "EDbgMsgType"
EDBGMSGTYPE.full_name = ".Cmd.EDbgMsgType"
EDBGMSGTYPE.values = {
  EDBGMSGTYPE_EDBGMSGTYPE_MIN_ENUM,
  EDBGMSGTYPE_EDBGMSGTYPE_TEST_ENUM
}
GAMETIMEOPT_EGAMETIMEOPT_SYNC_ENUM.name = "EGAMETIMEOPT_SYNC"
GAMETIMEOPT_EGAMETIMEOPT_SYNC_ENUM.index = 0
GAMETIMEOPT_EGAMETIMEOPT_SYNC_ENUM.number = 1
GAMETIMEOPT_EGAMETIMEOPT_ADJUST_ENUM.name = "EGAMETIMEOPT_ADJUST"
GAMETIMEOPT_EGAMETIMEOPT_ADJUST_ENUM.index = 1
GAMETIMEOPT_EGAMETIMEOPT_ADJUST_ENUM.number = 2
GAMETIMEOPT.name = "GameTimeOpt"
GAMETIMEOPT.full_name = ".Cmd.GameTimeOpt"
GAMETIMEOPT.values = {
  GAMETIMEOPT_EGAMETIMEOPT_SYNC_ENUM,
  GAMETIMEOPT_EGAMETIMEOPT_ADJUST_ENUM
}
CD_TYPE_CD_TYPE_SKILL_ENUM.name = "CD_TYPE_SKILL"
CD_TYPE_CD_TYPE_SKILL_ENUM.index = 0
CD_TYPE_CD_TYPE_SKILL_ENUM.number = 0
CD_TYPE_CD_TYPE_ITEM_ENUM.name = "CD_TYPE_ITEM"
CD_TYPE_CD_TYPE_ITEM_ENUM.index = 1
CD_TYPE_CD_TYPE_ITEM_ENUM.number = 1
CD_TYPE_CD_TYPE_SKILLDEALY_ENUM.name = "CD_TYPE_SKILLDEALY"
CD_TYPE_CD_TYPE_SKILLDEALY_ENUM.index = 2
CD_TYPE_CD_TYPE_SKILLDEALY_ENUM.number = 2
CD_TYPE.name = "CD_TYPE"
CD_TYPE.full_name = ".Cmd.CD_TYPE"
CD_TYPE.values = {
  CD_TYPE_CD_TYPE_SKILL_ENUM,
  CD_TYPE_CD_TYPE_ITEM_ENUM,
  CD_TYPE_CD_TYPE_SKILLDEALY_ENUM
}
EGOTOGEARTYPE_EGOTOGEARTYPE_SINGLE_ENUM.name = "EGoToGearType_Single"
EGOTOGEARTYPE_EGOTOGEARTYPE_SINGLE_ENUM.index = 0
EGOTOGEARTYPE_EGOTOGEARTYPE_SINGLE_ENUM.number = 1
EGOTOGEARTYPE_EGOTOGEARTYPE_HAND_ENUM.name = "EGoToGearType_Hand"
EGOTOGEARTYPE_EGOTOGEARTYPE_HAND_ENUM.index = 1
EGOTOGEARTYPE_EGOTOGEARTYPE_HAND_ENUM.number = 2
EGOTOGEARTYPE_EGOTOGEARTYPE_TEAM_ENUM.name = "EGoToGearType_Team"
EGOTOGEARTYPE_EGOTOGEARTYPE_TEAM_ENUM.index = 2
EGOTOGEARTYPE_EGOTOGEARTYPE_TEAM_ENUM.number = 3
EGOTOGEARTYPE_EGOTOGEARTYPE_FREE_ENUM.name = "EGoToGearType_Free"
EGOTOGEARTYPE_EGOTOGEARTYPE_FREE_ENUM.index = 3
EGOTOGEARTYPE_EGOTOGEARTYPE_FREE_ENUM.number = 4
EGOTOGEARTYPE.name = "EGoToGearType"
EGOTOGEARTYPE.full_name = ".Cmd.EGoToGearType"
EGOTOGEARTYPE.values = {
  EGOTOGEARTYPE_EGOTOGEARTYPE_SINGLE_ENUM,
  EGOTOGEARTYPE_EGOTOGEARTYPE_HAND_ENUM,
  EGOTOGEARTYPE_EGOTOGEARTYPE_TEAM_ENUM,
  EGOTOGEARTYPE_EGOTOGEARTYPE_FREE_ENUM
}
EFOLLOWTYPE_EFOLLOWTYPE_MIN_ENUM.name = "EFOLLOWTYPE_MIN"
EFOLLOWTYPE_EFOLLOWTYPE_MIN_ENUM.index = 0
EFOLLOWTYPE_EFOLLOWTYPE_MIN_ENUM.number = 0
EFOLLOWTYPE_EFOLLOWTYPE_HAND_ENUM.name = "EFOLLOWTYPE_HAND"
EFOLLOWTYPE_EFOLLOWTYPE_HAND_ENUM.index = 1
EFOLLOWTYPE_EFOLLOWTYPE_HAND_ENUM.number = 1
EFOLLOWTYPE_EFOLLOWTYPE_BREAK_ENUM.name = "EFOLLOWTYPE_BREAK"
EFOLLOWTYPE_EFOLLOWTYPE_BREAK_ENUM.index = 2
EFOLLOWTYPE_EFOLLOWTYPE_BREAK_ENUM.number = 5
EFOLLOWTYPE_EFOLLOWTYPE_TWINSACTION_ENUM.name = "EFOLLOWTYPE_TWINSACTION"
EFOLLOWTYPE_EFOLLOWTYPE_TWINSACTION_ENUM.index = 3
EFOLLOWTYPE_EFOLLOWTYPE_TWINSACTION_ENUM.number = 6
EFOLLOWTYPE_EFOLLOWTYPE_MAX_ENUM.name = "EFOLLOWTYPE_MAX"
EFOLLOWTYPE_EFOLLOWTYPE_MAX_ENUM.index = 4
EFOLLOWTYPE_EFOLLOWTYPE_MAX_ENUM.number = 7
EFOLLOWTYPE.name = "EFollowType"
EFOLLOWTYPE.full_name = ".Cmd.EFollowType"
EFOLLOWTYPE.values = {
  EFOLLOWTYPE_EFOLLOWTYPE_MIN_ENUM,
  EFOLLOWTYPE_EFOLLOWTYPE_HAND_ENUM,
  EFOLLOWTYPE_EFOLLOWTYPE_BREAK_ENUM,
  EFOLLOWTYPE_EFOLLOWTYPE_TWINSACTION_ENUM,
  EFOLLOWTYPE_EFOLLOWTYPE_MAX_ENUM
}
EALBUMTYPE_EALBUMTYPE_MIN_ENUM.name = "EALBUMTYPE_MIN"
EALBUMTYPE_EALBUMTYPE_MIN_ENUM.index = 0
EALBUMTYPE_EALBUMTYPE_MIN_ENUM.number = 0
EALBUMTYPE_EALBUMTYPE_SCENERY_ENUM.name = "EALBUMTYPE_SCENERY"
EALBUMTYPE_EALBUMTYPE_SCENERY_ENUM.index = 1
EALBUMTYPE_EALBUMTYPE_SCENERY_ENUM.number = 1
EALBUMTYPE_EALBUMTYPE_PHOTO_ENUM.name = "EALBUMTYPE_PHOTO"
EALBUMTYPE_EALBUMTYPE_PHOTO_ENUM.index = 2
EALBUMTYPE_EALBUMTYPE_PHOTO_ENUM.number = 2
EALBUMTYPE_EALBUMTYPE_GUILD_ICON_ENUM.name = "EALBUMTYPE_GUILD_ICON"
EALBUMTYPE_EALBUMTYPE_GUILD_ICON_ENUM.index = 3
EALBUMTYPE_EALBUMTYPE_GUILD_ICON_ENUM.number = 3
EALBUMTYPE_EALBUMTYPE_WEDDING_ENUM.name = "EALBUMTYPE_WEDDING"
EALBUMTYPE_EALBUMTYPE_WEDDING_ENUM.index = 4
EALBUMTYPE_EALBUMTYPE_WEDDING_ENUM.number = 4
EALBUMTYPE_EALBUMTYPE_MAX_ENUM.name = "EALBUMTYPE_MAX"
EALBUMTYPE_EALBUMTYPE_MAX_ENUM.index = 5
EALBUMTYPE_EALBUMTYPE_MAX_ENUM.number = 5
EALBUMTYPE.name = "EAlbumType"
EALBUMTYPE.full_name = ".Cmd.EAlbumType"
EALBUMTYPE.values = {
  EALBUMTYPE_EALBUMTYPE_MIN_ENUM,
  EALBUMTYPE_EALBUMTYPE_SCENERY_ENUM,
  EALBUMTYPE_EALBUMTYPE_PHOTO_ENUM,
  EALBUMTYPE_EALBUMTYPE_GUILD_ICON_ENUM,
  EALBUMTYPE_EALBUMTYPE_WEDDING_ENUM,
  EALBUMTYPE_EALBUMTYPE_MAX_ENUM
}
EBATTLESTATUS_EBATTLESTATUS_EASY_ENUM.name = "EBATTLESTATUS_EASY"
EBATTLESTATUS_EBATTLESTATUS_EASY_ENUM.index = 0
EBATTLESTATUS_EBATTLESTATUS_EASY_ENUM.number = 1
EBATTLESTATUS_EBATTLESTATUS_TIRED_ENUM.name = "EBATTLESTATUS_TIRED"
EBATTLESTATUS_EBATTLESTATUS_TIRED_ENUM.index = 1
EBATTLESTATUS_EBATTLESTATUS_TIRED_ENUM.number = 2
EBATTLESTATUS_EBATTLESTATUS_HIGHTIRED_ENUM.name = "EBATTLESTATUS_HIGHTIRED"
EBATTLESTATUS_EBATTLESTATUS_HIGHTIRED_ENUM.index = 2
EBATTLESTATUS_EBATTLESTATUS_HIGHTIRED_ENUM.number = 3
EBATTLESTATUS.name = "EBattleStatus"
EBATTLESTATUS.full_name = ".Cmd.EBattleStatus"
EBATTLESTATUS.values = {
  EBATTLESTATUS_EBATTLESTATUS_EASY_ENUM,
  EBATTLESTATUS_EBATTLESTATUS_TIRED_ENUM,
  EBATTLESTATUS_EBATTLESTATUS_HIGHTIRED_ENUM
}
EQUERYTYPE_EQUERYTYPE_MIN_ENUM.name = "EQUERYTYPE_MIN"
EQUERYTYPE_EQUERYTYPE_MIN_ENUM.index = 0
EQUERYTYPE_EQUERYTYPE_MIN_ENUM.number = 0
EQUERYTYPE_EQUERYTYPE_ALL_ENUM.name = "EQUERYTYPE_ALL"
EQUERYTYPE_EQUERYTYPE_ALL_ENUM.index = 1
EQUERYTYPE_EQUERYTYPE_ALL_ENUM.number = 1
EQUERYTYPE_EQUERYTYPE_FRIEND_ENUM.name = "EQUERYTYPE_FRIEND"
EQUERYTYPE_EQUERYTYPE_FRIEND_ENUM.index = 2
EQUERYTYPE_EQUERYTYPE_FRIEND_ENUM.number = 2
EQUERYTYPE_EQUERYTYPE_CLOSE_ENUM.name = "EQUERYTYPE_CLOSE"
EQUERYTYPE_EQUERYTYPE_CLOSE_ENUM.index = 3
EQUERYTYPE_EQUERYTYPE_CLOSE_ENUM.number = 3
EQUERYTYPE_EQUERYTYPE_WEDDING_ALL_ENUM.name = "EQUERYTYPE_WEDDING_ALL"
EQUERYTYPE_EQUERYTYPE_WEDDING_ALL_ENUM.index = 4
EQUERYTYPE_EQUERYTYPE_WEDDING_ALL_ENUM.number = 4
EQUERYTYPE_EQUERYTYPE_WEDDING_FRIEND_ENUM.name = "EQUERYTYPE_WEDDING_FRIEND"
EQUERYTYPE_EQUERYTYPE_WEDDING_FRIEND_ENUM.index = 5
EQUERYTYPE_EQUERYTYPE_WEDDING_FRIEND_ENUM.number = 5
EQUERYTYPE_EQUERYTYPE_WEDDING_CLOSE_ENUM.name = "EQUERYTYPE_WEDDING_CLOSE"
EQUERYTYPE_EQUERYTYPE_WEDDING_CLOSE_ENUM.index = 6
EQUERYTYPE_EQUERYTYPE_WEDDING_CLOSE_ENUM.number = 6
EQUERYTYPE_EQUERYTYPE_MAX_ENUM.name = "EQUERYTYPE_MAX"
EQUERYTYPE_EQUERYTYPE_MAX_ENUM.index = 7
EQUERYTYPE_EQUERYTYPE_MAX_ENUM.number = 7
EQUERYTYPE.name = "EQueryType"
EQUERYTYPE.full_name = ".Cmd.EQueryType"
EQUERYTYPE.values = {
  EQUERYTYPE_EQUERYTYPE_MIN_ENUM,
  EQUERYTYPE_EQUERYTYPE_ALL_ENUM,
  EQUERYTYPE_EQUERYTYPE_FRIEND_ENUM,
  EQUERYTYPE_EQUERYTYPE_CLOSE_ENUM,
  EQUERYTYPE_EQUERYTYPE_WEDDING_ALL_ENUM,
  EQUERYTYPE_EQUERYTYPE_WEDDING_FRIEND_ENUM,
  EQUERYTYPE_EQUERYTYPE_WEDDING_CLOSE_ENUM,
  EQUERYTYPE_EQUERYTYPE_MAX_ENUM
}
EFASHIONHIDETYPE_EFASHIONHIDETYPE_HEAD_ENUM.name = "EFASHIONHIDETYPE_HEAD"
EFASHIONHIDETYPE_EFASHIONHIDETYPE_HEAD_ENUM.index = 0
EFASHIONHIDETYPE_EFASHIONHIDETYPE_HEAD_ENUM.number = 0
EFASHIONHIDETYPE_EFASHIONHIDETYPE_BACK_ENUM.name = "EFASHIONHIDETYPE_BACK"
EFASHIONHIDETYPE_EFASHIONHIDETYPE_BACK_ENUM.index = 1
EFASHIONHIDETYPE_EFASHIONHIDETYPE_BACK_ENUM.number = 1
EFASHIONHIDETYPE_EFASHIONHIDETYPE_FACE_ENUM.name = "EFASHIONHIDETYPE_FACE"
EFASHIONHIDETYPE_EFASHIONHIDETYPE_FACE_ENUM.index = 2
EFASHIONHIDETYPE_EFASHIONHIDETYPE_FACE_ENUM.number = 2
EFASHIONHIDETYPE_EFASHIONHIDETYPE_TAIL_ENUM.name = "EFASHIONHIDETYPE_TAIL"
EFASHIONHIDETYPE_EFASHIONHIDETYPE_TAIL_ENUM.index = 3
EFASHIONHIDETYPE_EFASHIONHIDETYPE_TAIL_ENUM.number = 3
EFASHIONHIDETYPE_EFASHIONHIDETYPE_MOUTH_ENUM.name = "EFASHIONHIDETYPE_MOUTH"
EFASHIONHIDETYPE_EFASHIONHIDETYPE_MOUTH_ENUM.index = 4
EFASHIONHIDETYPE_EFASHIONHIDETYPE_MOUTH_ENUM.number = 4
EFASHIONHIDETYPE_EFASHIONHIDETYPE_BODY_ENUM.name = "EFASHIONHIDETYPE_BODY"
EFASHIONHIDETYPE_EFASHIONHIDETYPE_BODY_ENUM.index = 5
EFASHIONHIDETYPE_EFASHIONHIDETYPE_BODY_ENUM.number = 5
EFASHIONHIDETYPE_EFASHIONHIDETYPE_MAX_ENUM.name = "EFASHIONHIDETYPE_MAX"
EFASHIONHIDETYPE_EFASHIONHIDETYPE_MAX_ENUM.index = 6
EFASHIONHIDETYPE_EFASHIONHIDETYPE_MAX_ENUM.number = 6
EFASHIONHIDETYPE.name = "EFashionHideType"
EFASHIONHIDETYPE.full_name = ".Cmd.EFashionHideType"
EFASHIONHIDETYPE.values = {
  EFASHIONHIDETYPE_EFASHIONHIDETYPE_HEAD_ENUM,
  EFASHIONHIDETYPE_EFASHIONHIDETYPE_BACK_ENUM,
  EFASHIONHIDETYPE_EFASHIONHIDETYPE_FACE_ENUM,
  EFASHIONHIDETYPE_EFASHIONHIDETYPE_TAIL_ENUM,
  EFASHIONHIDETYPE_EFASHIONHIDETYPE_MOUTH_ENUM,
  EFASHIONHIDETYPE_EFASHIONHIDETYPE_BODY_ENUM,
  EFASHIONHIDETYPE_EFASHIONHIDETYPE_MAX_ENUM
}
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_DOJO_ENUM.name = "ECOUNTDOWNTYPE_DOJO"
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_DOJO_ENUM.index = 0
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_DOJO_ENUM.number = 1
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_TOWER_ENUM.name = "ECOUNTDOWNTYPE_TOWER"
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_TOWER_ENUM.index = 1
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_TOWER_ENUM.number = 2
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_ALTMAN_ENUM.name = "ECOUNTDOWNTYPE_ALTMAN"
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_ALTMAN_ENUM.index = 2
ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_ALTMAN_ENUM.number = 3
ECOUNTDOWNTYPE.name = "ECountDownType"
ECOUNTDOWNTYPE.full_name = ".Cmd.ECountDownType"
ECOUNTDOWNTYPE.values = {
  ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_DOJO_ENUM,
  ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_TOWER_ENUM,
  ECOUNTDOWNTYPE_ECOUNTDOWNTYPE_ALTMAN_ENUM
}
ETREESTATUS_ETREESTATUS_MIN_ENUM.name = "ETREESTATUS_MIN"
ETREESTATUS_ETREESTATUS_MIN_ENUM.index = 0
ETREESTATUS_ETREESTATUS_MIN_ENUM.number = 0
ETREESTATUS_ETREESTATUS_NORMAL_ENUM.name = "ETREESTATUS_NORMAL"
ETREESTATUS_ETREESTATUS_NORMAL_ENUM.index = 1
ETREESTATUS_ETREESTATUS_NORMAL_ENUM.number = 1
ETREESTATUS_ETREESTATUS_MONSTER_ENUM.name = "ETREESTATUS_MONSTER"
ETREESTATUS_ETREESTATUS_MONSTER_ENUM.index = 2
ETREESTATUS_ETREESTATUS_MONSTER_ENUM.number = 2
ETREESTATUS_ETREESTATUS_REWARD_ENUM.name = "ETREESTATUS_REWARD"
ETREESTATUS_ETREESTATUS_REWARD_ENUM.index = 3
ETREESTATUS_ETREESTATUS_REWARD_ENUM.number = 3
ETREESTATUS_ETREESTATUS_DEAD_ENUM.name = "ETREESTATUS_DEAD"
ETREESTATUS_ETREESTATUS_DEAD_ENUM.index = 4
ETREESTATUS_ETREESTATUS_DEAD_ENUM.number = 4
ETREESTATUS_ETREESTATUS_MAX_ENUM.name = "ETREESTATUS_MAX"
ETREESTATUS_ETREESTATUS_MAX_ENUM.index = 5
ETREESTATUS_ETREESTATUS_MAX_ENUM.number = 5
ETREESTATUS.name = "ETreeStatus"
ETREESTATUS.full_name = ".Cmd.ETreeStatus"
ETREESTATUS.values = {
  ETREESTATUS_ETREESTATUS_MIN_ENUM,
  ETREESTATUS_ETREESTATUS_NORMAL_ENUM,
  ETREESTATUS_ETREESTATUS_MONSTER_ENUM,
  ETREESTATUS_ETREESTATUS_REWARD_ENUM,
  ETREESTATUS_ETREESTATUS_DEAD_ENUM,
  ETREESTATUS_ETREESTATUS_MAX_ENUM
}
EZONESTATUS_EZONESTATUS_MIN_ENUM.name = "EZONESTATUS_MIN"
EZONESTATUS_EZONESTATUS_MIN_ENUM.index = 0
EZONESTATUS_EZONESTATUS_MIN_ENUM.number = 0
EZONESTATUS_EZONESTATUS_FREE_ENUM.name = "EZONESTATUS_FREE"
EZONESTATUS_EZONESTATUS_FREE_ENUM.index = 1
EZONESTATUS_EZONESTATUS_FREE_ENUM.number = 1
EZONESTATUS_EZONESTATUS_BUSY_ENUM.name = "EZONESTATUS_BUSY"
EZONESTATUS_EZONESTATUS_BUSY_ENUM.index = 2
EZONESTATUS_EZONESTATUS_BUSY_ENUM.number = 2
EZONESTATUS_EZONESTATUS_VERYBUSY_ENUM.name = "EZONESTATUS_VERYBUSY"
EZONESTATUS_EZONESTATUS_VERYBUSY_ENUM.index = 3
EZONESTATUS_EZONESTATUS_VERYBUSY_ENUM.number = 3
EZONESTATUS_EZONESTATUS_MAX_ENUM.name = "EZONESTATUS_MAX"
EZONESTATUS_EZONESTATUS_MAX_ENUM.index = 4
EZONESTATUS_EZONESTATUS_MAX_ENUM.number = 4
EZONESTATUS.name = "EZoneStatus"
EZONESTATUS.full_name = ".Cmd.EZoneStatus"
EZONESTATUS.values = {
  EZONESTATUS_EZONESTATUS_MIN_ENUM,
  EZONESTATUS_EZONESTATUS_FREE_ENUM,
  EZONESTATUS_EZONESTATUS_BUSY_ENUM,
  EZONESTATUS_EZONESTATUS_VERYBUSY_ENUM,
  EZONESTATUS_EZONESTATUS_MAX_ENUM
}
EZONESTATE_EZONESTATE_MIN_ENUM.name = "EZONESTATE_MIN"
EZONESTATE_EZONESTATE_MIN_ENUM.index = 0
EZONESTATE_EZONESTATE_MIN_ENUM.number = 0
EZONESTATE_EZONESTATE_FULL_ENUM.name = "EZONESTATE_FULL"
EZONESTATE_EZONESTATE_FULL_ENUM.index = 1
EZONESTATE_EZONESTATE_FULL_ENUM.number = 1
EZONESTATE_EZONESTATE_NOFULL_ENUM.name = "EZONESTATE_NOFULL"
EZONESTATE_EZONESTATE_NOFULL_ENUM.index = 2
EZONESTATE_EZONESTATE_NOFULL_ENUM.number = 2
EZONESTATE_EZONESTATE_MAX_ENUM.name = "EZONESTATE_MAX"
EZONESTATE_EZONESTATE_MAX_ENUM.index = 3
EZONESTATE_EZONESTATE_MAX_ENUM.number = 3
EZONESTATE.name = "EZoneState"
EZONESTATE.full_name = ".Cmd.EZoneState"
EZONESTATE.values = {
  EZONESTATE_EZONESTATE_MIN_ENUM,
  EZONESTATE_EZONESTATE_FULL_ENUM,
  EZONESTATE_EZONESTATE_NOFULL_ENUM,
  EZONESTATE_EZONESTATE_MAX_ENUM
}
EJUMPZONE_EJUMPZONE_MIN_ENUM.name = "EJUMPZONE_MIN"
EJUMPZONE_EJUMPZONE_MIN_ENUM.index = 0
EJUMPZONE_EJUMPZONE_MIN_ENUM.number = 0
EJUMPZONE_EJUMPZONE_GUILD_ENUM.name = "EJUMPZONE_GUILD"
EJUMPZONE_EJUMPZONE_GUILD_ENUM.index = 1
EJUMPZONE_EJUMPZONE_GUILD_ENUM.number = 1
EJUMPZONE_EJUMPZONE_TEAM_ENUM.name = "EJUMPZONE_TEAM"
EJUMPZONE_EJUMPZONE_TEAM_ENUM.index = 2
EJUMPZONE_EJUMPZONE_TEAM_ENUM.number = 2
EJUMPZONE_EJUMPZONE_USER_ENUM.name = "EJUMPZONE_USER"
EJUMPZONE_EJUMPZONE_USER_ENUM.index = 3
EJUMPZONE_EJUMPZONE_USER_ENUM.number = 3
EJUMPZONE_EJUMPZONE_MAX_ENUM.name = "EJUMPZONE_MAX"
EJUMPZONE_EJUMPZONE_MAX_ENUM.index = 4
EJUMPZONE_EJUMPZONE_MAX_ENUM.number = 4
EJUMPZONE.name = "EJumpZone"
EJUMPZONE.full_name = ".Cmd.EJumpZone"
EJUMPZONE.values = {
  EJUMPZONE_EJUMPZONE_MIN_ENUM,
  EJUMPZONE_EJUMPZONE_GUILD_ENUM,
  EJUMPZONE_EJUMPZONE_TEAM_ENUM,
  EJUMPZONE_EJUMPZONE_USER_ENUM,
  EJUMPZONE_EJUMPZONE_MAX_ENUM
}
SEATSHOWTYPE_SEAT_SHOW_VISIBLE_ENUM.name = "SEAT_SHOW_VISIBLE"
SEATSHOWTYPE_SEAT_SHOW_VISIBLE_ENUM.index = 0
SEATSHOWTYPE_SEAT_SHOW_VISIBLE_ENUM.number = 0
SEATSHOWTYPE_SEAT_SHOW_INVISIBLE_ENUM.name = "SEAT_SHOW_INVISIBLE"
SEATSHOWTYPE_SEAT_SHOW_INVISIBLE_ENUM.index = 1
SEATSHOWTYPE_SEAT_SHOW_INVISIBLE_ENUM.number = 1
SEATSHOWTYPE.name = "SeatShowType"
SEATSHOWTYPE.full_name = ".Cmd.SeatShowType"
SEATSHOWTYPE.values = {
  SEATSHOWTYPE_SEAT_SHOW_VISIBLE_ENUM,
  SEATSHOWTYPE_SEAT_SHOW_INVISIBLE_ENUM
}
EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_HP_ENUM.name = "EOPTIONTYPE_USE_SAVE_HP"
EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_HP_ENUM.index = 0
EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_HP_ENUM.number = 0
EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_SP_ENUM.name = "EOPTIONTYPE_USE_SAVE_SP"
EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_SP_ENUM.index = 1
EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_SP_ENUM.number = 1
EOPTIONTYPE_EOPTIONTYPE_USE_SLIM_ENUM.name = "EOPTIONTYPE_USE_SLIM"
EOPTIONTYPE_EOPTIONTYPE_USE_SLIM_ENUM.index = 2
EOPTIONTYPE_EOPTIONTYPE_USE_SLIM_ENUM.number = 2
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_HEAD_ENUM.name = "EOPTIONTYPE_LOTTERY_CNT_HEAD"
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_HEAD_ENUM.index = 3
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_HEAD_ENUM.number = 3
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_EQUIP_ENUM.name = "EOPTIONTYPE_LOTTERY_CNT_EQUIP"
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_EQUIP_ENUM.index = 4
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_EQUIP_ENUM.number = 4
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_CARD_ENUM.name = "EOPTIONTYPE_LOTTERY_CNT_CARD"
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_CARD_ENUM.index = 5
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_CARD_ENUM.number = 5
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_ENUM.name = "EOPTIONTYPE_LOTTERY_CNT_MAGIC"
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_ENUM.index = 6
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_ENUM.number = 6
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_GIVE_ENUM.name = "EOPTIONTYPE_LOTTERY_CNT_GIVE"
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_GIVE_ENUM.index = 7
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_GIVE_ENUM.number = 7
EOPTIONTYPE_EOPTIONTYPE_USE_PETTALK_ENUM.name = "EOPTIONTYPE_USE_PETTALK"
EOPTIONTYPE_EOPTIONTYPE_USE_PETTALK_ENUM.index = 8
EOPTIONTYPE_EOPTIONTYPE_USE_PETTALK_ENUM.number = 8
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_2_ENUM.name = "EOPTIONTYPE_LOTTERY_CNT_MAGIC_2"
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_2_ENUM.index = 9
EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_2_ENUM.number = 9
EOPTIONTYPE_EOPTIONTYPE_MAX_ENUM.name = "EOPTIONTYPE_MAX"
EOPTIONTYPE_EOPTIONTYPE_MAX_ENUM.index = 10
EOPTIONTYPE_EOPTIONTYPE_MAX_ENUM.number = 63
EOPTIONTYPE.name = "EOptionType"
EOPTIONTYPE.full_name = ".Cmd.EOptionType"
EOPTIONTYPE.values = {
  EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_HP_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_USE_SAVE_SP_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_USE_SLIM_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_HEAD_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_EQUIP_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_CARD_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_GIVE_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_USE_PETTALK_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_LOTTERY_CNT_MAGIC_2_ENUM,
  EOPTIONTYPE_EOPTIONTYPE_MAX_ENUM
}
ERENAMEERRCODE_ERENAME_SUCCESS_ENUM.name = "ERENAME_SUCCESS"
ERENAMEERRCODE_ERENAME_SUCCESS_ENUM.index = 0
ERENAMEERRCODE_ERENAME_SUCCESS_ENUM.number = 0
ERENAMEERRCODE_ERENAME_CD_ENUM.name = "ERENAME_CD"
ERENAMEERRCODE_ERENAME_CD_ENUM.index = 1
ERENAMEERRCODE_ERENAME_CD_ENUM.number = 1
ERENAMEERRCODE_ERENAME_CONFLICT_ENUM.name = "ERENAME_CONFLICT"
ERENAMEERRCODE_ERENAME_CONFLICT_ENUM.index = 2
ERENAMEERRCODE_ERENAME_CONFLICT_ENUM.number = 2
ERENAMEERRCODE.name = "ERenameErrCode"
ERENAMEERRCODE.full_name = ".Cmd.ERenameErrCode"
ERENAMEERRCODE.values = {
  ERENAMEERRCODE_ERENAME_SUCCESS_ENUM,
  ERENAMEERRCODE_ERENAME_CD_ENUM,
  ERENAMEERRCODE_ERENAME_CONFLICT_ENUM
}
EPROPOSALREPLY_EPROPOSALREPLY_YES_ENUM.name = "EPROPOSALREPLY_YES"
EPROPOSALREPLY_EPROPOSALREPLY_YES_ENUM.index = 0
EPROPOSALREPLY_EPROPOSALREPLY_YES_ENUM.number = 0
EPROPOSALREPLY_EPROPOSALREPLY_NO_ENUM.name = "EPROPOSALREPLY_NO"
EPROPOSALREPLY_EPROPOSALREPLY_NO_ENUM.index = 1
EPROPOSALREPLY_EPROPOSALREPLY_NO_ENUM.number = 1
EPROPOSALREPLY_EPROPOSALREPLY_OUTRANGE_ENUM.name = "EPROPOSALREPLY_OUTRANGE"
EPROPOSALREPLY_EPROPOSALREPLY_OUTRANGE_ENUM.index = 2
EPROPOSALREPLY_EPROPOSALREPLY_OUTRANGE_ENUM.number = 2
EPROPOSALREPLY_EPROPOSALREPLY_CANCEL_ENUM.name = "EPROPOSALREPLY_CANCEL"
EPROPOSALREPLY_EPROPOSALREPLY_CANCEL_ENUM.index = 3
EPROPOSALREPLY_EPROPOSALREPLY_CANCEL_ENUM.number = 3
EPROPOSALREPLY.name = "EProposalReply"
EPROPOSALREPLY.full_name = ".Cmd.EProposalReply"
EPROPOSALREPLY.values = {
  EPROPOSALREPLY_EPROPOSALREPLY_YES_ENUM,
  EPROPOSALREPLY_EPROPOSALREPLY_NO_ENUM,
  EPROPOSALREPLY_EPROPOSALREPLY_OUTRANGE_ENUM,
  EPROPOSALREPLY_EPROPOSALREPLY_CANCEL_ENUM
}
SHARETYPE_ESHARETYPE_KFC_SHARE_ENUM.name = "ESHARETYPE_KFC_SHARE"
SHARETYPE_ESHARETYPE_KFC_SHARE_ENUM.index = 0
SHARETYPE_ESHARETYPE_KFC_SHARE_ENUM.number = 0
SHARETYPE_ESHARETYPE_KFC_ARPHOTO_SHARE_ENUM.name = "ESHARETYPE_KFC_ARPHOTO_SHARE"
SHARETYPE_ESHARETYPE_KFC_ARPHOTO_SHARE_ENUM.index = 1
SHARETYPE_ESHARETYPE_KFC_ARPHOTO_SHARE_ENUM.number = 1
SHARETYPE_ESHARETYPE_CONCERT_ENUM.name = "ESHARETYPE_CONCERT"
SHARETYPE_ESHARETYPE_CONCERT_ENUM.index = 2
SHARETYPE_ESHARETYPE_CONCERT_ENUM.number = 3
SHARETYPE.name = "ShareType"
SHARETYPE.full_name = ".Cmd.ShareType"
SHARETYPE.values = {
  SHARETYPE_ESHARETYPE_KFC_SHARE_ENUM,
  SHARETYPE_ESHARETYPE_KFC_ARPHOTO_SHARE_ENUM,
  SHARETYPE_ESHARETYPE_CONCERT_ENUM
}
ENROLLRESULT_EENROLLRESULT_SUCCESS_ENUM.name = "EENROLLRESULT_SUCCESS"
ENROLLRESULT_EENROLLRESULT_SUCCESS_ENUM.index = 0
ENROLLRESULT_EENROLLRESULT_SUCCESS_ENUM.number = 0
ENROLLRESULT_EENROLLRESULT_CHARID_EXISTED_ENUM.name = "EENROLLRESULT_CHARID_EXISTED"
ENROLLRESULT_EENROLLRESULT_CHARID_EXISTED_ENUM.index = 1
ENROLLRESULT_EENROLLRESULT_CHARID_EXISTED_ENUM.number = 1
ENROLLRESULT_EENROLLRESULT_PHONE_EXISTED_ENUM.name = "EENROLLRESULT_PHONE_EXISTED"
ENROLLRESULT_EENROLLRESULT_PHONE_EXISTED_ENUM.index = 2
ENROLLRESULT_EENROLLRESULT_PHONE_EXISTED_ENUM.number = 2
ENROLLRESULT_EENROLLRESULT_CODE_INCORRECT_ENUM.name = "EENROLLRESULT_CODE_INCORRECT"
ENROLLRESULT_EENROLLRESULT_CODE_INCORRECT_ENUM.index = 3
ENROLLRESULT_EENROLLRESULT_CODE_INCORRECT_ENUM.number = 3
ENROLLRESULT_EENROLLRESULT_CODE_INVALID_ENUM.name = "EENROLLRESULT_CODE_INVALID"
ENROLLRESULT_EENROLLRESULT_CODE_INVALID_ENUM.index = 4
ENROLLRESULT_EENROLLRESULT_CODE_INVALID_ENUM.number = 4
ENROLLRESULT_EENROLLRESULT_CODE_TOOFAST_ENUM.name = "EENROLLRESULT_CODE_TOOFAST"
ENROLLRESULT_EENROLLRESULT_CODE_TOOFAST_ENUM.index = 5
ENROLLRESULT_EENROLLRESULT_CODE_TOOFAST_ENUM.number = 5
ENROLLRESULT_EENROLLRESULT_ERROR_ENUM.name = "EENROLLRESULT_ERROR"
ENROLLRESULT_EENROLLRESULT_ERROR_ENUM.index = 6
ENROLLRESULT_EENROLLRESULT_ERROR_ENUM.number = 6
ENROLLRESULT.name = "EnrollResult"
ENROLLRESULT.full_name = ".Cmd.EnrollResult"
ENROLLRESULT.values = {
  ENROLLRESULT_EENROLLRESULT_SUCCESS_ENUM,
  ENROLLRESULT_EENROLLRESULT_CHARID_EXISTED_ENUM,
  ENROLLRESULT_EENROLLRESULT_PHONE_EXISTED_ENUM,
  ENROLLRESULT_EENROLLRESULT_CODE_INCORRECT_ENUM,
  ENROLLRESULT_EENROLLRESULT_CODE_INVALID_ENUM,
  ENROLLRESULT_EENROLLRESULT_CODE_TOOFAST_ENUM,
  ENROLLRESULT_EENROLLRESULT_ERROR_ENUM
}
ETWINSOPERATION_ETWINS_OPERATION_MIN_ENUM.name = "ETWINS_OPERATION_MIN"
ETWINSOPERATION_ETWINS_OPERATION_MIN_ENUM.index = 0
ETWINSOPERATION_ETWINS_OPERATION_MIN_ENUM.number = 0
ETWINSOPERATION_ETWINS_OPERATION_SPONSOR_ENUM.name = "ETWINS_OPERATION_SPONSOR"
ETWINSOPERATION_ETWINS_OPERATION_SPONSOR_ENUM.index = 1
ETWINSOPERATION_ETWINS_OPERATION_SPONSOR_ENUM.number = 1
ETWINSOPERATION_ETWINS_OPERATION_REQUEST_ENUM.name = "ETWINS_OPERATION_REQUEST"
ETWINSOPERATION_ETWINS_OPERATION_REQUEST_ENUM.index = 2
ETWINSOPERATION_ETWINS_OPERATION_REQUEST_ENUM.number = 2
ETWINSOPERATION_ETWINS_OPERATION_AGREE_ENUM.name = "ETWINS_OPERATION_AGREE"
ETWINSOPERATION_ETWINS_OPERATION_AGREE_ENUM.index = 3
ETWINSOPERATION_ETWINS_OPERATION_AGREE_ENUM.number = 3
ETWINSOPERATION_ETWINS_OPERATION_DISAGREE_ENUM.name = "ETWINS_OPERATION_DISAGREE"
ETWINSOPERATION_ETWINS_OPERATION_DISAGREE_ENUM.index = 4
ETWINSOPERATION_ETWINS_OPERATION_DISAGREE_ENUM.number = 4
ETWINSOPERATION_ETWINS_OPERATION_COMMIT_ENUM.name = "ETWINS_OPERATION_COMMIT"
ETWINSOPERATION_ETWINS_OPERATION_COMMIT_ENUM.index = 5
ETWINSOPERATION_ETWINS_OPERATION_COMMIT_ENUM.number = 5
ETWINSOPERATION.name = "ETwinsOperation"
ETWINSOPERATION.full_name = ".Cmd.ETwinsOperation"
ETWINSOPERATION.values = {
  ETWINSOPERATION_ETWINS_OPERATION_MIN_ENUM,
  ETWINSOPERATION_ETWINS_OPERATION_SPONSOR_ENUM,
  ETWINSOPERATION_ETWINS_OPERATION_REQUEST_ENUM,
  ETWINSOPERATION_ETWINS_OPERATION_AGREE_ENUM,
  ETWINSOPERATION_ETWINS_OPERATION_DISAGREE_ENUM,
  ETWINSOPERATION_ETWINS_OPERATION_COMMIT_ENUM
}
ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_ENUM.name = "ESERVANT_SERVICE_RECOMMEND"
ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_ENUM.index = 0
ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_ENUM.number = 1
ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_THREE_ENUM.name = "ESERVANT_SERVICE_FINANCE_THREE"
ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_THREE_ENUM.index = 1
ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_THREE_ENUM.number = 2
ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_SEVEN_ENUM.name = "ESERVANT_SERVICE_FINANCE_SEVEN"
ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_SEVEN_ENUM.index = 2
ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_SEVEN_ENUM.number = 3
ESERVANTSERVICE_ESERVANT_SERVICE_UPGRADE_ENUM.name = "ESERVANT_SERVICE_UPGRADE"
ESERVANTSERVICE_ESERVANT_SERVICE_UPGRADE_ENUM.index = 3
ESERVANTSERVICE_ESERVANT_SERVICE_UPGRADE_ENUM.number = 4
ESERVANTSERVICE_ESERVANT_SERVICE_SPECIAL_ENUM.name = "ESERVANT_SERVICE_SPECIAL"
ESERVANTSERVICE_ESERVANT_SERVICE_SPECIAL_ENUM.index = 4
ESERVANTSERVICE_ESERVANT_SERVICE_SPECIAL_ENUM.number = 5
ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_REFRESH_ENUM.name = "ESERVANT_SERVICE_RECOMMEND_REFRESH"
ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_REFRESH_ENUM.index = 5
ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_REFRESH_ENUM.number = 6
ESERVANTSERVICE_ESERVANT_SERVICE_INVITE_HAND_ENUM.name = "ESERVANT_SERVICE_INVITE_HAND"
ESERVANTSERVICE_ESERVANT_SERVICE_INVITE_HAND_ENUM.index = 6
ESERVANTSERVICE_ESERVANT_SERVICE_INVITE_HAND_ENUM.number = 7
ESERVANTSERVICE_ESERVANT_SERVICE_BREAK_HAND_ENUM.name = "ESERVANT_SERVICE_BREAK_HAND"
ESERVANTSERVICE_ESERVANT_SERVICE_BREAK_HAND_ENUM.index = 7
ESERVANTSERVICE_ESERVANT_SERVICE_BREAK_HAND_ENUM.number = 8
ESERVANTSERVICE.name = "EServantService"
ESERVANTSERVICE.full_name = ".Cmd.EServantService"
ESERVANTSERVICE.values = {
  ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_ENUM,
  ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_THREE_ENUM,
  ESERVANTSERVICE_ESERVANT_SERVICE_FINANCE_SEVEN_ENUM,
  ESERVANTSERVICE_ESERVANT_SERVICE_UPGRADE_ENUM,
  ESERVANTSERVICE_ESERVANT_SERVICE_SPECIAL_ENUM,
  ESERVANTSERVICE_ESERVANT_SERVICE_RECOMMEND_REFRESH_ENUM,
  ESERVANTSERVICE_ESERVANT_SERVICE_INVITE_HAND_ENUM,
  ESERVANTSERVICE_ESERVANT_SERVICE_BREAK_HAND_ENUM
}
ERECOMMENDSTATUS_ERECOMMEND_STATUS_MIN_ENUM.name = "ERECOMMEND_STATUS_MIN"
ERECOMMENDSTATUS_ERECOMMEND_STATUS_MIN_ENUM.index = 0
ERECOMMENDSTATUS_ERECOMMEND_STATUS_MIN_ENUM.number = 0
ERECOMMENDSTATUS_ERECOMMEND_STATUS_GO_ENUM.name = "ERECOMMEND_STATUS_GO"
ERECOMMENDSTATUS_ERECOMMEND_STATUS_GO_ENUM.index = 1
ERECOMMENDSTATUS_ERECOMMEND_STATUS_GO_ENUM.number = 1
ERECOMMENDSTATUS_ERECOMMEND_STATUS_RECEIVE_ENUM.name = "ERECOMMEND_STATUS_RECEIVE"
ERECOMMENDSTATUS_ERECOMMEND_STATUS_RECEIVE_ENUM.index = 2
ERECOMMENDSTATUS_ERECOMMEND_STATUS_RECEIVE_ENUM.number = 2
ERECOMMENDSTATUS_ERECOMMEND_STATUS_FINISH_ENUM.name = "ERECOMMEND_STATUS_FINISH"
ERECOMMENDSTATUS_ERECOMMEND_STATUS_FINISH_ENUM.index = 3
ERECOMMENDSTATUS_ERECOMMEND_STATUS_FINISH_ENUM.number = 3
ERECOMMENDSTATUS.name = "ERecommendStatus"
ERECOMMENDSTATUS.full_name = ".Cmd.ERecommendStatus"
ERECOMMENDSTATUS.values = {
  ERECOMMENDSTATUS_ERECOMMEND_STATUS_MIN_ENUM,
  ERECOMMENDSTATUS_ERECOMMEND_STATUS_GO_ENUM,
  ERECOMMENDSTATUS_ERECOMMEND_STATUS_RECEIVE_ENUM,
  ERECOMMENDSTATUS_ERECOMMEND_STATUS_FINISH_ENUM
}
EPROFRESSIONDATATYPE_ETYPEADVANCE_ENUM.name = "ETypeAdvance"
EPROFRESSIONDATATYPE_ETYPEADVANCE_ENUM.index = 0
EPROFRESSIONDATATYPE_ETYPEADVANCE_ENUM.number = 0
EPROFRESSIONDATATYPE_ETYPEBRANCH_ENUM.name = "ETypeBranch"
EPROFRESSIONDATATYPE_ETYPEBRANCH_ENUM.index = 1
EPROFRESSIONDATATYPE_ETYPEBRANCH_ENUM.number = 1
EPROFRESSIONDATATYPE_ETYPERECORD_ENUM.name = "ETypeRecord"
EPROFRESSIONDATATYPE_ETYPERECORD_ENUM.index = 2
EPROFRESSIONDATATYPE_ETYPERECORD_ENUM.number = 2
EPROFRESSIONDATATYPE.name = "EProfressionDataType"
EPROFRESSIONDATATYPE.full_name = ".Cmd.EProfressionDataType"
EPROFRESSIONDATATYPE.values = {
  EPROFRESSIONDATATYPE_ETYPEADVANCE_ENUM,
  EPROFRESSIONDATATYPE_ETYPEBRANCH_ENUM,
  EPROFRESSIONDATATYPE_ETYPERECORD_ENUM
}
ESLOTTYPE_ESLOT_DEFAULT_ENUM.name = "ESLOT_DEFAULT"
ESLOTTYPE_ESLOT_DEFAULT_ENUM.index = 0
ESLOTTYPE_ESLOT_DEFAULT_ENUM.number = 1
ESLOTTYPE_ESLOT_BUY_ENUM.name = "ESLOT_BUY"
ESLOTTYPE_ESLOT_BUY_ENUM.index = 1
ESLOTTYPE_ESLOT_BUY_ENUM.number = 2
ESLOTTYPE_ESLOT_MONTH_CARD_ENUM.name = "ESLOT_MONTH_CARD"
ESLOTTYPE_ESLOT_MONTH_CARD_ENUM.index = 2
ESLOTTYPE_ESLOT_MONTH_CARD_ENUM.number = 3
ESLOTTYPE.name = "ESlotType"
ESLOTTYPE.full_name = ".Cmd.ESlotType"
ESLOTTYPE.values = {
  ESLOTTYPE_ESLOT_DEFAULT_ENUM,
  ESLOTTYPE_ESLOT_BUY_ENUM,
  ESLOTTYPE_ESLOT_MONTH_CARD_ENUM
}
EBOOTHOPER_EBOOTHOPER_OPEN_ENUM.name = "EBOOTHOPER_OPEN"
EBOOTHOPER_EBOOTHOPER_OPEN_ENUM.index = 0
EBOOTHOPER_EBOOTHOPER_OPEN_ENUM.number = 0
EBOOTHOPER_EBOOTHOPER_CLOSE_ENUM.name = "EBOOTHOPER_CLOSE"
EBOOTHOPER_EBOOTHOPER_CLOSE_ENUM.index = 1
EBOOTHOPER_EBOOTHOPER_CLOSE_ENUM.number = 1
EBOOTHOPER_EBOOTHOPER_UPDATE_ENUM.name = "EBOOTHOPER_UPDATE"
EBOOTHOPER_EBOOTHOPER_UPDATE_ENUM.index = 2
EBOOTHOPER_EBOOTHOPER_UPDATE_ENUM.number = 2
EBOOTHOPER.name = "EBoothOper"
EBOOTHOPER.full_name = ".Cmd.EBoothOper"
EBOOTHOPER.values = {
  EBOOTHOPER_EBOOTHOPER_OPEN_ENUM,
  EBOOTHOPER_EBOOTHOPER_CLOSE_ENUM,
  EBOOTHOPER_EBOOTHOPER_UPDATE_ENUM
}
EBOOTHSIGN_EBOOTHSIGN_WHITE_ENUM.name = "EBOOTHSIGN_WHITE"
EBOOTHSIGN_EBOOTHSIGN_WHITE_ENUM.index = 0
EBOOTHSIGN_EBOOTHSIGN_WHITE_ENUM.number = 0
EBOOTHSIGN_EBOOTHSIGN_GREEN_ENUM.name = "EBOOTHSIGN_GREEN"
EBOOTHSIGN_EBOOTHSIGN_GREEN_ENUM.index = 1
EBOOTHSIGN_EBOOTHSIGN_GREEN_ENUM.number = 1
EBOOTHSIGN_EBOOTHSIGN_BLUE_ENUM.name = "EBOOTHSIGN_BLUE"
EBOOTHSIGN_EBOOTHSIGN_BLUE_ENUM.index = 2
EBOOTHSIGN_EBOOTHSIGN_BLUE_ENUM.number = 2
EBOOTHSIGN_EBOOTHSIGN_PURPLE_ENUM.name = "EBOOTHSIGN_PURPLE"
EBOOTHSIGN_EBOOTHSIGN_PURPLE_ENUM.index = 3
EBOOTHSIGN_EBOOTHSIGN_PURPLE_ENUM.number = 3
EBOOTHSIGN_EBOOTHSIGN_ORANGE_ENUM.name = "EBOOTHSIGN_ORANGE"
EBOOTHSIGN_EBOOTHSIGN_ORANGE_ENUM.index = 4
EBOOTHSIGN_EBOOTHSIGN_ORANGE_ENUM.number = 4
EBOOTHSIGN_EBOOTHSIGN_PINK_ENUM.name = "EBOOTHSIGN_PINK"
EBOOTHSIGN_EBOOTHSIGN_PINK_ENUM.index = 5
EBOOTHSIGN_EBOOTHSIGN_PINK_ENUM.number = 5
EBOOTHSIGN.name = "EBoothSign"
EBOOTHSIGN.full_name = ".Cmd.EBoothSign"
EBOOTHSIGN.values = {
  EBOOTHSIGN_EBOOTHSIGN_WHITE_ENUM,
  EBOOTHSIGN_EBOOTHSIGN_GREEN_ENUM,
  EBOOTHSIGN_EBOOTHSIGN_BLUE_ENUM,
  EBOOTHSIGN_EBOOTHSIGN_PURPLE_ENUM,
  EBOOTHSIGN_EBOOTHSIGN_ORANGE_ENUM,
  EBOOTHSIGN_EBOOTHSIGN_PINK_ENUM
}
EDRESSUPSTATUS_EDRESSUP_MIN_ENUM.name = "EDRESSUP_MIN"
EDRESSUPSTATUS_EDRESSUP_MIN_ENUM.index = 0
EDRESSUPSTATUS_EDRESSUP_MIN_ENUM.number = 0
EDRESSUPSTATUS_EDRESSUP_WAIT_ENUM.name = "EDRESSUP_WAIT"
EDRESSUPSTATUS_EDRESSUP_WAIT_ENUM.index = 1
EDRESSUPSTATUS_EDRESSUP_WAIT_ENUM.number = 1
EDRESSUPSTATUS_EDRESSUP_SHOW_ENUM.name = "EDRESSUP_SHOW"
EDRESSUPSTATUS_EDRESSUP_SHOW_ENUM.index = 2
EDRESSUPSTATUS_EDRESSUP_SHOW_ENUM.number = 2
EDRESSUPSTATUS.name = "EDressUpStatus"
EDRESSUPSTATUS.full_name = ".Cmd.EDressUpStatus"
EDRESSUPSTATUS.values = {
  EDRESSUPSTATUS_EDRESSUP_MIN_ENUM,
  EDRESSUPSTATUS_EDRESSUP_WAIT_ENUM,
  EDRESSUPSTATUS_EDRESSUP_SHOW_ENUM
}
EFUNCMAPTYPE_EFUNCMAPTYPE_POLLY_ENUM.name = "EFUNCMAPTYPE_POLLY"
EFUNCMAPTYPE_EFUNCMAPTYPE_POLLY_ENUM.index = 0
EFUNCMAPTYPE_EFUNCMAPTYPE_POLLY_ENUM.number = 1
EFUNCMAPTYPE.name = "EFuncMapType"
EFUNCMAPTYPE.full_name = ".Cmd.EFuncMapType"
EFUNCMAPTYPE.values = {
  EFUNCMAPTYPE_EFUNCMAPTYPE_POLLY_ENUM
}
EGROWTHSTATUS_EGROWTH_STATUS_MIN_ENUM.name = "EGROWTH_STATUS_MIN"
EGROWTHSTATUS_EGROWTH_STATUS_MIN_ENUM.index = 0
EGROWTHSTATUS_EGROWTH_STATUS_MIN_ENUM.number = 0
EGROWTHSTATUS_EGROWTH_STATUS_GO_ENUM.name = "EGROWTH_STATUS_GO"
EGROWTHSTATUS_EGROWTH_STATUS_GO_ENUM.index = 1
EGROWTHSTATUS_EGROWTH_STATUS_GO_ENUM.number = 1
EGROWTHSTATUS_EGROWTH_STATUS_RECEIVE_ENUM.name = "EGROWTH_STATUS_RECEIVE"
EGROWTHSTATUS_EGROWTH_STATUS_RECEIVE_ENUM.index = 2
EGROWTHSTATUS_EGROWTH_STATUS_RECEIVE_ENUM.number = 2
EGROWTHSTATUS_EGROWTH_STATUS_FINISH_ENUM.name = "EGROWTH_STATUS_FINISH"
EGROWTHSTATUS_EGROWTH_STATUS_FINISH_ENUM.index = 3
EGROWTHSTATUS_EGROWTH_STATUS_FINISH_ENUM.number = 3
EGROWTHSTATUS.name = "EGrowthStatus"
EGROWTHSTATUS.full_name = ".Cmd.EGrowthStatus"
EGROWTHSTATUS.values = {
  EGROWTHSTATUS_EGROWTH_STATUS_MIN_ENUM,
  EGROWTHSTATUS_EGROWTH_STATUS_GO_ENUM,
  EGROWTHSTATUS_EGROWTH_STATUS_RECEIVE_ENUM,
  EGROWTHSTATUS_EGROWTH_STATUS_FINISH_ENUM
}
EGROWTHTYPE_EGROWTH_TYPE_MIN_ENUM.name = "EGROWTH_TYPE_MIN"
EGROWTHTYPE_EGROWTH_TYPE_MIN_ENUM.index = 0
EGROWTHTYPE_EGROWTH_TYPE_MIN_ENUM.number = 0
EGROWTHTYPE_EGROWTH_TYPE_STEP_ENUM.name = "EGROWTH_TYPE_STEP"
EGROWTHTYPE_EGROWTH_TYPE_STEP_ENUM.index = 1
EGROWTHTYPE_EGROWTH_TYPE_STEP_ENUM.number = 1
EGROWTHTYPE_EGROWTH_TYPE_EP_ENUM.name = "EGROWTH_TYPE_EP"
EGROWTHTYPE_EGROWTH_TYPE_EP_ENUM.index = 2
EGROWTHTYPE_EGROWTH_TYPE_EP_ENUM.number = 2
EGROWTHTYPE_EGROWTH_TYPE_TIME_LIMIT_ENUM.name = "EGROWTH_TYPE_TIME_LIMIT"
EGROWTHTYPE_EGROWTH_TYPE_TIME_LIMIT_ENUM.index = 3
EGROWTHTYPE_EGROWTH_TYPE_TIME_LIMIT_ENUM.number = 3
EGROWTHTYPE.name = "EGrowthType"
EGROWTHTYPE.full_name = ".Cmd.EGrowthType"
EGROWTHTYPE.values = {
  EGROWTHTYPE_EGROWTH_TYPE_MIN_ENUM,
  EGROWTHTYPE_EGROWTH_TYPE_STEP_ENUM,
  EGROWTHTYPE_EGROWTH_TYPE_EP_ENUM,
  EGROWTHTYPE_EGROWTH_TYPE_TIME_LIMIT_ENUM
}
EMONITORBUTTON_EMONITORBUTTON_AUTO_BATTLE_BUTTON_ENUM.name = "EMONITORBUTTON_AUTO_BATTLE_BUTTON"
EMONITORBUTTON_EMONITORBUTTON_AUTO_BATTLE_BUTTON_ENUM.index = 0
EMONITORBUTTON_EMONITORBUTTON_AUTO_BATTLE_BUTTON_ENUM.number = 0
EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL1_ENUM.name = "EMONITORBUTTON_QUICK_ITEM_CELL1"
EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL1_ENUM.index = 1
EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL1_ENUM.number = 1
EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL2_ENUM.name = "EMONITORBUTTON_QUICK_ITEM_CELL2"
EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL2_ENUM.index = 2
EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL2_ENUM.number = 2
EMONITORBUTTON_EMONITORBUTTON_NEARLY_BUTTON_ENUM.name = "EMONITORBUTTON_NEARLY_BUTTON"
EMONITORBUTTON_EMONITORBUTTON_NEARLY_BUTTON_ENUM.index = 3
EMONITORBUTTON_EMONITORBUTTON_NEARLY_BUTTON_ENUM.number = 3
EMONITORBUTTON_EMONITORBUTTON_NPC_TOG_ENUM.name = "EMONITORBUTTON_NPC_TOG"
EMONITORBUTTON_EMONITORBUTTON_NPC_TOG_ENUM.index = 4
EMONITORBUTTON_EMONITORBUTTON_NPC_TOG_ENUM.number = 4
EMONITORBUTTON_EMONITORBUTTON_NEARLY_CREATURE_CELL2_ENUM.name = "EMONITORBUTTON_NEARLY_CREATURE_CELL2"
EMONITORBUTTON_EMONITORBUTTON_NEARLY_CREATURE_CELL2_ENUM.index = 5
EMONITORBUTTON_EMONITORBUTTON_NEARLY_CREATURE_CELL2_ENUM.number = 5
EMONITORBUTTON_EMONITORBUTTON_CLICK_MVP_MINI_ENUM.name = "EMONITORBUTTON_CLICK_MVP_MINI"
EMONITORBUTTON_EMONITORBUTTON_CLICK_MVP_MINI_ENUM.index = 6
EMONITORBUTTON_EMONITORBUTTON_CLICK_MVP_MINI_ENUM.number = 101
EMONITORBUTTON_EMONITORBUTTON_AUTO_CLICK_MVP_MINI_ENUM.name = "EMONITORBUTTON_AUTO_CLICK_MVP_MINI"
EMONITORBUTTON_EMONITORBUTTON_AUTO_CLICK_MVP_MINI_ENUM.index = 7
EMONITORBUTTON_EMONITORBUTTON_AUTO_CLICK_MVP_MINI_ENUM.number = 102
EMONITORBUTTON_EMONITORBUTTON_CLICK_NPC_ENUM.name = "EMONITORBUTTON_CLICK_NPC"
EMONITORBUTTON_EMONITORBUTTON_CLICK_NPC_ENUM.index = 8
EMONITORBUTTON_EMONITORBUTTON_CLICK_NPC_ENUM.number = 103
EMONITORBUTTON_EMONITORBUTTON_MAP_CLICK_NPC_ENUM.name = "EMONITORBUTTON_MAP_CLICK_NPC"
EMONITORBUTTON_EMONITORBUTTON_MAP_CLICK_NPC_ENUM.index = 9
EMONITORBUTTON_EMONITORBUTTON_MAP_CLICK_NPC_ENUM.number = 104
EMONITORBUTTON_EMONITORBUTTON_MAX_ENUM.name = "EMONITORBUTTON_MAX"
EMONITORBUTTON_EMONITORBUTTON_MAX_ENUM.index = 10
EMONITORBUTTON_EMONITORBUTTON_MAX_ENUM.number = 105
EMONITORBUTTON.name = "EMonitorButton"
EMONITORBUTTON.full_name = ".Cmd.EMonitorButton"
EMONITORBUTTON.values = {
  EMONITORBUTTON_EMONITORBUTTON_AUTO_BATTLE_BUTTON_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL1_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_QUICK_ITEM_CELL2_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_NEARLY_BUTTON_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_NPC_TOG_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_NEARLY_CREATURE_CELL2_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_CLICK_MVP_MINI_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_AUTO_CLICK_MVP_MINI_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_CLICK_NPC_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_MAP_CLICK_NPC_ENUM,
  EMONITORBUTTON_EMONITORBUTTON_MAX_ENUM
}
EREWARDSTATUS_EREWEARD_STATUS_MIN_ENUM.name = "EREWEARD_STATUS_MIN"
EREWARDSTATUS_EREWEARD_STATUS_MIN_ENUM.index = 0
EREWARDSTATUS_EREWEARD_STATUS_MIN_ENUM.number = 0
EREWARDSTATUS_EREWEARD_STATUS_CAN_GET_ENUM.name = "EREWEARD_STATUS_CAN_GET"
EREWARDSTATUS_EREWEARD_STATUS_CAN_GET_ENUM.index = 1
EREWARDSTATUS_EREWEARD_STATUS_CAN_GET_ENUM.number = 1
EREWARDSTATUS_EREWEARD_STATUS_GET_ENUM.name = "EREWEARD_STATUS_GET"
EREWARDSTATUS_EREWEARD_STATUS_GET_ENUM.index = 2
EREWARDSTATUS_EREWEARD_STATUS_GET_ENUM.number = 2
EREWARDSTATUS_EREWEARD_STATUS_MAX_ENUM.name = "EREWEARD_STATUS_MAX"
EREWARDSTATUS_EREWEARD_STATUS_MAX_ENUM.index = 3
EREWARDSTATUS_EREWEARD_STATUS_MAX_ENUM.number = 3
EREWARDSTATUS.name = "ERewardStatus"
EREWARDSTATUS.full_name = ".Cmd.ERewardStatus"
EREWARDSTATUS.values = {
  EREWARDSTATUS_EREWEARD_STATUS_MIN_ENUM,
  EREWARDSTATUS_EREWEARD_STATUS_CAN_GET_ENUM,
  EREWARDSTATUS_EREWEARD_STATUS_GET_ENUM,
  EREWARDSTATUS_EREWEARD_STATUS_MAX_ENUM
}
ERESERVATIONTYPE_ERESERVATIONTYPE_CONFIG_ENUM.name = "ERESERVATIONTYPE_CONFIG"
ERESERVATIONTYPE_ERESERVATIONTYPE_CONFIG_ENUM.index = 0
ERESERVATIONTYPE_ERESERVATIONTYPE_CONFIG_ENUM.number = 1
ERESERVATIONTYPE_ERESERVATIONTYPE_CONSOLE_ENUM.name = "ERESERVATIONTYPE_CONSOLE"
ERESERVATIONTYPE_ERESERVATIONTYPE_CONSOLE_ENUM.index = 1
ERESERVATIONTYPE_ERESERVATIONTYPE_CONSOLE_ENUM.number = 2
ERESERVATIONTYPE.name = "EReservationType"
ERESERVATIONTYPE.full_name = ".Cmd.EReservationType"
ERESERVATIONTYPE.values = {
  ERESERVATIONTYPE_ERESERVATIONTYPE_CONFIG_ENUM,
  ERESERVATIONTYPE_ERESERVATIONTYPE_CONSOLE_ENUM
}
GOCITY_CMD_FIELD.name = "cmd"
GOCITY_CMD_FIELD.full_name = ".Cmd.GoCity.cmd"
GOCITY_CMD_FIELD.number = 1
GOCITY_CMD_FIELD.index = 0
GOCITY_CMD_FIELD.label = 1
GOCITY_CMD_FIELD.has_default_value = true
GOCITY_CMD_FIELD.default_value = 9
GOCITY_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GOCITY_CMD_FIELD.type = 14
GOCITY_CMD_FIELD.cpp_type = 8
GOCITY_PARAM_FIELD.name = "param"
GOCITY_PARAM_FIELD.full_name = ".Cmd.GoCity.param"
GOCITY_PARAM_FIELD.number = 2
GOCITY_PARAM_FIELD.index = 1
GOCITY_PARAM_FIELD.label = 1
GOCITY_PARAM_FIELD.has_default_value = true
GOCITY_PARAM_FIELD.default_value = 1
GOCITY_PARAM_FIELD.enum_type = USER2PARAM
GOCITY_PARAM_FIELD.type = 14
GOCITY_PARAM_FIELD.cpp_type = 8
GOCITY_MAPID_FIELD.name = "mapid"
GOCITY_MAPID_FIELD.full_name = ".Cmd.GoCity.mapid"
GOCITY_MAPID_FIELD.number = 3
GOCITY_MAPID_FIELD.index = 2
GOCITY_MAPID_FIELD.label = 1
GOCITY_MAPID_FIELD.has_default_value = true
GOCITY_MAPID_FIELD.default_value = 0
GOCITY_MAPID_FIELD.type = 13
GOCITY_MAPID_FIELD.cpp_type = 3
GOCITY.name = "GoCity"
GOCITY.full_name = ".Cmd.GoCity"
GOCITY.nested_types = {}
GOCITY.enum_types = {}
GOCITY.fields = {
  GOCITY_CMD_FIELD,
  GOCITY_PARAM_FIELD,
  GOCITY_MAPID_FIELD
}
GOCITY.is_extendable = false
GOCITY.extensions = {}
MSGLANGPARAM_LANGUAGE_FIELD.name = "language"
MSGLANGPARAM_LANGUAGE_FIELD.full_name = ".Cmd.MsgLangParam.language"
MSGLANGPARAM_LANGUAGE_FIELD.number = 1
MSGLANGPARAM_LANGUAGE_FIELD.index = 0
MSGLANGPARAM_LANGUAGE_FIELD.label = 1
MSGLANGPARAM_LANGUAGE_FIELD.has_default_value = true
MSGLANGPARAM_LANGUAGE_FIELD.default_value = 0
MSGLANGPARAM_LANGUAGE_FIELD.type = 13
MSGLANGPARAM_LANGUAGE_FIELD.cpp_type = 3
MSGLANGPARAM_PARAM_FIELD.name = "param"
MSGLANGPARAM_PARAM_FIELD.full_name = ".Cmd.MsgLangParam.param"
MSGLANGPARAM_PARAM_FIELD.number = 2
MSGLANGPARAM_PARAM_FIELD.index = 1
MSGLANGPARAM_PARAM_FIELD.label = 1
MSGLANGPARAM_PARAM_FIELD.has_default_value = false
MSGLANGPARAM_PARAM_FIELD.default_value = ""
MSGLANGPARAM_PARAM_FIELD.type = 9
MSGLANGPARAM_PARAM_FIELD.cpp_type = 9
MSGLANGPARAM.name = "MsgLangParam"
MSGLANGPARAM.full_name = ".Cmd.MsgLangParam"
MSGLANGPARAM.nested_types = {}
MSGLANGPARAM.enum_types = {}
MSGLANGPARAM.fields = {
  MSGLANGPARAM_LANGUAGE_FIELD,
  MSGLANGPARAM_PARAM_FIELD
}
MSGLANGPARAM.is_extendable = false
MSGLANGPARAM.extensions = {}
MSGPARAM_PARAM_FIELD.name = "param"
MSGPARAM_PARAM_FIELD.full_name = ".Cmd.MsgParam.param"
MSGPARAM_PARAM_FIELD.number = 1
MSGPARAM_PARAM_FIELD.index = 0
MSGPARAM_PARAM_FIELD.label = 1
MSGPARAM_PARAM_FIELD.has_default_value = false
MSGPARAM_PARAM_FIELD.default_value = ""
MSGPARAM_PARAM_FIELD.type = 9
MSGPARAM_PARAM_FIELD.cpp_type = 9
MSGPARAM_SUBPARAMS_FIELD.name = "subparams"
MSGPARAM_SUBPARAMS_FIELD.full_name = ".Cmd.MsgParam.subparams"
MSGPARAM_SUBPARAMS_FIELD.number = 2
MSGPARAM_SUBPARAMS_FIELD.index = 1
MSGPARAM_SUBPARAMS_FIELD.label = 3
MSGPARAM_SUBPARAMS_FIELD.has_default_value = false
MSGPARAM_SUBPARAMS_FIELD.default_value = {}
MSGPARAM_SUBPARAMS_FIELD.type = 9
MSGPARAM_SUBPARAMS_FIELD.cpp_type = 9
MSGPARAM_LANGPARAMS_FIELD.name = "langparams"
MSGPARAM_LANGPARAMS_FIELD.full_name = ".Cmd.MsgParam.langparams"
MSGPARAM_LANGPARAMS_FIELD.number = 3
MSGPARAM_LANGPARAMS_FIELD.index = 2
MSGPARAM_LANGPARAMS_FIELD.label = 3
MSGPARAM_LANGPARAMS_FIELD.has_default_value = false
MSGPARAM_LANGPARAMS_FIELD.default_value = {}
MSGPARAM_LANGPARAMS_FIELD.message_type = MSGLANGPARAM
MSGPARAM_LANGPARAMS_FIELD.type = 11
MSGPARAM_LANGPARAMS_FIELD.cpp_type = 10
MSGPARAM.name = "MsgParam"
MSGPARAM.full_name = ".Cmd.MsgParam"
MSGPARAM.nested_types = {}
MSGPARAM.enum_types = {}
MSGPARAM.fields = {
  MSGPARAM_PARAM_FIELD,
  MSGPARAM_SUBPARAMS_FIELD,
  MSGPARAM_LANGPARAMS_FIELD
}
MSGPARAM.is_extendable = false
MSGPARAM.extensions = {}
SYSMSG_CMD_FIELD.name = "cmd"
SYSMSG_CMD_FIELD.full_name = ".Cmd.SysMsg.cmd"
SYSMSG_CMD_FIELD.number = 1
SYSMSG_CMD_FIELD.index = 0
SYSMSG_CMD_FIELD.label = 1
SYSMSG_CMD_FIELD.has_default_value = true
SYSMSG_CMD_FIELD.default_value = 9
SYSMSG_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYSMSG_CMD_FIELD.type = 14
SYSMSG_CMD_FIELD.cpp_type = 8
SYSMSG_PARAM_FIELD.name = "param"
SYSMSG_PARAM_FIELD.full_name = ".Cmd.SysMsg.param"
SYSMSG_PARAM_FIELD.number = 2
SYSMSG_PARAM_FIELD.index = 1
SYSMSG_PARAM_FIELD.label = 1
SYSMSG_PARAM_FIELD.has_default_value = true
SYSMSG_PARAM_FIELD.default_value = 2
SYSMSG_PARAM_FIELD.enum_type = USER2PARAM
SYSMSG_PARAM_FIELD.type = 14
SYSMSG_PARAM_FIELD.cpp_type = 8
SYSMSG_ID_FIELD.name = "id"
SYSMSG_ID_FIELD.full_name = ".Cmd.SysMsg.id"
SYSMSG_ID_FIELD.number = 3
SYSMSG_ID_FIELD.index = 2
SYSMSG_ID_FIELD.label = 1
SYSMSG_ID_FIELD.has_default_value = true
SYSMSG_ID_FIELD.default_value = 0
SYSMSG_ID_FIELD.type = 13
SYSMSG_ID_FIELD.cpp_type = 3
SYSMSG_TYPE_FIELD.name = "type"
SYSMSG_TYPE_FIELD.full_name = ".Cmd.SysMsg.type"
SYSMSG_TYPE_FIELD.number = 4
SYSMSG_TYPE_FIELD.index = 3
SYSMSG_TYPE_FIELD.label = 1
SYSMSG_TYPE_FIELD.has_default_value = true
SYSMSG_TYPE_FIELD.default_value = 0
SYSMSG_TYPE_FIELD.enum_type = EMESSAGETYPE
SYSMSG_TYPE_FIELD.type = 14
SYSMSG_TYPE_FIELD.cpp_type = 8
SYSMSG_PARAMS_FIELD.name = "params"
SYSMSG_PARAMS_FIELD.full_name = ".Cmd.SysMsg.params"
SYSMSG_PARAMS_FIELD.number = 5
SYSMSG_PARAMS_FIELD.index = 4
SYSMSG_PARAMS_FIELD.label = 3
SYSMSG_PARAMS_FIELD.has_default_value = false
SYSMSG_PARAMS_FIELD.default_value = {}
SYSMSG_PARAMS_FIELD.message_type = MSGPARAM
SYSMSG_PARAMS_FIELD.type = 11
SYSMSG_PARAMS_FIELD.cpp_type = 10
SYSMSG_ACT_FIELD.name = "act"
SYSMSG_ACT_FIELD.full_name = ".Cmd.SysMsg.act"
SYSMSG_ACT_FIELD.number = 6
SYSMSG_ACT_FIELD.index = 5
SYSMSG_ACT_FIELD.label = 1
SYSMSG_ACT_FIELD.has_default_value = true
SYSMSG_ACT_FIELD.default_value = 1
SYSMSG_ACT_FIELD.enum_type = EMESSAGEACTOPT
SYSMSG_ACT_FIELD.type = 14
SYSMSG_ACT_FIELD.cpp_type = 8
SYSMSG_DELAY_FIELD.name = "delay"
SYSMSG_DELAY_FIELD.full_name = ".Cmd.SysMsg.delay"
SYSMSG_DELAY_FIELD.number = 7
SYSMSG_DELAY_FIELD.index = 6
SYSMSG_DELAY_FIELD.label = 1
SYSMSG_DELAY_FIELD.has_default_value = true
SYSMSG_DELAY_FIELD.default_value = 0
SYSMSG_DELAY_FIELD.type = 13
SYSMSG_DELAY_FIELD.cpp_type = 3
SYSMSG.name = "SysMsg"
SYSMSG.full_name = ".Cmd.SysMsg"
SYSMSG.nested_types = {}
SYSMSG.enum_types = {}
SYSMSG.fields = {
  SYSMSG_CMD_FIELD,
  SYSMSG_PARAM_FIELD,
  SYSMSG_ID_FIELD,
  SYSMSG_TYPE_FIELD,
  SYSMSG_PARAMS_FIELD,
  SYSMSG_ACT_FIELD,
  SYSMSG_DELAY_FIELD
}
SYSMSG.is_extendable = false
SYSMSG.extensions = {}
NPCDATASYNC_CMD_FIELD.name = "cmd"
NPCDATASYNC_CMD_FIELD.full_name = ".Cmd.NpcDataSync.cmd"
NPCDATASYNC_CMD_FIELD.number = 1
NPCDATASYNC_CMD_FIELD.index = 0
NPCDATASYNC_CMD_FIELD.label = 1
NPCDATASYNC_CMD_FIELD.has_default_value = true
NPCDATASYNC_CMD_FIELD.default_value = 9
NPCDATASYNC_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NPCDATASYNC_CMD_FIELD.type = 14
NPCDATASYNC_CMD_FIELD.cpp_type = 8
NPCDATASYNC_PARAM_FIELD.name = "param"
NPCDATASYNC_PARAM_FIELD.full_name = ".Cmd.NpcDataSync.param"
NPCDATASYNC_PARAM_FIELD.number = 2
NPCDATASYNC_PARAM_FIELD.index = 1
NPCDATASYNC_PARAM_FIELD.label = 1
NPCDATASYNC_PARAM_FIELD.has_default_value = true
NPCDATASYNC_PARAM_FIELD.default_value = 3
NPCDATASYNC_PARAM_FIELD.enum_type = USER2PARAM
NPCDATASYNC_PARAM_FIELD.type = 14
NPCDATASYNC_PARAM_FIELD.cpp_type = 8
NPCDATASYNC_GUID_FIELD.name = "guid"
NPCDATASYNC_GUID_FIELD.full_name = ".Cmd.NpcDataSync.guid"
NPCDATASYNC_GUID_FIELD.number = 3
NPCDATASYNC_GUID_FIELD.index = 2
NPCDATASYNC_GUID_FIELD.label = 1
NPCDATASYNC_GUID_FIELD.has_default_value = true
NPCDATASYNC_GUID_FIELD.default_value = 0
NPCDATASYNC_GUID_FIELD.type = 4
NPCDATASYNC_GUID_FIELD.cpp_type = 4
NPCDATASYNC_ATTRS_FIELD.name = "attrs"
NPCDATASYNC_ATTRS_FIELD.full_name = ".Cmd.NpcDataSync.attrs"
NPCDATASYNC_ATTRS_FIELD.number = 4
NPCDATASYNC_ATTRS_FIELD.index = 3
NPCDATASYNC_ATTRS_FIELD.label = 3
NPCDATASYNC_ATTRS_FIELD.has_default_value = false
NPCDATASYNC_ATTRS_FIELD.default_value = {}
NPCDATASYNC_ATTRS_FIELD.message_type = SceneUser_pb.USERATTR
NPCDATASYNC_ATTRS_FIELD.type = 11
NPCDATASYNC_ATTRS_FIELD.cpp_type = 10
NPCDATASYNC_DATAS_FIELD.name = "datas"
NPCDATASYNC_DATAS_FIELD.full_name = ".Cmd.NpcDataSync.datas"
NPCDATASYNC_DATAS_FIELD.number = 5
NPCDATASYNC_DATAS_FIELD.index = 4
NPCDATASYNC_DATAS_FIELD.label = 3
NPCDATASYNC_DATAS_FIELD.has_default_value = false
NPCDATASYNC_DATAS_FIELD.default_value = {}
NPCDATASYNC_DATAS_FIELD.message_type = SceneUser_pb.USERDATA
NPCDATASYNC_DATAS_FIELD.type = 11
NPCDATASYNC_DATAS_FIELD.cpp_type = 10
NPCDATASYNC.name = "NpcDataSync"
NPCDATASYNC.full_name = ".Cmd.NpcDataSync"
NPCDATASYNC.nested_types = {}
NPCDATASYNC.enum_types = {}
NPCDATASYNC.fields = {
  NPCDATASYNC_CMD_FIELD,
  NPCDATASYNC_PARAM_FIELD,
  NPCDATASYNC_GUID_FIELD,
  NPCDATASYNC_ATTRS_FIELD,
  NPCDATASYNC_DATAS_FIELD
}
NPCDATASYNC.is_extendable = false
NPCDATASYNC.extensions = {}
USERNINESYNCCMD_CMD_FIELD.name = "cmd"
USERNINESYNCCMD_CMD_FIELD.full_name = ".Cmd.UserNineSyncCmd.cmd"
USERNINESYNCCMD_CMD_FIELD.number = 1
USERNINESYNCCMD_CMD_FIELD.index = 0
USERNINESYNCCMD_CMD_FIELD.label = 1
USERNINESYNCCMD_CMD_FIELD.has_default_value = true
USERNINESYNCCMD_CMD_FIELD.default_value = 9
USERNINESYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USERNINESYNCCMD_CMD_FIELD.type = 14
USERNINESYNCCMD_CMD_FIELD.cpp_type = 8
USERNINESYNCCMD_PARAM_FIELD.name = "param"
USERNINESYNCCMD_PARAM_FIELD.full_name = ".Cmd.UserNineSyncCmd.param"
USERNINESYNCCMD_PARAM_FIELD.number = 2
USERNINESYNCCMD_PARAM_FIELD.index = 1
USERNINESYNCCMD_PARAM_FIELD.label = 1
USERNINESYNCCMD_PARAM_FIELD.has_default_value = true
USERNINESYNCCMD_PARAM_FIELD.default_value = 4
USERNINESYNCCMD_PARAM_FIELD.enum_type = USER2PARAM
USERNINESYNCCMD_PARAM_FIELD.type = 14
USERNINESYNCCMD_PARAM_FIELD.cpp_type = 8
USERNINESYNCCMD_GUID_FIELD.name = "guid"
USERNINESYNCCMD_GUID_FIELD.full_name = ".Cmd.UserNineSyncCmd.guid"
USERNINESYNCCMD_GUID_FIELD.number = 3
USERNINESYNCCMD_GUID_FIELD.index = 2
USERNINESYNCCMD_GUID_FIELD.label = 1
USERNINESYNCCMD_GUID_FIELD.has_default_value = true
USERNINESYNCCMD_GUID_FIELD.default_value = 0
USERNINESYNCCMD_GUID_FIELD.type = 4
USERNINESYNCCMD_GUID_FIELD.cpp_type = 4
USERNINESYNCCMD_DATAS_FIELD.name = "datas"
USERNINESYNCCMD_DATAS_FIELD.full_name = ".Cmd.UserNineSyncCmd.datas"
USERNINESYNCCMD_DATAS_FIELD.number = 4
USERNINESYNCCMD_DATAS_FIELD.index = 3
USERNINESYNCCMD_DATAS_FIELD.label = 3
USERNINESYNCCMD_DATAS_FIELD.has_default_value = false
USERNINESYNCCMD_DATAS_FIELD.default_value = {}
USERNINESYNCCMD_DATAS_FIELD.message_type = SceneUser_pb.USERDATA
USERNINESYNCCMD_DATAS_FIELD.type = 11
USERNINESYNCCMD_DATAS_FIELD.cpp_type = 10
USERNINESYNCCMD_ATTRS_FIELD.name = "attrs"
USERNINESYNCCMD_ATTRS_FIELD.full_name = ".Cmd.UserNineSyncCmd.attrs"
USERNINESYNCCMD_ATTRS_FIELD.number = 5
USERNINESYNCCMD_ATTRS_FIELD.index = 4
USERNINESYNCCMD_ATTRS_FIELD.label = 3
USERNINESYNCCMD_ATTRS_FIELD.has_default_value = false
USERNINESYNCCMD_ATTRS_FIELD.default_value = {}
USERNINESYNCCMD_ATTRS_FIELD.message_type = SceneUser_pb.USERATTR
USERNINESYNCCMD_ATTRS_FIELD.type = 11
USERNINESYNCCMD_ATTRS_FIELD.cpp_type = 10
USERNINESYNCCMD.name = "UserNineSyncCmd"
USERNINESYNCCMD.full_name = ".Cmd.UserNineSyncCmd"
USERNINESYNCCMD.nested_types = {}
USERNINESYNCCMD.enum_types = {}
USERNINESYNCCMD.fields = {
  USERNINESYNCCMD_CMD_FIELD,
  USERNINESYNCCMD_PARAM_FIELD,
  USERNINESYNCCMD_GUID_FIELD,
  USERNINESYNCCMD_DATAS_FIELD,
  USERNINESYNCCMD_ATTRS_FIELD
}
USERNINESYNCCMD.is_extendable = false
USERNINESYNCCMD.extensions = {}
USERACTIONNTF_CMD_FIELD.name = "cmd"
USERACTIONNTF_CMD_FIELD.full_name = ".Cmd.UserActionNtf.cmd"
USERACTIONNTF_CMD_FIELD.number = 1
USERACTIONNTF_CMD_FIELD.index = 0
USERACTIONNTF_CMD_FIELD.label = 1
USERACTIONNTF_CMD_FIELD.has_default_value = true
USERACTIONNTF_CMD_FIELD.default_value = 9
USERACTIONNTF_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USERACTIONNTF_CMD_FIELD.type = 14
USERACTIONNTF_CMD_FIELD.cpp_type = 8
USERACTIONNTF_PARAM_FIELD.name = "param"
USERACTIONNTF_PARAM_FIELD.full_name = ".Cmd.UserActionNtf.param"
USERACTIONNTF_PARAM_FIELD.number = 2
USERACTIONNTF_PARAM_FIELD.index = 1
USERACTIONNTF_PARAM_FIELD.label = 1
USERACTIONNTF_PARAM_FIELD.has_default_value = true
USERACTIONNTF_PARAM_FIELD.default_value = 5
USERACTIONNTF_PARAM_FIELD.enum_type = USER2PARAM
USERACTIONNTF_PARAM_FIELD.type = 14
USERACTIONNTF_PARAM_FIELD.cpp_type = 8
USERACTIONNTF_CHARID_FIELD.name = "charid"
USERACTIONNTF_CHARID_FIELD.full_name = ".Cmd.UserActionNtf.charid"
USERACTIONNTF_CHARID_FIELD.number = 3
USERACTIONNTF_CHARID_FIELD.index = 2
USERACTIONNTF_CHARID_FIELD.label = 1
USERACTIONNTF_CHARID_FIELD.has_default_value = true
USERACTIONNTF_CHARID_FIELD.default_value = 0
USERACTIONNTF_CHARID_FIELD.type = 4
USERACTIONNTF_CHARID_FIELD.cpp_type = 4
USERACTIONNTF_VALUE_FIELD.name = "value"
USERACTIONNTF_VALUE_FIELD.full_name = ".Cmd.UserActionNtf.value"
USERACTIONNTF_VALUE_FIELD.number = 5
USERACTIONNTF_VALUE_FIELD.index = 3
USERACTIONNTF_VALUE_FIELD.label = 1
USERACTIONNTF_VALUE_FIELD.has_default_value = true
USERACTIONNTF_VALUE_FIELD.default_value = 0
USERACTIONNTF_VALUE_FIELD.type = 4
USERACTIONNTF_VALUE_FIELD.cpp_type = 4
USERACTIONNTF_TYPE_FIELD.name = "type"
USERACTIONNTF_TYPE_FIELD.full_name = ".Cmd.UserActionNtf.type"
USERACTIONNTF_TYPE_FIELD.number = 4
USERACTIONNTF_TYPE_FIELD.index = 4
USERACTIONNTF_TYPE_FIELD.label = 1
USERACTIONNTF_TYPE_FIELD.has_default_value = true
USERACTIONNTF_TYPE_FIELD.default_value = 0
USERACTIONNTF_TYPE_FIELD.enum_type = EUSERACTIONTYPE
USERACTIONNTF_TYPE_FIELD.type = 14
USERACTIONNTF_TYPE_FIELD.cpp_type = 8
USERACTIONNTF_DELAY_FIELD.name = "delay"
USERACTIONNTF_DELAY_FIELD.full_name = ".Cmd.UserActionNtf.delay"
USERACTIONNTF_DELAY_FIELD.number = 6
USERACTIONNTF_DELAY_FIELD.index = 5
USERACTIONNTF_DELAY_FIELD.label = 1
USERACTIONNTF_DELAY_FIELD.has_default_value = true
USERACTIONNTF_DELAY_FIELD.default_value = 0
USERACTIONNTF_DELAY_FIELD.type = 13
USERACTIONNTF_DELAY_FIELD.cpp_type = 3
USERACTIONNTF.name = "UserActionNtf"
USERACTIONNTF.full_name = ".Cmd.UserActionNtf"
USERACTIONNTF.nested_types = {}
USERACTIONNTF.enum_types = {}
USERACTIONNTF.fields = {
  USERACTIONNTF_CMD_FIELD,
  USERACTIONNTF_PARAM_FIELD,
  USERACTIONNTF_CHARID_FIELD,
  USERACTIONNTF_VALUE_FIELD,
  USERACTIONNTF_TYPE_FIELD,
  USERACTIONNTF_DELAY_FIELD
}
USERACTIONNTF.is_extendable = false
USERACTIONNTF.extensions = {}
BUFFERDATA_ID_FIELD.name = "id"
BUFFERDATA_ID_FIELD.full_name = ".Cmd.BufferData.id"
BUFFERDATA_ID_FIELD.number = 1
BUFFERDATA_ID_FIELD.index = 0
BUFFERDATA_ID_FIELD.label = 1
BUFFERDATA_ID_FIELD.has_default_value = true
BUFFERDATA_ID_FIELD.default_value = 0
BUFFERDATA_ID_FIELD.type = 13
BUFFERDATA_ID_FIELD.cpp_type = 3
BUFFERDATA_LAYER_FIELD.name = "layer"
BUFFERDATA_LAYER_FIELD.full_name = ".Cmd.BufferData.layer"
BUFFERDATA_LAYER_FIELD.number = 2
BUFFERDATA_LAYER_FIELD.index = 1
BUFFERDATA_LAYER_FIELD.label = 1
BUFFERDATA_LAYER_FIELD.has_default_value = true
BUFFERDATA_LAYER_FIELD.default_value = 0
BUFFERDATA_LAYER_FIELD.type = 13
BUFFERDATA_LAYER_FIELD.cpp_type = 3
BUFFERDATA_TIME_FIELD.name = "time"
BUFFERDATA_TIME_FIELD.full_name = ".Cmd.BufferData.time"
BUFFERDATA_TIME_FIELD.number = 3
BUFFERDATA_TIME_FIELD.index = 2
BUFFERDATA_TIME_FIELD.label = 1
BUFFERDATA_TIME_FIELD.has_default_value = true
BUFFERDATA_TIME_FIELD.default_value = 0
BUFFERDATA_TIME_FIELD.type = 4
BUFFERDATA_TIME_FIELD.cpp_type = 4
BUFFERDATA_ACTIVE_FIELD.name = "active"
BUFFERDATA_ACTIVE_FIELD.full_name = ".Cmd.BufferData.active"
BUFFERDATA_ACTIVE_FIELD.number = 4
BUFFERDATA_ACTIVE_FIELD.index = 3
BUFFERDATA_ACTIVE_FIELD.label = 1
BUFFERDATA_ACTIVE_FIELD.has_default_value = true
BUFFERDATA_ACTIVE_FIELD.default_value = true
BUFFERDATA_ACTIVE_FIELD.type = 8
BUFFERDATA_ACTIVE_FIELD.cpp_type = 7
BUFFERDATA_FROMNAME_FIELD.name = "fromname"
BUFFERDATA_FROMNAME_FIELD.full_name = ".Cmd.BufferData.fromname"
BUFFERDATA_FROMNAME_FIELD.number = 5
BUFFERDATA_FROMNAME_FIELD.index = 4
BUFFERDATA_FROMNAME_FIELD.label = 1
BUFFERDATA_FROMNAME_FIELD.has_default_value = false
BUFFERDATA_FROMNAME_FIELD.default_value = ""
BUFFERDATA_FROMNAME_FIELD.type = 9
BUFFERDATA_FROMNAME_FIELD.cpp_type = 9
BUFFERDATA_FROMID_FIELD.name = "fromid"
BUFFERDATA_FROMID_FIELD.full_name = ".Cmd.BufferData.fromid"
BUFFERDATA_FROMID_FIELD.number = 6
BUFFERDATA_FROMID_FIELD.index = 5
BUFFERDATA_FROMID_FIELD.label = 1
BUFFERDATA_FROMID_FIELD.has_default_value = true
BUFFERDATA_FROMID_FIELD.default_value = 0
BUFFERDATA_FROMID_FIELD.type = 4
BUFFERDATA_FROMID_FIELD.cpp_type = 4
BUFFERDATA_LEVEL_FIELD.name = "level"
BUFFERDATA_LEVEL_FIELD.full_name = ".Cmd.BufferData.level"
BUFFERDATA_LEVEL_FIELD.number = 7
BUFFERDATA_LEVEL_FIELD.index = 6
BUFFERDATA_LEVEL_FIELD.label = 1
BUFFERDATA_LEVEL_FIELD.has_default_value = true
BUFFERDATA_LEVEL_FIELD.default_value = 0
BUFFERDATA_LEVEL_FIELD.type = 13
BUFFERDATA_LEVEL_FIELD.cpp_type = 3
BUFFERDATA.name = "BufferData"
BUFFERDATA.full_name = ".Cmd.BufferData"
BUFFERDATA.nested_types = {}
BUFFERDATA.enum_types = {}
BUFFERDATA.fields = {
  BUFFERDATA_ID_FIELD,
  BUFFERDATA_LAYER_FIELD,
  BUFFERDATA_TIME_FIELD,
  BUFFERDATA_ACTIVE_FIELD,
  BUFFERDATA_FROMNAME_FIELD,
  BUFFERDATA_FROMID_FIELD,
  BUFFERDATA_LEVEL_FIELD
}
BUFFERDATA.is_extendable = false
BUFFERDATA.extensions = {}
USERBUFFNINESYNCCMD_CMD_FIELD.name = "cmd"
USERBUFFNINESYNCCMD_CMD_FIELD.full_name = ".Cmd.UserBuffNineSyncCmd.cmd"
USERBUFFNINESYNCCMD_CMD_FIELD.number = 1
USERBUFFNINESYNCCMD_CMD_FIELD.index = 0
USERBUFFNINESYNCCMD_CMD_FIELD.label = 1
USERBUFFNINESYNCCMD_CMD_FIELD.has_default_value = true
USERBUFFNINESYNCCMD_CMD_FIELD.default_value = 9
USERBUFFNINESYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USERBUFFNINESYNCCMD_CMD_FIELD.type = 14
USERBUFFNINESYNCCMD_CMD_FIELD.cpp_type = 8
USERBUFFNINESYNCCMD_PARAM_FIELD.name = "param"
USERBUFFNINESYNCCMD_PARAM_FIELD.full_name = ".Cmd.UserBuffNineSyncCmd.param"
USERBUFFNINESYNCCMD_PARAM_FIELD.number = 2
USERBUFFNINESYNCCMD_PARAM_FIELD.index = 1
USERBUFFNINESYNCCMD_PARAM_FIELD.label = 1
USERBUFFNINESYNCCMD_PARAM_FIELD.has_default_value = true
USERBUFFNINESYNCCMD_PARAM_FIELD.default_value = 6
USERBUFFNINESYNCCMD_PARAM_FIELD.enum_type = USER2PARAM
USERBUFFNINESYNCCMD_PARAM_FIELD.type = 14
USERBUFFNINESYNCCMD_PARAM_FIELD.cpp_type = 8
USERBUFFNINESYNCCMD_GUID_FIELD.name = "guid"
USERBUFFNINESYNCCMD_GUID_FIELD.full_name = ".Cmd.UserBuffNineSyncCmd.guid"
USERBUFFNINESYNCCMD_GUID_FIELD.number = 3
USERBUFFNINESYNCCMD_GUID_FIELD.index = 2
USERBUFFNINESYNCCMD_GUID_FIELD.label = 1
USERBUFFNINESYNCCMD_GUID_FIELD.has_default_value = true
USERBUFFNINESYNCCMD_GUID_FIELD.default_value = 0
USERBUFFNINESYNCCMD_GUID_FIELD.type = 4
USERBUFFNINESYNCCMD_GUID_FIELD.cpp_type = 4
USERBUFFNINESYNCCMD_UPDATES_FIELD.name = "updates"
USERBUFFNINESYNCCMD_UPDATES_FIELD.full_name = ".Cmd.UserBuffNineSyncCmd.updates"
USERBUFFNINESYNCCMD_UPDATES_FIELD.number = 4
USERBUFFNINESYNCCMD_UPDATES_FIELD.index = 3
USERBUFFNINESYNCCMD_UPDATES_FIELD.label = 3
USERBUFFNINESYNCCMD_UPDATES_FIELD.has_default_value = false
USERBUFFNINESYNCCMD_UPDATES_FIELD.default_value = {}
USERBUFFNINESYNCCMD_UPDATES_FIELD.message_type = BUFFERDATA
USERBUFFNINESYNCCMD_UPDATES_FIELD.type = 11
USERBUFFNINESYNCCMD_UPDATES_FIELD.cpp_type = 10
USERBUFFNINESYNCCMD_DELS_FIELD.name = "dels"
USERBUFFNINESYNCCMD_DELS_FIELD.full_name = ".Cmd.UserBuffNineSyncCmd.dels"
USERBUFFNINESYNCCMD_DELS_FIELD.number = 5
USERBUFFNINESYNCCMD_DELS_FIELD.index = 4
USERBUFFNINESYNCCMD_DELS_FIELD.label = 3
USERBUFFNINESYNCCMD_DELS_FIELD.has_default_value = false
USERBUFFNINESYNCCMD_DELS_FIELD.default_value = {}
USERBUFFNINESYNCCMD_DELS_FIELD.type = 13
USERBUFFNINESYNCCMD_DELS_FIELD.cpp_type = 3
USERBUFFNINESYNCCMD.name = "UserBuffNineSyncCmd"
USERBUFFNINESYNCCMD.full_name = ".Cmd.UserBuffNineSyncCmd"
USERBUFFNINESYNCCMD.nested_types = {}
USERBUFFNINESYNCCMD.enum_types = {}
USERBUFFNINESYNCCMD.fields = {
  USERBUFFNINESYNCCMD_CMD_FIELD,
  USERBUFFNINESYNCCMD_PARAM_FIELD,
  USERBUFFNINESYNCCMD_GUID_FIELD,
  USERBUFFNINESYNCCMD_UPDATES_FIELD,
  USERBUFFNINESYNCCMD_DELS_FIELD
}
USERBUFFNINESYNCCMD.is_extendable = false
USERBUFFNINESYNCCMD.extensions = {}
EXITPOSUSERCMD_CMD_FIELD.name = "cmd"
EXITPOSUSERCMD_CMD_FIELD.full_name = ".Cmd.ExitPosUserCmd.cmd"
EXITPOSUSERCMD_CMD_FIELD.number = 1
EXITPOSUSERCMD_CMD_FIELD.index = 0
EXITPOSUSERCMD_CMD_FIELD.label = 1
EXITPOSUSERCMD_CMD_FIELD.has_default_value = true
EXITPOSUSERCMD_CMD_FIELD.default_value = 9
EXITPOSUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EXITPOSUSERCMD_CMD_FIELD.type = 14
EXITPOSUSERCMD_CMD_FIELD.cpp_type = 8
EXITPOSUSERCMD_PARAM_FIELD.name = "param"
EXITPOSUSERCMD_PARAM_FIELD.full_name = ".Cmd.ExitPosUserCmd.param"
EXITPOSUSERCMD_PARAM_FIELD.number = 2
EXITPOSUSERCMD_PARAM_FIELD.index = 1
EXITPOSUSERCMD_PARAM_FIELD.label = 1
EXITPOSUSERCMD_PARAM_FIELD.has_default_value = true
EXITPOSUSERCMD_PARAM_FIELD.default_value = 7
EXITPOSUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
EXITPOSUSERCMD_PARAM_FIELD.type = 14
EXITPOSUSERCMD_PARAM_FIELD.cpp_type = 8
EXITPOSUSERCMD_POS_FIELD.name = "pos"
EXITPOSUSERCMD_POS_FIELD.full_name = ".Cmd.ExitPosUserCmd.pos"
EXITPOSUSERCMD_POS_FIELD.number = 3
EXITPOSUSERCMD_POS_FIELD.index = 2
EXITPOSUSERCMD_POS_FIELD.label = 1
EXITPOSUSERCMD_POS_FIELD.has_default_value = false
EXITPOSUSERCMD_POS_FIELD.default_value = nil
EXITPOSUSERCMD_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
EXITPOSUSERCMD_POS_FIELD.type = 11
EXITPOSUSERCMD_POS_FIELD.cpp_type = 10
EXITPOSUSERCMD_EXITID_FIELD.name = "exitid"
EXITPOSUSERCMD_EXITID_FIELD.full_name = ".Cmd.ExitPosUserCmd.exitid"
EXITPOSUSERCMD_EXITID_FIELD.number = 4
EXITPOSUSERCMD_EXITID_FIELD.index = 3
EXITPOSUSERCMD_EXITID_FIELD.label = 1
EXITPOSUSERCMD_EXITID_FIELD.has_default_value = false
EXITPOSUSERCMD_EXITID_FIELD.default_value = 0
EXITPOSUSERCMD_EXITID_FIELD.type = 13
EXITPOSUSERCMD_EXITID_FIELD.cpp_type = 3
EXITPOSUSERCMD_MAPID_FIELD.name = "mapid"
EXITPOSUSERCMD_MAPID_FIELD.full_name = ".Cmd.ExitPosUserCmd.mapid"
EXITPOSUSERCMD_MAPID_FIELD.number = 5
EXITPOSUSERCMD_MAPID_FIELD.index = 4
EXITPOSUSERCMD_MAPID_FIELD.label = 1
EXITPOSUSERCMD_MAPID_FIELD.has_default_value = false
EXITPOSUSERCMD_MAPID_FIELD.default_value = 0
EXITPOSUSERCMD_MAPID_FIELD.type = 13
EXITPOSUSERCMD_MAPID_FIELD.cpp_type = 3
EXITPOSUSERCMD.name = "ExitPosUserCmd"
EXITPOSUSERCMD.full_name = ".Cmd.ExitPosUserCmd"
EXITPOSUSERCMD.nested_types = {}
EXITPOSUSERCMD.enum_types = {}
EXITPOSUSERCMD.fields = {
  EXITPOSUSERCMD_CMD_FIELD,
  EXITPOSUSERCMD_PARAM_FIELD,
  EXITPOSUSERCMD_POS_FIELD,
  EXITPOSUSERCMD_EXITID_FIELD,
  EXITPOSUSERCMD_MAPID_FIELD
}
EXITPOSUSERCMD.is_extendable = false
EXITPOSUSERCMD.extensions = {}
RELIVE_CMD_FIELD.name = "cmd"
RELIVE_CMD_FIELD.full_name = ".Cmd.Relive.cmd"
RELIVE_CMD_FIELD.number = 1
RELIVE_CMD_FIELD.index = 0
RELIVE_CMD_FIELD.label = 1
RELIVE_CMD_FIELD.has_default_value = true
RELIVE_CMD_FIELD.default_value = 9
RELIVE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RELIVE_CMD_FIELD.type = 14
RELIVE_CMD_FIELD.cpp_type = 8
RELIVE_PARAM_FIELD.name = "param"
RELIVE_PARAM_FIELD.full_name = ".Cmd.Relive.param"
RELIVE_PARAM_FIELD.number = 2
RELIVE_PARAM_FIELD.index = 1
RELIVE_PARAM_FIELD.label = 1
RELIVE_PARAM_FIELD.has_default_value = true
RELIVE_PARAM_FIELD.default_value = 8
RELIVE_PARAM_FIELD.enum_type = USER2PARAM
RELIVE_PARAM_FIELD.type = 14
RELIVE_PARAM_FIELD.cpp_type = 8
RELIVE_TYPE_FIELD.name = "type"
RELIVE_TYPE_FIELD.full_name = ".Cmd.Relive.type"
RELIVE_TYPE_FIELD.number = 3
RELIVE_TYPE_FIELD.index = 2
RELIVE_TYPE_FIELD.label = 1
RELIVE_TYPE_FIELD.has_default_value = true
RELIVE_TYPE_FIELD.default_value = 0
RELIVE_TYPE_FIELD.enum_type = ERELIVETYPE
RELIVE_TYPE_FIELD.type = 14
RELIVE_TYPE_FIELD.cpp_type = 8
RELIVE.name = "Relive"
RELIVE.full_name = ".Cmd.Relive"
RELIVE.nested_types = {}
RELIVE.enum_types = {}
RELIVE.fields = {
  RELIVE_CMD_FIELD,
  RELIVE_PARAM_FIELD,
  RELIVE_TYPE_FIELD
}
RELIVE.is_extendable = false
RELIVE.extensions = {}
VARUPDATE_CMD_FIELD.name = "cmd"
VARUPDATE_CMD_FIELD.full_name = ".Cmd.VarUpdate.cmd"
VARUPDATE_CMD_FIELD.number = 1
VARUPDATE_CMD_FIELD.index = 0
VARUPDATE_CMD_FIELD.label = 1
VARUPDATE_CMD_FIELD.has_default_value = true
VARUPDATE_CMD_FIELD.default_value = 9
VARUPDATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
VARUPDATE_CMD_FIELD.type = 14
VARUPDATE_CMD_FIELD.cpp_type = 8
VARUPDATE_PARAM_FIELD.name = "param"
VARUPDATE_PARAM_FIELD.full_name = ".Cmd.VarUpdate.param"
VARUPDATE_PARAM_FIELD.number = 2
VARUPDATE_PARAM_FIELD.index = 1
VARUPDATE_PARAM_FIELD.label = 1
VARUPDATE_PARAM_FIELD.has_default_value = true
VARUPDATE_PARAM_FIELD.default_value = 9
VARUPDATE_PARAM_FIELD.enum_type = USER2PARAM
VARUPDATE_PARAM_FIELD.type = 14
VARUPDATE_PARAM_FIELD.cpp_type = 8
VARUPDATE_VARS_FIELD.name = "vars"
VARUPDATE_VARS_FIELD.full_name = ".Cmd.VarUpdate.vars"
VARUPDATE_VARS_FIELD.number = 3
VARUPDATE_VARS_FIELD.index = 2
VARUPDATE_VARS_FIELD.label = 3
VARUPDATE_VARS_FIELD.has_default_value = false
VARUPDATE_VARS_FIELD.default_value = {}
VARUPDATE_VARS_FIELD.message_type = Var_pb.VAR
VARUPDATE_VARS_FIELD.type = 11
VARUPDATE_VARS_FIELD.cpp_type = 10
VARUPDATE_ACCVARS_FIELD.name = "accvars"
VARUPDATE_ACCVARS_FIELD.full_name = ".Cmd.VarUpdate.accvars"
VARUPDATE_ACCVARS_FIELD.number = 4
VARUPDATE_ACCVARS_FIELD.index = 3
VARUPDATE_ACCVARS_FIELD.label = 3
VARUPDATE_ACCVARS_FIELD.has_default_value = false
VARUPDATE_ACCVARS_FIELD.default_value = {}
VARUPDATE_ACCVARS_FIELD.message_type = Var_pb.ACCVAR
VARUPDATE_ACCVARS_FIELD.type = 11
VARUPDATE_ACCVARS_FIELD.cpp_type = 10
VARUPDATE.name = "VarUpdate"
VARUPDATE.full_name = ".Cmd.VarUpdate"
VARUPDATE.nested_types = {}
VARUPDATE.enum_types = {}
VARUPDATE.fields = {
  VARUPDATE_CMD_FIELD,
  VARUPDATE_PARAM_FIELD,
  VARUPDATE_VARS_FIELD,
  VARUPDATE_ACCVARS_FIELD
}
VARUPDATE.is_extendable = false
VARUPDATE.extensions = {}
TALKINFO_CMD_FIELD.name = "cmd"
TALKINFO_CMD_FIELD.full_name = ".Cmd.TalkInfo.cmd"
TALKINFO_CMD_FIELD.number = 1
TALKINFO_CMD_FIELD.index = 0
TALKINFO_CMD_FIELD.label = 1
TALKINFO_CMD_FIELD.has_default_value = true
TALKINFO_CMD_FIELD.default_value = 9
TALKINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TALKINFO_CMD_FIELD.type = 14
TALKINFO_CMD_FIELD.cpp_type = 8
TALKINFO_PARAM_FIELD.name = "param"
TALKINFO_PARAM_FIELD.full_name = ".Cmd.TalkInfo.param"
TALKINFO_PARAM_FIELD.number = 2
TALKINFO_PARAM_FIELD.index = 1
TALKINFO_PARAM_FIELD.label = 1
TALKINFO_PARAM_FIELD.has_default_value = true
TALKINFO_PARAM_FIELD.default_value = 10
TALKINFO_PARAM_FIELD.enum_type = USER2PARAM
TALKINFO_PARAM_FIELD.type = 14
TALKINFO_PARAM_FIELD.cpp_type = 8
TALKINFO_GUID_FIELD.name = "guid"
TALKINFO_GUID_FIELD.full_name = ".Cmd.TalkInfo.guid"
TALKINFO_GUID_FIELD.number = 3
TALKINFO_GUID_FIELD.index = 2
TALKINFO_GUID_FIELD.label = 1
TALKINFO_GUID_FIELD.has_default_value = true
TALKINFO_GUID_FIELD.default_value = 0
TALKINFO_GUID_FIELD.type = 4
TALKINFO_GUID_FIELD.cpp_type = 4
TALKINFO_TALKID_FIELD.name = "talkid"
TALKINFO_TALKID_FIELD.full_name = ".Cmd.TalkInfo.talkid"
TALKINFO_TALKID_FIELD.number = 4
TALKINFO_TALKID_FIELD.index = 3
TALKINFO_TALKID_FIELD.label = 1
TALKINFO_TALKID_FIELD.has_default_value = false
TALKINFO_TALKID_FIELD.default_value = 0
TALKINFO_TALKID_FIELD.type = 13
TALKINFO_TALKID_FIELD.cpp_type = 3
TALKINFO_TALKMESSAGE_FIELD.name = "talkmessage"
TALKINFO_TALKMESSAGE_FIELD.full_name = ".Cmd.TalkInfo.talkmessage"
TALKINFO_TALKMESSAGE_FIELD.number = 5
TALKINFO_TALKMESSAGE_FIELD.index = 4
TALKINFO_TALKMESSAGE_FIELD.label = 1
TALKINFO_TALKMESSAGE_FIELD.has_default_value = false
TALKINFO_TALKMESSAGE_FIELD.default_value = ""
TALKINFO_TALKMESSAGE_FIELD.type = 9
TALKINFO_TALKMESSAGE_FIELD.cpp_type = 9
TALKINFO_PARAMS_FIELD.name = "params"
TALKINFO_PARAMS_FIELD.full_name = ".Cmd.TalkInfo.params"
TALKINFO_PARAMS_FIELD.number = 6
TALKINFO_PARAMS_FIELD.index = 5
TALKINFO_PARAMS_FIELD.label = 3
TALKINFO_PARAMS_FIELD.has_default_value = false
TALKINFO_PARAMS_FIELD.default_value = {}
TALKINFO_PARAMS_FIELD.message_type = MSGPARAM
TALKINFO_PARAMS_FIELD.type = 11
TALKINFO_PARAMS_FIELD.cpp_type = 10
TALKINFO.name = "TalkInfo"
TALKINFO.full_name = ".Cmd.TalkInfo"
TALKINFO.nested_types = {}
TALKINFO.enum_types = {}
TALKINFO.fields = {
  TALKINFO_CMD_FIELD,
  TALKINFO_PARAM_FIELD,
  TALKINFO_GUID_FIELD,
  TALKINFO_TALKID_FIELD,
  TALKINFO_TALKMESSAGE_FIELD,
  TALKINFO_PARAMS_FIELD
}
TALKINFO.is_extendable = false
TALKINFO.extensions = {}
SERVERTIME_CMD_FIELD.name = "cmd"
SERVERTIME_CMD_FIELD.full_name = ".Cmd.ServerTime.cmd"
SERVERTIME_CMD_FIELD.number = 1
SERVERTIME_CMD_FIELD.index = 0
SERVERTIME_CMD_FIELD.label = 1
SERVERTIME_CMD_FIELD.has_default_value = true
SERVERTIME_CMD_FIELD.default_value = 9
SERVERTIME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SERVERTIME_CMD_FIELD.type = 14
SERVERTIME_CMD_FIELD.cpp_type = 8
SERVERTIME_PARAM_FIELD.name = "param"
SERVERTIME_PARAM_FIELD.full_name = ".Cmd.ServerTime.param"
SERVERTIME_PARAM_FIELD.number = 2
SERVERTIME_PARAM_FIELD.index = 1
SERVERTIME_PARAM_FIELD.label = 1
SERVERTIME_PARAM_FIELD.has_default_value = true
SERVERTIME_PARAM_FIELD.default_value = 11
SERVERTIME_PARAM_FIELD.enum_type = USER2PARAM
SERVERTIME_PARAM_FIELD.type = 14
SERVERTIME_PARAM_FIELD.cpp_type = 8
SERVERTIME_TIME_FIELD.name = "time"
SERVERTIME_TIME_FIELD.full_name = ".Cmd.ServerTime.time"
SERVERTIME_TIME_FIELD.number = 3
SERVERTIME_TIME_FIELD.index = 2
SERVERTIME_TIME_FIELD.label = 1
SERVERTIME_TIME_FIELD.has_default_value = true
SERVERTIME_TIME_FIELD.default_value = 0
SERVERTIME_TIME_FIELD.type = 4
SERVERTIME_TIME_FIELD.cpp_type = 4
SERVERTIME.name = "ServerTime"
SERVERTIME.full_name = ".Cmd.ServerTime"
SERVERTIME.nested_types = {}
SERVERTIME.enum_types = {}
SERVERTIME.fields = {
  SERVERTIME_CMD_FIELD,
  SERVERTIME_PARAM_FIELD,
  SERVERTIME_TIME_FIELD
}
SERVERTIME.is_extendable = false
SERVERTIME.extensions = {}
EFFECTUSERCMD_CMD_FIELD.name = "cmd"
EFFECTUSERCMD_CMD_FIELD.full_name = ".Cmd.EffectUserCmd.cmd"
EFFECTUSERCMD_CMD_FIELD.number = 1
EFFECTUSERCMD_CMD_FIELD.index = 0
EFFECTUSERCMD_CMD_FIELD.label = 1
EFFECTUSERCMD_CMD_FIELD.has_default_value = true
EFFECTUSERCMD_CMD_FIELD.default_value = 9
EFFECTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EFFECTUSERCMD_CMD_FIELD.type = 14
EFFECTUSERCMD_CMD_FIELD.cpp_type = 8
EFFECTUSERCMD_PARAM_FIELD.name = "param"
EFFECTUSERCMD_PARAM_FIELD.full_name = ".Cmd.EffectUserCmd.param"
EFFECTUSERCMD_PARAM_FIELD.number = 2
EFFECTUSERCMD_PARAM_FIELD.index = 1
EFFECTUSERCMD_PARAM_FIELD.label = 1
EFFECTUSERCMD_PARAM_FIELD.has_default_value = true
EFFECTUSERCMD_PARAM_FIELD.default_value = 14
EFFECTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
EFFECTUSERCMD_PARAM_FIELD.type = 14
EFFECTUSERCMD_PARAM_FIELD.cpp_type = 8
EFFECTUSERCMD_EFFECTTYPE_FIELD.name = "effecttype"
EFFECTUSERCMD_EFFECTTYPE_FIELD.full_name = ".Cmd.EffectUserCmd.effecttype"
EFFECTUSERCMD_EFFECTTYPE_FIELD.number = 3
EFFECTUSERCMD_EFFECTTYPE_FIELD.index = 2
EFFECTUSERCMD_EFFECTTYPE_FIELD.label = 1
EFFECTUSERCMD_EFFECTTYPE_FIELD.has_default_value = true
EFFECTUSERCMD_EFFECTTYPE_FIELD.default_value = 1
EFFECTUSERCMD_EFFECTTYPE_FIELD.enum_type = EEFFECTTYPE
EFFECTUSERCMD_EFFECTTYPE_FIELD.type = 14
EFFECTUSERCMD_EFFECTTYPE_FIELD.cpp_type = 8
EFFECTUSERCMD_CHARID_FIELD.name = "charid"
EFFECTUSERCMD_CHARID_FIELD.full_name = ".Cmd.EffectUserCmd.charid"
EFFECTUSERCMD_CHARID_FIELD.number = 4
EFFECTUSERCMD_CHARID_FIELD.index = 3
EFFECTUSERCMD_CHARID_FIELD.label = 1
EFFECTUSERCMD_CHARID_FIELD.has_default_value = false
EFFECTUSERCMD_CHARID_FIELD.default_value = 0
EFFECTUSERCMD_CHARID_FIELD.type = 4
EFFECTUSERCMD_CHARID_FIELD.cpp_type = 4
EFFECTUSERCMD_EFFECTPOS_FIELD.name = "effectpos"
EFFECTUSERCMD_EFFECTPOS_FIELD.full_name = ".Cmd.EffectUserCmd.effectpos"
EFFECTUSERCMD_EFFECTPOS_FIELD.number = 5
EFFECTUSERCMD_EFFECTPOS_FIELD.index = 4
EFFECTUSERCMD_EFFECTPOS_FIELD.label = 1
EFFECTUSERCMD_EFFECTPOS_FIELD.has_default_value = false
EFFECTUSERCMD_EFFECTPOS_FIELD.default_value = 0
EFFECTUSERCMD_EFFECTPOS_FIELD.type = 13
EFFECTUSERCMD_EFFECTPOS_FIELD.cpp_type = 3
EFFECTUSERCMD_POS_FIELD.name = "pos"
EFFECTUSERCMD_POS_FIELD.full_name = ".Cmd.EffectUserCmd.pos"
EFFECTUSERCMD_POS_FIELD.number = 6
EFFECTUSERCMD_POS_FIELD.index = 5
EFFECTUSERCMD_POS_FIELD.label = 1
EFFECTUSERCMD_POS_FIELD.has_default_value = false
EFFECTUSERCMD_POS_FIELD.default_value = nil
EFFECTUSERCMD_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
EFFECTUSERCMD_POS_FIELD.type = 11
EFFECTUSERCMD_POS_FIELD.cpp_type = 10
EFFECTUSERCMD_EFFECT_FIELD.name = "effect"
EFFECTUSERCMD_EFFECT_FIELD.full_name = ".Cmd.EffectUserCmd.effect"
EFFECTUSERCMD_EFFECT_FIELD.number = 7
EFFECTUSERCMD_EFFECT_FIELD.index = 6
EFFECTUSERCMD_EFFECT_FIELD.label = 1
EFFECTUSERCMD_EFFECT_FIELD.has_default_value = false
EFFECTUSERCMD_EFFECT_FIELD.default_value = ""
EFFECTUSERCMD_EFFECT_FIELD.type = 9
EFFECTUSERCMD_EFFECT_FIELD.cpp_type = 9
EFFECTUSERCMD_MSEC_FIELD.name = "msec"
EFFECTUSERCMD_MSEC_FIELD.full_name = ".Cmd.EffectUserCmd.msec"
EFFECTUSERCMD_MSEC_FIELD.number = 8
EFFECTUSERCMD_MSEC_FIELD.index = 7
EFFECTUSERCMD_MSEC_FIELD.label = 1
EFFECTUSERCMD_MSEC_FIELD.has_default_value = true
EFFECTUSERCMD_MSEC_FIELD.default_value = 0
EFFECTUSERCMD_MSEC_FIELD.type = 13
EFFECTUSERCMD_MSEC_FIELD.cpp_type = 3
EFFECTUSERCMD_TIMES_FIELD.name = "times"
EFFECTUSERCMD_TIMES_FIELD.full_name = ".Cmd.EffectUserCmd.times"
EFFECTUSERCMD_TIMES_FIELD.number = 9
EFFECTUSERCMD_TIMES_FIELD.index = 8
EFFECTUSERCMD_TIMES_FIELD.label = 1
EFFECTUSERCMD_TIMES_FIELD.has_default_value = true
EFFECTUSERCMD_TIMES_FIELD.default_value = 1
EFFECTUSERCMD_TIMES_FIELD.type = 13
EFFECTUSERCMD_TIMES_FIELD.cpp_type = 3
EFFECTUSERCMD_INDEX_FIELD.name = "index"
EFFECTUSERCMD_INDEX_FIELD.full_name = ".Cmd.EffectUserCmd.index"
EFFECTUSERCMD_INDEX_FIELD.number = 10
EFFECTUSERCMD_INDEX_FIELD.index = 9
EFFECTUSERCMD_INDEX_FIELD.label = 1
EFFECTUSERCMD_INDEX_FIELD.has_default_value = true
EFFECTUSERCMD_INDEX_FIELD.default_value = 1
EFFECTUSERCMD_INDEX_FIELD.type = 13
EFFECTUSERCMD_INDEX_FIELD.cpp_type = 3
EFFECTUSERCMD_OPT_FIELD.name = "opt"
EFFECTUSERCMD_OPT_FIELD.full_name = ".Cmd.EffectUserCmd.opt"
EFFECTUSERCMD_OPT_FIELD.number = 11
EFFECTUSERCMD_OPT_FIELD.index = 10
EFFECTUSERCMD_OPT_FIELD.label = 1
EFFECTUSERCMD_OPT_FIELD.has_default_value = true
EFFECTUSERCMD_OPT_FIELD.default_value = 1
EFFECTUSERCMD_OPT_FIELD.enum_type = EEFFECTOPT
EFFECTUSERCMD_OPT_FIELD.type = 14
EFFECTUSERCMD_OPT_FIELD.cpp_type = 8
EFFECTUSERCMD_POSBIND_FIELD.name = "posbind"
EFFECTUSERCMD_POSBIND_FIELD.full_name = ".Cmd.EffectUserCmd.posbind"
EFFECTUSERCMD_POSBIND_FIELD.number = 12
EFFECTUSERCMD_POSBIND_FIELD.index = 11
EFFECTUSERCMD_POSBIND_FIELD.label = 1
EFFECTUSERCMD_POSBIND_FIELD.has_default_value = true
EFFECTUSERCMD_POSBIND_FIELD.default_value = false
EFFECTUSERCMD_POSBIND_FIELD.type = 8
EFFECTUSERCMD_POSBIND_FIELD.cpp_type = 7
EFFECTUSERCMD_EPBIND_FIELD.name = "epbind"
EFFECTUSERCMD_EPBIND_FIELD.full_name = ".Cmd.EffectUserCmd.epbind"
EFFECTUSERCMD_EPBIND_FIELD.number = 13
EFFECTUSERCMD_EPBIND_FIELD.index = 12
EFFECTUSERCMD_EPBIND_FIELD.label = 1
EFFECTUSERCMD_EPBIND_FIELD.has_default_value = true
EFFECTUSERCMD_EPBIND_FIELD.default_value = false
EFFECTUSERCMD_EPBIND_FIELD.type = 8
EFFECTUSERCMD_EPBIND_FIELD.cpp_type = 7
EFFECTUSERCMD_DELAY_FIELD.name = "delay"
EFFECTUSERCMD_DELAY_FIELD.full_name = ".Cmd.EffectUserCmd.delay"
EFFECTUSERCMD_DELAY_FIELD.number = 14
EFFECTUSERCMD_DELAY_FIELD.index = 13
EFFECTUSERCMD_DELAY_FIELD.label = 1
EFFECTUSERCMD_DELAY_FIELD.has_default_value = true
EFFECTUSERCMD_DELAY_FIELD.default_value = 0
EFFECTUSERCMD_DELAY_FIELD.type = 13
EFFECTUSERCMD_DELAY_FIELD.cpp_type = 3
EFFECTUSERCMD_ID_FIELD.name = "id"
EFFECTUSERCMD_ID_FIELD.full_name = ".Cmd.EffectUserCmd.id"
EFFECTUSERCMD_ID_FIELD.number = 15
EFFECTUSERCMD_ID_FIELD.index = 14
EFFECTUSERCMD_ID_FIELD.label = 1
EFFECTUSERCMD_ID_FIELD.has_default_value = true
EFFECTUSERCMD_ID_FIELD.default_value = 0
EFFECTUSERCMD_ID_FIELD.type = 4
EFFECTUSERCMD_ID_FIELD.cpp_type = 4
EFFECTUSERCMD_DIR_FIELD.name = "dir"
EFFECTUSERCMD_DIR_FIELD.full_name = ".Cmd.EffectUserCmd.dir"
EFFECTUSERCMD_DIR_FIELD.number = 16
EFFECTUSERCMD_DIR_FIELD.index = 15
EFFECTUSERCMD_DIR_FIELD.label = 1
EFFECTUSERCMD_DIR_FIELD.has_default_value = false
EFFECTUSERCMD_DIR_FIELD.default_value = 0
EFFECTUSERCMD_DIR_FIELD.type = 13
EFFECTUSERCMD_DIR_FIELD.cpp_type = 3
EFFECTUSERCMD_SKILLID_FIELD.name = "skillid"
EFFECTUSERCMD_SKILLID_FIELD.full_name = ".Cmd.EffectUserCmd.skillid"
EFFECTUSERCMD_SKILLID_FIELD.number = 17
EFFECTUSERCMD_SKILLID_FIELD.index = 16
EFFECTUSERCMD_SKILLID_FIELD.label = 1
EFFECTUSERCMD_SKILLID_FIELD.has_default_value = true
EFFECTUSERCMD_SKILLID_FIELD.default_value = 0
EFFECTUSERCMD_SKILLID_FIELD.type = 13
EFFECTUSERCMD_SKILLID_FIELD.cpp_type = 3
EFFECTUSERCMD_IGNORENAVMESH_FIELD.name = "ignorenavmesh"
EFFECTUSERCMD_IGNORENAVMESH_FIELD.full_name = ".Cmd.EffectUserCmd.ignorenavmesh"
EFFECTUSERCMD_IGNORENAVMESH_FIELD.number = 18
EFFECTUSERCMD_IGNORENAVMESH_FIELD.index = 17
EFFECTUSERCMD_IGNORENAVMESH_FIELD.label = 1
EFFECTUSERCMD_IGNORENAVMESH_FIELD.has_default_value = true
EFFECTUSERCMD_IGNORENAVMESH_FIELD.default_value = false
EFFECTUSERCMD_IGNORENAVMESH_FIELD.type = 8
EFFECTUSERCMD_IGNORENAVMESH_FIELD.cpp_type = 7
EFFECTUSERCMD.name = "EffectUserCmd"
EFFECTUSERCMD.full_name = ".Cmd.EffectUserCmd"
EFFECTUSERCMD.nested_types = {}
EFFECTUSERCMD.enum_types = {}
EFFECTUSERCMD.fields = {
  EFFECTUSERCMD_CMD_FIELD,
  EFFECTUSERCMD_PARAM_FIELD,
  EFFECTUSERCMD_EFFECTTYPE_FIELD,
  EFFECTUSERCMD_CHARID_FIELD,
  EFFECTUSERCMD_EFFECTPOS_FIELD,
  EFFECTUSERCMD_POS_FIELD,
  EFFECTUSERCMD_EFFECT_FIELD,
  EFFECTUSERCMD_MSEC_FIELD,
  EFFECTUSERCMD_TIMES_FIELD,
  EFFECTUSERCMD_INDEX_FIELD,
  EFFECTUSERCMD_OPT_FIELD,
  EFFECTUSERCMD_POSBIND_FIELD,
  EFFECTUSERCMD_EPBIND_FIELD,
  EFFECTUSERCMD_DELAY_FIELD,
  EFFECTUSERCMD_ID_FIELD,
  EFFECTUSERCMD_DIR_FIELD,
  EFFECTUSERCMD_SKILLID_FIELD,
  EFFECTUSERCMD_IGNORENAVMESH_FIELD
}
EFFECTUSERCMD.is_extendable = false
EFFECTUSERCMD.extensions = {}
MENULIST_CMD_FIELD.name = "cmd"
MENULIST_CMD_FIELD.full_name = ".Cmd.MenuList.cmd"
MENULIST_CMD_FIELD.number = 1
MENULIST_CMD_FIELD.index = 0
MENULIST_CMD_FIELD.label = 1
MENULIST_CMD_FIELD.has_default_value = true
MENULIST_CMD_FIELD.default_value = 9
MENULIST_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MENULIST_CMD_FIELD.type = 14
MENULIST_CMD_FIELD.cpp_type = 8
MENULIST_PARAM_FIELD.name = "param"
MENULIST_PARAM_FIELD.full_name = ".Cmd.MenuList.param"
MENULIST_PARAM_FIELD.number = 2
MENULIST_PARAM_FIELD.index = 1
MENULIST_PARAM_FIELD.label = 1
MENULIST_PARAM_FIELD.has_default_value = true
MENULIST_PARAM_FIELD.default_value = 15
MENULIST_PARAM_FIELD.enum_type = USER2PARAM
MENULIST_PARAM_FIELD.type = 14
MENULIST_PARAM_FIELD.cpp_type = 8
MENULIST_LIST_FIELD.name = "list"
MENULIST_LIST_FIELD.full_name = ".Cmd.MenuList.list"
MENULIST_LIST_FIELD.number = 3
MENULIST_LIST_FIELD.index = 2
MENULIST_LIST_FIELD.label = 3
MENULIST_LIST_FIELD.has_default_value = false
MENULIST_LIST_FIELD.default_value = {}
MENULIST_LIST_FIELD.type = 13
MENULIST_LIST_FIELD.cpp_type = 3
MENULIST_DELLIST_FIELD.name = "dellist"
MENULIST_DELLIST_FIELD.full_name = ".Cmd.MenuList.dellist"
MENULIST_DELLIST_FIELD.number = 4
MENULIST_DELLIST_FIELD.index = 3
MENULIST_DELLIST_FIELD.label = 3
MENULIST_DELLIST_FIELD.has_default_value = false
MENULIST_DELLIST_FIELD.default_value = {}
MENULIST_DELLIST_FIELD.type = 13
MENULIST_DELLIST_FIELD.cpp_type = 3
MENULIST.name = "MenuList"
MENULIST.full_name = ".Cmd.MenuList"
MENULIST.nested_types = {}
MENULIST.enum_types = {}
MENULIST.fields = {
  MENULIST_CMD_FIELD,
  MENULIST_PARAM_FIELD,
  MENULIST_LIST_FIELD,
  MENULIST_DELLIST_FIELD
}
MENULIST.is_extendable = false
MENULIST.extensions = {}
NEWMENU_CMD_FIELD.name = "cmd"
NEWMENU_CMD_FIELD.full_name = ".Cmd.NewMenu.cmd"
NEWMENU_CMD_FIELD.number = 1
NEWMENU_CMD_FIELD.index = 0
NEWMENU_CMD_FIELD.label = 1
NEWMENU_CMD_FIELD.has_default_value = true
NEWMENU_CMD_FIELD.default_value = 9
NEWMENU_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWMENU_CMD_FIELD.type = 14
NEWMENU_CMD_FIELD.cpp_type = 8
NEWMENU_PARAM_FIELD.name = "param"
NEWMENU_PARAM_FIELD.full_name = ".Cmd.NewMenu.param"
NEWMENU_PARAM_FIELD.number = 2
NEWMENU_PARAM_FIELD.index = 1
NEWMENU_PARAM_FIELD.label = 1
NEWMENU_PARAM_FIELD.has_default_value = true
NEWMENU_PARAM_FIELD.default_value = 16
NEWMENU_PARAM_FIELD.enum_type = USER2PARAM
NEWMENU_PARAM_FIELD.type = 14
NEWMENU_PARAM_FIELD.cpp_type = 8
NEWMENU_ANIMPLAY_FIELD.name = "animplay"
NEWMENU_ANIMPLAY_FIELD.full_name = ".Cmd.NewMenu.animplay"
NEWMENU_ANIMPLAY_FIELD.number = 3
NEWMENU_ANIMPLAY_FIELD.index = 2
NEWMENU_ANIMPLAY_FIELD.label = 1
NEWMENU_ANIMPLAY_FIELD.has_default_value = true
NEWMENU_ANIMPLAY_FIELD.default_value = true
NEWMENU_ANIMPLAY_FIELD.type = 8
NEWMENU_ANIMPLAY_FIELD.cpp_type = 7
NEWMENU_LIST_FIELD.name = "list"
NEWMENU_LIST_FIELD.full_name = ".Cmd.NewMenu.list"
NEWMENU_LIST_FIELD.number = 4
NEWMENU_LIST_FIELD.index = 3
NEWMENU_LIST_FIELD.label = 3
NEWMENU_LIST_FIELD.has_default_value = false
NEWMENU_LIST_FIELD.default_value = {}
NEWMENU_LIST_FIELD.type = 13
NEWMENU_LIST_FIELD.cpp_type = 3
NEWMENU.name = "NewMenu"
NEWMENU.full_name = ".Cmd.NewMenu"
NEWMENU.nested_types = {}
NEWMENU.enum_types = {}
NEWMENU.fields = {
  NEWMENU_CMD_FIELD,
  NEWMENU_PARAM_FIELD,
  NEWMENU_ANIMPLAY_FIELD,
  NEWMENU_LIST_FIELD
}
NEWMENU.is_extendable = false
NEWMENU.extensions = {}
TEAMINFONINE_CMD_FIELD.name = "cmd"
TEAMINFONINE_CMD_FIELD.full_name = ".Cmd.TeamInfoNine.cmd"
TEAMINFONINE_CMD_FIELD.number = 1
TEAMINFONINE_CMD_FIELD.index = 0
TEAMINFONINE_CMD_FIELD.label = 1
TEAMINFONINE_CMD_FIELD.has_default_value = true
TEAMINFONINE_CMD_FIELD.default_value = 9
TEAMINFONINE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMINFONINE_CMD_FIELD.type = 14
TEAMINFONINE_CMD_FIELD.cpp_type = 8
TEAMINFONINE_PARAM_FIELD.name = "param"
TEAMINFONINE_PARAM_FIELD.full_name = ".Cmd.TeamInfoNine.param"
TEAMINFONINE_PARAM_FIELD.number = 2
TEAMINFONINE_PARAM_FIELD.index = 1
TEAMINFONINE_PARAM_FIELD.label = 1
TEAMINFONINE_PARAM_FIELD.has_default_value = true
TEAMINFONINE_PARAM_FIELD.default_value = 17
TEAMINFONINE_PARAM_FIELD.enum_type = USER2PARAM
TEAMINFONINE_PARAM_FIELD.type = 14
TEAMINFONINE_PARAM_FIELD.cpp_type = 8
TEAMINFONINE_USERID_FIELD.name = "userid"
TEAMINFONINE_USERID_FIELD.full_name = ".Cmd.TeamInfoNine.userid"
TEAMINFONINE_USERID_FIELD.number = 3
TEAMINFONINE_USERID_FIELD.index = 2
TEAMINFONINE_USERID_FIELD.label = 1
TEAMINFONINE_USERID_FIELD.has_default_value = true
TEAMINFONINE_USERID_FIELD.default_value = 0
TEAMINFONINE_USERID_FIELD.type = 4
TEAMINFONINE_USERID_FIELD.cpp_type = 4
TEAMINFONINE_ID_FIELD.name = "id"
TEAMINFONINE_ID_FIELD.full_name = ".Cmd.TeamInfoNine.id"
TEAMINFONINE_ID_FIELD.number = 4
TEAMINFONINE_ID_FIELD.index = 3
TEAMINFONINE_ID_FIELD.label = 1
TEAMINFONINE_ID_FIELD.has_default_value = true
TEAMINFONINE_ID_FIELD.default_value = 0
TEAMINFONINE_ID_FIELD.type = 13
TEAMINFONINE_ID_FIELD.cpp_type = 3
TEAMINFONINE_NAME_FIELD.name = "name"
TEAMINFONINE_NAME_FIELD.full_name = ".Cmd.TeamInfoNine.name"
TEAMINFONINE_NAME_FIELD.number = 5
TEAMINFONINE_NAME_FIELD.index = 4
TEAMINFONINE_NAME_FIELD.label = 1
TEAMINFONINE_NAME_FIELD.has_default_value = false
TEAMINFONINE_NAME_FIELD.default_value = ""
TEAMINFONINE_NAME_FIELD.type = 9
TEAMINFONINE_NAME_FIELD.cpp_type = 9
TEAMINFONINE.name = "TeamInfoNine"
TEAMINFONINE.full_name = ".Cmd.TeamInfoNine"
TEAMINFONINE.nested_types = {}
TEAMINFONINE.enum_types = {}
TEAMINFONINE.fields = {
  TEAMINFONINE_CMD_FIELD,
  TEAMINFONINE_PARAM_FIELD,
  TEAMINFONINE_USERID_FIELD,
  TEAMINFONINE_ID_FIELD,
  TEAMINFONINE_NAME_FIELD
}
TEAMINFONINE.is_extendable = false
TEAMINFONINE.extensions = {}
USEPORTRAIT_CMD_FIELD.name = "cmd"
USEPORTRAIT_CMD_FIELD.full_name = ".Cmd.UsePortrait.cmd"
USEPORTRAIT_CMD_FIELD.number = 1
USEPORTRAIT_CMD_FIELD.index = 0
USEPORTRAIT_CMD_FIELD.label = 1
USEPORTRAIT_CMD_FIELD.has_default_value = true
USEPORTRAIT_CMD_FIELD.default_value = 9
USEPORTRAIT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USEPORTRAIT_CMD_FIELD.type = 14
USEPORTRAIT_CMD_FIELD.cpp_type = 8
USEPORTRAIT_PARAM_FIELD.name = "param"
USEPORTRAIT_PARAM_FIELD.full_name = ".Cmd.UsePortrait.param"
USEPORTRAIT_PARAM_FIELD.number = 2
USEPORTRAIT_PARAM_FIELD.index = 1
USEPORTRAIT_PARAM_FIELD.label = 1
USEPORTRAIT_PARAM_FIELD.has_default_value = true
USEPORTRAIT_PARAM_FIELD.default_value = 18
USEPORTRAIT_PARAM_FIELD.enum_type = USER2PARAM
USEPORTRAIT_PARAM_FIELD.type = 14
USEPORTRAIT_PARAM_FIELD.cpp_type = 8
USEPORTRAIT_ID_FIELD.name = "id"
USEPORTRAIT_ID_FIELD.full_name = ".Cmd.UsePortrait.id"
USEPORTRAIT_ID_FIELD.number = 3
USEPORTRAIT_ID_FIELD.index = 2
USEPORTRAIT_ID_FIELD.label = 1
USEPORTRAIT_ID_FIELD.has_default_value = true
USEPORTRAIT_ID_FIELD.default_value = 0
USEPORTRAIT_ID_FIELD.type = 13
USEPORTRAIT_ID_FIELD.cpp_type = 3
USEPORTRAIT.name = "UsePortrait"
USEPORTRAIT.full_name = ".Cmd.UsePortrait"
USEPORTRAIT.nested_types = {}
USEPORTRAIT.enum_types = {}
USEPORTRAIT.fields = {
  USEPORTRAIT_CMD_FIELD,
  USEPORTRAIT_PARAM_FIELD,
  USEPORTRAIT_ID_FIELD
}
USEPORTRAIT.is_extendable = false
USEPORTRAIT.extensions = {}
USEFRAME_CMD_FIELD.name = "cmd"
USEFRAME_CMD_FIELD.full_name = ".Cmd.UseFrame.cmd"
USEFRAME_CMD_FIELD.number = 1
USEFRAME_CMD_FIELD.index = 0
USEFRAME_CMD_FIELD.label = 1
USEFRAME_CMD_FIELD.has_default_value = true
USEFRAME_CMD_FIELD.default_value = 9
USEFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USEFRAME_CMD_FIELD.type = 14
USEFRAME_CMD_FIELD.cpp_type = 8
USEFRAME_PARAM_FIELD.name = "param"
USEFRAME_PARAM_FIELD.full_name = ".Cmd.UseFrame.param"
USEFRAME_PARAM_FIELD.number = 2
USEFRAME_PARAM_FIELD.index = 1
USEFRAME_PARAM_FIELD.label = 1
USEFRAME_PARAM_FIELD.has_default_value = true
USEFRAME_PARAM_FIELD.default_value = 19
USEFRAME_PARAM_FIELD.enum_type = USER2PARAM
USEFRAME_PARAM_FIELD.type = 14
USEFRAME_PARAM_FIELD.cpp_type = 8
USEFRAME_ID_FIELD.name = "id"
USEFRAME_ID_FIELD.full_name = ".Cmd.UseFrame.id"
USEFRAME_ID_FIELD.number = 3
USEFRAME_ID_FIELD.index = 2
USEFRAME_ID_FIELD.label = 1
USEFRAME_ID_FIELD.has_default_value = true
USEFRAME_ID_FIELD.default_value = 0
USEFRAME_ID_FIELD.type = 13
USEFRAME_ID_FIELD.cpp_type = 3
USEFRAME.name = "UseFrame"
USEFRAME.full_name = ".Cmd.UseFrame"
USEFRAME.nested_types = {}
USEFRAME.enum_types = {}
USEFRAME.fields = {
  USEFRAME_CMD_FIELD,
  USEFRAME_PARAM_FIELD,
  USEFRAME_ID_FIELD
}
USEFRAME.is_extendable = false
USEFRAME.extensions = {}
NEWPORTRAITFRAME_CMD_FIELD.name = "cmd"
NEWPORTRAITFRAME_CMD_FIELD.full_name = ".Cmd.NewPortraitFrame.cmd"
NEWPORTRAITFRAME_CMD_FIELD.number = 1
NEWPORTRAITFRAME_CMD_FIELD.index = 0
NEWPORTRAITFRAME_CMD_FIELD.label = 1
NEWPORTRAITFRAME_CMD_FIELD.has_default_value = true
NEWPORTRAITFRAME_CMD_FIELD.default_value = 9
NEWPORTRAITFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWPORTRAITFRAME_CMD_FIELD.type = 14
NEWPORTRAITFRAME_CMD_FIELD.cpp_type = 8
NEWPORTRAITFRAME_PARAM_FIELD.name = "param"
NEWPORTRAITFRAME_PARAM_FIELD.full_name = ".Cmd.NewPortraitFrame.param"
NEWPORTRAITFRAME_PARAM_FIELD.number = 2
NEWPORTRAITFRAME_PARAM_FIELD.index = 1
NEWPORTRAITFRAME_PARAM_FIELD.label = 1
NEWPORTRAITFRAME_PARAM_FIELD.has_default_value = true
NEWPORTRAITFRAME_PARAM_FIELD.default_value = 20
NEWPORTRAITFRAME_PARAM_FIELD.enum_type = USER2PARAM
NEWPORTRAITFRAME_PARAM_FIELD.type = 14
NEWPORTRAITFRAME_PARAM_FIELD.cpp_type = 8
NEWPORTRAITFRAME_PORTRAIT_FIELD.name = "portrait"
NEWPORTRAITFRAME_PORTRAIT_FIELD.full_name = ".Cmd.NewPortraitFrame.portrait"
NEWPORTRAITFRAME_PORTRAIT_FIELD.number = 3
NEWPORTRAITFRAME_PORTRAIT_FIELD.index = 2
NEWPORTRAITFRAME_PORTRAIT_FIELD.label = 3
NEWPORTRAITFRAME_PORTRAIT_FIELD.has_default_value = false
NEWPORTRAITFRAME_PORTRAIT_FIELD.default_value = {}
NEWPORTRAITFRAME_PORTRAIT_FIELD.type = 13
NEWPORTRAITFRAME_PORTRAIT_FIELD.cpp_type = 3
NEWPORTRAITFRAME_FRAME_FIELD.name = "frame"
NEWPORTRAITFRAME_FRAME_FIELD.full_name = ".Cmd.NewPortraitFrame.frame"
NEWPORTRAITFRAME_FRAME_FIELD.number = 4
NEWPORTRAITFRAME_FRAME_FIELD.index = 3
NEWPORTRAITFRAME_FRAME_FIELD.label = 3
NEWPORTRAITFRAME_FRAME_FIELD.has_default_value = false
NEWPORTRAITFRAME_FRAME_FIELD.default_value = {}
NEWPORTRAITFRAME_FRAME_FIELD.type = 13
NEWPORTRAITFRAME_FRAME_FIELD.cpp_type = 3
NEWPORTRAITFRAME.name = "NewPortraitFrame"
NEWPORTRAITFRAME.full_name = ".Cmd.NewPortraitFrame"
NEWPORTRAITFRAME.nested_types = {}
NEWPORTRAITFRAME.enum_types = {}
NEWPORTRAITFRAME.fields = {
  NEWPORTRAITFRAME_CMD_FIELD,
  NEWPORTRAITFRAME_PARAM_FIELD,
  NEWPORTRAITFRAME_PORTRAIT_FIELD,
  NEWPORTRAITFRAME_FRAME_FIELD
}
NEWPORTRAITFRAME.is_extendable = false
NEWPORTRAITFRAME.extensions = {}
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.name = "cmd"
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.full_name = ".Cmd.QueryPortraitListUserCmd.cmd"
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.number = 1
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.index = 0
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.label = 1
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.has_default_value = true
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.default_value = 9
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.type = 14
QUERYPORTRAITLISTUSERCMD_CMD_FIELD.cpp_type = 8
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.name = "param"
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.full_name = ".Cmd.QueryPortraitListUserCmd.param"
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.number = 2
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.index = 1
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.label = 1
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.has_default_value = true
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.default_value = 24
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.type = 14
QUERYPORTRAITLISTUSERCMD_PARAM_FIELD.cpp_type = 8
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.name = "portrait"
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.full_name = ".Cmd.QueryPortraitListUserCmd.portrait"
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.number = 3
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.index = 2
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.label = 3
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.has_default_value = false
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.default_value = {}
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.type = 13
QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD.cpp_type = 3
QUERYPORTRAITLISTUSERCMD.name = "QueryPortraitListUserCmd"
QUERYPORTRAITLISTUSERCMD.full_name = ".Cmd.QueryPortraitListUserCmd"
QUERYPORTRAITLISTUSERCMD.nested_types = {}
QUERYPORTRAITLISTUSERCMD.enum_types = {}
QUERYPORTRAITLISTUSERCMD.fields = {
  QUERYPORTRAITLISTUSERCMD_CMD_FIELD,
  QUERYPORTRAITLISTUSERCMD_PARAM_FIELD,
  QUERYPORTRAITLISTUSERCMD_PORTRAIT_FIELD
}
QUERYPORTRAITLISTUSERCMD.is_extendable = false
QUERYPORTRAITLISTUSERCMD.extensions = {}
USEDRESSING_CMD_FIELD.name = "cmd"
USEDRESSING_CMD_FIELD.full_name = ".Cmd.UseDressing.cmd"
USEDRESSING_CMD_FIELD.number = 1
USEDRESSING_CMD_FIELD.index = 0
USEDRESSING_CMD_FIELD.label = 1
USEDRESSING_CMD_FIELD.has_default_value = true
USEDRESSING_CMD_FIELD.default_value = 9
USEDRESSING_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USEDRESSING_CMD_FIELD.type = 14
USEDRESSING_CMD_FIELD.cpp_type = 8
USEDRESSING_PARAM_FIELD.name = "param"
USEDRESSING_PARAM_FIELD.full_name = ".Cmd.UseDressing.param"
USEDRESSING_PARAM_FIELD.number = 2
USEDRESSING_PARAM_FIELD.index = 1
USEDRESSING_PARAM_FIELD.label = 1
USEDRESSING_PARAM_FIELD.has_default_value = true
USEDRESSING_PARAM_FIELD.default_value = 25
USEDRESSING_PARAM_FIELD.enum_type = USER2PARAM
USEDRESSING_PARAM_FIELD.type = 14
USEDRESSING_PARAM_FIELD.cpp_type = 8
USEDRESSING_ID_FIELD.name = "id"
USEDRESSING_ID_FIELD.full_name = ".Cmd.UseDressing.id"
USEDRESSING_ID_FIELD.number = 3
USEDRESSING_ID_FIELD.index = 2
USEDRESSING_ID_FIELD.label = 1
USEDRESSING_ID_FIELD.has_default_value = true
USEDRESSING_ID_FIELD.default_value = 0
USEDRESSING_ID_FIELD.type = 13
USEDRESSING_ID_FIELD.cpp_type = 3
USEDRESSING_CHARID_FIELD.name = "charid"
USEDRESSING_CHARID_FIELD.full_name = ".Cmd.UseDressing.charid"
USEDRESSING_CHARID_FIELD.number = 4
USEDRESSING_CHARID_FIELD.index = 3
USEDRESSING_CHARID_FIELD.label = 1
USEDRESSING_CHARID_FIELD.has_default_value = true
USEDRESSING_CHARID_FIELD.default_value = 0
USEDRESSING_CHARID_FIELD.type = 4
USEDRESSING_CHARID_FIELD.cpp_type = 4
USEDRESSING_TYPE_FIELD.name = "type"
USEDRESSING_TYPE_FIELD.full_name = ".Cmd.UseDressing.type"
USEDRESSING_TYPE_FIELD.number = 5
USEDRESSING_TYPE_FIELD.index = 4
USEDRESSING_TYPE_FIELD.label = 1
USEDRESSING_TYPE_FIELD.has_default_value = true
USEDRESSING_TYPE_FIELD.default_value = 0
USEDRESSING_TYPE_FIELD.enum_type = EDRESSTYPE
USEDRESSING_TYPE_FIELD.type = 14
USEDRESSING_TYPE_FIELD.cpp_type = 8
USEDRESSING.name = "UseDressing"
USEDRESSING.full_name = ".Cmd.UseDressing"
USEDRESSING.nested_types = {}
USEDRESSING.enum_types = {}
USEDRESSING.fields = {
  USEDRESSING_CMD_FIELD,
  USEDRESSING_PARAM_FIELD,
  USEDRESSING_ID_FIELD,
  USEDRESSING_CHARID_FIELD,
  USEDRESSING_TYPE_FIELD
}
USEDRESSING.is_extendable = false
USEDRESSING.extensions = {}
NEWDRESSING_CMD_FIELD.name = "cmd"
NEWDRESSING_CMD_FIELD.full_name = ".Cmd.NewDressing.cmd"
NEWDRESSING_CMD_FIELD.number = 1
NEWDRESSING_CMD_FIELD.index = 0
NEWDRESSING_CMD_FIELD.label = 1
NEWDRESSING_CMD_FIELD.has_default_value = true
NEWDRESSING_CMD_FIELD.default_value = 9
NEWDRESSING_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWDRESSING_CMD_FIELD.type = 14
NEWDRESSING_CMD_FIELD.cpp_type = 8
NEWDRESSING_PARAM_FIELD.name = "param"
NEWDRESSING_PARAM_FIELD.full_name = ".Cmd.NewDressing.param"
NEWDRESSING_PARAM_FIELD.number = 2
NEWDRESSING_PARAM_FIELD.index = 1
NEWDRESSING_PARAM_FIELD.label = 1
NEWDRESSING_PARAM_FIELD.has_default_value = true
NEWDRESSING_PARAM_FIELD.default_value = 26
NEWDRESSING_PARAM_FIELD.enum_type = USER2PARAM
NEWDRESSING_PARAM_FIELD.type = 14
NEWDRESSING_PARAM_FIELD.cpp_type = 8
NEWDRESSING_TYPE_FIELD.name = "type"
NEWDRESSING_TYPE_FIELD.full_name = ".Cmd.NewDressing.type"
NEWDRESSING_TYPE_FIELD.number = 3
NEWDRESSING_TYPE_FIELD.index = 2
NEWDRESSING_TYPE_FIELD.label = 1
NEWDRESSING_TYPE_FIELD.has_default_value = true
NEWDRESSING_TYPE_FIELD.default_value = 0
NEWDRESSING_TYPE_FIELD.enum_type = EDRESSTYPE
NEWDRESSING_TYPE_FIELD.type = 14
NEWDRESSING_TYPE_FIELD.cpp_type = 8
NEWDRESSING_DRESSIDS_FIELD.name = "dressids"
NEWDRESSING_DRESSIDS_FIELD.full_name = ".Cmd.NewDressing.dressids"
NEWDRESSING_DRESSIDS_FIELD.number = 4
NEWDRESSING_DRESSIDS_FIELD.index = 3
NEWDRESSING_DRESSIDS_FIELD.label = 3
NEWDRESSING_DRESSIDS_FIELD.has_default_value = false
NEWDRESSING_DRESSIDS_FIELD.default_value = {}
NEWDRESSING_DRESSIDS_FIELD.type = 13
NEWDRESSING_DRESSIDS_FIELD.cpp_type = 3
NEWDRESSING.name = "NewDressing"
NEWDRESSING.full_name = ".Cmd.NewDressing"
NEWDRESSING.nested_types = {}
NEWDRESSING.enum_types = {}
NEWDRESSING.fields = {
  NEWDRESSING_CMD_FIELD,
  NEWDRESSING_PARAM_FIELD,
  NEWDRESSING_TYPE_FIELD,
  NEWDRESSING_DRESSIDS_FIELD
}
NEWDRESSING.is_extendable = false
NEWDRESSING.extensions = {}
DRESSINGLISTUSERCMD_CMD_FIELD.name = "cmd"
DRESSINGLISTUSERCMD_CMD_FIELD.full_name = ".Cmd.DressingListUserCmd.cmd"
DRESSINGLISTUSERCMD_CMD_FIELD.number = 1
DRESSINGLISTUSERCMD_CMD_FIELD.index = 0
DRESSINGLISTUSERCMD_CMD_FIELD.label = 1
DRESSINGLISTUSERCMD_CMD_FIELD.has_default_value = true
DRESSINGLISTUSERCMD_CMD_FIELD.default_value = 9
DRESSINGLISTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DRESSINGLISTUSERCMD_CMD_FIELD.type = 14
DRESSINGLISTUSERCMD_CMD_FIELD.cpp_type = 8
DRESSINGLISTUSERCMD_PARAM_FIELD.name = "param"
DRESSINGLISTUSERCMD_PARAM_FIELD.full_name = ".Cmd.DressingListUserCmd.param"
DRESSINGLISTUSERCMD_PARAM_FIELD.number = 2
DRESSINGLISTUSERCMD_PARAM_FIELD.index = 1
DRESSINGLISTUSERCMD_PARAM_FIELD.label = 1
DRESSINGLISTUSERCMD_PARAM_FIELD.has_default_value = true
DRESSINGLISTUSERCMD_PARAM_FIELD.default_value = 27
DRESSINGLISTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
DRESSINGLISTUSERCMD_PARAM_FIELD.type = 14
DRESSINGLISTUSERCMD_PARAM_FIELD.cpp_type = 8
DRESSINGLISTUSERCMD_TYPE_FIELD.name = "type"
DRESSINGLISTUSERCMD_TYPE_FIELD.full_name = ".Cmd.DressingListUserCmd.type"
DRESSINGLISTUSERCMD_TYPE_FIELD.number = 3
DRESSINGLISTUSERCMD_TYPE_FIELD.index = 2
DRESSINGLISTUSERCMD_TYPE_FIELD.label = 1
DRESSINGLISTUSERCMD_TYPE_FIELD.has_default_value = true
DRESSINGLISTUSERCMD_TYPE_FIELD.default_value = 0
DRESSINGLISTUSERCMD_TYPE_FIELD.enum_type = EDRESSTYPE
DRESSINGLISTUSERCMD_TYPE_FIELD.type = 14
DRESSINGLISTUSERCMD_TYPE_FIELD.cpp_type = 8
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.name = "dressids"
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.full_name = ".Cmd.DressingListUserCmd.dressids"
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.number = 4
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.index = 3
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.label = 3
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.has_default_value = false
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.default_value = {}
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.type = 13
DRESSINGLISTUSERCMD_DRESSIDS_FIELD.cpp_type = 3
DRESSINGLISTUSERCMD.name = "DressingListUserCmd"
DRESSINGLISTUSERCMD.full_name = ".Cmd.DressingListUserCmd"
DRESSINGLISTUSERCMD.nested_types = {}
DRESSINGLISTUSERCMD.enum_types = {}
DRESSINGLISTUSERCMD.fields = {
  DRESSINGLISTUSERCMD_CMD_FIELD,
  DRESSINGLISTUSERCMD_PARAM_FIELD,
  DRESSINGLISTUSERCMD_TYPE_FIELD,
  DRESSINGLISTUSERCMD_DRESSIDS_FIELD
}
DRESSINGLISTUSERCMD.is_extendable = false
DRESSINGLISTUSERCMD.extensions = {}
ADDATTRPOINT_CMD_FIELD.name = "cmd"
ADDATTRPOINT_CMD_FIELD.full_name = ".Cmd.AddAttrPoint.cmd"
ADDATTRPOINT_CMD_FIELD.number = 1
ADDATTRPOINT_CMD_FIELD.index = 0
ADDATTRPOINT_CMD_FIELD.label = 1
ADDATTRPOINT_CMD_FIELD.has_default_value = true
ADDATTRPOINT_CMD_FIELD.default_value = 9
ADDATTRPOINT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ADDATTRPOINT_CMD_FIELD.type = 14
ADDATTRPOINT_CMD_FIELD.cpp_type = 8
ADDATTRPOINT_PARAM_FIELD.name = "param"
ADDATTRPOINT_PARAM_FIELD.full_name = ".Cmd.AddAttrPoint.param"
ADDATTRPOINT_PARAM_FIELD.number = 2
ADDATTRPOINT_PARAM_FIELD.index = 1
ADDATTRPOINT_PARAM_FIELD.label = 1
ADDATTRPOINT_PARAM_FIELD.has_default_value = true
ADDATTRPOINT_PARAM_FIELD.default_value = 21
ADDATTRPOINT_PARAM_FIELD.enum_type = USER2PARAM
ADDATTRPOINT_PARAM_FIELD.type = 14
ADDATTRPOINT_PARAM_FIELD.cpp_type = 8
ADDATTRPOINT_TYPE_FIELD.name = "type"
ADDATTRPOINT_TYPE_FIELD.full_name = ".Cmd.AddAttrPoint.type"
ADDATTRPOINT_TYPE_FIELD.number = 3
ADDATTRPOINT_TYPE_FIELD.index = 2
ADDATTRPOINT_TYPE_FIELD.label = 1
ADDATTRPOINT_TYPE_FIELD.has_default_value = true
ADDATTRPOINT_TYPE_FIELD.default_value = 1
ADDATTRPOINT_TYPE_FIELD.enum_type = POINTTYPE
ADDATTRPOINT_TYPE_FIELD.type = 14
ADDATTRPOINT_TYPE_FIELD.cpp_type = 8
ADDATTRPOINT_STRPOINT_FIELD.name = "strpoint"
ADDATTRPOINT_STRPOINT_FIELD.full_name = ".Cmd.AddAttrPoint.strpoint"
ADDATTRPOINT_STRPOINT_FIELD.number = 4
ADDATTRPOINT_STRPOINT_FIELD.index = 3
ADDATTRPOINT_STRPOINT_FIELD.label = 1
ADDATTRPOINT_STRPOINT_FIELD.has_default_value = true
ADDATTRPOINT_STRPOINT_FIELD.default_value = 0
ADDATTRPOINT_STRPOINT_FIELD.type = 13
ADDATTRPOINT_STRPOINT_FIELD.cpp_type = 3
ADDATTRPOINT_INTPOINT_FIELD.name = "intpoint"
ADDATTRPOINT_INTPOINT_FIELD.full_name = ".Cmd.AddAttrPoint.intpoint"
ADDATTRPOINT_INTPOINT_FIELD.number = 5
ADDATTRPOINT_INTPOINT_FIELD.index = 4
ADDATTRPOINT_INTPOINT_FIELD.label = 1
ADDATTRPOINT_INTPOINT_FIELD.has_default_value = true
ADDATTRPOINT_INTPOINT_FIELD.default_value = 0
ADDATTRPOINT_INTPOINT_FIELD.type = 13
ADDATTRPOINT_INTPOINT_FIELD.cpp_type = 3
ADDATTRPOINT_AGIPOINT_FIELD.name = "agipoint"
ADDATTRPOINT_AGIPOINT_FIELD.full_name = ".Cmd.AddAttrPoint.agipoint"
ADDATTRPOINT_AGIPOINT_FIELD.number = 6
ADDATTRPOINT_AGIPOINT_FIELD.index = 5
ADDATTRPOINT_AGIPOINT_FIELD.label = 1
ADDATTRPOINT_AGIPOINT_FIELD.has_default_value = true
ADDATTRPOINT_AGIPOINT_FIELD.default_value = 0
ADDATTRPOINT_AGIPOINT_FIELD.type = 13
ADDATTRPOINT_AGIPOINT_FIELD.cpp_type = 3
ADDATTRPOINT_DEXPOINT_FIELD.name = "dexpoint"
ADDATTRPOINT_DEXPOINT_FIELD.full_name = ".Cmd.AddAttrPoint.dexpoint"
ADDATTRPOINT_DEXPOINT_FIELD.number = 7
ADDATTRPOINT_DEXPOINT_FIELD.index = 6
ADDATTRPOINT_DEXPOINT_FIELD.label = 1
ADDATTRPOINT_DEXPOINT_FIELD.has_default_value = true
ADDATTRPOINT_DEXPOINT_FIELD.default_value = 0
ADDATTRPOINT_DEXPOINT_FIELD.type = 13
ADDATTRPOINT_DEXPOINT_FIELD.cpp_type = 3
ADDATTRPOINT_VITPOINT_FIELD.name = "vitpoint"
ADDATTRPOINT_VITPOINT_FIELD.full_name = ".Cmd.AddAttrPoint.vitpoint"
ADDATTRPOINT_VITPOINT_FIELD.number = 8
ADDATTRPOINT_VITPOINT_FIELD.index = 7
ADDATTRPOINT_VITPOINT_FIELD.label = 1
ADDATTRPOINT_VITPOINT_FIELD.has_default_value = true
ADDATTRPOINT_VITPOINT_FIELD.default_value = 0
ADDATTRPOINT_VITPOINT_FIELD.type = 13
ADDATTRPOINT_VITPOINT_FIELD.cpp_type = 3
ADDATTRPOINT_LUKPOINT_FIELD.name = "lukpoint"
ADDATTRPOINT_LUKPOINT_FIELD.full_name = ".Cmd.AddAttrPoint.lukpoint"
ADDATTRPOINT_LUKPOINT_FIELD.number = 9
ADDATTRPOINT_LUKPOINT_FIELD.index = 8
ADDATTRPOINT_LUKPOINT_FIELD.label = 1
ADDATTRPOINT_LUKPOINT_FIELD.has_default_value = true
ADDATTRPOINT_LUKPOINT_FIELD.default_value = 0
ADDATTRPOINT_LUKPOINT_FIELD.type = 13
ADDATTRPOINT_LUKPOINT_FIELD.cpp_type = 3
ADDATTRPOINT.name = "AddAttrPoint"
ADDATTRPOINT.full_name = ".Cmd.AddAttrPoint"
ADDATTRPOINT.nested_types = {}
ADDATTRPOINT.enum_types = {}
ADDATTRPOINT.fields = {
  ADDATTRPOINT_CMD_FIELD,
  ADDATTRPOINT_PARAM_FIELD,
  ADDATTRPOINT_TYPE_FIELD,
  ADDATTRPOINT_STRPOINT_FIELD,
  ADDATTRPOINT_INTPOINT_FIELD,
  ADDATTRPOINT_AGIPOINT_FIELD,
  ADDATTRPOINT_DEXPOINT_FIELD,
  ADDATTRPOINT_VITPOINT_FIELD,
  ADDATTRPOINT_LUKPOINT_FIELD
}
ADDATTRPOINT.is_extendable = false
ADDATTRPOINT.extensions = {}
SHOPGOTITEM_ID_FIELD.name = "id"
SHOPGOTITEM_ID_FIELD.full_name = ".Cmd.ShopGotItem.id"
SHOPGOTITEM_ID_FIELD.number = 1
SHOPGOTITEM_ID_FIELD.index = 0
SHOPGOTITEM_ID_FIELD.label = 1
SHOPGOTITEM_ID_FIELD.has_default_value = true
SHOPGOTITEM_ID_FIELD.default_value = 0
SHOPGOTITEM_ID_FIELD.type = 13
SHOPGOTITEM_ID_FIELD.cpp_type = 3
SHOPGOTITEM_COUNT_FIELD.name = "count"
SHOPGOTITEM_COUNT_FIELD.full_name = ".Cmd.ShopGotItem.count"
SHOPGOTITEM_COUNT_FIELD.number = 2
SHOPGOTITEM_COUNT_FIELD.index = 1
SHOPGOTITEM_COUNT_FIELD.label = 1
SHOPGOTITEM_COUNT_FIELD.has_default_value = true
SHOPGOTITEM_COUNT_FIELD.default_value = 0
SHOPGOTITEM_COUNT_FIELD.type = 13
SHOPGOTITEM_COUNT_FIELD.cpp_type = 3
SHOPGOTITEM.name = "ShopGotItem"
SHOPGOTITEM.full_name = ".Cmd.ShopGotItem"
SHOPGOTITEM.nested_types = {}
SHOPGOTITEM.enum_types = {}
SHOPGOTITEM.fields = {
  SHOPGOTITEM_ID_FIELD,
  SHOPGOTITEM_COUNT_FIELD
}
SHOPGOTITEM.is_extendable = false
SHOPGOTITEM.extensions = {}
QUERYSHOPGOTITEM_CMD_FIELD.name = "cmd"
QUERYSHOPGOTITEM_CMD_FIELD.full_name = ".Cmd.QueryShopGotItem.cmd"
QUERYSHOPGOTITEM_CMD_FIELD.number = 1
QUERYSHOPGOTITEM_CMD_FIELD.index = 0
QUERYSHOPGOTITEM_CMD_FIELD.label = 1
QUERYSHOPGOTITEM_CMD_FIELD.has_default_value = true
QUERYSHOPGOTITEM_CMD_FIELD.default_value = 9
QUERYSHOPGOTITEM_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYSHOPGOTITEM_CMD_FIELD.type = 14
QUERYSHOPGOTITEM_CMD_FIELD.cpp_type = 8
QUERYSHOPGOTITEM_PARAM_FIELD.name = "param"
QUERYSHOPGOTITEM_PARAM_FIELD.full_name = ".Cmd.QueryShopGotItem.param"
QUERYSHOPGOTITEM_PARAM_FIELD.number = 2
QUERYSHOPGOTITEM_PARAM_FIELD.index = 1
QUERYSHOPGOTITEM_PARAM_FIELD.label = 1
QUERYSHOPGOTITEM_PARAM_FIELD.has_default_value = true
QUERYSHOPGOTITEM_PARAM_FIELD.default_value = 22
QUERYSHOPGOTITEM_PARAM_FIELD.enum_type = USER2PARAM
QUERYSHOPGOTITEM_PARAM_FIELD.type = 14
QUERYSHOPGOTITEM_PARAM_FIELD.cpp_type = 8
QUERYSHOPGOTITEM_ITEMS_FIELD.name = "items"
QUERYSHOPGOTITEM_ITEMS_FIELD.full_name = ".Cmd.QueryShopGotItem.items"
QUERYSHOPGOTITEM_ITEMS_FIELD.number = 3
QUERYSHOPGOTITEM_ITEMS_FIELD.index = 2
QUERYSHOPGOTITEM_ITEMS_FIELD.label = 3
QUERYSHOPGOTITEM_ITEMS_FIELD.has_default_value = false
QUERYSHOPGOTITEM_ITEMS_FIELD.default_value = {}
QUERYSHOPGOTITEM_ITEMS_FIELD.message_type = SHOPGOTITEM
QUERYSHOPGOTITEM_ITEMS_FIELD.type = 11
QUERYSHOPGOTITEM_ITEMS_FIELD.cpp_type = 10
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.name = "discountitems"
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.full_name = ".Cmd.QueryShopGotItem.discountitems"
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.number = 4
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.index = 3
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.label = 3
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.has_default_value = false
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.default_value = {}
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.message_type = SHOPGOTITEM
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.type = 11
QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD.cpp_type = 10
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.name = "limititems"
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.full_name = ".Cmd.QueryShopGotItem.limititems"
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.number = 5
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.index = 4
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.label = 3
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.has_default_value = false
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.default_value = {}
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.message_type = SHOPGOTITEM
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.type = 11
QUERYSHOPGOTITEM_LIMITITEMS_FIELD.cpp_type = 10
QUERYSHOPGOTITEM.name = "QueryShopGotItem"
QUERYSHOPGOTITEM.full_name = ".Cmd.QueryShopGotItem"
QUERYSHOPGOTITEM.nested_types = {}
QUERYSHOPGOTITEM.enum_types = {}
QUERYSHOPGOTITEM.fields = {
  QUERYSHOPGOTITEM_CMD_FIELD,
  QUERYSHOPGOTITEM_PARAM_FIELD,
  QUERYSHOPGOTITEM_ITEMS_FIELD,
  QUERYSHOPGOTITEM_DISCOUNTITEMS_FIELD,
  QUERYSHOPGOTITEM_LIMITITEMS_FIELD
}
QUERYSHOPGOTITEM.is_extendable = false
QUERYSHOPGOTITEM.extensions = {}
UPDATESHOPGOTITEM_CMD_FIELD.name = "cmd"
UPDATESHOPGOTITEM_CMD_FIELD.full_name = ".Cmd.UpdateShopGotItem.cmd"
UPDATESHOPGOTITEM_CMD_FIELD.number = 1
UPDATESHOPGOTITEM_CMD_FIELD.index = 0
UPDATESHOPGOTITEM_CMD_FIELD.label = 1
UPDATESHOPGOTITEM_CMD_FIELD.has_default_value = true
UPDATESHOPGOTITEM_CMD_FIELD.default_value = 9
UPDATESHOPGOTITEM_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATESHOPGOTITEM_CMD_FIELD.type = 14
UPDATESHOPGOTITEM_CMD_FIELD.cpp_type = 8
UPDATESHOPGOTITEM_PARAM_FIELD.name = "param"
UPDATESHOPGOTITEM_PARAM_FIELD.full_name = ".Cmd.UpdateShopGotItem.param"
UPDATESHOPGOTITEM_PARAM_FIELD.number = 2
UPDATESHOPGOTITEM_PARAM_FIELD.index = 1
UPDATESHOPGOTITEM_PARAM_FIELD.label = 1
UPDATESHOPGOTITEM_PARAM_FIELD.has_default_value = true
UPDATESHOPGOTITEM_PARAM_FIELD.default_value = 23
UPDATESHOPGOTITEM_PARAM_FIELD.enum_type = USER2PARAM
UPDATESHOPGOTITEM_PARAM_FIELD.type = 14
UPDATESHOPGOTITEM_PARAM_FIELD.cpp_type = 8
UPDATESHOPGOTITEM_ITEM_FIELD.name = "item"
UPDATESHOPGOTITEM_ITEM_FIELD.full_name = ".Cmd.UpdateShopGotItem.item"
UPDATESHOPGOTITEM_ITEM_FIELD.number = 3
UPDATESHOPGOTITEM_ITEM_FIELD.index = 2
UPDATESHOPGOTITEM_ITEM_FIELD.label = 1
UPDATESHOPGOTITEM_ITEM_FIELD.has_default_value = false
UPDATESHOPGOTITEM_ITEM_FIELD.default_value = nil
UPDATESHOPGOTITEM_ITEM_FIELD.message_type = SHOPGOTITEM
UPDATESHOPGOTITEM_ITEM_FIELD.type = 11
UPDATESHOPGOTITEM_ITEM_FIELD.cpp_type = 10
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.name = "discountitem"
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.full_name = ".Cmd.UpdateShopGotItem.discountitem"
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.number = 4
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.index = 3
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.label = 1
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.has_default_value = false
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.default_value = nil
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.message_type = SHOPGOTITEM
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.type = 11
UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD.cpp_type = 10
UPDATESHOPGOTITEM_LIMITITEM_FIELD.name = "limititem"
UPDATESHOPGOTITEM_LIMITITEM_FIELD.full_name = ".Cmd.UpdateShopGotItem.limititem"
UPDATESHOPGOTITEM_LIMITITEM_FIELD.number = 5
UPDATESHOPGOTITEM_LIMITITEM_FIELD.index = 4
UPDATESHOPGOTITEM_LIMITITEM_FIELD.label = 1
UPDATESHOPGOTITEM_LIMITITEM_FIELD.has_default_value = false
UPDATESHOPGOTITEM_LIMITITEM_FIELD.default_value = nil
UPDATESHOPGOTITEM_LIMITITEM_FIELD.message_type = SHOPGOTITEM
UPDATESHOPGOTITEM_LIMITITEM_FIELD.type = 11
UPDATESHOPGOTITEM_LIMITITEM_FIELD.cpp_type = 10
UPDATESHOPGOTITEM.name = "UpdateShopGotItem"
UPDATESHOPGOTITEM.full_name = ".Cmd.UpdateShopGotItem"
UPDATESHOPGOTITEM.nested_types = {}
UPDATESHOPGOTITEM.enum_types = {}
UPDATESHOPGOTITEM.fields = {
  UPDATESHOPGOTITEM_CMD_FIELD,
  UPDATESHOPGOTITEM_PARAM_FIELD,
  UPDATESHOPGOTITEM_ITEM_FIELD,
  UPDATESHOPGOTITEM_DISCOUNTITEM_FIELD,
  UPDATESHOPGOTITEM_LIMITITEM_FIELD
}
UPDATESHOPGOTITEM.is_extendable = false
UPDATESHOPGOTITEM.extensions = {}
OPENUI_CMD_FIELD.name = "cmd"
OPENUI_CMD_FIELD.full_name = ".Cmd.OpenUI.cmd"
OPENUI_CMD_FIELD.number = 1
OPENUI_CMD_FIELD.index = 0
OPENUI_CMD_FIELD.label = 1
OPENUI_CMD_FIELD.has_default_value = true
OPENUI_CMD_FIELD.default_value = 9
OPENUI_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OPENUI_CMD_FIELD.type = 14
OPENUI_CMD_FIELD.cpp_type = 8
OPENUI_PARAM_FIELD.name = "param"
OPENUI_PARAM_FIELD.full_name = ".Cmd.OpenUI.param"
OPENUI_PARAM_FIELD.number = 2
OPENUI_PARAM_FIELD.index = 1
OPENUI_PARAM_FIELD.label = 1
OPENUI_PARAM_FIELD.has_default_value = true
OPENUI_PARAM_FIELD.default_value = 29
OPENUI_PARAM_FIELD.enum_type = USER2PARAM
OPENUI_PARAM_FIELD.type = 14
OPENUI_PARAM_FIELD.cpp_type = 8
OPENUI_ID_FIELD.name = "id"
OPENUI_ID_FIELD.full_name = ".Cmd.OpenUI.id"
OPENUI_ID_FIELD.number = 3
OPENUI_ID_FIELD.index = 2
OPENUI_ID_FIELD.label = 1
OPENUI_ID_FIELD.has_default_value = true
OPENUI_ID_FIELD.default_value = 0
OPENUI_ID_FIELD.type = 13
OPENUI_ID_FIELD.cpp_type = 3
OPENUI_UI_FIELD.name = "ui"
OPENUI_UI_FIELD.full_name = ".Cmd.OpenUI.ui"
OPENUI_UI_FIELD.number = 4
OPENUI_UI_FIELD.index = 3
OPENUI_UI_FIELD.label = 1
OPENUI_UI_FIELD.has_default_value = true
OPENUI_UI_FIELD.default_value = 0
OPENUI_UI_FIELD.type = 13
OPENUI_UI_FIELD.cpp_type = 3
OPENUI.name = "OpenUI"
OPENUI.full_name = ".Cmd.OpenUI"
OPENUI.nested_types = {}
OPENUI.enum_types = {}
OPENUI.fields = {
  OPENUI_CMD_FIELD,
  OPENUI_PARAM_FIELD,
  OPENUI_ID_FIELD,
  OPENUI_UI_FIELD
}
OPENUI.is_extendable = false
OPENUI.extensions = {}
DBGSYSMSG_CMD_FIELD.name = "cmd"
DBGSYSMSG_CMD_FIELD.full_name = ".Cmd.DbgSysMsg.cmd"
DBGSYSMSG_CMD_FIELD.number = 1
DBGSYSMSG_CMD_FIELD.index = 0
DBGSYSMSG_CMD_FIELD.label = 1
DBGSYSMSG_CMD_FIELD.has_default_value = true
DBGSYSMSG_CMD_FIELD.default_value = 9
DBGSYSMSG_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DBGSYSMSG_CMD_FIELD.type = 14
DBGSYSMSG_CMD_FIELD.cpp_type = 8
DBGSYSMSG_PARAM_FIELD.name = "param"
DBGSYSMSG_PARAM_FIELD.full_name = ".Cmd.DbgSysMsg.param"
DBGSYSMSG_PARAM_FIELD.number = 2
DBGSYSMSG_PARAM_FIELD.index = 1
DBGSYSMSG_PARAM_FIELD.label = 1
DBGSYSMSG_PARAM_FIELD.has_default_value = true
DBGSYSMSG_PARAM_FIELD.default_value = 30
DBGSYSMSG_PARAM_FIELD.enum_type = USER2PARAM
DBGSYSMSG_PARAM_FIELD.type = 14
DBGSYSMSG_PARAM_FIELD.cpp_type = 8
DBGSYSMSG_TYPE_FIELD.name = "type"
DBGSYSMSG_TYPE_FIELD.full_name = ".Cmd.DbgSysMsg.type"
DBGSYSMSG_TYPE_FIELD.number = 3
DBGSYSMSG_TYPE_FIELD.index = 2
DBGSYSMSG_TYPE_FIELD.label = 2
DBGSYSMSG_TYPE_FIELD.has_default_value = true
DBGSYSMSG_TYPE_FIELD.default_value = 0
DBGSYSMSG_TYPE_FIELD.enum_type = EDBGMSGTYPE
DBGSYSMSG_TYPE_FIELD.type = 14
DBGSYSMSG_TYPE_FIELD.cpp_type = 8
DBGSYSMSG_CONTENT_FIELD.name = "content"
DBGSYSMSG_CONTENT_FIELD.full_name = ".Cmd.DbgSysMsg.content"
DBGSYSMSG_CONTENT_FIELD.number = 4
DBGSYSMSG_CONTENT_FIELD.index = 3
DBGSYSMSG_CONTENT_FIELD.label = 2
DBGSYSMSG_CONTENT_FIELD.has_default_value = false
DBGSYSMSG_CONTENT_FIELD.default_value = ""
DBGSYSMSG_CONTENT_FIELD.type = 9
DBGSYSMSG_CONTENT_FIELD.cpp_type = 9
DBGSYSMSG.name = "DbgSysMsg"
DBGSYSMSG.full_name = ".Cmd.DbgSysMsg"
DBGSYSMSG.nested_types = {}
DBGSYSMSG.enum_types = {}
DBGSYSMSG.fields = {
  DBGSYSMSG_CMD_FIELD,
  DBGSYSMSG_PARAM_FIELD,
  DBGSYSMSG_TYPE_FIELD,
  DBGSYSMSG_CONTENT_FIELD
}
DBGSYSMSG.is_extendable = false
DBGSYSMSG.extensions = {}
FOLLOWTRANSFERCMD_CMD_FIELD.name = "cmd"
FOLLOWTRANSFERCMD_CMD_FIELD.full_name = ".Cmd.FollowTransferCmd.cmd"
FOLLOWTRANSFERCMD_CMD_FIELD.number = 1
FOLLOWTRANSFERCMD_CMD_FIELD.index = 0
FOLLOWTRANSFERCMD_CMD_FIELD.label = 1
FOLLOWTRANSFERCMD_CMD_FIELD.has_default_value = true
FOLLOWTRANSFERCMD_CMD_FIELD.default_value = 9
FOLLOWTRANSFERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FOLLOWTRANSFERCMD_CMD_FIELD.type = 14
FOLLOWTRANSFERCMD_CMD_FIELD.cpp_type = 8
FOLLOWTRANSFERCMD_PARAM_FIELD.name = "param"
FOLLOWTRANSFERCMD_PARAM_FIELD.full_name = ".Cmd.FollowTransferCmd.param"
FOLLOWTRANSFERCMD_PARAM_FIELD.number = 2
FOLLOWTRANSFERCMD_PARAM_FIELD.index = 1
FOLLOWTRANSFERCMD_PARAM_FIELD.label = 1
FOLLOWTRANSFERCMD_PARAM_FIELD.has_default_value = true
FOLLOWTRANSFERCMD_PARAM_FIELD.default_value = 32
FOLLOWTRANSFERCMD_PARAM_FIELD.enum_type = USER2PARAM
FOLLOWTRANSFERCMD_PARAM_FIELD.type = 14
FOLLOWTRANSFERCMD_PARAM_FIELD.cpp_type = 8
FOLLOWTRANSFERCMD_TARGETID_FIELD.name = "targetId"
FOLLOWTRANSFERCMD_TARGETID_FIELD.full_name = ".Cmd.FollowTransferCmd.targetId"
FOLLOWTRANSFERCMD_TARGETID_FIELD.number = 3
FOLLOWTRANSFERCMD_TARGETID_FIELD.index = 2
FOLLOWTRANSFERCMD_TARGETID_FIELD.label = 1
FOLLOWTRANSFERCMD_TARGETID_FIELD.has_default_value = false
FOLLOWTRANSFERCMD_TARGETID_FIELD.default_value = 0
FOLLOWTRANSFERCMD_TARGETID_FIELD.type = 4
FOLLOWTRANSFERCMD_TARGETID_FIELD.cpp_type = 4
FOLLOWTRANSFERCMD.name = "FollowTransferCmd"
FOLLOWTRANSFERCMD.full_name = ".Cmd.FollowTransferCmd"
FOLLOWTRANSFERCMD.nested_types = {}
FOLLOWTRANSFERCMD.enum_types = {}
FOLLOWTRANSFERCMD.fields = {
  FOLLOWTRANSFERCMD_CMD_FIELD,
  FOLLOWTRANSFERCMD_PARAM_FIELD,
  FOLLOWTRANSFERCMD_TARGETID_FIELD
}
FOLLOWTRANSFERCMD.is_extendable = false
FOLLOWTRANSFERCMD.extensions = {}
CALLNPCFUNCCMD_CMD_FIELD.name = "cmd"
CALLNPCFUNCCMD_CMD_FIELD.full_name = ".Cmd.CallNpcFuncCmd.cmd"
CALLNPCFUNCCMD_CMD_FIELD.number = 1
CALLNPCFUNCCMD_CMD_FIELD.index = 0
CALLNPCFUNCCMD_CMD_FIELD.label = 1
CALLNPCFUNCCMD_CMD_FIELD.has_default_value = true
CALLNPCFUNCCMD_CMD_FIELD.default_value = 9
CALLNPCFUNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CALLNPCFUNCCMD_CMD_FIELD.type = 14
CALLNPCFUNCCMD_CMD_FIELD.cpp_type = 8
CALLNPCFUNCCMD_PARAM_FIELD.name = "param"
CALLNPCFUNCCMD_PARAM_FIELD.full_name = ".Cmd.CallNpcFuncCmd.param"
CALLNPCFUNCCMD_PARAM_FIELD.number = 2
CALLNPCFUNCCMD_PARAM_FIELD.index = 1
CALLNPCFUNCCMD_PARAM_FIELD.label = 1
CALLNPCFUNCCMD_PARAM_FIELD.has_default_value = true
CALLNPCFUNCCMD_PARAM_FIELD.default_value = 33
CALLNPCFUNCCMD_PARAM_FIELD.enum_type = USER2PARAM
CALLNPCFUNCCMD_PARAM_FIELD.type = 14
CALLNPCFUNCCMD_PARAM_FIELD.cpp_type = 8
CALLNPCFUNCCMD_TYPE_FIELD.name = "type"
CALLNPCFUNCCMD_TYPE_FIELD.full_name = ".Cmd.CallNpcFuncCmd.type"
CALLNPCFUNCCMD_TYPE_FIELD.number = 3
CALLNPCFUNCCMD_TYPE_FIELD.index = 2
CALLNPCFUNCCMD_TYPE_FIELD.label = 1
CALLNPCFUNCCMD_TYPE_FIELD.has_default_value = true
CALLNPCFUNCCMD_TYPE_FIELD.default_value = 0
CALLNPCFUNCCMD_TYPE_FIELD.type = 13
CALLNPCFUNCCMD_TYPE_FIELD.cpp_type = 3
CALLNPCFUNCCMD_FUNPARAM_FIELD.name = "funparam"
CALLNPCFUNCCMD_FUNPARAM_FIELD.full_name = ".Cmd.CallNpcFuncCmd.funparam"
CALLNPCFUNCCMD_FUNPARAM_FIELD.number = 4
CALLNPCFUNCCMD_FUNPARAM_FIELD.index = 3
CALLNPCFUNCCMD_FUNPARAM_FIELD.label = 1
CALLNPCFUNCCMD_FUNPARAM_FIELD.has_default_value = false
CALLNPCFUNCCMD_FUNPARAM_FIELD.default_value = ""
CALLNPCFUNCCMD_FUNPARAM_FIELD.type = 9
CALLNPCFUNCCMD_FUNPARAM_FIELD.cpp_type = 9
CALLNPCFUNCCMD.name = "CallNpcFuncCmd"
CALLNPCFUNCCMD.full_name = ".Cmd.CallNpcFuncCmd"
CALLNPCFUNCCMD.nested_types = {}
CALLNPCFUNCCMD.enum_types = {}
CALLNPCFUNCCMD.fields = {
  CALLNPCFUNCCMD_CMD_FIELD,
  CALLNPCFUNCCMD_PARAM_FIELD,
  CALLNPCFUNCCMD_TYPE_FIELD,
  CALLNPCFUNCCMD_FUNPARAM_FIELD
}
CALLNPCFUNCCMD.is_extendable = false
CALLNPCFUNCCMD.extensions = {}
MODELSHOW_CMD_FIELD.name = "cmd"
MODELSHOW_CMD_FIELD.full_name = ".Cmd.ModelShow.cmd"
MODELSHOW_CMD_FIELD.number = 1
MODELSHOW_CMD_FIELD.index = 0
MODELSHOW_CMD_FIELD.label = 1
MODELSHOW_CMD_FIELD.has_default_value = true
MODELSHOW_CMD_FIELD.default_value = 9
MODELSHOW_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MODELSHOW_CMD_FIELD.type = 14
MODELSHOW_CMD_FIELD.cpp_type = 8
MODELSHOW_PARAM_FIELD.name = "param"
MODELSHOW_PARAM_FIELD.full_name = ".Cmd.ModelShow.param"
MODELSHOW_PARAM_FIELD.number = 2
MODELSHOW_PARAM_FIELD.index = 1
MODELSHOW_PARAM_FIELD.label = 1
MODELSHOW_PARAM_FIELD.has_default_value = true
MODELSHOW_PARAM_FIELD.default_value = 34
MODELSHOW_PARAM_FIELD.enum_type = USER2PARAM
MODELSHOW_PARAM_FIELD.type = 14
MODELSHOW_PARAM_FIELD.cpp_type = 8
MODELSHOW_TYPE_FIELD.name = "type"
MODELSHOW_TYPE_FIELD.full_name = ".Cmd.ModelShow.type"
MODELSHOW_TYPE_FIELD.number = 3
MODELSHOW_TYPE_FIELD.index = 2
MODELSHOW_TYPE_FIELD.label = 1
MODELSHOW_TYPE_FIELD.has_default_value = true
MODELSHOW_TYPE_FIELD.default_value = 0
MODELSHOW_TYPE_FIELD.type = 13
MODELSHOW_TYPE_FIELD.cpp_type = 3
MODELSHOW_DATA_FIELD.name = "data"
MODELSHOW_DATA_FIELD.full_name = ".Cmd.ModelShow.data"
MODELSHOW_DATA_FIELD.number = 4
MODELSHOW_DATA_FIELD.index = 3
MODELSHOW_DATA_FIELD.label = 1
MODELSHOW_DATA_FIELD.has_default_value = false
MODELSHOW_DATA_FIELD.default_value = ""
MODELSHOW_DATA_FIELD.type = 9
MODELSHOW_DATA_FIELD.cpp_type = 9
MODELSHOW.name = "ModelShow"
MODELSHOW.full_name = ".Cmd.ModelShow"
MODELSHOW.nested_types = {}
MODELSHOW.enum_types = {}
MODELSHOW.fields = {
  MODELSHOW_CMD_FIELD,
  MODELSHOW_PARAM_FIELD,
  MODELSHOW_TYPE_FIELD,
  MODELSHOW_DATA_FIELD
}
MODELSHOW.is_extendable = false
MODELSHOW.extensions = {}
SOUNDEFFECTCMD_CMD_FIELD.name = "cmd"
SOUNDEFFECTCMD_CMD_FIELD.full_name = ".Cmd.SoundEffectCmd.cmd"
SOUNDEFFECTCMD_CMD_FIELD.number = 1
SOUNDEFFECTCMD_CMD_FIELD.index = 0
SOUNDEFFECTCMD_CMD_FIELD.label = 1
SOUNDEFFECTCMD_CMD_FIELD.has_default_value = true
SOUNDEFFECTCMD_CMD_FIELD.default_value = 9
SOUNDEFFECTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SOUNDEFFECTCMD_CMD_FIELD.type = 14
SOUNDEFFECTCMD_CMD_FIELD.cpp_type = 8
SOUNDEFFECTCMD_PARAM_FIELD.name = "param"
SOUNDEFFECTCMD_PARAM_FIELD.full_name = ".Cmd.SoundEffectCmd.param"
SOUNDEFFECTCMD_PARAM_FIELD.number = 2
SOUNDEFFECTCMD_PARAM_FIELD.index = 1
SOUNDEFFECTCMD_PARAM_FIELD.label = 1
SOUNDEFFECTCMD_PARAM_FIELD.has_default_value = true
SOUNDEFFECTCMD_PARAM_FIELD.default_value = 35
SOUNDEFFECTCMD_PARAM_FIELD.enum_type = USER2PARAM
SOUNDEFFECTCMD_PARAM_FIELD.type = 14
SOUNDEFFECTCMD_PARAM_FIELD.cpp_type = 8
SOUNDEFFECTCMD_SE_FIELD.name = "se"
SOUNDEFFECTCMD_SE_FIELD.full_name = ".Cmd.SoundEffectCmd.se"
SOUNDEFFECTCMD_SE_FIELD.number = 3
SOUNDEFFECTCMD_SE_FIELD.index = 2
SOUNDEFFECTCMD_SE_FIELD.label = 1
SOUNDEFFECTCMD_SE_FIELD.has_default_value = false
SOUNDEFFECTCMD_SE_FIELD.default_value = ""
SOUNDEFFECTCMD_SE_FIELD.type = 9
SOUNDEFFECTCMD_SE_FIELD.cpp_type = 9
SOUNDEFFECTCMD_POS_FIELD.name = "pos"
SOUNDEFFECTCMD_POS_FIELD.full_name = ".Cmd.SoundEffectCmd.pos"
SOUNDEFFECTCMD_POS_FIELD.number = 4
SOUNDEFFECTCMD_POS_FIELD.index = 3
SOUNDEFFECTCMD_POS_FIELD.label = 1
SOUNDEFFECTCMD_POS_FIELD.has_default_value = false
SOUNDEFFECTCMD_POS_FIELD.default_value = nil
SOUNDEFFECTCMD_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
SOUNDEFFECTCMD_POS_FIELD.type = 11
SOUNDEFFECTCMD_POS_FIELD.cpp_type = 10
SOUNDEFFECTCMD_MSEC_FIELD.name = "msec"
SOUNDEFFECTCMD_MSEC_FIELD.full_name = ".Cmd.SoundEffectCmd.msec"
SOUNDEFFECTCMD_MSEC_FIELD.number = 5
SOUNDEFFECTCMD_MSEC_FIELD.index = 4
SOUNDEFFECTCMD_MSEC_FIELD.label = 1
SOUNDEFFECTCMD_MSEC_FIELD.has_default_value = true
SOUNDEFFECTCMD_MSEC_FIELD.default_value = 0
SOUNDEFFECTCMD_MSEC_FIELD.type = 13
SOUNDEFFECTCMD_MSEC_FIELD.cpp_type = 3
SOUNDEFFECTCMD_TIMES_FIELD.name = "times"
SOUNDEFFECTCMD_TIMES_FIELD.full_name = ".Cmd.SoundEffectCmd.times"
SOUNDEFFECTCMD_TIMES_FIELD.number = 6
SOUNDEFFECTCMD_TIMES_FIELD.index = 5
SOUNDEFFECTCMD_TIMES_FIELD.label = 1
SOUNDEFFECTCMD_TIMES_FIELD.has_default_value = true
SOUNDEFFECTCMD_TIMES_FIELD.default_value = 1
SOUNDEFFECTCMD_TIMES_FIELD.type = 13
SOUNDEFFECTCMD_TIMES_FIELD.cpp_type = 3
SOUNDEFFECTCMD_DELAY_FIELD.name = "delay"
SOUNDEFFECTCMD_DELAY_FIELD.full_name = ".Cmd.SoundEffectCmd.delay"
SOUNDEFFECTCMD_DELAY_FIELD.number = 7
SOUNDEFFECTCMD_DELAY_FIELD.index = 6
SOUNDEFFECTCMD_DELAY_FIELD.label = 1
SOUNDEFFECTCMD_DELAY_FIELD.has_default_value = true
SOUNDEFFECTCMD_DELAY_FIELD.default_value = 0
SOUNDEFFECTCMD_DELAY_FIELD.type = 13
SOUNDEFFECTCMD_DELAY_FIELD.cpp_type = 3
SOUNDEFFECTCMD.name = "SoundEffectCmd"
SOUNDEFFECTCMD.full_name = ".Cmd.SoundEffectCmd"
SOUNDEFFECTCMD.nested_types = {}
SOUNDEFFECTCMD.enum_types = {}
SOUNDEFFECTCMD.fields = {
  SOUNDEFFECTCMD_CMD_FIELD,
  SOUNDEFFECTCMD_PARAM_FIELD,
  SOUNDEFFECTCMD_SE_FIELD,
  SOUNDEFFECTCMD_POS_FIELD,
  SOUNDEFFECTCMD_MSEC_FIELD,
  SOUNDEFFECTCMD_TIMES_FIELD,
  SOUNDEFFECTCMD_DELAY_FIELD
}
SOUNDEFFECTCMD.is_extendable = false
SOUNDEFFECTCMD.extensions = {}
PRESETMSG_MSGID_FIELD.name = "msgid"
PRESETMSG_MSGID_FIELD.full_name = ".Cmd.PresetMsg.msgid"
PRESETMSG_MSGID_FIELD.number = 1
PRESETMSG_MSGID_FIELD.index = 0
PRESETMSG_MSGID_FIELD.label = 1
PRESETMSG_MSGID_FIELD.has_default_value = true
PRESETMSG_MSGID_FIELD.default_value = 0
PRESETMSG_MSGID_FIELD.type = 13
PRESETMSG_MSGID_FIELD.cpp_type = 3
PRESETMSG_MSG_FIELD.name = "msg"
PRESETMSG_MSG_FIELD.full_name = ".Cmd.PresetMsg.msg"
PRESETMSG_MSG_FIELD.number = 2
PRESETMSG_MSG_FIELD.index = 1
PRESETMSG_MSG_FIELD.label = 1
PRESETMSG_MSG_FIELD.has_default_value = false
PRESETMSG_MSG_FIELD.default_value = ""
PRESETMSG_MSG_FIELD.type = 9
PRESETMSG_MSG_FIELD.cpp_type = 9
PRESETMSG.name = "PresetMsg"
PRESETMSG.full_name = ".Cmd.PresetMsg"
PRESETMSG.nested_types = {}
PRESETMSG.enum_types = {}
PRESETMSG.fields = {
  PRESETMSG_MSGID_FIELD,
  PRESETMSG_MSG_FIELD
}
PRESETMSG.is_extendable = false
PRESETMSG.extensions = {}
PRESETMSGCMD_CMD_FIELD.name = "cmd"
PRESETMSGCMD_CMD_FIELD.full_name = ".Cmd.PresetMsgCmd.cmd"
PRESETMSGCMD_CMD_FIELD.number = 1
PRESETMSGCMD_CMD_FIELD.index = 0
PRESETMSGCMD_CMD_FIELD.label = 1
PRESETMSGCMD_CMD_FIELD.has_default_value = true
PRESETMSGCMD_CMD_FIELD.default_value = 9
PRESETMSGCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PRESETMSGCMD_CMD_FIELD.type = 14
PRESETMSGCMD_CMD_FIELD.cpp_type = 8
PRESETMSGCMD_PARAM_FIELD.name = "param"
PRESETMSGCMD_PARAM_FIELD.full_name = ".Cmd.PresetMsgCmd.param"
PRESETMSGCMD_PARAM_FIELD.number = 2
PRESETMSGCMD_PARAM_FIELD.index = 1
PRESETMSGCMD_PARAM_FIELD.label = 1
PRESETMSGCMD_PARAM_FIELD.has_default_value = true
PRESETMSGCMD_PARAM_FIELD.default_value = 36
PRESETMSGCMD_PARAM_FIELD.enum_type = USER2PARAM
PRESETMSGCMD_PARAM_FIELD.type = 14
PRESETMSGCMD_PARAM_FIELD.cpp_type = 8
PRESETMSGCMD_MSGS_FIELD.name = "msgs"
PRESETMSGCMD_MSGS_FIELD.full_name = ".Cmd.PresetMsgCmd.msgs"
PRESETMSGCMD_MSGS_FIELD.number = 3
PRESETMSGCMD_MSGS_FIELD.index = 2
PRESETMSGCMD_MSGS_FIELD.label = 3
PRESETMSGCMD_MSGS_FIELD.has_default_value = false
PRESETMSGCMD_MSGS_FIELD.default_value = {}
PRESETMSGCMD_MSGS_FIELD.type = 9
PRESETMSGCMD_MSGS_FIELD.cpp_type = 9
PRESETMSGCMD.name = "PresetMsgCmd"
PRESETMSGCMD.full_name = ".Cmd.PresetMsgCmd"
PRESETMSGCMD.nested_types = {}
PRESETMSGCMD.enum_types = {}
PRESETMSGCMD.fields = {
  PRESETMSGCMD_CMD_FIELD,
  PRESETMSGCMD_PARAM_FIELD,
  PRESETMSGCMD_MSGS_FIELD
}
PRESETMSGCMD.is_extendable = false
PRESETMSGCMD.extensions = {}
CHANGEBGMCMD_CMD_FIELD.name = "cmd"
CHANGEBGMCMD_CMD_FIELD.full_name = ".Cmd.ChangeBgmCmd.cmd"
CHANGEBGMCMD_CMD_FIELD.number = 1
CHANGEBGMCMD_CMD_FIELD.index = 0
CHANGEBGMCMD_CMD_FIELD.label = 1
CHANGEBGMCMD_CMD_FIELD.has_default_value = true
CHANGEBGMCMD_CMD_FIELD.default_value = 9
CHANGEBGMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHANGEBGMCMD_CMD_FIELD.type = 14
CHANGEBGMCMD_CMD_FIELD.cpp_type = 8
CHANGEBGMCMD_PARAM_FIELD.name = "param"
CHANGEBGMCMD_PARAM_FIELD.full_name = ".Cmd.ChangeBgmCmd.param"
CHANGEBGMCMD_PARAM_FIELD.number = 2
CHANGEBGMCMD_PARAM_FIELD.index = 1
CHANGEBGMCMD_PARAM_FIELD.label = 1
CHANGEBGMCMD_PARAM_FIELD.has_default_value = true
CHANGEBGMCMD_PARAM_FIELD.default_value = 37
CHANGEBGMCMD_PARAM_FIELD.enum_type = USER2PARAM
CHANGEBGMCMD_PARAM_FIELD.type = 14
CHANGEBGMCMD_PARAM_FIELD.cpp_type = 8
CHANGEBGMCMD_BGM_FIELD.name = "bgm"
CHANGEBGMCMD_BGM_FIELD.full_name = ".Cmd.ChangeBgmCmd.bgm"
CHANGEBGMCMD_BGM_FIELD.number = 3
CHANGEBGMCMD_BGM_FIELD.index = 2
CHANGEBGMCMD_BGM_FIELD.label = 1
CHANGEBGMCMD_BGM_FIELD.has_default_value = false
CHANGEBGMCMD_BGM_FIELD.default_value = ""
CHANGEBGMCMD_BGM_FIELD.type = 9
CHANGEBGMCMD_BGM_FIELD.cpp_type = 9
CHANGEBGMCMD_PLAY_FIELD.name = "play"
CHANGEBGMCMD_PLAY_FIELD.full_name = ".Cmd.ChangeBgmCmd.play"
CHANGEBGMCMD_PLAY_FIELD.number = 4
CHANGEBGMCMD_PLAY_FIELD.index = 3
CHANGEBGMCMD_PLAY_FIELD.label = 1
CHANGEBGMCMD_PLAY_FIELD.has_default_value = true
CHANGEBGMCMD_PLAY_FIELD.default_value = true
CHANGEBGMCMD_PLAY_FIELD.type = 8
CHANGEBGMCMD_PLAY_FIELD.cpp_type = 7
CHANGEBGMCMD_TIMES_FIELD.name = "times"
CHANGEBGMCMD_TIMES_FIELD.full_name = ".Cmd.ChangeBgmCmd.times"
CHANGEBGMCMD_TIMES_FIELD.number = 5
CHANGEBGMCMD_TIMES_FIELD.index = 4
CHANGEBGMCMD_TIMES_FIELD.label = 1
CHANGEBGMCMD_TIMES_FIELD.has_default_value = true
CHANGEBGMCMD_TIMES_FIELD.default_value = 0
CHANGEBGMCMD_TIMES_FIELD.type = 13
CHANGEBGMCMD_TIMES_FIELD.cpp_type = 3
CHANGEBGMCMD_TYPE_FIELD.name = "type"
CHANGEBGMCMD_TYPE_FIELD.full_name = ".Cmd.ChangeBgmCmd.type"
CHANGEBGMCMD_TYPE_FIELD.number = 6
CHANGEBGMCMD_TYPE_FIELD.index = 5
CHANGEBGMCMD_TYPE_FIELD.label = 1
CHANGEBGMCMD_TYPE_FIELD.has_default_value = false
CHANGEBGMCMD_TYPE_FIELD.default_value = nil
CHANGEBGMCMD_TYPE_FIELD.enum_type = PROTOCOMMON_PB_EBGMTYPE
CHANGEBGMCMD_TYPE_FIELD.type = 14
CHANGEBGMCMD_TYPE_FIELD.cpp_type = 8
CHANGEBGMCMD.name = "ChangeBgmCmd"
CHANGEBGMCMD.full_name = ".Cmd.ChangeBgmCmd"
CHANGEBGMCMD.nested_types = {}
CHANGEBGMCMD.enum_types = {}
CHANGEBGMCMD.fields = {
  CHANGEBGMCMD_CMD_FIELD,
  CHANGEBGMCMD_PARAM_FIELD,
  CHANGEBGMCMD_BGM_FIELD,
  CHANGEBGMCMD_PLAY_FIELD,
  CHANGEBGMCMD_TIMES_FIELD,
  CHANGEBGMCMD_TYPE_FIELD
}
CHANGEBGMCMD.is_extendable = false
CHANGEBGMCMD.extensions = {}
FIGHTERINFO_DATAS_FIELD.name = "datas"
FIGHTERINFO_DATAS_FIELD.full_name = ".Cmd.FighterInfo.datas"
FIGHTERINFO_DATAS_FIELD.number = 1
FIGHTERINFO_DATAS_FIELD.index = 0
FIGHTERINFO_DATAS_FIELD.label = 3
FIGHTERINFO_DATAS_FIELD.has_default_value = false
FIGHTERINFO_DATAS_FIELD.default_value = {}
FIGHTERINFO_DATAS_FIELD.message_type = SceneUser_pb.USERDATA
FIGHTERINFO_DATAS_FIELD.type = 11
FIGHTERINFO_DATAS_FIELD.cpp_type = 10
FIGHTERINFO_ATTRS_FIELD.name = "attrs"
FIGHTERINFO_ATTRS_FIELD.full_name = ".Cmd.FighterInfo.attrs"
FIGHTERINFO_ATTRS_FIELD.number = 2
FIGHTERINFO_ATTRS_FIELD.index = 1
FIGHTERINFO_ATTRS_FIELD.label = 3
FIGHTERINFO_ATTRS_FIELD.has_default_value = false
FIGHTERINFO_ATTRS_FIELD.default_value = {}
FIGHTERINFO_ATTRS_FIELD.message_type = SceneUser_pb.USERATTR
FIGHTERINFO_ATTRS_FIELD.type = 11
FIGHTERINFO_ATTRS_FIELD.cpp_type = 10
FIGHTERINFO.name = "FighterInfo"
FIGHTERINFO.full_name = ".Cmd.FighterInfo"
FIGHTERINFO.nested_types = {}
FIGHTERINFO.enum_types = {}
FIGHTERINFO.fields = {
  FIGHTERINFO_DATAS_FIELD,
  FIGHTERINFO_ATTRS_FIELD
}
FIGHTERINFO.is_extendable = false
FIGHTERINFO.extensions = {}
QUERYFIGHTERINFO_CMD_FIELD.name = "cmd"
QUERYFIGHTERINFO_CMD_FIELD.full_name = ".Cmd.QueryFighterInfo.cmd"
QUERYFIGHTERINFO_CMD_FIELD.number = 1
QUERYFIGHTERINFO_CMD_FIELD.index = 0
QUERYFIGHTERINFO_CMD_FIELD.label = 1
QUERYFIGHTERINFO_CMD_FIELD.has_default_value = true
QUERYFIGHTERINFO_CMD_FIELD.default_value = 9
QUERYFIGHTERINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYFIGHTERINFO_CMD_FIELD.type = 14
QUERYFIGHTERINFO_CMD_FIELD.cpp_type = 8
QUERYFIGHTERINFO_PARAM_FIELD.name = "param"
QUERYFIGHTERINFO_PARAM_FIELD.full_name = ".Cmd.QueryFighterInfo.param"
QUERYFIGHTERINFO_PARAM_FIELD.number = 2
QUERYFIGHTERINFO_PARAM_FIELD.index = 1
QUERYFIGHTERINFO_PARAM_FIELD.label = 1
QUERYFIGHTERINFO_PARAM_FIELD.has_default_value = true
QUERYFIGHTERINFO_PARAM_FIELD.default_value = 38
QUERYFIGHTERINFO_PARAM_FIELD.enum_type = USER2PARAM
QUERYFIGHTERINFO_PARAM_FIELD.type = 14
QUERYFIGHTERINFO_PARAM_FIELD.cpp_type = 8
QUERYFIGHTERINFO_FIGHTERS_FIELD.name = "fighters"
QUERYFIGHTERINFO_FIGHTERS_FIELD.full_name = ".Cmd.QueryFighterInfo.fighters"
QUERYFIGHTERINFO_FIGHTERS_FIELD.number = 3
QUERYFIGHTERINFO_FIGHTERS_FIELD.index = 2
QUERYFIGHTERINFO_FIGHTERS_FIELD.label = 3
QUERYFIGHTERINFO_FIGHTERS_FIELD.has_default_value = false
QUERYFIGHTERINFO_FIGHTERS_FIELD.default_value = {}
QUERYFIGHTERINFO_FIGHTERS_FIELD.message_type = FIGHTERINFO
QUERYFIGHTERINFO_FIGHTERS_FIELD.type = 11
QUERYFIGHTERINFO_FIGHTERS_FIELD.cpp_type = 10
QUERYFIGHTERINFO.name = "QueryFighterInfo"
QUERYFIGHTERINFO.full_name = ".Cmd.QueryFighterInfo"
QUERYFIGHTERINFO.nested_types = {}
QUERYFIGHTERINFO.enum_types = {}
QUERYFIGHTERINFO.fields = {
  QUERYFIGHTERINFO_CMD_FIELD,
  QUERYFIGHTERINFO_PARAM_FIELD,
  QUERYFIGHTERINFO_FIGHTERS_FIELD
}
QUERYFIGHTERINFO.is_extendable = false
QUERYFIGHTERINFO.extensions = {}
GAMETIMECMD_CMD_FIELD.name = "cmd"
GAMETIMECMD_CMD_FIELD.full_name = ".Cmd.GameTimeCmd.cmd"
GAMETIMECMD_CMD_FIELD.number = 1
GAMETIMECMD_CMD_FIELD.index = 0
GAMETIMECMD_CMD_FIELD.label = 1
GAMETIMECMD_CMD_FIELD.has_default_value = true
GAMETIMECMD_CMD_FIELD.default_value = 9
GAMETIMECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GAMETIMECMD_CMD_FIELD.type = 14
GAMETIMECMD_CMD_FIELD.cpp_type = 8
GAMETIMECMD_PARAM_FIELD.name = "param"
GAMETIMECMD_PARAM_FIELD.full_name = ".Cmd.GameTimeCmd.param"
GAMETIMECMD_PARAM_FIELD.number = 2
GAMETIMECMD_PARAM_FIELD.index = 1
GAMETIMECMD_PARAM_FIELD.label = 1
GAMETIMECMD_PARAM_FIELD.has_default_value = true
GAMETIMECMD_PARAM_FIELD.default_value = 40
GAMETIMECMD_PARAM_FIELD.enum_type = USER2PARAM
GAMETIMECMD_PARAM_FIELD.type = 14
GAMETIMECMD_PARAM_FIELD.cpp_type = 8
GAMETIMECMD_OPT_FIELD.name = "opt"
GAMETIMECMD_OPT_FIELD.full_name = ".Cmd.GameTimeCmd.opt"
GAMETIMECMD_OPT_FIELD.number = 3
GAMETIMECMD_OPT_FIELD.index = 2
GAMETIMECMD_OPT_FIELD.label = 1
GAMETIMECMD_OPT_FIELD.has_default_value = true
GAMETIMECMD_OPT_FIELD.default_value = 1
GAMETIMECMD_OPT_FIELD.enum_type = GAMETIMEOPT
GAMETIMECMD_OPT_FIELD.type = 14
GAMETIMECMD_OPT_FIELD.cpp_type = 8
GAMETIMECMD_SEC_FIELD.name = "sec"
GAMETIMECMD_SEC_FIELD.full_name = ".Cmd.GameTimeCmd.sec"
GAMETIMECMD_SEC_FIELD.number = 4
GAMETIMECMD_SEC_FIELD.index = 3
GAMETIMECMD_SEC_FIELD.label = 1
GAMETIMECMD_SEC_FIELD.has_default_value = true
GAMETIMECMD_SEC_FIELD.default_value = 1
GAMETIMECMD_SEC_FIELD.type = 13
GAMETIMECMD_SEC_FIELD.cpp_type = 3
GAMETIMECMD_SPEED_FIELD.name = "speed"
GAMETIMECMD_SPEED_FIELD.full_name = ".Cmd.GameTimeCmd.speed"
GAMETIMECMD_SPEED_FIELD.number = 5
GAMETIMECMD_SPEED_FIELD.index = 4
GAMETIMECMD_SPEED_FIELD.label = 1
GAMETIMECMD_SPEED_FIELD.has_default_value = true
GAMETIMECMD_SPEED_FIELD.default_value = 1
GAMETIMECMD_SPEED_FIELD.type = 13
GAMETIMECMD_SPEED_FIELD.cpp_type = 3
GAMETIMECMD.name = "GameTimeCmd"
GAMETIMECMD.full_name = ".Cmd.GameTimeCmd"
GAMETIMECMD.nested_types = {}
GAMETIMECMD.enum_types = {}
GAMETIMECMD.fields = {
  GAMETIMECMD_CMD_FIELD,
  GAMETIMECMD_PARAM_FIELD,
  GAMETIMECMD_OPT_FIELD,
  GAMETIMECMD_SEC_FIELD,
  GAMETIMECMD_SPEED_FIELD
}
GAMETIMECMD.is_extendable = false
GAMETIMECMD.extensions = {}
CDTIMEITEM_ID_FIELD.name = "id"
CDTIMEITEM_ID_FIELD.full_name = ".Cmd.CDTimeItem.id"
CDTIMEITEM_ID_FIELD.number = 1
CDTIMEITEM_ID_FIELD.index = 0
CDTIMEITEM_ID_FIELD.label = 1
CDTIMEITEM_ID_FIELD.has_default_value = false
CDTIMEITEM_ID_FIELD.default_value = 0
CDTIMEITEM_ID_FIELD.type = 13
CDTIMEITEM_ID_FIELD.cpp_type = 3
CDTIMEITEM_TIME_FIELD.name = "time"
CDTIMEITEM_TIME_FIELD.full_name = ".Cmd.CDTimeItem.time"
CDTIMEITEM_TIME_FIELD.number = 2
CDTIMEITEM_TIME_FIELD.index = 1
CDTIMEITEM_TIME_FIELD.label = 1
CDTIMEITEM_TIME_FIELD.has_default_value = false
CDTIMEITEM_TIME_FIELD.default_value = 0
CDTIMEITEM_TIME_FIELD.type = 4
CDTIMEITEM_TIME_FIELD.cpp_type = 4
CDTIMEITEM_TYPE_FIELD.name = "type"
CDTIMEITEM_TYPE_FIELD.full_name = ".Cmd.CDTimeItem.type"
CDTIMEITEM_TYPE_FIELD.number = 3
CDTIMEITEM_TYPE_FIELD.index = 2
CDTIMEITEM_TYPE_FIELD.label = 1
CDTIMEITEM_TYPE_FIELD.has_default_value = false
CDTIMEITEM_TYPE_FIELD.default_value = nil
CDTIMEITEM_TYPE_FIELD.enum_type = CD_TYPE
CDTIMEITEM_TYPE_FIELD.type = 14
CDTIMEITEM_TYPE_FIELD.cpp_type = 8
CDTIMEITEM.name = "CDTimeItem"
CDTIMEITEM.full_name = ".Cmd.CDTimeItem"
CDTIMEITEM.nested_types = {}
CDTIMEITEM.enum_types = {}
CDTIMEITEM.fields = {
  CDTIMEITEM_ID_FIELD,
  CDTIMEITEM_TIME_FIELD,
  CDTIMEITEM_TYPE_FIELD
}
CDTIMEITEM.is_extendable = false
CDTIMEITEM.extensions = {}
CDTIMEUSERCMD_CMD_FIELD.name = "cmd"
CDTIMEUSERCMD_CMD_FIELD.full_name = ".Cmd.CDTimeUserCmd.cmd"
CDTIMEUSERCMD_CMD_FIELD.number = 1
CDTIMEUSERCMD_CMD_FIELD.index = 0
CDTIMEUSERCMD_CMD_FIELD.label = 1
CDTIMEUSERCMD_CMD_FIELD.has_default_value = true
CDTIMEUSERCMD_CMD_FIELD.default_value = 9
CDTIMEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CDTIMEUSERCMD_CMD_FIELD.type = 14
CDTIMEUSERCMD_CMD_FIELD.cpp_type = 8
CDTIMEUSERCMD_PARAM_FIELD.name = "param"
CDTIMEUSERCMD_PARAM_FIELD.full_name = ".Cmd.CDTimeUserCmd.param"
CDTIMEUSERCMD_PARAM_FIELD.number = 2
CDTIMEUSERCMD_PARAM_FIELD.index = 1
CDTIMEUSERCMD_PARAM_FIELD.label = 1
CDTIMEUSERCMD_PARAM_FIELD.has_default_value = true
CDTIMEUSERCMD_PARAM_FIELD.default_value = 41
CDTIMEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CDTIMEUSERCMD_PARAM_FIELD.type = 14
CDTIMEUSERCMD_PARAM_FIELD.cpp_type = 8
CDTIMEUSERCMD_LIST_FIELD.name = "list"
CDTIMEUSERCMD_LIST_FIELD.full_name = ".Cmd.CDTimeUserCmd.list"
CDTIMEUSERCMD_LIST_FIELD.number = 3
CDTIMEUSERCMD_LIST_FIELD.index = 2
CDTIMEUSERCMD_LIST_FIELD.label = 3
CDTIMEUSERCMD_LIST_FIELD.has_default_value = false
CDTIMEUSERCMD_LIST_FIELD.default_value = {}
CDTIMEUSERCMD_LIST_FIELD.message_type = CDTIMEITEM
CDTIMEUSERCMD_LIST_FIELD.type = 11
CDTIMEUSERCMD_LIST_FIELD.cpp_type = 10
CDTIMEUSERCMD.name = "CDTimeUserCmd"
CDTIMEUSERCMD.full_name = ".Cmd.CDTimeUserCmd"
CDTIMEUSERCMD.nested_types = {}
CDTIMEUSERCMD.enum_types = {}
CDTIMEUSERCMD.fields = {
  CDTIMEUSERCMD_CMD_FIELD,
  CDTIMEUSERCMD_PARAM_FIELD,
  CDTIMEUSERCMD_LIST_FIELD
}
CDTIMEUSERCMD.is_extendable = false
CDTIMEUSERCMD.extensions = {}
STATECHANGE_CMD_FIELD.name = "cmd"
STATECHANGE_CMD_FIELD.full_name = ".Cmd.StateChange.cmd"
STATECHANGE_CMD_FIELD.number = 1
STATECHANGE_CMD_FIELD.index = 0
STATECHANGE_CMD_FIELD.label = 1
STATECHANGE_CMD_FIELD.has_default_value = true
STATECHANGE_CMD_FIELD.default_value = 9
STATECHANGE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STATECHANGE_CMD_FIELD.type = 14
STATECHANGE_CMD_FIELD.cpp_type = 8
STATECHANGE_PARAM_FIELD.name = "param"
STATECHANGE_PARAM_FIELD.full_name = ".Cmd.StateChange.param"
STATECHANGE_PARAM_FIELD.number = 2
STATECHANGE_PARAM_FIELD.index = 1
STATECHANGE_PARAM_FIELD.label = 1
STATECHANGE_PARAM_FIELD.has_default_value = true
STATECHANGE_PARAM_FIELD.default_value = 42
STATECHANGE_PARAM_FIELD.enum_type = USER2PARAM
STATECHANGE_PARAM_FIELD.type = 14
STATECHANGE_PARAM_FIELD.cpp_type = 8
STATECHANGE_STATUS_FIELD.name = "status"
STATECHANGE_STATUS_FIELD.full_name = ".Cmd.StateChange.status"
STATECHANGE_STATUS_FIELD.number = 3
STATECHANGE_STATUS_FIELD.index = 2
STATECHANGE_STATUS_FIELD.label = 1
STATECHANGE_STATUS_FIELD.has_default_value = true
STATECHANGE_STATUS_FIELD.default_value = 0
STATECHANGE_STATUS_FIELD.enum_type = PROTOCOMMON_PB_ECREATURESTATUS
STATECHANGE_STATUS_FIELD.type = 14
STATECHANGE_STATUS_FIELD.cpp_type = 8
STATECHANGE.name = "StateChange"
STATECHANGE.full_name = ".Cmd.StateChange"
STATECHANGE.nested_types = {}
STATECHANGE.enum_types = {}
STATECHANGE.fields = {
  STATECHANGE_CMD_FIELD,
  STATECHANGE_PARAM_FIELD,
  STATECHANGE_STATUS_FIELD
}
STATECHANGE.is_extendable = false
STATECHANGE.extensions = {}
PHOTO_CMD_FIELD.name = "cmd"
PHOTO_CMD_FIELD.full_name = ".Cmd.Photo.cmd"
PHOTO_CMD_FIELD.number = 1
PHOTO_CMD_FIELD.index = 0
PHOTO_CMD_FIELD.label = 1
PHOTO_CMD_FIELD.has_default_value = true
PHOTO_CMD_FIELD.default_value = 9
PHOTO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PHOTO_CMD_FIELD.type = 14
PHOTO_CMD_FIELD.cpp_type = 8
PHOTO_PARAM_FIELD.name = "param"
PHOTO_PARAM_FIELD.full_name = ".Cmd.Photo.param"
PHOTO_PARAM_FIELD.number = 2
PHOTO_PARAM_FIELD.index = 1
PHOTO_PARAM_FIELD.label = 1
PHOTO_PARAM_FIELD.has_default_value = true
PHOTO_PARAM_FIELD.default_value = 44
PHOTO_PARAM_FIELD.enum_type = USER2PARAM
PHOTO_PARAM_FIELD.type = 14
PHOTO_PARAM_FIELD.cpp_type = 8
PHOTO_GUID_FIELD.name = "guid"
PHOTO_GUID_FIELD.full_name = ".Cmd.Photo.guid"
PHOTO_GUID_FIELD.number = 3
PHOTO_GUID_FIELD.index = 2
PHOTO_GUID_FIELD.label = 1
PHOTO_GUID_FIELD.has_default_value = true
PHOTO_GUID_FIELD.default_value = 0
PHOTO_GUID_FIELD.type = 4
PHOTO_GUID_FIELD.cpp_type = 4
PHOTO.name = "Photo"
PHOTO.full_name = ".Cmd.Photo"
PHOTO.nested_types = {}
PHOTO.enum_types = {}
PHOTO.fields = {
  PHOTO_CMD_FIELD,
  PHOTO_PARAM_FIELD,
  PHOTO_GUID_FIELD
}
PHOTO.is_extendable = false
PHOTO.extensions = {}
SHAKESCREEN_CMD_FIELD.name = "cmd"
SHAKESCREEN_CMD_FIELD.full_name = ".Cmd.ShakeScreen.cmd"
SHAKESCREEN_CMD_FIELD.number = 1
SHAKESCREEN_CMD_FIELD.index = 0
SHAKESCREEN_CMD_FIELD.label = 1
SHAKESCREEN_CMD_FIELD.has_default_value = true
SHAKESCREEN_CMD_FIELD.default_value = 9
SHAKESCREEN_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SHAKESCREEN_CMD_FIELD.type = 14
SHAKESCREEN_CMD_FIELD.cpp_type = 8
SHAKESCREEN_PARAM_FIELD.name = "param"
SHAKESCREEN_PARAM_FIELD.full_name = ".Cmd.ShakeScreen.param"
SHAKESCREEN_PARAM_FIELD.number = 2
SHAKESCREEN_PARAM_FIELD.index = 1
SHAKESCREEN_PARAM_FIELD.label = 1
SHAKESCREEN_PARAM_FIELD.has_default_value = true
SHAKESCREEN_PARAM_FIELD.default_value = 45
SHAKESCREEN_PARAM_FIELD.enum_type = USER2PARAM
SHAKESCREEN_PARAM_FIELD.type = 14
SHAKESCREEN_PARAM_FIELD.cpp_type = 8
SHAKESCREEN_MAXAMPLITUDE_FIELD.name = "maxamplitude"
SHAKESCREEN_MAXAMPLITUDE_FIELD.full_name = ".Cmd.ShakeScreen.maxamplitude"
SHAKESCREEN_MAXAMPLITUDE_FIELD.number = 3
SHAKESCREEN_MAXAMPLITUDE_FIELD.index = 2
SHAKESCREEN_MAXAMPLITUDE_FIELD.label = 1
SHAKESCREEN_MAXAMPLITUDE_FIELD.has_default_value = true
SHAKESCREEN_MAXAMPLITUDE_FIELD.default_value = 3
SHAKESCREEN_MAXAMPLITUDE_FIELD.type = 13
SHAKESCREEN_MAXAMPLITUDE_FIELD.cpp_type = 3
SHAKESCREEN_MSEC_FIELD.name = "msec"
SHAKESCREEN_MSEC_FIELD.full_name = ".Cmd.ShakeScreen.msec"
SHAKESCREEN_MSEC_FIELD.number = 4
SHAKESCREEN_MSEC_FIELD.index = 3
SHAKESCREEN_MSEC_FIELD.label = 1
SHAKESCREEN_MSEC_FIELD.has_default_value = true
SHAKESCREEN_MSEC_FIELD.default_value = 0
SHAKESCREEN_MSEC_FIELD.type = 13
SHAKESCREEN_MSEC_FIELD.cpp_type = 3
SHAKESCREEN_SHAKETYPE_FIELD.name = "shaketype"
SHAKESCREEN_SHAKETYPE_FIELD.full_name = ".Cmd.ShakeScreen.shaketype"
SHAKESCREEN_SHAKETYPE_FIELD.number = 5
SHAKESCREEN_SHAKETYPE_FIELD.index = 4
SHAKESCREEN_SHAKETYPE_FIELD.label = 1
SHAKESCREEN_SHAKETYPE_FIELD.has_default_value = true
SHAKESCREEN_SHAKETYPE_FIELD.default_value = 1
SHAKESCREEN_SHAKETYPE_FIELD.type = 13
SHAKESCREEN_SHAKETYPE_FIELD.cpp_type = 3
SHAKESCREEN.name = "ShakeScreen"
SHAKESCREEN.full_name = ".Cmd.ShakeScreen"
SHAKESCREEN.nested_types = {}
SHAKESCREEN.enum_types = {}
SHAKESCREEN.fields = {
  SHAKESCREEN_CMD_FIELD,
  SHAKESCREEN_PARAM_FIELD,
  SHAKESCREEN_MAXAMPLITUDE_FIELD,
  SHAKESCREEN_MSEC_FIELD,
  SHAKESCREEN_SHAKETYPE_FIELD
}
SHAKESCREEN.is_extendable = false
SHAKESCREEN.extensions = {}
SHORTCUTITEM_GUID_FIELD.name = "guid"
SHORTCUTITEM_GUID_FIELD.full_name = ".Cmd.ShortcutItem.guid"
SHORTCUTITEM_GUID_FIELD.number = 1
SHORTCUTITEM_GUID_FIELD.index = 0
SHORTCUTITEM_GUID_FIELD.label = 1
SHORTCUTITEM_GUID_FIELD.has_default_value = false
SHORTCUTITEM_GUID_FIELD.default_value = ""
SHORTCUTITEM_GUID_FIELD.type = 9
SHORTCUTITEM_GUID_FIELD.cpp_type = 9
SHORTCUTITEM_TYPE_FIELD.name = "type"
SHORTCUTITEM_TYPE_FIELD.full_name = ".Cmd.ShortcutItem.type"
SHORTCUTITEM_TYPE_FIELD.number = 2
SHORTCUTITEM_TYPE_FIELD.index = 1
SHORTCUTITEM_TYPE_FIELD.label = 1
SHORTCUTITEM_TYPE_FIELD.has_default_value = true
SHORTCUTITEM_TYPE_FIELD.default_value = 0
SHORTCUTITEM_TYPE_FIELD.type = 13
SHORTCUTITEM_TYPE_FIELD.cpp_type = 3
SHORTCUTITEM_POS_FIELD.name = "pos"
SHORTCUTITEM_POS_FIELD.full_name = ".Cmd.ShortcutItem.pos"
SHORTCUTITEM_POS_FIELD.number = 3
SHORTCUTITEM_POS_FIELD.index = 2
SHORTCUTITEM_POS_FIELD.label = 1
SHORTCUTITEM_POS_FIELD.has_default_value = true
SHORTCUTITEM_POS_FIELD.default_value = 0
SHORTCUTITEM_POS_FIELD.type = 13
SHORTCUTITEM_POS_FIELD.cpp_type = 3
SHORTCUTITEM.name = "ShortcutItem"
SHORTCUTITEM.full_name = ".Cmd.ShortcutItem"
SHORTCUTITEM.nested_types = {}
SHORTCUTITEM.enum_types = {}
SHORTCUTITEM.fields = {
  SHORTCUTITEM_GUID_FIELD,
  SHORTCUTITEM_TYPE_FIELD,
  SHORTCUTITEM_POS_FIELD
}
SHORTCUTITEM.is_extendable = false
SHORTCUTITEM.extensions = {}
QUERYSHORTCUT_CMD_FIELD.name = "cmd"
QUERYSHORTCUT_CMD_FIELD.full_name = ".Cmd.QueryShortcut.cmd"
QUERYSHORTCUT_CMD_FIELD.number = 1
QUERYSHORTCUT_CMD_FIELD.index = 0
QUERYSHORTCUT_CMD_FIELD.label = 1
QUERYSHORTCUT_CMD_FIELD.has_default_value = true
QUERYSHORTCUT_CMD_FIELD.default_value = 9
QUERYSHORTCUT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYSHORTCUT_CMD_FIELD.type = 14
QUERYSHORTCUT_CMD_FIELD.cpp_type = 8
QUERYSHORTCUT_PARAM_FIELD.name = "param"
QUERYSHORTCUT_PARAM_FIELD.full_name = ".Cmd.QueryShortcut.param"
QUERYSHORTCUT_PARAM_FIELD.number = 2
QUERYSHORTCUT_PARAM_FIELD.index = 1
QUERYSHORTCUT_PARAM_FIELD.label = 1
QUERYSHORTCUT_PARAM_FIELD.has_default_value = true
QUERYSHORTCUT_PARAM_FIELD.default_value = 47
QUERYSHORTCUT_PARAM_FIELD.enum_type = USER2PARAM
QUERYSHORTCUT_PARAM_FIELD.type = 14
QUERYSHORTCUT_PARAM_FIELD.cpp_type = 8
QUERYSHORTCUT_LIST_FIELD.name = "list"
QUERYSHORTCUT_LIST_FIELD.full_name = ".Cmd.QueryShortcut.list"
QUERYSHORTCUT_LIST_FIELD.number = 3
QUERYSHORTCUT_LIST_FIELD.index = 2
QUERYSHORTCUT_LIST_FIELD.label = 3
QUERYSHORTCUT_LIST_FIELD.has_default_value = false
QUERYSHORTCUT_LIST_FIELD.default_value = {}
QUERYSHORTCUT_LIST_FIELD.message_type = SHORTCUTITEM
QUERYSHORTCUT_LIST_FIELD.type = 11
QUERYSHORTCUT_LIST_FIELD.cpp_type = 10
QUERYSHORTCUT.name = "QueryShortcut"
QUERYSHORTCUT.full_name = ".Cmd.QueryShortcut"
QUERYSHORTCUT.nested_types = {}
QUERYSHORTCUT.enum_types = {}
QUERYSHORTCUT.fields = {
  QUERYSHORTCUT_CMD_FIELD,
  QUERYSHORTCUT_PARAM_FIELD,
  QUERYSHORTCUT_LIST_FIELD
}
QUERYSHORTCUT.is_extendable = false
QUERYSHORTCUT.extensions = {}
PUTSHORTCUT_CMD_FIELD.name = "cmd"
PUTSHORTCUT_CMD_FIELD.full_name = ".Cmd.PutShortcut.cmd"
PUTSHORTCUT_CMD_FIELD.number = 1
PUTSHORTCUT_CMD_FIELD.index = 0
PUTSHORTCUT_CMD_FIELD.label = 1
PUTSHORTCUT_CMD_FIELD.has_default_value = true
PUTSHORTCUT_CMD_FIELD.default_value = 9
PUTSHORTCUT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PUTSHORTCUT_CMD_FIELD.type = 14
PUTSHORTCUT_CMD_FIELD.cpp_type = 8
PUTSHORTCUT_PARAM_FIELD.name = "param"
PUTSHORTCUT_PARAM_FIELD.full_name = ".Cmd.PutShortcut.param"
PUTSHORTCUT_PARAM_FIELD.number = 2
PUTSHORTCUT_PARAM_FIELD.index = 1
PUTSHORTCUT_PARAM_FIELD.label = 1
PUTSHORTCUT_PARAM_FIELD.has_default_value = true
PUTSHORTCUT_PARAM_FIELD.default_value = 48
PUTSHORTCUT_PARAM_FIELD.enum_type = USER2PARAM
PUTSHORTCUT_PARAM_FIELD.type = 14
PUTSHORTCUT_PARAM_FIELD.cpp_type = 8
PUTSHORTCUT_ITEM_FIELD.name = "item"
PUTSHORTCUT_ITEM_FIELD.full_name = ".Cmd.PutShortcut.item"
PUTSHORTCUT_ITEM_FIELD.number = 3
PUTSHORTCUT_ITEM_FIELD.index = 2
PUTSHORTCUT_ITEM_FIELD.label = 1
PUTSHORTCUT_ITEM_FIELD.has_default_value = false
PUTSHORTCUT_ITEM_FIELD.default_value = nil
PUTSHORTCUT_ITEM_FIELD.message_type = SHORTCUTITEM
PUTSHORTCUT_ITEM_FIELD.type = 11
PUTSHORTCUT_ITEM_FIELD.cpp_type = 10
PUTSHORTCUT.name = "PutShortcut"
PUTSHORTCUT.full_name = ".Cmd.PutShortcut"
PUTSHORTCUT.nested_types = {}
PUTSHORTCUT.enum_types = {}
PUTSHORTCUT.fields = {
  PUTSHORTCUT_CMD_FIELD,
  PUTSHORTCUT_PARAM_FIELD,
  PUTSHORTCUT_ITEM_FIELD
}
PUTSHORTCUT.is_extendable = false
PUTSHORTCUT.extensions = {}
NPCCHANGEANGLE_CMD_FIELD.name = "cmd"
NPCCHANGEANGLE_CMD_FIELD.full_name = ".Cmd.NpcChangeAngle.cmd"
NPCCHANGEANGLE_CMD_FIELD.number = 1
NPCCHANGEANGLE_CMD_FIELD.index = 0
NPCCHANGEANGLE_CMD_FIELD.label = 1
NPCCHANGEANGLE_CMD_FIELD.has_default_value = true
NPCCHANGEANGLE_CMD_FIELD.default_value = 9
NPCCHANGEANGLE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NPCCHANGEANGLE_CMD_FIELD.type = 14
NPCCHANGEANGLE_CMD_FIELD.cpp_type = 8
NPCCHANGEANGLE_PARAM_FIELD.name = "param"
NPCCHANGEANGLE_PARAM_FIELD.full_name = ".Cmd.NpcChangeAngle.param"
NPCCHANGEANGLE_PARAM_FIELD.number = 2
NPCCHANGEANGLE_PARAM_FIELD.index = 1
NPCCHANGEANGLE_PARAM_FIELD.label = 1
NPCCHANGEANGLE_PARAM_FIELD.has_default_value = true
NPCCHANGEANGLE_PARAM_FIELD.default_value = 49
NPCCHANGEANGLE_PARAM_FIELD.enum_type = USER2PARAM
NPCCHANGEANGLE_PARAM_FIELD.type = 14
NPCCHANGEANGLE_PARAM_FIELD.cpp_type = 8
NPCCHANGEANGLE_GUID_FIELD.name = "guid"
NPCCHANGEANGLE_GUID_FIELD.full_name = ".Cmd.NpcChangeAngle.guid"
NPCCHANGEANGLE_GUID_FIELD.number = 3
NPCCHANGEANGLE_GUID_FIELD.index = 2
NPCCHANGEANGLE_GUID_FIELD.label = 1
NPCCHANGEANGLE_GUID_FIELD.has_default_value = true
NPCCHANGEANGLE_GUID_FIELD.default_value = 0
NPCCHANGEANGLE_GUID_FIELD.type = 4
NPCCHANGEANGLE_GUID_FIELD.cpp_type = 4
NPCCHANGEANGLE_TARGETID_FIELD.name = "targetid"
NPCCHANGEANGLE_TARGETID_FIELD.full_name = ".Cmd.NpcChangeAngle.targetid"
NPCCHANGEANGLE_TARGETID_FIELD.number = 4
NPCCHANGEANGLE_TARGETID_FIELD.index = 3
NPCCHANGEANGLE_TARGETID_FIELD.label = 1
NPCCHANGEANGLE_TARGETID_FIELD.has_default_value = true
NPCCHANGEANGLE_TARGETID_FIELD.default_value = 0
NPCCHANGEANGLE_TARGETID_FIELD.type = 4
NPCCHANGEANGLE_TARGETID_FIELD.cpp_type = 4
NPCCHANGEANGLE_ANGLE_FIELD.name = "angle"
NPCCHANGEANGLE_ANGLE_FIELD.full_name = ".Cmd.NpcChangeAngle.angle"
NPCCHANGEANGLE_ANGLE_FIELD.number = 5
NPCCHANGEANGLE_ANGLE_FIELD.index = 4
NPCCHANGEANGLE_ANGLE_FIELD.label = 1
NPCCHANGEANGLE_ANGLE_FIELD.has_default_value = true
NPCCHANGEANGLE_ANGLE_FIELD.default_value = 0
NPCCHANGEANGLE_ANGLE_FIELD.type = 13
NPCCHANGEANGLE_ANGLE_FIELD.cpp_type = 3
NPCCHANGEANGLE.name = "NpcChangeAngle"
NPCCHANGEANGLE.full_name = ".Cmd.NpcChangeAngle"
NPCCHANGEANGLE.nested_types = {}
NPCCHANGEANGLE.enum_types = {}
NPCCHANGEANGLE.fields = {
  NPCCHANGEANGLE_CMD_FIELD,
  NPCCHANGEANGLE_PARAM_FIELD,
  NPCCHANGEANGLE_GUID_FIELD,
  NPCCHANGEANGLE_TARGETID_FIELD,
  NPCCHANGEANGLE_ANGLE_FIELD
}
NPCCHANGEANGLE.is_extendable = false
NPCCHANGEANGLE.extensions = {}
CAMERAFOCUS_CMD_FIELD.name = "cmd"
CAMERAFOCUS_CMD_FIELD.full_name = ".Cmd.CameraFocus.cmd"
CAMERAFOCUS_CMD_FIELD.number = 1
CAMERAFOCUS_CMD_FIELD.index = 0
CAMERAFOCUS_CMD_FIELD.label = 1
CAMERAFOCUS_CMD_FIELD.has_default_value = true
CAMERAFOCUS_CMD_FIELD.default_value = 9
CAMERAFOCUS_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CAMERAFOCUS_CMD_FIELD.type = 14
CAMERAFOCUS_CMD_FIELD.cpp_type = 8
CAMERAFOCUS_PARAM_FIELD.name = "param"
CAMERAFOCUS_PARAM_FIELD.full_name = ".Cmd.CameraFocus.param"
CAMERAFOCUS_PARAM_FIELD.number = 2
CAMERAFOCUS_PARAM_FIELD.index = 1
CAMERAFOCUS_PARAM_FIELD.label = 1
CAMERAFOCUS_PARAM_FIELD.has_default_value = true
CAMERAFOCUS_PARAM_FIELD.default_value = 50
CAMERAFOCUS_PARAM_FIELD.enum_type = USER2PARAM
CAMERAFOCUS_PARAM_FIELD.type = 14
CAMERAFOCUS_PARAM_FIELD.cpp_type = 8
CAMERAFOCUS_TARGETS_FIELD.name = "targets"
CAMERAFOCUS_TARGETS_FIELD.full_name = ".Cmd.CameraFocus.targets"
CAMERAFOCUS_TARGETS_FIELD.number = 3
CAMERAFOCUS_TARGETS_FIELD.index = 2
CAMERAFOCUS_TARGETS_FIELD.label = 3
CAMERAFOCUS_TARGETS_FIELD.has_default_value = false
CAMERAFOCUS_TARGETS_FIELD.default_value = {}
CAMERAFOCUS_TARGETS_FIELD.type = 4
CAMERAFOCUS_TARGETS_FIELD.cpp_type = 4
CAMERAFOCUS.name = "CameraFocus"
CAMERAFOCUS.full_name = ".Cmd.CameraFocus"
CAMERAFOCUS.nested_types = {}
CAMERAFOCUS.enum_types = {}
CAMERAFOCUS.fields = {
  CAMERAFOCUS_CMD_FIELD,
  CAMERAFOCUS_PARAM_FIELD,
  CAMERAFOCUS_TARGETS_FIELD
}
CAMERAFOCUS.is_extendable = false
CAMERAFOCUS.extensions = {}
GOTOLISTUSERCMD_CMD_FIELD.name = "cmd"
GOTOLISTUSERCMD_CMD_FIELD.full_name = ".Cmd.GoToListUserCmd.cmd"
GOTOLISTUSERCMD_CMD_FIELD.number = 1
GOTOLISTUSERCMD_CMD_FIELD.index = 0
GOTOLISTUSERCMD_CMD_FIELD.label = 1
GOTOLISTUSERCMD_CMD_FIELD.has_default_value = true
GOTOLISTUSERCMD_CMD_FIELD.default_value = 9
GOTOLISTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GOTOLISTUSERCMD_CMD_FIELD.type = 14
GOTOLISTUSERCMD_CMD_FIELD.cpp_type = 8
GOTOLISTUSERCMD_PARAM_FIELD.name = "param"
GOTOLISTUSERCMD_PARAM_FIELD.full_name = ".Cmd.GoToListUserCmd.param"
GOTOLISTUSERCMD_PARAM_FIELD.number = 2
GOTOLISTUSERCMD_PARAM_FIELD.index = 1
GOTOLISTUSERCMD_PARAM_FIELD.label = 1
GOTOLISTUSERCMD_PARAM_FIELD.has_default_value = true
GOTOLISTUSERCMD_PARAM_FIELD.default_value = 51
GOTOLISTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
GOTOLISTUSERCMD_PARAM_FIELD.type = 14
GOTOLISTUSERCMD_PARAM_FIELD.cpp_type = 8
GOTOLISTUSERCMD_MAPID_FIELD.name = "mapid"
GOTOLISTUSERCMD_MAPID_FIELD.full_name = ".Cmd.GoToListUserCmd.mapid"
GOTOLISTUSERCMD_MAPID_FIELD.number = 3
GOTOLISTUSERCMD_MAPID_FIELD.index = 2
GOTOLISTUSERCMD_MAPID_FIELD.label = 3
GOTOLISTUSERCMD_MAPID_FIELD.has_default_value = false
GOTOLISTUSERCMD_MAPID_FIELD.default_value = {}
GOTOLISTUSERCMD_MAPID_FIELD.type = 13
GOTOLISTUSERCMD_MAPID_FIELD.cpp_type = 3
GOTOLISTUSERCMD.name = "GoToListUserCmd"
GOTOLISTUSERCMD.full_name = ".Cmd.GoToListUserCmd"
GOTOLISTUSERCMD.nested_types = {}
GOTOLISTUSERCMD.enum_types = {}
GOTOLISTUSERCMD.fields = {
  GOTOLISTUSERCMD_CMD_FIELD,
  GOTOLISTUSERCMD_PARAM_FIELD,
  GOTOLISTUSERCMD_MAPID_FIELD
}
GOTOLISTUSERCMD.is_extendable = false
GOTOLISTUSERCMD.extensions = {}
GOTOGEARUSERCMD_CMD_FIELD.name = "cmd"
GOTOGEARUSERCMD_CMD_FIELD.full_name = ".Cmd.GoToGearUserCmd.cmd"
GOTOGEARUSERCMD_CMD_FIELD.number = 1
GOTOGEARUSERCMD_CMD_FIELD.index = 0
GOTOGEARUSERCMD_CMD_FIELD.label = 1
GOTOGEARUSERCMD_CMD_FIELD.has_default_value = true
GOTOGEARUSERCMD_CMD_FIELD.default_value = 9
GOTOGEARUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GOTOGEARUSERCMD_CMD_FIELD.type = 14
GOTOGEARUSERCMD_CMD_FIELD.cpp_type = 8
GOTOGEARUSERCMD_PARAM_FIELD.name = "param"
GOTOGEARUSERCMD_PARAM_FIELD.full_name = ".Cmd.GoToGearUserCmd.param"
GOTOGEARUSERCMD_PARAM_FIELD.number = 2
GOTOGEARUSERCMD_PARAM_FIELD.index = 1
GOTOGEARUSERCMD_PARAM_FIELD.label = 1
GOTOGEARUSERCMD_PARAM_FIELD.has_default_value = true
GOTOGEARUSERCMD_PARAM_FIELD.default_value = 52
GOTOGEARUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
GOTOGEARUSERCMD_PARAM_FIELD.type = 14
GOTOGEARUSERCMD_PARAM_FIELD.cpp_type = 8
GOTOGEARUSERCMD_MAPID_FIELD.name = "mapid"
GOTOGEARUSERCMD_MAPID_FIELD.full_name = ".Cmd.GoToGearUserCmd.mapid"
GOTOGEARUSERCMD_MAPID_FIELD.number = 3
GOTOGEARUSERCMD_MAPID_FIELD.index = 2
GOTOGEARUSERCMD_MAPID_FIELD.label = 1
GOTOGEARUSERCMD_MAPID_FIELD.has_default_value = false
GOTOGEARUSERCMD_MAPID_FIELD.default_value = 0
GOTOGEARUSERCMD_MAPID_FIELD.type = 13
GOTOGEARUSERCMD_MAPID_FIELD.cpp_type = 3
GOTOGEARUSERCMD_TYPE_FIELD.name = "type"
GOTOGEARUSERCMD_TYPE_FIELD.full_name = ".Cmd.GoToGearUserCmd.type"
GOTOGEARUSERCMD_TYPE_FIELD.number = 4
GOTOGEARUSERCMD_TYPE_FIELD.index = 3
GOTOGEARUSERCMD_TYPE_FIELD.label = 1
GOTOGEARUSERCMD_TYPE_FIELD.has_default_value = false
GOTOGEARUSERCMD_TYPE_FIELD.default_value = nil
GOTOGEARUSERCMD_TYPE_FIELD.enum_type = EGOTOGEARTYPE
GOTOGEARUSERCMD_TYPE_FIELD.type = 14
GOTOGEARUSERCMD_TYPE_FIELD.cpp_type = 8
GOTOGEARUSERCMD_OTHERIDS_FIELD.name = "otherids"
GOTOGEARUSERCMD_OTHERIDS_FIELD.full_name = ".Cmd.GoToGearUserCmd.otherids"
GOTOGEARUSERCMD_OTHERIDS_FIELD.number = 5
GOTOGEARUSERCMD_OTHERIDS_FIELD.index = 4
GOTOGEARUSERCMD_OTHERIDS_FIELD.label = 3
GOTOGEARUSERCMD_OTHERIDS_FIELD.has_default_value = false
GOTOGEARUSERCMD_OTHERIDS_FIELD.default_value = {}
GOTOGEARUSERCMD_OTHERIDS_FIELD.type = 4
GOTOGEARUSERCMD_OTHERIDS_FIELD.cpp_type = 4
GOTOGEARUSERCMD.name = "GoToGearUserCmd"
GOTOGEARUSERCMD.full_name = ".Cmd.GoToGearUserCmd"
GOTOGEARUSERCMD.nested_types = {}
GOTOGEARUSERCMD.enum_types = {}
GOTOGEARUSERCMD.fields = {
  GOTOGEARUSERCMD_CMD_FIELD,
  GOTOGEARUSERCMD_PARAM_FIELD,
  GOTOGEARUSERCMD_MAPID_FIELD,
  GOTOGEARUSERCMD_TYPE_FIELD,
  GOTOGEARUSERCMD_OTHERIDS_FIELD
}
GOTOGEARUSERCMD.is_extendable = false
GOTOGEARUSERCMD.extensions = {}
NEWTRANSMAPCMD_CMD_FIELD.name = "cmd"
NEWTRANSMAPCMD_CMD_FIELD.full_name = ".Cmd.NewTransMapCmd.cmd"
NEWTRANSMAPCMD_CMD_FIELD.number = 1
NEWTRANSMAPCMD_CMD_FIELD.index = 0
NEWTRANSMAPCMD_CMD_FIELD.label = 1
NEWTRANSMAPCMD_CMD_FIELD.has_default_value = true
NEWTRANSMAPCMD_CMD_FIELD.default_value = 9
NEWTRANSMAPCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWTRANSMAPCMD_CMD_FIELD.type = 14
NEWTRANSMAPCMD_CMD_FIELD.cpp_type = 8
NEWTRANSMAPCMD_PARAM_FIELD.name = "param"
NEWTRANSMAPCMD_PARAM_FIELD.full_name = ".Cmd.NewTransMapCmd.param"
NEWTRANSMAPCMD_PARAM_FIELD.number = 2
NEWTRANSMAPCMD_PARAM_FIELD.index = 1
NEWTRANSMAPCMD_PARAM_FIELD.label = 1
NEWTRANSMAPCMD_PARAM_FIELD.has_default_value = true
NEWTRANSMAPCMD_PARAM_FIELD.default_value = 12
NEWTRANSMAPCMD_PARAM_FIELD.enum_type = USER2PARAM
NEWTRANSMAPCMD_PARAM_FIELD.type = 14
NEWTRANSMAPCMD_PARAM_FIELD.cpp_type = 8
NEWTRANSMAPCMD_MAPID_FIELD.name = "mapid"
NEWTRANSMAPCMD_MAPID_FIELD.full_name = ".Cmd.NewTransMapCmd.mapid"
NEWTRANSMAPCMD_MAPID_FIELD.number = 3
NEWTRANSMAPCMD_MAPID_FIELD.index = 2
NEWTRANSMAPCMD_MAPID_FIELD.label = 3
NEWTRANSMAPCMD_MAPID_FIELD.has_default_value = false
NEWTRANSMAPCMD_MAPID_FIELD.default_value = {}
NEWTRANSMAPCMD_MAPID_FIELD.type = 13
NEWTRANSMAPCMD_MAPID_FIELD.cpp_type = 3
NEWTRANSMAPCMD.name = "NewTransMapCmd"
NEWTRANSMAPCMD.full_name = ".Cmd.NewTransMapCmd"
NEWTRANSMAPCMD.nested_types = {}
NEWTRANSMAPCMD.enum_types = {}
NEWTRANSMAPCMD.fields = {
  NEWTRANSMAPCMD_CMD_FIELD,
  NEWTRANSMAPCMD_PARAM_FIELD,
  NEWTRANSMAPCMD_MAPID_FIELD
}
NEWTRANSMAPCMD.is_extendable = false
NEWTRANSMAPCMD.extensions = {}
DEATHTRANSFERLISTCMD_CMD_FIELD.name = "cmd"
DEATHTRANSFERLISTCMD_CMD_FIELD.full_name = ".Cmd.DeathTransferListCmd.cmd"
DEATHTRANSFERLISTCMD_CMD_FIELD.number = 1
DEATHTRANSFERLISTCMD_CMD_FIELD.index = 0
DEATHTRANSFERLISTCMD_CMD_FIELD.label = 1
DEATHTRANSFERLISTCMD_CMD_FIELD.has_default_value = true
DEATHTRANSFERLISTCMD_CMD_FIELD.default_value = 9
DEATHTRANSFERLISTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DEATHTRANSFERLISTCMD_CMD_FIELD.type = 14
DEATHTRANSFERLISTCMD_CMD_FIELD.cpp_type = 8
DEATHTRANSFERLISTCMD_PARAM_FIELD.name = "param"
DEATHTRANSFERLISTCMD_PARAM_FIELD.full_name = ".Cmd.DeathTransferListCmd.param"
DEATHTRANSFERLISTCMD_PARAM_FIELD.number = 2
DEATHTRANSFERLISTCMD_PARAM_FIELD.index = 1
DEATHTRANSFERLISTCMD_PARAM_FIELD.label = 1
DEATHTRANSFERLISTCMD_PARAM_FIELD.has_default_value = true
DEATHTRANSFERLISTCMD_PARAM_FIELD.default_value = 151
DEATHTRANSFERLISTCMD_PARAM_FIELD.enum_type = USER2PARAM
DEATHTRANSFERLISTCMD_PARAM_FIELD.type = 14
DEATHTRANSFERLISTCMD_PARAM_FIELD.cpp_type = 8
DEATHTRANSFERLISTCMD_NPCID_FIELD.name = "npcId"
DEATHTRANSFERLISTCMD_NPCID_FIELD.full_name = ".Cmd.DeathTransferListCmd.npcId"
DEATHTRANSFERLISTCMD_NPCID_FIELD.number = 3
DEATHTRANSFERLISTCMD_NPCID_FIELD.index = 2
DEATHTRANSFERLISTCMD_NPCID_FIELD.label = 3
DEATHTRANSFERLISTCMD_NPCID_FIELD.has_default_value = false
DEATHTRANSFERLISTCMD_NPCID_FIELD.default_value = {}
DEATHTRANSFERLISTCMD_NPCID_FIELD.type = 13
DEATHTRANSFERLISTCMD_NPCID_FIELD.cpp_type = 3
DEATHTRANSFERLISTCMD.name = "DeathTransferListCmd"
DEATHTRANSFERLISTCMD.full_name = ".Cmd.DeathTransferListCmd"
DEATHTRANSFERLISTCMD.nested_types = {}
DEATHTRANSFERLISTCMD.enum_types = {}
DEATHTRANSFERLISTCMD.fields = {
  DEATHTRANSFERLISTCMD_CMD_FIELD,
  DEATHTRANSFERLISTCMD_PARAM_FIELD,
  DEATHTRANSFERLISTCMD_NPCID_FIELD
}
DEATHTRANSFERLISTCMD.is_extendable = false
DEATHTRANSFERLISTCMD.extensions = {}
NEWDEATHTRANSFERCMD_CMD_FIELD.name = "cmd"
NEWDEATHTRANSFERCMD_CMD_FIELD.full_name = ".Cmd.NewDeathTransferCmd.cmd"
NEWDEATHTRANSFERCMD_CMD_FIELD.number = 1
NEWDEATHTRANSFERCMD_CMD_FIELD.index = 0
NEWDEATHTRANSFERCMD_CMD_FIELD.label = 1
NEWDEATHTRANSFERCMD_CMD_FIELD.has_default_value = true
NEWDEATHTRANSFERCMD_CMD_FIELD.default_value = 9
NEWDEATHTRANSFERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWDEATHTRANSFERCMD_CMD_FIELD.type = 14
NEWDEATHTRANSFERCMD_CMD_FIELD.cpp_type = 8
NEWDEATHTRANSFERCMD_PARAM_FIELD.name = "param"
NEWDEATHTRANSFERCMD_PARAM_FIELD.full_name = ".Cmd.NewDeathTransferCmd.param"
NEWDEATHTRANSFERCMD_PARAM_FIELD.number = 2
NEWDEATHTRANSFERCMD_PARAM_FIELD.index = 1
NEWDEATHTRANSFERCMD_PARAM_FIELD.label = 1
NEWDEATHTRANSFERCMD_PARAM_FIELD.has_default_value = true
NEWDEATHTRANSFERCMD_PARAM_FIELD.default_value = 152
NEWDEATHTRANSFERCMD_PARAM_FIELD.enum_type = USER2PARAM
NEWDEATHTRANSFERCMD_PARAM_FIELD.type = 14
NEWDEATHTRANSFERCMD_PARAM_FIELD.cpp_type = 8
NEWDEATHTRANSFERCMD_NPCID_FIELD.name = "npcId"
NEWDEATHTRANSFERCMD_NPCID_FIELD.full_name = ".Cmd.NewDeathTransferCmd.npcId"
NEWDEATHTRANSFERCMD_NPCID_FIELD.number = 3
NEWDEATHTRANSFERCMD_NPCID_FIELD.index = 2
NEWDEATHTRANSFERCMD_NPCID_FIELD.label = 1
NEWDEATHTRANSFERCMD_NPCID_FIELD.has_default_value = false
NEWDEATHTRANSFERCMD_NPCID_FIELD.default_value = 0
NEWDEATHTRANSFERCMD_NPCID_FIELD.type = 13
NEWDEATHTRANSFERCMD_NPCID_FIELD.cpp_type = 3
NEWDEATHTRANSFERCMD.name = "NewDeathTransferCmd"
NEWDEATHTRANSFERCMD.full_name = ".Cmd.NewDeathTransferCmd"
NEWDEATHTRANSFERCMD.nested_types = {}
NEWDEATHTRANSFERCMD.enum_types = {}
NEWDEATHTRANSFERCMD.fields = {
  NEWDEATHTRANSFERCMD_CMD_FIELD,
  NEWDEATHTRANSFERCMD_PARAM_FIELD,
  NEWDEATHTRANSFERCMD_NPCID_FIELD
}
NEWDEATHTRANSFERCMD.is_extendable = false
NEWDEATHTRANSFERCMD.extensions = {}
USEDEATHTRANSFERCMD_CMD_FIELD.name = "cmd"
USEDEATHTRANSFERCMD_CMD_FIELD.full_name = ".Cmd.UseDeathTransferCmd.cmd"
USEDEATHTRANSFERCMD_CMD_FIELD.number = 1
USEDEATHTRANSFERCMD_CMD_FIELD.index = 0
USEDEATHTRANSFERCMD_CMD_FIELD.label = 1
USEDEATHTRANSFERCMD_CMD_FIELD.has_default_value = true
USEDEATHTRANSFERCMD_CMD_FIELD.default_value = 9
USEDEATHTRANSFERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USEDEATHTRANSFERCMD_CMD_FIELD.type = 14
USEDEATHTRANSFERCMD_CMD_FIELD.cpp_type = 8
USEDEATHTRANSFERCMD_PARAM_FIELD.name = "param"
USEDEATHTRANSFERCMD_PARAM_FIELD.full_name = ".Cmd.UseDeathTransferCmd.param"
USEDEATHTRANSFERCMD_PARAM_FIELD.number = 2
USEDEATHTRANSFERCMD_PARAM_FIELD.index = 1
USEDEATHTRANSFERCMD_PARAM_FIELD.label = 1
USEDEATHTRANSFERCMD_PARAM_FIELD.has_default_value = true
USEDEATHTRANSFERCMD_PARAM_FIELD.default_value = 153
USEDEATHTRANSFERCMD_PARAM_FIELD.enum_type = USER2PARAM
USEDEATHTRANSFERCMD_PARAM_FIELD.type = 14
USEDEATHTRANSFERCMD_PARAM_FIELD.cpp_type = 8
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.name = "fromNpcId"
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.full_name = ".Cmd.UseDeathTransferCmd.fromNpcId"
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.number = 3
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.index = 2
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.label = 1
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.has_default_value = false
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.default_value = 0
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.type = 13
USEDEATHTRANSFERCMD_FROMNPCID_FIELD.cpp_type = 3
USEDEATHTRANSFERCMD_TONPCID_FIELD.name = "toNpcId"
USEDEATHTRANSFERCMD_TONPCID_FIELD.full_name = ".Cmd.UseDeathTransferCmd.toNpcId"
USEDEATHTRANSFERCMD_TONPCID_FIELD.number = 4
USEDEATHTRANSFERCMD_TONPCID_FIELD.index = 3
USEDEATHTRANSFERCMD_TONPCID_FIELD.label = 1
USEDEATHTRANSFERCMD_TONPCID_FIELD.has_default_value = false
USEDEATHTRANSFERCMD_TONPCID_FIELD.default_value = 0
USEDEATHTRANSFERCMD_TONPCID_FIELD.type = 13
USEDEATHTRANSFERCMD_TONPCID_FIELD.cpp_type = 3
USEDEATHTRANSFERCMD.name = "UseDeathTransferCmd"
USEDEATHTRANSFERCMD.full_name = ".Cmd.UseDeathTransferCmd"
USEDEATHTRANSFERCMD.nested_types = {}
USEDEATHTRANSFERCMD.enum_types = {}
USEDEATHTRANSFERCMD.fields = {
  USEDEATHTRANSFERCMD_CMD_FIELD,
  USEDEATHTRANSFERCMD_PARAM_FIELD,
  USEDEATHTRANSFERCMD_FROMNPCID_FIELD,
  USEDEATHTRANSFERCMD_TONPCID_FIELD
}
USEDEATHTRANSFERCMD.is_extendable = false
USEDEATHTRANSFERCMD.extensions = {}
FOLLOWERUSER_CMD_FIELD.name = "cmd"
FOLLOWERUSER_CMD_FIELD.full_name = ".Cmd.FollowerUser.cmd"
FOLLOWERUSER_CMD_FIELD.number = 1
FOLLOWERUSER_CMD_FIELD.index = 0
FOLLOWERUSER_CMD_FIELD.label = 1
FOLLOWERUSER_CMD_FIELD.has_default_value = true
FOLLOWERUSER_CMD_FIELD.default_value = 9
FOLLOWERUSER_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FOLLOWERUSER_CMD_FIELD.type = 14
FOLLOWERUSER_CMD_FIELD.cpp_type = 8
FOLLOWERUSER_PARAM_FIELD.name = "param"
FOLLOWERUSER_PARAM_FIELD.full_name = ".Cmd.FollowerUser.param"
FOLLOWERUSER_PARAM_FIELD.number = 2
FOLLOWERUSER_PARAM_FIELD.index = 1
FOLLOWERUSER_PARAM_FIELD.label = 1
FOLLOWERUSER_PARAM_FIELD.has_default_value = true
FOLLOWERUSER_PARAM_FIELD.default_value = 53
FOLLOWERUSER_PARAM_FIELD.enum_type = USER2PARAM
FOLLOWERUSER_PARAM_FIELD.type = 14
FOLLOWERUSER_PARAM_FIELD.cpp_type = 8
FOLLOWERUSER_USERID_FIELD.name = "userid"
FOLLOWERUSER_USERID_FIELD.full_name = ".Cmd.FollowerUser.userid"
FOLLOWERUSER_USERID_FIELD.number = 3
FOLLOWERUSER_USERID_FIELD.index = 2
FOLLOWERUSER_USERID_FIELD.label = 1
FOLLOWERUSER_USERID_FIELD.has_default_value = true
FOLLOWERUSER_USERID_FIELD.default_value = 0
FOLLOWERUSER_USERID_FIELD.type = 4
FOLLOWERUSER_USERID_FIELD.cpp_type = 4
FOLLOWERUSER_ETYPE_FIELD.name = "eType"
FOLLOWERUSER_ETYPE_FIELD.full_name = ".Cmd.FollowerUser.eType"
FOLLOWERUSER_ETYPE_FIELD.number = 4
FOLLOWERUSER_ETYPE_FIELD.index = 3
FOLLOWERUSER_ETYPE_FIELD.label = 1
FOLLOWERUSER_ETYPE_FIELD.has_default_value = true
FOLLOWERUSER_ETYPE_FIELD.default_value = 0
FOLLOWERUSER_ETYPE_FIELD.enum_type = EFOLLOWTYPE
FOLLOWERUSER_ETYPE_FIELD.type = 14
FOLLOWERUSER_ETYPE_FIELD.cpp_type = 8
FOLLOWERUSER.name = "FollowerUser"
FOLLOWERUSER.full_name = ".Cmd.FollowerUser"
FOLLOWERUSER.nested_types = {}
FOLLOWERUSER.enum_types = {}
FOLLOWERUSER.fields = {
  FOLLOWERUSER_CMD_FIELD,
  FOLLOWERUSER_PARAM_FIELD,
  FOLLOWERUSER_USERID_FIELD,
  FOLLOWERUSER_ETYPE_FIELD
}
FOLLOWERUSER.is_extendable = false
FOLLOWERUSER.extensions = {}
BEFOLLOWUSERCMD_CMD_FIELD.name = "cmd"
BEFOLLOWUSERCMD_CMD_FIELD.full_name = ".Cmd.BeFollowUserCmd.cmd"
BEFOLLOWUSERCMD_CMD_FIELD.number = 1
BEFOLLOWUSERCMD_CMD_FIELD.index = 0
BEFOLLOWUSERCMD_CMD_FIELD.label = 1
BEFOLLOWUSERCMD_CMD_FIELD.has_default_value = true
BEFOLLOWUSERCMD_CMD_FIELD.default_value = 9
BEFOLLOWUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BEFOLLOWUSERCMD_CMD_FIELD.type = 14
BEFOLLOWUSERCMD_CMD_FIELD.cpp_type = 8
BEFOLLOWUSERCMD_PARAM_FIELD.name = "param"
BEFOLLOWUSERCMD_PARAM_FIELD.full_name = ".Cmd.BeFollowUserCmd.param"
BEFOLLOWUSERCMD_PARAM_FIELD.number = 2
BEFOLLOWUSERCMD_PARAM_FIELD.index = 1
BEFOLLOWUSERCMD_PARAM_FIELD.label = 1
BEFOLLOWUSERCMD_PARAM_FIELD.has_default_value = true
BEFOLLOWUSERCMD_PARAM_FIELD.default_value = 96
BEFOLLOWUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
BEFOLLOWUSERCMD_PARAM_FIELD.type = 14
BEFOLLOWUSERCMD_PARAM_FIELD.cpp_type = 8
BEFOLLOWUSERCMD_USERID_FIELD.name = "userid"
BEFOLLOWUSERCMD_USERID_FIELD.full_name = ".Cmd.BeFollowUserCmd.userid"
BEFOLLOWUSERCMD_USERID_FIELD.number = 3
BEFOLLOWUSERCMD_USERID_FIELD.index = 2
BEFOLLOWUSERCMD_USERID_FIELD.label = 1
BEFOLLOWUSERCMD_USERID_FIELD.has_default_value = true
BEFOLLOWUSERCMD_USERID_FIELD.default_value = 0
BEFOLLOWUSERCMD_USERID_FIELD.type = 4
BEFOLLOWUSERCMD_USERID_FIELD.cpp_type = 4
BEFOLLOWUSERCMD_ETYPE_FIELD.name = "eType"
BEFOLLOWUSERCMD_ETYPE_FIELD.full_name = ".Cmd.BeFollowUserCmd.eType"
BEFOLLOWUSERCMD_ETYPE_FIELD.number = 4
BEFOLLOWUSERCMD_ETYPE_FIELD.index = 3
BEFOLLOWUSERCMD_ETYPE_FIELD.label = 1
BEFOLLOWUSERCMD_ETYPE_FIELD.has_default_value = true
BEFOLLOWUSERCMD_ETYPE_FIELD.default_value = 0
BEFOLLOWUSERCMD_ETYPE_FIELD.enum_type = EFOLLOWTYPE
BEFOLLOWUSERCMD_ETYPE_FIELD.type = 14
BEFOLLOWUSERCMD_ETYPE_FIELD.cpp_type = 8
BEFOLLOWUSERCMD.name = "BeFollowUserCmd"
BEFOLLOWUSERCMD.full_name = ".Cmd.BeFollowUserCmd"
BEFOLLOWUSERCMD.nested_types = {}
BEFOLLOWUSERCMD.enum_types = {}
BEFOLLOWUSERCMD.fields = {
  BEFOLLOWUSERCMD_CMD_FIELD,
  BEFOLLOWUSERCMD_PARAM_FIELD,
  BEFOLLOWUSERCMD_USERID_FIELD,
  BEFOLLOWUSERCMD_ETYPE_FIELD
}
BEFOLLOWUSERCMD.is_extendable = false
BEFOLLOWUSERCMD.extensions = {}
LABORATORYUSERCMD_CMD_FIELD.name = "cmd"
LABORATORYUSERCMD_CMD_FIELD.full_name = ".Cmd.LaboratoryUserCmd.cmd"
LABORATORYUSERCMD_CMD_FIELD.number = 1
LABORATORYUSERCMD_CMD_FIELD.index = 0
LABORATORYUSERCMD_CMD_FIELD.label = 1
LABORATORYUSERCMD_CMD_FIELD.has_default_value = true
LABORATORYUSERCMD_CMD_FIELD.default_value = 9
LABORATORYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LABORATORYUSERCMD_CMD_FIELD.type = 14
LABORATORYUSERCMD_CMD_FIELD.cpp_type = 8
LABORATORYUSERCMD_PARAM_FIELD.name = "param"
LABORATORYUSERCMD_PARAM_FIELD.full_name = ".Cmd.LaboratoryUserCmd.param"
LABORATORYUSERCMD_PARAM_FIELD.number = 2
LABORATORYUSERCMD_PARAM_FIELD.index = 1
LABORATORYUSERCMD_PARAM_FIELD.label = 1
LABORATORYUSERCMD_PARAM_FIELD.has_default_value = true
LABORATORYUSERCMD_PARAM_FIELD.default_value = 54
LABORATORYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
LABORATORYUSERCMD_PARAM_FIELD.type = 14
LABORATORYUSERCMD_PARAM_FIELD.cpp_type = 8
LABORATORYUSERCMD_ROUND_FIELD.name = "round"
LABORATORYUSERCMD_ROUND_FIELD.full_name = ".Cmd.LaboratoryUserCmd.round"
LABORATORYUSERCMD_ROUND_FIELD.number = 3
LABORATORYUSERCMD_ROUND_FIELD.index = 2
LABORATORYUSERCMD_ROUND_FIELD.label = 1
LABORATORYUSERCMD_ROUND_FIELD.has_default_value = true
LABORATORYUSERCMD_ROUND_FIELD.default_value = 0
LABORATORYUSERCMD_ROUND_FIELD.type = 13
LABORATORYUSERCMD_ROUND_FIELD.cpp_type = 3
LABORATORYUSERCMD_CURSCORE_FIELD.name = "curscore"
LABORATORYUSERCMD_CURSCORE_FIELD.full_name = ".Cmd.LaboratoryUserCmd.curscore"
LABORATORYUSERCMD_CURSCORE_FIELD.number = 4
LABORATORYUSERCMD_CURSCORE_FIELD.index = 3
LABORATORYUSERCMD_CURSCORE_FIELD.label = 1
LABORATORYUSERCMD_CURSCORE_FIELD.has_default_value = true
LABORATORYUSERCMD_CURSCORE_FIELD.default_value = 0
LABORATORYUSERCMD_CURSCORE_FIELD.type = 13
LABORATORYUSERCMD_CURSCORE_FIELD.cpp_type = 3
LABORATORYUSERCMD_MAXSCORE_FIELD.name = "maxscore"
LABORATORYUSERCMD_MAXSCORE_FIELD.full_name = ".Cmd.LaboratoryUserCmd.maxscore"
LABORATORYUSERCMD_MAXSCORE_FIELD.number = 5
LABORATORYUSERCMD_MAXSCORE_FIELD.index = 4
LABORATORYUSERCMD_MAXSCORE_FIELD.label = 1
LABORATORYUSERCMD_MAXSCORE_FIELD.has_default_value = true
LABORATORYUSERCMD_MAXSCORE_FIELD.default_value = 0
LABORATORYUSERCMD_MAXSCORE_FIELD.type = 13
LABORATORYUSERCMD_MAXSCORE_FIELD.cpp_type = 3
LABORATORYUSERCMD.name = "LaboratoryUserCmd"
LABORATORYUSERCMD.full_name = ".Cmd.LaboratoryUserCmd"
LABORATORYUSERCMD.nested_types = {}
LABORATORYUSERCMD.enum_types = {}
LABORATORYUSERCMD.fields = {
  LABORATORYUSERCMD_CMD_FIELD,
  LABORATORYUSERCMD_PARAM_FIELD,
  LABORATORYUSERCMD_ROUND_FIELD,
  LABORATORYUSERCMD_CURSCORE_FIELD,
  LABORATORYUSERCMD_MAXSCORE_FIELD
}
LABORATORYUSERCMD.is_extendable = false
LABORATORYUSERCMD.extensions = {}
GOTOLABORATORYUSERCMD_CMD_FIELD.name = "cmd"
GOTOLABORATORYUSERCMD_CMD_FIELD.full_name = ".Cmd.GotoLaboratoryUserCmd.cmd"
GOTOLABORATORYUSERCMD_CMD_FIELD.number = 1
GOTOLABORATORYUSERCMD_CMD_FIELD.index = 0
GOTOLABORATORYUSERCMD_CMD_FIELD.label = 1
GOTOLABORATORYUSERCMD_CMD_FIELD.has_default_value = true
GOTOLABORATORYUSERCMD_CMD_FIELD.default_value = 9
GOTOLABORATORYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GOTOLABORATORYUSERCMD_CMD_FIELD.type = 14
GOTOLABORATORYUSERCMD_CMD_FIELD.cpp_type = 8
GOTOLABORATORYUSERCMD_PARAM_FIELD.name = "param"
GOTOLABORATORYUSERCMD_PARAM_FIELD.full_name = ".Cmd.GotoLaboratoryUserCmd.param"
GOTOLABORATORYUSERCMD_PARAM_FIELD.number = 2
GOTOLABORATORYUSERCMD_PARAM_FIELD.index = 1
GOTOLABORATORYUSERCMD_PARAM_FIELD.label = 1
GOTOLABORATORYUSERCMD_PARAM_FIELD.has_default_value = true
GOTOLABORATORYUSERCMD_PARAM_FIELD.default_value = 57
GOTOLABORATORYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
GOTOLABORATORYUSERCMD_PARAM_FIELD.type = 14
GOTOLABORATORYUSERCMD_PARAM_FIELD.cpp_type = 8
GOTOLABORATORYUSERCMD_FUNID_FIELD.name = "funid"
GOTOLABORATORYUSERCMD_FUNID_FIELD.full_name = ".Cmd.GotoLaboratoryUserCmd.funid"
GOTOLABORATORYUSERCMD_FUNID_FIELD.number = 3
GOTOLABORATORYUSERCMD_FUNID_FIELD.index = 2
GOTOLABORATORYUSERCMD_FUNID_FIELD.label = 1
GOTOLABORATORYUSERCMD_FUNID_FIELD.has_default_value = false
GOTOLABORATORYUSERCMD_FUNID_FIELD.default_value = 0
GOTOLABORATORYUSERCMD_FUNID_FIELD.type = 13
GOTOLABORATORYUSERCMD_FUNID_FIELD.cpp_type = 3
GOTOLABORATORYUSERCMD.name = "GotoLaboratoryUserCmd"
GOTOLABORATORYUSERCMD.full_name = ".Cmd.GotoLaboratoryUserCmd"
GOTOLABORATORYUSERCMD.nested_types = {}
GOTOLABORATORYUSERCMD.enum_types = {}
GOTOLABORATORYUSERCMD.fields = {
  GOTOLABORATORYUSERCMD_CMD_FIELD,
  GOTOLABORATORYUSERCMD_PARAM_FIELD,
  GOTOLABORATORYUSERCMD_FUNID_FIELD
}
GOTOLABORATORYUSERCMD.is_extendable = false
GOTOLABORATORYUSERCMD.extensions = {}
EXCHANGEPROFESSION_CMD_FIELD.name = "cmd"
EXCHANGEPROFESSION_CMD_FIELD.full_name = ".Cmd.ExchangeProfession.cmd"
EXCHANGEPROFESSION_CMD_FIELD.number = 1
EXCHANGEPROFESSION_CMD_FIELD.index = 0
EXCHANGEPROFESSION_CMD_FIELD.label = 1
EXCHANGEPROFESSION_CMD_FIELD.has_default_value = true
EXCHANGEPROFESSION_CMD_FIELD.default_value = 9
EXCHANGEPROFESSION_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EXCHANGEPROFESSION_CMD_FIELD.type = 14
EXCHANGEPROFESSION_CMD_FIELD.cpp_type = 8
EXCHANGEPROFESSION_PARAM_FIELD.name = "param"
EXCHANGEPROFESSION_PARAM_FIELD.full_name = ".Cmd.ExchangeProfession.param"
EXCHANGEPROFESSION_PARAM_FIELD.number = 2
EXCHANGEPROFESSION_PARAM_FIELD.index = 1
EXCHANGEPROFESSION_PARAM_FIELD.label = 1
EXCHANGEPROFESSION_PARAM_FIELD.has_default_value = true
EXCHANGEPROFESSION_PARAM_FIELD.default_value = 56
EXCHANGEPROFESSION_PARAM_FIELD.enum_type = USER2PARAM
EXCHANGEPROFESSION_PARAM_FIELD.type = 14
EXCHANGEPROFESSION_PARAM_FIELD.cpp_type = 8
EXCHANGEPROFESSION_GUID_FIELD.name = "guid"
EXCHANGEPROFESSION_GUID_FIELD.full_name = ".Cmd.ExchangeProfession.guid"
EXCHANGEPROFESSION_GUID_FIELD.number = 3
EXCHANGEPROFESSION_GUID_FIELD.index = 2
EXCHANGEPROFESSION_GUID_FIELD.label = 1
EXCHANGEPROFESSION_GUID_FIELD.has_default_value = true
EXCHANGEPROFESSION_GUID_FIELD.default_value = 0
EXCHANGEPROFESSION_GUID_FIELD.type = 4
EXCHANGEPROFESSION_GUID_FIELD.cpp_type = 4
EXCHANGEPROFESSION_DATAS_FIELD.name = "datas"
EXCHANGEPROFESSION_DATAS_FIELD.full_name = ".Cmd.ExchangeProfession.datas"
EXCHANGEPROFESSION_DATAS_FIELD.number = 4
EXCHANGEPROFESSION_DATAS_FIELD.index = 3
EXCHANGEPROFESSION_DATAS_FIELD.label = 3
EXCHANGEPROFESSION_DATAS_FIELD.has_default_value = false
EXCHANGEPROFESSION_DATAS_FIELD.default_value = {}
EXCHANGEPROFESSION_DATAS_FIELD.message_type = SceneUser_pb.USERDATA
EXCHANGEPROFESSION_DATAS_FIELD.type = 11
EXCHANGEPROFESSION_DATAS_FIELD.cpp_type = 10
EXCHANGEPROFESSION_ATTRS_FIELD.name = "attrs"
EXCHANGEPROFESSION_ATTRS_FIELD.full_name = ".Cmd.ExchangeProfession.attrs"
EXCHANGEPROFESSION_ATTRS_FIELD.number = 5
EXCHANGEPROFESSION_ATTRS_FIELD.index = 4
EXCHANGEPROFESSION_ATTRS_FIELD.label = 3
EXCHANGEPROFESSION_ATTRS_FIELD.has_default_value = false
EXCHANGEPROFESSION_ATTRS_FIELD.default_value = {}
EXCHANGEPROFESSION_ATTRS_FIELD.message_type = SceneUser_pb.USERATTR
EXCHANGEPROFESSION_ATTRS_FIELD.type = 11
EXCHANGEPROFESSION_ATTRS_FIELD.cpp_type = 10
EXCHANGEPROFESSION_POINTATTRS_FIELD.name = "pointattrs"
EXCHANGEPROFESSION_POINTATTRS_FIELD.full_name = ".Cmd.ExchangeProfession.pointattrs"
EXCHANGEPROFESSION_POINTATTRS_FIELD.number = 6
EXCHANGEPROFESSION_POINTATTRS_FIELD.index = 5
EXCHANGEPROFESSION_POINTATTRS_FIELD.label = 3
EXCHANGEPROFESSION_POINTATTRS_FIELD.has_default_value = false
EXCHANGEPROFESSION_POINTATTRS_FIELD.default_value = {}
EXCHANGEPROFESSION_POINTATTRS_FIELD.message_type = SceneUser_pb.USERATTR
EXCHANGEPROFESSION_POINTATTRS_FIELD.type = 11
EXCHANGEPROFESSION_POINTATTRS_FIELD.cpp_type = 10
EXCHANGEPROFESSION_TYPE_FIELD.name = "type"
EXCHANGEPROFESSION_TYPE_FIELD.full_name = ".Cmd.ExchangeProfession.type"
EXCHANGEPROFESSION_TYPE_FIELD.number = 7
EXCHANGEPROFESSION_TYPE_FIELD.index = 6
EXCHANGEPROFESSION_TYPE_FIELD.label = 1
EXCHANGEPROFESSION_TYPE_FIELD.has_default_value = true
EXCHANGEPROFESSION_TYPE_FIELD.default_value = 0
EXCHANGEPROFESSION_TYPE_FIELD.enum_type = EPROFRESSIONDATATYPE
EXCHANGEPROFESSION_TYPE_FIELD.type = 14
EXCHANGEPROFESSION_TYPE_FIELD.cpp_type = 8
EXCHANGEPROFESSION.name = "ExchangeProfession"
EXCHANGEPROFESSION.full_name = ".Cmd.ExchangeProfession"
EXCHANGEPROFESSION.nested_types = {}
EXCHANGEPROFESSION.enum_types = {}
EXCHANGEPROFESSION.fields = {
  EXCHANGEPROFESSION_CMD_FIELD,
  EXCHANGEPROFESSION_PARAM_FIELD,
  EXCHANGEPROFESSION_GUID_FIELD,
  EXCHANGEPROFESSION_DATAS_FIELD,
  EXCHANGEPROFESSION_ATTRS_FIELD,
  EXCHANGEPROFESSION_POINTATTRS_FIELD,
  EXCHANGEPROFESSION_TYPE_FIELD
}
EXCHANGEPROFESSION.is_extendable = false
EXCHANGEPROFESSION.extensions = {}
SCENERY_SCENERYID_FIELD.name = "sceneryid"
SCENERY_SCENERYID_FIELD.full_name = ".Cmd.Scenery.sceneryid"
SCENERY_SCENERYID_FIELD.number = 1
SCENERY_SCENERYID_FIELD.index = 0
SCENERY_SCENERYID_FIELD.label = 1
SCENERY_SCENERYID_FIELD.has_default_value = true
SCENERY_SCENERYID_FIELD.default_value = 0
SCENERY_SCENERYID_FIELD.type = 13
SCENERY_SCENERYID_FIELD.cpp_type = 3
SCENERY_ANGLEZ_FIELD.name = "anglez"
SCENERY_ANGLEZ_FIELD.full_name = ".Cmd.Scenery.anglez"
SCENERY_ANGLEZ_FIELD.number = 2
SCENERY_ANGLEZ_FIELD.index = 1
SCENERY_ANGLEZ_FIELD.label = 1
SCENERY_ANGLEZ_FIELD.has_default_value = true
SCENERY_ANGLEZ_FIELD.default_value = 0
SCENERY_ANGLEZ_FIELD.type = 13
SCENERY_ANGLEZ_FIELD.cpp_type = 3
SCENERY_CHARID_FIELD.name = "charid"
SCENERY_CHARID_FIELD.full_name = ".Cmd.Scenery.charid"
SCENERY_CHARID_FIELD.number = 3
SCENERY_CHARID_FIELD.index = 2
SCENERY_CHARID_FIELD.label = 1
SCENERY_CHARID_FIELD.has_default_value = true
SCENERY_CHARID_FIELD.default_value = 0
SCENERY_CHARID_FIELD.type = 4
SCENERY_CHARID_FIELD.cpp_type = 4
SCENERY.name = "Scenery"
SCENERY.full_name = ".Cmd.Scenery"
SCENERY.nested_types = {}
SCENERY.enum_types = {}
SCENERY.fields = {
  SCENERY_SCENERYID_FIELD,
  SCENERY_ANGLEZ_FIELD,
  SCENERY_CHARID_FIELD
}
SCENERY.is_extendable = false
SCENERY.extensions = {}
SCENERYUSERCMD_CMD_FIELD.name = "cmd"
SCENERYUSERCMD_CMD_FIELD.full_name = ".Cmd.SceneryUserCmd.cmd"
SCENERYUSERCMD_CMD_FIELD.number = 1
SCENERYUSERCMD_CMD_FIELD.index = 0
SCENERYUSERCMD_CMD_FIELD.label = 1
SCENERYUSERCMD_CMD_FIELD.has_default_value = true
SCENERYUSERCMD_CMD_FIELD.default_value = 9
SCENERYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SCENERYUSERCMD_CMD_FIELD.type = 14
SCENERYUSERCMD_CMD_FIELD.cpp_type = 8
SCENERYUSERCMD_PARAM_FIELD.name = "param"
SCENERYUSERCMD_PARAM_FIELD.full_name = ".Cmd.SceneryUserCmd.param"
SCENERYUSERCMD_PARAM_FIELD.number = 2
SCENERYUSERCMD_PARAM_FIELD.index = 1
SCENERYUSERCMD_PARAM_FIELD.label = 1
SCENERYUSERCMD_PARAM_FIELD.has_default_value = true
SCENERYUSERCMD_PARAM_FIELD.default_value = 58
SCENERYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SCENERYUSERCMD_PARAM_FIELD.type = 14
SCENERYUSERCMD_PARAM_FIELD.cpp_type = 8
SCENERYUSERCMD_MAPID_FIELD.name = "mapid"
SCENERYUSERCMD_MAPID_FIELD.full_name = ".Cmd.SceneryUserCmd.mapid"
SCENERYUSERCMD_MAPID_FIELD.number = 3
SCENERYUSERCMD_MAPID_FIELD.index = 2
SCENERYUSERCMD_MAPID_FIELD.label = 1
SCENERYUSERCMD_MAPID_FIELD.has_default_value = true
SCENERYUSERCMD_MAPID_FIELD.default_value = 0
SCENERYUSERCMD_MAPID_FIELD.type = 13
SCENERYUSERCMD_MAPID_FIELD.cpp_type = 3
SCENERYUSERCMD_SCENERYS_FIELD.name = "scenerys"
SCENERYUSERCMD_SCENERYS_FIELD.full_name = ".Cmd.SceneryUserCmd.scenerys"
SCENERYUSERCMD_SCENERYS_FIELD.number = 4
SCENERYUSERCMD_SCENERYS_FIELD.index = 3
SCENERYUSERCMD_SCENERYS_FIELD.label = 3
SCENERYUSERCMD_SCENERYS_FIELD.has_default_value = false
SCENERYUSERCMD_SCENERYS_FIELD.default_value = {}
SCENERYUSERCMD_SCENERYS_FIELD.message_type = SCENERY
SCENERYUSERCMD_SCENERYS_FIELD.type = 11
SCENERYUSERCMD_SCENERYS_FIELD.cpp_type = 10
SCENERYUSERCMD.name = "SceneryUserCmd"
SCENERYUSERCMD.full_name = ".Cmd.SceneryUserCmd"
SCENERYUSERCMD.nested_types = {}
SCENERYUSERCMD.enum_types = {}
SCENERYUSERCMD.fields = {
  SCENERYUSERCMD_CMD_FIELD,
  SCENERYUSERCMD_PARAM_FIELD,
  SCENERYUSERCMD_MAPID_FIELD,
  SCENERYUSERCMD_SCENERYS_FIELD
}
SCENERYUSERCMD.is_extendable = false
SCENERYUSERCMD.extensions = {}
GOMAPQUESTUSERCMD_CMD_FIELD.name = "cmd"
GOMAPQUESTUSERCMD_CMD_FIELD.full_name = ".Cmd.GoMapQuestUserCmd.cmd"
GOMAPQUESTUSERCMD_CMD_FIELD.number = 1
GOMAPQUESTUSERCMD_CMD_FIELD.index = 0
GOMAPQUESTUSERCMD_CMD_FIELD.label = 1
GOMAPQUESTUSERCMD_CMD_FIELD.has_default_value = true
GOMAPQUESTUSERCMD_CMD_FIELD.default_value = 9
GOMAPQUESTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GOMAPQUESTUSERCMD_CMD_FIELD.type = 14
GOMAPQUESTUSERCMD_CMD_FIELD.cpp_type = 8
GOMAPQUESTUSERCMD_PARAM_FIELD.name = "param"
GOMAPQUESTUSERCMD_PARAM_FIELD.full_name = ".Cmd.GoMapQuestUserCmd.param"
GOMAPQUESTUSERCMD_PARAM_FIELD.number = 2
GOMAPQUESTUSERCMD_PARAM_FIELD.index = 1
GOMAPQUESTUSERCMD_PARAM_FIELD.label = 1
GOMAPQUESTUSERCMD_PARAM_FIELD.has_default_value = true
GOMAPQUESTUSERCMD_PARAM_FIELD.default_value = 59
GOMAPQUESTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
GOMAPQUESTUSERCMD_PARAM_FIELD.type = 14
GOMAPQUESTUSERCMD_PARAM_FIELD.cpp_type = 8
GOMAPQUESTUSERCMD_QUESTID_FIELD.name = "questid"
GOMAPQUESTUSERCMD_QUESTID_FIELD.full_name = ".Cmd.GoMapQuestUserCmd.questid"
GOMAPQUESTUSERCMD_QUESTID_FIELD.number = 3
GOMAPQUESTUSERCMD_QUESTID_FIELD.index = 2
GOMAPQUESTUSERCMD_QUESTID_FIELD.label = 1
GOMAPQUESTUSERCMD_QUESTID_FIELD.has_default_value = true
GOMAPQUESTUSERCMD_QUESTID_FIELD.default_value = 0
GOMAPQUESTUSERCMD_QUESTID_FIELD.type = 13
GOMAPQUESTUSERCMD_QUESTID_FIELD.cpp_type = 3
GOMAPQUESTUSERCMD.name = "GoMapQuestUserCmd"
GOMAPQUESTUSERCMD.full_name = ".Cmd.GoMapQuestUserCmd"
GOMAPQUESTUSERCMD.nested_types = {}
GOMAPQUESTUSERCMD.enum_types = {}
GOMAPQUESTUSERCMD.fields = {
  GOMAPQUESTUSERCMD_CMD_FIELD,
  GOMAPQUESTUSERCMD_PARAM_FIELD,
  GOMAPQUESTUSERCMD_QUESTID_FIELD
}
GOMAPQUESTUSERCMD.is_extendable = false
GOMAPQUESTUSERCMD.extensions = {}
GOMAPFOLLOWUSERCMD_CMD_FIELD.name = "cmd"
GOMAPFOLLOWUSERCMD_CMD_FIELD.full_name = ".Cmd.GoMapFollowUserCmd.cmd"
GOMAPFOLLOWUSERCMD_CMD_FIELD.number = 1
GOMAPFOLLOWUSERCMD_CMD_FIELD.index = 0
GOMAPFOLLOWUSERCMD_CMD_FIELD.label = 1
GOMAPFOLLOWUSERCMD_CMD_FIELD.has_default_value = true
GOMAPFOLLOWUSERCMD_CMD_FIELD.default_value = 9
GOMAPFOLLOWUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GOMAPFOLLOWUSERCMD_CMD_FIELD.type = 14
GOMAPFOLLOWUSERCMD_CMD_FIELD.cpp_type = 8
GOMAPFOLLOWUSERCMD_PARAM_FIELD.name = "param"
GOMAPFOLLOWUSERCMD_PARAM_FIELD.full_name = ".Cmd.GoMapFollowUserCmd.param"
GOMAPFOLLOWUSERCMD_PARAM_FIELD.number = 2
GOMAPFOLLOWUSERCMD_PARAM_FIELD.index = 1
GOMAPFOLLOWUSERCMD_PARAM_FIELD.label = 1
GOMAPFOLLOWUSERCMD_PARAM_FIELD.has_default_value = true
GOMAPFOLLOWUSERCMD_PARAM_FIELD.default_value = 60
GOMAPFOLLOWUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
GOMAPFOLLOWUSERCMD_PARAM_FIELD.type = 14
GOMAPFOLLOWUSERCMD_PARAM_FIELD.cpp_type = 8
GOMAPFOLLOWUSERCMD_MAPID_FIELD.name = "mapid"
GOMAPFOLLOWUSERCMD_MAPID_FIELD.full_name = ".Cmd.GoMapFollowUserCmd.mapid"
GOMAPFOLLOWUSERCMD_MAPID_FIELD.number = 3
GOMAPFOLLOWUSERCMD_MAPID_FIELD.index = 2
GOMAPFOLLOWUSERCMD_MAPID_FIELD.label = 1
GOMAPFOLLOWUSERCMD_MAPID_FIELD.has_default_value = true
GOMAPFOLLOWUSERCMD_MAPID_FIELD.default_value = 0
GOMAPFOLLOWUSERCMD_MAPID_FIELD.type = 13
GOMAPFOLLOWUSERCMD_MAPID_FIELD.cpp_type = 3
GOMAPFOLLOWUSERCMD_CHARID_FIELD.name = "charid"
GOMAPFOLLOWUSERCMD_CHARID_FIELD.full_name = ".Cmd.GoMapFollowUserCmd.charid"
GOMAPFOLLOWUSERCMD_CHARID_FIELD.number = 4
GOMAPFOLLOWUSERCMD_CHARID_FIELD.index = 3
GOMAPFOLLOWUSERCMD_CHARID_FIELD.label = 1
GOMAPFOLLOWUSERCMD_CHARID_FIELD.has_default_value = true
GOMAPFOLLOWUSERCMD_CHARID_FIELD.default_value = 0
GOMAPFOLLOWUSERCMD_CHARID_FIELD.type = 4
GOMAPFOLLOWUSERCMD_CHARID_FIELD.cpp_type = 4
GOMAPFOLLOWUSERCMD.name = "GoMapFollowUserCmd"
GOMAPFOLLOWUSERCMD.full_name = ".Cmd.GoMapFollowUserCmd"
GOMAPFOLLOWUSERCMD.nested_types = {}
GOMAPFOLLOWUSERCMD.enum_types = {}
GOMAPFOLLOWUSERCMD.fields = {
  GOMAPFOLLOWUSERCMD_CMD_FIELD,
  GOMAPFOLLOWUSERCMD_PARAM_FIELD,
  GOMAPFOLLOWUSERCMD_MAPID_FIELD,
  GOMAPFOLLOWUSERCMD_CHARID_FIELD
}
GOMAPFOLLOWUSERCMD.is_extendable = false
GOMAPFOLLOWUSERCMD.extensions = {}
USERAUTOHITCMD_CMD_FIELD.name = "cmd"
USERAUTOHITCMD_CMD_FIELD.full_name = ".Cmd.UserAutoHitCmd.cmd"
USERAUTOHITCMD_CMD_FIELD.number = 1
USERAUTOHITCMD_CMD_FIELD.index = 0
USERAUTOHITCMD_CMD_FIELD.label = 1
USERAUTOHITCMD_CMD_FIELD.has_default_value = true
USERAUTOHITCMD_CMD_FIELD.default_value = 9
USERAUTOHITCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USERAUTOHITCMD_CMD_FIELD.type = 14
USERAUTOHITCMD_CMD_FIELD.cpp_type = 8
USERAUTOHITCMD_PARAM_FIELD.name = "param"
USERAUTOHITCMD_PARAM_FIELD.full_name = ".Cmd.UserAutoHitCmd.param"
USERAUTOHITCMD_PARAM_FIELD.number = 2
USERAUTOHITCMD_PARAM_FIELD.index = 1
USERAUTOHITCMD_PARAM_FIELD.label = 1
USERAUTOHITCMD_PARAM_FIELD.has_default_value = true
USERAUTOHITCMD_PARAM_FIELD.default_value = 61
USERAUTOHITCMD_PARAM_FIELD.enum_type = USER2PARAM
USERAUTOHITCMD_PARAM_FIELD.type = 14
USERAUTOHITCMD_PARAM_FIELD.cpp_type = 8
USERAUTOHITCMD_CHARID_FIELD.name = "charid"
USERAUTOHITCMD_CHARID_FIELD.full_name = ".Cmd.UserAutoHitCmd.charid"
USERAUTOHITCMD_CHARID_FIELD.number = 3
USERAUTOHITCMD_CHARID_FIELD.index = 2
USERAUTOHITCMD_CHARID_FIELD.label = 1
USERAUTOHITCMD_CHARID_FIELD.has_default_value = true
USERAUTOHITCMD_CHARID_FIELD.default_value = 0
USERAUTOHITCMD_CHARID_FIELD.type = 4
USERAUTOHITCMD_CHARID_FIELD.cpp_type = 4
USERAUTOHITCMD.name = "UserAutoHitCmd"
USERAUTOHITCMD.full_name = ".Cmd.UserAutoHitCmd"
USERAUTOHITCMD.nested_types = {}
USERAUTOHITCMD.enum_types = {}
USERAUTOHITCMD.fields = {
  USERAUTOHITCMD_CMD_FIELD,
  USERAUTOHITCMD_PARAM_FIELD,
  USERAUTOHITCMD_CHARID_FIELD
}
USERAUTOHITCMD.is_extendable = false
USERAUTOHITCMD.extensions = {}
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.name = "cmd"
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.full_name = ".Cmd.UploadSceneryPhotoUserCmd.cmd"
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.number = 1
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.index = 0
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.label = 1
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.has_default_value = true
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.default_value = 9
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.type = 14
UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD.cpp_type = 8
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.name = "param"
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.full_name = ".Cmd.UploadSceneryPhotoUserCmd.param"
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.number = 2
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.index = 1
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.label = 1
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.has_default_value = true
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.default_value = 62
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.type = 14
UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.cpp_type = 8
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.name = "type"
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.full_name = ".Cmd.UploadSceneryPhotoUserCmd.type"
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.number = 3
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.index = 2
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.label = 1
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.has_default_value = true
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.default_value = 1
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.enum_type = EALBUMTYPE
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.type = 14
UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD.cpp_type = 8
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.name = "sceneryid"
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.full_name = ".Cmd.UploadSceneryPhotoUserCmd.sceneryid"
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.number = 4
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.index = 3
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.label = 1
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.has_default_value = false
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.default_value = 0
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.type = 13
UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD.cpp_type = 3
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.name = "policy"
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.full_name = ".Cmd.UploadSceneryPhotoUserCmd.policy"
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.number = 5
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.index = 4
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.label = 1
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.has_default_value = false
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.default_value = ""
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.type = 9
UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD.cpp_type = 9
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.name = "signature"
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.full_name = ".Cmd.UploadSceneryPhotoUserCmd.signature"
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.number = 6
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.index = 5
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.label = 1
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.has_default_value = false
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.default_value = ""
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.type = 9
UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD.cpp_type = 9
UPLOADSCENERYPHOTOUSERCMD.name = "UploadSceneryPhotoUserCmd"
UPLOADSCENERYPHOTOUSERCMD.full_name = ".Cmd.UploadSceneryPhotoUserCmd"
UPLOADSCENERYPHOTOUSERCMD.nested_types = {}
UPLOADSCENERYPHOTOUSERCMD.enum_types = {}
UPLOADSCENERYPHOTOUSERCMD.fields = {
  UPLOADSCENERYPHOTOUSERCMD_CMD_FIELD,
  UPLOADSCENERYPHOTOUSERCMD_PARAM_FIELD,
  UPLOADSCENERYPHOTOUSERCMD_TYPE_FIELD,
  UPLOADSCENERYPHOTOUSERCMD_SCENERYID_FIELD,
  UPLOADSCENERYPHOTOUSERCMD_POLICY_FIELD,
  UPLOADSCENERYPHOTOUSERCMD_SIGNATURE_FIELD
}
UPLOADSCENERYPHOTOUSERCMD.is_extendable = false
UPLOADSCENERYPHOTOUSERCMD.extensions = {}
UPYUNURL_TYPE_FIELD.name = "type"
UPYUNURL_TYPE_FIELD.full_name = ".Cmd.UpyunUrl.type"
UPYUNURL_TYPE_FIELD.number = 1
UPYUNURL_TYPE_FIELD.index = 0
UPYUNURL_TYPE_FIELD.label = 1
UPYUNURL_TYPE_FIELD.has_default_value = true
UPYUNURL_TYPE_FIELD.default_value = 1
UPYUNURL_TYPE_FIELD.enum_type = EALBUMTYPE
UPYUNURL_TYPE_FIELD.type = 14
UPYUNURL_TYPE_FIELD.cpp_type = 8
UPYUNURL_CHAR_URL_FIELD.name = "char_url"
UPYUNURL_CHAR_URL_FIELD.full_name = ".Cmd.UpyunUrl.char_url"
UPYUNURL_CHAR_URL_FIELD.number = 2
UPYUNURL_CHAR_URL_FIELD.index = 1
UPYUNURL_CHAR_URL_FIELD.label = 1
UPYUNURL_CHAR_URL_FIELD.has_default_value = false
UPYUNURL_CHAR_URL_FIELD.default_value = ""
UPYUNURL_CHAR_URL_FIELD.type = 9
UPYUNURL_CHAR_URL_FIELD.cpp_type = 9
UPYUNURL_ACC_URL_FIELD.name = "acc_url"
UPYUNURL_ACC_URL_FIELD.full_name = ".Cmd.UpyunUrl.acc_url"
UPYUNURL_ACC_URL_FIELD.number = 3
UPYUNURL_ACC_URL_FIELD.index = 2
UPYUNURL_ACC_URL_FIELD.label = 1
UPYUNURL_ACC_URL_FIELD.has_default_value = false
UPYUNURL_ACC_URL_FIELD.default_value = ""
UPYUNURL_ACC_URL_FIELD.type = 9
UPYUNURL_ACC_URL_FIELD.cpp_type = 9
UPYUNURL.name = "UpyunUrl"
UPYUNURL.full_name = ".Cmd.UpyunUrl"
UPYUNURL.nested_types = {}
UPYUNURL.enum_types = {}
UPYUNURL.fields = {
  UPYUNURL_TYPE_FIELD,
  UPYUNURL_CHAR_URL_FIELD,
  UPYUNURL_ACC_URL_FIELD
}
UPYUNURL.is_extendable = false
UPYUNURL.extensions = {}
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.name = "cmd"
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.full_name = ".Cmd.DownloadSceneryPhotoUserCmd.cmd"
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.number = 1
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.index = 0
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.label = 1
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.has_default_value = true
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.default_value = 9
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.type = 14
DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD.cpp_type = 8
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.name = "param"
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.full_name = ".Cmd.DownloadSceneryPhotoUserCmd.param"
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.number = 2
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.index = 1
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.label = 1
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.has_default_value = true
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.default_value = 80
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.type = 14
DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD.cpp_type = 8
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.name = "urls"
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.full_name = ".Cmd.DownloadSceneryPhotoUserCmd.urls"
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.number = 3
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.index = 2
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.label = 3
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.has_default_value = false
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.default_value = {}
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.message_type = UPYUNURL
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.type = 11
DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD.cpp_type = 10
DOWNLOADSCENERYPHOTOUSERCMD.name = "DownloadSceneryPhotoUserCmd"
DOWNLOADSCENERYPHOTOUSERCMD.full_name = ".Cmd.DownloadSceneryPhotoUserCmd"
DOWNLOADSCENERYPHOTOUSERCMD.nested_types = {}
DOWNLOADSCENERYPHOTOUSERCMD.enum_types = {}
DOWNLOADSCENERYPHOTOUSERCMD.fields = {
  DOWNLOADSCENERYPHOTOUSERCMD_CMD_FIELD,
  DOWNLOADSCENERYPHOTOUSERCMD_PARAM_FIELD,
  DOWNLOADSCENERYPHOTOUSERCMD_URLS_FIELD
}
DOWNLOADSCENERYPHOTOUSERCMD.is_extendable = false
DOWNLOADSCENERYPHOTOUSERCMD.extensions = {}
QUERYMAPAREA_CMD_FIELD.name = "cmd"
QUERYMAPAREA_CMD_FIELD.full_name = ".Cmd.QueryMapArea.cmd"
QUERYMAPAREA_CMD_FIELD.number = 1
QUERYMAPAREA_CMD_FIELD.index = 0
QUERYMAPAREA_CMD_FIELD.label = 1
QUERYMAPAREA_CMD_FIELD.has_default_value = true
QUERYMAPAREA_CMD_FIELD.default_value = 9
QUERYMAPAREA_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYMAPAREA_CMD_FIELD.type = 14
QUERYMAPAREA_CMD_FIELD.cpp_type = 8
QUERYMAPAREA_PARAM_FIELD.name = "param"
QUERYMAPAREA_PARAM_FIELD.full_name = ".Cmd.QueryMapArea.param"
QUERYMAPAREA_PARAM_FIELD.number = 2
QUERYMAPAREA_PARAM_FIELD.index = 1
QUERYMAPAREA_PARAM_FIELD.label = 1
QUERYMAPAREA_PARAM_FIELD.has_default_value = true
QUERYMAPAREA_PARAM_FIELD.default_value = 63
QUERYMAPAREA_PARAM_FIELD.enum_type = USER2PARAM
QUERYMAPAREA_PARAM_FIELD.type = 14
QUERYMAPAREA_PARAM_FIELD.cpp_type = 8
QUERYMAPAREA_AREAS_FIELD.name = "areas"
QUERYMAPAREA_AREAS_FIELD.full_name = ".Cmd.QueryMapArea.areas"
QUERYMAPAREA_AREAS_FIELD.number = 3
QUERYMAPAREA_AREAS_FIELD.index = 2
QUERYMAPAREA_AREAS_FIELD.label = 3
QUERYMAPAREA_AREAS_FIELD.has_default_value = false
QUERYMAPAREA_AREAS_FIELD.default_value = {}
QUERYMAPAREA_AREAS_FIELD.type = 13
QUERYMAPAREA_AREAS_FIELD.cpp_type = 3
QUERYMAPAREA.name = "QueryMapArea"
QUERYMAPAREA.full_name = ".Cmd.QueryMapArea"
QUERYMAPAREA.nested_types = {}
QUERYMAPAREA.enum_types = {}
QUERYMAPAREA.fields = {
  QUERYMAPAREA_CMD_FIELD,
  QUERYMAPAREA_PARAM_FIELD,
  QUERYMAPAREA_AREAS_FIELD
}
QUERYMAPAREA.is_extendable = false
QUERYMAPAREA.extensions = {}
NEWMAPAREANTF_CMD_FIELD.name = "cmd"
NEWMAPAREANTF_CMD_FIELD.full_name = ".Cmd.NewMapAreaNtf.cmd"
NEWMAPAREANTF_CMD_FIELD.number = 1
NEWMAPAREANTF_CMD_FIELD.index = 0
NEWMAPAREANTF_CMD_FIELD.label = 1
NEWMAPAREANTF_CMD_FIELD.has_default_value = true
NEWMAPAREANTF_CMD_FIELD.default_value = 9
NEWMAPAREANTF_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWMAPAREANTF_CMD_FIELD.type = 14
NEWMAPAREANTF_CMD_FIELD.cpp_type = 8
NEWMAPAREANTF_PARAM_FIELD.name = "param"
NEWMAPAREANTF_PARAM_FIELD.full_name = ".Cmd.NewMapAreaNtf.param"
NEWMAPAREANTF_PARAM_FIELD.number = 2
NEWMAPAREANTF_PARAM_FIELD.index = 1
NEWMAPAREANTF_PARAM_FIELD.label = 1
NEWMAPAREANTF_PARAM_FIELD.has_default_value = true
NEWMAPAREANTF_PARAM_FIELD.default_value = 64
NEWMAPAREANTF_PARAM_FIELD.enum_type = USER2PARAM
NEWMAPAREANTF_PARAM_FIELD.type = 14
NEWMAPAREANTF_PARAM_FIELD.cpp_type = 8
NEWMAPAREANTF_AREA_FIELD.name = "area"
NEWMAPAREANTF_AREA_FIELD.full_name = ".Cmd.NewMapAreaNtf.area"
NEWMAPAREANTF_AREA_FIELD.number = 3
NEWMAPAREANTF_AREA_FIELD.index = 2
NEWMAPAREANTF_AREA_FIELD.label = 1
NEWMAPAREANTF_AREA_FIELD.has_default_value = true
NEWMAPAREANTF_AREA_FIELD.default_value = 0
NEWMAPAREANTF_AREA_FIELD.type = 13
NEWMAPAREANTF_AREA_FIELD.cpp_type = 3
NEWMAPAREANTF.name = "NewMapAreaNtf"
NEWMAPAREANTF.full_name = ".Cmd.NewMapAreaNtf"
NEWMAPAREANTF.nested_types = {}
NEWMAPAREANTF.enum_types = {}
NEWMAPAREANTF.fields = {
  NEWMAPAREANTF_CMD_FIELD,
  NEWMAPAREANTF_PARAM_FIELD,
  NEWMAPAREANTF_AREA_FIELD
}
NEWMAPAREANTF.is_extendable = false
NEWMAPAREANTF.extensions = {}
BUFFFOREVERCMD_CMD_FIELD.name = "cmd"
BUFFFOREVERCMD_CMD_FIELD.full_name = ".Cmd.BuffForeverCmd.cmd"
BUFFFOREVERCMD_CMD_FIELD.number = 1
BUFFFOREVERCMD_CMD_FIELD.index = 0
BUFFFOREVERCMD_CMD_FIELD.label = 1
BUFFFOREVERCMD_CMD_FIELD.has_default_value = true
BUFFFOREVERCMD_CMD_FIELD.default_value = 9
BUFFFOREVERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BUFFFOREVERCMD_CMD_FIELD.type = 14
BUFFFOREVERCMD_CMD_FIELD.cpp_type = 8
BUFFFOREVERCMD_PARAM_FIELD.name = "param"
BUFFFOREVERCMD_PARAM_FIELD.full_name = ".Cmd.BuffForeverCmd.param"
BUFFFOREVERCMD_PARAM_FIELD.number = 2
BUFFFOREVERCMD_PARAM_FIELD.index = 1
BUFFFOREVERCMD_PARAM_FIELD.label = 1
BUFFFOREVERCMD_PARAM_FIELD.has_default_value = true
BUFFFOREVERCMD_PARAM_FIELD.default_value = 66
BUFFFOREVERCMD_PARAM_FIELD.enum_type = USER2PARAM
BUFFFOREVERCMD_PARAM_FIELD.type = 14
BUFFFOREVERCMD_PARAM_FIELD.cpp_type = 8
BUFFFOREVERCMD_BUFF_FIELD.name = "buff"
BUFFFOREVERCMD_BUFF_FIELD.full_name = ".Cmd.BuffForeverCmd.buff"
BUFFFOREVERCMD_BUFF_FIELD.number = 3
BUFFFOREVERCMD_BUFF_FIELD.index = 2
BUFFFOREVERCMD_BUFF_FIELD.label = 3
BUFFFOREVERCMD_BUFF_FIELD.has_default_value = false
BUFFFOREVERCMD_BUFF_FIELD.default_value = {}
BUFFFOREVERCMD_BUFF_FIELD.message_type = BUFFERDATA
BUFFFOREVERCMD_BUFF_FIELD.type = 11
BUFFFOREVERCMD_BUFF_FIELD.cpp_type = 10
BUFFFOREVERCMD.name = "BuffForeverCmd"
BUFFFOREVERCMD.full_name = ".Cmd.BuffForeverCmd"
BUFFFOREVERCMD.nested_types = {}
BUFFFOREVERCMD.enum_types = {}
BUFFFOREVERCMD.fields = {
  BUFFFOREVERCMD_CMD_FIELD,
  BUFFFOREVERCMD_PARAM_FIELD,
  BUFFFOREVERCMD_BUFF_FIELD
}
BUFFFOREVERCMD.is_extendable = false
BUFFFOREVERCMD.extensions = {}
INVITEJOINHANDSUSERCMD_CMD_FIELD.name = "cmd"
INVITEJOINHANDSUSERCMD_CMD_FIELD.full_name = ".Cmd.InviteJoinHandsUserCmd.cmd"
INVITEJOINHANDSUSERCMD_CMD_FIELD.number = 1
INVITEJOINHANDSUSERCMD_CMD_FIELD.index = 0
INVITEJOINHANDSUSERCMD_CMD_FIELD.label = 1
INVITEJOINHANDSUSERCMD_CMD_FIELD.has_default_value = true
INVITEJOINHANDSUSERCMD_CMD_FIELD.default_value = 9
INVITEJOINHANDSUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITEJOINHANDSUSERCMD_CMD_FIELD.type = 14
INVITEJOINHANDSUSERCMD_CMD_FIELD.cpp_type = 8
INVITEJOINHANDSUSERCMD_PARAM_FIELD.name = "param"
INVITEJOINHANDSUSERCMD_PARAM_FIELD.full_name = ".Cmd.InviteJoinHandsUserCmd.param"
INVITEJOINHANDSUSERCMD_PARAM_FIELD.number = 2
INVITEJOINHANDSUSERCMD_PARAM_FIELD.index = 1
INVITEJOINHANDSUSERCMD_PARAM_FIELD.label = 1
INVITEJOINHANDSUSERCMD_PARAM_FIELD.has_default_value = true
INVITEJOINHANDSUSERCMD_PARAM_FIELD.default_value = 67
INVITEJOINHANDSUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
INVITEJOINHANDSUSERCMD_PARAM_FIELD.type = 14
INVITEJOINHANDSUSERCMD_PARAM_FIELD.cpp_type = 8
INVITEJOINHANDSUSERCMD_CHARID_FIELD.name = "charid"
INVITEJOINHANDSUSERCMD_CHARID_FIELD.full_name = ".Cmd.InviteJoinHandsUserCmd.charid"
INVITEJOINHANDSUSERCMD_CHARID_FIELD.number = 3
INVITEJOINHANDSUSERCMD_CHARID_FIELD.index = 2
INVITEJOINHANDSUSERCMD_CHARID_FIELD.label = 1
INVITEJOINHANDSUSERCMD_CHARID_FIELD.has_default_value = true
INVITEJOINHANDSUSERCMD_CHARID_FIELD.default_value = 0
INVITEJOINHANDSUSERCMD_CHARID_FIELD.type = 4
INVITEJOINHANDSUSERCMD_CHARID_FIELD.cpp_type = 4
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.name = "masterid"
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.full_name = ".Cmd.InviteJoinHandsUserCmd.masterid"
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.number = 4
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.index = 3
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.label = 1
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.has_default_value = true
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.default_value = 0
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.type = 4
INVITEJOINHANDSUSERCMD_MASTERID_FIELD.cpp_type = 4
INVITEJOINHANDSUSERCMD_TIME_FIELD.name = "time"
INVITEJOINHANDSUSERCMD_TIME_FIELD.full_name = ".Cmd.InviteJoinHandsUserCmd.time"
INVITEJOINHANDSUSERCMD_TIME_FIELD.number = 5
INVITEJOINHANDSUSERCMD_TIME_FIELD.index = 4
INVITEJOINHANDSUSERCMD_TIME_FIELD.label = 1
INVITEJOINHANDSUSERCMD_TIME_FIELD.has_default_value = true
INVITEJOINHANDSUSERCMD_TIME_FIELD.default_value = 0
INVITEJOINHANDSUSERCMD_TIME_FIELD.type = 13
INVITEJOINHANDSUSERCMD_TIME_FIELD.cpp_type = 3
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.name = "mastername"
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.full_name = ".Cmd.InviteJoinHandsUserCmd.mastername"
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.number = 6
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.index = 5
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.label = 1
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.has_default_value = false
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.default_value = ""
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.type = 9
INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD.cpp_type = 9
INVITEJOINHANDSUSERCMD_SIGN_FIELD.name = "sign"
INVITEJOINHANDSUSERCMD_SIGN_FIELD.full_name = ".Cmd.InviteJoinHandsUserCmd.sign"
INVITEJOINHANDSUSERCMD_SIGN_FIELD.number = 7
INVITEJOINHANDSUSERCMD_SIGN_FIELD.index = 6
INVITEJOINHANDSUSERCMD_SIGN_FIELD.label = 1
INVITEJOINHANDSUSERCMD_SIGN_FIELD.has_default_value = false
INVITEJOINHANDSUSERCMD_SIGN_FIELD.default_value = ""
INVITEJOINHANDSUSERCMD_SIGN_FIELD.type = 12
INVITEJOINHANDSUSERCMD_SIGN_FIELD.cpp_type = 9
INVITEJOINHANDSUSERCMD.name = "InviteJoinHandsUserCmd"
INVITEJOINHANDSUSERCMD.full_name = ".Cmd.InviteJoinHandsUserCmd"
INVITEJOINHANDSUSERCMD.nested_types = {}
INVITEJOINHANDSUSERCMD.enum_types = {}
INVITEJOINHANDSUSERCMD.fields = {
  INVITEJOINHANDSUSERCMD_CMD_FIELD,
  INVITEJOINHANDSUSERCMD_PARAM_FIELD,
  INVITEJOINHANDSUSERCMD_CHARID_FIELD,
  INVITEJOINHANDSUSERCMD_MASTERID_FIELD,
  INVITEJOINHANDSUSERCMD_TIME_FIELD,
  INVITEJOINHANDSUSERCMD_MASTERNAME_FIELD,
  INVITEJOINHANDSUSERCMD_SIGN_FIELD
}
INVITEJOINHANDSUSERCMD.is_extendable = false
INVITEJOINHANDSUSERCMD.extensions = {}
BREAKUPHANDSUSERCMD_CMD_FIELD.name = "cmd"
BREAKUPHANDSUSERCMD_CMD_FIELD.full_name = ".Cmd.BreakUpHandsUserCmd.cmd"
BREAKUPHANDSUSERCMD_CMD_FIELD.number = 1
BREAKUPHANDSUSERCMD_CMD_FIELD.index = 0
BREAKUPHANDSUSERCMD_CMD_FIELD.label = 1
BREAKUPHANDSUSERCMD_CMD_FIELD.has_default_value = true
BREAKUPHANDSUSERCMD_CMD_FIELD.default_value = 9
BREAKUPHANDSUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BREAKUPHANDSUSERCMD_CMD_FIELD.type = 14
BREAKUPHANDSUSERCMD_CMD_FIELD.cpp_type = 8
BREAKUPHANDSUSERCMD_PARAM_FIELD.name = "param"
BREAKUPHANDSUSERCMD_PARAM_FIELD.full_name = ".Cmd.BreakUpHandsUserCmd.param"
BREAKUPHANDSUSERCMD_PARAM_FIELD.number = 2
BREAKUPHANDSUSERCMD_PARAM_FIELD.index = 1
BREAKUPHANDSUSERCMD_PARAM_FIELD.label = 1
BREAKUPHANDSUSERCMD_PARAM_FIELD.has_default_value = true
BREAKUPHANDSUSERCMD_PARAM_FIELD.default_value = 68
BREAKUPHANDSUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
BREAKUPHANDSUSERCMD_PARAM_FIELD.type = 14
BREAKUPHANDSUSERCMD_PARAM_FIELD.cpp_type = 8
BREAKUPHANDSUSERCMD.name = "BreakUpHandsUserCmd"
BREAKUPHANDSUSERCMD.full_name = ".Cmd.BreakUpHandsUserCmd"
BREAKUPHANDSUSERCMD.nested_types = {}
BREAKUPHANDSUSERCMD.enum_types = {}
BREAKUPHANDSUSERCMD.fields = {
  BREAKUPHANDSUSERCMD_CMD_FIELD,
  BREAKUPHANDSUSERCMD_PARAM_FIELD
}
BREAKUPHANDSUSERCMD.is_extendable = false
BREAKUPHANDSUSERCMD.extensions = {}
HANDSTATUSUSERCMD_CMD_FIELD.name = "cmd"
HANDSTATUSUSERCMD_CMD_FIELD.full_name = ".Cmd.HandStatusUserCmd.cmd"
HANDSTATUSUSERCMD_CMD_FIELD.number = 1
HANDSTATUSUSERCMD_CMD_FIELD.index = 0
HANDSTATUSUSERCMD_CMD_FIELD.label = 1
HANDSTATUSUSERCMD_CMD_FIELD.has_default_value = true
HANDSTATUSUSERCMD_CMD_FIELD.default_value = 9
HANDSTATUSUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
HANDSTATUSUSERCMD_CMD_FIELD.type = 14
HANDSTATUSUSERCMD_CMD_FIELD.cpp_type = 8
HANDSTATUSUSERCMD_PARAM_FIELD.name = "param"
HANDSTATUSUSERCMD_PARAM_FIELD.full_name = ".Cmd.HandStatusUserCmd.param"
HANDSTATUSUSERCMD_PARAM_FIELD.number = 2
HANDSTATUSUSERCMD_PARAM_FIELD.index = 1
HANDSTATUSUSERCMD_PARAM_FIELD.label = 1
HANDSTATUSUSERCMD_PARAM_FIELD.has_default_value = true
HANDSTATUSUSERCMD_PARAM_FIELD.default_value = 95
HANDSTATUSUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
HANDSTATUSUSERCMD_PARAM_FIELD.type = 14
HANDSTATUSUSERCMD_PARAM_FIELD.cpp_type = 8
HANDSTATUSUSERCMD_BUILD_FIELD.name = "build"
HANDSTATUSUSERCMD_BUILD_FIELD.full_name = ".Cmd.HandStatusUserCmd.build"
HANDSTATUSUSERCMD_BUILD_FIELD.number = 3
HANDSTATUSUSERCMD_BUILD_FIELD.index = 2
HANDSTATUSUSERCMD_BUILD_FIELD.label = 1
HANDSTATUSUSERCMD_BUILD_FIELD.has_default_value = true
HANDSTATUSUSERCMD_BUILD_FIELD.default_value = true
HANDSTATUSUSERCMD_BUILD_FIELD.type = 8
HANDSTATUSUSERCMD_BUILD_FIELD.cpp_type = 7
HANDSTATUSUSERCMD_MASTERID_FIELD.name = "masterid"
HANDSTATUSUSERCMD_MASTERID_FIELD.full_name = ".Cmd.HandStatusUserCmd.masterid"
HANDSTATUSUSERCMD_MASTERID_FIELD.number = 4
HANDSTATUSUSERCMD_MASTERID_FIELD.index = 3
HANDSTATUSUSERCMD_MASTERID_FIELD.label = 1
HANDSTATUSUSERCMD_MASTERID_FIELD.has_default_value = true
HANDSTATUSUSERCMD_MASTERID_FIELD.default_value = 0
HANDSTATUSUSERCMD_MASTERID_FIELD.type = 4
HANDSTATUSUSERCMD_MASTERID_FIELD.cpp_type = 4
HANDSTATUSUSERCMD_FOLLOWID_FIELD.name = "followid"
HANDSTATUSUSERCMD_FOLLOWID_FIELD.full_name = ".Cmd.HandStatusUserCmd.followid"
HANDSTATUSUSERCMD_FOLLOWID_FIELD.number = 5
HANDSTATUSUSERCMD_FOLLOWID_FIELD.index = 4
HANDSTATUSUSERCMD_FOLLOWID_FIELD.label = 1
HANDSTATUSUSERCMD_FOLLOWID_FIELD.has_default_value = true
HANDSTATUSUSERCMD_FOLLOWID_FIELD.default_value = 0
HANDSTATUSUSERCMD_FOLLOWID_FIELD.type = 4
HANDSTATUSUSERCMD_FOLLOWID_FIELD.cpp_type = 4
HANDSTATUSUSERCMD_TYPE_FIELD.name = "type"
HANDSTATUSUSERCMD_TYPE_FIELD.full_name = ".Cmd.HandStatusUserCmd.type"
HANDSTATUSUSERCMD_TYPE_FIELD.number = 6
HANDSTATUSUSERCMD_TYPE_FIELD.index = 5
HANDSTATUSUSERCMD_TYPE_FIELD.label = 1
HANDSTATUSUSERCMD_TYPE_FIELD.has_default_value = true
HANDSTATUSUSERCMD_TYPE_FIELD.default_value = 0
HANDSTATUSUSERCMD_TYPE_FIELD.type = 13
HANDSTATUSUSERCMD_TYPE_FIELD.cpp_type = 3
HANDSTATUSUSERCMD.name = "HandStatusUserCmd"
HANDSTATUSUSERCMD.full_name = ".Cmd.HandStatusUserCmd"
HANDSTATUSUSERCMD.nested_types = {}
HANDSTATUSUSERCMD.enum_types = {}
HANDSTATUSUSERCMD.fields = {
  HANDSTATUSUSERCMD_CMD_FIELD,
  HANDSTATUSUSERCMD_PARAM_FIELD,
  HANDSTATUSUSERCMD_BUILD_FIELD,
  HANDSTATUSUSERCMD_MASTERID_FIELD,
  HANDSTATUSUSERCMD_FOLLOWID_FIELD,
  HANDSTATUSUSERCMD_TYPE_FIELD
}
HANDSTATUSUSERCMD.is_extendable = false
HANDSTATUSUSERCMD.extensions = {}
QUERYSHOW_CMD_FIELD.name = "cmd"
QUERYSHOW_CMD_FIELD.full_name = ".Cmd.QueryShow.cmd"
QUERYSHOW_CMD_FIELD.number = 1
QUERYSHOW_CMD_FIELD.index = 0
QUERYSHOW_CMD_FIELD.label = 1
QUERYSHOW_CMD_FIELD.has_default_value = true
QUERYSHOW_CMD_FIELD.default_value = 9
QUERYSHOW_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYSHOW_CMD_FIELD.type = 14
QUERYSHOW_CMD_FIELD.cpp_type = 8
QUERYSHOW_PARAM_FIELD.name = "param"
QUERYSHOW_PARAM_FIELD.full_name = ".Cmd.QueryShow.param"
QUERYSHOW_PARAM_FIELD.number = 2
QUERYSHOW_PARAM_FIELD.index = 1
QUERYSHOW_PARAM_FIELD.label = 1
QUERYSHOW_PARAM_FIELD.has_default_value = true
QUERYSHOW_PARAM_FIELD.default_value = 69
QUERYSHOW_PARAM_FIELD.enum_type = USER2PARAM
QUERYSHOW_PARAM_FIELD.type = 14
QUERYSHOW_PARAM_FIELD.cpp_type = 8
QUERYSHOW_ACTIONID_FIELD.name = "actionid"
QUERYSHOW_ACTIONID_FIELD.full_name = ".Cmd.QueryShow.actionid"
QUERYSHOW_ACTIONID_FIELD.number = 3
QUERYSHOW_ACTIONID_FIELD.index = 2
QUERYSHOW_ACTIONID_FIELD.label = 3
QUERYSHOW_ACTIONID_FIELD.has_default_value = false
QUERYSHOW_ACTIONID_FIELD.default_value = {}
QUERYSHOW_ACTIONID_FIELD.type = 13
QUERYSHOW_ACTIONID_FIELD.cpp_type = 3
QUERYSHOW_EXPRESSION_FIELD.name = "expression"
QUERYSHOW_EXPRESSION_FIELD.full_name = ".Cmd.QueryShow.expression"
QUERYSHOW_EXPRESSION_FIELD.number = 4
QUERYSHOW_EXPRESSION_FIELD.index = 3
QUERYSHOW_EXPRESSION_FIELD.label = 3
QUERYSHOW_EXPRESSION_FIELD.has_default_value = false
QUERYSHOW_EXPRESSION_FIELD.default_value = {}
QUERYSHOW_EXPRESSION_FIELD.type = 13
QUERYSHOW_EXPRESSION_FIELD.cpp_type = 3
QUERYSHOW.name = "QueryShow"
QUERYSHOW.full_name = ".Cmd.QueryShow"
QUERYSHOW.nested_types = {}
QUERYSHOW.enum_types = {}
QUERYSHOW.fields = {
  QUERYSHOW_CMD_FIELD,
  QUERYSHOW_PARAM_FIELD,
  QUERYSHOW_ACTIONID_FIELD,
  QUERYSHOW_EXPRESSION_FIELD
}
QUERYSHOW.is_extendable = false
QUERYSHOW.extensions = {}
MUSICITEM_CHARID_FIELD.name = "charid"
MUSICITEM_CHARID_FIELD.full_name = ".Cmd.MusicItem.charid"
MUSICITEM_CHARID_FIELD.number = 1
MUSICITEM_CHARID_FIELD.index = 0
MUSICITEM_CHARID_FIELD.label = 1
MUSICITEM_CHARID_FIELD.has_default_value = true
MUSICITEM_CHARID_FIELD.default_value = 0
MUSICITEM_CHARID_FIELD.type = 4
MUSICITEM_CHARID_FIELD.cpp_type = 4
MUSICITEM_DEMANDTIME_FIELD.name = "demandtime"
MUSICITEM_DEMANDTIME_FIELD.full_name = ".Cmd.MusicItem.demandtime"
MUSICITEM_DEMANDTIME_FIELD.number = 2
MUSICITEM_DEMANDTIME_FIELD.index = 1
MUSICITEM_DEMANDTIME_FIELD.label = 1
MUSICITEM_DEMANDTIME_FIELD.has_default_value = true
MUSICITEM_DEMANDTIME_FIELD.default_value = 0
MUSICITEM_DEMANDTIME_FIELD.type = 13
MUSICITEM_DEMANDTIME_FIELD.cpp_type = 3
MUSICITEM_MAPID_FIELD.name = "mapid"
MUSICITEM_MAPID_FIELD.full_name = ".Cmd.MusicItem.mapid"
MUSICITEM_MAPID_FIELD.number = 3
MUSICITEM_MAPID_FIELD.index = 2
MUSICITEM_MAPID_FIELD.label = 1
MUSICITEM_MAPID_FIELD.has_default_value = true
MUSICITEM_MAPID_FIELD.default_value = 0
MUSICITEM_MAPID_FIELD.type = 13
MUSICITEM_MAPID_FIELD.cpp_type = 3
MUSICITEM_NPCID_FIELD.name = "npcid"
MUSICITEM_NPCID_FIELD.full_name = ".Cmd.MusicItem.npcid"
MUSICITEM_NPCID_FIELD.number = 4
MUSICITEM_NPCID_FIELD.index = 3
MUSICITEM_NPCID_FIELD.label = 1
MUSICITEM_NPCID_FIELD.has_default_value = true
MUSICITEM_NPCID_FIELD.default_value = 0
MUSICITEM_NPCID_FIELD.type = 13
MUSICITEM_NPCID_FIELD.cpp_type = 3
MUSICITEM_MUSICID_FIELD.name = "musicid"
MUSICITEM_MUSICID_FIELD.full_name = ".Cmd.MusicItem.musicid"
MUSICITEM_MUSICID_FIELD.number = 5
MUSICITEM_MUSICID_FIELD.index = 4
MUSICITEM_MUSICID_FIELD.label = 1
MUSICITEM_MUSICID_FIELD.has_default_value = true
MUSICITEM_MUSICID_FIELD.default_value = 0
MUSICITEM_MUSICID_FIELD.type = 13
MUSICITEM_MUSICID_FIELD.cpp_type = 3
MUSICITEM_STARTTIME_FIELD.name = "starttime"
MUSICITEM_STARTTIME_FIELD.full_name = ".Cmd.MusicItem.starttime"
MUSICITEM_STARTTIME_FIELD.number = 6
MUSICITEM_STARTTIME_FIELD.index = 5
MUSICITEM_STARTTIME_FIELD.label = 1
MUSICITEM_STARTTIME_FIELD.has_default_value = true
MUSICITEM_STARTTIME_FIELD.default_value = 0
MUSICITEM_STARTTIME_FIELD.type = 13
MUSICITEM_STARTTIME_FIELD.cpp_type = 3
MUSICITEM_ENDTIME_FIELD.name = "endtime"
MUSICITEM_ENDTIME_FIELD.full_name = ".Cmd.MusicItem.endtime"
MUSICITEM_ENDTIME_FIELD.number = 7
MUSICITEM_ENDTIME_FIELD.index = 6
MUSICITEM_ENDTIME_FIELD.label = 1
MUSICITEM_ENDTIME_FIELD.has_default_value = true
MUSICITEM_ENDTIME_FIELD.default_value = 0
MUSICITEM_ENDTIME_FIELD.type = 13
MUSICITEM_ENDTIME_FIELD.cpp_type = 3
MUSICITEM_STATUS_FIELD.name = "status"
MUSICITEM_STATUS_FIELD.full_name = ".Cmd.MusicItem.status"
MUSICITEM_STATUS_FIELD.number = 8
MUSICITEM_STATUS_FIELD.index = 7
MUSICITEM_STATUS_FIELD.label = 1
MUSICITEM_STATUS_FIELD.has_default_value = true
MUSICITEM_STATUS_FIELD.default_value = 0
MUSICITEM_STATUS_FIELD.type = 13
MUSICITEM_STATUS_FIELD.cpp_type = 3
MUSICITEM_NAME_FIELD.name = "name"
MUSICITEM_NAME_FIELD.full_name = ".Cmd.MusicItem.name"
MUSICITEM_NAME_FIELD.number = 9
MUSICITEM_NAME_FIELD.index = 8
MUSICITEM_NAME_FIELD.label = 1
MUSICITEM_NAME_FIELD.has_default_value = false
MUSICITEM_NAME_FIELD.default_value = ""
MUSICITEM_NAME_FIELD.type = 9
MUSICITEM_NAME_FIELD.cpp_type = 9
MUSICITEM.name = "MusicItem"
MUSICITEM.full_name = ".Cmd.MusicItem"
MUSICITEM.nested_types = {}
MUSICITEM.enum_types = {}
MUSICITEM.fields = {
  MUSICITEM_CHARID_FIELD,
  MUSICITEM_DEMANDTIME_FIELD,
  MUSICITEM_MAPID_FIELD,
  MUSICITEM_NPCID_FIELD,
  MUSICITEM_MUSICID_FIELD,
  MUSICITEM_STARTTIME_FIELD,
  MUSICITEM_ENDTIME_FIELD,
  MUSICITEM_STATUS_FIELD,
  MUSICITEM_NAME_FIELD
}
MUSICITEM.is_extendable = false
MUSICITEM.extensions = {}
QUERYMUSICLIST_CMD_FIELD.name = "cmd"
QUERYMUSICLIST_CMD_FIELD.full_name = ".Cmd.QueryMusicList.cmd"
QUERYMUSICLIST_CMD_FIELD.number = 1
QUERYMUSICLIST_CMD_FIELD.index = 0
QUERYMUSICLIST_CMD_FIELD.label = 1
QUERYMUSICLIST_CMD_FIELD.has_default_value = true
QUERYMUSICLIST_CMD_FIELD.default_value = 9
QUERYMUSICLIST_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYMUSICLIST_CMD_FIELD.type = 14
QUERYMUSICLIST_CMD_FIELD.cpp_type = 8
QUERYMUSICLIST_PARAM_FIELD.name = "param"
QUERYMUSICLIST_PARAM_FIELD.full_name = ".Cmd.QueryMusicList.param"
QUERYMUSICLIST_PARAM_FIELD.number = 2
QUERYMUSICLIST_PARAM_FIELD.index = 1
QUERYMUSICLIST_PARAM_FIELD.label = 1
QUERYMUSICLIST_PARAM_FIELD.has_default_value = true
QUERYMUSICLIST_PARAM_FIELD.default_value = 70
QUERYMUSICLIST_PARAM_FIELD.enum_type = USER2PARAM
QUERYMUSICLIST_PARAM_FIELD.type = 14
QUERYMUSICLIST_PARAM_FIELD.cpp_type = 8
QUERYMUSICLIST_NPCID_FIELD.name = "npcid"
QUERYMUSICLIST_NPCID_FIELD.full_name = ".Cmd.QueryMusicList.npcid"
QUERYMUSICLIST_NPCID_FIELD.number = 3
QUERYMUSICLIST_NPCID_FIELD.index = 2
QUERYMUSICLIST_NPCID_FIELD.label = 1
QUERYMUSICLIST_NPCID_FIELD.has_default_value = true
QUERYMUSICLIST_NPCID_FIELD.default_value = 0
QUERYMUSICLIST_NPCID_FIELD.type = 4
QUERYMUSICLIST_NPCID_FIELD.cpp_type = 4
QUERYMUSICLIST_ITEMS_FIELD.name = "items"
QUERYMUSICLIST_ITEMS_FIELD.full_name = ".Cmd.QueryMusicList.items"
QUERYMUSICLIST_ITEMS_FIELD.number = 4
QUERYMUSICLIST_ITEMS_FIELD.index = 3
QUERYMUSICLIST_ITEMS_FIELD.label = 3
QUERYMUSICLIST_ITEMS_FIELD.has_default_value = false
QUERYMUSICLIST_ITEMS_FIELD.default_value = {}
QUERYMUSICLIST_ITEMS_FIELD.message_type = MUSICITEM
QUERYMUSICLIST_ITEMS_FIELD.type = 11
QUERYMUSICLIST_ITEMS_FIELD.cpp_type = 10
QUERYMUSICLIST.name = "QueryMusicList"
QUERYMUSICLIST.full_name = ".Cmd.QueryMusicList"
QUERYMUSICLIST.nested_types = {}
QUERYMUSICLIST.enum_types = {}
QUERYMUSICLIST.fields = {
  QUERYMUSICLIST_CMD_FIELD,
  QUERYMUSICLIST_PARAM_FIELD,
  QUERYMUSICLIST_NPCID_FIELD,
  QUERYMUSICLIST_ITEMS_FIELD
}
QUERYMUSICLIST.is_extendable = false
QUERYMUSICLIST.extensions = {}
DEMANDMUSIC_CMD_FIELD.name = "cmd"
DEMANDMUSIC_CMD_FIELD.full_name = ".Cmd.DemandMusic.cmd"
DEMANDMUSIC_CMD_FIELD.number = 1
DEMANDMUSIC_CMD_FIELD.index = 0
DEMANDMUSIC_CMD_FIELD.label = 1
DEMANDMUSIC_CMD_FIELD.has_default_value = true
DEMANDMUSIC_CMD_FIELD.default_value = 9
DEMANDMUSIC_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DEMANDMUSIC_CMD_FIELD.type = 14
DEMANDMUSIC_CMD_FIELD.cpp_type = 8
DEMANDMUSIC_PARAM_FIELD.name = "param"
DEMANDMUSIC_PARAM_FIELD.full_name = ".Cmd.DemandMusic.param"
DEMANDMUSIC_PARAM_FIELD.number = 2
DEMANDMUSIC_PARAM_FIELD.index = 1
DEMANDMUSIC_PARAM_FIELD.label = 1
DEMANDMUSIC_PARAM_FIELD.has_default_value = true
DEMANDMUSIC_PARAM_FIELD.default_value = 71
DEMANDMUSIC_PARAM_FIELD.enum_type = USER2PARAM
DEMANDMUSIC_PARAM_FIELD.type = 14
DEMANDMUSIC_PARAM_FIELD.cpp_type = 8
DEMANDMUSIC_NPCID_FIELD.name = "npcid"
DEMANDMUSIC_NPCID_FIELD.full_name = ".Cmd.DemandMusic.npcid"
DEMANDMUSIC_NPCID_FIELD.number = 3
DEMANDMUSIC_NPCID_FIELD.index = 2
DEMANDMUSIC_NPCID_FIELD.label = 1
DEMANDMUSIC_NPCID_FIELD.has_default_value = true
DEMANDMUSIC_NPCID_FIELD.default_value = 0
DEMANDMUSIC_NPCID_FIELD.type = 4
DEMANDMUSIC_NPCID_FIELD.cpp_type = 4
DEMANDMUSIC_MUSICID_FIELD.name = "musicid"
DEMANDMUSIC_MUSICID_FIELD.full_name = ".Cmd.DemandMusic.musicid"
DEMANDMUSIC_MUSICID_FIELD.number = 4
DEMANDMUSIC_MUSICID_FIELD.index = 3
DEMANDMUSIC_MUSICID_FIELD.label = 1
DEMANDMUSIC_MUSICID_FIELD.has_default_value = true
DEMANDMUSIC_MUSICID_FIELD.default_value = 0
DEMANDMUSIC_MUSICID_FIELD.type = 13
DEMANDMUSIC_MUSICID_FIELD.cpp_type = 3
DEMANDMUSIC.name = "DemandMusic"
DEMANDMUSIC.full_name = ".Cmd.DemandMusic"
DEMANDMUSIC.nested_types = {}
DEMANDMUSIC.enum_types = {}
DEMANDMUSIC.fields = {
  DEMANDMUSIC_CMD_FIELD,
  DEMANDMUSIC_PARAM_FIELD,
  DEMANDMUSIC_NPCID_FIELD,
  DEMANDMUSIC_MUSICID_FIELD
}
DEMANDMUSIC.is_extendable = false
DEMANDMUSIC.extensions = {}
CLOSEMUSICFRAME_CMD_FIELD.name = "cmd"
CLOSEMUSICFRAME_CMD_FIELD.full_name = ".Cmd.CloseMusicFrame.cmd"
CLOSEMUSICFRAME_CMD_FIELD.number = 1
CLOSEMUSICFRAME_CMD_FIELD.index = 0
CLOSEMUSICFRAME_CMD_FIELD.label = 1
CLOSEMUSICFRAME_CMD_FIELD.has_default_value = true
CLOSEMUSICFRAME_CMD_FIELD.default_value = 9
CLOSEMUSICFRAME_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CLOSEMUSICFRAME_CMD_FIELD.type = 14
CLOSEMUSICFRAME_CMD_FIELD.cpp_type = 8
CLOSEMUSICFRAME_PARAM_FIELD.name = "param"
CLOSEMUSICFRAME_PARAM_FIELD.full_name = ".Cmd.CloseMusicFrame.param"
CLOSEMUSICFRAME_PARAM_FIELD.number = 2
CLOSEMUSICFRAME_PARAM_FIELD.index = 1
CLOSEMUSICFRAME_PARAM_FIELD.label = 1
CLOSEMUSICFRAME_PARAM_FIELD.has_default_value = true
CLOSEMUSICFRAME_PARAM_FIELD.default_value = 72
CLOSEMUSICFRAME_PARAM_FIELD.enum_type = USER2PARAM
CLOSEMUSICFRAME_PARAM_FIELD.type = 14
CLOSEMUSICFRAME_PARAM_FIELD.cpp_type = 8
CLOSEMUSICFRAME.name = "CloseMusicFrame"
CLOSEMUSICFRAME.full_name = ".Cmd.CloseMusicFrame"
CLOSEMUSICFRAME.nested_types = {}
CLOSEMUSICFRAME.enum_types = {}
CLOSEMUSICFRAME.fields = {
  CLOSEMUSICFRAME_CMD_FIELD,
  CLOSEMUSICFRAME_PARAM_FIELD
}
CLOSEMUSICFRAME.is_extendable = false
CLOSEMUSICFRAME.extensions = {}
UPLOADOKSCENERYUSERCMD_CMD_FIELD.name = "cmd"
UPLOADOKSCENERYUSERCMD_CMD_FIELD.full_name = ".Cmd.UploadOkSceneryUserCmd.cmd"
UPLOADOKSCENERYUSERCMD_CMD_FIELD.number = 1
UPLOADOKSCENERYUSERCMD_CMD_FIELD.index = 0
UPLOADOKSCENERYUSERCMD_CMD_FIELD.label = 1
UPLOADOKSCENERYUSERCMD_CMD_FIELD.has_default_value = true
UPLOADOKSCENERYUSERCMD_CMD_FIELD.default_value = 9
UPLOADOKSCENERYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPLOADOKSCENERYUSERCMD_CMD_FIELD.type = 14
UPLOADOKSCENERYUSERCMD_CMD_FIELD.cpp_type = 8
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.name = "param"
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.full_name = ".Cmd.UploadOkSceneryUserCmd.param"
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.number = 2
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.index = 1
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.label = 1
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.has_default_value = true
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.default_value = 73
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.type = 14
UPLOADOKSCENERYUSERCMD_PARAM_FIELD.cpp_type = 8
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.name = "sceneryid"
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.full_name = ".Cmd.UploadOkSceneryUserCmd.sceneryid"
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.number = 3
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.index = 2
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.label = 1
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.has_default_value = true
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.default_value = 0
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.type = 13
UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD.cpp_type = 3
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.name = "status"
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.full_name = ".Cmd.UploadOkSceneryUserCmd.status"
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.number = 4
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.index = 3
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.label = 1
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.has_default_value = true
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.default_value = 0
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.type = 13
UPLOADOKSCENERYUSERCMD_STATUS_FIELD.cpp_type = 3
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.name = "anglez"
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.full_name = ".Cmd.UploadOkSceneryUserCmd.anglez"
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.number = 5
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.index = 4
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.label = 1
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.has_default_value = true
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.default_value = 0
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.type = 13
UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD.cpp_type = 3
UPLOADOKSCENERYUSERCMD_TIME_FIELD.name = "time"
UPLOADOKSCENERYUSERCMD_TIME_FIELD.full_name = ".Cmd.UploadOkSceneryUserCmd.time"
UPLOADOKSCENERYUSERCMD_TIME_FIELD.number = 6
UPLOADOKSCENERYUSERCMD_TIME_FIELD.index = 5
UPLOADOKSCENERYUSERCMD_TIME_FIELD.label = 1
UPLOADOKSCENERYUSERCMD_TIME_FIELD.has_default_value = true
UPLOADOKSCENERYUSERCMD_TIME_FIELD.default_value = 0
UPLOADOKSCENERYUSERCMD_TIME_FIELD.type = 13
UPLOADOKSCENERYUSERCMD_TIME_FIELD.cpp_type = 3
UPLOADOKSCENERYUSERCMD.name = "UploadOkSceneryUserCmd"
UPLOADOKSCENERYUSERCMD.full_name = ".Cmd.UploadOkSceneryUserCmd"
UPLOADOKSCENERYUSERCMD.nested_types = {}
UPLOADOKSCENERYUSERCMD.enum_types = {}
UPLOADOKSCENERYUSERCMD.fields = {
  UPLOADOKSCENERYUSERCMD_CMD_FIELD,
  UPLOADOKSCENERYUSERCMD_PARAM_FIELD,
  UPLOADOKSCENERYUSERCMD_SCENERYID_FIELD,
  UPLOADOKSCENERYUSERCMD_STATUS_FIELD,
  UPLOADOKSCENERYUSERCMD_ANGLEZ_FIELD,
  UPLOADOKSCENERYUSERCMD_TIME_FIELD
}
UPLOADOKSCENERYUSERCMD.is_extendable = false
UPLOADOKSCENERYUSERCMD.extensions = {}
JOINHANDSUSERCMD_CMD_FIELD.name = "cmd"
JOINHANDSUSERCMD_CMD_FIELD.full_name = ".Cmd.JoinHandsUserCmd.cmd"
JOINHANDSUSERCMD_CMD_FIELD.number = 1
JOINHANDSUSERCMD_CMD_FIELD.index = 0
JOINHANDSUSERCMD_CMD_FIELD.label = 1
JOINHANDSUSERCMD_CMD_FIELD.has_default_value = true
JOINHANDSUSERCMD_CMD_FIELD.default_value = 9
JOINHANDSUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
JOINHANDSUSERCMD_CMD_FIELD.type = 14
JOINHANDSUSERCMD_CMD_FIELD.cpp_type = 8
JOINHANDSUSERCMD_PARAM_FIELD.name = "param"
JOINHANDSUSERCMD_PARAM_FIELD.full_name = ".Cmd.JoinHandsUserCmd.param"
JOINHANDSUSERCMD_PARAM_FIELD.number = 2
JOINHANDSUSERCMD_PARAM_FIELD.index = 1
JOINHANDSUSERCMD_PARAM_FIELD.label = 1
JOINHANDSUSERCMD_PARAM_FIELD.has_default_value = true
JOINHANDSUSERCMD_PARAM_FIELD.default_value = 74
JOINHANDSUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
JOINHANDSUSERCMD_PARAM_FIELD.type = 14
JOINHANDSUSERCMD_PARAM_FIELD.cpp_type = 8
JOINHANDSUSERCMD_MASTERID_FIELD.name = "masterid"
JOINHANDSUSERCMD_MASTERID_FIELD.full_name = ".Cmd.JoinHandsUserCmd.masterid"
JOINHANDSUSERCMD_MASTERID_FIELD.number = 3
JOINHANDSUSERCMD_MASTERID_FIELD.index = 2
JOINHANDSUSERCMD_MASTERID_FIELD.label = 1
JOINHANDSUSERCMD_MASTERID_FIELD.has_default_value = true
JOINHANDSUSERCMD_MASTERID_FIELD.default_value = 0
JOINHANDSUSERCMD_MASTERID_FIELD.type = 4
JOINHANDSUSERCMD_MASTERID_FIELD.cpp_type = 4
JOINHANDSUSERCMD_SIGN_FIELD.name = "sign"
JOINHANDSUSERCMD_SIGN_FIELD.full_name = ".Cmd.JoinHandsUserCmd.sign"
JOINHANDSUSERCMD_SIGN_FIELD.number = 4
JOINHANDSUSERCMD_SIGN_FIELD.index = 3
JOINHANDSUSERCMD_SIGN_FIELD.label = 1
JOINHANDSUSERCMD_SIGN_FIELD.has_default_value = false
JOINHANDSUSERCMD_SIGN_FIELD.default_value = ""
JOINHANDSUSERCMD_SIGN_FIELD.type = 9
JOINHANDSUSERCMD_SIGN_FIELD.cpp_type = 9
JOINHANDSUSERCMD_TIME_FIELD.name = "time"
JOINHANDSUSERCMD_TIME_FIELD.full_name = ".Cmd.JoinHandsUserCmd.time"
JOINHANDSUSERCMD_TIME_FIELD.number = 5
JOINHANDSUSERCMD_TIME_FIELD.index = 4
JOINHANDSUSERCMD_TIME_FIELD.label = 1
JOINHANDSUSERCMD_TIME_FIELD.has_default_value = true
JOINHANDSUSERCMD_TIME_FIELD.default_value = 0
JOINHANDSUSERCMD_TIME_FIELD.type = 13
JOINHANDSUSERCMD_TIME_FIELD.cpp_type = 3
JOINHANDSUSERCMD.name = "JoinHandsUserCmd"
JOINHANDSUSERCMD.full_name = ".Cmd.JoinHandsUserCmd"
JOINHANDSUSERCMD.nested_types = {}
JOINHANDSUSERCMD.enum_types = {}
JOINHANDSUSERCMD.fields = {
  JOINHANDSUSERCMD_CMD_FIELD,
  JOINHANDSUSERCMD_PARAM_FIELD,
  JOINHANDSUSERCMD_MASTERID_FIELD,
  JOINHANDSUSERCMD_SIGN_FIELD,
  JOINHANDSUSERCMD_TIME_FIELD
}
JOINHANDSUSERCMD.is_extendable = false
JOINHANDSUSERCMD.extensions = {}
TRACEITEM_ITEMID_FIELD.name = "itemid"
TRACEITEM_ITEMID_FIELD.full_name = ".Cmd.TraceItem.itemid"
TRACEITEM_ITEMID_FIELD.number = 1
TRACEITEM_ITEMID_FIELD.index = 0
TRACEITEM_ITEMID_FIELD.label = 1
TRACEITEM_ITEMID_FIELD.has_default_value = true
TRACEITEM_ITEMID_FIELD.default_value = 0
TRACEITEM_ITEMID_FIELD.type = 13
TRACEITEM_ITEMID_FIELD.cpp_type = 3
TRACEITEM_MONSTERID_FIELD.name = "monsterid"
TRACEITEM_MONSTERID_FIELD.full_name = ".Cmd.TraceItem.monsterid"
TRACEITEM_MONSTERID_FIELD.number = 2
TRACEITEM_MONSTERID_FIELD.index = 1
TRACEITEM_MONSTERID_FIELD.label = 1
TRACEITEM_MONSTERID_FIELD.has_default_value = true
TRACEITEM_MONSTERID_FIELD.default_value = 0
TRACEITEM_MONSTERID_FIELD.type = 13
TRACEITEM_MONSTERID_FIELD.cpp_type = 3
TRACEITEM.name = "TraceItem"
TRACEITEM.full_name = ".Cmd.TraceItem"
TRACEITEM.nested_types = {}
TRACEITEM.enum_types = {}
TRACEITEM.fields = {
  TRACEITEM_ITEMID_FIELD,
  TRACEITEM_MONSTERID_FIELD
}
TRACEITEM.is_extendable = false
TRACEITEM.extensions = {}
QUERYTRACELIST_CMD_FIELD.name = "cmd"
QUERYTRACELIST_CMD_FIELD.full_name = ".Cmd.QueryTraceList.cmd"
QUERYTRACELIST_CMD_FIELD.number = 1
QUERYTRACELIST_CMD_FIELD.index = 0
QUERYTRACELIST_CMD_FIELD.label = 1
QUERYTRACELIST_CMD_FIELD.has_default_value = true
QUERYTRACELIST_CMD_FIELD.default_value = 9
QUERYTRACELIST_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYTRACELIST_CMD_FIELD.type = 14
QUERYTRACELIST_CMD_FIELD.cpp_type = 8
QUERYTRACELIST_PARAM_FIELD.name = "param"
QUERYTRACELIST_PARAM_FIELD.full_name = ".Cmd.QueryTraceList.param"
QUERYTRACELIST_PARAM_FIELD.number = 2
QUERYTRACELIST_PARAM_FIELD.index = 1
QUERYTRACELIST_PARAM_FIELD.label = 1
QUERYTRACELIST_PARAM_FIELD.has_default_value = true
QUERYTRACELIST_PARAM_FIELD.default_value = 75
QUERYTRACELIST_PARAM_FIELD.enum_type = USER2PARAM
QUERYTRACELIST_PARAM_FIELD.type = 14
QUERYTRACELIST_PARAM_FIELD.cpp_type = 8
QUERYTRACELIST_ITEMS_FIELD.name = "items"
QUERYTRACELIST_ITEMS_FIELD.full_name = ".Cmd.QueryTraceList.items"
QUERYTRACELIST_ITEMS_FIELD.number = 3
QUERYTRACELIST_ITEMS_FIELD.index = 2
QUERYTRACELIST_ITEMS_FIELD.label = 3
QUERYTRACELIST_ITEMS_FIELD.has_default_value = false
QUERYTRACELIST_ITEMS_FIELD.default_value = {}
QUERYTRACELIST_ITEMS_FIELD.message_type = TRACEITEM
QUERYTRACELIST_ITEMS_FIELD.type = 11
QUERYTRACELIST_ITEMS_FIELD.cpp_type = 10
QUERYTRACELIST.name = "QueryTraceList"
QUERYTRACELIST.full_name = ".Cmd.QueryTraceList"
QUERYTRACELIST.nested_types = {}
QUERYTRACELIST.enum_types = {}
QUERYTRACELIST.fields = {
  QUERYTRACELIST_CMD_FIELD,
  QUERYTRACELIST_PARAM_FIELD,
  QUERYTRACELIST_ITEMS_FIELD
}
QUERYTRACELIST.is_extendable = false
QUERYTRACELIST.extensions = {}
UPDATETRACELIST_CMD_FIELD.name = "cmd"
UPDATETRACELIST_CMD_FIELD.full_name = ".Cmd.UpdateTraceList.cmd"
UPDATETRACELIST_CMD_FIELD.number = 1
UPDATETRACELIST_CMD_FIELD.index = 0
UPDATETRACELIST_CMD_FIELD.label = 1
UPDATETRACELIST_CMD_FIELD.has_default_value = true
UPDATETRACELIST_CMD_FIELD.default_value = 9
UPDATETRACELIST_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATETRACELIST_CMD_FIELD.type = 14
UPDATETRACELIST_CMD_FIELD.cpp_type = 8
UPDATETRACELIST_PARAM_FIELD.name = "param"
UPDATETRACELIST_PARAM_FIELD.full_name = ".Cmd.UpdateTraceList.param"
UPDATETRACELIST_PARAM_FIELD.number = 2
UPDATETRACELIST_PARAM_FIELD.index = 1
UPDATETRACELIST_PARAM_FIELD.label = 1
UPDATETRACELIST_PARAM_FIELD.has_default_value = true
UPDATETRACELIST_PARAM_FIELD.default_value = 76
UPDATETRACELIST_PARAM_FIELD.enum_type = USER2PARAM
UPDATETRACELIST_PARAM_FIELD.type = 14
UPDATETRACELIST_PARAM_FIELD.cpp_type = 8
UPDATETRACELIST_UPDATES_FIELD.name = "updates"
UPDATETRACELIST_UPDATES_FIELD.full_name = ".Cmd.UpdateTraceList.updates"
UPDATETRACELIST_UPDATES_FIELD.number = 3
UPDATETRACELIST_UPDATES_FIELD.index = 2
UPDATETRACELIST_UPDATES_FIELD.label = 3
UPDATETRACELIST_UPDATES_FIELD.has_default_value = false
UPDATETRACELIST_UPDATES_FIELD.default_value = {}
UPDATETRACELIST_UPDATES_FIELD.message_type = TRACEITEM
UPDATETRACELIST_UPDATES_FIELD.type = 11
UPDATETRACELIST_UPDATES_FIELD.cpp_type = 10
UPDATETRACELIST_DELS_FIELD.name = "dels"
UPDATETRACELIST_DELS_FIELD.full_name = ".Cmd.UpdateTraceList.dels"
UPDATETRACELIST_DELS_FIELD.number = 4
UPDATETRACELIST_DELS_FIELD.index = 3
UPDATETRACELIST_DELS_FIELD.label = 3
UPDATETRACELIST_DELS_FIELD.has_default_value = false
UPDATETRACELIST_DELS_FIELD.default_value = {}
UPDATETRACELIST_DELS_FIELD.type = 13
UPDATETRACELIST_DELS_FIELD.cpp_type = 3
UPDATETRACELIST.name = "UpdateTraceList"
UPDATETRACELIST.full_name = ".Cmd.UpdateTraceList"
UPDATETRACELIST.nested_types = {}
UPDATETRACELIST.enum_types = {}
UPDATETRACELIST.fields = {
  UPDATETRACELIST_CMD_FIELD,
  UPDATETRACELIST_PARAM_FIELD,
  UPDATETRACELIST_UPDATES_FIELD,
  UPDATETRACELIST_DELS_FIELD
}
UPDATETRACELIST.is_extendable = false
UPDATETRACELIST.extensions = {}
SETDIRECTION_CMD_FIELD.name = "cmd"
SETDIRECTION_CMD_FIELD.full_name = ".Cmd.SetDirection.cmd"
SETDIRECTION_CMD_FIELD.number = 1
SETDIRECTION_CMD_FIELD.index = 0
SETDIRECTION_CMD_FIELD.label = 1
SETDIRECTION_CMD_FIELD.has_default_value = true
SETDIRECTION_CMD_FIELD.default_value = 9
SETDIRECTION_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SETDIRECTION_CMD_FIELD.type = 14
SETDIRECTION_CMD_FIELD.cpp_type = 8
SETDIRECTION_PARAM_FIELD.name = "param"
SETDIRECTION_PARAM_FIELD.full_name = ".Cmd.SetDirection.param"
SETDIRECTION_PARAM_FIELD.number = 2
SETDIRECTION_PARAM_FIELD.index = 1
SETDIRECTION_PARAM_FIELD.label = 1
SETDIRECTION_PARAM_FIELD.has_default_value = true
SETDIRECTION_PARAM_FIELD.default_value = 77
SETDIRECTION_PARAM_FIELD.enum_type = USER2PARAM
SETDIRECTION_PARAM_FIELD.type = 14
SETDIRECTION_PARAM_FIELD.cpp_type = 8
SETDIRECTION_DIR_FIELD.name = "dir"
SETDIRECTION_DIR_FIELD.full_name = ".Cmd.SetDirection.dir"
SETDIRECTION_DIR_FIELD.number = 3
SETDIRECTION_DIR_FIELD.index = 2
SETDIRECTION_DIR_FIELD.label = 1
SETDIRECTION_DIR_FIELD.has_default_value = true
SETDIRECTION_DIR_FIELD.default_value = 0
SETDIRECTION_DIR_FIELD.type = 13
SETDIRECTION_DIR_FIELD.cpp_type = 3
SETDIRECTION.name = "SetDirection"
SETDIRECTION.full_name = ".Cmd.SetDirection"
SETDIRECTION.nested_types = {}
SETDIRECTION.enum_types = {}
SETDIRECTION.fields = {
  SETDIRECTION_CMD_FIELD,
  SETDIRECTION_PARAM_FIELD,
  SETDIRECTION_DIR_FIELD
}
SETDIRECTION.is_extendable = false
SETDIRECTION.extensions = {}
BATTLETIMELENUSERCMD_CMD_FIELD.name = "cmd"
BATTLETIMELENUSERCMD_CMD_FIELD.full_name = ".Cmd.BattleTimelenUserCmd.cmd"
BATTLETIMELENUSERCMD_CMD_FIELD.number = 1
BATTLETIMELENUSERCMD_CMD_FIELD.index = 0
BATTLETIMELENUSERCMD_CMD_FIELD.label = 1
BATTLETIMELENUSERCMD_CMD_FIELD.has_default_value = true
BATTLETIMELENUSERCMD_CMD_FIELD.default_value = 9
BATTLETIMELENUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BATTLETIMELENUSERCMD_CMD_FIELD.type = 14
BATTLETIMELENUSERCMD_CMD_FIELD.cpp_type = 8
BATTLETIMELENUSERCMD_PARAM_FIELD.name = "param"
BATTLETIMELENUSERCMD_PARAM_FIELD.full_name = ".Cmd.BattleTimelenUserCmd.param"
BATTLETIMELENUSERCMD_PARAM_FIELD.number = 2
BATTLETIMELENUSERCMD_PARAM_FIELD.index = 1
BATTLETIMELENUSERCMD_PARAM_FIELD.label = 1
BATTLETIMELENUSERCMD_PARAM_FIELD.has_default_value = true
BATTLETIMELENUSERCMD_PARAM_FIELD.default_value = 82
BATTLETIMELENUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
BATTLETIMELENUSERCMD_PARAM_FIELD.type = 14
BATTLETIMELENUSERCMD_PARAM_FIELD.cpp_type = 8
BATTLETIMELENUSERCMD_TIMELEN_FIELD.name = "timelen"
BATTLETIMELENUSERCMD_TIMELEN_FIELD.full_name = ".Cmd.BattleTimelenUserCmd.timelen"
BATTLETIMELENUSERCMD_TIMELEN_FIELD.number = 3
BATTLETIMELENUSERCMD_TIMELEN_FIELD.index = 2
BATTLETIMELENUSERCMD_TIMELEN_FIELD.label = 1
BATTLETIMELENUSERCMD_TIMELEN_FIELD.has_default_value = true
BATTLETIMELENUSERCMD_TIMELEN_FIELD.default_value = 0
BATTLETIMELENUSERCMD_TIMELEN_FIELD.type = 13
BATTLETIMELENUSERCMD_TIMELEN_FIELD.cpp_type = 3
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.name = "totaltime"
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.full_name = ".Cmd.BattleTimelenUserCmd.totaltime"
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.number = 4
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.index = 3
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.label = 1
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.has_default_value = true
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.default_value = 0
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.type = 13
BATTLETIMELENUSERCMD_TOTALTIME_FIELD.cpp_type = 3
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.name = "musictime"
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.full_name = ".Cmd.BattleTimelenUserCmd.musictime"
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.number = 5
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.index = 4
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.label = 1
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.has_default_value = true
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.default_value = 0
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.type = 13
BATTLETIMELENUSERCMD_MUSICTIME_FIELD.cpp_type = 3
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.name = "tutortime"
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.full_name = ".Cmd.BattleTimelenUserCmd.tutortime"
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.number = 6
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.index = 5
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.label = 1
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.has_default_value = true
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.default_value = 0
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.type = 13
BATTLETIMELENUSERCMD_TUTORTIME_FIELD.cpp_type = 3
BATTLETIMELENUSERCMD_ESTATUS_FIELD.name = "estatus"
BATTLETIMELENUSERCMD_ESTATUS_FIELD.full_name = ".Cmd.BattleTimelenUserCmd.estatus"
BATTLETIMELENUSERCMD_ESTATUS_FIELD.number = 7
BATTLETIMELENUSERCMD_ESTATUS_FIELD.index = 6
BATTLETIMELENUSERCMD_ESTATUS_FIELD.label = 1
BATTLETIMELENUSERCMD_ESTATUS_FIELD.has_default_value = true
BATTLETIMELENUSERCMD_ESTATUS_FIELD.default_value = 1
BATTLETIMELENUSERCMD_ESTATUS_FIELD.enum_type = EBATTLESTATUS
BATTLETIMELENUSERCMD_ESTATUS_FIELD.type = 14
BATTLETIMELENUSERCMD_ESTATUS_FIELD.cpp_type = 8
BATTLETIMELENUSERCMD.name = "BattleTimelenUserCmd"
BATTLETIMELENUSERCMD.full_name = ".Cmd.BattleTimelenUserCmd"
BATTLETIMELENUSERCMD.nested_types = {}
BATTLETIMELENUSERCMD.enum_types = {}
BATTLETIMELENUSERCMD.fields = {
  BATTLETIMELENUSERCMD_CMD_FIELD,
  BATTLETIMELENUSERCMD_PARAM_FIELD,
  BATTLETIMELENUSERCMD_TIMELEN_FIELD,
  BATTLETIMELENUSERCMD_TOTALTIME_FIELD,
  BATTLETIMELENUSERCMD_MUSICTIME_FIELD,
  BATTLETIMELENUSERCMD_TUTORTIME_FIELD,
  BATTLETIMELENUSERCMD_ESTATUS_FIELD
}
BATTLETIMELENUSERCMD.is_extendable = false
BATTLETIMELENUSERCMD.extensions = {}
SETOPTIONUSERCMD_CMD_FIELD.name = "cmd"
SETOPTIONUSERCMD_CMD_FIELD.full_name = ".Cmd.SetOptionUserCmd.cmd"
SETOPTIONUSERCMD_CMD_FIELD.number = 1
SETOPTIONUSERCMD_CMD_FIELD.index = 0
SETOPTIONUSERCMD_CMD_FIELD.label = 1
SETOPTIONUSERCMD_CMD_FIELD.has_default_value = true
SETOPTIONUSERCMD_CMD_FIELD.default_value = 9
SETOPTIONUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SETOPTIONUSERCMD_CMD_FIELD.type = 14
SETOPTIONUSERCMD_CMD_FIELD.cpp_type = 8
SETOPTIONUSERCMD_PARAM_FIELD.name = "param"
SETOPTIONUSERCMD_PARAM_FIELD.full_name = ".Cmd.SetOptionUserCmd.param"
SETOPTIONUSERCMD_PARAM_FIELD.number = 2
SETOPTIONUSERCMD_PARAM_FIELD.index = 1
SETOPTIONUSERCMD_PARAM_FIELD.label = 1
SETOPTIONUSERCMD_PARAM_FIELD.has_default_value = true
SETOPTIONUSERCMD_PARAM_FIELD.default_value = 83
SETOPTIONUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SETOPTIONUSERCMD_PARAM_FIELD.type = 14
SETOPTIONUSERCMD_PARAM_FIELD.cpp_type = 8
SETOPTIONUSERCMD_TYPE_FIELD.name = "type"
SETOPTIONUSERCMD_TYPE_FIELD.full_name = ".Cmd.SetOptionUserCmd.type"
SETOPTIONUSERCMD_TYPE_FIELD.number = 3
SETOPTIONUSERCMD_TYPE_FIELD.index = 2
SETOPTIONUSERCMD_TYPE_FIELD.label = 1
SETOPTIONUSERCMD_TYPE_FIELD.has_default_value = true
SETOPTIONUSERCMD_TYPE_FIELD.default_value = 0
SETOPTIONUSERCMD_TYPE_FIELD.enum_type = EQUERYTYPE
SETOPTIONUSERCMD_TYPE_FIELD.type = 14
SETOPTIONUSERCMD_TYPE_FIELD.cpp_type = 8
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.name = "fashionhide"
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.full_name = ".Cmd.SetOptionUserCmd.fashionhide"
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.number = 4
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.index = 3
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.label = 1
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.has_default_value = true
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.default_value = 0
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.type = 13
SETOPTIONUSERCMD_FASHIONHIDE_FIELD.cpp_type = 3
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.name = "wedding_type"
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.full_name = ".Cmd.SetOptionUserCmd.wedding_type"
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.number = 5
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.index = 4
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.label = 1
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.has_default_value = true
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.default_value = 0
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.enum_type = EQUERYTYPE
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.type = 14
SETOPTIONUSERCMD_WEDDING_TYPE_FIELD.cpp_type = 8
SETOPTIONUSERCMD.name = "SetOptionUserCmd"
SETOPTIONUSERCMD.full_name = ".Cmd.SetOptionUserCmd"
SETOPTIONUSERCMD.nested_types = {}
SETOPTIONUSERCMD.enum_types = {}
SETOPTIONUSERCMD.fields = {
  SETOPTIONUSERCMD_CMD_FIELD,
  SETOPTIONUSERCMD_PARAM_FIELD,
  SETOPTIONUSERCMD_TYPE_FIELD,
  SETOPTIONUSERCMD_FASHIONHIDE_FIELD,
  SETOPTIONUSERCMD_WEDDING_TYPE_FIELD
}
SETOPTIONUSERCMD.is_extendable = false
SETOPTIONUSERCMD.extensions = {}
QUERYUSERINFOUSERCMD_CMD_FIELD.name = "cmd"
QUERYUSERINFOUSERCMD_CMD_FIELD.full_name = ".Cmd.QueryUserInfoUserCmd.cmd"
QUERYUSERINFOUSERCMD_CMD_FIELD.number = 1
QUERYUSERINFOUSERCMD_CMD_FIELD.index = 0
QUERYUSERINFOUSERCMD_CMD_FIELD.label = 1
QUERYUSERINFOUSERCMD_CMD_FIELD.has_default_value = true
QUERYUSERINFOUSERCMD_CMD_FIELD.default_value = 9
QUERYUSERINFOUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYUSERINFOUSERCMD_CMD_FIELD.type = 14
QUERYUSERINFOUSERCMD_CMD_FIELD.cpp_type = 8
QUERYUSERINFOUSERCMD_PARAM_FIELD.name = "param"
QUERYUSERINFOUSERCMD_PARAM_FIELD.full_name = ".Cmd.QueryUserInfoUserCmd.param"
QUERYUSERINFOUSERCMD_PARAM_FIELD.number = 2
QUERYUSERINFOUSERCMD_PARAM_FIELD.index = 1
QUERYUSERINFOUSERCMD_PARAM_FIELD.label = 1
QUERYUSERINFOUSERCMD_PARAM_FIELD.has_default_value = true
QUERYUSERINFOUSERCMD_PARAM_FIELD.default_value = 84
QUERYUSERINFOUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
QUERYUSERINFOUSERCMD_PARAM_FIELD.type = 14
QUERYUSERINFOUSERCMD_PARAM_FIELD.cpp_type = 8
QUERYUSERINFOUSERCMD_CHARID_FIELD.name = "charid"
QUERYUSERINFOUSERCMD_CHARID_FIELD.full_name = ".Cmd.QueryUserInfoUserCmd.charid"
QUERYUSERINFOUSERCMD_CHARID_FIELD.number = 3
QUERYUSERINFOUSERCMD_CHARID_FIELD.index = 2
QUERYUSERINFOUSERCMD_CHARID_FIELD.label = 1
QUERYUSERINFOUSERCMD_CHARID_FIELD.has_default_value = true
QUERYUSERINFOUSERCMD_CHARID_FIELD.default_value = 0
QUERYUSERINFOUSERCMD_CHARID_FIELD.type = 4
QUERYUSERINFOUSERCMD_CHARID_FIELD.cpp_type = 4
QUERYUSERINFOUSERCMD_TEAMID_FIELD.name = "teamid"
QUERYUSERINFOUSERCMD_TEAMID_FIELD.full_name = ".Cmd.QueryUserInfoUserCmd.teamid"
QUERYUSERINFOUSERCMD_TEAMID_FIELD.number = 4
QUERYUSERINFOUSERCMD_TEAMID_FIELD.index = 3
QUERYUSERINFOUSERCMD_TEAMID_FIELD.label = 1
QUERYUSERINFOUSERCMD_TEAMID_FIELD.has_default_value = true
QUERYUSERINFOUSERCMD_TEAMID_FIELD.default_value = 0
QUERYUSERINFOUSERCMD_TEAMID_FIELD.type = 4
QUERYUSERINFOUSERCMD_TEAMID_FIELD.cpp_type = 4
QUERYUSERINFOUSERCMD_BLINK_FIELD.name = "blink"
QUERYUSERINFOUSERCMD_BLINK_FIELD.full_name = ".Cmd.QueryUserInfoUserCmd.blink"
QUERYUSERINFOUSERCMD_BLINK_FIELD.number = 5
QUERYUSERINFOUSERCMD_BLINK_FIELD.index = 4
QUERYUSERINFOUSERCMD_BLINK_FIELD.label = 1
QUERYUSERINFOUSERCMD_BLINK_FIELD.has_default_value = true
QUERYUSERINFOUSERCMD_BLINK_FIELD.default_value = false
QUERYUSERINFOUSERCMD_BLINK_FIELD.type = 8
QUERYUSERINFOUSERCMD_BLINK_FIELD.cpp_type = 7
QUERYUSERINFOUSERCMD.name = "QueryUserInfoUserCmd"
QUERYUSERINFOUSERCMD.full_name = ".Cmd.QueryUserInfoUserCmd"
QUERYUSERINFOUSERCMD.nested_types = {}
QUERYUSERINFOUSERCMD.enum_types = {}
QUERYUSERINFOUSERCMD.fields = {
  QUERYUSERINFOUSERCMD_CMD_FIELD,
  QUERYUSERINFOUSERCMD_PARAM_FIELD,
  QUERYUSERINFOUSERCMD_CHARID_FIELD,
  QUERYUSERINFOUSERCMD_TEAMID_FIELD,
  QUERYUSERINFOUSERCMD_BLINK_FIELD
}
QUERYUSERINFOUSERCMD.is_extendable = false
QUERYUSERINFOUSERCMD.extensions = {}
COUNTDOWNTICKUSERCMD_CMD_FIELD.name = "cmd"
COUNTDOWNTICKUSERCMD_CMD_FIELD.full_name = ".Cmd.CountDownTickUserCmd.cmd"
COUNTDOWNTICKUSERCMD_CMD_FIELD.number = 1
COUNTDOWNTICKUSERCMD_CMD_FIELD.index = 0
COUNTDOWNTICKUSERCMD_CMD_FIELD.label = 1
COUNTDOWNTICKUSERCMD_CMD_FIELD.has_default_value = true
COUNTDOWNTICKUSERCMD_CMD_FIELD.default_value = 9
COUNTDOWNTICKUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
COUNTDOWNTICKUSERCMD_CMD_FIELD.type = 14
COUNTDOWNTICKUSERCMD_CMD_FIELD.cpp_type = 8
COUNTDOWNTICKUSERCMD_PARAM_FIELD.name = "param"
COUNTDOWNTICKUSERCMD_PARAM_FIELD.full_name = ".Cmd.CountDownTickUserCmd.param"
COUNTDOWNTICKUSERCMD_PARAM_FIELD.number = 2
COUNTDOWNTICKUSERCMD_PARAM_FIELD.index = 1
COUNTDOWNTICKUSERCMD_PARAM_FIELD.label = 1
COUNTDOWNTICKUSERCMD_PARAM_FIELD.has_default_value = true
COUNTDOWNTICKUSERCMD_PARAM_FIELD.default_value = 85
COUNTDOWNTICKUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
COUNTDOWNTICKUSERCMD_PARAM_FIELD.type = 14
COUNTDOWNTICKUSERCMD_PARAM_FIELD.cpp_type = 8
COUNTDOWNTICKUSERCMD_TYPE_FIELD.name = "type"
COUNTDOWNTICKUSERCMD_TYPE_FIELD.full_name = ".Cmd.CountDownTickUserCmd.type"
COUNTDOWNTICKUSERCMD_TYPE_FIELD.number = 3
COUNTDOWNTICKUSERCMD_TYPE_FIELD.index = 2
COUNTDOWNTICKUSERCMD_TYPE_FIELD.label = 1
COUNTDOWNTICKUSERCMD_TYPE_FIELD.has_default_value = false
COUNTDOWNTICKUSERCMD_TYPE_FIELD.default_value = nil
COUNTDOWNTICKUSERCMD_TYPE_FIELD.enum_type = ECOUNTDOWNTYPE
COUNTDOWNTICKUSERCMD_TYPE_FIELD.type = 14
COUNTDOWNTICKUSERCMD_TYPE_FIELD.cpp_type = 8
COUNTDOWNTICKUSERCMD_TICK_FIELD.name = "tick"
COUNTDOWNTICKUSERCMD_TICK_FIELD.full_name = ".Cmd.CountDownTickUserCmd.tick"
COUNTDOWNTICKUSERCMD_TICK_FIELD.number = 4
COUNTDOWNTICKUSERCMD_TICK_FIELD.index = 3
COUNTDOWNTICKUSERCMD_TICK_FIELD.label = 1
COUNTDOWNTICKUSERCMD_TICK_FIELD.has_default_value = false
COUNTDOWNTICKUSERCMD_TICK_FIELD.default_value = 0
COUNTDOWNTICKUSERCMD_TICK_FIELD.type = 13
COUNTDOWNTICKUSERCMD_TICK_FIELD.cpp_type = 3
COUNTDOWNTICKUSERCMD_TIME_FIELD.name = "time"
COUNTDOWNTICKUSERCMD_TIME_FIELD.full_name = ".Cmd.CountDownTickUserCmd.time"
COUNTDOWNTICKUSERCMD_TIME_FIELD.number = 5
COUNTDOWNTICKUSERCMD_TIME_FIELD.index = 4
COUNTDOWNTICKUSERCMD_TIME_FIELD.label = 1
COUNTDOWNTICKUSERCMD_TIME_FIELD.has_default_value = false
COUNTDOWNTICKUSERCMD_TIME_FIELD.default_value = 0
COUNTDOWNTICKUSERCMD_TIME_FIELD.type = 13
COUNTDOWNTICKUSERCMD_TIME_FIELD.cpp_type = 3
COUNTDOWNTICKUSERCMD_SIGN_FIELD.name = "sign"
COUNTDOWNTICKUSERCMD_SIGN_FIELD.full_name = ".Cmd.CountDownTickUserCmd.sign"
COUNTDOWNTICKUSERCMD_SIGN_FIELD.number = 6
COUNTDOWNTICKUSERCMD_SIGN_FIELD.index = 5
COUNTDOWNTICKUSERCMD_SIGN_FIELD.label = 1
COUNTDOWNTICKUSERCMD_SIGN_FIELD.has_default_value = false
COUNTDOWNTICKUSERCMD_SIGN_FIELD.default_value = ""
COUNTDOWNTICKUSERCMD_SIGN_FIELD.type = 9
COUNTDOWNTICKUSERCMD_SIGN_FIELD.cpp_type = 9
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.name = "extparam"
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.full_name = ".Cmd.CountDownTickUserCmd.extparam"
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.number = 7
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.index = 6
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.label = 1
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.has_default_value = false
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.default_value = 0
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.type = 13
COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD.cpp_type = 3
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.name = "gomaptype"
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.full_name = ".Cmd.CountDownTickUserCmd.gomaptype"
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.number = 8
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.index = 7
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.label = 1
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.has_default_value = true
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.default_value = 0
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.type = 13
COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD.cpp_type = 3
COUNTDOWNTICKUSERCMD.name = "CountDownTickUserCmd"
COUNTDOWNTICKUSERCMD.full_name = ".Cmd.CountDownTickUserCmd"
COUNTDOWNTICKUSERCMD.nested_types = {}
COUNTDOWNTICKUSERCMD.enum_types = {}
COUNTDOWNTICKUSERCMD.fields = {
  COUNTDOWNTICKUSERCMD_CMD_FIELD,
  COUNTDOWNTICKUSERCMD_PARAM_FIELD,
  COUNTDOWNTICKUSERCMD_TYPE_FIELD,
  COUNTDOWNTICKUSERCMD_TICK_FIELD,
  COUNTDOWNTICKUSERCMD_TIME_FIELD,
  COUNTDOWNTICKUSERCMD_SIGN_FIELD,
  COUNTDOWNTICKUSERCMD_EXTPARAM_FIELD,
  COUNTDOWNTICKUSERCMD_GOMAPTYPE_FIELD
}
COUNTDOWNTICKUSERCMD.is_extendable = false
COUNTDOWNTICKUSERCMD.extensions = {}
ITEMMUSICNTFUSERCMD_CMD_FIELD.name = "cmd"
ITEMMUSICNTFUSERCMD_CMD_FIELD.full_name = ".Cmd.ItemMusicNtfUserCmd.cmd"
ITEMMUSICNTFUSERCMD_CMD_FIELD.number = 1
ITEMMUSICNTFUSERCMD_CMD_FIELD.index = 0
ITEMMUSICNTFUSERCMD_CMD_FIELD.label = 1
ITEMMUSICNTFUSERCMD_CMD_FIELD.has_default_value = true
ITEMMUSICNTFUSERCMD_CMD_FIELD.default_value = 9
ITEMMUSICNTFUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ITEMMUSICNTFUSERCMD_CMD_FIELD.type = 14
ITEMMUSICNTFUSERCMD_CMD_FIELD.cpp_type = 8
ITEMMUSICNTFUSERCMD_PARAM_FIELD.name = "param"
ITEMMUSICNTFUSERCMD_PARAM_FIELD.full_name = ".Cmd.ItemMusicNtfUserCmd.param"
ITEMMUSICNTFUSERCMD_PARAM_FIELD.number = 2
ITEMMUSICNTFUSERCMD_PARAM_FIELD.index = 1
ITEMMUSICNTFUSERCMD_PARAM_FIELD.label = 1
ITEMMUSICNTFUSERCMD_PARAM_FIELD.has_default_value = true
ITEMMUSICNTFUSERCMD_PARAM_FIELD.default_value = 86
ITEMMUSICNTFUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
ITEMMUSICNTFUSERCMD_PARAM_FIELD.type = 14
ITEMMUSICNTFUSERCMD_PARAM_FIELD.cpp_type = 8
ITEMMUSICNTFUSERCMD_ADD_FIELD.name = "add"
ITEMMUSICNTFUSERCMD_ADD_FIELD.full_name = ".Cmd.ItemMusicNtfUserCmd.add"
ITEMMUSICNTFUSERCMD_ADD_FIELD.number = 3
ITEMMUSICNTFUSERCMD_ADD_FIELD.index = 2
ITEMMUSICNTFUSERCMD_ADD_FIELD.label = 1
ITEMMUSICNTFUSERCMD_ADD_FIELD.has_default_value = false
ITEMMUSICNTFUSERCMD_ADD_FIELD.default_value = false
ITEMMUSICNTFUSERCMD_ADD_FIELD.type = 8
ITEMMUSICNTFUSERCMD_ADD_FIELD.cpp_type = 7
ITEMMUSICNTFUSERCMD_URI_FIELD.name = "uri"
ITEMMUSICNTFUSERCMD_URI_FIELD.full_name = ".Cmd.ItemMusicNtfUserCmd.uri"
ITEMMUSICNTFUSERCMD_URI_FIELD.number = 4
ITEMMUSICNTFUSERCMD_URI_FIELD.index = 3
ITEMMUSICNTFUSERCMD_URI_FIELD.label = 1
ITEMMUSICNTFUSERCMD_URI_FIELD.has_default_value = false
ITEMMUSICNTFUSERCMD_URI_FIELD.default_value = ""
ITEMMUSICNTFUSERCMD_URI_FIELD.type = 9
ITEMMUSICNTFUSERCMD_URI_FIELD.cpp_type = 9
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.name = "starttime"
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.full_name = ".Cmd.ItemMusicNtfUserCmd.starttime"
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.number = 5
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.index = 4
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.label = 1
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.has_default_value = false
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.default_value = 0
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.type = 13
ITEMMUSICNTFUSERCMD_STARTTIME_FIELD.cpp_type = 3
ITEMMUSICNTFUSERCMD.name = "ItemMusicNtfUserCmd"
ITEMMUSICNTFUSERCMD.full_name = ".Cmd.ItemMusicNtfUserCmd"
ITEMMUSICNTFUSERCMD.nested_types = {}
ITEMMUSICNTFUSERCMD.enum_types = {}
ITEMMUSICNTFUSERCMD.fields = {
  ITEMMUSICNTFUSERCMD_CMD_FIELD,
  ITEMMUSICNTFUSERCMD_PARAM_FIELD,
  ITEMMUSICNTFUSERCMD_ADD_FIELD,
  ITEMMUSICNTFUSERCMD_URI_FIELD,
  ITEMMUSICNTFUSERCMD_STARTTIME_FIELD
}
ITEMMUSICNTFUSERCMD.is_extendable = false
ITEMMUSICNTFUSERCMD.extensions = {}
SHAKETREEUSERCMD_CMD_FIELD.name = "cmd"
SHAKETREEUSERCMD_CMD_FIELD.full_name = ".Cmd.ShakeTreeUserCmd.cmd"
SHAKETREEUSERCMD_CMD_FIELD.number = 1
SHAKETREEUSERCMD_CMD_FIELD.index = 0
SHAKETREEUSERCMD_CMD_FIELD.label = 1
SHAKETREEUSERCMD_CMD_FIELD.has_default_value = true
SHAKETREEUSERCMD_CMD_FIELD.default_value = 9
SHAKETREEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SHAKETREEUSERCMD_CMD_FIELD.type = 14
SHAKETREEUSERCMD_CMD_FIELD.cpp_type = 8
SHAKETREEUSERCMD_PARAM_FIELD.name = "param"
SHAKETREEUSERCMD_PARAM_FIELD.full_name = ".Cmd.ShakeTreeUserCmd.param"
SHAKETREEUSERCMD_PARAM_FIELD.number = 2
SHAKETREEUSERCMD_PARAM_FIELD.index = 1
SHAKETREEUSERCMD_PARAM_FIELD.label = 1
SHAKETREEUSERCMD_PARAM_FIELD.has_default_value = true
SHAKETREEUSERCMD_PARAM_FIELD.default_value = 87
SHAKETREEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SHAKETREEUSERCMD_PARAM_FIELD.type = 14
SHAKETREEUSERCMD_PARAM_FIELD.cpp_type = 8
SHAKETREEUSERCMD_NPCID_FIELD.name = "npcid"
SHAKETREEUSERCMD_NPCID_FIELD.full_name = ".Cmd.ShakeTreeUserCmd.npcid"
SHAKETREEUSERCMD_NPCID_FIELD.number = 3
SHAKETREEUSERCMD_NPCID_FIELD.index = 2
SHAKETREEUSERCMD_NPCID_FIELD.label = 1
SHAKETREEUSERCMD_NPCID_FIELD.has_default_value = true
SHAKETREEUSERCMD_NPCID_FIELD.default_value = 0
SHAKETREEUSERCMD_NPCID_FIELD.type = 4
SHAKETREEUSERCMD_NPCID_FIELD.cpp_type = 4
SHAKETREEUSERCMD_RESULT_FIELD.name = "result"
SHAKETREEUSERCMD_RESULT_FIELD.full_name = ".Cmd.ShakeTreeUserCmd.result"
SHAKETREEUSERCMD_RESULT_FIELD.number = 4
SHAKETREEUSERCMD_RESULT_FIELD.index = 3
SHAKETREEUSERCMD_RESULT_FIELD.label = 1
SHAKETREEUSERCMD_RESULT_FIELD.has_default_value = true
SHAKETREEUSERCMD_RESULT_FIELD.default_value = 0
SHAKETREEUSERCMD_RESULT_FIELD.enum_type = ETREESTATUS
SHAKETREEUSERCMD_RESULT_FIELD.type = 14
SHAKETREEUSERCMD_RESULT_FIELD.cpp_type = 8
SHAKETREEUSERCMD.name = "ShakeTreeUserCmd"
SHAKETREEUSERCMD.full_name = ".Cmd.ShakeTreeUserCmd"
SHAKETREEUSERCMD.nested_types = {}
SHAKETREEUSERCMD.enum_types = {}
SHAKETREEUSERCMD.fields = {
  SHAKETREEUSERCMD_CMD_FIELD,
  SHAKETREEUSERCMD_PARAM_FIELD,
  SHAKETREEUSERCMD_NPCID_FIELD,
  SHAKETREEUSERCMD_RESULT_FIELD
}
SHAKETREEUSERCMD.is_extendable = false
SHAKETREEUSERCMD.extensions = {}
TREE_ID_FIELD.name = "id"
TREE_ID_FIELD.full_name = ".Cmd.Tree.id"
TREE_ID_FIELD.number = 1
TREE_ID_FIELD.index = 0
TREE_ID_FIELD.label = 1
TREE_ID_FIELD.has_default_value = true
TREE_ID_FIELD.default_value = 0
TREE_ID_FIELD.type = 4
TREE_ID_FIELD.cpp_type = 4
TREE_TYPEID_FIELD.name = "typeid"
TREE_TYPEID_FIELD.full_name = ".Cmd.Tree.typeid"
TREE_TYPEID_FIELD.number = 2
TREE_TYPEID_FIELD.index = 1
TREE_TYPEID_FIELD.label = 1
TREE_TYPEID_FIELD.has_default_value = true
TREE_TYPEID_FIELD.default_value = 0
TREE_TYPEID_FIELD.type = 13
TREE_TYPEID_FIELD.cpp_type = 3
TREE_POS_FIELD.name = "pos"
TREE_POS_FIELD.full_name = ".Cmd.Tree.pos"
TREE_POS_FIELD.number = 3
TREE_POS_FIELD.index = 2
TREE_POS_FIELD.label = 1
TREE_POS_FIELD.has_default_value = false
TREE_POS_FIELD.default_value = nil
TREE_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
TREE_POS_FIELD.type = 11
TREE_POS_FIELD.cpp_type = 10
TREE.name = "Tree"
TREE.full_name = ".Cmd.Tree"
TREE.nested_types = {}
TREE.enum_types = {}
TREE.fields = {
  TREE_ID_FIELD,
  TREE_TYPEID_FIELD,
  TREE_POS_FIELD
}
TREE.is_extendable = false
TREE.extensions = {}
TREELISTUSERCMD_CMD_FIELD.name = "cmd"
TREELISTUSERCMD_CMD_FIELD.full_name = ".Cmd.TreeListUserCmd.cmd"
TREELISTUSERCMD_CMD_FIELD.number = 1
TREELISTUSERCMD_CMD_FIELD.index = 0
TREELISTUSERCMD_CMD_FIELD.label = 1
TREELISTUSERCMD_CMD_FIELD.has_default_value = true
TREELISTUSERCMD_CMD_FIELD.default_value = 9
TREELISTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TREELISTUSERCMD_CMD_FIELD.type = 14
TREELISTUSERCMD_CMD_FIELD.cpp_type = 8
TREELISTUSERCMD_PARAM_FIELD.name = "param"
TREELISTUSERCMD_PARAM_FIELD.full_name = ".Cmd.TreeListUserCmd.param"
TREELISTUSERCMD_PARAM_FIELD.number = 2
TREELISTUSERCMD_PARAM_FIELD.index = 1
TREELISTUSERCMD_PARAM_FIELD.label = 1
TREELISTUSERCMD_PARAM_FIELD.has_default_value = true
TREELISTUSERCMD_PARAM_FIELD.default_value = 88
TREELISTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
TREELISTUSERCMD_PARAM_FIELD.type = 14
TREELISTUSERCMD_PARAM_FIELD.cpp_type = 8
TREELISTUSERCMD_UPDATES_FIELD.name = "updates"
TREELISTUSERCMD_UPDATES_FIELD.full_name = ".Cmd.TreeListUserCmd.updates"
TREELISTUSERCMD_UPDATES_FIELD.number = 3
TREELISTUSERCMD_UPDATES_FIELD.index = 2
TREELISTUSERCMD_UPDATES_FIELD.label = 3
TREELISTUSERCMD_UPDATES_FIELD.has_default_value = false
TREELISTUSERCMD_UPDATES_FIELD.default_value = {}
TREELISTUSERCMD_UPDATES_FIELD.message_type = TREE
TREELISTUSERCMD_UPDATES_FIELD.type = 11
TREELISTUSERCMD_UPDATES_FIELD.cpp_type = 10
TREELISTUSERCMD_DELS_FIELD.name = "dels"
TREELISTUSERCMD_DELS_FIELD.full_name = ".Cmd.TreeListUserCmd.dels"
TREELISTUSERCMD_DELS_FIELD.number = 4
TREELISTUSERCMD_DELS_FIELD.index = 3
TREELISTUSERCMD_DELS_FIELD.label = 3
TREELISTUSERCMD_DELS_FIELD.has_default_value = false
TREELISTUSERCMD_DELS_FIELD.default_value = {}
TREELISTUSERCMD_DELS_FIELD.type = 4
TREELISTUSERCMD_DELS_FIELD.cpp_type = 4
TREELISTUSERCMD.name = "TreeListUserCmd"
TREELISTUSERCMD.full_name = ".Cmd.TreeListUserCmd"
TREELISTUSERCMD.nested_types = {}
TREELISTUSERCMD.enum_types = {}
TREELISTUSERCMD.fields = {
  TREELISTUSERCMD_CMD_FIELD,
  TREELISTUSERCMD_PARAM_FIELD,
  TREELISTUSERCMD_UPDATES_FIELD,
  TREELISTUSERCMD_DELS_FIELD
}
TREELISTUSERCMD.is_extendable = false
TREELISTUSERCMD.extensions = {}
ACTIVITYNTFUSERCMD_CMD_FIELD.name = "cmd"
ACTIVITYNTFUSERCMD_CMD_FIELD.full_name = ".Cmd.ActivityNtfUserCmd.cmd"
ACTIVITYNTFUSERCMD_CMD_FIELD.number = 1
ACTIVITYNTFUSERCMD_CMD_FIELD.index = 0
ACTIVITYNTFUSERCMD_CMD_FIELD.label = 1
ACTIVITYNTFUSERCMD_CMD_FIELD.has_default_value = true
ACTIVITYNTFUSERCMD_CMD_FIELD.default_value = 9
ACTIVITYNTFUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ACTIVITYNTFUSERCMD_CMD_FIELD.type = 14
ACTIVITYNTFUSERCMD_CMD_FIELD.cpp_type = 8
ACTIVITYNTFUSERCMD_PARAM_FIELD.name = "param"
ACTIVITYNTFUSERCMD_PARAM_FIELD.full_name = ".Cmd.ActivityNtfUserCmd.param"
ACTIVITYNTFUSERCMD_PARAM_FIELD.number = 2
ACTIVITYNTFUSERCMD_PARAM_FIELD.index = 1
ACTIVITYNTFUSERCMD_PARAM_FIELD.label = 1
ACTIVITYNTFUSERCMD_PARAM_FIELD.has_default_value = true
ACTIVITYNTFUSERCMD_PARAM_FIELD.default_value = 89
ACTIVITYNTFUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
ACTIVITYNTFUSERCMD_PARAM_FIELD.type = 14
ACTIVITYNTFUSERCMD_PARAM_FIELD.cpp_type = 8
ACTIVITYNTFUSERCMD_ID_FIELD.name = "id"
ACTIVITYNTFUSERCMD_ID_FIELD.full_name = ".Cmd.ActivityNtfUserCmd.id"
ACTIVITYNTFUSERCMD_ID_FIELD.number = 3
ACTIVITYNTFUSERCMD_ID_FIELD.index = 2
ACTIVITYNTFUSERCMD_ID_FIELD.label = 1
ACTIVITYNTFUSERCMD_ID_FIELD.has_default_value = false
ACTIVITYNTFUSERCMD_ID_FIELD.default_value = 0
ACTIVITYNTFUSERCMD_ID_FIELD.type = 13
ACTIVITYNTFUSERCMD_ID_FIELD.cpp_type = 3
ACTIVITYNTFUSERCMD_MAPID_FIELD.name = "mapid"
ACTIVITYNTFUSERCMD_MAPID_FIELD.full_name = ".Cmd.ActivityNtfUserCmd.mapid"
ACTIVITYNTFUSERCMD_MAPID_FIELD.number = 4
ACTIVITYNTFUSERCMD_MAPID_FIELD.index = 3
ACTIVITYNTFUSERCMD_MAPID_FIELD.label = 1
ACTIVITYNTFUSERCMD_MAPID_FIELD.has_default_value = true
ACTIVITYNTFUSERCMD_MAPID_FIELD.default_value = 0
ACTIVITYNTFUSERCMD_MAPID_FIELD.type = 13
ACTIVITYNTFUSERCMD_MAPID_FIELD.cpp_type = 3
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.name = "endtime"
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.full_name = ".Cmd.ActivityNtfUserCmd.endtime"
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.number = 5
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.index = 4
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.label = 1
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.has_default_value = true
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.default_value = 0
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.type = 13
ACTIVITYNTFUSERCMD_ENDTIME_FIELD.cpp_type = 3
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.name = "progress"
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.full_name = ".Cmd.ActivityNtfUserCmd.progress"
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.number = 6
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.index = 5
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.label = 1
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.has_default_value = false
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.default_value = 0
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.type = 13
ACTIVITYNTFUSERCMD_PROGRESS_FIELD.cpp_type = 3
ACTIVITYNTFUSERCMD.name = "ActivityNtfUserCmd"
ACTIVITYNTFUSERCMD.full_name = ".Cmd.ActivityNtfUserCmd"
ACTIVITYNTFUSERCMD.nested_types = {}
ACTIVITYNTFUSERCMD.enum_types = {}
ACTIVITYNTFUSERCMD.fields = {
  ACTIVITYNTFUSERCMD_CMD_FIELD,
  ACTIVITYNTFUSERCMD_PARAM_FIELD,
  ACTIVITYNTFUSERCMD_ID_FIELD,
  ACTIVITYNTFUSERCMD_MAPID_FIELD,
  ACTIVITYNTFUSERCMD_ENDTIME_FIELD,
  ACTIVITYNTFUSERCMD_PROGRESS_FIELD
}
ACTIVITYNTFUSERCMD.is_extendable = false
ACTIVITYNTFUSERCMD.extensions = {}
ZONEINFO_ZONEID_FIELD.name = "zoneid"
ZONEINFO_ZONEID_FIELD.full_name = ".Cmd.ZoneInfo.zoneid"
ZONEINFO_ZONEID_FIELD.number = 1
ZONEINFO_ZONEID_FIELD.index = 0
ZONEINFO_ZONEID_FIELD.label = 1
ZONEINFO_ZONEID_FIELD.has_default_value = true
ZONEINFO_ZONEID_FIELD.default_value = 0
ZONEINFO_ZONEID_FIELD.type = 13
ZONEINFO_ZONEID_FIELD.cpp_type = 3
ZONEINFO_MAXBASELV_FIELD.name = "maxbaselv"
ZONEINFO_MAXBASELV_FIELD.full_name = ".Cmd.ZoneInfo.maxbaselv"
ZONEINFO_MAXBASELV_FIELD.number = 2
ZONEINFO_MAXBASELV_FIELD.index = 1
ZONEINFO_MAXBASELV_FIELD.label = 1
ZONEINFO_MAXBASELV_FIELD.has_default_value = true
ZONEINFO_MAXBASELV_FIELD.default_value = 0
ZONEINFO_MAXBASELV_FIELD.type = 13
ZONEINFO_MAXBASELV_FIELD.cpp_type = 3
ZONEINFO_STATUS_FIELD.name = "status"
ZONEINFO_STATUS_FIELD.full_name = ".Cmd.ZoneInfo.status"
ZONEINFO_STATUS_FIELD.number = 3
ZONEINFO_STATUS_FIELD.index = 2
ZONEINFO_STATUS_FIELD.label = 1
ZONEINFO_STATUS_FIELD.has_default_value = true
ZONEINFO_STATUS_FIELD.default_value = 0
ZONEINFO_STATUS_FIELD.enum_type = EZONESTATUS
ZONEINFO_STATUS_FIELD.type = 14
ZONEINFO_STATUS_FIELD.cpp_type = 8
ZONEINFO_STATE_FIELD.name = "state"
ZONEINFO_STATE_FIELD.full_name = ".Cmd.ZoneInfo.state"
ZONEINFO_STATE_FIELD.number = 4
ZONEINFO_STATE_FIELD.index = 3
ZONEINFO_STATE_FIELD.label = 1
ZONEINFO_STATE_FIELD.has_default_value = true
ZONEINFO_STATE_FIELD.default_value = 0
ZONEINFO_STATE_FIELD.enum_type = EZONESTATE
ZONEINFO_STATE_FIELD.type = 14
ZONEINFO_STATE_FIELD.cpp_type = 8
ZONEINFO.name = "ZoneInfo"
ZONEINFO.full_name = ".Cmd.ZoneInfo"
ZONEINFO.nested_types = {}
ZONEINFO.enum_types = {}
ZONEINFO.fields = {
  ZONEINFO_ZONEID_FIELD,
  ZONEINFO_MAXBASELV_FIELD,
  ZONEINFO_STATUS_FIELD,
  ZONEINFO_STATE_FIELD
}
ZONEINFO.is_extendable = false
ZONEINFO.extensions = {}
RECENTZONEINFO_TYPE_FIELD.name = "type"
RECENTZONEINFO_TYPE_FIELD.full_name = ".Cmd.RecentZoneInfo.type"
RECENTZONEINFO_TYPE_FIELD.number = 1
RECENTZONEINFO_TYPE_FIELD.index = 0
RECENTZONEINFO_TYPE_FIELD.label = 1
RECENTZONEINFO_TYPE_FIELD.has_default_value = true
RECENTZONEINFO_TYPE_FIELD.default_value = 0
RECENTZONEINFO_TYPE_FIELD.enum_type = EJUMPZONE
RECENTZONEINFO_TYPE_FIELD.type = 14
RECENTZONEINFO_TYPE_FIELD.cpp_type = 8
RECENTZONEINFO_ZONEID_FIELD.name = "zoneid"
RECENTZONEINFO_ZONEID_FIELD.full_name = ".Cmd.RecentZoneInfo.zoneid"
RECENTZONEINFO_ZONEID_FIELD.number = 2
RECENTZONEINFO_ZONEID_FIELD.index = 1
RECENTZONEINFO_ZONEID_FIELD.label = 1
RECENTZONEINFO_ZONEID_FIELD.has_default_value = true
RECENTZONEINFO_ZONEID_FIELD.default_value = 0
RECENTZONEINFO_ZONEID_FIELD.type = 13
RECENTZONEINFO_ZONEID_FIELD.cpp_type = 3
RECENTZONEINFO.name = "RecentZoneInfo"
RECENTZONEINFO.full_name = ".Cmd.RecentZoneInfo"
RECENTZONEINFO.nested_types = {}
RECENTZONEINFO.enum_types = {}
RECENTZONEINFO.fields = {
  RECENTZONEINFO_TYPE_FIELD,
  RECENTZONEINFO_ZONEID_FIELD
}
RECENTZONEINFO.is_extendable = false
RECENTZONEINFO.extensions = {}
QUERYZONESTATUSUSERCMD_CMD_FIELD.name = "cmd"
QUERYZONESTATUSUSERCMD_CMD_FIELD.full_name = ".Cmd.QueryZoneStatusUserCmd.cmd"
QUERYZONESTATUSUSERCMD_CMD_FIELD.number = 1
QUERYZONESTATUSUSERCMD_CMD_FIELD.index = 0
QUERYZONESTATUSUSERCMD_CMD_FIELD.label = 1
QUERYZONESTATUSUSERCMD_CMD_FIELD.has_default_value = true
QUERYZONESTATUSUSERCMD_CMD_FIELD.default_value = 9
QUERYZONESTATUSUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYZONESTATUSUSERCMD_CMD_FIELD.type = 14
QUERYZONESTATUSUSERCMD_CMD_FIELD.cpp_type = 8
QUERYZONESTATUSUSERCMD_PARAM_FIELD.name = "param"
QUERYZONESTATUSUSERCMD_PARAM_FIELD.full_name = ".Cmd.QueryZoneStatusUserCmd.param"
QUERYZONESTATUSUSERCMD_PARAM_FIELD.number = 2
QUERYZONESTATUSUSERCMD_PARAM_FIELD.index = 1
QUERYZONESTATUSUSERCMD_PARAM_FIELD.label = 1
QUERYZONESTATUSUSERCMD_PARAM_FIELD.has_default_value = true
QUERYZONESTATUSUSERCMD_PARAM_FIELD.default_value = 91
QUERYZONESTATUSUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
QUERYZONESTATUSUSERCMD_PARAM_FIELD.type = 14
QUERYZONESTATUSUSERCMD_PARAM_FIELD.cpp_type = 8
QUERYZONESTATUSUSERCMD_INFOS_FIELD.name = "infos"
QUERYZONESTATUSUSERCMD_INFOS_FIELD.full_name = ".Cmd.QueryZoneStatusUserCmd.infos"
QUERYZONESTATUSUSERCMD_INFOS_FIELD.number = 3
QUERYZONESTATUSUSERCMD_INFOS_FIELD.index = 2
QUERYZONESTATUSUSERCMD_INFOS_FIELD.label = 3
QUERYZONESTATUSUSERCMD_INFOS_FIELD.has_default_value = false
QUERYZONESTATUSUSERCMD_INFOS_FIELD.default_value = {}
QUERYZONESTATUSUSERCMD_INFOS_FIELD.message_type = ZONEINFO
QUERYZONESTATUSUSERCMD_INFOS_FIELD.type = 11
QUERYZONESTATUSUSERCMD_INFOS_FIELD.cpp_type = 10
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.name = "recents"
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.full_name = ".Cmd.QueryZoneStatusUserCmd.recents"
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.number = 4
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.index = 3
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.label = 3
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.has_default_value = false
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.default_value = {}
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.message_type = RECENTZONEINFO
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.type = 11
QUERYZONESTATUSUSERCMD_RECENTS_FIELD.cpp_type = 10
QUERYZONESTATUSUSERCMD.name = "QueryZoneStatusUserCmd"
QUERYZONESTATUSUSERCMD.full_name = ".Cmd.QueryZoneStatusUserCmd"
QUERYZONESTATUSUSERCMD.nested_types = {}
QUERYZONESTATUSUSERCMD.enum_types = {}
QUERYZONESTATUSUSERCMD.fields = {
  QUERYZONESTATUSUSERCMD_CMD_FIELD,
  QUERYZONESTATUSUSERCMD_PARAM_FIELD,
  QUERYZONESTATUSUSERCMD_INFOS_FIELD,
  QUERYZONESTATUSUSERCMD_RECENTS_FIELD
}
QUERYZONESTATUSUSERCMD.is_extendable = false
QUERYZONESTATUSUSERCMD.extensions = {}
JUMPZONEUSERCMD_CMD_FIELD.name = "cmd"
JUMPZONEUSERCMD_CMD_FIELD.full_name = ".Cmd.JumpZoneUserCmd.cmd"
JUMPZONEUSERCMD_CMD_FIELD.number = 1
JUMPZONEUSERCMD_CMD_FIELD.index = 0
JUMPZONEUSERCMD_CMD_FIELD.label = 1
JUMPZONEUSERCMD_CMD_FIELD.has_default_value = true
JUMPZONEUSERCMD_CMD_FIELD.default_value = 9
JUMPZONEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
JUMPZONEUSERCMD_CMD_FIELD.type = 14
JUMPZONEUSERCMD_CMD_FIELD.cpp_type = 8
JUMPZONEUSERCMD_PARAM_FIELD.name = "param"
JUMPZONEUSERCMD_PARAM_FIELD.full_name = ".Cmd.JumpZoneUserCmd.param"
JUMPZONEUSERCMD_PARAM_FIELD.number = 2
JUMPZONEUSERCMD_PARAM_FIELD.index = 1
JUMPZONEUSERCMD_PARAM_FIELD.label = 1
JUMPZONEUSERCMD_PARAM_FIELD.has_default_value = true
JUMPZONEUSERCMD_PARAM_FIELD.default_value = 92
JUMPZONEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
JUMPZONEUSERCMD_PARAM_FIELD.type = 14
JUMPZONEUSERCMD_PARAM_FIELD.cpp_type = 8
JUMPZONEUSERCMD_NPCID_FIELD.name = "npcid"
JUMPZONEUSERCMD_NPCID_FIELD.full_name = ".Cmd.JumpZoneUserCmd.npcid"
JUMPZONEUSERCMD_NPCID_FIELD.number = 3
JUMPZONEUSERCMD_NPCID_FIELD.index = 2
JUMPZONEUSERCMD_NPCID_FIELD.label = 1
JUMPZONEUSERCMD_NPCID_FIELD.has_default_value = true
JUMPZONEUSERCMD_NPCID_FIELD.default_value = 0
JUMPZONEUSERCMD_NPCID_FIELD.type = 4
JUMPZONEUSERCMD_NPCID_FIELD.cpp_type = 4
JUMPZONEUSERCMD_ZONEID_FIELD.name = "zoneid"
JUMPZONEUSERCMD_ZONEID_FIELD.full_name = ".Cmd.JumpZoneUserCmd.zoneid"
JUMPZONEUSERCMD_ZONEID_FIELD.number = 4
JUMPZONEUSERCMD_ZONEID_FIELD.index = 3
JUMPZONEUSERCMD_ZONEID_FIELD.label = 1
JUMPZONEUSERCMD_ZONEID_FIELD.has_default_value = true
JUMPZONEUSERCMD_ZONEID_FIELD.default_value = 0
JUMPZONEUSERCMD_ZONEID_FIELD.type = 13
JUMPZONEUSERCMD_ZONEID_FIELD.cpp_type = 3
JUMPZONEUSERCMD.name = "JumpZoneUserCmd"
JUMPZONEUSERCMD.full_name = ".Cmd.JumpZoneUserCmd"
JUMPZONEUSERCMD.nested_types = {}
JUMPZONEUSERCMD.enum_types = {}
JUMPZONEUSERCMD.fields = {
  JUMPZONEUSERCMD_CMD_FIELD,
  JUMPZONEUSERCMD_PARAM_FIELD,
  JUMPZONEUSERCMD_NPCID_FIELD,
  JUMPZONEUSERCMD_ZONEID_FIELD
}
JUMPZONEUSERCMD.is_extendable = false
JUMPZONEUSERCMD.extensions = {}
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.name = "cmd"
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.full_name = ".Cmd.ItemImageUserNtfUserCmd.cmd"
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.number = 1
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.index = 0
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.label = 1
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.has_default_value = true
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.default_value = 9
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.type = 14
ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD.cpp_type = 8
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.name = "param"
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.full_name = ".Cmd.ItemImageUserNtfUserCmd.param"
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.number = 2
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.index = 1
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.label = 1
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.has_default_value = true
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.default_value = 93
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.type = 14
ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD.cpp_type = 8
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.name = "userid"
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.full_name = ".Cmd.ItemImageUserNtfUserCmd.userid"
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.number = 3
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.index = 2
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.label = 1
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.has_default_value = true
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.default_value = 0
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.type = 4
ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD.cpp_type = 4
ITEMIMAGEUSERNTFUSERCMD.name = "ItemImageUserNtfUserCmd"
ITEMIMAGEUSERNTFUSERCMD.full_name = ".Cmd.ItemImageUserNtfUserCmd"
ITEMIMAGEUSERNTFUSERCMD.nested_types = {}
ITEMIMAGEUSERNTFUSERCMD.enum_types = {}
ITEMIMAGEUSERNTFUSERCMD.fields = {
  ITEMIMAGEUSERNTFUSERCMD_CMD_FIELD,
  ITEMIMAGEUSERNTFUSERCMD_PARAM_FIELD,
  ITEMIMAGEUSERNTFUSERCMD_USERID_FIELD
}
ITEMIMAGEUSERNTFUSERCMD.is_extendable = false
ITEMIMAGEUSERNTFUSERCMD.extensions = {}
INVITEFOLLOWUSERCMD_CMD_FIELD.name = "cmd"
INVITEFOLLOWUSERCMD_CMD_FIELD.full_name = ".Cmd.InviteFollowUserCmd.cmd"
INVITEFOLLOWUSERCMD_CMD_FIELD.number = 1
INVITEFOLLOWUSERCMD_CMD_FIELD.index = 0
INVITEFOLLOWUSERCMD_CMD_FIELD.label = 1
INVITEFOLLOWUSERCMD_CMD_FIELD.has_default_value = true
INVITEFOLLOWUSERCMD_CMD_FIELD.default_value = 9
INVITEFOLLOWUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITEFOLLOWUSERCMD_CMD_FIELD.type = 14
INVITEFOLLOWUSERCMD_CMD_FIELD.cpp_type = 8
INVITEFOLLOWUSERCMD_PARAM_FIELD.name = "param"
INVITEFOLLOWUSERCMD_PARAM_FIELD.full_name = ".Cmd.InviteFollowUserCmd.param"
INVITEFOLLOWUSERCMD_PARAM_FIELD.number = 2
INVITEFOLLOWUSERCMD_PARAM_FIELD.index = 1
INVITEFOLLOWUSERCMD_PARAM_FIELD.label = 1
INVITEFOLLOWUSERCMD_PARAM_FIELD.has_default_value = true
INVITEFOLLOWUSERCMD_PARAM_FIELD.default_value = 97
INVITEFOLLOWUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
INVITEFOLLOWUSERCMD_PARAM_FIELD.type = 14
INVITEFOLLOWUSERCMD_PARAM_FIELD.cpp_type = 8
INVITEFOLLOWUSERCMD_CHARID_FIELD.name = "charid"
INVITEFOLLOWUSERCMD_CHARID_FIELD.full_name = ".Cmd.InviteFollowUserCmd.charid"
INVITEFOLLOWUSERCMD_CHARID_FIELD.number = 3
INVITEFOLLOWUSERCMD_CHARID_FIELD.index = 2
INVITEFOLLOWUSERCMD_CHARID_FIELD.label = 1
INVITEFOLLOWUSERCMD_CHARID_FIELD.has_default_value = true
INVITEFOLLOWUSERCMD_CHARID_FIELD.default_value = 0
INVITEFOLLOWUSERCMD_CHARID_FIELD.type = 4
INVITEFOLLOWUSERCMD_CHARID_FIELD.cpp_type = 4
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.name = "follow"
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.full_name = ".Cmd.InviteFollowUserCmd.follow"
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.number = 4
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.index = 3
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.label = 1
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.has_default_value = true
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.default_value = true
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.type = 8
INVITEFOLLOWUSERCMD_FOLLOW_FIELD.cpp_type = 7
INVITEFOLLOWUSERCMD.name = "InviteFollowUserCmd"
INVITEFOLLOWUSERCMD.full_name = ".Cmd.InviteFollowUserCmd"
INVITEFOLLOWUSERCMD.nested_types = {}
INVITEFOLLOWUSERCMD.enum_types = {}
INVITEFOLLOWUSERCMD.fields = {
  INVITEFOLLOWUSERCMD_CMD_FIELD,
  INVITEFOLLOWUSERCMD_PARAM_FIELD,
  INVITEFOLLOWUSERCMD_CHARID_FIELD,
  INVITEFOLLOWUSERCMD_FOLLOW_FIELD
}
INVITEFOLLOWUSERCMD.is_extendable = false
INVITEFOLLOWUSERCMD.extensions = {}
CHANGENAMEUSERCMD_CMD_FIELD.name = "cmd"
CHANGENAMEUSERCMD_CMD_FIELD.full_name = ".Cmd.ChangeNameUserCmd.cmd"
CHANGENAMEUSERCMD_CMD_FIELD.number = 1
CHANGENAMEUSERCMD_CMD_FIELD.index = 0
CHANGENAMEUSERCMD_CMD_FIELD.label = 1
CHANGENAMEUSERCMD_CMD_FIELD.has_default_value = true
CHANGENAMEUSERCMD_CMD_FIELD.default_value = 9
CHANGENAMEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHANGENAMEUSERCMD_CMD_FIELD.type = 14
CHANGENAMEUSERCMD_CMD_FIELD.cpp_type = 8
CHANGENAMEUSERCMD_PARAM_FIELD.name = "param"
CHANGENAMEUSERCMD_PARAM_FIELD.full_name = ".Cmd.ChangeNameUserCmd.param"
CHANGENAMEUSERCMD_PARAM_FIELD.number = 2
CHANGENAMEUSERCMD_PARAM_FIELD.index = 1
CHANGENAMEUSERCMD_PARAM_FIELD.label = 1
CHANGENAMEUSERCMD_PARAM_FIELD.has_default_value = true
CHANGENAMEUSERCMD_PARAM_FIELD.default_value = 98
CHANGENAMEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CHANGENAMEUSERCMD_PARAM_FIELD.type = 14
CHANGENAMEUSERCMD_PARAM_FIELD.cpp_type = 8
CHANGENAMEUSERCMD_NAME_FIELD.name = "name"
CHANGENAMEUSERCMD_NAME_FIELD.full_name = ".Cmd.ChangeNameUserCmd.name"
CHANGENAMEUSERCMD_NAME_FIELD.number = 3
CHANGENAMEUSERCMD_NAME_FIELD.index = 2
CHANGENAMEUSERCMD_NAME_FIELD.label = 1
CHANGENAMEUSERCMD_NAME_FIELD.has_default_value = false
CHANGENAMEUSERCMD_NAME_FIELD.default_value = ""
CHANGENAMEUSERCMD_NAME_FIELD.type = 9
CHANGENAMEUSERCMD_NAME_FIELD.cpp_type = 9
CHANGENAMEUSERCMD.name = "ChangeNameUserCmd"
CHANGENAMEUSERCMD.full_name = ".Cmd.ChangeNameUserCmd"
CHANGENAMEUSERCMD.nested_types = {}
CHANGENAMEUSERCMD.enum_types = {}
CHANGENAMEUSERCMD.fields = {
  CHANGENAMEUSERCMD_CMD_FIELD,
  CHANGENAMEUSERCMD_PARAM_FIELD,
  CHANGENAMEUSERCMD_NAME_FIELD
}
CHANGENAMEUSERCMD.is_extendable = false
CHANGENAMEUSERCMD.extensions = {}
CHARGEPLAYUSERCMD_CMD_FIELD.name = "cmd"
CHARGEPLAYUSERCMD_CMD_FIELD.full_name = ".Cmd.ChargePlayUserCmd.cmd"
CHARGEPLAYUSERCMD_CMD_FIELD.number = 1
CHARGEPLAYUSERCMD_CMD_FIELD.index = 0
CHARGEPLAYUSERCMD_CMD_FIELD.label = 1
CHARGEPLAYUSERCMD_CMD_FIELD.has_default_value = true
CHARGEPLAYUSERCMD_CMD_FIELD.default_value = 9
CHARGEPLAYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHARGEPLAYUSERCMD_CMD_FIELD.type = 14
CHARGEPLAYUSERCMD_CMD_FIELD.cpp_type = 8
CHARGEPLAYUSERCMD_PARAM_FIELD.name = "param"
CHARGEPLAYUSERCMD_PARAM_FIELD.full_name = ".Cmd.ChargePlayUserCmd.param"
CHARGEPLAYUSERCMD_PARAM_FIELD.number = 2
CHARGEPLAYUSERCMD_PARAM_FIELD.index = 1
CHARGEPLAYUSERCMD_PARAM_FIELD.label = 1
CHARGEPLAYUSERCMD_PARAM_FIELD.has_default_value = true
CHARGEPLAYUSERCMD_PARAM_FIELD.default_value = 99
CHARGEPLAYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CHARGEPLAYUSERCMD_PARAM_FIELD.type = 14
CHARGEPLAYUSERCMD_PARAM_FIELD.cpp_type = 8
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.name = "chargeids"
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.full_name = ".Cmd.ChargePlayUserCmd.chargeids"
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.number = 3
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.index = 2
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.label = 3
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.has_default_value = false
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.default_value = {}
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.type = 13
CHARGEPLAYUSERCMD_CHARGEIDS_FIELD.cpp_type = 3
CHARGEPLAYUSERCMD.name = "ChargePlayUserCmd"
CHARGEPLAYUSERCMD.full_name = ".Cmd.ChargePlayUserCmd"
CHARGEPLAYUSERCMD.nested_types = {}
CHARGEPLAYUSERCMD.enum_types = {}
CHARGEPLAYUSERCMD.fields = {
  CHARGEPLAYUSERCMD_CMD_FIELD,
  CHARGEPLAYUSERCMD_PARAM_FIELD,
  CHARGEPLAYUSERCMD_CHARGEIDS_FIELD
}
CHARGEPLAYUSERCMD.is_extendable = false
CHARGEPLAYUSERCMD.extensions = {}
REQUIRENPCFUNCUSERCMD_CMD_FIELD.name = "cmd"
REQUIRENPCFUNCUSERCMD_CMD_FIELD.full_name = ".Cmd.RequireNpcFuncUserCmd.cmd"
REQUIRENPCFUNCUSERCMD_CMD_FIELD.number = 1
REQUIRENPCFUNCUSERCMD_CMD_FIELD.index = 0
REQUIRENPCFUNCUSERCMD_CMD_FIELD.label = 1
REQUIRENPCFUNCUSERCMD_CMD_FIELD.has_default_value = true
REQUIRENPCFUNCUSERCMD_CMD_FIELD.default_value = 9
REQUIRENPCFUNCUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REQUIRENPCFUNCUSERCMD_CMD_FIELD.type = 14
REQUIRENPCFUNCUSERCMD_CMD_FIELD.cpp_type = 8
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.name = "param"
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.full_name = ".Cmd.RequireNpcFuncUserCmd.param"
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.number = 2
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.index = 1
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.label = 1
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.has_default_value = true
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.default_value = 100
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.type = 14
REQUIRENPCFUNCUSERCMD_PARAM_FIELD.cpp_type = 8
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.name = "npcid"
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.full_name = ".Cmd.RequireNpcFuncUserCmd.npcid"
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.number = 3
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.index = 2
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.label = 1
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.has_default_value = true
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.default_value = 0
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.type = 13
REQUIRENPCFUNCUSERCMD_NPCID_FIELD.cpp_type = 3
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.name = "functions"
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.full_name = ".Cmd.RequireNpcFuncUserCmd.functions"
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.number = 4
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.index = 3
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.label = 3
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.has_default_value = false
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.default_value = {}
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.type = 9
REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD.cpp_type = 9
REQUIRENPCFUNCUSERCMD.name = "RequireNpcFuncUserCmd"
REQUIRENPCFUNCUSERCMD.full_name = ".Cmd.RequireNpcFuncUserCmd"
REQUIRENPCFUNCUSERCMD.nested_types = {}
REQUIRENPCFUNCUSERCMD.enum_types = {}
REQUIRENPCFUNCUSERCMD.fields = {
  REQUIRENPCFUNCUSERCMD_CMD_FIELD,
  REQUIRENPCFUNCUSERCMD_PARAM_FIELD,
  REQUIRENPCFUNCUSERCMD_NPCID_FIELD,
  REQUIRENPCFUNCUSERCMD_FUNCTIONS_FIELD
}
REQUIRENPCFUNCUSERCMD.is_extendable = false
REQUIRENPCFUNCUSERCMD.extensions = {}
CHECKSEATUSERCMD_CMD_FIELD.name = "cmd"
CHECKSEATUSERCMD_CMD_FIELD.full_name = ".Cmd.CheckSeatUserCmd.cmd"
CHECKSEATUSERCMD_CMD_FIELD.number = 1
CHECKSEATUSERCMD_CMD_FIELD.index = 0
CHECKSEATUSERCMD_CMD_FIELD.label = 1
CHECKSEATUSERCMD_CMD_FIELD.has_default_value = true
CHECKSEATUSERCMD_CMD_FIELD.default_value = 9
CHECKSEATUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHECKSEATUSERCMD_CMD_FIELD.type = 14
CHECKSEATUSERCMD_CMD_FIELD.cpp_type = 8
CHECKSEATUSERCMD_PARAM_FIELD.name = "param"
CHECKSEATUSERCMD_PARAM_FIELD.full_name = ".Cmd.CheckSeatUserCmd.param"
CHECKSEATUSERCMD_PARAM_FIELD.number = 2
CHECKSEATUSERCMD_PARAM_FIELD.index = 1
CHECKSEATUSERCMD_PARAM_FIELD.label = 1
CHECKSEATUSERCMD_PARAM_FIELD.has_default_value = true
CHECKSEATUSERCMD_PARAM_FIELD.default_value = 101
CHECKSEATUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CHECKSEATUSERCMD_PARAM_FIELD.type = 14
CHECKSEATUSERCMD_PARAM_FIELD.cpp_type = 8
CHECKSEATUSERCMD_SEATID_FIELD.name = "seatid"
CHECKSEATUSERCMD_SEATID_FIELD.full_name = ".Cmd.CheckSeatUserCmd.seatid"
CHECKSEATUSERCMD_SEATID_FIELD.number = 3
CHECKSEATUSERCMD_SEATID_FIELD.index = 2
CHECKSEATUSERCMD_SEATID_FIELD.label = 1
CHECKSEATUSERCMD_SEATID_FIELD.has_default_value = true
CHECKSEATUSERCMD_SEATID_FIELD.default_value = 0
CHECKSEATUSERCMD_SEATID_FIELD.type = 13
CHECKSEATUSERCMD_SEATID_FIELD.cpp_type = 3
CHECKSEATUSERCMD_SUCCESS_FIELD.name = "success"
CHECKSEATUSERCMD_SUCCESS_FIELD.full_name = ".Cmd.CheckSeatUserCmd.success"
CHECKSEATUSERCMD_SUCCESS_FIELD.number = 4
CHECKSEATUSERCMD_SUCCESS_FIELD.index = 3
CHECKSEATUSERCMD_SUCCESS_FIELD.label = 1
CHECKSEATUSERCMD_SUCCESS_FIELD.has_default_value = false
CHECKSEATUSERCMD_SUCCESS_FIELD.default_value = false
CHECKSEATUSERCMD_SUCCESS_FIELD.type = 8
CHECKSEATUSERCMD_SUCCESS_FIELD.cpp_type = 7
CHECKSEATUSERCMD.name = "CheckSeatUserCmd"
CHECKSEATUSERCMD.full_name = ".Cmd.CheckSeatUserCmd"
CHECKSEATUSERCMD.nested_types = {}
CHECKSEATUSERCMD.enum_types = {}
CHECKSEATUSERCMD.fields = {
  CHECKSEATUSERCMD_CMD_FIELD,
  CHECKSEATUSERCMD_PARAM_FIELD,
  CHECKSEATUSERCMD_SEATID_FIELD,
  CHECKSEATUSERCMD_SUCCESS_FIELD
}
CHECKSEATUSERCMD.is_extendable = false
CHECKSEATUSERCMD.extensions = {}
NTFSEATUSERCMD_CMD_FIELD.name = "cmd"
NTFSEATUSERCMD_CMD_FIELD.full_name = ".Cmd.NtfSeatUserCmd.cmd"
NTFSEATUSERCMD_CMD_FIELD.number = 1
NTFSEATUSERCMD_CMD_FIELD.index = 0
NTFSEATUSERCMD_CMD_FIELD.label = 1
NTFSEATUSERCMD_CMD_FIELD.has_default_value = true
NTFSEATUSERCMD_CMD_FIELD.default_value = 9
NTFSEATUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NTFSEATUSERCMD_CMD_FIELD.type = 14
NTFSEATUSERCMD_CMD_FIELD.cpp_type = 8
NTFSEATUSERCMD_PARAM_FIELD.name = "param"
NTFSEATUSERCMD_PARAM_FIELD.full_name = ".Cmd.NtfSeatUserCmd.param"
NTFSEATUSERCMD_PARAM_FIELD.number = 2
NTFSEATUSERCMD_PARAM_FIELD.index = 1
NTFSEATUSERCMD_PARAM_FIELD.label = 1
NTFSEATUSERCMD_PARAM_FIELD.has_default_value = true
NTFSEATUSERCMD_PARAM_FIELD.default_value = 102
NTFSEATUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
NTFSEATUSERCMD_PARAM_FIELD.type = 14
NTFSEATUSERCMD_PARAM_FIELD.cpp_type = 8
NTFSEATUSERCMD_CHARID_FIELD.name = "charid"
NTFSEATUSERCMD_CHARID_FIELD.full_name = ".Cmd.NtfSeatUserCmd.charid"
NTFSEATUSERCMD_CHARID_FIELD.number = 3
NTFSEATUSERCMD_CHARID_FIELD.index = 2
NTFSEATUSERCMD_CHARID_FIELD.label = 1
NTFSEATUSERCMD_CHARID_FIELD.has_default_value = false
NTFSEATUSERCMD_CHARID_FIELD.default_value = 0
NTFSEATUSERCMD_CHARID_FIELD.type = 4
NTFSEATUSERCMD_CHARID_FIELD.cpp_type = 4
NTFSEATUSERCMD_SEATID_FIELD.name = "seatid"
NTFSEATUSERCMD_SEATID_FIELD.full_name = ".Cmd.NtfSeatUserCmd.seatid"
NTFSEATUSERCMD_SEATID_FIELD.number = 4
NTFSEATUSERCMD_SEATID_FIELD.index = 3
NTFSEATUSERCMD_SEATID_FIELD.label = 1
NTFSEATUSERCMD_SEATID_FIELD.has_default_value = false
NTFSEATUSERCMD_SEATID_FIELD.default_value = 0
NTFSEATUSERCMD_SEATID_FIELD.type = 13
NTFSEATUSERCMD_SEATID_FIELD.cpp_type = 3
NTFSEATUSERCMD_ISSEATDOWN_FIELD.name = "isseatdown"
NTFSEATUSERCMD_ISSEATDOWN_FIELD.full_name = ".Cmd.NtfSeatUserCmd.isseatdown"
NTFSEATUSERCMD_ISSEATDOWN_FIELD.number = 5
NTFSEATUSERCMD_ISSEATDOWN_FIELD.index = 4
NTFSEATUSERCMD_ISSEATDOWN_FIELD.label = 1
NTFSEATUSERCMD_ISSEATDOWN_FIELD.has_default_value = false
NTFSEATUSERCMD_ISSEATDOWN_FIELD.default_value = false
NTFSEATUSERCMD_ISSEATDOWN_FIELD.type = 8
NTFSEATUSERCMD_ISSEATDOWN_FIELD.cpp_type = 7
NTFSEATUSERCMD.name = "NtfSeatUserCmd"
NTFSEATUSERCMD.full_name = ".Cmd.NtfSeatUserCmd"
NTFSEATUSERCMD.nested_types = {}
NTFSEATUSERCMD.enum_types = {}
NTFSEATUSERCMD.fields = {
  NTFSEATUSERCMD_CMD_FIELD,
  NTFSEATUSERCMD_PARAM_FIELD,
  NTFSEATUSERCMD_CHARID_FIELD,
  NTFSEATUSERCMD_SEATID_FIELD,
  NTFSEATUSERCMD_ISSEATDOWN_FIELD
}
NTFSEATUSERCMD.is_extendable = false
NTFSEATUSERCMD.extensions = {}
YOYOSEATUSERCMD_CMD_FIELD.name = "cmd"
YOYOSEATUSERCMD_CMD_FIELD.full_name = ".Cmd.YoyoSeatUserCmd.cmd"
YOYOSEATUSERCMD_CMD_FIELD.number = 1
YOYOSEATUSERCMD_CMD_FIELD.index = 0
YOYOSEATUSERCMD_CMD_FIELD.label = 1
YOYOSEATUSERCMD_CMD_FIELD.has_default_value = true
YOYOSEATUSERCMD_CMD_FIELD.default_value = 9
YOYOSEATUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
YOYOSEATUSERCMD_CMD_FIELD.type = 14
YOYOSEATUSERCMD_CMD_FIELD.cpp_type = 8
YOYOSEATUSERCMD_PARAM_FIELD.name = "param"
YOYOSEATUSERCMD_PARAM_FIELD.full_name = ".Cmd.YoyoSeatUserCmd.param"
YOYOSEATUSERCMD_PARAM_FIELD.number = 2
YOYOSEATUSERCMD_PARAM_FIELD.index = 1
YOYOSEATUSERCMD_PARAM_FIELD.label = 1
YOYOSEATUSERCMD_PARAM_FIELD.has_default_value = true
YOYOSEATUSERCMD_PARAM_FIELD.default_value = 114
YOYOSEATUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
YOYOSEATUSERCMD_PARAM_FIELD.type = 14
YOYOSEATUSERCMD_PARAM_FIELD.cpp_type = 8
YOYOSEATUSERCMD_GUID_FIELD.name = "guid"
YOYOSEATUSERCMD_GUID_FIELD.full_name = ".Cmd.YoyoSeatUserCmd.guid"
YOYOSEATUSERCMD_GUID_FIELD.number = 3
YOYOSEATUSERCMD_GUID_FIELD.index = 2
YOYOSEATUSERCMD_GUID_FIELD.label = 1
YOYOSEATUSERCMD_GUID_FIELD.has_default_value = true
YOYOSEATUSERCMD_GUID_FIELD.default_value = 0
YOYOSEATUSERCMD_GUID_FIELD.type = 4
YOYOSEATUSERCMD_GUID_FIELD.cpp_type = 4
YOYOSEATUSERCMD.name = "YoyoSeatUserCmd"
YOYOSEATUSERCMD.full_name = ".Cmd.YoyoSeatUserCmd"
YOYOSEATUSERCMD.nested_types = {}
YOYOSEATUSERCMD.enum_types = {}
YOYOSEATUSERCMD.fields = {
  YOYOSEATUSERCMD_CMD_FIELD,
  YOYOSEATUSERCMD_PARAM_FIELD,
  YOYOSEATUSERCMD_GUID_FIELD
}
YOYOSEATUSERCMD.is_extendable = false
YOYOSEATUSERCMD.extensions = {}
SHOWSEATUSERCMD_CMD_FIELD.name = "cmd"
SHOWSEATUSERCMD_CMD_FIELD.full_name = ".Cmd.ShowSeatUserCmd.cmd"
SHOWSEATUSERCMD_CMD_FIELD.number = 1
SHOWSEATUSERCMD_CMD_FIELD.index = 0
SHOWSEATUSERCMD_CMD_FIELD.label = 1
SHOWSEATUSERCMD_CMD_FIELD.has_default_value = true
SHOWSEATUSERCMD_CMD_FIELD.default_value = 9
SHOWSEATUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SHOWSEATUSERCMD_CMD_FIELD.type = 14
SHOWSEATUSERCMD_CMD_FIELD.cpp_type = 8
SHOWSEATUSERCMD_PARAM_FIELD.name = "param"
SHOWSEATUSERCMD_PARAM_FIELD.full_name = ".Cmd.ShowSeatUserCmd.param"
SHOWSEATUSERCMD_PARAM_FIELD.number = 2
SHOWSEATUSERCMD_PARAM_FIELD.index = 1
SHOWSEATUSERCMD_PARAM_FIELD.label = 1
SHOWSEATUSERCMD_PARAM_FIELD.has_default_value = true
SHOWSEATUSERCMD_PARAM_FIELD.default_value = 115
SHOWSEATUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SHOWSEATUSERCMD_PARAM_FIELD.type = 14
SHOWSEATUSERCMD_PARAM_FIELD.cpp_type = 8
SHOWSEATUSERCMD_SEATID_FIELD.name = "seatid"
SHOWSEATUSERCMD_SEATID_FIELD.full_name = ".Cmd.ShowSeatUserCmd.seatid"
SHOWSEATUSERCMD_SEATID_FIELD.number = 3
SHOWSEATUSERCMD_SEATID_FIELD.index = 2
SHOWSEATUSERCMD_SEATID_FIELD.label = 3
SHOWSEATUSERCMD_SEATID_FIELD.has_default_value = false
SHOWSEATUSERCMD_SEATID_FIELD.default_value = {}
SHOWSEATUSERCMD_SEATID_FIELD.type = 13
SHOWSEATUSERCMD_SEATID_FIELD.cpp_type = 3
SHOWSEATUSERCMD_SHOW_FIELD.name = "show"
SHOWSEATUSERCMD_SHOW_FIELD.full_name = ".Cmd.ShowSeatUserCmd.show"
SHOWSEATUSERCMD_SHOW_FIELD.number = 4
SHOWSEATUSERCMD_SHOW_FIELD.index = 3
SHOWSEATUSERCMD_SHOW_FIELD.label = 1
SHOWSEATUSERCMD_SHOW_FIELD.has_default_value = true
SHOWSEATUSERCMD_SHOW_FIELD.default_value = 0
SHOWSEATUSERCMD_SHOW_FIELD.enum_type = SEATSHOWTYPE
SHOWSEATUSERCMD_SHOW_FIELD.type = 14
SHOWSEATUSERCMD_SHOW_FIELD.cpp_type = 8
SHOWSEATUSERCMD.name = "ShowSeatUserCmd"
SHOWSEATUSERCMD.full_name = ".Cmd.ShowSeatUserCmd"
SHOWSEATUSERCMD.nested_types = {}
SHOWSEATUSERCMD.enum_types = {}
SHOWSEATUSERCMD.fields = {
  SHOWSEATUSERCMD_CMD_FIELD,
  SHOWSEATUSERCMD_PARAM_FIELD,
  SHOWSEATUSERCMD_SEATID_FIELD,
  SHOWSEATUSERCMD_SHOW_FIELD
}
SHOWSEATUSERCMD.is_extendable = false
SHOWSEATUSERCMD.extensions = {}
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.name = "cmd"
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.full_name = ".Cmd.SetNormalSkillOptionUserCmd.cmd"
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.number = 1
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.index = 0
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.label = 1
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.has_default_value = true
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.default_value = 9
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.type = 14
SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD.cpp_type = 8
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.name = "param"
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.full_name = ".Cmd.SetNormalSkillOptionUserCmd.param"
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.number = 2
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.index = 1
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.label = 1
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.has_default_value = true
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.default_value = 103
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.type = 14
SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD.cpp_type = 8
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.name = "flag"
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.full_name = ".Cmd.SetNormalSkillOptionUserCmd.flag"
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.number = 3
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.index = 2
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.label = 1
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.has_default_value = false
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.default_value = 0
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.type = 13
SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD.cpp_type = 3
SETNORMALSKILLOPTIONUSERCMD.name = "SetNormalSkillOptionUserCmd"
SETNORMALSKILLOPTIONUSERCMD.full_name = ".Cmd.SetNormalSkillOptionUserCmd"
SETNORMALSKILLOPTIONUSERCMD.nested_types = {}
SETNORMALSKILLOPTIONUSERCMD.enum_types = {}
SETNORMALSKILLOPTIONUSERCMD.fields = {
  SETNORMALSKILLOPTIONUSERCMD_CMD_FIELD,
  SETNORMALSKILLOPTIONUSERCMD_PARAM_FIELD,
  SETNORMALSKILLOPTIONUSERCMD_FLAG_FIELD
}
SETNORMALSKILLOPTIONUSERCMD.is_extendable = false
SETNORMALSKILLOPTIONUSERCMD.extensions = {}
NEWSETOPTIONUSERCMD_CMD_FIELD.name = "cmd"
NEWSETOPTIONUSERCMD_CMD_FIELD.full_name = ".Cmd.NewSetOptionUserCmd.cmd"
NEWSETOPTIONUSERCMD_CMD_FIELD.number = 1
NEWSETOPTIONUSERCMD_CMD_FIELD.index = 0
NEWSETOPTIONUSERCMD_CMD_FIELD.label = 1
NEWSETOPTIONUSERCMD_CMD_FIELD.has_default_value = true
NEWSETOPTIONUSERCMD_CMD_FIELD.default_value = 9
NEWSETOPTIONUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWSETOPTIONUSERCMD_CMD_FIELD.type = 14
NEWSETOPTIONUSERCMD_CMD_FIELD.cpp_type = 8
NEWSETOPTIONUSERCMD_PARAM_FIELD.name = "param"
NEWSETOPTIONUSERCMD_PARAM_FIELD.full_name = ".Cmd.NewSetOptionUserCmd.param"
NEWSETOPTIONUSERCMD_PARAM_FIELD.number = 2
NEWSETOPTIONUSERCMD_PARAM_FIELD.index = 1
NEWSETOPTIONUSERCMD_PARAM_FIELD.label = 1
NEWSETOPTIONUSERCMD_PARAM_FIELD.has_default_value = true
NEWSETOPTIONUSERCMD_PARAM_FIELD.default_value = 106
NEWSETOPTIONUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
NEWSETOPTIONUSERCMD_PARAM_FIELD.type = 14
NEWSETOPTIONUSERCMD_PARAM_FIELD.cpp_type = 8
NEWSETOPTIONUSERCMD_TYPE_FIELD.name = "type"
NEWSETOPTIONUSERCMD_TYPE_FIELD.full_name = ".Cmd.NewSetOptionUserCmd.type"
NEWSETOPTIONUSERCMD_TYPE_FIELD.number = 3
NEWSETOPTIONUSERCMD_TYPE_FIELD.index = 2
NEWSETOPTIONUSERCMD_TYPE_FIELD.label = 1
NEWSETOPTIONUSERCMD_TYPE_FIELD.has_default_value = false
NEWSETOPTIONUSERCMD_TYPE_FIELD.default_value = nil
NEWSETOPTIONUSERCMD_TYPE_FIELD.enum_type = EOPTIONTYPE
NEWSETOPTIONUSERCMD_TYPE_FIELD.type = 14
NEWSETOPTIONUSERCMD_TYPE_FIELD.cpp_type = 8
NEWSETOPTIONUSERCMD_FLAG_FIELD.name = "flag"
NEWSETOPTIONUSERCMD_FLAG_FIELD.full_name = ".Cmd.NewSetOptionUserCmd.flag"
NEWSETOPTIONUSERCMD_FLAG_FIELD.number = 4
NEWSETOPTIONUSERCMD_FLAG_FIELD.index = 3
NEWSETOPTIONUSERCMD_FLAG_FIELD.label = 1
NEWSETOPTIONUSERCMD_FLAG_FIELD.has_default_value = false
NEWSETOPTIONUSERCMD_FLAG_FIELD.default_value = 0
NEWSETOPTIONUSERCMD_FLAG_FIELD.type = 13
NEWSETOPTIONUSERCMD_FLAG_FIELD.cpp_type = 3
NEWSETOPTIONUSERCMD.name = "NewSetOptionUserCmd"
NEWSETOPTIONUSERCMD.full_name = ".Cmd.NewSetOptionUserCmd"
NEWSETOPTIONUSERCMD.nested_types = {}
NEWSETOPTIONUSERCMD.enum_types = {}
NEWSETOPTIONUSERCMD.fields = {
  NEWSETOPTIONUSERCMD_CMD_FIELD,
  NEWSETOPTIONUSERCMD_PARAM_FIELD,
  NEWSETOPTIONUSERCMD_TYPE_FIELD,
  NEWSETOPTIONUSERCMD_FLAG_FIELD
}
NEWSETOPTIONUSERCMD.is_extendable = false
NEWSETOPTIONUSERCMD.extensions = {}
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.name = "cmd"
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.full_name = ".Cmd.UnsolvedSceneryNtfUserCmd.cmd"
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.number = 1
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.index = 0
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.label = 1
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.has_default_value = true
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.default_value = 9
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.type = 14
UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD.cpp_type = 8
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.name = "param"
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.full_name = ".Cmd.UnsolvedSceneryNtfUserCmd.param"
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.number = 2
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.index = 1
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.label = 1
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.has_default_value = true
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.default_value = 104
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.type = 14
UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD.cpp_type = 8
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.name = "ids"
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.full_name = ".Cmd.UnsolvedSceneryNtfUserCmd.ids"
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.number = 3
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.index = 2
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.label = 3
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.has_default_value = false
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.default_value = {}
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.type = 13
UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD.cpp_type = 3
UNSOLVEDSCENERYNTFUSERCMD.name = "UnsolvedSceneryNtfUserCmd"
UNSOLVEDSCENERYNTFUSERCMD.full_name = ".Cmd.UnsolvedSceneryNtfUserCmd"
UNSOLVEDSCENERYNTFUSERCMD.nested_types = {}
UNSOLVEDSCENERYNTFUSERCMD.enum_types = {}
UNSOLVEDSCENERYNTFUSERCMD.fields = {
  UNSOLVEDSCENERYNTFUSERCMD_CMD_FIELD,
  UNSOLVEDSCENERYNTFUSERCMD_PARAM_FIELD,
  UNSOLVEDSCENERYNTFUSERCMD_IDS_FIELD
}
UNSOLVEDSCENERYNTFUSERCMD.is_extendable = false
UNSOLVEDSCENERYNTFUSERCMD.extensions = {}
VISIBLENPC_NPCID_FIELD.name = "npcid"
VISIBLENPC_NPCID_FIELD.full_name = ".Cmd.VisibleNpc.npcid"
VISIBLENPC_NPCID_FIELD.number = 1
VISIBLENPC_NPCID_FIELD.index = 0
VISIBLENPC_NPCID_FIELD.label = 1
VISIBLENPC_NPCID_FIELD.has_default_value = true
VISIBLENPC_NPCID_FIELD.default_value = 0
VISIBLENPC_NPCID_FIELD.type = 13
VISIBLENPC_NPCID_FIELD.cpp_type = 3
VISIBLENPC_POS_FIELD.name = "pos"
VISIBLENPC_POS_FIELD.full_name = ".Cmd.VisibleNpc.pos"
VISIBLENPC_POS_FIELD.number = 2
VISIBLENPC_POS_FIELD.index = 1
VISIBLENPC_POS_FIELD.label = 1
VISIBLENPC_POS_FIELD.has_default_value = false
VISIBLENPC_POS_FIELD.default_value = nil
VISIBLENPC_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
VISIBLENPC_POS_FIELD.type = 11
VISIBLENPC_POS_FIELD.cpp_type = 10
VISIBLENPC_UNIQUEID_FIELD.name = "uniqueid"
VISIBLENPC_UNIQUEID_FIELD.full_name = ".Cmd.VisibleNpc.uniqueid"
VISIBLENPC_UNIQUEID_FIELD.number = 3
VISIBLENPC_UNIQUEID_FIELD.index = 2
VISIBLENPC_UNIQUEID_FIELD.label = 1
VISIBLENPC_UNIQUEID_FIELD.has_default_value = true
VISIBLENPC_UNIQUEID_FIELD.default_value = 0
VISIBLENPC_UNIQUEID_FIELD.type = 4
VISIBLENPC_UNIQUEID_FIELD.cpp_type = 4
VISIBLENPC.name = "VisibleNpc"
VISIBLENPC.full_name = ".Cmd.VisibleNpc"
VISIBLENPC.nested_types = {}
VISIBLENPC.enum_types = {}
VISIBLENPC.fields = {
  VISIBLENPC_NPCID_FIELD,
  VISIBLENPC_POS_FIELD,
  VISIBLENPC_UNIQUEID_FIELD
}
VISIBLENPC.is_extendable = false
VISIBLENPC.extensions = {}
NTFVISIBLENPCUSERCMD_CMD_FIELD.name = "cmd"
NTFVISIBLENPCUSERCMD_CMD_FIELD.full_name = ".Cmd.NtfVisibleNpcUserCmd.cmd"
NTFVISIBLENPCUSERCMD_CMD_FIELD.number = 1
NTFVISIBLENPCUSERCMD_CMD_FIELD.index = 0
NTFVISIBLENPCUSERCMD_CMD_FIELD.label = 1
NTFVISIBLENPCUSERCMD_CMD_FIELD.has_default_value = true
NTFVISIBLENPCUSERCMD_CMD_FIELD.default_value = 9
NTFVISIBLENPCUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NTFVISIBLENPCUSERCMD_CMD_FIELD.type = 14
NTFVISIBLENPCUSERCMD_CMD_FIELD.cpp_type = 8
NTFVISIBLENPCUSERCMD_PARAM_FIELD.name = "param"
NTFVISIBLENPCUSERCMD_PARAM_FIELD.full_name = ".Cmd.NtfVisibleNpcUserCmd.param"
NTFVISIBLENPCUSERCMD_PARAM_FIELD.number = 2
NTFVISIBLENPCUSERCMD_PARAM_FIELD.index = 1
NTFVISIBLENPCUSERCMD_PARAM_FIELD.label = 1
NTFVISIBLENPCUSERCMD_PARAM_FIELD.has_default_value = true
NTFVISIBLENPCUSERCMD_PARAM_FIELD.default_value = 105
NTFVISIBLENPCUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
NTFVISIBLENPCUSERCMD_PARAM_FIELD.type = 14
NTFVISIBLENPCUSERCMD_PARAM_FIELD.cpp_type = 8
NTFVISIBLENPCUSERCMD_NPCS_FIELD.name = "npcs"
NTFVISIBLENPCUSERCMD_NPCS_FIELD.full_name = ".Cmd.NtfVisibleNpcUserCmd.npcs"
NTFVISIBLENPCUSERCMD_NPCS_FIELD.number = 3
NTFVISIBLENPCUSERCMD_NPCS_FIELD.index = 2
NTFVISIBLENPCUSERCMD_NPCS_FIELD.label = 3
NTFVISIBLENPCUSERCMD_NPCS_FIELD.has_default_value = false
NTFVISIBLENPCUSERCMD_NPCS_FIELD.default_value = {}
NTFVISIBLENPCUSERCMD_NPCS_FIELD.message_type = VISIBLENPC
NTFVISIBLENPCUSERCMD_NPCS_FIELD.type = 11
NTFVISIBLENPCUSERCMD_NPCS_FIELD.cpp_type = 10
NTFVISIBLENPCUSERCMD_TYPE_FIELD.name = "type"
NTFVISIBLENPCUSERCMD_TYPE_FIELD.full_name = ".Cmd.NtfVisibleNpcUserCmd.type"
NTFVISIBLENPCUSERCMD_TYPE_FIELD.number = 4
NTFVISIBLENPCUSERCMD_TYPE_FIELD.index = 3
NTFVISIBLENPCUSERCMD_TYPE_FIELD.label = 1
NTFVISIBLENPCUSERCMD_TYPE_FIELD.has_default_value = true
NTFVISIBLENPCUSERCMD_TYPE_FIELD.default_value = 0
NTFVISIBLENPCUSERCMD_TYPE_FIELD.type = 13
NTFVISIBLENPCUSERCMD_TYPE_FIELD.cpp_type = 3
NTFVISIBLENPCUSERCMD.name = "NtfVisibleNpcUserCmd"
NTFVISIBLENPCUSERCMD.full_name = ".Cmd.NtfVisibleNpcUserCmd"
NTFVISIBLENPCUSERCMD.nested_types = {}
NTFVISIBLENPCUSERCMD.enum_types = {}
NTFVISIBLENPCUSERCMD.fields = {
  NTFVISIBLENPCUSERCMD_CMD_FIELD,
  NTFVISIBLENPCUSERCMD_PARAM_FIELD,
  NTFVISIBLENPCUSERCMD_NPCS_FIELD,
  NTFVISIBLENPCUSERCMD_TYPE_FIELD
}
NTFVISIBLENPCUSERCMD.is_extendable = false
NTFVISIBLENPCUSERCMD.extensions = {}
UPYUNAUTHORIZATIONCMD_CMD_FIELD.name = "cmd"
UPYUNAUTHORIZATIONCMD_CMD_FIELD.full_name = ".Cmd.UpyunAuthorizationCmd.cmd"
UPYUNAUTHORIZATIONCMD_CMD_FIELD.number = 1
UPYUNAUTHORIZATIONCMD_CMD_FIELD.index = 0
UPYUNAUTHORIZATIONCMD_CMD_FIELD.label = 1
UPYUNAUTHORIZATIONCMD_CMD_FIELD.has_default_value = true
UPYUNAUTHORIZATIONCMD_CMD_FIELD.default_value = 9
UPYUNAUTHORIZATIONCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPYUNAUTHORIZATIONCMD_CMD_FIELD.type = 14
UPYUNAUTHORIZATIONCMD_CMD_FIELD.cpp_type = 8
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.name = "param"
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.full_name = ".Cmd.UpyunAuthorizationCmd.param"
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.number = 2
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.index = 1
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.label = 1
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.has_default_value = true
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.default_value = 107
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.enum_type = USER2PARAM
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.type = 14
UPYUNAUTHORIZATIONCMD_PARAM_FIELD.cpp_type = 8
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.name = "authvalue"
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.full_name = ".Cmd.UpyunAuthorizationCmd.authvalue"
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.number = 3
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.index = 2
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.label = 1
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.has_default_value = false
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.default_value = ""
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.type = 9
UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD.cpp_type = 9
UPYUNAUTHORIZATIONCMD.name = "UpyunAuthorizationCmd"
UPYUNAUTHORIZATIONCMD.full_name = ".Cmd.UpyunAuthorizationCmd"
UPYUNAUTHORIZATIONCMD.nested_types = {}
UPYUNAUTHORIZATIONCMD.enum_types = {}
UPYUNAUTHORIZATIONCMD.fields = {
  UPYUNAUTHORIZATIONCMD_CMD_FIELD,
  UPYUNAUTHORIZATIONCMD_PARAM_FIELD,
  UPYUNAUTHORIZATIONCMD_AUTHVALUE_FIELD
}
UPYUNAUTHORIZATIONCMD.is_extendable = false
UPYUNAUTHORIZATIONCMD.extensions = {}
TRANSFORMPREDATACMD_CMD_FIELD.name = "cmd"
TRANSFORMPREDATACMD_CMD_FIELD.full_name = ".Cmd.TransformPreDataCmd.cmd"
TRANSFORMPREDATACMD_CMD_FIELD.number = 1
TRANSFORMPREDATACMD_CMD_FIELD.index = 0
TRANSFORMPREDATACMD_CMD_FIELD.label = 1
TRANSFORMPREDATACMD_CMD_FIELD.has_default_value = true
TRANSFORMPREDATACMD_CMD_FIELD.default_value = 9
TRANSFORMPREDATACMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TRANSFORMPREDATACMD_CMD_FIELD.type = 14
TRANSFORMPREDATACMD_CMD_FIELD.cpp_type = 8
TRANSFORMPREDATACMD_PARAM_FIELD.name = "param"
TRANSFORMPREDATACMD_PARAM_FIELD.full_name = ".Cmd.TransformPreDataCmd.param"
TRANSFORMPREDATACMD_PARAM_FIELD.number = 2
TRANSFORMPREDATACMD_PARAM_FIELD.index = 1
TRANSFORMPREDATACMD_PARAM_FIELD.label = 1
TRANSFORMPREDATACMD_PARAM_FIELD.has_default_value = true
TRANSFORMPREDATACMD_PARAM_FIELD.default_value = 108
TRANSFORMPREDATACMD_PARAM_FIELD.enum_type = USER2PARAM
TRANSFORMPREDATACMD_PARAM_FIELD.type = 14
TRANSFORMPREDATACMD_PARAM_FIELD.cpp_type = 8
TRANSFORMPREDATACMD_DATAS_FIELD.name = "datas"
TRANSFORMPREDATACMD_DATAS_FIELD.full_name = ".Cmd.TransformPreDataCmd.datas"
TRANSFORMPREDATACMD_DATAS_FIELD.number = 3
TRANSFORMPREDATACMD_DATAS_FIELD.index = 2
TRANSFORMPREDATACMD_DATAS_FIELD.label = 3
TRANSFORMPREDATACMD_DATAS_FIELD.has_default_value = false
TRANSFORMPREDATACMD_DATAS_FIELD.default_value = {}
TRANSFORMPREDATACMD_DATAS_FIELD.message_type = SceneUser_pb.USERDATA
TRANSFORMPREDATACMD_DATAS_FIELD.type = 11
TRANSFORMPREDATACMD_DATAS_FIELD.cpp_type = 10
TRANSFORMPREDATACMD.name = "TransformPreDataCmd"
TRANSFORMPREDATACMD.full_name = ".Cmd.TransformPreDataCmd"
TRANSFORMPREDATACMD.nested_types = {}
TRANSFORMPREDATACMD.enum_types = {}
TRANSFORMPREDATACMD.fields = {
  TRANSFORMPREDATACMD_CMD_FIELD,
  TRANSFORMPREDATACMD_PARAM_FIELD,
  TRANSFORMPREDATACMD_DATAS_FIELD
}
TRANSFORMPREDATACMD.is_extendable = false
TRANSFORMPREDATACMD.extensions = {}
USERRENAMECMD_CMD_FIELD.name = "cmd"
USERRENAMECMD_CMD_FIELD.full_name = ".Cmd.UserRenameCmd.cmd"
USERRENAMECMD_CMD_FIELD.number = 1
USERRENAMECMD_CMD_FIELD.index = 0
USERRENAMECMD_CMD_FIELD.label = 1
USERRENAMECMD_CMD_FIELD.has_default_value = true
USERRENAMECMD_CMD_FIELD.default_value = 9
USERRENAMECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USERRENAMECMD_CMD_FIELD.type = 14
USERRENAMECMD_CMD_FIELD.cpp_type = 8
USERRENAMECMD_PARAM_FIELD.name = "param"
USERRENAMECMD_PARAM_FIELD.full_name = ".Cmd.UserRenameCmd.param"
USERRENAMECMD_PARAM_FIELD.number = 2
USERRENAMECMD_PARAM_FIELD.index = 1
USERRENAMECMD_PARAM_FIELD.label = 1
USERRENAMECMD_PARAM_FIELD.has_default_value = true
USERRENAMECMD_PARAM_FIELD.default_value = 109
USERRENAMECMD_PARAM_FIELD.enum_type = USER2PARAM
USERRENAMECMD_PARAM_FIELD.type = 14
USERRENAMECMD_PARAM_FIELD.cpp_type = 8
USERRENAMECMD_NAME_FIELD.name = "name"
USERRENAMECMD_NAME_FIELD.full_name = ".Cmd.UserRenameCmd.name"
USERRENAMECMD_NAME_FIELD.number = 3
USERRENAMECMD_NAME_FIELD.index = 2
USERRENAMECMD_NAME_FIELD.label = 1
USERRENAMECMD_NAME_FIELD.has_default_value = false
USERRENAMECMD_NAME_FIELD.default_value = ""
USERRENAMECMD_NAME_FIELD.type = 9
USERRENAMECMD_NAME_FIELD.cpp_type = 9
USERRENAMECMD_CODE_FIELD.name = "code"
USERRENAMECMD_CODE_FIELD.full_name = ".Cmd.UserRenameCmd.code"
USERRENAMECMD_CODE_FIELD.number = 4
USERRENAMECMD_CODE_FIELD.index = 3
USERRENAMECMD_CODE_FIELD.label = 1
USERRENAMECMD_CODE_FIELD.has_default_value = true
USERRENAMECMD_CODE_FIELD.default_value = 0
USERRENAMECMD_CODE_FIELD.enum_type = ERENAMEERRCODE
USERRENAMECMD_CODE_FIELD.type = 14
USERRENAMECMD_CODE_FIELD.cpp_type = 8
USERRENAMECMD.name = "UserRenameCmd"
USERRENAMECMD.full_name = ".Cmd.UserRenameCmd"
USERRENAMECMD.nested_types = {}
USERRENAMECMD.enum_types = {}
USERRENAMECMD.fields = {
  USERRENAMECMD_CMD_FIELD,
  USERRENAMECMD_PARAM_FIELD,
  USERRENAMECMD_NAME_FIELD,
  USERRENAMECMD_CODE_FIELD
}
USERRENAMECMD.is_extendable = false
USERRENAMECMD.extensions = {}
BUYZENYCMD_CMD_FIELD.name = "cmd"
BUYZENYCMD_CMD_FIELD.full_name = ".Cmd.BuyZenyCmd.cmd"
BUYZENYCMD_CMD_FIELD.number = 1
BUYZENYCMD_CMD_FIELD.index = 0
BUYZENYCMD_CMD_FIELD.label = 1
BUYZENYCMD_CMD_FIELD.has_default_value = true
BUYZENYCMD_CMD_FIELD.default_value = 9
BUYZENYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BUYZENYCMD_CMD_FIELD.type = 14
BUYZENYCMD_CMD_FIELD.cpp_type = 8
BUYZENYCMD_PARAM_FIELD.name = "param"
BUYZENYCMD_PARAM_FIELD.full_name = ".Cmd.BuyZenyCmd.param"
BUYZENYCMD_PARAM_FIELD.number = 2
BUYZENYCMD_PARAM_FIELD.index = 1
BUYZENYCMD_PARAM_FIELD.label = 1
BUYZENYCMD_PARAM_FIELD.has_default_value = true
BUYZENYCMD_PARAM_FIELD.default_value = 111
BUYZENYCMD_PARAM_FIELD.enum_type = USER2PARAM
BUYZENYCMD_PARAM_FIELD.type = 14
BUYZENYCMD_PARAM_FIELD.cpp_type = 8
BUYZENYCMD_BCOIN_FIELD.name = "bcoin"
BUYZENYCMD_BCOIN_FIELD.full_name = ".Cmd.BuyZenyCmd.bcoin"
BUYZENYCMD_BCOIN_FIELD.number = 3
BUYZENYCMD_BCOIN_FIELD.index = 2
BUYZENYCMD_BCOIN_FIELD.label = 1
BUYZENYCMD_BCOIN_FIELD.has_default_value = false
BUYZENYCMD_BCOIN_FIELD.default_value = 0
BUYZENYCMD_BCOIN_FIELD.type = 13
BUYZENYCMD_BCOIN_FIELD.cpp_type = 3
BUYZENYCMD_ZENY_FIELD.name = "zeny"
BUYZENYCMD_ZENY_FIELD.full_name = ".Cmd.BuyZenyCmd.zeny"
BUYZENYCMD_ZENY_FIELD.number = 4
BUYZENYCMD_ZENY_FIELD.index = 3
BUYZENYCMD_ZENY_FIELD.label = 1
BUYZENYCMD_ZENY_FIELD.has_default_value = false
BUYZENYCMD_ZENY_FIELD.default_value = 0
BUYZENYCMD_ZENY_FIELD.type = 4
BUYZENYCMD_ZENY_FIELD.cpp_type = 4
BUYZENYCMD_RET_FIELD.name = "ret"
BUYZENYCMD_RET_FIELD.full_name = ".Cmd.BuyZenyCmd.ret"
BUYZENYCMD_RET_FIELD.number = 5
BUYZENYCMD_RET_FIELD.index = 4
BUYZENYCMD_RET_FIELD.label = 1
BUYZENYCMD_RET_FIELD.has_default_value = false
BUYZENYCMD_RET_FIELD.default_value = false
BUYZENYCMD_RET_FIELD.type = 8
BUYZENYCMD_RET_FIELD.cpp_type = 7
BUYZENYCMD.name = "BuyZenyCmd"
BUYZENYCMD.full_name = ".Cmd.BuyZenyCmd"
BUYZENYCMD.nested_types = {}
BUYZENYCMD.enum_types = {}
BUYZENYCMD.fields = {
  BUYZENYCMD_CMD_FIELD,
  BUYZENYCMD_PARAM_FIELD,
  BUYZENYCMD_BCOIN_FIELD,
  BUYZENYCMD_ZENY_FIELD,
  BUYZENYCMD_RET_FIELD
}
BUYZENYCMD.is_extendable = false
BUYZENYCMD.extensions = {}
CALLTEAMERUSERCMD_CMD_FIELD.name = "cmd"
CALLTEAMERUSERCMD_CMD_FIELD.full_name = ".Cmd.CallTeamerUserCmd.cmd"
CALLTEAMERUSERCMD_CMD_FIELD.number = 1
CALLTEAMERUSERCMD_CMD_FIELD.index = 0
CALLTEAMERUSERCMD_CMD_FIELD.label = 1
CALLTEAMERUSERCMD_CMD_FIELD.has_default_value = true
CALLTEAMERUSERCMD_CMD_FIELD.default_value = 9
CALLTEAMERUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CALLTEAMERUSERCMD_CMD_FIELD.type = 14
CALLTEAMERUSERCMD_CMD_FIELD.cpp_type = 8
CALLTEAMERUSERCMD_PARAM_FIELD.name = "param"
CALLTEAMERUSERCMD_PARAM_FIELD.full_name = ".Cmd.CallTeamerUserCmd.param"
CALLTEAMERUSERCMD_PARAM_FIELD.number = 2
CALLTEAMERUSERCMD_PARAM_FIELD.index = 1
CALLTEAMERUSERCMD_PARAM_FIELD.label = 1
CALLTEAMERUSERCMD_PARAM_FIELD.has_default_value = true
CALLTEAMERUSERCMD_PARAM_FIELD.default_value = 112
CALLTEAMERUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CALLTEAMERUSERCMD_PARAM_FIELD.type = 14
CALLTEAMERUSERCMD_PARAM_FIELD.cpp_type = 8
CALLTEAMERUSERCMD_MASTERID_FIELD.name = "masterid"
CALLTEAMERUSERCMD_MASTERID_FIELD.full_name = ".Cmd.CallTeamerUserCmd.masterid"
CALLTEAMERUSERCMD_MASTERID_FIELD.number = 3
CALLTEAMERUSERCMD_MASTERID_FIELD.index = 2
CALLTEAMERUSERCMD_MASTERID_FIELD.label = 1
CALLTEAMERUSERCMD_MASTERID_FIELD.has_default_value = true
CALLTEAMERUSERCMD_MASTERID_FIELD.default_value = 0
CALLTEAMERUSERCMD_MASTERID_FIELD.type = 4
CALLTEAMERUSERCMD_MASTERID_FIELD.cpp_type = 4
CALLTEAMERUSERCMD_SIGN_FIELD.name = "sign"
CALLTEAMERUSERCMD_SIGN_FIELD.full_name = ".Cmd.CallTeamerUserCmd.sign"
CALLTEAMERUSERCMD_SIGN_FIELD.number = 4
CALLTEAMERUSERCMD_SIGN_FIELD.index = 3
CALLTEAMERUSERCMD_SIGN_FIELD.label = 1
CALLTEAMERUSERCMD_SIGN_FIELD.has_default_value = false
CALLTEAMERUSERCMD_SIGN_FIELD.default_value = ""
CALLTEAMERUSERCMD_SIGN_FIELD.type = 9
CALLTEAMERUSERCMD_SIGN_FIELD.cpp_type = 9
CALLTEAMERUSERCMD_TIME_FIELD.name = "time"
CALLTEAMERUSERCMD_TIME_FIELD.full_name = ".Cmd.CallTeamerUserCmd.time"
CALLTEAMERUSERCMD_TIME_FIELD.number = 5
CALLTEAMERUSERCMD_TIME_FIELD.index = 4
CALLTEAMERUSERCMD_TIME_FIELD.label = 1
CALLTEAMERUSERCMD_TIME_FIELD.has_default_value = true
CALLTEAMERUSERCMD_TIME_FIELD.default_value = 0
CALLTEAMERUSERCMD_TIME_FIELD.type = 13
CALLTEAMERUSERCMD_TIME_FIELD.cpp_type = 3
CALLTEAMERUSERCMD_USERNAME_FIELD.name = "username"
CALLTEAMERUSERCMD_USERNAME_FIELD.full_name = ".Cmd.CallTeamerUserCmd.username"
CALLTEAMERUSERCMD_USERNAME_FIELD.number = 6
CALLTEAMERUSERCMD_USERNAME_FIELD.index = 5
CALLTEAMERUSERCMD_USERNAME_FIELD.label = 1
CALLTEAMERUSERCMD_USERNAME_FIELD.has_default_value = false
CALLTEAMERUSERCMD_USERNAME_FIELD.default_value = ""
CALLTEAMERUSERCMD_USERNAME_FIELD.type = 9
CALLTEAMERUSERCMD_USERNAME_FIELD.cpp_type = 9
CALLTEAMERUSERCMD_MAPID_FIELD.name = "mapid"
CALLTEAMERUSERCMD_MAPID_FIELD.full_name = ".Cmd.CallTeamerUserCmd.mapid"
CALLTEAMERUSERCMD_MAPID_FIELD.number = 7
CALLTEAMERUSERCMD_MAPID_FIELD.index = 6
CALLTEAMERUSERCMD_MAPID_FIELD.label = 1
CALLTEAMERUSERCMD_MAPID_FIELD.has_default_value = true
CALLTEAMERUSERCMD_MAPID_FIELD.default_value = 0
CALLTEAMERUSERCMD_MAPID_FIELD.type = 13
CALLTEAMERUSERCMD_MAPID_FIELD.cpp_type = 3
CALLTEAMERUSERCMD_POS_FIELD.name = "pos"
CALLTEAMERUSERCMD_POS_FIELD.full_name = ".Cmd.CallTeamerUserCmd.pos"
CALLTEAMERUSERCMD_POS_FIELD.number = 8
CALLTEAMERUSERCMD_POS_FIELD.index = 7
CALLTEAMERUSERCMD_POS_FIELD.label = 1
CALLTEAMERUSERCMD_POS_FIELD.has_default_value = false
CALLTEAMERUSERCMD_POS_FIELD.default_value = nil
CALLTEAMERUSERCMD_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
CALLTEAMERUSERCMD_POS_FIELD.type = 11
CALLTEAMERUSERCMD_POS_FIELD.cpp_type = 10
CALLTEAMERUSERCMD.name = "CallTeamerUserCmd"
CALLTEAMERUSERCMD.full_name = ".Cmd.CallTeamerUserCmd"
CALLTEAMERUSERCMD.nested_types = {}
CALLTEAMERUSERCMD.enum_types = {}
CALLTEAMERUSERCMD.fields = {
  CALLTEAMERUSERCMD_CMD_FIELD,
  CALLTEAMERUSERCMD_PARAM_FIELD,
  CALLTEAMERUSERCMD_MASTERID_FIELD,
  CALLTEAMERUSERCMD_SIGN_FIELD,
  CALLTEAMERUSERCMD_TIME_FIELD,
  CALLTEAMERUSERCMD_USERNAME_FIELD,
  CALLTEAMERUSERCMD_MAPID_FIELD,
  CALLTEAMERUSERCMD_POS_FIELD
}
CALLTEAMERUSERCMD.is_extendable = false
CALLTEAMERUSERCMD.extensions = {}
CALLTEAMERREPLYUSERCMD_CMD_FIELD.name = "cmd"
CALLTEAMERREPLYUSERCMD_CMD_FIELD.full_name = ".Cmd.CallTeamerReplyUserCmd.cmd"
CALLTEAMERREPLYUSERCMD_CMD_FIELD.number = 1
CALLTEAMERREPLYUSERCMD_CMD_FIELD.index = 0
CALLTEAMERREPLYUSERCMD_CMD_FIELD.label = 1
CALLTEAMERREPLYUSERCMD_CMD_FIELD.has_default_value = true
CALLTEAMERREPLYUSERCMD_CMD_FIELD.default_value = 9
CALLTEAMERREPLYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CALLTEAMERREPLYUSERCMD_CMD_FIELD.type = 14
CALLTEAMERREPLYUSERCMD_CMD_FIELD.cpp_type = 8
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.name = "param"
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.full_name = ".Cmd.CallTeamerReplyUserCmd.param"
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.number = 2
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.index = 1
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.label = 1
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.has_default_value = true
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.default_value = 113
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.type = 14
CALLTEAMERREPLYUSERCMD_PARAM_FIELD.cpp_type = 8
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.name = "masterid"
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.full_name = ".Cmd.CallTeamerReplyUserCmd.masterid"
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.number = 3
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.index = 2
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.label = 1
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.has_default_value = true
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.default_value = 0
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.type = 4
CALLTEAMERREPLYUSERCMD_MASTERID_FIELD.cpp_type = 4
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.name = "sign"
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.full_name = ".Cmd.CallTeamerReplyUserCmd.sign"
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.number = 4
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.index = 3
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.label = 1
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.has_default_value = false
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.default_value = ""
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.type = 9
CALLTEAMERREPLYUSERCMD_SIGN_FIELD.cpp_type = 9
CALLTEAMERREPLYUSERCMD_TIME_FIELD.name = "time"
CALLTEAMERREPLYUSERCMD_TIME_FIELD.full_name = ".Cmd.CallTeamerReplyUserCmd.time"
CALLTEAMERREPLYUSERCMD_TIME_FIELD.number = 5
CALLTEAMERREPLYUSERCMD_TIME_FIELD.index = 4
CALLTEAMERREPLYUSERCMD_TIME_FIELD.label = 1
CALLTEAMERREPLYUSERCMD_TIME_FIELD.has_default_value = true
CALLTEAMERREPLYUSERCMD_TIME_FIELD.default_value = 0
CALLTEAMERREPLYUSERCMD_TIME_FIELD.type = 13
CALLTEAMERREPLYUSERCMD_TIME_FIELD.cpp_type = 3
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.name = "mapid"
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.full_name = ".Cmd.CallTeamerReplyUserCmd.mapid"
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.number = 6
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.index = 5
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.label = 1
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.has_default_value = true
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.default_value = 0
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.type = 13
CALLTEAMERREPLYUSERCMD_MAPID_FIELD.cpp_type = 3
CALLTEAMERREPLYUSERCMD_POS_FIELD.name = "pos"
CALLTEAMERREPLYUSERCMD_POS_FIELD.full_name = ".Cmd.CallTeamerReplyUserCmd.pos"
CALLTEAMERREPLYUSERCMD_POS_FIELD.number = 7
CALLTEAMERREPLYUSERCMD_POS_FIELD.index = 6
CALLTEAMERREPLYUSERCMD_POS_FIELD.label = 1
CALLTEAMERREPLYUSERCMD_POS_FIELD.has_default_value = false
CALLTEAMERREPLYUSERCMD_POS_FIELD.default_value = nil
CALLTEAMERREPLYUSERCMD_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
CALLTEAMERREPLYUSERCMD_POS_FIELD.type = 11
CALLTEAMERREPLYUSERCMD_POS_FIELD.cpp_type = 10
CALLTEAMERREPLYUSERCMD.name = "CallTeamerReplyUserCmd"
CALLTEAMERREPLYUSERCMD.full_name = ".Cmd.CallTeamerReplyUserCmd"
CALLTEAMERREPLYUSERCMD.nested_types = {}
CALLTEAMERREPLYUSERCMD.enum_types = {}
CALLTEAMERREPLYUSERCMD.fields = {
  CALLTEAMERREPLYUSERCMD_CMD_FIELD,
  CALLTEAMERREPLYUSERCMD_PARAM_FIELD,
  CALLTEAMERREPLYUSERCMD_MASTERID_FIELD,
  CALLTEAMERREPLYUSERCMD_SIGN_FIELD,
  CALLTEAMERREPLYUSERCMD_TIME_FIELD,
  CALLTEAMERREPLYUSERCMD_MAPID_FIELD,
  CALLTEAMERREPLYUSERCMD_POS_FIELD
}
CALLTEAMERREPLYUSERCMD.is_extendable = false
CALLTEAMERREPLYUSERCMD.extensions = {}
SPECIALEFFECTCMD_CMD_FIELD.name = "cmd"
SPECIALEFFECTCMD_CMD_FIELD.full_name = ".Cmd.SpecialEffectCmd.cmd"
SPECIALEFFECTCMD_CMD_FIELD.number = 1
SPECIALEFFECTCMD_CMD_FIELD.index = 0
SPECIALEFFECTCMD_CMD_FIELD.label = 1
SPECIALEFFECTCMD_CMD_FIELD.has_default_value = true
SPECIALEFFECTCMD_CMD_FIELD.default_value = 9
SPECIALEFFECTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SPECIALEFFECTCMD_CMD_FIELD.type = 14
SPECIALEFFECTCMD_CMD_FIELD.cpp_type = 8
SPECIALEFFECTCMD_PARAM_FIELD.name = "param"
SPECIALEFFECTCMD_PARAM_FIELD.full_name = ".Cmd.SpecialEffectCmd.param"
SPECIALEFFECTCMD_PARAM_FIELD.number = 2
SPECIALEFFECTCMD_PARAM_FIELD.index = 1
SPECIALEFFECTCMD_PARAM_FIELD.label = 1
SPECIALEFFECTCMD_PARAM_FIELD.has_default_value = true
SPECIALEFFECTCMD_PARAM_FIELD.default_value = 116
SPECIALEFFECTCMD_PARAM_FIELD.enum_type = USER2PARAM
SPECIALEFFECTCMD_PARAM_FIELD.type = 14
SPECIALEFFECTCMD_PARAM_FIELD.cpp_type = 8
SPECIALEFFECTCMD_DRAMAID_FIELD.name = "dramaid"
SPECIALEFFECTCMD_DRAMAID_FIELD.full_name = ".Cmd.SpecialEffectCmd.dramaid"
SPECIALEFFECTCMD_DRAMAID_FIELD.number = 3
SPECIALEFFECTCMD_DRAMAID_FIELD.index = 2
SPECIALEFFECTCMD_DRAMAID_FIELD.label = 1
SPECIALEFFECTCMD_DRAMAID_FIELD.has_default_value = false
SPECIALEFFECTCMD_DRAMAID_FIELD.default_value = 0
SPECIALEFFECTCMD_DRAMAID_FIELD.type = 13
SPECIALEFFECTCMD_DRAMAID_FIELD.cpp_type = 3
SPECIALEFFECTCMD_STARTTIME_FIELD.name = "starttime"
SPECIALEFFECTCMD_STARTTIME_FIELD.full_name = ".Cmd.SpecialEffectCmd.starttime"
SPECIALEFFECTCMD_STARTTIME_FIELD.number = 4
SPECIALEFFECTCMD_STARTTIME_FIELD.index = 3
SPECIALEFFECTCMD_STARTTIME_FIELD.label = 1
SPECIALEFFECTCMD_STARTTIME_FIELD.has_default_value = false
SPECIALEFFECTCMD_STARTTIME_FIELD.default_value = 0
SPECIALEFFECTCMD_STARTTIME_FIELD.type = 13
SPECIALEFFECTCMD_STARTTIME_FIELD.cpp_type = 3
SPECIALEFFECTCMD_TIMES_FIELD.name = "times"
SPECIALEFFECTCMD_TIMES_FIELD.full_name = ".Cmd.SpecialEffectCmd.times"
SPECIALEFFECTCMD_TIMES_FIELD.number = 5
SPECIALEFFECTCMD_TIMES_FIELD.index = 4
SPECIALEFFECTCMD_TIMES_FIELD.label = 1
SPECIALEFFECTCMD_TIMES_FIELD.has_default_value = true
SPECIALEFFECTCMD_TIMES_FIELD.default_value = 0
SPECIALEFFECTCMD_TIMES_FIELD.type = 13
SPECIALEFFECTCMD_TIMES_FIELD.cpp_type = 3
SPECIALEFFECTCMD.name = "SpecialEffectCmd"
SPECIALEFFECTCMD.full_name = ".Cmd.SpecialEffectCmd"
SPECIALEFFECTCMD.nested_types = {}
SPECIALEFFECTCMD.enum_types = {}
SPECIALEFFECTCMD.fields = {
  SPECIALEFFECTCMD_CMD_FIELD,
  SPECIALEFFECTCMD_PARAM_FIELD,
  SPECIALEFFECTCMD_DRAMAID_FIELD,
  SPECIALEFFECTCMD_STARTTIME_FIELD,
  SPECIALEFFECTCMD_TIMES_FIELD
}
SPECIALEFFECTCMD.is_extendable = false
SPECIALEFFECTCMD.extensions = {}
MARRIAGEPROPOSALCMD_CMD_FIELD.name = "cmd"
MARRIAGEPROPOSALCMD_CMD_FIELD.full_name = ".Cmd.MarriageProposalCmd.cmd"
MARRIAGEPROPOSALCMD_CMD_FIELD.number = 1
MARRIAGEPROPOSALCMD_CMD_FIELD.index = 0
MARRIAGEPROPOSALCMD_CMD_FIELD.label = 1
MARRIAGEPROPOSALCMD_CMD_FIELD.has_default_value = true
MARRIAGEPROPOSALCMD_CMD_FIELD.default_value = 9
MARRIAGEPROPOSALCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MARRIAGEPROPOSALCMD_CMD_FIELD.type = 14
MARRIAGEPROPOSALCMD_CMD_FIELD.cpp_type = 8
MARRIAGEPROPOSALCMD_PARAM_FIELD.name = "param"
MARRIAGEPROPOSALCMD_PARAM_FIELD.full_name = ".Cmd.MarriageProposalCmd.param"
MARRIAGEPROPOSALCMD_PARAM_FIELD.number = 2
MARRIAGEPROPOSALCMD_PARAM_FIELD.index = 1
MARRIAGEPROPOSALCMD_PARAM_FIELD.label = 1
MARRIAGEPROPOSALCMD_PARAM_FIELD.has_default_value = true
MARRIAGEPROPOSALCMD_PARAM_FIELD.default_value = 117
MARRIAGEPROPOSALCMD_PARAM_FIELD.enum_type = USER2PARAM
MARRIAGEPROPOSALCMD_PARAM_FIELD.type = 14
MARRIAGEPROPOSALCMD_PARAM_FIELD.cpp_type = 8
MARRIAGEPROPOSALCMD_MASTERID_FIELD.name = "masterid"
MARRIAGEPROPOSALCMD_MASTERID_FIELD.full_name = ".Cmd.MarriageProposalCmd.masterid"
MARRIAGEPROPOSALCMD_MASTERID_FIELD.number = 3
MARRIAGEPROPOSALCMD_MASTERID_FIELD.index = 2
MARRIAGEPROPOSALCMD_MASTERID_FIELD.label = 1
MARRIAGEPROPOSALCMD_MASTERID_FIELD.has_default_value = true
MARRIAGEPROPOSALCMD_MASTERID_FIELD.default_value = 0
MARRIAGEPROPOSALCMD_MASTERID_FIELD.type = 4
MARRIAGEPROPOSALCMD_MASTERID_FIELD.cpp_type = 4
MARRIAGEPROPOSALCMD_ITEMID_FIELD.name = "itemid"
MARRIAGEPROPOSALCMD_ITEMID_FIELD.full_name = ".Cmd.MarriageProposalCmd.itemid"
MARRIAGEPROPOSALCMD_ITEMID_FIELD.number = 4
MARRIAGEPROPOSALCMD_ITEMID_FIELD.index = 3
MARRIAGEPROPOSALCMD_ITEMID_FIELD.label = 1
MARRIAGEPROPOSALCMD_ITEMID_FIELD.has_default_value = true
MARRIAGEPROPOSALCMD_ITEMID_FIELD.default_value = 0
MARRIAGEPROPOSALCMD_ITEMID_FIELD.type = 13
MARRIAGEPROPOSALCMD_ITEMID_FIELD.cpp_type = 3
MARRIAGEPROPOSALCMD_TIME_FIELD.name = "time"
MARRIAGEPROPOSALCMD_TIME_FIELD.full_name = ".Cmd.MarriageProposalCmd.time"
MARRIAGEPROPOSALCMD_TIME_FIELD.number = 5
MARRIAGEPROPOSALCMD_TIME_FIELD.index = 4
MARRIAGEPROPOSALCMD_TIME_FIELD.label = 1
MARRIAGEPROPOSALCMD_TIME_FIELD.has_default_value = true
MARRIAGEPROPOSALCMD_TIME_FIELD.default_value = 0
MARRIAGEPROPOSALCMD_TIME_FIELD.type = 13
MARRIAGEPROPOSALCMD_TIME_FIELD.cpp_type = 3
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.name = "mastername"
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.full_name = ".Cmd.MarriageProposalCmd.mastername"
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.number = 6
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.index = 5
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.label = 1
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.has_default_value = false
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.default_value = ""
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.type = 9
MARRIAGEPROPOSALCMD_MASTERNAME_FIELD.cpp_type = 9
MARRIAGEPROPOSALCMD_SIGN_FIELD.name = "sign"
MARRIAGEPROPOSALCMD_SIGN_FIELD.full_name = ".Cmd.MarriageProposalCmd.sign"
MARRIAGEPROPOSALCMD_SIGN_FIELD.number = 7
MARRIAGEPROPOSALCMD_SIGN_FIELD.index = 6
MARRIAGEPROPOSALCMD_SIGN_FIELD.label = 1
MARRIAGEPROPOSALCMD_SIGN_FIELD.has_default_value = false
MARRIAGEPROPOSALCMD_SIGN_FIELD.default_value = ""
MARRIAGEPROPOSALCMD_SIGN_FIELD.type = 12
MARRIAGEPROPOSALCMD_SIGN_FIELD.cpp_type = 9
MARRIAGEPROPOSALCMD.name = "MarriageProposalCmd"
MARRIAGEPROPOSALCMD.full_name = ".Cmd.MarriageProposalCmd"
MARRIAGEPROPOSALCMD.nested_types = {}
MARRIAGEPROPOSALCMD.enum_types = {}
MARRIAGEPROPOSALCMD.fields = {
  MARRIAGEPROPOSALCMD_CMD_FIELD,
  MARRIAGEPROPOSALCMD_PARAM_FIELD,
  MARRIAGEPROPOSALCMD_MASTERID_FIELD,
  MARRIAGEPROPOSALCMD_ITEMID_FIELD,
  MARRIAGEPROPOSALCMD_TIME_FIELD,
  MARRIAGEPROPOSALCMD_MASTERNAME_FIELD,
  MARRIAGEPROPOSALCMD_SIGN_FIELD
}
MARRIAGEPROPOSALCMD.is_extendable = false
MARRIAGEPROPOSALCMD.extensions = {}
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.name = "cmd"
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.full_name = ".Cmd.MarriageProposalReplyCmd.cmd"
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.number = 1
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.index = 0
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.label = 1
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.has_default_value = true
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.default_value = 9
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.type = 14
MARRIAGEPROPOSALREPLYCMD_CMD_FIELD.cpp_type = 8
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.name = "param"
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.full_name = ".Cmd.MarriageProposalReplyCmd.param"
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.number = 2
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.index = 1
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.label = 1
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.has_default_value = true
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.default_value = 118
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.enum_type = USER2PARAM
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.type = 14
MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD.cpp_type = 8
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.name = "masterid"
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.full_name = ".Cmd.MarriageProposalReplyCmd.masterid"
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.number = 3
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.index = 2
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.label = 1
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.has_default_value = true
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.default_value = 0
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.type = 4
MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD.cpp_type = 4
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.name = "reply"
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.full_name = ".Cmd.MarriageProposalReplyCmd.reply"
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.number = 4
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.index = 3
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.label = 1
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.has_default_value = true
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.default_value = 0
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.enum_type = EPROPOSALREPLY
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.type = 14
MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD.cpp_type = 8
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.name = "time"
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.full_name = ".Cmd.MarriageProposalReplyCmd.time"
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.number = 5
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.index = 4
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.label = 1
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.has_default_value = true
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.default_value = 0
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.type = 13
MARRIAGEPROPOSALREPLYCMD_TIME_FIELD.cpp_type = 3
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.name = "sign"
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.full_name = ".Cmd.MarriageProposalReplyCmd.sign"
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.number = 6
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.index = 5
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.label = 1
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.has_default_value = false
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.default_value = ""
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.type = 9
MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD.cpp_type = 9
MARRIAGEPROPOSALREPLYCMD.name = "MarriageProposalReplyCmd"
MARRIAGEPROPOSALREPLYCMD.full_name = ".Cmd.MarriageProposalReplyCmd"
MARRIAGEPROPOSALREPLYCMD.nested_types = {}
MARRIAGEPROPOSALREPLYCMD.enum_types = {}
MARRIAGEPROPOSALREPLYCMD.fields = {
  MARRIAGEPROPOSALREPLYCMD_CMD_FIELD,
  MARRIAGEPROPOSALREPLYCMD_PARAM_FIELD,
  MARRIAGEPROPOSALREPLYCMD_MASTERID_FIELD,
  MARRIAGEPROPOSALREPLYCMD_REPLY_FIELD,
  MARRIAGEPROPOSALREPLYCMD_TIME_FIELD,
  MARRIAGEPROPOSALREPLYCMD_SIGN_FIELD
}
MARRIAGEPROPOSALREPLYCMD.is_extendable = false
MARRIAGEPROPOSALREPLYCMD.extensions = {}
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.name = "cmd"
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.full_name = ".Cmd.UploadWeddingPhotoUserCmd.cmd"
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.number = 1
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.index = 0
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.label = 1
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.has_default_value = true
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.default_value = 9
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.type = 14
UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD.cpp_type = 8
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.name = "param"
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.full_name = ".Cmd.UploadWeddingPhotoUserCmd.param"
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.number = 2
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.index = 1
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.label = 1
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.has_default_value = true
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.default_value = 119
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.type = 14
UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD.cpp_type = 8
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.name = "itemguid"
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.full_name = ".Cmd.UploadWeddingPhotoUserCmd.itemguid"
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.number = 3
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.index = 2
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.label = 1
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.has_default_value = false
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.default_value = ""
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.type = 9
UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD.cpp_type = 9
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.name = "index"
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.full_name = ".Cmd.UploadWeddingPhotoUserCmd.index"
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.number = 4
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.index = 3
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.label = 1
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.has_default_value = true
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.default_value = 0
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.type = 13
UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD.cpp_type = 3
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.name = "time"
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.full_name = ".Cmd.UploadWeddingPhotoUserCmd.time"
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.number = 5
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.index = 4
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.label = 1
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.has_default_value = true
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.default_value = 0
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.type = 13
UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD.cpp_type = 3
UPLOADWEDDINGPHOTOUSERCMD.name = "UploadWeddingPhotoUserCmd"
UPLOADWEDDINGPHOTOUSERCMD.full_name = ".Cmd.UploadWeddingPhotoUserCmd"
UPLOADWEDDINGPHOTOUSERCMD.nested_types = {}
UPLOADWEDDINGPHOTOUSERCMD.enum_types = {}
UPLOADWEDDINGPHOTOUSERCMD.fields = {
  UPLOADWEDDINGPHOTOUSERCMD_CMD_FIELD,
  UPLOADWEDDINGPHOTOUSERCMD_PARAM_FIELD,
  UPLOADWEDDINGPHOTOUSERCMD_ITEMGUID_FIELD,
  UPLOADWEDDINGPHOTOUSERCMD_INDEX_FIELD,
  UPLOADWEDDINGPHOTOUSERCMD_TIME_FIELD
}
UPLOADWEDDINGPHOTOUSERCMD.is_extendable = false
UPLOADWEDDINGPHOTOUSERCMD.extensions = {}
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.name = "cmd"
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.full_name = ".Cmd.MarriageProposalSuccessCmd.cmd"
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.number = 1
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.index = 0
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.label = 1
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.has_default_value = true
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.default_value = 9
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.type = 14
MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD.cpp_type = 8
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.name = "param"
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.full_name = ".Cmd.MarriageProposalSuccessCmd.param"
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.number = 2
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.index = 1
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.label = 1
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.has_default_value = true
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.default_value = 120
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.enum_type = USER2PARAM
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.type = 14
MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD.cpp_type = 8
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.name = "charid"
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.full_name = ".Cmd.MarriageProposalSuccessCmd.charid"
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.number = 3
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.index = 2
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.label = 1
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.has_default_value = true
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.default_value = 0
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.type = 4
MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD.cpp_type = 4
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.name = "ismaster"
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.full_name = ".Cmd.MarriageProposalSuccessCmd.ismaster"
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.number = 4
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.index = 3
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.label = 1
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.has_default_value = true
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.default_value = true
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.type = 8
MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD.cpp_type = 7
MARRIAGEPROPOSALSUCCESSCMD.name = "MarriageProposalSuccessCmd"
MARRIAGEPROPOSALSUCCESSCMD.full_name = ".Cmd.MarriageProposalSuccessCmd"
MARRIAGEPROPOSALSUCCESSCMD.nested_types = {}
MARRIAGEPROPOSALSUCCESSCMD.enum_types = {}
MARRIAGEPROPOSALSUCCESSCMD.fields = {
  MARRIAGEPROPOSALSUCCESSCMD_CMD_FIELD,
  MARRIAGEPROPOSALSUCCESSCMD_PARAM_FIELD,
  MARRIAGEPROPOSALSUCCESSCMD_CHARID_FIELD,
  MARRIAGEPROPOSALSUCCESSCMD_ISMASTER_FIELD
}
MARRIAGEPROPOSALSUCCESSCMD.is_extendable = false
MARRIAGEPROPOSALSUCCESSCMD.extensions = {}
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.name = "cmd"
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.full_name = ".Cmd.InviteeWeddingStartNtfUserCmd.cmd"
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.number = 1
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.index = 0
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.label = 1
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.has_default_value = true
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.default_value = 9
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.type = 14
INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD.cpp_type = 8
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.name = "param"
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.full_name = ".Cmd.InviteeWeddingStartNtfUserCmd.param"
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.number = 2
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.index = 1
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.label = 1
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.has_default_value = true
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.default_value = 121
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.type = 14
INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD.cpp_type = 8
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.name = "itemguid"
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.full_name = ".Cmd.InviteeWeddingStartNtfUserCmd.itemguid"
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.number = 3
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.index = 2
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.label = 1
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.has_default_value = false
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.default_value = ""
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.type = 9
INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD.cpp_type = 9
INVITEEWEDDINGSTARTNTFUSERCMD.name = "InviteeWeddingStartNtfUserCmd"
INVITEEWEDDINGSTARTNTFUSERCMD.full_name = ".Cmd.InviteeWeddingStartNtfUserCmd"
INVITEEWEDDINGSTARTNTFUSERCMD.nested_types = {}
INVITEEWEDDINGSTARTNTFUSERCMD.enum_types = {}
INVITEEWEDDINGSTARTNTFUSERCMD.fields = {
  INVITEEWEDDINGSTARTNTFUSERCMD_CMD_FIELD,
  INVITEEWEDDINGSTARTNTFUSERCMD_PARAM_FIELD,
  INVITEEWEDDINGSTARTNTFUSERCMD_ITEMGUID_FIELD
}
INVITEEWEDDINGSTARTNTFUSERCMD.is_extendable = false
INVITEEWEDDINGSTARTNTFUSERCMD.extensions = {}
KFCSHAREUSERCMD_CMD_FIELD.name = "cmd"
KFCSHAREUSERCMD_CMD_FIELD.full_name = ".Cmd.KFCShareUserCmd.cmd"
KFCSHAREUSERCMD_CMD_FIELD.number = 1
KFCSHAREUSERCMD_CMD_FIELD.index = 0
KFCSHAREUSERCMD_CMD_FIELD.label = 1
KFCSHAREUSERCMD_CMD_FIELD.has_default_value = true
KFCSHAREUSERCMD_CMD_FIELD.default_value = 9
KFCSHAREUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
KFCSHAREUSERCMD_CMD_FIELD.type = 14
KFCSHAREUSERCMD_CMD_FIELD.cpp_type = 8
KFCSHAREUSERCMD_PARAM_FIELD.name = "param"
KFCSHAREUSERCMD_PARAM_FIELD.full_name = ".Cmd.KFCShareUserCmd.param"
KFCSHAREUSERCMD_PARAM_FIELD.number = 2
KFCSHAREUSERCMD_PARAM_FIELD.index = 1
KFCSHAREUSERCMD_PARAM_FIELD.label = 1
KFCSHAREUSERCMD_PARAM_FIELD.has_default_value = true
KFCSHAREUSERCMD_PARAM_FIELD.default_value = 128
KFCSHAREUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
KFCSHAREUSERCMD_PARAM_FIELD.type = 14
KFCSHAREUSERCMD_PARAM_FIELD.cpp_type = 8
KFCSHAREUSERCMD_SHARETYPE_FIELD.name = "sharetype"
KFCSHAREUSERCMD_SHARETYPE_FIELD.full_name = ".Cmd.KFCShareUserCmd.sharetype"
KFCSHAREUSERCMD_SHARETYPE_FIELD.number = 3
KFCSHAREUSERCMD_SHARETYPE_FIELD.index = 2
KFCSHAREUSERCMD_SHARETYPE_FIELD.label = 1
KFCSHAREUSERCMD_SHARETYPE_FIELD.has_default_value = true
KFCSHAREUSERCMD_SHARETYPE_FIELD.default_value = 0
KFCSHAREUSERCMD_SHARETYPE_FIELD.enum_type = SHARETYPE
KFCSHAREUSERCMD_SHARETYPE_FIELD.type = 14
KFCSHAREUSERCMD_SHARETYPE_FIELD.cpp_type = 8
KFCSHAREUSERCMD.name = "KFCShareUserCmd"
KFCSHAREUSERCMD.full_name = ".Cmd.KFCShareUserCmd"
KFCSHAREUSERCMD.nested_types = {}
KFCSHAREUSERCMD.enum_types = {}
KFCSHAREUSERCMD.fields = {
  KFCSHAREUSERCMD_CMD_FIELD,
  KFCSHAREUSERCMD_PARAM_FIELD,
  KFCSHAREUSERCMD_SHARETYPE_FIELD
}
KFCSHAREUSERCMD.is_extendable = false
KFCSHAREUSERCMD.extensions = {}
KFCENROLLUSERCMD_CMD_FIELD.name = "cmd"
KFCENROLLUSERCMD_CMD_FIELD.full_name = ".Cmd.KFCEnrollUserCmd.cmd"
KFCENROLLUSERCMD_CMD_FIELD.number = 1
KFCENROLLUSERCMD_CMD_FIELD.index = 0
KFCENROLLUSERCMD_CMD_FIELD.label = 1
KFCENROLLUSERCMD_CMD_FIELD.has_default_value = true
KFCENROLLUSERCMD_CMD_FIELD.default_value = 9
KFCENROLLUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
KFCENROLLUSERCMD_CMD_FIELD.type = 14
KFCENROLLUSERCMD_CMD_FIELD.cpp_type = 8
KFCENROLLUSERCMD_PARAM_FIELD.name = "param"
KFCENROLLUSERCMD_PARAM_FIELD.full_name = ".Cmd.KFCEnrollUserCmd.param"
KFCENROLLUSERCMD_PARAM_FIELD.number = 2
KFCENROLLUSERCMD_PARAM_FIELD.index = 1
KFCENROLLUSERCMD_PARAM_FIELD.label = 1
KFCENROLLUSERCMD_PARAM_FIELD.has_default_value = true
KFCENROLLUSERCMD_PARAM_FIELD.default_value = 162
KFCENROLLUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
KFCENROLLUSERCMD_PARAM_FIELD.type = 14
KFCENROLLUSERCMD_PARAM_FIELD.cpp_type = 8
KFCENROLLUSERCMD_PHONE_FIELD.name = "phone"
KFCENROLLUSERCMD_PHONE_FIELD.full_name = ".Cmd.KFCEnrollUserCmd.phone"
KFCENROLLUSERCMD_PHONE_FIELD.number = 3
KFCENROLLUSERCMD_PHONE_FIELD.index = 2
KFCENROLLUSERCMD_PHONE_FIELD.label = 1
KFCENROLLUSERCMD_PHONE_FIELD.has_default_value = false
KFCENROLLUSERCMD_PHONE_FIELD.default_value = ""
KFCENROLLUSERCMD_PHONE_FIELD.type = 9
KFCENROLLUSERCMD_PHONE_FIELD.cpp_type = 9
KFCENROLLUSERCMD.name = "KFCEnrollUserCmd"
KFCENROLLUSERCMD.full_name = ".Cmd.KFCEnrollUserCmd"
KFCENROLLUSERCMD.nested_types = {}
KFCENROLLUSERCMD.enum_types = {}
KFCENROLLUSERCMD.fields = {
  KFCENROLLUSERCMD_CMD_FIELD,
  KFCENROLLUSERCMD_PARAM_FIELD,
  KFCENROLLUSERCMD_PHONE_FIELD
}
KFCENROLLUSERCMD.is_extendable = false
KFCENROLLUSERCMD.extensions = {}
KFCENROLLCODEUSERCMD_CMD_FIELD.name = "cmd"
KFCENROLLCODEUSERCMD_CMD_FIELD.full_name = ".Cmd.KFCEnrollCodeUserCmd.cmd"
KFCENROLLCODEUSERCMD_CMD_FIELD.number = 1
KFCENROLLCODEUSERCMD_CMD_FIELD.index = 0
KFCENROLLCODEUSERCMD_CMD_FIELD.label = 1
KFCENROLLCODEUSERCMD_CMD_FIELD.has_default_value = true
KFCENROLLCODEUSERCMD_CMD_FIELD.default_value = 9
KFCENROLLCODEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
KFCENROLLCODEUSERCMD_CMD_FIELD.type = 14
KFCENROLLCODEUSERCMD_CMD_FIELD.cpp_type = 8
KFCENROLLCODEUSERCMD_PARAM_FIELD.name = "param"
KFCENROLLCODEUSERCMD_PARAM_FIELD.full_name = ".Cmd.KFCEnrollCodeUserCmd.param"
KFCENROLLCODEUSERCMD_PARAM_FIELD.number = 2
KFCENROLLCODEUSERCMD_PARAM_FIELD.index = 1
KFCENROLLCODEUSERCMD_PARAM_FIELD.label = 1
KFCENROLLCODEUSERCMD_PARAM_FIELD.has_default_value = true
KFCENROLLCODEUSERCMD_PARAM_FIELD.default_value = 168
KFCENROLLCODEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
KFCENROLLCODEUSERCMD_PARAM_FIELD.type = 14
KFCENROLLCODEUSERCMD_PARAM_FIELD.cpp_type = 8
KFCENROLLCODEUSERCMD_CODE_FIELD.name = "code"
KFCENROLLCODEUSERCMD_CODE_FIELD.full_name = ".Cmd.KFCEnrollCodeUserCmd.code"
KFCENROLLCODEUSERCMD_CODE_FIELD.number = 3
KFCENROLLCODEUSERCMD_CODE_FIELD.index = 2
KFCENROLLCODEUSERCMD_CODE_FIELD.label = 1
KFCENROLLCODEUSERCMD_CODE_FIELD.has_default_value = false
KFCENROLLCODEUSERCMD_CODE_FIELD.default_value = 0
KFCENROLLCODEUSERCMD_CODE_FIELD.type = 13
KFCENROLLCODEUSERCMD_CODE_FIELD.cpp_type = 3
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.name = "district"
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.full_name = ".Cmd.KFCEnrollCodeUserCmd.district"
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.number = 4
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.index = 3
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.label = 1
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.has_default_value = false
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.default_value = ""
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.type = 9
KFCENROLLCODEUSERCMD_DISTRICT_FIELD.cpp_type = 9
KFCENROLLCODEUSERCMD.name = "KFCEnrollCodeUserCmd"
KFCENROLLCODEUSERCMD.full_name = ".Cmd.KFCEnrollCodeUserCmd"
KFCENROLLCODEUSERCMD.nested_types = {}
KFCENROLLCODEUSERCMD.enum_types = {}
KFCENROLLCODEUSERCMD.fields = {
  KFCENROLLCODEUSERCMD_CMD_FIELD,
  KFCENROLLCODEUSERCMD_PARAM_FIELD,
  KFCENROLLCODEUSERCMD_CODE_FIELD,
  KFCENROLLCODEUSERCMD_DISTRICT_FIELD
}
KFCENROLLCODEUSERCMD.is_extendable = false
KFCENROLLCODEUSERCMD.extensions = {}
KFCENROLLREPLYUSERCMD_CMD_FIELD.name = "cmd"
KFCENROLLREPLYUSERCMD_CMD_FIELD.full_name = ".Cmd.KFCEnrollReplyUserCmd.cmd"
KFCENROLLREPLYUSERCMD_CMD_FIELD.number = 1
KFCENROLLREPLYUSERCMD_CMD_FIELD.index = 0
KFCENROLLREPLYUSERCMD_CMD_FIELD.label = 1
KFCENROLLREPLYUSERCMD_CMD_FIELD.has_default_value = true
KFCENROLLREPLYUSERCMD_CMD_FIELD.default_value = 9
KFCENROLLREPLYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
KFCENROLLREPLYUSERCMD_CMD_FIELD.type = 14
KFCENROLLREPLYUSERCMD_CMD_FIELD.cpp_type = 8
KFCENROLLREPLYUSERCMD_PARAM_FIELD.name = "param"
KFCENROLLREPLYUSERCMD_PARAM_FIELD.full_name = ".Cmd.KFCEnrollReplyUserCmd.param"
KFCENROLLREPLYUSERCMD_PARAM_FIELD.number = 2
KFCENROLLREPLYUSERCMD_PARAM_FIELD.index = 1
KFCENROLLREPLYUSERCMD_PARAM_FIELD.label = 1
KFCENROLLREPLYUSERCMD_PARAM_FIELD.has_default_value = true
KFCENROLLREPLYUSERCMD_PARAM_FIELD.default_value = 163
KFCENROLLREPLYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
KFCENROLLREPLYUSERCMD_PARAM_FIELD.type = 14
KFCENROLLREPLYUSERCMD_PARAM_FIELD.cpp_type = 8
KFCENROLLREPLYUSERCMD_RESULT_FIELD.name = "result"
KFCENROLLREPLYUSERCMD_RESULT_FIELD.full_name = ".Cmd.KFCEnrollReplyUserCmd.result"
KFCENROLLREPLYUSERCMD_RESULT_FIELD.number = 3
KFCENROLLREPLYUSERCMD_RESULT_FIELD.index = 2
KFCENROLLREPLYUSERCMD_RESULT_FIELD.label = 1
KFCENROLLREPLYUSERCMD_RESULT_FIELD.has_default_value = true
KFCENROLLREPLYUSERCMD_RESULT_FIELD.default_value = 0
KFCENROLLREPLYUSERCMD_RESULT_FIELD.enum_type = ENROLLRESULT
KFCENROLLREPLYUSERCMD_RESULT_FIELD.type = 14
KFCENROLLREPLYUSERCMD_RESULT_FIELD.cpp_type = 8
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.name = "district"
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.full_name = ".Cmd.KFCEnrollReplyUserCmd.district"
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.number = 4
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.index = 3
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.label = 1
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.has_default_value = false
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.default_value = ""
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.type = 9
KFCENROLLREPLYUSERCMD_DISTRICT_FIELD.cpp_type = 9
KFCENROLLREPLYUSERCMD_INDEX_FIELD.name = "index"
KFCENROLLREPLYUSERCMD_INDEX_FIELD.full_name = ".Cmd.KFCEnrollReplyUserCmd.index"
KFCENROLLREPLYUSERCMD_INDEX_FIELD.number = 5
KFCENROLLREPLYUSERCMD_INDEX_FIELD.index = 4
KFCENROLLREPLYUSERCMD_INDEX_FIELD.label = 1
KFCENROLLREPLYUSERCMD_INDEX_FIELD.has_default_value = false
KFCENROLLREPLYUSERCMD_INDEX_FIELD.default_value = 0
KFCENROLLREPLYUSERCMD_INDEX_FIELD.type = 13
KFCENROLLREPLYUSERCMD_INDEX_FIELD.cpp_type = 3
KFCENROLLREPLYUSERCMD.name = "KFCEnrollReplyUserCmd"
KFCENROLLREPLYUSERCMD.full_name = ".Cmd.KFCEnrollReplyUserCmd"
KFCENROLLREPLYUSERCMD.nested_types = {}
KFCENROLLREPLYUSERCMD.enum_types = {}
KFCENROLLREPLYUSERCMD.fields = {
  KFCENROLLREPLYUSERCMD_CMD_FIELD,
  KFCENROLLREPLYUSERCMD_PARAM_FIELD,
  KFCENROLLREPLYUSERCMD_RESULT_FIELD,
  KFCENROLLREPLYUSERCMD_DISTRICT_FIELD,
  KFCENROLLREPLYUSERCMD_INDEX_FIELD
}
KFCENROLLREPLYUSERCMD.is_extendable = false
KFCENROLLREPLYUSERCMD.extensions = {}
KFCENROLLQUERYUSERCMD_CMD_FIELD.name = "cmd"
KFCENROLLQUERYUSERCMD_CMD_FIELD.full_name = ".Cmd.KFCEnrollQueryUserCmd.cmd"
KFCENROLLQUERYUSERCMD_CMD_FIELD.number = 1
KFCENROLLQUERYUSERCMD_CMD_FIELD.index = 0
KFCENROLLQUERYUSERCMD_CMD_FIELD.label = 1
KFCENROLLQUERYUSERCMD_CMD_FIELD.has_default_value = true
KFCENROLLQUERYUSERCMD_CMD_FIELD.default_value = 9
KFCENROLLQUERYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
KFCENROLLQUERYUSERCMD_CMD_FIELD.type = 14
KFCENROLLQUERYUSERCMD_CMD_FIELD.cpp_type = 8
KFCENROLLQUERYUSERCMD_PARAM_FIELD.name = "param"
KFCENROLLQUERYUSERCMD_PARAM_FIELD.full_name = ".Cmd.KFCEnrollQueryUserCmd.param"
KFCENROLLQUERYUSERCMD_PARAM_FIELD.number = 2
KFCENROLLQUERYUSERCMD_PARAM_FIELD.index = 1
KFCENROLLQUERYUSERCMD_PARAM_FIELD.label = 1
KFCENROLLQUERYUSERCMD_PARAM_FIELD.has_default_value = true
KFCENROLLQUERYUSERCMD_PARAM_FIELD.default_value = 167
KFCENROLLQUERYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
KFCENROLLQUERYUSERCMD_PARAM_FIELD.type = 14
KFCENROLLQUERYUSERCMD_PARAM_FIELD.cpp_type = 8
KFCENROLLQUERYUSERCMD.name = "KFCEnrollQueryUserCmd"
KFCENROLLQUERYUSERCMD.full_name = ".Cmd.KFCEnrollQueryUserCmd"
KFCENROLLQUERYUSERCMD.nested_types = {}
KFCENROLLQUERYUSERCMD.enum_types = {}
KFCENROLLQUERYUSERCMD.fields = {
  KFCENROLLQUERYUSERCMD_CMD_FIELD,
  KFCENROLLQUERYUSERCMD_PARAM_FIELD
}
KFCENROLLQUERYUSERCMD.is_extendable = false
KFCENROLLQUERYUSERCMD.extensions = {}
KFCHASENROLLEDUSERCMD_CMD_FIELD.name = "cmd"
KFCHASENROLLEDUSERCMD_CMD_FIELD.full_name = ".Cmd.KFCHasEnrolledUserCmd.cmd"
KFCHASENROLLEDUSERCMD_CMD_FIELD.number = 1
KFCHASENROLLEDUSERCMD_CMD_FIELD.index = 0
KFCHASENROLLEDUSERCMD_CMD_FIELD.label = 1
KFCHASENROLLEDUSERCMD_CMD_FIELD.has_default_value = true
KFCHASENROLLEDUSERCMD_CMD_FIELD.default_value = 9
KFCHASENROLLEDUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
KFCHASENROLLEDUSERCMD_CMD_FIELD.type = 14
KFCHASENROLLEDUSERCMD_CMD_FIELD.cpp_type = 8
KFCHASENROLLEDUSERCMD_PARAM_FIELD.name = "param"
KFCHASENROLLEDUSERCMD_PARAM_FIELD.full_name = ".Cmd.KFCHasEnrolledUserCmd.param"
KFCHASENROLLEDUSERCMD_PARAM_FIELD.number = 2
KFCHASENROLLEDUSERCMD_PARAM_FIELD.index = 1
KFCHASENROLLEDUSERCMD_PARAM_FIELD.label = 1
KFCHASENROLLEDUSERCMD_PARAM_FIELD.has_default_value = true
KFCHASENROLLEDUSERCMD_PARAM_FIELD.default_value = 166
KFCHASENROLLEDUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
KFCHASENROLLEDUSERCMD_PARAM_FIELD.type = 14
KFCHASENROLLEDUSERCMD_PARAM_FIELD.cpp_type = 8
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.name = "hasenrolled"
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.full_name = ".Cmd.KFCHasEnrolledUserCmd.hasenrolled"
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.number = 3
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.index = 2
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.label = 1
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.has_default_value = true
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.default_value = false
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.type = 8
KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD.cpp_type = 7
KFCHASENROLLEDUSERCMD.name = "KFCHasEnrolledUserCmd"
KFCHASENROLLEDUSERCMD.full_name = ".Cmd.KFCHasEnrolledUserCmd"
KFCHASENROLLEDUSERCMD.nested_types = {}
KFCHASENROLLEDUSERCMD.enum_types = {}
KFCHASENROLLEDUSERCMD.fields = {
  KFCHASENROLLEDUSERCMD_CMD_FIELD,
  KFCHASENROLLEDUSERCMD_PARAM_FIELD,
  KFCHASENROLLEDUSERCMD_HASENROLLED_FIELD
}
KFCHASENROLLEDUSERCMD.is_extendable = false
KFCHASENROLLEDUSERCMD.extensions = {}
CHECKRELATIONUSERCMD_CMD_FIELD.name = "cmd"
CHECKRELATIONUSERCMD_CMD_FIELD.full_name = ".Cmd.CheckRelationUserCmd.cmd"
CHECKRELATIONUSERCMD_CMD_FIELD.number = 1
CHECKRELATIONUSERCMD_CMD_FIELD.index = 0
CHECKRELATIONUSERCMD_CMD_FIELD.label = 1
CHECKRELATIONUSERCMD_CMD_FIELD.has_default_value = true
CHECKRELATIONUSERCMD_CMD_FIELD.default_value = 9
CHECKRELATIONUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHECKRELATIONUSERCMD_CMD_FIELD.type = 14
CHECKRELATIONUSERCMD_CMD_FIELD.cpp_type = 8
CHECKRELATIONUSERCMD_PARAM_FIELD.name = "param"
CHECKRELATIONUSERCMD_PARAM_FIELD.full_name = ".Cmd.CheckRelationUserCmd.param"
CHECKRELATIONUSERCMD_PARAM_FIELD.number = 2
CHECKRELATIONUSERCMD_PARAM_FIELD.index = 1
CHECKRELATIONUSERCMD_PARAM_FIELD.label = 1
CHECKRELATIONUSERCMD_PARAM_FIELD.has_default_value = true
CHECKRELATIONUSERCMD_PARAM_FIELD.default_value = 130
CHECKRELATIONUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CHECKRELATIONUSERCMD_PARAM_FIELD.type = 14
CHECKRELATIONUSERCMD_PARAM_FIELD.cpp_type = 8
CHECKRELATIONUSERCMD_CHARID_FIELD.name = "charid"
CHECKRELATIONUSERCMD_CHARID_FIELD.full_name = ".Cmd.CheckRelationUserCmd.charid"
CHECKRELATIONUSERCMD_CHARID_FIELD.number = 3
CHECKRELATIONUSERCMD_CHARID_FIELD.index = 2
CHECKRELATIONUSERCMD_CHARID_FIELD.label = 1
CHECKRELATIONUSERCMD_CHARID_FIELD.has_default_value = true
CHECKRELATIONUSERCMD_CHARID_FIELD.default_value = 0
CHECKRELATIONUSERCMD_CHARID_FIELD.type = 4
CHECKRELATIONUSERCMD_CHARID_FIELD.cpp_type = 4
CHECKRELATIONUSERCMD_ETYPE_FIELD.name = "etype"
CHECKRELATIONUSERCMD_ETYPE_FIELD.full_name = ".Cmd.CheckRelationUserCmd.etype"
CHECKRELATIONUSERCMD_ETYPE_FIELD.number = 4
CHECKRELATIONUSERCMD_ETYPE_FIELD.index = 3
CHECKRELATIONUSERCMD_ETYPE_FIELD.label = 1
CHECKRELATIONUSERCMD_ETYPE_FIELD.has_default_value = true
CHECKRELATIONUSERCMD_ETYPE_FIELD.default_value = 1
CHECKRELATIONUSERCMD_ETYPE_FIELD.enum_type = SESSIONSOCIALITY_PB_ESOCIALRELATION
CHECKRELATIONUSERCMD_ETYPE_FIELD.type = 14
CHECKRELATIONUSERCMD_ETYPE_FIELD.cpp_type = 8
CHECKRELATIONUSERCMD_RET_FIELD.name = "ret"
CHECKRELATIONUSERCMD_RET_FIELD.full_name = ".Cmd.CheckRelationUserCmd.ret"
CHECKRELATIONUSERCMD_RET_FIELD.number = 5
CHECKRELATIONUSERCMD_RET_FIELD.index = 4
CHECKRELATIONUSERCMD_RET_FIELD.label = 1
CHECKRELATIONUSERCMD_RET_FIELD.has_default_value = true
CHECKRELATIONUSERCMD_RET_FIELD.default_value = false
CHECKRELATIONUSERCMD_RET_FIELD.type = 8
CHECKRELATIONUSERCMD_RET_FIELD.cpp_type = 7
CHECKRELATIONUSERCMD.name = "CheckRelationUserCmd"
CHECKRELATIONUSERCMD.full_name = ".Cmd.CheckRelationUserCmd"
CHECKRELATIONUSERCMD.nested_types = {}
CHECKRELATIONUSERCMD.enum_types = {}
CHECKRELATIONUSERCMD.fields = {
  CHECKRELATIONUSERCMD_CMD_FIELD,
  CHECKRELATIONUSERCMD_PARAM_FIELD,
  CHECKRELATIONUSERCMD_CHARID_FIELD,
  CHECKRELATIONUSERCMD_ETYPE_FIELD,
  CHECKRELATIONUSERCMD_RET_FIELD
}
CHECKRELATIONUSERCMD.is_extendable = false
CHECKRELATIONUSERCMD.extensions = {}
TWINSACTIONUSERCMD_CMD_FIELD.name = "cmd"
TWINSACTIONUSERCMD_CMD_FIELD.full_name = ".Cmd.TwinsActionUserCmd.cmd"
TWINSACTIONUSERCMD_CMD_FIELD.number = 1
TWINSACTIONUSERCMD_CMD_FIELD.index = 0
TWINSACTIONUSERCMD_CMD_FIELD.label = 1
TWINSACTIONUSERCMD_CMD_FIELD.has_default_value = true
TWINSACTIONUSERCMD_CMD_FIELD.default_value = 9
TWINSACTIONUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TWINSACTIONUSERCMD_CMD_FIELD.type = 14
TWINSACTIONUSERCMD_CMD_FIELD.cpp_type = 8
TWINSACTIONUSERCMD_PARAM_FIELD.name = "param"
TWINSACTIONUSERCMD_PARAM_FIELD.full_name = ".Cmd.TwinsActionUserCmd.param"
TWINSACTIONUSERCMD_PARAM_FIELD.number = 2
TWINSACTIONUSERCMD_PARAM_FIELD.index = 1
TWINSACTIONUSERCMD_PARAM_FIELD.label = 1
TWINSACTIONUSERCMD_PARAM_FIELD.has_default_value = true
TWINSACTIONUSERCMD_PARAM_FIELD.default_value = 129
TWINSACTIONUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
TWINSACTIONUSERCMD_PARAM_FIELD.type = 14
TWINSACTIONUSERCMD_PARAM_FIELD.cpp_type = 8
TWINSACTIONUSERCMD_USERID_FIELD.name = "userid"
TWINSACTIONUSERCMD_USERID_FIELD.full_name = ".Cmd.TwinsActionUserCmd.userid"
TWINSACTIONUSERCMD_USERID_FIELD.number = 3
TWINSACTIONUSERCMD_USERID_FIELD.index = 2
TWINSACTIONUSERCMD_USERID_FIELD.label = 1
TWINSACTIONUSERCMD_USERID_FIELD.has_default_value = true
TWINSACTIONUSERCMD_USERID_FIELD.default_value = 0
TWINSACTIONUSERCMD_USERID_FIELD.type = 4
TWINSACTIONUSERCMD_USERID_FIELD.cpp_type = 4
TWINSACTIONUSERCMD_ACTIONID_FIELD.name = "actionid"
TWINSACTIONUSERCMD_ACTIONID_FIELD.full_name = ".Cmd.TwinsActionUserCmd.actionid"
TWINSACTIONUSERCMD_ACTIONID_FIELD.number = 4
TWINSACTIONUSERCMD_ACTIONID_FIELD.index = 3
TWINSACTIONUSERCMD_ACTIONID_FIELD.label = 1
TWINSACTIONUSERCMD_ACTIONID_FIELD.has_default_value = true
TWINSACTIONUSERCMD_ACTIONID_FIELD.default_value = 0
TWINSACTIONUSERCMD_ACTIONID_FIELD.type = 13
TWINSACTIONUSERCMD_ACTIONID_FIELD.cpp_type = 3
TWINSACTIONUSERCMD_ETYPE_FIELD.name = "etype"
TWINSACTIONUSERCMD_ETYPE_FIELD.full_name = ".Cmd.TwinsActionUserCmd.etype"
TWINSACTIONUSERCMD_ETYPE_FIELD.number = 5
TWINSACTIONUSERCMD_ETYPE_FIELD.index = 4
TWINSACTIONUSERCMD_ETYPE_FIELD.label = 1
TWINSACTIONUSERCMD_ETYPE_FIELD.has_default_value = true
TWINSACTIONUSERCMD_ETYPE_FIELD.default_value = 0
TWINSACTIONUSERCMD_ETYPE_FIELD.enum_type = ETWINSOPERATION
TWINSACTIONUSERCMD_ETYPE_FIELD.type = 14
TWINSACTIONUSERCMD_ETYPE_FIELD.cpp_type = 8
TWINSACTIONUSERCMD_SPONSOR_FIELD.name = "sponsor"
TWINSACTIONUSERCMD_SPONSOR_FIELD.full_name = ".Cmd.TwinsActionUserCmd.sponsor"
TWINSACTIONUSERCMD_SPONSOR_FIELD.number = 6
TWINSACTIONUSERCMD_SPONSOR_FIELD.index = 5
TWINSACTIONUSERCMD_SPONSOR_FIELD.label = 1
TWINSACTIONUSERCMD_SPONSOR_FIELD.has_default_value = true
TWINSACTIONUSERCMD_SPONSOR_FIELD.default_value = true
TWINSACTIONUSERCMD_SPONSOR_FIELD.type = 8
TWINSACTIONUSERCMD_SPONSOR_FIELD.cpp_type = 7
TWINSACTIONUSERCMD.name = "TwinsActionUserCmd"
TWINSACTIONUSERCMD.full_name = ".Cmd.TwinsActionUserCmd"
TWINSACTIONUSERCMD.nested_types = {}
TWINSACTIONUSERCMD.enum_types = {}
TWINSACTIONUSERCMD.fields = {
  TWINSACTIONUSERCMD_CMD_FIELD,
  TWINSACTIONUSERCMD_PARAM_FIELD,
  TWINSACTIONUSERCMD_USERID_FIELD,
  TWINSACTIONUSERCMD_ACTIONID_FIELD,
  TWINSACTIONUSERCMD_ETYPE_FIELD,
  TWINSACTIONUSERCMD_SPONSOR_FIELD
}
TWINSACTIONUSERCMD.is_extendable = false
TWINSACTIONUSERCMD.extensions = {}
SHOWSERVANTUSERCMD_CMD_FIELD.name = "cmd"
SHOWSERVANTUSERCMD_CMD_FIELD.full_name = ".Cmd.ShowServantUserCmd.cmd"
SHOWSERVANTUSERCMD_CMD_FIELD.number = 1
SHOWSERVANTUSERCMD_CMD_FIELD.index = 0
SHOWSERVANTUSERCMD_CMD_FIELD.label = 1
SHOWSERVANTUSERCMD_CMD_FIELD.has_default_value = true
SHOWSERVANTUSERCMD_CMD_FIELD.default_value = 9
SHOWSERVANTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SHOWSERVANTUSERCMD_CMD_FIELD.type = 14
SHOWSERVANTUSERCMD_CMD_FIELD.cpp_type = 8
SHOWSERVANTUSERCMD_PARAM_FIELD.name = "param"
SHOWSERVANTUSERCMD_PARAM_FIELD.full_name = ".Cmd.ShowServantUserCmd.param"
SHOWSERVANTUSERCMD_PARAM_FIELD.number = 2
SHOWSERVANTUSERCMD_PARAM_FIELD.index = 1
SHOWSERVANTUSERCMD_PARAM_FIELD.label = 1
SHOWSERVANTUSERCMD_PARAM_FIELD.has_default_value = true
SHOWSERVANTUSERCMD_PARAM_FIELD.default_value = 122
SHOWSERVANTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SHOWSERVANTUSERCMD_PARAM_FIELD.type = 14
SHOWSERVANTUSERCMD_PARAM_FIELD.cpp_type = 8
SHOWSERVANTUSERCMD_SHOW_FIELD.name = "show"
SHOWSERVANTUSERCMD_SHOW_FIELD.full_name = ".Cmd.ShowServantUserCmd.show"
SHOWSERVANTUSERCMD_SHOW_FIELD.number = 3
SHOWSERVANTUSERCMD_SHOW_FIELD.index = 2
SHOWSERVANTUSERCMD_SHOW_FIELD.label = 1
SHOWSERVANTUSERCMD_SHOW_FIELD.has_default_value = false
SHOWSERVANTUSERCMD_SHOW_FIELD.default_value = false
SHOWSERVANTUSERCMD_SHOW_FIELD.type = 8
SHOWSERVANTUSERCMD_SHOW_FIELD.cpp_type = 7
SHOWSERVANTUSERCMD.name = "ShowServantUserCmd"
SHOWSERVANTUSERCMD.full_name = ".Cmd.ShowServantUserCmd"
SHOWSERVANTUSERCMD.nested_types = {}
SHOWSERVANTUSERCMD.enum_types = {}
SHOWSERVANTUSERCMD.fields = {
  SHOWSERVANTUSERCMD_CMD_FIELD,
  SHOWSERVANTUSERCMD_PARAM_FIELD,
  SHOWSERVANTUSERCMD_SHOW_FIELD
}
SHOWSERVANTUSERCMD.is_extendable = false
SHOWSERVANTUSERCMD.extensions = {}
REPLACESERVANTUSERCMD_CMD_FIELD.name = "cmd"
REPLACESERVANTUSERCMD_CMD_FIELD.full_name = ".Cmd.ReplaceServantUserCmd.cmd"
REPLACESERVANTUSERCMD_CMD_FIELD.number = 1
REPLACESERVANTUSERCMD_CMD_FIELD.index = 0
REPLACESERVANTUSERCMD_CMD_FIELD.label = 1
REPLACESERVANTUSERCMD_CMD_FIELD.has_default_value = true
REPLACESERVANTUSERCMD_CMD_FIELD.default_value = 9
REPLACESERVANTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REPLACESERVANTUSERCMD_CMD_FIELD.type = 14
REPLACESERVANTUSERCMD_CMD_FIELD.cpp_type = 8
REPLACESERVANTUSERCMD_PARAM_FIELD.name = "param"
REPLACESERVANTUSERCMD_PARAM_FIELD.full_name = ".Cmd.ReplaceServantUserCmd.param"
REPLACESERVANTUSERCMD_PARAM_FIELD.number = 2
REPLACESERVANTUSERCMD_PARAM_FIELD.index = 1
REPLACESERVANTUSERCMD_PARAM_FIELD.label = 1
REPLACESERVANTUSERCMD_PARAM_FIELD.has_default_value = true
REPLACESERVANTUSERCMD_PARAM_FIELD.default_value = 123
REPLACESERVANTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
REPLACESERVANTUSERCMD_PARAM_FIELD.type = 14
REPLACESERVANTUSERCMD_PARAM_FIELD.cpp_type = 8
REPLACESERVANTUSERCMD_REPLACE_FIELD.name = "replace"
REPLACESERVANTUSERCMD_REPLACE_FIELD.full_name = ".Cmd.ReplaceServantUserCmd.replace"
REPLACESERVANTUSERCMD_REPLACE_FIELD.number = 3
REPLACESERVANTUSERCMD_REPLACE_FIELD.index = 2
REPLACESERVANTUSERCMD_REPLACE_FIELD.label = 1
REPLACESERVANTUSERCMD_REPLACE_FIELD.has_default_value = false
REPLACESERVANTUSERCMD_REPLACE_FIELD.default_value = false
REPLACESERVANTUSERCMD_REPLACE_FIELD.type = 8
REPLACESERVANTUSERCMD_REPLACE_FIELD.cpp_type = 7
REPLACESERVANTUSERCMD_SERVANT_FIELD.name = "servant"
REPLACESERVANTUSERCMD_SERVANT_FIELD.full_name = ".Cmd.ReplaceServantUserCmd.servant"
REPLACESERVANTUSERCMD_SERVANT_FIELD.number = 4
REPLACESERVANTUSERCMD_SERVANT_FIELD.index = 3
REPLACESERVANTUSERCMD_SERVANT_FIELD.label = 1
REPLACESERVANTUSERCMD_SERVANT_FIELD.has_default_value = true
REPLACESERVANTUSERCMD_SERVANT_FIELD.default_value = 0
REPLACESERVANTUSERCMD_SERVANT_FIELD.type = 13
REPLACESERVANTUSERCMD_SERVANT_FIELD.cpp_type = 3
REPLACESERVANTUSERCMD.name = "ReplaceServantUserCmd"
REPLACESERVANTUSERCMD.full_name = ".Cmd.ReplaceServantUserCmd"
REPLACESERVANTUSERCMD.nested_types = {}
REPLACESERVANTUSERCMD.enum_types = {}
REPLACESERVANTUSERCMD.fields = {
  REPLACESERVANTUSERCMD_CMD_FIELD,
  REPLACESERVANTUSERCMD_PARAM_FIELD,
  REPLACESERVANTUSERCMD_REPLACE_FIELD,
  REPLACESERVANTUSERCMD_SERVANT_FIELD
}
REPLACESERVANTUSERCMD.is_extendable = false
REPLACESERVANTUSERCMD.extensions = {}
SERVANTSERVICE_CMD_FIELD.name = "cmd"
SERVANTSERVICE_CMD_FIELD.full_name = ".Cmd.ServantService.cmd"
SERVANTSERVICE_CMD_FIELD.number = 1
SERVANTSERVICE_CMD_FIELD.index = 0
SERVANTSERVICE_CMD_FIELD.label = 1
SERVANTSERVICE_CMD_FIELD.has_default_value = true
SERVANTSERVICE_CMD_FIELD.default_value = 9
SERVANTSERVICE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SERVANTSERVICE_CMD_FIELD.type = 14
SERVANTSERVICE_CMD_FIELD.cpp_type = 8
SERVANTSERVICE_PARAM_FIELD.name = "param"
SERVANTSERVICE_PARAM_FIELD.full_name = ".Cmd.ServantService.param"
SERVANTSERVICE_PARAM_FIELD.number = 2
SERVANTSERVICE_PARAM_FIELD.index = 1
SERVANTSERVICE_PARAM_FIELD.label = 1
SERVANTSERVICE_PARAM_FIELD.has_default_value = true
SERVANTSERVICE_PARAM_FIELD.default_value = 124
SERVANTSERVICE_PARAM_FIELD.enum_type = USER2PARAM
SERVANTSERVICE_PARAM_FIELD.type = 14
SERVANTSERVICE_PARAM_FIELD.cpp_type = 8
SERVANTSERVICE_TYPE_FIELD.name = "type"
SERVANTSERVICE_TYPE_FIELD.full_name = ".Cmd.ServantService.type"
SERVANTSERVICE_TYPE_FIELD.number = 3
SERVANTSERVICE_TYPE_FIELD.index = 2
SERVANTSERVICE_TYPE_FIELD.label = 1
SERVANTSERVICE_TYPE_FIELD.has_default_value = true
SERVANTSERVICE_TYPE_FIELD.default_value = 1
SERVANTSERVICE_TYPE_FIELD.enum_type = ESERVANTSERVICE
SERVANTSERVICE_TYPE_FIELD.type = 14
SERVANTSERVICE_TYPE_FIELD.cpp_type = 8
SERVANTSERVICE.name = "ServantService"
SERVANTSERVICE.full_name = ".Cmd.ServantService"
SERVANTSERVICE.nested_types = {}
SERVANTSERVICE.enum_types = {}
SERVANTSERVICE.fields = {
  SERVANTSERVICE_CMD_FIELD,
  SERVANTSERVICE_PARAM_FIELD,
  SERVANTSERVICE_TYPE_FIELD
}
SERVANTSERVICE.is_extendable = false
SERVANTSERVICE.extensions = {}
RECOMMENDITEMINFO_DWID_FIELD.name = "dwid"
RECOMMENDITEMINFO_DWID_FIELD.full_name = ".Cmd.RecommendItemInfo.dwid"
RECOMMENDITEMINFO_DWID_FIELD.number = 1
RECOMMENDITEMINFO_DWID_FIELD.index = 0
RECOMMENDITEMINFO_DWID_FIELD.label = 1
RECOMMENDITEMINFO_DWID_FIELD.has_default_value = true
RECOMMENDITEMINFO_DWID_FIELD.default_value = 0
RECOMMENDITEMINFO_DWID_FIELD.type = 13
RECOMMENDITEMINFO_DWID_FIELD.cpp_type = 3
RECOMMENDITEMINFO_FINISHTIMES_FIELD.name = "finishtimes"
RECOMMENDITEMINFO_FINISHTIMES_FIELD.full_name = ".Cmd.RecommendItemInfo.finishtimes"
RECOMMENDITEMINFO_FINISHTIMES_FIELD.number = 2
RECOMMENDITEMINFO_FINISHTIMES_FIELD.index = 1
RECOMMENDITEMINFO_FINISHTIMES_FIELD.label = 1
RECOMMENDITEMINFO_FINISHTIMES_FIELD.has_default_value = true
RECOMMENDITEMINFO_FINISHTIMES_FIELD.default_value = 0
RECOMMENDITEMINFO_FINISHTIMES_FIELD.type = 13
RECOMMENDITEMINFO_FINISHTIMES_FIELD.cpp_type = 3
RECOMMENDITEMINFO_STATUS_FIELD.name = "status"
RECOMMENDITEMINFO_STATUS_FIELD.full_name = ".Cmd.RecommendItemInfo.status"
RECOMMENDITEMINFO_STATUS_FIELD.number = 3
RECOMMENDITEMINFO_STATUS_FIELD.index = 2
RECOMMENDITEMINFO_STATUS_FIELD.label = 1
RECOMMENDITEMINFO_STATUS_FIELD.has_default_value = true
RECOMMENDITEMINFO_STATUS_FIELD.default_value = 0
RECOMMENDITEMINFO_STATUS_FIELD.enum_type = ERECOMMENDSTATUS
RECOMMENDITEMINFO_STATUS_FIELD.type = 14
RECOMMENDITEMINFO_STATUS_FIELD.cpp_type = 8
RECOMMENDITEMINFO_REALOPEN_FIELD.name = "realopen"
RECOMMENDITEMINFO_REALOPEN_FIELD.full_name = ".Cmd.RecommendItemInfo.realopen"
RECOMMENDITEMINFO_REALOPEN_FIELD.number = 4
RECOMMENDITEMINFO_REALOPEN_FIELD.index = 3
RECOMMENDITEMINFO_REALOPEN_FIELD.label = 1
RECOMMENDITEMINFO_REALOPEN_FIELD.has_default_value = true
RECOMMENDITEMINFO_REALOPEN_FIELD.default_value = false
RECOMMENDITEMINFO_REALOPEN_FIELD.type = 8
RECOMMENDITEMINFO_REALOPEN_FIELD.cpp_type = 7
RECOMMENDITEMINFO.name = "RecommendItemInfo"
RECOMMENDITEMINFO.full_name = ".Cmd.RecommendItemInfo"
RECOMMENDITEMINFO.nested_types = {}
RECOMMENDITEMINFO.enum_types = {}
RECOMMENDITEMINFO.fields = {
  RECOMMENDITEMINFO_DWID_FIELD,
  RECOMMENDITEMINFO_FINISHTIMES_FIELD,
  RECOMMENDITEMINFO_STATUS_FIELD,
  RECOMMENDITEMINFO_REALOPEN_FIELD
}
RECOMMENDITEMINFO.is_extendable = false
RECOMMENDITEMINFO.extensions = {}
RECOMMENDSERVANTUSERCMD_CMD_FIELD.name = "cmd"
RECOMMENDSERVANTUSERCMD_CMD_FIELD.full_name = ".Cmd.RecommendServantUserCmd.cmd"
RECOMMENDSERVANTUSERCMD_CMD_FIELD.number = 1
RECOMMENDSERVANTUSERCMD_CMD_FIELD.index = 0
RECOMMENDSERVANTUSERCMD_CMD_FIELD.label = 1
RECOMMENDSERVANTUSERCMD_CMD_FIELD.has_default_value = true
RECOMMENDSERVANTUSERCMD_CMD_FIELD.default_value = 9
RECOMMENDSERVANTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RECOMMENDSERVANTUSERCMD_CMD_FIELD.type = 14
RECOMMENDSERVANTUSERCMD_CMD_FIELD.cpp_type = 8
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.name = "param"
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.full_name = ".Cmd.RecommendServantUserCmd.param"
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.number = 2
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.index = 1
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.label = 1
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.has_default_value = true
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.default_value = 125
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.type = 14
RECOMMENDSERVANTUSERCMD_PARAM_FIELD.cpp_type = 8
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.name = "items"
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.full_name = ".Cmd.RecommendServantUserCmd.items"
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.number = 3
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.index = 2
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.label = 3
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.has_default_value = false
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.default_value = {}
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.message_type = RECOMMENDITEMINFO
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.type = 11
RECOMMENDSERVANTUSERCMD_ITEMS_FIELD.cpp_type = 10
RECOMMENDSERVANTUSERCMD.name = "RecommendServantUserCmd"
RECOMMENDSERVANTUSERCMD.full_name = ".Cmd.RecommendServantUserCmd"
RECOMMENDSERVANTUSERCMD.nested_types = {}
RECOMMENDSERVANTUSERCMD.enum_types = {}
RECOMMENDSERVANTUSERCMD.fields = {
  RECOMMENDSERVANTUSERCMD_CMD_FIELD,
  RECOMMENDSERVANTUSERCMD_PARAM_FIELD,
  RECOMMENDSERVANTUSERCMD_ITEMS_FIELD
}
RECOMMENDSERVANTUSERCMD.is_extendable = false
RECOMMENDSERVANTUSERCMD.extensions = {}
RECEIVESERVANTUSERCMD_CMD_FIELD.name = "cmd"
RECEIVESERVANTUSERCMD_CMD_FIELD.full_name = ".Cmd.ReceiveServantUserCmd.cmd"
RECEIVESERVANTUSERCMD_CMD_FIELD.number = 1
RECEIVESERVANTUSERCMD_CMD_FIELD.index = 0
RECEIVESERVANTUSERCMD_CMD_FIELD.label = 1
RECEIVESERVANTUSERCMD_CMD_FIELD.has_default_value = true
RECEIVESERVANTUSERCMD_CMD_FIELD.default_value = 9
RECEIVESERVANTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RECEIVESERVANTUSERCMD_CMD_FIELD.type = 14
RECEIVESERVANTUSERCMD_CMD_FIELD.cpp_type = 8
RECEIVESERVANTUSERCMD_PARAM_FIELD.name = "param"
RECEIVESERVANTUSERCMD_PARAM_FIELD.full_name = ".Cmd.ReceiveServantUserCmd.param"
RECEIVESERVANTUSERCMD_PARAM_FIELD.number = 2
RECEIVESERVANTUSERCMD_PARAM_FIELD.index = 1
RECEIVESERVANTUSERCMD_PARAM_FIELD.label = 1
RECEIVESERVANTUSERCMD_PARAM_FIELD.has_default_value = true
RECEIVESERVANTUSERCMD_PARAM_FIELD.default_value = 126
RECEIVESERVANTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
RECEIVESERVANTUSERCMD_PARAM_FIELD.type = 14
RECEIVESERVANTUSERCMD_PARAM_FIELD.cpp_type = 8
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.name = "favorability"
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.full_name = ".Cmd.ReceiveServantUserCmd.favorability"
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.number = 3
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.index = 2
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.label = 1
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.has_default_value = true
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.default_value = false
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.type = 8
RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD.cpp_type = 7
RECEIVESERVANTUSERCMD_DWID_FIELD.name = "dwid"
RECEIVESERVANTUSERCMD_DWID_FIELD.full_name = ".Cmd.ReceiveServantUserCmd.dwid"
RECEIVESERVANTUSERCMD_DWID_FIELD.number = 4
RECEIVESERVANTUSERCMD_DWID_FIELD.index = 3
RECEIVESERVANTUSERCMD_DWID_FIELD.label = 1
RECEIVESERVANTUSERCMD_DWID_FIELD.has_default_value = false
RECEIVESERVANTUSERCMD_DWID_FIELD.default_value = 0
RECEIVESERVANTUSERCMD_DWID_FIELD.type = 13
RECEIVESERVANTUSERCMD_DWID_FIELD.cpp_type = 3
RECEIVESERVANTUSERCMD.name = "ReceiveServantUserCmd"
RECEIVESERVANTUSERCMD.full_name = ".Cmd.ReceiveServantUserCmd"
RECEIVESERVANTUSERCMD.nested_types = {}
RECEIVESERVANTUSERCMD.enum_types = {}
RECEIVESERVANTUSERCMD.fields = {
  RECEIVESERVANTUSERCMD_CMD_FIELD,
  RECEIVESERVANTUSERCMD_PARAM_FIELD,
  RECEIVESERVANTUSERCMD_FAVORABILITY_FIELD,
  RECEIVESERVANTUSERCMD_DWID_FIELD
}
RECEIVESERVANTUSERCMD.is_extendable = false
RECEIVESERVANTUSERCMD.extensions = {}
FAVORABILITYSTATUS_FAVORABILITY_FIELD.name = "favorability"
FAVORABILITYSTATUS_FAVORABILITY_FIELD.full_name = ".Cmd.FavorabilityStatus.favorability"
FAVORABILITYSTATUS_FAVORABILITY_FIELD.number = 1
FAVORABILITYSTATUS_FAVORABILITY_FIELD.index = 0
FAVORABILITYSTATUS_FAVORABILITY_FIELD.label = 1
FAVORABILITYSTATUS_FAVORABILITY_FIELD.has_default_value = true
FAVORABILITYSTATUS_FAVORABILITY_FIELD.default_value = 0
FAVORABILITYSTATUS_FAVORABILITY_FIELD.type = 13
FAVORABILITYSTATUS_FAVORABILITY_FIELD.cpp_type = 3
FAVORABILITYSTATUS_STATUS_FIELD.name = "status"
FAVORABILITYSTATUS_STATUS_FIELD.full_name = ".Cmd.FavorabilityStatus.status"
FAVORABILITYSTATUS_STATUS_FIELD.number = 2
FAVORABILITYSTATUS_STATUS_FIELD.index = 1
FAVORABILITYSTATUS_STATUS_FIELD.label = 1
FAVORABILITYSTATUS_STATUS_FIELD.has_default_value = true
FAVORABILITYSTATUS_STATUS_FIELD.default_value = 0
FAVORABILITYSTATUS_STATUS_FIELD.type = 13
FAVORABILITYSTATUS_STATUS_FIELD.cpp_type = 3
FAVORABILITYSTATUS.name = "FavorabilityStatus"
FAVORABILITYSTATUS.full_name = ".Cmd.FavorabilityStatus"
FAVORABILITYSTATUS.nested_types = {}
FAVORABILITYSTATUS.enum_types = {}
FAVORABILITYSTATUS.fields = {
  FAVORABILITYSTATUS_FAVORABILITY_FIELD,
  FAVORABILITYSTATUS_STATUS_FIELD
}
FAVORABILITYSTATUS.is_extendable = false
FAVORABILITYSTATUS.extensions = {}
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.name = "cmd"
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.full_name = ".Cmd.ServantRewardStatusUserCmd.cmd"
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.number = 1
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.index = 0
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.label = 1
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.has_default_value = true
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.default_value = 9
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.type = 14
SERVANTREWARDSTATUSUSERCMD_CMD_FIELD.cpp_type = 8
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.name = "param"
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.full_name = ".Cmd.ServantRewardStatusUserCmd.param"
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.number = 2
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.index = 1
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.label = 1
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.has_default_value = true
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.default_value = 127
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.type = 14
SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD.cpp_type = 8
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.name = "items"
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.full_name = ".Cmd.ServantRewardStatusUserCmd.items"
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.number = 3
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.index = 2
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.label = 3
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.has_default_value = false
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.default_value = {}
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.message_type = FAVORABILITYSTATUS
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.type = 11
SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD.cpp_type = 10
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.name = "stayfavo"
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.full_name = ".Cmd.ServantRewardStatusUserCmd.stayfavo"
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.number = 4
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.index = 3
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.label = 1
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.has_default_value = true
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.default_value = 0
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.type = 13
SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD.cpp_type = 3
SERVANTREWARDSTATUSUSERCMD.name = "ServantRewardStatusUserCmd"
SERVANTREWARDSTATUSUSERCMD.full_name = ".Cmd.ServantRewardStatusUserCmd"
SERVANTREWARDSTATUSUSERCMD.nested_types = {}
SERVANTREWARDSTATUSUSERCMD.enum_types = {}
SERVANTREWARDSTATUSUSERCMD.fields = {
  SERVANTREWARDSTATUSUSERCMD_CMD_FIELD,
  SERVANTREWARDSTATUSUSERCMD_PARAM_FIELD,
  SERVANTREWARDSTATUSUSERCMD_ITEMS_FIELD,
  SERVANTREWARDSTATUSUSERCMD_STAYFAVO_FIELD
}
SERVANTREWARDSTATUSUSERCMD.is_extendable = false
SERVANTREWARDSTATUSUSERCMD.extensions = {}
PROFESSIONINFO_BRANCH_FIELD.name = "branch"
PROFESSIONINFO_BRANCH_FIELD.full_name = ".Cmd.ProfessionInfo.branch"
PROFESSIONINFO_BRANCH_FIELD.number = 1
PROFESSIONINFO_BRANCH_FIELD.index = 0
PROFESSIONINFO_BRANCH_FIELD.label = 1
PROFESSIONINFO_BRANCH_FIELD.has_default_value = false
PROFESSIONINFO_BRANCH_FIELD.default_value = 0
PROFESSIONINFO_BRANCH_FIELD.type = 13
PROFESSIONINFO_BRANCH_FIELD.cpp_type = 3
PROFESSIONINFO_PROFESSION_FIELD.name = "profession"
PROFESSIONINFO_PROFESSION_FIELD.full_name = ".Cmd.ProfessionInfo.profession"
PROFESSIONINFO_PROFESSION_FIELD.number = 2
PROFESSIONINFO_PROFESSION_FIELD.index = 1
PROFESSIONINFO_PROFESSION_FIELD.label = 1
PROFESSIONINFO_PROFESSION_FIELD.has_default_value = false
PROFESSIONINFO_PROFESSION_FIELD.default_value = 0
PROFESSIONINFO_PROFESSION_FIELD.type = 13
PROFESSIONINFO_PROFESSION_FIELD.cpp_type = 3
PROFESSIONINFO_JOBLV_FIELD.name = "joblv"
PROFESSIONINFO_JOBLV_FIELD.full_name = ".Cmd.ProfessionInfo.joblv"
PROFESSIONINFO_JOBLV_FIELD.number = 3
PROFESSIONINFO_JOBLV_FIELD.index = 2
PROFESSIONINFO_JOBLV_FIELD.label = 1
PROFESSIONINFO_JOBLV_FIELD.has_default_value = false
PROFESSIONINFO_JOBLV_FIELD.default_value = 0
PROFESSIONINFO_JOBLV_FIELD.type = 13
PROFESSIONINFO_JOBLV_FIELD.cpp_type = 3
PROFESSIONINFO_ISCURRENT_FIELD.name = "iscurrent"
PROFESSIONINFO_ISCURRENT_FIELD.full_name = ".Cmd.ProfessionInfo.iscurrent"
PROFESSIONINFO_ISCURRENT_FIELD.number = 4
PROFESSIONINFO_ISCURRENT_FIELD.index = 3
PROFESSIONINFO_ISCURRENT_FIELD.label = 1
PROFESSIONINFO_ISCURRENT_FIELD.has_default_value = true
PROFESSIONINFO_ISCURRENT_FIELD.default_value = false
PROFESSIONINFO_ISCURRENT_FIELD.type = 8
PROFESSIONINFO_ISCURRENT_FIELD.cpp_type = 7
PROFESSIONINFO_ISBUY_FIELD.name = "isbuy"
PROFESSIONINFO_ISBUY_FIELD.full_name = ".Cmd.ProfessionInfo.isbuy"
PROFESSIONINFO_ISBUY_FIELD.number = 5
PROFESSIONINFO_ISBUY_FIELD.index = 4
PROFESSIONINFO_ISBUY_FIELD.label = 1
PROFESSIONINFO_ISBUY_FIELD.has_default_value = true
PROFESSIONINFO_ISBUY_FIELD.default_value = false
PROFESSIONINFO_ISBUY_FIELD.type = 8
PROFESSIONINFO_ISBUY_FIELD.cpp_type = 7
PROFESSIONINFO.name = "ProfessionInfo"
PROFESSIONINFO.full_name = ".Cmd.ProfessionInfo"
PROFESSIONINFO.nested_types = {}
PROFESSIONINFO.enum_types = {}
PROFESSIONINFO.fields = {
  PROFESSIONINFO_BRANCH_FIELD,
  PROFESSIONINFO_PROFESSION_FIELD,
  PROFESSIONINFO_JOBLV_FIELD,
  PROFESSIONINFO_ISCURRENT_FIELD,
  PROFESSIONINFO_ISBUY_FIELD
}
PROFESSIONINFO.is_extendable = false
PROFESSIONINFO.extensions = {}
PROFESSIONQUERYUSERCMD_CMD_FIELD.name = "cmd"
PROFESSIONQUERYUSERCMD_CMD_FIELD.full_name = ".Cmd.ProfessionQueryUserCmd.cmd"
PROFESSIONQUERYUSERCMD_CMD_FIELD.number = 1
PROFESSIONQUERYUSERCMD_CMD_FIELD.index = 0
PROFESSIONQUERYUSERCMD_CMD_FIELD.label = 1
PROFESSIONQUERYUSERCMD_CMD_FIELD.has_default_value = true
PROFESSIONQUERYUSERCMD_CMD_FIELD.default_value = 9
PROFESSIONQUERYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PROFESSIONQUERYUSERCMD_CMD_FIELD.type = 14
PROFESSIONQUERYUSERCMD_CMD_FIELD.cpp_type = 8
PROFESSIONQUERYUSERCMD_PARAM_FIELD.name = "param"
PROFESSIONQUERYUSERCMD_PARAM_FIELD.full_name = ".Cmd.ProfessionQueryUserCmd.param"
PROFESSIONQUERYUSERCMD_PARAM_FIELD.number = 2
PROFESSIONQUERYUSERCMD_PARAM_FIELD.index = 1
PROFESSIONQUERYUSERCMD_PARAM_FIELD.label = 1
PROFESSIONQUERYUSERCMD_PARAM_FIELD.has_default_value = true
PROFESSIONQUERYUSERCMD_PARAM_FIELD.default_value = 131
PROFESSIONQUERYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
PROFESSIONQUERYUSERCMD_PARAM_FIELD.type = 14
PROFESSIONQUERYUSERCMD_PARAM_FIELD.cpp_type = 8
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.name = "items"
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.full_name = ".Cmd.ProfessionQueryUserCmd.items"
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.number = 3
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.index = 2
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.label = 3
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.has_default_value = false
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.default_value = {}
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.message_type = PROFESSIONINFO
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.type = 11
PROFESSIONQUERYUSERCMD_ITEMS_FIELD.cpp_type = 10
PROFESSIONQUERYUSERCMD.name = "ProfessionQueryUserCmd"
PROFESSIONQUERYUSERCMD.full_name = ".Cmd.ProfessionQueryUserCmd"
PROFESSIONQUERYUSERCMD.nested_types = {}
PROFESSIONQUERYUSERCMD.enum_types = {}
PROFESSIONQUERYUSERCMD.fields = {
  PROFESSIONQUERYUSERCMD_CMD_FIELD,
  PROFESSIONQUERYUSERCMD_PARAM_FIELD,
  PROFESSIONQUERYUSERCMD_ITEMS_FIELD
}
PROFESSIONQUERYUSERCMD.is_extendable = false
PROFESSIONQUERYUSERCMD.extensions = {}
PROFESSIONBUYUSERCMD_CMD_FIELD.name = "cmd"
PROFESSIONBUYUSERCMD_CMD_FIELD.full_name = ".Cmd.ProfessionBuyUserCmd.cmd"
PROFESSIONBUYUSERCMD_CMD_FIELD.number = 1
PROFESSIONBUYUSERCMD_CMD_FIELD.index = 0
PROFESSIONBUYUSERCMD_CMD_FIELD.label = 1
PROFESSIONBUYUSERCMD_CMD_FIELD.has_default_value = true
PROFESSIONBUYUSERCMD_CMD_FIELD.default_value = 9
PROFESSIONBUYUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PROFESSIONBUYUSERCMD_CMD_FIELD.type = 14
PROFESSIONBUYUSERCMD_CMD_FIELD.cpp_type = 8
PROFESSIONBUYUSERCMD_PARAM_FIELD.name = "param"
PROFESSIONBUYUSERCMD_PARAM_FIELD.full_name = ".Cmd.ProfessionBuyUserCmd.param"
PROFESSIONBUYUSERCMD_PARAM_FIELD.number = 2
PROFESSIONBUYUSERCMD_PARAM_FIELD.index = 1
PROFESSIONBUYUSERCMD_PARAM_FIELD.label = 1
PROFESSIONBUYUSERCMD_PARAM_FIELD.has_default_value = true
PROFESSIONBUYUSERCMD_PARAM_FIELD.default_value = 132
PROFESSIONBUYUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
PROFESSIONBUYUSERCMD_PARAM_FIELD.type = 14
PROFESSIONBUYUSERCMD_PARAM_FIELD.cpp_type = 8
PROFESSIONBUYUSERCMD_BRANCH_FIELD.name = "branch"
PROFESSIONBUYUSERCMD_BRANCH_FIELD.full_name = ".Cmd.ProfessionBuyUserCmd.branch"
PROFESSIONBUYUSERCMD_BRANCH_FIELD.number = 3
PROFESSIONBUYUSERCMD_BRANCH_FIELD.index = 2
PROFESSIONBUYUSERCMD_BRANCH_FIELD.label = 1
PROFESSIONBUYUSERCMD_BRANCH_FIELD.has_default_value = false
PROFESSIONBUYUSERCMD_BRANCH_FIELD.default_value = 0
PROFESSIONBUYUSERCMD_BRANCH_FIELD.type = 13
PROFESSIONBUYUSERCMD_BRANCH_FIELD.cpp_type = 3
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.name = "success"
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.full_name = ".Cmd.ProfessionBuyUserCmd.success"
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.number = 4
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.index = 3
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.label = 1
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.has_default_value = true
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.default_value = true
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.type = 8
PROFESSIONBUYUSERCMD_SUCCESS_FIELD.cpp_type = 7
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.name = "onlymoney"
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.full_name = ".Cmd.ProfessionBuyUserCmd.onlymoney"
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.number = 5
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.index = 4
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.label = 1
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.has_default_value = true
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.default_value = false
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.type = 8
PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD.cpp_type = 7
PROFESSIONBUYUSERCMD.name = "ProfessionBuyUserCmd"
PROFESSIONBUYUSERCMD.full_name = ".Cmd.ProfessionBuyUserCmd"
PROFESSIONBUYUSERCMD.nested_types = {}
PROFESSIONBUYUSERCMD.enum_types = {}
PROFESSIONBUYUSERCMD.fields = {
  PROFESSIONBUYUSERCMD_CMD_FIELD,
  PROFESSIONBUYUSERCMD_PARAM_FIELD,
  PROFESSIONBUYUSERCMD_BRANCH_FIELD,
  PROFESSIONBUYUSERCMD_SUCCESS_FIELD,
  PROFESSIONBUYUSERCMD_ONLYMONEY_FIELD
}
PROFESSIONBUYUSERCMD.is_extendable = false
PROFESSIONBUYUSERCMD.extensions = {}
PROFESSIONCHANGEUSERCMD_CMD_FIELD.name = "cmd"
PROFESSIONCHANGEUSERCMD_CMD_FIELD.full_name = ".Cmd.ProfessionChangeUserCmd.cmd"
PROFESSIONCHANGEUSERCMD_CMD_FIELD.number = 1
PROFESSIONCHANGEUSERCMD_CMD_FIELD.index = 0
PROFESSIONCHANGEUSERCMD_CMD_FIELD.label = 1
PROFESSIONCHANGEUSERCMD_CMD_FIELD.has_default_value = true
PROFESSIONCHANGEUSERCMD_CMD_FIELD.default_value = 9
PROFESSIONCHANGEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PROFESSIONCHANGEUSERCMD_CMD_FIELD.type = 14
PROFESSIONCHANGEUSERCMD_CMD_FIELD.cpp_type = 8
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.name = "param"
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.full_name = ".Cmd.ProfessionChangeUserCmd.param"
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.number = 2
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.index = 1
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.label = 1
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.has_default_value = true
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.default_value = 133
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.type = 14
PROFESSIONCHANGEUSERCMD_PARAM_FIELD.cpp_type = 8
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.name = "branch"
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.full_name = ".Cmd.ProfessionChangeUserCmd.branch"
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.number = 3
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.index = 2
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.label = 1
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.has_default_value = false
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.default_value = 0
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.type = 13
PROFESSIONCHANGEUSERCMD_BRANCH_FIELD.cpp_type = 3
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.name = "success"
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.full_name = ".Cmd.ProfessionChangeUserCmd.success"
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.number = 4
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.index = 3
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.label = 1
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.has_default_value = true
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.default_value = true
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.type = 8
PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD.cpp_type = 7
PROFESSIONCHANGEUSERCMD.name = "ProfessionChangeUserCmd"
PROFESSIONCHANGEUSERCMD.full_name = ".Cmd.ProfessionChangeUserCmd"
PROFESSIONCHANGEUSERCMD.nested_types = {}
PROFESSIONCHANGEUSERCMD.enum_types = {}
PROFESSIONCHANGEUSERCMD.fields = {
  PROFESSIONCHANGEUSERCMD_CMD_FIELD,
  PROFESSIONCHANGEUSERCMD_PARAM_FIELD,
  PROFESSIONCHANGEUSERCMD_BRANCH_FIELD,
  PROFESSIONCHANGEUSERCMD_SUCCESS_FIELD
}
PROFESSIONCHANGEUSERCMD.is_extendable = false
PROFESSIONCHANGEUSERCMD.extensions = {}
ASTROLABEPROFESSIONDATA_STARS_FIELD.name = "stars"
ASTROLABEPROFESSIONDATA_STARS_FIELD.full_name = ".Cmd.AstrolabeProfessionData.stars"
ASTROLABEPROFESSIONDATA_STARS_FIELD.number = 2
ASTROLABEPROFESSIONDATA_STARS_FIELD.index = 0
ASTROLABEPROFESSIONDATA_STARS_FIELD.label = 3
ASTROLABEPROFESSIONDATA_STARS_FIELD.has_default_value = false
ASTROLABEPROFESSIONDATA_STARS_FIELD.default_value = {}
ASTROLABEPROFESSIONDATA_STARS_FIELD.type = 13
ASTROLABEPROFESSIONDATA_STARS_FIELD.cpp_type = 3
ASTROLABEPROFESSIONDATA.name = "AstrolabeProfessionData"
ASTROLABEPROFESSIONDATA.full_name = ".Cmd.AstrolabeProfessionData"
ASTROLABEPROFESSIONDATA.nested_types = {}
ASTROLABEPROFESSIONDATA.enum_types = {}
ASTROLABEPROFESSIONDATA.fields = {
  ASTROLABEPROFESSIONDATA_STARS_FIELD
}
ASTROLABEPROFESSIONDATA.is_extendable = false
ASTROLABEPROFESSIONDATA.extensions = {}
ATTRPROFESSIONDATA_ATTRS_FIELD.name = "attrs"
ATTRPROFESSIONDATA_ATTRS_FIELD.full_name = ".Cmd.AttrProfessionData.attrs"
ATTRPROFESSIONDATA_ATTRS_FIELD.number = 1
ATTRPROFESSIONDATA_ATTRS_FIELD.index = 0
ATTRPROFESSIONDATA_ATTRS_FIELD.label = 3
ATTRPROFESSIONDATA_ATTRS_FIELD.has_default_value = false
ATTRPROFESSIONDATA_ATTRS_FIELD.default_value = {}
ATTRPROFESSIONDATA_ATTRS_FIELD.message_type = SceneUser_pb.USERATTR
ATTRPROFESSIONDATA_ATTRS_FIELD.type = 11
ATTRPROFESSIONDATA_ATTRS_FIELD.cpp_type = 10
ATTRPROFESSIONDATA_DATAS_FIELD.name = "datas"
ATTRPROFESSIONDATA_DATAS_FIELD.full_name = ".Cmd.AttrProfessionData.datas"
ATTRPROFESSIONDATA_DATAS_FIELD.number = 2
ATTRPROFESSIONDATA_DATAS_FIELD.index = 1
ATTRPROFESSIONDATA_DATAS_FIELD.label = 3
ATTRPROFESSIONDATA_DATAS_FIELD.has_default_value = false
ATTRPROFESSIONDATA_DATAS_FIELD.default_value = {}
ATTRPROFESSIONDATA_DATAS_FIELD.message_type = SceneUser_pb.USERDATA
ATTRPROFESSIONDATA_DATAS_FIELD.type = 11
ATTRPROFESSIONDATA_DATAS_FIELD.cpp_type = 10
ATTRPROFESSIONDATA.name = "AttrProfessionData"
ATTRPROFESSIONDATA.full_name = ".Cmd.AttrProfessionData"
ATTRPROFESSIONDATA.nested_types = {}
ATTRPROFESSIONDATA.enum_types = {}
ATTRPROFESSIONDATA.fields = {
  ATTRPROFESSIONDATA_ATTRS_FIELD,
  ATTRPROFESSIONDATA_DATAS_FIELD
}
ATTRPROFESSIONDATA.is_extendable = false
ATTRPROFESSIONDATA.extensions = {}
EQUIPINFO_POS_FIELD.name = "pos"
EQUIPINFO_POS_FIELD.full_name = ".Cmd.EquipInfo.pos"
EQUIPINFO_POS_FIELD.number = 1
EQUIPINFO_POS_FIELD.index = 0
EQUIPINFO_POS_FIELD.label = 1
EQUIPINFO_POS_FIELD.has_default_value = false
EQUIPINFO_POS_FIELD.default_value = 0
EQUIPINFO_POS_FIELD.type = 13
EQUIPINFO_POS_FIELD.cpp_type = 3
EQUIPINFO_TYPE_ID_FIELD.name = "type_id"
EQUIPINFO_TYPE_ID_FIELD.full_name = ".Cmd.EquipInfo.type_id"
EQUIPINFO_TYPE_ID_FIELD.number = 2
EQUIPINFO_TYPE_ID_FIELD.index = 1
EQUIPINFO_TYPE_ID_FIELD.label = 1
EQUIPINFO_TYPE_ID_FIELD.has_default_value = false
EQUIPINFO_TYPE_ID_FIELD.default_value = 0
EQUIPINFO_TYPE_ID_FIELD.type = 13
EQUIPINFO_TYPE_ID_FIELD.cpp_type = 3
EQUIPINFO_GUID_FIELD.name = "guid"
EQUIPINFO_GUID_FIELD.full_name = ".Cmd.EquipInfo.guid"
EQUIPINFO_GUID_FIELD.number = 3
EQUIPINFO_GUID_FIELD.index = 2
EQUIPINFO_GUID_FIELD.label = 1
EQUIPINFO_GUID_FIELD.has_default_value = false
EQUIPINFO_GUID_FIELD.default_value = ""
EQUIPINFO_GUID_FIELD.type = 9
EQUIPINFO_GUID_FIELD.cpp_type = 9
EQUIPINFO.name = "EquipInfo"
EQUIPINFO.full_name = ".Cmd.EquipInfo"
EQUIPINFO.nested_types = {}
EQUIPINFO.enum_types = {}
EQUIPINFO.fields = {
  EQUIPINFO_POS_FIELD,
  EQUIPINFO_TYPE_ID_FIELD,
  EQUIPINFO_GUID_FIELD
}
EQUIPINFO.is_extendable = false
EQUIPINFO.extensions = {}
EQUIPPACKDATA_TYPE_FIELD.name = "type"
EQUIPPACKDATA_TYPE_FIELD.full_name = ".Cmd.EquipPackData.type"
EQUIPPACKDATA_TYPE_FIELD.number = 1
EQUIPPACKDATA_TYPE_FIELD.index = 0
EQUIPPACKDATA_TYPE_FIELD.label = 1
EQUIPPACKDATA_TYPE_FIELD.has_default_value = false
EQUIPPACKDATA_TYPE_FIELD.default_value = 0
EQUIPPACKDATA_TYPE_FIELD.type = 13
EQUIPPACKDATA_TYPE_FIELD.cpp_type = 3
EQUIPPACKDATA_DATAS_FIELD.name = "datas"
EQUIPPACKDATA_DATAS_FIELD.full_name = ".Cmd.EquipPackData.datas"
EQUIPPACKDATA_DATAS_FIELD.number = 2
EQUIPPACKDATA_DATAS_FIELD.index = 1
EQUIPPACKDATA_DATAS_FIELD.label = 3
EQUIPPACKDATA_DATAS_FIELD.has_default_value = false
EQUIPPACKDATA_DATAS_FIELD.default_value = {}
EQUIPPACKDATA_DATAS_FIELD.message_type = EQUIPINFO
EQUIPPACKDATA_DATAS_FIELD.type = 11
EQUIPPACKDATA_DATAS_FIELD.cpp_type = 10
EQUIPPACKDATA.name = "EquipPackData"
EQUIPPACKDATA.full_name = ".Cmd.EquipPackData"
EQUIPPACKDATA.nested_types = {}
EQUIPPACKDATA.enum_types = {}
EQUIPPACKDATA.fields = {
  EQUIPPACKDATA_TYPE_FIELD,
  EQUIPPACKDATA_DATAS_FIELD
}
EQUIPPACKDATA.is_extendable = false
EQUIPPACKDATA.extensions = {}
SKILLVALIDPOSDATA_POS_FIELD.name = "pos"
SKILLVALIDPOSDATA_POS_FIELD.full_name = ".Cmd.SkillValidPosData.pos"
SKILLVALIDPOSDATA_POS_FIELD.number = 1
SKILLVALIDPOSDATA_POS_FIELD.index = 0
SKILLVALIDPOSDATA_POS_FIELD.label = 3
SKILLVALIDPOSDATA_POS_FIELD.has_default_value = false
SKILLVALIDPOSDATA_POS_FIELD.default_value = {}
SKILLVALIDPOSDATA_POS_FIELD.type = 13
SKILLVALIDPOSDATA_POS_FIELD.cpp_type = 3
SKILLVALIDPOSDATA_AUTOPOS_FIELD.name = "autopos"
SKILLVALIDPOSDATA_AUTOPOS_FIELD.full_name = ".Cmd.SkillValidPosData.autopos"
SKILLVALIDPOSDATA_AUTOPOS_FIELD.number = 2
SKILLVALIDPOSDATA_AUTOPOS_FIELD.index = 1
SKILLVALIDPOSDATA_AUTOPOS_FIELD.label = 3
SKILLVALIDPOSDATA_AUTOPOS_FIELD.has_default_value = false
SKILLVALIDPOSDATA_AUTOPOS_FIELD.default_value = {}
SKILLVALIDPOSDATA_AUTOPOS_FIELD.type = 13
SKILLVALIDPOSDATA_AUTOPOS_FIELD.cpp_type = 3
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.name = "extendpos"
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.full_name = ".Cmd.SkillValidPosData.extendpos"
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.number = 3
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.index = 2
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.label = 3
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.has_default_value = false
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.default_value = {}
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.type = 13
SKILLVALIDPOSDATA_EXTENDPOS_FIELD.cpp_type = 3
SKILLVALIDPOSDATA.name = "SkillValidPosData"
SKILLVALIDPOSDATA.full_name = ".Cmd.SkillValidPosData"
SKILLVALIDPOSDATA.nested_types = {}
SKILLVALIDPOSDATA.enum_types = {}
SKILLVALIDPOSDATA.fields = {
  SKILLVALIDPOSDATA_POS_FIELD,
  SKILLVALIDPOSDATA_AUTOPOS_FIELD,
  SKILLVALIDPOSDATA_EXTENDPOS_FIELD
}
SKILLVALIDPOSDATA.is_extendable = false
SKILLVALIDPOSDATA.extensions = {}
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.name = "left_point"
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.full_name = ".Cmd.SkillProfessionData.left_point"
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.number = 1
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.index = 0
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.label = 1
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.has_default_value = false
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.default_value = 0
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.type = 13
SKILLPROFESSIONDATA_LEFT_POINT_FIELD.cpp_type = 3
SKILLPROFESSIONDATA_DATAS_FIELD.name = "datas"
SKILLPROFESSIONDATA_DATAS_FIELD.full_name = ".Cmd.SkillProfessionData.datas"
SKILLPROFESSIONDATA_DATAS_FIELD.number = 2
SKILLPROFESSIONDATA_DATAS_FIELD.index = 1
SKILLPROFESSIONDATA_DATAS_FIELD.label = 3
SKILLPROFESSIONDATA_DATAS_FIELD.has_default_value = false
SKILLPROFESSIONDATA_DATAS_FIELD.default_value = {}
SKILLPROFESSIONDATA_DATAS_FIELD.message_type = SceneSkill_pb.SKILLDATA
SKILLPROFESSIONDATA_DATAS_FIELD.type = 11
SKILLPROFESSIONDATA_DATAS_FIELD.cpp_type = 10
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.name = "novice_data"
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.full_name = ".Cmd.SkillProfessionData.novice_data"
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.number = 3
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.index = 2
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.label = 1
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.has_default_value = false
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.default_value = nil
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.message_type = SceneSkill_pb.SKILLDATA
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.type = 11
SKILLPROFESSIONDATA_NOVICE_DATA_FIELD.cpp_type = 10
SKILLPROFESSIONDATA_BEINGS_FIELD.name = "beings"
SKILLPROFESSIONDATA_BEINGS_FIELD.full_name = ".Cmd.SkillProfessionData.beings"
SKILLPROFESSIONDATA_BEINGS_FIELD.number = 4
SKILLPROFESSIONDATA_BEINGS_FIELD.index = 3
SKILLPROFESSIONDATA_BEINGS_FIELD.label = 3
SKILLPROFESSIONDATA_BEINGS_FIELD.has_default_value = false
SKILLPROFESSIONDATA_BEINGS_FIELD.default_value = {}
SKILLPROFESSIONDATA_BEINGS_FIELD.message_type = SceneBeing_pb.BEINGSKILLDATA
SKILLPROFESSIONDATA_BEINGS_FIELD.type = 11
SKILLPROFESSIONDATA_BEINGS_FIELD.cpp_type = 10
SKILLPROFESSIONDATA_CURBEINGID_FIELD.name = "curbeingid"
SKILLPROFESSIONDATA_CURBEINGID_FIELD.full_name = ".Cmd.SkillProfessionData.curbeingid"
SKILLPROFESSIONDATA_CURBEINGID_FIELD.number = 5
SKILLPROFESSIONDATA_CURBEINGID_FIELD.index = 4
SKILLPROFESSIONDATA_CURBEINGID_FIELD.label = 1
SKILLPROFESSIONDATA_CURBEINGID_FIELD.has_default_value = false
SKILLPROFESSIONDATA_CURBEINGID_FIELD.default_value = 0
SKILLPROFESSIONDATA_CURBEINGID_FIELD.type = 13
SKILLPROFESSIONDATA_CURBEINGID_FIELD.cpp_type = 3
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.name = "beinginfos"
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.full_name = ".Cmd.SkillProfessionData.beinginfos"
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.number = 6
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.index = 5
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.label = 3
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.has_default_value = false
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.default_value = {}
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.message_type = SceneBeing_pb.BEINGINFO
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.type = 11
SKILLPROFESSIONDATA_BEINGINFOS_FIELD.cpp_type = 10
SKILLPROFESSIONDATA_SKILLPOS_FIELD.name = "skillpos"
SKILLPROFESSIONDATA_SKILLPOS_FIELD.full_name = ".Cmd.SkillProfessionData.skillpos"
SKILLPROFESSIONDATA_SKILLPOS_FIELD.number = 7
SKILLPROFESSIONDATA_SKILLPOS_FIELD.index = 6
SKILLPROFESSIONDATA_SKILLPOS_FIELD.label = 1
SKILLPROFESSIONDATA_SKILLPOS_FIELD.has_default_value = false
SKILLPROFESSIONDATA_SKILLPOS_FIELD.default_value = nil
SKILLPROFESSIONDATA_SKILLPOS_FIELD.message_type = SKILLVALIDPOSDATA
SKILLPROFESSIONDATA_SKILLPOS_FIELD.type = 11
SKILLPROFESSIONDATA_SKILLPOS_FIELD.cpp_type = 10
SKILLPROFESSIONDATA_SHORTCUT_FIELD.name = "shortcut"
SKILLPROFESSIONDATA_SHORTCUT_FIELD.full_name = ".Cmd.SkillProfessionData.shortcut"
SKILLPROFESSIONDATA_SHORTCUT_FIELD.number = 8
SKILLPROFESSIONDATA_SHORTCUT_FIELD.index = 7
SKILLPROFESSIONDATA_SHORTCUT_FIELD.label = 1
SKILLPROFESSIONDATA_SHORTCUT_FIELD.has_default_value = false
SKILLPROFESSIONDATA_SHORTCUT_FIELD.default_value = nil
SKILLPROFESSIONDATA_SHORTCUT_FIELD.message_type = SceneSkill_pb.SKILLVALIDPOS
SKILLPROFESSIONDATA_SHORTCUT_FIELD.type = 11
SKILLPROFESSIONDATA_SHORTCUT_FIELD.cpp_type = 10
SKILLPROFESSIONDATA.name = "SkillProfessionData"
SKILLPROFESSIONDATA.full_name = ".Cmd.SkillProfessionData"
SKILLPROFESSIONDATA.nested_types = {}
SKILLPROFESSIONDATA.enum_types = {}
SKILLPROFESSIONDATA.fields = {
  SKILLPROFESSIONDATA_LEFT_POINT_FIELD,
  SKILLPROFESSIONDATA_DATAS_FIELD,
  SKILLPROFESSIONDATA_NOVICE_DATA_FIELD,
  SKILLPROFESSIONDATA_BEINGS_FIELD,
  SKILLPROFESSIONDATA_CURBEINGID_FIELD,
  SKILLPROFESSIONDATA_BEINGINFOS_FIELD,
  SKILLPROFESSIONDATA_SKILLPOS_FIELD,
  SKILLPROFESSIONDATA_SHORTCUT_FIELD
}
SKILLPROFESSIONDATA.is_extendable = false
SKILLPROFESSIONDATA.extensions = {}
PROFESSIONUSERINFO_ID_FIELD.name = "id"
PROFESSIONUSERINFO_ID_FIELD.full_name = ".Cmd.ProfessionUserInfo.id"
PROFESSIONUSERINFO_ID_FIELD.number = 1
PROFESSIONUSERINFO_ID_FIELD.index = 0
PROFESSIONUSERINFO_ID_FIELD.label = 1
PROFESSIONUSERINFO_ID_FIELD.has_default_value = false
PROFESSIONUSERINFO_ID_FIELD.default_value = 0
PROFESSIONUSERINFO_ID_FIELD.type = 13
PROFESSIONUSERINFO_ID_FIELD.cpp_type = 3
PROFESSIONUSERINFO_PROFESSION_FIELD.name = "profession"
PROFESSIONUSERINFO_PROFESSION_FIELD.full_name = ".Cmd.ProfessionUserInfo.profession"
PROFESSIONUSERINFO_PROFESSION_FIELD.number = 2
PROFESSIONUSERINFO_PROFESSION_FIELD.index = 1
PROFESSIONUSERINFO_PROFESSION_FIELD.label = 1
PROFESSIONUSERINFO_PROFESSION_FIELD.has_default_value = false
PROFESSIONUSERINFO_PROFESSION_FIELD.default_value = 0
PROFESSIONUSERINFO_PROFESSION_FIELD.type = 13
PROFESSIONUSERINFO_PROFESSION_FIELD.cpp_type = 3
PROFESSIONUSERINFO_JOBLV_FIELD.name = "joblv"
PROFESSIONUSERINFO_JOBLV_FIELD.full_name = ".Cmd.ProfessionUserInfo.joblv"
PROFESSIONUSERINFO_JOBLV_FIELD.number = 3
PROFESSIONUSERINFO_JOBLV_FIELD.index = 2
PROFESSIONUSERINFO_JOBLV_FIELD.label = 1
PROFESSIONUSERINFO_JOBLV_FIELD.has_default_value = true
PROFESSIONUSERINFO_JOBLV_FIELD.default_value = 0
PROFESSIONUSERINFO_JOBLV_FIELD.type = 13
PROFESSIONUSERINFO_JOBLV_FIELD.cpp_type = 3
PROFESSIONUSERINFO_JOBEXP_FIELD.name = "jobexp"
PROFESSIONUSERINFO_JOBEXP_FIELD.full_name = ".Cmd.ProfessionUserInfo.jobexp"
PROFESSIONUSERINFO_JOBEXP_FIELD.number = 4
PROFESSIONUSERINFO_JOBEXP_FIELD.index = 3
PROFESSIONUSERINFO_JOBEXP_FIELD.label = 1
PROFESSIONUSERINFO_JOBEXP_FIELD.has_default_value = true
PROFESSIONUSERINFO_JOBEXP_FIELD.default_value = 0
PROFESSIONUSERINFO_JOBEXP_FIELD.type = 13
PROFESSIONUSERINFO_JOBEXP_FIELD.cpp_type = 3
PROFESSIONUSERINFO_TYPE_FIELD.name = "type"
PROFESSIONUSERINFO_TYPE_FIELD.full_name = ".Cmd.ProfessionUserInfo.type"
PROFESSIONUSERINFO_TYPE_FIELD.number = 5
PROFESSIONUSERINFO_TYPE_FIELD.index = 4
PROFESSIONUSERINFO_TYPE_FIELD.label = 1
PROFESSIONUSERINFO_TYPE_FIELD.has_default_value = true
PROFESSIONUSERINFO_TYPE_FIELD.default_value = 1
PROFESSIONUSERINFO_TYPE_FIELD.enum_type = EPROFRESSIONDATATYPE
PROFESSIONUSERINFO_TYPE_FIELD.type = 14
PROFESSIONUSERINFO_TYPE_FIELD.cpp_type = 8
PROFESSIONUSERINFO_RECORDNAME_FIELD.name = "recordname"
PROFESSIONUSERINFO_RECORDNAME_FIELD.full_name = ".Cmd.ProfessionUserInfo.recordname"
PROFESSIONUSERINFO_RECORDNAME_FIELD.number = 6
PROFESSIONUSERINFO_RECORDNAME_FIELD.index = 5
PROFESSIONUSERINFO_RECORDNAME_FIELD.label = 1
PROFESSIONUSERINFO_RECORDNAME_FIELD.has_default_value = false
PROFESSIONUSERINFO_RECORDNAME_FIELD.default_value = ""
PROFESSIONUSERINFO_RECORDNAME_FIELD.type = 9
PROFESSIONUSERINFO_RECORDNAME_FIELD.cpp_type = 9
PROFESSIONUSERINFO_RECORDTIME_FIELD.name = "recordtime"
PROFESSIONUSERINFO_RECORDTIME_FIELD.full_name = ".Cmd.ProfessionUserInfo.recordtime"
PROFESSIONUSERINFO_RECORDTIME_FIELD.number = 7
PROFESSIONUSERINFO_RECORDTIME_FIELD.index = 6
PROFESSIONUSERINFO_RECORDTIME_FIELD.label = 1
PROFESSIONUSERINFO_RECORDTIME_FIELD.has_default_value = false
PROFESSIONUSERINFO_RECORDTIME_FIELD.default_value = 0
PROFESSIONUSERINFO_RECORDTIME_FIELD.type = 13
PROFESSIONUSERINFO_RECORDTIME_FIELD.cpp_type = 3
PROFESSIONUSERINFO_CHARID_FIELD.name = "charid"
PROFESSIONUSERINFO_CHARID_FIELD.full_name = ".Cmd.ProfessionUserInfo.charid"
PROFESSIONUSERINFO_CHARID_FIELD.number = 8
PROFESSIONUSERINFO_CHARID_FIELD.index = 7
PROFESSIONUSERINFO_CHARID_FIELD.label = 1
PROFESSIONUSERINFO_CHARID_FIELD.has_default_value = false
PROFESSIONUSERINFO_CHARID_FIELD.default_value = 0
PROFESSIONUSERINFO_CHARID_FIELD.type = 4
PROFESSIONUSERINFO_CHARID_FIELD.cpp_type = 4
PROFESSIONUSERINFO_CHARNAME_FIELD.name = "charname"
PROFESSIONUSERINFO_CHARNAME_FIELD.full_name = ".Cmd.ProfessionUserInfo.charname"
PROFESSIONUSERINFO_CHARNAME_FIELD.number = 9
PROFESSIONUSERINFO_CHARNAME_FIELD.index = 8
PROFESSIONUSERINFO_CHARNAME_FIELD.label = 1
PROFESSIONUSERINFO_CHARNAME_FIELD.has_default_value = false
PROFESSIONUSERINFO_CHARNAME_FIELD.default_value = ""
PROFESSIONUSERINFO_CHARNAME_FIELD.type = 9
PROFESSIONUSERINFO_CHARNAME_FIELD.cpp_type = 9
PROFESSIONUSERINFO_ATTR_DATA_FIELD.name = "attr_data"
PROFESSIONUSERINFO_ATTR_DATA_FIELD.full_name = ".Cmd.ProfessionUserInfo.attr_data"
PROFESSIONUSERINFO_ATTR_DATA_FIELD.number = 10
PROFESSIONUSERINFO_ATTR_DATA_FIELD.index = 9
PROFESSIONUSERINFO_ATTR_DATA_FIELD.label = 1
PROFESSIONUSERINFO_ATTR_DATA_FIELD.has_default_value = false
PROFESSIONUSERINFO_ATTR_DATA_FIELD.default_value = nil
PROFESSIONUSERINFO_ATTR_DATA_FIELD.message_type = ATTRPROFESSIONDATA
PROFESSIONUSERINFO_ATTR_DATA_FIELD.type = 11
PROFESSIONUSERINFO_ATTR_DATA_FIELD.cpp_type = 10
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.name = "equip_data"
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.full_name = ".Cmd.ProfessionUserInfo.equip_data"
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.number = 11
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.index = 10
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.label = 3
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.has_default_value = false
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.default_value = {}
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.message_type = EQUIPPACKDATA
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.type = 11
PROFESSIONUSERINFO_EQUIP_DATA_FIELD.cpp_type = 10
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.name = "astrolabe_data"
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.full_name = ".Cmd.ProfessionUserInfo.astrolabe_data"
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.number = 12
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.index = 11
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.label = 1
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.has_default_value = false
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.default_value = nil
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.message_type = ASTROLABEPROFESSIONDATA
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.type = 11
PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD.cpp_type = 10
PROFESSIONUSERINFO_SKILL_DATA_FIELD.name = "skill_data"
PROFESSIONUSERINFO_SKILL_DATA_FIELD.full_name = ".Cmd.ProfessionUserInfo.skill_data"
PROFESSIONUSERINFO_SKILL_DATA_FIELD.number = 13
PROFESSIONUSERINFO_SKILL_DATA_FIELD.index = 12
PROFESSIONUSERINFO_SKILL_DATA_FIELD.label = 1
PROFESSIONUSERINFO_SKILL_DATA_FIELD.has_default_value = false
PROFESSIONUSERINFO_SKILL_DATA_FIELD.default_value = nil
PROFESSIONUSERINFO_SKILL_DATA_FIELD.message_type = SKILLPROFESSIONDATA
PROFESSIONUSERINFO_SKILL_DATA_FIELD.type = 11
PROFESSIONUSERINFO_SKILL_DATA_FIELD.cpp_type = 10
PROFESSIONUSERINFO_ISFIRST_FIELD.name = "isfirst"
PROFESSIONUSERINFO_ISFIRST_FIELD.full_name = ".Cmd.ProfessionUserInfo.isfirst"
PROFESSIONUSERINFO_ISFIRST_FIELD.number = 14
PROFESSIONUSERINFO_ISFIRST_FIELD.index = 13
PROFESSIONUSERINFO_ISFIRST_FIELD.label = 1
PROFESSIONUSERINFO_ISFIRST_FIELD.has_default_value = true
PROFESSIONUSERINFO_ISFIRST_FIELD.default_value = true
PROFESSIONUSERINFO_ISFIRST_FIELD.type = 8
PROFESSIONUSERINFO_ISFIRST_FIELD.cpp_type = 7
PROFESSIONUSERINFO_ISBUY_FIELD.name = "isbuy"
PROFESSIONUSERINFO_ISBUY_FIELD.full_name = ".Cmd.ProfessionUserInfo.isbuy"
PROFESSIONUSERINFO_ISBUY_FIELD.number = 15
PROFESSIONUSERINFO_ISBUY_FIELD.index = 14
PROFESSIONUSERINFO_ISBUY_FIELD.label = 1
PROFESSIONUSERINFO_ISBUY_FIELD.has_default_value = true
PROFESSIONUSERINFO_ISBUY_FIELD.default_value = false
PROFESSIONUSERINFO_ISBUY_FIELD.type = 8
PROFESSIONUSERINFO_ISBUY_FIELD.cpp_type = 7
PROFESSIONUSERINFO.name = "ProfessionUserInfo"
PROFESSIONUSERINFO.full_name = ".Cmd.ProfessionUserInfo"
PROFESSIONUSERINFO.nested_types = {}
PROFESSIONUSERINFO.enum_types = {}
PROFESSIONUSERINFO.fields = {
  PROFESSIONUSERINFO_ID_FIELD,
  PROFESSIONUSERINFO_PROFESSION_FIELD,
  PROFESSIONUSERINFO_JOBLV_FIELD,
  PROFESSIONUSERINFO_JOBEXP_FIELD,
  PROFESSIONUSERINFO_TYPE_FIELD,
  PROFESSIONUSERINFO_RECORDNAME_FIELD,
  PROFESSIONUSERINFO_RECORDTIME_FIELD,
  PROFESSIONUSERINFO_CHARID_FIELD,
  PROFESSIONUSERINFO_CHARNAME_FIELD,
  PROFESSIONUSERINFO_ATTR_DATA_FIELD,
  PROFESSIONUSERINFO_EQUIP_DATA_FIELD,
  PROFESSIONUSERINFO_ASTROLABE_DATA_FIELD,
  PROFESSIONUSERINFO_SKILL_DATA_FIELD,
  PROFESSIONUSERINFO_ISFIRST_FIELD,
  PROFESSIONUSERINFO_ISBUY_FIELD
}
PROFESSIONUSERINFO.is_extendable = false
PROFESSIONUSERINFO.extensions = {}
SLOTINFO_ID_FIELD.name = "id"
SLOTINFO_ID_FIELD.full_name = ".Cmd.SlotInfo.id"
SLOTINFO_ID_FIELD.number = 1
SLOTINFO_ID_FIELD.index = 0
SLOTINFO_ID_FIELD.label = 1
SLOTINFO_ID_FIELD.has_default_value = false
SLOTINFO_ID_FIELD.default_value = 0
SLOTINFO_ID_FIELD.type = 13
SLOTINFO_ID_FIELD.cpp_type = 3
SLOTINFO_TYPE_FIELD.name = "type"
SLOTINFO_TYPE_FIELD.full_name = ".Cmd.SlotInfo.type"
SLOTINFO_TYPE_FIELD.number = 2
SLOTINFO_TYPE_FIELD.index = 1
SLOTINFO_TYPE_FIELD.label = 1
SLOTINFO_TYPE_FIELD.has_default_value = true
SLOTINFO_TYPE_FIELD.default_value = 1
SLOTINFO_TYPE_FIELD.enum_type = ESLOTTYPE
SLOTINFO_TYPE_FIELD.type = 14
SLOTINFO_TYPE_FIELD.cpp_type = 8
SLOTINFO_ACTIVE_FIELD.name = "active"
SLOTINFO_ACTIVE_FIELD.full_name = ".Cmd.SlotInfo.active"
SLOTINFO_ACTIVE_FIELD.number = 3
SLOTINFO_ACTIVE_FIELD.index = 2
SLOTINFO_ACTIVE_FIELD.label = 1
SLOTINFO_ACTIVE_FIELD.has_default_value = true
SLOTINFO_ACTIVE_FIELD.default_value = false
SLOTINFO_ACTIVE_FIELD.type = 8
SLOTINFO_ACTIVE_FIELD.cpp_type = 7
SLOTINFO_COSTID_FIELD.name = "costid"
SLOTINFO_COSTID_FIELD.full_name = ".Cmd.SlotInfo.costid"
SLOTINFO_COSTID_FIELD.number = 4
SLOTINFO_COSTID_FIELD.index = 3
SLOTINFO_COSTID_FIELD.label = 1
SLOTINFO_COSTID_FIELD.has_default_value = false
SLOTINFO_COSTID_FIELD.default_value = 0
SLOTINFO_COSTID_FIELD.type = 13
SLOTINFO_COSTID_FIELD.cpp_type = 3
SLOTINFO_COSTNUM_FIELD.name = "costnum"
SLOTINFO_COSTNUM_FIELD.full_name = ".Cmd.SlotInfo.costnum"
SLOTINFO_COSTNUM_FIELD.number = 5
SLOTINFO_COSTNUM_FIELD.index = 4
SLOTINFO_COSTNUM_FIELD.label = 1
SLOTINFO_COSTNUM_FIELD.has_default_value = false
SLOTINFO_COSTNUM_FIELD.default_value = 0
SLOTINFO_COSTNUM_FIELD.type = 13
SLOTINFO_COSTNUM_FIELD.cpp_type = 3
SLOTINFO.name = "SlotInfo"
SLOTINFO.full_name = ".Cmd.SlotInfo"
SLOTINFO.nested_types = {}
SLOTINFO.enum_types = {}
SLOTINFO.fields = {
  SLOTINFO_ID_FIELD,
  SLOTINFO_TYPE_FIELD,
  SLOTINFO_ACTIVE_FIELD,
  SLOTINFO_COSTID_FIELD,
  SLOTINFO_COSTNUM_FIELD
}
SLOTINFO.is_extendable = false
SLOTINFO.extensions = {}
USERASTROLMATERIALDATA_CHARID_FIELD.name = "charid"
USERASTROLMATERIALDATA_CHARID_FIELD.full_name = ".Cmd.UserAstrolMaterialData.charid"
USERASTROLMATERIALDATA_CHARID_FIELD.number = 1
USERASTROLMATERIALDATA_CHARID_FIELD.index = 0
USERASTROLMATERIALDATA_CHARID_FIELD.label = 1
USERASTROLMATERIALDATA_CHARID_FIELD.has_default_value = false
USERASTROLMATERIALDATA_CHARID_FIELD.default_value = 0
USERASTROLMATERIALDATA_CHARID_FIELD.type = 4
USERASTROLMATERIALDATA_CHARID_FIELD.cpp_type = 4
USERASTROLMATERIALDATA_MATERIALS_FIELD.name = "materials"
USERASTROLMATERIALDATA_MATERIALS_FIELD.full_name = ".Cmd.UserAstrolMaterialData.materials"
USERASTROLMATERIALDATA_MATERIALS_FIELD.number = 2
USERASTROLMATERIALDATA_MATERIALS_FIELD.index = 1
USERASTROLMATERIALDATA_MATERIALS_FIELD.label = 3
USERASTROLMATERIALDATA_MATERIALS_FIELD.has_default_value = false
USERASTROLMATERIALDATA_MATERIALS_FIELD.default_value = {}
USERASTROLMATERIALDATA_MATERIALS_FIELD.message_type = AstrolabeCmd_pb.ASTROLABECOSTDATA
USERASTROLMATERIALDATA_MATERIALS_FIELD.type = 11
USERASTROLMATERIALDATA_MATERIALS_FIELD.cpp_type = 10
USERASTROLMATERIALDATA.name = "UserAstrolMaterialData"
USERASTROLMATERIALDATA.full_name = ".Cmd.UserAstrolMaterialData"
USERASTROLMATERIALDATA.nested_types = {}
USERASTROLMATERIALDATA.enum_types = {}
USERASTROLMATERIALDATA.fields = {
  USERASTROLMATERIALDATA_CHARID_FIELD,
  USERASTROLMATERIALDATA_MATERIALS_FIELD
}
USERASTROLMATERIALDATA.is_extendable = false
USERASTROLMATERIALDATA.extensions = {}
UPDATERECORDINFOUSERCMD_CMD_FIELD.name = "cmd"
UPDATERECORDINFOUSERCMD_CMD_FIELD.full_name = ".Cmd.UpdateRecordInfoUserCmd.cmd"
UPDATERECORDINFOUSERCMD_CMD_FIELD.number = 1
UPDATERECORDINFOUSERCMD_CMD_FIELD.index = 0
UPDATERECORDINFOUSERCMD_CMD_FIELD.label = 1
UPDATERECORDINFOUSERCMD_CMD_FIELD.has_default_value = true
UPDATERECORDINFOUSERCMD_CMD_FIELD.default_value = 9
UPDATERECORDINFOUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATERECORDINFOUSERCMD_CMD_FIELD.type = 14
UPDATERECORDINFOUSERCMD_CMD_FIELD.cpp_type = 8
UPDATERECORDINFOUSERCMD_PARAM_FIELD.name = "param"
UPDATERECORDINFOUSERCMD_PARAM_FIELD.full_name = ".Cmd.UpdateRecordInfoUserCmd.param"
UPDATERECORDINFOUSERCMD_PARAM_FIELD.number = 2
UPDATERECORDINFOUSERCMD_PARAM_FIELD.index = 1
UPDATERECORDINFOUSERCMD_PARAM_FIELD.label = 1
UPDATERECORDINFOUSERCMD_PARAM_FIELD.has_default_value = true
UPDATERECORDINFOUSERCMD_PARAM_FIELD.default_value = 134
UPDATERECORDINFOUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
UPDATERECORDINFOUSERCMD_PARAM_FIELD.type = 14
UPDATERECORDINFOUSERCMD_PARAM_FIELD.cpp_type = 8
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.name = "slots"
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.full_name = ".Cmd.UpdateRecordInfoUserCmd.slots"
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.number = 3
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.index = 2
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.label = 3
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.has_default_value = false
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.default_value = {}
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.message_type = SLOTINFO
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.type = 11
UPDATERECORDINFOUSERCMD_SLOTS_FIELD.cpp_type = 10
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.name = "records"
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.full_name = ".Cmd.UpdateRecordInfoUserCmd.records"
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.number = 4
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.index = 3
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.label = 3
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.has_default_value = false
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.default_value = {}
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.message_type = PROFESSIONUSERINFO
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.type = 11
UPDATERECORDINFOUSERCMD_RECORDS_FIELD.cpp_type = 10
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.name = "delete_ids"
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.full_name = ".Cmd.UpdateRecordInfoUserCmd.delete_ids"
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.number = 5
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.index = 4
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.label = 3
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.has_default_value = false
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.default_value = {}
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.type = 13
UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD.cpp_type = 3
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.name = "card_expiretime"
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.full_name = ".Cmd.UpdateRecordInfoUserCmd.card_expiretime"
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.number = 6
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.index = 5
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.label = 1
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.has_default_value = false
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.default_value = 0
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.type = 13
UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD.cpp_type = 3
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.name = "astrol_data"
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.full_name = ".Cmd.UpdateRecordInfoUserCmd.astrol_data"
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.number = 7
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.index = 6
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.label = 3
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.has_default_value = false
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.default_value = {}
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.message_type = USERASTROLMATERIALDATA
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.type = 11
UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD.cpp_type = 10
UPDATERECORDINFOUSERCMD.name = "UpdateRecordInfoUserCmd"
UPDATERECORDINFOUSERCMD.full_name = ".Cmd.UpdateRecordInfoUserCmd"
UPDATERECORDINFOUSERCMD.nested_types = {}
UPDATERECORDINFOUSERCMD.enum_types = {}
UPDATERECORDINFOUSERCMD.fields = {
  UPDATERECORDINFOUSERCMD_CMD_FIELD,
  UPDATERECORDINFOUSERCMD_PARAM_FIELD,
  UPDATERECORDINFOUSERCMD_SLOTS_FIELD,
  UPDATERECORDINFOUSERCMD_RECORDS_FIELD,
  UPDATERECORDINFOUSERCMD_DELETE_IDS_FIELD,
  UPDATERECORDINFOUSERCMD_CARD_EXPIRETIME_FIELD,
  UPDATERECORDINFOUSERCMD_ASTROL_DATA_FIELD
}
UPDATERECORDINFOUSERCMD.is_extendable = false
UPDATERECORDINFOUSERCMD.extensions = {}
SAVERECORDUSERCMD_CMD_FIELD.name = "cmd"
SAVERECORDUSERCMD_CMD_FIELD.full_name = ".Cmd.SaveRecordUserCmd.cmd"
SAVERECORDUSERCMD_CMD_FIELD.number = 1
SAVERECORDUSERCMD_CMD_FIELD.index = 0
SAVERECORDUSERCMD_CMD_FIELD.label = 1
SAVERECORDUSERCMD_CMD_FIELD.has_default_value = true
SAVERECORDUSERCMD_CMD_FIELD.default_value = 9
SAVERECORDUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SAVERECORDUSERCMD_CMD_FIELD.type = 14
SAVERECORDUSERCMD_CMD_FIELD.cpp_type = 8
SAVERECORDUSERCMD_PARAM_FIELD.name = "param"
SAVERECORDUSERCMD_PARAM_FIELD.full_name = ".Cmd.SaveRecordUserCmd.param"
SAVERECORDUSERCMD_PARAM_FIELD.number = 2
SAVERECORDUSERCMD_PARAM_FIELD.index = 1
SAVERECORDUSERCMD_PARAM_FIELD.label = 1
SAVERECORDUSERCMD_PARAM_FIELD.has_default_value = true
SAVERECORDUSERCMD_PARAM_FIELD.default_value = 135
SAVERECORDUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SAVERECORDUSERCMD_PARAM_FIELD.type = 14
SAVERECORDUSERCMD_PARAM_FIELD.cpp_type = 8
SAVERECORDUSERCMD_SLOTID_FIELD.name = "slotid"
SAVERECORDUSERCMD_SLOTID_FIELD.full_name = ".Cmd.SaveRecordUserCmd.slotid"
SAVERECORDUSERCMD_SLOTID_FIELD.number = 3
SAVERECORDUSERCMD_SLOTID_FIELD.index = 2
SAVERECORDUSERCMD_SLOTID_FIELD.label = 1
SAVERECORDUSERCMD_SLOTID_FIELD.has_default_value = false
SAVERECORDUSERCMD_SLOTID_FIELD.default_value = 0
SAVERECORDUSERCMD_SLOTID_FIELD.type = 13
SAVERECORDUSERCMD_SLOTID_FIELD.cpp_type = 3
SAVERECORDUSERCMD_RECORD_NAME_FIELD.name = "record_name"
SAVERECORDUSERCMD_RECORD_NAME_FIELD.full_name = ".Cmd.SaveRecordUserCmd.record_name"
SAVERECORDUSERCMD_RECORD_NAME_FIELD.number = 4
SAVERECORDUSERCMD_RECORD_NAME_FIELD.index = 3
SAVERECORDUSERCMD_RECORD_NAME_FIELD.label = 1
SAVERECORDUSERCMD_RECORD_NAME_FIELD.has_default_value = false
SAVERECORDUSERCMD_RECORD_NAME_FIELD.default_value = ""
SAVERECORDUSERCMD_RECORD_NAME_FIELD.type = 9
SAVERECORDUSERCMD_RECORD_NAME_FIELD.cpp_type = 9
SAVERECORDUSERCMD.name = "SaveRecordUserCmd"
SAVERECORDUSERCMD.full_name = ".Cmd.SaveRecordUserCmd"
SAVERECORDUSERCMD.nested_types = {}
SAVERECORDUSERCMD.enum_types = {}
SAVERECORDUSERCMD.fields = {
  SAVERECORDUSERCMD_CMD_FIELD,
  SAVERECORDUSERCMD_PARAM_FIELD,
  SAVERECORDUSERCMD_SLOTID_FIELD,
  SAVERECORDUSERCMD_RECORD_NAME_FIELD
}
SAVERECORDUSERCMD.is_extendable = false
SAVERECORDUSERCMD.extensions = {}
LOADRECORDUSERCMD_CMD_FIELD.name = "cmd"
LOADRECORDUSERCMD_CMD_FIELD.full_name = ".Cmd.LoadRecordUserCmd.cmd"
LOADRECORDUSERCMD_CMD_FIELD.number = 1
LOADRECORDUSERCMD_CMD_FIELD.index = 0
LOADRECORDUSERCMD_CMD_FIELD.label = 1
LOADRECORDUSERCMD_CMD_FIELD.has_default_value = true
LOADRECORDUSERCMD_CMD_FIELD.default_value = 9
LOADRECORDUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LOADRECORDUSERCMD_CMD_FIELD.type = 14
LOADRECORDUSERCMD_CMD_FIELD.cpp_type = 8
LOADRECORDUSERCMD_PARAM_FIELD.name = "param"
LOADRECORDUSERCMD_PARAM_FIELD.full_name = ".Cmd.LoadRecordUserCmd.param"
LOADRECORDUSERCMD_PARAM_FIELD.number = 2
LOADRECORDUSERCMD_PARAM_FIELD.index = 1
LOADRECORDUSERCMD_PARAM_FIELD.label = 1
LOADRECORDUSERCMD_PARAM_FIELD.has_default_value = true
LOADRECORDUSERCMD_PARAM_FIELD.default_value = 136
LOADRECORDUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
LOADRECORDUSERCMD_PARAM_FIELD.type = 14
LOADRECORDUSERCMD_PARAM_FIELD.cpp_type = 8
LOADRECORDUSERCMD_SLOTID_FIELD.name = "slotid"
LOADRECORDUSERCMD_SLOTID_FIELD.full_name = ".Cmd.LoadRecordUserCmd.slotid"
LOADRECORDUSERCMD_SLOTID_FIELD.number = 3
LOADRECORDUSERCMD_SLOTID_FIELD.index = 2
LOADRECORDUSERCMD_SLOTID_FIELD.label = 1
LOADRECORDUSERCMD_SLOTID_FIELD.has_default_value = false
LOADRECORDUSERCMD_SLOTID_FIELD.default_value = 0
LOADRECORDUSERCMD_SLOTID_FIELD.type = 13
LOADRECORDUSERCMD_SLOTID_FIELD.cpp_type = 3
LOADRECORDUSERCMD.name = "LoadRecordUserCmd"
LOADRECORDUSERCMD.full_name = ".Cmd.LoadRecordUserCmd"
LOADRECORDUSERCMD.nested_types = {}
LOADRECORDUSERCMD.enum_types = {}
LOADRECORDUSERCMD.fields = {
  LOADRECORDUSERCMD_CMD_FIELD,
  LOADRECORDUSERCMD_PARAM_FIELD,
  LOADRECORDUSERCMD_SLOTID_FIELD
}
LOADRECORDUSERCMD.is_extendable = false
LOADRECORDUSERCMD.extensions = {}
CHANGERECORDNAMEUSERCMD_CMD_FIELD.name = "cmd"
CHANGERECORDNAMEUSERCMD_CMD_FIELD.full_name = ".Cmd.ChangeRecordNameUserCmd.cmd"
CHANGERECORDNAMEUSERCMD_CMD_FIELD.number = 1
CHANGERECORDNAMEUSERCMD_CMD_FIELD.index = 0
CHANGERECORDNAMEUSERCMD_CMD_FIELD.label = 1
CHANGERECORDNAMEUSERCMD_CMD_FIELD.has_default_value = true
CHANGERECORDNAMEUSERCMD_CMD_FIELD.default_value = 9
CHANGERECORDNAMEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHANGERECORDNAMEUSERCMD_CMD_FIELD.type = 14
CHANGERECORDNAMEUSERCMD_CMD_FIELD.cpp_type = 8
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.name = "param"
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.full_name = ".Cmd.ChangeRecordNameUserCmd.param"
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.number = 2
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.index = 1
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.label = 1
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.has_default_value = true
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.default_value = 137
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.type = 14
CHANGERECORDNAMEUSERCMD_PARAM_FIELD.cpp_type = 8
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.name = "slotid"
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.full_name = ".Cmd.ChangeRecordNameUserCmd.slotid"
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.number = 3
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.index = 2
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.label = 1
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.has_default_value = false
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.default_value = 0
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.type = 13
CHANGERECORDNAMEUSERCMD_SLOTID_FIELD.cpp_type = 3
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.name = "record_name"
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.full_name = ".Cmd.ChangeRecordNameUserCmd.record_name"
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.number = 4
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.index = 3
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.label = 1
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.has_default_value = false
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.default_value = ""
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.type = 9
CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD.cpp_type = 9
CHANGERECORDNAMEUSERCMD.name = "ChangeRecordNameUserCmd"
CHANGERECORDNAMEUSERCMD.full_name = ".Cmd.ChangeRecordNameUserCmd"
CHANGERECORDNAMEUSERCMD.nested_types = {}
CHANGERECORDNAMEUSERCMD.enum_types = {}
CHANGERECORDNAMEUSERCMD.fields = {
  CHANGERECORDNAMEUSERCMD_CMD_FIELD,
  CHANGERECORDNAMEUSERCMD_PARAM_FIELD,
  CHANGERECORDNAMEUSERCMD_SLOTID_FIELD,
  CHANGERECORDNAMEUSERCMD_RECORD_NAME_FIELD
}
CHANGERECORDNAMEUSERCMD.is_extendable = false
CHANGERECORDNAMEUSERCMD.extensions = {}
BUYRECORDSLOTUSERCMD_CMD_FIELD.name = "cmd"
BUYRECORDSLOTUSERCMD_CMD_FIELD.full_name = ".Cmd.BuyRecordSlotUserCmd.cmd"
BUYRECORDSLOTUSERCMD_CMD_FIELD.number = 1
BUYRECORDSLOTUSERCMD_CMD_FIELD.index = 0
BUYRECORDSLOTUSERCMD_CMD_FIELD.label = 1
BUYRECORDSLOTUSERCMD_CMD_FIELD.has_default_value = true
BUYRECORDSLOTUSERCMD_CMD_FIELD.default_value = 9
BUYRECORDSLOTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BUYRECORDSLOTUSERCMD_CMD_FIELD.type = 14
BUYRECORDSLOTUSERCMD_CMD_FIELD.cpp_type = 8
BUYRECORDSLOTUSERCMD_PARAM_FIELD.name = "param"
BUYRECORDSLOTUSERCMD_PARAM_FIELD.full_name = ".Cmd.BuyRecordSlotUserCmd.param"
BUYRECORDSLOTUSERCMD_PARAM_FIELD.number = 2
BUYRECORDSLOTUSERCMD_PARAM_FIELD.index = 1
BUYRECORDSLOTUSERCMD_PARAM_FIELD.label = 1
BUYRECORDSLOTUSERCMD_PARAM_FIELD.has_default_value = true
BUYRECORDSLOTUSERCMD_PARAM_FIELD.default_value = 138
BUYRECORDSLOTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
BUYRECORDSLOTUSERCMD_PARAM_FIELD.type = 14
BUYRECORDSLOTUSERCMD_PARAM_FIELD.cpp_type = 8
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.name = "slotid"
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.full_name = ".Cmd.BuyRecordSlotUserCmd.slotid"
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.number = 3
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.index = 2
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.label = 1
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.has_default_value = false
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.default_value = 0
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.type = 13
BUYRECORDSLOTUSERCMD_SLOTID_FIELD.cpp_type = 3
BUYRECORDSLOTUSERCMD.name = "BuyRecordSlotUserCmd"
BUYRECORDSLOTUSERCMD.full_name = ".Cmd.BuyRecordSlotUserCmd"
BUYRECORDSLOTUSERCMD.nested_types = {}
BUYRECORDSLOTUSERCMD.enum_types = {}
BUYRECORDSLOTUSERCMD.fields = {
  BUYRECORDSLOTUSERCMD_CMD_FIELD,
  BUYRECORDSLOTUSERCMD_PARAM_FIELD,
  BUYRECORDSLOTUSERCMD_SLOTID_FIELD
}
BUYRECORDSLOTUSERCMD.is_extendable = false
BUYRECORDSLOTUSERCMD.extensions = {}
DELETERECORDUSERCMD_CMD_FIELD.name = "cmd"
DELETERECORDUSERCMD_CMD_FIELD.full_name = ".Cmd.DeleteRecordUserCmd.cmd"
DELETERECORDUSERCMD_CMD_FIELD.number = 1
DELETERECORDUSERCMD_CMD_FIELD.index = 0
DELETERECORDUSERCMD_CMD_FIELD.label = 1
DELETERECORDUSERCMD_CMD_FIELD.has_default_value = true
DELETERECORDUSERCMD_CMD_FIELD.default_value = 9
DELETERECORDUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DELETERECORDUSERCMD_CMD_FIELD.type = 14
DELETERECORDUSERCMD_CMD_FIELD.cpp_type = 8
DELETERECORDUSERCMD_PARAM_FIELD.name = "param"
DELETERECORDUSERCMD_PARAM_FIELD.full_name = ".Cmd.DeleteRecordUserCmd.param"
DELETERECORDUSERCMD_PARAM_FIELD.number = 2
DELETERECORDUSERCMD_PARAM_FIELD.index = 1
DELETERECORDUSERCMD_PARAM_FIELD.label = 1
DELETERECORDUSERCMD_PARAM_FIELD.has_default_value = true
DELETERECORDUSERCMD_PARAM_FIELD.default_value = 139
DELETERECORDUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
DELETERECORDUSERCMD_PARAM_FIELD.type = 14
DELETERECORDUSERCMD_PARAM_FIELD.cpp_type = 8
DELETERECORDUSERCMD_SLOTID_FIELD.name = "slotid"
DELETERECORDUSERCMD_SLOTID_FIELD.full_name = ".Cmd.DeleteRecordUserCmd.slotid"
DELETERECORDUSERCMD_SLOTID_FIELD.number = 3
DELETERECORDUSERCMD_SLOTID_FIELD.index = 2
DELETERECORDUSERCMD_SLOTID_FIELD.label = 1
DELETERECORDUSERCMD_SLOTID_FIELD.has_default_value = false
DELETERECORDUSERCMD_SLOTID_FIELD.default_value = 0
DELETERECORDUSERCMD_SLOTID_FIELD.type = 13
DELETERECORDUSERCMD_SLOTID_FIELD.cpp_type = 3
DELETERECORDUSERCMD.name = "DeleteRecordUserCmd"
DELETERECORDUSERCMD.full_name = ".Cmd.DeleteRecordUserCmd"
DELETERECORDUSERCMD.nested_types = {}
DELETERECORDUSERCMD.enum_types = {}
DELETERECORDUSERCMD.fields = {
  DELETERECORDUSERCMD_CMD_FIELD,
  DELETERECORDUSERCMD_PARAM_FIELD,
  DELETERECORDUSERCMD_SLOTID_FIELD
}
DELETERECORDUSERCMD.is_extendable = false
DELETERECORDUSERCMD.extensions = {}
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.name = "cmd"
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.full_name = ".Cmd.UpdateBranchInfoUserCmd.cmd"
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.number = 1
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.index = 0
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.label = 1
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.has_default_value = true
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.default_value = 9
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.type = 14
UPDATEBRANCHINFOUSERCMD_CMD_FIELD.cpp_type = 8
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.name = "param"
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.full_name = ".Cmd.UpdateBranchInfoUserCmd.param"
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.number = 2
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.index = 1
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.label = 1
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.has_default_value = true
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.default_value = 140
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.type = 14
UPDATEBRANCHINFOUSERCMD_PARAM_FIELD.cpp_type = 8
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.name = "datas"
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.full_name = ".Cmd.UpdateBranchInfoUserCmd.datas"
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.number = 3
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.index = 2
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.label = 3
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.has_default_value = false
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.default_value = {}
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.message_type = PROFESSIONUSERINFO
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.type = 11
UPDATEBRANCHINFOUSERCMD_DATAS_FIELD.cpp_type = 10
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.name = "sync_type"
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.full_name = ".Cmd.UpdateBranchInfoUserCmd.sync_type"
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.number = 4
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.index = 3
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.label = 1
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.has_default_value = true
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.default_value = 0
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.type = 13
UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD.cpp_type = 3
UPDATEBRANCHINFOUSERCMD.name = "UpdateBranchInfoUserCmd"
UPDATEBRANCHINFOUSERCMD.full_name = ".Cmd.UpdateBranchInfoUserCmd"
UPDATEBRANCHINFOUSERCMD.nested_types = {}
UPDATEBRANCHINFOUSERCMD.enum_types = {}
UPDATEBRANCHINFOUSERCMD.fields = {
  UPDATEBRANCHINFOUSERCMD_CMD_FIELD,
  UPDATEBRANCHINFOUSERCMD_PARAM_FIELD,
  UPDATEBRANCHINFOUSERCMD_DATAS_FIELD,
  UPDATEBRANCHINFOUSERCMD_SYNC_TYPE_FIELD
}
UPDATEBRANCHINFOUSERCMD.is_extendable = false
UPDATEBRANCHINFOUSERCMD.extensions = {}
ENTERCAPRAACTIVITYCMD_CMD_FIELD.name = "cmd"
ENTERCAPRAACTIVITYCMD_CMD_FIELD.full_name = ".Cmd.EnterCapraActivityCmd.cmd"
ENTERCAPRAACTIVITYCMD_CMD_FIELD.number = 1
ENTERCAPRAACTIVITYCMD_CMD_FIELD.index = 0
ENTERCAPRAACTIVITYCMD_CMD_FIELD.label = 1
ENTERCAPRAACTIVITYCMD_CMD_FIELD.has_default_value = true
ENTERCAPRAACTIVITYCMD_CMD_FIELD.default_value = 9
ENTERCAPRAACTIVITYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ENTERCAPRAACTIVITYCMD_CMD_FIELD.type = 14
ENTERCAPRAACTIVITYCMD_CMD_FIELD.cpp_type = 8
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.name = "param"
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.full_name = ".Cmd.EnterCapraActivityCmd.param"
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.number = 2
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.index = 1
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.label = 1
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.has_default_value = true
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.default_value = 110
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.enum_type = USER2PARAM
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.type = 14
ENTERCAPRAACTIVITYCMD_PARAM_FIELD.cpp_type = 8
ENTERCAPRAACTIVITYCMD.name = "EnterCapraActivityCmd"
ENTERCAPRAACTIVITYCMD.full_name = ".Cmd.EnterCapraActivityCmd"
ENTERCAPRAACTIVITYCMD.nested_types = {}
ENTERCAPRAACTIVITYCMD.enum_types = {}
ENTERCAPRAACTIVITYCMD.fields = {
  ENTERCAPRAACTIVITYCMD_CMD_FIELD,
  ENTERCAPRAACTIVITYCMD_PARAM_FIELD
}
ENTERCAPRAACTIVITYCMD.is_extendable = false
ENTERCAPRAACTIVITYCMD.extensions = {}
INVITEWITHMEUSERCMD_CMD_FIELD.name = "cmd"
INVITEWITHMEUSERCMD_CMD_FIELD.full_name = ".Cmd.InviteWithMeUserCmd.cmd"
INVITEWITHMEUSERCMD_CMD_FIELD.number = 1
INVITEWITHMEUSERCMD_CMD_FIELD.index = 0
INVITEWITHMEUSERCMD_CMD_FIELD.label = 1
INVITEWITHMEUSERCMD_CMD_FIELD.has_default_value = true
INVITEWITHMEUSERCMD_CMD_FIELD.default_value = 9
INVITEWITHMEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITEWITHMEUSERCMD_CMD_FIELD.type = 14
INVITEWITHMEUSERCMD_CMD_FIELD.cpp_type = 8
INVITEWITHMEUSERCMD_PARAM_FIELD.name = "param"
INVITEWITHMEUSERCMD_PARAM_FIELD.full_name = ".Cmd.InviteWithMeUserCmd.param"
INVITEWITHMEUSERCMD_PARAM_FIELD.number = 2
INVITEWITHMEUSERCMD_PARAM_FIELD.index = 1
INVITEWITHMEUSERCMD_PARAM_FIELD.label = 1
INVITEWITHMEUSERCMD_PARAM_FIELD.has_default_value = true
INVITEWITHMEUSERCMD_PARAM_FIELD.default_value = 142
INVITEWITHMEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
INVITEWITHMEUSERCMD_PARAM_FIELD.type = 14
INVITEWITHMEUSERCMD_PARAM_FIELD.cpp_type = 8
INVITEWITHMEUSERCMD_SENDID_FIELD.name = "sendid"
INVITEWITHMEUSERCMD_SENDID_FIELD.full_name = ".Cmd.InviteWithMeUserCmd.sendid"
INVITEWITHMEUSERCMD_SENDID_FIELD.number = 3
INVITEWITHMEUSERCMD_SENDID_FIELD.index = 2
INVITEWITHMEUSERCMD_SENDID_FIELD.label = 1
INVITEWITHMEUSERCMD_SENDID_FIELD.has_default_value = true
INVITEWITHMEUSERCMD_SENDID_FIELD.default_value = 0
INVITEWITHMEUSERCMD_SENDID_FIELD.type = 4
INVITEWITHMEUSERCMD_SENDID_FIELD.cpp_type = 4
INVITEWITHMEUSERCMD_TIME_FIELD.name = "time"
INVITEWITHMEUSERCMD_TIME_FIELD.full_name = ".Cmd.InviteWithMeUserCmd.time"
INVITEWITHMEUSERCMD_TIME_FIELD.number = 4
INVITEWITHMEUSERCMD_TIME_FIELD.index = 3
INVITEWITHMEUSERCMD_TIME_FIELD.label = 1
INVITEWITHMEUSERCMD_TIME_FIELD.has_default_value = true
INVITEWITHMEUSERCMD_TIME_FIELD.default_value = 0
INVITEWITHMEUSERCMD_TIME_FIELD.type = 13
INVITEWITHMEUSERCMD_TIME_FIELD.cpp_type = 3
INVITEWITHMEUSERCMD_REPLY_FIELD.name = "reply"
INVITEWITHMEUSERCMD_REPLY_FIELD.full_name = ".Cmd.InviteWithMeUserCmd.reply"
INVITEWITHMEUSERCMD_REPLY_FIELD.number = 5
INVITEWITHMEUSERCMD_REPLY_FIELD.index = 4
INVITEWITHMEUSERCMD_REPLY_FIELD.label = 1
INVITEWITHMEUSERCMD_REPLY_FIELD.has_default_value = true
INVITEWITHMEUSERCMD_REPLY_FIELD.default_value = false
INVITEWITHMEUSERCMD_REPLY_FIELD.type = 8
INVITEWITHMEUSERCMD_REPLY_FIELD.cpp_type = 7
INVITEWITHMEUSERCMD_SIGN_FIELD.name = "sign"
INVITEWITHMEUSERCMD_SIGN_FIELD.full_name = ".Cmd.InviteWithMeUserCmd.sign"
INVITEWITHMEUSERCMD_SIGN_FIELD.number = 6
INVITEWITHMEUSERCMD_SIGN_FIELD.index = 5
INVITEWITHMEUSERCMD_SIGN_FIELD.label = 1
INVITEWITHMEUSERCMD_SIGN_FIELD.has_default_value = false
INVITEWITHMEUSERCMD_SIGN_FIELD.default_value = ""
INVITEWITHMEUSERCMD_SIGN_FIELD.type = 12
INVITEWITHMEUSERCMD_SIGN_FIELD.cpp_type = 9
INVITEWITHMEUSERCMD.name = "InviteWithMeUserCmd"
INVITEWITHMEUSERCMD.full_name = ".Cmd.InviteWithMeUserCmd"
INVITEWITHMEUSERCMD.nested_types = {}
INVITEWITHMEUSERCMD.enum_types = {}
INVITEWITHMEUSERCMD.fields = {
  INVITEWITHMEUSERCMD_CMD_FIELD,
  INVITEWITHMEUSERCMD_PARAM_FIELD,
  INVITEWITHMEUSERCMD_SENDID_FIELD,
  INVITEWITHMEUSERCMD_TIME_FIELD,
  INVITEWITHMEUSERCMD_REPLY_FIELD,
  INVITEWITHMEUSERCMD_SIGN_FIELD
}
INVITEWITHMEUSERCMD.is_extendable = false
INVITEWITHMEUSERCMD.extensions = {}
QUERYALTMANKILLUSERCMD_CMD_FIELD.name = "cmd"
QUERYALTMANKILLUSERCMD_CMD_FIELD.full_name = ".Cmd.QueryAltmanKillUserCmd.cmd"
QUERYALTMANKILLUSERCMD_CMD_FIELD.number = 1
QUERYALTMANKILLUSERCMD_CMD_FIELD.index = 0
QUERYALTMANKILLUSERCMD_CMD_FIELD.label = 1
QUERYALTMANKILLUSERCMD_CMD_FIELD.has_default_value = true
QUERYALTMANKILLUSERCMD_CMD_FIELD.default_value = 9
QUERYALTMANKILLUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYALTMANKILLUSERCMD_CMD_FIELD.type = 14
QUERYALTMANKILLUSERCMD_CMD_FIELD.cpp_type = 8
QUERYALTMANKILLUSERCMD_PARAM_FIELD.name = "param"
QUERYALTMANKILLUSERCMD_PARAM_FIELD.full_name = ".Cmd.QueryAltmanKillUserCmd.param"
QUERYALTMANKILLUSERCMD_PARAM_FIELD.number = 2
QUERYALTMANKILLUSERCMD_PARAM_FIELD.index = 1
QUERYALTMANKILLUSERCMD_PARAM_FIELD.label = 1
QUERYALTMANKILLUSERCMD_PARAM_FIELD.has_default_value = true
QUERYALTMANKILLUSERCMD_PARAM_FIELD.default_value = 143
QUERYALTMANKILLUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
QUERYALTMANKILLUSERCMD_PARAM_FIELD.type = 14
QUERYALTMANKILLUSERCMD_PARAM_FIELD.cpp_type = 8
QUERYALTMANKILLUSERCMD.name = "QueryAltmanKillUserCmd"
QUERYALTMANKILLUSERCMD.full_name = ".Cmd.QueryAltmanKillUserCmd"
QUERYALTMANKILLUSERCMD.nested_types = {}
QUERYALTMANKILLUSERCMD.enum_types = {}
QUERYALTMANKILLUSERCMD.fields = {
  QUERYALTMANKILLUSERCMD_CMD_FIELD,
  QUERYALTMANKILLUSERCMD_PARAM_FIELD
}
QUERYALTMANKILLUSERCMD.is_extendable = false
QUERYALTMANKILLUSERCMD.extensions = {}
BOOTHINFO_NAME_FIELD.name = "name"
BOOTHINFO_NAME_FIELD.full_name = ".Cmd.BoothInfo.name"
BOOTHINFO_NAME_FIELD.number = 1
BOOTHINFO_NAME_FIELD.index = 0
BOOTHINFO_NAME_FIELD.label = 1
BOOTHINFO_NAME_FIELD.has_default_value = false
BOOTHINFO_NAME_FIELD.default_value = ""
BOOTHINFO_NAME_FIELD.type = 9
BOOTHINFO_NAME_FIELD.cpp_type = 9
BOOTHINFO_SIGN_FIELD.name = "sign"
BOOTHINFO_SIGN_FIELD.full_name = ".Cmd.BoothInfo.sign"
BOOTHINFO_SIGN_FIELD.number = 2
BOOTHINFO_SIGN_FIELD.index = 1
BOOTHINFO_SIGN_FIELD.label = 1
BOOTHINFO_SIGN_FIELD.has_default_value = false
BOOTHINFO_SIGN_FIELD.default_value = nil
BOOTHINFO_SIGN_FIELD.enum_type = EBOOTHSIGN
BOOTHINFO_SIGN_FIELD.type = 14
BOOTHINFO_SIGN_FIELD.cpp_type = 8
BOOTHINFO.name = "BoothInfo"
BOOTHINFO.full_name = ".Cmd.BoothInfo"
BOOTHINFO.nested_types = {}
BOOTHINFO.enum_types = {}
BOOTHINFO.fields = {
  BOOTHINFO_NAME_FIELD,
  BOOTHINFO_SIGN_FIELD
}
BOOTHINFO.is_extendable = false
BOOTHINFO.extensions = {}
BOOTHREQUSERCMD_CMD_FIELD.name = "cmd"
BOOTHREQUSERCMD_CMD_FIELD.full_name = ".Cmd.BoothReqUserCmd.cmd"
BOOTHREQUSERCMD_CMD_FIELD.number = 1
BOOTHREQUSERCMD_CMD_FIELD.index = 0
BOOTHREQUSERCMD_CMD_FIELD.label = 1
BOOTHREQUSERCMD_CMD_FIELD.has_default_value = true
BOOTHREQUSERCMD_CMD_FIELD.default_value = 9
BOOTHREQUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BOOTHREQUSERCMD_CMD_FIELD.type = 14
BOOTHREQUSERCMD_CMD_FIELD.cpp_type = 8
BOOTHREQUSERCMD_PARAM_FIELD.name = "param"
BOOTHREQUSERCMD_PARAM_FIELD.full_name = ".Cmd.BoothReqUserCmd.param"
BOOTHREQUSERCMD_PARAM_FIELD.number = 2
BOOTHREQUSERCMD_PARAM_FIELD.index = 1
BOOTHREQUSERCMD_PARAM_FIELD.label = 1
BOOTHREQUSERCMD_PARAM_FIELD.has_default_value = true
BOOTHREQUSERCMD_PARAM_FIELD.default_value = 144
BOOTHREQUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
BOOTHREQUSERCMD_PARAM_FIELD.type = 14
BOOTHREQUSERCMD_PARAM_FIELD.cpp_type = 8
BOOTHREQUSERCMD_NAME_FIELD.name = "name"
BOOTHREQUSERCMD_NAME_FIELD.full_name = ".Cmd.BoothReqUserCmd.name"
BOOTHREQUSERCMD_NAME_FIELD.number = 3
BOOTHREQUSERCMD_NAME_FIELD.index = 2
BOOTHREQUSERCMD_NAME_FIELD.label = 1
BOOTHREQUSERCMD_NAME_FIELD.has_default_value = false
BOOTHREQUSERCMD_NAME_FIELD.default_value = ""
BOOTHREQUSERCMD_NAME_FIELD.type = 9
BOOTHREQUSERCMD_NAME_FIELD.cpp_type = 9
BOOTHREQUSERCMD_OPER_FIELD.name = "oper"
BOOTHREQUSERCMD_OPER_FIELD.full_name = ".Cmd.BoothReqUserCmd.oper"
BOOTHREQUSERCMD_OPER_FIELD.number = 4
BOOTHREQUSERCMD_OPER_FIELD.index = 3
BOOTHREQUSERCMD_OPER_FIELD.label = 1
BOOTHREQUSERCMD_OPER_FIELD.has_default_value = true
BOOTHREQUSERCMD_OPER_FIELD.default_value = 0
BOOTHREQUSERCMD_OPER_FIELD.enum_type = EBOOTHOPER
BOOTHREQUSERCMD_OPER_FIELD.type = 14
BOOTHREQUSERCMD_OPER_FIELD.cpp_type = 8
BOOTHREQUSERCMD_SUCCESS_FIELD.name = "success"
BOOTHREQUSERCMD_SUCCESS_FIELD.full_name = ".Cmd.BoothReqUserCmd.success"
BOOTHREQUSERCMD_SUCCESS_FIELD.number = 5
BOOTHREQUSERCMD_SUCCESS_FIELD.index = 4
BOOTHREQUSERCMD_SUCCESS_FIELD.label = 1
BOOTHREQUSERCMD_SUCCESS_FIELD.has_default_value = true
BOOTHREQUSERCMD_SUCCESS_FIELD.default_value = true
BOOTHREQUSERCMD_SUCCESS_FIELD.type = 8
BOOTHREQUSERCMD_SUCCESS_FIELD.cpp_type = 7
BOOTHREQUSERCMD.name = "BoothReqUserCmd"
BOOTHREQUSERCMD.full_name = ".Cmd.BoothReqUserCmd"
BOOTHREQUSERCMD.nested_types = {}
BOOTHREQUSERCMD.enum_types = {}
BOOTHREQUSERCMD.fields = {
  BOOTHREQUSERCMD_CMD_FIELD,
  BOOTHREQUSERCMD_PARAM_FIELD,
  BOOTHREQUSERCMD_NAME_FIELD,
  BOOTHREQUSERCMD_OPER_FIELD,
  BOOTHREQUSERCMD_SUCCESS_FIELD
}
BOOTHREQUSERCMD.is_extendable = false
BOOTHREQUSERCMD.extensions = {}
BOOTHINFOSYNCUSERCMD_CMD_FIELD.name = "cmd"
BOOTHINFOSYNCUSERCMD_CMD_FIELD.full_name = ".Cmd.BoothInfoSyncUserCmd.cmd"
BOOTHINFOSYNCUSERCMD_CMD_FIELD.number = 1
BOOTHINFOSYNCUSERCMD_CMD_FIELD.index = 0
BOOTHINFOSYNCUSERCMD_CMD_FIELD.label = 1
BOOTHINFOSYNCUSERCMD_CMD_FIELD.has_default_value = true
BOOTHINFOSYNCUSERCMD_CMD_FIELD.default_value = 9
BOOTHINFOSYNCUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BOOTHINFOSYNCUSERCMD_CMD_FIELD.type = 14
BOOTHINFOSYNCUSERCMD_CMD_FIELD.cpp_type = 8
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.name = "param"
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.full_name = ".Cmd.BoothInfoSyncUserCmd.param"
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.number = 2
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.index = 1
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.label = 1
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.has_default_value = true
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.default_value = 145
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.type = 14
BOOTHINFOSYNCUSERCMD_PARAM_FIELD.cpp_type = 8
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.name = "charid"
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.full_name = ".Cmd.BoothInfoSyncUserCmd.charid"
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.number = 3
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.index = 2
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.label = 1
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.has_default_value = false
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.default_value = 0
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.type = 4
BOOTHINFOSYNCUSERCMD_CHARID_FIELD.cpp_type = 4
BOOTHINFOSYNCUSERCMD_OPER_FIELD.name = "oper"
BOOTHINFOSYNCUSERCMD_OPER_FIELD.full_name = ".Cmd.BoothInfoSyncUserCmd.oper"
BOOTHINFOSYNCUSERCMD_OPER_FIELD.number = 4
BOOTHINFOSYNCUSERCMD_OPER_FIELD.index = 3
BOOTHINFOSYNCUSERCMD_OPER_FIELD.label = 1
BOOTHINFOSYNCUSERCMD_OPER_FIELD.has_default_value = true
BOOTHINFOSYNCUSERCMD_OPER_FIELD.default_value = 0
BOOTHINFOSYNCUSERCMD_OPER_FIELD.enum_type = EBOOTHOPER
BOOTHINFOSYNCUSERCMD_OPER_FIELD.type = 14
BOOTHINFOSYNCUSERCMD_OPER_FIELD.cpp_type = 8
BOOTHINFOSYNCUSERCMD_INFO_FIELD.name = "info"
BOOTHINFOSYNCUSERCMD_INFO_FIELD.full_name = ".Cmd.BoothInfoSyncUserCmd.info"
BOOTHINFOSYNCUSERCMD_INFO_FIELD.number = 5
BOOTHINFOSYNCUSERCMD_INFO_FIELD.index = 4
BOOTHINFOSYNCUSERCMD_INFO_FIELD.label = 1
BOOTHINFOSYNCUSERCMD_INFO_FIELD.has_default_value = false
BOOTHINFOSYNCUSERCMD_INFO_FIELD.default_value = nil
BOOTHINFOSYNCUSERCMD_INFO_FIELD.message_type = BOOTHINFO
BOOTHINFOSYNCUSERCMD_INFO_FIELD.type = 11
BOOTHINFOSYNCUSERCMD_INFO_FIELD.cpp_type = 10
BOOTHINFOSYNCUSERCMD.name = "BoothInfoSyncUserCmd"
BOOTHINFOSYNCUSERCMD.full_name = ".Cmd.BoothInfoSyncUserCmd"
BOOTHINFOSYNCUSERCMD.nested_types = {}
BOOTHINFOSYNCUSERCMD.enum_types = {}
BOOTHINFOSYNCUSERCMD.fields = {
  BOOTHINFOSYNCUSERCMD_CMD_FIELD,
  BOOTHINFOSYNCUSERCMD_PARAM_FIELD,
  BOOTHINFOSYNCUSERCMD_CHARID_FIELD,
  BOOTHINFOSYNCUSERCMD_OPER_FIELD,
  BOOTHINFOSYNCUSERCMD_INFO_FIELD
}
BOOTHINFOSYNCUSERCMD.is_extendable = false
BOOTHINFOSYNCUSERCMD.extensions = {}
DRESSUPMODELUSERCMD_CMD_FIELD.name = "cmd"
DRESSUPMODELUSERCMD_CMD_FIELD.full_name = ".Cmd.DressUpModelUserCmd.cmd"
DRESSUPMODELUSERCMD_CMD_FIELD.number = 1
DRESSUPMODELUSERCMD_CMD_FIELD.index = 0
DRESSUPMODELUSERCMD_CMD_FIELD.label = 1
DRESSUPMODELUSERCMD_CMD_FIELD.has_default_value = true
DRESSUPMODELUSERCMD_CMD_FIELD.default_value = 9
DRESSUPMODELUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DRESSUPMODELUSERCMD_CMD_FIELD.type = 14
DRESSUPMODELUSERCMD_CMD_FIELD.cpp_type = 8
DRESSUPMODELUSERCMD_PARAM_FIELD.name = "param"
DRESSUPMODELUSERCMD_PARAM_FIELD.full_name = ".Cmd.DressUpModelUserCmd.param"
DRESSUPMODELUSERCMD_PARAM_FIELD.number = 2
DRESSUPMODELUSERCMD_PARAM_FIELD.index = 1
DRESSUPMODELUSERCMD_PARAM_FIELD.label = 1
DRESSUPMODELUSERCMD_PARAM_FIELD.has_default_value = true
DRESSUPMODELUSERCMD_PARAM_FIELD.default_value = 146
DRESSUPMODELUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
DRESSUPMODELUSERCMD_PARAM_FIELD.type = 14
DRESSUPMODELUSERCMD_PARAM_FIELD.cpp_type = 8
DRESSUPMODELUSERCMD_STAGEID_FIELD.name = "stageid"
DRESSUPMODELUSERCMD_STAGEID_FIELD.full_name = ".Cmd.DressUpModelUserCmd.stageid"
DRESSUPMODELUSERCMD_STAGEID_FIELD.number = 3
DRESSUPMODELUSERCMD_STAGEID_FIELD.index = 2
DRESSUPMODELUSERCMD_STAGEID_FIELD.label = 1
DRESSUPMODELUSERCMD_STAGEID_FIELD.has_default_value = true
DRESSUPMODELUSERCMD_STAGEID_FIELD.default_value = 0
DRESSUPMODELUSERCMD_STAGEID_FIELD.type = 13
DRESSUPMODELUSERCMD_STAGEID_FIELD.cpp_type = 3
DRESSUPMODELUSERCMD_TYPE_FIELD.name = "type"
DRESSUPMODELUSERCMD_TYPE_FIELD.full_name = ".Cmd.DressUpModelUserCmd.type"
DRESSUPMODELUSERCMD_TYPE_FIELD.number = 4
DRESSUPMODELUSERCMD_TYPE_FIELD.index = 3
DRESSUPMODELUSERCMD_TYPE_FIELD.label = 1
DRESSUPMODELUSERCMD_TYPE_FIELD.has_default_value = true
DRESSUPMODELUSERCMD_TYPE_FIELD.default_value = 0
DRESSUPMODELUSERCMD_TYPE_FIELD.enum_type = PROTOCOMMON_PB_EUSERDATATYPE
DRESSUPMODELUSERCMD_TYPE_FIELD.type = 14
DRESSUPMODELUSERCMD_TYPE_FIELD.cpp_type = 8
DRESSUPMODELUSERCMD_VALUE_FIELD.name = "value"
DRESSUPMODELUSERCMD_VALUE_FIELD.full_name = ".Cmd.DressUpModelUserCmd.value"
DRESSUPMODELUSERCMD_VALUE_FIELD.number = 5
DRESSUPMODELUSERCMD_VALUE_FIELD.index = 4
DRESSUPMODELUSERCMD_VALUE_FIELD.label = 1
DRESSUPMODELUSERCMD_VALUE_FIELD.has_default_value = true
DRESSUPMODELUSERCMD_VALUE_FIELD.default_value = 0
DRESSUPMODELUSERCMD_VALUE_FIELD.type = 13
DRESSUPMODELUSERCMD_VALUE_FIELD.cpp_type = 3
DRESSUPMODELUSERCMD.name = "DressUpModelUserCmd"
DRESSUPMODELUSERCMD.full_name = ".Cmd.DressUpModelUserCmd"
DRESSUPMODELUSERCMD.nested_types = {}
DRESSUPMODELUSERCMD.enum_types = {}
DRESSUPMODELUSERCMD.fields = {
  DRESSUPMODELUSERCMD_CMD_FIELD,
  DRESSUPMODELUSERCMD_PARAM_FIELD,
  DRESSUPMODELUSERCMD_STAGEID_FIELD,
  DRESSUPMODELUSERCMD_TYPE_FIELD,
  DRESSUPMODELUSERCMD_VALUE_FIELD
}
DRESSUPMODELUSERCMD.is_extendable = false
DRESSUPMODELUSERCMD.extensions = {}
DRESSUPHEADUSERCMD_CMD_FIELD.name = "cmd"
DRESSUPHEADUSERCMD_CMD_FIELD.full_name = ".Cmd.DressUpHeadUserCmd.cmd"
DRESSUPHEADUSERCMD_CMD_FIELD.number = 1
DRESSUPHEADUSERCMD_CMD_FIELD.index = 0
DRESSUPHEADUSERCMD_CMD_FIELD.label = 1
DRESSUPHEADUSERCMD_CMD_FIELD.has_default_value = true
DRESSUPHEADUSERCMD_CMD_FIELD.default_value = 9
DRESSUPHEADUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DRESSUPHEADUSERCMD_CMD_FIELD.type = 14
DRESSUPHEADUSERCMD_CMD_FIELD.cpp_type = 8
DRESSUPHEADUSERCMD_PARAM_FIELD.name = "param"
DRESSUPHEADUSERCMD_PARAM_FIELD.full_name = ".Cmd.DressUpHeadUserCmd.param"
DRESSUPHEADUSERCMD_PARAM_FIELD.number = 2
DRESSUPHEADUSERCMD_PARAM_FIELD.index = 1
DRESSUPHEADUSERCMD_PARAM_FIELD.label = 1
DRESSUPHEADUSERCMD_PARAM_FIELD.has_default_value = true
DRESSUPHEADUSERCMD_PARAM_FIELD.default_value = 147
DRESSUPHEADUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
DRESSUPHEADUSERCMD_PARAM_FIELD.type = 14
DRESSUPHEADUSERCMD_PARAM_FIELD.cpp_type = 8
DRESSUPHEADUSERCMD_TYPE_FIELD.name = "type"
DRESSUPHEADUSERCMD_TYPE_FIELD.full_name = ".Cmd.DressUpHeadUserCmd.type"
DRESSUPHEADUSERCMD_TYPE_FIELD.number = 3
DRESSUPHEADUSERCMD_TYPE_FIELD.index = 2
DRESSUPHEADUSERCMD_TYPE_FIELD.label = 1
DRESSUPHEADUSERCMD_TYPE_FIELD.has_default_value = true
DRESSUPHEADUSERCMD_TYPE_FIELD.default_value = 0
DRESSUPHEADUSERCMD_TYPE_FIELD.enum_type = PROTOCOMMON_PB_EUSERDATATYPE
DRESSUPHEADUSERCMD_TYPE_FIELD.type = 14
DRESSUPHEADUSERCMD_TYPE_FIELD.cpp_type = 8
DRESSUPHEADUSERCMD_VALUE_FIELD.name = "value"
DRESSUPHEADUSERCMD_VALUE_FIELD.full_name = ".Cmd.DressUpHeadUserCmd.value"
DRESSUPHEADUSERCMD_VALUE_FIELD.number = 4
DRESSUPHEADUSERCMD_VALUE_FIELD.index = 3
DRESSUPHEADUSERCMD_VALUE_FIELD.label = 1
DRESSUPHEADUSERCMD_VALUE_FIELD.has_default_value = true
DRESSUPHEADUSERCMD_VALUE_FIELD.default_value = 0
DRESSUPHEADUSERCMD_VALUE_FIELD.type = 13
DRESSUPHEADUSERCMD_VALUE_FIELD.cpp_type = 3
DRESSUPHEADUSERCMD_PUTON_FIELD.name = "puton"
DRESSUPHEADUSERCMD_PUTON_FIELD.full_name = ".Cmd.DressUpHeadUserCmd.puton"
DRESSUPHEADUSERCMD_PUTON_FIELD.number = 5
DRESSUPHEADUSERCMD_PUTON_FIELD.index = 4
DRESSUPHEADUSERCMD_PUTON_FIELD.label = 1
DRESSUPHEADUSERCMD_PUTON_FIELD.has_default_value = true
DRESSUPHEADUSERCMD_PUTON_FIELD.default_value = true
DRESSUPHEADUSERCMD_PUTON_FIELD.type = 8
DRESSUPHEADUSERCMD_PUTON_FIELD.cpp_type = 7
DRESSUPHEADUSERCMD.name = "DressUpHeadUserCmd"
DRESSUPHEADUSERCMD.full_name = ".Cmd.DressUpHeadUserCmd"
DRESSUPHEADUSERCMD.nested_types = {}
DRESSUPHEADUSERCMD.enum_types = {}
DRESSUPHEADUSERCMD.fields = {
  DRESSUPHEADUSERCMD_CMD_FIELD,
  DRESSUPHEADUSERCMD_PARAM_FIELD,
  DRESSUPHEADUSERCMD_TYPE_FIELD,
  DRESSUPHEADUSERCMD_VALUE_FIELD,
  DRESSUPHEADUSERCMD_PUTON_FIELD
}
DRESSUPHEADUSERCMD.is_extendable = false
DRESSUPHEADUSERCMD.extensions = {}
STAGEINFO_STAGEID_FIELD.name = "stageid"
STAGEINFO_STAGEID_FIELD.full_name = ".Cmd.StageInfo.stageid"
STAGEINFO_STAGEID_FIELD.number = 1
STAGEINFO_STAGEID_FIELD.index = 0
STAGEINFO_STAGEID_FIELD.label = 1
STAGEINFO_STAGEID_FIELD.has_default_value = true
STAGEINFO_STAGEID_FIELD.default_value = 0
STAGEINFO_STAGEID_FIELD.type = 13
STAGEINFO_STAGEID_FIELD.cpp_type = 3
STAGEINFO_USERNUM_FIELD.name = "usernum"
STAGEINFO_USERNUM_FIELD.full_name = ".Cmd.StageInfo.usernum"
STAGEINFO_USERNUM_FIELD.number = 2
STAGEINFO_USERNUM_FIELD.index = 1
STAGEINFO_USERNUM_FIELD.label = 1
STAGEINFO_USERNUM_FIELD.has_default_value = true
STAGEINFO_USERNUM_FIELD.default_value = 0
STAGEINFO_USERNUM_FIELD.type = 13
STAGEINFO_USERNUM_FIELD.cpp_type = 3
STAGEINFO_WAITTIME_FIELD.name = "waittime"
STAGEINFO_WAITTIME_FIELD.full_name = ".Cmd.StageInfo.waittime"
STAGEINFO_WAITTIME_FIELD.number = 3
STAGEINFO_WAITTIME_FIELD.index = 2
STAGEINFO_WAITTIME_FIELD.label = 1
STAGEINFO_WAITTIME_FIELD.has_default_value = true
STAGEINFO_WAITTIME_FIELD.default_value = 0
STAGEINFO_WAITTIME_FIELD.type = 13
STAGEINFO_WAITTIME_FIELD.cpp_type = 3
STAGEINFO_STATUS_FIELD.name = "status"
STAGEINFO_STATUS_FIELD.full_name = ".Cmd.StageInfo.status"
STAGEINFO_STATUS_FIELD.number = 4
STAGEINFO_STATUS_FIELD.index = 3
STAGEINFO_STATUS_FIELD.label = 1
STAGEINFO_STATUS_FIELD.has_default_value = true
STAGEINFO_STATUS_FIELD.default_value = 0
STAGEINFO_STATUS_FIELD.type = 13
STAGEINFO_STATUS_FIELD.cpp_type = 3
STAGEINFO.name = "StageInfo"
STAGEINFO.full_name = ".Cmd.StageInfo"
STAGEINFO.nested_types = {}
STAGEINFO.enum_types = {}
STAGEINFO.fields = {
  STAGEINFO_STAGEID_FIELD,
  STAGEINFO_USERNUM_FIELD,
  STAGEINFO_WAITTIME_FIELD,
  STAGEINFO_STATUS_FIELD
}
STAGEINFO.is_extendable = false
STAGEINFO.extensions = {}
QUERYSTAGEUSERCMD_CMD_FIELD.name = "cmd"
QUERYSTAGEUSERCMD_CMD_FIELD.full_name = ".Cmd.QueryStageUserCmd.cmd"
QUERYSTAGEUSERCMD_CMD_FIELD.number = 1
QUERYSTAGEUSERCMD_CMD_FIELD.index = 0
QUERYSTAGEUSERCMD_CMD_FIELD.label = 1
QUERYSTAGEUSERCMD_CMD_FIELD.has_default_value = true
QUERYSTAGEUSERCMD_CMD_FIELD.default_value = 9
QUERYSTAGEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYSTAGEUSERCMD_CMD_FIELD.type = 14
QUERYSTAGEUSERCMD_CMD_FIELD.cpp_type = 8
QUERYSTAGEUSERCMD_PARAM_FIELD.name = "param"
QUERYSTAGEUSERCMD_PARAM_FIELD.full_name = ".Cmd.QueryStageUserCmd.param"
QUERYSTAGEUSERCMD_PARAM_FIELD.number = 2
QUERYSTAGEUSERCMD_PARAM_FIELD.index = 1
QUERYSTAGEUSERCMD_PARAM_FIELD.label = 1
QUERYSTAGEUSERCMD_PARAM_FIELD.has_default_value = true
QUERYSTAGEUSERCMD_PARAM_FIELD.default_value = 148
QUERYSTAGEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
QUERYSTAGEUSERCMD_PARAM_FIELD.type = 14
QUERYSTAGEUSERCMD_PARAM_FIELD.cpp_type = 8
QUERYSTAGEUSERCMD_STAGEID_FIELD.name = "stageid"
QUERYSTAGEUSERCMD_STAGEID_FIELD.full_name = ".Cmd.QueryStageUserCmd.stageid"
QUERYSTAGEUSERCMD_STAGEID_FIELD.number = 3
QUERYSTAGEUSERCMD_STAGEID_FIELD.index = 2
QUERYSTAGEUSERCMD_STAGEID_FIELD.label = 1
QUERYSTAGEUSERCMD_STAGEID_FIELD.has_default_value = true
QUERYSTAGEUSERCMD_STAGEID_FIELD.default_value = 0
QUERYSTAGEUSERCMD_STAGEID_FIELD.type = 13
QUERYSTAGEUSERCMD_STAGEID_FIELD.cpp_type = 3
QUERYSTAGEUSERCMD_INFO_FIELD.name = "info"
QUERYSTAGEUSERCMD_INFO_FIELD.full_name = ".Cmd.QueryStageUserCmd.info"
QUERYSTAGEUSERCMD_INFO_FIELD.number = 4
QUERYSTAGEUSERCMD_INFO_FIELD.index = 3
QUERYSTAGEUSERCMD_INFO_FIELD.label = 3
QUERYSTAGEUSERCMD_INFO_FIELD.has_default_value = false
QUERYSTAGEUSERCMD_INFO_FIELD.default_value = {}
QUERYSTAGEUSERCMD_INFO_FIELD.message_type = STAGEINFO
QUERYSTAGEUSERCMD_INFO_FIELD.type = 11
QUERYSTAGEUSERCMD_INFO_FIELD.cpp_type = 10
QUERYSTAGEUSERCMD.name = "QueryStageUserCmd"
QUERYSTAGEUSERCMD.full_name = ".Cmd.QueryStageUserCmd"
QUERYSTAGEUSERCMD.nested_types = {}
QUERYSTAGEUSERCMD.enum_types = {}
QUERYSTAGEUSERCMD.fields = {
  QUERYSTAGEUSERCMD_CMD_FIELD,
  QUERYSTAGEUSERCMD_PARAM_FIELD,
  QUERYSTAGEUSERCMD_STAGEID_FIELD,
  QUERYSTAGEUSERCMD_INFO_FIELD
}
QUERYSTAGEUSERCMD.is_extendable = false
QUERYSTAGEUSERCMD.extensions = {}
DRESSUPLINEUPUSERCMD_CMD_FIELD.name = "cmd"
DRESSUPLINEUPUSERCMD_CMD_FIELD.full_name = ".Cmd.DressUpLineUpUserCmd.cmd"
DRESSUPLINEUPUSERCMD_CMD_FIELD.number = 1
DRESSUPLINEUPUSERCMD_CMD_FIELD.index = 0
DRESSUPLINEUPUSERCMD_CMD_FIELD.label = 1
DRESSUPLINEUPUSERCMD_CMD_FIELD.has_default_value = true
DRESSUPLINEUPUSERCMD_CMD_FIELD.default_value = 9
DRESSUPLINEUPUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DRESSUPLINEUPUSERCMD_CMD_FIELD.type = 14
DRESSUPLINEUPUSERCMD_CMD_FIELD.cpp_type = 8
DRESSUPLINEUPUSERCMD_PARAM_FIELD.name = "param"
DRESSUPLINEUPUSERCMD_PARAM_FIELD.full_name = ".Cmd.DressUpLineUpUserCmd.param"
DRESSUPLINEUPUSERCMD_PARAM_FIELD.number = 2
DRESSUPLINEUPUSERCMD_PARAM_FIELD.index = 1
DRESSUPLINEUPUSERCMD_PARAM_FIELD.label = 1
DRESSUPLINEUPUSERCMD_PARAM_FIELD.has_default_value = true
DRESSUPLINEUPUSERCMD_PARAM_FIELD.default_value = 149
DRESSUPLINEUPUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
DRESSUPLINEUPUSERCMD_PARAM_FIELD.type = 14
DRESSUPLINEUPUSERCMD_PARAM_FIELD.cpp_type = 8
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.name = "stageid"
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.full_name = ".Cmd.DressUpLineUpUserCmd.stageid"
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.number = 3
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.index = 2
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.label = 1
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.has_default_value = true
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.default_value = 0
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.type = 13
DRESSUPLINEUPUSERCMD_STAGEID_FIELD.cpp_type = 3
DRESSUPLINEUPUSERCMD_MODE_FIELD.name = "mode"
DRESSUPLINEUPUSERCMD_MODE_FIELD.full_name = ".Cmd.DressUpLineUpUserCmd.mode"
DRESSUPLINEUPUSERCMD_MODE_FIELD.number = 4
DRESSUPLINEUPUSERCMD_MODE_FIELD.index = 3
DRESSUPLINEUPUSERCMD_MODE_FIELD.label = 1
DRESSUPLINEUPUSERCMD_MODE_FIELD.has_default_value = true
DRESSUPLINEUPUSERCMD_MODE_FIELD.default_value = 0
DRESSUPLINEUPUSERCMD_MODE_FIELD.type = 13
DRESSUPLINEUPUSERCMD_MODE_FIELD.cpp_type = 3
DRESSUPLINEUPUSERCMD_ENTER_FIELD.name = "enter"
DRESSUPLINEUPUSERCMD_ENTER_FIELD.full_name = ".Cmd.DressUpLineUpUserCmd.enter"
DRESSUPLINEUPUSERCMD_ENTER_FIELD.number = 5
DRESSUPLINEUPUSERCMD_ENTER_FIELD.index = 4
DRESSUPLINEUPUSERCMD_ENTER_FIELD.label = 1
DRESSUPLINEUPUSERCMD_ENTER_FIELD.has_default_value = true
DRESSUPLINEUPUSERCMD_ENTER_FIELD.default_value = false
DRESSUPLINEUPUSERCMD_ENTER_FIELD.type = 8
DRESSUPLINEUPUSERCMD_ENTER_FIELD.cpp_type = 7
DRESSUPLINEUPUSERCMD.name = "DressUpLineUpUserCmd"
DRESSUPLINEUPUSERCMD.full_name = ".Cmd.DressUpLineUpUserCmd"
DRESSUPLINEUPUSERCMD.nested_types = {}
DRESSUPLINEUPUSERCMD.enum_types = {}
DRESSUPLINEUPUSERCMD.fields = {
  DRESSUPLINEUPUSERCMD_CMD_FIELD,
  DRESSUPLINEUPUSERCMD_PARAM_FIELD,
  DRESSUPLINEUPUSERCMD_STAGEID_FIELD,
  DRESSUPLINEUPUSERCMD_MODE_FIELD,
  DRESSUPLINEUPUSERCMD_ENTER_FIELD
}
DRESSUPLINEUPUSERCMD.is_extendable = false
DRESSUPLINEUPUSERCMD.extensions = {}
STAGEUSERDATATYPE_TYPE_FIELD.name = "type"
STAGEUSERDATATYPE_TYPE_FIELD.full_name = ".Cmd.StageUserDataType.type"
STAGEUSERDATATYPE_TYPE_FIELD.number = 1
STAGEUSERDATATYPE_TYPE_FIELD.index = 0
STAGEUSERDATATYPE_TYPE_FIELD.label = 1
STAGEUSERDATATYPE_TYPE_FIELD.has_default_value = true
STAGEUSERDATATYPE_TYPE_FIELD.default_value = 0
STAGEUSERDATATYPE_TYPE_FIELD.enum_type = PROTOCOMMON_PB_EUSERDATATYPE
STAGEUSERDATATYPE_TYPE_FIELD.type = 14
STAGEUSERDATATYPE_TYPE_FIELD.cpp_type = 8
STAGEUSERDATATYPE_VALUE_FIELD.name = "value"
STAGEUSERDATATYPE_VALUE_FIELD.full_name = ".Cmd.StageUserDataType.value"
STAGEUSERDATATYPE_VALUE_FIELD.number = 2
STAGEUSERDATATYPE_VALUE_FIELD.index = 1
STAGEUSERDATATYPE_VALUE_FIELD.label = 1
STAGEUSERDATATYPE_VALUE_FIELD.has_default_value = true
STAGEUSERDATATYPE_VALUE_FIELD.default_value = 0
STAGEUSERDATATYPE_VALUE_FIELD.type = 13
STAGEUSERDATATYPE_VALUE_FIELD.cpp_type = 3
STAGEUSERDATATYPE.name = "StageUserDataType"
STAGEUSERDATATYPE.full_name = ".Cmd.StageUserDataType"
STAGEUSERDATATYPE.nested_types = {}
STAGEUSERDATATYPE.enum_types = {}
STAGEUSERDATATYPE.fields = {
  STAGEUSERDATATYPE_TYPE_FIELD,
  STAGEUSERDATATYPE_VALUE_FIELD
}
STAGEUSERDATATYPE.is_extendable = false
STAGEUSERDATATYPE.extensions = {}
DRESSUPSTAGEUSERCMD_CMD_FIELD.name = "cmd"
DRESSUPSTAGEUSERCMD_CMD_FIELD.full_name = ".Cmd.DressUpStageUserCmd.cmd"
DRESSUPSTAGEUSERCMD_CMD_FIELD.number = 1
DRESSUPSTAGEUSERCMD_CMD_FIELD.index = 0
DRESSUPSTAGEUSERCMD_CMD_FIELD.label = 1
DRESSUPSTAGEUSERCMD_CMD_FIELD.has_default_value = true
DRESSUPSTAGEUSERCMD_CMD_FIELD.default_value = 9
DRESSUPSTAGEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DRESSUPSTAGEUSERCMD_CMD_FIELD.type = 14
DRESSUPSTAGEUSERCMD_CMD_FIELD.cpp_type = 8
DRESSUPSTAGEUSERCMD_PARAM_FIELD.name = "param"
DRESSUPSTAGEUSERCMD_PARAM_FIELD.full_name = ".Cmd.DressUpStageUserCmd.param"
DRESSUPSTAGEUSERCMD_PARAM_FIELD.number = 2
DRESSUPSTAGEUSERCMD_PARAM_FIELD.index = 1
DRESSUPSTAGEUSERCMD_PARAM_FIELD.label = 1
DRESSUPSTAGEUSERCMD_PARAM_FIELD.has_default_value = true
DRESSUPSTAGEUSERCMD_PARAM_FIELD.default_value = 150
DRESSUPSTAGEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
DRESSUPSTAGEUSERCMD_PARAM_FIELD.type = 14
DRESSUPSTAGEUSERCMD_PARAM_FIELD.cpp_type = 8
DRESSUPSTAGEUSERCMD_USERID_FIELD.name = "userid"
DRESSUPSTAGEUSERCMD_USERID_FIELD.full_name = ".Cmd.DressUpStageUserCmd.userid"
DRESSUPSTAGEUSERCMD_USERID_FIELD.number = 3
DRESSUPSTAGEUSERCMD_USERID_FIELD.index = 2
DRESSUPSTAGEUSERCMD_USERID_FIELD.label = 3
DRESSUPSTAGEUSERCMD_USERID_FIELD.has_default_value = false
DRESSUPSTAGEUSERCMD_USERID_FIELD.default_value = {}
DRESSUPSTAGEUSERCMD_USERID_FIELD.type = 4
DRESSUPSTAGEUSERCMD_USERID_FIELD.cpp_type = 4
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.name = "stageid"
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.full_name = ".Cmd.DressUpStageUserCmd.stageid"
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.number = 4
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.index = 3
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.label = 1
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.has_default_value = true
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.default_value = 0
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.type = 13
DRESSUPSTAGEUSERCMD_STAGEID_FIELD.cpp_type = 3
DRESSUPSTAGEUSERCMD_DATAS_FIELD.name = "datas"
DRESSUPSTAGEUSERCMD_DATAS_FIELD.full_name = ".Cmd.DressUpStageUserCmd.datas"
DRESSUPSTAGEUSERCMD_DATAS_FIELD.number = 5
DRESSUPSTAGEUSERCMD_DATAS_FIELD.index = 4
DRESSUPSTAGEUSERCMD_DATAS_FIELD.label = 3
DRESSUPSTAGEUSERCMD_DATAS_FIELD.has_default_value = false
DRESSUPSTAGEUSERCMD_DATAS_FIELD.default_value = {}
DRESSUPSTAGEUSERCMD_DATAS_FIELD.message_type = STAGEUSERDATATYPE
DRESSUPSTAGEUSERCMD_DATAS_FIELD.type = 11
DRESSUPSTAGEUSERCMD_DATAS_FIELD.cpp_type = 10
DRESSUPSTAGEUSERCMD.name = "DressUpStageUserCmd"
DRESSUPSTAGEUSERCMD.full_name = ".Cmd.DressUpStageUserCmd"
DRESSUPSTAGEUSERCMD.nested_types = {}
DRESSUPSTAGEUSERCMD.enum_types = {}
DRESSUPSTAGEUSERCMD.fields = {
  DRESSUPSTAGEUSERCMD_CMD_FIELD,
  DRESSUPSTAGEUSERCMD_PARAM_FIELD,
  DRESSUPSTAGEUSERCMD_USERID_FIELD,
  DRESSUPSTAGEUSERCMD_STAGEID_FIELD,
  DRESSUPSTAGEUSERCMD_DATAS_FIELD
}
DRESSUPSTAGEUSERCMD.is_extendable = false
DRESSUPSTAGEUSERCMD.extensions = {}
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.name = "cmd"
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.full_name = ".Cmd.GoToFunctionMapUserCmd.cmd"
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.number = 1
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.index = 0
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.label = 1
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.has_default_value = true
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.default_value = 9
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.type = 14
GOTOFUNCTIONMAPUSERCMD_CMD_FIELD.cpp_type = 8
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.name = "param"
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.full_name = ".Cmd.GoToFunctionMapUserCmd.param"
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.number = 2
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.index = 1
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.label = 1
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.has_default_value = true
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.default_value = 141
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.type = 14
GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD.cpp_type = 8
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.name = "etype"
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.full_name = ".Cmd.GoToFunctionMapUserCmd.etype"
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.number = 3
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.index = 2
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.label = 2
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.has_default_value = false
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.default_value = nil
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.enum_type = EFUNCMAPTYPE
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.type = 14
GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD.cpp_type = 8
GOTOFUNCTIONMAPUSERCMD.name = "GoToFunctionMapUserCmd"
GOTOFUNCTIONMAPUSERCMD.full_name = ".Cmd.GoToFunctionMapUserCmd"
GOTOFUNCTIONMAPUSERCMD.nested_types = {}
GOTOFUNCTIONMAPUSERCMD.enum_types = {}
GOTOFUNCTIONMAPUSERCMD.fields = {
  GOTOFUNCTIONMAPUSERCMD_CMD_FIELD,
  GOTOFUNCTIONMAPUSERCMD_PARAM_FIELD,
  GOTOFUNCTIONMAPUSERCMD_ETYPE_FIELD
}
GOTOFUNCTIONMAPUSERCMD.is_extendable = false
GOTOFUNCTIONMAPUSERCMD.extensions = {}
GROWTHCURINFO_TYPE_FIELD.name = "type"
GROWTHCURINFO_TYPE_FIELD.full_name = ".Cmd.GrowthCurInfo.type"
GROWTHCURINFO_TYPE_FIELD.number = 1
GROWTHCURINFO_TYPE_FIELD.index = 0
GROWTHCURINFO_TYPE_FIELD.label = 1
GROWTHCURINFO_TYPE_FIELD.has_default_value = true
GROWTHCURINFO_TYPE_FIELD.default_value = 1
GROWTHCURINFO_TYPE_FIELD.enum_type = EGROWTHTYPE
GROWTHCURINFO_TYPE_FIELD.type = 14
GROWTHCURINFO_TYPE_FIELD.cpp_type = 8
GROWTHCURINFO_GROUPID_FIELD.name = "groupid"
GROWTHCURINFO_GROUPID_FIELD.full_name = ".Cmd.GrowthCurInfo.groupid"
GROWTHCURINFO_GROUPID_FIELD.number = 2
GROWTHCURINFO_GROUPID_FIELD.index = 1
GROWTHCURINFO_GROUPID_FIELD.label = 1
GROWTHCURINFO_GROUPID_FIELD.has_default_value = true
GROWTHCURINFO_GROUPID_FIELD.default_value = 0
GROWTHCURINFO_GROUPID_FIELD.type = 13
GROWTHCURINFO_GROUPID_FIELD.cpp_type = 3
GROWTHCURINFO.name = "GrowthCurInfo"
GROWTHCURINFO.full_name = ".Cmd.GrowthCurInfo"
GROWTHCURINFO.nested_types = {}
GROWTHCURINFO.enum_types = {}
GROWTHCURINFO.fields = {
  GROWTHCURINFO_TYPE_FIELD,
  GROWTHCURINFO_GROUPID_FIELD
}
GROWTHCURINFO.is_extendable = false
GROWTHCURINFO.extensions = {}
GROWTHITEMINFO_DWID_FIELD.name = "dwid"
GROWTHITEMINFO_DWID_FIELD.full_name = ".Cmd.GrowthItemInfo.dwid"
GROWTHITEMINFO_DWID_FIELD.number = 1
GROWTHITEMINFO_DWID_FIELD.index = 0
GROWTHITEMINFO_DWID_FIELD.label = 1
GROWTHITEMINFO_DWID_FIELD.has_default_value = true
GROWTHITEMINFO_DWID_FIELD.default_value = 0
GROWTHITEMINFO_DWID_FIELD.type = 13
GROWTHITEMINFO_DWID_FIELD.cpp_type = 3
GROWTHITEMINFO_FINISHTIMES_FIELD.name = "finishtimes"
GROWTHITEMINFO_FINISHTIMES_FIELD.full_name = ".Cmd.GrowthItemInfo.finishtimes"
GROWTHITEMINFO_FINISHTIMES_FIELD.number = 2
GROWTHITEMINFO_FINISHTIMES_FIELD.index = 1
GROWTHITEMINFO_FINISHTIMES_FIELD.label = 1
GROWTHITEMINFO_FINISHTIMES_FIELD.has_default_value = true
GROWTHITEMINFO_FINISHTIMES_FIELD.default_value = 0
GROWTHITEMINFO_FINISHTIMES_FIELD.type = 13
GROWTHITEMINFO_FINISHTIMES_FIELD.cpp_type = 3
GROWTHITEMINFO_STATUS_FIELD.name = "status"
GROWTHITEMINFO_STATUS_FIELD.full_name = ".Cmd.GrowthItemInfo.status"
GROWTHITEMINFO_STATUS_FIELD.number = 3
GROWTHITEMINFO_STATUS_FIELD.index = 2
GROWTHITEMINFO_STATUS_FIELD.label = 1
GROWTHITEMINFO_STATUS_FIELD.has_default_value = true
GROWTHITEMINFO_STATUS_FIELD.default_value = 0
GROWTHITEMINFO_STATUS_FIELD.enum_type = EGROWTHSTATUS
GROWTHITEMINFO_STATUS_FIELD.type = 14
GROWTHITEMINFO_STATUS_FIELD.cpp_type = 8
GROWTHITEMINFO.name = "GrowthItemInfo"
GROWTHITEMINFO.full_name = ".Cmd.GrowthItemInfo"
GROWTHITEMINFO.nested_types = {}
GROWTHITEMINFO.enum_types = {}
GROWTHITEMINFO.fields = {
  GROWTHITEMINFO_DWID_FIELD,
  GROWTHITEMINFO_FINISHTIMES_FIELD,
  GROWTHITEMINFO_STATUS_FIELD
}
GROWTHITEMINFO.is_extendable = false
GROWTHITEMINFO.extensions = {}
GROWTHVALUEINFO_GROUPID_FIELD.name = "groupid"
GROWTHVALUEINFO_GROUPID_FIELD.full_name = ".Cmd.GrowthValueInfo.groupid"
GROWTHVALUEINFO_GROUPID_FIELD.number = 1
GROWTHVALUEINFO_GROUPID_FIELD.index = 0
GROWTHVALUEINFO_GROUPID_FIELD.label = 1
GROWTHVALUEINFO_GROUPID_FIELD.has_default_value = true
GROWTHVALUEINFO_GROUPID_FIELD.default_value = 0
GROWTHVALUEINFO_GROUPID_FIELD.type = 13
GROWTHVALUEINFO_GROUPID_FIELD.cpp_type = 3
GROWTHVALUEINFO_GROWTH_FIELD.name = "growth"
GROWTHVALUEINFO_GROWTH_FIELD.full_name = ".Cmd.GrowthValueInfo.growth"
GROWTHVALUEINFO_GROWTH_FIELD.number = 2
GROWTHVALUEINFO_GROWTH_FIELD.index = 1
GROWTHVALUEINFO_GROWTH_FIELD.label = 1
GROWTHVALUEINFO_GROWTH_FIELD.has_default_value = true
GROWTHVALUEINFO_GROWTH_FIELD.default_value = 0
GROWTHVALUEINFO_GROWTH_FIELD.type = 13
GROWTHVALUEINFO_GROWTH_FIELD.cpp_type = 3
GROWTHVALUEINFO_EVERREWARD_FIELD.name = "everreward"
GROWTHVALUEINFO_EVERREWARD_FIELD.full_name = ".Cmd.GrowthValueInfo.everreward"
GROWTHVALUEINFO_EVERREWARD_FIELD.number = 3
GROWTHVALUEINFO_EVERREWARD_FIELD.index = 2
GROWTHVALUEINFO_EVERREWARD_FIELD.label = 3
GROWTHVALUEINFO_EVERREWARD_FIELD.has_default_value = false
GROWTHVALUEINFO_EVERREWARD_FIELD.default_value = {}
GROWTHVALUEINFO_EVERREWARD_FIELD.type = 13
GROWTHVALUEINFO_EVERREWARD_FIELD.cpp_type = 3
GROWTHVALUEINFO.name = "GrowthValueInfo"
GROWTHVALUEINFO.full_name = ".Cmd.GrowthValueInfo"
GROWTHVALUEINFO.nested_types = {}
GROWTHVALUEINFO.enum_types = {}
GROWTHVALUEINFO.fields = {
  GROWTHVALUEINFO_GROUPID_FIELD,
  GROWTHVALUEINFO_GROWTH_FIELD,
  GROWTHVALUEINFO_EVERREWARD_FIELD
}
GROWTHVALUEINFO.is_extendable = false
GROWTHVALUEINFO.extensions = {}
GROWTHGROUPINFO_ITEMS_FIELD.name = "items"
GROWTHGROUPINFO_ITEMS_FIELD.full_name = ".Cmd.GrowthGroupInfo.items"
GROWTHGROUPINFO_ITEMS_FIELD.number = 1
GROWTHGROUPINFO_ITEMS_FIELD.index = 0
GROWTHGROUPINFO_ITEMS_FIELD.label = 3
GROWTHGROUPINFO_ITEMS_FIELD.has_default_value = false
GROWTHGROUPINFO_ITEMS_FIELD.default_value = {}
GROWTHGROUPINFO_ITEMS_FIELD.message_type = GROWTHITEMINFO
GROWTHGROUPINFO_ITEMS_FIELD.type = 11
GROWTHGROUPINFO_ITEMS_FIELD.cpp_type = 10
GROWTHGROUPINFO_VALUEITEMS_FIELD.name = "valueitems"
GROWTHGROUPINFO_VALUEITEMS_FIELD.full_name = ".Cmd.GrowthGroupInfo.valueitems"
GROWTHGROUPINFO_VALUEITEMS_FIELD.number = 2
GROWTHGROUPINFO_VALUEITEMS_FIELD.index = 1
GROWTHGROUPINFO_VALUEITEMS_FIELD.label = 1
GROWTHGROUPINFO_VALUEITEMS_FIELD.has_default_value = false
GROWTHGROUPINFO_VALUEITEMS_FIELD.default_value = nil
GROWTHGROUPINFO_VALUEITEMS_FIELD.message_type = GROWTHVALUEINFO
GROWTHGROUPINFO_VALUEITEMS_FIELD.type = 11
GROWTHGROUPINFO_VALUEITEMS_FIELD.cpp_type = 10
GROWTHGROUPINFO.name = "GrowthGroupInfo"
GROWTHGROUPINFO.full_name = ".Cmd.GrowthGroupInfo"
GROWTHGROUPINFO.nested_types = {}
GROWTHGROUPINFO.enum_types = {}
GROWTHGROUPINFO.fields = {
  GROWTHGROUPINFO_ITEMS_FIELD,
  GROWTHGROUPINFO_VALUEITEMS_FIELD
}
GROWTHGROUPINFO.is_extendable = false
GROWTHGROUPINFO.extensions = {}
GROWTHSERVANTUSERCMD_CMD_FIELD.name = "cmd"
GROWTHSERVANTUSERCMD_CMD_FIELD.full_name = ".Cmd.GrowthServantUserCmd.cmd"
GROWTHSERVANTUSERCMD_CMD_FIELD.number = 1
GROWTHSERVANTUSERCMD_CMD_FIELD.index = 0
GROWTHSERVANTUSERCMD_CMD_FIELD.label = 1
GROWTHSERVANTUSERCMD_CMD_FIELD.has_default_value = true
GROWTHSERVANTUSERCMD_CMD_FIELD.default_value = 9
GROWTHSERVANTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GROWTHSERVANTUSERCMD_CMD_FIELD.type = 14
GROWTHSERVANTUSERCMD_CMD_FIELD.cpp_type = 8
GROWTHSERVANTUSERCMD_PARAM_FIELD.name = "param"
GROWTHSERVANTUSERCMD_PARAM_FIELD.full_name = ".Cmd.GrowthServantUserCmd.param"
GROWTHSERVANTUSERCMD_PARAM_FIELD.number = 2
GROWTHSERVANTUSERCMD_PARAM_FIELD.index = 1
GROWTHSERVANTUSERCMD_PARAM_FIELD.label = 1
GROWTHSERVANTUSERCMD_PARAM_FIELD.has_default_value = true
GROWTHSERVANTUSERCMD_PARAM_FIELD.default_value = 154
GROWTHSERVANTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
GROWTHSERVANTUSERCMD_PARAM_FIELD.type = 14
GROWTHSERVANTUSERCMD_PARAM_FIELD.cpp_type = 8
GROWTHSERVANTUSERCMD_DATAS_FIELD.name = "datas"
GROWTHSERVANTUSERCMD_DATAS_FIELD.full_name = ".Cmd.GrowthServantUserCmd.datas"
GROWTHSERVANTUSERCMD_DATAS_FIELD.number = 3
GROWTHSERVANTUSERCMD_DATAS_FIELD.index = 2
GROWTHSERVANTUSERCMD_DATAS_FIELD.label = 3
GROWTHSERVANTUSERCMD_DATAS_FIELD.has_default_value = false
GROWTHSERVANTUSERCMD_DATAS_FIELD.default_value = {}
GROWTHSERVANTUSERCMD_DATAS_FIELD.message_type = GROWTHGROUPINFO
GROWTHSERVANTUSERCMD_DATAS_FIELD.type = 11
GROWTHSERVANTUSERCMD_DATAS_FIELD.cpp_type = 10
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.name = "unlockitems"
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.full_name = ".Cmd.GrowthServantUserCmd.unlockitems"
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.number = 4
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.index = 3
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.label = 3
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.has_default_value = false
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.default_value = {}
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.type = 13
GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD.cpp_type = 3
GROWTHSERVANTUSERCMD.name = "GrowthServantUserCmd"
GROWTHSERVANTUSERCMD.full_name = ".Cmd.GrowthServantUserCmd"
GROWTHSERVANTUSERCMD.nested_types = {}
GROWTHSERVANTUSERCMD.enum_types = {}
GROWTHSERVANTUSERCMD.fields = {
  GROWTHSERVANTUSERCMD_CMD_FIELD,
  GROWTHSERVANTUSERCMD_PARAM_FIELD,
  GROWTHSERVANTUSERCMD_DATAS_FIELD,
  GROWTHSERVANTUSERCMD_UNLOCKITEMS_FIELD
}
GROWTHSERVANTUSERCMD.is_extendable = false
GROWTHSERVANTUSERCMD.extensions = {}
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.name = "cmd"
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.full_name = ".Cmd.ReceiveGrowthServantUserCmd.cmd"
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.number = 1
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.index = 0
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.label = 1
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.has_default_value = true
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.default_value = 9
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.type = 14
RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD.cpp_type = 8
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.name = "param"
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.full_name = ".Cmd.ReceiveGrowthServantUserCmd.param"
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.number = 2
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.index = 1
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.label = 1
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.has_default_value = true
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.default_value = 155
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.type = 14
RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD.cpp_type = 8
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.name = "dwid"
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.full_name = ".Cmd.ReceiveGrowthServantUserCmd.dwid"
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.number = 3
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.index = 2
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.label = 1
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.has_default_value = true
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.default_value = 0
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.type = 13
RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD.cpp_type = 3
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.name = "dwvalue"
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.full_name = ".Cmd.ReceiveGrowthServantUserCmd.dwvalue"
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.number = 4
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.index = 3
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.label = 1
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.has_default_value = true
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.default_value = 0
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.type = 13
RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD.cpp_type = 3
RECEIVEGROWTHSERVANTUSERCMD.name = "ReceiveGrowthServantUserCmd"
RECEIVEGROWTHSERVANTUSERCMD.full_name = ".Cmd.ReceiveGrowthServantUserCmd"
RECEIVEGROWTHSERVANTUSERCMD.nested_types = {}
RECEIVEGROWTHSERVANTUSERCMD.enum_types = {}
RECEIVEGROWTHSERVANTUSERCMD.fields = {
  RECEIVEGROWTHSERVANTUSERCMD_CMD_FIELD,
  RECEIVEGROWTHSERVANTUSERCMD_PARAM_FIELD,
  RECEIVEGROWTHSERVANTUSERCMD_DWID_FIELD,
  RECEIVEGROWTHSERVANTUSERCMD_DWVALUE_FIELD
}
RECEIVEGROWTHSERVANTUSERCMD.is_extendable = false
RECEIVEGROWTHSERVANTUSERCMD.extensions = {}
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.name = "cmd"
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.full_name = ".Cmd.GrowthOpenServantUserCmd.cmd"
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.number = 1
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.index = 0
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.label = 1
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.has_default_value = true
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.default_value = 9
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.type = 14
GROWTHOPENSERVANTUSERCMD_CMD_FIELD.cpp_type = 8
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.name = "param"
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.full_name = ".Cmd.GrowthOpenServantUserCmd.param"
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.number = 2
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.index = 1
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.label = 1
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.has_default_value = true
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.default_value = 156
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.type = 14
GROWTHOPENSERVANTUSERCMD_PARAM_FIELD.cpp_type = 8
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.name = "groupid"
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.full_name = ".Cmd.GrowthOpenServantUserCmd.groupid"
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.number = 3
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.index = 2
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.label = 1
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.has_default_value = true
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.default_value = 0
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.type = 13
GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD.cpp_type = 3
GROWTHOPENSERVANTUSERCMD.name = "GrowthOpenServantUserCmd"
GROWTHOPENSERVANTUSERCMD.full_name = ".Cmd.GrowthOpenServantUserCmd"
GROWTHOPENSERVANTUSERCMD.nested_types = {}
GROWTHOPENSERVANTUSERCMD.enum_types = {}
GROWTHOPENSERVANTUSERCMD.fields = {
  GROWTHOPENSERVANTUSERCMD_CMD_FIELD,
  GROWTHOPENSERVANTUSERCMD_PARAM_FIELD,
  GROWTHOPENSERVANTUSERCMD_GROUPID_FIELD
}
GROWTHOPENSERVANTUSERCMD.is_extendable = false
GROWTHOPENSERVANTUSERCMD.extensions = {}
CHEATTAGUSERCMD_CMD_FIELD.name = "cmd"
CHEATTAGUSERCMD_CMD_FIELD.full_name = ".Cmd.CheatTagUserCmd.cmd"
CHEATTAGUSERCMD_CMD_FIELD.number = 1
CHEATTAGUSERCMD_CMD_FIELD.index = 0
CHEATTAGUSERCMD_CMD_FIELD.label = 1
CHEATTAGUSERCMD_CMD_FIELD.has_default_value = true
CHEATTAGUSERCMD_CMD_FIELD.default_value = 9
CHEATTAGUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHEATTAGUSERCMD_CMD_FIELD.type = 14
CHEATTAGUSERCMD_CMD_FIELD.cpp_type = 8
CHEATTAGUSERCMD_PARAM_FIELD.name = "param"
CHEATTAGUSERCMD_PARAM_FIELD.full_name = ".Cmd.CheatTagUserCmd.param"
CHEATTAGUSERCMD_PARAM_FIELD.number = 2
CHEATTAGUSERCMD_PARAM_FIELD.index = 1
CHEATTAGUSERCMD_PARAM_FIELD.label = 1
CHEATTAGUSERCMD_PARAM_FIELD.has_default_value = true
CHEATTAGUSERCMD_PARAM_FIELD.default_value = 157
CHEATTAGUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CHEATTAGUSERCMD_PARAM_FIELD.type = 14
CHEATTAGUSERCMD_PARAM_FIELD.cpp_type = 8
CHEATTAGUSERCMD_INTERVAL_FIELD.name = "interval"
CHEATTAGUSERCMD_INTERVAL_FIELD.full_name = ".Cmd.CheatTagUserCmd.interval"
CHEATTAGUSERCMD_INTERVAL_FIELD.number = 3
CHEATTAGUSERCMD_INTERVAL_FIELD.index = 2
CHEATTAGUSERCMD_INTERVAL_FIELD.label = 1
CHEATTAGUSERCMD_INTERVAL_FIELD.has_default_value = true
CHEATTAGUSERCMD_INTERVAL_FIELD.default_value = 0
CHEATTAGUSERCMD_INTERVAL_FIELD.type = 13
CHEATTAGUSERCMD_INTERVAL_FIELD.cpp_type = 3
CHEATTAGUSERCMD_FRAME_FIELD.name = "frame"
CHEATTAGUSERCMD_FRAME_FIELD.full_name = ".Cmd.CheatTagUserCmd.frame"
CHEATTAGUSERCMD_FRAME_FIELD.number = 4
CHEATTAGUSERCMD_FRAME_FIELD.index = 3
CHEATTAGUSERCMD_FRAME_FIELD.label = 1
CHEATTAGUSERCMD_FRAME_FIELD.has_default_value = true
CHEATTAGUSERCMD_FRAME_FIELD.default_value = 0
CHEATTAGUSERCMD_FRAME_FIELD.type = 13
CHEATTAGUSERCMD_FRAME_FIELD.cpp_type = 3
CHEATTAGUSERCMD.name = "CheatTagUserCmd"
CHEATTAGUSERCMD.full_name = ".Cmd.CheatTagUserCmd"
CHEATTAGUSERCMD.nested_types = {}
CHEATTAGUSERCMD.enum_types = {}
CHEATTAGUSERCMD.fields = {
  CHEATTAGUSERCMD_CMD_FIELD,
  CHEATTAGUSERCMD_PARAM_FIELD,
  CHEATTAGUSERCMD_INTERVAL_FIELD,
  CHEATTAGUSERCMD_FRAME_FIELD
}
CHEATTAGUSERCMD.is_extendable = false
CHEATTAGUSERCMD.extensions = {}
BUTTONTHRESHOLD_BUTTON_FIELD.name = "button"
BUTTONTHRESHOLD_BUTTON_FIELD.full_name = ".Cmd.ButtonThreshold.button"
BUTTONTHRESHOLD_BUTTON_FIELD.number = 1
BUTTONTHRESHOLD_BUTTON_FIELD.index = 0
BUTTONTHRESHOLD_BUTTON_FIELD.label = 1
BUTTONTHRESHOLD_BUTTON_FIELD.has_default_value = true
BUTTONTHRESHOLD_BUTTON_FIELD.default_value = 0
BUTTONTHRESHOLD_BUTTON_FIELD.enum_type = EMONITORBUTTON
BUTTONTHRESHOLD_BUTTON_FIELD.type = 14
BUTTONTHRESHOLD_BUTTON_FIELD.cpp_type = 8
BUTTONTHRESHOLD_THRESHOLD_FIELD.name = "threshold"
BUTTONTHRESHOLD_THRESHOLD_FIELD.full_name = ".Cmd.ButtonThreshold.threshold"
BUTTONTHRESHOLD_THRESHOLD_FIELD.number = 2
BUTTONTHRESHOLD_THRESHOLD_FIELD.index = 1
BUTTONTHRESHOLD_THRESHOLD_FIELD.label = 1
BUTTONTHRESHOLD_THRESHOLD_FIELD.has_default_value = true
BUTTONTHRESHOLD_THRESHOLD_FIELD.default_value = 0
BUTTONTHRESHOLD_THRESHOLD_FIELD.type = 13
BUTTONTHRESHOLD_THRESHOLD_FIELD.cpp_type = 3
BUTTONTHRESHOLD.name = "ButtonThreshold"
BUTTONTHRESHOLD.full_name = ".Cmd.ButtonThreshold"
BUTTONTHRESHOLD.nested_types = {}
BUTTONTHRESHOLD.enum_types = {}
BUTTONTHRESHOLD.fields = {
  BUTTONTHRESHOLD_BUTTON_FIELD,
  BUTTONTHRESHOLD_THRESHOLD_FIELD
}
BUTTONTHRESHOLD.is_extendable = false
BUTTONTHRESHOLD.extensions = {}
CHEATTAGSTATUSERCMD_CMD_FIELD.name = "cmd"
CHEATTAGSTATUSERCMD_CMD_FIELD.full_name = ".Cmd.CheatTagStatUserCmd.cmd"
CHEATTAGSTATUSERCMD_CMD_FIELD.number = 1
CHEATTAGSTATUSERCMD_CMD_FIELD.index = 0
CHEATTAGSTATUSERCMD_CMD_FIELD.label = 1
CHEATTAGSTATUSERCMD_CMD_FIELD.has_default_value = true
CHEATTAGSTATUSERCMD_CMD_FIELD.default_value = 9
CHEATTAGSTATUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHEATTAGSTATUSERCMD_CMD_FIELD.type = 14
CHEATTAGSTATUSERCMD_CMD_FIELD.cpp_type = 8
CHEATTAGSTATUSERCMD_PARAM_FIELD.name = "param"
CHEATTAGSTATUSERCMD_PARAM_FIELD.full_name = ".Cmd.CheatTagStatUserCmd.param"
CHEATTAGSTATUSERCMD_PARAM_FIELD.number = 2
CHEATTAGSTATUSERCMD_PARAM_FIELD.index = 1
CHEATTAGSTATUSERCMD_PARAM_FIELD.label = 1
CHEATTAGSTATUSERCMD_PARAM_FIELD.has_default_value = true
CHEATTAGSTATUSERCMD_PARAM_FIELD.default_value = 158
CHEATTAGSTATUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
CHEATTAGSTATUSERCMD_PARAM_FIELD.type = 14
CHEATTAGSTATUSERCMD_PARAM_FIELD.cpp_type = 8
CHEATTAGSTATUSERCMD_CHEATED_FIELD.name = "cheated"
CHEATTAGSTATUSERCMD_CHEATED_FIELD.full_name = ".Cmd.CheatTagStatUserCmd.cheated"
CHEATTAGSTATUSERCMD_CHEATED_FIELD.number = 3
CHEATTAGSTATUSERCMD_CHEATED_FIELD.index = 2
CHEATTAGSTATUSERCMD_CHEATED_FIELD.label = 1
CHEATTAGSTATUSERCMD_CHEATED_FIELD.has_default_value = true
CHEATTAGSTATUSERCMD_CHEATED_FIELD.default_value = false
CHEATTAGSTATUSERCMD_CHEATED_FIELD.type = 8
CHEATTAGSTATUSERCMD_CHEATED_FIELD.cpp_type = 7
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.name = "clickmvpthreshold"
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.full_name = ".Cmd.CheatTagStatUserCmd.clickmvpthreshold"
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.number = 4
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.index = 3
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.label = 1
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.has_default_value = true
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.default_value = 0
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.type = 13
CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD.cpp_type = 3
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.name = "buttonthreshold"
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.full_name = ".Cmd.CheatTagStatUserCmd.buttonthreshold"
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.number = 5
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.index = 4
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.label = 3
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.has_default_value = false
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.default_value = {}
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.message_type = BUTTONTHRESHOLD
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.type = 11
CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD.cpp_type = 10
CHEATTAGSTATUSERCMD.name = "CheatTagStatUserCmd"
CHEATTAGSTATUSERCMD.full_name = ".Cmd.CheatTagStatUserCmd"
CHEATTAGSTATUSERCMD.nested_types = {}
CHEATTAGSTATUSERCMD.enum_types = {}
CHEATTAGSTATUSERCMD.fields = {
  CHEATTAGSTATUSERCMD_CMD_FIELD,
  CHEATTAGSTATUSERCMD_PARAM_FIELD,
  CHEATTAGSTATUSERCMD_CHEATED_FIELD,
  CHEATTAGSTATUSERCMD_CLICKMVPTHRESHOLD_FIELD,
  CHEATTAGSTATUSERCMD_BUTTONTHRESHOLD_FIELD
}
CHEATTAGSTATUSERCMD.is_extendable = false
CHEATTAGSTATUSERCMD.extensions = {}
CLICKPOSLIST_CMD_FIELD.name = "cmd"
CLICKPOSLIST_CMD_FIELD.full_name = ".Cmd.ClickPosList.cmd"
CLICKPOSLIST_CMD_FIELD.number = 1
CLICKPOSLIST_CMD_FIELD.index = 0
CLICKPOSLIST_CMD_FIELD.label = 1
CLICKPOSLIST_CMD_FIELD.has_default_value = true
CLICKPOSLIST_CMD_FIELD.default_value = 9
CLICKPOSLIST_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CLICKPOSLIST_CMD_FIELD.type = 14
CLICKPOSLIST_CMD_FIELD.cpp_type = 8
CLICKPOSLIST_PARAM_FIELD.name = "param"
CLICKPOSLIST_PARAM_FIELD.full_name = ".Cmd.ClickPosList.param"
CLICKPOSLIST_PARAM_FIELD.number = 2
CLICKPOSLIST_PARAM_FIELD.index = 1
CLICKPOSLIST_PARAM_FIELD.label = 1
CLICKPOSLIST_PARAM_FIELD.has_default_value = true
CLICKPOSLIST_PARAM_FIELD.default_value = 159
CLICKPOSLIST_PARAM_FIELD.enum_type = USER2PARAM
CLICKPOSLIST_PARAM_FIELD.type = 14
CLICKPOSLIST_PARAM_FIELD.cpp_type = 8
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.name = "clickbuttonpos"
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.full_name = ".Cmd.ClickPosList.clickbuttonpos"
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.number = 3
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.index = 2
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.label = 3
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.has_default_value = false
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.default_value = {}
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.message_type = _CLICKBUTTONPOS
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.type = 11
CLICKPOSLIST_CLICKBUTTONPOS_FIELD.cpp_type = 10
CLICKPOSLIST.name = "ClickPosList"
CLICKPOSLIST.full_name = ".Cmd.ClickPosList"
CLICKPOSLIST.nested_types = {}
CLICKPOSLIST.enum_types = {}
CLICKPOSLIST.fields = {
  CLICKPOSLIST_CMD_FIELD,
  CLICKPOSLIST_PARAM_FIELD,
  CLICKPOSLIST_CLICKBUTTONPOS_FIELD
}
CLICKPOSLIST.is_extendable = false
CLICKPOSLIST.extensions = {}
CLICKBUTTONPOS_BUTTON_FIELD.name = "button"
CLICKBUTTONPOS_BUTTON_FIELD.full_name = ".Cmd.ClickButtonPos.button"
CLICKBUTTONPOS_BUTTON_FIELD.number = 1
CLICKBUTTONPOS_BUTTON_FIELD.index = 0
CLICKBUTTONPOS_BUTTON_FIELD.label = 1
CLICKBUTTONPOS_BUTTON_FIELD.has_default_value = false
CLICKBUTTONPOS_BUTTON_FIELD.default_value = nil
CLICKBUTTONPOS_BUTTON_FIELD.enum_type = EMONITORBUTTON
CLICKBUTTONPOS_BUTTON_FIELD.type = 14
CLICKBUTTONPOS_BUTTON_FIELD.cpp_type = 8
CLICKBUTTONPOS_POS_FIELD.name = "pos"
CLICKBUTTONPOS_POS_FIELD.full_name = ".Cmd.ClickButtonPos.pos"
CLICKBUTTONPOS_POS_FIELD.number = 2
CLICKBUTTONPOS_POS_FIELD.index = 1
CLICKBUTTONPOS_POS_FIELD.label = 1
CLICKBUTTONPOS_POS_FIELD.has_default_value = false
CLICKBUTTONPOS_POS_FIELD.default_value = 0
CLICKBUTTONPOS_POS_FIELD.type = 13
CLICKBUTTONPOS_POS_FIELD.cpp_type = 3
CLICKBUTTONPOS_COUNT_FIELD.name = "count"
CLICKBUTTONPOS_COUNT_FIELD.full_name = ".Cmd.ClickButtonPos.count"
CLICKBUTTONPOS_COUNT_FIELD.number = 3
CLICKBUTTONPOS_COUNT_FIELD.index = 2
CLICKBUTTONPOS_COUNT_FIELD.label = 1
CLICKBUTTONPOS_COUNT_FIELD.has_default_value = true
CLICKBUTTONPOS_COUNT_FIELD.default_value = 0
CLICKBUTTONPOS_COUNT_FIELD.type = 13
CLICKBUTTONPOS_COUNT_FIELD.cpp_type = 3
CLICKBUTTONPOS.name = "ClickButtonPos"
CLICKBUTTONPOS.full_name = ".Cmd.ClickButtonPos"
CLICKBUTTONPOS.nested_types = {}
CLICKBUTTONPOS.enum_types = {}
CLICKBUTTONPOS.fields = {
  CLICKBUTTONPOS_BUTTON_FIELD,
  CLICKBUTTONPOS_POS_FIELD,
  CLICKBUTTONPOS_COUNT_FIELD
}
CLICKBUTTONPOS.is_extendable = false
CLICKBUTTONPOS.extensions = {}
SIGNINUSERCMD_CMD_FIELD.name = "cmd"
SIGNINUSERCMD_CMD_FIELD.full_name = ".Cmd.SignInUserCmd.cmd"
SIGNINUSERCMD_CMD_FIELD.number = 1
SIGNINUSERCMD_CMD_FIELD.index = 0
SIGNINUSERCMD_CMD_FIELD.label = 1
SIGNINUSERCMD_CMD_FIELD.has_default_value = true
SIGNINUSERCMD_CMD_FIELD.default_value = 9
SIGNINUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SIGNINUSERCMD_CMD_FIELD.type = 14
SIGNINUSERCMD_CMD_FIELD.cpp_type = 8
SIGNINUSERCMD_PARAM_FIELD.name = "param"
SIGNINUSERCMD_PARAM_FIELD.full_name = ".Cmd.SignInUserCmd.param"
SIGNINUSERCMD_PARAM_FIELD.number = 2
SIGNINUSERCMD_PARAM_FIELD.index = 1
SIGNINUSERCMD_PARAM_FIELD.label = 1
SIGNINUSERCMD_PARAM_FIELD.has_default_value = true
SIGNINUSERCMD_PARAM_FIELD.default_value = 164
SIGNINUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SIGNINUSERCMD_PARAM_FIELD.type = 14
SIGNINUSERCMD_PARAM_FIELD.cpp_type = 8
SIGNINUSERCMD_SUCCESS_FIELD.name = "success"
SIGNINUSERCMD_SUCCESS_FIELD.full_name = ".Cmd.SignInUserCmd.success"
SIGNINUSERCMD_SUCCESS_FIELD.number = 3
SIGNINUSERCMD_SUCCESS_FIELD.index = 2
SIGNINUSERCMD_SUCCESS_FIELD.label = 1
SIGNINUSERCMD_SUCCESS_FIELD.has_default_value = true
SIGNINUSERCMD_SUCCESS_FIELD.default_value = false
SIGNINUSERCMD_SUCCESS_FIELD.type = 8
SIGNINUSERCMD_SUCCESS_FIELD.cpp_type = 7
SIGNINUSERCMD.name = "SignInUserCmd"
SIGNINUSERCMD.full_name = ".Cmd.SignInUserCmd"
SIGNINUSERCMD.nested_types = {}
SIGNINUSERCMD.enum_types = {}
SIGNINUSERCMD.fields = {
  SIGNINUSERCMD_CMD_FIELD,
  SIGNINUSERCMD_PARAM_FIELD,
  SIGNINUSERCMD_SUCCESS_FIELD
}
SIGNINUSERCMD.is_extendable = false
SIGNINUSERCMD.extensions = {}
SIGNINNTFUSERCMD_CMD_FIELD.name = "cmd"
SIGNINNTFUSERCMD_CMD_FIELD.full_name = ".Cmd.SignInNtfUserCmd.cmd"
SIGNINNTFUSERCMD_CMD_FIELD.number = 1
SIGNINNTFUSERCMD_CMD_FIELD.index = 0
SIGNINNTFUSERCMD_CMD_FIELD.label = 1
SIGNINNTFUSERCMD_CMD_FIELD.has_default_value = true
SIGNINNTFUSERCMD_CMD_FIELD.default_value = 9
SIGNINNTFUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SIGNINNTFUSERCMD_CMD_FIELD.type = 14
SIGNINNTFUSERCMD_CMD_FIELD.cpp_type = 8
SIGNINNTFUSERCMD_PARAM_FIELD.name = "param"
SIGNINNTFUSERCMD_PARAM_FIELD.full_name = ".Cmd.SignInNtfUserCmd.param"
SIGNINNTFUSERCMD_PARAM_FIELD.number = 2
SIGNINNTFUSERCMD_PARAM_FIELD.index = 1
SIGNINNTFUSERCMD_PARAM_FIELD.label = 1
SIGNINNTFUSERCMD_PARAM_FIELD.has_default_value = true
SIGNINNTFUSERCMD_PARAM_FIELD.default_value = 165
SIGNINNTFUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SIGNINNTFUSERCMD_PARAM_FIELD.type = 14
SIGNINNTFUSERCMD_PARAM_FIELD.cpp_type = 8
SIGNINNTFUSERCMD_COUNT_FIELD.name = "count"
SIGNINNTFUSERCMD_COUNT_FIELD.full_name = ".Cmd.SignInNtfUserCmd.count"
SIGNINNTFUSERCMD_COUNT_FIELD.number = 3
SIGNINNTFUSERCMD_COUNT_FIELD.index = 2
SIGNINNTFUSERCMD_COUNT_FIELD.label = 1
SIGNINNTFUSERCMD_COUNT_FIELD.has_default_value = true
SIGNINNTFUSERCMD_COUNT_FIELD.default_value = 0
SIGNINNTFUSERCMD_COUNT_FIELD.type = 13
SIGNINNTFUSERCMD_COUNT_FIELD.cpp_type = 3
SIGNINNTFUSERCMD_ISSIGN_FIELD.name = "issign"
SIGNINNTFUSERCMD_ISSIGN_FIELD.full_name = ".Cmd.SignInNtfUserCmd.issign"
SIGNINNTFUSERCMD_ISSIGN_FIELD.number = 4
SIGNINNTFUSERCMD_ISSIGN_FIELD.index = 3
SIGNINNTFUSERCMD_ISSIGN_FIELD.label = 1
SIGNINNTFUSERCMD_ISSIGN_FIELD.has_default_value = true
SIGNINNTFUSERCMD_ISSIGN_FIELD.default_value = 0
SIGNINNTFUSERCMD_ISSIGN_FIELD.type = 13
SIGNINNTFUSERCMD_ISSIGN_FIELD.cpp_type = 3
SIGNINNTFUSERCMD_ISSHOWED_FIELD.name = "isshowed"
SIGNINNTFUSERCMD_ISSHOWED_FIELD.full_name = ".Cmd.SignInNtfUserCmd.isshowed"
SIGNINNTFUSERCMD_ISSHOWED_FIELD.number = 5
SIGNINNTFUSERCMD_ISSHOWED_FIELD.index = 4
SIGNINNTFUSERCMD_ISSHOWED_FIELD.label = 1
SIGNINNTFUSERCMD_ISSHOWED_FIELD.has_default_value = true
SIGNINNTFUSERCMD_ISSHOWED_FIELD.default_value = 0
SIGNINNTFUSERCMD_ISSHOWED_FIELD.type = 13
SIGNINNTFUSERCMD_ISSHOWED_FIELD.cpp_type = 3
SIGNINNTFUSERCMD.name = "SignInNtfUserCmd"
SIGNINNTFUSERCMD.full_name = ".Cmd.SignInNtfUserCmd"
SIGNINNTFUSERCMD.nested_types = {}
SIGNINNTFUSERCMD.enum_types = {}
SIGNINNTFUSERCMD.fields = {
  SIGNINNTFUSERCMD_CMD_FIELD,
  SIGNINNTFUSERCMD_PARAM_FIELD,
  SIGNINNTFUSERCMD_COUNT_FIELD,
  SIGNINNTFUSERCMD_ISSIGN_FIELD,
  SIGNINNTFUSERCMD_ISSHOWED_FIELD
}
SIGNINNTFUSERCMD.is_extendable = false
SIGNINNTFUSERCMD.extensions = {}
BEATPORIUSERCMD_CMD_FIELD.name = "cmd"
BEATPORIUSERCMD_CMD_FIELD.full_name = ".Cmd.BeatPoriUserCmd.cmd"
BEATPORIUSERCMD_CMD_FIELD.number = 1
BEATPORIUSERCMD_CMD_FIELD.index = 0
BEATPORIUSERCMD_CMD_FIELD.label = 1
BEATPORIUSERCMD_CMD_FIELD.has_default_value = true
BEATPORIUSERCMD_CMD_FIELD.default_value = 9
BEATPORIUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BEATPORIUSERCMD_CMD_FIELD.type = 14
BEATPORIUSERCMD_CMD_FIELD.cpp_type = 8
BEATPORIUSERCMD_PARAM_FIELD.name = "param"
BEATPORIUSERCMD_PARAM_FIELD.full_name = ".Cmd.BeatPoriUserCmd.param"
BEATPORIUSERCMD_PARAM_FIELD.number = 2
BEATPORIUSERCMD_PARAM_FIELD.index = 1
BEATPORIUSERCMD_PARAM_FIELD.label = 1
BEATPORIUSERCMD_PARAM_FIELD.has_default_value = true
BEATPORIUSERCMD_PARAM_FIELD.default_value = 160
BEATPORIUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
BEATPORIUSERCMD_PARAM_FIELD.type = 14
BEATPORIUSERCMD_PARAM_FIELD.cpp_type = 8
BEATPORIUSERCMD_START_FIELD.name = "start"
BEATPORIUSERCMD_START_FIELD.full_name = ".Cmd.BeatPoriUserCmd.start"
BEATPORIUSERCMD_START_FIELD.number = 3
BEATPORIUSERCMD_START_FIELD.index = 2
BEATPORIUSERCMD_START_FIELD.label = 1
BEATPORIUSERCMD_START_FIELD.has_default_value = true
BEATPORIUSERCMD_START_FIELD.default_value = true
BEATPORIUSERCMD_START_FIELD.type = 8
BEATPORIUSERCMD_START_FIELD.cpp_type = 7
BEATPORIUSERCMD_SUCCESS_FIELD.name = "success"
BEATPORIUSERCMD_SUCCESS_FIELD.full_name = ".Cmd.BeatPoriUserCmd.success"
BEATPORIUSERCMD_SUCCESS_FIELD.number = 4
BEATPORIUSERCMD_SUCCESS_FIELD.index = 3
BEATPORIUSERCMD_SUCCESS_FIELD.label = 1
BEATPORIUSERCMD_SUCCESS_FIELD.has_default_value = true
BEATPORIUSERCMD_SUCCESS_FIELD.default_value = false
BEATPORIUSERCMD_SUCCESS_FIELD.type = 8
BEATPORIUSERCMD_SUCCESS_FIELD.cpp_type = 7
BEATPORIUSERCMD.name = "BeatPoriUserCmd"
BEATPORIUSERCMD.full_name = ".Cmd.BeatPoriUserCmd"
BEATPORIUSERCMD.nested_types = {}
BEATPORIUSERCMD.enum_types = {}
BEATPORIUSERCMD.fields = {
  BEATPORIUSERCMD_CMD_FIELD,
  BEATPORIUSERCMD_PARAM_FIELD,
  BEATPORIUSERCMD_START_FIELD,
  BEATPORIUSERCMD_SUCCESS_FIELD
}
BEATPORIUSERCMD.is_extendable = false
BEATPORIUSERCMD.extensions = {}
UNLOCKFRAMEUSERCMD_CMD_FIELD.name = "cmd"
UNLOCKFRAMEUSERCMD_CMD_FIELD.full_name = ".Cmd.UnlockFrameUserCmd.cmd"
UNLOCKFRAMEUSERCMD_CMD_FIELD.number = 1
UNLOCKFRAMEUSERCMD_CMD_FIELD.index = 0
UNLOCKFRAMEUSERCMD_CMD_FIELD.label = 1
UNLOCKFRAMEUSERCMD_CMD_FIELD.has_default_value = true
UNLOCKFRAMEUSERCMD_CMD_FIELD.default_value = 9
UNLOCKFRAMEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UNLOCKFRAMEUSERCMD_CMD_FIELD.type = 14
UNLOCKFRAMEUSERCMD_CMD_FIELD.cpp_type = 8
UNLOCKFRAMEUSERCMD_PARAM_FIELD.name = "param"
UNLOCKFRAMEUSERCMD_PARAM_FIELD.full_name = ".Cmd.UnlockFrameUserCmd.param"
UNLOCKFRAMEUSERCMD_PARAM_FIELD.number = 2
UNLOCKFRAMEUSERCMD_PARAM_FIELD.index = 1
UNLOCKFRAMEUSERCMD_PARAM_FIELD.label = 1
UNLOCKFRAMEUSERCMD_PARAM_FIELD.has_default_value = true
UNLOCKFRAMEUSERCMD_PARAM_FIELD.default_value = 161
UNLOCKFRAMEUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
UNLOCKFRAMEUSERCMD_PARAM_FIELD.type = 14
UNLOCKFRAMEUSERCMD_PARAM_FIELD.cpp_type = 8
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.name = "frameid"
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.full_name = ".Cmd.UnlockFrameUserCmd.frameid"
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.number = 3
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.index = 2
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.label = 3
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.has_default_value = false
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.default_value = {}
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.type = 13
UNLOCKFRAMEUSERCMD_FRAMEID_FIELD.cpp_type = 3
UNLOCKFRAMEUSERCMD.name = "UnlockFrameUserCmd"
UNLOCKFRAMEUSERCMD.full_name = ".Cmd.UnlockFrameUserCmd"
UNLOCKFRAMEUSERCMD.nested_types = {}
UNLOCKFRAMEUSERCMD.enum_types = {}
UNLOCKFRAMEUSERCMD.fields = {
  UNLOCKFRAMEUSERCMD_CMD_FIELD,
  UNLOCKFRAMEUSERCMD_PARAM_FIELD,
  UNLOCKFRAMEUSERCMD_FRAMEID_FIELD
}
UNLOCKFRAMEUSERCMD.is_extendable = false
UNLOCKFRAMEUSERCMD.extensions = {}
REWARDITEM_REWARDID_FIELD.name = "rewardid"
REWARDITEM_REWARDID_FIELD.full_name = ".Cmd.RewardItem.rewardid"
REWARDITEM_REWARDID_FIELD.number = 1
REWARDITEM_REWARDID_FIELD.index = 0
REWARDITEM_REWARDID_FIELD.label = 1
REWARDITEM_REWARDID_FIELD.has_default_value = true
REWARDITEM_REWARDID_FIELD.default_value = 0
REWARDITEM_REWARDID_FIELD.type = 13
REWARDITEM_REWARDID_FIELD.cpp_type = 3
REWARDITEM_STATUS_FIELD.name = "status"
REWARDITEM_STATUS_FIELD.full_name = ".Cmd.RewardItem.status"
REWARDITEM_STATUS_FIELD.number = 2
REWARDITEM_STATUS_FIELD.index = 1
REWARDITEM_STATUS_FIELD.label = 1
REWARDITEM_STATUS_FIELD.has_default_value = true
REWARDITEM_STATUS_FIELD.default_value = 0
REWARDITEM_STATUS_FIELD.enum_type = EREWARDSTATUS
REWARDITEM_STATUS_FIELD.type = 14
REWARDITEM_STATUS_FIELD.cpp_type = 8
REWARDITEM.name = "RewardItem"
REWARDITEM.full_name = ".Cmd.RewardItem"
REWARDITEM.nested_types = {}
REWARDITEM.enum_types = {}
REWARDITEM.fields = {
  REWARDITEM_REWARDID_FIELD,
  REWARDITEM_STATUS_FIELD
}
REWARDITEM.is_extendable = false
REWARDITEM.extensions = {}
ALTMANREWARDUSERCMD_CMD_FIELD.name = "cmd"
ALTMANREWARDUSERCMD_CMD_FIELD.full_name = ".Cmd.AltmanRewardUserCmd.cmd"
ALTMANREWARDUSERCMD_CMD_FIELD.number = 1
ALTMANREWARDUSERCMD_CMD_FIELD.index = 0
ALTMANREWARDUSERCMD_CMD_FIELD.label = 1
ALTMANREWARDUSERCMD_CMD_FIELD.has_default_value = true
ALTMANREWARDUSERCMD_CMD_FIELD.default_value = 9
ALTMANREWARDUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ALTMANREWARDUSERCMD_CMD_FIELD.type = 14
ALTMANREWARDUSERCMD_CMD_FIELD.cpp_type = 8
ALTMANREWARDUSERCMD_PARAM_FIELD.name = "param"
ALTMANREWARDUSERCMD_PARAM_FIELD.full_name = ".Cmd.AltmanRewardUserCmd.param"
ALTMANREWARDUSERCMD_PARAM_FIELD.number = 2
ALTMANREWARDUSERCMD_PARAM_FIELD.index = 1
ALTMANREWARDUSERCMD_PARAM_FIELD.label = 1
ALTMANREWARDUSERCMD_PARAM_FIELD.has_default_value = true
ALTMANREWARDUSERCMD_PARAM_FIELD.default_value = 170
ALTMANREWARDUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
ALTMANREWARDUSERCMD_PARAM_FIELD.type = 14
ALTMANREWARDUSERCMD_PARAM_FIELD.cpp_type = 8
ALTMANREWARDUSERCMD_PASSTIME_FIELD.name = "passtime"
ALTMANREWARDUSERCMD_PASSTIME_FIELD.full_name = ".Cmd.AltmanRewardUserCmd.passtime"
ALTMANREWARDUSERCMD_PASSTIME_FIELD.number = 3
ALTMANREWARDUSERCMD_PASSTIME_FIELD.index = 2
ALTMANREWARDUSERCMD_PASSTIME_FIELD.label = 1
ALTMANREWARDUSERCMD_PASSTIME_FIELD.has_default_value = true
ALTMANREWARDUSERCMD_PASSTIME_FIELD.default_value = 0
ALTMANREWARDUSERCMD_PASSTIME_FIELD.type = 13
ALTMANREWARDUSERCMD_PASSTIME_FIELD.cpp_type = 3
ALTMANREWARDUSERCMD_ITEMS_FIELD.name = "items"
ALTMANREWARDUSERCMD_ITEMS_FIELD.full_name = ".Cmd.AltmanRewardUserCmd.items"
ALTMANREWARDUSERCMD_ITEMS_FIELD.number = 4
ALTMANREWARDUSERCMD_ITEMS_FIELD.index = 3
ALTMANREWARDUSERCMD_ITEMS_FIELD.label = 3
ALTMANREWARDUSERCMD_ITEMS_FIELD.has_default_value = false
ALTMANREWARDUSERCMD_ITEMS_FIELD.default_value = {}
ALTMANREWARDUSERCMD_ITEMS_FIELD.message_type = REWARDITEM
ALTMANREWARDUSERCMD_ITEMS_FIELD.type = 11
ALTMANREWARDUSERCMD_ITEMS_FIELD.cpp_type = 10
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.name = "getrewardid"
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.full_name = ".Cmd.AltmanRewardUserCmd.getrewardid"
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.number = 5
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.index = 4
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.label = 1
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.has_default_value = true
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.default_value = 0
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.type = 13
ALTMANREWARDUSERCMD_GETREWARDID_FIELD.cpp_type = 3
ALTMANREWARDUSERCMD.name = "AltmanRewardUserCmd"
ALTMANREWARDUSERCMD.full_name = ".Cmd.AltmanRewardUserCmd"
ALTMANREWARDUSERCMD.nested_types = {}
ALTMANREWARDUSERCMD.enum_types = {}
ALTMANREWARDUSERCMD.fields = {
  ALTMANREWARDUSERCMD_CMD_FIELD,
  ALTMANREWARDUSERCMD_PARAM_FIELD,
  ALTMANREWARDUSERCMD_PASSTIME_FIELD,
  ALTMANREWARDUSERCMD_ITEMS_FIELD,
  ALTMANREWARDUSERCMD_GETREWARDID_FIELD
}
ALTMANREWARDUSERCMD.is_extendable = false
ALTMANREWARDUSERCMD.extensions = {}
SERVANTRESERVATIONITEM_DATE_FIELD.name = "date"
SERVANTRESERVATIONITEM_DATE_FIELD.full_name = ".Cmd.ServantReservationItem.date"
SERVANTRESERVATIONITEM_DATE_FIELD.number = 1
SERVANTRESERVATIONITEM_DATE_FIELD.index = 0
SERVANTRESERVATIONITEM_DATE_FIELD.label = 1
SERVANTRESERVATIONITEM_DATE_FIELD.has_default_value = true
SERVANTRESERVATIONITEM_DATE_FIELD.default_value = 0
SERVANTRESERVATIONITEM_DATE_FIELD.type = 13
SERVANTRESERVATIONITEM_DATE_FIELD.cpp_type = 3
SERVANTRESERVATIONITEM_ACTIDS_FIELD.name = "actids"
SERVANTRESERVATIONITEM_ACTIDS_FIELD.full_name = ".Cmd.ServantReservationItem.actids"
SERVANTRESERVATIONITEM_ACTIDS_FIELD.number = 2
SERVANTRESERVATIONITEM_ACTIDS_FIELD.index = 1
SERVANTRESERVATIONITEM_ACTIDS_FIELD.label = 3
SERVANTRESERVATIONITEM_ACTIDS_FIELD.has_default_value = false
SERVANTRESERVATIONITEM_ACTIDS_FIELD.default_value = {}
SERVANTRESERVATIONITEM_ACTIDS_FIELD.type = 13
SERVANTRESERVATIONITEM_ACTIDS_FIELD.cpp_type = 3
SERVANTRESERVATIONITEM_TYPE_FIELD.name = "type"
SERVANTRESERVATIONITEM_TYPE_FIELD.full_name = ".Cmd.ServantReservationItem.type"
SERVANTRESERVATIONITEM_TYPE_FIELD.number = 3
SERVANTRESERVATIONITEM_TYPE_FIELD.index = 2
SERVANTRESERVATIONITEM_TYPE_FIELD.label = 1
SERVANTRESERVATIONITEM_TYPE_FIELD.has_default_value = true
SERVANTRESERVATIONITEM_TYPE_FIELD.default_value = 1
SERVANTRESERVATIONITEM_TYPE_FIELD.enum_type = ERESERVATIONTYPE
SERVANTRESERVATIONITEM_TYPE_FIELD.type = 14
SERVANTRESERVATIONITEM_TYPE_FIELD.cpp_type = 8
SERVANTRESERVATIONITEM.name = "ServantReservationItem"
SERVANTRESERVATIONITEM.full_name = ".Cmd.ServantReservationItem"
SERVANTRESERVATIONITEM.nested_types = {}
SERVANTRESERVATIONITEM.enum_types = {}
SERVANTRESERVATIONITEM.fields = {
  SERVANTRESERVATIONITEM_DATE_FIELD,
  SERVANTRESERVATIONITEM_ACTIDS_FIELD,
  SERVANTRESERVATIONITEM_TYPE_FIELD
}
SERVANTRESERVATIONITEM.is_extendable = false
SERVANTRESERVATIONITEM.extensions = {}
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.name = "cmd"
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.full_name = ".Cmd.ServantReqReservationUserCmd.cmd"
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.number = 1
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.index = 0
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.label = 1
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.has_default_value = true
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.default_value = 9
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.type = 14
SERVANTREQRESERVATIONUSERCMD_CMD_FIELD.cpp_type = 8
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.name = "param"
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.full_name = ".Cmd.ServantReqReservationUserCmd.param"
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.number = 2
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.index = 1
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.label = 1
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.has_default_value = true
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.default_value = 171
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.type = 14
SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD.cpp_type = 8
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.name = "actid"
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.full_name = ".Cmd.ServantReqReservationUserCmd.actid"
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.number = 3
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.index = 2
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.label = 1
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.has_default_value = true
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.default_value = 0
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.type = 13
SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD.cpp_type = 3
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.name = "time"
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.full_name = ".Cmd.ServantReqReservationUserCmd.time"
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.number = 4
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.index = 3
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.label = 1
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.has_default_value = true
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.default_value = 0
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.type = 13
SERVANTREQRESERVATIONUSERCMD_TIME_FIELD.cpp_type = 3
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.name = "reservation"
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.full_name = ".Cmd.ServantReqReservationUserCmd.reservation"
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.number = 5
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.index = 4
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.label = 1
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.has_default_value = true
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.default_value = false
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.type = 8
SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD.cpp_type = 7
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.name = "type"
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.full_name = ".Cmd.ServantReqReservationUserCmd.type"
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.number = 6
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.index = 5
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.label = 1
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.has_default_value = true
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.default_value = 1
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.enum_type = ERESERVATIONTYPE
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.type = 14
SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD.cpp_type = 8
SERVANTREQRESERVATIONUSERCMD.name = "ServantReqReservationUserCmd"
SERVANTREQRESERVATIONUSERCMD.full_name = ".Cmd.ServantReqReservationUserCmd"
SERVANTREQRESERVATIONUSERCMD.nested_types = {}
SERVANTREQRESERVATIONUSERCMD.enum_types = {}
SERVANTREQRESERVATIONUSERCMD.fields = {
  SERVANTREQRESERVATIONUSERCMD_CMD_FIELD,
  SERVANTREQRESERVATIONUSERCMD_PARAM_FIELD,
  SERVANTREQRESERVATIONUSERCMD_ACTID_FIELD,
  SERVANTREQRESERVATIONUSERCMD_TIME_FIELD,
  SERVANTREQRESERVATIONUSERCMD_RESERVATION_FIELD,
  SERVANTREQRESERVATIONUSERCMD_TYPE_FIELD
}
SERVANTREQRESERVATIONUSERCMD.is_extendable = false
SERVANTREQRESERVATIONUSERCMD.extensions = {}
SERVANTRESERVATIONUSERCMD_CMD_FIELD.name = "cmd"
SERVANTRESERVATIONUSERCMD_CMD_FIELD.full_name = ".Cmd.ServantReservationUserCmd.cmd"
SERVANTRESERVATIONUSERCMD_CMD_FIELD.number = 1
SERVANTRESERVATIONUSERCMD_CMD_FIELD.index = 0
SERVANTRESERVATIONUSERCMD_CMD_FIELD.label = 1
SERVANTRESERVATIONUSERCMD_CMD_FIELD.has_default_value = true
SERVANTRESERVATIONUSERCMD_CMD_FIELD.default_value = 9
SERVANTRESERVATIONUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SERVANTRESERVATIONUSERCMD_CMD_FIELD.type = 14
SERVANTRESERVATIONUSERCMD_CMD_FIELD.cpp_type = 8
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.name = "param"
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.full_name = ".Cmd.ServantReservationUserCmd.param"
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.number = 2
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.index = 1
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.label = 1
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.has_default_value = true
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.default_value = 172
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.type = 14
SERVANTRESERVATIONUSERCMD_PARAM_FIELD.cpp_type = 8
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.name = "datas"
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.full_name = ".Cmd.ServantReservationUserCmd.datas"
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.number = 3
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.index = 2
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.label = 3
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.has_default_value = false
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.default_value = {}
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.message_type = SERVANTRESERVATIONITEM
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.type = 11
SERVANTRESERVATIONUSERCMD_DATAS_FIELD.cpp_type = 10
SERVANTRESERVATIONUSERCMD_OPT_FIELD.name = "opt"
SERVANTRESERVATIONUSERCMD_OPT_FIELD.full_name = ".Cmd.ServantReservationUserCmd.opt"
SERVANTRESERVATIONUSERCMD_OPT_FIELD.number = 4
SERVANTRESERVATIONUSERCMD_OPT_FIELD.index = 3
SERVANTRESERVATIONUSERCMD_OPT_FIELD.label = 1
SERVANTRESERVATIONUSERCMD_OPT_FIELD.has_default_value = true
SERVANTRESERVATIONUSERCMD_OPT_FIELD.default_value = 0
SERVANTRESERVATIONUSERCMD_OPT_FIELD.type = 13
SERVANTRESERVATIONUSERCMD_OPT_FIELD.cpp_type = 3
SERVANTRESERVATIONUSERCMD.name = "ServantReservationUserCmd"
SERVANTRESERVATIONUSERCMD.full_name = ".Cmd.ServantReservationUserCmd"
SERVANTRESERVATIONUSERCMD.nested_types = {}
SERVANTRESERVATIONUSERCMD.enum_types = {}
SERVANTRESERVATIONUSERCMD.fields = {
  SERVANTRESERVATIONUSERCMD_CMD_FIELD,
  SERVANTRESERVATIONUSERCMD_PARAM_FIELD,
  SERVANTRESERVATIONUSERCMD_DATAS_FIELD,
  SERVANTRESERVATIONUSERCMD_OPT_FIELD
}
SERVANTRESERVATIONUSERCMD.is_extendable = false
SERVANTRESERVATIONUSERCMD.extensions = {}
SERVANTEQUIPITEM_ID_FIELD.name = "id"
SERVANTEQUIPITEM_ID_FIELD.full_name = ".Cmd.ServantEquipItem.id"
SERVANTEQUIPITEM_ID_FIELD.number = 1
SERVANTEQUIPITEM_ID_FIELD.index = 0
SERVANTEQUIPITEM_ID_FIELD.label = 1
SERVANTEQUIPITEM_ID_FIELD.has_default_value = true
SERVANTEQUIPITEM_ID_FIELD.default_value = 0
SERVANTEQUIPITEM_ID_FIELD.type = 13
SERVANTEQUIPITEM_ID_FIELD.cpp_type = 3
SERVANTEQUIPITEM_EQUIPID_FIELD.name = "equipid"
SERVANTEQUIPITEM_EQUIPID_FIELD.full_name = ".Cmd.ServantEquipItem.equipid"
SERVANTEQUIPITEM_EQUIPID_FIELD.number = 2
SERVANTEQUIPITEM_EQUIPID_FIELD.index = 1
SERVANTEQUIPITEM_EQUIPID_FIELD.label = 3
SERVANTEQUIPITEM_EQUIPID_FIELD.has_default_value = false
SERVANTEQUIPITEM_EQUIPID_FIELD.default_value = {}
SERVANTEQUIPITEM_EQUIPID_FIELD.type = 13
SERVANTEQUIPITEM_EQUIPID_FIELD.cpp_type = 3
SERVANTEQUIPITEM.name = "ServantEquipItem"
SERVANTEQUIPITEM.full_name = ".Cmd.ServantEquipItem"
SERVANTEQUIPITEM.nested_types = {}
SERVANTEQUIPITEM.enum_types = {}
SERVANTEQUIPITEM.fields = {
  SERVANTEQUIPITEM_ID_FIELD,
  SERVANTEQUIPITEM_EQUIPID_FIELD
}
SERVANTEQUIPITEM.is_extendable = false
SERVANTEQUIPITEM.extensions = {}
SERVANTRECEQUIPUSERCMD_CMD_FIELD.name = "cmd"
SERVANTRECEQUIPUSERCMD_CMD_FIELD.full_name = ".Cmd.ServantRecEquipUserCmd.cmd"
SERVANTRECEQUIPUSERCMD_CMD_FIELD.number = 1
SERVANTRECEQUIPUSERCMD_CMD_FIELD.index = 0
SERVANTRECEQUIPUSERCMD_CMD_FIELD.label = 1
SERVANTRECEQUIPUSERCMD_CMD_FIELD.has_default_value = true
SERVANTRECEQUIPUSERCMD_CMD_FIELD.default_value = 9
SERVANTRECEQUIPUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SERVANTRECEQUIPUSERCMD_CMD_FIELD.type = 14
SERVANTRECEQUIPUSERCMD_CMD_FIELD.cpp_type = 8
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.name = "param"
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.full_name = ".Cmd.ServantRecEquipUserCmd.param"
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.number = 2
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.index = 1
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.label = 1
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.has_default_value = true
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.default_value = 173
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.enum_type = USER2PARAM
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.type = 14
SERVANTRECEQUIPUSERCMD_PARAM_FIELD.cpp_type = 8
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.name = "datas"
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.full_name = ".Cmd.ServantRecEquipUserCmd.datas"
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.number = 3
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.index = 2
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.label = 3
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.has_default_value = false
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.default_value = {}
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.message_type = SERVANTEQUIPITEM
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.type = 11
SERVANTRECEQUIPUSERCMD_DATAS_FIELD.cpp_type = 10
SERVANTRECEQUIPUSERCMD.name = "ServantRecEquipUserCmd"
SERVANTRECEQUIPUSERCMD.full_name = ".Cmd.ServantRecEquipUserCmd"
SERVANTRECEQUIPUSERCMD.nested_types = {}
SERVANTRECEQUIPUSERCMD.enum_types = {}
SERVANTRECEQUIPUSERCMD.fields = {
  SERVANTRECEQUIPUSERCMD_CMD_FIELD,
  SERVANTRECEQUIPUSERCMD_PARAM_FIELD,
  SERVANTRECEQUIPUSERCMD_DATAS_FIELD
}
SERVANTRECEQUIPUSERCMD.is_extendable = false
SERVANTRECEQUIPUSERCMD.extensions = {}
ActivityNtfUserCmd = protobuf.Message(ACTIVITYNTFUSERCMD)
AddAttrPoint = protobuf.Message(ADDATTRPOINT)
AltmanRewardUserCmd = protobuf.Message(ALTMANREWARDUSERCMD)
AstrolabeProfessionData = protobuf.Message(ASTROLABEPROFESSIONDATA)
AttrProfessionData = protobuf.Message(ATTRPROFESSIONDATA)
BattleTimelenUserCmd = protobuf.Message(BATTLETIMELENUSERCMD)
BeFollowUserCmd = protobuf.Message(BEFOLLOWUSERCMD)
BeatPoriUserCmd = protobuf.Message(BEATPORIUSERCMD)
BoothInfo = protobuf.Message(BOOTHINFO)
BoothInfoSyncUserCmd = protobuf.Message(BOOTHINFOSYNCUSERCMD)
BoothReqUserCmd = protobuf.Message(BOOTHREQUSERCMD)
BreakUpHandsUserCmd = protobuf.Message(BREAKUPHANDSUSERCMD)
BuffForeverCmd = protobuf.Message(BUFFFOREVERCMD)
BufferData = protobuf.Message(BUFFERDATA)
ButtonThreshold = protobuf.Message(BUTTONTHRESHOLD)
BuyRecordSlotUserCmd = protobuf.Message(BUYRECORDSLOTUSERCMD)
BuyZenyCmd = protobuf.Message(BUYZENYCMD)
CDTimeItem = protobuf.Message(CDTIMEITEM)
CDTimeUserCmd = protobuf.Message(CDTIMEUSERCMD)
CD_TYPE_ITEM = 1
CD_TYPE_SKILL = 0
CD_TYPE_SKILLDEALY = 2
CallNpcFuncCmd = protobuf.Message(CALLNPCFUNCCMD)
CallTeamerReplyUserCmd = protobuf.Message(CALLTEAMERREPLYUSERCMD)
CallTeamerUserCmd = protobuf.Message(CALLTEAMERUSERCMD)
CameraFocus = protobuf.Message(CAMERAFOCUS)
ChangeBgmCmd = protobuf.Message(CHANGEBGMCMD)
ChangeNameUserCmd = protobuf.Message(CHANGENAMEUSERCMD)
ChangeRecordNameUserCmd = protobuf.Message(CHANGERECORDNAMEUSERCMD)
ChargePlayUserCmd = protobuf.Message(CHARGEPLAYUSERCMD)
CheatTagStatUserCmd = protobuf.Message(CHEATTAGSTATUSERCMD)
CheatTagUserCmd = protobuf.Message(CHEATTAGUSERCMD)
CheckRelationUserCmd = protobuf.Message(CHECKRELATIONUSERCMD)
CheckSeatUserCmd = protobuf.Message(CHECKSEATUSERCMD)
ClickButtonPos = protobuf.Message(CLICKBUTTONPOS)
ClickPosList = protobuf.Message(CLICKPOSLIST)
CloseMusicFrame = protobuf.Message(CLOSEMUSICFRAME)
CountDownTickUserCmd = protobuf.Message(COUNTDOWNTICKUSERCMD)
DbgSysMsg = protobuf.Message(DBGSYSMSG)
DeathTransferListCmd = protobuf.Message(DEATHTRANSFERLISTCMD)
DeleteRecordUserCmd = protobuf.Message(DELETERECORDUSERCMD)
DemandMusic = protobuf.Message(DEMANDMUSIC)
DownloadSceneryPhotoUserCmd = protobuf.Message(DOWNLOADSCENERYPHOTOUSERCMD)
DressUpHeadUserCmd = protobuf.Message(DRESSUPHEADUSERCMD)
DressUpLineUpUserCmd = protobuf.Message(DRESSUPLINEUPUSERCMD)
DressUpModelUserCmd = protobuf.Message(DRESSUPMODELUSERCMD)
DressUpStageUserCmd = protobuf.Message(DRESSUPSTAGEUSERCMD)
DressingListUserCmd = protobuf.Message(DRESSINGLISTUSERCMD)
EALBUMTYPE_GUILD_ICON = 3
EALBUMTYPE_MAX = 5
EALBUMTYPE_MIN = 0
EALBUMTYPE_PHOTO = 2
EALBUMTYPE_SCENERY = 1
EALBUMTYPE_WEDDING = 4
EBATTLESTATUS_EASY = 1
EBATTLESTATUS_HIGHTIRED = 3
EBATTLESTATUS_TIRED = 2
EBOOTHOPER_CLOSE = 1
EBOOTHOPER_OPEN = 0
EBOOTHOPER_UPDATE = 2
EBOOTHSIGN_BLUE = 2
EBOOTHSIGN_GREEN = 1
EBOOTHSIGN_ORANGE = 4
EBOOTHSIGN_PINK = 5
EBOOTHSIGN_PURPLE = 3
EBOOTHSIGN_WHITE = 0
ECOUNTDOWNTYPE_ALTMAN = 3
ECOUNTDOWNTYPE_DOJO = 1
ECOUNTDOWNTYPE_TOWER = 2
EDBGMSGTYPE_MIN = 0
EDBGMSGTYPE_TEST = 1
EDRESSTYPE_CLOTH = 4
EDRESSTYPE_EYE = 3
EDRESSTYPE_HAIR = 1
EDRESSTYPE_HAIRCOLOR = 2
EDRESSTYPE_MAX = 5
EDRESSTYPE_MIN = 0
EDRESSUP_MIN = 0
EDRESSUP_SHOW = 2
EDRESSUP_WAIT = 1
EEFFECTOPT_DELETE = 3
EEFFECTOPT_PLAY = 1
EEFFECTOPT_STOP = 2
EEFFECTTYPE_ACCEPTQUEST = 2
EEFFECTTYPE_FINISHQUEST = 3
EEFFECTTYPE_MVPSHOW = 4
EEFFECTTYPE_NORMAL = 1
EEFFECTTYPE_SCENEEFFECT = 5
EENROLLRESULT_CHARID_EXISTED = 1
EENROLLRESULT_CODE_INCORRECT = 3
EENROLLRESULT_CODE_INVALID = 4
EENROLLRESULT_CODE_TOOFAST = 5
EENROLLRESULT_ERROR = 6
EENROLLRESULT_PHONE_EXISTED = 2
EENROLLRESULT_SUCCESS = 0
EFASHIONHIDETYPE_BACK = 1
EFASHIONHIDETYPE_BODY = 5
EFASHIONHIDETYPE_FACE = 2
EFASHIONHIDETYPE_HEAD = 0
EFASHIONHIDETYPE_MAX = 6
EFASHIONHIDETYPE_MOUTH = 4
EFASHIONHIDETYPE_TAIL = 3
EFOLLOWTYPE_BREAK = 5
EFOLLOWTYPE_HAND = 1
EFOLLOWTYPE_MAX = 7
EFOLLOWTYPE_MIN = 0
EFOLLOWTYPE_TWINSACTION = 6
EFUNCMAPTYPE_POLLY = 1
EGAMETIMEOPT_ADJUST = 2
EGAMETIMEOPT_SYNC = 1
EGROWTH_STATUS_FINISH = 3
EGROWTH_STATUS_GO = 1
EGROWTH_STATUS_MIN = 0
EGROWTH_STATUS_RECEIVE = 2
EGROWTH_TYPE_EP = 2
EGROWTH_TYPE_MIN = 0
EGROWTH_TYPE_STEP = 1
EGROWTH_TYPE_TIME_LIMIT = 3
EGoToGearType_Free = 4
EGoToGearType_Hand = 2
EGoToGearType_Single = 1
EGoToGearType_Team = 3
EJUMPZONE_GUILD = 1
EJUMPZONE_MAX = 4
EJUMPZONE_MIN = 0
EJUMPZONE_TEAM = 2
EJUMPZONE_USER = 3
EMESSAGEACT_ADD = 1
EMESSAGEACT_DEL = 2
EMESSAGETYPE_FRAME = 1
EMESSAGETYPE_GETEXP = 2
EMESSAGETYPE_MAX = 6
EMESSAGETYPE_MIDDLE_SHOW = 5
EMESSAGETYPE_MIN = 0
EMESSAGETYPE_TIME_DOWN = 3
EMESSAGETYPE_TIME_DOWN_NOT_CLEAR = 4
EMONITORBUTTON_AUTO_BATTLE_BUTTON = 0
EMONITORBUTTON_AUTO_CLICK_MVP_MINI = 102
EMONITORBUTTON_CLICK_MVP_MINI = 101
EMONITORBUTTON_CLICK_NPC = 103
EMONITORBUTTON_MAP_CLICK_NPC = 104
EMONITORBUTTON_MAX = 105
EMONITORBUTTON_NEARLY_BUTTON = 3
EMONITORBUTTON_NEARLY_CREATURE_CELL2 = 5
EMONITORBUTTON_NPC_TOG = 4
EMONITORBUTTON_QUICK_ITEM_CELL1 = 1
EMONITORBUTTON_QUICK_ITEM_CELL2 = 2
EOPTIONTYPE_LOTTERY_CNT_CARD = 5
EOPTIONTYPE_LOTTERY_CNT_EQUIP = 4
EOPTIONTYPE_LOTTERY_CNT_GIVE = 7
EOPTIONTYPE_LOTTERY_CNT_HEAD = 3
EOPTIONTYPE_LOTTERY_CNT_MAGIC = 6
EOPTIONTYPE_LOTTERY_CNT_MAGIC_2 = 9
EOPTIONTYPE_MAX = 63
EOPTIONTYPE_USE_PETTALK = 8
EOPTIONTYPE_USE_SAVE_HP = 0
EOPTIONTYPE_USE_SAVE_SP = 1
EOPTIONTYPE_USE_SLIM = 2
EPROPOSALREPLY_CANCEL = 3
EPROPOSALREPLY_NO = 1
EPROPOSALREPLY_OUTRANGE = 2
EPROPOSALREPLY_YES = 0
EQUERYTYPE_ALL = 1
EQUERYTYPE_CLOSE = 3
EQUERYTYPE_FRIEND = 2
EQUERYTYPE_MAX = 7
EQUERYTYPE_MIN = 0
EQUERYTYPE_WEDDING_ALL = 4
EQUERYTYPE_WEDDING_CLOSE = 6
EQUERYTYPE_WEDDING_FRIEND = 5
ERECOMMEND_STATUS_FINISH = 3
ERECOMMEND_STATUS_GO = 1
ERECOMMEND_STATUS_MIN = 0
ERECOMMEND_STATUS_RECEIVE = 2
ERELIVETYPE_MAX = 7
ERELIVETYPE_MIN = 0
ERELIVETYPE_MONEY = 2
ERELIVETYPE_RAND = 3
ERELIVETYPE_RETURN = 1
ERELIVETYPE_RETURNSAVE = 4
ERELIVETYPE_SKILL = 5
ERELIVETYPE_TOWER = 6
ERENAME_CD = 1
ERENAME_CONFLICT = 2
ERENAME_SUCCESS = 0
ERESERVATIONTYPE_CONFIG = 1
ERESERVATIONTYPE_CONSOLE = 2
EREWEARD_STATUS_CAN_GET = 1
EREWEARD_STATUS_GET = 2
EREWEARD_STATUS_MAX = 3
EREWEARD_STATUS_MIN = 0
ESERVANT_SERVICE_BREAK_HAND = 8
ESERVANT_SERVICE_FINANCE_SEVEN = 3
ESERVANT_SERVICE_FINANCE_THREE = 2
ESERVANT_SERVICE_INVITE_HAND = 7
ESERVANT_SERVICE_RECOMMEND = 1
ESERVANT_SERVICE_RECOMMEND_REFRESH = 6
ESERVANT_SERVICE_SPECIAL = 5
ESERVANT_SERVICE_UPGRADE = 4
ESHARETYPE_CONCERT = 3
ESHARETYPE_KFC_ARPHOTO_SHARE = 1
ESHARETYPE_KFC_SHARE = 0
ESLOT_BUY = 2
ESLOT_DEFAULT = 1
ESLOT_MONTH_CARD = 3
ETREESTATUS_DEAD = 4
ETREESTATUS_MAX = 5
ETREESTATUS_MIN = 0
ETREESTATUS_MONSTER = 2
ETREESTATUS_NORMAL = 1
ETREESTATUS_REWARD = 3
ETWINS_OPERATION_AGREE = 3
ETWINS_OPERATION_COMMIT = 5
ETWINS_OPERATION_DISAGREE = 4
ETWINS_OPERATION_MIN = 0
ETWINS_OPERATION_REQUEST = 2
ETWINS_OPERATION_SPONSOR = 1
ETypeAdvance = 0
ETypeBranch = 1
ETypeRecord = 2
EUSERACTIONTYPE_ADDHP = 1
EUSERACTIONTYPE_DIALOG = 7
EUSERACTIONTYPE_EXPRESSION = 3
EUSERACTIONTYPE_GEAR_ACTION = 5
EUSERACTIONTYPE_MAX = 8
EUSERACTIONTYPE_MIN = 0
EUSERACTIONTYPE_MOTION = 4
EUSERACTIONTYPE_NORMALMOTION = 6
EUSERACTIONTYPE_REFINE = 2
EZONESTATE_FULL = 1
EZONESTATE_MAX = 3
EZONESTATE_MIN = 0
EZONESTATE_NOFULL = 2
EZONESTATUS_BUSY = 2
EZONESTATUS_FREE = 1
EZONESTATUS_MAX = 4
EZONESTATUS_MIN = 0
EZONESTATUS_VERYBUSY = 3
EffectUserCmd = protobuf.Message(EFFECTUSERCMD)
EnterCapraActivityCmd = protobuf.Message(ENTERCAPRAACTIVITYCMD)
EquipInfo = protobuf.Message(EQUIPINFO)
EquipPackData = protobuf.Message(EQUIPPACKDATA)
ExchangeProfession = protobuf.Message(EXCHANGEPROFESSION)
ExitPosUserCmd = protobuf.Message(EXITPOSUSERCMD)
FavorabilityStatus = protobuf.Message(FAVORABILITYSTATUS)
FighterInfo = protobuf.Message(FIGHTERINFO)
FollowTransferCmd = protobuf.Message(FOLLOWTRANSFERCMD)
FollowerUser = protobuf.Message(FOLLOWERUSER)
GameTimeCmd = protobuf.Message(GAMETIMECMD)
GoCity = protobuf.Message(GOCITY)
GoMapFollowUserCmd = protobuf.Message(GOMAPFOLLOWUSERCMD)
GoMapQuestUserCmd = protobuf.Message(GOMAPQUESTUSERCMD)
GoToFunctionMapUserCmd = protobuf.Message(GOTOFUNCTIONMAPUSERCMD)
GoToGearUserCmd = protobuf.Message(GOTOGEARUSERCMD)
GoToListUserCmd = protobuf.Message(GOTOLISTUSERCMD)
GotoLaboratoryUserCmd = protobuf.Message(GOTOLABORATORYUSERCMD)
GrowthCurInfo = protobuf.Message(GROWTHCURINFO)
GrowthGroupInfo = protobuf.Message(GROWTHGROUPINFO)
GrowthItemInfo = protobuf.Message(GROWTHITEMINFO)
GrowthOpenServantUserCmd = protobuf.Message(GROWTHOPENSERVANTUSERCMD)
GrowthServantUserCmd = protobuf.Message(GROWTHSERVANTUSERCMD)
GrowthValueInfo = protobuf.Message(GROWTHVALUEINFO)
HandStatusUserCmd = protobuf.Message(HANDSTATUSUSERCMD)
InviteFollowUserCmd = protobuf.Message(INVITEFOLLOWUSERCMD)
InviteJoinHandsUserCmd = protobuf.Message(INVITEJOINHANDSUSERCMD)
InviteWithMeUserCmd = protobuf.Message(INVITEWITHMEUSERCMD)
InviteeWeddingStartNtfUserCmd = protobuf.Message(INVITEEWEDDINGSTARTNTFUSERCMD)
ItemImageUserNtfUserCmd = protobuf.Message(ITEMIMAGEUSERNTFUSERCMD)
ItemMusicNtfUserCmd = protobuf.Message(ITEMMUSICNTFUSERCMD)
JoinHandsUserCmd = protobuf.Message(JOINHANDSUSERCMD)
JumpZoneUserCmd = protobuf.Message(JUMPZONEUSERCMD)
KFCEnrollCodeUserCmd = protobuf.Message(KFCENROLLCODEUSERCMD)
KFCEnrollQueryUserCmd = protobuf.Message(KFCENROLLQUERYUSERCMD)
KFCEnrollReplyUserCmd = protobuf.Message(KFCENROLLREPLYUSERCMD)
KFCEnrollUserCmd = protobuf.Message(KFCENROLLUSERCMD)
KFCHasEnrolledUserCmd = protobuf.Message(KFCHASENROLLEDUSERCMD)
KFCShareUserCmd = protobuf.Message(KFCSHAREUSERCMD)
LaboratoryUserCmd = protobuf.Message(LABORATORYUSERCMD)
LoadRecordUserCmd = protobuf.Message(LOADRECORDUSERCMD)
MarriageProposalCmd = protobuf.Message(MARRIAGEPROPOSALCMD)
MarriageProposalReplyCmd = protobuf.Message(MARRIAGEPROPOSALREPLYCMD)
MarriageProposalSuccessCmd = protobuf.Message(MARRIAGEPROPOSALSUCCESSCMD)
MenuList = protobuf.Message(MENULIST)
ModelShow = protobuf.Message(MODELSHOW)
MsgLangParam = protobuf.Message(MSGLANGPARAM)
MsgParam = protobuf.Message(MSGPARAM)
MusicItem = protobuf.Message(MUSICITEM)
NewDeathTransferCmd = protobuf.Message(NEWDEATHTRANSFERCMD)
NewDressing = protobuf.Message(NEWDRESSING)
NewMapAreaNtf = protobuf.Message(NEWMAPAREANTF)
NewMenu = protobuf.Message(NEWMENU)
NewPortraitFrame = protobuf.Message(NEWPORTRAITFRAME)
NewSetOptionUserCmd = protobuf.Message(NEWSETOPTIONUSERCMD)
NewTransMapCmd = protobuf.Message(NEWTRANSMAPCMD)
NpcChangeAngle = protobuf.Message(NPCCHANGEANGLE)
NpcDataSync = protobuf.Message(NPCDATASYNC)
NtfSeatUserCmd = protobuf.Message(NTFSEATUSERCMD)
NtfVisibleNpcUserCmd = protobuf.Message(NTFVISIBLENPCUSERCMD)
OpenUI = protobuf.Message(OPENUI)
POINTTYPE_ADD = 1
POINTTYPE_RESET = 2
Photo = protobuf.Message(PHOTO)
PresetMsg = protobuf.Message(PRESETMSG)
PresetMsgCmd = protobuf.Message(PRESETMSGCMD)
ProfessionBuyUserCmd = protobuf.Message(PROFESSIONBUYUSERCMD)
ProfessionChangeUserCmd = protobuf.Message(PROFESSIONCHANGEUSERCMD)
ProfessionInfo = protobuf.Message(PROFESSIONINFO)
ProfessionQueryUserCmd = protobuf.Message(PROFESSIONQUERYUSERCMD)
ProfessionUserInfo = protobuf.Message(PROFESSIONUSERINFO)
PutShortcut = protobuf.Message(PUTSHORTCUT)
QueryAltmanKillUserCmd = protobuf.Message(QUERYALTMANKILLUSERCMD)
QueryFighterInfo = protobuf.Message(QUERYFIGHTERINFO)
QueryMapArea = protobuf.Message(QUERYMAPAREA)
QueryMusicList = protobuf.Message(QUERYMUSICLIST)
QueryPortraitListUserCmd = protobuf.Message(QUERYPORTRAITLISTUSERCMD)
QueryShopGotItem = protobuf.Message(QUERYSHOPGOTITEM)
QueryShortcut = protobuf.Message(QUERYSHORTCUT)
QueryShow = protobuf.Message(QUERYSHOW)
QueryStageUserCmd = protobuf.Message(QUERYSTAGEUSERCMD)
QueryTraceList = protobuf.Message(QUERYTRACELIST)
QueryUserInfoUserCmd = protobuf.Message(QUERYUSERINFOUSERCMD)
QueryZoneStatusUserCmd = protobuf.Message(QUERYZONESTATUSUSERCMD)
ReceiveGrowthServantUserCmd = protobuf.Message(RECEIVEGROWTHSERVANTUSERCMD)
ReceiveServantUserCmd = protobuf.Message(RECEIVESERVANTUSERCMD)
RecentZoneInfo = protobuf.Message(RECENTZONEINFO)
RecommendItemInfo = protobuf.Message(RECOMMENDITEMINFO)
RecommendServantUserCmd = protobuf.Message(RECOMMENDSERVANTUSERCMD)
Relive = protobuf.Message(RELIVE)
ReplaceServantUserCmd = protobuf.Message(REPLACESERVANTUSERCMD)
RequireNpcFuncUserCmd = protobuf.Message(REQUIRENPCFUNCUSERCMD)
RewardItem = protobuf.Message(REWARDITEM)
SEAT_SHOW_INVISIBLE = 1
SEAT_SHOW_VISIBLE = 0
SaveRecordUserCmd = protobuf.Message(SAVERECORDUSERCMD)
Scenery = protobuf.Message(SCENERY)
SceneryUserCmd = protobuf.Message(SCENERYUSERCMD)
ServantEquipItem = protobuf.Message(SERVANTEQUIPITEM)
ServantRecEquipUserCmd = protobuf.Message(SERVANTRECEQUIPUSERCMD)
ServantReqReservationUserCmd = protobuf.Message(SERVANTREQRESERVATIONUSERCMD)
ServantReservationItem = protobuf.Message(SERVANTRESERVATIONITEM)
ServantReservationUserCmd = protobuf.Message(SERVANTRESERVATIONUSERCMD)
ServantRewardStatusUserCmd = protobuf.Message(SERVANTREWARDSTATUSUSERCMD)
ServantService = protobuf.Message(SERVANTSERVICE)
ServerTime = protobuf.Message(SERVERTIME)
SetDirection = protobuf.Message(SETDIRECTION)
SetNormalSkillOptionUserCmd = protobuf.Message(SETNORMALSKILLOPTIONUSERCMD)
SetOptionUserCmd = protobuf.Message(SETOPTIONUSERCMD)
ShakeScreen = protobuf.Message(SHAKESCREEN)
ShakeTreeUserCmd = protobuf.Message(SHAKETREEUSERCMD)
ShopGotItem = protobuf.Message(SHOPGOTITEM)
ShortcutItem = protobuf.Message(SHORTCUTITEM)
ShowSeatUserCmd = protobuf.Message(SHOWSEATUSERCMD)
ShowServantUserCmd = protobuf.Message(SHOWSERVANTUSERCMD)
SignInNtfUserCmd = protobuf.Message(SIGNINNTFUSERCMD)
SignInUserCmd = protobuf.Message(SIGNINUSERCMD)
SkillProfessionData = protobuf.Message(SKILLPROFESSIONDATA)
SkillValidPosData = protobuf.Message(SKILLVALIDPOSDATA)
SlotInfo = protobuf.Message(SLOTINFO)
SoundEffectCmd = protobuf.Message(SOUNDEFFECTCMD)
SpecialEffectCmd = protobuf.Message(SPECIALEFFECTCMD)
StageInfo = protobuf.Message(STAGEINFO)
StageUserDataType = protobuf.Message(STAGEUSERDATATYPE)
StateChange = protobuf.Message(STATECHANGE)
SysMsg = protobuf.Message(SYSMSG)
TalkInfo = protobuf.Message(TALKINFO)
TeamInfoNine = protobuf.Message(TEAMINFONINE)
TraceItem = protobuf.Message(TRACEITEM)
TransformPreDataCmd = protobuf.Message(TRANSFORMPREDATACMD)
Tree = protobuf.Message(TREE)
TreeListUserCmd = protobuf.Message(TREELISTUSERCMD)
TwinsActionUserCmd = protobuf.Message(TWINSACTIONUSERCMD)
USER2PARAM_ACTION = 5
USER2PARAM_ACTIVITY_NTF = 89
USER2PARAM_ADDATTRPOINT = 21
USER2PARAM_ALTMAN_REWARD = 170
USER2PARAM_AUTOHIT = 61
USER2PARAM_BATTLE_TIMELEN_USER_CMD = 82
USER2PARAM_BEAT_PORI = 160
USER2PARAM_BEFOLLOW = 96
USER2PARAM_BOOTH_INFO_SYNC = 145
USER2PARAM_BREAK_UP_HANDS = 68
USER2PARAM_BUFFERSYNC = 6
USER2PARAM_BUY_RECORD_SLOT = 138
USER2PARAM_BUY_ZENY = 111
USER2PARAM_CALL_TEAMER = 112
USER2PARAM_CALL_TEAMER_JOIN = 113
USER2PARAM_CAMERAFOCUS = 50
USER2PARAM_CDTIME = 41
USER2PARAM_CHANGEBGM = 37
USER2PARAM_CHANGENAME = 98
USER2PARAM_CHANGE_RECORD_NAME = 137
USER2PARAM_CHARGEPLAY = 99
USER2PARAM_CHEAT_TAG = 157
USER2PARAM_CHEAT_TAG_STAT = 158
USER2PARAM_CHECK_RELATION = 130
USER2PARAM_CHECK_SEAT = 101
USER2PARAM_CLICK_POS_LIST = 159
USER2PARAM_COUNTDOWN_TICK = 85
USER2PARAM_DBGSYSMSG = 30
USER2PARAM_DEATH_TRANSFER_LIST = 151
USER2PARAM_DELETE_RECORD = 139
USER2PARAM_DOWNLOAD_SCENERY_PHOTO = 80
USER2PARAM_DRESSINGLIST = 27
USER2PARAM_DRESSUP_HEAD = 147
USER2PARAM_DRESSUP_LINEUP = 149
USER2PARAM_DRESSUP_MODEL = 146
USER2PARAM_DRESSUP_STAGE = 150
USER2PARAM_EFFECT = 14
USER2PARAM_ENTER_CAPRA_ACTIVITY = 110
USER2PARAM_EXCHANGEPROFESSION = 56
USER2PARAM_EXIT_POS = 7
USER2PARAM_FOLLOWER = 53
USER2PARAM_FOLLOWTRANSFER = 32
USER2PARAM_FOREVER_BUFF = 66
USER2PARAM_GAMETIME = 40
USER2PARAM_GOCITY = 1
USER2PARAM_GOMAP_FOLLOW = 60
USER2PARAM_GOMAP_QUEST = 59
USER2PARAM_GOTO_FUNCMAP = 141
USER2PARAM_GOTO_GEAR = 52
USER2PARAM_GOTO_LABORATORY = 57
USER2PARAM_GOTO_LIST = 51
USER2PARAM_HANDSTATUS = 95
USER2PARAM_INVITEE_WEDDING_START_NTF = 121
USER2PARAM_INVITEFOLLOW = 97
USER2PARAM_INVITE_JOIN_HANDS = 67
USER2PARAM_INVITE_WITH_ME = 142
USER2PARAM_ITEMIMAGE_USER_NTF = 93
USER2PARAM_ITEM_MUSIC_NTF = 86
USER2PARAM_JOIN_HANDS = 74
USER2PARAM_JUMP_ZONE = 92
USER2PARAM_KFC_ENROLL = 162
USER2PARAM_KFC_ENROLL_CODE = 168
USER2PARAM_KFC_ENROLL_QUERY = 167
USER2PARAM_KFC_ENROLL_REPLY = 163
USER2PARAM_KFC_HAS_ENROLLED = 166
USER2PARAM_KFC_SHARE = 128
USER2PARAM_LABORATORY = 54
USER2PARAM_LOAD_RECORD = 136
USER2PARAM_MARRIAGE_PROPOSAL = 117
USER2PARAM_MARRIAGE_PROPOSAL_REPLY = 118
USER2PARAM_MARRIAGE_PROPOSAL_SUCCESS = 120
USER2PARAM_MENU = 15
USER2PARAM_MODELSHOW = 34
USER2PARAM_MUSIC_CLOSE = 72
USER2PARAM_MUSIC_DEMAND = 71
USER2PARAM_MUSIC_LIST = 70
USER2PARAM_NEWDRESSING = 26
USER2PARAM_NEWMENU = 16
USER2PARAM_NEWPORTRAITFRAME = 20
USER2PARAM_NEWTRANSMAP = 12
USER2PARAM_NEW_DEATH_TRANSFER = 152
USER2PARAM_NEW_MAPAREA = 64
USER2PARAM_NEW_SET_OPTION = 106
USER2PARAM_NPCANGLE = 49
USER2PARAM_NPCDATASYNC = 3
USER2PARAM_NPCFUNC = 33
USER2PARAM_NTF_SEAT = 102
USER2PARAM_NTF_VISIBLENPC = 105
USER2PARAM_OPENUI = 29
USER2PARAM_PHOTO = 44
USER2PARAM_PRESETCHATMSG = 36
USER2PARAM_PROFESSION_BUY = 132
USER2PARAM_PROFESSION_CHANGE = 133
USER2PARAM_PROFESSION_QUERY = 131
USER2PARAM_PUTSHORTCUT = 48
USER2PARAM_QUERYFIGHTERINFO = 38
USER2PARAM_QUERYPORTRAITLIST = 24
USER2PARAM_QUERYSHOPGOTITEM = 22
USER2PARAM_QUERYSHORTCUT = 47
USER2PARAM_QUERYUSERINFO = 84
USER2PARAM_QUERY_ACTION = 69
USER2PARAM_QUERY_ALTMAN_KILL = 143
USER2PARAM_QUERY_MAPAREA = 63
USER2PARAM_QUERY_STAGE = 148
USER2PARAM_QUERY_TRACE_LIST = 75
USER2PARAM_QUERY_ZONESTATUS = 91
USER2PARAM_RELIVE = 8
USER2PARAM_REQUIRENPCFUNC = 100
USER2PARAM_SAVE_RECORD = 135
USER2PARAM_SCENERY = 58
USER2PARAM_SERVANT_GROWTH = 154
USER2PARAM_SERVANT_GROWTH_OPEN = 156
USER2PARAM_SERVANT_RECEIVE = 126
USER2PARAM_SERVANT_RECEIVE_GROWTH = 155
USER2PARAM_SERVANT_RECOMMEND = 125
USER2PARAM_SERVANT_REC_EQUIP = 173
USER2PARAM_SERVANT_REPLACE = 123
USER2PARAM_SERVANT_REQ_RESERVATION = 171
USER2PARAM_SERVANT_RESERVATION = 172
USER2PARAM_SERVANT_REWARD_STATUS = 127
USER2PARAM_SERVANT_SERVICE = 124
USER2PARAM_SERVANT_SHOW = 122
USER2PARAM_SERVERTIME = 11
USER2PARAM_SETOPTION = 83
USER2PARAM_SET_DIRECTION = 77
USER2PARAM_SET_NORMALSKILL_OPTION = 103
USER2PARAM_SHAKESCREEN = 45
USER2PARAM_SHAKETREE = 87
USER2PARAM_SHOW_SEAT = 115
USER2PARAM_SIGNIN = 164
USER2PARAM_SIGNIN_NTF = 165
USER2PARAM_SOUNDEFFECT = 35
USER2PARAM_SPECIAL_EFFECT = 116
USER2PARAM_STATECHANGE = 42
USER2PARAM_SYSMSG = 2
USER2PARAM_TALKINFO = 10
USER2PARAM_TEAMINFONINE = 17
USER2PARAM_TRANSFER = 153
USER2PARAM_TRANSFORM_PREDATA = 108
USER2PARAM_TREELIST = 88
USER2PARAM_TWINS_ACTION = 129
USER2PARAM_UNLOCK_FRAME = 161
USER2PARAM_UNSOLVED_SCENERY_NTF = 104
USER2PARAM_UPDATESHOPGOTITEM = 23
USER2PARAM_UPDATE_BRANCH_INFO = 140
USER2PARAM_UPDATE_RECORD_INFO = 134
USER2PARAM_UPDATE_TRACE_LIST = 76
USER2PARAM_UPLOAD_OK_SCENERY = 73
USER2PARAM_UPLOAD_SCENERY_PHOTO = 62
USER2PARAM_UPLOAD_WEDDING_PHOTO = 119
USER2PARAM_UPYUN_AUTHORIZATION = 107
USER2PARAM_USEDRESSING = 25
USER2PARAM_USEFRAME = 19
USER2PARAM_USEPORTRAIT = 18
USER2PARAM_USERNINESYNC = 4
USER2PARAM_USER_BOOTH_REQ = 144
USER2PARAM_USER_RENAME = 109
USER2PARAM_VAR = 9
USER2PARAM_YOYO_SEAT = 114
UnlockFrameUserCmd = protobuf.Message(UNLOCKFRAMEUSERCMD)
UnsolvedSceneryNtfUserCmd = protobuf.Message(UNSOLVEDSCENERYNTFUSERCMD)
UpdateBranchInfoUserCmd = protobuf.Message(UPDATEBRANCHINFOUSERCMD)
UpdateRecordInfoUserCmd = protobuf.Message(UPDATERECORDINFOUSERCMD)
UpdateShopGotItem = protobuf.Message(UPDATESHOPGOTITEM)
UpdateTraceList = protobuf.Message(UPDATETRACELIST)
UploadOkSceneryUserCmd = protobuf.Message(UPLOADOKSCENERYUSERCMD)
UploadSceneryPhotoUserCmd = protobuf.Message(UPLOADSCENERYPHOTOUSERCMD)
UploadWeddingPhotoUserCmd = protobuf.Message(UPLOADWEDDINGPHOTOUSERCMD)
UpyunAuthorizationCmd = protobuf.Message(UPYUNAUTHORIZATIONCMD)
UpyunUrl = protobuf.Message(UPYUNURL)
UseDeathTransferCmd = protobuf.Message(USEDEATHTRANSFERCMD)
UseDressing = protobuf.Message(USEDRESSING)
UseFrame = protobuf.Message(USEFRAME)
UsePortrait = protobuf.Message(USEPORTRAIT)
UserActionNtf = protobuf.Message(USERACTIONNTF)
UserAstrolMaterialData = protobuf.Message(USERASTROLMATERIALDATA)
UserAutoHitCmd = protobuf.Message(USERAUTOHITCMD)
UserBuffNineSyncCmd = protobuf.Message(USERBUFFNINESYNCCMD)
UserNineSyncCmd = protobuf.Message(USERNINESYNCCMD)
UserRenameCmd = protobuf.Message(USERRENAMECMD)
VarUpdate = protobuf.Message(VARUPDATE)
VisibleNpc = protobuf.Message(VISIBLENPC)
YoyoSeatUserCmd = protobuf.Message(YOYOSEATUSERCMD)
ZoneInfo = protobuf.Message(ZONEINFO)
