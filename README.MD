# Local deploy

First install Nodejs 18.x or higher

## Backend (NodeJS)

Go to the `./backend` folder and add your `firebase-admin.json` and your `.env`

## example:

.env

```
PORT=9000

CRYPTO_JS_SECRET=YOUR_SECRET

## SMTP ###
SMTP_HOST=your_smtpmailhost.com
SMTP_PORT=587
SMTP_USER=your-stmp-user@meedu.app
SMTP_PASSWORD=your-password
```

---

firebase-admin.json

```JSON
{
  "type": "service_account",
  "project_id": "your-projec-id",
  "private_key_id": "your-private-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\nYOUR_KEY-----END PRIVATE KEY-----\n",
  "client_email": "yourclientemail@test.com",
  "client_id": "your_client_id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "client_x509_cert_url"
}
```

Next run `npm install` and run the project using `npm run dev`.

## Flutter APP (only web and macOS)

Go to the `./app` folder and add your `env.json` file with your firebase credentials.

Example:

```JSON
{
  "webApiKey": "YOUR_WEB_API_KEY",
  "iosApiKey": "YOUR_IOS_API_KEY",
  "appId": "YOUR_APP_ID",
  "projectId": "YOUR_PROJECT_ID",
  "authDomain": "YOUR_AUTH_DOMAIN",
  "storageBucket": "YOUR_STORAGE_BUCKET",
  "iosClientId": "YOUR_IOS_CLIENT_ID",
  "iosBundleId": "app.meedu.icons",
  "apiHost": "https://YOUR_API_HOST"
}
```

Run your app on Web using

```shell
flutter run -d chrome --web-renderer html --release --dart-define-from-file=env.json
```

For macOS you need to add your `GoogleService-Info.plist` into the `macos/runner folder`


## CLI APP (dart command line application)