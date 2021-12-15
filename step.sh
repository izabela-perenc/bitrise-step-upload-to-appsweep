#!/bin/bash
set -ex
cd ${gradlew_path}
BUILD_FILE=./app/build.gradle
if [ ! -f "$BUILD_FILE" ]; then
    echo "$BUILD_FILE does not exist. Probably you are using not standard project sturcture, please add following plugin \"com.guardsquare.appsweep\" to build.gradle script."
    exit 1
fi
if grep -Fq "\"com.guardsquare.appsweep\"" $BUILD_FILE
then
    echo "AppSweep plugin exists in $BUILD_FILE"
else
    echo "AppSweep plugin was not found in $BUILD_FILE. Injecting..."
    #remove all white lines
    sed -i '/^[[:space:]]*$/d' $BUILD_FILE
    #remove new line character after 'plugins' hopefully before '{' if not we inject new one
    sed -i '/plugins/{N;s/\n//;}' $BUILD_FILE
    #inject AppSweep plugin
    sed -i 's/plugins\s*{/plugins\n{\n\tid "com.guardsquare.appsweep" version "0.1.6"\n/1' $BUILD_FILE
    if grep -Fq "\"com.guardsquare.appsweep\"" $BUILD_FILE
    then
        echo "AppSweep plugin succesfully injected to $BUILD_FILE"
    else
        echo "AppSweep plugin was not injected to $BUILD_FILE. Please add following plugin \"com.guardsquare.appsweep\" to build.gradle script manually."
        exit 1
    fi   
fi
if ${debug}
then
    ./gradlew uploadToAppSweepDebug
else
    ./gradlew uploadToAppSweepRelease
fi
