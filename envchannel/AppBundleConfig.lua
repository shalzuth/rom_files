AppBundleConfig = {}

-- 获取bundleID :例如com.xd.ro
if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V8) then
	AppBundleConfig.BundleID = GetAppBundleVersion.BundleVersion
end

AppBundleConfig.IOSAppUrl = "https://itunes.apple.com/cn/app/xian-jing-chuan-shuoro/id1071801856?l=zh&ls=1&mt=8"
AppBundleConfig.AndroidAppUrl = "https://www.taptap.com/app/7133"

AppBundleConfig.iosApp_ID = "1071801856"
AppBundleConfig.IOSAppReviewUrl = string.format ("http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%s&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",
										AppBundleConfig.iosApp_ID)
AppBundleConfig.AndroidAppReviewUrl = "https://www.taptap.com/app/7133/review"

-- iOS
-- com.xd.ro : release
-- com.pinidea.ent.generalofgods : trunk
-- com.xd.ro1 : tf
-- com.xd.ro2 : tf
-- com.xd.ro3 : tf
-- com.xd.ro4 : tf
-- android
-- com.xd.ro.xdapk : not release
-- com.xd.ro.roapk : release

local XDSDK_Config = {
	["com.xd.ro"] = {APP_ID="2isp77irl1c0gc4",APP_SECRET="4be2a070553dab1665fc6e91ea71714f",PRIVATE_SECRET="",ORIENTATION=0},
	["com.pinidea.ent.generalofgods"] = {APP_ID="cf1j5axm7hckw48",APP_SECRET="28450c8d55956f53d775eef31047870b",PRIVATE_SECRET="",ORIENTATION=0},
	["com.xd.ro1"] = {APP_ID="4qnxjf4p9zi8k4o",APP_SECRET="ceeac4b5dec00d8c1022516e416d598e",PRIVATE_SECRET="",ORIENTATION=0},
	["com.xd.ro2"] = {APP_ID="93ff4crh0pogg80",APP_SECRET="381411b2ed82fe9776f92e0fa0bdc534",PRIVATE_SECRET="",ORIENTATION=0},
	["com.xd.ro3"] = {APP_ID="6f7sft2ht3c4g80",APP_SECRET="3935ce1c396a8015aed23ead8a331eb1",PRIVATE_SECRET="",ORIENTATION=0},
	["com.xd.ro4"] = {APP_ID="1wmiwtf3ckg08k4",APP_SECRET="1bcb805a2d6f7bfd06eca20ea88f13fa",PRIVATE_SECRET="",ORIENTATION=0},
	["com.xd.ro.xdapk"] = {APP_ID="8ptdnizk5ukg4c0",ORIENTATION=0},
	["com.xd.ro.apk"] = {APP_ID="8ptdnizk5ukg4c0",ORIENTATION=0},
	["com.xd.ro.roapk"] = {APP_ID="9hshhxi7c4wso8o",ORIENTATION=0}
}

local TyrantdbAppInfo_Config = {
	["com.xd.ro"] = {APP_ID="s8nltyei9wt4ckxv"},
	["com.pinidea.ent.generalofgods"] = {APP_ID="mstl7ve57kljoncq"},
	["com.xd.ro1"] = {APP_ID="mstl7ve57kljoncq"},
	["com.xd.ro2"] = {APP_ID="mstl7ve57kljoncq"},
	["com.xd.ro3"] = {APP_ID="mstl7ve57kljoncq"},
	["com.xd.ro4"] = {APP_ID="mstl7ve57kljoncq"},
	["com.xd.ro.xdapk"] = {APP_ID="mstl7ve57kljoncq"},
	["com.xd.ro.apk"] = {APP_ID="s8nltyei9wt4ckxv"},
	["com.xd.ro.roapk"] = {APP_ID="s8nltyei9wt4ckxv"},
	["com.ro.test"] = {APP_ID="mstl7ve57kljoncq"},
	["com.gravity.ro.ios"] = {APP_ID="xr9fvy9ksgwuu3zw"},
	["com.gravity.ro.and"] = {APP_ID="xr9fvy9ksgwuu3zw"},
	["com.gravity.rom.aos"] = {APP_ID="ibjy57amp9pq8ah0"},
	["com.gravity.rom.ios"] = {APP_ID="ibjy57amp9pq8ah0"},
	["com.gravity.rom.ones"] = {APP_ID="ibjy57amp9pq8ah0"},
	["com.gravity.romi"] = {APP_ID="r7squgwt8rcjnf21"},
	["com.gravity.romg"] = {APP_ID="r7squgwt8rcjnf21"},
	["com.gravity.romi.zhb"] = {APP_ID="r7squgwt8rcjnf21"},
	["com.gravity.romg.zhb"] = {APP_ID="r7squgwt8rcjnf21"},
	["com.gravity.romg.cbt"] = {APP_ID="r7squgwt8rcjnf21"},
	["com.gravity.romg.gw"] = {APP_ID="r7squgwt8rcjnf21"},
}

-- unused
local ANDROID_ANYSDK_Config = {
	["com.xd.ro.xdapk"] = {APP_KEY="60F4926A-CB37-BBF5-1079-3E18B1082257", APP_SECRET = "a8c0e0641798fbda1cbd69733008d93a", PRIVATE_KEY = "FB029C15F0AACD225BA99B1816C7AAD4", OAUTH_LOGIN_SERVER = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php"},
	["com.xd.ro.apk"] = {APP_KEY="60F4926A-CB37-BBF5-1079-3E18B1082257", APP_SECRET = "a8c0e0641798fbda1cbd69733008d93a", PRIVATE_KEY = "FB029C15F0AACD225BA99B1816C7AAD4", OAUTH_LOGIN_SERVER = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php"},
	["com.xd.ro.roapk"] = {APP_KEY="60F4926A-CB37-BBF5-1079-3E18B1082257", APP_SECRET = "a8c0e0641798fbda1cbd69733008d93a", PRIVATE_KEY = "FB029C15F0AACD225BA99B1816C7AAD4", OAUTH_LOGIN_SERVER = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php"},
}

local SocialShare_Config = {
	["com.xd.ro"] = {SINA_WEIBO_APP_KEY="650343694", SINA_WEIBO_APP_SECRET="5bd99ffa23bd05cbb649ea540963ab86", QQ_APP_ID="1105442815", QQ_APP_KEY="2b723a9b2c445b174b5bc60e6f7234cb", WECHAT_APP_ID="wx9fdd68bd6b3c85a2", WECHAT_APP_SECRET="b3558e97106af65d2326d43fcfd606aa"},
	["com.pinidea.ent.generalofgods"] = nil,
	["com.xd.ro1"] = nil,
	["com.xd.ro2"] = nil,
	["com.xd.ro3"] = nil,
	["com.xd.ro4"] = nil,
	["com.xd.ro.xdapk"] = nil,
	["com.xd.ro.apk"] = nil,
	["com.xd.ro.roapk"] = {SINA_WEIBO_APP_KEY="650343694", SINA_WEIBO_APP_SECRET="5bd99ffa23bd05cbb649ea540963ab86", QQ_APP_ID="1105442815", QQ_APP_KEY="2b723a9b2c445b174b5bc60e6f7234cb", WECHAT_APP_ID="wx9fdd68bd6b3c85a2", WECHAT_APP_SECRET="b3558e97106af65d2326d43fcfd606aa"},
	["com.gravity.ro.ios"] = {},
	["com.gravity.ro.and"] = {},
	["com.gravity.rom.aos"] = {},
	["com.gravity.rom.ios"] = {},
	["com.gravity.rom.ones"] = nil,
	["com.gravity.romi"] = {},
	["com.gravity.romg"] = {},
	["com.gravity.romi.zhb"] = {},
	["com.gravity.romg.zhb"] = {},
	["com.gravity.romg.cbt"] = {},
	["com.gravity.romg.gw"] = {},
}

local IOS_TXWYSDK_Config = {
	["com.gravity.rom.ios"] = {
		APP_ID="159613",
		APP_KEY="0cb62c7b584957d6b89a324ec7f74364",
		FUID="kr_ro_ios",
		LANG="kr"
	},
	["com.msm.rom.ios"] = {
		APP_ID="159613",
		APP_KEY="0cb62c7b584957d6b89a324ec7f74364",
		FUID="kr_ro_ios",
		LANG="kr"
	},
	["com.gravity.romi"] = {
		APP_ID="160313",
		APP_KEY="90bfa15510a2ee69f9e33db3466baf2c",
		FUID="ios_ro",
		LANG="en"
	},
	["com.gravity.romi.zhb"] = {
		APP_ID="160313",
		APP_KEY="90bfa15510a2ee69f9e33db3466baf2c",
		FUID="ios_ro",
		LANG="en"
	},
}

local ANDROID_TXWYSDK_Config = {
	["com.gravity.rom.aos"] = {
		APP_ID="159614",
		APP_KEY="0cb62c7b584957d6b89a324ec7f74364",
		FUID="kr_ro_gp",
		LANG="kr"
	},
	["com.gravity.romg"] = {
		APP_ID="160314",
		APP_KEY="90bfa15510a2ee69f9e33db3466baf2c",
		FUID="android_ro",
		LANG="kr"
	},
	["com.gravity.romg.zhb"] = {
		APP_ID="160314",
		APP_KEY="90bfa15510a2ee69f9e33db3466baf2c",
		FUID="android_ro",
		LANG="kr"
	},
	["com.gravity.romg.cbt"] = {
		APP_ID="160314",
		APP_KEY="90bfa15510a2ee69f9e33db3466baf2c",
		FUID="android_ro",
		LANG="kr"
	},
	["com.gravity.romg.gw"] = {
		APP_ID="160314",
		APP_KEY="90bfa15510a2ee69f9e33db3466baf2c",
		FUID="android_ro",
		LANG="kr"
	}
}

function AppBundleConfig.GetXDSDKInfo()
	return XDSDK_Config[AppBundleConfig.BundleID]
end

function AppBundleConfig.GetTyrantdbInfo()
	return TyrantdbAppInfo_Config[AppBundleConfig.BundleID]
end

-- unused
function AppBundleConfig.GetANYSDKInfo()
	return ANDROID_ANYSDK_Config[AppBundleConfig.BundleID]
end

function AppBundleConfig.GetSocialShareInfo()
	return SocialShare_Config[AppBundleConfig.BundleID]
end

--应用商店
function AppBundleConfig.JumpToAppStore()
	AppBundleConfig.JumpToIOSAppStore()
	AppBundleConfig.JumpToAndroidAppStore()
end

function AppBundleConfig.JumpToIOSAppStore()
	if(ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer) then
		Application.OpenURL(AppBundleConfig.IOSAppUrl)
	end
end

function AppBundleConfig.JumpToAndroidAppStore()
	if(ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android) then
		Application.OpenURL(AppBundleConfig.AndroidAppUrl)
	end
end
--应用商店

--应用商店评论
function AppBundleConfig.JumpToAppReview()
	AppBundleConfig.JumpToIOSAppReview()
	AppBundleConfig.JumpToAndroidAppReview()
end

function AppBundleConfig.JumpToIOSAppReview()
	if(ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer) then
		if(BackwardCompatibilityUtil.CompatibilityMode_V13) then
			Application.OpenURL(AppBundleConfig.IOSAppReviewUrl)
		else
			ExternalInterfaces.RateReviewApp(AppBundleConfig.iosApp_ID)
		end
	end
end

function AppBundleConfig.JumpToAndroidAppReview()
	if(ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android) then
		Application.OpenURL(AppBundleConfig.AndroidAppReviewUrl)
	end
end
--应用商店评论

function AppBundleConfig.GetTXWYSDKInfo()
	Debug.LogFormat("get bundle id :{0}",AppBundleConfig.BundleID)
	Debug.LogFormat("get version :{0}",GetAppBundleVersion.BundleVersion)
	local info  = IOS_TXWYSDK_Config[AppBundleConfig.BundleID]
	local runtimePlatform = ApplicationInfo.GetRunPlatform()
	if(runtimePlatform == RuntimePlatform.Android) then
		Debug.Log("android!!!!!")
		info  = ANDROID_TXWYSDK_Config[AppBundleConfig.BundleID]
	end
	return info
end

local langConf = {
	["English"] = "en",
	["Indonesian"] = "id",
	["Japanese"] = "jp",
	["Portuguese"] = "pt",
	["Russian"] = "ru",
	["Spanish"] = "es",
	["Thai"] = "th",
	["Vietnamese"] = "vi",
	["ChineseSimplified"] = "cn",
	["ChineseTraditional"] = "tw"
}

--todo xde sdk lang
function AppBundleConfig.GetSDKLang()
	local curLang =  OverSea.LangManager.Instance().CurSysLang
	if langConf[curLang] ~= nil then
		return langConf[curLang]
	end
	return 'en'
end