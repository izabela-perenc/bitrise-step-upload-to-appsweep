#!/bin/bash
set -ex

if [[ ! -z "${APPSWEEP_API_KEY}" ]]; then
  export APPSWEEP_API_KEY=${appsweep_api_key}
fi

cd ${project_location}
BUILD_FILE=./app/build.gradle

if [ ! -f "$BUILD_FILE" ]; then
    echo "$BUILD_FILE does not exist. Probably you are using not standard project structure, please add following plugin \"com.guardsquare.appsweep\" to build.gradle script."
else
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
		fi   
	fi
fi

if [ -f "${gradlew_path}" ];
then
	echo "The gradlew file was found in ${gradlew_path}"
	GRADLEW={$gradlew_path}
elif [ -f "./gradlew" ];
then
	echo "The gradlew file was found in ${project_location}/gradlew"
	GRADLEW=./gradlew
else
	echo "The gradlew file was not found please provide correct gradlew_path"
	exit 1
fi
	
if ${debug}
then
    "$GRADLEW" uploadToAppSweepDebug
else
    "$GRADLEW" uploadToAppSweepRelease
fi

