###
# this script print the main activities of
# all packages in vairalbe $apps

## global variables
# all packgea in the system
pkg=()

## note:
# this command gets all activity in a package
# shell dumpsys package | grep -i "your.package.name" | grep Activity

## command to get main activity:
# pm dump PACKAGE_NAME | grep -A 1 action.MAIN | head -n 2 | tail -n 1 | cut -d' ' -f12
# @input: $1 package_name
# this may fail. get a wrong activity name.
function get_main_activ() {
    # activ=$(pm dump $1 | grep -A 1 action.MAIN | head -n 2 | tail -n 1 | cut -d' ' -f12)
    activ=$(pm dump $1 | grep -B 2 category.LAUNCHER | grep -B 1 action.MAIN | head -n 1 |
        cut -d' ' -f12)
    if [[ -z $activ ]]; then
        activ=$(pm dump $1 | grep -B 3 category.LAUNCHER | grep -B 1 action.MAIN | head -n 1 |
            cut -d' ' -f12)
    fi
    echo $activ
}

## print all package names excluding system apps
function get_package_names() {
    echo "============= available apps ==========="
    # exclude build in packages
    # pm -l | cut -d":" -f2 | grep -v "huawei" | grep -v "android" | grep -v "qualcom"
    # "androidhwext" is no a normal package
    pkg=$(pm -l | cut -d":" -f2 | grep -v "androidhwext")
    # echo $pkg;
    for p in $pkg; do
        echo -n "$p\t"
        dumpsys package $p | grep versionName
        ## note there may be the same package of multiple version
    done
    # echo "================ end ==================="
}

# apps=(
# "com.qiyi.video"
# "com.xunmeng.pinduoduo"
# # "com.smile.gifmaker"
# "com.tencent.mobileqq"
# # "com.sina.weibo"
# "com.touchtype.swiftkey"
# "com.tencent.karaoke"
# )

. ./config.sh


# activs=("com.qiyi.video/.WelcomActivity"
# "com.xunmeng.pinduoduo/.ui.activity.MainFrameActivity"
# )

##### main

# parse arguments

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


if [[ $LIST -eq 1 ]]; then
    get_package_names
    exit 0
fi


for app in "${apps[@]}"
do
    get_main_activ $app
done



