local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
autoImport("ProtoCommon_pb")
local ProtoCommon_pb = ProtoCommon_pb
module("SceneItem_pb")
ITEMPARAM = protobuf.EnumDescriptor()
ITEMPARAM_ITEMPARAM_PACKAGEITEM_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_PACKAGEUPDATE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_ITEMUSE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_PACKAGESORT_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_EQUIP_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_SELLITEM_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_EQUIPSTRENGTH_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_PRODUCE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_PRODUCEDONE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_REFINE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_DECOMPOSE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_QUERYEQUIPDATA_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_BROWSEPACK_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_EQUIPCARD_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_ITEMSHOW_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_REPAIR_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_HINTNTF_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_ENCHANT_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_PROCESSENCHANT_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_EQUIPEXCHANGE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_ONOFFSTORE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_PACKSLOTNTF_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_RESTOREEQUIP_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_USECOUNT_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_QUERYDECOMPOSERESULT_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_EXCHANGECARD_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_GETCOUNT_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_SAVE_LOVE_LETTER_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_ITEMDATASHOW_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_LOTTERY_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_LOTTERY_RECOVERY_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_QUERY_LOTTERYINFO_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_ITEMSHOW64_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_HIGHREFINE_MATCOMPOSE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_HIGHREFINE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_NTF_HIGHTREFINE_DATA_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_UPDATE_HIGHTREFINE_DATA_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_REQ_QUOTA_LOG_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_REQ_QUOTA_DETAIL_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_EQUIPPOSDATA_UPDATE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_USE_CODE_ITEM_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_ADD_JOBLEVEL_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_LOTTERY_GIVE_BUY_COUNT_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_GIVE_WEDDING_DRESS_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_QUICK_STOREITEM_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_QUICK_SELLITEM_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_ENCHANT_TRANS_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_QUERY_LOTTERYHEAD_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_LOTTERY_RATE_QUERY_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_EQUIPCOMPOSE_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_QUERY_ITEMDEBT_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_FAVORITE_ACTION_ENUM = protobuf.EnumValueDescriptor()
ITEMPARAM_ITEMPARAM_LOTTERY_ACTIVITY_NTF_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE = protobuf.EnumDescriptor()
EPACKTYPE_EPACKTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_MAIN_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_EQUIP_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_FASHION_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_FASHIONEQUIP_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_CARD_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_STORE_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_PERSONAL_STORE_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_TEMP_MAIN_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_BARROW_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_QUEST_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_FOOD_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_PET_ENUM = protobuf.EnumValueDescriptor()
EPACKTYPE_EPACKTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE = protobuf.EnumDescriptor()
EITEMTYPE_EITEMTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_HONOR_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_STREASURE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_TREASURE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_STUFF_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_STUFFNOCUT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARROW_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_USESKILL_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_GHOSTLAMP_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MULTITIME_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MONTHCARD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_QUEST_ONCE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_QUEST_TIME_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_SHEET_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PET_WEARSHEET_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PET_WEARUNLOCK_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CONSUME_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_HAIRSTUFF_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CONSUME_2_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_COLLECTION_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_RANGE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FUNCTION_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ACTIVITY_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEDDING_RING_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MATERIAL_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_LETTER_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_GOLDAPPLE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_GETSKILL_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PICKEFFECT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FRIEND_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PICKEFFECT_1_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_TOY_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CARD_WEAPON_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CARD_ASSIST_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CARD_ARMOUR_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CARD_ROBE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CARD_SHOES_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CARD_ACCESSORY_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CARD_HEAD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MOUNT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_BARROW_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PET_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_EGG_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PET_EQUIP_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PET_CONSUME_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CARDPIECE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_EQUIPPIECE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FASHION_PIECE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_GOLD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_SILVER_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_DIAMOND_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_GARDEN_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CONTRIBUTE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ASSET_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FRIENDSHIP_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MANUALSPOINT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MORA_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PVPCOIN_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_QUOTA_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_BASEEXP_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_JOBEXP_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PURIFY_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MANUALPOINT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_LOTTERY_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_COOKER_EXP_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_GUILDHONOR_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_POLLY_COIN_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_QUESTITEM_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_COURAGE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_QUESTITEMCOUNT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEDDING_CERT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEDDING_INVITE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEDDING_MANUAL_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_DEADCOIN_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_LANCE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_SWORD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_WAND_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_KNIFE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_BOW_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_HAMMER_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_AXE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_BOOK_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_DAGGER_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_INSTRUMEMT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_WHIP_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_TUBE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WEAPON_FIST_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_LANCE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_SWORD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_WAND_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_KNIFE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_BOW_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_HAMMER_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_AXE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_DAGGER_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_FIST_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_INSTRUMEMT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_WHIP_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_BOOK_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_HEAD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARTIFACT_BACK_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARMOUR_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ARMOUR_FASHION_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_SHIELD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PEARL_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_EIKON_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_BRACER_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_BRACELET_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_TROLLEY_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ROBE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_SHOES_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_ACCESSORY_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FOOD_MEAT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FOOD_FISH_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FOOD_VEGETABLE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FOOD_FRUIT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FOOD_SEASONING_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FOOD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_HEAD_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_BACK_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_HAIR_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_HAIR_MALE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_HAIR_FEMALE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_EYE_MALE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_EYE_FEMALE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FACE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_TAIL_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MOUTH_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_WATER_ELEMENT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_PORTRAIT_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_FRAME_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_CODE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_KFC_CODE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_DRAW_CODE_ENUM = protobuf.EnumValueDescriptor()
EITEMTYPE_EITEMTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE = protobuf.EnumDescriptor()
EEQUIPTYPE_EEQUIPTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_WEAPON_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_SHIELD_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_ARMOUR_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_ROBE_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_SHOES_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_ACCESSORY_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_HEAD_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_BACK_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_FACE_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_TAIL_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_MOUNT_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_MOUTH_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_BARROW_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_PEARL_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_EIKON_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_BRACELET_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_HANDBRACELET_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_TROLLEY_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_HEAD_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_BACK_ENUM = protobuf.EnumValueDescriptor()
EEQUIPTYPE_EEQUIPTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EBINDTYPE = protobuf.EnumDescriptor()
EBINDTYPE_EBINDTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EBINDTYPE_EBINDTYPE_BIND_ENUM = protobuf.EnumValueDescriptor()
EBINDTYPE_EBINDTYPE_NOBIND_ENUM = protobuf.EnumValueDescriptor()
EBINDTYPE_EBINDTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EEXPIRETYPE = protobuf.EnumDescriptor()
EEXPIRETYPE_EEXPIRETYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EEXPIRETYPE_EEXPIRETYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
ERIDETYPE = protobuf.EnumDescriptor()
ERIDETYPE_ERIDETYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
ERIDETYPE_ERIDETYPE_ON_ENUM = protobuf.EnumValueDescriptor()
ERIDETYPE_ERIDETYPE_OFF_ENUM = protobuf.EnumValueDescriptor()
ERIDETYPE_ERIDETYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
ETRAGETTYPE = protobuf.EnumDescriptor()
ETRAGETTYPE_ETARGETTYPE_MY_ENUM = protobuf.EnumValueDescriptor()
ETRAGETTYPE_ETARGETTYPE_USER_ENUM = protobuf.EnumValueDescriptor()
ETRAGETTYPE_ETARGETTYPE_MONSTER_ENUM = protobuf.EnumValueDescriptor()
ETRAGETTYPE_ETARGETTYPE_USERANDMONSTER_ENUM = protobuf.EnumValueDescriptor()
EENCHANTTYPE = protobuf.EnumDescriptor()
EENCHANTTYPE_EENCHANTTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EENCHANTTYPE_EENCHANTTYPE_PRIMARY_ENUM = protobuf.EnumValueDescriptor()
EENCHANTTYPE_EENCHANTTYPE_MEDIUM_ENUM = protobuf.EnumValueDescriptor()
EENCHANTTYPE_EENCHANTTYPE_SENIOR_ENUM = protobuf.EnumValueDescriptor()
EENCHANTTYPE_EENCHANTTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
ELETTERTYPE = protobuf.EnumDescriptor()
ELETTERTYPE_ELETTERTYPE_LOVE_ENUM = protobuf.EnumValueDescriptor()
ELETTERTYPE_ELETTERTYPE_CONSTELLATION_ENUM = protobuf.EnumValueDescriptor()
ELETTERTYPE_ELETTERTYPE_CHRISTMAS_ENUM = protobuf.EnumValueDescriptor()
ELETTERTYPE_ELETTERTYPE_SPRING_ENUM = protobuf.EnumValueDescriptor()
ELETTERTYPE_ELETTERTYPE_LOTTERY_ENUM = protobuf.EnumValueDescriptor()
ELETTERTYPE_ELETTERTYPE_WEDDINGDRESS_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER = protobuf.EnumDescriptor()
EEQUIPOPER_EEQUIPOPER_MIN_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_ON_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_OFF_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_PUTFASHION_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_OFFFASHION_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_PUTSTORE_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_OFFSTORE_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_OFFALL_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_OFFPOS_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_PUTPSTORE_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_OFFPSTORE_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_OFFTEMP_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_PUTBARROW_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_OFFBARROW_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_DRESSUP_ON_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_DRESSUP_OFF_ENUM = protobuf.EnumValueDescriptor()
EEQUIPOPER_EEQUIPOPER_MAX_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS = protobuf.EnumDescriptor()
EEQUIPPOS_EEQUIPPOS_MIN_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_WEAPON_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_ARMOUR_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_SHIELD_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_ROBE_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_SHOES_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_ACCESSORY1_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_ACCESSORY2_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_HEAD_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_BACK_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_FACE_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_TAIL_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_MOUNT_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_MOUTH_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_BARROW_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_ARTIFACT_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_ARTIFACT_HEAD_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_ARTIFACT_BACK_ENUM = protobuf.EnumValueDescriptor()
EEQUIPPOS_EEQUIPPOS_MAX_ENUM = protobuf.EnumValueDescriptor()
ESTRENGTHRESULT = protobuf.EnumDescriptor()
ESTRENGTHRESULT_ESTRENGTHRESULT_MIN_ENUM = protobuf.EnumValueDescriptor()
ESTRENGTHRESULT_ESTRENGTHRESULT_SUCCESS_ENUM = protobuf.EnumValueDescriptor()
ESTRENGTHRESULT_ESTRENGTHRESULT_NOMATERIAL_ENUM = protobuf.EnumValueDescriptor()
ESTRENGTHRESULT_ESTRENGTHRESULT_MAXLV_ENUM = protobuf.EnumValueDescriptor()
ESTRENGTHTYPE = protobuf.EnumDescriptor()
ESTRENGTHTYPE_ESTRENGTHTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
ESTRENGTHTYPE_ESTRENGTHTYPE_NORMAL_ENUM = protobuf.EnumValueDescriptor()
ESTRENGTHTYPE_ESTRENGTHTYPE_GUILD_ENUM = protobuf.EnumValueDescriptor()
ESTRENGTHTYPE_ESTRENGTHTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EPRODUCETYPE = protobuf.EnumDescriptor()
EPRODUCETYPE_EPRODUCETYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EPRODUCETYPE_EPRODUCETYPE_HEAD_ENUM = protobuf.EnumValueDescriptor()
EPRODUCETYPE_EPRODUCETYPE_EQUIP_ENUM = protobuf.EnumValueDescriptor()
EPRODUCETYPE_EPRODUCETYPE_TRADER_ENUM = protobuf.EnumValueDescriptor()
EPRODUCETYPE_EPRODUCETYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EREFINERESULT = protobuf.EnumDescriptor()
EREFINERESULT_EREFINERESULT_MIN_ENUM = protobuf.EnumValueDescriptor()
EREFINERESULT_EREFINERESULT_SUCCESS_ENUM = protobuf.EnumValueDescriptor()
EREFINERESULT_EREFINERESULT_FAILSTAY_ENUM = protobuf.EnumValueDescriptor()
EREFINERESULT_EREFINERESULT_FAILBACK_ENUM = protobuf.EnumValueDescriptor()
EREFINERESULT_EREFINERESULT_FAILSTAYDAM_ENUM = protobuf.EnumValueDescriptor()
EREFINERESULT_EREFINERESULT_FAILBACKDAM_ENUM = protobuf.EnumValueDescriptor()
EREFINERESULT_EREFINERESULT_MAX_ENUM = protobuf.EnumValueDescriptor()
EDECOMPOSERESULT = protobuf.EnumDescriptor()
EDECOMPOSERESULT_EDECOMPOSERESULT_MIN_ENUM = protobuf.EnumValueDescriptor()
EDECOMPOSERESULT_EDECOMPOSERESULT_FAIL_ENUM = protobuf.EnumValueDescriptor()
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_ENUM = protobuf.EnumValueDescriptor()
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_BIG_ENUM = protobuf.EnumValueDescriptor()
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_SBIG_ENUM = protobuf.EnumValueDescriptor()
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_FANTASY_ENUM = protobuf.EnumValueDescriptor()
EDECOMPOSERESULT_EDECOMPOSERESULT_MAX_ENUM = protobuf.EnumValueDescriptor()
ECARDOPER = protobuf.EnumDescriptor()
ECARDOPER_ECARDOPER_MIN_ENUM = protobuf.EnumValueDescriptor()
ECARDOPER_ECARDOPER_EQUIPON_ENUM = protobuf.EnumValueDescriptor()
ECARDOPER_ECARDOPER_EQUIPOFF_ENUM = protobuf.EnumValueDescriptor()
ECARDOPER_ECARDOPER_MAX_ENUM = protobuf.EnumValueDescriptor()
ETRADETYPE = protobuf.EnumDescriptor()
ETRADETYPE_ETRADETYPE_ALL_ENUM = protobuf.EnumValueDescriptor()
ETRADETYPE_ETRADETYPE_TRADE_ENUM = protobuf.EnumValueDescriptor()
ETRADETYPE_ETRADETYPE_BOOTH_ENUM = protobuf.EnumValueDescriptor()
EEXCHANGETYPE = protobuf.EnumDescriptor()
EEXCHANGETYPE_EEXCHANGETYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EEXCHANGETYPE_EEXCHANGETYPE_EXCHANGE_ENUM = protobuf.EnumValueDescriptor()
EEXCHANGETYPE_EEXCHANGETYPE_LEVELUP_ENUM = protobuf.EnumValueDescriptor()
EEXCHANGETYPE_EEXCHANGETYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EEXCHANGECARDTYPE = protobuf.EnumDescriptor()
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DRAW_ENUM = protobuf.EnumValueDescriptor()
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_COMPOSE_ENUM = protobuf.EnumValueDescriptor()
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DECOMPOSE_ENUM = protobuf.EnumValueDescriptor()
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_BOSSCOMPOSE_ENUM = protobuf.EnumValueDescriptor()
ELOTTERYTYPE = protobuf.EnumDescriptor()
ELOTTERYTYPE_ELOTTERYTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
ELOTTERYTYPE_ELOTTERYTYPE_HEAD_ENUM = protobuf.EnumValueDescriptor()
ELOTTERYTYPE_ELOTTERYTYPE_EQUIP_ENUM = protobuf.EnumValueDescriptor()
ELOTTERYTYPE_ELOTTERYTYPE_CARD_ENUM = protobuf.EnumValueDescriptor()
ELOTTERYTYPE_ELOTTERYTYPE_CATLITTERBOX_ENUM = protobuf.EnumValueDescriptor()
ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_ENUM = protobuf.EnumValueDescriptor()
ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_2_ENUM = protobuf.EnumValueDescriptor()
ELOTTERYTYPE_ELOTTERYTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE = protobuf.EnumDescriptor()
EQUOTATYPE_EQUOTATYPE_G_CHARGE_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_C_GIVE_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_C_AUCTION_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_G_AUCTION_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_C_LOTTERY_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_C_GUILDBOX_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_C_WEDDINGDRESS_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_L_BOOTH_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_U_BOOTH_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_C_BOOTH_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_L_GIVE_TRADE_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_U_GIVE_TRADE_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_C_GIVE_TRADE_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_G_REWARD_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_C_GUILDMATERIAL_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_L_CHARGE_ENUM = protobuf.EnumValueDescriptor()
EQUOTATYPE_EQUOTATYPE_U_CHARGE_ENUM = protobuf.EnumValueDescriptor()
EFAVORITEACTION = protobuf.EnumDescriptor()
EFAVORITEACTION_EFAVORITEACTION_MIN_ENUM = protobuf.EnumValueDescriptor()
EFAVORITEACTION_EFAVORITEACTION_ADD_ENUM = protobuf.EnumValueDescriptor()
EFAVORITEACTION_EFAVORITEACTION_DEL_ENUM = protobuf.EnumValueDescriptor()
EFAVORITEACTION_EFAVORITEACTION_MAX_ENUM = protobuf.EnumValueDescriptor()
ITEMINFO = protobuf.Descriptor()
ITEMINFO_GUID_FIELD = protobuf.FieldDescriptor()
ITEMINFO_ID_FIELD = protobuf.FieldDescriptor()
ITEMINFO_COUNT_FIELD = protobuf.FieldDescriptor()
ITEMINFO_INDEX_FIELD = protobuf.FieldDescriptor()
ITEMINFO_CREATETIME_FIELD = protobuf.FieldDescriptor()
ITEMINFO_CD_FIELD = protobuf.FieldDescriptor()
ITEMINFO_TYPE_FIELD = protobuf.FieldDescriptor()
ITEMINFO_BIND_FIELD = protobuf.FieldDescriptor()
ITEMINFO_EXPIRE_FIELD = protobuf.FieldDescriptor()
ITEMINFO_QUALITY_FIELD = protobuf.FieldDescriptor()
ITEMINFO_EQUIPTYPE_FIELD = protobuf.FieldDescriptor()
ITEMINFO_SOURCE_FIELD = protobuf.FieldDescriptor()
ITEMINFO_ISNEW_FIELD = protobuf.FieldDescriptor()
ITEMINFO_MAXCARDSLOT_FIELD = protobuf.FieldDescriptor()
ITEMINFO_ISHINT_FIELD = protobuf.FieldDescriptor()
ITEMINFO_ISACTIVE_FIELD = protobuf.FieldDescriptor()
ITEMINFO_SOURCE_NPC_FIELD = protobuf.FieldDescriptor()
ITEMINFO_REFINELV_FIELD = protobuf.FieldDescriptor()
ITEMINFO_CHARGEMONEY_FIELD = protobuf.FieldDescriptor()
ITEMINFO_OVERTIME_FIELD = protobuf.FieldDescriptor()
ITEMINFO_QUOTA_FIELD = protobuf.FieldDescriptor()
ITEMINFO_USEDTIMES_FIELD = protobuf.FieldDescriptor()
ITEMINFO_USEDTIME_FIELD = protobuf.FieldDescriptor()
ITEMINFO_ISFAVORITE_FIELD = protobuf.FieldDescriptor()
REFINECOMPOSE = protobuf.Descriptor()
REFINECOMPOSE_ID_FIELD = protobuf.FieldDescriptor()
REFINECOMPOSE_NUM_FIELD = protobuf.FieldDescriptor()
EQUIPDATA = protobuf.Descriptor()
EQUIPDATA_STRENGTHLV_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_REFINELV_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_STRENGTHCOST_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_REFINECOMPOSE_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_CARDSLOT_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_BUFFID_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_DAMAGE_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_LV_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_COLOR_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_BREAKSTARTTIME_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_BREAKENDTIME_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_STRENGTHLV2_FIELD = protobuf.FieldDescriptor()
EQUIPDATA_STRENGTHLV2COST_FIELD = protobuf.FieldDescriptor()
CARDDATA = protobuf.Descriptor()
CARDDATA_GUID_FIELD = protobuf.FieldDescriptor()
CARDDATA_ID_FIELD = protobuf.FieldDescriptor()
CARDDATA_POS_FIELD = protobuf.FieldDescriptor()
ENCHANTATTR = protobuf.Descriptor()
ENCHANTATTR_TYPE_FIELD = protobuf.FieldDescriptor()
ENCHANTATTR_VALUE_FIELD = protobuf.FieldDescriptor()
ENCHANTEXTRA = protobuf.Descriptor()
ENCHANTEXTRA_CONFIGID_FIELD = protobuf.FieldDescriptor()
ENCHANTEXTRA_BUFFID_FIELD = protobuf.FieldDescriptor()
ENCHANTDATA = protobuf.Descriptor()
ENCHANTDATA_TYPE_FIELD = protobuf.FieldDescriptor()
ENCHANTDATA_ATTRS_FIELD = protobuf.FieldDescriptor()
ENCHANTDATA_EXTRAS_FIELD = protobuf.FieldDescriptor()
ENCHANTDATA_PATCH_FIELD = protobuf.FieldDescriptor()
REFINEDATA = protobuf.Descriptor()
REFINEDATA_LASTFAIL_FIELD = protobuf.FieldDescriptor()
REFINEDATA_REPAIRCOUNT_FIELD = protobuf.FieldDescriptor()
EGGEQUIP = protobuf.Descriptor()
EGGEQUIP_BASE_FIELD = protobuf.FieldDescriptor()
EGGEQUIP_DATA_FIELD = protobuf.FieldDescriptor()
EGGEQUIP_CARD_FIELD = protobuf.FieldDescriptor()
EGGEQUIP_ENCHANT_FIELD = protobuf.FieldDescriptor()
EGGEQUIP_PREVIEWENCHANT_FIELD = protobuf.FieldDescriptor()
EGGEQUIP_REFINE_FIELD = protobuf.FieldDescriptor()
PETEQUIPDATA = protobuf.Descriptor()
PETEQUIPDATA_EPOS_FIELD = protobuf.FieldDescriptor()
PETEQUIPDATA_ITEMID_FIELD = protobuf.FieldDescriptor()
EGGDATA = protobuf.Descriptor()
EGGDATA_EXP_FIELD = protobuf.FieldDescriptor()
EGGDATA_FRIENDEXP_FIELD = protobuf.FieldDescriptor()
EGGDATA_REWARDEXP_FIELD = protobuf.FieldDescriptor()
EGGDATA_ID_FIELD = protobuf.FieldDescriptor()
EGGDATA_LV_FIELD = protobuf.FieldDescriptor()
EGGDATA_FRIENDLV_FIELD = protobuf.FieldDescriptor()
EGGDATA_BODY_FIELD = protobuf.FieldDescriptor()
EGGDATA_RELIVETIME_FIELD = protobuf.FieldDescriptor()
EGGDATA_HP_FIELD = protobuf.FieldDescriptor()
EGGDATA_RESTORETIME_FIELD = protobuf.FieldDescriptor()
EGGDATA_TIME_HAPPLY_FIELD = protobuf.FieldDescriptor()
EGGDATA_TIME_EXCITE_FIELD = protobuf.FieldDescriptor()
EGGDATA_TIME_HAPPINESS_FIELD = protobuf.FieldDescriptor()
EGGDATA_TIME_HAPPLY_GIFT_FIELD = protobuf.FieldDescriptor()
EGGDATA_TIME_EXCITE_GIFT_FIELD = protobuf.FieldDescriptor()
EGGDATA_TIME_HAPPINESS_GIFT_FIELD = protobuf.FieldDescriptor()
EGGDATA_TOUCH_TICK_FIELD = protobuf.FieldDescriptor()
EGGDATA_FEED_TICK_FIELD = protobuf.FieldDescriptor()
EGGDATA_NAME_FIELD = protobuf.FieldDescriptor()
EGGDATA_VAR_FIELD = protobuf.FieldDescriptor()
EGGDATA_SKILLIDS_FIELD = protobuf.FieldDescriptor()
EGGDATA_EQUIPS_FIELD = protobuf.FieldDescriptor()
EGGDATA_BUFF_FIELD = protobuf.FieldDescriptor()
EGGDATA_UNLOCK_EQUIP_FIELD = protobuf.FieldDescriptor()
EGGDATA_UNLOCK_BODY_FIELD = protobuf.FieldDescriptor()
EGGDATA_VERSION_FIELD = protobuf.FieldDescriptor()
EGGDATA_SKILLOFF_FIELD = protobuf.FieldDescriptor()
EGGDATA_EXCHANGE_COUNT_FIELD = protobuf.FieldDescriptor()
EGGDATA_GUID_FIELD = protobuf.FieldDescriptor()
EGGDATA_DEFAULTWEARS_FIELD = protobuf.FieldDescriptor()
EGGDATA_WEARS_FIELD = protobuf.FieldDescriptor()
LOVELETTERDATA = protobuf.Descriptor()
LOVELETTERDATA_SENDUSERNAME_FIELD = protobuf.FieldDescriptor()
LOVELETTERDATA_BG_FIELD = protobuf.FieldDescriptor()
LOVELETTERDATA_CONFIGID_FIELD = protobuf.FieldDescriptor()
LOVELETTERDATA_CONTENT_FIELD = protobuf.FieldDescriptor()
LOVELETTERDATA_CONTENT2_FIELD = protobuf.FieldDescriptor()
CODEDATA = protobuf.Descriptor()
CODEDATA_CODE_FIELD = protobuf.FieldDescriptor()
CODEDATA_USED_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA = protobuf.Descriptor()
WEDDINGDATA_ID_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_ZONEID_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_CHARID1_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_CHARID2_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_WEDDINGTIME_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_PHOTOIDX_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_PHOTOTIME_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_MYNAME_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_PARTNERNAME_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_STARTTIME_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_ENDTIME_FIELD = protobuf.FieldDescriptor()
WEDDINGDATA_NOTIFIED_FIELD = protobuf.FieldDescriptor()
SENDERDATA = protobuf.Descriptor()
SENDERDATA_CHARID_FIELD = protobuf.FieldDescriptor()
SENDERDATA_NAME_FIELD = protobuf.FieldDescriptor()
ITEMDATA = protobuf.Descriptor()
ITEMDATA_BASE_FIELD = protobuf.FieldDescriptor()
ITEMDATA_EQUIPED_FIELD = protobuf.FieldDescriptor()
ITEMDATA_BATTLEPOINT_FIELD = protobuf.FieldDescriptor()
ITEMDATA_EQUIP_FIELD = protobuf.FieldDescriptor()
ITEMDATA_CARD_FIELD = protobuf.FieldDescriptor()
ITEMDATA_ENCHANT_FIELD = protobuf.FieldDescriptor()
ITEMDATA_PREVIEWENCHANT_FIELD = protobuf.FieldDescriptor()
ITEMDATA_REFINE_FIELD = protobuf.FieldDescriptor()
ITEMDATA_EGG_FIELD = protobuf.FieldDescriptor()
ITEMDATA_LETTER_FIELD = protobuf.FieldDescriptor()
ITEMDATA_CODE_FIELD = protobuf.FieldDescriptor()
ITEMDATA_WEDDING_FIELD = protobuf.FieldDescriptor()
ITEMDATA_SENDER_FIELD = protobuf.FieldDescriptor()
PACKAGEITEM = protobuf.Descriptor()
PACKAGEITEM_CMD_FIELD = protobuf.FieldDescriptor()
PACKAGEITEM_PARAM_FIELD = protobuf.FieldDescriptor()
PACKAGEITEM_TYPE_FIELD = protobuf.FieldDescriptor()
PACKAGEITEM_DATA_FIELD = protobuf.FieldDescriptor()
PACKAGEITEM_MAXSLOT_FIELD = protobuf.FieldDescriptor()
PACKAGEUPDATE = protobuf.Descriptor()
PACKAGEUPDATE_CMD_FIELD = protobuf.FieldDescriptor()
PACKAGEUPDATE_PARAM_FIELD = protobuf.FieldDescriptor()
PACKAGEUPDATE_TYPE_FIELD = protobuf.FieldDescriptor()
PACKAGEUPDATE_UPDATEITEMS_FIELD = protobuf.FieldDescriptor()
PACKAGEUPDATE_DELITEMS_FIELD = protobuf.FieldDescriptor()
ITEMUSE = protobuf.Descriptor()
ITEMUSE_CMD_FIELD = protobuf.FieldDescriptor()
ITEMUSE_PARAM_FIELD = protobuf.FieldDescriptor()
ITEMUSE_ITEMGUID_FIELD = protobuf.FieldDescriptor()
ITEMUSE_TARGETS_FIELD = protobuf.FieldDescriptor()
ITEMUSE_COUNT_FIELD = protobuf.FieldDescriptor()
SORTINFO = protobuf.Descriptor()
SORTINFO_GUID_FIELD = protobuf.FieldDescriptor()
SORTINFO_INDEX_FIELD = protobuf.FieldDescriptor()
PACKAGESORT = protobuf.Descriptor()
PACKAGESORT_CMD_FIELD = protobuf.FieldDescriptor()
PACKAGESORT_PARAM_FIELD = protobuf.FieldDescriptor()
PACKAGESORT_TYPE_FIELD = protobuf.FieldDescriptor()
PACKAGESORT_ITEM_FIELD = protobuf.FieldDescriptor()
EQUIP = protobuf.Descriptor()
EQUIP_CMD_FIELD = protobuf.FieldDescriptor()
EQUIP_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIP_OPER_FIELD = protobuf.FieldDescriptor()
EQUIP_POS_FIELD = protobuf.FieldDescriptor()
EQUIP_GUID_FIELD = protobuf.FieldDescriptor()
EQUIP_TRANSFER_FIELD = protobuf.FieldDescriptor()
EQUIP_COUNT_FIELD = protobuf.FieldDescriptor()
SITEM = protobuf.Descriptor()
SITEM_GUID_FIELD = protobuf.FieldDescriptor()
SITEM_COUNT_FIELD = protobuf.FieldDescriptor()
SELLITEM = protobuf.Descriptor()
SELLITEM_CMD_FIELD = protobuf.FieldDescriptor()
SELLITEM_PARAM_FIELD = protobuf.FieldDescriptor()
SELLITEM_NPCID_FIELD = protobuf.FieldDescriptor()
SELLITEM_ITEMS_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH = protobuf.Descriptor()
EQUIPSTRENGTH_CMD_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_GUID_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_DESTCOUNT_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_COUNT_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_CRICOUNT_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_OLDLV_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_NEWLV_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_RESULT_FIELD = protobuf.FieldDescriptor()
EQUIPSTRENGTH_TYPE_FIELD = protobuf.FieldDescriptor()
PRODUCE = protobuf.Descriptor()
PRODUCE_CMD_FIELD = protobuf.FieldDescriptor()
PRODUCE_PARAM_FIELD = protobuf.FieldDescriptor()
PRODUCE_TYPE_FIELD = protobuf.FieldDescriptor()
PRODUCE_COMPOSEID_FIELD = protobuf.FieldDescriptor()
PRODUCE_NPCID_FIELD = protobuf.FieldDescriptor()
PRODUCE_ITEMID_FIELD = protobuf.FieldDescriptor()
PRODUCE_COUNT_FIELD = protobuf.FieldDescriptor()
PRODUCE_QUCIKPRODUCE_FIELD = protobuf.FieldDescriptor()
PRODUCEDONE = protobuf.Descriptor()
PRODUCEDONE_CMD_FIELD = protobuf.FieldDescriptor()
PRODUCEDONE_PARAM_FIELD = protobuf.FieldDescriptor()
PRODUCEDONE_TYPE_FIELD = protobuf.FieldDescriptor()
PRODUCEDONE_NPCID_FIELD = protobuf.FieldDescriptor()
PRODUCEDONE_CHARID_FIELD = protobuf.FieldDescriptor()
PRODUCEDONE_DELAY_FIELD = protobuf.FieldDescriptor()
PRODUCEDONE_ITEMID_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE = protobuf.Descriptor()
EQUIPREFINE_CMD_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE_GUID_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE_COMPOSEID_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE_REFINELV_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE_ERESULT_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE_NPCID_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE_SAFEREFINE_FIELD = protobuf.FieldDescriptor()
EQUIPREFINE_ITEMGUID_FIELD = protobuf.FieldDescriptor()
EQUIPDECOMPOSE = protobuf.Descriptor()
EQUIPDECOMPOSE_CMD_FIELD = protobuf.FieldDescriptor()
EQUIPDECOMPOSE_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIPDECOMPOSE_GUID_FIELD = protobuf.FieldDescriptor()
EQUIPDECOMPOSE_RESULT_FIELD = protobuf.FieldDescriptor()
EQUIPDECOMPOSE_ITEMS_FIELD = protobuf.FieldDescriptor()
DECOMPOSERESULT = protobuf.Descriptor()
DECOMPOSERESULT_ITEM_FIELD = protobuf.FieldDescriptor()
DECOMPOSERESULT_RATE_FIELD = protobuf.FieldDescriptor()
DECOMPOSERESULT_MIN_COUNT_FIELD = protobuf.FieldDescriptor()
DECOMPOSERESULT_MAX_COUNT_FIELD = protobuf.FieldDescriptor()
QUERYDECOMPOSERESULTITEMCMD = protobuf.Descriptor()
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD = protobuf.FieldDescriptor()
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD = protobuf.FieldDescriptor()
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD = protobuf.FieldDescriptor()
QUERYEQUIPDATA = protobuf.Descriptor()
QUERYEQUIPDATA_CMD_FIELD = protobuf.FieldDescriptor()
QUERYEQUIPDATA_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYEQUIPDATA_GUID_FIELD = protobuf.FieldDescriptor()
QUERYEQUIPDATA_DATA_FIELD = protobuf.FieldDescriptor()
BROWSEPACKAGE = protobuf.Descriptor()
BROWSEPACKAGE_CMD_FIELD = protobuf.FieldDescriptor()
BROWSEPACKAGE_PARAM_FIELD = protobuf.FieldDescriptor()
BROWSEPACKAGE_TYPE_FIELD = protobuf.FieldDescriptor()
EQUIPCARD = protobuf.Descriptor()
EQUIPCARD_CMD_FIELD = protobuf.FieldDescriptor()
EQUIPCARD_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIPCARD_OPER_FIELD = protobuf.FieldDescriptor()
EQUIPCARD_CARDGUID_FIELD = protobuf.FieldDescriptor()
EQUIPCARD_EQUIPGUID_FIELD = protobuf.FieldDescriptor()
EQUIPCARD_POS_FIELD = protobuf.FieldDescriptor()
ITEMSHOW = protobuf.Descriptor()
ITEMSHOW_CMD_FIELD = protobuf.FieldDescriptor()
ITEMSHOW_PARAM_FIELD = protobuf.FieldDescriptor()
ITEMSHOW_ITEMS_FIELD = protobuf.FieldDescriptor()
ITEMSHOW64 = protobuf.Descriptor()
ITEMSHOW64_CMD_FIELD = protobuf.FieldDescriptor()
ITEMSHOW64_PARAM_FIELD = protobuf.FieldDescriptor()
ITEMSHOW64_ID_FIELD = protobuf.FieldDescriptor()
ITEMSHOW64_COUNT_FIELD = protobuf.FieldDescriptor()
EQUIPREPAIR = protobuf.Descriptor()
EQUIPREPAIR_CMD_FIELD = protobuf.FieldDescriptor()
EQUIPREPAIR_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIPREPAIR_TARGETGUID_FIELD = protobuf.FieldDescriptor()
EQUIPREPAIR_SUCCESS_FIELD = protobuf.FieldDescriptor()
EQUIPREPAIR_STUFFGUID_FIELD = protobuf.FieldDescriptor()
HINTNTF = protobuf.Descriptor()
HINTNTF_CMD_FIELD = protobuf.FieldDescriptor()
HINTNTF_PARAM_FIELD = protobuf.FieldDescriptor()
HINTNTF_ITEMID_FIELD = protobuf.FieldDescriptor()
ENCHANTEQUIP = protobuf.Descriptor()
ENCHANTEQUIP_CMD_FIELD = protobuf.FieldDescriptor()
ENCHANTEQUIP_PARAM_FIELD = protobuf.FieldDescriptor()
ENCHANTEQUIP_TYPE_FIELD = protobuf.FieldDescriptor()
ENCHANTEQUIP_GUID_FIELD = protobuf.FieldDescriptor()
TRADECOMPOSEPAIR = protobuf.Descriptor()
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD = protobuf.FieldDescriptor()
TRADECOMPOSEPAIR_COUNT_FIELD = protobuf.FieldDescriptor()
TRADEREFINEDATA = protobuf.Descriptor()
TRADEREFINEDATA_COMPOSEINFOS_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO = protobuf.Descriptor()
TRADEITEMBASEINFO_ITEMID_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_PRICE_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_COUNT_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_GUID_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_ORDER_ID_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_REFINE_LV_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_OVERLAP_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_IS_EXPIRED_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_ITEM_DATA_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_END_TIME_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_KEY_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_CHARID_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_NAME_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_TYPE_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_UP_RATE_FIELD = protobuf.FieldDescriptor()
TRADEITEMBASEINFO_DOWN_RATE_FIELD = protobuf.FieldDescriptor()
PROCESSENCHANTITEMCMD = protobuf.Descriptor()
PROCESSENCHANTITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
PROCESSENCHANTITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
PROCESSENCHANTITEMCMD_SAVE_FIELD = protobuf.FieldDescriptor()
PROCESSENCHANTITEMCMD_ITEMID_FIELD = protobuf.FieldDescriptor()
EQUIPEXCHANGEITEMCMD = protobuf.Descriptor()
EQUIPEXCHANGEITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
EQUIPEXCHANGEITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIPEXCHANGEITEMCMD_GUID_FIELD = protobuf.FieldDescriptor()
EQUIPEXCHANGEITEMCMD_TYPE_FIELD = protobuf.FieldDescriptor()
ONOFFSTOREITEMCMD = protobuf.Descriptor()
ONOFFSTOREITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
ONOFFSTOREITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ONOFFSTOREITEMCMD_OPEN_FIELD = protobuf.FieldDescriptor()
PACKSLOTNTFITEMCMD = protobuf.Descriptor()
PACKSLOTNTFITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
PACKSLOTNTFITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
PACKSLOTNTFITEMCMD_TYPE_FIELD = protobuf.FieldDescriptor()
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD = protobuf.FieldDescriptor()
RESTOREEQUIPITEMCMD = protobuf.Descriptor()
RESTOREEQUIPITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
RESTOREEQUIPITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RESTOREEQUIPITEMCMD_EQUIPID_FIELD = protobuf.FieldDescriptor()
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD = protobuf.FieldDescriptor()
RESTOREEQUIPITEMCMD_CARDIDS_FIELD = protobuf.FieldDescriptor()
RESTOREEQUIPITEMCMD_ENCHANT_FIELD = protobuf.FieldDescriptor()
RESTOREEQUIPITEMCMD_UPGRADE_FIELD = protobuf.FieldDescriptor()
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD = protobuf.FieldDescriptor()
USECOUNTITEMCMD = protobuf.Descriptor()
USECOUNTITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
USECOUNTITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USECOUNTITEMCMD_ITEMID_FIELD = protobuf.FieldDescriptor()
USECOUNTITEMCMD_COUNT_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD = protobuf.Descriptor()
EXCHANGECARDITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD_TYPE_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD_NPCID_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD_MATERIAL_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD_CHARID_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD_CARDID_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD_ANIM_FIELD = protobuf.FieldDescriptor()
EXCHANGECARDITEMCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
GETCOUNTITEMCMD = protobuf.Descriptor()
GETCOUNTITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
GETCOUNTITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GETCOUNTITEMCMD_ITEMID_FIELD = protobuf.FieldDescriptor()
GETCOUNTITEMCMD_COUNT_FIELD = protobuf.FieldDescriptor()
GETCOUNTITEMCMD_SOURCE_FIELD = protobuf.FieldDescriptor()
SAVELOVELETTERCMD = protobuf.Descriptor()
SAVELOVELETTERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SAVELOVELETTERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SAVELOVELETTERCMD_DWID_FIELD = protobuf.FieldDescriptor()
ITEMDATASHOW = protobuf.Descriptor()
ITEMDATASHOW_CMD_FIELD = protobuf.FieldDescriptor()
ITEMDATASHOW_PARAM_FIELD = protobuf.FieldDescriptor()
ITEMDATASHOW_ITEMS_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD = protobuf.Descriptor()
LOTTERYCMD_CMD_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_YEAR_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_MONTH_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_NPCID_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_SKIP_ANIM_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_PRICE_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_TICKET_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_TYPE_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_COUNT_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_CHARID_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_GUID_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_TODAY_CNT_FIELD = protobuf.FieldDescriptor()
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD = protobuf.FieldDescriptor()
LOTTERYRECOVERYCMD = protobuf.Descriptor()
LOTTERYRECOVERYCMD_CMD_FIELD = protobuf.FieldDescriptor()
LOTTERYRECOVERYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LOTTERYRECOVERYCMD_GUIDS_FIELD = protobuf.FieldDescriptor()
LOTTERYRECOVERYCMD_NPCID_FIELD = protobuf.FieldDescriptor()
LOTTERYRECOVERYCMD_TYPE_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO = protobuf.Descriptor()
LOTTERYSUBINFO_ITEMID_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO_RECOVER_PRICE_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO_RATE_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO_RARITY_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO_CUR_BATCH_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO_ID_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO_COUNT_FIELD = protobuf.FieldDescriptor()
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD = protobuf.FieldDescriptor()
LOTTERYINFO = protobuf.Descriptor()
LOTTERYINFO_YEAR_FIELD = protobuf.FieldDescriptor()
LOTTERYINFO_MONTH_FIELD = protobuf.FieldDescriptor()
LOTTERYINFO_PRICE_FIELD = protobuf.FieldDescriptor()
LOTTERYINFO_DISCOUNT_FIELD = protobuf.FieldDescriptor()
LOTTERYINFO_SUBINFO_FIELD = protobuf.FieldDescriptor()
LOTTERYINFO_LOTTERYBOX_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO = protobuf.Descriptor()
QUERYLOTTERYINFO_CMD_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO_INFOS_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO_TYPE_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO_TODAY_CNT_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO_MAX_CNT_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD = protobuf.FieldDescriptor()
QUOTALOG = protobuf.Descriptor()
QUOTALOG_VALUE_FIELD = protobuf.FieldDescriptor()
QUOTALOG_TYPE_FIELD = protobuf.FieldDescriptor()
QUOTALOG_TIME_FIELD = protobuf.FieldDescriptor()
QUOTADETAIL = protobuf.Descriptor()
QUOTADETAIL_VALUE_FIELD = protobuf.FieldDescriptor()
QUOTADETAIL_LEFT_FIELD = protobuf.FieldDescriptor()
QUOTADETAIL_EXPIRE_TIME_FIELD = protobuf.FieldDescriptor()
QUOTADETAIL_TIME_FIELD = protobuf.FieldDescriptor()
REQQUOTALOGCMD = protobuf.Descriptor()
REQQUOTALOGCMD_CMD_FIELD = protobuf.FieldDescriptor()
REQQUOTALOGCMD_PARAM_FIELD = protobuf.FieldDescriptor()
REQQUOTALOGCMD_PAGE_INDEX_FIELD = protobuf.FieldDescriptor()
REQQUOTALOGCMD_LOG_FIELD = protobuf.FieldDescriptor()
REQQUOTADETAILCMD = protobuf.Descriptor()
REQQUOTADETAILCMD_CMD_FIELD = protobuf.FieldDescriptor()
REQQUOTADETAILCMD_PARAM_FIELD = protobuf.FieldDescriptor()
REQQUOTADETAILCMD_PAGE_INDEX_FIELD = protobuf.FieldDescriptor()
REQQUOTADETAILCMD_DETAIL_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATA = protobuf.Descriptor()
EQUIPPOSDATA_POS_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATA_OFFSTARTTIME_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATA_OFFENDTIME_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATA_PROTECTTIME_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATA_PROTECTALWAYS_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATA_RECORDGUID_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATAUPDATE = protobuf.Descriptor()
EQUIPPOSDATAUPDATE_CMD_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATAUPDATE_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIPPOSDATAUPDATE_DATAS_FIELD = protobuf.FieldDescriptor()
MATITEMINFO = protobuf.Descriptor()
MATITEMINFO_ITEMID_FIELD = protobuf.FieldDescriptor()
MATITEMINFO_NUM_FIELD = protobuf.FieldDescriptor()
HIGHREFINEMATCOMPOSECMD = protobuf.Descriptor()
HIGHREFINEMATCOMPOSECMD_CMD_FIELD = protobuf.FieldDescriptor()
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD = protobuf.FieldDescriptor()
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD = protobuf.FieldDescriptor()
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD = protobuf.FieldDescriptor()
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD = protobuf.FieldDescriptor()
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD = protobuf.FieldDescriptor()
HIGHREFINECMD = protobuf.Descriptor()
HIGHREFINECMD_CMD_FIELD = protobuf.FieldDescriptor()
HIGHREFINECMD_PARAM_FIELD = protobuf.FieldDescriptor()
HIGHREFINECMD_DATAID_FIELD = protobuf.FieldDescriptor()
HIGHREFINEDATA = protobuf.Descriptor()
HIGHREFINEDATA_POS_FIELD = protobuf.FieldDescriptor()
HIGHREFINEDATA_LEVEL_FIELD = protobuf.FieldDescriptor()
NTFHIGHREFINEDATACMD = protobuf.Descriptor()
NTFHIGHREFINEDATACMD_CMD_FIELD = protobuf.FieldDescriptor()
NTFHIGHREFINEDATACMD_PARAM_FIELD = protobuf.FieldDescriptor()
NTFHIGHREFINEDATACMD_DATAS_FIELD = protobuf.FieldDescriptor()
UPDATEHIGHREFINEDATACMD = protobuf.Descriptor()
UPDATEHIGHREFINEDATACMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEHIGHREFINEDATACMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEHIGHREFINEDATACMD_DATA_FIELD = protobuf.FieldDescriptor()
USECODITEMCMD = protobuf.Descriptor()
USECODITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
USECODITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USECODITEMCMD_GUID_FIELD = protobuf.FieldDescriptor()
USECODITEMCMD_CODE_FIELD = protobuf.FieldDescriptor()
ADDJOBLEVELITEMCMD = protobuf.Descriptor()
ADDJOBLEVELITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
ADDJOBLEVELITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ADDJOBLEVELITEMCMD_ITEM_FIELD = protobuf.FieldDescriptor()
ADDJOBLEVELITEMCMD_NUM_FIELD = protobuf.FieldDescriptor()
LOTTERGIVBUYCOUNTCMD = protobuf.Descriptor()
LOTTERGIVBUYCOUNTCMD_CMD_FIELD = protobuf.FieldDescriptor()
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD = protobuf.FieldDescriptor()
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD = protobuf.FieldDescriptor()
GIVEWEDDINGDRESSCMD = protobuf.Descriptor()
GIVEWEDDINGDRESSCMD_CMD_FIELD = protobuf.FieldDescriptor()
GIVEWEDDINGDRESSCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GIVEWEDDINGDRESSCMD_GUID_FIELD = protobuf.FieldDescriptor()
GIVEWEDDINGDRESSCMD_CONTENT_FIELD = protobuf.FieldDescriptor()
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD = protobuf.FieldDescriptor()
QUICKSTOREITEMCMD = protobuf.Descriptor()
QUICKSTOREITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUICKSTOREITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUICKSTOREITEMCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
QUICKSELLITEMCMD = protobuf.Descriptor()
QUICKSELLITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUICKSELLITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUICKSELLITEMCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
ENCHANTTRANSITEMCMD = protobuf.Descriptor()
ENCHANTTRANSITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
ENCHANTTRANSITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD = protobuf.FieldDescriptor()
ENCHANTTRANSITEMCMD_TO_GUID_FIELD = protobuf.FieldDescriptor()
ENCHANTTRANSITEMCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYHEADITEMCMD = protobuf.Descriptor()
QUERYLOTTERYHEADITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYLOTTERYHEADITEMCMD_IDS_FIELD = protobuf.FieldDescriptor()
LOTTERYRATEINFO = protobuf.Descriptor()
LOTTERYRATEINFO_TYPE_FIELD = protobuf.FieldDescriptor()
LOTTERYRATEINFO_RATE_FIELD = protobuf.FieldDescriptor()
LOTTERYRATEQUERYCMD = protobuf.Descriptor()
LOTTERYRATEQUERYCMD_CMD_FIELD = protobuf.FieldDescriptor()
LOTTERYRATEQUERYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LOTTERYRATEQUERYCMD_TYPE_FIELD = protobuf.FieldDescriptor()
LOTTERYRATEQUERYCMD_INFOS_FIELD = protobuf.FieldDescriptor()
EQUIPCOMPOSEITEMCMD = protobuf.Descriptor()
EQUIPCOMPOSEITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
EQUIPCOMPOSEITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
EQUIPCOMPOSEITEMCMD_ID_FIELD = protobuf.FieldDescriptor()
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD = protobuf.FieldDescriptor()
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD = protobuf.FieldDescriptor()
QUERYDEBTITEMCMD = protobuf.Descriptor()
QUERYDEBTITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYDEBTITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYDEBTITEMCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
LOTTERYACTIVITYINFO = protobuf.Descriptor()
LOTTERYACTIVITYINFO_TYPE_FIELD = protobuf.FieldDescriptor()
LOTTERYACTIVITYINFO_OPEN_FIELD = protobuf.FieldDescriptor()
LOTTERYACTIVITYNTFCMD = protobuf.Descriptor()
LOTTERYACTIVITYNTFCMD_CMD_FIELD = protobuf.FieldDescriptor()
LOTTERYACTIVITYNTFCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LOTTERYACTIVITYNTFCMD_INFOS_FIELD = protobuf.FieldDescriptor()
FAVORITEITEMACTIONITEMCMD = protobuf.Descriptor()
FAVORITEITEMACTIONITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD = protobuf.FieldDescriptor()
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD = protobuf.FieldDescriptor()
ITEMPARAM_ITEMPARAM_PACKAGEITEM_ENUM.name = "ITEMPARAM_PACKAGEITEM"
ITEMPARAM_ITEMPARAM_PACKAGEITEM_ENUM.index = 0
ITEMPARAM_ITEMPARAM_PACKAGEITEM_ENUM.number = 1
ITEMPARAM_ITEMPARAM_PACKAGEUPDATE_ENUM.name = "ITEMPARAM_PACKAGEUPDATE"
ITEMPARAM_ITEMPARAM_PACKAGEUPDATE_ENUM.index = 1
ITEMPARAM_ITEMPARAM_PACKAGEUPDATE_ENUM.number = 2
ITEMPARAM_ITEMPARAM_ITEMUSE_ENUM.name = "ITEMPARAM_ITEMUSE"
ITEMPARAM_ITEMPARAM_ITEMUSE_ENUM.index = 2
ITEMPARAM_ITEMPARAM_ITEMUSE_ENUM.number = 3
ITEMPARAM_ITEMPARAM_PACKAGESORT_ENUM.name = "ITEMPARAM_PACKAGESORT"
ITEMPARAM_ITEMPARAM_PACKAGESORT_ENUM.index = 3
ITEMPARAM_ITEMPARAM_PACKAGESORT_ENUM.number = 4
ITEMPARAM_ITEMPARAM_EQUIP_ENUM.name = "ITEMPARAM_EQUIP"
ITEMPARAM_ITEMPARAM_EQUIP_ENUM.index = 4
ITEMPARAM_ITEMPARAM_EQUIP_ENUM.number = 5
ITEMPARAM_ITEMPARAM_SELLITEM_ENUM.name = "ITEMPARAM_SELLITEM"
ITEMPARAM_ITEMPARAM_SELLITEM_ENUM.index = 5
ITEMPARAM_ITEMPARAM_SELLITEM_ENUM.number = 6
ITEMPARAM_ITEMPARAM_EQUIPSTRENGTH_ENUM.name = "ITEMPARAM_EQUIPSTRENGTH"
ITEMPARAM_ITEMPARAM_EQUIPSTRENGTH_ENUM.index = 6
ITEMPARAM_ITEMPARAM_EQUIPSTRENGTH_ENUM.number = 7
ITEMPARAM_ITEMPARAM_PRODUCE_ENUM.name = "ITEMPARAM_PRODUCE"
ITEMPARAM_ITEMPARAM_PRODUCE_ENUM.index = 7
ITEMPARAM_ITEMPARAM_PRODUCE_ENUM.number = 9
ITEMPARAM_ITEMPARAM_PRODUCEDONE_ENUM.name = "ITEMPARAM_PRODUCEDONE"
ITEMPARAM_ITEMPARAM_PRODUCEDONE_ENUM.index = 8
ITEMPARAM_ITEMPARAM_PRODUCEDONE_ENUM.number = 10
ITEMPARAM_ITEMPARAM_REFINE_ENUM.name = "ITEMPARAM_REFINE"
ITEMPARAM_ITEMPARAM_REFINE_ENUM.index = 9
ITEMPARAM_ITEMPARAM_REFINE_ENUM.number = 11
ITEMPARAM_ITEMPARAM_DECOMPOSE_ENUM.name = "ITEMPARAM_DECOMPOSE"
ITEMPARAM_ITEMPARAM_DECOMPOSE_ENUM.index = 10
ITEMPARAM_ITEMPARAM_DECOMPOSE_ENUM.number = 12
ITEMPARAM_ITEMPARAM_QUERYEQUIPDATA_ENUM.name = "ITEMPARAM_QUERYEQUIPDATA"
ITEMPARAM_ITEMPARAM_QUERYEQUIPDATA_ENUM.index = 11
ITEMPARAM_ITEMPARAM_QUERYEQUIPDATA_ENUM.number = 13
ITEMPARAM_ITEMPARAM_BROWSEPACK_ENUM.name = "ITEMPARAM_BROWSEPACK"
ITEMPARAM_ITEMPARAM_BROWSEPACK_ENUM.index = 12
ITEMPARAM_ITEMPARAM_BROWSEPACK_ENUM.number = 14
ITEMPARAM_ITEMPARAM_EQUIPCARD_ENUM.name = "ITEMPARAM_EQUIPCARD"
ITEMPARAM_ITEMPARAM_EQUIPCARD_ENUM.index = 13
ITEMPARAM_ITEMPARAM_EQUIPCARD_ENUM.number = 15
ITEMPARAM_ITEMPARAM_ITEMSHOW_ENUM.name = "ITEMPARAM_ITEMSHOW"
ITEMPARAM_ITEMPARAM_ITEMSHOW_ENUM.index = 14
ITEMPARAM_ITEMPARAM_ITEMSHOW_ENUM.number = 16
ITEMPARAM_ITEMPARAM_REPAIR_ENUM.name = "ITEMPARAM_REPAIR"
ITEMPARAM_ITEMPARAM_REPAIR_ENUM.index = 15
ITEMPARAM_ITEMPARAM_REPAIR_ENUM.number = 17
ITEMPARAM_ITEMPARAM_HINTNTF_ENUM.name = "ITEMPARAM_HINTNTF"
ITEMPARAM_ITEMPARAM_HINTNTF_ENUM.index = 16
ITEMPARAM_ITEMPARAM_HINTNTF_ENUM.number = 18
ITEMPARAM_ITEMPARAM_ENCHANT_ENUM.name = "ITEMPARAM_ENCHANT"
ITEMPARAM_ITEMPARAM_ENCHANT_ENUM.index = 17
ITEMPARAM_ITEMPARAM_ENCHANT_ENUM.number = 19
ITEMPARAM_ITEMPARAM_PROCESSENCHANT_ENUM.name = "ITEMPARAM_PROCESSENCHANT"
ITEMPARAM_ITEMPARAM_PROCESSENCHANT_ENUM.index = 18
ITEMPARAM_ITEMPARAM_PROCESSENCHANT_ENUM.number = 20
ITEMPARAM_ITEMPARAM_EQUIPEXCHANGE_ENUM.name = "ITEMPARAM_EQUIPEXCHANGE"
ITEMPARAM_ITEMPARAM_EQUIPEXCHANGE_ENUM.index = 19
ITEMPARAM_ITEMPARAM_EQUIPEXCHANGE_ENUM.number = 21
ITEMPARAM_ITEMPARAM_ONOFFSTORE_ENUM.name = "ITEMPARAM_ONOFFSTORE"
ITEMPARAM_ITEMPARAM_ONOFFSTORE_ENUM.index = 20
ITEMPARAM_ITEMPARAM_ONOFFSTORE_ENUM.number = 22
ITEMPARAM_ITEMPARAM_PACKSLOTNTF_ENUM.name = "ITEMPARAM_PACKSLOTNTF"
ITEMPARAM_ITEMPARAM_PACKSLOTNTF_ENUM.index = 21
ITEMPARAM_ITEMPARAM_PACKSLOTNTF_ENUM.number = 23
ITEMPARAM_ITEMPARAM_RESTOREEQUIP_ENUM.name = "ITEMPARAM_RESTOREEQUIP"
ITEMPARAM_ITEMPARAM_RESTOREEQUIP_ENUM.index = 22
ITEMPARAM_ITEMPARAM_RESTOREEQUIP_ENUM.number = 24
ITEMPARAM_ITEMPARAM_USECOUNT_ENUM.name = "ITEMPARAM_USECOUNT"
ITEMPARAM_ITEMPARAM_USECOUNT_ENUM.index = 23
ITEMPARAM_ITEMPARAM_USECOUNT_ENUM.number = 25
ITEMPARAM_ITEMPARAM_QUERYDECOMPOSERESULT_ENUM.name = "ITEMPARAM_QUERYDECOMPOSERESULT"
ITEMPARAM_ITEMPARAM_QUERYDECOMPOSERESULT_ENUM.index = 24
ITEMPARAM_ITEMPARAM_QUERYDECOMPOSERESULT_ENUM.number = 27
ITEMPARAM_ITEMPARAM_EXCHANGECARD_ENUM.name = "ITEMPARAM_EXCHANGECARD"
ITEMPARAM_ITEMPARAM_EXCHANGECARD_ENUM.index = 25
ITEMPARAM_ITEMPARAM_EXCHANGECARD_ENUM.number = 28
ITEMPARAM_ITEMPARAM_GETCOUNT_ENUM.name = "ITEMPARAM_GETCOUNT"
ITEMPARAM_ITEMPARAM_GETCOUNT_ENUM.index = 26
ITEMPARAM_ITEMPARAM_GETCOUNT_ENUM.number = 29
ITEMPARAM_ITEMPARAM_SAVE_LOVE_LETTER_ENUM.name = "ITEMPARAM_SAVE_LOVE_LETTER"
ITEMPARAM_ITEMPARAM_SAVE_LOVE_LETTER_ENUM.index = 27
ITEMPARAM_ITEMPARAM_SAVE_LOVE_LETTER_ENUM.number = 30
ITEMPARAM_ITEMPARAM_ITEMDATASHOW_ENUM.name = "ITEMPARAM_ITEMDATASHOW"
ITEMPARAM_ITEMPARAM_ITEMDATASHOW_ENUM.index = 28
ITEMPARAM_ITEMPARAM_ITEMDATASHOW_ENUM.number = 31
ITEMPARAM_ITEMPARAM_LOTTERY_ENUM.name = "ITEMPARAM_LOTTERY"
ITEMPARAM_ITEMPARAM_LOTTERY_ENUM.index = 29
ITEMPARAM_ITEMPARAM_LOTTERY_ENUM.number = 32
ITEMPARAM_ITEMPARAM_LOTTERY_RECOVERY_ENUM.name = "ITEMPARAM_LOTTERY_RECOVERY"
ITEMPARAM_ITEMPARAM_LOTTERY_RECOVERY_ENUM.index = 30
ITEMPARAM_ITEMPARAM_LOTTERY_RECOVERY_ENUM.number = 33
ITEMPARAM_ITEMPARAM_QUERY_LOTTERYINFO_ENUM.name = "ITEMPARAM_QUERY_LOTTERYINFO"
ITEMPARAM_ITEMPARAM_QUERY_LOTTERYINFO_ENUM.index = 31
ITEMPARAM_ITEMPARAM_QUERY_LOTTERYINFO_ENUM.number = 34
ITEMPARAM_ITEMPARAM_ITEMSHOW64_ENUM.name = "ITEMPARAM_ITEMSHOW64"
ITEMPARAM_ITEMPARAM_ITEMSHOW64_ENUM.index = 32
ITEMPARAM_ITEMPARAM_ITEMSHOW64_ENUM.number = 35
ITEMPARAM_ITEMPARAM_HIGHREFINE_MATCOMPOSE_ENUM.name = "ITEMPARAM_HIGHREFINE_MATCOMPOSE"
ITEMPARAM_ITEMPARAM_HIGHREFINE_MATCOMPOSE_ENUM.index = 33
ITEMPARAM_ITEMPARAM_HIGHREFINE_MATCOMPOSE_ENUM.number = 36
ITEMPARAM_ITEMPARAM_HIGHREFINE_ENUM.name = "ITEMPARAM_HIGHREFINE"
ITEMPARAM_ITEMPARAM_HIGHREFINE_ENUM.index = 34
ITEMPARAM_ITEMPARAM_HIGHREFINE_ENUM.number = 37
ITEMPARAM_ITEMPARAM_NTF_HIGHTREFINE_DATA_ENUM.name = "ITEMPARAM_NTF_HIGHTREFINE_DATA"
ITEMPARAM_ITEMPARAM_NTF_HIGHTREFINE_DATA_ENUM.index = 35
ITEMPARAM_ITEMPARAM_NTF_HIGHTREFINE_DATA_ENUM.number = 38
ITEMPARAM_ITEMPARAM_UPDATE_HIGHTREFINE_DATA_ENUM.name = "ITEMPARAM_UPDATE_HIGHTREFINE_DATA"
ITEMPARAM_ITEMPARAM_UPDATE_HIGHTREFINE_DATA_ENUM.index = 36
ITEMPARAM_ITEMPARAM_UPDATE_HIGHTREFINE_DATA_ENUM.number = 39
ITEMPARAM_ITEMPARAM_REQ_QUOTA_LOG_ENUM.name = "ITEMPARAM_REQ_QUOTA_LOG"
ITEMPARAM_ITEMPARAM_REQ_QUOTA_LOG_ENUM.index = 37
ITEMPARAM_ITEMPARAM_REQ_QUOTA_LOG_ENUM.number = 40
ITEMPARAM_ITEMPARAM_REQ_QUOTA_DETAIL_ENUM.name = "ITEMPARAM_REQ_QUOTA_DETAIL"
ITEMPARAM_ITEMPARAM_REQ_QUOTA_DETAIL_ENUM.index = 38
ITEMPARAM_ITEMPARAM_REQ_QUOTA_DETAIL_ENUM.number = 41
ITEMPARAM_ITEMPARAM_EQUIPPOSDATA_UPDATE_ENUM.name = "ITEMPARAM_EQUIPPOSDATA_UPDATE"
ITEMPARAM_ITEMPARAM_EQUIPPOSDATA_UPDATE_ENUM.index = 39
ITEMPARAM_ITEMPARAM_EQUIPPOSDATA_UPDATE_ENUM.number = 42
ITEMPARAM_ITEMPARAM_USE_CODE_ITEM_ENUM.name = "ITEMPARAM_USE_CODE_ITEM"
ITEMPARAM_ITEMPARAM_USE_CODE_ITEM_ENUM.index = 40
ITEMPARAM_ITEMPARAM_USE_CODE_ITEM_ENUM.number = 43
ITEMPARAM_ITEMPARAM_ADD_JOBLEVEL_ENUM.name = "ITEMPARAM_ADD_JOBLEVEL"
ITEMPARAM_ITEMPARAM_ADD_JOBLEVEL_ENUM.index = 41
ITEMPARAM_ITEMPARAM_ADD_JOBLEVEL_ENUM.number = 44
ITEMPARAM_ITEMPARAM_LOTTERY_GIVE_BUY_COUNT_ENUM.name = "ITEMPARAM_LOTTERY_GIVE_BUY_COUNT"
ITEMPARAM_ITEMPARAM_LOTTERY_GIVE_BUY_COUNT_ENUM.index = 42
ITEMPARAM_ITEMPARAM_LOTTERY_GIVE_BUY_COUNT_ENUM.number = 46
ITEMPARAM_ITEMPARAM_GIVE_WEDDING_DRESS_ENUM.name = "ITEMPARAM_GIVE_WEDDING_DRESS"
ITEMPARAM_ITEMPARAM_GIVE_WEDDING_DRESS_ENUM.index = 43
ITEMPARAM_ITEMPARAM_GIVE_WEDDING_DRESS_ENUM.number = 47
ITEMPARAM_ITEMPARAM_QUICK_STOREITEM_ENUM.name = "ITEMPARAM_QUICK_STOREITEM"
ITEMPARAM_ITEMPARAM_QUICK_STOREITEM_ENUM.index = 44
ITEMPARAM_ITEMPARAM_QUICK_STOREITEM_ENUM.number = 48
ITEMPARAM_ITEMPARAM_QUICK_SELLITEM_ENUM.name = "ITEMPARAM_QUICK_SELLITEM"
ITEMPARAM_ITEMPARAM_QUICK_SELLITEM_ENUM.index = 45
ITEMPARAM_ITEMPARAM_QUICK_SELLITEM_ENUM.number = 49
ITEMPARAM_ITEMPARAM_ENCHANT_TRANS_ENUM.name = "ITEMPARAM_ENCHANT_TRANS"
ITEMPARAM_ITEMPARAM_ENCHANT_TRANS_ENUM.index = 46
ITEMPARAM_ITEMPARAM_ENCHANT_TRANS_ENUM.number = 50
ITEMPARAM_ITEMPARAM_QUERY_LOTTERYHEAD_ENUM.name = "ITEMPARAM_QUERY_LOTTERYHEAD"
ITEMPARAM_ITEMPARAM_QUERY_LOTTERYHEAD_ENUM.index = 47
ITEMPARAM_ITEMPARAM_QUERY_LOTTERYHEAD_ENUM.number = 51
ITEMPARAM_ITEMPARAM_LOTTERY_RATE_QUERY_ENUM.name = "ITEMPARAM_LOTTERY_RATE_QUERY"
ITEMPARAM_ITEMPARAM_LOTTERY_RATE_QUERY_ENUM.index = 48
ITEMPARAM_ITEMPARAM_LOTTERY_RATE_QUERY_ENUM.number = 52
ITEMPARAM_ITEMPARAM_EQUIPCOMPOSE_ENUM.name = "ITEMPARAM_EQUIPCOMPOSE"
ITEMPARAM_ITEMPARAM_EQUIPCOMPOSE_ENUM.index = 49
ITEMPARAM_ITEMPARAM_EQUIPCOMPOSE_ENUM.number = 53
ITEMPARAM_ITEMPARAM_QUERY_ITEMDEBT_ENUM.name = "ITEMPARAM_QUERY_ITEMDEBT"
ITEMPARAM_ITEMPARAM_QUERY_ITEMDEBT_ENUM.index = 50
ITEMPARAM_ITEMPARAM_QUERY_ITEMDEBT_ENUM.number = 54
ITEMPARAM_ITEMPARAM_FAVORITE_ACTION_ENUM.name = "ITEMPARAM_FAVORITE_ACTION"
ITEMPARAM_ITEMPARAM_FAVORITE_ACTION_ENUM.index = 51
ITEMPARAM_ITEMPARAM_FAVORITE_ACTION_ENUM.number = 56
ITEMPARAM_ITEMPARAM_LOTTERY_ACTIVITY_NTF_ENUM.name = "ITEMPARAM_LOTTERY_ACTIVITY_NTF"
ITEMPARAM_ITEMPARAM_LOTTERY_ACTIVITY_NTF_ENUM.index = 52
ITEMPARAM_ITEMPARAM_LOTTERY_ACTIVITY_NTF_ENUM.number = 57
ITEMPARAM.name = "ItemParam"
ITEMPARAM.full_name = ".Cmd.ItemParam"
ITEMPARAM.values = {
  ITEMPARAM_ITEMPARAM_PACKAGEITEM_ENUM,
  ITEMPARAM_ITEMPARAM_PACKAGEUPDATE_ENUM,
  ITEMPARAM_ITEMPARAM_ITEMUSE_ENUM,
  ITEMPARAM_ITEMPARAM_PACKAGESORT_ENUM,
  ITEMPARAM_ITEMPARAM_EQUIP_ENUM,
  ITEMPARAM_ITEMPARAM_SELLITEM_ENUM,
  ITEMPARAM_ITEMPARAM_EQUIPSTRENGTH_ENUM,
  ITEMPARAM_ITEMPARAM_PRODUCE_ENUM,
  ITEMPARAM_ITEMPARAM_PRODUCEDONE_ENUM,
  ITEMPARAM_ITEMPARAM_REFINE_ENUM,
  ITEMPARAM_ITEMPARAM_DECOMPOSE_ENUM,
  ITEMPARAM_ITEMPARAM_QUERYEQUIPDATA_ENUM,
  ITEMPARAM_ITEMPARAM_BROWSEPACK_ENUM,
  ITEMPARAM_ITEMPARAM_EQUIPCARD_ENUM,
  ITEMPARAM_ITEMPARAM_ITEMSHOW_ENUM,
  ITEMPARAM_ITEMPARAM_REPAIR_ENUM,
  ITEMPARAM_ITEMPARAM_HINTNTF_ENUM,
  ITEMPARAM_ITEMPARAM_ENCHANT_ENUM,
  ITEMPARAM_ITEMPARAM_PROCESSENCHANT_ENUM,
  ITEMPARAM_ITEMPARAM_EQUIPEXCHANGE_ENUM,
  ITEMPARAM_ITEMPARAM_ONOFFSTORE_ENUM,
  ITEMPARAM_ITEMPARAM_PACKSLOTNTF_ENUM,
  ITEMPARAM_ITEMPARAM_RESTOREEQUIP_ENUM,
  ITEMPARAM_ITEMPARAM_USECOUNT_ENUM,
  ITEMPARAM_ITEMPARAM_QUERYDECOMPOSERESULT_ENUM,
  ITEMPARAM_ITEMPARAM_EXCHANGECARD_ENUM,
  ITEMPARAM_ITEMPARAM_GETCOUNT_ENUM,
  ITEMPARAM_ITEMPARAM_SAVE_LOVE_LETTER_ENUM,
  ITEMPARAM_ITEMPARAM_ITEMDATASHOW_ENUM,
  ITEMPARAM_ITEMPARAM_LOTTERY_ENUM,
  ITEMPARAM_ITEMPARAM_LOTTERY_RECOVERY_ENUM,
  ITEMPARAM_ITEMPARAM_QUERY_LOTTERYINFO_ENUM,
  ITEMPARAM_ITEMPARAM_ITEMSHOW64_ENUM,
  ITEMPARAM_ITEMPARAM_HIGHREFINE_MATCOMPOSE_ENUM,
  ITEMPARAM_ITEMPARAM_HIGHREFINE_ENUM,
  ITEMPARAM_ITEMPARAM_NTF_HIGHTREFINE_DATA_ENUM,
  ITEMPARAM_ITEMPARAM_UPDATE_HIGHTREFINE_DATA_ENUM,
  ITEMPARAM_ITEMPARAM_REQ_QUOTA_LOG_ENUM,
  ITEMPARAM_ITEMPARAM_REQ_QUOTA_DETAIL_ENUM,
  ITEMPARAM_ITEMPARAM_EQUIPPOSDATA_UPDATE_ENUM,
  ITEMPARAM_ITEMPARAM_USE_CODE_ITEM_ENUM,
  ITEMPARAM_ITEMPARAM_ADD_JOBLEVEL_ENUM,
  ITEMPARAM_ITEMPARAM_LOTTERY_GIVE_BUY_COUNT_ENUM,
  ITEMPARAM_ITEMPARAM_GIVE_WEDDING_DRESS_ENUM,
  ITEMPARAM_ITEMPARAM_QUICK_STOREITEM_ENUM,
  ITEMPARAM_ITEMPARAM_QUICK_SELLITEM_ENUM,
  ITEMPARAM_ITEMPARAM_ENCHANT_TRANS_ENUM,
  ITEMPARAM_ITEMPARAM_QUERY_LOTTERYHEAD_ENUM,
  ITEMPARAM_ITEMPARAM_LOTTERY_RATE_QUERY_ENUM,
  ITEMPARAM_ITEMPARAM_EQUIPCOMPOSE_ENUM,
  ITEMPARAM_ITEMPARAM_QUERY_ITEMDEBT_ENUM,
  ITEMPARAM_ITEMPARAM_FAVORITE_ACTION_ENUM,
  ITEMPARAM_ITEMPARAM_LOTTERY_ACTIVITY_NTF_ENUM
}
EPACKTYPE_EPACKTYPE_MIN_ENUM.name = "EPACKTYPE_MIN"
EPACKTYPE_EPACKTYPE_MIN_ENUM.index = 0
EPACKTYPE_EPACKTYPE_MIN_ENUM.number = 0
EPACKTYPE_EPACKTYPE_MAIN_ENUM.name = "EPACKTYPE_MAIN"
EPACKTYPE_EPACKTYPE_MAIN_ENUM.index = 1
EPACKTYPE_EPACKTYPE_MAIN_ENUM.number = 1
EPACKTYPE_EPACKTYPE_EQUIP_ENUM.name = "EPACKTYPE_EQUIP"
EPACKTYPE_EPACKTYPE_EQUIP_ENUM.index = 2
EPACKTYPE_EPACKTYPE_EQUIP_ENUM.number = 2
EPACKTYPE_EPACKTYPE_FASHION_ENUM.name = "EPACKTYPE_FASHION"
EPACKTYPE_EPACKTYPE_FASHION_ENUM.index = 3
EPACKTYPE_EPACKTYPE_FASHION_ENUM.number = 3
EPACKTYPE_EPACKTYPE_FASHIONEQUIP_ENUM.name = "EPACKTYPE_FASHIONEQUIP"
EPACKTYPE_EPACKTYPE_FASHIONEQUIP_ENUM.index = 4
EPACKTYPE_EPACKTYPE_FASHIONEQUIP_ENUM.number = 4
EPACKTYPE_EPACKTYPE_CARD_ENUM.name = "EPACKTYPE_CARD"
EPACKTYPE_EPACKTYPE_CARD_ENUM.index = 5
EPACKTYPE_EPACKTYPE_CARD_ENUM.number = 5
EPACKTYPE_EPACKTYPE_STORE_ENUM.name = "EPACKTYPE_STORE"
EPACKTYPE_EPACKTYPE_STORE_ENUM.index = 6
EPACKTYPE_EPACKTYPE_STORE_ENUM.number = 6
EPACKTYPE_EPACKTYPE_PERSONAL_STORE_ENUM.name = "EPACKTYPE_PERSONAL_STORE"
EPACKTYPE_EPACKTYPE_PERSONAL_STORE_ENUM.index = 7
EPACKTYPE_EPACKTYPE_PERSONAL_STORE_ENUM.number = 7
EPACKTYPE_EPACKTYPE_TEMP_MAIN_ENUM.name = "EPACKTYPE_TEMP_MAIN"
EPACKTYPE_EPACKTYPE_TEMP_MAIN_ENUM.index = 8
EPACKTYPE_EPACKTYPE_TEMP_MAIN_ENUM.number = 8
EPACKTYPE_EPACKTYPE_BARROW_ENUM.name = "EPACKTYPE_BARROW"
EPACKTYPE_EPACKTYPE_BARROW_ENUM.index = 9
EPACKTYPE_EPACKTYPE_BARROW_ENUM.number = 9
EPACKTYPE_EPACKTYPE_QUEST_ENUM.name = "EPACKTYPE_QUEST"
EPACKTYPE_EPACKTYPE_QUEST_ENUM.index = 10
EPACKTYPE_EPACKTYPE_QUEST_ENUM.number = 10
EPACKTYPE_EPACKTYPE_FOOD_ENUM.name = "EPACKTYPE_FOOD"
EPACKTYPE_EPACKTYPE_FOOD_ENUM.index = 11
EPACKTYPE_EPACKTYPE_FOOD_ENUM.number = 11
EPACKTYPE_EPACKTYPE_PET_ENUM.name = "EPACKTYPE_PET"
EPACKTYPE_EPACKTYPE_PET_ENUM.index = 12
EPACKTYPE_EPACKTYPE_PET_ENUM.number = 12
EPACKTYPE_EPACKTYPE_MAX_ENUM.name = "EPACKTYPE_MAX"
EPACKTYPE_EPACKTYPE_MAX_ENUM.index = 13
EPACKTYPE_EPACKTYPE_MAX_ENUM.number = 13
EPACKTYPE.name = "EPackType"
EPACKTYPE.full_name = ".Cmd.EPackType"
EPACKTYPE.values = {
  EPACKTYPE_EPACKTYPE_MIN_ENUM,
  EPACKTYPE_EPACKTYPE_MAIN_ENUM,
  EPACKTYPE_EPACKTYPE_EQUIP_ENUM,
  EPACKTYPE_EPACKTYPE_FASHION_ENUM,
  EPACKTYPE_EPACKTYPE_FASHIONEQUIP_ENUM,
  EPACKTYPE_EPACKTYPE_CARD_ENUM,
  EPACKTYPE_EPACKTYPE_STORE_ENUM,
  EPACKTYPE_EPACKTYPE_PERSONAL_STORE_ENUM,
  EPACKTYPE_EPACKTYPE_TEMP_MAIN_ENUM,
  EPACKTYPE_EPACKTYPE_BARROW_ENUM,
  EPACKTYPE_EPACKTYPE_QUEST_ENUM,
  EPACKTYPE_EPACKTYPE_FOOD_ENUM,
  EPACKTYPE_EPACKTYPE_PET_ENUM,
  EPACKTYPE_EPACKTYPE_MAX_ENUM
}
EITEMTYPE_EITEMTYPE_MIN_ENUM.name = "EITEMTYPE_MIN"
EITEMTYPE_EITEMTYPE_MIN_ENUM.index = 0
EITEMTYPE_EITEMTYPE_MIN_ENUM.number = 0
EITEMTYPE_EITEMTYPE_HONOR_ENUM.name = "EITEMTYPE_HONOR"
EITEMTYPE_EITEMTYPE_HONOR_ENUM.index = 1
EITEMTYPE_EITEMTYPE_HONOR_ENUM.number = 10
EITEMTYPE_EITEMTYPE_STREASURE_ENUM.name = "EITEMTYPE_STREASURE"
EITEMTYPE_EITEMTYPE_STREASURE_ENUM.index = 2
EITEMTYPE_EITEMTYPE_STREASURE_ENUM.number = 20
EITEMTYPE_EITEMTYPE_TREASURE_ENUM.name = "EITEMTYPE_TREASURE"
EITEMTYPE_EITEMTYPE_TREASURE_ENUM.index = 3
EITEMTYPE_EITEMTYPE_TREASURE_ENUM.number = 30
EITEMTYPE_EITEMTYPE_STUFF_ENUM.name = "EITEMTYPE_STUFF"
EITEMTYPE_EITEMTYPE_STUFF_ENUM.index = 4
EITEMTYPE_EITEMTYPE_STUFF_ENUM.number = 40
EITEMTYPE_EITEMTYPE_STUFFNOCUT_ENUM.name = "EITEMTYPE_STUFFNOCUT"
EITEMTYPE_EITEMTYPE_STUFFNOCUT_ENUM.index = 5
EITEMTYPE_EITEMTYPE_STUFFNOCUT_ENUM.number = 41
EITEMTYPE_EITEMTYPE_ARROW_ENUM.name = "EITEMTYPE_ARROW"
EITEMTYPE_EITEMTYPE_ARROW_ENUM.index = 6
EITEMTYPE_EITEMTYPE_ARROW_ENUM.number = 43
EITEMTYPE_EITEMTYPE_USESKILL_ENUM.name = "EITEMTYPE_USESKILL"
EITEMTYPE_EITEMTYPE_USESKILL_ENUM.index = 7
EITEMTYPE_EITEMTYPE_USESKILL_ENUM.number = 44
EITEMTYPE_EITEMTYPE_GHOSTLAMP_ENUM.name = "EITEMTYPE_GHOSTLAMP"
EITEMTYPE_EITEMTYPE_GHOSTLAMP_ENUM.index = 8
EITEMTYPE_EITEMTYPE_GHOSTLAMP_ENUM.number = 45
EITEMTYPE_EITEMTYPE_MULTITIME_ENUM.name = "EITEMTYPE_MULTITIME"
EITEMTYPE_EITEMTYPE_MULTITIME_ENUM.index = 9
EITEMTYPE_EITEMTYPE_MULTITIME_ENUM.number = 46
EITEMTYPE_EITEMTYPE_MONTHCARD_ENUM.name = "EITEMTYPE_MONTHCARD"
EITEMTYPE_EITEMTYPE_MONTHCARD_ENUM.index = 10
EITEMTYPE_EITEMTYPE_MONTHCARD_ENUM.number = 47
EITEMTYPE_EITEMTYPE_QUEST_ONCE_ENUM.name = "EITEMTYPE_QUEST_ONCE"
EITEMTYPE_EITEMTYPE_QUEST_ONCE_ENUM.index = 11
EITEMTYPE_EITEMTYPE_QUEST_ONCE_ENUM.number = 48
EITEMTYPE_EITEMTYPE_QUEST_TIME_ENUM.name = "EITEMTYPE_QUEST_TIME"
EITEMTYPE_EITEMTYPE_QUEST_TIME_ENUM.index = 12
EITEMTYPE_EITEMTYPE_QUEST_TIME_ENUM.number = 49
EITEMTYPE_EITEMTYPE_SHEET_ENUM.name = "EITEMTYPE_SHEET"
EITEMTYPE_EITEMTYPE_SHEET_ENUM.index = 13
EITEMTYPE_EITEMTYPE_SHEET_ENUM.number = 50
EITEMTYPE_EITEMTYPE_PET_WEARSHEET_ENUM.name = "EITEMTYPE_PET_WEARSHEET"
EITEMTYPE_EITEMTYPE_PET_WEARSHEET_ENUM.index = 14
EITEMTYPE_EITEMTYPE_PET_WEARSHEET_ENUM.number = 51
EITEMTYPE_EITEMTYPE_PET_WEARUNLOCK_ENUM.name = "EITEMTYPE_PET_WEARUNLOCK"
EITEMTYPE_EITEMTYPE_PET_WEARUNLOCK_ENUM.index = 15
EITEMTYPE_EITEMTYPE_PET_WEARUNLOCK_ENUM.number = 52
EITEMTYPE_EITEMTYPE_CONSUME_ENUM.name = "EITEMTYPE_CONSUME"
EITEMTYPE_EITEMTYPE_CONSUME_ENUM.index = 16
EITEMTYPE_EITEMTYPE_CONSUME_ENUM.number = 60
EITEMTYPE_EITEMTYPE_HAIRSTUFF_ENUM.name = "EITEMTYPE_HAIRSTUFF"
EITEMTYPE_EITEMTYPE_HAIRSTUFF_ENUM.index = 17
EITEMTYPE_EITEMTYPE_HAIRSTUFF_ENUM.number = 61
EITEMTYPE_EITEMTYPE_CONSUME_2_ENUM.name = "EITEMTYPE_CONSUME_2"
EITEMTYPE_EITEMTYPE_CONSUME_2_ENUM.index = 18
EITEMTYPE_EITEMTYPE_CONSUME_2_ENUM.number = 62
EITEMTYPE_EITEMTYPE_COLLECTION_ENUM.name = "EITEMTYPE_COLLECTION"
EITEMTYPE_EITEMTYPE_COLLECTION_ENUM.index = 19
EITEMTYPE_EITEMTYPE_COLLECTION_ENUM.number = 63
EITEMTYPE_EITEMTYPE_RANGE_ENUM.name = "EITEMTYPE_RANGE"
EITEMTYPE_EITEMTYPE_RANGE_ENUM.index = 20
EITEMTYPE_EITEMTYPE_RANGE_ENUM.number = 64
EITEMTYPE_EITEMTYPE_FUNCTION_ENUM.name = "EITEMTYPE_FUNCTION"
EITEMTYPE_EITEMTYPE_FUNCTION_ENUM.index = 21
EITEMTYPE_EITEMTYPE_FUNCTION_ENUM.number = 65
EITEMTYPE_EITEMTYPE_ACTIVITY_ENUM.name = "EITEMTYPE_ACTIVITY"
EITEMTYPE_EITEMTYPE_ACTIVITY_ENUM.index = 22
EITEMTYPE_EITEMTYPE_ACTIVITY_ENUM.number = 66
EITEMTYPE_EITEMTYPE_WEDDING_RING_ENUM.name = "EITEMTYPE_WEDDING_RING"
EITEMTYPE_EITEMTYPE_WEDDING_RING_ENUM.index = 23
EITEMTYPE_EITEMTYPE_WEDDING_RING_ENUM.number = 67
EITEMTYPE_EITEMTYPE_MATERIAL_ENUM.name = "EITEMTYPE_MATERIAL"
EITEMTYPE_EITEMTYPE_MATERIAL_ENUM.index = 24
EITEMTYPE_EITEMTYPE_MATERIAL_ENUM.number = 70
EITEMTYPE_EITEMTYPE_LETTER_ENUM.name = "EITEMTYPE_LETTER"
EITEMTYPE_EITEMTYPE_LETTER_ENUM.index = 25
EITEMTYPE_EITEMTYPE_LETTER_ENUM.number = 71
EITEMTYPE_EITEMTYPE_GOLDAPPLE_ENUM.name = "EITEMTYPE_GOLDAPPLE"
EITEMTYPE_EITEMTYPE_GOLDAPPLE_ENUM.index = 26
EITEMTYPE_EITEMTYPE_GOLDAPPLE_ENUM.number = 72
EITEMTYPE_EITEMTYPE_GETSKILL_ENUM.name = "EITEMTYPE_GETSKILL"
EITEMTYPE_EITEMTYPE_GETSKILL_ENUM.index = 27
EITEMTYPE_EITEMTYPE_GETSKILL_ENUM.number = 73
EITEMTYPE_EITEMTYPE_PICKEFFECT_ENUM.name = "EITEMTYPE_PICKEFFECT"
EITEMTYPE_EITEMTYPE_PICKEFFECT_ENUM.index = 28
EITEMTYPE_EITEMTYPE_PICKEFFECT_ENUM.number = 74
EITEMTYPE_EITEMTYPE_FRIEND_ENUM.name = "EITEMTYPE_FRIEND"
EITEMTYPE_EITEMTYPE_FRIEND_ENUM.index = 29
EITEMTYPE_EITEMTYPE_FRIEND_ENUM.number = 75
EITEMTYPE_EITEMTYPE_PICKEFFECT_1_ENUM.name = "EITEMTYPE_PICKEFFECT_1"
EITEMTYPE_EITEMTYPE_PICKEFFECT_1_ENUM.index = 30
EITEMTYPE_EITEMTYPE_PICKEFFECT_1_ENUM.number = 76
EITEMTYPE_EITEMTYPE_TOY_ENUM.name = "EITEMTYPE_TOY"
EITEMTYPE_EITEMTYPE_TOY_ENUM.index = 31
EITEMTYPE_EITEMTYPE_TOY_ENUM.number = 77
EITEMTYPE_EITEMTYPE_CARD_WEAPON_ENUM.name = "EITEMTYPE_CARD_WEAPON"
EITEMTYPE_EITEMTYPE_CARD_WEAPON_ENUM.index = 32
EITEMTYPE_EITEMTYPE_CARD_WEAPON_ENUM.number = 81
EITEMTYPE_EITEMTYPE_CARD_ASSIST_ENUM.name = "EITEMTYPE_CARD_ASSIST"
EITEMTYPE_EITEMTYPE_CARD_ASSIST_ENUM.index = 33
EITEMTYPE_EITEMTYPE_CARD_ASSIST_ENUM.number = 82
EITEMTYPE_EITEMTYPE_CARD_ARMOUR_ENUM.name = "EITEMTYPE_CARD_ARMOUR"
EITEMTYPE_EITEMTYPE_CARD_ARMOUR_ENUM.index = 34
EITEMTYPE_EITEMTYPE_CARD_ARMOUR_ENUM.number = 83
EITEMTYPE_EITEMTYPE_CARD_ROBE_ENUM.name = "EITEMTYPE_CARD_ROBE"
EITEMTYPE_EITEMTYPE_CARD_ROBE_ENUM.index = 35
EITEMTYPE_EITEMTYPE_CARD_ROBE_ENUM.number = 84
EITEMTYPE_EITEMTYPE_CARD_SHOES_ENUM.name = "EITEMTYPE_CARD_SHOES"
EITEMTYPE_EITEMTYPE_CARD_SHOES_ENUM.index = 36
EITEMTYPE_EITEMTYPE_CARD_SHOES_ENUM.number = 85
EITEMTYPE_EITEMTYPE_CARD_ACCESSORY_ENUM.name = "EITEMTYPE_CARD_ACCESSORY"
EITEMTYPE_EITEMTYPE_CARD_ACCESSORY_ENUM.index = 37
EITEMTYPE_EITEMTYPE_CARD_ACCESSORY_ENUM.number = 86
EITEMTYPE_EITEMTYPE_CARD_HEAD_ENUM.name = "EITEMTYPE_CARD_HEAD"
EITEMTYPE_EITEMTYPE_CARD_HEAD_ENUM.index = 38
EITEMTYPE_EITEMTYPE_CARD_HEAD_ENUM.number = 87
EITEMTYPE_EITEMTYPE_MOUNT_ENUM.name = "EITEMTYPE_MOUNT"
EITEMTYPE_EITEMTYPE_MOUNT_ENUM.index = 39
EITEMTYPE_EITEMTYPE_MOUNT_ENUM.number = 90
EITEMTYPE_EITEMTYPE_BARROW_ENUM.name = "EITEMTYPE_BARROW"
EITEMTYPE_EITEMTYPE_BARROW_ENUM.index = 40
EITEMTYPE_EITEMTYPE_BARROW_ENUM.number = 91
EITEMTYPE_EITEMTYPE_PET_ENUM.name = "EITEMTYPE_PET"
EITEMTYPE_EITEMTYPE_PET_ENUM.index = 41
EITEMTYPE_EITEMTYPE_PET_ENUM.number = 100
EITEMTYPE_EITEMTYPE_EGG_ENUM.name = "EITEMTYPE_EGG"
EITEMTYPE_EITEMTYPE_EGG_ENUM.index = 42
EITEMTYPE_EITEMTYPE_EGG_ENUM.number = 101
EITEMTYPE_EITEMTYPE_PET_EQUIP_ENUM.name = "EITEMTYPE_PET_EQUIP"
EITEMTYPE_EITEMTYPE_PET_EQUIP_ENUM.index = 43
EITEMTYPE_EITEMTYPE_PET_EQUIP_ENUM.number = 102
EITEMTYPE_EITEMTYPE_PET_CONSUME_ENUM.name = "EITEMTYPE_PET_CONSUME"
EITEMTYPE_EITEMTYPE_PET_CONSUME_ENUM.index = 44
EITEMTYPE_EITEMTYPE_PET_CONSUME_ENUM.number = 103
EITEMTYPE_EITEMTYPE_CARDPIECE_ENUM.name = "EITEMTYPE_CARDPIECE"
EITEMTYPE_EITEMTYPE_CARDPIECE_ENUM.index = 45
EITEMTYPE_EITEMTYPE_CARDPIECE_ENUM.number = 110
EITEMTYPE_EITEMTYPE_EQUIPPIECE_ENUM.name = "EITEMTYPE_EQUIPPIECE"
EITEMTYPE_EITEMTYPE_EQUIPPIECE_ENUM.index = 46
EITEMTYPE_EITEMTYPE_EQUIPPIECE_ENUM.number = 120
EITEMTYPE_EITEMTYPE_FASHION_PIECE_ENUM.name = "EITEMTYPE_FASHION_PIECE"
EITEMTYPE_EITEMTYPE_FASHION_PIECE_ENUM.index = 47
EITEMTYPE_EITEMTYPE_FASHION_PIECE_ENUM.number = 121
EITEMTYPE_EITEMTYPE_GOLD_ENUM.name = "EITEMTYPE_GOLD"
EITEMTYPE_EITEMTYPE_GOLD_ENUM.index = 48
EITEMTYPE_EITEMTYPE_GOLD_ENUM.number = 130
EITEMTYPE_EITEMTYPE_SILVER_ENUM.name = "EITEMTYPE_SILVER"
EITEMTYPE_EITEMTYPE_SILVER_ENUM.index = 49
EITEMTYPE_EITEMTYPE_SILVER_ENUM.number = 131
EITEMTYPE_EITEMTYPE_DIAMOND_ENUM.name = "EITEMTYPE_DIAMOND"
EITEMTYPE_EITEMTYPE_DIAMOND_ENUM.index = 50
EITEMTYPE_EITEMTYPE_DIAMOND_ENUM.number = 132
EITEMTYPE_EITEMTYPE_GARDEN_ENUM.name = "EITEMTYPE_GARDEN"
EITEMTYPE_EITEMTYPE_GARDEN_ENUM.index = 51
EITEMTYPE_EITEMTYPE_GARDEN_ENUM.number = 140
EITEMTYPE_EITEMTYPE_CONTRIBUTE_ENUM.name = "EITEMTYPE_CONTRIBUTE"
EITEMTYPE_EITEMTYPE_CONTRIBUTE_ENUM.index = 52
EITEMTYPE_EITEMTYPE_CONTRIBUTE_ENUM.number = 145
EITEMTYPE_EITEMTYPE_ASSET_ENUM.name = "EITEMTYPE_ASSET"
EITEMTYPE_EITEMTYPE_ASSET_ENUM.index = 53
EITEMTYPE_EITEMTYPE_ASSET_ENUM.number = 146
EITEMTYPE_EITEMTYPE_FRIENDSHIP_ENUM.name = "EITEMTYPE_FRIENDSHIP"
EITEMTYPE_EITEMTYPE_FRIENDSHIP_ENUM.index = 54
EITEMTYPE_EITEMTYPE_FRIENDSHIP_ENUM.number = 147
EITEMTYPE_EITEMTYPE_MANUALSPOINT_ENUM.name = "EITEMTYPE_MANUALSPOINT"
EITEMTYPE_EITEMTYPE_MANUALSPOINT_ENUM.index = 55
EITEMTYPE_EITEMTYPE_MANUALSPOINT_ENUM.number = 143
EITEMTYPE_EITEMTYPE_MORA_ENUM.name = "EITEMTYPE_MORA"
EITEMTYPE_EITEMTYPE_MORA_ENUM.index = 56
EITEMTYPE_EITEMTYPE_MORA_ENUM.number = 144
EITEMTYPE_EITEMTYPE_PVPCOIN_ENUM.name = "EITEMTYPE_PVPCOIN"
EITEMTYPE_EITEMTYPE_PVPCOIN_ENUM.index = 57
EITEMTYPE_EITEMTYPE_PVPCOIN_ENUM.number = 141
EITEMTYPE_EITEMTYPE_QUOTA_ENUM.name = "EITEMTYPE_QUOTA"
EITEMTYPE_EITEMTYPE_QUOTA_ENUM.index = 58
EITEMTYPE_EITEMTYPE_QUOTA_ENUM.number = 149
EITEMTYPE_EITEMTYPE_BASEEXP_ENUM.name = "EITEMTYPE_BASEEXP"
EITEMTYPE_EITEMTYPE_BASEEXP_ENUM.index = 59
EITEMTYPE_EITEMTYPE_BASEEXP_ENUM.number = 150
EITEMTYPE_EITEMTYPE_JOBEXP_ENUM.name = "EITEMTYPE_JOBEXP"
EITEMTYPE_EITEMTYPE_JOBEXP_ENUM.index = 60
EITEMTYPE_EITEMTYPE_JOBEXP_ENUM.number = 151
EITEMTYPE_EITEMTYPE_PURIFY_ENUM.name = "EITEMTYPE_PURIFY"
EITEMTYPE_EITEMTYPE_PURIFY_ENUM.index = 61
EITEMTYPE_EITEMTYPE_PURIFY_ENUM.number = 152
EITEMTYPE_EITEMTYPE_MANUALPOINT_ENUM.name = "EITEMTYPE_MANUALPOINT"
EITEMTYPE_EITEMTYPE_MANUALPOINT_ENUM.index = 62
EITEMTYPE_EITEMTYPE_MANUALPOINT_ENUM.number = 153
EITEMTYPE_EITEMTYPE_LOTTERY_ENUM.name = "EITEMTYPE_LOTTERY"
EITEMTYPE_EITEMTYPE_LOTTERY_ENUM.index = 63
EITEMTYPE_EITEMTYPE_LOTTERY_ENUM.number = 154
EITEMTYPE_EITEMTYPE_COOKER_EXP_ENUM.name = "EITEMTYPE_COOKER_EXP"
EITEMTYPE_EITEMTYPE_COOKER_EXP_ENUM.index = 64
EITEMTYPE_EITEMTYPE_COOKER_EXP_ENUM.number = 155
EITEMTYPE_EITEMTYPE_GUILDHONOR_ENUM.name = "EITEMTYPE_GUILDHONOR"
EITEMTYPE_EITEMTYPE_GUILDHONOR_ENUM.index = 65
EITEMTYPE_EITEMTYPE_GUILDHONOR_ENUM.number = 156
EITEMTYPE_EITEMTYPE_POLLY_COIN_ENUM.name = "EITEMTYPE_POLLY_COIN"
EITEMTYPE_EITEMTYPE_POLLY_COIN_ENUM.index = 66
EITEMTYPE_EITEMTYPE_POLLY_COIN_ENUM.number = 157
EITEMTYPE_EITEMTYPE_QUESTITEM_ENUM.name = "EITEMTYPE_QUESTITEM"
EITEMTYPE_EITEMTYPE_QUESTITEM_ENUM.index = 67
EITEMTYPE_EITEMTYPE_QUESTITEM_ENUM.number = 160
EITEMTYPE_EITEMTYPE_COURAGE_ENUM.name = "EITEMTYPE_COURAGE"
EITEMTYPE_EITEMTYPE_COURAGE_ENUM.index = 68
EITEMTYPE_EITEMTYPE_COURAGE_ENUM.number = 164
EITEMTYPE_EITEMTYPE_QUESTITEMCOUNT_ENUM.name = "EITEMTYPE_QUESTITEMCOUNT"
EITEMTYPE_EITEMTYPE_QUESTITEMCOUNT_ENUM.index = 69
EITEMTYPE_EITEMTYPE_QUESTITEMCOUNT_ENUM.number = 165
EITEMTYPE_EITEMTYPE_WEDDING_CERT_ENUM.name = "EITEMTYPE_WEDDING_CERT"
EITEMTYPE_EITEMTYPE_WEDDING_CERT_ENUM.index = 70
EITEMTYPE_EITEMTYPE_WEDDING_CERT_ENUM.number = 166
EITEMTYPE_EITEMTYPE_WEDDING_INVITE_ENUM.name = "EITEMTYPE_WEDDING_INVITE"
EITEMTYPE_EITEMTYPE_WEDDING_INVITE_ENUM.index = 71
EITEMTYPE_EITEMTYPE_WEDDING_INVITE_ENUM.number = 167
EITEMTYPE_EITEMTYPE_WEDDING_MANUAL_ENUM.name = "EITEMTYPE_WEDDING_MANUAL"
EITEMTYPE_EITEMTYPE_WEDDING_MANUAL_ENUM.index = 72
EITEMTYPE_EITEMTYPE_WEDDING_MANUAL_ENUM.number = 168
EITEMTYPE_EITEMTYPE_DEADCOIN_ENUM.name = "EITEMTYPE_DEADCOIN"
EITEMTYPE_EITEMTYPE_DEADCOIN_ENUM.index = 73
EITEMTYPE_EITEMTYPE_DEADCOIN_ENUM.number = 169
EITEMTYPE_EITEMTYPE_WEAPON_LANCE_ENUM.name = "EITEMTYPE_WEAPON_LANCE"
EITEMTYPE_EITEMTYPE_WEAPON_LANCE_ENUM.index = 74
EITEMTYPE_EITEMTYPE_WEAPON_LANCE_ENUM.number = 170
EITEMTYPE_EITEMTYPE_WEAPON_SWORD_ENUM.name = "EITEMTYPE_WEAPON_SWORD"
EITEMTYPE_EITEMTYPE_WEAPON_SWORD_ENUM.index = 75
EITEMTYPE_EITEMTYPE_WEAPON_SWORD_ENUM.number = 180
EITEMTYPE_EITEMTYPE_WEAPON_WAND_ENUM.name = "EITEMTYPE_WEAPON_WAND"
EITEMTYPE_EITEMTYPE_WEAPON_WAND_ENUM.index = 76
EITEMTYPE_EITEMTYPE_WEAPON_WAND_ENUM.number = 190
EITEMTYPE_EITEMTYPE_WEAPON_KNIFE_ENUM.name = "EITEMTYPE_WEAPON_KNIFE"
EITEMTYPE_EITEMTYPE_WEAPON_KNIFE_ENUM.index = 77
EITEMTYPE_EITEMTYPE_WEAPON_KNIFE_ENUM.number = 200
EITEMTYPE_EITEMTYPE_WEAPON_BOW_ENUM.name = "EITEMTYPE_WEAPON_BOW"
EITEMTYPE_EITEMTYPE_WEAPON_BOW_ENUM.index = 78
EITEMTYPE_EITEMTYPE_WEAPON_BOW_ENUM.number = 210
EITEMTYPE_EITEMTYPE_WEAPON_HAMMER_ENUM.name = "EITEMTYPE_WEAPON_HAMMER"
EITEMTYPE_EITEMTYPE_WEAPON_HAMMER_ENUM.index = 79
EITEMTYPE_EITEMTYPE_WEAPON_HAMMER_ENUM.number = 220
EITEMTYPE_EITEMTYPE_WEAPON_AXE_ENUM.name = "EITEMTYPE_WEAPON_AXE"
EITEMTYPE_EITEMTYPE_WEAPON_AXE_ENUM.index = 80
EITEMTYPE_EITEMTYPE_WEAPON_AXE_ENUM.number = 230
EITEMTYPE_EITEMTYPE_WEAPON_BOOK_ENUM.name = "EITEMTYPE_WEAPON_BOOK"
EITEMTYPE_EITEMTYPE_WEAPON_BOOK_ENUM.index = 81
EITEMTYPE_EITEMTYPE_WEAPON_BOOK_ENUM.number = 240
EITEMTYPE_EITEMTYPE_WEAPON_DAGGER_ENUM.name = "EITEMTYPE_WEAPON_DAGGER"
EITEMTYPE_EITEMTYPE_WEAPON_DAGGER_ENUM.index = 82
EITEMTYPE_EITEMTYPE_WEAPON_DAGGER_ENUM.number = 250
EITEMTYPE_EITEMTYPE_WEAPON_INSTRUMEMT_ENUM.name = "EITEMTYPE_WEAPON_INSTRUMEMT"
EITEMTYPE_EITEMTYPE_WEAPON_INSTRUMEMT_ENUM.index = 83
EITEMTYPE_EITEMTYPE_WEAPON_INSTRUMEMT_ENUM.number = 260
EITEMTYPE_EITEMTYPE_WEAPON_WHIP_ENUM.name = "EITEMTYPE_WEAPON_WHIP"
EITEMTYPE_EITEMTYPE_WEAPON_WHIP_ENUM.index = 84
EITEMTYPE_EITEMTYPE_WEAPON_WHIP_ENUM.number = 270
EITEMTYPE_EITEMTYPE_WEAPON_TUBE_ENUM.name = "EITEMTYPE_WEAPON_TUBE"
EITEMTYPE_EITEMTYPE_WEAPON_TUBE_ENUM.index = 85
EITEMTYPE_EITEMTYPE_WEAPON_TUBE_ENUM.number = 280
EITEMTYPE_EITEMTYPE_WEAPON_FIST_ENUM.name = "EITEMTYPE_WEAPON_FIST"
EITEMTYPE_EITEMTYPE_WEAPON_FIST_ENUM.index = 86
EITEMTYPE_EITEMTYPE_WEAPON_FIST_ENUM.number = 290
EITEMTYPE_EITEMTYPE_ARTIFACT_LANCE_ENUM.name = "EITEMTYPE_ARTIFACT_LANCE"
EITEMTYPE_EITEMTYPE_ARTIFACT_LANCE_ENUM.index = 87
EITEMTYPE_EITEMTYPE_ARTIFACT_LANCE_ENUM.number = 450
EITEMTYPE_EITEMTYPE_ARTIFACT_SWORD_ENUM.name = "EITEMTYPE_ARTIFACT_SWORD"
EITEMTYPE_EITEMTYPE_ARTIFACT_SWORD_ENUM.index = 88
EITEMTYPE_EITEMTYPE_ARTIFACT_SWORD_ENUM.number = 451
EITEMTYPE_EITEMTYPE_ARTIFACT_WAND_ENUM.name = "EITEMTYPE_ARTIFACT_WAND"
EITEMTYPE_EITEMTYPE_ARTIFACT_WAND_ENUM.index = 89
EITEMTYPE_EITEMTYPE_ARTIFACT_WAND_ENUM.number = 452
EITEMTYPE_EITEMTYPE_ARTIFACT_KNIFE_ENUM.name = "EITEMTYPE_ARTIFACT_KNIFE"
EITEMTYPE_EITEMTYPE_ARTIFACT_KNIFE_ENUM.index = 90
EITEMTYPE_EITEMTYPE_ARTIFACT_KNIFE_ENUM.number = 453
EITEMTYPE_EITEMTYPE_ARTIFACT_BOW_ENUM.name = "EITEMTYPE_ARTIFACT_BOW"
EITEMTYPE_EITEMTYPE_ARTIFACT_BOW_ENUM.index = 91
EITEMTYPE_EITEMTYPE_ARTIFACT_BOW_ENUM.number = 454
EITEMTYPE_EITEMTYPE_ARTIFACT_HAMMER_ENUM.name = "EITEMTYPE_ARTIFACT_HAMMER"
EITEMTYPE_EITEMTYPE_ARTIFACT_HAMMER_ENUM.index = 92
EITEMTYPE_EITEMTYPE_ARTIFACT_HAMMER_ENUM.number = 455
EITEMTYPE_EITEMTYPE_ARTIFACT_AXE_ENUM.name = "EITEMTYPE_ARTIFACT_AXE"
EITEMTYPE_EITEMTYPE_ARTIFACT_AXE_ENUM.index = 93
EITEMTYPE_EITEMTYPE_ARTIFACT_AXE_ENUM.number = 456
EITEMTYPE_EITEMTYPE_ARTIFACT_DAGGER_ENUM.name = "EITEMTYPE_ARTIFACT_DAGGER"
EITEMTYPE_EITEMTYPE_ARTIFACT_DAGGER_ENUM.index = 94
EITEMTYPE_EITEMTYPE_ARTIFACT_DAGGER_ENUM.number = 457
EITEMTYPE_EITEMTYPE_ARTIFACT_FIST_ENUM.name = "EITEMTYPE_ARTIFACT_FIST"
EITEMTYPE_EITEMTYPE_ARTIFACT_FIST_ENUM.index = 95
EITEMTYPE_EITEMTYPE_ARTIFACT_FIST_ENUM.number = 458
EITEMTYPE_EITEMTYPE_ARTIFACT_INSTRUMEMT_ENUM.name = "EITEMTYPE_ARTIFACT_INSTRUMEMT"
EITEMTYPE_EITEMTYPE_ARTIFACT_INSTRUMEMT_ENUM.index = 96
EITEMTYPE_EITEMTYPE_ARTIFACT_INSTRUMEMT_ENUM.number = 459
EITEMTYPE_EITEMTYPE_ARTIFACT_WHIP_ENUM.name = "EITEMTYPE_ARTIFACT_WHIP"
EITEMTYPE_EITEMTYPE_ARTIFACT_WHIP_ENUM.index = 97
EITEMTYPE_EITEMTYPE_ARTIFACT_WHIP_ENUM.number = 460
EITEMTYPE_EITEMTYPE_ARTIFACT_BOOK_ENUM.name = "EITEMTYPE_ARTIFACT_BOOK"
EITEMTYPE_EITEMTYPE_ARTIFACT_BOOK_ENUM.index = 98
EITEMTYPE_EITEMTYPE_ARTIFACT_BOOK_ENUM.number = 461
EITEMTYPE_EITEMTYPE_ARTIFACT_HEAD_ENUM.name = "EITEMTYPE_ARTIFACT_HEAD"
EITEMTYPE_EITEMTYPE_ARTIFACT_HEAD_ENUM.index = 99
EITEMTYPE_EITEMTYPE_ARTIFACT_HEAD_ENUM.number = 485
EITEMTYPE_EITEMTYPE_ARTIFACT_BACK_ENUM.name = "EITEMTYPE_ARTIFACT_BACK"
EITEMTYPE_EITEMTYPE_ARTIFACT_BACK_ENUM.index = 100
EITEMTYPE_EITEMTYPE_ARTIFACT_BACK_ENUM.number = 488
EITEMTYPE_EITEMTYPE_ARMOUR_ENUM.name = "EITEMTYPE_ARMOUR"
EITEMTYPE_EITEMTYPE_ARMOUR_ENUM.index = 101
EITEMTYPE_EITEMTYPE_ARMOUR_ENUM.number = 500
EITEMTYPE_EITEMTYPE_ARMOUR_FASHION_ENUM.name = "EITEMTYPE_ARMOUR_FASHION"
EITEMTYPE_EITEMTYPE_ARMOUR_FASHION_ENUM.index = 102
EITEMTYPE_EITEMTYPE_ARMOUR_FASHION_ENUM.number = 501
EITEMTYPE_EITEMTYPE_SHIELD_ENUM.name = "EITEMTYPE_SHIELD"
EITEMTYPE_EITEMTYPE_SHIELD_ENUM.index = 103
EITEMTYPE_EITEMTYPE_SHIELD_ENUM.number = 510
EITEMTYPE_EITEMTYPE_PEARL_ENUM.name = "EITEMTYPE_PEARL"
EITEMTYPE_EITEMTYPE_PEARL_ENUM.index = 104
EITEMTYPE_EITEMTYPE_PEARL_ENUM.number = 511
EITEMTYPE_EITEMTYPE_EIKON_ENUM.name = "EITEMTYPE_EIKON"
EITEMTYPE_EITEMTYPE_EIKON_ENUM.index = 105
EITEMTYPE_EITEMTYPE_EIKON_ENUM.number = 512
EITEMTYPE_EITEMTYPE_BRACER_ENUM.name = "EITEMTYPE_BRACER"
EITEMTYPE_EITEMTYPE_BRACER_ENUM.index = 106
EITEMTYPE_EITEMTYPE_BRACER_ENUM.number = 513
EITEMTYPE_EITEMTYPE_BRACELET_ENUM.name = "EITEMTYPE_BRACELET"
EITEMTYPE_EITEMTYPE_BRACELET_ENUM.index = 107
EITEMTYPE_EITEMTYPE_BRACELET_ENUM.number = 514
EITEMTYPE_EITEMTYPE_TROLLEY_ENUM.name = "EITEMTYPE_TROLLEY"
EITEMTYPE_EITEMTYPE_TROLLEY_ENUM.index = 108
EITEMTYPE_EITEMTYPE_TROLLEY_ENUM.number = 515
EITEMTYPE_EITEMTYPE_ROBE_ENUM.name = "EITEMTYPE_ROBE"
EITEMTYPE_EITEMTYPE_ROBE_ENUM.index = 109
EITEMTYPE_EITEMTYPE_ROBE_ENUM.number = 520
EITEMTYPE_EITEMTYPE_SHOES_ENUM.name = "EITEMTYPE_SHOES"
EITEMTYPE_EITEMTYPE_SHOES_ENUM.index = 110
EITEMTYPE_EITEMTYPE_SHOES_ENUM.number = 530
EITEMTYPE_EITEMTYPE_ACCESSORY_ENUM.name = "EITEMTYPE_ACCESSORY"
EITEMTYPE_EITEMTYPE_ACCESSORY_ENUM.index = 111
EITEMTYPE_EITEMTYPE_ACCESSORY_ENUM.number = 540
EITEMTYPE_EITEMTYPE_FOOD_MEAT_ENUM.name = "EITEMTYPE_FOOD_MEAT"
EITEMTYPE_EITEMTYPE_FOOD_MEAT_ENUM.index = 112
EITEMTYPE_EITEMTYPE_FOOD_MEAT_ENUM.number = 601
EITEMTYPE_EITEMTYPE_FOOD_FISH_ENUM.name = "EITEMTYPE_FOOD_FISH"
EITEMTYPE_EITEMTYPE_FOOD_FISH_ENUM.index = 113
EITEMTYPE_EITEMTYPE_FOOD_FISH_ENUM.number = 602
EITEMTYPE_EITEMTYPE_FOOD_VEGETABLE_ENUM.name = "EITEMTYPE_FOOD_VEGETABLE"
EITEMTYPE_EITEMTYPE_FOOD_VEGETABLE_ENUM.index = 114
EITEMTYPE_EITEMTYPE_FOOD_VEGETABLE_ENUM.number = 603
EITEMTYPE_EITEMTYPE_FOOD_FRUIT_ENUM.name = "EITEMTYPE_FOOD_FRUIT"
EITEMTYPE_EITEMTYPE_FOOD_FRUIT_ENUM.index = 115
EITEMTYPE_EITEMTYPE_FOOD_FRUIT_ENUM.number = 604
EITEMTYPE_EITEMTYPE_FOOD_SEASONING_ENUM.name = "EITEMTYPE_FOOD_SEASONING"
EITEMTYPE_EITEMTYPE_FOOD_SEASONING_ENUM.index = 116
EITEMTYPE_EITEMTYPE_FOOD_SEASONING_ENUM.number = 605
EITEMTYPE_EITEMTYPE_FOOD_ENUM.name = "EITEMTYPE_FOOD"
EITEMTYPE_EITEMTYPE_FOOD_ENUM.index = 117
EITEMTYPE_EITEMTYPE_FOOD_ENUM.number = 610
EITEMTYPE_EITEMTYPE_HEAD_ENUM.name = "EITEMTYPE_HEAD"
EITEMTYPE_EITEMTYPE_HEAD_ENUM.index = 118
EITEMTYPE_EITEMTYPE_HEAD_ENUM.number = 800
EITEMTYPE_EITEMTYPE_BACK_ENUM.name = "EITEMTYPE_BACK"
EITEMTYPE_EITEMTYPE_BACK_ENUM.index = 119
EITEMTYPE_EITEMTYPE_BACK_ENUM.number = 810
EITEMTYPE_EITEMTYPE_HAIR_ENUM.name = "EITEMTYPE_HAIR"
EITEMTYPE_EITEMTYPE_HAIR_ENUM.index = 120
EITEMTYPE_EITEMTYPE_HAIR_ENUM.number = 820
EITEMTYPE_EITEMTYPE_HAIR_MALE_ENUM.name = "EITEMTYPE_HAIR_MALE"
EITEMTYPE_EITEMTYPE_HAIR_MALE_ENUM.index = 121
EITEMTYPE_EITEMTYPE_HAIR_MALE_ENUM.number = 821
EITEMTYPE_EITEMTYPE_HAIR_FEMALE_ENUM.name = "EITEMTYPE_HAIR_FEMALE"
EITEMTYPE_EITEMTYPE_HAIR_FEMALE_ENUM.index = 122
EITEMTYPE_EITEMTYPE_HAIR_FEMALE_ENUM.number = 822
EITEMTYPE_EITEMTYPE_EYE_MALE_ENUM.name = "EITEMTYPE_EYE_MALE"
EITEMTYPE_EITEMTYPE_EYE_MALE_ENUM.index = 123
EITEMTYPE_EITEMTYPE_EYE_MALE_ENUM.number = 823
EITEMTYPE_EITEMTYPE_EYE_FEMALE_ENUM.name = "EITEMTYPE_EYE_FEMALE"
EITEMTYPE_EITEMTYPE_EYE_FEMALE_ENUM.index = 124
EITEMTYPE_EITEMTYPE_EYE_FEMALE_ENUM.number = 824
EITEMTYPE_EITEMTYPE_FACE_ENUM.name = "EITEMTYPE_FACE"
EITEMTYPE_EITEMTYPE_FACE_ENUM.index = 125
EITEMTYPE_EITEMTYPE_FACE_ENUM.number = 830
EITEMTYPE_EITEMTYPE_TAIL_ENUM.name = "EITEMTYPE_TAIL"
EITEMTYPE_EITEMTYPE_TAIL_ENUM.index = 126
EITEMTYPE_EITEMTYPE_TAIL_ENUM.number = 840
EITEMTYPE_EITEMTYPE_MOUTH_ENUM.name = "EITEMTYPE_MOUTH"
EITEMTYPE_EITEMTYPE_MOUTH_ENUM.index = 127
EITEMTYPE_EITEMTYPE_MOUTH_ENUM.number = 850
EITEMTYPE_EITEMTYPE_WATER_ELEMENT_ENUM.name = "EITEMTYPE_WATER_ELEMENT"
EITEMTYPE_EITEMTYPE_WATER_ELEMENT_ENUM.index = 128
EITEMTYPE_EITEMTYPE_WATER_ELEMENT_ENUM.number = 1001
EITEMTYPE_EITEMTYPE_PORTRAIT_ENUM.name = "EITEMTYPE_PORTRAIT"
EITEMTYPE_EITEMTYPE_PORTRAIT_ENUM.index = 129
EITEMTYPE_EITEMTYPE_PORTRAIT_ENUM.number = 1200
EITEMTYPE_EITEMTYPE_FRAME_ENUM.name = "EITEMTYPE_FRAME"
EITEMTYPE_EITEMTYPE_FRAME_ENUM.index = 130
EITEMTYPE_EITEMTYPE_FRAME_ENUM.number = 1210
EITEMTYPE_EITEMTYPE_CODE_ENUM.name = "EITEMTYPE_CODE"
EITEMTYPE_EITEMTYPE_CODE_ENUM.index = 131
EITEMTYPE_EITEMTYPE_CODE_ENUM.number = 4000
EITEMTYPE_EITEMTYPE_KFC_CODE_ENUM.name = "EITEMTYPE_KFC_CODE"
EITEMTYPE_EITEMTYPE_KFC_CODE_ENUM.index = 132
EITEMTYPE_EITEMTYPE_KFC_CODE_ENUM.number = 4200
EITEMTYPE_EITEMTYPE_DRAW_CODE_ENUM.name = "EITEMTYPE_DRAW_CODE"
EITEMTYPE_EITEMTYPE_DRAW_CODE_ENUM.index = 133
EITEMTYPE_EITEMTYPE_DRAW_CODE_ENUM.number = 4201
EITEMTYPE_EITEMTYPE_MAX_ENUM.name = "EITEMTYPE_MAX"
EITEMTYPE_EITEMTYPE_MAX_ENUM.index = 134
EITEMTYPE_EITEMTYPE_MAX_ENUM.number = 4202
EITEMTYPE.name = "EItemType"
EITEMTYPE.full_name = ".Cmd.EItemType"
EITEMTYPE.values = {
  EITEMTYPE_EITEMTYPE_MIN_ENUM,
  EITEMTYPE_EITEMTYPE_HONOR_ENUM,
  EITEMTYPE_EITEMTYPE_STREASURE_ENUM,
  EITEMTYPE_EITEMTYPE_TREASURE_ENUM,
  EITEMTYPE_EITEMTYPE_STUFF_ENUM,
  EITEMTYPE_EITEMTYPE_STUFFNOCUT_ENUM,
  EITEMTYPE_EITEMTYPE_ARROW_ENUM,
  EITEMTYPE_EITEMTYPE_USESKILL_ENUM,
  EITEMTYPE_EITEMTYPE_GHOSTLAMP_ENUM,
  EITEMTYPE_EITEMTYPE_MULTITIME_ENUM,
  EITEMTYPE_EITEMTYPE_MONTHCARD_ENUM,
  EITEMTYPE_EITEMTYPE_QUEST_ONCE_ENUM,
  EITEMTYPE_EITEMTYPE_QUEST_TIME_ENUM,
  EITEMTYPE_EITEMTYPE_SHEET_ENUM,
  EITEMTYPE_EITEMTYPE_PET_WEARSHEET_ENUM,
  EITEMTYPE_EITEMTYPE_PET_WEARUNLOCK_ENUM,
  EITEMTYPE_EITEMTYPE_CONSUME_ENUM,
  EITEMTYPE_EITEMTYPE_HAIRSTUFF_ENUM,
  EITEMTYPE_EITEMTYPE_CONSUME_2_ENUM,
  EITEMTYPE_EITEMTYPE_COLLECTION_ENUM,
  EITEMTYPE_EITEMTYPE_RANGE_ENUM,
  EITEMTYPE_EITEMTYPE_FUNCTION_ENUM,
  EITEMTYPE_EITEMTYPE_ACTIVITY_ENUM,
  EITEMTYPE_EITEMTYPE_WEDDING_RING_ENUM,
  EITEMTYPE_EITEMTYPE_MATERIAL_ENUM,
  EITEMTYPE_EITEMTYPE_LETTER_ENUM,
  EITEMTYPE_EITEMTYPE_GOLDAPPLE_ENUM,
  EITEMTYPE_EITEMTYPE_GETSKILL_ENUM,
  EITEMTYPE_EITEMTYPE_PICKEFFECT_ENUM,
  EITEMTYPE_EITEMTYPE_FRIEND_ENUM,
  EITEMTYPE_EITEMTYPE_PICKEFFECT_1_ENUM,
  EITEMTYPE_EITEMTYPE_TOY_ENUM,
  EITEMTYPE_EITEMTYPE_CARD_WEAPON_ENUM,
  EITEMTYPE_EITEMTYPE_CARD_ASSIST_ENUM,
  EITEMTYPE_EITEMTYPE_CARD_ARMOUR_ENUM,
  EITEMTYPE_EITEMTYPE_CARD_ROBE_ENUM,
  EITEMTYPE_EITEMTYPE_CARD_SHOES_ENUM,
  EITEMTYPE_EITEMTYPE_CARD_ACCESSORY_ENUM,
  EITEMTYPE_EITEMTYPE_CARD_HEAD_ENUM,
  EITEMTYPE_EITEMTYPE_MOUNT_ENUM,
  EITEMTYPE_EITEMTYPE_BARROW_ENUM,
  EITEMTYPE_EITEMTYPE_PET_ENUM,
  EITEMTYPE_EITEMTYPE_EGG_ENUM,
  EITEMTYPE_EITEMTYPE_PET_EQUIP_ENUM,
  EITEMTYPE_EITEMTYPE_PET_CONSUME_ENUM,
  EITEMTYPE_EITEMTYPE_CARDPIECE_ENUM,
  EITEMTYPE_EITEMTYPE_EQUIPPIECE_ENUM,
  EITEMTYPE_EITEMTYPE_FASHION_PIECE_ENUM,
  EITEMTYPE_EITEMTYPE_GOLD_ENUM,
  EITEMTYPE_EITEMTYPE_SILVER_ENUM,
  EITEMTYPE_EITEMTYPE_DIAMOND_ENUM,
  EITEMTYPE_EITEMTYPE_GARDEN_ENUM,
  EITEMTYPE_EITEMTYPE_CONTRIBUTE_ENUM,
  EITEMTYPE_EITEMTYPE_ASSET_ENUM,
  EITEMTYPE_EITEMTYPE_FRIENDSHIP_ENUM,
  EITEMTYPE_EITEMTYPE_MANUALSPOINT_ENUM,
  EITEMTYPE_EITEMTYPE_MORA_ENUM,
  EITEMTYPE_EITEMTYPE_PVPCOIN_ENUM,
  EITEMTYPE_EITEMTYPE_QUOTA_ENUM,
  EITEMTYPE_EITEMTYPE_BASEEXP_ENUM,
  EITEMTYPE_EITEMTYPE_JOBEXP_ENUM,
  EITEMTYPE_EITEMTYPE_PURIFY_ENUM,
  EITEMTYPE_EITEMTYPE_MANUALPOINT_ENUM,
  EITEMTYPE_EITEMTYPE_LOTTERY_ENUM,
  EITEMTYPE_EITEMTYPE_COOKER_EXP_ENUM,
  EITEMTYPE_EITEMTYPE_GUILDHONOR_ENUM,
  EITEMTYPE_EITEMTYPE_POLLY_COIN_ENUM,
  EITEMTYPE_EITEMTYPE_QUESTITEM_ENUM,
  EITEMTYPE_EITEMTYPE_COURAGE_ENUM,
  EITEMTYPE_EITEMTYPE_QUESTITEMCOUNT_ENUM,
  EITEMTYPE_EITEMTYPE_WEDDING_CERT_ENUM,
  EITEMTYPE_EITEMTYPE_WEDDING_INVITE_ENUM,
  EITEMTYPE_EITEMTYPE_WEDDING_MANUAL_ENUM,
  EITEMTYPE_EITEMTYPE_DEADCOIN_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_LANCE_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_SWORD_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_WAND_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_KNIFE_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_BOW_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_HAMMER_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_AXE_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_BOOK_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_DAGGER_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_INSTRUMEMT_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_WHIP_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_TUBE_ENUM,
  EITEMTYPE_EITEMTYPE_WEAPON_FIST_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_LANCE_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_SWORD_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_WAND_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_KNIFE_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_BOW_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_HAMMER_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_AXE_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_DAGGER_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_FIST_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_INSTRUMEMT_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_WHIP_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_BOOK_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_HEAD_ENUM,
  EITEMTYPE_EITEMTYPE_ARTIFACT_BACK_ENUM,
  EITEMTYPE_EITEMTYPE_ARMOUR_ENUM,
  EITEMTYPE_EITEMTYPE_ARMOUR_FASHION_ENUM,
  EITEMTYPE_EITEMTYPE_SHIELD_ENUM,
  EITEMTYPE_EITEMTYPE_PEARL_ENUM,
  EITEMTYPE_EITEMTYPE_EIKON_ENUM,
  EITEMTYPE_EITEMTYPE_BRACER_ENUM,
  EITEMTYPE_EITEMTYPE_BRACELET_ENUM,
  EITEMTYPE_EITEMTYPE_TROLLEY_ENUM,
  EITEMTYPE_EITEMTYPE_ROBE_ENUM,
  EITEMTYPE_EITEMTYPE_SHOES_ENUM,
  EITEMTYPE_EITEMTYPE_ACCESSORY_ENUM,
  EITEMTYPE_EITEMTYPE_FOOD_MEAT_ENUM,
  EITEMTYPE_EITEMTYPE_FOOD_FISH_ENUM,
  EITEMTYPE_EITEMTYPE_FOOD_VEGETABLE_ENUM,
  EITEMTYPE_EITEMTYPE_FOOD_FRUIT_ENUM,
  EITEMTYPE_EITEMTYPE_FOOD_SEASONING_ENUM,
  EITEMTYPE_EITEMTYPE_FOOD_ENUM,
  EITEMTYPE_EITEMTYPE_HEAD_ENUM,
  EITEMTYPE_EITEMTYPE_BACK_ENUM,
  EITEMTYPE_EITEMTYPE_HAIR_ENUM,
  EITEMTYPE_EITEMTYPE_HAIR_MALE_ENUM,
  EITEMTYPE_EITEMTYPE_HAIR_FEMALE_ENUM,
  EITEMTYPE_EITEMTYPE_EYE_MALE_ENUM,
  EITEMTYPE_EITEMTYPE_EYE_FEMALE_ENUM,
  EITEMTYPE_EITEMTYPE_FACE_ENUM,
  EITEMTYPE_EITEMTYPE_TAIL_ENUM,
  EITEMTYPE_EITEMTYPE_MOUTH_ENUM,
  EITEMTYPE_EITEMTYPE_WATER_ELEMENT_ENUM,
  EITEMTYPE_EITEMTYPE_PORTRAIT_ENUM,
  EITEMTYPE_EITEMTYPE_FRAME_ENUM,
  EITEMTYPE_EITEMTYPE_CODE_ENUM,
  EITEMTYPE_EITEMTYPE_KFC_CODE_ENUM,
  EITEMTYPE_EITEMTYPE_DRAW_CODE_ENUM,
  EITEMTYPE_EITEMTYPE_MAX_ENUM
}
EEQUIPTYPE_EEQUIPTYPE_MIN_ENUM.name = "EEQUIPTYPE_MIN"
EEQUIPTYPE_EEQUIPTYPE_MIN_ENUM.index = 0
EEQUIPTYPE_EEQUIPTYPE_MIN_ENUM.number = 0
EEQUIPTYPE_EEQUIPTYPE_WEAPON_ENUM.name = "EEQUIPTYPE_WEAPON"
EEQUIPTYPE_EEQUIPTYPE_WEAPON_ENUM.index = 1
EEQUIPTYPE_EEQUIPTYPE_WEAPON_ENUM.number = 1
EEQUIPTYPE_EEQUIPTYPE_SHIELD_ENUM.name = "EEQUIPTYPE_SHIELD"
EEQUIPTYPE_EEQUIPTYPE_SHIELD_ENUM.index = 2
EEQUIPTYPE_EEQUIPTYPE_SHIELD_ENUM.number = 3
EEQUIPTYPE_EEQUIPTYPE_ARMOUR_ENUM.name = "EEQUIPTYPE_ARMOUR"
EEQUIPTYPE_EEQUIPTYPE_ARMOUR_ENUM.index = 3
EEQUIPTYPE_EEQUIPTYPE_ARMOUR_ENUM.number = 2
EEQUIPTYPE_EEQUIPTYPE_ROBE_ENUM.name = "EEQUIPTYPE_ROBE"
EEQUIPTYPE_EEQUIPTYPE_ROBE_ENUM.index = 4
EEQUIPTYPE_EEQUIPTYPE_ROBE_ENUM.number = 4
EEQUIPTYPE_EEQUIPTYPE_SHOES_ENUM.name = "EEQUIPTYPE_SHOES"
EEQUIPTYPE_EEQUIPTYPE_SHOES_ENUM.index = 5
EEQUIPTYPE_EEQUIPTYPE_SHOES_ENUM.number = 5
EEQUIPTYPE_EEQUIPTYPE_ACCESSORY_ENUM.name = "EEQUIPTYPE_ACCESSORY"
EEQUIPTYPE_EEQUIPTYPE_ACCESSORY_ENUM.index = 6
EEQUIPTYPE_EEQUIPTYPE_ACCESSORY_ENUM.number = 6
EEQUIPTYPE_EEQUIPTYPE_HEAD_ENUM.name = "EEQUIPTYPE_HEAD"
EEQUIPTYPE_EEQUIPTYPE_HEAD_ENUM.index = 7
EEQUIPTYPE_EEQUIPTYPE_HEAD_ENUM.number = 8
EEQUIPTYPE_EEQUIPTYPE_BACK_ENUM.name = "EEQUIPTYPE_BACK"
EEQUIPTYPE_EEQUIPTYPE_BACK_ENUM.index = 8
EEQUIPTYPE_EEQUIPTYPE_BACK_ENUM.number = 9
EEQUIPTYPE_EEQUIPTYPE_FACE_ENUM.name = "EEQUIPTYPE_FACE"
EEQUIPTYPE_EEQUIPTYPE_FACE_ENUM.index = 9
EEQUIPTYPE_EEQUIPTYPE_FACE_ENUM.number = 10
EEQUIPTYPE_EEQUIPTYPE_TAIL_ENUM.name = "EEQUIPTYPE_TAIL"
EEQUIPTYPE_EEQUIPTYPE_TAIL_ENUM.index = 10
EEQUIPTYPE_EEQUIPTYPE_TAIL_ENUM.number = 11
EEQUIPTYPE_EEQUIPTYPE_MOUNT_ENUM.name = "EEQUIPTYPE_MOUNT"
EEQUIPTYPE_EEQUIPTYPE_MOUNT_ENUM.index = 11
EEQUIPTYPE_EEQUIPTYPE_MOUNT_ENUM.number = 12
EEQUIPTYPE_EEQUIPTYPE_MOUTH_ENUM.name = "EEQUIPTYPE_MOUTH"
EEQUIPTYPE_EEQUIPTYPE_MOUTH_ENUM.index = 12
EEQUIPTYPE_EEQUIPTYPE_MOUTH_ENUM.number = 13
EEQUIPTYPE_EEQUIPTYPE_BARROW_ENUM.name = "EEQUIPTYPE_BARROW"
EEQUIPTYPE_EEQUIPTYPE_BARROW_ENUM.index = 13
EEQUIPTYPE_EEQUIPTYPE_BARROW_ENUM.number = 14
EEQUIPTYPE_EEQUIPTYPE_PEARL_ENUM.name = "EEQUIPTYPE_PEARL"
EEQUIPTYPE_EEQUIPTYPE_PEARL_ENUM.index = 14
EEQUIPTYPE_EEQUIPTYPE_PEARL_ENUM.number = 16
EEQUIPTYPE_EEQUIPTYPE_EIKON_ENUM.name = "EEQUIPTYPE_EIKON"
EEQUIPTYPE_EEQUIPTYPE_EIKON_ENUM.index = 15
EEQUIPTYPE_EEQUIPTYPE_EIKON_ENUM.number = 17
EEQUIPTYPE_EEQUIPTYPE_BRACELET_ENUM.name = "EEQUIPTYPE_BRACELET"
EEQUIPTYPE_EEQUIPTYPE_BRACELET_ENUM.index = 16
EEQUIPTYPE_EEQUIPTYPE_BRACELET_ENUM.number = 18
EEQUIPTYPE_EEQUIPTYPE_HANDBRACELET_ENUM.name = "EEQUIPTYPE_HANDBRACELET"
EEQUIPTYPE_EEQUIPTYPE_HANDBRACELET_ENUM.index = 17
EEQUIPTYPE_EEQUIPTYPE_HANDBRACELET_ENUM.number = 19
EEQUIPTYPE_EEQUIPTYPE_TROLLEY_ENUM.name = "EEQUIPTYPE_TROLLEY"
EEQUIPTYPE_EEQUIPTYPE_TROLLEY_ENUM.index = 18
EEQUIPTYPE_EEQUIPTYPE_TROLLEY_ENUM.number = 20
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_ENUM.name = "EEQUIPTYPE_ARTIFACT"
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_ENUM.index = 19
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_ENUM.number = 21
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_HEAD_ENUM.name = "EEQUIPTYPE_ARTIFACT_HEAD"
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_HEAD_ENUM.index = 20
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_HEAD_ENUM.number = 22
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_BACK_ENUM.name = "EEQUIPTYPE_ARTIFACT_BACK"
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_BACK_ENUM.index = 21
EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_BACK_ENUM.number = 23
EEQUIPTYPE_EEQUIPTYPE_MAX_ENUM.name = "EEQUIPTYPE_MAX"
EEQUIPTYPE_EEQUIPTYPE_MAX_ENUM.index = 22
EEQUIPTYPE_EEQUIPTYPE_MAX_ENUM.number = 24
EEQUIPTYPE.name = "EEquipType"
EEQUIPTYPE.full_name = ".Cmd.EEquipType"
EEQUIPTYPE.values = {
  EEQUIPTYPE_EEQUIPTYPE_MIN_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_WEAPON_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_SHIELD_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_ARMOUR_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_ROBE_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_SHOES_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_ACCESSORY_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_HEAD_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_BACK_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_FACE_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_TAIL_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_MOUNT_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_MOUTH_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_BARROW_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_PEARL_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_EIKON_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_BRACELET_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_HANDBRACELET_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_TROLLEY_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_HEAD_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_ARTIFACT_BACK_ENUM,
  EEQUIPTYPE_EEQUIPTYPE_MAX_ENUM
}
EBINDTYPE_EBINDTYPE_MIN_ENUM.name = "EBINDTYPE_MIN"
EBINDTYPE_EBINDTYPE_MIN_ENUM.index = 0
EBINDTYPE_EBINDTYPE_MIN_ENUM.number = 0
EBINDTYPE_EBINDTYPE_BIND_ENUM.name = "EBINDTYPE_BIND"
EBINDTYPE_EBINDTYPE_BIND_ENUM.index = 1
EBINDTYPE_EBINDTYPE_BIND_ENUM.number = 1
EBINDTYPE_EBINDTYPE_NOBIND_ENUM.name = "EBINDTYPE_NOBIND"
EBINDTYPE_EBINDTYPE_NOBIND_ENUM.index = 2
EBINDTYPE_EBINDTYPE_NOBIND_ENUM.number = 2
EBINDTYPE_EBINDTYPE_MAX_ENUM.name = "EBINDTYPE_MAX"
EBINDTYPE_EBINDTYPE_MAX_ENUM.index = 3
EBINDTYPE_EBINDTYPE_MAX_ENUM.number = 3
EBINDTYPE.name = "EBindType"
EBINDTYPE.full_name = ".Cmd.EBindType"
EBINDTYPE.values = {
  EBINDTYPE_EBINDTYPE_MIN_ENUM,
  EBINDTYPE_EBINDTYPE_BIND_ENUM,
  EBINDTYPE_EBINDTYPE_NOBIND_ENUM,
  EBINDTYPE_EBINDTYPE_MAX_ENUM
}
EEXPIRETYPE_EEXPIRETYPE_MIN_ENUM.name = "EEXPIRETYPE_MIN"
EEXPIRETYPE_EEXPIRETYPE_MIN_ENUM.index = 0
EEXPIRETYPE_EEXPIRETYPE_MIN_ENUM.number = 0
EEXPIRETYPE_EEXPIRETYPE_MAX_ENUM.name = "EEXPIRETYPE_MAX"
EEXPIRETYPE_EEXPIRETYPE_MAX_ENUM.index = 1
EEXPIRETYPE_EEXPIRETYPE_MAX_ENUM.number = 1
EEXPIRETYPE.name = "EExpireType"
EEXPIRETYPE.full_name = ".Cmd.EExpireType"
EEXPIRETYPE.values = {
  EEXPIRETYPE_EEXPIRETYPE_MIN_ENUM,
  EEXPIRETYPE_EEXPIRETYPE_MAX_ENUM
}
ERIDETYPE_ERIDETYPE_MIN_ENUM.name = "ERIDETYPE_MIN"
ERIDETYPE_ERIDETYPE_MIN_ENUM.index = 0
ERIDETYPE_ERIDETYPE_MIN_ENUM.number = 0
ERIDETYPE_ERIDETYPE_ON_ENUM.name = "ERIDETYPE_ON"
ERIDETYPE_ERIDETYPE_ON_ENUM.index = 1
ERIDETYPE_ERIDETYPE_ON_ENUM.number = 1
ERIDETYPE_ERIDETYPE_OFF_ENUM.name = "ERIDETYPE_OFF"
ERIDETYPE_ERIDETYPE_OFF_ENUM.index = 2
ERIDETYPE_ERIDETYPE_OFF_ENUM.number = 2
ERIDETYPE_ERIDETYPE_MAX_ENUM.name = "ERIDETYPE_MAX"
ERIDETYPE_ERIDETYPE_MAX_ENUM.index = 3
ERIDETYPE_ERIDETYPE_MAX_ENUM.number = 3
ERIDETYPE.name = "ERideType"
ERIDETYPE.full_name = ".Cmd.ERideType"
ERIDETYPE.values = {
  ERIDETYPE_ERIDETYPE_MIN_ENUM,
  ERIDETYPE_ERIDETYPE_ON_ENUM,
  ERIDETYPE_ERIDETYPE_OFF_ENUM,
  ERIDETYPE_ERIDETYPE_MAX_ENUM
}
ETRAGETTYPE_ETARGETTYPE_MY_ENUM.name = "ETARGETTYPE_MY"
ETRAGETTYPE_ETARGETTYPE_MY_ENUM.index = 0
ETRAGETTYPE_ETARGETTYPE_MY_ENUM.number = 0
ETRAGETTYPE_ETARGETTYPE_USER_ENUM.name = "ETARGETTYPE_USER"
ETRAGETTYPE_ETARGETTYPE_USER_ENUM.index = 1
ETRAGETTYPE_ETARGETTYPE_USER_ENUM.number = 1
ETRAGETTYPE_ETARGETTYPE_MONSTER_ENUM.name = "ETARGETTYPE_MONSTER"
ETRAGETTYPE_ETARGETTYPE_MONSTER_ENUM.index = 2
ETRAGETTYPE_ETARGETTYPE_MONSTER_ENUM.number = 2
ETRAGETTYPE_ETARGETTYPE_USERANDMONSTER_ENUM.name = "ETARGETTYPE_USERANDMONSTER"
ETRAGETTYPE_ETARGETTYPE_USERANDMONSTER_ENUM.index = 3
ETRAGETTYPE_ETARGETTYPE_USERANDMONSTER_ENUM.number = 3
ETRAGETTYPE.name = "ETragetType"
ETRAGETTYPE.full_name = ".Cmd.ETragetType"
ETRAGETTYPE.values = {
  ETRAGETTYPE_ETARGETTYPE_MY_ENUM,
  ETRAGETTYPE_ETARGETTYPE_USER_ENUM,
  ETRAGETTYPE_ETARGETTYPE_MONSTER_ENUM,
  ETRAGETTYPE_ETARGETTYPE_USERANDMONSTER_ENUM
}
EENCHANTTYPE_EENCHANTTYPE_MIN_ENUM.name = "EENCHANTTYPE_MIN"
EENCHANTTYPE_EENCHANTTYPE_MIN_ENUM.index = 0
EENCHANTTYPE_EENCHANTTYPE_MIN_ENUM.number = 0
EENCHANTTYPE_EENCHANTTYPE_PRIMARY_ENUM.name = "EENCHANTTYPE_PRIMARY"
EENCHANTTYPE_EENCHANTTYPE_PRIMARY_ENUM.index = 1
EENCHANTTYPE_EENCHANTTYPE_PRIMARY_ENUM.number = 1
EENCHANTTYPE_EENCHANTTYPE_MEDIUM_ENUM.name = "EENCHANTTYPE_MEDIUM"
EENCHANTTYPE_EENCHANTTYPE_MEDIUM_ENUM.index = 2
EENCHANTTYPE_EENCHANTTYPE_MEDIUM_ENUM.number = 2
EENCHANTTYPE_EENCHANTTYPE_SENIOR_ENUM.name = "EENCHANTTYPE_SENIOR"
EENCHANTTYPE_EENCHANTTYPE_SENIOR_ENUM.index = 3
EENCHANTTYPE_EENCHANTTYPE_SENIOR_ENUM.number = 3
EENCHANTTYPE_EENCHANTTYPE_MAX_ENUM.name = "EENCHANTTYPE_MAX"
EENCHANTTYPE_EENCHANTTYPE_MAX_ENUM.index = 4
EENCHANTTYPE_EENCHANTTYPE_MAX_ENUM.number = 4
EENCHANTTYPE.name = "EEnchantType"
EENCHANTTYPE.full_name = ".Cmd.EEnchantType"
EENCHANTTYPE.values = {
  EENCHANTTYPE_EENCHANTTYPE_MIN_ENUM,
  EENCHANTTYPE_EENCHANTTYPE_PRIMARY_ENUM,
  EENCHANTTYPE_EENCHANTTYPE_MEDIUM_ENUM,
  EENCHANTTYPE_EENCHANTTYPE_SENIOR_ENUM,
  EENCHANTTYPE_EENCHANTTYPE_MAX_ENUM
}
ELETTERTYPE_ELETTERTYPE_LOVE_ENUM.name = "ELETTERTYPE_LOVE"
ELETTERTYPE_ELETTERTYPE_LOVE_ENUM.index = 0
ELETTERTYPE_ELETTERTYPE_LOVE_ENUM.number = 1
ELETTERTYPE_ELETTERTYPE_CONSTELLATION_ENUM.name = "ELETTERTYPE_CONSTELLATION"
ELETTERTYPE_ELETTERTYPE_CONSTELLATION_ENUM.index = 1
ELETTERTYPE_ELETTERTYPE_CONSTELLATION_ENUM.number = 2
ELETTERTYPE_ELETTERTYPE_CHRISTMAS_ENUM.name = "ELETTERTYPE_CHRISTMAS"
ELETTERTYPE_ELETTERTYPE_CHRISTMAS_ENUM.index = 2
ELETTERTYPE_ELETTERTYPE_CHRISTMAS_ENUM.number = 3
ELETTERTYPE_ELETTERTYPE_SPRING_ENUM.name = "ELETTERTYPE_SPRING"
ELETTERTYPE_ELETTERTYPE_SPRING_ENUM.index = 3
ELETTERTYPE_ELETTERTYPE_SPRING_ENUM.number = 4
ELETTERTYPE_ELETTERTYPE_LOTTERY_ENUM.name = "ELETTERTYPE_LOTTERY"
ELETTERTYPE_ELETTERTYPE_LOTTERY_ENUM.index = 4
ELETTERTYPE_ELETTERTYPE_LOTTERY_ENUM.number = 5
ELETTERTYPE_ELETTERTYPE_WEDDINGDRESS_ENUM.name = "ELETTERTYPE_WEDDINGDRESS"
ELETTERTYPE_ELETTERTYPE_WEDDINGDRESS_ENUM.index = 5
ELETTERTYPE_ELETTERTYPE_WEDDINGDRESS_ENUM.number = 6
ELETTERTYPE.name = "ELetterType"
ELETTERTYPE.full_name = ".Cmd.ELetterType"
ELETTERTYPE.values = {
  ELETTERTYPE_ELETTERTYPE_LOVE_ENUM,
  ELETTERTYPE_ELETTERTYPE_CONSTELLATION_ENUM,
  ELETTERTYPE_ELETTERTYPE_CHRISTMAS_ENUM,
  ELETTERTYPE_ELETTERTYPE_SPRING_ENUM,
  ELETTERTYPE_ELETTERTYPE_LOTTERY_ENUM,
  ELETTERTYPE_ELETTERTYPE_WEDDINGDRESS_ENUM
}
EEQUIPOPER_EEQUIPOPER_MIN_ENUM.name = "EEQUIPOPER_MIN"
EEQUIPOPER_EEQUIPOPER_MIN_ENUM.index = 0
EEQUIPOPER_EEQUIPOPER_MIN_ENUM.number = 0
EEQUIPOPER_EEQUIPOPER_ON_ENUM.name = "EEQUIPOPER_ON"
EEQUIPOPER_EEQUIPOPER_ON_ENUM.index = 1
EEQUIPOPER_EEQUIPOPER_ON_ENUM.number = 1
EEQUIPOPER_EEQUIPOPER_OFF_ENUM.name = "EEQUIPOPER_OFF"
EEQUIPOPER_EEQUIPOPER_OFF_ENUM.index = 2
EEQUIPOPER_EEQUIPOPER_OFF_ENUM.number = 2
EEQUIPOPER_EEQUIPOPER_PUTFASHION_ENUM.name = "EEQUIPOPER_PUTFASHION"
EEQUIPOPER_EEQUIPOPER_PUTFASHION_ENUM.index = 3
EEQUIPOPER_EEQUIPOPER_PUTFASHION_ENUM.number = 3
EEQUIPOPER_EEQUIPOPER_OFFFASHION_ENUM.name = "EEQUIPOPER_OFFFASHION"
EEQUIPOPER_EEQUIPOPER_OFFFASHION_ENUM.index = 4
EEQUIPOPER_EEQUIPOPER_OFFFASHION_ENUM.number = 4
EEQUIPOPER_EEQUIPOPER_PUTSTORE_ENUM.name = "EEQUIPOPER_PUTSTORE"
EEQUIPOPER_EEQUIPOPER_PUTSTORE_ENUM.index = 5
EEQUIPOPER_EEQUIPOPER_PUTSTORE_ENUM.number = 5
EEQUIPOPER_EEQUIPOPER_OFFSTORE_ENUM.name = "EEQUIPOPER_OFFSTORE"
EEQUIPOPER_EEQUIPOPER_OFFSTORE_ENUM.index = 6
EEQUIPOPER_EEQUIPOPER_OFFSTORE_ENUM.number = 6
EEQUIPOPER_EEQUIPOPER_OFFALL_ENUM.name = "EEQUIPOPER_OFFALL"
EEQUIPOPER_EEQUIPOPER_OFFALL_ENUM.index = 7
EEQUIPOPER_EEQUIPOPER_OFFALL_ENUM.number = 7
EEQUIPOPER_EEQUIPOPER_OFFPOS_ENUM.name = "EEQUIPOPER_OFFPOS"
EEQUIPOPER_EEQUIPOPER_OFFPOS_ENUM.index = 8
EEQUIPOPER_EEQUIPOPER_OFFPOS_ENUM.number = 8
EEQUIPOPER_EEQUIPOPER_PUTPSTORE_ENUM.name = "EEQUIPOPER_PUTPSTORE"
EEQUIPOPER_EEQUIPOPER_PUTPSTORE_ENUM.index = 9
EEQUIPOPER_EEQUIPOPER_PUTPSTORE_ENUM.number = 9
EEQUIPOPER_EEQUIPOPER_OFFPSTORE_ENUM.name = "EEQUIPOPER_OFFPSTORE"
EEQUIPOPER_EEQUIPOPER_OFFPSTORE_ENUM.index = 10
EEQUIPOPER_EEQUIPOPER_OFFPSTORE_ENUM.number = 10
EEQUIPOPER_EEQUIPOPER_OFFTEMP_ENUM.name = "EEQUIPOPER_OFFTEMP"
EEQUIPOPER_EEQUIPOPER_OFFTEMP_ENUM.index = 11
EEQUIPOPER_EEQUIPOPER_OFFTEMP_ENUM.number = 11
EEQUIPOPER_EEQUIPOPER_PUTBARROW_ENUM.name = "EEQUIPOPER_PUTBARROW"
EEQUIPOPER_EEQUIPOPER_PUTBARROW_ENUM.index = 12
EEQUIPOPER_EEQUIPOPER_PUTBARROW_ENUM.number = 12
EEQUIPOPER_EEQUIPOPER_OFFBARROW_ENUM.name = "EEQUIPOPER_OFFBARROW"
EEQUIPOPER_EEQUIPOPER_OFFBARROW_ENUM.index = 13
EEQUIPOPER_EEQUIPOPER_OFFBARROW_ENUM.number = 13
EEQUIPOPER_EEQUIPOPER_DRESSUP_ON_ENUM.name = "EEQUIPOPER_DRESSUP_ON"
EEQUIPOPER_EEQUIPOPER_DRESSUP_ON_ENUM.index = 14
EEQUIPOPER_EEQUIPOPER_DRESSUP_ON_ENUM.number = 14
EEQUIPOPER_EEQUIPOPER_DRESSUP_OFF_ENUM.name = "EEQUIPOPER_DRESSUP_OFF"
EEQUIPOPER_EEQUIPOPER_DRESSUP_OFF_ENUM.index = 15
EEQUIPOPER_EEQUIPOPER_DRESSUP_OFF_ENUM.number = 15
EEQUIPOPER_EEQUIPOPER_MAX_ENUM.name = "EEQUIPOPER_MAX"
EEQUIPOPER_EEQUIPOPER_MAX_ENUM.index = 16
EEQUIPOPER_EEQUIPOPER_MAX_ENUM.number = 16
EEQUIPOPER.name = "EEquipOper"
EEQUIPOPER.full_name = ".Cmd.EEquipOper"
EEQUIPOPER.values = {
  EEQUIPOPER_EEQUIPOPER_MIN_ENUM,
  EEQUIPOPER_EEQUIPOPER_ON_ENUM,
  EEQUIPOPER_EEQUIPOPER_OFF_ENUM,
  EEQUIPOPER_EEQUIPOPER_PUTFASHION_ENUM,
  EEQUIPOPER_EEQUIPOPER_OFFFASHION_ENUM,
  EEQUIPOPER_EEQUIPOPER_PUTSTORE_ENUM,
  EEQUIPOPER_EEQUIPOPER_OFFSTORE_ENUM,
  EEQUIPOPER_EEQUIPOPER_OFFALL_ENUM,
  EEQUIPOPER_EEQUIPOPER_OFFPOS_ENUM,
  EEQUIPOPER_EEQUIPOPER_PUTPSTORE_ENUM,
  EEQUIPOPER_EEQUIPOPER_OFFPSTORE_ENUM,
  EEQUIPOPER_EEQUIPOPER_OFFTEMP_ENUM,
  EEQUIPOPER_EEQUIPOPER_PUTBARROW_ENUM,
  EEQUIPOPER_EEQUIPOPER_OFFBARROW_ENUM,
  EEQUIPOPER_EEQUIPOPER_DRESSUP_ON_ENUM,
  EEQUIPOPER_EEQUIPOPER_DRESSUP_OFF_ENUM,
  EEQUIPOPER_EEQUIPOPER_MAX_ENUM
}
EEQUIPPOS_EEQUIPPOS_MIN_ENUM.name = "EEQUIPPOS_MIN"
EEQUIPPOS_EEQUIPPOS_MIN_ENUM.index = 0
EEQUIPPOS_EEQUIPPOS_MIN_ENUM.number = 0
EEQUIPPOS_EEQUIPPOS_WEAPON_ENUM.name = "EEQUIPPOS_WEAPON"
EEQUIPPOS_EEQUIPPOS_WEAPON_ENUM.index = 1
EEQUIPPOS_EEQUIPPOS_WEAPON_ENUM.number = 7
EEQUIPPOS_EEQUIPPOS_ARMOUR_ENUM.name = "EEQUIPPOS_ARMOUR"
EEQUIPPOS_EEQUIPPOS_ARMOUR_ENUM.index = 2
EEQUIPPOS_EEQUIPPOS_ARMOUR_ENUM.number = 2
EEQUIPPOS_EEQUIPPOS_SHIELD_ENUM.name = "EEQUIPPOS_SHIELD"
EEQUIPPOS_EEQUIPPOS_SHIELD_ENUM.index = 3
EEQUIPPOS_EEQUIPPOS_SHIELD_ENUM.number = 1
EEQUIPPOS_EEQUIPPOS_ROBE_ENUM.name = "EEQUIPPOS_ROBE"
EEQUIPPOS_EEQUIPPOS_ROBE_ENUM.index = 4
EEQUIPPOS_EEQUIPPOS_ROBE_ENUM.number = 3
EEQUIPPOS_EEQUIPPOS_SHOES_ENUM.name = "EEQUIPPOS_SHOES"
EEQUIPPOS_EEQUIPPOS_SHOES_ENUM.index = 5
EEQUIPPOS_EEQUIPPOS_SHOES_ENUM.number = 4
EEQUIPPOS_EEQUIPPOS_ACCESSORY1_ENUM.name = "EEQUIPPOS_ACCESSORY1"
EEQUIPPOS_EEQUIPPOS_ACCESSORY1_ENUM.index = 6
EEQUIPPOS_EEQUIPPOS_ACCESSORY1_ENUM.number = 5
EEQUIPPOS_EEQUIPPOS_ACCESSORY2_ENUM.name = "EEQUIPPOS_ACCESSORY2"
EEQUIPPOS_EEQUIPPOS_ACCESSORY2_ENUM.index = 7
EEQUIPPOS_EEQUIPPOS_ACCESSORY2_ENUM.number = 6
EEQUIPPOS_EEQUIPPOS_HEAD_ENUM.name = "EEQUIPPOS_HEAD"
EEQUIPPOS_EEQUIPPOS_HEAD_ENUM.index = 8
EEQUIPPOS_EEQUIPPOS_HEAD_ENUM.number = 8
EEQUIPPOS_EEQUIPPOS_BACK_ENUM.name = "EEQUIPPOS_BACK"
EEQUIPPOS_EEQUIPPOS_BACK_ENUM.index = 9
EEQUIPPOS_EEQUIPPOS_BACK_ENUM.number = 11
EEQUIPPOS_EEQUIPPOS_FACE_ENUM.name = "EEQUIPPOS_FACE"
EEQUIPPOS_EEQUIPPOS_FACE_ENUM.index = 10
EEQUIPPOS_EEQUIPPOS_FACE_ENUM.number = 9
EEQUIPPOS_EEQUIPPOS_TAIL_ENUM.name = "EEQUIPPOS_TAIL"
EEQUIPPOS_EEQUIPPOS_TAIL_ENUM.index = 11
EEQUIPPOS_EEQUIPPOS_TAIL_ENUM.number = 12
EEQUIPPOS_EEQUIPPOS_MOUNT_ENUM.name = "EEQUIPPOS_MOUNT"
EEQUIPPOS_EEQUIPPOS_MOUNT_ENUM.index = 12
EEQUIPPOS_EEQUIPPOS_MOUNT_ENUM.number = 13
EEQUIPPOS_EEQUIPPOS_MOUTH_ENUM.name = "EEQUIPPOS_MOUTH"
EEQUIPPOS_EEQUIPPOS_MOUTH_ENUM.index = 13
EEQUIPPOS_EEQUIPPOS_MOUTH_ENUM.number = 10
EEQUIPPOS_EEQUIPPOS_BARROW_ENUM.name = "EEQUIPPOS_BARROW"
EEQUIPPOS_EEQUIPPOS_BARROW_ENUM.index = 14
EEQUIPPOS_EEQUIPPOS_BARROW_ENUM.number = 14
EEQUIPPOS_EEQUIPPOS_ARTIFACT_ENUM.name = "EEQUIPPOS_ARTIFACT"
EEQUIPPOS_EEQUIPPOS_ARTIFACT_ENUM.index = 15
EEQUIPPOS_EEQUIPPOS_ARTIFACT_ENUM.number = 15
EEQUIPPOS_EEQUIPPOS_ARTIFACT_HEAD_ENUM.name = "EEQUIPPOS_ARTIFACT_HEAD"
EEQUIPPOS_EEQUIPPOS_ARTIFACT_HEAD_ENUM.index = 16
EEQUIPPOS_EEQUIPPOS_ARTIFACT_HEAD_ENUM.number = 16
EEQUIPPOS_EEQUIPPOS_ARTIFACT_BACK_ENUM.name = "EEQUIPPOS_ARTIFACT_BACK"
EEQUIPPOS_EEQUIPPOS_ARTIFACT_BACK_ENUM.index = 17
EEQUIPPOS_EEQUIPPOS_ARTIFACT_BACK_ENUM.number = 17
EEQUIPPOS_EEQUIPPOS_MAX_ENUM.name = "EEQUIPPOS_MAX"
EEQUIPPOS_EEQUIPPOS_MAX_ENUM.index = 18
EEQUIPPOS_EEQUIPPOS_MAX_ENUM.number = 18
EEQUIPPOS.name = "EEquipPos"
EEQUIPPOS.full_name = ".Cmd.EEquipPos"
EEQUIPPOS.values = {
  EEQUIPPOS_EEQUIPPOS_MIN_ENUM,
  EEQUIPPOS_EEQUIPPOS_WEAPON_ENUM,
  EEQUIPPOS_EEQUIPPOS_ARMOUR_ENUM,
  EEQUIPPOS_EEQUIPPOS_SHIELD_ENUM,
  EEQUIPPOS_EEQUIPPOS_ROBE_ENUM,
  EEQUIPPOS_EEQUIPPOS_SHOES_ENUM,
  EEQUIPPOS_EEQUIPPOS_ACCESSORY1_ENUM,
  EEQUIPPOS_EEQUIPPOS_ACCESSORY2_ENUM,
  EEQUIPPOS_EEQUIPPOS_HEAD_ENUM,
  EEQUIPPOS_EEQUIPPOS_BACK_ENUM,
  EEQUIPPOS_EEQUIPPOS_FACE_ENUM,
  EEQUIPPOS_EEQUIPPOS_TAIL_ENUM,
  EEQUIPPOS_EEQUIPPOS_MOUNT_ENUM,
  EEQUIPPOS_EEQUIPPOS_MOUTH_ENUM,
  EEQUIPPOS_EEQUIPPOS_BARROW_ENUM,
  EEQUIPPOS_EEQUIPPOS_ARTIFACT_ENUM,
  EEQUIPPOS_EEQUIPPOS_ARTIFACT_HEAD_ENUM,
  EEQUIPPOS_EEQUIPPOS_ARTIFACT_BACK_ENUM,
  EEQUIPPOS_EEQUIPPOS_MAX_ENUM
}
ESTRENGTHRESULT_ESTRENGTHRESULT_MIN_ENUM.name = "ESTRENGTHRESULT_MIN"
ESTRENGTHRESULT_ESTRENGTHRESULT_MIN_ENUM.index = 0
ESTRENGTHRESULT_ESTRENGTHRESULT_MIN_ENUM.number = 0
ESTRENGTHRESULT_ESTRENGTHRESULT_SUCCESS_ENUM.name = "ESTRENGTHRESULT_SUCCESS"
ESTRENGTHRESULT_ESTRENGTHRESULT_SUCCESS_ENUM.index = 1
ESTRENGTHRESULT_ESTRENGTHRESULT_SUCCESS_ENUM.number = 1
ESTRENGTHRESULT_ESTRENGTHRESULT_NOMATERIAL_ENUM.name = "ESTRENGTHRESULT_NOMATERIAL"
ESTRENGTHRESULT_ESTRENGTHRESULT_NOMATERIAL_ENUM.index = 2
ESTRENGTHRESULT_ESTRENGTHRESULT_NOMATERIAL_ENUM.number = 2
ESTRENGTHRESULT_ESTRENGTHRESULT_MAXLV_ENUM.name = "ESTRENGTHRESULT_MAXLV"
ESTRENGTHRESULT_ESTRENGTHRESULT_MAXLV_ENUM.index = 3
ESTRENGTHRESULT_ESTRENGTHRESULT_MAXLV_ENUM.number = 3
ESTRENGTHRESULT.name = "EStrengthResult"
ESTRENGTHRESULT.full_name = ".Cmd.EStrengthResult"
ESTRENGTHRESULT.values = {
  ESTRENGTHRESULT_ESTRENGTHRESULT_MIN_ENUM,
  ESTRENGTHRESULT_ESTRENGTHRESULT_SUCCESS_ENUM,
  ESTRENGTHRESULT_ESTRENGTHRESULT_NOMATERIAL_ENUM,
  ESTRENGTHRESULT_ESTRENGTHRESULT_MAXLV_ENUM
}
ESTRENGTHTYPE_ESTRENGTHTYPE_MIN_ENUM.name = "ESTRENGTHTYPE_MIN"
ESTRENGTHTYPE_ESTRENGTHTYPE_MIN_ENUM.index = 0
ESTRENGTHTYPE_ESTRENGTHTYPE_MIN_ENUM.number = 0
ESTRENGTHTYPE_ESTRENGTHTYPE_NORMAL_ENUM.name = "ESTRENGTHTYPE_NORMAL"
ESTRENGTHTYPE_ESTRENGTHTYPE_NORMAL_ENUM.index = 1
ESTRENGTHTYPE_ESTRENGTHTYPE_NORMAL_ENUM.number = 1
ESTRENGTHTYPE_ESTRENGTHTYPE_GUILD_ENUM.name = "ESTRENGTHTYPE_GUILD"
ESTRENGTHTYPE_ESTRENGTHTYPE_GUILD_ENUM.index = 2
ESTRENGTHTYPE_ESTRENGTHTYPE_GUILD_ENUM.number = 2
ESTRENGTHTYPE_ESTRENGTHTYPE_MAX_ENUM.name = "ESTRENGTHTYPE_MAX"
ESTRENGTHTYPE_ESTRENGTHTYPE_MAX_ENUM.index = 3
ESTRENGTHTYPE_ESTRENGTHTYPE_MAX_ENUM.number = 3
ESTRENGTHTYPE.name = "EStrengthType"
ESTRENGTHTYPE.full_name = ".Cmd.EStrengthType"
ESTRENGTHTYPE.values = {
  ESTRENGTHTYPE_ESTRENGTHTYPE_MIN_ENUM,
  ESTRENGTHTYPE_ESTRENGTHTYPE_NORMAL_ENUM,
  ESTRENGTHTYPE_ESTRENGTHTYPE_GUILD_ENUM,
  ESTRENGTHTYPE_ESTRENGTHTYPE_MAX_ENUM
}
EPRODUCETYPE_EPRODUCETYPE_MIN_ENUM.name = "EPRODUCETYPE_MIN"
EPRODUCETYPE_EPRODUCETYPE_MIN_ENUM.index = 0
EPRODUCETYPE_EPRODUCETYPE_MIN_ENUM.number = 1
EPRODUCETYPE_EPRODUCETYPE_HEAD_ENUM.name = "EPRODUCETYPE_HEAD"
EPRODUCETYPE_EPRODUCETYPE_HEAD_ENUM.index = 1
EPRODUCETYPE_EPRODUCETYPE_HEAD_ENUM.number = 2
EPRODUCETYPE_EPRODUCETYPE_EQUIP_ENUM.name = "EPRODUCETYPE_EQUIP"
EPRODUCETYPE_EPRODUCETYPE_EQUIP_ENUM.index = 2
EPRODUCETYPE_EPRODUCETYPE_EQUIP_ENUM.number = 3
EPRODUCETYPE_EPRODUCETYPE_TRADER_ENUM.name = "EPRODUCETYPE_TRADER"
EPRODUCETYPE_EPRODUCETYPE_TRADER_ENUM.index = 3
EPRODUCETYPE_EPRODUCETYPE_TRADER_ENUM.number = 4
EPRODUCETYPE_EPRODUCETYPE_MAX_ENUM.name = "EPRODUCETYPE_MAX"
EPRODUCETYPE_EPRODUCETYPE_MAX_ENUM.index = 4
EPRODUCETYPE_EPRODUCETYPE_MAX_ENUM.number = 5
EPRODUCETYPE.name = "EProduceType"
EPRODUCETYPE.full_name = ".Cmd.EProduceType"
EPRODUCETYPE.values = {
  EPRODUCETYPE_EPRODUCETYPE_MIN_ENUM,
  EPRODUCETYPE_EPRODUCETYPE_HEAD_ENUM,
  EPRODUCETYPE_EPRODUCETYPE_EQUIP_ENUM,
  EPRODUCETYPE_EPRODUCETYPE_TRADER_ENUM,
  EPRODUCETYPE_EPRODUCETYPE_MAX_ENUM
}
EREFINERESULT_EREFINERESULT_MIN_ENUM.name = "EREFINERESULT_MIN"
EREFINERESULT_EREFINERESULT_MIN_ENUM.index = 0
EREFINERESULT_EREFINERESULT_MIN_ENUM.number = 0
EREFINERESULT_EREFINERESULT_SUCCESS_ENUM.name = "EREFINERESULT_SUCCESS"
EREFINERESULT_EREFINERESULT_SUCCESS_ENUM.index = 1
EREFINERESULT_EREFINERESULT_SUCCESS_ENUM.number = 1
EREFINERESULT_EREFINERESULT_FAILSTAY_ENUM.name = "EREFINERESULT_FAILSTAY"
EREFINERESULT_EREFINERESULT_FAILSTAY_ENUM.index = 2
EREFINERESULT_EREFINERESULT_FAILSTAY_ENUM.number = 2
EREFINERESULT_EREFINERESULT_FAILBACK_ENUM.name = "EREFINERESULT_FAILBACK"
EREFINERESULT_EREFINERESULT_FAILBACK_ENUM.index = 3
EREFINERESULT_EREFINERESULT_FAILBACK_ENUM.number = 3
EREFINERESULT_EREFINERESULT_FAILSTAYDAM_ENUM.name = "EREFINERESULT_FAILSTAYDAM"
EREFINERESULT_EREFINERESULT_FAILSTAYDAM_ENUM.index = 4
EREFINERESULT_EREFINERESULT_FAILSTAYDAM_ENUM.number = 4
EREFINERESULT_EREFINERESULT_FAILBACKDAM_ENUM.name = "EREFINERESULT_FAILBACKDAM"
EREFINERESULT_EREFINERESULT_FAILBACKDAM_ENUM.index = 5
EREFINERESULT_EREFINERESULT_FAILBACKDAM_ENUM.number = 5
EREFINERESULT_EREFINERESULT_MAX_ENUM.name = "EREFINERESULT_MAX"
EREFINERESULT_EREFINERESULT_MAX_ENUM.index = 6
EREFINERESULT_EREFINERESULT_MAX_ENUM.number = 6
EREFINERESULT.name = "ERefineResult"
EREFINERESULT.full_name = ".Cmd.ERefineResult"
EREFINERESULT.values = {
  EREFINERESULT_EREFINERESULT_MIN_ENUM,
  EREFINERESULT_EREFINERESULT_SUCCESS_ENUM,
  EREFINERESULT_EREFINERESULT_FAILSTAY_ENUM,
  EREFINERESULT_EREFINERESULT_FAILBACK_ENUM,
  EREFINERESULT_EREFINERESULT_FAILSTAYDAM_ENUM,
  EREFINERESULT_EREFINERESULT_FAILBACKDAM_ENUM,
  EREFINERESULT_EREFINERESULT_MAX_ENUM
}
EDECOMPOSERESULT_EDECOMPOSERESULT_MIN_ENUM.name = "EDECOMPOSERESULT_MIN"
EDECOMPOSERESULT_EDECOMPOSERESULT_MIN_ENUM.index = 0
EDECOMPOSERESULT_EDECOMPOSERESULT_MIN_ENUM.number = 0
EDECOMPOSERESULT_EDECOMPOSERESULT_FAIL_ENUM.name = "EDECOMPOSERESULT_FAIL"
EDECOMPOSERESULT_EDECOMPOSERESULT_FAIL_ENUM.index = 1
EDECOMPOSERESULT_EDECOMPOSERESULT_FAIL_ENUM.number = 1
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_ENUM.name = "EDECOMPOSERESULT_SUCCESS"
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_ENUM.index = 2
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_ENUM.number = 2
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_BIG_ENUM.name = "EDECOMPOSERESULT_SUCCESS_BIG"
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_BIG_ENUM.index = 3
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_BIG_ENUM.number = 3
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_SBIG_ENUM.name = "EDECOMPOSERESULT_SUCCESS_SBIG"
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_SBIG_ENUM.index = 4
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_SBIG_ENUM.number = 4
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_FANTASY_ENUM.name = "EDECOMPOSERESULT_SUCCESS_FANTASY"
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_FANTASY_ENUM.index = 5
EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_FANTASY_ENUM.number = 5
EDECOMPOSERESULT_EDECOMPOSERESULT_MAX_ENUM.name = "EDECOMPOSERESULT_MAX"
EDECOMPOSERESULT_EDECOMPOSERESULT_MAX_ENUM.index = 6
EDECOMPOSERESULT_EDECOMPOSERESULT_MAX_ENUM.number = 6
EDECOMPOSERESULT.name = "EDecomposeResult"
EDECOMPOSERESULT.full_name = ".Cmd.EDecomposeResult"
EDECOMPOSERESULT.values = {
  EDECOMPOSERESULT_EDECOMPOSERESULT_MIN_ENUM,
  EDECOMPOSERESULT_EDECOMPOSERESULT_FAIL_ENUM,
  EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_ENUM,
  EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_BIG_ENUM,
  EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_SBIG_ENUM,
  EDECOMPOSERESULT_EDECOMPOSERESULT_SUCCESS_FANTASY_ENUM,
  EDECOMPOSERESULT_EDECOMPOSERESULT_MAX_ENUM
}
ECARDOPER_ECARDOPER_MIN_ENUM.name = "ECARDOPER_MIN"
ECARDOPER_ECARDOPER_MIN_ENUM.index = 0
ECARDOPER_ECARDOPER_MIN_ENUM.number = 0
ECARDOPER_ECARDOPER_EQUIPON_ENUM.name = "ECARDOPER_EQUIPON"
ECARDOPER_ECARDOPER_EQUIPON_ENUM.index = 1
ECARDOPER_ECARDOPER_EQUIPON_ENUM.number = 1
ECARDOPER_ECARDOPER_EQUIPOFF_ENUM.name = "ECARDOPER_EQUIPOFF"
ECARDOPER_ECARDOPER_EQUIPOFF_ENUM.index = 2
ECARDOPER_ECARDOPER_EQUIPOFF_ENUM.number = 2
ECARDOPER_ECARDOPER_MAX_ENUM.name = "ECARDOPER_MAX"
ECARDOPER_ECARDOPER_MAX_ENUM.index = 3
ECARDOPER_ECARDOPER_MAX_ENUM.number = 3
ECARDOPER.name = "ECardOper"
ECARDOPER.full_name = ".Cmd.ECardOper"
ECARDOPER.values = {
  ECARDOPER_ECARDOPER_MIN_ENUM,
  ECARDOPER_ECARDOPER_EQUIPON_ENUM,
  ECARDOPER_ECARDOPER_EQUIPOFF_ENUM,
  ECARDOPER_ECARDOPER_MAX_ENUM
}
ETRADETYPE_ETRADETYPE_ALL_ENUM.name = "ETRADETYPE_ALL"
ETRADETYPE_ETRADETYPE_ALL_ENUM.index = 0
ETRADETYPE_ETRADETYPE_ALL_ENUM.number = 0
ETRADETYPE_ETRADETYPE_TRADE_ENUM.name = "ETRADETYPE_TRADE"
ETRADETYPE_ETRADETYPE_TRADE_ENUM.index = 1
ETRADETYPE_ETRADETYPE_TRADE_ENUM.number = 1
ETRADETYPE_ETRADETYPE_BOOTH_ENUM.name = "ETRADETYPE_BOOTH"
ETRADETYPE_ETRADETYPE_BOOTH_ENUM.index = 2
ETRADETYPE_ETRADETYPE_BOOTH_ENUM.number = 2
ETRADETYPE.name = "ETradeType"
ETRADETYPE.full_name = ".Cmd.ETradeType"
ETRADETYPE.values = {
  ETRADETYPE_ETRADETYPE_ALL_ENUM,
  ETRADETYPE_ETRADETYPE_TRADE_ENUM,
  ETRADETYPE_ETRADETYPE_BOOTH_ENUM
}
EEXCHANGETYPE_EEXCHANGETYPE_MIN_ENUM.name = "EEXCHANGETYPE_MIN"
EEXCHANGETYPE_EEXCHANGETYPE_MIN_ENUM.index = 0
EEXCHANGETYPE_EEXCHANGETYPE_MIN_ENUM.number = 0
EEXCHANGETYPE_EEXCHANGETYPE_EXCHANGE_ENUM.name = "EEXCHANGETYPE_EXCHANGE"
EEXCHANGETYPE_EEXCHANGETYPE_EXCHANGE_ENUM.index = 1
EEXCHANGETYPE_EEXCHANGETYPE_EXCHANGE_ENUM.number = 1
EEXCHANGETYPE_EEXCHANGETYPE_LEVELUP_ENUM.name = "EEXCHANGETYPE_LEVELUP"
EEXCHANGETYPE_EEXCHANGETYPE_LEVELUP_ENUM.index = 2
EEXCHANGETYPE_EEXCHANGETYPE_LEVELUP_ENUM.number = 2
EEXCHANGETYPE_EEXCHANGETYPE_MAX_ENUM.name = "EEXCHANGETYPE_MAX"
EEXCHANGETYPE_EEXCHANGETYPE_MAX_ENUM.index = 3
EEXCHANGETYPE_EEXCHANGETYPE_MAX_ENUM.number = 3
EEXCHANGETYPE.name = "EExchangeType"
EEXCHANGETYPE.full_name = ".Cmd.EExchangeType"
EEXCHANGETYPE.values = {
  EEXCHANGETYPE_EEXCHANGETYPE_MIN_ENUM,
  EEXCHANGETYPE_EEXCHANGETYPE_EXCHANGE_ENUM,
  EEXCHANGETYPE_EEXCHANGETYPE_LEVELUP_ENUM,
  EEXCHANGETYPE_EEXCHANGETYPE_MAX_ENUM
}
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DRAW_ENUM.name = "EEXCHANGECARDTYPE_DRAW"
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DRAW_ENUM.index = 0
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DRAW_ENUM.number = 1
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_COMPOSE_ENUM.name = "EEXCHANGECARDTYPE_COMPOSE"
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_COMPOSE_ENUM.index = 1
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_COMPOSE_ENUM.number = 2
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DECOMPOSE_ENUM.name = "EEXCHANGECARDTYPE_DECOMPOSE"
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DECOMPOSE_ENUM.index = 2
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DECOMPOSE_ENUM.number = 3
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_BOSSCOMPOSE_ENUM.name = "EEXCHANGECARDTYPE_BOSSCOMPOSE"
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_BOSSCOMPOSE_ENUM.index = 3
EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_BOSSCOMPOSE_ENUM.number = 4
EEXCHANGECARDTYPE.name = "EExchangeCardType"
EEXCHANGECARDTYPE.full_name = ".Cmd.EExchangeCardType"
EEXCHANGECARDTYPE.values = {
  EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DRAW_ENUM,
  EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_COMPOSE_ENUM,
  EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_DECOMPOSE_ENUM,
  EEXCHANGECARDTYPE_EEXCHANGECARDTYPE_BOSSCOMPOSE_ENUM
}
ELOTTERYTYPE_ELOTTERYTYPE_MIN_ENUM.name = "ELotteryType_Min"
ELOTTERYTYPE_ELOTTERYTYPE_MIN_ENUM.index = 0
ELOTTERYTYPE_ELOTTERYTYPE_MIN_ENUM.number = 0
ELOTTERYTYPE_ELOTTERYTYPE_HEAD_ENUM.name = "ELotteryType_Head"
ELOTTERYTYPE_ELOTTERYTYPE_HEAD_ENUM.index = 1
ELOTTERYTYPE_ELOTTERYTYPE_HEAD_ENUM.number = 1
ELOTTERYTYPE_ELOTTERYTYPE_EQUIP_ENUM.name = "ELotteryType_Equip"
ELOTTERYTYPE_ELOTTERYTYPE_EQUIP_ENUM.index = 2
ELOTTERYTYPE_ELOTTERYTYPE_EQUIP_ENUM.number = 2
ELOTTERYTYPE_ELOTTERYTYPE_CARD_ENUM.name = "ELotteryType_Card"
ELOTTERYTYPE_ELOTTERYTYPE_CARD_ENUM.index = 3
ELOTTERYTYPE_ELOTTERYTYPE_CARD_ENUM.number = 3
ELOTTERYTYPE_ELOTTERYTYPE_CATLITTERBOX_ENUM.name = "ELotteryType_CatLitterBox"
ELOTTERYTYPE_ELOTTERYTYPE_CATLITTERBOX_ENUM.index = 4
ELOTTERYTYPE_ELOTTERYTYPE_CATLITTERBOX_ENUM.number = 4
ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_ENUM.name = "ELotteryType_Magic"
ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_ENUM.index = 5
ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_ENUM.number = 5
ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_2_ENUM.name = "ELotteryType_Magic_2"
ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_2_ENUM.index = 6
ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_2_ENUM.number = 6
ELOTTERYTYPE_ELOTTERYTYPE_MAX_ENUM.name = "ELotteryType_Max"
ELOTTERYTYPE_ELOTTERYTYPE_MAX_ENUM.index = 7
ELOTTERYTYPE_ELOTTERYTYPE_MAX_ENUM.number = 7
ELOTTERYTYPE.name = "ELotteryType"
ELOTTERYTYPE.full_name = ".Cmd.ELotteryType"
ELOTTERYTYPE.values = {
  ELOTTERYTYPE_ELOTTERYTYPE_MIN_ENUM,
  ELOTTERYTYPE_ELOTTERYTYPE_HEAD_ENUM,
  ELOTTERYTYPE_ELOTTERYTYPE_EQUIP_ENUM,
  ELOTTERYTYPE_ELOTTERYTYPE_CARD_ENUM,
  ELOTTERYTYPE_ELOTTERYTYPE_CATLITTERBOX_ENUM,
  ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_ENUM,
  ELOTTERYTYPE_ELOTTERYTYPE_MAGIC_2_ENUM,
  ELOTTERYTYPE_ELOTTERYTYPE_MAX_ENUM
}
EQUOTATYPE_EQUOTATYPE_G_CHARGE_ENUM.name = "EQuotaType_G_Charge"
EQUOTATYPE_EQUOTATYPE_G_CHARGE_ENUM.index = 0
EQUOTATYPE_EQUOTATYPE_G_CHARGE_ENUM.number = 1
EQUOTATYPE_EQUOTATYPE_C_GIVE_ENUM.name = "EQuotaType_C_Give"
EQUOTATYPE_EQUOTATYPE_C_GIVE_ENUM.index = 1
EQUOTATYPE_EQUOTATYPE_C_GIVE_ENUM.number = 2
EQUOTATYPE_EQUOTATYPE_C_AUCTION_ENUM.name = "EQuotaType_C_Auction"
EQUOTATYPE_EQUOTATYPE_C_AUCTION_ENUM.index = 2
EQUOTATYPE_EQUOTATYPE_C_AUCTION_ENUM.number = 3
EQUOTATYPE_EQUOTATYPE_G_AUCTION_ENUM.name = "EQuotaType_G_Auction"
EQUOTATYPE_EQUOTATYPE_G_AUCTION_ENUM.index = 3
EQUOTATYPE_EQUOTATYPE_G_AUCTION_ENUM.number = 4
EQUOTATYPE_EQUOTATYPE_C_LOTTERY_ENUM.name = "EQuotaType_C_Lottery"
EQUOTATYPE_EQUOTATYPE_C_LOTTERY_ENUM.index = 4
EQUOTATYPE_EQUOTATYPE_C_LOTTERY_ENUM.number = 5
EQUOTATYPE_EQUOTATYPE_C_GUILDBOX_ENUM.name = "EQuotaType_C_GuildBox"
EQUOTATYPE_EQUOTATYPE_C_GUILDBOX_ENUM.index = 5
EQUOTATYPE_EQUOTATYPE_C_GUILDBOX_ENUM.number = 6
EQUOTATYPE_EQUOTATYPE_C_WEDDINGDRESS_ENUM.name = "EQuotaType_C_WeddingDress"
EQUOTATYPE_EQUOTATYPE_C_WEDDINGDRESS_ENUM.index = 6
EQUOTATYPE_EQUOTATYPE_C_WEDDINGDRESS_ENUM.number = 7
EQUOTATYPE_EQUOTATYPE_L_BOOTH_ENUM.name = "EQuotaType_L_Booth"
EQUOTATYPE_EQUOTATYPE_L_BOOTH_ENUM.index = 7
EQUOTATYPE_EQUOTATYPE_L_BOOTH_ENUM.number = 8
EQUOTATYPE_EQUOTATYPE_U_BOOTH_ENUM.name = "EQuotaType_U_Booth"
EQUOTATYPE_EQUOTATYPE_U_BOOTH_ENUM.index = 8
EQUOTATYPE_EQUOTATYPE_U_BOOTH_ENUM.number = 9
EQUOTATYPE_EQUOTATYPE_C_BOOTH_ENUM.name = "EQuotaType_C_Booth"
EQUOTATYPE_EQUOTATYPE_C_BOOTH_ENUM.index = 9
EQUOTATYPE_EQUOTATYPE_C_BOOTH_ENUM.number = 10
EQUOTATYPE_EQUOTATYPE_L_GIVE_TRADE_ENUM.name = "EQuotaType_L_Give_Trade"
EQUOTATYPE_EQUOTATYPE_L_GIVE_TRADE_ENUM.index = 10
EQUOTATYPE_EQUOTATYPE_L_GIVE_TRADE_ENUM.number = 11
EQUOTATYPE_EQUOTATYPE_U_GIVE_TRADE_ENUM.name = "EQuotaType_U_Give_Trade"
EQUOTATYPE_EQUOTATYPE_U_GIVE_TRADE_ENUM.index = 11
EQUOTATYPE_EQUOTATYPE_U_GIVE_TRADE_ENUM.number = 12
EQUOTATYPE_EQUOTATYPE_C_GIVE_TRADE_ENUM.name = "EQuotaType_C_Give_Trade"
EQUOTATYPE_EQUOTATYPE_C_GIVE_TRADE_ENUM.index = 12
EQUOTATYPE_EQUOTATYPE_C_GIVE_TRADE_ENUM.number = 13
EQUOTATYPE_EQUOTATYPE_G_REWARD_ENUM.name = "EQuotaType_G_Reward"
EQUOTATYPE_EQUOTATYPE_G_REWARD_ENUM.index = 13
EQUOTATYPE_EQUOTATYPE_G_REWARD_ENUM.number = 14
EQUOTATYPE_EQUOTATYPE_C_GUILDMATERIAL_ENUM.name = "EQuotaType_C_GuildMaterial"
EQUOTATYPE_EQUOTATYPE_C_GUILDMATERIAL_ENUM.index = 14
EQUOTATYPE_EQUOTATYPE_C_GUILDMATERIAL_ENUM.number = 15
EQUOTATYPE_EQUOTATYPE_L_CHARGE_ENUM.name = "EQuotaType_L_Charge"
EQUOTATYPE_EQUOTATYPE_L_CHARGE_ENUM.index = 15
EQUOTATYPE_EQUOTATYPE_L_CHARGE_ENUM.number = 20
EQUOTATYPE_EQUOTATYPE_U_CHARGE_ENUM.name = "EQuotaType_U_Charge"
EQUOTATYPE_EQUOTATYPE_U_CHARGE_ENUM.index = 16
EQUOTATYPE_EQUOTATYPE_U_CHARGE_ENUM.number = 21
EQUOTATYPE.name = "EQuotaType"
EQUOTATYPE.full_name = ".Cmd.EQuotaType"
EQUOTATYPE.values = {
  EQUOTATYPE_EQUOTATYPE_G_CHARGE_ENUM,
  EQUOTATYPE_EQUOTATYPE_C_GIVE_ENUM,
  EQUOTATYPE_EQUOTATYPE_C_AUCTION_ENUM,
  EQUOTATYPE_EQUOTATYPE_G_AUCTION_ENUM,
  EQUOTATYPE_EQUOTATYPE_C_LOTTERY_ENUM,
  EQUOTATYPE_EQUOTATYPE_C_GUILDBOX_ENUM,
  EQUOTATYPE_EQUOTATYPE_C_WEDDINGDRESS_ENUM,
  EQUOTATYPE_EQUOTATYPE_L_BOOTH_ENUM,
  EQUOTATYPE_EQUOTATYPE_U_BOOTH_ENUM,
  EQUOTATYPE_EQUOTATYPE_C_BOOTH_ENUM,
  EQUOTATYPE_EQUOTATYPE_L_GIVE_TRADE_ENUM,
  EQUOTATYPE_EQUOTATYPE_U_GIVE_TRADE_ENUM,
  EQUOTATYPE_EQUOTATYPE_C_GIVE_TRADE_ENUM,
  EQUOTATYPE_EQUOTATYPE_G_REWARD_ENUM,
  EQUOTATYPE_EQUOTATYPE_C_GUILDMATERIAL_ENUM,
  EQUOTATYPE_EQUOTATYPE_L_CHARGE_ENUM,
  EQUOTATYPE_EQUOTATYPE_U_CHARGE_ENUM
}
EFAVORITEACTION_EFAVORITEACTION_MIN_ENUM.name = "EFAVORITEACTION_MIN"
EFAVORITEACTION_EFAVORITEACTION_MIN_ENUM.index = 0
EFAVORITEACTION_EFAVORITEACTION_MIN_ENUM.number = 0
EFAVORITEACTION_EFAVORITEACTION_ADD_ENUM.name = "EFAVORITEACTION_ADD"
EFAVORITEACTION_EFAVORITEACTION_ADD_ENUM.index = 1
EFAVORITEACTION_EFAVORITEACTION_ADD_ENUM.number = 1
EFAVORITEACTION_EFAVORITEACTION_DEL_ENUM.name = "EFAVORITEACTION_DEL"
EFAVORITEACTION_EFAVORITEACTION_DEL_ENUM.index = 2
EFAVORITEACTION_EFAVORITEACTION_DEL_ENUM.number = 2
EFAVORITEACTION_EFAVORITEACTION_MAX_ENUM.name = "EFAVORITEACTION_MAX"
EFAVORITEACTION_EFAVORITEACTION_MAX_ENUM.index = 3
EFAVORITEACTION_EFAVORITEACTION_MAX_ENUM.number = 3
EFAVORITEACTION.name = "EFavoriteAction"
EFAVORITEACTION.full_name = ".Cmd.EFavoriteAction"
EFAVORITEACTION.values = {
  EFAVORITEACTION_EFAVORITEACTION_MIN_ENUM,
  EFAVORITEACTION_EFAVORITEACTION_ADD_ENUM,
  EFAVORITEACTION_EFAVORITEACTION_DEL_ENUM,
  EFAVORITEACTION_EFAVORITEACTION_MAX_ENUM
}
ITEMINFO_GUID_FIELD.name = "guid"
ITEMINFO_GUID_FIELD.full_name = ".Cmd.ItemInfo.guid"
ITEMINFO_GUID_FIELD.number = 1
ITEMINFO_GUID_FIELD.index = 0
ITEMINFO_GUID_FIELD.label = 1
ITEMINFO_GUID_FIELD.has_default_value = false
ITEMINFO_GUID_FIELD.default_value = ""
ITEMINFO_GUID_FIELD.type = 9
ITEMINFO_GUID_FIELD.cpp_type = 9
ITEMINFO_ID_FIELD.name = "id"
ITEMINFO_ID_FIELD.full_name = ".Cmd.ItemInfo.id"
ITEMINFO_ID_FIELD.number = 2
ITEMINFO_ID_FIELD.index = 1
ITEMINFO_ID_FIELD.label = 1
ITEMINFO_ID_FIELD.has_default_value = true
ITEMINFO_ID_FIELD.default_value = 0
ITEMINFO_ID_FIELD.type = 13
ITEMINFO_ID_FIELD.cpp_type = 3
ITEMINFO_COUNT_FIELD.name = "count"
ITEMINFO_COUNT_FIELD.full_name = ".Cmd.ItemInfo.count"
ITEMINFO_COUNT_FIELD.number = 3
ITEMINFO_COUNT_FIELD.index = 2
ITEMINFO_COUNT_FIELD.label = 1
ITEMINFO_COUNT_FIELD.has_default_value = true
ITEMINFO_COUNT_FIELD.default_value = 1
ITEMINFO_COUNT_FIELD.type = 13
ITEMINFO_COUNT_FIELD.cpp_type = 3
ITEMINFO_INDEX_FIELD.name = "index"
ITEMINFO_INDEX_FIELD.full_name = ".Cmd.ItemInfo.index"
ITEMINFO_INDEX_FIELD.number = 4
ITEMINFO_INDEX_FIELD.index = 3
ITEMINFO_INDEX_FIELD.label = 1
ITEMINFO_INDEX_FIELD.has_default_value = true
ITEMINFO_INDEX_FIELD.default_value = 0
ITEMINFO_INDEX_FIELD.type = 13
ITEMINFO_INDEX_FIELD.cpp_type = 3
ITEMINFO_CREATETIME_FIELD.name = "createtime"
ITEMINFO_CREATETIME_FIELD.full_name = ".Cmd.ItemInfo.createtime"
ITEMINFO_CREATETIME_FIELD.number = 5
ITEMINFO_CREATETIME_FIELD.index = 4
ITEMINFO_CREATETIME_FIELD.label = 1
ITEMINFO_CREATETIME_FIELD.has_default_value = true
ITEMINFO_CREATETIME_FIELD.default_value = 0
ITEMINFO_CREATETIME_FIELD.type = 13
ITEMINFO_CREATETIME_FIELD.cpp_type = 3
ITEMINFO_CD_FIELD.name = "cd"
ITEMINFO_CD_FIELD.full_name = ".Cmd.ItemInfo.cd"
ITEMINFO_CD_FIELD.number = 6
ITEMINFO_CD_FIELD.index = 5
ITEMINFO_CD_FIELD.label = 1
ITEMINFO_CD_FIELD.has_default_value = true
ITEMINFO_CD_FIELD.default_value = 0
ITEMINFO_CD_FIELD.type = 4
ITEMINFO_CD_FIELD.cpp_type = 4
ITEMINFO_TYPE_FIELD.name = "type"
ITEMINFO_TYPE_FIELD.full_name = ".Cmd.ItemInfo.type"
ITEMINFO_TYPE_FIELD.number = 7
ITEMINFO_TYPE_FIELD.index = 6
ITEMINFO_TYPE_FIELD.label = 1
ITEMINFO_TYPE_FIELD.has_default_value = true
ITEMINFO_TYPE_FIELD.default_value = 0
ITEMINFO_TYPE_FIELD.enum_type = EITEMTYPE
ITEMINFO_TYPE_FIELD.type = 14
ITEMINFO_TYPE_FIELD.cpp_type = 8
ITEMINFO_BIND_FIELD.name = "bind"
ITEMINFO_BIND_FIELD.full_name = ".Cmd.ItemInfo.bind"
ITEMINFO_BIND_FIELD.number = 8
ITEMINFO_BIND_FIELD.index = 7
ITEMINFO_BIND_FIELD.label = 1
ITEMINFO_BIND_FIELD.has_default_value = true
ITEMINFO_BIND_FIELD.default_value = 0
ITEMINFO_BIND_FIELD.enum_type = EBINDTYPE
ITEMINFO_BIND_FIELD.type = 14
ITEMINFO_BIND_FIELD.cpp_type = 8
ITEMINFO_EXPIRE_FIELD.name = "expire"
ITEMINFO_EXPIRE_FIELD.full_name = ".Cmd.ItemInfo.expire"
ITEMINFO_EXPIRE_FIELD.number = 9
ITEMINFO_EXPIRE_FIELD.index = 8
ITEMINFO_EXPIRE_FIELD.label = 1
ITEMINFO_EXPIRE_FIELD.has_default_value = true
ITEMINFO_EXPIRE_FIELD.default_value = 0
ITEMINFO_EXPIRE_FIELD.enum_type = EEXPIRETYPE
ITEMINFO_EXPIRE_FIELD.type = 14
ITEMINFO_EXPIRE_FIELD.cpp_type = 8
ITEMINFO_QUALITY_FIELD.name = "quality"
ITEMINFO_QUALITY_FIELD.full_name = ".Cmd.ItemInfo.quality"
ITEMINFO_QUALITY_FIELD.number = 10
ITEMINFO_QUALITY_FIELD.index = 9
ITEMINFO_QUALITY_FIELD.label = 1
ITEMINFO_QUALITY_FIELD.has_default_value = true
ITEMINFO_QUALITY_FIELD.default_value = 0
ITEMINFO_QUALITY_FIELD.enum_type = PROTOCOMMON_PB_EQUALITYTYPE
ITEMINFO_QUALITY_FIELD.type = 14
ITEMINFO_QUALITY_FIELD.cpp_type = 8
ITEMINFO_EQUIPTYPE_FIELD.name = "equipType"
ITEMINFO_EQUIPTYPE_FIELD.full_name = ".Cmd.ItemInfo.equipType"
ITEMINFO_EQUIPTYPE_FIELD.number = 11
ITEMINFO_EQUIPTYPE_FIELD.index = 10
ITEMINFO_EQUIPTYPE_FIELD.label = 1
ITEMINFO_EQUIPTYPE_FIELD.has_default_value = true
ITEMINFO_EQUIPTYPE_FIELD.default_value = 0
ITEMINFO_EQUIPTYPE_FIELD.enum_type = EEQUIPTYPE
ITEMINFO_EQUIPTYPE_FIELD.type = 14
ITEMINFO_EQUIPTYPE_FIELD.cpp_type = 8
ITEMINFO_SOURCE_FIELD.name = "source"
ITEMINFO_SOURCE_FIELD.full_name = ".Cmd.ItemInfo.source"
ITEMINFO_SOURCE_FIELD.number = 12
ITEMINFO_SOURCE_FIELD.index = 11
ITEMINFO_SOURCE_FIELD.label = 1
ITEMINFO_SOURCE_FIELD.has_default_value = true
ITEMINFO_SOURCE_FIELD.default_value = 1
ITEMINFO_SOURCE_FIELD.enum_type = PROTOCOMMON_PB_ESOURCE
ITEMINFO_SOURCE_FIELD.type = 14
ITEMINFO_SOURCE_FIELD.cpp_type = 8
ITEMINFO_ISNEW_FIELD.name = "isnew"
ITEMINFO_ISNEW_FIELD.full_name = ".Cmd.ItemInfo.isnew"
ITEMINFO_ISNEW_FIELD.number = 13
ITEMINFO_ISNEW_FIELD.index = 12
ITEMINFO_ISNEW_FIELD.label = 1
ITEMINFO_ISNEW_FIELD.has_default_value = true
ITEMINFO_ISNEW_FIELD.default_value = false
ITEMINFO_ISNEW_FIELD.type = 8
ITEMINFO_ISNEW_FIELD.cpp_type = 7
ITEMINFO_MAXCARDSLOT_FIELD.name = "maxcardslot"
ITEMINFO_MAXCARDSLOT_FIELD.full_name = ".Cmd.ItemInfo.maxcardslot"
ITEMINFO_MAXCARDSLOT_FIELD.number = 14
ITEMINFO_MAXCARDSLOT_FIELD.index = 13
ITEMINFO_MAXCARDSLOT_FIELD.label = 1
ITEMINFO_MAXCARDSLOT_FIELD.has_default_value = true
ITEMINFO_MAXCARDSLOT_FIELD.default_value = 0
ITEMINFO_MAXCARDSLOT_FIELD.type = 13
ITEMINFO_MAXCARDSLOT_FIELD.cpp_type = 3
ITEMINFO_ISHINT_FIELD.name = "ishint"
ITEMINFO_ISHINT_FIELD.full_name = ".Cmd.ItemInfo.ishint"
ITEMINFO_ISHINT_FIELD.number = 15
ITEMINFO_ISHINT_FIELD.index = 14
ITEMINFO_ISHINT_FIELD.label = 1
ITEMINFO_ISHINT_FIELD.has_default_value = true
ITEMINFO_ISHINT_FIELD.default_value = false
ITEMINFO_ISHINT_FIELD.type = 8
ITEMINFO_ISHINT_FIELD.cpp_type = 7
ITEMINFO_ISACTIVE_FIELD.name = "isactive"
ITEMINFO_ISACTIVE_FIELD.full_name = ".Cmd.ItemInfo.isactive"
ITEMINFO_ISACTIVE_FIELD.number = 16
ITEMINFO_ISACTIVE_FIELD.index = 15
ITEMINFO_ISACTIVE_FIELD.label = 1
ITEMINFO_ISACTIVE_FIELD.has_default_value = true
ITEMINFO_ISACTIVE_FIELD.default_value = false
ITEMINFO_ISACTIVE_FIELD.type = 8
ITEMINFO_ISACTIVE_FIELD.cpp_type = 7
ITEMINFO_SOURCE_NPC_FIELD.name = "source_npc"
ITEMINFO_SOURCE_NPC_FIELD.full_name = ".Cmd.ItemInfo.source_npc"
ITEMINFO_SOURCE_NPC_FIELD.number = 17
ITEMINFO_SOURCE_NPC_FIELD.index = 16
ITEMINFO_SOURCE_NPC_FIELD.label = 1
ITEMINFO_SOURCE_NPC_FIELD.has_default_value = true
ITEMINFO_SOURCE_NPC_FIELD.default_value = 0
ITEMINFO_SOURCE_NPC_FIELD.type = 13
ITEMINFO_SOURCE_NPC_FIELD.cpp_type = 3
ITEMINFO_REFINELV_FIELD.name = "refinelv"
ITEMINFO_REFINELV_FIELD.full_name = ".Cmd.ItemInfo.refinelv"
ITEMINFO_REFINELV_FIELD.number = 18
ITEMINFO_REFINELV_FIELD.index = 17
ITEMINFO_REFINELV_FIELD.label = 1
ITEMINFO_REFINELV_FIELD.has_default_value = true
ITEMINFO_REFINELV_FIELD.default_value = 0
ITEMINFO_REFINELV_FIELD.type = 13
ITEMINFO_REFINELV_FIELD.cpp_type = 3
ITEMINFO_CHARGEMONEY_FIELD.name = "chargemoney"
ITEMINFO_CHARGEMONEY_FIELD.full_name = ".Cmd.ItemInfo.chargemoney"
ITEMINFO_CHARGEMONEY_FIELD.number = 19
ITEMINFO_CHARGEMONEY_FIELD.index = 18
ITEMINFO_CHARGEMONEY_FIELD.label = 1
ITEMINFO_CHARGEMONEY_FIELD.has_default_value = true
ITEMINFO_CHARGEMONEY_FIELD.default_value = 0
ITEMINFO_CHARGEMONEY_FIELD.type = 13
ITEMINFO_CHARGEMONEY_FIELD.cpp_type = 3
ITEMINFO_OVERTIME_FIELD.name = "overtime"
ITEMINFO_OVERTIME_FIELD.full_name = ".Cmd.ItemInfo.overtime"
ITEMINFO_OVERTIME_FIELD.number = 20
ITEMINFO_OVERTIME_FIELD.index = 19
ITEMINFO_OVERTIME_FIELD.label = 1
ITEMINFO_OVERTIME_FIELD.has_default_value = true
ITEMINFO_OVERTIME_FIELD.default_value = 0
ITEMINFO_OVERTIME_FIELD.type = 13
ITEMINFO_OVERTIME_FIELD.cpp_type = 3
ITEMINFO_QUOTA_FIELD.name = "quota"
ITEMINFO_QUOTA_FIELD.full_name = ".Cmd.ItemInfo.quota"
ITEMINFO_QUOTA_FIELD.number = 21
ITEMINFO_QUOTA_FIELD.index = 20
ITEMINFO_QUOTA_FIELD.label = 1
ITEMINFO_QUOTA_FIELD.has_default_value = true
ITEMINFO_QUOTA_FIELD.default_value = 0
ITEMINFO_QUOTA_FIELD.type = 4
ITEMINFO_QUOTA_FIELD.cpp_type = 4
ITEMINFO_USEDTIMES_FIELD.name = "usedtimes"
ITEMINFO_USEDTIMES_FIELD.full_name = ".Cmd.ItemInfo.usedtimes"
ITEMINFO_USEDTIMES_FIELD.number = 22
ITEMINFO_USEDTIMES_FIELD.index = 21
ITEMINFO_USEDTIMES_FIELD.label = 1
ITEMINFO_USEDTIMES_FIELD.has_default_value = true
ITEMINFO_USEDTIMES_FIELD.default_value = 0
ITEMINFO_USEDTIMES_FIELD.type = 13
ITEMINFO_USEDTIMES_FIELD.cpp_type = 3
ITEMINFO_USEDTIME_FIELD.name = "usedtime"
ITEMINFO_USEDTIME_FIELD.full_name = ".Cmd.ItemInfo.usedtime"
ITEMINFO_USEDTIME_FIELD.number = 23
ITEMINFO_USEDTIME_FIELD.index = 22
ITEMINFO_USEDTIME_FIELD.label = 1
ITEMINFO_USEDTIME_FIELD.has_default_value = true
ITEMINFO_USEDTIME_FIELD.default_value = 0
ITEMINFO_USEDTIME_FIELD.type = 13
ITEMINFO_USEDTIME_FIELD.cpp_type = 3
ITEMINFO_ISFAVORITE_FIELD.name = "isfavorite"
ITEMINFO_ISFAVORITE_FIELD.full_name = ".Cmd.ItemInfo.isfavorite"
ITEMINFO_ISFAVORITE_FIELD.number = 24
ITEMINFO_ISFAVORITE_FIELD.index = 23
ITEMINFO_ISFAVORITE_FIELD.label = 1
ITEMINFO_ISFAVORITE_FIELD.has_default_value = true
ITEMINFO_ISFAVORITE_FIELD.default_value = false
ITEMINFO_ISFAVORITE_FIELD.type = 8
ITEMINFO_ISFAVORITE_FIELD.cpp_type = 7
ITEMINFO.name = "ItemInfo"
ITEMINFO.full_name = ".Cmd.ItemInfo"
ITEMINFO.nested_types = {}
ITEMINFO.enum_types = {}
ITEMINFO.fields = {
  ITEMINFO_GUID_FIELD,
  ITEMINFO_ID_FIELD,
  ITEMINFO_COUNT_FIELD,
  ITEMINFO_INDEX_FIELD,
  ITEMINFO_CREATETIME_FIELD,
  ITEMINFO_CD_FIELD,
  ITEMINFO_TYPE_FIELD,
  ITEMINFO_BIND_FIELD,
  ITEMINFO_EXPIRE_FIELD,
  ITEMINFO_QUALITY_FIELD,
  ITEMINFO_EQUIPTYPE_FIELD,
  ITEMINFO_SOURCE_FIELD,
  ITEMINFO_ISNEW_FIELD,
  ITEMINFO_MAXCARDSLOT_FIELD,
  ITEMINFO_ISHINT_FIELD,
  ITEMINFO_ISACTIVE_FIELD,
  ITEMINFO_SOURCE_NPC_FIELD,
  ITEMINFO_REFINELV_FIELD,
  ITEMINFO_CHARGEMONEY_FIELD,
  ITEMINFO_OVERTIME_FIELD,
  ITEMINFO_QUOTA_FIELD,
  ITEMINFO_USEDTIMES_FIELD,
  ITEMINFO_USEDTIME_FIELD,
  ITEMINFO_ISFAVORITE_FIELD
}
ITEMINFO.is_extendable = false
ITEMINFO.extensions = {}
REFINECOMPOSE_ID_FIELD.name = "id"
REFINECOMPOSE_ID_FIELD.full_name = ".Cmd.RefineCompose.id"
REFINECOMPOSE_ID_FIELD.number = 1
REFINECOMPOSE_ID_FIELD.index = 0
REFINECOMPOSE_ID_FIELD.label = 1
REFINECOMPOSE_ID_FIELD.has_default_value = true
REFINECOMPOSE_ID_FIELD.default_value = 0
REFINECOMPOSE_ID_FIELD.type = 13
REFINECOMPOSE_ID_FIELD.cpp_type = 3
REFINECOMPOSE_NUM_FIELD.name = "num"
REFINECOMPOSE_NUM_FIELD.full_name = ".Cmd.RefineCompose.num"
REFINECOMPOSE_NUM_FIELD.number = 2
REFINECOMPOSE_NUM_FIELD.index = 1
REFINECOMPOSE_NUM_FIELD.label = 1
REFINECOMPOSE_NUM_FIELD.has_default_value = true
REFINECOMPOSE_NUM_FIELD.default_value = 0
REFINECOMPOSE_NUM_FIELD.type = 13
REFINECOMPOSE_NUM_FIELD.cpp_type = 3
REFINECOMPOSE.name = "RefineCompose"
REFINECOMPOSE.full_name = ".Cmd.RefineCompose"
REFINECOMPOSE.nested_types = {}
REFINECOMPOSE.enum_types = {}
REFINECOMPOSE.fields = {
  REFINECOMPOSE_ID_FIELD,
  REFINECOMPOSE_NUM_FIELD
}
REFINECOMPOSE.is_extendable = false
REFINECOMPOSE.extensions = {}
EQUIPDATA_STRENGTHLV_FIELD.name = "strengthlv"
EQUIPDATA_STRENGTHLV_FIELD.full_name = ".Cmd.EquipData.strengthlv"
EQUIPDATA_STRENGTHLV_FIELD.number = 1
EQUIPDATA_STRENGTHLV_FIELD.index = 0
EQUIPDATA_STRENGTHLV_FIELD.label = 1
EQUIPDATA_STRENGTHLV_FIELD.has_default_value = true
EQUIPDATA_STRENGTHLV_FIELD.default_value = 0
EQUIPDATA_STRENGTHLV_FIELD.type = 13
EQUIPDATA_STRENGTHLV_FIELD.cpp_type = 3
EQUIPDATA_REFINELV_FIELD.name = "refinelv"
EQUIPDATA_REFINELV_FIELD.full_name = ".Cmd.EquipData.refinelv"
EQUIPDATA_REFINELV_FIELD.number = 2
EQUIPDATA_REFINELV_FIELD.index = 1
EQUIPDATA_REFINELV_FIELD.label = 1
EQUIPDATA_REFINELV_FIELD.has_default_value = true
EQUIPDATA_REFINELV_FIELD.default_value = 0
EQUIPDATA_REFINELV_FIELD.type = 13
EQUIPDATA_REFINELV_FIELD.cpp_type = 3
EQUIPDATA_STRENGTHCOST_FIELD.name = "strengthCost"
EQUIPDATA_STRENGTHCOST_FIELD.full_name = ".Cmd.EquipData.strengthCost"
EQUIPDATA_STRENGTHCOST_FIELD.number = 3
EQUIPDATA_STRENGTHCOST_FIELD.index = 2
EQUIPDATA_STRENGTHCOST_FIELD.label = 1
EQUIPDATA_STRENGTHCOST_FIELD.has_default_value = true
EQUIPDATA_STRENGTHCOST_FIELD.default_value = 0
EQUIPDATA_STRENGTHCOST_FIELD.type = 13
EQUIPDATA_STRENGTHCOST_FIELD.cpp_type = 3
EQUIPDATA_REFINECOMPOSE_FIELD.name = "refineCompose"
EQUIPDATA_REFINECOMPOSE_FIELD.full_name = ".Cmd.EquipData.refineCompose"
EQUIPDATA_REFINECOMPOSE_FIELD.number = 4
EQUIPDATA_REFINECOMPOSE_FIELD.index = 3
EQUIPDATA_REFINECOMPOSE_FIELD.label = 3
EQUIPDATA_REFINECOMPOSE_FIELD.has_default_value = false
EQUIPDATA_REFINECOMPOSE_FIELD.default_value = {}
EQUIPDATA_REFINECOMPOSE_FIELD.message_type = REFINECOMPOSE
EQUIPDATA_REFINECOMPOSE_FIELD.type = 11
EQUIPDATA_REFINECOMPOSE_FIELD.cpp_type = 10
EQUIPDATA_CARDSLOT_FIELD.name = "cardslot"
EQUIPDATA_CARDSLOT_FIELD.full_name = ".Cmd.EquipData.cardslot"
EQUIPDATA_CARDSLOT_FIELD.number = 5
EQUIPDATA_CARDSLOT_FIELD.index = 4
EQUIPDATA_CARDSLOT_FIELD.label = 1
EQUIPDATA_CARDSLOT_FIELD.has_default_value = true
EQUIPDATA_CARDSLOT_FIELD.default_value = 0
EQUIPDATA_CARDSLOT_FIELD.type = 13
EQUIPDATA_CARDSLOT_FIELD.cpp_type = 3
EQUIPDATA_BUFFID_FIELD.name = "buffid"
EQUIPDATA_BUFFID_FIELD.full_name = ".Cmd.EquipData.buffid"
EQUIPDATA_BUFFID_FIELD.number = 6
EQUIPDATA_BUFFID_FIELD.index = 5
EQUIPDATA_BUFFID_FIELD.label = 3
EQUIPDATA_BUFFID_FIELD.has_default_value = false
EQUIPDATA_BUFFID_FIELD.default_value = {}
EQUIPDATA_BUFFID_FIELD.type = 13
EQUIPDATA_BUFFID_FIELD.cpp_type = 3
EQUIPDATA_DAMAGE_FIELD.name = "damage"
EQUIPDATA_DAMAGE_FIELD.full_name = ".Cmd.EquipData.damage"
EQUIPDATA_DAMAGE_FIELD.number = 7
EQUIPDATA_DAMAGE_FIELD.index = 6
EQUIPDATA_DAMAGE_FIELD.label = 1
EQUIPDATA_DAMAGE_FIELD.has_default_value = true
EQUIPDATA_DAMAGE_FIELD.default_value = false
EQUIPDATA_DAMAGE_FIELD.type = 8
EQUIPDATA_DAMAGE_FIELD.cpp_type = 7
EQUIPDATA_LV_FIELD.name = "lv"
EQUIPDATA_LV_FIELD.full_name = ".Cmd.EquipData.lv"
EQUIPDATA_LV_FIELD.number = 8
EQUIPDATA_LV_FIELD.index = 7
EQUIPDATA_LV_FIELD.label = 1
EQUIPDATA_LV_FIELD.has_default_value = true
EQUIPDATA_LV_FIELD.default_value = 0
EQUIPDATA_LV_FIELD.type = 13
EQUIPDATA_LV_FIELD.cpp_type = 3
EQUIPDATA_COLOR_FIELD.name = "color"
EQUIPDATA_COLOR_FIELD.full_name = ".Cmd.EquipData.color"
EQUIPDATA_COLOR_FIELD.number = 9
EQUIPDATA_COLOR_FIELD.index = 8
EQUIPDATA_COLOR_FIELD.label = 1
EQUIPDATA_COLOR_FIELD.has_default_value = true
EQUIPDATA_COLOR_FIELD.default_value = 0
EQUIPDATA_COLOR_FIELD.type = 13
EQUIPDATA_COLOR_FIELD.cpp_type = 3
EQUIPDATA_BREAKSTARTTIME_FIELD.name = "breakstarttime"
EQUIPDATA_BREAKSTARTTIME_FIELD.full_name = ".Cmd.EquipData.breakstarttime"
EQUIPDATA_BREAKSTARTTIME_FIELD.number = 10
EQUIPDATA_BREAKSTARTTIME_FIELD.index = 9
EQUIPDATA_BREAKSTARTTIME_FIELD.label = 1
EQUIPDATA_BREAKSTARTTIME_FIELD.has_default_value = true
EQUIPDATA_BREAKSTARTTIME_FIELD.default_value = 0
EQUIPDATA_BREAKSTARTTIME_FIELD.type = 13
EQUIPDATA_BREAKSTARTTIME_FIELD.cpp_type = 3
EQUIPDATA_BREAKENDTIME_FIELD.name = "breakendtime"
EQUIPDATA_BREAKENDTIME_FIELD.full_name = ".Cmd.EquipData.breakendtime"
EQUIPDATA_BREAKENDTIME_FIELD.number = 11
EQUIPDATA_BREAKENDTIME_FIELD.index = 10
EQUIPDATA_BREAKENDTIME_FIELD.label = 1
EQUIPDATA_BREAKENDTIME_FIELD.has_default_value = true
EQUIPDATA_BREAKENDTIME_FIELD.default_value = 0
EQUIPDATA_BREAKENDTIME_FIELD.type = 13
EQUIPDATA_BREAKENDTIME_FIELD.cpp_type = 3
EQUIPDATA_STRENGTHLV2_FIELD.name = "strengthlv2"
EQUIPDATA_STRENGTHLV2_FIELD.full_name = ".Cmd.EquipData.strengthlv2"
EQUIPDATA_STRENGTHLV2_FIELD.number = 12
EQUIPDATA_STRENGTHLV2_FIELD.index = 11
EQUIPDATA_STRENGTHLV2_FIELD.label = 1
EQUIPDATA_STRENGTHLV2_FIELD.has_default_value = true
EQUIPDATA_STRENGTHLV2_FIELD.default_value = 0
EQUIPDATA_STRENGTHLV2_FIELD.type = 13
EQUIPDATA_STRENGTHLV2_FIELD.cpp_type = 3
EQUIPDATA_STRENGTHLV2COST_FIELD.name = "strengthlv2cost"
EQUIPDATA_STRENGTHLV2COST_FIELD.full_name = ".Cmd.EquipData.strengthlv2cost"
EQUIPDATA_STRENGTHLV2COST_FIELD.number = 13
EQUIPDATA_STRENGTHLV2COST_FIELD.index = 12
EQUIPDATA_STRENGTHLV2COST_FIELD.label = 3
EQUIPDATA_STRENGTHLV2COST_FIELD.has_default_value = false
EQUIPDATA_STRENGTHLV2COST_FIELD.default_value = {}
EQUIPDATA_STRENGTHLV2COST_FIELD.message_type = ITEMINFO
EQUIPDATA_STRENGTHLV2COST_FIELD.type = 11
EQUIPDATA_STRENGTHLV2COST_FIELD.cpp_type = 10
EQUIPDATA.name = "EquipData"
EQUIPDATA.full_name = ".Cmd.EquipData"
EQUIPDATA.nested_types = {}
EQUIPDATA.enum_types = {}
EQUIPDATA.fields = {
  EQUIPDATA_STRENGTHLV_FIELD,
  EQUIPDATA_REFINELV_FIELD,
  EQUIPDATA_STRENGTHCOST_FIELD,
  EQUIPDATA_REFINECOMPOSE_FIELD,
  EQUIPDATA_CARDSLOT_FIELD,
  EQUIPDATA_BUFFID_FIELD,
  EQUIPDATA_DAMAGE_FIELD,
  EQUIPDATA_LV_FIELD,
  EQUIPDATA_COLOR_FIELD,
  EQUIPDATA_BREAKSTARTTIME_FIELD,
  EQUIPDATA_BREAKENDTIME_FIELD,
  EQUIPDATA_STRENGTHLV2_FIELD,
  EQUIPDATA_STRENGTHLV2COST_FIELD
}
EQUIPDATA.is_extendable = false
EQUIPDATA.extensions = {}
CARDDATA_GUID_FIELD.name = "guid"
CARDDATA_GUID_FIELD.full_name = ".Cmd.CardData.guid"
CARDDATA_GUID_FIELD.number = 1
CARDDATA_GUID_FIELD.index = 0
CARDDATA_GUID_FIELD.label = 1
CARDDATA_GUID_FIELD.has_default_value = false
CARDDATA_GUID_FIELD.default_value = ""
CARDDATA_GUID_FIELD.type = 9
CARDDATA_GUID_FIELD.cpp_type = 9
CARDDATA_ID_FIELD.name = "id"
CARDDATA_ID_FIELD.full_name = ".Cmd.CardData.id"
CARDDATA_ID_FIELD.number = 2
CARDDATA_ID_FIELD.index = 1
CARDDATA_ID_FIELD.label = 1
CARDDATA_ID_FIELD.has_default_value = true
CARDDATA_ID_FIELD.default_value = 0
CARDDATA_ID_FIELD.type = 13
CARDDATA_ID_FIELD.cpp_type = 3
CARDDATA_POS_FIELD.name = "pos"
CARDDATA_POS_FIELD.full_name = ".Cmd.CardData.pos"
CARDDATA_POS_FIELD.number = 3
CARDDATA_POS_FIELD.index = 2
CARDDATA_POS_FIELD.label = 1
CARDDATA_POS_FIELD.has_default_value = true
CARDDATA_POS_FIELD.default_value = 0
CARDDATA_POS_FIELD.type = 13
CARDDATA_POS_FIELD.cpp_type = 3
CARDDATA.name = "CardData"
CARDDATA.full_name = ".Cmd.CardData"
CARDDATA.nested_types = {}
CARDDATA.enum_types = {}
CARDDATA.fields = {
  CARDDATA_GUID_FIELD,
  CARDDATA_ID_FIELD,
  CARDDATA_POS_FIELD
}
CARDDATA.is_extendable = false
CARDDATA.extensions = {}
ENCHANTATTR_TYPE_FIELD.name = "type"
ENCHANTATTR_TYPE_FIELD.full_name = ".Cmd.EnchantAttr.type"
ENCHANTATTR_TYPE_FIELD.number = 1
ENCHANTATTR_TYPE_FIELD.index = 0
ENCHANTATTR_TYPE_FIELD.label = 1
ENCHANTATTR_TYPE_FIELD.has_default_value = true
ENCHANTATTR_TYPE_FIELD.default_value = 0
ENCHANTATTR_TYPE_FIELD.enum_type = PROTOCOMMON_PB_EATTRTYPE
ENCHANTATTR_TYPE_FIELD.type = 14
ENCHANTATTR_TYPE_FIELD.cpp_type = 8
ENCHANTATTR_VALUE_FIELD.name = "value"
ENCHANTATTR_VALUE_FIELD.full_name = ".Cmd.EnchantAttr.value"
ENCHANTATTR_VALUE_FIELD.number = 2
ENCHANTATTR_VALUE_FIELD.index = 1
ENCHANTATTR_VALUE_FIELD.label = 1
ENCHANTATTR_VALUE_FIELD.has_default_value = true
ENCHANTATTR_VALUE_FIELD.default_value = 0
ENCHANTATTR_VALUE_FIELD.type = 13
ENCHANTATTR_VALUE_FIELD.cpp_type = 3
ENCHANTATTR.name = "EnchantAttr"
ENCHANTATTR.full_name = ".Cmd.EnchantAttr"
ENCHANTATTR.nested_types = {}
ENCHANTATTR.enum_types = {}
ENCHANTATTR.fields = {
  ENCHANTATTR_TYPE_FIELD,
  ENCHANTATTR_VALUE_FIELD
}
ENCHANTATTR.is_extendable = false
ENCHANTATTR.extensions = {}
ENCHANTEXTRA_CONFIGID_FIELD.name = "configid"
ENCHANTEXTRA_CONFIGID_FIELD.full_name = ".Cmd.EnchantExtra.configid"
ENCHANTEXTRA_CONFIGID_FIELD.number = 1
ENCHANTEXTRA_CONFIGID_FIELD.index = 0
ENCHANTEXTRA_CONFIGID_FIELD.label = 1
ENCHANTEXTRA_CONFIGID_FIELD.has_default_value = true
ENCHANTEXTRA_CONFIGID_FIELD.default_value = 0
ENCHANTEXTRA_CONFIGID_FIELD.type = 13
ENCHANTEXTRA_CONFIGID_FIELD.cpp_type = 3
ENCHANTEXTRA_BUFFID_FIELD.name = "buffid"
ENCHANTEXTRA_BUFFID_FIELD.full_name = ".Cmd.EnchantExtra.buffid"
ENCHANTEXTRA_BUFFID_FIELD.number = 2
ENCHANTEXTRA_BUFFID_FIELD.index = 1
ENCHANTEXTRA_BUFFID_FIELD.label = 1
ENCHANTEXTRA_BUFFID_FIELD.has_default_value = true
ENCHANTEXTRA_BUFFID_FIELD.default_value = 0
ENCHANTEXTRA_BUFFID_FIELD.type = 13
ENCHANTEXTRA_BUFFID_FIELD.cpp_type = 3
ENCHANTEXTRA.name = "EnchantExtra"
ENCHANTEXTRA.full_name = ".Cmd.EnchantExtra"
ENCHANTEXTRA.nested_types = {}
ENCHANTEXTRA.enum_types = {}
ENCHANTEXTRA.fields = {
  ENCHANTEXTRA_CONFIGID_FIELD,
  ENCHANTEXTRA_BUFFID_FIELD
}
ENCHANTEXTRA.is_extendable = false
ENCHANTEXTRA.extensions = {}
ENCHANTDATA_TYPE_FIELD.name = "type"
ENCHANTDATA_TYPE_FIELD.full_name = ".Cmd.EnchantData.type"
ENCHANTDATA_TYPE_FIELD.number = 1
ENCHANTDATA_TYPE_FIELD.index = 0
ENCHANTDATA_TYPE_FIELD.label = 1
ENCHANTDATA_TYPE_FIELD.has_default_value = true
ENCHANTDATA_TYPE_FIELD.default_value = 0
ENCHANTDATA_TYPE_FIELD.enum_type = EENCHANTTYPE
ENCHANTDATA_TYPE_FIELD.type = 14
ENCHANTDATA_TYPE_FIELD.cpp_type = 8
ENCHANTDATA_ATTRS_FIELD.name = "attrs"
ENCHANTDATA_ATTRS_FIELD.full_name = ".Cmd.EnchantData.attrs"
ENCHANTDATA_ATTRS_FIELD.number = 2
ENCHANTDATA_ATTRS_FIELD.index = 1
ENCHANTDATA_ATTRS_FIELD.label = 3
ENCHANTDATA_ATTRS_FIELD.has_default_value = false
ENCHANTDATA_ATTRS_FIELD.default_value = {}
ENCHANTDATA_ATTRS_FIELD.message_type = ENCHANTATTR
ENCHANTDATA_ATTRS_FIELD.type = 11
ENCHANTDATA_ATTRS_FIELD.cpp_type = 10
ENCHANTDATA_EXTRAS_FIELD.name = "extras"
ENCHANTDATA_EXTRAS_FIELD.full_name = ".Cmd.EnchantData.extras"
ENCHANTDATA_EXTRAS_FIELD.number = 3
ENCHANTDATA_EXTRAS_FIELD.index = 2
ENCHANTDATA_EXTRAS_FIELD.label = 3
ENCHANTDATA_EXTRAS_FIELD.has_default_value = false
ENCHANTDATA_EXTRAS_FIELD.default_value = {}
ENCHANTDATA_EXTRAS_FIELD.message_type = ENCHANTEXTRA
ENCHANTDATA_EXTRAS_FIELD.type = 11
ENCHANTDATA_EXTRAS_FIELD.cpp_type = 10
ENCHANTDATA_PATCH_FIELD.name = "patch"
ENCHANTDATA_PATCH_FIELD.full_name = ".Cmd.EnchantData.patch"
ENCHANTDATA_PATCH_FIELD.number = 4
ENCHANTDATA_PATCH_FIELD.index = 3
ENCHANTDATA_PATCH_FIELD.label = 3
ENCHANTDATA_PATCH_FIELD.has_default_value = false
ENCHANTDATA_PATCH_FIELD.default_value = {}
ENCHANTDATA_PATCH_FIELD.type = 13
ENCHANTDATA_PATCH_FIELD.cpp_type = 3
ENCHANTDATA.name = "EnchantData"
ENCHANTDATA.full_name = ".Cmd.EnchantData"
ENCHANTDATA.nested_types = {}
ENCHANTDATA.enum_types = {}
ENCHANTDATA.fields = {
  ENCHANTDATA_TYPE_FIELD,
  ENCHANTDATA_ATTRS_FIELD,
  ENCHANTDATA_EXTRAS_FIELD,
  ENCHANTDATA_PATCH_FIELD
}
ENCHANTDATA.is_extendable = false
ENCHANTDATA.extensions = {}
REFINEDATA_LASTFAIL_FIELD.name = "lastfail"
REFINEDATA_LASTFAIL_FIELD.full_name = ".Cmd.RefineData.lastfail"
REFINEDATA_LASTFAIL_FIELD.number = 1
REFINEDATA_LASTFAIL_FIELD.index = 0
REFINEDATA_LASTFAIL_FIELD.label = 1
REFINEDATA_LASTFAIL_FIELD.has_default_value = true
REFINEDATA_LASTFAIL_FIELD.default_value = false
REFINEDATA_LASTFAIL_FIELD.type = 8
REFINEDATA_LASTFAIL_FIELD.cpp_type = 7
REFINEDATA_REPAIRCOUNT_FIELD.name = "repaircount"
REFINEDATA_REPAIRCOUNT_FIELD.full_name = ".Cmd.RefineData.repaircount"
REFINEDATA_REPAIRCOUNT_FIELD.number = 2
REFINEDATA_REPAIRCOUNT_FIELD.index = 1
REFINEDATA_REPAIRCOUNT_FIELD.label = 1
REFINEDATA_REPAIRCOUNT_FIELD.has_default_value = true
REFINEDATA_REPAIRCOUNT_FIELD.default_value = 0
REFINEDATA_REPAIRCOUNT_FIELD.type = 13
REFINEDATA_REPAIRCOUNT_FIELD.cpp_type = 3
REFINEDATA.name = "RefineData"
REFINEDATA.full_name = ".Cmd.RefineData"
REFINEDATA.nested_types = {}
REFINEDATA.enum_types = {}
REFINEDATA.fields = {
  REFINEDATA_LASTFAIL_FIELD,
  REFINEDATA_REPAIRCOUNT_FIELD
}
REFINEDATA.is_extendable = false
REFINEDATA.extensions = {}
EGGEQUIP_BASE_FIELD.name = "base"
EGGEQUIP_BASE_FIELD.full_name = ".Cmd.EggEquip.base"
EGGEQUIP_BASE_FIELD.number = 1
EGGEQUIP_BASE_FIELD.index = 0
EGGEQUIP_BASE_FIELD.label = 1
EGGEQUIP_BASE_FIELD.has_default_value = false
EGGEQUIP_BASE_FIELD.default_value = nil
EGGEQUIP_BASE_FIELD.message_type = ITEMINFO
EGGEQUIP_BASE_FIELD.type = 11
EGGEQUIP_BASE_FIELD.cpp_type = 10
EGGEQUIP_DATA_FIELD.name = "data"
EGGEQUIP_DATA_FIELD.full_name = ".Cmd.EggEquip.data"
EGGEQUIP_DATA_FIELD.number = 2
EGGEQUIP_DATA_FIELD.index = 1
EGGEQUIP_DATA_FIELD.label = 1
EGGEQUIP_DATA_FIELD.has_default_value = false
EGGEQUIP_DATA_FIELD.default_value = nil
EGGEQUIP_DATA_FIELD.message_type = EQUIPDATA
EGGEQUIP_DATA_FIELD.type = 11
EGGEQUIP_DATA_FIELD.cpp_type = 10
EGGEQUIP_CARD_FIELD.name = "card"
EGGEQUIP_CARD_FIELD.full_name = ".Cmd.EggEquip.card"
EGGEQUIP_CARD_FIELD.number = 3
EGGEQUIP_CARD_FIELD.index = 2
EGGEQUIP_CARD_FIELD.label = 3
EGGEQUIP_CARD_FIELD.has_default_value = false
EGGEQUIP_CARD_FIELD.default_value = {}
EGGEQUIP_CARD_FIELD.message_type = CARDDATA
EGGEQUIP_CARD_FIELD.type = 11
EGGEQUIP_CARD_FIELD.cpp_type = 10
EGGEQUIP_ENCHANT_FIELD.name = "enchant"
EGGEQUIP_ENCHANT_FIELD.full_name = ".Cmd.EggEquip.enchant"
EGGEQUIP_ENCHANT_FIELD.number = 4
EGGEQUIP_ENCHANT_FIELD.index = 3
EGGEQUIP_ENCHANT_FIELD.label = 1
EGGEQUIP_ENCHANT_FIELD.has_default_value = false
EGGEQUIP_ENCHANT_FIELD.default_value = nil
EGGEQUIP_ENCHANT_FIELD.message_type = ENCHANTDATA
EGGEQUIP_ENCHANT_FIELD.type = 11
EGGEQUIP_ENCHANT_FIELD.cpp_type = 10
EGGEQUIP_PREVIEWENCHANT_FIELD.name = "previewenchant"
EGGEQUIP_PREVIEWENCHANT_FIELD.full_name = ".Cmd.EggEquip.previewenchant"
EGGEQUIP_PREVIEWENCHANT_FIELD.number = 5
EGGEQUIP_PREVIEWENCHANT_FIELD.index = 4
EGGEQUIP_PREVIEWENCHANT_FIELD.label = 1
EGGEQUIP_PREVIEWENCHANT_FIELD.has_default_value = false
EGGEQUIP_PREVIEWENCHANT_FIELD.default_value = nil
EGGEQUIP_PREVIEWENCHANT_FIELD.message_type = ENCHANTDATA
EGGEQUIP_PREVIEWENCHANT_FIELD.type = 11
EGGEQUIP_PREVIEWENCHANT_FIELD.cpp_type = 10
EGGEQUIP_REFINE_FIELD.name = "refine"
EGGEQUIP_REFINE_FIELD.full_name = ".Cmd.EggEquip.refine"
EGGEQUIP_REFINE_FIELD.number = 7
EGGEQUIP_REFINE_FIELD.index = 5
EGGEQUIP_REFINE_FIELD.label = 1
EGGEQUIP_REFINE_FIELD.has_default_value = false
EGGEQUIP_REFINE_FIELD.default_value = nil
EGGEQUIP_REFINE_FIELD.message_type = REFINEDATA
EGGEQUIP_REFINE_FIELD.type = 11
EGGEQUIP_REFINE_FIELD.cpp_type = 10
EGGEQUIP.name = "EggEquip"
EGGEQUIP.full_name = ".Cmd.EggEquip"
EGGEQUIP.nested_types = {}
EGGEQUIP.enum_types = {}
EGGEQUIP.fields = {
  EGGEQUIP_BASE_FIELD,
  EGGEQUIP_DATA_FIELD,
  EGGEQUIP_CARD_FIELD,
  EGGEQUIP_ENCHANT_FIELD,
  EGGEQUIP_PREVIEWENCHANT_FIELD,
  EGGEQUIP_REFINE_FIELD
}
EGGEQUIP.is_extendable = false
EGGEQUIP.extensions = {}
PETEQUIPDATA_EPOS_FIELD.name = "epos"
PETEQUIPDATA_EPOS_FIELD.full_name = ".Cmd.PetEquipData.epos"
PETEQUIPDATA_EPOS_FIELD.number = 1
PETEQUIPDATA_EPOS_FIELD.index = 0
PETEQUIPDATA_EPOS_FIELD.label = 1
PETEQUIPDATA_EPOS_FIELD.has_default_value = false
PETEQUIPDATA_EPOS_FIELD.default_value = nil
PETEQUIPDATA_EPOS_FIELD.enum_type = EEQUIPPOS
PETEQUIPDATA_EPOS_FIELD.type = 14
PETEQUIPDATA_EPOS_FIELD.cpp_type = 8
PETEQUIPDATA_ITEMID_FIELD.name = "itemid"
PETEQUIPDATA_ITEMID_FIELD.full_name = ".Cmd.PetEquipData.itemid"
PETEQUIPDATA_ITEMID_FIELD.number = 2
PETEQUIPDATA_ITEMID_FIELD.index = 1
PETEQUIPDATA_ITEMID_FIELD.label = 1
PETEQUIPDATA_ITEMID_FIELD.has_default_value = false
PETEQUIPDATA_ITEMID_FIELD.default_value = 0
PETEQUIPDATA_ITEMID_FIELD.type = 13
PETEQUIPDATA_ITEMID_FIELD.cpp_type = 3
PETEQUIPDATA.name = "PetEquipData"
PETEQUIPDATA.full_name = ".Cmd.PetEquipData"
PETEQUIPDATA.nested_types = {}
PETEQUIPDATA.enum_types = {}
PETEQUIPDATA.fields = {
  PETEQUIPDATA_EPOS_FIELD,
  PETEQUIPDATA_ITEMID_FIELD
}
PETEQUIPDATA.is_extendable = false
PETEQUIPDATA.extensions = {}
EGGDATA_EXP_FIELD.name = "exp"
EGGDATA_EXP_FIELD.full_name = ".Cmd.EggData.exp"
EGGDATA_EXP_FIELD.number = 1
EGGDATA_EXP_FIELD.index = 0
EGGDATA_EXP_FIELD.label = 1
EGGDATA_EXP_FIELD.has_default_value = true
EGGDATA_EXP_FIELD.default_value = 0
EGGDATA_EXP_FIELD.type = 4
EGGDATA_EXP_FIELD.cpp_type = 4
EGGDATA_FRIENDEXP_FIELD.name = "friendexp"
EGGDATA_FRIENDEXP_FIELD.full_name = ".Cmd.EggData.friendexp"
EGGDATA_FRIENDEXP_FIELD.number = 2
EGGDATA_FRIENDEXP_FIELD.index = 1
EGGDATA_FRIENDEXP_FIELD.label = 1
EGGDATA_FRIENDEXP_FIELD.has_default_value = true
EGGDATA_FRIENDEXP_FIELD.default_value = 0
EGGDATA_FRIENDEXP_FIELD.type = 4
EGGDATA_FRIENDEXP_FIELD.cpp_type = 4
EGGDATA_REWARDEXP_FIELD.name = "rewardexp"
EGGDATA_REWARDEXP_FIELD.full_name = ".Cmd.EggData.rewardexp"
EGGDATA_REWARDEXP_FIELD.number = 3
EGGDATA_REWARDEXP_FIELD.index = 2
EGGDATA_REWARDEXP_FIELD.label = 1
EGGDATA_REWARDEXP_FIELD.has_default_value = true
EGGDATA_REWARDEXP_FIELD.default_value = 0
EGGDATA_REWARDEXP_FIELD.type = 4
EGGDATA_REWARDEXP_FIELD.cpp_type = 4
EGGDATA_ID_FIELD.name = "id"
EGGDATA_ID_FIELD.full_name = ".Cmd.EggData.id"
EGGDATA_ID_FIELD.number = 4
EGGDATA_ID_FIELD.index = 3
EGGDATA_ID_FIELD.label = 1
EGGDATA_ID_FIELD.has_default_value = true
EGGDATA_ID_FIELD.default_value = 0
EGGDATA_ID_FIELD.type = 13
EGGDATA_ID_FIELD.cpp_type = 3
EGGDATA_LV_FIELD.name = "lv"
EGGDATA_LV_FIELD.full_name = ".Cmd.EggData.lv"
EGGDATA_LV_FIELD.number = 5
EGGDATA_LV_FIELD.index = 4
EGGDATA_LV_FIELD.label = 1
EGGDATA_LV_FIELD.has_default_value = true
EGGDATA_LV_FIELD.default_value = 0
EGGDATA_LV_FIELD.type = 13
EGGDATA_LV_FIELD.cpp_type = 3
EGGDATA_FRIENDLV_FIELD.name = "friendlv"
EGGDATA_FRIENDLV_FIELD.full_name = ".Cmd.EggData.friendlv"
EGGDATA_FRIENDLV_FIELD.number = 6
EGGDATA_FRIENDLV_FIELD.index = 5
EGGDATA_FRIENDLV_FIELD.label = 1
EGGDATA_FRIENDLV_FIELD.has_default_value = true
EGGDATA_FRIENDLV_FIELD.default_value = 0
EGGDATA_FRIENDLV_FIELD.type = 13
EGGDATA_FRIENDLV_FIELD.cpp_type = 3
EGGDATA_BODY_FIELD.name = "body"
EGGDATA_BODY_FIELD.full_name = ".Cmd.EggData.body"
EGGDATA_BODY_FIELD.number = 7
EGGDATA_BODY_FIELD.index = 6
EGGDATA_BODY_FIELD.label = 1
EGGDATA_BODY_FIELD.has_default_value = true
EGGDATA_BODY_FIELD.default_value = 0
EGGDATA_BODY_FIELD.type = 13
EGGDATA_BODY_FIELD.cpp_type = 3
EGGDATA_RELIVETIME_FIELD.name = "relivetime"
EGGDATA_RELIVETIME_FIELD.full_name = ".Cmd.EggData.relivetime"
EGGDATA_RELIVETIME_FIELD.number = 8
EGGDATA_RELIVETIME_FIELD.index = 7
EGGDATA_RELIVETIME_FIELD.label = 1
EGGDATA_RELIVETIME_FIELD.has_default_value = true
EGGDATA_RELIVETIME_FIELD.default_value = 0
EGGDATA_RELIVETIME_FIELD.type = 13
EGGDATA_RELIVETIME_FIELD.cpp_type = 3
EGGDATA_HP_FIELD.name = "hp"
EGGDATA_HP_FIELD.full_name = ".Cmd.EggData.hp"
EGGDATA_HP_FIELD.number = 9
EGGDATA_HP_FIELD.index = 8
EGGDATA_HP_FIELD.label = 1
EGGDATA_HP_FIELD.has_default_value = true
EGGDATA_HP_FIELD.default_value = 0
EGGDATA_HP_FIELD.type = 13
EGGDATA_HP_FIELD.cpp_type = 3
EGGDATA_RESTORETIME_FIELD.name = "restoretime"
EGGDATA_RESTORETIME_FIELD.full_name = ".Cmd.EggData.restoretime"
EGGDATA_RESTORETIME_FIELD.number = 10
EGGDATA_RESTORETIME_FIELD.index = 9
EGGDATA_RESTORETIME_FIELD.label = 1
EGGDATA_RESTORETIME_FIELD.has_default_value = true
EGGDATA_RESTORETIME_FIELD.default_value = 0
EGGDATA_RESTORETIME_FIELD.type = 13
EGGDATA_RESTORETIME_FIELD.cpp_type = 3
EGGDATA_TIME_HAPPLY_FIELD.name = "time_happly"
EGGDATA_TIME_HAPPLY_FIELD.full_name = ".Cmd.EggData.time_happly"
EGGDATA_TIME_HAPPLY_FIELD.number = 11
EGGDATA_TIME_HAPPLY_FIELD.index = 10
EGGDATA_TIME_HAPPLY_FIELD.label = 1
EGGDATA_TIME_HAPPLY_FIELD.has_default_value = true
EGGDATA_TIME_HAPPLY_FIELD.default_value = 0
EGGDATA_TIME_HAPPLY_FIELD.type = 13
EGGDATA_TIME_HAPPLY_FIELD.cpp_type = 3
EGGDATA_TIME_EXCITE_FIELD.name = "time_excite"
EGGDATA_TIME_EXCITE_FIELD.full_name = ".Cmd.EggData.time_excite"
EGGDATA_TIME_EXCITE_FIELD.number = 12
EGGDATA_TIME_EXCITE_FIELD.index = 11
EGGDATA_TIME_EXCITE_FIELD.label = 1
EGGDATA_TIME_EXCITE_FIELD.has_default_value = true
EGGDATA_TIME_EXCITE_FIELD.default_value = 0
EGGDATA_TIME_EXCITE_FIELD.type = 13
EGGDATA_TIME_EXCITE_FIELD.cpp_type = 3
EGGDATA_TIME_HAPPINESS_FIELD.name = "time_happiness"
EGGDATA_TIME_HAPPINESS_FIELD.full_name = ".Cmd.EggData.time_happiness"
EGGDATA_TIME_HAPPINESS_FIELD.number = 13
EGGDATA_TIME_HAPPINESS_FIELD.index = 12
EGGDATA_TIME_HAPPINESS_FIELD.label = 1
EGGDATA_TIME_HAPPINESS_FIELD.has_default_value = true
EGGDATA_TIME_HAPPINESS_FIELD.default_value = 0
EGGDATA_TIME_HAPPINESS_FIELD.type = 13
EGGDATA_TIME_HAPPINESS_FIELD.cpp_type = 3
EGGDATA_TIME_HAPPLY_GIFT_FIELD.name = "time_happly_gift"
EGGDATA_TIME_HAPPLY_GIFT_FIELD.full_name = ".Cmd.EggData.time_happly_gift"
EGGDATA_TIME_HAPPLY_GIFT_FIELD.number = 14
EGGDATA_TIME_HAPPLY_GIFT_FIELD.index = 13
EGGDATA_TIME_HAPPLY_GIFT_FIELD.label = 1
EGGDATA_TIME_HAPPLY_GIFT_FIELD.has_default_value = true
EGGDATA_TIME_HAPPLY_GIFT_FIELD.default_value = 0
EGGDATA_TIME_HAPPLY_GIFT_FIELD.type = 13
EGGDATA_TIME_HAPPLY_GIFT_FIELD.cpp_type = 3
EGGDATA_TIME_EXCITE_GIFT_FIELD.name = "time_excite_gift"
EGGDATA_TIME_EXCITE_GIFT_FIELD.full_name = ".Cmd.EggData.time_excite_gift"
EGGDATA_TIME_EXCITE_GIFT_FIELD.number = 15
EGGDATA_TIME_EXCITE_GIFT_FIELD.index = 14
EGGDATA_TIME_EXCITE_GIFT_FIELD.label = 1
EGGDATA_TIME_EXCITE_GIFT_FIELD.has_default_value = true
EGGDATA_TIME_EXCITE_GIFT_FIELD.default_value = 0
EGGDATA_TIME_EXCITE_GIFT_FIELD.type = 13
EGGDATA_TIME_EXCITE_GIFT_FIELD.cpp_type = 3
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.name = "time_happiness_gift"
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.full_name = ".Cmd.EggData.time_happiness_gift"
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.number = 16
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.index = 15
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.label = 1
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.has_default_value = true
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.default_value = 0
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.type = 13
EGGDATA_TIME_HAPPINESS_GIFT_FIELD.cpp_type = 3
EGGDATA_TOUCH_TICK_FIELD.name = "touch_tick"
EGGDATA_TOUCH_TICK_FIELD.full_name = ".Cmd.EggData.touch_tick"
EGGDATA_TOUCH_TICK_FIELD.number = 22
EGGDATA_TOUCH_TICK_FIELD.index = 16
EGGDATA_TOUCH_TICK_FIELD.label = 1
EGGDATA_TOUCH_TICK_FIELD.has_default_value = true
EGGDATA_TOUCH_TICK_FIELD.default_value = 0
EGGDATA_TOUCH_TICK_FIELD.type = 13
EGGDATA_TOUCH_TICK_FIELD.cpp_type = 3
EGGDATA_FEED_TICK_FIELD.name = "feed_tick"
EGGDATA_FEED_TICK_FIELD.full_name = ".Cmd.EggData.feed_tick"
EGGDATA_FEED_TICK_FIELD.number = 23
EGGDATA_FEED_TICK_FIELD.index = 17
EGGDATA_FEED_TICK_FIELD.label = 1
EGGDATA_FEED_TICK_FIELD.has_default_value = true
EGGDATA_FEED_TICK_FIELD.default_value = 0
EGGDATA_FEED_TICK_FIELD.type = 13
EGGDATA_FEED_TICK_FIELD.cpp_type = 3
EGGDATA_NAME_FIELD.name = "name"
EGGDATA_NAME_FIELD.full_name = ".Cmd.EggData.name"
EGGDATA_NAME_FIELD.number = 17
EGGDATA_NAME_FIELD.index = 18
EGGDATA_NAME_FIELD.label = 1
EGGDATA_NAME_FIELD.has_default_value = false
EGGDATA_NAME_FIELD.default_value = ""
EGGDATA_NAME_FIELD.type = 9
EGGDATA_NAME_FIELD.cpp_type = 9
EGGDATA_VAR_FIELD.name = "var"
EGGDATA_VAR_FIELD.full_name = ".Cmd.EggData.var"
EGGDATA_VAR_FIELD.number = 18
EGGDATA_VAR_FIELD.index = 19
EGGDATA_VAR_FIELD.label = 1
EGGDATA_VAR_FIELD.has_default_value = false
EGGDATA_VAR_FIELD.default_value = ""
EGGDATA_VAR_FIELD.type = 12
EGGDATA_VAR_FIELD.cpp_type = 9
EGGDATA_SKILLIDS_FIELD.name = "skillids"
EGGDATA_SKILLIDS_FIELD.full_name = ".Cmd.EggData.skillids"
EGGDATA_SKILLIDS_FIELD.number = 19
EGGDATA_SKILLIDS_FIELD.index = 20
EGGDATA_SKILLIDS_FIELD.label = 3
EGGDATA_SKILLIDS_FIELD.has_default_value = false
EGGDATA_SKILLIDS_FIELD.default_value = {}
EGGDATA_SKILLIDS_FIELD.type = 13
EGGDATA_SKILLIDS_FIELD.cpp_type = 3
EGGDATA_EQUIPS_FIELD.name = "equips"
EGGDATA_EQUIPS_FIELD.full_name = ".Cmd.EggData.equips"
EGGDATA_EQUIPS_FIELD.number = 20
EGGDATA_EQUIPS_FIELD.index = 21
EGGDATA_EQUIPS_FIELD.label = 3
EGGDATA_EQUIPS_FIELD.has_default_value = false
EGGDATA_EQUIPS_FIELD.default_value = {}
EGGDATA_EQUIPS_FIELD.message_type = EGGEQUIP
EGGDATA_EQUIPS_FIELD.type = 11
EGGDATA_EQUIPS_FIELD.cpp_type = 10
EGGDATA_BUFF_FIELD.name = "buff"
EGGDATA_BUFF_FIELD.full_name = ".Cmd.EggData.buff"
EGGDATA_BUFF_FIELD.number = 21
EGGDATA_BUFF_FIELD.index = 22
EGGDATA_BUFF_FIELD.label = 1
EGGDATA_BUFF_FIELD.has_default_value = false
EGGDATA_BUFF_FIELD.default_value = ""
EGGDATA_BUFF_FIELD.type = 12
EGGDATA_BUFF_FIELD.cpp_type = 9
EGGDATA_UNLOCK_EQUIP_FIELD.name = "unlock_equip"
EGGDATA_UNLOCK_EQUIP_FIELD.full_name = ".Cmd.EggData.unlock_equip"
EGGDATA_UNLOCK_EQUIP_FIELD.number = 24
EGGDATA_UNLOCK_EQUIP_FIELD.index = 23
EGGDATA_UNLOCK_EQUIP_FIELD.label = 3
EGGDATA_UNLOCK_EQUIP_FIELD.has_default_value = false
EGGDATA_UNLOCK_EQUIP_FIELD.default_value = {}
EGGDATA_UNLOCK_EQUIP_FIELD.type = 13
EGGDATA_UNLOCK_EQUIP_FIELD.cpp_type = 3
EGGDATA_UNLOCK_BODY_FIELD.name = "unlock_body"
EGGDATA_UNLOCK_BODY_FIELD.full_name = ".Cmd.EggData.unlock_body"
EGGDATA_UNLOCK_BODY_FIELD.number = 25
EGGDATA_UNLOCK_BODY_FIELD.index = 24
EGGDATA_UNLOCK_BODY_FIELD.label = 3
EGGDATA_UNLOCK_BODY_FIELD.has_default_value = false
EGGDATA_UNLOCK_BODY_FIELD.default_value = {}
EGGDATA_UNLOCK_BODY_FIELD.type = 13
EGGDATA_UNLOCK_BODY_FIELD.cpp_type = 3
EGGDATA_VERSION_FIELD.name = "version"
EGGDATA_VERSION_FIELD.full_name = ".Cmd.EggData.version"
EGGDATA_VERSION_FIELD.number = 26
EGGDATA_VERSION_FIELD.index = 25
EGGDATA_VERSION_FIELD.label = 1
EGGDATA_VERSION_FIELD.has_default_value = true
EGGDATA_VERSION_FIELD.default_value = 0
EGGDATA_VERSION_FIELD.type = 13
EGGDATA_VERSION_FIELD.cpp_type = 3
EGGDATA_SKILLOFF_FIELD.name = "skilloff"
EGGDATA_SKILLOFF_FIELD.full_name = ".Cmd.EggData.skilloff"
EGGDATA_SKILLOFF_FIELD.number = 27
EGGDATA_SKILLOFF_FIELD.index = 26
EGGDATA_SKILLOFF_FIELD.label = 1
EGGDATA_SKILLOFF_FIELD.has_default_value = true
EGGDATA_SKILLOFF_FIELD.default_value = false
EGGDATA_SKILLOFF_FIELD.type = 8
EGGDATA_SKILLOFF_FIELD.cpp_type = 7
EGGDATA_EXCHANGE_COUNT_FIELD.name = "exchange_count"
EGGDATA_EXCHANGE_COUNT_FIELD.full_name = ".Cmd.EggData.exchange_count"
EGGDATA_EXCHANGE_COUNT_FIELD.number = 28
EGGDATA_EXCHANGE_COUNT_FIELD.index = 27
EGGDATA_EXCHANGE_COUNT_FIELD.label = 1
EGGDATA_EXCHANGE_COUNT_FIELD.has_default_value = true
EGGDATA_EXCHANGE_COUNT_FIELD.default_value = 0
EGGDATA_EXCHANGE_COUNT_FIELD.type = 13
EGGDATA_EXCHANGE_COUNT_FIELD.cpp_type = 3
EGGDATA_GUID_FIELD.name = "guid"
EGGDATA_GUID_FIELD.full_name = ".Cmd.EggData.guid"
EGGDATA_GUID_FIELD.number = 29
EGGDATA_GUID_FIELD.index = 28
EGGDATA_GUID_FIELD.label = 1
EGGDATA_GUID_FIELD.has_default_value = false
EGGDATA_GUID_FIELD.default_value = ""
EGGDATA_GUID_FIELD.type = 9
EGGDATA_GUID_FIELD.cpp_type = 9
EGGDATA_DEFAULTWEARS_FIELD.name = "defaultwears"
EGGDATA_DEFAULTWEARS_FIELD.full_name = ".Cmd.EggData.defaultwears"
EGGDATA_DEFAULTWEARS_FIELD.number = 30
EGGDATA_DEFAULTWEARS_FIELD.index = 29
EGGDATA_DEFAULTWEARS_FIELD.label = 3
EGGDATA_DEFAULTWEARS_FIELD.has_default_value = false
EGGDATA_DEFAULTWEARS_FIELD.default_value = {}
EGGDATA_DEFAULTWEARS_FIELD.message_type = PETEQUIPDATA
EGGDATA_DEFAULTWEARS_FIELD.type = 11
EGGDATA_DEFAULTWEARS_FIELD.cpp_type = 10
EGGDATA_WEARS_FIELD.name = "wears"
EGGDATA_WEARS_FIELD.full_name = ".Cmd.EggData.wears"
EGGDATA_WEARS_FIELD.number = 31
EGGDATA_WEARS_FIELD.index = 30
EGGDATA_WEARS_FIELD.label = 3
EGGDATA_WEARS_FIELD.has_default_value = false
EGGDATA_WEARS_FIELD.default_value = {}
EGGDATA_WEARS_FIELD.message_type = PETEQUIPDATA
EGGDATA_WEARS_FIELD.type = 11
EGGDATA_WEARS_FIELD.cpp_type = 10
EGGDATA.name = "EggData"
EGGDATA.full_name = ".Cmd.EggData"
EGGDATA.nested_types = {}
EGGDATA.enum_types = {}
EGGDATA.fields = {
  EGGDATA_EXP_FIELD,
  EGGDATA_FRIENDEXP_FIELD,
  EGGDATA_REWARDEXP_FIELD,
  EGGDATA_ID_FIELD,
  EGGDATA_LV_FIELD,
  EGGDATA_FRIENDLV_FIELD,
  EGGDATA_BODY_FIELD,
  EGGDATA_RELIVETIME_FIELD,
  EGGDATA_HP_FIELD,
  EGGDATA_RESTORETIME_FIELD,
  EGGDATA_TIME_HAPPLY_FIELD,
  EGGDATA_TIME_EXCITE_FIELD,
  EGGDATA_TIME_HAPPINESS_FIELD,
  EGGDATA_TIME_HAPPLY_GIFT_FIELD,
  EGGDATA_TIME_EXCITE_GIFT_FIELD,
  EGGDATA_TIME_HAPPINESS_GIFT_FIELD,
  EGGDATA_TOUCH_TICK_FIELD,
  EGGDATA_FEED_TICK_FIELD,
  EGGDATA_NAME_FIELD,
  EGGDATA_VAR_FIELD,
  EGGDATA_SKILLIDS_FIELD,
  EGGDATA_EQUIPS_FIELD,
  EGGDATA_BUFF_FIELD,
  EGGDATA_UNLOCK_EQUIP_FIELD,
  EGGDATA_UNLOCK_BODY_FIELD,
  EGGDATA_VERSION_FIELD,
  EGGDATA_SKILLOFF_FIELD,
  EGGDATA_EXCHANGE_COUNT_FIELD,
  EGGDATA_GUID_FIELD,
  EGGDATA_DEFAULTWEARS_FIELD,
  EGGDATA_WEARS_FIELD
}
EGGDATA.is_extendable = false
EGGDATA.extensions = {}
LOVELETTERDATA_SENDUSERNAME_FIELD.name = "sendUserName"
LOVELETTERDATA_SENDUSERNAME_FIELD.full_name = ".Cmd.LoveLetterData.sendUserName"
LOVELETTERDATA_SENDUSERNAME_FIELD.number = 1
LOVELETTERDATA_SENDUSERNAME_FIELD.index = 0
LOVELETTERDATA_SENDUSERNAME_FIELD.label = 1
LOVELETTERDATA_SENDUSERNAME_FIELD.has_default_value = false
LOVELETTERDATA_SENDUSERNAME_FIELD.default_value = ""
LOVELETTERDATA_SENDUSERNAME_FIELD.type = 9
LOVELETTERDATA_SENDUSERNAME_FIELD.cpp_type = 9
LOVELETTERDATA_BG_FIELD.name = "bg"
LOVELETTERDATA_BG_FIELD.full_name = ".Cmd.LoveLetterData.bg"
LOVELETTERDATA_BG_FIELD.number = 2
LOVELETTERDATA_BG_FIELD.index = 1
LOVELETTERDATA_BG_FIELD.label = 1
LOVELETTERDATA_BG_FIELD.has_default_value = false
LOVELETTERDATA_BG_FIELD.default_value = ""
LOVELETTERDATA_BG_FIELD.type = 9
LOVELETTERDATA_BG_FIELD.cpp_type = 9
LOVELETTERDATA_CONFIGID_FIELD.name = "configID"
LOVELETTERDATA_CONFIGID_FIELD.full_name = ".Cmd.LoveLetterData.configID"
LOVELETTERDATA_CONFIGID_FIELD.number = 3
LOVELETTERDATA_CONFIGID_FIELD.index = 2
LOVELETTERDATA_CONFIGID_FIELD.label = 1
LOVELETTERDATA_CONFIGID_FIELD.has_default_value = false
LOVELETTERDATA_CONFIGID_FIELD.default_value = 0
LOVELETTERDATA_CONFIGID_FIELD.type = 13
LOVELETTERDATA_CONFIGID_FIELD.cpp_type = 3
LOVELETTERDATA_CONTENT_FIELD.name = "content"
LOVELETTERDATA_CONTENT_FIELD.full_name = ".Cmd.LoveLetterData.content"
LOVELETTERDATA_CONTENT_FIELD.number = 4
LOVELETTERDATA_CONTENT_FIELD.index = 3
LOVELETTERDATA_CONTENT_FIELD.label = 1
LOVELETTERDATA_CONTENT_FIELD.has_default_value = false
LOVELETTERDATA_CONTENT_FIELD.default_value = ""
LOVELETTERDATA_CONTENT_FIELD.type = 9
LOVELETTERDATA_CONTENT_FIELD.cpp_type = 9
LOVELETTERDATA_CONTENT2_FIELD.name = "content2"
LOVELETTERDATA_CONTENT2_FIELD.full_name = ".Cmd.LoveLetterData.content2"
LOVELETTERDATA_CONTENT2_FIELD.number = 5
LOVELETTERDATA_CONTENT2_FIELD.index = 4
LOVELETTERDATA_CONTENT2_FIELD.label = 1
LOVELETTERDATA_CONTENT2_FIELD.has_default_value = false
LOVELETTERDATA_CONTENT2_FIELD.default_value = ""
LOVELETTERDATA_CONTENT2_FIELD.type = 9
LOVELETTERDATA_CONTENT2_FIELD.cpp_type = 9
LOVELETTERDATA.name = "LoveLetterData"
LOVELETTERDATA.full_name = ".Cmd.LoveLetterData"
LOVELETTERDATA.nested_types = {}
LOVELETTERDATA.enum_types = {}
LOVELETTERDATA.fields = {
  LOVELETTERDATA_SENDUSERNAME_FIELD,
  LOVELETTERDATA_BG_FIELD,
  LOVELETTERDATA_CONFIGID_FIELD,
  LOVELETTERDATA_CONTENT_FIELD,
  LOVELETTERDATA_CONTENT2_FIELD
}
LOVELETTERDATA.is_extendable = false
LOVELETTERDATA.extensions = {}
CODEDATA_CODE_FIELD.name = "code"
CODEDATA_CODE_FIELD.full_name = ".Cmd.CodeData.code"
CODEDATA_CODE_FIELD.number = 1
CODEDATA_CODE_FIELD.index = 0
CODEDATA_CODE_FIELD.label = 1
CODEDATA_CODE_FIELD.has_default_value = false
CODEDATA_CODE_FIELD.default_value = ""
CODEDATA_CODE_FIELD.type = 9
CODEDATA_CODE_FIELD.cpp_type = 9
CODEDATA_USED_FIELD.name = "used"
CODEDATA_USED_FIELD.full_name = ".Cmd.CodeData.used"
CODEDATA_USED_FIELD.number = 2
CODEDATA_USED_FIELD.index = 1
CODEDATA_USED_FIELD.label = 1
CODEDATA_USED_FIELD.has_default_value = true
CODEDATA_USED_FIELD.default_value = false
CODEDATA_USED_FIELD.type = 8
CODEDATA_USED_FIELD.cpp_type = 7
CODEDATA.name = "CodeData"
CODEDATA.full_name = ".Cmd.CodeData"
CODEDATA.nested_types = {}
CODEDATA.enum_types = {}
CODEDATA.fields = {
  CODEDATA_CODE_FIELD,
  CODEDATA_USED_FIELD
}
CODEDATA.is_extendable = false
CODEDATA.extensions = {}
WEDDINGDATA_ID_FIELD.name = "id"
WEDDINGDATA_ID_FIELD.full_name = ".Cmd.WeddingData.id"
WEDDINGDATA_ID_FIELD.number = 1
WEDDINGDATA_ID_FIELD.index = 0
WEDDINGDATA_ID_FIELD.label = 1
WEDDINGDATA_ID_FIELD.has_default_value = true
WEDDINGDATA_ID_FIELD.default_value = 0
WEDDINGDATA_ID_FIELD.type = 4
WEDDINGDATA_ID_FIELD.cpp_type = 4
WEDDINGDATA_ZONEID_FIELD.name = "zoneid"
WEDDINGDATA_ZONEID_FIELD.full_name = ".Cmd.WeddingData.zoneid"
WEDDINGDATA_ZONEID_FIELD.number = 2
WEDDINGDATA_ZONEID_FIELD.index = 1
WEDDINGDATA_ZONEID_FIELD.label = 1
WEDDINGDATA_ZONEID_FIELD.has_default_value = true
WEDDINGDATA_ZONEID_FIELD.default_value = 0
WEDDINGDATA_ZONEID_FIELD.type = 13
WEDDINGDATA_ZONEID_FIELD.cpp_type = 3
WEDDINGDATA_CHARID1_FIELD.name = "charid1"
WEDDINGDATA_CHARID1_FIELD.full_name = ".Cmd.WeddingData.charid1"
WEDDINGDATA_CHARID1_FIELD.number = 3
WEDDINGDATA_CHARID1_FIELD.index = 2
WEDDINGDATA_CHARID1_FIELD.label = 1
WEDDINGDATA_CHARID1_FIELD.has_default_value = true
WEDDINGDATA_CHARID1_FIELD.default_value = 0
WEDDINGDATA_CHARID1_FIELD.type = 4
WEDDINGDATA_CHARID1_FIELD.cpp_type = 4
WEDDINGDATA_CHARID2_FIELD.name = "charid2"
WEDDINGDATA_CHARID2_FIELD.full_name = ".Cmd.WeddingData.charid2"
WEDDINGDATA_CHARID2_FIELD.number = 4
WEDDINGDATA_CHARID2_FIELD.index = 3
WEDDINGDATA_CHARID2_FIELD.label = 1
WEDDINGDATA_CHARID2_FIELD.has_default_value = true
WEDDINGDATA_CHARID2_FIELD.default_value = 0
WEDDINGDATA_CHARID2_FIELD.type = 4
WEDDINGDATA_CHARID2_FIELD.cpp_type = 4
WEDDINGDATA_WEDDINGTIME_FIELD.name = "weddingtime"
WEDDINGDATA_WEDDINGTIME_FIELD.full_name = ".Cmd.WeddingData.weddingtime"
WEDDINGDATA_WEDDINGTIME_FIELD.number = 5
WEDDINGDATA_WEDDINGTIME_FIELD.index = 4
WEDDINGDATA_WEDDINGTIME_FIELD.label = 1
WEDDINGDATA_WEDDINGTIME_FIELD.has_default_value = true
WEDDINGDATA_WEDDINGTIME_FIELD.default_value = 0
WEDDINGDATA_WEDDINGTIME_FIELD.type = 13
WEDDINGDATA_WEDDINGTIME_FIELD.cpp_type = 3
WEDDINGDATA_PHOTOIDX_FIELD.name = "photoidx"
WEDDINGDATA_PHOTOIDX_FIELD.full_name = ".Cmd.WeddingData.photoidx"
WEDDINGDATA_PHOTOIDX_FIELD.number = 6
WEDDINGDATA_PHOTOIDX_FIELD.index = 5
WEDDINGDATA_PHOTOIDX_FIELD.label = 1
WEDDINGDATA_PHOTOIDX_FIELD.has_default_value = true
WEDDINGDATA_PHOTOIDX_FIELD.default_value = 0
WEDDINGDATA_PHOTOIDX_FIELD.type = 13
WEDDINGDATA_PHOTOIDX_FIELD.cpp_type = 3
WEDDINGDATA_PHOTOTIME_FIELD.name = "phototime"
WEDDINGDATA_PHOTOTIME_FIELD.full_name = ".Cmd.WeddingData.phototime"
WEDDINGDATA_PHOTOTIME_FIELD.number = 7
WEDDINGDATA_PHOTOTIME_FIELD.index = 6
WEDDINGDATA_PHOTOTIME_FIELD.label = 1
WEDDINGDATA_PHOTOTIME_FIELD.has_default_value = true
WEDDINGDATA_PHOTOTIME_FIELD.default_value = 0
WEDDINGDATA_PHOTOTIME_FIELD.type = 13
WEDDINGDATA_PHOTOTIME_FIELD.cpp_type = 3
WEDDINGDATA_MYNAME_FIELD.name = "myname"
WEDDINGDATA_MYNAME_FIELD.full_name = ".Cmd.WeddingData.myname"
WEDDINGDATA_MYNAME_FIELD.number = 8
WEDDINGDATA_MYNAME_FIELD.index = 7
WEDDINGDATA_MYNAME_FIELD.label = 1
WEDDINGDATA_MYNAME_FIELD.has_default_value = false
WEDDINGDATA_MYNAME_FIELD.default_value = ""
WEDDINGDATA_MYNAME_FIELD.type = 9
WEDDINGDATA_MYNAME_FIELD.cpp_type = 9
WEDDINGDATA_PARTNERNAME_FIELD.name = "partnername"
WEDDINGDATA_PARTNERNAME_FIELD.full_name = ".Cmd.WeddingData.partnername"
WEDDINGDATA_PARTNERNAME_FIELD.number = 9
WEDDINGDATA_PARTNERNAME_FIELD.index = 8
WEDDINGDATA_PARTNERNAME_FIELD.label = 1
WEDDINGDATA_PARTNERNAME_FIELD.has_default_value = false
WEDDINGDATA_PARTNERNAME_FIELD.default_value = ""
WEDDINGDATA_PARTNERNAME_FIELD.type = 9
WEDDINGDATA_PARTNERNAME_FIELD.cpp_type = 9
WEDDINGDATA_STARTTIME_FIELD.name = "starttime"
WEDDINGDATA_STARTTIME_FIELD.full_name = ".Cmd.WeddingData.starttime"
WEDDINGDATA_STARTTIME_FIELD.number = 10
WEDDINGDATA_STARTTIME_FIELD.index = 9
WEDDINGDATA_STARTTIME_FIELD.label = 1
WEDDINGDATA_STARTTIME_FIELD.has_default_value = true
WEDDINGDATA_STARTTIME_FIELD.default_value = 0
WEDDINGDATA_STARTTIME_FIELD.type = 13
WEDDINGDATA_STARTTIME_FIELD.cpp_type = 3
WEDDINGDATA_ENDTIME_FIELD.name = "endtime"
WEDDINGDATA_ENDTIME_FIELD.full_name = ".Cmd.WeddingData.endtime"
WEDDINGDATA_ENDTIME_FIELD.number = 11
WEDDINGDATA_ENDTIME_FIELD.index = 10
WEDDINGDATA_ENDTIME_FIELD.label = 1
WEDDINGDATA_ENDTIME_FIELD.has_default_value = true
WEDDINGDATA_ENDTIME_FIELD.default_value = 0
WEDDINGDATA_ENDTIME_FIELD.type = 13
WEDDINGDATA_ENDTIME_FIELD.cpp_type = 3
WEDDINGDATA_NOTIFIED_FIELD.name = "notified"
WEDDINGDATA_NOTIFIED_FIELD.full_name = ".Cmd.WeddingData.notified"
WEDDINGDATA_NOTIFIED_FIELD.number = 12
WEDDINGDATA_NOTIFIED_FIELD.index = 11
WEDDINGDATA_NOTIFIED_FIELD.label = 1
WEDDINGDATA_NOTIFIED_FIELD.has_default_value = true
WEDDINGDATA_NOTIFIED_FIELD.default_value = false
WEDDINGDATA_NOTIFIED_FIELD.type = 8
WEDDINGDATA_NOTIFIED_FIELD.cpp_type = 7
WEDDINGDATA.name = "WeddingData"
WEDDINGDATA.full_name = ".Cmd.WeddingData"
WEDDINGDATA.nested_types = {}
WEDDINGDATA.enum_types = {}
WEDDINGDATA.fields = {
  WEDDINGDATA_ID_FIELD,
  WEDDINGDATA_ZONEID_FIELD,
  WEDDINGDATA_CHARID1_FIELD,
  WEDDINGDATA_CHARID2_FIELD,
  WEDDINGDATA_WEDDINGTIME_FIELD,
  WEDDINGDATA_PHOTOIDX_FIELD,
  WEDDINGDATA_PHOTOTIME_FIELD,
  WEDDINGDATA_MYNAME_FIELD,
  WEDDINGDATA_PARTNERNAME_FIELD,
  WEDDINGDATA_STARTTIME_FIELD,
  WEDDINGDATA_ENDTIME_FIELD,
  WEDDINGDATA_NOTIFIED_FIELD
}
WEDDINGDATA.is_extendable = false
WEDDINGDATA.extensions = {}
SENDERDATA_CHARID_FIELD.name = "charid"
SENDERDATA_CHARID_FIELD.full_name = ".Cmd.SenderData.charid"
SENDERDATA_CHARID_FIELD.number = 1
SENDERDATA_CHARID_FIELD.index = 0
SENDERDATA_CHARID_FIELD.label = 1
SENDERDATA_CHARID_FIELD.has_default_value = false
SENDERDATA_CHARID_FIELD.default_value = 0
SENDERDATA_CHARID_FIELD.type = 4
SENDERDATA_CHARID_FIELD.cpp_type = 4
SENDERDATA_NAME_FIELD.name = "name"
SENDERDATA_NAME_FIELD.full_name = ".Cmd.SenderData.name"
SENDERDATA_NAME_FIELD.number = 2
SENDERDATA_NAME_FIELD.index = 1
SENDERDATA_NAME_FIELD.label = 1
SENDERDATA_NAME_FIELD.has_default_value = false
SENDERDATA_NAME_FIELD.default_value = ""
SENDERDATA_NAME_FIELD.type = 9
SENDERDATA_NAME_FIELD.cpp_type = 9
SENDERDATA.name = "SenderData"
SENDERDATA.full_name = ".Cmd.SenderData"
SENDERDATA.nested_types = {}
SENDERDATA.enum_types = {}
SENDERDATA.fields = {
  SENDERDATA_CHARID_FIELD,
  SENDERDATA_NAME_FIELD
}
SENDERDATA.is_extendable = false
SENDERDATA.extensions = {}
ITEMDATA_BASE_FIELD.name = "base"
ITEMDATA_BASE_FIELD.full_name = ".Cmd.ItemData.base"
ITEMDATA_BASE_FIELD.number = 1
ITEMDATA_BASE_FIELD.index = 0
ITEMDATA_BASE_FIELD.label = 1
ITEMDATA_BASE_FIELD.has_default_value = false
ITEMDATA_BASE_FIELD.default_value = nil
ITEMDATA_BASE_FIELD.message_type = ITEMINFO
ITEMDATA_BASE_FIELD.type = 11
ITEMDATA_BASE_FIELD.cpp_type = 10
ITEMDATA_EQUIPED_FIELD.name = "equiped"
ITEMDATA_EQUIPED_FIELD.full_name = ".Cmd.ItemData.equiped"
ITEMDATA_EQUIPED_FIELD.number = 2
ITEMDATA_EQUIPED_FIELD.index = 1
ITEMDATA_EQUIPED_FIELD.label = 1
ITEMDATA_EQUIPED_FIELD.has_default_value = true
ITEMDATA_EQUIPED_FIELD.default_value = false
ITEMDATA_EQUIPED_FIELD.type = 8
ITEMDATA_EQUIPED_FIELD.cpp_type = 7
ITEMDATA_BATTLEPOINT_FIELD.name = "battlepoint"
ITEMDATA_BATTLEPOINT_FIELD.full_name = ".Cmd.ItemData.battlepoint"
ITEMDATA_BATTLEPOINT_FIELD.number = 3
ITEMDATA_BATTLEPOINT_FIELD.index = 2
ITEMDATA_BATTLEPOINT_FIELD.label = 1
ITEMDATA_BATTLEPOINT_FIELD.has_default_value = true
ITEMDATA_BATTLEPOINT_FIELD.default_value = 0
ITEMDATA_BATTLEPOINT_FIELD.type = 13
ITEMDATA_BATTLEPOINT_FIELD.cpp_type = 3
ITEMDATA_EQUIP_FIELD.name = "equip"
ITEMDATA_EQUIP_FIELD.full_name = ".Cmd.ItemData.equip"
ITEMDATA_EQUIP_FIELD.number = 4
ITEMDATA_EQUIP_FIELD.index = 3
ITEMDATA_EQUIP_FIELD.label = 1
ITEMDATA_EQUIP_FIELD.has_default_value = false
ITEMDATA_EQUIP_FIELD.default_value = nil
ITEMDATA_EQUIP_FIELD.message_type = EQUIPDATA
ITEMDATA_EQUIP_FIELD.type = 11
ITEMDATA_EQUIP_FIELD.cpp_type = 10
ITEMDATA_CARD_FIELD.name = "card"
ITEMDATA_CARD_FIELD.full_name = ".Cmd.ItemData.card"
ITEMDATA_CARD_FIELD.number = 5
ITEMDATA_CARD_FIELD.index = 4
ITEMDATA_CARD_FIELD.label = 3
ITEMDATA_CARD_FIELD.has_default_value = false
ITEMDATA_CARD_FIELD.default_value = {}
ITEMDATA_CARD_FIELD.message_type = CARDDATA
ITEMDATA_CARD_FIELD.type = 11
ITEMDATA_CARD_FIELD.cpp_type = 10
ITEMDATA_ENCHANT_FIELD.name = "enchant"
ITEMDATA_ENCHANT_FIELD.full_name = ".Cmd.ItemData.enchant"
ITEMDATA_ENCHANT_FIELD.number = 6
ITEMDATA_ENCHANT_FIELD.index = 5
ITEMDATA_ENCHANT_FIELD.label = 1
ITEMDATA_ENCHANT_FIELD.has_default_value = false
ITEMDATA_ENCHANT_FIELD.default_value = nil
ITEMDATA_ENCHANT_FIELD.message_type = ENCHANTDATA
ITEMDATA_ENCHANT_FIELD.type = 11
ITEMDATA_ENCHANT_FIELD.cpp_type = 10
ITEMDATA_PREVIEWENCHANT_FIELD.name = "previewenchant"
ITEMDATA_PREVIEWENCHANT_FIELD.full_name = ".Cmd.ItemData.previewenchant"
ITEMDATA_PREVIEWENCHANT_FIELD.number = 7
ITEMDATA_PREVIEWENCHANT_FIELD.index = 6
ITEMDATA_PREVIEWENCHANT_FIELD.label = 1
ITEMDATA_PREVIEWENCHANT_FIELD.has_default_value = false
ITEMDATA_PREVIEWENCHANT_FIELD.default_value = nil
ITEMDATA_PREVIEWENCHANT_FIELD.message_type = ENCHANTDATA
ITEMDATA_PREVIEWENCHANT_FIELD.type = 11
ITEMDATA_PREVIEWENCHANT_FIELD.cpp_type = 10
ITEMDATA_REFINE_FIELD.name = "refine"
ITEMDATA_REFINE_FIELD.full_name = ".Cmd.ItemData.refine"
ITEMDATA_REFINE_FIELD.number = 8
ITEMDATA_REFINE_FIELD.index = 7
ITEMDATA_REFINE_FIELD.label = 1
ITEMDATA_REFINE_FIELD.has_default_value = false
ITEMDATA_REFINE_FIELD.default_value = nil
ITEMDATA_REFINE_FIELD.message_type = REFINEDATA
ITEMDATA_REFINE_FIELD.type = 11
ITEMDATA_REFINE_FIELD.cpp_type = 10
ITEMDATA_EGG_FIELD.name = "egg"
ITEMDATA_EGG_FIELD.full_name = ".Cmd.ItemData.egg"
ITEMDATA_EGG_FIELD.number = 9
ITEMDATA_EGG_FIELD.index = 8
ITEMDATA_EGG_FIELD.label = 1
ITEMDATA_EGG_FIELD.has_default_value = false
ITEMDATA_EGG_FIELD.default_value = nil
ITEMDATA_EGG_FIELD.message_type = EGGDATA
ITEMDATA_EGG_FIELD.type = 11
ITEMDATA_EGG_FIELD.cpp_type = 10
ITEMDATA_LETTER_FIELD.name = "letter"
ITEMDATA_LETTER_FIELD.full_name = ".Cmd.ItemData.letter"
ITEMDATA_LETTER_FIELD.number = 10
ITEMDATA_LETTER_FIELD.index = 9
ITEMDATA_LETTER_FIELD.label = 1
ITEMDATA_LETTER_FIELD.has_default_value = false
ITEMDATA_LETTER_FIELD.default_value = nil
ITEMDATA_LETTER_FIELD.message_type = LOVELETTERDATA
ITEMDATA_LETTER_FIELD.type = 11
ITEMDATA_LETTER_FIELD.cpp_type = 10
ITEMDATA_CODE_FIELD.name = "code"
ITEMDATA_CODE_FIELD.full_name = ".Cmd.ItemData.code"
ITEMDATA_CODE_FIELD.number = 11
ITEMDATA_CODE_FIELD.index = 10
ITEMDATA_CODE_FIELD.label = 1
ITEMDATA_CODE_FIELD.has_default_value = false
ITEMDATA_CODE_FIELD.default_value = nil
ITEMDATA_CODE_FIELD.message_type = CODEDATA
ITEMDATA_CODE_FIELD.type = 11
ITEMDATA_CODE_FIELD.cpp_type = 10
ITEMDATA_WEDDING_FIELD.name = "wedding"
ITEMDATA_WEDDING_FIELD.full_name = ".Cmd.ItemData.wedding"
ITEMDATA_WEDDING_FIELD.number = 12
ITEMDATA_WEDDING_FIELD.index = 11
ITEMDATA_WEDDING_FIELD.label = 1
ITEMDATA_WEDDING_FIELD.has_default_value = false
ITEMDATA_WEDDING_FIELD.default_value = nil
ITEMDATA_WEDDING_FIELD.message_type = WEDDINGDATA
ITEMDATA_WEDDING_FIELD.type = 11
ITEMDATA_WEDDING_FIELD.cpp_type = 10
ITEMDATA_SENDER_FIELD.name = "sender"
ITEMDATA_SENDER_FIELD.full_name = ".Cmd.ItemData.sender"
ITEMDATA_SENDER_FIELD.number = 13
ITEMDATA_SENDER_FIELD.index = 12
ITEMDATA_SENDER_FIELD.label = 1
ITEMDATA_SENDER_FIELD.has_default_value = false
ITEMDATA_SENDER_FIELD.default_value = nil
ITEMDATA_SENDER_FIELD.message_type = SENDERDATA
ITEMDATA_SENDER_FIELD.type = 11
ITEMDATA_SENDER_FIELD.cpp_type = 10
ITEMDATA.name = "ItemData"
ITEMDATA.full_name = ".Cmd.ItemData"
ITEMDATA.nested_types = {}
ITEMDATA.enum_types = {}
ITEMDATA.fields = {
  ITEMDATA_BASE_FIELD,
  ITEMDATA_EQUIPED_FIELD,
  ITEMDATA_BATTLEPOINT_FIELD,
  ITEMDATA_EQUIP_FIELD,
  ITEMDATA_CARD_FIELD,
  ITEMDATA_ENCHANT_FIELD,
  ITEMDATA_PREVIEWENCHANT_FIELD,
  ITEMDATA_REFINE_FIELD,
  ITEMDATA_EGG_FIELD,
  ITEMDATA_LETTER_FIELD,
  ITEMDATA_CODE_FIELD,
  ITEMDATA_WEDDING_FIELD,
  ITEMDATA_SENDER_FIELD
}
ITEMDATA.is_extendable = false
ITEMDATA.extensions = {}
PACKAGEITEM_CMD_FIELD.name = "cmd"
PACKAGEITEM_CMD_FIELD.full_name = ".Cmd.PackageItem.cmd"
PACKAGEITEM_CMD_FIELD.number = 1
PACKAGEITEM_CMD_FIELD.index = 0
PACKAGEITEM_CMD_FIELD.label = 1
PACKAGEITEM_CMD_FIELD.has_default_value = true
PACKAGEITEM_CMD_FIELD.default_value = 6
PACKAGEITEM_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PACKAGEITEM_CMD_FIELD.type = 14
PACKAGEITEM_CMD_FIELD.cpp_type = 8
PACKAGEITEM_PARAM_FIELD.name = "param"
PACKAGEITEM_PARAM_FIELD.full_name = ".Cmd.PackageItem.param"
PACKAGEITEM_PARAM_FIELD.number = 2
PACKAGEITEM_PARAM_FIELD.index = 1
PACKAGEITEM_PARAM_FIELD.label = 1
PACKAGEITEM_PARAM_FIELD.has_default_value = true
PACKAGEITEM_PARAM_FIELD.default_value = 1
PACKAGEITEM_PARAM_FIELD.enum_type = ITEMPARAM
PACKAGEITEM_PARAM_FIELD.type = 14
PACKAGEITEM_PARAM_FIELD.cpp_type = 8
PACKAGEITEM_TYPE_FIELD.name = "type"
PACKAGEITEM_TYPE_FIELD.full_name = ".Cmd.PackageItem.type"
PACKAGEITEM_TYPE_FIELD.number = 3
PACKAGEITEM_TYPE_FIELD.index = 2
PACKAGEITEM_TYPE_FIELD.label = 1
PACKAGEITEM_TYPE_FIELD.has_default_value = true
PACKAGEITEM_TYPE_FIELD.default_value = 0
PACKAGEITEM_TYPE_FIELD.enum_type = EPACKTYPE
PACKAGEITEM_TYPE_FIELD.type = 14
PACKAGEITEM_TYPE_FIELD.cpp_type = 8
PACKAGEITEM_DATA_FIELD.name = "data"
PACKAGEITEM_DATA_FIELD.full_name = ".Cmd.PackageItem.data"
PACKAGEITEM_DATA_FIELD.number = 4
PACKAGEITEM_DATA_FIELD.index = 3
PACKAGEITEM_DATA_FIELD.label = 3
PACKAGEITEM_DATA_FIELD.has_default_value = false
PACKAGEITEM_DATA_FIELD.default_value = {}
PACKAGEITEM_DATA_FIELD.message_type = ITEMDATA
PACKAGEITEM_DATA_FIELD.type = 11
PACKAGEITEM_DATA_FIELD.cpp_type = 10
PACKAGEITEM_MAXSLOT_FIELD.name = "maxslot"
PACKAGEITEM_MAXSLOT_FIELD.full_name = ".Cmd.PackageItem.maxslot"
PACKAGEITEM_MAXSLOT_FIELD.number = 5
PACKAGEITEM_MAXSLOT_FIELD.index = 4
PACKAGEITEM_MAXSLOT_FIELD.label = 1
PACKAGEITEM_MAXSLOT_FIELD.has_default_value = true
PACKAGEITEM_MAXSLOT_FIELD.default_value = 0
PACKAGEITEM_MAXSLOT_FIELD.type = 13
PACKAGEITEM_MAXSLOT_FIELD.cpp_type = 3
PACKAGEITEM.name = "PackageItem"
PACKAGEITEM.full_name = ".Cmd.PackageItem"
PACKAGEITEM.nested_types = {}
PACKAGEITEM.enum_types = {}
PACKAGEITEM.fields = {
  PACKAGEITEM_CMD_FIELD,
  PACKAGEITEM_PARAM_FIELD,
  PACKAGEITEM_TYPE_FIELD,
  PACKAGEITEM_DATA_FIELD,
  PACKAGEITEM_MAXSLOT_FIELD
}
PACKAGEITEM.is_extendable = false
PACKAGEITEM.extensions = {}
PACKAGEUPDATE_CMD_FIELD.name = "cmd"
PACKAGEUPDATE_CMD_FIELD.full_name = ".Cmd.PackageUpdate.cmd"
PACKAGEUPDATE_CMD_FIELD.number = 1
PACKAGEUPDATE_CMD_FIELD.index = 0
PACKAGEUPDATE_CMD_FIELD.label = 1
PACKAGEUPDATE_CMD_FIELD.has_default_value = true
PACKAGEUPDATE_CMD_FIELD.default_value = 6
PACKAGEUPDATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PACKAGEUPDATE_CMD_FIELD.type = 14
PACKAGEUPDATE_CMD_FIELD.cpp_type = 8
PACKAGEUPDATE_PARAM_FIELD.name = "param"
PACKAGEUPDATE_PARAM_FIELD.full_name = ".Cmd.PackageUpdate.param"
PACKAGEUPDATE_PARAM_FIELD.number = 2
PACKAGEUPDATE_PARAM_FIELD.index = 1
PACKAGEUPDATE_PARAM_FIELD.label = 1
PACKAGEUPDATE_PARAM_FIELD.has_default_value = true
PACKAGEUPDATE_PARAM_FIELD.default_value = 2
PACKAGEUPDATE_PARAM_FIELD.enum_type = ITEMPARAM
PACKAGEUPDATE_PARAM_FIELD.type = 14
PACKAGEUPDATE_PARAM_FIELD.cpp_type = 8
PACKAGEUPDATE_TYPE_FIELD.name = "type"
PACKAGEUPDATE_TYPE_FIELD.full_name = ".Cmd.PackageUpdate.type"
PACKAGEUPDATE_TYPE_FIELD.number = 3
PACKAGEUPDATE_TYPE_FIELD.index = 2
PACKAGEUPDATE_TYPE_FIELD.label = 1
PACKAGEUPDATE_TYPE_FIELD.has_default_value = true
PACKAGEUPDATE_TYPE_FIELD.default_value = 0
PACKAGEUPDATE_TYPE_FIELD.enum_type = EPACKTYPE
PACKAGEUPDATE_TYPE_FIELD.type = 14
PACKAGEUPDATE_TYPE_FIELD.cpp_type = 8
PACKAGEUPDATE_UPDATEITEMS_FIELD.name = "updateItems"
PACKAGEUPDATE_UPDATEITEMS_FIELD.full_name = ".Cmd.PackageUpdate.updateItems"
PACKAGEUPDATE_UPDATEITEMS_FIELD.number = 4
PACKAGEUPDATE_UPDATEITEMS_FIELD.index = 3
PACKAGEUPDATE_UPDATEITEMS_FIELD.label = 3
PACKAGEUPDATE_UPDATEITEMS_FIELD.has_default_value = false
PACKAGEUPDATE_UPDATEITEMS_FIELD.default_value = {}
PACKAGEUPDATE_UPDATEITEMS_FIELD.message_type = ITEMDATA
PACKAGEUPDATE_UPDATEITEMS_FIELD.type = 11
PACKAGEUPDATE_UPDATEITEMS_FIELD.cpp_type = 10
PACKAGEUPDATE_DELITEMS_FIELD.name = "delItems"
PACKAGEUPDATE_DELITEMS_FIELD.full_name = ".Cmd.PackageUpdate.delItems"
PACKAGEUPDATE_DELITEMS_FIELD.number = 5
PACKAGEUPDATE_DELITEMS_FIELD.index = 4
PACKAGEUPDATE_DELITEMS_FIELD.label = 3
PACKAGEUPDATE_DELITEMS_FIELD.has_default_value = false
PACKAGEUPDATE_DELITEMS_FIELD.default_value = {}
PACKAGEUPDATE_DELITEMS_FIELD.message_type = ITEMDATA
PACKAGEUPDATE_DELITEMS_FIELD.type = 11
PACKAGEUPDATE_DELITEMS_FIELD.cpp_type = 10
PACKAGEUPDATE.name = "PackageUpdate"
PACKAGEUPDATE.full_name = ".Cmd.PackageUpdate"
PACKAGEUPDATE.nested_types = {}
PACKAGEUPDATE.enum_types = {}
PACKAGEUPDATE.fields = {
  PACKAGEUPDATE_CMD_FIELD,
  PACKAGEUPDATE_PARAM_FIELD,
  PACKAGEUPDATE_TYPE_FIELD,
  PACKAGEUPDATE_UPDATEITEMS_FIELD,
  PACKAGEUPDATE_DELITEMS_FIELD
}
PACKAGEUPDATE.is_extendable = false
PACKAGEUPDATE.extensions = {}
ITEMUSE_CMD_FIELD.name = "cmd"
ITEMUSE_CMD_FIELD.full_name = ".Cmd.ItemUse.cmd"
ITEMUSE_CMD_FIELD.number = 1
ITEMUSE_CMD_FIELD.index = 0
ITEMUSE_CMD_FIELD.label = 1
ITEMUSE_CMD_FIELD.has_default_value = true
ITEMUSE_CMD_FIELD.default_value = 6
ITEMUSE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ITEMUSE_CMD_FIELD.type = 14
ITEMUSE_CMD_FIELD.cpp_type = 8
ITEMUSE_PARAM_FIELD.name = "param"
ITEMUSE_PARAM_FIELD.full_name = ".Cmd.ItemUse.param"
ITEMUSE_PARAM_FIELD.number = 2
ITEMUSE_PARAM_FIELD.index = 1
ITEMUSE_PARAM_FIELD.label = 1
ITEMUSE_PARAM_FIELD.has_default_value = true
ITEMUSE_PARAM_FIELD.default_value = 3
ITEMUSE_PARAM_FIELD.enum_type = ITEMPARAM
ITEMUSE_PARAM_FIELD.type = 14
ITEMUSE_PARAM_FIELD.cpp_type = 8
ITEMUSE_ITEMGUID_FIELD.name = "itemguid"
ITEMUSE_ITEMGUID_FIELD.full_name = ".Cmd.ItemUse.itemguid"
ITEMUSE_ITEMGUID_FIELD.number = 3
ITEMUSE_ITEMGUID_FIELD.index = 2
ITEMUSE_ITEMGUID_FIELD.label = 1
ITEMUSE_ITEMGUID_FIELD.has_default_value = false
ITEMUSE_ITEMGUID_FIELD.default_value = ""
ITEMUSE_ITEMGUID_FIELD.type = 9
ITEMUSE_ITEMGUID_FIELD.cpp_type = 9
ITEMUSE_TARGETS_FIELD.name = "targets"
ITEMUSE_TARGETS_FIELD.full_name = ".Cmd.ItemUse.targets"
ITEMUSE_TARGETS_FIELD.number = 4
ITEMUSE_TARGETS_FIELD.index = 3
ITEMUSE_TARGETS_FIELD.label = 3
ITEMUSE_TARGETS_FIELD.has_default_value = false
ITEMUSE_TARGETS_FIELD.default_value = {}
ITEMUSE_TARGETS_FIELD.type = 4
ITEMUSE_TARGETS_FIELD.cpp_type = 4
ITEMUSE_COUNT_FIELD.name = "count"
ITEMUSE_COUNT_FIELD.full_name = ".Cmd.ItemUse.count"
ITEMUSE_COUNT_FIELD.number = 5
ITEMUSE_COUNT_FIELD.index = 4
ITEMUSE_COUNT_FIELD.label = 1
ITEMUSE_COUNT_FIELD.has_default_value = false
ITEMUSE_COUNT_FIELD.default_value = 0
ITEMUSE_COUNT_FIELD.type = 13
ITEMUSE_COUNT_FIELD.cpp_type = 3
ITEMUSE.name = "ItemUse"
ITEMUSE.full_name = ".Cmd.ItemUse"
ITEMUSE.nested_types = {}
ITEMUSE.enum_types = {}
ITEMUSE.fields = {
  ITEMUSE_CMD_FIELD,
  ITEMUSE_PARAM_FIELD,
  ITEMUSE_ITEMGUID_FIELD,
  ITEMUSE_TARGETS_FIELD,
  ITEMUSE_COUNT_FIELD
}
ITEMUSE.is_extendable = false
ITEMUSE.extensions = {}
SORTINFO_GUID_FIELD.name = "guid"
SORTINFO_GUID_FIELD.full_name = ".Cmd.SortInfo.guid"
SORTINFO_GUID_FIELD.number = 1
SORTINFO_GUID_FIELD.index = 0
SORTINFO_GUID_FIELD.label = 1
SORTINFO_GUID_FIELD.has_default_value = false
SORTINFO_GUID_FIELD.default_value = ""
SORTINFO_GUID_FIELD.type = 9
SORTINFO_GUID_FIELD.cpp_type = 9
SORTINFO_INDEX_FIELD.name = "index"
SORTINFO_INDEX_FIELD.full_name = ".Cmd.SortInfo.index"
SORTINFO_INDEX_FIELD.number = 2
SORTINFO_INDEX_FIELD.index = 1
SORTINFO_INDEX_FIELD.label = 1
SORTINFO_INDEX_FIELD.has_default_value = true
SORTINFO_INDEX_FIELD.default_value = 0
SORTINFO_INDEX_FIELD.type = 13
SORTINFO_INDEX_FIELD.cpp_type = 3
SORTINFO.name = "SortInfo"
SORTINFO.full_name = ".Cmd.SortInfo"
SORTINFO.nested_types = {}
SORTINFO.enum_types = {}
SORTINFO.fields = {
  SORTINFO_GUID_FIELD,
  SORTINFO_INDEX_FIELD
}
SORTINFO.is_extendable = false
SORTINFO.extensions = {}
PACKAGESORT_CMD_FIELD.name = "cmd"
PACKAGESORT_CMD_FIELD.full_name = ".Cmd.PackageSort.cmd"
PACKAGESORT_CMD_FIELD.number = 1
PACKAGESORT_CMD_FIELD.index = 0
PACKAGESORT_CMD_FIELD.label = 1
PACKAGESORT_CMD_FIELD.has_default_value = true
PACKAGESORT_CMD_FIELD.default_value = 6
PACKAGESORT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PACKAGESORT_CMD_FIELD.type = 14
PACKAGESORT_CMD_FIELD.cpp_type = 8
PACKAGESORT_PARAM_FIELD.name = "param"
PACKAGESORT_PARAM_FIELD.full_name = ".Cmd.PackageSort.param"
PACKAGESORT_PARAM_FIELD.number = 2
PACKAGESORT_PARAM_FIELD.index = 1
PACKAGESORT_PARAM_FIELD.label = 1
PACKAGESORT_PARAM_FIELD.has_default_value = true
PACKAGESORT_PARAM_FIELD.default_value = 4
PACKAGESORT_PARAM_FIELD.enum_type = ITEMPARAM
PACKAGESORT_PARAM_FIELD.type = 14
PACKAGESORT_PARAM_FIELD.cpp_type = 8
PACKAGESORT_TYPE_FIELD.name = "type"
PACKAGESORT_TYPE_FIELD.full_name = ".Cmd.PackageSort.type"
PACKAGESORT_TYPE_FIELD.number = 3
PACKAGESORT_TYPE_FIELD.index = 2
PACKAGESORT_TYPE_FIELD.label = 1
PACKAGESORT_TYPE_FIELD.has_default_value = true
PACKAGESORT_TYPE_FIELD.default_value = 0
PACKAGESORT_TYPE_FIELD.enum_type = EPACKTYPE
PACKAGESORT_TYPE_FIELD.type = 14
PACKAGESORT_TYPE_FIELD.cpp_type = 8
PACKAGESORT_ITEM_FIELD.name = "item"
PACKAGESORT_ITEM_FIELD.full_name = ".Cmd.PackageSort.item"
PACKAGESORT_ITEM_FIELD.number = 4
PACKAGESORT_ITEM_FIELD.index = 3
PACKAGESORT_ITEM_FIELD.label = 3
PACKAGESORT_ITEM_FIELD.has_default_value = false
PACKAGESORT_ITEM_FIELD.default_value = {}
PACKAGESORT_ITEM_FIELD.message_type = SORTINFO
PACKAGESORT_ITEM_FIELD.type = 11
PACKAGESORT_ITEM_FIELD.cpp_type = 10
PACKAGESORT.name = "PackageSort"
PACKAGESORT.full_name = ".Cmd.PackageSort"
PACKAGESORT.nested_types = {}
PACKAGESORT.enum_types = {}
PACKAGESORT.fields = {
  PACKAGESORT_CMD_FIELD,
  PACKAGESORT_PARAM_FIELD,
  PACKAGESORT_TYPE_FIELD,
  PACKAGESORT_ITEM_FIELD
}
PACKAGESORT.is_extendable = false
PACKAGESORT.extensions = {}
EQUIP_CMD_FIELD.name = "cmd"
EQUIP_CMD_FIELD.full_name = ".Cmd.Equip.cmd"
EQUIP_CMD_FIELD.number = 1
EQUIP_CMD_FIELD.index = 0
EQUIP_CMD_FIELD.label = 1
EQUIP_CMD_FIELD.has_default_value = true
EQUIP_CMD_FIELD.default_value = 6
EQUIP_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIP_CMD_FIELD.type = 14
EQUIP_CMD_FIELD.cpp_type = 8
EQUIP_PARAM_FIELD.name = "param"
EQUIP_PARAM_FIELD.full_name = ".Cmd.Equip.param"
EQUIP_PARAM_FIELD.number = 2
EQUIP_PARAM_FIELD.index = 1
EQUIP_PARAM_FIELD.label = 1
EQUIP_PARAM_FIELD.has_default_value = true
EQUIP_PARAM_FIELD.default_value = 5
EQUIP_PARAM_FIELD.enum_type = ITEMPARAM
EQUIP_PARAM_FIELD.type = 14
EQUIP_PARAM_FIELD.cpp_type = 8
EQUIP_OPER_FIELD.name = "oper"
EQUIP_OPER_FIELD.full_name = ".Cmd.Equip.oper"
EQUIP_OPER_FIELD.number = 3
EQUIP_OPER_FIELD.index = 2
EQUIP_OPER_FIELD.label = 1
EQUIP_OPER_FIELD.has_default_value = true
EQUIP_OPER_FIELD.default_value = 0
EQUIP_OPER_FIELD.enum_type = EEQUIPOPER
EQUIP_OPER_FIELD.type = 14
EQUIP_OPER_FIELD.cpp_type = 8
EQUIP_POS_FIELD.name = "pos"
EQUIP_POS_FIELD.full_name = ".Cmd.Equip.pos"
EQUIP_POS_FIELD.number = 4
EQUIP_POS_FIELD.index = 3
EQUIP_POS_FIELD.label = 1
EQUIP_POS_FIELD.has_default_value = true
EQUIP_POS_FIELD.default_value = 0
EQUIP_POS_FIELD.enum_type = EEQUIPPOS
EQUIP_POS_FIELD.type = 14
EQUIP_POS_FIELD.cpp_type = 8
EQUIP_GUID_FIELD.name = "guid"
EQUIP_GUID_FIELD.full_name = ".Cmd.Equip.guid"
EQUIP_GUID_FIELD.number = 5
EQUIP_GUID_FIELD.index = 4
EQUIP_GUID_FIELD.label = 1
EQUIP_GUID_FIELD.has_default_value = false
EQUIP_GUID_FIELD.default_value = ""
EQUIP_GUID_FIELD.type = 9
EQUIP_GUID_FIELD.cpp_type = 9
EQUIP_TRANSFER_FIELD.name = "transfer"
EQUIP_TRANSFER_FIELD.full_name = ".Cmd.Equip.transfer"
EQUIP_TRANSFER_FIELD.number = 6
EQUIP_TRANSFER_FIELD.index = 5
EQUIP_TRANSFER_FIELD.label = 1
EQUIP_TRANSFER_FIELD.has_default_value = true
EQUIP_TRANSFER_FIELD.default_value = false
EQUIP_TRANSFER_FIELD.type = 8
EQUIP_TRANSFER_FIELD.cpp_type = 7
EQUIP_COUNT_FIELD.name = "count"
EQUIP_COUNT_FIELD.full_name = ".Cmd.Equip.count"
EQUIP_COUNT_FIELD.number = 7
EQUIP_COUNT_FIELD.index = 6
EQUIP_COUNT_FIELD.label = 1
EQUIP_COUNT_FIELD.has_default_value = true
EQUIP_COUNT_FIELD.default_value = 0
EQUIP_COUNT_FIELD.type = 13
EQUIP_COUNT_FIELD.cpp_type = 3
EQUIP.name = "Equip"
EQUIP.full_name = ".Cmd.Equip"
EQUIP.nested_types = {}
EQUIP.enum_types = {}
EQUIP.fields = {
  EQUIP_CMD_FIELD,
  EQUIP_PARAM_FIELD,
  EQUIP_OPER_FIELD,
  EQUIP_POS_FIELD,
  EQUIP_GUID_FIELD,
  EQUIP_TRANSFER_FIELD,
  EQUIP_COUNT_FIELD
}
EQUIP.is_extendable = false
EQUIP.extensions = {}
SITEM_GUID_FIELD.name = "guid"
SITEM_GUID_FIELD.full_name = ".Cmd.SItem.guid"
SITEM_GUID_FIELD.number = 1
SITEM_GUID_FIELD.index = 0
SITEM_GUID_FIELD.label = 1
SITEM_GUID_FIELD.has_default_value = false
SITEM_GUID_FIELD.default_value = ""
SITEM_GUID_FIELD.type = 9
SITEM_GUID_FIELD.cpp_type = 9
SITEM_COUNT_FIELD.name = "count"
SITEM_COUNT_FIELD.full_name = ".Cmd.SItem.count"
SITEM_COUNT_FIELD.number = 2
SITEM_COUNT_FIELD.index = 1
SITEM_COUNT_FIELD.label = 1
SITEM_COUNT_FIELD.has_default_value = true
SITEM_COUNT_FIELD.default_value = 0
SITEM_COUNT_FIELD.type = 13
SITEM_COUNT_FIELD.cpp_type = 3
SITEM.name = "SItem"
SITEM.full_name = ".Cmd.SItem"
SITEM.nested_types = {}
SITEM.enum_types = {}
SITEM.fields = {
  SITEM_GUID_FIELD,
  SITEM_COUNT_FIELD
}
SITEM.is_extendable = false
SITEM.extensions = {}
SELLITEM_CMD_FIELD.name = "cmd"
SELLITEM_CMD_FIELD.full_name = ".Cmd.SellItem.cmd"
SELLITEM_CMD_FIELD.number = 1
SELLITEM_CMD_FIELD.index = 0
SELLITEM_CMD_FIELD.label = 1
SELLITEM_CMD_FIELD.has_default_value = true
SELLITEM_CMD_FIELD.default_value = 6
SELLITEM_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SELLITEM_CMD_FIELD.type = 14
SELLITEM_CMD_FIELD.cpp_type = 8
SELLITEM_PARAM_FIELD.name = "param"
SELLITEM_PARAM_FIELD.full_name = ".Cmd.SellItem.param"
SELLITEM_PARAM_FIELD.number = 2
SELLITEM_PARAM_FIELD.index = 1
SELLITEM_PARAM_FIELD.label = 1
SELLITEM_PARAM_FIELD.has_default_value = true
SELLITEM_PARAM_FIELD.default_value = 6
SELLITEM_PARAM_FIELD.enum_type = ITEMPARAM
SELLITEM_PARAM_FIELD.type = 14
SELLITEM_PARAM_FIELD.cpp_type = 8
SELLITEM_NPCID_FIELD.name = "npcid"
SELLITEM_NPCID_FIELD.full_name = ".Cmd.SellItem.npcid"
SELLITEM_NPCID_FIELD.number = 3
SELLITEM_NPCID_FIELD.index = 2
SELLITEM_NPCID_FIELD.label = 1
SELLITEM_NPCID_FIELD.has_default_value = true
SELLITEM_NPCID_FIELD.default_value = 0
SELLITEM_NPCID_FIELD.type = 4
SELLITEM_NPCID_FIELD.cpp_type = 4
SELLITEM_ITEMS_FIELD.name = "items"
SELLITEM_ITEMS_FIELD.full_name = ".Cmd.SellItem.items"
SELLITEM_ITEMS_FIELD.number = 4
SELLITEM_ITEMS_FIELD.index = 3
SELLITEM_ITEMS_FIELD.label = 3
SELLITEM_ITEMS_FIELD.has_default_value = false
SELLITEM_ITEMS_FIELD.default_value = {}
SELLITEM_ITEMS_FIELD.message_type = SITEM
SELLITEM_ITEMS_FIELD.type = 11
SELLITEM_ITEMS_FIELD.cpp_type = 10
SELLITEM.name = "SellItem"
SELLITEM.full_name = ".Cmd.SellItem"
SELLITEM.nested_types = {}
SELLITEM.enum_types = {}
SELLITEM.fields = {
  SELLITEM_CMD_FIELD,
  SELLITEM_PARAM_FIELD,
  SELLITEM_NPCID_FIELD,
  SELLITEM_ITEMS_FIELD
}
SELLITEM.is_extendable = false
SELLITEM.extensions = {}
EQUIPSTRENGTH_CMD_FIELD.name = "cmd"
EQUIPSTRENGTH_CMD_FIELD.full_name = ".Cmd.EquipStrength.cmd"
EQUIPSTRENGTH_CMD_FIELD.number = 1
EQUIPSTRENGTH_CMD_FIELD.index = 0
EQUIPSTRENGTH_CMD_FIELD.label = 1
EQUIPSTRENGTH_CMD_FIELD.has_default_value = true
EQUIPSTRENGTH_CMD_FIELD.default_value = 6
EQUIPSTRENGTH_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIPSTRENGTH_CMD_FIELD.type = 14
EQUIPSTRENGTH_CMD_FIELD.cpp_type = 8
EQUIPSTRENGTH_PARAM_FIELD.name = "param"
EQUIPSTRENGTH_PARAM_FIELD.full_name = ".Cmd.EquipStrength.param"
EQUIPSTRENGTH_PARAM_FIELD.number = 2
EQUIPSTRENGTH_PARAM_FIELD.index = 1
EQUIPSTRENGTH_PARAM_FIELD.label = 1
EQUIPSTRENGTH_PARAM_FIELD.has_default_value = true
EQUIPSTRENGTH_PARAM_FIELD.default_value = 7
EQUIPSTRENGTH_PARAM_FIELD.enum_type = ITEMPARAM
EQUIPSTRENGTH_PARAM_FIELD.type = 14
EQUIPSTRENGTH_PARAM_FIELD.cpp_type = 8
EQUIPSTRENGTH_GUID_FIELD.name = "guid"
EQUIPSTRENGTH_GUID_FIELD.full_name = ".Cmd.EquipStrength.guid"
EQUIPSTRENGTH_GUID_FIELD.number = 3
EQUIPSTRENGTH_GUID_FIELD.index = 2
EQUIPSTRENGTH_GUID_FIELD.label = 1
EQUIPSTRENGTH_GUID_FIELD.has_default_value = false
EQUIPSTRENGTH_GUID_FIELD.default_value = ""
EQUIPSTRENGTH_GUID_FIELD.type = 9
EQUIPSTRENGTH_GUID_FIELD.cpp_type = 9
EQUIPSTRENGTH_DESTCOUNT_FIELD.name = "destcount"
EQUIPSTRENGTH_DESTCOUNT_FIELD.full_name = ".Cmd.EquipStrength.destcount"
EQUIPSTRENGTH_DESTCOUNT_FIELD.number = 4
EQUIPSTRENGTH_DESTCOUNT_FIELD.index = 3
EQUIPSTRENGTH_DESTCOUNT_FIELD.label = 1
EQUIPSTRENGTH_DESTCOUNT_FIELD.has_default_value = true
EQUIPSTRENGTH_DESTCOUNT_FIELD.default_value = 0
EQUIPSTRENGTH_DESTCOUNT_FIELD.type = 13
EQUIPSTRENGTH_DESTCOUNT_FIELD.cpp_type = 3
EQUIPSTRENGTH_COUNT_FIELD.name = "count"
EQUIPSTRENGTH_COUNT_FIELD.full_name = ".Cmd.EquipStrength.count"
EQUIPSTRENGTH_COUNT_FIELD.number = 5
EQUIPSTRENGTH_COUNT_FIELD.index = 4
EQUIPSTRENGTH_COUNT_FIELD.label = 1
EQUIPSTRENGTH_COUNT_FIELD.has_default_value = true
EQUIPSTRENGTH_COUNT_FIELD.default_value = 0
EQUIPSTRENGTH_COUNT_FIELD.type = 13
EQUIPSTRENGTH_COUNT_FIELD.cpp_type = 3
EQUIPSTRENGTH_CRICOUNT_FIELD.name = "cricount"
EQUIPSTRENGTH_CRICOUNT_FIELD.full_name = ".Cmd.EquipStrength.cricount"
EQUIPSTRENGTH_CRICOUNT_FIELD.number = 6
EQUIPSTRENGTH_CRICOUNT_FIELD.index = 5
EQUIPSTRENGTH_CRICOUNT_FIELD.label = 1
EQUIPSTRENGTH_CRICOUNT_FIELD.has_default_value = true
EQUIPSTRENGTH_CRICOUNT_FIELD.default_value = 0
EQUIPSTRENGTH_CRICOUNT_FIELD.type = 13
EQUIPSTRENGTH_CRICOUNT_FIELD.cpp_type = 3
EQUIPSTRENGTH_OLDLV_FIELD.name = "oldlv"
EQUIPSTRENGTH_OLDLV_FIELD.full_name = ".Cmd.EquipStrength.oldlv"
EQUIPSTRENGTH_OLDLV_FIELD.number = 7
EQUIPSTRENGTH_OLDLV_FIELD.index = 6
EQUIPSTRENGTH_OLDLV_FIELD.label = 1
EQUIPSTRENGTH_OLDLV_FIELD.has_default_value = true
EQUIPSTRENGTH_OLDLV_FIELD.default_value = 0
EQUIPSTRENGTH_OLDLV_FIELD.type = 13
EQUIPSTRENGTH_OLDLV_FIELD.cpp_type = 3
EQUIPSTRENGTH_NEWLV_FIELD.name = "newlv"
EQUIPSTRENGTH_NEWLV_FIELD.full_name = ".Cmd.EquipStrength.newlv"
EQUIPSTRENGTH_NEWLV_FIELD.number = 8
EQUIPSTRENGTH_NEWLV_FIELD.index = 7
EQUIPSTRENGTH_NEWLV_FIELD.label = 1
EQUIPSTRENGTH_NEWLV_FIELD.has_default_value = true
EQUIPSTRENGTH_NEWLV_FIELD.default_value = 0
EQUIPSTRENGTH_NEWLV_FIELD.type = 13
EQUIPSTRENGTH_NEWLV_FIELD.cpp_type = 3
EQUIPSTRENGTH_RESULT_FIELD.name = "result"
EQUIPSTRENGTH_RESULT_FIELD.full_name = ".Cmd.EquipStrength.result"
EQUIPSTRENGTH_RESULT_FIELD.number = 9
EQUIPSTRENGTH_RESULT_FIELD.index = 8
EQUIPSTRENGTH_RESULT_FIELD.label = 1
EQUIPSTRENGTH_RESULT_FIELD.has_default_value = true
EQUIPSTRENGTH_RESULT_FIELD.default_value = 0
EQUIPSTRENGTH_RESULT_FIELD.enum_type = ESTRENGTHRESULT
EQUIPSTRENGTH_RESULT_FIELD.type = 14
EQUIPSTRENGTH_RESULT_FIELD.cpp_type = 8
EQUIPSTRENGTH_TYPE_FIELD.name = "type"
EQUIPSTRENGTH_TYPE_FIELD.full_name = ".Cmd.EquipStrength.type"
EQUIPSTRENGTH_TYPE_FIELD.number = 10
EQUIPSTRENGTH_TYPE_FIELD.index = 9
EQUIPSTRENGTH_TYPE_FIELD.label = 1
EQUIPSTRENGTH_TYPE_FIELD.has_default_value = true
EQUIPSTRENGTH_TYPE_FIELD.default_value = 0
EQUIPSTRENGTH_TYPE_FIELD.enum_type = ESTRENGTHTYPE
EQUIPSTRENGTH_TYPE_FIELD.type = 14
EQUIPSTRENGTH_TYPE_FIELD.cpp_type = 8
EQUIPSTRENGTH.name = "EquipStrength"
EQUIPSTRENGTH.full_name = ".Cmd.EquipStrength"
EQUIPSTRENGTH.nested_types = {}
EQUIPSTRENGTH.enum_types = {}
EQUIPSTRENGTH.fields = {
  EQUIPSTRENGTH_CMD_FIELD,
  EQUIPSTRENGTH_PARAM_FIELD,
  EQUIPSTRENGTH_GUID_FIELD,
  EQUIPSTRENGTH_DESTCOUNT_FIELD,
  EQUIPSTRENGTH_COUNT_FIELD,
  EQUIPSTRENGTH_CRICOUNT_FIELD,
  EQUIPSTRENGTH_OLDLV_FIELD,
  EQUIPSTRENGTH_NEWLV_FIELD,
  EQUIPSTRENGTH_RESULT_FIELD,
  EQUIPSTRENGTH_TYPE_FIELD
}
EQUIPSTRENGTH.is_extendable = false
EQUIPSTRENGTH.extensions = {}
PRODUCE_CMD_FIELD.name = "cmd"
PRODUCE_CMD_FIELD.full_name = ".Cmd.Produce.cmd"
PRODUCE_CMD_FIELD.number = 1
PRODUCE_CMD_FIELD.index = 0
PRODUCE_CMD_FIELD.label = 1
PRODUCE_CMD_FIELD.has_default_value = true
PRODUCE_CMD_FIELD.default_value = 6
PRODUCE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PRODUCE_CMD_FIELD.type = 14
PRODUCE_CMD_FIELD.cpp_type = 8
PRODUCE_PARAM_FIELD.name = "param"
PRODUCE_PARAM_FIELD.full_name = ".Cmd.Produce.param"
PRODUCE_PARAM_FIELD.number = 2
PRODUCE_PARAM_FIELD.index = 1
PRODUCE_PARAM_FIELD.label = 1
PRODUCE_PARAM_FIELD.has_default_value = true
PRODUCE_PARAM_FIELD.default_value = 9
PRODUCE_PARAM_FIELD.enum_type = ITEMPARAM
PRODUCE_PARAM_FIELD.type = 14
PRODUCE_PARAM_FIELD.cpp_type = 8
PRODUCE_TYPE_FIELD.name = "type"
PRODUCE_TYPE_FIELD.full_name = ".Cmd.Produce.type"
PRODUCE_TYPE_FIELD.number = 3
PRODUCE_TYPE_FIELD.index = 2
PRODUCE_TYPE_FIELD.label = 1
PRODUCE_TYPE_FIELD.has_default_value = true
PRODUCE_TYPE_FIELD.default_value = 1
PRODUCE_TYPE_FIELD.enum_type = EPRODUCETYPE
PRODUCE_TYPE_FIELD.type = 14
PRODUCE_TYPE_FIELD.cpp_type = 8
PRODUCE_COMPOSEID_FIELD.name = "composeid"
PRODUCE_COMPOSEID_FIELD.full_name = ".Cmd.Produce.composeid"
PRODUCE_COMPOSEID_FIELD.number = 4
PRODUCE_COMPOSEID_FIELD.index = 3
PRODUCE_COMPOSEID_FIELD.label = 1
PRODUCE_COMPOSEID_FIELD.has_default_value = true
PRODUCE_COMPOSEID_FIELD.default_value = 0
PRODUCE_COMPOSEID_FIELD.type = 13
PRODUCE_COMPOSEID_FIELD.cpp_type = 3
PRODUCE_NPCID_FIELD.name = "npcid"
PRODUCE_NPCID_FIELD.full_name = ".Cmd.Produce.npcid"
PRODUCE_NPCID_FIELD.number = 5
PRODUCE_NPCID_FIELD.index = 4
PRODUCE_NPCID_FIELD.label = 1
PRODUCE_NPCID_FIELD.has_default_value = true
PRODUCE_NPCID_FIELD.default_value = 0
PRODUCE_NPCID_FIELD.type = 4
PRODUCE_NPCID_FIELD.cpp_type = 4
PRODUCE_ITEMID_FIELD.name = "itemid"
PRODUCE_ITEMID_FIELD.full_name = ".Cmd.Produce.itemid"
PRODUCE_ITEMID_FIELD.number = 6
PRODUCE_ITEMID_FIELD.index = 5
PRODUCE_ITEMID_FIELD.label = 1
PRODUCE_ITEMID_FIELD.has_default_value = true
PRODUCE_ITEMID_FIELD.default_value = 0
PRODUCE_ITEMID_FIELD.type = 13
PRODUCE_ITEMID_FIELD.cpp_type = 3
PRODUCE_COUNT_FIELD.name = "count"
PRODUCE_COUNT_FIELD.full_name = ".Cmd.Produce.count"
PRODUCE_COUNT_FIELD.number = 7
PRODUCE_COUNT_FIELD.index = 6
PRODUCE_COUNT_FIELD.label = 1
PRODUCE_COUNT_FIELD.has_default_value = true
PRODUCE_COUNT_FIELD.default_value = 1
PRODUCE_COUNT_FIELD.type = 13
PRODUCE_COUNT_FIELD.cpp_type = 3
PRODUCE_QUCIKPRODUCE_FIELD.name = "qucikproduce"
PRODUCE_QUCIKPRODUCE_FIELD.full_name = ".Cmd.Produce.qucikproduce"
PRODUCE_QUCIKPRODUCE_FIELD.number = 8
PRODUCE_QUCIKPRODUCE_FIELD.index = 7
PRODUCE_QUCIKPRODUCE_FIELD.label = 1
PRODUCE_QUCIKPRODUCE_FIELD.has_default_value = true
PRODUCE_QUCIKPRODUCE_FIELD.default_value = false
PRODUCE_QUCIKPRODUCE_FIELD.type = 8
PRODUCE_QUCIKPRODUCE_FIELD.cpp_type = 7
PRODUCE.name = "Produce"
PRODUCE.full_name = ".Cmd.Produce"
PRODUCE.nested_types = {}
PRODUCE.enum_types = {}
PRODUCE.fields = {
  PRODUCE_CMD_FIELD,
  PRODUCE_PARAM_FIELD,
  PRODUCE_TYPE_FIELD,
  PRODUCE_COMPOSEID_FIELD,
  PRODUCE_NPCID_FIELD,
  PRODUCE_ITEMID_FIELD,
  PRODUCE_COUNT_FIELD,
  PRODUCE_QUCIKPRODUCE_FIELD
}
PRODUCE.is_extendable = false
PRODUCE.extensions = {}
PRODUCEDONE_CMD_FIELD.name = "cmd"
PRODUCEDONE_CMD_FIELD.full_name = ".Cmd.ProduceDone.cmd"
PRODUCEDONE_CMD_FIELD.number = 1
PRODUCEDONE_CMD_FIELD.index = 0
PRODUCEDONE_CMD_FIELD.label = 1
PRODUCEDONE_CMD_FIELD.has_default_value = true
PRODUCEDONE_CMD_FIELD.default_value = 6
PRODUCEDONE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PRODUCEDONE_CMD_FIELD.type = 14
PRODUCEDONE_CMD_FIELD.cpp_type = 8
PRODUCEDONE_PARAM_FIELD.name = "param"
PRODUCEDONE_PARAM_FIELD.full_name = ".Cmd.ProduceDone.param"
PRODUCEDONE_PARAM_FIELD.number = 2
PRODUCEDONE_PARAM_FIELD.index = 1
PRODUCEDONE_PARAM_FIELD.label = 1
PRODUCEDONE_PARAM_FIELD.has_default_value = true
PRODUCEDONE_PARAM_FIELD.default_value = 10
PRODUCEDONE_PARAM_FIELD.enum_type = ITEMPARAM
PRODUCEDONE_PARAM_FIELD.type = 14
PRODUCEDONE_PARAM_FIELD.cpp_type = 8
PRODUCEDONE_TYPE_FIELD.name = "type"
PRODUCEDONE_TYPE_FIELD.full_name = ".Cmd.ProduceDone.type"
PRODUCEDONE_TYPE_FIELD.number = 3
PRODUCEDONE_TYPE_FIELD.index = 2
PRODUCEDONE_TYPE_FIELD.label = 1
PRODUCEDONE_TYPE_FIELD.has_default_value = true
PRODUCEDONE_TYPE_FIELD.default_value = 1
PRODUCEDONE_TYPE_FIELD.enum_type = EPRODUCETYPE
PRODUCEDONE_TYPE_FIELD.type = 14
PRODUCEDONE_TYPE_FIELD.cpp_type = 8
PRODUCEDONE_NPCID_FIELD.name = "npcid"
PRODUCEDONE_NPCID_FIELD.full_name = ".Cmd.ProduceDone.npcid"
PRODUCEDONE_NPCID_FIELD.number = 4
PRODUCEDONE_NPCID_FIELD.index = 3
PRODUCEDONE_NPCID_FIELD.label = 1
PRODUCEDONE_NPCID_FIELD.has_default_value = true
PRODUCEDONE_NPCID_FIELD.default_value = 0
PRODUCEDONE_NPCID_FIELD.type = 4
PRODUCEDONE_NPCID_FIELD.cpp_type = 4
PRODUCEDONE_CHARID_FIELD.name = "charid"
PRODUCEDONE_CHARID_FIELD.full_name = ".Cmd.ProduceDone.charid"
PRODUCEDONE_CHARID_FIELD.number = 5
PRODUCEDONE_CHARID_FIELD.index = 4
PRODUCEDONE_CHARID_FIELD.label = 1
PRODUCEDONE_CHARID_FIELD.has_default_value = true
PRODUCEDONE_CHARID_FIELD.default_value = 0
PRODUCEDONE_CHARID_FIELD.type = 4
PRODUCEDONE_CHARID_FIELD.cpp_type = 4
PRODUCEDONE_DELAY_FIELD.name = "delay"
PRODUCEDONE_DELAY_FIELD.full_name = ".Cmd.ProduceDone.delay"
PRODUCEDONE_DELAY_FIELD.number = 6
PRODUCEDONE_DELAY_FIELD.index = 5
PRODUCEDONE_DELAY_FIELD.label = 1
PRODUCEDONE_DELAY_FIELD.has_default_value = true
PRODUCEDONE_DELAY_FIELD.default_value = 0
PRODUCEDONE_DELAY_FIELD.type = 13
PRODUCEDONE_DELAY_FIELD.cpp_type = 3
PRODUCEDONE_ITEMID_FIELD.name = "itemid"
PRODUCEDONE_ITEMID_FIELD.full_name = ".Cmd.ProduceDone.itemid"
PRODUCEDONE_ITEMID_FIELD.number = 7
PRODUCEDONE_ITEMID_FIELD.index = 6
PRODUCEDONE_ITEMID_FIELD.label = 1
PRODUCEDONE_ITEMID_FIELD.has_default_value = true
PRODUCEDONE_ITEMID_FIELD.default_value = 0
PRODUCEDONE_ITEMID_FIELD.type = 13
PRODUCEDONE_ITEMID_FIELD.cpp_type = 3
PRODUCEDONE.name = "ProduceDone"
PRODUCEDONE.full_name = ".Cmd.ProduceDone"
PRODUCEDONE.nested_types = {}
PRODUCEDONE.enum_types = {}
PRODUCEDONE.fields = {
  PRODUCEDONE_CMD_FIELD,
  PRODUCEDONE_PARAM_FIELD,
  PRODUCEDONE_TYPE_FIELD,
  PRODUCEDONE_NPCID_FIELD,
  PRODUCEDONE_CHARID_FIELD,
  PRODUCEDONE_DELAY_FIELD,
  PRODUCEDONE_ITEMID_FIELD
}
PRODUCEDONE.is_extendable = false
PRODUCEDONE.extensions = {}
EQUIPREFINE_CMD_FIELD.name = "cmd"
EQUIPREFINE_CMD_FIELD.full_name = ".Cmd.EquipRefine.cmd"
EQUIPREFINE_CMD_FIELD.number = 1
EQUIPREFINE_CMD_FIELD.index = 0
EQUIPREFINE_CMD_FIELD.label = 1
EQUIPREFINE_CMD_FIELD.has_default_value = true
EQUIPREFINE_CMD_FIELD.default_value = 6
EQUIPREFINE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIPREFINE_CMD_FIELD.type = 14
EQUIPREFINE_CMD_FIELD.cpp_type = 8
EQUIPREFINE_PARAM_FIELD.name = "param"
EQUIPREFINE_PARAM_FIELD.full_name = ".Cmd.EquipRefine.param"
EQUIPREFINE_PARAM_FIELD.number = 2
EQUIPREFINE_PARAM_FIELD.index = 1
EQUIPREFINE_PARAM_FIELD.label = 1
EQUIPREFINE_PARAM_FIELD.has_default_value = true
EQUIPREFINE_PARAM_FIELD.default_value = 11
EQUIPREFINE_PARAM_FIELD.enum_type = ITEMPARAM
EQUIPREFINE_PARAM_FIELD.type = 14
EQUIPREFINE_PARAM_FIELD.cpp_type = 8
EQUIPREFINE_GUID_FIELD.name = "guid"
EQUIPREFINE_GUID_FIELD.full_name = ".Cmd.EquipRefine.guid"
EQUIPREFINE_GUID_FIELD.number = 3
EQUIPREFINE_GUID_FIELD.index = 2
EQUIPREFINE_GUID_FIELD.label = 1
EQUIPREFINE_GUID_FIELD.has_default_value = false
EQUIPREFINE_GUID_FIELD.default_value = ""
EQUIPREFINE_GUID_FIELD.type = 9
EQUIPREFINE_GUID_FIELD.cpp_type = 9
EQUIPREFINE_COMPOSEID_FIELD.name = "composeid"
EQUIPREFINE_COMPOSEID_FIELD.full_name = ".Cmd.EquipRefine.composeid"
EQUIPREFINE_COMPOSEID_FIELD.number = 4
EQUIPREFINE_COMPOSEID_FIELD.index = 3
EQUIPREFINE_COMPOSEID_FIELD.label = 1
EQUIPREFINE_COMPOSEID_FIELD.has_default_value = true
EQUIPREFINE_COMPOSEID_FIELD.default_value = 0
EQUIPREFINE_COMPOSEID_FIELD.type = 13
EQUIPREFINE_COMPOSEID_FIELD.cpp_type = 3
EQUIPREFINE_REFINELV_FIELD.name = "refinelv"
EQUIPREFINE_REFINELV_FIELD.full_name = ".Cmd.EquipRefine.refinelv"
EQUIPREFINE_REFINELV_FIELD.number = 5
EQUIPREFINE_REFINELV_FIELD.index = 4
EQUIPREFINE_REFINELV_FIELD.label = 1
EQUIPREFINE_REFINELV_FIELD.has_default_value = true
EQUIPREFINE_REFINELV_FIELD.default_value = 0
EQUIPREFINE_REFINELV_FIELD.type = 13
EQUIPREFINE_REFINELV_FIELD.cpp_type = 3
EQUIPREFINE_ERESULT_FIELD.name = "eresult"
EQUIPREFINE_ERESULT_FIELD.full_name = ".Cmd.EquipRefine.eresult"
EQUIPREFINE_ERESULT_FIELD.number = 6
EQUIPREFINE_ERESULT_FIELD.index = 5
EQUIPREFINE_ERESULT_FIELD.label = 1
EQUIPREFINE_ERESULT_FIELD.has_default_value = true
EQUIPREFINE_ERESULT_FIELD.default_value = 0
EQUIPREFINE_ERESULT_FIELD.enum_type = EREFINERESULT
EQUIPREFINE_ERESULT_FIELD.type = 14
EQUIPREFINE_ERESULT_FIELD.cpp_type = 8
EQUIPREFINE_NPCID_FIELD.name = "npcid"
EQUIPREFINE_NPCID_FIELD.full_name = ".Cmd.EquipRefine.npcid"
EQUIPREFINE_NPCID_FIELD.number = 7
EQUIPREFINE_NPCID_FIELD.index = 6
EQUIPREFINE_NPCID_FIELD.label = 1
EQUIPREFINE_NPCID_FIELD.has_default_value = true
EQUIPREFINE_NPCID_FIELD.default_value = 0
EQUIPREFINE_NPCID_FIELD.type = 4
EQUIPREFINE_NPCID_FIELD.cpp_type = 4
EQUIPREFINE_SAFEREFINE_FIELD.name = "saferefine"
EQUIPREFINE_SAFEREFINE_FIELD.full_name = ".Cmd.EquipRefine.saferefine"
EQUIPREFINE_SAFEREFINE_FIELD.number = 8
EQUIPREFINE_SAFEREFINE_FIELD.index = 7
EQUIPREFINE_SAFEREFINE_FIELD.label = 1
EQUIPREFINE_SAFEREFINE_FIELD.has_default_value = true
EQUIPREFINE_SAFEREFINE_FIELD.default_value = false
EQUIPREFINE_SAFEREFINE_FIELD.type = 8
EQUIPREFINE_SAFEREFINE_FIELD.cpp_type = 7
EQUIPREFINE_ITEMGUID_FIELD.name = "itemguid"
EQUIPREFINE_ITEMGUID_FIELD.full_name = ".Cmd.EquipRefine.itemguid"
EQUIPREFINE_ITEMGUID_FIELD.number = 9
EQUIPREFINE_ITEMGUID_FIELD.index = 8
EQUIPREFINE_ITEMGUID_FIELD.label = 3
EQUIPREFINE_ITEMGUID_FIELD.has_default_value = false
EQUIPREFINE_ITEMGUID_FIELD.default_value = {}
EQUIPREFINE_ITEMGUID_FIELD.type = 9
EQUIPREFINE_ITEMGUID_FIELD.cpp_type = 9
EQUIPREFINE.name = "EquipRefine"
EQUIPREFINE.full_name = ".Cmd.EquipRefine"
EQUIPREFINE.nested_types = {}
EQUIPREFINE.enum_types = {}
EQUIPREFINE.fields = {
  EQUIPREFINE_CMD_FIELD,
  EQUIPREFINE_PARAM_FIELD,
  EQUIPREFINE_GUID_FIELD,
  EQUIPREFINE_COMPOSEID_FIELD,
  EQUIPREFINE_REFINELV_FIELD,
  EQUIPREFINE_ERESULT_FIELD,
  EQUIPREFINE_NPCID_FIELD,
  EQUIPREFINE_SAFEREFINE_FIELD,
  EQUIPREFINE_ITEMGUID_FIELD
}
EQUIPREFINE.is_extendable = false
EQUIPREFINE.extensions = {}
EQUIPDECOMPOSE_CMD_FIELD.name = "cmd"
EQUIPDECOMPOSE_CMD_FIELD.full_name = ".Cmd.EquipDecompose.cmd"
EQUIPDECOMPOSE_CMD_FIELD.number = 1
EQUIPDECOMPOSE_CMD_FIELD.index = 0
EQUIPDECOMPOSE_CMD_FIELD.label = 1
EQUIPDECOMPOSE_CMD_FIELD.has_default_value = true
EQUIPDECOMPOSE_CMD_FIELD.default_value = 6
EQUIPDECOMPOSE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIPDECOMPOSE_CMD_FIELD.type = 14
EQUIPDECOMPOSE_CMD_FIELD.cpp_type = 8
EQUIPDECOMPOSE_PARAM_FIELD.name = "param"
EQUIPDECOMPOSE_PARAM_FIELD.full_name = ".Cmd.EquipDecompose.param"
EQUIPDECOMPOSE_PARAM_FIELD.number = 2
EQUIPDECOMPOSE_PARAM_FIELD.index = 1
EQUIPDECOMPOSE_PARAM_FIELD.label = 1
EQUIPDECOMPOSE_PARAM_FIELD.has_default_value = true
EQUIPDECOMPOSE_PARAM_FIELD.default_value = 12
EQUIPDECOMPOSE_PARAM_FIELD.enum_type = ITEMPARAM
EQUIPDECOMPOSE_PARAM_FIELD.type = 14
EQUIPDECOMPOSE_PARAM_FIELD.cpp_type = 8
EQUIPDECOMPOSE_GUID_FIELD.name = "guid"
EQUIPDECOMPOSE_GUID_FIELD.full_name = ".Cmd.EquipDecompose.guid"
EQUIPDECOMPOSE_GUID_FIELD.number = 3
EQUIPDECOMPOSE_GUID_FIELD.index = 2
EQUIPDECOMPOSE_GUID_FIELD.label = 1
EQUIPDECOMPOSE_GUID_FIELD.has_default_value = false
EQUIPDECOMPOSE_GUID_FIELD.default_value = ""
EQUIPDECOMPOSE_GUID_FIELD.type = 9
EQUIPDECOMPOSE_GUID_FIELD.cpp_type = 9
EQUIPDECOMPOSE_RESULT_FIELD.name = "result"
EQUIPDECOMPOSE_RESULT_FIELD.full_name = ".Cmd.EquipDecompose.result"
EQUIPDECOMPOSE_RESULT_FIELD.number = 4
EQUIPDECOMPOSE_RESULT_FIELD.index = 3
EQUIPDECOMPOSE_RESULT_FIELD.label = 1
EQUIPDECOMPOSE_RESULT_FIELD.has_default_value = true
EQUIPDECOMPOSE_RESULT_FIELD.default_value = 0
EQUIPDECOMPOSE_RESULT_FIELD.enum_type = EDECOMPOSERESULT
EQUIPDECOMPOSE_RESULT_FIELD.type = 14
EQUIPDECOMPOSE_RESULT_FIELD.cpp_type = 8
EQUIPDECOMPOSE_ITEMS_FIELD.name = "items"
EQUIPDECOMPOSE_ITEMS_FIELD.full_name = ".Cmd.EquipDecompose.items"
EQUIPDECOMPOSE_ITEMS_FIELD.number = 5
EQUIPDECOMPOSE_ITEMS_FIELD.index = 4
EQUIPDECOMPOSE_ITEMS_FIELD.label = 3
EQUIPDECOMPOSE_ITEMS_FIELD.has_default_value = false
EQUIPDECOMPOSE_ITEMS_FIELD.default_value = {}
EQUIPDECOMPOSE_ITEMS_FIELD.message_type = ITEMINFO
EQUIPDECOMPOSE_ITEMS_FIELD.type = 11
EQUIPDECOMPOSE_ITEMS_FIELD.cpp_type = 10
EQUIPDECOMPOSE.name = "EquipDecompose"
EQUIPDECOMPOSE.full_name = ".Cmd.EquipDecompose"
EQUIPDECOMPOSE.nested_types = {}
EQUIPDECOMPOSE.enum_types = {}
EQUIPDECOMPOSE.fields = {
  EQUIPDECOMPOSE_CMD_FIELD,
  EQUIPDECOMPOSE_PARAM_FIELD,
  EQUIPDECOMPOSE_GUID_FIELD,
  EQUIPDECOMPOSE_RESULT_FIELD,
  EQUIPDECOMPOSE_ITEMS_FIELD
}
EQUIPDECOMPOSE.is_extendable = false
EQUIPDECOMPOSE.extensions = {}
DECOMPOSERESULT_ITEM_FIELD.name = "item"
DECOMPOSERESULT_ITEM_FIELD.full_name = ".Cmd.DecomposeResult.item"
DECOMPOSERESULT_ITEM_FIELD.number = 1
DECOMPOSERESULT_ITEM_FIELD.index = 0
DECOMPOSERESULT_ITEM_FIELD.label = 1
DECOMPOSERESULT_ITEM_FIELD.has_default_value = false
DECOMPOSERESULT_ITEM_FIELD.default_value = nil
DECOMPOSERESULT_ITEM_FIELD.message_type = ITEMINFO
DECOMPOSERESULT_ITEM_FIELD.type = 11
DECOMPOSERESULT_ITEM_FIELD.cpp_type = 10
DECOMPOSERESULT_RATE_FIELD.name = "rate"
DECOMPOSERESULT_RATE_FIELD.full_name = ".Cmd.DecomposeResult.rate"
DECOMPOSERESULT_RATE_FIELD.number = 2
DECOMPOSERESULT_RATE_FIELD.index = 1
DECOMPOSERESULT_RATE_FIELD.label = 1
DECOMPOSERESULT_RATE_FIELD.has_default_value = true
DECOMPOSERESULT_RATE_FIELD.default_value = 0
DECOMPOSERESULT_RATE_FIELD.type = 13
DECOMPOSERESULT_RATE_FIELD.cpp_type = 3
DECOMPOSERESULT_MIN_COUNT_FIELD.name = "min_count"
DECOMPOSERESULT_MIN_COUNT_FIELD.full_name = ".Cmd.DecomposeResult.min_count"
DECOMPOSERESULT_MIN_COUNT_FIELD.number = 3
DECOMPOSERESULT_MIN_COUNT_FIELD.index = 2
DECOMPOSERESULT_MIN_COUNT_FIELD.label = 1
DECOMPOSERESULT_MIN_COUNT_FIELD.has_default_value = true
DECOMPOSERESULT_MIN_COUNT_FIELD.default_value = 0
DECOMPOSERESULT_MIN_COUNT_FIELD.type = 13
DECOMPOSERESULT_MIN_COUNT_FIELD.cpp_type = 3
DECOMPOSERESULT_MAX_COUNT_FIELD.name = "max_count"
DECOMPOSERESULT_MAX_COUNT_FIELD.full_name = ".Cmd.DecomposeResult.max_count"
DECOMPOSERESULT_MAX_COUNT_FIELD.number = 4
DECOMPOSERESULT_MAX_COUNT_FIELD.index = 3
DECOMPOSERESULT_MAX_COUNT_FIELD.label = 1
DECOMPOSERESULT_MAX_COUNT_FIELD.has_default_value = true
DECOMPOSERESULT_MAX_COUNT_FIELD.default_value = 0
DECOMPOSERESULT_MAX_COUNT_FIELD.type = 13
DECOMPOSERESULT_MAX_COUNT_FIELD.cpp_type = 3
DECOMPOSERESULT.name = "DecomposeResult"
DECOMPOSERESULT.full_name = ".Cmd.DecomposeResult"
DECOMPOSERESULT.nested_types = {}
DECOMPOSERESULT.enum_types = {}
DECOMPOSERESULT.fields = {
  DECOMPOSERESULT_ITEM_FIELD,
  DECOMPOSERESULT_RATE_FIELD,
  DECOMPOSERESULT_MIN_COUNT_FIELD,
  DECOMPOSERESULT_MAX_COUNT_FIELD
}
DECOMPOSERESULT.is_extendable = false
DECOMPOSERESULT.extensions = {}
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.name = "cmd"
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.full_name = ".Cmd.QueryDecomposeResultItemCmd.cmd"
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.number = 1
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.index = 0
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.label = 1
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.has_default_value = true
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.default_value = 6
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.type = 14
QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD.cpp_type = 8
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.name = "param"
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.full_name = ".Cmd.QueryDecomposeResultItemCmd.param"
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.number = 2
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.index = 1
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.label = 1
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.has_default_value = true
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.default_value = 27
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.type = 14
QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD.cpp_type = 8
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.name = "guid"
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.full_name = ".Cmd.QueryDecomposeResultItemCmd.guid"
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.number = 3
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.index = 2
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.label = 1
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.has_default_value = false
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.default_value = ""
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.type = 9
QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD.cpp_type = 9
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.name = "results"
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.full_name = ".Cmd.QueryDecomposeResultItemCmd.results"
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.number = 4
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.index = 3
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.label = 3
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.has_default_value = false
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.default_value = {}
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.message_type = DECOMPOSERESULT
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.type = 11
QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD.cpp_type = 10
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.name = "sell_price"
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.full_name = ".Cmd.QueryDecomposeResultItemCmd.sell_price"
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.number = 5
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.index = 4
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.label = 1
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.has_default_value = true
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.default_value = 0
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.type = 13
QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD.cpp_type = 3
QUERYDECOMPOSERESULTITEMCMD.name = "QueryDecomposeResultItemCmd"
QUERYDECOMPOSERESULTITEMCMD.full_name = ".Cmd.QueryDecomposeResultItemCmd"
QUERYDECOMPOSERESULTITEMCMD.nested_types = {}
QUERYDECOMPOSERESULTITEMCMD.enum_types = {}
QUERYDECOMPOSERESULTITEMCMD.fields = {
  QUERYDECOMPOSERESULTITEMCMD_CMD_FIELD,
  QUERYDECOMPOSERESULTITEMCMD_PARAM_FIELD,
  QUERYDECOMPOSERESULTITEMCMD_GUID_FIELD,
  QUERYDECOMPOSERESULTITEMCMD_RESULTS_FIELD,
  QUERYDECOMPOSERESULTITEMCMD_SELL_PRICE_FIELD
}
QUERYDECOMPOSERESULTITEMCMD.is_extendable = false
QUERYDECOMPOSERESULTITEMCMD.extensions = {}
QUERYEQUIPDATA_CMD_FIELD.name = "cmd"
QUERYEQUIPDATA_CMD_FIELD.full_name = ".Cmd.QueryEquipData.cmd"
QUERYEQUIPDATA_CMD_FIELD.number = 1
QUERYEQUIPDATA_CMD_FIELD.index = 0
QUERYEQUIPDATA_CMD_FIELD.label = 1
QUERYEQUIPDATA_CMD_FIELD.has_default_value = true
QUERYEQUIPDATA_CMD_FIELD.default_value = 6
QUERYEQUIPDATA_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYEQUIPDATA_CMD_FIELD.type = 14
QUERYEQUIPDATA_CMD_FIELD.cpp_type = 8
QUERYEQUIPDATA_PARAM_FIELD.name = "param"
QUERYEQUIPDATA_PARAM_FIELD.full_name = ".Cmd.QueryEquipData.param"
QUERYEQUIPDATA_PARAM_FIELD.number = 2
QUERYEQUIPDATA_PARAM_FIELD.index = 1
QUERYEQUIPDATA_PARAM_FIELD.label = 1
QUERYEQUIPDATA_PARAM_FIELD.has_default_value = true
QUERYEQUIPDATA_PARAM_FIELD.default_value = 13
QUERYEQUIPDATA_PARAM_FIELD.enum_type = ITEMPARAM
QUERYEQUIPDATA_PARAM_FIELD.type = 14
QUERYEQUIPDATA_PARAM_FIELD.cpp_type = 8
QUERYEQUIPDATA_GUID_FIELD.name = "guid"
QUERYEQUIPDATA_GUID_FIELD.full_name = ".Cmd.QueryEquipData.guid"
QUERYEQUIPDATA_GUID_FIELD.number = 3
QUERYEQUIPDATA_GUID_FIELD.index = 2
QUERYEQUIPDATA_GUID_FIELD.label = 1
QUERYEQUIPDATA_GUID_FIELD.has_default_value = false
QUERYEQUIPDATA_GUID_FIELD.default_value = ""
QUERYEQUIPDATA_GUID_FIELD.type = 9
QUERYEQUIPDATA_GUID_FIELD.cpp_type = 9
QUERYEQUIPDATA_DATA_FIELD.name = "data"
QUERYEQUIPDATA_DATA_FIELD.full_name = ".Cmd.QueryEquipData.data"
QUERYEQUIPDATA_DATA_FIELD.number = 4
QUERYEQUIPDATA_DATA_FIELD.index = 3
QUERYEQUIPDATA_DATA_FIELD.label = 1
QUERYEQUIPDATA_DATA_FIELD.has_default_value = false
QUERYEQUIPDATA_DATA_FIELD.default_value = nil
QUERYEQUIPDATA_DATA_FIELD.message_type = EQUIPDATA
QUERYEQUIPDATA_DATA_FIELD.type = 11
QUERYEQUIPDATA_DATA_FIELD.cpp_type = 10
QUERYEQUIPDATA.name = "QueryEquipData"
QUERYEQUIPDATA.full_name = ".Cmd.QueryEquipData"
QUERYEQUIPDATA.nested_types = {}
QUERYEQUIPDATA.enum_types = {}
QUERYEQUIPDATA.fields = {
  QUERYEQUIPDATA_CMD_FIELD,
  QUERYEQUIPDATA_PARAM_FIELD,
  QUERYEQUIPDATA_GUID_FIELD,
  QUERYEQUIPDATA_DATA_FIELD
}
QUERYEQUIPDATA.is_extendable = false
QUERYEQUIPDATA.extensions = {}
BROWSEPACKAGE_CMD_FIELD.name = "cmd"
BROWSEPACKAGE_CMD_FIELD.full_name = ".Cmd.BrowsePackage.cmd"
BROWSEPACKAGE_CMD_FIELD.number = 1
BROWSEPACKAGE_CMD_FIELD.index = 0
BROWSEPACKAGE_CMD_FIELD.label = 1
BROWSEPACKAGE_CMD_FIELD.has_default_value = true
BROWSEPACKAGE_CMD_FIELD.default_value = 6
BROWSEPACKAGE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BROWSEPACKAGE_CMD_FIELD.type = 14
BROWSEPACKAGE_CMD_FIELD.cpp_type = 8
BROWSEPACKAGE_PARAM_FIELD.name = "param"
BROWSEPACKAGE_PARAM_FIELD.full_name = ".Cmd.BrowsePackage.param"
BROWSEPACKAGE_PARAM_FIELD.number = 2
BROWSEPACKAGE_PARAM_FIELD.index = 1
BROWSEPACKAGE_PARAM_FIELD.label = 1
BROWSEPACKAGE_PARAM_FIELD.has_default_value = true
BROWSEPACKAGE_PARAM_FIELD.default_value = 14
BROWSEPACKAGE_PARAM_FIELD.enum_type = ITEMPARAM
BROWSEPACKAGE_PARAM_FIELD.type = 14
BROWSEPACKAGE_PARAM_FIELD.cpp_type = 8
BROWSEPACKAGE_TYPE_FIELD.name = "type"
BROWSEPACKAGE_TYPE_FIELD.full_name = ".Cmd.BrowsePackage.type"
BROWSEPACKAGE_TYPE_FIELD.number = 3
BROWSEPACKAGE_TYPE_FIELD.index = 2
BROWSEPACKAGE_TYPE_FIELD.label = 1
BROWSEPACKAGE_TYPE_FIELD.has_default_value = true
BROWSEPACKAGE_TYPE_FIELD.default_value = 0
BROWSEPACKAGE_TYPE_FIELD.enum_type = EPACKTYPE
BROWSEPACKAGE_TYPE_FIELD.type = 14
BROWSEPACKAGE_TYPE_FIELD.cpp_type = 8
BROWSEPACKAGE.name = "BrowsePackage"
BROWSEPACKAGE.full_name = ".Cmd.BrowsePackage"
BROWSEPACKAGE.nested_types = {}
BROWSEPACKAGE.enum_types = {}
BROWSEPACKAGE.fields = {
  BROWSEPACKAGE_CMD_FIELD,
  BROWSEPACKAGE_PARAM_FIELD,
  BROWSEPACKAGE_TYPE_FIELD
}
BROWSEPACKAGE.is_extendable = false
BROWSEPACKAGE.extensions = {}
EQUIPCARD_CMD_FIELD.name = "cmd"
EQUIPCARD_CMD_FIELD.full_name = ".Cmd.EquipCard.cmd"
EQUIPCARD_CMD_FIELD.number = 1
EQUIPCARD_CMD_FIELD.index = 0
EQUIPCARD_CMD_FIELD.label = 1
EQUIPCARD_CMD_FIELD.has_default_value = true
EQUIPCARD_CMD_FIELD.default_value = 6
EQUIPCARD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIPCARD_CMD_FIELD.type = 14
EQUIPCARD_CMD_FIELD.cpp_type = 8
EQUIPCARD_PARAM_FIELD.name = "param"
EQUIPCARD_PARAM_FIELD.full_name = ".Cmd.EquipCard.param"
EQUIPCARD_PARAM_FIELD.number = 2
EQUIPCARD_PARAM_FIELD.index = 1
EQUIPCARD_PARAM_FIELD.label = 1
EQUIPCARD_PARAM_FIELD.has_default_value = true
EQUIPCARD_PARAM_FIELD.default_value = 15
EQUIPCARD_PARAM_FIELD.enum_type = ITEMPARAM
EQUIPCARD_PARAM_FIELD.type = 14
EQUIPCARD_PARAM_FIELD.cpp_type = 8
EQUIPCARD_OPER_FIELD.name = "oper"
EQUIPCARD_OPER_FIELD.full_name = ".Cmd.EquipCard.oper"
EQUIPCARD_OPER_FIELD.number = 3
EQUIPCARD_OPER_FIELD.index = 2
EQUIPCARD_OPER_FIELD.label = 1
EQUIPCARD_OPER_FIELD.has_default_value = true
EQUIPCARD_OPER_FIELD.default_value = 0
EQUIPCARD_OPER_FIELD.enum_type = ECARDOPER
EQUIPCARD_OPER_FIELD.type = 14
EQUIPCARD_OPER_FIELD.cpp_type = 8
EQUIPCARD_CARDGUID_FIELD.name = "cardguid"
EQUIPCARD_CARDGUID_FIELD.full_name = ".Cmd.EquipCard.cardguid"
EQUIPCARD_CARDGUID_FIELD.number = 4
EQUIPCARD_CARDGUID_FIELD.index = 3
EQUIPCARD_CARDGUID_FIELD.label = 1
EQUIPCARD_CARDGUID_FIELD.has_default_value = false
EQUIPCARD_CARDGUID_FIELD.default_value = ""
EQUIPCARD_CARDGUID_FIELD.type = 9
EQUIPCARD_CARDGUID_FIELD.cpp_type = 9
EQUIPCARD_EQUIPGUID_FIELD.name = "equipguid"
EQUIPCARD_EQUIPGUID_FIELD.full_name = ".Cmd.EquipCard.equipguid"
EQUIPCARD_EQUIPGUID_FIELD.number = 5
EQUIPCARD_EQUIPGUID_FIELD.index = 4
EQUIPCARD_EQUIPGUID_FIELD.label = 1
EQUIPCARD_EQUIPGUID_FIELD.has_default_value = false
EQUIPCARD_EQUIPGUID_FIELD.default_value = ""
EQUIPCARD_EQUIPGUID_FIELD.type = 9
EQUIPCARD_EQUIPGUID_FIELD.cpp_type = 9
EQUIPCARD_POS_FIELD.name = "pos"
EQUIPCARD_POS_FIELD.full_name = ".Cmd.EquipCard.pos"
EQUIPCARD_POS_FIELD.number = 6
EQUIPCARD_POS_FIELD.index = 5
EQUIPCARD_POS_FIELD.label = 1
EQUIPCARD_POS_FIELD.has_default_value = true
EQUIPCARD_POS_FIELD.default_value = 0
EQUIPCARD_POS_FIELD.type = 13
EQUIPCARD_POS_FIELD.cpp_type = 3
EQUIPCARD.name = "EquipCard"
EQUIPCARD.full_name = ".Cmd.EquipCard"
EQUIPCARD.nested_types = {}
EQUIPCARD.enum_types = {}
EQUIPCARD.fields = {
  EQUIPCARD_CMD_FIELD,
  EQUIPCARD_PARAM_FIELD,
  EQUIPCARD_OPER_FIELD,
  EQUIPCARD_CARDGUID_FIELD,
  EQUIPCARD_EQUIPGUID_FIELD,
  EQUIPCARD_POS_FIELD
}
EQUIPCARD.is_extendable = false
EQUIPCARD.extensions = {}
ITEMSHOW_CMD_FIELD.name = "cmd"
ITEMSHOW_CMD_FIELD.full_name = ".Cmd.ItemShow.cmd"
ITEMSHOW_CMD_FIELD.number = 1
ITEMSHOW_CMD_FIELD.index = 0
ITEMSHOW_CMD_FIELD.label = 1
ITEMSHOW_CMD_FIELD.has_default_value = true
ITEMSHOW_CMD_FIELD.default_value = 6
ITEMSHOW_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ITEMSHOW_CMD_FIELD.type = 14
ITEMSHOW_CMD_FIELD.cpp_type = 8
ITEMSHOW_PARAM_FIELD.name = "param"
ITEMSHOW_PARAM_FIELD.full_name = ".Cmd.ItemShow.param"
ITEMSHOW_PARAM_FIELD.number = 2
ITEMSHOW_PARAM_FIELD.index = 1
ITEMSHOW_PARAM_FIELD.label = 1
ITEMSHOW_PARAM_FIELD.has_default_value = true
ITEMSHOW_PARAM_FIELD.default_value = 16
ITEMSHOW_PARAM_FIELD.enum_type = ITEMPARAM
ITEMSHOW_PARAM_FIELD.type = 14
ITEMSHOW_PARAM_FIELD.cpp_type = 8
ITEMSHOW_ITEMS_FIELD.name = "items"
ITEMSHOW_ITEMS_FIELD.full_name = ".Cmd.ItemShow.items"
ITEMSHOW_ITEMS_FIELD.number = 3
ITEMSHOW_ITEMS_FIELD.index = 2
ITEMSHOW_ITEMS_FIELD.label = 3
ITEMSHOW_ITEMS_FIELD.has_default_value = false
ITEMSHOW_ITEMS_FIELD.default_value = {}
ITEMSHOW_ITEMS_FIELD.message_type = ITEMINFO
ITEMSHOW_ITEMS_FIELD.type = 11
ITEMSHOW_ITEMS_FIELD.cpp_type = 10
ITEMSHOW.name = "ItemShow"
ITEMSHOW.full_name = ".Cmd.ItemShow"
ITEMSHOW.nested_types = {}
ITEMSHOW.enum_types = {}
ITEMSHOW.fields = {
  ITEMSHOW_CMD_FIELD,
  ITEMSHOW_PARAM_FIELD,
  ITEMSHOW_ITEMS_FIELD
}
ITEMSHOW.is_extendable = false
ITEMSHOW.extensions = {}
ITEMSHOW64_CMD_FIELD.name = "cmd"
ITEMSHOW64_CMD_FIELD.full_name = ".Cmd.ItemShow64.cmd"
ITEMSHOW64_CMD_FIELD.number = 1
ITEMSHOW64_CMD_FIELD.index = 0
ITEMSHOW64_CMD_FIELD.label = 1
ITEMSHOW64_CMD_FIELD.has_default_value = true
ITEMSHOW64_CMD_FIELD.default_value = 6
ITEMSHOW64_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ITEMSHOW64_CMD_FIELD.type = 14
ITEMSHOW64_CMD_FIELD.cpp_type = 8
ITEMSHOW64_PARAM_FIELD.name = "param"
ITEMSHOW64_PARAM_FIELD.full_name = ".Cmd.ItemShow64.param"
ITEMSHOW64_PARAM_FIELD.number = 2
ITEMSHOW64_PARAM_FIELD.index = 1
ITEMSHOW64_PARAM_FIELD.label = 1
ITEMSHOW64_PARAM_FIELD.has_default_value = true
ITEMSHOW64_PARAM_FIELD.default_value = 35
ITEMSHOW64_PARAM_FIELD.enum_type = ITEMPARAM
ITEMSHOW64_PARAM_FIELD.type = 14
ITEMSHOW64_PARAM_FIELD.cpp_type = 8
ITEMSHOW64_ID_FIELD.name = "id"
ITEMSHOW64_ID_FIELD.full_name = ".Cmd.ItemShow64.id"
ITEMSHOW64_ID_FIELD.number = 3
ITEMSHOW64_ID_FIELD.index = 2
ITEMSHOW64_ID_FIELD.label = 1
ITEMSHOW64_ID_FIELD.has_default_value = false
ITEMSHOW64_ID_FIELD.default_value = 0
ITEMSHOW64_ID_FIELD.type = 13
ITEMSHOW64_ID_FIELD.cpp_type = 3
ITEMSHOW64_COUNT_FIELD.name = "count"
ITEMSHOW64_COUNT_FIELD.full_name = ".Cmd.ItemShow64.count"
ITEMSHOW64_COUNT_FIELD.number = 4
ITEMSHOW64_COUNT_FIELD.index = 3
ITEMSHOW64_COUNT_FIELD.label = 1
ITEMSHOW64_COUNT_FIELD.has_default_value = false
ITEMSHOW64_COUNT_FIELD.default_value = 0
ITEMSHOW64_COUNT_FIELD.type = 4
ITEMSHOW64_COUNT_FIELD.cpp_type = 4
ITEMSHOW64.name = "ItemShow64"
ITEMSHOW64.full_name = ".Cmd.ItemShow64"
ITEMSHOW64.nested_types = {}
ITEMSHOW64.enum_types = {}
ITEMSHOW64.fields = {
  ITEMSHOW64_CMD_FIELD,
  ITEMSHOW64_PARAM_FIELD,
  ITEMSHOW64_ID_FIELD,
  ITEMSHOW64_COUNT_FIELD
}
ITEMSHOW64.is_extendable = false
ITEMSHOW64.extensions = {}
EQUIPREPAIR_CMD_FIELD.name = "cmd"
EQUIPREPAIR_CMD_FIELD.full_name = ".Cmd.EquipRepair.cmd"
EQUIPREPAIR_CMD_FIELD.number = 1
EQUIPREPAIR_CMD_FIELD.index = 0
EQUIPREPAIR_CMD_FIELD.label = 1
EQUIPREPAIR_CMD_FIELD.has_default_value = true
EQUIPREPAIR_CMD_FIELD.default_value = 6
EQUIPREPAIR_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIPREPAIR_CMD_FIELD.type = 14
EQUIPREPAIR_CMD_FIELD.cpp_type = 8
EQUIPREPAIR_PARAM_FIELD.name = "param"
EQUIPREPAIR_PARAM_FIELD.full_name = ".Cmd.EquipRepair.param"
EQUIPREPAIR_PARAM_FIELD.number = 2
EQUIPREPAIR_PARAM_FIELD.index = 1
EQUIPREPAIR_PARAM_FIELD.label = 1
EQUIPREPAIR_PARAM_FIELD.has_default_value = true
EQUIPREPAIR_PARAM_FIELD.default_value = 17
EQUIPREPAIR_PARAM_FIELD.enum_type = ITEMPARAM
EQUIPREPAIR_PARAM_FIELD.type = 14
EQUIPREPAIR_PARAM_FIELD.cpp_type = 8
EQUIPREPAIR_TARGETGUID_FIELD.name = "targetguid"
EQUIPREPAIR_TARGETGUID_FIELD.full_name = ".Cmd.EquipRepair.targetguid"
EQUIPREPAIR_TARGETGUID_FIELD.number = 3
EQUIPREPAIR_TARGETGUID_FIELD.index = 2
EQUIPREPAIR_TARGETGUID_FIELD.label = 1
EQUIPREPAIR_TARGETGUID_FIELD.has_default_value = false
EQUIPREPAIR_TARGETGUID_FIELD.default_value = ""
EQUIPREPAIR_TARGETGUID_FIELD.type = 9
EQUIPREPAIR_TARGETGUID_FIELD.cpp_type = 9
EQUIPREPAIR_SUCCESS_FIELD.name = "success"
EQUIPREPAIR_SUCCESS_FIELD.full_name = ".Cmd.EquipRepair.success"
EQUIPREPAIR_SUCCESS_FIELD.number = 4
EQUIPREPAIR_SUCCESS_FIELD.index = 3
EQUIPREPAIR_SUCCESS_FIELD.label = 1
EQUIPREPAIR_SUCCESS_FIELD.has_default_value = true
EQUIPREPAIR_SUCCESS_FIELD.default_value = false
EQUIPREPAIR_SUCCESS_FIELD.type = 8
EQUIPREPAIR_SUCCESS_FIELD.cpp_type = 7
EQUIPREPAIR_STUFFGUID_FIELD.name = "stuffguid"
EQUIPREPAIR_STUFFGUID_FIELD.full_name = ".Cmd.EquipRepair.stuffguid"
EQUIPREPAIR_STUFFGUID_FIELD.number = 5
EQUIPREPAIR_STUFFGUID_FIELD.index = 4
EQUIPREPAIR_STUFFGUID_FIELD.label = 1
EQUIPREPAIR_STUFFGUID_FIELD.has_default_value = false
EQUIPREPAIR_STUFFGUID_FIELD.default_value = ""
EQUIPREPAIR_STUFFGUID_FIELD.type = 9
EQUIPREPAIR_STUFFGUID_FIELD.cpp_type = 9
EQUIPREPAIR.name = "EquipRepair"
EQUIPREPAIR.full_name = ".Cmd.EquipRepair"
EQUIPREPAIR.nested_types = {}
EQUIPREPAIR.enum_types = {}
EQUIPREPAIR.fields = {
  EQUIPREPAIR_CMD_FIELD,
  EQUIPREPAIR_PARAM_FIELD,
  EQUIPREPAIR_TARGETGUID_FIELD,
  EQUIPREPAIR_SUCCESS_FIELD,
  EQUIPREPAIR_STUFFGUID_FIELD
}
EQUIPREPAIR.is_extendable = false
EQUIPREPAIR.extensions = {}
HINTNTF_CMD_FIELD.name = "cmd"
HINTNTF_CMD_FIELD.full_name = ".Cmd.HintNtf.cmd"
HINTNTF_CMD_FIELD.number = 1
HINTNTF_CMD_FIELD.index = 0
HINTNTF_CMD_FIELD.label = 1
HINTNTF_CMD_FIELD.has_default_value = true
HINTNTF_CMD_FIELD.default_value = 6
HINTNTF_CMD_FIELD.enum_type = XCMD_PB_COMMAND
HINTNTF_CMD_FIELD.type = 14
HINTNTF_CMD_FIELD.cpp_type = 8
HINTNTF_PARAM_FIELD.name = "param"
HINTNTF_PARAM_FIELD.full_name = ".Cmd.HintNtf.param"
HINTNTF_PARAM_FIELD.number = 2
HINTNTF_PARAM_FIELD.index = 1
HINTNTF_PARAM_FIELD.label = 1
HINTNTF_PARAM_FIELD.has_default_value = true
HINTNTF_PARAM_FIELD.default_value = 18
HINTNTF_PARAM_FIELD.enum_type = ITEMPARAM
HINTNTF_PARAM_FIELD.type = 14
HINTNTF_PARAM_FIELD.cpp_type = 8
HINTNTF_ITEMID_FIELD.name = "itemid"
HINTNTF_ITEMID_FIELD.full_name = ".Cmd.HintNtf.itemid"
HINTNTF_ITEMID_FIELD.number = 3
HINTNTF_ITEMID_FIELD.index = 2
HINTNTF_ITEMID_FIELD.label = 1
HINTNTF_ITEMID_FIELD.has_default_value = true
HINTNTF_ITEMID_FIELD.default_value = 0
HINTNTF_ITEMID_FIELD.type = 13
HINTNTF_ITEMID_FIELD.cpp_type = 3
HINTNTF.name = "HintNtf"
HINTNTF.full_name = ".Cmd.HintNtf"
HINTNTF.nested_types = {}
HINTNTF.enum_types = {}
HINTNTF.fields = {
  HINTNTF_CMD_FIELD,
  HINTNTF_PARAM_FIELD,
  HINTNTF_ITEMID_FIELD
}
HINTNTF.is_extendable = false
HINTNTF.extensions = {}
ENCHANTEQUIP_CMD_FIELD.name = "cmd"
ENCHANTEQUIP_CMD_FIELD.full_name = ".Cmd.EnchantEquip.cmd"
ENCHANTEQUIP_CMD_FIELD.number = 1
ENCHANTEQUIP_CMD_FIELD.index = 0
ENCHANTEQUIP_CMD_FIELD.label = 1
ENCHANTEQUIP_CMD_FIELD.has_default_value = true
ENCHANTEQUIP_CMD_FIELD.default_value = 6
ENCHANTEQUIP_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ENCHANTEQUIP_CMD_FIELD.type = 14
ENCHANTEQUIP_CMD_FIELD.cpp_type = 8
ENCHANTEQUIP_PARAM_FIELD.name = "param"
ENCHANTEQUIP_PARAM_FIELD.full_name = ".Cmd.EnchantEquip.param"
ENCHANTEQUIP_PARAM_FIELD.number = 2
ENCHANTEQUIP_PARAM_FIELD.index = 1
ENCHANTEQUIP_PARAM_FIELD.label = 1
ENCHANTEQUIP_PARAM_FIELD.has_default_value = true
ENCHANTEQUIP_PARAM_FIELD.default_value = 19
ENCHANTEQUIP_PARAM_FIELD.enum_type = ITEMPARAM
ENCHANTEQUIP_PARAM_FIELD.type = 14
ENCHANTEQUIP_PARAM_FIELD.cpp_type = 8
ENCHANTEQUIP_TYPE_FIELD.name = "type"
ENCHANTEQUIP_TYPE_FIELD.full_name = ".Cmd.EnchantEquip.type"
ENCHANTEQUIP_TYPE_FIELD.number = 3
ENCHANTEQUIP_TYPE_FIELD.index = 2
ENCHANTEQUIP_TYPE_FIELD.label = 1
ENCHANTEQUIP_TYPE_FIELD.has_default_value = true
ENCHANTEQUIP_TYPE_FIELD.default_value = 0
ENCHANTEQUIP_TYPE_FIELD.enum_type = EENCHANTTYPE
ENCHANTEQUIP_TYPE_FIELD.type = 14
ENCHANTEQUIP_TYPE_FIELD.cpp_type = 8
ENCHANTEQUIP_GUID_FIELD.name = "guid"
ENCHANTEQUIP_GUID_FIELD.full_name = ".Cmd.EnchantEquip.guid"
ENCHANTEQUIP_GUID_FIELD.number = 4
ENCHANTEQUIP_GUID_FIELD.index = 3
ENCHANTEQUIP_GUID_FIELD.label = 1
ENCHANTEQUIP_GUID_FIELD.has_default_value = false
ENCHANTEQUIP_GUID_FIELD.default_value = ""
ENCHANTEQUIP_GUID_FIELD.type = 9
ENCHANTEQUIP_GUID_FIELD.cpp_type = 9
ENCHANTEQUIP.name = "EnchantEquip"
ENCHANTEQUIP.full_name = ".Cmd.EnchantEquip"
ENCHANTEQUIP.nested_types = {}
ENCHANTEQUIP.enum_types = {}
ENCHANTEQUIP.fields = {
  ENCHANTEQUIP_CMD_FIELD,
  ENCHANTEQUIP_PARAM_FIELD,
  ENCHANTEQUIP_TYPE_FIELD,
  ENCHANTEQUIP_GUID_FIELD
}
ENCHANTEQUIP.is_extendable = false
ENCHANTEQUIP.extensions = {}
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.name = "compose_id"
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.full_name = ".Cmd.TradeComposePair.compose_id"
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.number = 1
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.index = 0
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.label = 1
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.has_default_value = false
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.default_value = 0
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.type = 13
TRADECOMPOSEPAIR_COMPOSE_ID_FIELD.cpp_type = 3
TRADECOMPOSEPAIR_COUNT_FIELD.name = "count"
TRADECOMPOSEPAIR_COUNT_FIELD.full_name = ".Cmd.TradeComposePair.count"
TRADECOMPOSEPAIR_COUNT_FIELD.number = 2
TRADECOMPOSEPAIR_COUNT_FIELD.index = 1
TRADECOMPOSEPAIR_COUNT_FIELD.label = 1
TRADECOMPOSEPAIR_COUNT_FIELD.has_default_value = false
TRADECOMPOSEPAIR_COUNT_FIELD.default_value = 0
TRADECOMPOSEPAIR_COUNT_FIELD.type = 13
TRADECOMPOSEPAIR_COUNT_FIELD.cpp_type = 3
TRADECOMPOSEPAIR.name = "TradeComposePair"
TRADECOMPOSEPAIR.full_name = ".Cmd.TradeComposePair"
TRADECOMPOSEPAIR.nested_types = {}
TRADECOMPOSEPAIR.enum_types = {}
TRADECOMPOSEPAIR.fields = {
  TRADECOMPOSEPAIR_COMPOSE_ID_FIELD,
  TRADECOMPOSEPAIR_COUNT_FIELD
}
TRADECOMPOSEPAIR.is_extendable = false
TRADECOMPOSEPAIR.extensions = {}
TRADEREFINEDATA_COMPOSEINFOS_FIELD.name = "composeInfos"
TRADEREFINEDATA_COMPOSEINFOS_FIELD.full_name = ".Cmd.TradeRefineData.composeInfos"
TRADEREFINEDATA_COMPOSEINFOS_FIELD.number = 1
TRADEREFINEDATA_COMPOSEINFOS_FIELD.index = 0
TRADEREFINEDATA_COMPOSEINFOS_FIELD.label = 3
TRADEREFINEDATA_COMPOSEINFOS_FIELD.has_default_value = false
TRADEREFINEDATA_COMPOSEINFOS_FIELD.default_value = {}
TRADEREFINEDATA_COMPOSEINFOS_FIELD.message_type = TRADECOMPOSEPAIR
TRADEREFINEDATA_COMPOSEINFOS_FIELD.type = 11
TRADEREFINEDATA_COMPOSEINFOS_FIELD.cpp_type = 10
TRADEREFINEDATA.name = "TradeRefineData"
TRADEREFINEDATA.full_name = ".Cmd.TradeRefineData"
TRADEREFINEDATA.nested_types = {}
TRADEREFINEDATA.enum_types = {}
TRADEREFINEDATA.fields = {
  TRADEREFINEDATA_COMPOSEINFOS_FIELD
}
TRADEREFINEDATA.is_extendable = false
TRADEREFINEDATA.extensions = {}
TRADEITEMBASEINFO_ITEMID_FIELD.name = "itemid"
TRADEITEMBASEINFO_ITEMID_FIELD.full_name = ".Cmd.TradeItemBaseInfo.itemid"
TRADEITEMBASEINFO_ITEMID_FIELD.number = 1
TRADEITEMBASEINFO_ITEMID_FIELD.index = 0
TRADEITEMBASEINFO_ITEMID_FIELD.label = 1
TRADEITEMBASEINFO_ITEMID_FIELD.has_default_value = false
TRADEITEMBASEINFO_ITEMID_FIELD.default_value = 0
TRADEITEMBASEINFO_ITEMID_FIELD.type = 13
TRADEITEMBASEINFO_ITEMID_FIELD.cpp_type = 3
TRADEITEMBASEINFO_PRICE_FIELD.name = "price"
TRADEITEMBASEINFO_PRICE_FIELD.full_name = ".Cmd.TradeItemBaseInfo.price"
TRADEITEMBASEINFO_PRICE_FIELD.number = 2
TRADEITEMBASEINFO_PRICE_FIELD.index = 1
TRADEITEMBASEINFO_PRICE_FIELD.label = 1
TRADEITEMBASEINFO_PRICE_FIELD.has_default_value = false
TRADEITEMBASEINFO_PRICE_FIELD.default_value = 0
TRADEITEMBASEINFO_PRICE_FIELD.type = 4
TRADEITEMBASEINFO_PRICE_FIELD.cpp_type = 4
TRADEITEMBASEINFO_COUNT_FIELD.name = "count"
TRADEITEMBASEINFO_COUNT_FIELD.full_name = ".Cmd.TradeItemBaseInfo.count"
TRADEITEMBASEINFO_COUNT_FIELD.number = 3
TRADEITEMBASEINFO_COUNT_FIELD.index = 2
TRADEITEMBASEINFO_COUNT_FIELD.label = 1
TRADEITEMBASEINFO_COUNT_FIELD.has_default_value = false
TRADEITEMBASEINFO_COUNT_FIELD.default_value = 0
TRADEITEMBASEINFO_COUNT_FIELD.type = 13
TRADEITEMBASEINFO_COUNT_FIELD.cpp_type = 3
TRADEITEMBASEINFO_GUID_FIELD.name = "guid"
TRADEITEMBASEINFO_GUID_FIELD.full_name = ".Cmd.TradeItemBaseInfo.guid"
TRADEITEMBASEINFO_GUID_FIELD.number = 4
TRADEITEMBASEINFO_GUID_FIELD.index = 3
TRADEITEMBASEINFO_GUID_FIELD.label = 1
TRADEITEMBASEINFO_GUID_FIELD.has_default_value = false
TRADEITEMBASEINFO_GUID_FIELD.default_value = ""
TRADEITEMBASEINFO_GUID_FIELD.type = 9
TRADEITEMBASEINFO_GUID_FIELD.cpp_type = 9
TRADEITEMBASEINFO_ORDER_ID_FIELD.name = "order_id"
TRADEITEMBASEINFO_ORDER_ID_FIELD.full_name = ".Cmd.TradeItemBaseInfo.order_id"
TRADEITEMBASEINFO_ORDER_ID_FIELD.number = 5
TRADEITEMBASEINFO_ORDER_ID_FIELD.index = 4
TRADEITEMBASEINFO_ORDER_ID_FIELD.label = 1
TRADEITEMBASEINFO_ORDER_ID_FIELD.has_default_value = false
TRADEITEMBASEINFO_ORDER_ID_FIELD.default_value = 0
TRADEITEMBASEINFO_ORDER_ID_FIELD.type = 4
TRADEITEMBASEINFO_ORDER_ID_FIELD.cpp_type = 4
TRADEITEMBASEINFO_REFINE_LV_FIELD.name = "refine_lv"
TRADEITEMBASEINFO_REFINE_LV_FIELD.full_name = ".Cmd.TradeItemBaseInfo.refine_lv"
TRADEITEMBASEINFO_REFINE_LV_FIELD.number = 6
TRADEITEMBASEINFO_REFINE_LV_FIELD.index = 5
TRADEITEMBASEINFO_REFINE_LV_FIELD.label = 1
TRADEITEMBASEINFO_REFINE_LV_FIELD.has_default_value = false
TRADEITEMBASEINFO_REFINE_LV_FIELD.default_value = 0
TRADEITEMBASEINFO_REFINE_LV_FIELD.type = 13
TRADEITEMBASEINFO_REFINE_LV_FIELD.cpp_type = 3
TRADEITEMBASEINFO_OVERLAP_FIELD.name = "overlap"
TRADEITEMBASEINFO_OVERLAP_FIELD.full_name = ".Cmd.TradeItemBaseInfo.overlap"
TRADEITEMBASEINFO_OVERLAP_FIELD.number = 8
TRADEITEMBASEINFO_OVERLAP_FIELD.index = 6
TRADEITEMBASEINFO_OVERLAP_FIELD.label = 1
TRADEITEMBASEINFO_OVERLAP_FIELD.has_default_value = false
TRADEITEMBASEINFO_OVERLAP_FIELD.default_value = false
TRADEITEMBASEINFO_OVERLAP_FIELD.type = 8
TRADEITEMBASEINFO_OVERLAP_FIELD.cpp_type = 7
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.name = "is_expired"
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.full_name = ".Cmd.TradeItemBaseInfo.is_expired"
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.number = 9
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.index = 7
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.label = 1
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.has_default_value = false
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.default_value = false
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.type = 8
TRADEITEMBASEINFO_IS_EXPIRED_FIELD.cpp_type = 7
TRADEITEMBASEINFO_ITEM_DATA_FIELD.name = "item_data"
TRADEITEMBASEINFO_ITEM_DATA_FIELD.full_name = ".Cmd.TradeItemBaseInfo.item_data"
TRADEITEMBASEINFO_ITEM_DATA_FIELD.number = 10
TRADEITEMBASEINFO_ITEM_DATA_FIELD.index = 8
TRADEITEMBASEINFO_ITEM_DATA_FIELD.label = 1
TRADEITEMBASEINFO_ITEM_DATA_FIELD.has_default_value = false
TRADEITEMBASEINFO_ITEM_DATA_FIELD.default_value = nil
TRADEITEMBASEINFO_ITEM_DATA_FIELD.message_type = ITEMDATA
TRADEITEMBASEINFO_ITEM_DATA_FIELD.type = 11
TRADEITEMBASEINFO_ITEM_DATA_FIELD.cpp_type = 10
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.name = "publicity_id"
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.full_name = ".Cmd.TradeItemBaseInfo.publicity_id"
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.number = 11
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.index = 9
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.label = 1
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.has_default_value = true
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.default_value = 0
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.type = 13
TRADEITEMBASEINFO_PUBLICITY_ID_FIELD.cpp_type = 3
TRADEITEMBASEINFO_END_TIME_FIELD.name = "end_time"
TRADEITEMBASEINFO_END_TIME_FIELD.full_name = ".Cmd.TradeItemBaseInfo.end_time"
TRADEITEMBASEINFO_END_TIME_FIELD.number = 12
TRADEITEMBASEINFO_END_TIME_FIELD.index = 10
TRADEITEMBASEINFO_END_TIME_FIELD.label = 1
TRADEITEMBASEINFO_END_TIME_FIELD.has_default_value = true
TRADEITEMBASEINFO_END_TIME_FIELD.default_value = 0
TRADEITEMBASEINFO_END_TIME_FIELD.type = 13
TRADEITEMBASEINFO_END_TIME_FIELD.cpp_type = 3
TRADEITEMBASEINFO_KEY_FIELD.name = "key"
TRADEITEMBASEINFO_KEY_FIELD.full_name = ".Cmd.TradeItemBaseInfo.key"
TRADEITEMBASEINFO_KEY_FIELD.number = 13
TRADEITEMBASEINFO_KEY_FIELD.index = 11
TRADEITEMBASEINFO_KEY_FIELD.label = 1
TRADEITEMBASEINFO_KEY_FIELD.has_default_value = false
TRADEITEMBASEINFO_KEY_FIELD.default_value = ""
TRADEITEMBASEINFO_KEY_FIELD.type = 9
TRADEITEMBASEINFO_KEY_FIELD.cpp_type = 9
TRADEITEMBASEINFO_CHARID_FIELD.name = "charid"
TRADEITEMBASEINFO_CHARID_FIELD.full_name = ".Cmd.TradeItemBaseInfo.charid"
TRADEITEMBASEINFO_CHARID_FIELD.number = 14
TRADEITEMBASEINFO_CHARID_FIELD.index = 12
TRADEITEMBASEINFO_CHARID_FIELD.label = 1
TRADEITEMBASEINFO_CHARID_FIELD.has_default_value = false
TRADEITEMBASEINFO_CHARID_FIELD.default_value = 0
TRADEITEMBASEINFO_CHARID_FIELD.type = 4
TRADEITEMBASEINFO_CHARID_FIELD.cpp_type = 4
TRADEITEMBASEINFO_NAME_FIELD.name = "name"
TRADEITEMBASEINFO_NAME_FIELD.full_name = ".Cmd.TradeItemBaseInfo.name"
TRADEITEMBASEINFO_NAME_FIELD.number = 15
TRADEITEMBASEINFO_NAME_FIELD.index = 13
TRADEITEMBASEINFO_NAME_FIELD.label = 1
TRADEITEMBASEINFO_NAME_FIELD.has_default_value = false
TRADEITEMBASEINFO_NAME_FIELD.default_value = ""
TRADEITEMBASEINFO_NAME_FIELD.type = 9
TRADEITEMBASEINFO_NAME_FIELD.cpp_type = 9
TRADEITEMBASEINFO_TYPE_FIELD.name = "type"
TRADEITEMBASEINFO_TYPE_FIELD.full_name = ".Cmd.TradeItemBaseInfo.type"
TRADEITEMBASEINFO_TYPE_FIELD.number = 16
TRADEITEMBASEINFO_TYPE_FIELD.index = 14
TRADEITEMBASEINFO_TYPE_FIELD.label = 1
TRADEITEMBASEINFO_TYPE_FIELD.has_default_value = true
TRADEITEMBASEINFO_TYPE_FIELD.default_value = 1
TRADEITEMBASEINFO_TYPE_FIELD.enum_type = ETRADETYPE
TRADEITEMBASEINFO_TYPE_FIELD.type = 14
TRADEITEMBASEINFO_TYPE_FIELD.cpp_type = 8
TRADEITEMBASEINFO_UP_RATE_FIELD.name = "up_rate"
TRADEITEMBASEINFO_UP_RATE_FIELD.full_name = ".Cmd.TradeItemBaseInfo.up_rate"
TRADEITEMBASEINFO_UP_RATE_FIELD.number = 17
TRADEITEMBASEINFO_UP_RATE_FIELD.index = 15
TRADEITEMBASEINFO_UP_RATE_FIELD.label = 1
TRADEITEMBASEINFO_UP_RATE_FIELD.has_default_value = true
TRADEITEMBASEINFO_UP_RATE_FIELD.default_value = 0
TRADEITEMBASEINFO_UP_RATE_FIELD.type = 13
TRADEITEMBASEINFO_UP_RATE_FIELD.cpp_type = 3
TRADEITEMBASEINFO_DOWN_RATE_FIELD.name = "down_rate"
TRADEITEMBASEINFO_DOWN_RATE_FIELD.full_name = ".Cmd.TradeItemBaseInfo.down_rate"
TRADEITEMBASEINFO_DOWN_RATE_FIELD.number = 18
TRADEITEMBASEINFO_DOWN_RATE_FIELD.index = 16
TRADEITEMBASEINFO_DOWN_RATE_FIELD.label = 1
TRADEITEMBASEINFO_DOWN_RATE_FIELD.has_default_value = true
TRADEITEMBASEINFO_DOWN_RATE_FIELD.default_value = 0
TRADEITEMBASEINFO_DOWN_RATE_FIELD.type = 13
TRADEITEMBASEINFO_DOWN_RATE_FIELD.cpp_type = 3
TRADEITEMBASEINFO.name = "TradeItemBaseInfo"
TRADEITEMBASEINFO.full_name = ".Cmd.TradeItemBaseInfo"
TRADEITEMBASEINFO.nested_types = {}
TRADEITEMBASEINFO.enum_types = {}
TRADEITEMBASEINFO.fields = {
  TRADEITEMBASEINFO_ITEMID_FIELD,
  TRADEITEMBASEINFO_PRICE_FIELD,
  TRADEITEMBASEINFO_COUNT_FIELD,
  TRADEITEMBASEINFO_GUID_FIELD,
  TRADEITEMBASEINFO_ORDER_ID_FIELD,
  TRADEITEMBASEINFO_REFINE_LV_FIELD,
  TRADEITEMBASEINFO_OVERLAP_FIELD,
  TRADEITEMBASEINFO_IS_EXPIRED_FIELD,
  TRADEITEMBASEINFO_ITEM_DATA_FIELD,
  TRADEITEMBASEINFO_PUBLICITY_ID_FIELD,
  TRADEITEMBASEINFO_END_TIME_FIELD,
  TRADEITEMBASEINFO_KEY_FIELD,
  TRADEITEMBASEINFO_CHARID_FIELD,
  TRADEITEMBASEINFO_NAME_FIELD,
  TRADEITEMBASEINFO_TYPE_FIELD,
  TRADEITEMBASEINFO_UP_RATE_FIELD,
  TRADEITEMBASEINFO_DOWN_RATE_FIELD
}
TRADEITEMBASEINFO.is_extendable = false
TRADEITEMBASEINFO.extensions = {}
PROCESSENCHANTITEMCMD_CMD_FIELD.name = "cmd"
PROCESSENCHANTITEMCMD_CMD_FIELD.full_name = ".Cmd.ProcessEnchantItemCmd.cmd"
PROCESSENCHANTITEMCMD_CMD_FIELD.number = 1
PROCESSENCHANTITEMCMD_CMD_FIELD.index = 0
PROCESSENCHANTITEMCMD_CMD_FIELD.label = 1
PROCESSENCHANTITEMCMD_CMD_FIELD.has_default_value = true
PROCESSENCHANTITEMCMD_CMD_FIELD.default_value = 6
PROCESSENCHANTITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PROCESSENCHANTITEMCMD_CMD_FIELD.type = 14
PROCESSENCHANTITEMCMD_CMD_FIELD.cpp_type = 8
PROCESSENCHANTITEMCMD_PARAM_FIELD.name = "param"
PROCESSENCHANTITEMCMD_PARAM_FIELD.full_name = ".Cmd.ProcessEnchantItemCmd.param"
PROCESSENCHANTITEMCMD_PARAM_FIELD.number = 2
PROCESSENCHANTITEMCMD_PARAM_FIELD.index = 1
PROCESSENCHANTITEMCMD_PARAM_FIELD.label = 1
PROCESSENCHANTITEMCMD_PARAM_FIELD.has_default_value = true
PROCESSENCHANTITEMCMD_PARAM_FIELD.default_value = 20
PROCESSENCHANTITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
PROCESSENCHANTITEMCMD_PARAM_FIELD.type = 14
PROCESSENCHANTITEMCMD_PARAM_FIELD.cpp_type = 8
PROCESSENCHANTITEMCMD_SAVE_FIELD.name = "save"
PROCESSENCHANTITEMCMD_SAVE_FIELD.full_name = ".Cmd.ProcessEnchantItemCmd.save"
PROCESSENCHANTITEMCMD_SAVE_FIELD.number = 3
PROCESSENCHANTITEMCMD_SAVE_FIELD.index = 2
PROCESSENCHANTITEMCMD_SAVE_FIELD.label = 1
PROCESSENCHANTITEMCMD_SAVE_FIELD.has_default_value = true
PROCESSENCHANTITEMCMD_SAVE_FIELD.default_value = false
PROCESSENCHANTITEMCMD_SAVE_FIELD.type = 8
PROCESSENCHANTITEMCMD_SAVE_FIELD.cpp_type = 7
PROCESSENCHANTITEMCMD_ITEMID_FIELD.name = "itemid"
PROCESSENCHANTITEMCMD_ITEMID_FIELD.full_name = ".Cmd.ProcessEnchantItemCmd.itemid"
PROCESSENCHANTITEMCMD_ITEMID_FIELD.number = 4
PROCESSENCHANTITEMCMD_ITEMID_FIELD.index = 3
PROCESSENCHANTITEMCMD_ITEMID_FIELD.label = 1
PROCESSENCHANTITEMCMD_ITEMID_FIELD.has_default_value = false
PROCESSENCHANTITEMCMD_ITEMID_FIELD.default_value = ""
PROCESSENCHANTITEMCMD_ITEMID_FIELD.type = 9
PROCESSENCHANTITEMCMD_ITEMID_FIELD.cpp_type = 9
PROCESSENCHANTITEMCMD.name = "ProcessEnchantItemCmd"
PROCESSENCHANTITEMCMD.full_name = ".Cmd.ProcessEnchantItemCmd"
PROCESSENCHANTITEMCMD.nested_types = {}
PROCESSENCHANTITEMCMD.enum_types = {}
PROCESSENCHANTITEMCMD.fields = {
  PROCESSENCHANTITEMCMD_CMD_FIELD,
  PROCESSENCHANTITEMCMD_PARAM_FIELD,
  PROCESSENCHANTITEMCMD_SAVE_FIELD,
  PROCESSENCHANTITEMCMD_ITEMID_FIELD
}
PROCESSENCHANTITEMCMD.is_extendable = false
PROCESSENCHANTITEMCMD.extensions = {}
EQUIPEXCHANGEITEMCMD_CMD_FIELD.name = "cmd"
EQUIPEXCHANGEITEMCMD_CMD_FIELD.full_name = ".Cmd.EquipExchangeItemCmd.cmd"
EQUIPEXCHANGEITEMCMD_CMD_FIELD.number = 1
EQUIPEXCHANGEITEMCMD_CMD_FIELD.index = 0
EQUIPEXCHANGEITEMCMD_CMD_FIELD.label = 1
EQUIPEXCHANGEITEMCMD_CMD_FIELD.has_default_value = true
EQUIPEXCHANGEITEMCMD_CMD_FIELD.default_value = 6
EQUIPEXCHANGEITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIPEXCHANGEITEMCMD_CMD_FIELD.type = 14
EQUIPEXCHANGEITEMCMD_CMD_FIELD.cpp_type = 8
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.name = "param"
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.full_name = ".Cmd.EquipExchangeItemCmd.param"
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.number = 2
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.index = 1
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.label = 1
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.has_default_value = true
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.default_value = 21
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.type = 14
EQUIPEXCHANGEITEMCMD_PARAM_FIELD.cpp_type = 8
EQUIPEXCHANGEITEMCMD_GUID_FIELD.name = "guid"
EQUIPEXCHANGEITEMCMD_GUID_FIELD.full_name = ".Cmd.EquipExchangeItemCmd.guid"
EQUIPEXCHANGEITEMCMD_GUID_FIELD.number = 3
EQUIPEXCHANGEITEMCMD_GUID_FIELD.index = 2
EQUIPEXCHANGEITEMCMD_GUID_FIELD.label = 1
EQUIPEXCHANGEITEMCMD_GUID_FIELD.has_default_value = false
EQUIPEXCHANGEITEMCMD_GUID_FIELD.default_value = ""
EQUIPEXCHANGEITEMCMD_GUID_FIELD.type = 9
EQUIPEXCHANGEITEMCMD_GUID_FIELD.cpp_type = 9
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.name = "type"
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.full_name = ".Cmd.EquipExchangeItemCmd.type"
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.number = 4
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.index = 3
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.label = 1
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.has_default_value = true
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.default_value = 0
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.enum_type = EEXCHANGETYPE
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.type = 14
EQUIPEXCHANGEITEMCMD_TYPE_FIELD.cpp_type = 8
EQUIPEXCHANGEITEMCMD.name = "EquipExchangeItemCmd"
EQUIPEXCHANGEITEMCMD.full_name = ".Cmd.EquipExchangeItemCmd"
EQUIPEXCHANGEITEMCMD.nested_types = {}
EQUIPEXCHANGEITEMCMD.enum_types = {}
EQUIPEXCHANGEITEMCMD.fields = {
  EQUIPEXCHANGEITEMCMD_CMD_FIELD,
  EQUIPEXCHANGEITEMCMD_PARAM_FIELD,
  EQUIPEXCHANGEITEMCMD_GUID_FIELD,
  EQUIPEXCHANGEITEMCMD_TYPE_FIELD
}
EQUIPEXCHANGEITEMCMD.is_extendable = false
EQUIPEXCHANGEITEMCMD.extensions = {}
ONOFFSTOREITEMCMD_CMD_FIELD.name = "cmd"
ONOFFSTOREITEMCMD_CMD_FIELD.full_name = ".Cmd.OnOffStoreItemCmd.cmd"
ONOFFSTOREITEMCMD_CMD_FIELD.number = 1
ONOFFSTOREITEMCMD_CMD_FIELD.index = 0
ONOFFSTOREITEMCMD_CMD_FIELD.label = 1
ONOFFSTOREITEMCMD_CMD_FIELD.has_default_value = true
ONOFFSTOREITEMCMD_CMD_FIELD.default_value = 6
ONOFFSTOREITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ONOFFSTOREITEMCMD_CMD_FIELD.type = 14
ONOFFSTOREITEMCMD_CMD_FIELD.cpp_type = 8
ONOFFSTOREITEMCMD_PARAM_FIELD.name = "param"
ONOFFSTOREITEMCMD_PARAM_FIELD.full_name = ".Cmd.OnOffStoreItemCmd.param"
ONOFFSTOREITEMCMD_PARAM_FIELD.number = 2
ONOFFSTOREITEMCMD_PARAM_FIELD.index = 1
ONOFFSTOREITEMCMD_PARAM_FIELD.label = 1
ONOFFSTOREITEMCMD_PARAM_FIELD.has_default_value = true
ONOFFSTOREITEMCMD_PARAM_FIELD.default_value = 22
ONOFFSTOREITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
ONOFFSTOREITEMCMD_PARAM_FIELD.type = 14
ONOFFSTOREITEMCMD_PARAM_FIELD.cpp_type = 8
ONOFFSTOREITEMCMD_OPEN_FIELD.name = "open"
ONOFFSTOREITEMCMD_OPEN_FIELD.full_name = ".Cmd.OnOffStoreItemCmd.open"
ONOFFSTOREITEMCMD_OPEN_FIELD.number = 3
ONOFFSTOREITEMCMD_OPEN_FIELD.index = 2
ONOFFSTOREITEMCMD_OPEN_FIELD.label = 1
ONOFFSTOREITEMCMD_OPEN_FIELD.has_default_value = true
ONOFFSTOREITEMCMD_OPEN_FIELD.default_value = false
ONOFFSTOREITEMCMD_OPEN_FIELD.type = 8
ONOFFSTOREITEMCMD_OPEN_FIELD.cpp_type = 7
ONOFFSTOREITEMCMD.name = "OnOffStoreItemCmd"
ONOFFSTOREITEMCMD.full_name = ".Cmd.OnOffStoreItemCmd"
ONOFFSTOREITEMCMD.nested_types = {}
ONOFFSTOREITEMCMD.enum_types = {}
ONOFFSTOREITEMCMD.fields = {
  ONOFFSTOREITEMCMD_CMD_FIELD,
  ONOFFSTOREITEMCMD_PARAM_FIELD,
  ONOFFSTOREITEMCMD_OPEN_FIELD
}
ONOFFSTOREITEMCMD.is_extendable = false
ONOFFSTOREITEMCMD.extensions = {}
PACKSLOTNTFITEMCMD_CMD_FIELD.name = "cmd"
PACKSLOTNTFITEMCMD_CMD_FIELD.full_name = ".Cmd.PackSlotNtfItemCmd.cmd"
PACKSLOTNTFITEMCMD_CMD_FIELD.number = 1
PACKSLOTNTFITEMCMD_CMD_FIELD.index = 0
PACKSLOTNTFITEMCMD_CMD_FIELD.label = 1
PACKSLOTNTFITEMCMD_CMD_FIELD.has_default_value = true
PACKSLOTNTFITEMCMD_CMD_FIELD.default_value = 6
PACKSLOTNTFITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PACKSLOTNTFITEMCMD_CMD_FIELD.type = 14
PACKSLOTNTFITEMCMD_CMD_FIELD.cpp_type = 8
PACKSLOTNTFITEMCMD_PARAM_FIELD.name = "param"
PACKSLOTNTFITEMCMD_PARAM_FIELD.full_name = ".Cmd.PackSlotNtfItemCmd.param"
PACKSLOTNTFITEMCMD_PARAM_FIELD.number = 2
PACKSLOTNTFITEMCMD_PARAM_FIELD.index = 1
PACKSLOTNTFITEMCMD_PARAM_FIELD.label = 1
PACKSLOTNTFITEMCMD_PARAM_FIELD.has_default_value = true
PACKSLOTNTFITEMCMD_PARAM_FIELD.default_value = 23
PACKSLOTNTFITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
PACKSLOTNTFITEMCMD_PARAM_FIELD.type = 14
PACKSLOTNTFITEMCMD_PARAM_FIELD.cpp_type = 8
PACKSLOTNTFITEMCMD_TYPE_FIELD.name = "type"
PACKSLOTNTFITEMCMD_TYPE_FIELD.full_name = ".Cmd.PackSlotNtfItemCmd.type"
PACKSLOTNTFITEMCMD_TYPE_FIELD.number = 3
PACKSLOTNTFITEMCMD_TYPE_FIELD.index = 2
PACKSLOTNTFITEMCMD_TYPE_FIELD.label = 1
PACKSLOTNTFITEMCMD_TYPE_FIELD.has_default_value = true
PACKSLOTNTFITEMCMD_TYPE_FIELD.default_value = 0
PACKSLOTNTFITEMCMD_TYPE_FIELD.enum_type = EPACKTYPE
PACKSLOTNTFITEMCMD_TYPE_FIELD.type = 14
PACKSLOTNTFITEMCMD_TYPE_FIELD.cpp_type = 8
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.name = "maxslot"
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.full_name = ".Cmd.PackSlotNtfItemCmd.maxslot"
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.number = 4
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.index = 3
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.label = 1
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.has_default_value = true
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.default_value = 0
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.type = 13
PACKSLOTNTFITEMCMD_MAXSLOT_FIELD.cpp_type = 3
PACKSLOTNTFITEMCMD.name = "PackSlotNtfItemCmd"
PACKSLOTNTFITEMCMD.full_name = ".Cmd.PackSlotNtfItemCmd"
PACKSLOTNTFITEMCMD.nested_types = {}
PACKSLOTNTFITEMCMD.enum_types = {}
PACKSLOTNTFITEMCMD.fields = {
  PACKSLOTNTFITEMCMD_CMD_FIELD,
  PACKSLOTNTFITEMCMD_PARAM_FIELD,
  PACKSLOTNTFITEMCMD_TYPE_FIELD,
  PACKSLOTNTFITEMCMD_MAXSLOT_FIELD
}
PACKSLOTNTFITEMCMD.is_extendable = false
PACKSLOTNTFITEMCMD.extensions = {}
RESTOREEQUIPITEMCMD_CMD_FIELD.name = "cmd"
RESTOREEQUIPITEMCMD_CMD_FIELD.full_name = ".Cmd.RestoreEquipItemCmd.cmd"
RESTOREEQUIPITEMCMD_CMD_FIELD.number = 1
RESTOREEQUIPITEMCMD_CMD_FIELD.index = 0
RESTOREEQUIPITEMCMD_CMD_FIELD.label = 1
RESTOREEQUIPITEMCMD_CMD_FIELD.has_default_value = true
RESTOREEQUIPITEMCMD_CMD_FIELD.default_value = 6
RESTOREEQUIPITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RESTOREEQUIPITEMCMD_CMD_FIELD.type = 14
RESTOREEQUIPITEMCMD_CMD_FIELD.cpp_type = 8
RESTOREEQUIPITEMCMD_PARAM_FIELD.name = "param"
RESTOREEQUIPITEMCMD_PARAM_FIELD.full_name = ".Cmd.RestoreEquipItemCmd.param"
RESTOREEQUIPITEMCMD_PARAM_FIELD.number = 2
RESTOREEQUIPITEMCMD_PARAM_FIELD.index = 1
RESTOREEQUIPITEMCMD_PARAM_FIELD.label = 1
RESTOREEQUIPITEMCMD_PARAM_FIELD.has_default_value = true
RESTOREEQUIPITEMCMD_PARAM_FIELD.default_value = 24
RESTOREEQUIPITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
RESTOREEQUIPITEMCMD_PARAM_FIELD.type = 14
RESTOREEQUIPITEMCMD_PARAM_FIELD.cpp_type = 8
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.name = "equipid"
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.full_name = ".Cmd.RestoreEquipItemCmd.equipid"
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.number = 3
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.index = 2
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.label = 1
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.has_default_value = false
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.default_value = ""
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.type = 9
RESTOREEQUIPITEMCMD_EQUIPID_FIELD.cpp_type = 9
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.name = "strengthlv"
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.full_name = ".Cmd.RestoreEquipItemCmd.strengthlv"
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.number = 4
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.index = 3
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.label = 1
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.has_default_value = true
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.default_value = false
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.type = 8
RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD.cpp_type = 7
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.name = "cardids"
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.full_name = ".Cmd.RestoreEquipItemCmd.cardids"
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.number = 5
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.index = 4
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.label = 3
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.has_default_value = false
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.default_value = {}
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.type = 9
RESTOREEQUIPITEMCMD_CARDIDS_FIELD.cpp_type = 9
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.name = "enchant"
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.full_name = ".Cmd.RestoreEquipItemCmd.enchant"
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.number = 6
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.index = 5
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.label = 1
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.has_default_value = true
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.default_value = false
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.type = 8
RESTOREEQUIPITEMCMD_ENCHANT_FIELD.cpp_type = 7
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.name = "upgrade"
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.full_name = ".Cmd.RestoreEquipItemCmd.upgrade"
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.number = 7
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.index = 6
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.label = 1
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.has_default_value = true
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.default_value = false
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.type = 8
RESTOREEQUIPITEMCMD_UPGRADE_FIELD.cpp_type = 7
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.name = "strengthlv2"
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.full_name = ".Cmd.RestoreEquipItemCmd.strengthlv2"
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.number = 8
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.index = 7
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.label = 1
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.has_default_value = true
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.default_value = false
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.type = 8
RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD.cpp_type = 7
RESTOREEQUIPITEMCMD.name = "RestoreEquipItemCmd"
RESTOREEQUIPITEMCMD.full_name = ".Cmd.RestoreEquipItemCmd"
RESTOREEQUIPITEMCMD.nested_types = {}
RESTOREEQUIPITEMCMD.enum_types = {}
RESTOREEQUIPITEMCMD.fields = {
  RESTOREEQUIPITEMCMD_CMD_FIELD,
  RESTOREEQUIPITEMCMD_PARAM_FIELD,
  RESTOREEQUIPITEMCMD_EQUIPID_FIELD,
  RESTOREEQUIPITEMCMD_STRENGTHLV_FIELD,
  RESTOREEQUIPITEMCMD_CARDIDS_FIELD,
  RESTOREEQUIPITEMCMD_ENCHANT_FIELD,
  RESTOREEQUIPITEMCMD_UPGRADE_FIELD,
  RESTOREEQUIPITEMCMD_STRENGTHLV2_FIELD
}
RESTOREEQUIPITEMCMD.is_extendable = false
RESTOREEQUIPITEMCMD.extensions = {}
USECOUNTITEMCMD_CMD_FIELD.name = "cmd"
USECOUNTITEMCMD_CMD_FIELD.full_name = ".Cmd.UseCountItemCmd.cmd"
USECOUNTITEMCMD_CMD_FIELD.number = 1
USECOUNTITEMCMD_CMD_FIELD.index = 0
USECOUNTITEMCMD_CMD_FIELD.label = 1
USECOUNTITEMCMD_CMD_FIELD.has_default_value = true
USECOUNTITEMCMD_CMD_FIELD.default_value = 6
USECOUNTITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USECOUNTITEMCMD_CMD_FIELD.type = 14
USECOUNTITEMCMD_CMD_FIELD.cpp_type = 8
USECOUNTITEMCMD_PARAM_FIELD.name = "param"
USECOUNTITEMCMD_PARAM_FIELD.full_name = ".Cmd.UseCountItemCmd.param"
USECOUNTITEMCMD_PARAM_FIELD.number = 2
USECOUNTITEMCMD_PARAM_FIELD.index = 1
USECOUNTITEMCMD_PARAM_FIELD.label = 1
USECOUNTITEMCMD_PARAM_FIELD.has_default_value = true
USECOUNTITEMCMD_PARAM_FIELD.default_value = 25
USECOUNTITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
USECOUNTITEMCMD_PARAM_FIELD.type = 14
USECOUNTITEMCMD_PARAM_FIELD.cpp_type = 8
USECOUNTITEMCMD_ITEMID_FIELD.name = "itemid"
USECOUNTITEMCMD_ITEMID_FIELD.full_name = ".Cmd.UseCountItemCmd.itemid"
USECOUNTITEMCMD_ITEMID_FIELD.number = 3
USECOUNTITEMCMD_ITEMID_FIELD.index = 2
USECOUNTITEMCMD_ITEMID_FIELD.label = 2
USECOUNTITEMCMD_ITEMID_FIELD.has_default_value = false
USECOUNTITEMCMD_ITEMID_FIELD.default_value = 0
USECOUNTITEMCMD_ITEMID_FIELD.type = 13
USECOUNTITEMCMD_ITEMID_FIELD.cpp_type = 3
USECOUNTITEMCMD_COUNT_FIELD.name = "count"
USECOUNTITEMCMD_COUNT_FIELD.full_name = ".Cmd.UseCountItemCmd.count"
USECOUNTITEMCMD_COUNT_FIELD.number = 4
USECOUNTITEMCMD_COUNT_FIELD.index = 3
USECOUNTITEMCMD_COUNT_FIELD.label = 1
USECOUNTITEMCMD_COUNT_FIELD.has_default_value = true
USECOUNTITEMCMD_COUNT_FIELD.default_value = 0
USECOUNTITEMCMD_COUNT_FIELD.type = 13
USECOUNTITEMCMD_COUNT_FIELD.cpp_type = 3
USECOUNTITEMCMD.name = "UseCountItemCmd"
USECOUNTITEMCMD.full_name = ".Cmd.UseCountItemCmd"
USECOUNTITEMCMD.nested_types = {}
USECOUNTITEMCMD.enum_types = {}
USECOUNTITEMCMD.fields = {
  USECOUNTITEMCMD_CMD_FIELD,
  USECOUNTITEMCMD_PARAM_FIELD,
  USECOUNTITEMCMD_ITEMID_FIELD,
  USECOUNTITEMCMD_COUNT_FIELD
}
USECOUNTITEMCMD.is_extendable = false
USECOUNTITEMCMD.extensions = {}
EXCHANGECARDITEMCMD_CMD_FIELD.name = "cmd"
EXCHANGECARDITEMCMD_CMD_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.cmd"
EXCHANGECARDITEMCMD_CMD_FIELD.number = 1
EXCHANGECARDITEMCMD_CMD_FIELD.index = 0
EXCHANGECARDITEMCMD_CMD_FIELD.label = 1
EXCHANGECARDITEMCMD_CMD_FIELD.has_default_value = true
EXCHANGECARDITEMCMD_CMD_FIELD.default_value = 6
EXCHANGECARDITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EXCHANGECARDITEMCMD_CMD_FIELD.type = 14
EXCHANGECARDITEMCMD_CMD_FIELD.cpp_type = 8
EXCHANGECARDITEMCMD_PARAM_FIELD.name = "param"
EXCHANGECARDITEMCMD_PARAM_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.param"
EXCHANGECARDITEMCMD_PARAM_FIELD.number = 2
EXCHANGECARDITEMCMD_PARAM_FIELD.index = 1
EXCHANGECARDITEMCMD_PARAM_FIELD.label = 1
EXCHANGECARDITEMCMD_PARAM_FIELD.has_default_value = true
EXCHANGECARDITEMCMD_PARAM_FIELD.default_value = 28
EXCHANGECARDITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
EXCHANGECARDITEMCMD_PARAM_FIELD.type = 14
EXCHANGECARDITEMCMD_PARAM_FIELD.cpp_type = 8
EXCHANGECARDITEMCMD_TYPE_FIELD.name = "type"
EXCHANGECARDITEMCMD_TYPE_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.type"
EXCHANGECARDITEMCMD_TYPE_FIELD.number = 3
EXCHANGECARDITEMCMD_TYPE_FIELD.index = 2
EXCHANGECARDITEMCMD_TYPE_FIELD.label = 1
EXCHANGECARDITEMCMD_TYPE_FIELD.has_default_value = true
EXCHANGECARDITEMCMD_TYPE_FIELD.default_value = 1
EXCHANGECARDITEMCMD_TYPE_FIELD.enum_type = EEXCHANGECARDTYPE
EXCHANGECARDITEMCMD_TYPE_FIELD.type = 14
EXCHANGECARDITEMCMD_TYPE_FIELD.cpp_type = 8
EXCHANGECARDITEMCMD_NPCID_FIELD.name = "npcid"
EXCHANGECARDITEMCMD_NPCID_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.npcid"
EXCHANGECARDITEMCMD_NPCID_FIELD.number = 4
EXCHANGECARDITEMCMD_NPCID_FIELD.index = 3
EXCHANGECARDITEMCMD_NPCID_FIELD.label = 1
EXCHANGECARDITEMCMD_NPCID_FIELD.has_default_value = true
EXCHANGECARDITEMCMD_NPCID_FIELD.default_value = 0
EXCHANGECARDITEMCMD_NPCID_FIELD.type = 4
EXCHANGECARDITEMCMD_NPCID_FIELD.cpp_type = 4
EXCHANGECARDITEMCMD_MATERIAL_FIELD.name = "material"
EXCHANGECARDITEMCMD_MATERIAL_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.material"
EXCHANGECARDITEMCMD_MATERIAL_FIELD.number = 5
EXCHANGECARDITEMCMD_MATERIAL_FIELD.index = 4
EXCHANGECARDITEMCMD_MATERIAL_FIELD.label = 3
EXCHANGECARDITEMCMD_MATERIAL_FIELD.has_default_value = false
EXCHANGECARDITEMCMD_MATERIAL_FIELD.default_value = {}
EXCHANGECARDITEMCMD_MATERIAL_FIELD.type = 9
EXCHANGECARDITEMCMD_MATERIAL_FIELD.cpp_type = 9
EXCHANGECARDITEMCMD_CHARID_FIELD.name = "charid"
EXCHANGECARDITEMCMD_CHARID_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.charid"
EXCHANGECARDITEMCMD_CHARID_FIELD.number = 6
EXCHANGECARDITEMCMD_CHARID_FIELD.index = 5
EXCHANGECARDITEMCMD_CHARID_FIELD.label = 1
EXCHANGECARDITEMCMD_CHARID_FIELD.has_default_value = true
EXCHANGECARDITEMCMD_CHARID_FIELD.default_value = 0
EXCHANGECARDITEMCMD_CHARID_FIELD.type = 4
EXCHANGECARDITEMCMD_CHARID_FIELD.cpp_type = 4
EXCHANGECARDITEMCMD_CARDID_FIELD.name = "cardid"
EXCHANGECARDITEMCMD_CARDID_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.cardid"
EXCHANGECARDITEMCMD_CARDID_FIELD.number = 7
EXCHANGECARDITEMCMD_CARDID_FIELD.index = 6
EXCHANGECARDITEMCMD_CARDID_FIELD.label = 1
EXCHANGECARDITEMCMD_CARDID_FIELD.has_default_value = true
EXCHANGECARDITEMCMD_CARDID_FIELD.default_value = 0
EXCHANGECARDITEMCMD_CARDID_FIELD.type = 13
EXCHANGECARDITEMCMD_CARDID_FIELD.cpp_type = 3
EXCHANGECARDITEMCMD_ANIM_FIELD.name = "anim"
EXCHANGECARDITEMCMD_ANIM_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.anim"
EXCHANGECARDITEMCMD_ANIM_FIELD.number = 8
EXCHANGECARDITEMCMD_ANIM_FIELD.index = 7
EXCHANGECARDITEMCMD_ANIM_FIELD.label = 1
EXCHANGECARDITEMCMD_ANIM_FIELD.has_default_value = true
EXCHANGECARDITEMCMD_ANIM_FIELD.default_value = false
EXCHANGECARDITEMCMD_ANIM_FIELD.type = 8
EXCHANGECARDITEMCMD_ANIM_FIELD.cpp_type = 7
EXCHANGECARDITEMCMD_ITEMS_FIELD.name = "items"
EXCHANGECARDITEMCMD_ITEMS_FIELD.full_name = ".Cmd.ExchangeCardItemCmd.items"
EXCHANGECARDITEMCMD_ITEMS_FIELD.number = 9
EXCHANGECARDITEMCMD_ITEMS_FIELD.index = 8
EXCHANGECARDITEMCMD_ITEMS_FIELD.label = 3
EXCHANGECARDITEMCMD_ITEMS_FIELD.has_default_value = false
EXCHANGECARDITEMCMD_ITEMS_FIELD.default_value = {}
EXCHANGECARDITEMCMD_ITEMS_FIELD.message_type = ITEMINFO
EXCHANGECARDITEMCMD_ITEMS_FIELD.type = 11
EXCHANGECARDITEMCMD_ITEMS_FIELD.cpp_type = 10
EXCHANGECARDITEMCMD.name = "ExchangeCardItemCmd"
EXCHANGECARDITEMCMD.full_name = ".Cmd.ExchangeCardItemCmd"
EXCHANGECARDITEMCMD.nested_types = {}
EXCHANGECARDITEMCMD.enum_types = {}
EXCHANGECARDITEMCMD.fields = {
  EXCHANGECARDITEMCMD_CMD_FIELD,
  EXCHANGECARDITEMCMD_PARAM_FIELD,
  EXCHANGECARDITEMCMD_TYPE_FIELD,
  EXCHANGECARDITEMCMD_NPCID_FIELD,
  EXCHANGECARDITEMCMD_MATERIAL_FIELD,
  EXCHANGECARDITEMCMD_CHARID_FIELD,
  EXCHANGECARDITEMCMD_CARDID_FIELD,
  EXCHANGECARDITEMCMD_ANIM_FIELD,
  EXCHANGECARDITEMCMD_ITEMS_FIELD
}
EXCHANGECARDITEMCMD.is_extendable = false
EXCHANGECARDITEMCMD.extensions = {}
GETCOUNTITEMCMD_CMD_FIELD.name = "cmd"
GETCOUNTITEMCMD_CMD_FIELD.full_name = ".Cmd.GetCountItemCmd.cmd"
GETCOUNTITEMCMD_CMD_FIELD.number = 1
GETCOUNTITEMCMD_CMD_FIELD.index = 0
GETCOUNTITEMCMD_CMD_FIELD.label = 1
GETCOUNTITEMCMD_CMD_FIELD.has_default_value = true
GETCOUNTITEMCMD_CMD_FIELD.default_value = 6
GETCOUNTITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GETCOUNTITEMCMD_CMD_FIELD.type = 14
GETCOUNTITEMCMD_CMD_FIELD.cpp_type = 8
GETCOUNTITEMCMD_PARAM_FIELD.name = "param"
GETCOUNTITEMCMD_PARAM_FIELD.full_name = ".Cmd.GetCountItemCmd.param"
GETCOUNTITEMCMD_PARAM_FIELD.number = 2
GETCOUNTITEMCMD_PARAM_FIELD.index = 1
GETCOUNTITEMCMD_PARAM_FIELD.label = 1
GETCOUNTITEMCMD_PARAM_FIELD.has_default_value = true
GETCOUNTITEMCMD_PARAM_FIELD.default_value = 29
GETCOUNTITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
GETCOUNTITEMCMD_PARAM_FIELD.type = 14
GETCOUNTITEMCMD_PARAM_FIELD.cpp_type = 8
GETCOUNTITEMCMD_ITEMID_FIELD.name = "itemid"
GETCOUNTITEMCMD_ITEMID_FIELD.full_name = ".Cmd.GetCountItemCmd.itemid"
GETCOUNTITEMCMD_ITEMID_FIELD.number = 3
GETCOUNTITEMCMD_ITEMID_FIELD.index = 2
GETCOUNTITEMCMD_ITEMID_FIELD.label = 1
GETCOUNTITEMCMD_ITEMID_FIELD.has_default_value = false
GETCOUNTITEMCMD_ITEMID_FIELD.default_value = 0
GETCOUNTITEMCMD_ITEMID_FIELD.type = 13
GETCOUNTITEMCMD_ITEMID_FIELD.cpp_type = 3
GETCOUNTITEMCMD_COUNT_FIELD.name = "count"
GETCOUNTITEMCMD_COUNT_FIELD.full_name = ".Cmd.GetCountItemCmd.count"
GETCOUNTITEMCMD_COUNT_FIELD.number = 4
GETCOUNTITEMCMD_COUNT_FIELD.index = 3
GETCOUNTITEMCMD_COUNT_FIELD.label = 1
GETCOUNTITEMCMD_COUNT_FIELD.has_default_value = true
GETCOUNTITEMCMD_COUNT_FIELD.default_value = 0
GETCOUNTITEMCMD_COUNT_FIELD.type = 13
GETCOUNTITEMCMD_COUNT_FIELD.cpp_type = 3
GETCOUNTITEMCMD_SOURCE_FIELD.name = "source"
GETCOUNTITEMCMD_SOURCE_FIELD.full_name = ".Cmd.GetCountItemCmd.source"
GETCOUNTITEMCMD_SOURCE_FIELD.number = 5
GETCOUNTITEMCMD_SOURCE_FIELD.index = 4
GETCOUNTITEMCMD_SOURCE_FIELD.label = 1
GETCOUNTITEMCMD_SOURCE_FIELD.has_default_value = true
GETCOUNTITEMCMD_SOURCE_FIELD.default_value = 0
GETCOUNTITEMCMD_SOURCE_FIELD.enum_type = PROTOCOMMON_PB_ESOURCE
GETCOUNTITEMCMD_SOURCE_FIELD.type = 14
GETCOUNTITEMCMD_SOURCE_FIELD.cpp_type = 8
GETCOUNTITEMCMD.name = "GetCountItemCmd"
GETCOUNTITEMCMD.full_name = ".Cmd.GetCountItemCmd"
GETCOUNTITEMCMD.nested_types = {}
GETCOUNTITEMCMD.enum_types = {}
GETCOUNTITEMCMD.fields = {
  GETCOUNTITEMCMD_CMD_FIELD,
  GETCOUNTITEMCMD_PARAM_FIELD,
  GETCOUNTITEMCMD_ITEMID_FIELD,
  GETCOUNTITEMCMD_COUNT_FIELD,
  GETCOUNTITEMCMD_SOURCE_FIELD
}
GETCOUNTITEMCMD.is_extendable = false
GETCOUNTITEMCMD.extensions = {}
SAVELOVELETTERCMD_CMD_FIELD.name = "cmd"
SAVELOVELETTERCMD_CMD_FIELD.full_name = ".Cmd.SaveLoveLetterCmd.cmd"
SAVELOVELETTERCMD_CMD_FIELD.number = 1
SAVELOVELETTERCMD_CMD_FIELD.index = 0
SAVELOVELETTERCMD_CMD_FIELD.label = 1
SAVELOVELETTERCMD_CMD_FIELD.has_default_value = true
SAVELOVELETTERCMD_CMD_FIELD.default_value = 6
SAVELOVELETTERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SAVELOVELETTERCMD_CMD_FIELD.type = 14
SAVELOVELETTERCMD_CMD_FIELD.cpp_type = 8
SAVELOVELETTERCMD_PARAM_FIELD.name = "param"
SAVELOVELETTERCMD_PARAM_FIELD.full_name = ".Cmd.SaveLoveLetterCmd.param"
SAVELOVELETTERCMD_PARAM_FIELD.number = 2
SAVELOVELETTERCMD_PARAM_FIELD.index = 1
SAVELOVELETTERCMD_PARAM_FIELD.label = 1
SAVELOVELETTERCMD_PARAM_FIELD.has_default_value = true
SAVELOVELETTERCMD_PARAM_FIELD.default_value = 30
SAVELOVELETTERCMD_PARAM_FIELD.enum_type = ITEMPARAM
SAVELOVELETTERCMD_PARAM_FIELD.type = 14
SAVELOVELETTERCMD_PARAM_FIELD.cpp_type = 8
SAVELOVELETTERCMD_DWID_FIELD.name = "dwID"
SAVELOVELETTERCMD_DWID_FIELD.full_name = ".Cmd.SaveLoveLetterCmd.dwID"
SAVELOVELETTERCMD_DWID_FIELD.number = 3
SAVELOVELETTERCMD_DWID_FIELD.index = 2
SAVELOVELETTERCMD_DWID_FIELD.label = 1
SAVELOVELETTERCMD_DWID_FIELD.has_default_value = false
SAVELOVELETTERCMD_DWID_FIELD.default_value = 0
SAVELOVELETTERCMD_DWID_FIELD.type = 13
SAVELOVELETTERCMD_DWID_FIELD.cpp_type = 3
SAVELOVELETTERCMD.name = "SaveLoveLetterCmd"
SAVELOVELETTERCMD.full_name = ".Cmd.SaveLoveLetterCmd"
SAVELOVELETTERCMD.nested_types = {}
SAVELOVELETTERCMD.enum_types = {}
SAVELOVELETTERCMD.fields = {
  SAVELOVELETTERCMD_CMD_FIELD,
  SAVELOVELETTERCMD_PARAM_FIELD,
  SAVELOVELETTERCMD_DWID_FIELD
}
SAVELOVELETTERCMD.is_extendable = false
SAVELOVELETTERCMD.extensions = {}
ITEMDATASHOW_CMD_FIELD.name = "cmd"
ITEMDATASHOW_CMD_FIELD.full_name = ".Cmd.ItemDataShow.cmd"
ITEMDATASHOW_CMD_FIELD.number = 1
ITEMDATASHOW_CMD_FIELD.index = 0
ITEMDATASHOW_CMD_FIELD.label = 1
ITEMDATASHOW_CMD_FIELD.has_default_value = true
ITEMDATASHOW_CMD_FIELD.default_value = 6
ITEMDATASHOW_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ITEMDATASHOW_CMD_FIELD.type = 14
ITEMDATASHOW_CMD_FIELD.cpp_type = 8
ITEMDATASHOW_PARAM_FIELD.name = "param"
ITEMDATASHOW_PARAM_FIELD.full_name = ".Cmd.ItemDataShow.param"
ITEMDATASHOW_PARAM_FIELD.number = 2
ITEMDATASHOW_PARAM_FIELD.index = 1
ITEMDATASHOW_PARAM_FIELD.label = 1
ITEMDATASHOW_PARAM_FIELD.has_default_value = true
ITEMDATASHOW_PARAM_FIELD.default_value = 31
ITEMDATASHOW_PARAM_FIELD.enum_type = ITEMPARAM
ITEMDATASHOW_PARAM_FIELD.type = 14
ITEMDATASHOW_PARAM_FIELD.cpp_type = 8
ITEMDATASHOW_ITEMS_FIELD.name = "items"
ITEMDATASHOW_ITEMS_FIELD.full_name = ".Cmd.ItemDataShow.items"
ITEMDATASHOW_ITEMS_FIELD.number = 3
ITEMDATASHOW_ITEMS_FIELD.index = 2
ITEMDATASHOW_ITEMS_FIELD.label = 3
ITEMDATASHOW_ITEMS_FIELD.has_default_value = false
ITEMDATASHOW_ITEMS_FIELD.default_value = {}
ITEMDATASHOW_ITEMS_FIELD.message_type = ITEMDATA
ITEMDATASHOW_ITEMS_FIELD.type = 11
ITEMDATASHOW_ITEMS_FIELD.cpp_type = 10
ITEMDATASHOW.name = "ItemDataShow"
ITEMDATASHOW.full_name = ".Cmd.ItemDataShow"
ITEMDATASHOW.nested_types = {}
ITEMDATASHOW.enum_types = {}
ITEMDATASHOW.fields = {
  ITEMDATASHOW_CMD_FIELD,
  ITEMDATASHOW_PARAM_FIELD,
  ITEMDATASHOW_ITEMS_FIELD
}
ITEMDATASHOW.is_extendable = false
ITEMDATASHOW.extensions = {}
LOTTERYCMD_CMD_FIELD.name = "cmd"
LOTTERYCMD_CMD_FIELD.full_name = ".Cmd.LotteryCmd.cmd"
LOTTERYCMD_CMD_FIELD.number = 1
LOTTERYCMD_CMD_FIELD.index = 0
LOTTERYCMD_CMD_FIELD.label = 1
LOTTERYCMD_CMD_FIELD.has_default_value = true
LOTTERYCMD_CMD_FIELD.default_value = 6
LOTTERYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LOTTERYCMD_CMD_FIELD.type = 14
LOTTERYCMD_CMD_FIELD.cpp_type = 8
LOTTERYCMD_PARAM_FIELD.name = "param"
LOTTERYCMD_PARAM_FIELD.full_name = ".Cmd.LotteryCmd.param"
LOTTERYCMD_PARAM_FIELD.number = 2
LOTTERYCMD_PARAM_FIELD.index = 1
LOTTERYCMD_PARAM_FIELD.label = 1
LOTTERYCMD_PARAM_FIELD.has_default_value = true
LOTTERYCMD_PARAM_FIELD.default_value = 32
LOTTERYCMD_PARAM_FIELD.enum_type = ITEMPARAM
LOTTERYCMD_PARAM_FIELD.type = 14
LOTTERYCMD_PARAM_FIELD.cpp_type = 8
LOTTERYCMD_YEAR_FIELD.name = "year"
LOTTERYCMD_YEAR_FIELD.full_name = ".Cmd.LotteryCmd.year"
LOTTERYCMD_YEAR_FIELD.number = 3
LOTTERYCMD_YEAR_FIELD.index = 2
LOTTERYCMD_YEAR_FIELD.label = 1
LOTTERYCMD_YEAR_FIELD.has_default_value = false
LOTTERYCMD_YEAR_FIELD.default_value = 0
LOTTERYCMD_YEAR_FIELD.type = 13
LOTTERYCMD_YEAR_FIELD.cpp_type = 3
LOTTERYCMD_MONTH_FIELD.name = "month"
LOTTERYCMD_MONTH_FIELD.full_name = ".Cmd.LotteryCmd.month"
LOTTERYCMD_MONTH_FIELD.number = 4
LOTTERYCMD_MONTH_FIELD.index = 3
LOTTERYCMD_MONTH_FIELD.label = 1
LOTTERYCMD_MONTH_FIELD.has_default_value = false
LOTTERYCMD_MONTH_FIELD.default_value = 0
LOTTERYCMD_MONTH_FIELD.type = 13
LOTTERYCMD_MONTH_FIELD.cpp_type = 3
LOTTERYCMD_NPCID_FIELD.name = "npcid"
LOTTERYCMD_NPCID_FIELD.full_name = ".Cmd.LotteryCmd.npcid"
LOTTERYCMD_NPCID_FIELD.number = 5
LOTTERYCMD_NPCID_FIELD.index = 4
LOTTERYCMD_NPCID_FIELD.label = 1
LOTTERYCMD_NPCID_FIELD.has_default_value = false
LOTTERYCMD_NPCID_FIELD.default_value = 0
LOTTERYCMD_NPCID_FIELD.type = 4
LOTTERYCMD_NPCID_FIELD.cpp_type = 4
LOTTERYCMD_SKIP_ANIM_FIELD.name = "skip_anim"
LOTTERYCMD_SKIP_ANIM_FIELD.full_name = ".Cmd.LotteryCmd.skip_anim"
LOTTERYCMD_SKIP_ANIM_FIELD.number = 6
LOTTERYCMD_SKIP_ANIM_FIELD.index = 5
LOTTERYCMD_SKIP_ANIM_FIELD.label = 1
LOTTERYCMD_SKIP_ANIM_FIELD.has_default_value = true
LOTTERYCMD_SKIP_ANIM_FIELD.default_value = false
LOTTERYCMD_SKIP_ANIM_FIELD.type = 8
LOTTERYCMD_SKIP_ANIM_FIELD.cpp_type = 7
LOTTERYCMD_PRICE_FIELD.name = "price"
LOTTERYCMD_PRICE_FIELD.full_name = ".Cmd.LotteryCmd.price"
LOTTERYCMD_PRICE_FIELD.number = 7
LOTTERYCMD_PRICE_FIELD.index = 6
LOTTERYCMD_PRICE_FIELD.label = 1
LOTTERYCMD_PRICE_FIELD.has_default_value = false
LOTTERYCMD_PRICE_FIELD.default_value = 0
LOTTERYCMD_PRICE_FIELD.type = 13
LOTTERYCMD_PRICE_FIELD.cpp_type = 3
LOTTERYCMD_TICKET_FIELD.name = "ticket"
LOTTERYCMD_TICKET_FIELD.full_name = ".Cmd.LotteryCmd.ticket"
LOTTERYCMD_TICKET_FIELD.number = 8
LOTTERYCMD_TICKET_FIELD.index = 7
LOTTERYCMD_TICKET_FIELD.label = 1
LOTTERYCMD_TICKET_FIELD.has_default_value = false
LOTTERYCMD_TICKET_FIELD.default_value = 0
LOTTERYCMD_TICKET_FIELD.type = 13
LOTTERYCMD_TICKET_FIELD.cpp_type = 3
LOTTERYCMD_TYPE_FIELD.name = "type"
LOTTERYCMD_TYPE_FIELD.full_name = ".Cmd.LotteryCmd.type"
LOTTERYCMD_TYPE_FIELD.number = 9
LOTTERYCMD_TYPE_FIELD.index = 8
LOTTERYCMD_TYPE_FIELD.label = 1
LOTTERYCMD_TYPE_FIELD.has_default_value = false
LOTTERYCMD_TYPE_FIELD.default_value = nil
LOTTERYCMD_TYPE_FIELD.enum_type = ELOTTERYTYPE
LOTTERYCMD_TYPE_FIELD.type = 14
LOTTERYCMD_TYPE_FIELD.cpp_type = 8
LOTTERYCMD_COUNT_FIELD.name = "count"
LOTTERYCMD_COUNT_FIELD.full_name = ".Cmd.LotteryCmd.count"
LOTTERYCMD_COUNT_FIELD.number = 10
LOTTERYCMD_COUNT_FIELD.index = 9
LOTTERYCMD_COUNT_FIELD.label = 1
LOTTERYCMD_COUNT_FIELD.has_default_value = false
LOTTERYCMD_COUNT_FIELD.default_value = 0
LOTTERYCMD_COUNT_FIELD.type = 13
LOTTERYCMD_COUNT_FIELD.cpp_type = 3
LOTTERYCMD_ITEMS_FIELD.name = "items"
LOTTERYCMD_ITEMS_FIELD.full_name = ".Cmd.LotteryCmd.items"
LOTTERYCMD_ITEMS_FIELD.number = 11
LOTTERYCMD_ITEMS_FIELD.index = 10
LOTTERYCMD_ITEMS_FIELD.label = 3
LOTTERYCMD_ITEMS_FIELD.has_default_value = false
LOTTERYCMD_ITEMS_FIELD.default_value = {}
LOTTERYCMD_ITEMS_FIELD.message_type = ITEMINFO
LOTTERYCMD_ITEMS_FIELD.type = 11
LOTTERYCMD_ITEMS_FIELD.cpp_type = 10
LOTTERYCMD_CHARID_FIELD.name = "charid"
LOTTERYCMD_CHARID_FIELD.full_name = ".Cmd.LotteryCmd.charid"
LOTTERYCMD_CHARID_FIELD.number = 12
LOTTERYCMD_CHARID_FIELD.index = 11
LOTTERYCMD_CHARID_FIELD.label = 1
LOTTERYCMD_CHARID_FIELD.has_default_value = false
LOTTERYCMD_CHARID_FIELD.default_value = 0
LOTTERYCMD_CHARID_FIELD.type = 4
LOTTERYCMD_CHARID_FIELD.cpp_type = 4
LOTTERYCMD_GUID_FIELD.name = "guid"
LOTTERYCMD_GUID_FIELD.full_name = ".Cmd.LotteryCmd.guid"
LOTTERYCMD_GUID_FIELD.number = 13
LOTTERYCMD_GUID_FIELD.index = 12
LOTTERYCMD_GUID_FIELD.label = 1
LOTTERYCMD_GUID_FIELD.has_default_value = false
LOTTERYCMD_GUID_FIELD.default_value = ""
LOTTERYCMD_GUID_FIELD.type = 9
LOTTERYCMD_GUID_FIELD.cpp_type = 9
LOTTERYCMD_TODAY_CNT_FIELD.name = "today_cnt"
LOTTERYCMD_TODAY_CNT_FIELD.full_name = ".Cmd.LotteryCmd.today_cnt"
LOTTERYCMD_TODAY_CNT_FIELD.number = 14
LOTTERYCMD_TODAY_CNT_FIELD.index = 13
LOTTERYCMD_TODAY_CNT_FIELD.label = 1
LOTTERYCMD_TODAY_CNT_FIELD.has_default_value = false
LOTTERYCMD_TODAY_CNT_FIELD.default_value = 0
LOTTERYCMD_TODAY_CNT_FIELD.type = 13
LOTTERYCMD_TODAY_CNT_FIELD.cpp_type = 3
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.name = "today_extra_cnt"
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.full_name = ".Cmd.LotteryCmd.today_extra_cnt"
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.number = 15
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.index = 14
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.label = 1
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.has_default_value = false
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.default_value = 0
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.type = 13
LOTTERYCMD_TODAY_EXTRA_CNT_FIELD.cpp_type = 3
LOTTERYCMD.name = "LotteryCmd"
LOTTERYCMD.full_name = ".Cmd.LotteryCmd"
LOTTERYCMD.nested_types = {}
LOTTERYCMD.enum_types = {}
LOTTERYCMD.fields = {
  LOTTERYCMD_CMD_FIELD,
  LOTTERYCMD_PARAM_FIELD,
  LOTTERYCMD_YEAR_FIELD,
  LOTTERYCMD_MONTH_FIELD,
  LOTTERYCMD_NPCID_FIELD,
  LOTTERYCMD_SKIP_ANIM_FIELD,
  LOTTERYCMD_PRICE_FIELD,
  LOTTERYCMD_TICKET_FIELD,
  LOTTERYCMD_TYPE_FIELD,
  LOTTERYCMD_COUNT_FIELD,
  LOTTERYCMD_ITEMS_FIELD,
  LOTTERYCMD_CHARID_FIELD,
  LOTTERYCMD_GUID_FIELD,
  LOTTERYCMD_TODAY_CNT_FIELD,
  LOTTERYCMD_TODAY_EXTRA_CNT_FIELD
}
LOTTERYCMD.is_extendable = false
LOTTERYCMD.extensions = {}
LOTTERYRECOVERYCMD_CMD_FIELD.name = "cmd"
LOTTERYRECOVERYCMD_CMD_FIELD.full_name = ".Cmd.LotteryRecoveryCmd.cmd"
LOTTERYRECOVERYCMD_CMD_FIELD.number = 1
LOTTERYRECOVERYCMD_CMD_FIELD.index = 0
LOTTERYRECOVERYCMD_CMD_FIELD.label = 1
LOTTERYRECOVERYCMD_CMD_FIELD.has_default_value = true
LOTTERYRECOVERYCMD_CMD_FIELD.default_value = 6
LOTTERYRECOVERYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LOTTERYRECOVERYCMD_CMD_FIELD.type = 14
LOTTERYRECOVERYCMD_CMD_FIELD.cpp_type = 8
LOTTERYRECOVERYCMD_PARAM_FIELD.name = "param"
LOTTERYRECOVERYCMD_PARAM_FIELD.full_name = ".Cmd.LotteryRecoveryCmd.param"
LOTTERYRECOVERYCMD_PARAM_FIELD.number = 2
LOTTERYRECOVERYCMD_PARAM_FIELD.index = 1
LOTTERYRECOVERYCMD_PARAM_FIELD.label = 1
LOTTERYRECOVERYCMD_PARAM_FIELD.has_default_value = true
LOTTERYRECOVERYCMD_PARAM_FIELD.default_value = 33
LOTTERYRECOVERYCMD_PARAM_FIELD.enum_type = ITEMPARAM
LOTTERYRECOVERYCMD_PARAM_FIELD.type = 14
LOTTERYRECOVERYCMD_PARAM_FIELD.cpp_type = 8
LOTTERYRECOVERYCMD_GUIDS_FIELD.name = "guids"
LOTTERYRECOVERYCMD_GUIDS_FIELD.full_name = ".Cmd.LotteryRecoveryCmd.guids"
LOTTERYRECOVERYCMD_GUIDS_FIELD.number = 3
LOTTERYRECOVERYCMD_GUIDS_FIELD.index = 2
LOTTERYRECOVERYCMD_GUIDS_FIELD.label = 3
LOTTERYRECOVERYCMD_GUIDS_FIELD.has_default_value = false
LOTTERYRECOVERYCMD_GUIDS_FIELD.default_value = {}
LOTTERYRECOVERYCMD_GUIDS_FIELD.type = 9
LOTTERYRECOVERYCMD_GUIDS_FIELD.cpp_type = 9
LOTTERYRECOVERYCMD_NPCID_FIELD.name = "npcid"
LOTTERYRECOVERYCMD_NPCID_FIELD.full_name = ".Cmd.LotteryRecoveryCmd.npcid"
LOTTERYRECOVERYCMD_NPCID_FIELD.number = 4
LOTTERYRECOVERYCMD_NPCID_FIELD.index = 3
LOTTERYRECOVERYCMD_NPCID_FIELD.label = 1
LOTTERYRECOVERYCMD_NPCID_FIELD.has_default_value = false
LOTTERYRECOVERYCMD_NPCID_FIELD.default_value = 0
LOTTERYRECOVERYCMD_NPCID_FIELD.type = 4
LOTTERYRECOVERYCMD_NPCID_FIELD.cpp_type = 4
LOTTERYRECOVERYCMD_TYPE_FIELD.name = "type"
LOTTERYRECOVERYCMD_TYPE_FIELD.full_name = ".Cmd.LotteryRecoveryCmd.type"
LOTTERYRECOVERYCMD_TYPE_FIELD.number = 5
LOTTERYRECOVERYCMD_TYPE_FIELD.index = 4
LOTTERYRECOVERYCMD_TYPE_FIELD.label = 1
LOTTERYRECOVERYCMD_TYPE_FIELD.has_default_value = false
LOTTERYRECOVERYCMD_TYPE_FIELD.default_value = nil
LOTTERYRECOVERYCMD_TYPE_FIELD.enum_type = ELOTTERYTYPE
LOTTERYRECOVERYCMD_TYPE_FIELD.type = 14
LOTTERYRECOVERYCMD_TYPE_FIELD.cpp_type = 8
LOTTERYRECOVERYCMD.name = "LotteryRecoveryCmd"
LOTTERYRECOVERYCMD.full_name = ".Cmd.LotteryRecoveryCmd"
LOTTERYRECOVERYCMD.nested_types = {}
LOTTERYRECOVERYCMD.enum_types = {}
LOTTERYRECOVERYCMD.fields = {
  LOTTERYRECOVERYCMD_CMD_FIELD,
  LOTTERYRECOVERYCMD_PARAM_FIELD,
  LOTTERYRECOVERYCMD_GUIDS_FIELD,
  LOTTERYRECOVERYCMD_NPCID_FIELD,
  LOTTERYRECOVERYCMD_TYPE_FIELD
}
LOTTERYRECOVERYCMD.is_extendable = false
LOTTERYRECOVERYCMD.extensions = {}
LOTTERYSUBINFO_ITEMID_FIELD.name = "itemid"
LOTTERYSUBINFO_ITEMID_FIELD.full_name = ".Cmd.LotterySubInfo.itemid"
LOTTERYSUBINFO_ITEMID_FIELD.number = 1
LOTTERYSUBINFO_ITEMID_FIELD.index = 0
LOTTERYSUBINFO_ITEMID_FIELD.label = 1
LOTTERYSUBINFO_ITEMID_FIELD.has_default_value = false
LOTTERYSUBINFO_ITEMID_FIELD.default_value = 0
LOTTERYSUBINFO_ITEMID_FIELD.type = 13
LOTTERYSUBINFO_ITEMID_FIELD.cpp_type = 3
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.name = "recover_price"
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.full_name = ".Cmd.LotterySubInfo.recover_price"
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.number = 2
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.index = 1
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.label = 1
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.has_default_value = false
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.default_value = 0
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.type = 13
LOTTERYSUBINFO_RECOVER_PRICE_FIELD.cpp_type = 3
LOTTERYSUBINFO_RATE_FIELD.name = "rate"
LOTTERYSUBINFO_RATE_FIELD.full_name = ".Cmd.LotterySubInfo.rate"
LOTTERYSUBINFO_RATE_FIELD.number = 3
LOTTERYSUBINFO_RATE_FIELD.index = 2
LOTTERYSUBINFO_RATE_FIELD.label = 1
LOTTERYSUBINFO_RATE_FIELD.has_default_value = false
LOTTERYSUBINFO_RATE_FIELD.default_value = 0
LOTTERYSUBINFO_RATE_FIELD.type = 13
LOTTERYSUBINFO_RATE_FIELD.cpp_type = 3
LOTTERYSUBINFO_RARITY_FIELD.name = "rarity"
LOTTERYSUBINFO_RARITY_FIELD.full_name = ".Cmd.LotterySubInfo.rarity"
LOTTERYSUBINFO_RARITY_FIELD.number = 4
LOTTERYSUBINFO_RARITY_FIELD.index = 3
LOTTERYSUBINFO_RARITY_FIELD.label = 1
LOTTERYSUBINFO_RARITY_FIELD.has_default_value = false
LOTTERYSUBINFO_RARITY_FIELD.default_value = ""
LOTTERYSUBINFO_RARITY_FIELD.type = 9
LOTTERYSUBINFO_RARITY_FIELD.cpp_type = 9
LOTTERYSUBINFO_CUR_BATCH_FIELD.name = "cur_batch"
LOTTERYSUBINFO_CUR_BATCH_FIELD.full_name = ".Cmd.LotterySubInfo.cur_batch"
LOTTERYSUBINFO_CUR_BATCH_FIELD.number = 5
LOTTERYSUBINFO_CUR_BATCH_FIELD.index = 4
LOTTERYSUBINFO_CUR_BATCH_FIELD.label = 1
LOTTERYSUBINFO_CUR_BATCH_FIELD.has_default_value = false
LOTTERYSUBINFO_CUR_BATCH_FIELD.default_value = false
LOTTERYSUBINFO_CUR_BATCH_FIELD.type = 8
LOTTERYSUBINFO_CUR_BATCH_FIELD.cpp_type = 7
LOTTERYSUBINFO_ID_FIELD.name = "id"
LOTTERYSUBINFO_ID_FIELD.full_name = ".Cmd.LotterySubInfo.id"
LOTTERYSUBINFO_ID_FIELD.number = 6
LOTTERYSUBINFO_ID_FIELD.index = 5
LOTTERYSUBINFO_ID_FIELD.label = 1
LOTTERYSUBINFO_ID_FIELD.has_default_value = false
LOTTERYSUBINFO_ID_FIELD.default_value = 0
LOTTERYSUBINFO_ID_FIELD.type = 13
LOTTERYSUBINFO_ID_FIELD.cpp_type = 3
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.name = "recover_itemid"
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.full_name = ".Cmd.LotterySubInfo.recover_itemid"
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.number = 7
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.index = 6
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.label = 1
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.has_default_value = false
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.default_value = 0
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.type = 13
LOTTERYSUBINFO_RECOVER_ITEMID_FIELD.cpp_type = 3
LOTTERYSUBINFO_COUNT_FIELD.name = "count"
LOTTERYSUBINFO_COUNT_FIELD.full_name = ".Cmd.LotterySubInfo.count"
LOTTERYSUBINFO_COUNT_FIELD.number = 8
LOTTERYSUBINFO_COUNT_FIELD.index = 7
LOTTERYSUBINFO_COUNT_FIELD.label = 1
LOTTERYSUBINFO_COUNT_FIELD.has_default_value = false
LOTTERYSUBINFO_COUNT_FIELD.default_value = 0
LOTTERYSUBINFO_COUNT_FIELD.type = 13
LOTTERYSUBINFO_COUNT_FIELD.cpp_type = 3
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.name = "female_itemid"
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.full_name = ".Cmd.LotterySubInfo.female_itemid"
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.number = 9
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.index = 8
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.label = 1
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.has_default_value = false
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.default_value = 0
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.type = 13
LOTTERYSUBINFO_FEMALE_ITEMID_FIELD.cpp_type = 3
LOTTERYSUBINFO.name = "LotterySubInfo"
LOTTERYSUBINFO.full_name = ".Cmd.LotterySubInfo"
LOTTERYSUBINFO.nested_types = {}
LOTTERYSUBINFO.enum_types = {}
LOTTERYSUBINFO.fields = {
  LOTTERYSUBINFO_ITEMID_FIELD,
  LOTTERYSUBINFO_RECOVER_PRICE_FIELD,
  LOTTERYSUBINFO_RATE_FIELD,
  LOTTERYSUBINFO_RARITY_FIELD,
  LOTTERYSUBINFO_CUR_BATCH_FIELD,
  LOTTERYSUBINFO_ID_FIELD,
  LOTTERYSUBINFO_RECOVER_ITEMID_FIELD,
  LOTTERYSUBINFO_COUNT_FIELD,
  LOTTERYSUBINFO_FEMALE_ITEMID_FIELD
}
LOTTERYSUBINFO.is_extendable = false
LOTTERYSUBINFO.extensions = {}
LOTTERYINFO_YEAR_FIELD.name = "year"
LOTTERYINFO_YEAR_FIELD.full_name = ".Cmd.LotteryInfo.year"
LOTTERYINFO_YEAR_FIELD.number = 1
LOTTERYINFO_YEAR_FIELD.index = 0
LOTTERYINFO_YEAR_FIELD.label = 1
LOTTERYINFO_YEAR_FIELD.has_default_value = false
LOTTERYINFO_YEAR_FIELD.default_value = 0
LOTTERYINFO_YEAR_FIELD.type = 13
LOTTERYINFO_YEAR_FIELD.cpp_type = 3
LOTTERYINFO_MONTH_FIELD.name = "month"
LOTTERYINFO_MONTH_FIELD.full_name = ".Cmd.LotteryInfo.month"
LOTTERYINFO_MONTH_FIELD.number = 2
LOTTERYINFO_MONTH_FIELD.index = 1
LOTTERYINFO_MONTH_FIELD.label = 1
LOTTERYINFO_MONTH_FIELD.has_default_value = false
LOTTERYINFO_MONTH_FIELD.default_value = 0
LOTTERYINFO_MONTH_FIELD.type = 13
LOTTERYINFO_MONTH_FIELD.cpp_type = 3
LOTTERYINFO_PRICE_FIELD.name = "price"
LOTTERYINFO_PRICE_FIELD.full_name = ".Cmd.LotteryInfo.price"
LOTTERYINFO_PRICE_FIELD.number = 3
LOTTERYINFO_PRICE_FIELD.index = 2
LOTTERYINFO_PRICE_FIELD.label = 1
LOTTERYINFO_PRICE_FIELD.has_default_value = false
LOTTERYINFO_PRICE_FIELD.default_value = 0
LOTTERYINFO_PRICE_FIELD.type = 13
LOTTERYINFO_PRICE_FIELD.cpp_type = 3
LOTTERYINFO_DISCOUNT_FIELD.name = "discount"
LOTTERYINFO_DISCOUNT_FIELD.full_name = ".Cmd.LotteryInfo.discount"
LOTTERYINFO_DISCOUNT_FIELD.number = 4
LOTTERYINFO_DISCOUNT_FIELD.index = 3
LOTTERYINFO_DISCOUNT_FIELD.label = 1
LOTTERYINFO_DISCOUNT_FIELD.has_default_value = false
LOTTERYINFO_DISCOUNT_FIELD.default_value = 0
LOTTERYINFO_DISCOUNT_FIELD.type = 13
LOTTERYINFO_DISCOUNT_FIELD.cpp_type = 3
LOTTERYINFO_SUBINFO_FIELD.name = "subInfo"
LOTTERYINFO_SUBINFO_FIELD.full_name = ".Cmd.LotteryInfo.subInfo"
LOTTERYINFO_SUBINFO_FIELD.number = 5
LOTTERYINFO_SUBINFO_FIELD.index = 4
LOTTERYINFO_SUBINFO_FIELD.label = 3
LOTTERYINFO_SUBINFO_FIELD.has_default_value = false
LOTTERYINFO_SUBINFO_FIELD.default_value = {}
LOTTERYINFO_SUBINFO_FIELD.message_type = LOTTERYSUBINFO
LOTTERYINFO_SUBINFO_FIELD.type = 11
LOTTERYINFO_SUBINFO_FIELD.cpp_type = 10
LOTTERYINFO_LOTTERYBOX_FIELD.name = "lotterybox"
LOTTERYINFO_LOTTERYBOX_FIELD.full_name = ".Cmd.LotteryInfo.lotterybox"
LOTTERYINFO_LOTTERYBOX_FIELD.number = 6
LOTTERYINFO_LOTTERYBOX_FIELD.index = 5
LOTTERYINFO_LOTTERYBOX_FIELD.label = 1
LOTTERYINFO_LOTTERYBOX_FIELD.has_default_value = false
LOTTERYINFO_LOTTERYBOX_FIELD.default_value = 0
LOTTERYINFO_LOTTERYBOX_FIELD.type = 13
LOTTERYINFO_LOTTERYBOX_FIELD.cpp_type = 3
LOTTERYINFO.name = "LotteryInfo"
LOTTERYINFO.full_name = ".Cmd.LotteryInfo"
LOTTERYINFO.nested_types = {}
LOTTERYINFO.enum_types = {}
LOTTERYINFO.fields = {
  LOTTERYINFO_YEAR_FIELD,
  LOTTERYINFO_MONTH_FIELD,
  LOTTERYINFO_PRICE_FIELD,
  LOTTERYINFO_DISCOUNT_FIELD,
  LOTTERYINFO_SUBINFO_FIELD,
  LOTTERYINFO_LOTTERYBOX_FIELD
}
LOTTERYINFO.is_extendable = false
LOTTERYINFO.extensions = {}
QUERYLOTTERYINFO_CMD_FIELD.name = "cmd"
QUERYLOTTERYINFO_CMD_FIELD.full_name = ".Cmd.QueryLotteryInfo.cmd"
QUERYLOTTERYINFO_CMD_FIELD.number = 1
QUERYLOTTERYINFO_CMD_FIELD.index = 0
QUERYLOTTERYINFO_CMD_FIELD.label = 1
QUERYLOTTERYINFO_CMD_FIELD.has_default_value = true
QUERYLOTTERYINFO_CMD_FIELD.default_value = 6
QUERYLOTTERYINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYLOTTERYINFO_CMD_FIELD.type = 14
QUERYLOTTERYINFO_CMD_FIELD.cpp_type = 8
QUERYLOTTERYINFO_PARAM_FIELD.name = "param"
QUERYLOTTERYINFO_PARAM_FIELD.full_name = ".Cmd.QueryLotteryInfo.param"
QUERYLOTTERYINFO_PARAM_FIELD.number = 2
QUERYLOTTERYINFO_PARAM_FIELD.index = 1
QUERYLOTTERYINFO_PARAM_FIELD.label = 1
QUERYLOTTERYINFO_PARAM_FIELD.has_default_value = true
QUERYLOTTERYINFO_PARAM_FIELD.default_value = 34
QUERYLOTTERYINFO_PARAM_FIELD.enum_type = ITEMPARAM
QUERYLOTTERYINFO_PARAM_FIELD.type = 14
QUERYLOTTERYINFO_PARAM_FIELD.cpp_type = 8
QUERYLOTTERYINFO_INFOS_FIELD.name = "infos"
QUERYLOTTERYINFO_INFOS_FIELD.full_name = ".Cmd.QueryLotteryInfo.infos"
QUERYLOTTERYINFO_INFOS_FIELD.number = 3
QUERYLOTTERYINFO_INFOS_FIELD.index = 2
QUERYLOTTERYINFO_INFOS_FIELD.label = 3
QUERYLOTTERYINFO_INFOS_FIELD.has_default_value = false
QUERYLOTTERYINFO_INFOS_FIELD.default_value = {}
QUERYLOTTERYINFO_INFOS_FIELD.message_type = LOTTERYINFO
QUERYLOTTERYINFO_INFOS_FIELD.type = 11
QUERYLOTTERYINFO_INFOS_FIELD.cpp_type = 10
QUERYLOTTERYINFO_TYPE_FIELD.name = "type"
QUERYLOTTERYINFO_TYPE_FIELD.full_name = ".Cmd.QueryLotteryInfo.type"
QUERYLOTTERYINFO_TYPE_FIELD.number = 4
QUERYLOTTERYINFO_TYPE_FIELD.index = 3
QUERYLOTTERYINFO_TYPE_FIELD.label = 1
QUERYLOTTERYINFO_TYPE_FIELD.has_default_value = false
QUERYLOTTERYINFO_TYPE_FIELD.default_value = nil
QUERYLOTTERYINFO_TYPE_FIELD.enum_type = ELOTTERYTYPE
QUERYLOTTERYINFO_TYPE_FIELD.type = 14
QUERYLOTTERYINFO_TYPE_FIELD.cpp_type = 8
QUERYLOTTERYINFO_TODAY_CNT_FIELD.name = "today_cnt"
QUERYLOTTERYINFO_TODAY_CNT_FIELD.full_name = ".Cmd.QueryLotteryInfo.today_cnt"
QUERYLOTTERYINFO_TODAY_CNT_FIELD.number = 5
QUERYLOTTERYINFO_TODAY_CNT_FIELD.index = 4
QUERYLOTTERYINFO_TODAY_CNT_FIELD.label = 1
QUERYLOTTERYINFO_TODAY_CNT_FIELD.has_default_value = false
QUERYLOTTERYINFO_TODAY_CNT_FIELD.default_value = 0
QUERYLOTTERYINFO_TODAY_CNT_FIELD.type = 13
QUERYLOTTERYINFO_TODAY_CNT_FIELD.cpp_type = 3
QUERYLOTTERYINFO_MAX_CNT_FIELD.name = "max_cnt"
QUERYLOTTERYINFO_MAX_CNT_FIELD.full_name = ".Cmd.QueryLotteryInfo.max_cnt"
QUERYLOTTERYINFO_MAX_CNT_FIELD.number = 6
QUERYLOTTERYINFO_MAX_CNT_FIELD.index = 5
QUERYLOTTERYINFO_MAX_CNT_FIELD.label = 1
QUERYLOTTERYINFO_MAX_CNT_FIELD.has_default_value = false
QUERYLOTTERYINFO_MAX_CNT_FIELD.default_value = 0
QUERYLOTTERYINFO_MAX_CNT_FIELD.type = 13
QUERYLOTTERYINFO_MAX_CNT_FIELD.cpp_type = 3
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.name = "today_extra_cnt"
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.full_name = ".Cmd.QueryLotteryInfo.today_extra_cnt"
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.number = 7
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.index = 6
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.label = 1
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.has_default_value = false
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.default_value = 0
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.type = 13
QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD.cpp_type = 3
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.name = "max_extra_cnt"
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.full_name = ".Cmd.QueryLotteryInfo.max_extra_cnt"
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.number = 8
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.index = 7
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.label = 1
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.has_default_value = false
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.default_value = 0
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.type = 13
QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD.cpp_type = 3
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.name = "once_max_cnt"
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.full_name = ".Cmd.QueryLotteryInfo.once_max_cnt"
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.number = 9
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.index = 8
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.label = 1
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.has_default_value = true
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.default_value = 1
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.type = 13
QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD.cpp_type = 3
QUERYLOTTERYINFO.name = "QueryLotteryInfo"
QUERYLOTTERYINFO.full_name = ".Cmd.QueryLotteryInfo"
QUERYLOTTERYINFO.nested_types = {}
QUERYLOTTERYINFO.enum_types = {}
QUERYLOTTERYINFO.fields = {
  QUERYLOTTERYINFO_CMD_FIELD,
  QUERYLOTTERYINFO_PARAM_FIELD,
  QUERYLOTTERYINFO_INFOS_FIELD,
  QUERYLOTTERYINFO_TYPE_FIELD,
  QUERYLOTTERYINFO_TODAY_CNT_FIELD,
  QUERYLOTTERYINFO_MAX_CNT_FIELD,
  QUERYLOTTERYINFO_TODAY_EXTRA_CNT_FIELD,
  QUERYLOTTERYINFO_MAX_EXTRA_CNT_FIELD,
  QUERYLOTTERYINFO_ONCE_MAX_CNT_FIELD
}
QUERYLOTTERYINFO.is_extendable = false
QUERYLOTTERYINFO.extensions = {}
QUOTALOG_VALUE_FIELD.name = "value"
QUOTALOG_VALUE_FIELD.full_name = ".Cmd.QuotaLog.value"
QUOTALOG_VALUE_FIELD.number = 1
QUOTALOG_VALUE_FIELD.index = 0
QUOTALOG_VALUE_FIELD.label = 1
QUOTALOG_VALUE_FIELD.has_default_value = false
QUOTALOG_VALUE_FIELD.default_value = 0
QUOTALOG_VALUE_FIELD.type = 4
QUOTALOG_VALUE_FIELD.cpp_type = 4
QUOTALOG_TYPE_FIELD.name = "type"
QUOTALOG_TYPE_FIELD.full_name = ".Cmd.QuotaLog.type"
QUOTALOG_TYPE_FIELD.number = 2
QUOTALOG_TYPE_FIELD.index = 1
QUOTALOG_TYPE_FIELD.label = 1
QUOTALOG_TYPE_FIELD.has_default_value = false
QUOTALOG_TYPE_FIELD.default_value = nil
QUOTALOG_TYPE_FIELD.enum_type = EQUOTATYPE
QUOTALOG_TYPE_FIELD.type = 14
QUOTALOG_TYPE_FIELD.cpp_type = 8
QUOTALOG_TIME_FIELD.name = "time"
QUOTALOG_TIME_FIELD.full_name = ".Cmd.QuotaLog.time"
QUOTALOG_TIME_FIELD.number = 3
QUOTALOG_TIME_FIELD.index = 2
QUOTALOG_TIME_FIELD.label = 1
QUOTALOG_TIME_FIELD.has_default_value = false
QUOTALOG_TIME_FIELD.default_value = 0
QUOTALOG_TIME_FIELD.type = 13
QUOTALOG_TIME_FIELD.cpp_type = 3
QUOTALOG.name = "QuotaLog"
QUOTALOG.full_name = ".Cmd.QuotaLog"
QUOTALOG.nested_types = {}
QUOTALOG.enum_types = {}
QUOTALOG.fields = {
  QUOTALOG_VALUE_FIELD,
  QUOTALOG_TYPE_FIELD,
  QUOTALOG_TIME_FIELD
}
QUOTALOG.is_extendable = false
QUOTALOG.extensions = {}
QUOTADETAIL_VALUE_FIELD.name = "value"
QUOTADETAIL_VALUE_FIELD.full_name = ".Cmd.QuotaDetail.value"
QUOTADETAIL_VALUE_FIELD.number = 1
QUOTADETAIL_VALUE_FIELD.index = 0
QUOTADETAIL_VALUE_FIELD.label = 1
QUOTADETAIL_VALUE_FIELD.has_default_value = false
QUOTADETAIL_VALUE_FIELD.default_value = 0
QUOTADETAIL_VALUE_FIELD.type = 4
QUOTADETAIL_VALUE_FIELD.cpp_type = 4
QUOTADETAIL_LEFT_FIELD.name = "left"
QUOTADETAIL_LEFT_FIELD.full_name = ".Cmd.QuotaDetail.left"
QUOTADETAIL_LEFT_FIELD.number = 2
QUOTADETAIL_LEFT_FIELD.index = 1
QUOTADETAIL_LEFT_FIELD.label = 1
QUOTADETAIL_LEFT_FIELD.has_default_value = false
QUOTADETAIL_LEFT_FIELD.default_value = 0
QUOTADETAIL_LEFT_FIELD.type = 4
QUOTADETAIL_LEFT_FIELD.cpp_type = 4
QUOTADETAIL_EXPIRE_TIME_FIELD.name = "expire_time"
QUOTADETAIL_EXPIRE_TIME_FIELD.full_name = ".Cmd.QuotaDetail.expire_time"
QUOTADETAIL_EXPIRE_TIME_FIELD.number = 3
QUOTADETAIL_EXPIRE_TIME_FIELD.index = 2
QUOTADETAIL_EXPIRE_TIME_FIELD.label = 1
QUOTADETAIL_EXPIRE_TIME_FIELD.has_default_value = false
QUOTADETAIL_EXPIRE_TIME_FIELD.default_value = 0
QUOTADETAIL_EXPIRE_TIME_FIELD.type = 13
QUOTADETAIL_EXPIRE_TIME_FIELD.cpp_type = 3
QUOTADETAIL_TIME_FIELD.name = "time"
QUOTADETAIL_TIME_FIELD.full_name = ".Cmd.QuotaDetail.time"
QUOTADETAIL_TIME_FIELD.number = 4
QUOTADETAIL_TIME_FIELD.index = 3
QUOTADETAIL_TIME_FIELD.label = 1
QUOTADETAIL_TIME_FIELD.has_default_value = false
QUOTADETAIL_TIME_FIELD.default_value = 0
QUOTADETAIL_TIME_FIELD.type = 13
QUOTADETAIL_TIME_FIELD.cpp_type = 3
QUOTADETAIL.name = "QuotaDetail"
QUOTADETAIL.full_name = ".Cmd.QuotaDetail"
QUOTADETAIL.nested_types = {}
QUOTADETAIL.enum_types = {}
QUOTADETAIL.fields = {
  QUOTADETAIL_VALUE_FIELD,
  QUOTADETAIL_LEFT_FIELD,
  QUOTADETAIL_EXPIRE_TIME_FIELD,
  QUOTADETAIL_TIME_FIELD
}
QUOTADETAIL.is_extendable = false
QUOTADETAIL.extensions = {}
REQQUOTALOGCMD_CMD_FIELD.name = "cmd"
REQQUOTALOGCMD_CMD_FIELD.full_name = ".Cmd.ReqQuotaLogCmd.cmd"
REQQUOTALOGCMD_CMD_FIELD.number = 1
REQQUOTALOGCMD_CMD_FIELD.index = 0
REQQUOTALOGCMD_CMD_FIELD.label = 1
REQQUOTALOGCMD_CMD_FIELD.has_default_value = true
REQQUOTALOGCMD_CMD_FIELD.default_value = 6
REQQUOTALOGCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REQQUOTALOGCMD_CMD_FIELD.type = 14
REQQUOTALOGCMD_CMD_FIELD.cpp_type = 8
REQQUOTALOGCMD_PARAM_FIELD.name = "param"
REQQUOTALOGCMD_PARAM_FIELD.full_name = ".Cmd.ReqQuotaLogCmd.param"
REQQUOTALOGCMD_PARAM_FIELD.number = 2
REQQUOTALOGCMD_PARAM_FIELD.index = 1
REQQUOTALOGCMD_PARAM_FIELD.label = 1
REQQUOTALOGCMD_PARAM_FIELD.has_default_value = true
REQQUOTALOGCMD_PARAM_FIELD.default_value = 40
REQQUOTALOGCMD_PARAM_FIELD.enum_type = ITEMPARAM
REQQUOTALOGCMD_PARAM_FIELD.type = 14
REQQUOTALOGCMD_PARAM_FIELD.cpp_type = 8
REQQUOTALOGCMD_PAGE_INDEX_FIELD.name = "page_index"
REQQUOTALOGCMD_PAGE_INDEX_FIELD.full_name = ".Cmd.ReqQuotaLogCmd.page_index"
REQQUOTALOGCMD_PAGE_INDEX_FIELD.number = 3
REQQUOTALOGCMD_PAGE_INDEX_FIELD.index = 2
REQQUOTALOGCMD_PAGE_INDEX_FIELD.label = 1
REQQUOTALOGCMD_PAGE_INDEX_FIELD.has_default_value = false
REQQUOTALOGCMD_PAGE_INDEX_FIELD.default_value = 0
REQQUOTALOGCMD_PAGE_INDEX_FIELD.type = 13
REQQUOTALOGCMD_PAGE_INDEX_FIELD.cpp_type = 3
REQQUOTALOGCMD_LOG_FIELD.name = "log"
REQQUOTALOGCMD_LOG_FIELD.full_name = ".Cmd.ReqQuotaLogCmd.log"
REQQUOTALOGCMD_LOG_FIELD.number = 4
REQQUOTALOGCMD_LOG_FIELD.index = 3
REQQUOTALOGCMD_LOG_FIELD.label = 3
REQQUOTALOGCMD_LOG_FIELD.has_default_value = false
REQQUOTALOGCMD_LOG_FIELD.default_value = {}
REQQUOTALOGCMD_LOG_FIELD.message_type = QUOTALOG
REQQUOTALOGCMD_LOG_FIELD.type = 11
REQQUOTALOGCMD_LOG_FIELD.cpp_type = 10
REQQUOTALOGCMD.name = "ReqQuotaLogCmd"
REQQUOTALOGCMD.full_name = ".Cmd.ReqQuotaLogCmd"
REQQUOTALOGCMD.nested_types = {}
REQQUOTALOGCMD.enum_types = {}
REQQUOTALOGCMD.fields = {
  REQQUOTALOGCMD_CMD_FIELD,
  REQQUOTALOGCMD_PARAM_FIELD,
  REQQUOTALOGCMD_PAGE_INDEX_FIELD,
  REQQUOTALOGCMD_LOG_FIELD
}
REQQUOTALOGCMD.is_extendable = false
REQQUOTALOGCMD.extensions = {}
REQQUOTADETAILCMD_CMD_FIELD.name = "cmd"
REQQUOTADETAILCMD_CMD_FIELD.full_name = ".Cmd.ReqQuotaDetailCmd.cmd"
REQQUOTADETAILCMD_CMD_FIELD.number = 1
REQQUOTADETAILCMD_CMD_FIELD.index = 0
REQQUOTADETAILCMD_CMD_FIELD.label = 1
REQQUOTADETAILCMD_CMD_FIELD.has_default_value = true
REQQUOTADETAILCMD_CMD_FIELD.default_value = 6
REQQUOTADETAILCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REQQUOTADETAILCMD_CMD_FIELD.type = 14
REQQUOTADETAILCMD_CMD_FIELD.cpp_type = 8
REQQUOTADETAILCMD_PARAM_FIELD.name = "param"
REQQUOTADETAILCMD_PARAM_FIELD.full_name = ".Cmd.ReqQuotaDetailCmd.param"
REQQUOTADETAILCMD_PARAM_FIELD.number = 2
REQQUOTADETAILCMD_PARAM_FIELD.index = 1
REQQUOTADETAILCMD_PARAM_FIELD.label = 1
REQQUOTADETAILCMD_PARAM_FIELD.has_default_value = true
REQQUOTADETAILCMD_PARAM_FIELD.default_value = 41
REQQUOTADETAILCMD_PARAM_FIELD.enum_type = ITEMPARAM
REQQUOTADETAILCMD_PARAM_FIELD.type = 14
REQQUOTADETAILCMD_PARAM_FIELD.cpp_type = 8
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.name = "page_index"
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.full_name = ".Cmd.ReqQuotaDetailCmd.page_index"
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.number = 3
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.index = 2
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.label = 1
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.has_default_value = false
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.default_value = 0
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.type = 13
REQQUOTADETAILCMD_PAGE_INDEX_FIELD.cpp_type = 3
REQQUOTADETAILCMD_DETAIL_FIELD.name = "detail"
REQQUOTADETAILCMD_DETAIL_FIELD.full_name = ".Cmd.ReqQuotaDetailCmd.detail"
REQQUOTADETAILCMD_DETAIL_FIELD.number = 4
REQQUOTADETAILCMD_DETAIL_FIELD.index = 3
REQQUOTADETAILCMD_DETAIL_FIELD.label = 3
REQQUOTADETAILCMD_DETAIL_FIELD.has_default_value = false
REQQUOTADETAILCMD_DETAIL_FIELD.default_value = {}
REQQUOTADETAILCMD_DETAIL_FIELD.message_type = QUOTADETAIL
REQQUOTADETAILCMD_DETAIL_FIELD.type = 11
REQQUOTADETAILCMD_DETAIL_FIELD.cpp_type = 10
REQQUOTADETAILCMD.name = "ReqQuotaDetailCmd"
REQQUOTADETAILCMD.full_name = ".Cmd.ReqQuotaDetailCmd"
REQQUOTADETAILCMD.nested_types = {}
REQQUOTADETAILCMD.enum_types = {}
REQQUOTADETAILCMD.fields = {
  REQQUOTADETAILCMD_CMD_FIELD,
  REQQUOTADETAILCMD_PARAM_FIELD,
  REQQUOTADETAILCMD_PAGE_INDEX_FIELD,
  REQQUOTADETAILCMD_DETAIL_FIELD
}
REQQUOTADETAILCMD.is_extendable = false
REQQUOTADETAILCMD.extensions = {}
EQUIPPOSDATA_POS_FIELD.name = "pos"
EQUIPPOSDATA_POS_FIELD.full_name = ".Cmd.EquipPosData.pos"
EQUIPPOSDATA_POS_FIELD.number = 1
EQUIPPOSDATA_POS_FIELD.index = 0
EQUIPPOSDATA_POS_FIELD.label = 1
EQUIPPOSDATA_POS_FIELD.has_default_value = true
EQUIPPOSDATA_POS_FIELD.default_value = 0
EQUIPPOSDATA_POS_FIELD.enum_type = EEQUIPPOS
EQUIPPOSDATA_POS_FIELD.type = 14
EQUIPPOSDATA_POS_FIELD.cpp_type = 8
EQUIPPOSDATA_OFFSTARTTIME_FIELD.name = "offstarttime"
EQUIPPOSDATA_OFFSTARTTIME_FIELD.full_name = ".Cmd.EquipPosData.offstarttime"
EQUIPPOSDATA_OFFSTARTTIME_FIELD.number = 2
EQUIPPOSDATA_OFFSTARTTIME_FIELD.index = 1
EQUIPPOSDATA_OFFSTARTTIME_FIELD.label = 1
EQUIPPOSDATA_OFFSTARTTIME_FIELD.has_default_value = true
EQUIPPOSDATA_OFFSTARTTIME_FIELD.default_value = 0
EQUIPPOSDATA_OFFSTARTTIME_FIELD.type = 13
EQUIPPOSDATA_OFFSTARTTIME_FIELD.cpp_type = 3
EQUIPPOSDATA_OFFENDTIME_FIELD.name = "offendtime"
EQUIPPOSDATA_OFFENDTIME_FIELD.full_name = ".Cmd.EquipPosData.offendtime"
EQUIPPOSDATA_OFFENDTIME_FIELD.number = 3
EQUIPPOSDATA_OFFENDTIME_FIELD.index = 2
EQUIPPOSDATA_OFFENDTIME_FIELD.label = 1
EQUIPPOSDATA_OFFENDTIME_FIELD.has_default_value = true
EQUIPPOSDATA_OFFENDTIME_FIELD.default_value = 0
EQUIPPOSDATA_OFFENDTIME_FIELD.type = 13
EQUIPPOSDATA_OFFENDTIME_FIELD.cpp_type = 3
EQUIPPOSDATA_PROTECTTIME_FIELD.name = "protecttime"
EQUIPPOSDATA_PROTECTTIME_FIELD.full_name = ".Cmd.EquipPosData.protecttime"
EQUIPPOSDATA_PROTECTTIME_FIELD.number = 4
EQUIPPOSDATA_PROTECTTIME_FIELD.index = 3
EQUIPPOSDATA_PROTECTTIME_FIELD.label = 1
EQUIPPOSDATA_PROTECTTIME_FIELD.has_default_value = true
EQUIPPOSDATA_PROTECTTIME_FIELD.default_value = 0
EQUIPPOSDATA_PROTECTTIME_FIELD.type = 13
EQUIPPOSDATA_PROTECTTIME_FIELD.cpp_type = 3
EQUIPPOSDATA_PROTECTALWAYS_FIELD.name = "protectalways"
EQUIPPOSDATA_PROTECTALWAYS_FIELD.full_name = ".Cmd.EquipPosData.protectalways"
EQUIPPOSDATA_PROTECTALWAYS_FIELD.number = 5
EQUIPPOSDATA_PROTECTALWAYS_FIELD.index = 4
EQUIPPOSDATA_PROTECTALWAYS_FIELD.label = 1
EQUIPPOSDATA_PROTECTALWAYS_FIELD.has_default_value = true
EQUIPPOSDATA_PROTECTALWAYS_FIELD.default_value = 0
EQUIPPOSDATA_PROTECTALWAYS_FIELD.type = 13
EQUIPPOSDATA_PROTECTALWAYS_FIELD.cpp_type = 3
EQUIPPOSDATA_RECORDGUID_FIELD.name = "recordguid"
EQUIPPOSDATA_RECORDGUID_FIELD.full_name = ".Cmd.EquipPosData.recordguid"
EQUIPPOSDATA_RECORDGUID_FIELD.number = 6
EQUIPPOSDATA_RECORDGUID_FIELD.index = 5
EQUIPPOSDATA_RECORDGUID_FIELD.label = 1
EQUIPPOSDATA_RECORDGUID_FIELD.has_default_value = false
EQUIPPOSDATA_RECORDGUID_FIELD.default_value = ""
EQUIPPOSDATA_RECORDGUID_FIELD.type = 9
EQUIPPOSDATA_RECORDGUID_FIELD.cpp_type = 9
EQUIPPOSDATA.name = "EquipPosData"
EQUIPPOSDATA.full_name = ".Cmd.EquipPosData"
EQUIPPOSDATA.nested_types = {}
EQUIPPOSDATA.enum_types = {}
EQUIPPOSDATA.fields = {
  EQUIPPOSDATA_POS_FIELD,
  EQUIPPOSDATA_OFFSTARTTIME_FIELD,
  EQUIPPOSDATA_OFFENDTIME_FIELD,
  EQUIPPOSDATA_PROTECTTIME_FIELD,
  EQUIPPOSDATA_PROTECTALWAYS_FIELD,
  EQUIPPOSDATA_RECORDGUID_FIELD
}
EQUIPPOSDATA.is_extendable = false
EQUIPPOSDATA.extensions = {}
EQUIPPOSDATAUPDATE_CMD_FIELD.name = "cmd"
EQUIPPOSDATAUPDATE_CMD_FIELD.full_name = ".Cmd.EquipPosDataUpdate.cmd"
EQUIPPOSDATAUPDATE_CMD_FIELD.number = 1
EQUIPPOSDATAUPDATE_CMD_FIELD.index = 0
EQUIPPOSDATAUPDATE_CMD_FIELD.label = 1
EQUIPPOSDATAUPDATE_CMD_FIELD.has_default_value = true
EQUIPPOSDATAUPDATE_CMD_FIELD.default_value = 6
EQUIPPOSDATAUPDATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIPPOSDATAUPDATE_CMD_FIELD.type = 14
EQUIPPOSDATAUPDATE_CMD_FIELD.cpp_type = 8
EQUIPPOSDATAUPDATE_PARAM_FIELD.name = "param"
EQUIPPOSDATAUPDATE_PARAM_FIELD.full_name = ".Cmd.EquipPosDataUpdate.param"
EQUIPPOSDATAUPDATE_PARAM_FIELD.number = 2
EQUIPPOSDATAUPDATE_PARAM_FIELD.index = 1
EQUIPPOSDATAUPDATE_PARAM_FIELD.label = 1
EQUIPPOSDATAUPDATE_PARAM_FIELD.has_default_value = true
EQUIPPOSDATAUPDATE_PARAM_FIELD.default_value = 42
EQUIPPOSDATAUPDATE_PARAM_FIELD.enum_type = ITEMPARAM
EQUIPPOSDATAUPDATE_PARAM_FIELD.type = 14
EQUIPPOSDATAUPDATE_PARAM_FIELD.cpp_type = 8
EQUIPPOSDATAUPDATE_DATAS_FIELD.name = "datas"
EQUIPPOSDATAUPDATE_DATAS_FIELD.full_name = ".Cmd.EquipPosDataUpdate.datas"
EQUIPPOSDATAUPDATE_DATAS_FIELD.number = 3
EQUIPPOSDATAUPDATE_DATAS_FIELD.index = 2
EQUIPPOSDATAUPDATE_DATAS_FIELD.label = 3
EQUIPPOSDATAUPDATE_DATAS_FIELD.has_default_value = false
EQUIPPOSDATAUPDATE_DATAS_FIELD.default_value = {}
EQUIPPOSDATAUPDATE_DATAS_FIELD.message_type = EQUIPPOSDATA
EQUIPPOSDATAUPDATE_DATAS_FIELD.type = 11
EQUIPPOSDATAUPDATE_DATAS_FIELD.cpp_type = 10
EQUIPPOSDATAUPDATE.name = "EquipPosDataUpdate"
EQUIPPOSDATAUPDATE.full_name = ".Cmd.EquipPosDataUpdate"
EQUIPPOSDATAUPDATE.nested_types = {}
EQUIPPOSDATAUPDATE.enum_types = {}
EQUIPPOSDATAUPDATE.fields = {
  EQUIPPOSDATAUPDATE_CMD_FIELD,
  EQUIPPOSDATAUPDATE_PARAM_FIELD,
  EQUIPPOSDATAUPDATE_DATAS_FIELD
}
EQUIPPOSDATAUPDATE.is_extendable = false
EQUIPPOSDATAUPDATE.extensions = {}
MATITEMINFO_ITEMID_FIELD.name = "itemid"
MATITEMINFO_ITEMID_FIELD.full_name = ".Cmd.MatItemInfo.itemid"
MATITEMINFO_ITEMID_FIELD.number = 1
MATITEMINFO_ITEMID_FIELD.index = 0
MATITEMINFO_ITEMID_FIELD.label = 1
MATITEMINFO_ITEMID_FIELD.has_default_value = false
MATITEMINFO_ITEMID_FIELD.default_value = 0
MATITEMINFO_ITEMID_FIELD.type = 13
MATITEMINFO_ITEMID_FIELD.cpp_type = 3
MATITEMINFO_NUM_FIELD.name = "num"
MATITEMINFO_NUM_FIELD.full_name = ".Cmd.MatItemInfo.num"
MATITEMINFO_NUM_FIELD.number = 2
MATITEMINFO_NUM_FIELD.index = 1
MATITEMINFO_NUM_FIELD.label = 1
MATITEMINFO_NUM_FIELD.has_default_value = false
MATITEMINFO_NUM_FIELD.default_value = 0
MATITEMINFO_NUM_FIELD.type = 13
MATITEMINFO_NUM_FIELD.cpp_type = 3
MATITEMINFO.name = "MatItemInfo"
MATITEMINFO.full_name = ".Cmd.MatItemInfo"
MATITEMINFO.nested_types = {}
MATITEMINFO.enum_types = {}
MATITEMINFO.fields = {
  MATITEMINFO_ITEMID_FIELD,
  MATITEMINFO_NUM_FIELD
}
MATITEMINFO.is_extendable = false
MATITEMINFO.extensions = {}
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.name = "cmd"
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.full_name = ".Cmd.HighRefineMatComposeCmd.cmd"
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.number = 1
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.index = 0
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.label = 1
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.has_default_value = true
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.default_value = 6
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.type = 14
HIGHREFINEMATCOMPOSECMD_CMD_FIELD.cpp_type = 8
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.name = "param"
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.full_name = ".Cmd.HighRefineMatComposeCmd.param"
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.number = 2
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.index = 1
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.label = 1
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.has_default_value = true
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.default_value = 36
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.enum_type = ITEMPARAM
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.type = 14
HIGHREFINEMATCOMPOSECMD_PARAM_FIELD.cpp_type = 8
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.name = "dataid"
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.full_name = ".Cmd.HighRefineMatComposeCmd.dataid"
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.number = 3
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.index = 2
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.label = 1
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.has_default_value = false
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.default_value = 0
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.type = 13
HIGHREFINEMATCOMPOSECMD_DATAID_FIELD.cpp_type = 3
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.name = "npcid"
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.full_name = ".Cmd.HighRefineMatComposeCmd.npcid"
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.number = 4
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.index = 3
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.label = 1
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.has_default_value = false
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.default_value = 0
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.type = 4
HIGHREFINEMATCOMPOSECMD_NPCID_FIELD.cpp_type = 4
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.name = "mainmaterial"
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.full_name = ".Cmd.HighRefineMatComposeCmd.mainmaterial"
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.number = 5
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.index = 4
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.label = 3
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.has_default_value = false
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.default_value = {}
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.message_type = MATITEMINFO
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.type = 11
HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD.cpp_type = 10
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.name = "vicematerial"
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.full_name = ".Cmd.HighRefineMatComposeCmd.vicematerial"
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.number = 6
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.index = 5
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.label = 3
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.has_default_value = false
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.default_value = {}
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.message_type = MATITEMINFO
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.type = 11
HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD.cpp_type = 10
HIGHREFINEMATCOMPOSECMD.name = "HighRefineMatComposeCmd"
HIGHREFINEMATCOMPOSECMD.full_name = ".Cmd.HighRefineMatComposeCmd"
HIGHREFINEMATCOMPOSECMD.nested_types = {}
HIGHREFINEMATCOMPOSECMD.enum_types = {}
HIGHREFINEMATCOMPOSECMD.fields = {
  HIGHREFINEMATCOMPOSECMD_CMD_FIELD,
  HIGHREFINEMATCOMPOSECMD_PARAM_FIELD,
  HIGHREFINEMATCOMPOSECMD_DATAID_FIELD,
  HIGHREFINEMATCOMPOSECMD_NPCID_FIELD,
  HIGHREFINEMATCOMPOSECMD_MAINMATERIAL_FIELD,
  HIGHREFINEMATCOMPOSECMD_VICEMATERIAL_FIELD
}
HIGHREFINEMATCOMPOSECMD.is_extendable = false
HIGHREFINEMATCOMPOSECMD.extensions = {}
HIGHREFINECMD_CMD_FIELD.name = "cmd"
HIGHREFINECMD_CMD_FIELD.full_name = ".Cmd.HighRefineCmd.cmd"
HIGHREFINECMD_CMD_FIELD.number = 1
HIGHREFINECMD_CMD_FIELD.index = 0
HIGHREFINECMD_CMD_FIELD.label = 1
HIGHREFINECMD_CMD_FIELD.has_default_value = true
HIGHREFINECMD_CMD_FIELD.default_value = 6
HIGHREFINECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
HIGHREFINECMD_CMD_FIELD.type = 14
HIGHREFINECMD_CMD_FIELD.cpp_type = 8
HIGHREFINECMD_PARAM_FIELD.name = "param"
HIGHREFINECMD_PARAM_FIELD.full_name = ".Cmd.HighRefineCmd.param"
HIGHREFINECMD_PARAM_FIELD.number = 2
HIGHREFINECMD_PARAM_FIELD.index = 1
HIGHREFINECMD_PARAM_FIELD.label = 1
HIGHREFINECMD_PARAM_FIELD.has_default_value = true
HIGHREFINECMD_PARAM_FIELD.default_value = 37
HIGHREFINECMD_PARAM_FIELD.enum_type = ITEMPARAM
HIGHREFINECMD_PARAM_FIELD.type = 14
HIGHREFINECMD_PARAM_FIELD.cpp_type = 8
HIGHREFINECMD_DATAID_FIELD.name = "dataid"
HIGHREFINECMD_DATAID_FIELD.full_name = ".Cmd.HighRefineCmd.dataid"
HIGHREFINECMD_DATAID_FIELD.number = 3
HIGHREFINECMD_DATAID_FIELD.index = 2
HIGHREFINECMD_DATAID_FIELD.label = 1
HIGHREFINECMD_DATAID_FIELD.has_default_value = false
HIGHREFINECMD_DATAID_FIELD.default_value = 0
HIGHREFINECMD_DATAID_FIELD.type = 13
HIGHREFINECMD_DATAID_FIELD.cpp_type = 3
HIGHREFINECMD.name = "HighRefineCmd"
HIGHREFINECMD.full_name = ".Cmd.HighRefineCmd"
HIGHREFINECMD.nested_types = {}
HIGHREFINECMD.enum_types = {}
HIGHREFINECMD.fields = {
  HIGHREFINECMD_CMD_FIELD,
  HIGHREFINECMD_PARAM_FIELD,
  HIGHREFINECMD_DATAID_FIELD
}
HIGHREFINECMD.is_extendable = false
HIGHREFINECMD.extensions = {}
HIGHREFINEDATA_POS_FIELD.name = "pos"
HIGHREFINEDATA_POS_FIELD.full_name = ".Cmd.HighRefineData.pos"
HIGHREFINEDATA_POS_FIELD.number = 1
HIGHREFINEDATA_POS_FIELD.index = 0
HIGHREFINEDATA_POS_FIELD.label = 1
HIGHREFINEDATA_POS_FIELD.has_default_value = false
HIGHREFINEDATA_POS_FIELD.default_value = nil
HIGHREFINEDATA_POS_FIELD.enum_type = EEQUIPPOS
HIGHREFINEDATA_POS_FIELD.type = 14
HIGHREFINEDATA_POS_FIELD.cpp_type = 8
HIGHREFINEDATA_LEVEL_FIELD.name = "level"
HIGHREFINEDATA_LEVEL_FIELD.full_name = ".Cmd.HighRefineData.level"
HIGHREFINEDATA_LEVEL_FIELD.number = 2
HIGHREFINEDATA_LEVEL_FIELD.index = 1
HIGHREFINEDATA_LEVEL_FIELD.label = 3
HIGHREFINEDATA_LEVEL_FIELD.has_default_value = false
HIGHREFINEDATA_LEVEL_FIELD.default_value = {}
HIGHREFINEDATA_LEVEL_FIELD.type = 13
HIGHREFINEDATA_LEVEL_FIELD.cpp_type = 3
HIGHREFINEDATA.name = "HighRefineData"
HIGHREFINEDATA.full_name = ".Cmd.HighRefineData"
HIGHREFINEDATA.nested_types = {}
HIGHREFINEDATA.enum_types = {}
HIGHREFINEDATA.fields = {
  HIGHREFINEDATA_POS_FIELD,
  HIGHREFINEDATA_LEVEL_FIELD
}
HIGHREFINEDATA.is_extendable = false
HIGHREFINEDATA.extensions = {}
NTFHIGHREFINEDATACMD_CMD_FIELD.name = "cmd"
NTFHIGHREFINEDATACMD_CMD_FIELD.full_name = ".Cmd.NtfHighRefineDataCmd.cmd"
NTFHIGHREFINEDATACMD_CMD_FIELD.number = 1
NTFHIGHREFINEDATACMD_CMD_FIELD.index = 0
NTFHIGHREFINEDATACMD_CMD_FIELD.label = 1
NTFHIGHREFINEDATACMD_CMD_FIELD.has_default_value = true
NTFHIGHREFINEDATACMD_CMD_FIELD.default_value = 6
NTFHIGHREFINEDATACMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NTFHIGHREFINEDATACMD_CMD_FIELD.type = 14
NTFHIGHREFINEDATACMD_CMD_FIELD.cpp_type = 8
NTFHIGHREFINEDATACMD_PARAM_FIELD.name = "param"
NTFHIGHREFINEDATACMD_PARAM_FIELD.full_name = ".Cmd.NtfHighRefineDataCmd.param"
NTFHIGHREFINEDATACMD_PARAM_FIELD.number = 2
NTFHIGHREFINEDATACMD_PARAM_FIELD.index = 1
NTFHIGHREFINEDATACMD_PARAM_FIELD.label = 1
NTFHIGHREFINEDATACMD_PARAM_FIELD.has_default_value = true
NTFHIGHREFINEDATACMD_PARAM_FIELD.default_value = 38
NTFHIGHREFINEDATACMD_PARAM_FIELD.enum_type = ITEMPARAM
NTFHIGHREFINEDATACMD_PARAM_FIELD.type = 14
NTFHIGHREFINEDATACMD_PARAM_FIELD.cpp_type = 8
NTFHIGHREFINEDATACMD_DATAS_FIELD.name = "datas"
NTFHIGHREFINEDATACMD_DATAS_FIELD.full_name = ".Cmd.NtfHighRefineDataCmd.datas"
NTFHIGHREFINEDATACMD_DATAS_FIELD.number = 3
NTFHIGHREFINEDATACMD_DATAS_FIELD.index = 2
NTFHIGHREFINEDATACMD_DATAS_FIELD.label = 3
NTFHIGHREFINEDATACMD_DATAS_FIELD.has_default_value = false
NTFHIGHREFINEDATACMD_DATAS_FIELD.default_value = {}
NTFHIGHREFINEDATACMD_DATAS_FIELD.message_type = HIGHREFINEDATA
NTFHIGHREFINEDATACMD_DATAS_FIELD.type = 11
NTFHIGHREFINEDATACMD_DATAS_FIELD.cpp_type = 10
NTFHIGHREFINEDATACMD.name = "NtfHighRefineDataCmd"
NTFHIGHREFINEDATACMD.full_name = ".Cmd.NtfHighRefineDataCmd"
NTFHIGHREFINEDATACMD.nested_types = {}
NTFHIGHREFINEDATACMD.enum_types = {}
NTFHIGHREFINEDATACMD.fields = {
  NTFHIGHREFINEDATACMD_CMD_FIELD,
  NTFHIGHREFINEDATACMD_PARAM_FIELD,
  NTFHIGHREFINEDATACMD_DATAS_FIELD
}
NTFHIGHREFINEDATACMD.is_extendable = false
NTFHIGHREFINEDATACMD.extensions = {}
UPDATEHIGHREFINEDATACMD_CMD_FIELD.name = "cmd"
UPDATEHIGHREFINEDATACMD_CMD_FIELD.full_name = ".Cmd.UpdateHighRefineDataCmd.cmd"
UPDATEHIGHREFINEDATACMD_CMD_FIELD.number = 1
UPDATEHIGHREFINEDATACMD_CMD_FIELD.index = 0
UPDATEHIGHREFINEDATACMD_CMD_FIELD.label = 1
UPDATEHIGHREFINEDATACMD_CMD_FIELD.has_default_value = true
UPDATEHIGHREFINEDATACMD_CMD_FIELD.default_value = 6
UPDATEHIGHREFINEDATACMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEHIGHREFINEDATACMD_CMD_FIELD.type = 14
UPDATEHIGHREFINEDATACMD_CMD_FIELD.cpp_type = 8
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.name = "param"
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.full_name = ".Cmd.UpdateHighRefineDataCmd.param"
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.number = 2
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.index = 1
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.label = 1
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.has_default_value = true
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.default_value = 39
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.enum_type = ITEMPARAM
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.type = 14
UPDATEHIGHREFINEDATACMD_PARAM_FIELD.cpp_type = 8
UPDATEHIGHREFINEDATACMD_DATA_FIELD.name = "data"
UPDATEHIGHREFINEDATACMD_DATA_FIELD.full_name = ".Cmd.UpdateHighRefineDataCmd.data"
UPDATEHIGHREFINEDATACMD_DATA_FIELD.number = 3
UPDATEHIGHREFINEDATACMD_DATA_FIELD.index = 2
UPDATEHIGHREFINEDATACMD_DATA_FIELD.label = 1
UPDATEHIGHREFINEDATACMD_DATA_FIELD.has_default_value = false
UPDATEHIGHREFINEDATACMD_DATA_FIELD.default_value = nil
UPDATEHIGHREFINEDATACMD_DATA_FIELD.message_type = HIGHREFINEDATA
UPDATEHIGHREFINEDATACMD_DATA_FIELD.type = 11
UPDATEHIGHREFINEDATACMD_DATA_FIELD.cpp_type = 10
UPDATEHIGHREFINEDATACMD.name = "UpdateHighRefineDataCmd"
UPDATEHIGHREFINEDATACMD.full_name = ".Cmd.UpdateHighRefineDataCmd"
UPDATEHIGHREFINEDATACMD.nested_types = {}
UPDATEHIGHREFINEDATACMD.enum_types = {}
UPDATEHIGHREFINEDATACMD.fields = {
  UPDATEHIGHREFINEDATACMD_CMD_FIELD,
  UPDATEHIGHREFINEDATACMD_PARAM_FIELD,
  UPDATEHIGHREFINEDATACMD_DATA_FIELD
}
UPDATEHIGHREFINEDATACMD.is_extendable = false
UPDATEHIGHREFINEDATACMD.extensions = {}
USECODITEMCMD_CMD_FIELD.name = "cmd"
USECODITEMCMD_CMD_FIELD.full_name = ".Cmd.UseCodItemCmd.cmd"
USECODITEMCMD_CMD_FIELD.number = 1
USECODITEMCMD_CMD_FIELD.index = 0
USECODITEMCMD_CMD_FIELD.label = 1
USECODITEMCMD_CMD_FIELD.has_default_value = true
USECODITEMCMD_CMD_FIELD.default_value = 6
USECODITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USECODITEMCMD_CMD_FIELD.type = 14
USECODITEMCMD_CMD_FIELD.cpp_type = 8
USECODITEMCMD_PARAM_FIELD.name = "param"
USECODITEMCMD_PARAM_FIELD.full_name = ".Cmd.UseCodItemCmd.param"
USECODITEMCMD_PARAM_FIELD.number = 2
USECODITEMCMD_PARAM_FIELD.index = 1
USECODITEMCMD_PARAM_FIELD.label = 1
USECODITEMCMD_PARAM_FIELD.has_default_value = true
USECODITEMCMD_PARAM_FIELD.default_value = 43
USECODITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
USECODITEMCMD_PARAM_FIELD.type = 14
USECODITEMCMD_PARAM_FIELD.cpp_type = 8
USECODITEMCMD_GUID_FIELD.name = "guid"
USECODITEMCMD_GUID_FIELD.full_name = ".Cmd.UseCodItemCmd.guid"
USECODITEMCMD_GUID_FIELD.number = 3
USECODITEMCMD_GUID_FIELD.index = 2
USECODITEMCMD_GUID_FIELD.label = 1
USECODITEMCMD_GUID_FIELD.has_default_value = false
USECODITEMCMD_GUID_FIELD.default_value = ""
USECODITEMCMD_GUID_FIELD.type = 9
USECODITEMCMD_GUID_FIELD.cpp_type = 9
USECODITEMCMD_CODE_FIELD.name = "code"
USECODITEMCMD_CODE_FIELD.full_name = ".Cmd.UseCodItemCmd.code"
USECODITEMCMD_CODE_FIELD.number = 4
USECODITEMCMD_CODE_FIELD.index = 3
USECODITEMCMD_CODE_FIELD.label = 1
USECODITEMCMD_CODE_FIELD.has_default_value = false
USECODITEMCMD_CODE_FIELD.default_value = ""
USECODITEMCMD_CODE_FIELD.type = 9
USECODITEMCMD_CODE_FIELD.cpp_type = 9
USECODITEMCMD.name = "UseCodItemCmd"
USECODITEMCMD.full_name = ".Cmd.UseCodItemCmd"
USECODITEMCMD.nested_types = {}
USECODITEMCMD.enum_types = {}
USECODITEMCMD.fields = {
  USECODITEMCMD_CMD_FIELD,
  USECODITEMCMD_PARAM_FIELD,
  USECODITEMCMD_GUID_FIELD,
  USECODITEMCMD_CODE_FIELD
}
USECODITEMCMD.is_extendable = false
USECODITEMCMD.extensions = {}
ADDJOBLEVELITEMCMD_CMD_FIELD.name = "cmd"
ADDJOBLEVELITEMCMD_CMD_FIELD.full_name = ".Cmd.AddJobLevelItemCmd.cmd"
ADDJOBLEVELITEMCMD_CMD_FIELD.number = 1
ADDJOBLEVELITEMCMD_CMD_FIELD.index = 0
ADDJOBLEVELITEMCMD_CMD_FIELD.label = 1
ADDJOBLEVELITEMCMD_CMD_FIELD.has_default_value = true
ADDJOBLEVELITEMCMD_CMD_FIELD.default_value = 6
ADDJOBLEVELITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ADDJOBLEVELITEMCMD_CMD_FIELD.type = 14
ADDJOBLEVELITEMCMD_CMD_FIELD.cpp_type = 8
ADDJOBLEVELITEMCMD_PARAM_FIELD.name = "param"
ADDJOBLEVELITEMCMD_PARAM_FIELD.full_name = ".Cmd.AddJobLevelItemCmd.param"
ADDJOBLEVELITEMCMD_PARAM_FIELD.number = 2
ADDJOBLEVELITEMCMD_PARAM_FIELD.index = 1
ADDJOBLEVELITEMCMD_PARAM_FIELD.label = 1
ADDJOBLEVELITEMCMD_PARAM_FIELD.has_default_value = true
ADDJOBLEVELITEMCMD_PARAM_FIELD.default_value = 44
ADDJOBLEVELITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
ADDJOBLEVELITEMCMD_PARAM_FIELD.type = 14
ADDJOBLEVELITEMCMD_PARAM_FIELD.cpp_type = 8
ADDJOBLEVELITEMCMD_ITEM_FIELD.name = "item"
ADDJOBLEVELITEMCMD_ITEM_FIELD.full_name = ".Cmd.AddJobLevelItemCmd.item"
ADDJOBLEVELITEMCMD_ITEM_FIELD.number = 3
ADDJOBLEVELITEMCMD_ITEM_FIELD.index = 2
ADDJOBLEVELITEMCMD_ITEM_FIELD.label = 1
ADDJOBLEVELITEMCMD_ITEM_FIELD.has_default_value = true
ADDJOBLEVELITEMCMD_ITEM_FIELD.default_value = 0
ADDJOBLEVELITEMCMD_ITEM_FIELD.type = 13
ADDJOBLEVELITEMCMD_ITEM_FIELD.cpp_type = 3
ADDJOBLEVELITEMCMD_NUM_FIELD.name = "num"
ADDJOBLEVELITEMCMD_NUM_FIELD.full_name = ".Cmd.AddJobLevelItemCmd.num"
ADDJOBLEVELITEMCMD_NUM_FIELD.number = 4
ADDJOBLEVELITEMCMD_NUM_FIELD.index = 3
ADDJOBLEVELITEMCMD_NUM_FIELD.label = 1
ADDJOBLEVELITEMCMD_NUM_FIELD.has_default_value = true
ADDJOBLEVELITEMCMD_NUM_FIELD.default_value = 0
ADDJOBLEVELITEMCMD_NUM_FIELD.type = 13
ADDJOBLEVELITEMCMD_NUM_FIELD.cpp_type = 3
ADDJOBLEVELITEMCMD.name = "AddJobLevelItemCmd"
ADDJOBLEVELITEMCMD.full_name = ".Cmd.AddJobLevelItemCmd"
ADDJOBLEVELITEMCMD.nested_types = {}
ADDJOBLEVELITEMCMD.enum_types = {}
ADDJOBLEVELITEMCMD.fields = {
  ADDJOBLEVELITEMCMD_CMD_FIELD,
  ADDJOBLEVELITEMCMD_PARAM_FIELD,
  ADDJOBLEVELITEMCMD_ITEM_FIELD,
  ADDJOBLEVELITEMCMD_NUM_FIELD
}
ADDJOBLEVELITEMCMD.is_extendable = false
ADDJOBLEVELITEMCMD.extensions = {}
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.name = "cmd"
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.full_name = ".Cmd.LotterGivBuyCountCmd.cmd"
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.number = 1
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.index = 0
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.label = 1
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.has_default_value = true
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.default_value = 6
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.type = 14
LOTTERGIVBUYCOUNTCMD_CMD_FIELD.cpp_type = 8
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.name = "param"
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.full_name = ".Cmd.LotterGivBuyCountCmd.param"
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.number = 2
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.index = 1
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.label = 1
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.has_default_value = true
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.default_value = 46
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.enum_type = ITEMPARAM
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.type = 14
LOTTERGIVBUYCOUNTCMD_PARAM_FIELD.cpp_type = 8
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.name = "got_count"
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.full_name = ".Cmd.LotterGivBuyCountCmd.got_count"
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.number = 3
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.index = 2
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.label = 1
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.has_default_value = false
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.default_value = 0
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.type = 13
LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD.cpp_type = 3
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.name = "max_count"
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.full_name = ".Cmd.LotterGivBuyCountCmd.max_count"
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.number = 4
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.index = 3
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.label = 1
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.has_default_value = false
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.default_value = 0
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.type = 13
LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD.cpp_type = 3
LOTTERGIVBUYCOUNTCMD.name = "LotterGivBuyCountCmd"
LOTTERGIVBUYCOUNTCMD.full_name = ".Cmd.LotterGivBuyCountCmd"
LOTTERGIVBUYCOUNTCMD.nested_types = {}
LOTTERGIVBUYCOUNTCMD.enum_types = {}
LOTTERGIVBUYCOUNTCMD.fields = {
  LOTTERGIVBUYCOUNTCMD_CMD_FIELD,
  LOTTERGIVBUYCOUNTCMD_PARAM_FIELD,
  LOTTERGIVBUYCOUNTCMD_GOT_COUNT_FIELD,
  LOTTERGIVBUYCOUNTCMD_MAX_COUNT_FIELD
}
LOTTERGIVBUYCOUNTCMD.is_extendable = false
LOTTERGIVBUYCOUNTCMD.extensions = {}
GIVEWEDDINGDRESSCMD_CMD_FIELD.name = "cmd"
GIVEWEDDINGDRESSCMD_CMD_FIELD.full_name = ".Cmd.GiveWeddingDressCmd.cmd"
GIVEWEDDINGDRESSCMD_CMD_FIELD.number = 1
GIVEWEDDINGDRESSCMD_CMD_FIELD.index = 0
GIVEWEDDINGDRESSCMD_CMD_FIELD.label = 1
GIVEWEDDINGDRESSCMD_CMD_FIELD.has_default_value = true
GIVEWEDDINGDRESSCMD_CMD_FIELD.default_value = 6
GIVEWEDDINGDRESSCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GIVEWEDDINGDRESSCMD_CMD_FIELD.type = 14
GIVEWEDDINGDRESSCMD_CMD_FIELD.cpp_type = 8
GIVEWEDDINGDRESSCMD_PARAM_FIELD.name = "param"
GIVEWEDDINGDRESSCMD_PARAM_FIELD.full_name = ".Cmd.GiveWeddingDressCmd.param"
GIVEWEDDINGDRESSCMD_PARAM_FIELD.number = 2
GIVEWEDDINGDRESSCMD_PARAM_FIELD.index = 1
GIVEWEDDINGDRESSCMD_PARAM_FIELD.label = 1
GIVEWEDDINGDRESSCMD_PARAM_FIELD.has_default_value = true
GIVEWEDDINGDRESSCMD_PARAM_FIELD.default_value = 47
GIVEWEDDINGDRESSCMD_PARAM_FIELD.enum_type = ITEMPARAM
GIVEWEDDINGDRESSCMD_PARAM_FIELD.type = 14
GIVEWEDDINGDRESSCMD_PARAM_FIELD.cpp_type = 8
GIVEWEDDINGDRESSCMD_GUID_FIELD.name = "guid"
GIVEWEDDINGDRESSCMD_GUID_FIELD.full_name = ".Cmd.GiveWeddingDressCmd.guid"
GIVEWEDDINGDRESSCMD_GUID_FIELD.number = 3
GIVEWEDDINGDRESSCMD_GUID_FIELD.index = 2
GIVEWEDDINGDRESSCMD_GUID_FIELD.label = 1
GIVEWEDDINGDRESSCMD_GUID_FIELD.has_default_value = false
GIVEWEDDINGDRESSCMD_GUID_FIELD.default_value = ""
GIVEWEDDINGDRESSCMD_GUID_FIELD.type = 9
GIVEWEDDINGDRESSCMD_GUID_FIELD.cpp_type = 9
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.name = "content"
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.full_name = ".Cmd.GiveWeddingDressCmd.content"
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.number = 6
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.index = 3
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.label = 1
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.has_default_value = false
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.default_value = ""
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.type = 9
GIVEWEDDINGDRESSCMD_CONTENT_FIELD.cpp_type = 9
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.name = "receiverid"
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.full_name = ".Cmd.GiveWeddingDressCmd.receiverid"
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.number = 8
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.index = 4
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.label = 1
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.has_default_value = false
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.default_value = 0
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.type = 4
GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD.cpp_type = 4
GIVEWEDDINGDRESSCMD.name = "GiveWeddingDressCmd"
GIVEWEDDINGDRESSCMD.full_name = ".Cmd.GiveWeddingDressCmd"
GIVEWEDDINGDRESSCMD.nested_types = {}
GIVEWEDDINGDRESSCMD.enum_types = {}
GIVEWEDDINGDRESSCMD.fields = {
  GIVEWEDDINGDRESSCMD_CMD_FIELD,
  GIVEWEDDINGDRESSCMD_PARAM_FIELD,
  GIVEWEDDINGDRESSCMD_GUID_FIELD,
  GIVEWEDDINGDRESSCMD_CONTENT_FIELD,
  GIVEWEDDINGDRESSCMD_RECEIVERID_FIELD
}
GIVEWEDDINGDRESSCMD.is_extendable = false
GIVEWEDDINGDRESSCMD.extensions = {}
QUICKSTOREITEMCMD_CMD_FIELD.name = "cmd"
QUICKSTOREITEMCMD_CMD_FIELD.full_name = ".Cmd.QuickStoreItemCmd.cmd"
QUICKSTOREITEMCMD_CMD_FIELD.number = 1
QUICKSTOREITEMCMD_CMD_FIELD.index = 0
QUICKSTOREITEMCMD_CMD_FIELD.label = 1
QUICKSTOREITEMCMD_CMD_FIELD.has_default_value = true
QUICKSTOREITEMCMD_CMD_FIELD.default_value = 6
QUICKSTOREITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUICKSTOREITEMCMD_CMD_FIELD.type = 14
QUICKSTOREITEMCMD_CMD_FIELD.cpp_type = 8
QUICKSTOREITEMCMD_PARAM_FIELD.name = "param"
QUICKSTOREITEMCMD_PARAM_FIELD.full_name = ".Cmd.QuickStoreItemCmd.param"
QUICKSTOREITEMCMD_PARAM_FIELD.number = 2
QUICKSTOREITEMCMD_PARAM_FIELD.index = 1
QUICKSTOREITEMCMD_PARAM_FIELD.label = 1
QUICKSTOREITEMCMD_PARAM_FIELD.has_default_value = true
QUICKSTOREITEMCMD_PARAM_FIELD.default_value = 48
QUICKSTOREITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
QUICKSTOREITEMCMD_PARAM_FIELD.type = 14
QUICKSTOREITEMCMD_PARAM_FIELD.cpp_type = 8
QUICKSTOREITEMCMD_ITEMS_FIELD.name = "items"
QUICKSTOREITEMCMD_ITEMS_FIELD.full_name = ".Cmd.QuickStoreItemCmd.items"
QUICKSTOREITEMCMD_ITEMS_FIELD.number = 3
QUICKSTOREITEMCMD_ITEMS_FIELD.index = 2
QUICKSTOREITEMCMD_ITEMS_FIELD.label = 3
QUICKSTOREITEMCMD_ITEMS_FIELD.has_default_value = false
QUICKSTOREITEMCMD_ITEMS_FIELD.default_value = {}
QUICKSTOREITEMCMD_ITEMS_FIELD.message_type = ITEMINFO
QUICKSTOREITEMCMD_ITEMS_FIELD.type = 11
QUICKSTOREITEMCMD_ITEMS_FIELD.cpp_type = 10
QUICKSTOREITEMCMD.name = "QuickStoreItemCmd"
QUICKSTOREITEMCMD.full_name = ".Cmd.QuickStoreItemCmd"
QUICKSTOREITEMCMD.nested_types = {}
QUICKSTOREITEMCMD.enum_types = {}
QUICKSTOREITEMCMD.fields = {
  QUICKSTOREITEMCMD_CMD_FIELD,
  QUICKSTOREITEMCMD_PARAM_FIELD,
  QUICKSTOREITEMCMD_ITEMS_FIELD
}
QUICKSTOREITEMCMD.is_extendable = false
QUICKSTOREITEMCMD.extensions = {}
QUICKSELLITEMCMD_CMD_FIELD.name = "cmd"
QUICKSELLITEMCMD_CMD_FIELD.full_name = ".Cmd.QuickSellItemCmd.cmd"
QUICKSELLITEMCMD_CMD_FIELD.number = 1
QUICKSELLITEMCMD_CMD_FIELD.index = 0
QUICKSELLITEMCMD_CMD_FIELD.label = 1
QUICKSELLITEMCMD_CMD_FIELD.has_default_value = true
QUICKSELLITEMCMD_CMD_FIELD.default_value = 6
QUICKSELLITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUICKSELLITEMCMD_CMD_FIELD.type = 14
QUICKSELLITEMCMD_CMD_FIELD.cpp_type = 8
QUICKSELLITEMCMD_PARAM_FIELD.name = "param"
QUICKSELLITEMCMD_PARAM_FIELD.full_name = ".Cmd.QuickSellItemCmd.param"
QUICKSELLITEMCMD_PARAM_FIELD.number = 2
QUICKSELLITEMCMD_PARAM_FIELD.index = 1
QUICKSELLITEMCMD_PARAM_FIELD.label = 1
QUICKSELLITEMCMD_PARAM_FIELD.has_default_value = true
QUICKSELLITEMCMD_PARAM_FIELD.default_value = 49
QUICKSELLITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
QUICKSELLITEMCMD_PARAM_FIELD.type = 14
QUICKSELLITEMCMD_PARAM_FIELD.cpp_type = 8
QUICKSELLITEMCMD_ITEMS_FIELD.name = "items"
QUICKSELLITEMCMD_ITEMS_FIELD.full_name = ".Cmd.QuickSellItemCmd.items"
QUICKSELLITEMCMD_ITEMS_FIELD.number = 3
QUICKSELLITEMCMD_ITEMS_FIELD.index = 2
QUICKSELLITEMCMD_ITEMS_FIELD.label = 3
QUICKSELLITEMCMD_ITEMS_FIELD.has_default_value = false
QUICKSELLITEMCMD_ITEMS_FIELD.default_value = {}
QUICKSELLITEMCMD_ITEMS_FIELD.message_type = SITEM
QUICKSELLITEMCMD_ITEMS_FIELD.type = 11
QUICKSELLITEMCMD_ITEMS_FIELD.cpp_type = 10
QUICKSELLITEMCMD.name = "QuickSellItemCmd"
QUICKSELLITEMCMD.full_name = ".Cmd.QuickSellItemCmd"
QUICKSELLITEMCMD.nested_types = {}
QUICKSELLITEMCMD.enum_types = {}
QUICKSELLITEMCMD.fields = {
  QUICKSELLITEMCMD_CMD_FIELD,
  QUICKSELLITEMCMD_PARAM_FIELD,
  QUICKSELLITEMCMD_ITEMS_FIELD
}
QUICKSELLITEMCMD.is_extendable = false
QUICKSELLITEMCMD.extensions = {}
ENCHANTTRANSITEMCMD_CMD_FIELD.name = "cmd"
ENCHANTTRANSITEMCMD_CMD_FIELD.full_name = ".Cmd.EnchantTransItemCmd.cmd"
ENCHANTTRANSITEMCMD_CMD_FIELD.number = 1
ENCHANTTRANSITEMCMD_CMD_FIELD.index = 0
ENCHANTTRANSITEMCMD_CMD_FIELD.label = 1
ENCHANTTRANSITEMCMD_CMD_FIELD.has_default_value = true
ENCHANTTRANSITEMCMD_CMD_FIELD.default_value = 6
ENCHANTTRANSITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ENCHANTTRANSITEMCMD_CMD_FIELD.type = 14
ENCHANTTRANSITEMCMD_CMD_FIELD.cpp_type = 8
ENCHANTTRANSITEMCMD_PARAM_FIELD.name = "param"
ENCHANTTRANSITEMCMD_PARAM_FIELD.full_name = ".Cmd.EnchantTransItemCmd.param"
ENCHANTTRANSITEMCMD_PARAM_FIELD.number = 2
ENCHANTTRANSITEMCMD_PARAM_FIELD.index = 1
ENCHANTTRANSITEMCMD_PARAM_FIELD.label = 1
ENCHANTTRANSITEMCMD_PARAM_FIELD.has_default_value = true
ENCHANTTRANSITEMCMD_PARAM_FIELD.default_value = 50
ENCHANTTRANSITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
ENCHANTTRANSITEMCMD_PARAM_FIELD.type = 14
ENCHANTTRANSITEMCMD_PARAM_FIELD.cpp_type = 8
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.name = "from_guid"
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.full_name = ".Cmd.EnchantTransItemCmd.from_guid"
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.number = 3
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.index = 2
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.label = 1
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.has_default_value = false
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.default_value = ""
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.type = 9
ENCHANTTRANSITEMCMD_FROM_GUID_FIELD.cpp_type = 9
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.name = "to_guid"
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.full_name = ".Cmd.EnchantTransItemCmd.to_guid"
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.number = 4
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.index = 3
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.label = 1
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.has_default_value = false
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.default_value = ""
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.type = 9
ENCHANTTRANSITEMCMD_TO_GUID_FIELD.cpp_type = 9
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.name = "success"
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.full_name = ".Cmd.EnchantTransItemCmd.success"
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.number = 5
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.index = 4
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.label = 1
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.has_default_value = true
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.default_value = false
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.type = 8
ENCHANTTRANSITEMCMD_SUCCESS_FIELD.cpp_type = 7
ENCHANTTRANSITEMCMD.name = "EnchantTransItemCmd"
ENCHANTTRANSITEMCMD.full_name = ".Cmd.EnchantTransItemCmd"
ENCHANTTRANSITEMCMD.nested_types = {}
ENCHANTTRANSITEMCMD.enum_types = {}
ENCHANTTRANSITEMCMD.fields = {
  ENCHANTTRANSITEMCMD_CMD_FIELD,
  ENCHANTTRANSITEMCMD_PARAM_FIELD,
  ENCHANTTRANSITEMCMD_FROM_GUID_FIELD,
  ENCHANTTRANSITEMCMD_TO_GUID_FIELD,
  ENCHANTTRANSITEMCMD_SUCCESS_FIELD
}
ENCHANTTRANSITEMCMD.is_extendable = false
ENCHANTTRANSITEMCMD.extensions = {}
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.name = "cmd"
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.full_name = ".Cmd.QueryLotteryHeadItemCmd.cmd"
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.number = 1
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.index = 0
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.label = 1
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.has_default_value = true
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.default_value = 6
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.type = 14
QUERYLOTTERYHEADITEMCMD_CMD_FIELD.cpp_type = 8
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.name = "param"
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.full_name = ".Cmd.QueryLotteryHeadItemCmd.param"
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.number = 2
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.index = 1
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.label = 1
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.has_default_value = true
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.default_value = 51
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.type = 14
QUERYLOTTERYHEADITEMCMD_PARAM_FIELD.cpp_type = 8
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.name = "ids"
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.full_name = ".Cmd.QueryLotteryHeadItemCmd.ids"
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.number = 3
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.index = 2
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.label = 3
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.has_default_value = false
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.default_value = {}
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.type = 13
QUERYLOTTERYHEADITEMCMD_IDS_FIELD.cpp_type = 3
QUERYLOTTERYHEADITEMCMD.name = "QueryLotteryHeadItemCmd"
QUERYLOTTERYHEADITEMCMD.full_name = ".Cmd.QueryLotteryHeadItemCmd"
QUERYLOTTERYHEADITEMCMD.nested_types = {}
QUERYLOTTERYHEADITEMCMD.enum_types = {}
QUERYLOTTERYHEADITEMCMD.fields = {
  QUERYLOTTERYHEADITEMCMD_CMD_FIELD,
  QUERYLOTTERYHEADITEMCMD_PARAM_FIELD,
  QUERYLOTTERYHEADITEMCMD_IDS_FIELD
}
QUERYLOTTERYHEADITEMCMD.is_extendable = false
QUERYLOTTERYHEADITEMCMD.extensions = {}
LOTTERYRATEINFO_TYPE_FIELD.name = "type"
LOTTERYRATEINFO_TYPE_FIELD.full_name = ".Cmd.LotteryRateInfo.type"
LOTTERYRATEINFO_TYPE_FIELD.number = 1
LOTTERYRATEINFO_TYPE_FIELD.index = 0
LOTTERYRATEINFO_TYPE_FIELD.label = 1
LOTTERYRATEINFO_TYPE_FIELD.has_default_value = false
LOTTERYRATEINFO_TYPE_FIELD.default_value = 0
LOTTERYRATEINFO_TYPE_FIELD.type = 13
LOTTERYRATEINFO_TYPE_FIELD.cpp_type = 3
LOTTERYRATEINFO_RATE_FIELD.name = "rate"
LOTTERYRATEINFO_RATE_FIELD.full_name = ".Cmd.LotteryRateInfo.rate"
LOTTERYRATEINFO_RATE_FIELD.number = 2
LOTTERYRATEINFO_RATE_FIELD.index = 1
LOTTERYRATEINFO_RATE_FIELD.label = 1
LOTTERYRATEINFO_RATE_FIELD.has_default_value = false
LOTTERYRATEINFO_RATE_FIELD.default_value = 0
LOTTERYRATEINFO_RATE_FIELD.type = 13
LOTTERYRATEINFO_RATE_FIELD.cpp_type = 3
LOTTERYRATEINFO.name = "LotteryRateInfo"
LOTTERYRATEINFO.full_name = ".Cmd.LotteryRateInfo"
LOTTERYRATEINFO.nested_types = {}
LOTTERYRATEINFO.enum_types = {}
LOTTERYRATEINFO.fields = {
  LOTTERYRATEINFO_TYPE_FIELD,
  LOTTERYRATEINFO_RATE_FIELD
}
LOTTERYRATEINFO.is_extendable = false
LOTTERYRATEINFO.extensions = {}
LOTTERYRATEQUERYCMD_CMD_FIELD.name = "cmd"
LOTTERYRATEQUERYCMD_CMD_FIELD.full_name = ".Cmd.LotteryRateQueryCmd.cmd"
LOTTERYRATEQUERYCMD_CMD_FIELD.number = 1
LOTTERYRATEQUERYCMD_CMD_FIELD.index = 0
LOTTERYRATEQUERYCMD_CMD_FIELD.label = 1
LOTTERYRATEQUERYCMD_CMD_FIELD.has_default_value = true
LOTTERYRATEQUERYCMD_CMD_FIELD.default_value = 6
LOTTERYRATEQUERYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LOTTERYRATEQUERYCMD_CMD_FIELD.type = 14
LOTTERYRATEQUERYCMD_CMD_FIELD.cpp_type = 8
LOTTERYRATEQUERYCMD_PARAM_FIELD.name = "param"
LOTTERYRATEQUERYCMD_PARAM_FIELD.full_name = ".Cmd.LotteryRateQueryCmd.param"
LOTTERYRATEQUERYCMD_PARAM_FIELD.number = 2
LOTTERYRATEQUERYCMD_PARAM_FIELD.index = 1
LOTTERYRATEQUERYCMD_PARAM_FIELD.label = 1
LOTTERYRATEQUERYCMD_PARAM_FIELD.has_default_value = true
LOTTERYRATEQUERYCMD_PARAM_FIELD.default_value = 52
LOTTERYRATEQUERYCMD_PARAM_FIELD.enum_type = ITEMPARAM
LOTTERYRATEQUERYCMD_PARAM_FIELD.type = 14
LOTTERYRATEQUERYCMD_PARAM_FIELD.cpp_type = 8
LOTTERYRATEQUERYCMD_TYPE_FIELD.name = "type"
LOTTERYRATEQUERYCMD_TYPE_FIELD.full_name = ".Cmd.LotteryRateQueryCmd.type"
LOTTERYRATEQUERYCMD_TYPE_FIELD.number = 3
LOTTERYRATEQUERYCMD_TYPE_FIELD.index = 2
LOTTERYRATEQUERYCMD_TYPE_FIELD.label = 1
LOTTERYRATEQUERYCMD_TYPE_FIELD.has_default_value = false
LOTTERYRATEQUERYCMD_TYPE_FIELD.default_value = nil
LOTTERYRATEQUERYCMD_TYPE_FIELD.enum_type = ELOTTERYTYPE
LOTTERYRATEQUERYCMD_TYPE_FIELD.type = 14
LOTTERYRATEQUERYCMD_TYPE_FIELD.cpp_type = 8
LOTTERYRATEQUERYCMD_INFOS_FIELD.name = "infos"
LOTTERYRATEQUERYCMD_INFOS_FIELD.full_name = ".Cmd.LotteryRateQueryCmd.infos"
LOTTERYRATEQUERYCMD_INFOS_FIELD.number = 4
LOTTERYRATEQUERYCMD_INFOS_FIELD.index = 3
LOTTERYRATEQUERYCMD_INFOS_FIELD.label = 3
LOTTERYRATEQUERYCMD_INFOS_FIELD.has_default_value = false
LOTTERYRATEQUERYCMD_INFOS_FIELD.default_value = {}
LOTTERYRATEQUERYCMD_INFOS_FIELD.message_type = LOTTERYRATEINFO
LOTTERYRATEQUERYCMD_INFOS_FIELD.type = 11
LOTTERYRATEQUERYCMD_INFOS_FIELD.cpp_type = 10
LOTTERYRATEQUERYCMD.name = "LotteryRateQueryCmd"
LOTTERYRATEQUERYCMD.full_name = ".Cmd.LotteryRateQueryCmd"
LOTTERYRATEQUERYCMD.nested_types = {}
LOTTERYRATEQUERYCMD.enum_types = {}
LOTTERYRATEQUERYCMD.fields = {
  LOTTERYRATEQUERYCMD_CMD_FIELD,
  LOTTERYRATEQUERYCMD_PARAM_FIELD,
  LOTTERYRATEQUERYCMD_TYPE_FIELD,
  LOTTERYRATEQUERYCMD_INFOS_FIELD
}
LOTTERYRATEQUERYCMD.is_extendable = false
LOTTERYRATEQUERYCMD.extensions = {}
EQUIPCOMPOSEITEMCMD_CMD_FIELD.name = "cmd"
EQUIPCOMPOSEITEMCMD_CMD_FIELD.full_name = ".Cmd.EquipComposeItemCmd.cmd"
EQUIPCOMPOSEITEMCMD_CMD_FIELD.number = 1
EQUIPCOMPOSEITEMCMD_CMD_FIELD.index = 0
EQUIPCOMPOSEITEMCMD_CMD_FIELD.label = 1
EQUIPCOMPOSEITEMCMD_CMD_FIELD.has_default_value = true
EQUIPCOMPOSEITEMCMD_CMD_FIELD.default_value = 6
EQUIPCOMPOSEITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EQUIPCOMPOSEITEMCMD_CMD_FIELD.type = 14
EQUIPCOMPOSEITEMCMD_CMD_FIELD.cpp_type = 8
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.name = "param"
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.full_name = ".Cmd.EquipComposeItemCmd.param"
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.number = 2
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.index = 1
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.label = 1
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.has_default_value = true
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.default_value = 53
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.type = 14
EQUIPCOMPOSEITEMCMD_PARAM_FIELD.cpp_type = 8
EQUIPCOMPOSEITEMCMD_ID_FIELD.name = "id"
EQUIPCOMPOSEITEMCMD_ID_FIELD.full_name = ".Cmd.EquipComposeItemCmd.id"
EQUIPCOMPOSEITEMCMD_ID_FIELD.number = 3
EQUIPCOMPOSEITEMCMD_ID_FIELD.index = 2
EQUIPCOMPOSEITEMCMD_ID_FIELD.label = 1
EQUIPCOMPOSEITEMCMD_ID_FIELD.has_default_value = true
EQUIPCOMPOSEITEMCMD_ID_FIELD.default_value = 0
EQUIPCOMPOSEITEMCMD_ID_FIELD.type = 13
EQUIPCOMPOSEITEMCMD_ID_FIELD.cpp_type = 3
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.name = "materialequips"
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.full_name = ".Cmd.EquipComposeItemCmd.materialequips"
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.number = 4
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.index = 3
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.label = 3
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.has_default_value = false
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.default_value = {}
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.type = 9
EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD.cpp_type = 9
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.name = "retmsg"
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.full_name = ".Cmd.EquipComposeItemCmd.retmsg"
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.number = 5
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.index = 4
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.label = 1
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.has_default_value = true
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.default_value = 0
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.type = 13
EQUIPCOMPOSEITEMCMD_RETMSG_FIELD.cpp_type = 3
EQUIPCOMPOSEITEMCMD.name = "EquipComposeItemCmd"
EQUIPCOMPOSEITEMCMD.full_name = ".Cmd.EquipComposeItemCmd"
EQUIPCOMPOSEITEMCMD.nested_types = {}
EQUIPCOMPOSEITEMCMD.enum_types = {}
EQUIPCOMPOSEITEMCMD.fields = {
  EQUIPCOMPOSEITEMCMD_CMD_FIELD,
  EQUIPCOMPOSEITEMCMD_PARAM_FIELD,
  EQUIPCOMPOSEITEMCMD_ID_FIELD,
  EQUIPCOMPOSEITEMCMD_MATERIALEQUIPS_FIELD,
  EQUIPCOMPOSEITEMCMD_RETMSG_FIELD
}
EQUIPCOMPOSEITEMCMD.is_extendable = false
EQUIPCOMPOSEITEMCMD.extensions = {}
QUERYDEBTITEMCMD_CMD_FIELD.name = "cmd"
QUERYDEBTITEMCMD_CMD_FIELD.full_name = ".Cmd.QueryDebtItemCmd.cmd"
QUERYDEBTITEMCMD_CMD_FIELD.number = 1
QUERYDEBTITEMCMD_CMD_FIELD.index = 0
QUERYDEBTITEMCMD_CMD_FIELD.label = 1
QUERYDEBTITEMCMD_CMD_FIELD.has_default_value = true
QUERYDEBTITEMCMD_CMD_FIELD.default_value = 6
QUERYDEBTITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYDEBTITEMCMD_CMD_FIELD.type = 14
QUERYDEBTITEMCMD_CMD_FIELD.cpp_type = 8
QUERYDEBTITEMCMD_PARAM_FIELD.name = "param"
QUERYDEBTITEMCMD_PARAM_FIELD.full_name = ".Cmd.QueryDebtItemCmd.param"
QUERYDEBTITEMCMD_PARAM_FIELD.number = 2
QUERYDEBTITEMCMD_PARAM_FIELD.index = 1
QUERYDEBTITEMCMD_PARAM_FIELD.label = 1
QUERYDEBTITEMCMD_PARAM_FIELD.has_default_value = true
QUERYDEBTITEMCMD_PARAM_FIELD.default_value = 54
QUERYDEBTITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
QUERYDEBTITEMCMD_PARAM_FIELD.type = 14
QUERYDEBTITEMCMD_PARAM_FIELD.cpp_type = 8
QUERYDEBTITEMCMD_ITEMS_FIELD.name = "items"
QUERYDEBTITEMCMD_ITEMS_FIELD.full_name = ".Cmd.QueryDebtItemCmd.items"
QUERYDEBTITEMCMD_ITEMS_FIELD.number = 3
QUERYDEBTITEMCMD_ITEMS_FIELD.index = 2
QUERYDEBTITEMCMD_ITEMS_FIELD.label = 3
QUERYDEBTITEMCMD_ITEMS_FIELD.has_default_value = false
QUERYDEBTITEMCMD_ITEMS_FIELD.default_value = {}
QUERYDEBTITEMCMD_ITEMS_FIELD.message_type = ITEMDATA
QUERYDEBTITEMCMD_ITEMS_FIELD.type = 11
QUERYDEBTITEMCMD_ITEMS_FIELD.cpp_type = 10
QUERYDEBTITEMCMD.name = "QueryDebtItemCmd"
QUERYDEBTITEMCMD.full_name = ".Cmd.QueryDebtItemCmd"
QUERYDEBTITEMCMD.nested_types = {}
QUERYDEBTITEMCMD.enum_types = {}
QUERYDEBTITEMCMD.fields = {
  QUERYDEBTITEMCMD_CMD_FIELD,
  QUERYDEBTITEMCMD_PARAM_FIELD,
  QUERYDEBTITEMCMD_ITEMS_FIELD
}
QUERYDEBTITEMCMD.is_extendable = false
QUERYDEBTITEMCMD.extensions = {}
LOTTERYACTIVITYINFO_TYPE_FIELD.name = "type"
LOTTERYACTIVITYINFO_TYPE_FIELD.full_name = ".Cmd.LotteryActivityInfo.type"
LOTTERYACTIVITYINFO_TYPE_FIELD.number = 1
LOTTERYACTIVITYINFO_TYPE_FIELD.index = 0
LOTTERYACTIVITYINFO_TYPE_FIELD.label = 1
LOTTERYACTIVITYINFO_TYPE_FIELD.has_default_value = false
LOTTERYACTIVITYINFO_TYPE_FIELD.default_value = 0
LOTTERYACTIVITYINFO_TYPE_FIELD.type = 13
LOTTERYACTIVITYINFO_TYPE_FIELD.cpp_type = 3
LOTTERYACTIVITYINFO_OPEN_FIELD.name = "open"
LOTTERYACTIVITYINFO_OPEN_FIELD.full_name = ".Cmd.LotteryActivityInfo.open"
LOTTERYACTIVITYINFO_OPEN_FIELD.number = 2
LOTTERYACTIVITYINFO_OPEN_FIELD.index = 1
LOTTERYACTIVITYINFO_OPEN_FIELD.label = 1
LOTTERYACTIVITYINFO_OPEN_FIELD.has_default_value = true
LOTTERYACTIVITYINFO_OPEN_FIELD.default_value = true
LOTTERYACTIVITYINFO_OPEN_FIELD.type = 8
LOTTERYACTIVITYINFO_OPEN_FIELD.cpp_type = 7
LOTTERYACTIVITYINFO.name = "LotteryActivityInfo"
LOTTERYACTIVITYINFO.full_name = ".Cmd.LotteryActivityInfo"
LOTTERYACTIVITYINFO.nested_types = {}
LOTTERYACTIVITYINFO.enum_types = {}
LOTTERYACTIVITYINFO.fields = {
  LOTTERYACTIVITYINFO_TYPE_FIELD,
  LOTTERYACTIVITYINFO_OPEN_FIELD
}
LOTTERYACTIVITYINFO.is_extendable = false
LOTTERYACTIVITYINFO.extensions = {}
LOTTERYACTIVITYNTFCMD_CMD_FIELD.name = "cmd"
LOTTERYACTIVITYNTFCMD_CMD_FIELD.full_name = ".Cmd.LotteryActivityNtfCmd.cmd"
LOTTERYACTIVITYNTFCMD_CMD_FIELD.number = 1
LOTTERYACTIVITYNTFCMD_CMD_FIELD.index = 0
LOTTERYACTIVITYNTFCMD_CMD_FIELD.label = 1
LOTTERYACTIVITYNTFCMD_CMD_FIELD.has_default_value = true
LOTTERYACTIVITYNTFCMD_CMD_FIELD.default_value = 6
LOTTERYACTIVITYNTFCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LOTTERYACTIVITYNTFCMD_CMD_FIELD.type = 14
LOTTERYACTIVITYNTFCMD_CMD_FIELD.cpp_type = 8
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.name = "param"
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.full_name = ".Cmd.LotteryActivityNtfCmd.param"
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.number = 2
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.index = 1
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.label = 1
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.has_default_value = true
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.default_value = 57
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.enum_type = ITEMPARAM
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.type = 14
LOTTERYACTIVITYNTFCMD_PARAM_FIELD.cpp_type = 8
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.name = "infos"
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.full_name = ".Cmd.LotteryActivityNtfCmd.infos"
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.number = 3
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.index = 2
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.label = 3
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.has_default_value = false
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.default_value = {}
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.message_type = LOTTERYACTIVITYINFO
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.type = 11
LOTTERYACTIVITYNTFCMD_INFOS_FIELD.cpp_type = 10
LOTTERYACTIVITYNTFCMD.name = "LotteryActivityNtfCmd"
LOTTERYACTIVITYNTFCMD.full_name = ".Cmd.LotteryActivityNtfCmd"
LOTTERYACTIVITYNTFCMD.nested_types = {}
LOTTERYACTIVITYNTFCMD.enum_types = {}
LOTTERYACTIVITYNTFCMD.fields = {
  LOTTERYACTIVITYNTFCMD_CMD_FIELD,
  LOTTERYACTIVITYNTFCMD_PARAM_FIELD,
  LOTTERYACTIVITYNTFCMD_INFOS_FIELD
}
LOTTERYACTIVITYNTFCMD.is_extendable = false
LOTTERYACTIVITYNTFCMD.extensions = {}
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.name = "cmd"
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.full_name = ".Cmd.FavoriteItemActionItemCmd.cmd"
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.number = 1
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.index = 0
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.label = 1
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.has_default_value = true
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.default_value = 6
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.type = 14
FAVORITEITEMACTIONITEMCMD_CMD_FIELD.cpp_type = 8
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.name = "param"
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.full_name = ".Cmd.FavoriteItemActionItemCmd.param"
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.number = 2
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.index = 1
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.label = 1
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.has_default_value = true
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.default_value = 56
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.enum_type = ITEMPARAM
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.type = 14
FAVORITEITEMACTIONITEMCMD_PARAM_FIELD.cpp_type = 8
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.name = "action"
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.full_name = ".Cmd.FavoriteItemActionItemCmd.action"
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.number = 3
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.index = 2
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.label = 1
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.has_default_value = true
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.default_value = 0
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.enum_type = EFAVORITEACTION
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.type = 14
FAVORITEITEMACTIONITEMCMD_ACTION_FIELD.cpp_type = 8
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.name = "guids"
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.full_name = ".Cmd.FavoriteItemActionItemCmd.guids"
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.number = 4
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.index = 3
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.label = 3
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.has_default_value = false
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.default_value = {}
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.type = 9
FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD.cpp_type = 9
FAVORITEITEMACTIONITEMCMD.name = "FavoriteItemActionItemCmd"
FAVORITEITEMACTIONITEMCMD.full_name = ".Cmd.FavoriteItemActionItemCmd"
FAVORITEITEMACTIONITEMCMD.nested_types = {}
FAVORITEITEMACTIONITEMCMD.enum_types = {}
FAVORITEITEMACTIONITEMCMD.fields = {
  FAVORITEITEMACTIONITEMCMD_CMD_FIELD,
  FAVORITEITEMACTIONITEMCMD_PARAM_FIELD,
  FAVORITEITEMACTIONITEMCMD_ACTION_FIELD,
  FAVORITEITEMACTIONITEMCMD_GUIDS_FIELD
}
FAVORITEITEMACTIONITEMCMD.is_extendable = false
FAVORITEITEMACTIONITEMCMD.extensions = {}
AddJobLevelItemCmd = protobuf.Message(ADDJOBLEVELITEMCMD)
BrowsePackage = protobuf.Message(BROWSEPACKAGE)
CardData = protobuf.Message(CARDDATA)
CodeData = protobuf.Message(CODEDATA)
DecomposeResult = protobuf.Message(DECOMPOSERESULT)
EBINDTYPE_BIND = 1
EBINDTYPE_MAX = 3
EBINDTYPE_MIN = 0
EBINDTYPE_NOBIND = 2
ECARDOPER_EQUIPOFF = 2
ECARDOPER_EQUIPON = 1
ECARDOPER_MAX = 3
ECARDOPER_MIN = 0
EDECOMPOSERESULT_FAIL = 1
EDECOMPOSERESULT_MAX = 6
EDECOMPOSERESULT_MIN = 0
EDECOMPOSERESULT_SUCCESS = 2
EDECOMPOSERESULT_SUCCESS_BIG = 3
EDECOMPOSERESULT_SUCCESS_FANTASY = 5
EDECOMPOSERESULT_SUCCESS_SBIG = 4
EENCHANTTYPE_MAX = 4
EENCHANTTYPE_MEDIUM = 2
EENCHANTTYPE_MIN = 0
EENCHANTTYPE_PRIMARY = 1
EENCHANTTYPE_SENIOR = 3
EEQUIPOPER_DRESSUP_OFF = 15
EEQUIPOPER_DRESSUP_ON = 14
EEQUIPOPER_MAX = 16
EEQUIPOPER_MIN = 0
EEQUIPOPER_OFF = 2
EEQUIPOPER_OFFALL = 7
EEQUIPOPER_OFFBARROW = 13
EEQUIPOPER_OFFFASHION = 4
EEQUIPOPER_OFFPOS = 8
EEQUIPOPER_OFFPSTORE = 10
EEQUIPOPER_OFFSTORE = 6
EEQUIPOPER_OFFTEMP = 11
EEQUIPOPER_ON = 1
EEQUIPOPER_PUTBARROW = 12
EEQUIPOPER_PUTFASHION = 3
EEQUIPOPER_PUTPSTORE = 9
EEQUIPOPER_PUTSTORE = 5
EEQUIPPOS_ACCESSORY1 = 5
EEQUIPPOS_ACCESSORY2 = 6
EEQUIPPOS_ARMOUR = 2
EEQUIPPOS_ARTIFACT = 15
EEQUIPPOS_ARTIFACT_BACK = 17
EEQUIPPOS_ARTIFACT_HEAD = 16
EEQUIPPOS_BACK = 11
EEQUIPPOS_BARROW = 14
EEQUIPPOS_FACE = 9
EEQUIPPOS_HEAD = 8
EEQUIPPOS_MAX = 18
EEQUIPPOS_MIN = 0
EEQUIPPOS_MOUNT = 13
EEQUIPPOS_MOUTH = 10
EEQUIPPOS_ROBE = 3
EEQUIPPOS_SHIELD = 1
EEQUIPPOS_SHOES = 4
EEQUIPPOS_TAIL = 12
EEQUIPPOS_WEAPON = 7
EEQUIPTYPE_ACCESSORY = 6
EEQUIPTYPE_ARMOUR = 2
EEQUIPTYPE_ARTIFACT = 21
EEQUIPTYPE_ARTIFACT_BACK = 23
EEQUIPTYPE_ARTIFACT_HEAD = 22
EEQUIPTYPE_BACK = 9
EEQUIPTYPE_BARROW = 14
EEQUIPTYPE_BRACELET = 18
EEQUIPTYPE_EIKON = 17
EEQUIPTYPE_FACE = 10
EEQUIPTYPE_HANDBRACELET = 19
EEQUIPTYPE_HEAD = 8
EEQUIPTYPE_MAX = 24
EEQUIPTYPE_MIN = 0
EEQUIPTYPE_MOUNT = 12
EEQUIPTYPE_MOUTH = 13
EEQUIPTYPE_PEARL = 16
EEQUIPTYPE_ROBE = 4
EEQUIPTYPE_SHIELD = 3
EEQUIPTYPE_SHOES = 5
EEQUIPTYPE_TAIL = 11
EEQUIPTYPE_TROLLEY = 20
EEQUIPTYPE_WEAPON = 1
EEXCHANGECARDTYPE_BOSSCOMPOSE = 4
EEXCHANGECARDTYPE_COMPOSE = 2
EEXCHANGECARDTYPE_DECOMPOSE = 3
EEXCHANGECARDTYPE_DRAW = 1
EEXCHANGETYPE_EXCHANGE = 1
EEXCHANGETYPE_LEVELUP = 2
EEXCHANGETYPE_MAX = 3
EEXCHANGETYPE_MIN = 0
EEXPIRETYPE_MAX = 1
EEXPIRETYPE_MIN = 0
EFAVORITEACTION_ADD = 1
EFAVORITEACTION_DEL = 2
EFAVORITEACTION_MAX = 3
EFAVORITEACTION_MIN = 0
EITEMTYPE_ACCESSORY = 540
EITEMTYPE_ACTIVITY = 66
EITEMTYPE_ARMOUR = 500
EITEMTYPE_ARMOUR_FASHION = 501
EITEMTYPE_ARROW = 43
EITEMTYPE_ARTIFACT_AXE = 456
EITEMTYPE_ARTIFACT_BACK = 488
EITEMTYPE_ARTIFACT_BOOK = 461
EITEMTYPE_ARTIFACT_BOW = 454
EITEMTYPE_ARTIFACT_DAGGER = 457
EITEMTYPE_ARTIFACT_FIST = 458
EITEMTYPE_ARTIFACT_HAMMER = 455
EITEMTYPE_ARTIFACT_HEAD = 485
EITEMTYPE_ARTIFACT_INSTRUMEMT = 459
EITEMTYPE_ARTIFACT_KNIFE = 453
EITEMTYPE_ARTIFACT_LANCE = 450
EITEMTYPE_ARTIFACT_SWORD = 451
EITEMTYPE_ARTIFACT_WAND = 452
EITEMTYPE_ARTIFACT_WHIP = 460
EITEMTYPE_ASSET = 146
EITEMTYPE_BACK = 810
EITEMTYPE_BARROW = 91
EITEMTYPE_BASEEXP = 150
EITEMTYPE_BRACELET = 514
EITEMTYPE_BRACER = 513
EITEMTYPE_CARDPIECE = 110
EITEMTYPE_CARD_ACCESSORY = 86
EITEMTYPE_CARD_ARMOUR = 83
EITEMTYPE_CARD_ASSIST = 82
EITEMTYPE_CARD_HEAD = 87
EITEMTYPE_CARD_ROBE = 84
EITEMTYPE_CARD_SHOES = 85
EITEMTYPE_CARD_WEAPON = 81
EITEMTYPE_CODE = 4000
EITEMTYPE_COLLECTION = 63
EITEMTYPE_CONSUME = 60
EITEMTYPE_CONSUME_2 = 62
EITEMTYPE_CONTRIBUTE = 145
EITEMTYPE_COOKER_EXP = 155
EITEMTYPE_COURAGE = 164
EITEMTYPE_DEADCOIN = 169
EITEMTYPE_DIAMOND = 132
EITEMTYPE_DRAW_CODE = 4201
EITEMTYPE_EGG = 101
EITEMTYPE_EIKON = 512
EITEMTYPE_EQUIPPIECE = 120
EITEMTYPE_EYE_FEMALE = 824
EITEMTYPE_EYE_MALE = 823
EITEMTYPE_FACE = 830
EITEMTYPE_FASHION_PIECE = 121
EITEMTYPE_FOOD = 610
EITEMTYPE_FOOD_FISH = 602
EITEMTYPE_FOOD_FRUIT = 604
EITEMTYPE_FOOD_MEAT = 601
EITEMTYPE_FOOD_SEASONING = 605
EITEMTYPE_FOOD_VEGETABLE = 603
EITEMTYPE_FRAME = 1210
EITEMTYPE_FRIEND = 75
EITEMTYPE_FRIENDSHIP = 147
EITEMTYPE_FUNCTION = 65
EITEMTYPE_GARDEN = 140
EITEMTYPE_GETSKILL = 73
EITEMTYPE_GHOSTLAMP = 45
EITEMTYPE_GOLD = 130
EITEMTYPE_GOLDAPPLE = 72
EITEMTYPE_GUILDHONOR = 156
EITEMTYPE_HAIR = 820
EITEMTYPE_HAIRSTUFF = 61
EITEMTYPE_HAIR_FEMALE = 822
EITEMTYPE_HAIR_MALE = 821
EITEMTYPE_HEAD = 800
EITEMTYPE_HONOR = 10
EITEMTYPE_JOBEXP = 151
EITEMTYPE_KFC_CODE = 4200
EITEMTYPE_LETTER = 71
EITEMTYPE_LOTTERY = 154
EITEMTYPE_MANUALPOINT = 153
EITEMTYPE_MANUALSPOINT = 143
EITEMTYPE_MATERIAL = 70
EITEMTYPE_MAX = 4202
EITEMTYPE_MIN = 0
EITEMTYPE_MONTHCARD = 47
EITEMTYPE_MORA = 144
EITEMTYPE_MOUNT = 90
EITEMTYPE_MOUTH = 850
EITEMTYPE_MULTITIME = 46
EITEMTYPE_PEARL = 511
EITEMTYPE_PET = 100
EITEMTYPE_PET_CONSUME = 103
EITEMTYPE_PET_EQUIP = 102
EITEMTYPE_PET_WEARSHEET = 51
EITEMTYPE_PET_WEARUNLOCK = 52
EITEMTYPE_PICKEFFECT = 74
EITEMTYPE_PICKEFFECT_1 = 76
EITEMTYPE_POLLY_COIN = 157
EITEMTYPE_PORTRAIT = 1200
EITEMTYPE_PURIFY = 152
EITEMTYPE_PVPCOIN = 141
EITEMTYPE_QUESTITEM = 160
EITEMTYPE_QUESTITEMCOUNT = 165
EITEMTYPE_QUEST_ONCE = 48
EITEMTYPE_QUEST_TIME = 49
EITEMTYPE_QUOTA = 149
EITEMTYPE_RANGE = 64
EITEMTYPE_ROBE = 520
EITEMTYPE_SHEET = 50
EITEMTYPE_SHIELD = 510
EITEMTYPE_SHOES = 530
EITEMTYPE_SILVER = 131
EITEMTYPE_STREASURE = 20
EITEMTYPE_STUFF = 40
EITEMTYPE_STUFFNOCUT = 41
EITEMTYPE_TAIL = 840
EITEMTYPE_TOY = 77
EITEMTYPE_TREASURE = 30
EITEMTYPE_TROLLEY = 515
EITEMTYPE_USESKILL = 44
EITEMTYPE_WATER_ELEMENT = 1001
EITEMTYPE_WEAPON_AXE = 230
EITEMTYPE_WEAPON_BOOK = 240
EITEMTYPE_WEAPON_BOW = 210
EITEMTYPE_WEAPON_DAGGER = 250
EITEMTYPE_WEAPON_FIST = 290
EITEMTYPE_WEAPON_HAMMER = 220
EITEMTYPE_WEAPON_INSTRUMEMT = 260
EITEMTYPE_WEAPON_KNIFE = 200
EITEMTYPE_WEAPON_LANCE = 170
EITEMTYPE_WEAPON_SWORD = 180
EITEMTYPE_WEAPON_TUBE = 280
EITEMTYPE_WEAPON_WAND = 190
EITEMTYPE_WEAPON_WHIP = 270
EITEMTYPE_WEDDING_CERT = 166
EITEMTYPE_WEDDING_INVITE = 167
EITEMTYPE_WEDDING_MANUAL = 168
EITEMTYPE_WEDDING_RING = 67
ELETTERTYPE_CHRISTMAS = 3
ELETTERTYPE_CONSTELLATION = 2
ELETTERTYPE_LOTTERY = 5
ELETTERTYPE_LOVE = 1
ELETTERTYPE_SPRING = 4
ELETTERTYPE_WEDDINGDRESS = 6
ELotteryType_Card = 3
ELotteryType_CatLitterBox = 4
ELotteryType_Equip = 2
ELotteryType_Head = 1
ELotteryType_Magic = 5
ELotteryType_Magic_2 = 6
ELotteryType_Max = 7
ELotteryType_Min = 0
EPACKTYPE_BARROW = 9
EPACKTYPE_CARD = 5
EPACKTYPE_EQUIP = 2
EPACKTYPE_FASHION = 3
EPACKTYPE_FASHIONEQUIP = 4
EPACKTYPE_FOOD = 11
EPACKTYPE_MAIN = 1
EPACKTYPE_MAX = 13
EPACKTYPE_MIN = 0
EPACKTYPE_PERSONAL_STORE = 7
EPACKTYPE_PET = 12
EPACKTYPE_QUEST = 10
EPACKTYPE_STORE = 6
EPACKTYPE_TEMP_MAIN = 8
EPRODUCETYPE_EQUIP = 3
EPRODUCETYPE_HEAD = 2
EPRODUCETYPE_MAX = 5
EPRODUCETYPE_MIN = 1
EPRODUCETYPE_TRADER = 4
EQuotaType_C_Auction = 3
EQuotaType_C_Booth = 10
EQuotaType_C_Give = 2
EQuotaType_C_Give_Trade = 13
EQuotaType_C_GuildBox = 6
EQuotaType_C_GuildMaterial = 15
EQuotaType_C_Lottery = 5
EQuotaType_C_WeddingDress = 7
EQuotaType_G_Auction = 4
EQuotaType_G_Charge = 1
EQuotaType_G_Reward = 14
EQuotaType_L_Booth = 8
EQuotaType_L_Charge = 20
EQuotaType_L_Give_Trade = 11
EQuotaType_U_Booth = 9
EQuotaType_U_Charge = 21
EQuotaType_U_Give_Trade = 12
EREFINERESULT_FAILBACK = 3
EREFINERESULT_FAILBACKDAM = 5
EREFINERESULT_FAILSTAY = 2
EREFINERESULT_FAILSTAYDAM = 4
EREFINERESULT_MAX = 6
EREFINERESULT_MIN = 0
EREFINERESULT_SUCCESS = 1
ERIDETYPE_MAX = 3
ERIDETYPE_MIN = 0
ERIDETYPE_OFF = 2
ERIDETYPE_ON = 1
ESTRENGTHRESULT_MAXLV = 3
ESTRENGTHRESULT_MIN = 0
ESTRENGTHRESULT_NOMATERIAL = 2
ESTRENGTHRESULT_SUCCESS = 1
ESTRENGTHTYPE_GUILD = 2
ESTRENGTHTYPE_MAX = 3
ESTRENGTHTYPE_MIN = 0
ESTRENGTHTYPE_NORMAL = 1
ETARGETTYPE_MONSTER = 2
ETARGETTYPE_MY = 0
ETARGETTYPE_USER = 1
ETARGETTYPE_USERANDMONSTER = 3
ETRADETYPE_ALL = 0
ETRADETYPE_BOOTH = 2
ETRADETYPE_TRADE = 1
EggData = protobuf.Message(EGGDATA)
EggEquip = protobuf.Message(EGGEQUIP)
EnchantAttr = protobuf.Message(ENCHANTATTR)
EnchantData = protobuf.Message(ENCHANTDATA)
EnchantEquip = protobuf.Message(ENCHANTEQUIP)
EnchantExtra = protobuf.Message(ENCHANTEXTRA)
EnchantTransItemCmd = protobuf.Message(ENCHANTTRANSITEMCMD)
Equip = protobuf.Message(EQUIP)
EquipCard = protobuf.Message(EQUIPCARD)
EquipComposeItemCmd = protobuf.Message(EQUIPCOMPOSEITEMCMD)
EquipData = protobuf.Message(EQUIPDATA)
EquipDecompose = protobuf.Message(EQUIPDECOMPOSE)
EquipExchangeItemCmd = protobuf.Message(EQUIPEXCHANGEITEMCMD)
EquipPosData = protobuf.Message(EQUIPPOSDATA)
EquipPosDataUpdate = protobuf.Message(EQUIPPOSDATAUPDATE)
EquipRefine = protobuf.Message(EQUIPREFINE)
EquipRepair = protobuf.Message(EQUIPREPAIR)
EquipStrength = protobuf.Message(EQUIPSTRENGTH)
ExchangeCardItemCmd = protobuf.Message(EXCHANGECARDITEMCMD)
FavoriteItemActionItemCmd = protobuf.Message(FAVORITEITEMACTIONITEMCMD)
GetCountItemCmd = protobuf.Message(GETCOUNTITEMCMD)
GiveWeddingDressCmd = protobuf.Message(GIVEWEDDINGDRESSCMD)
HighRefineCmd = protobuf.Message(HIGHREFINECMD)
HighRefineData = protobuf.Message(HIGHREFINEDATA)
HighRefineMatComposeCmd = protobuf.Message(HIGHREFINEMATCOMPOSECMD)
HintNtf = protobuf.Message(HINTNTF)
ITEMPARAM_ADD_JOBLEVEL = 44
ITEMPARAM_BROWSEPACK = 14
ITEMPARAM_DECOMPOSE = 12
ITEMPARAM_ENCHANT = 19
ITEMPARAM_ENCHANT_TRANS = 50
ITEMPARAM_EQUIP = 5
ITEMPARAM_EQUIPCARD = 15
ITEMPARAM_EQUIPCOMPOSE = 53
ITEMPARAM_EQUIPEXCHANGE = 21
ITEMPARAM_EQUIPPOSDATA_UPDATE = 42
ITEMPARAM_EQUIPSTRENGTH = 7
ITEMPARAM_EXCHANGECARD = 28
ITEMPARAM_FAVORITE_ACTION = 56
ITEMPARAM_GETCOUNT = 29
ITEMPARAM_GIVE_WEDDING_DRESS = 47
ITEMPARAM_HIGHREFINE = 37
ITEMPARAM_HIGHREFINE_MATCOMPOSE = 36
ITEMPARAM_HINTNTF = 18
ITEMPARAM_ITEMDATASHOW = 31
ITEMPARAM_ITEMSHOW = 16
ITEMPARAM_ITEMSHOW64 = 35
ITEMPARAM_ITEMUSE = 3
ITEMPARAM_LOTTERY = 32
ITEMPARAM_LOTTERY_ACTIVITY_NTF = 57
ITEMPARAM_LOTTERY_GIVE_BUY_COUNT = 46
ITEMPARAM_LOTTERY_RATE_QUERY = 52
ITEMPARAM_LOTTERY_RECOVERY = 33
ITEMPARAM_NTF_HIGHTREFINE_DATA = 38
ITEMPARAM_ONOFFSTORE = 22
ITEMPARAM_PACKAGEITEM = 1
ITEMPARAM_PACKAGESORT = 4
ITEMPARAM_PACKAGEUPDATE = 2
ITEMPARAM_PACKSLOTNTF = 23
ITEMPARAM_PROCESSENCHANT = 20
ITEMPARAM_PRODUCE = 9
ITEMPARAM_PRODUCEDONE = 10
ITEMPARAM_QUERYDECOMPOSERESULT = 27
ITEMPARAM_QUERYEQUIPDATA = 13
ITEMPARAM_QUERY_ITEMDEBT = 54
ITEMPARAM_QUERY_LOTTERYHEAD = 51
ITEMPARAM_QUERY_LOTTERYINFO = 34
ITEMPARAM_QUICK_SELLITEM = 49
ITEMPARAM_QUICK_STOREITEM = 48
ITEMPARAM_REFINE = 11
ITEMPARAM_REPAIR = 17
ITEMPARAM_REQ_QUOTA_DETAIL = 41
ITEMPARAM_REQ_QUOTA_LOG = 40
ITEMPARAM_RESTOREEQUIP = 24
ITEMPARAM_SAVE_LOVE_LETTER = 30
ITEMPARAM_SELLITEM = 6
ITEMPARAM_UPDATE_HIGHTREFINE_DATA = 39
ITEMPARAM_USECOUNT = 25
ITEMPARAM_USE_CODE_ITEM = 43
ItemData = protobuf.Message(ITEMDATA)
ItemDataShow = protobuf.Message(ITEMDATASHOW)
ItemInfo = protobuf.Message(ITEMINFO)
ItemShow = protobuf.Message(ITEMSHOW)
ItemShow64 = protobuf.Message(ITEMSHOW64)
ItemUse = protobuf.Message(ITEMUSE)
LotterGivBuyCountCmd = protobuf.Message(LOTTERGIVBUYCOUNTCMD)
LotteryActivityInfo = protobuf.Message(LOTTERYACTIVITYINFO)
LotteryActivityNtfCmd = protobuf.Message(LOTTERYACTIVITYNTFCMD)
LotteryCmd = protobuf.Message(LOTTERYCMD)
LotteryInfo = protobuf.Message(LOTTERYINFO)
LotteryRateInfo = protobuf.Message(LOTTERYRATEINFO)
LotteryRateQueryCmd = protobuf.Message(LOTTERYRATEQUERYCMD)
LotteryRecoveryCmd = protobuf.Message(LOTTERYRECOVERYCMD)
LotterySubInfo = protobuf.Message(LOTTERYSUBINFO)
LoveLetterData = protobuf.Message(LOVELETTERDATA)
MatItemInfo = protobuf.Message(MATITEMINFO)
NtfHighRefineDataCmd = protobuf.Message(NTFHIGHREFINEDATACMD)
OnOffStoreItemCmd = protobuf.Message(ONOFFSTOREITEMCMD)
PackSlotNtfItemCmd = protobuf.Message(PACKSLOTNTFITEMCMD)
PackageItem = protobuf.Message(PACKAGEITEM)
PackageSort = protobuf.Message(PACKAGESORT)
PackageUpdate = protobuf.Message(PACKAGEUPDATE)
PetEquipData = protobuf.Message(PETEQUIPDATA)
ProcessEnchantItemCmd = protobuf.Message(PROCESSENCHANTITEMCMD)
Produce = protobuf.Message(PRODUCE)
ProduceDone = protobuf.Message(PRODUCEDONE)
QueryDebtItemCmd = protobuf.Message(QUERYDEBTITEMCMD)
QueryDecomposeResultItemCmd = protobuf.Message(QUERYDECOMPOSERESULTITEMCMD)
QueryEquipData = protobuf.Message(QUERYEQUIPDATA)
QueryLotteryHeadItemCmd = protobuf.Message(QUERYLOTTERYHEADITEMCMD)
QueryLotteryInfo = protobuf.Message(QUERYLOTTERYINFO)
QuickSellItemCmd = protobuf.Message(QUICKSELLITEMCMD)
QuickStoreItemCmd = protobuf.Message(QUICKSTOREITEMCMD)
QuotaDetail = protobuf.Message(QUOTADETAIL)
QuotaLog = protobuf.Message(QUOTALOG)
RefineCompose = protobuf.Message(REFINECOMPOSE)
RefineData = protobuf.Message(REFINEDATA)
ReqQuotaDetailCmd = protobuf.Message(REQQUOTADETAILCMD)
ReqQuotaLogCmd = protobuf.Message(REQQUOTALOGCMD)
RestoreEquipItemCmd = protobuf.Message(RESTOREEQUIPITEMCMD)
SItem = protobuf.Message(SITEM)
SaveLoveLetterCmd = protobuf.Message(SAVELOVELETTERCMD)
SellItem = protobuf.Message(SELLITEM)
SenderData = protobuf.Message(SENDERDATA)
SortInfo = protobuf.Message(SORTINFO)
TradeComposePair = protobuf.Message(TRADECOMPOSEPAIR)
TradeItemBaseInfo = protobuf.Message(TRADEITEMBASEINFO)
TradeRefineData = protobuf.Message(TRADEREFINEDATA)
UpdateHighRefineDataCmd = protobuf.Message(UPDATEHIGHREFINEDATACMD)
UseCodItemCmd = protobuf.Message(USECODITEMCMD)
UseCountItemCmd = protobuf.Message(USECOUNTITEMCMD)
WeddingData = protobuf.Message(WEDDINGDATA)
