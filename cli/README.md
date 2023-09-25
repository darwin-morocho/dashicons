The oficial CLI for **icons.meedu.app**


## Install

```shell
dart pub global activate micons_cli
```

Or 


```shell
flutter pub global activate micons_cli
```

## Commands

```
// To login in your icons.meedu.app account
micons login

// To initialize the icons.meedu.app package in the current directory
micons init

// Pull the ttf file and update the icons.dart file with the latest package changes from icons.meedu.app
micons pull

// You can use the file argument to use a different config file. Useful when you have multiple packages in one single project.
micons pull --file=your_config_file.json

// Use useApiKey=true if you are running a CI/CD process.
// Keep in mind that you must define an environment variable called MICONS_API_KEY with your API key.
micons pull --useApiKey=true

// Remove the current session data
micons logout
```