# Upload release to AppSweep

Sends app to AppSweep for app analysis.

<details>
<summary>Description</summary>

The Step runs Gradle task that uploads an app to AppSweep for security analysis. The step checks first if AppSweep plugin is included in `build.gradle` if not it injects it. Then Gradle task is generating a library mapping file that helps to identify packages in the app - distinguish between user code and libraries. Finaly both builded apk and mapping file are uploaded to AppSweep.

### Configuring the Step 

To use this Step, you need:

* [Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html) in your project. If it is in root folder, then it will be found automatically. If it is located in different place then please specify it in `GRADLEW_PATH`.
* A Gradle AppSweep plugin. If you have `./app/build.gradle` then the plugin will be injected automatically. Otherwise please add it manually `id "com.guardsquare.appsweep" version "0.1.6"`.
* An `APPSWEEP_API_KEY` must be set, you can generate it in the API Keys section of your project settings.

For the basic configuration:

1. Open the **Config** input group.
1. In the **Should debug version be uploaded** input, you can specify which version of an apk will be uploaded debug or release.
1. If `gradlew` is not in the project's root, set the `gradlew` file path: this is the path where the Gradle Wrapper is located in your project. The path should be relative to the project's root. 
1. If `build.gradle` is not in `./app/build.gradle`, set a path to the `build.gradle` file.
   
### Troubleshooting 

If the step fails because of **Task was not found in root project** it means that the plugin was not injected properly. Then please add in manually and verify if listing all tasks is showing also AppSweep tasks. 

If the step fails with **The gradlew file was not found please provide correct gradlew_path** that means that path to gradlew is not correct. Please remember thet, the path must be relative to the root of the repository and should contain `gradlew` file in the end for example `./dir/gradlew`.

If the step fails with **No API key set. Either set the APPSWEEP_API_KEY environmant variable or apiKey in the appsweep block
** it means that AppSweep API key was not set. 

</details>

## How to use this Step

Can be run directly with the [bitrise CLI](https://github.com/bitrise-io/bitrise).

You can also add this step directly to your workflow in the [Bitrise Workflow Editor](https://devcenter.bitrise.io/steps-and-workflows/steps-and-workflows-index/).

*Please set up all required environmental variables, especially APPSWEEP_API_KEY*

An example `.bitrise.secrets.yml` file:

```
envs:
- APPSWEEP_API_KEY: gs_appsweep_SOME_API_KEY
```


