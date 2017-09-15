# Fishtrip Docker Base Images

## Usage

```sh
./build.sh --help
Usage: ./build.sh [OPTION ...]

Options:
-i, --image [IMAGE]             Set image name
-v, --version [VERSION]         Set version
-m, --maintainer [MAINTAINER]   Set maintainer
-o, --online                    Set using online environment
-p, --push                      Set push image to registry
-h, --help                      Show help

./build --image ruby --version 2.2 --online --maintainer 'hxy' -p
./build -i ruby -v 2.4 -o -p
./build -i node -v 6 -o -p
```
