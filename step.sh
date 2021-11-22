#!/bin/bash
set -ex

cd ${gradlew_path}


if ${debug}
then
    ./gradlew uploadToAppSweepDebug
else
    ./gradlew uploadToAppSweepRelease
fi

