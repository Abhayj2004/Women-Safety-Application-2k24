// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geocoding/geocoding.dart';
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   AndroidNotificationChannel channel = AndroidNotificationChannel(
//     "script academy",
//     "foreground service",
//     importance: Importance.high,
//   );
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await service.configure(
//       iosConfiguration: IosConfiguration(),
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         isForegroundMode: true,
//         autoStart: true,
//         notificationChannelId: "script academy",
//         initialNotificationTitle: "foreground service",
//         initialNotificationContent: "initializing",
//         foregroundServiceNotificationId: 888,
//       ));
//   service.startService();
// }

// @pragma('vm-entry-point')
// void onStart(ServiceInstance service) async {
 

//   DartPluginRegistrant.ensureInitialized();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   Timer.periodic(Duration(seconds: 120), (timer) async {
// if(service is AndroidServiceInstance){
//   if (await service.isForegroundService()){
//     flutterLocalNotificationsPlugin.show(
//        888,
//        "women safety APP",
//        "shake feature enable",
//        NotificationDetails(
//         android:AndroidNotificationDetails(
//           "script academy",
//           "foreground services",
//           icon: "@mipmap/ic_launcher",
//           ongoing: true ,
//         )
//        )

//     );

//   }
// }
//   });
// }



import 'dart:async';
import 'dart:ui';


import 'package:flutter_application_3_mainproject/db/db_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';

import 'package:flutter_application_3_mainproject/model/contactsm.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';

sendMessage(String messageBody) async {
  List<TContact> contactList = await DatabaseHelper().getContactList();
  if (contactList.isEmpty) {
    Fluttertoast.showToast(msg: "no number exist please add a number");
  } else {
    for (var i = 0; i < contactList.length; i++) {
      Telephony.backgroundInstance
          .sendSms(to: contactList[i].number, message: messageBody)
          .then((value) {
        Fluttertoast.showToast(msg: "message send");
      });
    }
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    "script academy",
    "foregrounf service",
    importance: Importance.low,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: "script academy",
        initialNotificationTitle: "foregrounf service",
        initialNotificationContent: "initializing",
        foregroundServiceNotificationId: 888,
      ));
  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  Location? clocation;

  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(seconds: 2), (timer) async{
    if(service is AndroidServiceInstance){
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true)
          .then((Position position) {
            print("bg location ${position.latitude}");
          })
          .catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });
      if(await service.isForegroundService()) {
        ShakeDetector.autoStart(
            shakeThresholdGravity: 7,
            onPhoneShake: () async {
              if(await Vibration.hasVibrator() ?? false){
                
                print("66666666");
                if(await Vibration.hasCustomVibrationsSupport() ?? false){
                  print("88888888");
                  Vibration.vibrate(duration: 1000);
                  await Future.delayed(Duration(microseconds: 500));
                  Vibration.vibrate();

                  
                }
              }
        });
        flutterLocalNotificationsPlugin.show(
          888,
          "women safety app",
          "shake feature enable",
          NotificationDetails(
            android: AndroidNotificationDetails(
              "script academy",
              "foreground service",
              
              icon: 'ic_bg_service_small',
              ongoing: true,
            )
          ),
        );
      }
    }
  });
}