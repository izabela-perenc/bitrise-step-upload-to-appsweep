# Upload release to AppSweep

The Step runs the AppSweep Gradle task to upload your app for security analysis to [AppSweep](https://appsweep.guardsquare.com). 

## How to use this Step

You can also add this step directly to your workflow in the [Bitrise Workflow Editor](https://devcenter.bitrise.io/steps-and-workflows/steps-and-workflows-index/).  
Alternatively, you can run is with the [bitrise CLI](https://github.com/bitrise-io/bitrise).

To use this Step, you need:

* A [Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html) in your project. If it is in root folder, then it can be used automatically by this step. If it is located elsewhere, please specify its location in `GRADLEW_PATH`.
* The Gradle AppSweep plugin. If you have a common folder structre (in particular `./app/build.gradle` is your app's gradle file) then the plugin will be injected automatically. Otherwise you need to add the AppSweep plugin manually, by adding `id "com.guardsquare.appsweep" version "0.1.7"` to the plugin section of your app's build.gradle script.
* An `APPSWEEP_API_KEY` must be set, you can generate it in the API Keys section of your project settings. This key **SHOULD NOT** be checked into your repository, but set up as a [Bitrise Secret](https://devcenter.bitrise.io/en/builds/secrets.html).
* By default the `release` build will be scanned. If you want to change this, set `debug: true` in your steps configuration.


## Configuration

The step can either be configured directly in the `bitrise.yml`, or in the visual step configuration in the Workflow Editor.
| Parameter         | Default     | Description |
|--------------|-----------|------------|
| appsweep_api_key| `APPSWEEP_API_KEY` secret key | Must be set to allow scanning of the app inside an AppSweep project. You can generate it in the API Keys section of your project settings.| 
| debug | false | Set to true to upload the debug version of your app, or to false to upload the release version. |
| project_location | `$PROJECT_LOCATION` | Set this to the location of your project inside your repository. |
| gradle_path | `$PROJECT_LOCATION`/gradlew | Gradle taks to start the app scan. |

1. In the **Should debug version be uploaded** input, you can specify which version of an apk will be uploaded debug or release.
1. If `gradlew` is not in the project's root, set the `gradlew` file path: this is the path where the Gradle Wrapper is located in your project. The path should be relative to the project's root. 
1. If `build.gradle` is not in `./app/build.gradle`, set a path to the `build.gradle` file.


## Example bitrise.yml step

```
- git::https://github.com/izabela-perenc/bitrise-step-upload-to-appsweep.git@master:
    title: AppSweep
    inputs:
    - debug: true
```

### Troubleshooting 

If the step fails because of **Task was not found in root project** it means that the plugin was not injected properly. Then please add in manually and verify if listing all tasks is showing also AppSweep tasks. 

If the step fails with **The gradlew file was not found please provide correct gradlew_path** that means that path to gradlew is not correct. Please remember thet, the path must be relative to the root of the repository and should contain `gradlew` file in the end for example `./dir/gradlew`.

If the step fails with **No API key set. Either set the APPSWEEP_API_KEY environmant variable or apiKey in the appsweep block
** it means that AppSweep API key was not set. 
