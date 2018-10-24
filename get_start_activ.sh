###
# this script print the main activities of
# all packages in vairalbe $apps


## command to get main activity:
# pm dump PACKAGE_NAME | grep -A 1 action.MAIN | head -n 2 | tail -n 1 | cut -d' ' -f12
# @input: $1 package_name
function get_main_activ() {
    activ=$(pm dump $1 | grep -A 1 action.MAIN | head -n 2 | tail -n 1 | cut -d' ' -f12)
    echo $activ
}

## print all package names excluding system apps
function get_package_names() {
    echo "============= available apps ==========="
    pm -l | cut -d":" -f2 | grep -v "huawei" | grep -v "android" | grep -v "qualcom"
    echo "================ end ==================="
}

# "com.UCMobile"  # UC give strange start time, don't use it
apps=("com.qiyi.video"
"com.xunmeng.pinduoduo"
"com.smile.gifmaker"
"com.tencent.mobileqq"
"com.sina.weibo")

# activs=("com.qiyi.video/.WelcomActivity"
# "com.xunmeng.pinduoduo/.ui.activity.MainFrameActivity"
# )

##### main

get_package_names

for app in "${apps[@]}"
do
    get_main_activ $app
done



