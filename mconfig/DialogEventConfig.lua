--[EquipName]:升级/置换之前的装备    
--[ReplaceProduceName]：置换之后的装备
--[EquipSite]:装备部位     
--[ReplaceMaterials]：材料的名字*材料数量，以及银币
--[UpgradeMaterials]:装备升级所需材料
--[UpgradeProduceName]:升级之后的装备

--[UpJobLvMaterialsData]:提升巅峰等级的数量*材料名称
--[UpJobLvNumber]:提升巅峰等级值

DialogEventType = {
	-- 装备置换
	EquipReplace = "EquipReplace",
	-- 装备升级
	EquipUpgrade = "EquipUpgrade",
}

EventDialog = {
	[1] = {DialogText = "你好冒险者，我是%s部位打洞的专家，想试试吗？所谓的装备打洞就是让装备多出一个卡槽，可以让你变得更加强力！"},
	[2] = {DialogText = "可是你该部位没有穿戴装备，无法提供服务", Option = { 7 }},

	[3] = {DialogText = "冒险者，根据我所学的配方，我可以帮你升级一部分特定的装备，现在请你选择需要升级的装备吧！"},
	[4] = {DialogText = "我们乌加特家族在王国内可是数一数二的大家族呢！"},
	
	
	[51] = {DialogText = "将【[EquipName]】打洞成【[ReplaceProduceName]】时，需要消耗：[ReplaceMaterials]", Option = { 3,7 }},
	[52] = {DialogText = "该装备的卡槽数已达上限，无法进行打洞", Option = { 7 }},
	[53] = {DialogText = "打洞后卡片、附魔、强化、精炼、缝纫加固等级全部继承，继续吗？", Option = { 4,7 }},
	[54] = {DialogText = "恭喜你获得【[ReplaceProduceName]】"},
	[55] = {DialogText = "材料不足\n注意事项：如果所需材料中，需要装备，那么精炼＋6及以上和已打过洞的装备无法成为材料", Option = { 7 }},
	
     --以下是装备升级
	[60] = {DialogText = "可是你该部位没有穿戴装备，无法提供服务", Option = { 8 }},

	[61] = {DialogText = "【[EquipName]】升级为【[UpgradeProduceName]】需要以下材料：[UpgradeMaterials]", Option = { 5,8 } ,ShowEvent = "ShowUpgradeItem"},
	[62] = {DialogText = "你身上的【[EquipName]】不能升级，拿其他装备来我这里尝试下。", Option = { 8 } },
	[63] = {DialogText = "现在为你升级，请不用担心，升级后卡片、附魔、强化、缝纫加固都会继承哦~\n注意事项：当升级完最终回End档后，你的装备会升级成新的装备，所以精炼会下降2级，若新的装备没有卡槽，卡片会卸下并返还至包包中，请注意！", Option = { 6,8 }},
	[64] = {DialogText = "我已为你打造成功，这是升级后的【[UpgradeProduceName]】，欢迎再次选择我们乌加特家族",},
	[65] = {DialogText = "材料不足\n注意事项：如果所需材料中，需要装备，那么精炼＋6及以上和已打过洞的装备无法成为材料", Option = { 8 }},
	[66] = {DialogText = "职业等级不符合", Option = { 8 }},
	
	
	[80] = {DialogText = "必须完成职业等级突破上限任务后才能提升Job上限等级。"},
	[81] = {DialogText = "收集[UpJobLvMaterialsData]给我，我可以为你提升[UpJobLvNumber]级职业等级上限。", Option = { 10 }},
	[82] = {DialogText = "材料不足，请收集[UpJobLvMaterialsData]后再来找我吧。"},
	[83] = {DialogText = "材料已经收集齐全了，现在请闭上眼睛吧。", Option = { 11 }},
	[84] = {DialogText = "你的职业等级上限已经提升了[UpJobLvNumber]级。"},
	[85] = {DialogText = "当前已经无法再提升你的职业等级上限了。"},
	
}

--CanReplace：是否打洞
--CanUpgrade：是否升级
--Replace_MaterialEnough：打洞的材料是否足够
--DoReplace：进行打洞
--DoUpgrade：进行升级
--CanUpJobLv：是否可以进行巅峰升级
--DoUpJobLv：可以进行巅峰升级

EventDialogOption = {
	[3] = {Name = "继续", FuncType = "Replace_MaterialEnough", Result1 = { NextDialog = 53 }, Result2 = { NextDialog = 55}},
	[4] = {Name = "进行打洞", FuncType = "DoReplace", Result1 = { NextDialog = 54 } },
	 --以下是装备升级
	[5] = {Name = "下一步", FuncType = "Upgrade_MaterialEnough", Result1 = { NextDialog = 63 }, Result2 = { NextDialog = 65}, Result3 = { NextDialog = 66}},
	[6] = {Name = "进行升级", FuncType = "DoUpgrade", Result1 = { NextDialog = 64 } },
	[7] = {Name = "返回", Result1 = { DialogEventType = "EquipReplace" }, },

	[8] = {Name = "返回", Result1 = { DialogEventType = "EquipUpgrade" }},
	
	[10] = {Name = "下一步", FuncType = "CanUpJobLv", Result1 = { NextDialog = 83 }, Result2 = { NextDialog = 82 },Result3 = { NextDialog = 85 }}, 
	[11] = {Name = "下一步", FuncType = "DoUpJobLv", Result1 = { NextDialog = 84 }}, 
}

DialogParamType = 
{
	StoragePrice = "Dialog_ParamType_StoragePrice",
}

-- 仓库免费
Dialog_ReplaceParam = 
{
	[2015] = { DialogParamType.StoragePrice, },
	[3849] = { DialogParamType.StoragePrice, },
	[3957] = { DialogParamType.StoragePrice, },
	[7046] = { DialogParamType.StoragePrice, },
	[7047] = { DialogParamType.StoragePrice, },
	[93004] = { DialogParamType.StoragePrice, },
	[131487] = { DialogParamType.StoragePrice, },
	[8819] = { DialogParamType.StoragePrice, },
	[8820] = { DialogParamType.StoragePrice, },
	[8821] = { DialogParamType.StoragePrice, },
	[8824] = { DialogParamType.StoragePrice, },
	[8825] = { DialogParamType.StoragePrice, },
	[8827] = { DialogParamType.StoragePrice, },
	[8828] = { DialogParamType.StoragePrice, },
	[8830] = { DialogParamType.StoragePrice, },
	[8831] = { DialogParamType.StoragePrice, },
	[8833] = { DialogParamType.StoragePrice, },
	[8834] = { DialogParamType.StoragePrice, },
	[81733] = { DialogParamType.StoragePrice, },
	[84227] = { DialogParamType.StoragePrice, },
	[84229] = { DialogParamType.StoragePrice, },
	[84232] = { DialogParamType.StoragePrice, },
	[88775] = { DialogParamType.StoragePrice, },
	[51252] = { DialogParamType.StoragePrice, },
	[51253] = { DialogParamType.StoragePrice, },
	[101872] = { DialogParamType.StoragePrice, },
	[101873] = { DialogParamType.StoragePrice, },
	[101875] = { DialogParamType.StoragePrice, },
	[101876] = { DialogParamType.StoragePrice, },
	[101878] = { DialogParamType.StoragePrice, },
	[101879] = { DialogParamType.StoragePrice, },
}








