# ByCoders_ Mobile Challenge (Flutter)
A mobile ByCoders_ challenge implemented in Flutter using Clean Architecture.

## Challenge Requirements

1. Login page with FirebaseAuth (using email and password);
2. Home screen with a map rendering a point at the device's current location;
4. Store user data in the global store;
5. Track successful login and successful rendering with Analytics (send an event with data considered essential in these two cases);
6. Track errors and submit them to Crashlytics;
7. Store in the local database (in this case using Sembast) the logged in user and his last position on the map;
8. Test login flow (unit and e2e);
9. Test home flow (unit and e2e).

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

* [Flutter 2.2.3](https://flutter.dev/docs/development/tools/sdk/releases)

### Installation

1. Clone the repo
   ```
   git clone https://github.com/ArtMasson/desafio_mobile.git
   ```
2. Install Flutter packages
   ```
   flutter pub-get
   ```
3. Generate Mobx files
   ```
   flutter packages pub run build_runner build
   ```
4. Run the project
   ```
   flutter run
   ```

## Usage

- Login with:

```
email: user@user.com
password: 123456
```

![image](https://user-images.githubusercontent.com/44551981/127781204-828137a2-6803-4b66-b764-6ac45080b3e3.png)
![image](https://user-images.githubusercontent.com/44551981/127781219-78491841-0d8d-4f12-a8d1-b15b3bb7477f.png)
![image](https://user-images.githubusercontent.com/44551981/127781228-720b9887-7f29-4d45-a26b-4b3ec9b3b9d5.png)
![image](https://user-images.githubusercontent.com/44551981/127781238-bd77ee39-7097-4036-a52e-c0efea9e48ec.png)


- To enable event track in firestore analytics debug view i use the following command:

   ```
   adb -d shell setprop debug.firebase.analytics.app com.arthurmasson.desafio_mobile
   ```
   
![image](https://user-images.githubusercontent.com/44551981/127780927-c61986d3-4faf-447b-b1d0-06a5159bc96b.png)


## Built With

* [Flutter 2.2.3](https://flutter.dev/docs/development/tools/sdk/releases)
* [Firebase_Core 1.4.0](https://pub.dev/packages/firebase_core)
* [Firebase Auth 3.0.1](https://pub.dev/packages/firebase_auth)
* [Firebase Crashlytics 2.1.1](https://pub.dev/packages/firebase_crashlytics)
* [Firebase Analytics 8.2.0](https://pub.dev/packages/firebase_analytics)
* [Mobx 2.0.1](https://pub.dev/packages/mobx)
* [GetIt 7.1.4](https://pub.dev/packages/get_it)
* [Sembast NoSqlDb 3.1.0+2](https://pub.dev/packages/sembast)
* [Google Maps Flutter 2.0.6](https://pub.dev/packages/google_maps_flutter)





