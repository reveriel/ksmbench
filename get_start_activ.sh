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
    # exclude build in packages
    # pm -l | cut -d":" -f2 | grep -v "huawei" | grep -v "android" | grep -v "qualcom"
    pm -l | cut -d":" -f2
    echo "================ end ==================="
}

# "com.UCMobile"  # UC give strange start time, don't use it
apps=(
"com.qiyi.video"
"com.xunmeng.pinduoduo"
# "com.smile.gifmaker"
"com.tencent.mobileqq"
# "com.sina.weibo"
"com.touchtype.swiftkey"
"com.tencent.karaoke"
)

# activs=("com.qiyi.video/.WelcomActivity"
# "com.xunmeng.pinduoduo/.ui.activity.MainFrameActivity"
# )

##### main

# parse arguments

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -l)
            LIST=1
            shift
            ;;
        -h)
            echo "usage: $0 [-l|-h]"
            echo "    -l: list all packges in system"
            echo "    -h: print this help"
            exit 0
            ;;
        *)
            ;;
    esac
done


if [[ $LIST -eq 0 ]]; then
    get_package_names
    exit 0
fi


for app in "${apps[@]}"
do
    get_main_activ $app
done



