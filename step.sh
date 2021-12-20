#!/bin/bash
set -ex

export APPSWEEP_API_KEY=${appsweep_api_key}


cd ${project_location}
BUILD_FILE=./app/build.gradle

if [ ! -f "$BUILD_FILE" ]; then
    echo "$BUILD_FILE does not exist. Probably you are using not standard project structure, please add \"com.guardsquare.appsweep\" to the plugin section of your app's build.gradle script."
else
	if grep -Fq "\"com.guardsquare.appsweep\"" $BUILD_FILE
	then
		echo "AppSweep plugin already exists in $BUILD_FILE. Not injecting."
	else
		echo "AppSweep plugin was not found in $BUILD_FILE. Injecting..."
		#remove all white lines
		sed -i '/^[[:space:]]*$/d' $BUILD_FILE
		#remove potential new line characters after 'plugins'
		sed -i '/plugins/{N;s/\n//;}' $BUILD_FILE
		#inject AppSweep plugin
		sed -i 's/plugins\s*{/plugins\n{\n\tid "com.guardsquare.appsweep" version "0.1.6"\n/1' $BUILD_FILE
		if grep -Fq "\"com.guardsquare.appsweep\"" $BUILD_FILE
		then
			echo "AppSweep plugin succesfully injected to $BUILD_FILE."
		else
			echo "AppSweep plugin was not injected to $BUILD_FILE. Please add \"com.guardsquare.appsweep\" to the plugin section of your app's build.gradle script."
		fi   
	fi
fi

if [ -f "${gradlew_path}" ];
then
	echo "The gradlew wrapper was found in ${gradlew_path}."
	GRADLEW={$gradlew_path}
elif [ -f "./gradlew" ];
then
	echo "The gradlew wrapper was found in ${project_location}/gradlew"
	GRADLEW=./gradlew
else
	echo "The gradlew wrapper was not found. Please provide the correct gradlew_path."
	exit 1
fi
	
if ${debug}
then
    "$GRADLEW" uploadToAppSweepDebug
else
    "$GRADLEW" uploadToAppSweepRelease
fi

