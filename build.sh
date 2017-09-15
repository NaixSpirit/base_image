#!/bin/sh
set -e

PROGNAME=$(basename $0)
CURRENT_PATH=`pwd`
ONLINE_REMOTE_URL="registry-internal.cn-beijing.aliyuncs.com/fishtrip"
ONLINE_SOURCES_LIST_FILE="./aliyun.sources.list.online"
LOCAL_REMOTE_URL="registry.cn-beijing.aliyuncs.com/fishtrip"
LOCAL_SOURCES_LIST_FILE="./aliyun.sources.list.local"
DEFAULT_MAINTAINER="$(git config user.name) <$(git config user.email)>"

usage() {
    if [ "$*" != "" ]; then
        echo "Error: $*"
    fi

    cat << EOF
Usage: ./$PROGNAME [OPTION ...]

Options:
-i, --image [IMAGE]             Set image name
-v, --version [VERSION]         Set version
-m, --maintainer [MAINTAINER]   Set maintainer
-o, --online                    Set using online environment
-p, --push                      Set push image to registry
-h, --help                      Show help
EOF

    exit 1
}

while [ $# -gt 0 ] ; do
    case "$1" in
    -i|--image)
        IMAGE_NAME="$2"
        shift
        ;;
    -v|--version)
        VERSION="$2"
        shift
        ;;
    -m|--maintainer)
        MAINTAINER="$2"
        shift
        ;;
    -o|--online)
        ONLINE=1
        ;;
    -p|--push)
        PUSH=1
        ;;
    -h|--help)
        usage
        ;;
    -*)
        usage "Unknown option '$1'"
        ;;
    *)
        ;;
    esac
    shift
done

DOCKERFILE=$CURRENT_PATH/$IMAGE_NAME/Dockerfile
if [[ ! -n $MAINTAINER ]] ; then
    MAINTAINER=$DEFAULT_MAINTAINER
fi

if [[ -n $ONLINE ]] ; then
  cp $ONLINE_SOURCES_LIST_FILE $CURRENT_PATH/sources.list
  REMOTE_URL=$ONLINE_REMOTE_URL
else
  cp $LOCAL_SOURCES_LIST_FILE $CURRENT_PATH/sources.list
  REMOTE_URL=$LOCAL_REMOTE_URL
fi

echo "#### CHECK BUILD OPTIONS: ####\n"
echo "DOCKERFILE = ${DOCKERFILE}"
echo "IMAGE      = ${IMAGE_NAME}"
echo "VERSION    = ${VERSION}"
echo "MAINTAINER = ${MAINTAINER}"
echo "REMOTE_URL = ${REMOTE_URL}"
echo

if [[ ! -n $IMAGE_NAME ]] || [[ ! -n $VERSION ]]; then
    echo "WARNING: OPTIONS [--image] or [--version] can't be blank!!!"
    exit 1
fi

if [[ ! -f $DOCKERFILE ]]; then
    echo "WARNING: $DOCKERFILE not exist!!!"
    exit 1
fi

echo "#### CHECK BUILD OPTIONS PASSED"
echo

BUILD_COMMAND="docker build -t $REMOTE_URL/$IMAGE_NAME:$VERSION \
--build-arg VERSION=$VERSION \
--build-arg MAINTAINER='$MAINTAINER' \
-f $DOCKERFILE ."

echo "#### BUILD COMMAND: ####"
echo "$BUILD_COMMAND"

eval $BUILD_COMMAND

rm -rf $CURRENT_PATH/sources.list

if [[ -n $PUSH ]] ; then
    echo "#### START PUSH IMAGE TO REMOTE $REMOTE_URL"
    docker push $REMOTE_URL/$IMAGE_NAME:$VERSION
fi
