AppBundleConfig = {}
if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V8) then
  AppBundleConfig.BundleID = GetAppBundleVersion.BundleVersion
end
AppBundleConfig.IOSAppUrl = "https://itunes.apple.com/cn/app/xian-jing-chuan-shuoro/id1071801856?l=zh&ls=1&mt=8"
AppBundleConfig.AndroidAppUrl = "https://www.taptap.com/app/7133"
AppBundleConfig.iosApp_ID = "1071801856"
AppBundleConfig.IOSAppReviewUrl = string.format("http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1071801856&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", AppBundleConfig.iosApp_ID)
AppBundleConfig.AndroidAppReviewUrl = "https://www.taptap.com/app/7133/review"
local XDSDK_Config = {
  ["com.xd.ro"] = {
    APP_ID = "2isp77irl1c0gc4",
    APP_SECRET = "4be2a070553dab1665fc6e91ea71714f",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.pinidea.ent.generalofgods"] = {
    APP_ID = "cf1j5axm7hckw48",
    APP_SECRET = "28450c8d55956f53d775eef31047870b",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro1"] = {
    APP_ID = "4qnxjf4p9zi8k4o",
    APP_SECRET = "ceeac4b5dec00d8c1022516e416d598e",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro2"] = {
    APP_ID = "93ff4crh0pogg80",
    APP_SECRET = "381411b2ed82fe9776f92e0fa0bdc534",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro3"] = {
    APP_ID = "6f7sft2ht3c4g80",
    APP_SECRET = "3935ce1c396a8015aed23ead8a331eb1",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro4"] = {
    APP_ID = "1wmiwtf3ckg08k4",
    APP_SECRET = "1bcb805a2d6f7bfd06eca20ea88f13fa",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro.xdapk"] = {
    APP_ID = "8ptdnizk5ukg4c0",
    ORIENTATION = 0
  },
  ["com.xd.ro.apk"] = {
    APP_ID = "8ptdnizk5ukg4c0",
    ORIENTATION = 0
  },
  ["com.xd.ro.roapk"] = {
    APP_ID = "9hshhxi7c4wso8o",
    ORIENTATION = 0
  },
  ["com.xd.windows.rotf"] = {
    APP_ID = "70lp3618xyscokw",
    APP_SECRET = "300776c0d272982e8bf19a3fd0509dcf",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.windows.rorelease"] = {
    APP_ID = "a2ofxipzmcgggs0",
    APP_SECRET = "8e71e7610fd49af21592f8008312c193",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  }
}
local TyrantdbAppInfo_Config = {
  ["com.xd.ro"] = {
    APP_ID = "s8nltyei9wt4ckxv"
  },
  ["com.pinidea.ent.generalofgods"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.xd.ro1"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.xd.ro2"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.xd.ro3"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.xd.ro4"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.xd.ro.xdapk"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.xd.ro.apk"] = {
    APP_ID = "s8nltyei9wt4ckxv"
  },
  ["com.xd.ro.roapk"] = {
    APP_ID = "s8nltyei9wt4ckxv"
  },
  ["com.ro.test"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.xd.windows.rotf"] = {
    APP_ID = "s8nltyei9wt4ckxv"
  },
  ["com.xd.windows.rorelease"] = {
    APP_ID = "s8nltyei9wt4ckxv"
  },
  ["com.xd.windows.rotf"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.xd.windows.rorelease"] = {
    APP_ID = "mstl7ve57kljoncq"
  },
  ["com.gravity.ro.ios"] = {
    APP_ID = "xr9fvy9ksgwuu3zw"
  },
  ["com.gravity.ro.and"] = {
    APP_ID = "xr9fvy9ksgwuu3zw"
  },
  ["com.gravity.rom.aos"] = {
    APP_ID = "ibjy57amp9pq8ah0"
  },
  ["com.gravity.rom.ios"] = {
    APP_ID = "ibjy57amp9pq8ah0"
  },
  ["com.gravity.rom.ones"] = {
    APP_ID = "ibjy57amp9pq8ah0"
  },
  ["jp.gungho.ragnarokm"] = {
    APP_ID = "fjpn0cm9lg3za2m6"
  },
  ["jp.gungho.ragnarokm.cbt"] = {
    APP_ID = "fjpn0cm9lg3za2m6"
  },
  ["jptest.xdg.ios.ro"] = {
    APP_ID = "fjpn0cm9lg3za2m6"
  }
}
local ANDROID_ANYSDK_Config = {
  ["com.xd.ro.xdapk"] = {
    APP_KEY = "60F4926A-CB37-BBF5-1079-3E18B1082257",
    APP_SECRET = "a8c0e0641798fbda1cbd69733008d93a",
    PRIVATE_KEY = "FB029C15F0AACD225BA99B1816C7AAD4",
    OAUTH_LOGIN_SERVER = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php"
  },
  ["com.xd.ro.apk"] = {
    APP_KEY = "60F4926A-CB37-BBF5-1079-3E18B1082257",
    APP_SECRET = "a8c0e0641798fbda1cbd69733008d93a",
    PRIVATE_KEY = "FB029C15F0AACD225BA99B1816C7AAD4",
    OAUTH_LOGIN_SERVER = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php"
  },
  ["com.xd.ro.roapk"] = {
    APP_KEY = "60F4926A-CB37-BBF5-1079-3E18B1082257",
    APP_SECRET = "a8c0e0641798fbda1cbd69733008d93a",
    PRIVATE_KEY = "FB029C15F0AACD225BA99B1816C7AAD4",
    OAUTH_LOGIN_SERVER = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php"
  }
}
local SocialShare_Config = {
  ["com.xd.ro"] = {
    SINA_WEIBO_APP_KEY = "650343694",
    SINA_WEIBO_APP_SECRET = "5bd99ffa23bd05cbb649ea540963ab86",
    QQ_APP_ID = "1105442815",
    QQ_APP_KEY = "2b723a9b2c445b174b5bc60e6f7234cb",
    WECHAT_APP_ID = "wx9fdd68bd6b3c85a2",
    WECHAT_APP_SECRET = "b3558e97106af65d2326d43fcfd606aa"
  },
  ["com.pinidea.ent.generalofgods"] = nil,
  ["com.xd.ro1"] = nil,
  ["com.xd.ro2"] = nil,
  ["com.xd.ro3"] = nil,
  ["com.xd.ro4"] = nil,
  ["com.xd.ro.xdapk"] = nil,
  ["com.xd.ro.apk"] = nil,
  ["com.xd.ro.roapk"] = {
    SINA_WEIBO_APP_KEY = "650343694",
    SINA_WEIBO_APP_SECRET = "5bd99ffa23bd05cbb649ea540963ab86",
    QQ_APP_ID = "1105442815",
    QQ_APP_KEY = "2b723a9b2c445b174b5bc60e6f7234cb",
    WECHAT_APP_ID = "wx9fdd68bd6b3c85a2",
    WECHAT_APP_SECRET = "b3558e97106af65d2326d43fcfd606aa"
  },
  ["com.gravity.ro.ios"] = {},
  ["com.gravity.ro.and"] = {},
  ["com.gravity.rom.aos"] = {},
  ["com.gravity.rom.ios"] = {},
  ["com.gravity.rom.ones"] = nil,
  ["jp.gungho.ragnarokm"] = {},
  ["jp.gungho.ragnarokm.cbt"] = {},
  ["jptest.xdg.ios.ro"] = {}
}
local IOS_TXWYSDK_Config = {
  ["jp.gungho.ragnarokm"] = {
    APP_ID = "162813",
    APP_KEY = "6abe7455ece8a3a902135ee91e553f89",
    FUID = "ios_jp_ro",
    LANG = "jp"
  },
  ["jp.gungho.ragnarokm.cbt"] = {
    APP_ID = "162813",
    APP_KEY = "6abe7455ece8a3a902135ee91e553f89",
    FUID = "ios_jp_ro",
    LANG = "jp"
  },
  ["jptest.xdg.ios.ro"] = {
    APP_ID = "162813",
    APP_KEY = "90bfa15510a2ee69f9e33db3466baf2c",
    FUID = "ios_jp_ro",
    LANG = "jp"
  }
}
local ANDROID_TXWYSDK_Config = {
  ["jp.gungho.ragnarokm"] = {
    APP_ID = "162814",
    APP_KEY = "6abe7455ece8a3a902135ee91e553f89",
    FUID = "android_jp_ro",
    LANG = "jp"
  },
  ["jp.gungho.ragnarokm.cbt"] = {
    APP_ID = "162814",
    APP_KEY = "6abe7455ece8a3a902135ee91e553f89",
    FUID = "android_jp_ro",
    LANG = "jp"
  }
}
function AppBundleConfig.GetXDSDKInfo()
  if ApplicationInfo.IsWindows() then
    if EnvChannel.IsReleaseBranch() then
      return XDSDK_Config["com.xd.windows.rorelease"]
    elseif EnvChannel.IsTFBranch() then
      return XDSDK_Config["com.xd.windows.rotf"]
    elseif EnvChannel.IsStudioBranch() then
      return XDSDK_Config["com.xd.windows.rorelease"]
    else
      return XDSDK_Config["com.xd.windows.rorelease"]
    end
  elseif XDSDK_Config[AppBundleConfig.BundleID] == nil then
    if EnvChannel.IsReleaseBranch() then
      if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
        return XDSDK_Config["com.xd.ro"]
      elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
        return XDSDK_Config["com.xd.ro.roapk"]
      else
        return XDSDK_Config["com.xd.ro"]
      end
    elseif EnvChannel.IsTFBranch() then
      if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
        return XDSDK_Config["com.xd.ro2"]
      elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
        return XDSDK_Config["com.xd.ro.xdapk"]
      else
        return XDSDK_Config["com.xd.ro"]
      end
    else
      return XDSDK_Config["com.xd.ro"]
    end
  else
    return XDSDK_Config[AppBundleConfig.BundleID]
  end
end
function AppBundleConfig.GetTyrantdbInfo()
  if ApplicationInfo.IsWindows() then
    if EnvChannel.IsReleaseBranch() then
      return TyrantdbAppInfo_Config["com.xd.windows.rorelease"]
    elseif EnvChannel.IsTFBranch() then
      return TyrantdbAppInfo_Config["com.xd.windows.rotf"]
    elseif EnvChannel.IsStudioBranch() then
      return TyrantdbAppInfo_Config["com.xd.windows.rorelease"]
    else
      return TyrantdbAppInfo_Config["com.xd.windows.rorelease"]
    end
  else
    if EnvChannel.IsTrunkBranch() then
      return TyrantdbAppInfo_Config["com.xd.ro"]
    elseif EnvChannel.IsStudioBranch() then
      return TyrantdbAppInfo_Config["com.xd.ro"]
    end
    if TyrantdbAppInfo_Config[AppBundleConfig.BundleID] == nil then
      if EnvChannel.IsReleaseBranch() then
        if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
          return TyrantdbAppInfo_Config["com.xd.ro"]
        elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
          return TyrantdbAppInfo_Config["com.xd.ro.roapk"]
        else
          return TyrantdbAppInfo_Config["com.xd.ro"]
        end
      elseif EnvChannel.IsTFBranch() then
        if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
          return TyrantdbAppInfo_Config["com.xd.ro2"]
        elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
          return TyrantdbAppInfo_Config["com.xd.ro.xdapk"]
        else
          return TyrantdbAppInfo_Config["com.xd.ro"]
        end
      else
        return TyrantdbAppInfo_Config["com.xd.ro"]
      end
    else
      return TyrantdbAppInfo_Config[AppBundleConfig.BundleID]
    end
  end
end
function AppBundleConfig.GetANYSDKInfo()
  return ANDROID_ANYSDK_Config[AppBundleConfig.BundleID]
end
function AppBundleConfig.GetSocialShareInfo()
  return SocialShare_Config[AppBundleConfig.BundleID]
end
function AppBundleConfig.JumpToAppStore()
  AppBundleConfig.JumpToIOSAppStore()
  AppBundleConfig.JumpToAndroidAppStore()
end
function AppBundleConfig.JumpToIOSAppStore()
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    Application.OpenURL(AppBundleConfig.IOSAppUrl)
  end
end
function AppBundleConfig.JumpToAndroidAppStore()
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    Application.OpenURL(AppBundleConfig.AndroidAppUrl)
  end
end
function AppBundleConfig.JumpToAppReview()
  local config = GameConfig.AppBundleConfig
  if config == nil then
    config = AppBundleConfig
  end
  AppBundleConfig.JumpToIOSAppReview(config)
  AppBundleConfig.JumpToAndroidAppReview(config)
end
function AppBundleConfig.JumpToIOSAppReview(config)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    Application.OpenURL(config.IOSAppReviewUrl)
  end
end
function AppBundleConfig.JumpToAndroidAppReview(config)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    Application.OpenURL(config.AndroidAppReviewUrl)
  end
end
function AppBundleConfig.GetTXWYSDKInfo()
  Debug.LogFormat("get bundle id :{0}", AppBundleConfig.BundleID)
  Debug.LogFormat("get version :{0}", GetAppBundleVersion.BundleVersion)
  local info = IOS_TXWYSDK_Config[AppBundleConfig.BundleID]
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    Debug.Log("android!!!!!")
    info = ANDROID_TXWYSDK_Config[AppBundleConfig.BundleID]
  end
  return info
end
