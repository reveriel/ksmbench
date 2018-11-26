#! /bin/sh

# global, constant
apps=(
"com.tencent.mm"
"com.tencent.mobileqq"
"com.android.contacts"
"com.tencent.tmgp.sgame"
"com.happyelements.AndroidAnimal"
"com.sina.weibo"
"com.baidu.tieba"
"com.huawei.camera"
"com.qiyi.video"
"com.android.gallery3d"
"com.evernote"
"com.adobe.reader"
"com.android.calendar"
"com.android.chrome"
"com.google.android.apps.maps"
"com.ss.android.article.news"
"com.taobao.taobao"
)

# in the same order with $apps
# their start/main activity
# use script get_main_activ.sh to get it, **manually** checked
activs=(
"com.tencent.mm/.ui.LauncherUI"
"com.tencent.mobileqq/.activity.SplashActivity"
"com.android.contacts/.activities.DialtactsActivity"
"com.tencent.tmgp.sgame/.SGameActivity"
"com.happyelements.AndroidAnimal/com.happyelements.hellolua.MainActivity"
"com.sina.weibo/.SplashActivity"
"com.baidu.tieba/.LogoActivity"
"com.huawei.camera/com.huawei.camera"
"com.qiyi.video/.WelcomeActivity"
"com.android.gallery3d/com.huawei.gallery.app.GalleryMain"
"com.evernote/.ui.HomeActivity"
"com.adobe.reader/.AdobeReader"
"com.android.calendar/.AllInOneActivity"
"com.android.chrome/com.google.android.apps.chrome.Main"
"com.google.android.apps.maps/com.google.android.maps.MapsActivity"
"com.ss.android.article.news/.activity.SplashBadgeActivity"
"com.taobao.taobao/com.taobao.tao.welcome.Welcome"
)



