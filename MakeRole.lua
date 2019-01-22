--[[
????????????????????????
]]

--??????????????????
classList = {
	
    [11] = {classID=11, name="??????", str=9, int=6, vit=8, agi=3, dex=5, luk=2, body=3, femaleBody=4, weapon=40021},
	[21] = {classID=21, name="?????????", str=9, int=6, vit=8, agi=3, dex=5, luk=2, body=11, femaleBody=12, weapon=40611},
    [31] = {classID=31, name="??????", str=9, int=6, vit=8, agi=3, dex=5, luk=2, body=19, femaleBody=20, weapon=40301},
    [41] = {classID=41, name="?????????", str=9, int=6, vit=8, agi=3, dex=5, luk=2, body=27, femaleBody=28, weapon=41223},
	[51] = {classID=51, name="??????", str=1, int=9, vit=2, agi=3, dex=5, luk=2, body=35, femaleBody=36, weapon=41508},
    [61] = {classID=61, name="??????", str=6, int=3, vit=6, agi=2, dex=5, luk=2, body=43, femaleBody=44, weapon=41807},
}

--???????????????()
maleHairList = {2,3,6,8}
--???????????????
femaleHairList = {9,11,12,14,15,16,17}

--???????????????6?????????
nameLeng = 12

--[[
for i=1, #classList do
	output = "["..i.."] = ".."{"
	for key,value in pairs(classList[i]) do
		output = output..key.."="..value..", "
	end
	output = output.."}"
	print(output)
end
]]

-- refactory begin
CharacterGender = {
	Male={
		hairList={2,3,6,8}
	},
	Female={
		hairList={15,11,12,14}
	}
}
CharacterPreview = {
	hairColorList = {1,2,3,4},
	accessories = {45004,45045,45072}
}
CharacterSelectList = {
	[1] = {gender=CharacterGender.Female, maleID=1172, femaleID=1166, petID=1181, classID=42, name="??????", ename="Hunter", str=3, int=5, vit=4, agi=8, dex=9, luk=5},
	[2] = {gender=CharacterGender.Female, maleID=1173, femaleID=1167, petID=1263, classID=52, name="??????", ename="Priest", str=2, int=8, vit=6, agi=4, dex=4, luk=6},
	[3] = {gender=CharacterGender.Male, maleID=1168, femaleID=1174, classID=62, name="??????", ename="Blacksmith",str=9, int=3, vit=6, agi=4, dex=7, luk=5},
	[4] = {gender=CharacterGender.Female, maleID=1175, femaleID=1169, classID=22, name="??????", ename="Wizard", str=1, int=9, vit=3, agi=3, dex=8, luk=4},
	[5] = {gender=CharacterGender.Male, maleID=1170, femaleID=1176, classID=12, name="??????", ename="Knight", str=9, int=1, vit=8, agi=3, dex=5, luk=2},
	[6] = {gender=CharacterGender.Male, maleID=1171, femaleID=1177, petID=1264, classID=32, name="??????", ename="Assassin", str=4, int=4, vit=5, agi=9, dex=6, luk=8},
}
-- refactory end