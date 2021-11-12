#!/bin/bash
set -ex

cd ${gradlew_path}


if (./gradlew tasks | grep -q "Protected" ) && ${protected};
then
	if ${debug}
	then
	    ./gradlew uploadToAppSweepDebugProtected
	else
	    ./gradlew uploadToAppSweepReleaseProtected
	fi
fi

if ${debug}
then
    ./gradlew uploadToAppSweepDebug
else
    ./gradlew uploadToAppSweepRelease
fi

