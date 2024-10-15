import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
import 'package:flutter_application_3_mainproject/db/db_service.dart';
import 'package:flutter_application_3_mainproject/model/contactsm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;

  _getPermission() async => await [Permission.sms].request();

  _isPermissionGranted() async => await Permission.sms.status.isGranted;

  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: simSlot,
    ).then((SmsStatus status) {
      if (status.toString() == "SmsStatus.sent") {
        Fluttertoast.showToast(msg: "Message sent");
      } else {
        Fluttertoast.showToast(msg: "Message failed to send");
      }
    });
  }

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions are denied");
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Location permissions are permanently denied");
      return;
    }

    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    ).then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _getAddressFromLatLon();
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];
      if (mounted) {
        setState(() {
          _currentAddress = "${place.locality}, ${place.postalCode}, ${place.street}";
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _sendLocation() async {
    if (_currentPosition == null || _currentAddress == null) {
      Fluttertoast.showToast(msg: "Location is not available yet. Please wait.");
      return;
    }

    List<TContact> contactList = await DatabaseHelper().getContactList();
    String messageBody =
        "I am in trouble. Here's my location: https://www.google.com/maps/place/${_currentPosition!.latitude},${_currentPosition!.longitude} $_currentAddress";

    if (await _isPermissionGranted()) {
      for (TContact contact in contactList) {
        _sendSms(contact.number, messageBody, simSlot: 1);
      }
    } else {
      Fluttertoast.showToast(msg: "SMS permission denied");
    }
  }

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    // Clean up any resources here if needed
    super.dispose();
  }

  showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CURRENT LOCATION TO EMERGENCY CONTACTS",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                if (_currentAddress != null)
                  Text(_currentAddress!),
                PrimaryButton(
                  title: "GET LOCATION",
                  onPressed: _getCurrentLocation,
                ),
                SizedBox(height: 10),
                PrimaryButton(
                  title: "SEND LOCATION",
                  onPressed: _sendLocation,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModelSafeHome(context);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink,
                Color.fromARGB(255, 221, 112, 148),
                Color.fromARGB(255, 228, 207, 214)
              ],
            ),
          ),
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Send Location",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Share Location",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("assets/loc.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
// import 'dart:ui';

// import 'package:background_sms/background_sms.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geocoding/geocoding.dart';
// class Safehome extends StatefulWidget {
//   // const Safehome({super.key});

//   @override
//   State<Safehome>createState() => _SafehomeState();
// }

// class _SafehomeState extends State<Safehome> {

//   Position? _currentPosition;
//   String? _currentAddress; // The value of the field '_currentAddress' isn't used.
//   LocationPermission? _permission;

//   _getPermission() async=>
//   await [Permission.sms].request();
  

//   _isPermissionGranted() async =>
//     await Permission.sms.status.isGranted;
  

//   Future <SmsStatus> _sendSms(String phoneNumber, String message, {int? simSlot}) async {
//     await BackgroundSms.sendMessage(
//       phoneNumber: phoneNumber,
//       message: message,
//       simSlot: simSlot,
//     ).then((SmsStatus status) {
//       if (status == "sent") {
//         Fluttertoast.showToast(msg: "sent");
//       } else {
//         Fluttertoast.showToast(msg: "failed");
//       }
//     });
//   }
// _getCurrentLocation() async { 
//      permission = await Geolocator.checkPermission(); 
//     if (permission == LocationPermission.denied) { 
//         permission = await Geolocator.requestPermission(); 
//         Fluttertoast.showToast(msg: "Location permissions are denind"); 
//     } 
//     if (permission == LocationPermission.deniedForever) { 
//         Fluttertoast.showToast(
//             msg: "Location permissions are permanently denind"); 
//     } 
// } 

// Geolocator.getCurrentPosition( 
//   desiredAccuracy: LocationAccuracy.high,
//     forceAndroidLocationManager : true).then((Position position){ 
//         setState(() { 
//             _currentPosition = position; 
//             _getAddressFromLatLon(); 
//         }); 
//     }).catchError((e) { 
//         Fluttertoast.showToast(msg: e.toString()); 
//     });

// _getAddressFromLatLon() async{
//   try{
//     List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition!.longitude);

//     placemarks place = placemarks[0];
//     setState(() {
      
// _currentAddress = "${place.locality} , ${place.postalCode},${place.street}";
//     });
//   }catch(e){
//     Fluttertoast.showToast(msg: (msg: e.toString()));
//   }
// }
// @override
// void initState(){
//   super.initState();
//   _getCurrentLocation();
// }


  
//   showModelSafeHome(BuildContext context) {
//    showModalBottomSheet(
//   context: context,
//   builder: (context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 1.4,
//       child: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOUR EMERGENCY CONTACTS",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             PrimaryButton(title: "GET LOCATION", onPressed: () {}),
//             SizedBox(height: 10),
//             PrimaryButton(title: "SEND ALERT", onPressed: () {}),
//           ],
//         ),
//       ),
//     );
  
//   }
//    );
//   }
  



// 
// import 'package:background_sms/background_sms.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
// import 'package:flutter_application_3_mainproject/db/db_service.dart';
// import 'package:flutter_application_3_mainproject/model/contactsm.dart';
// import 'package:flutter_application_3_mainproject/utils/constants.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';


// import 'package:permission_handler/permission_handler.dart';

// class SafeHome extends StatefulWidget {
//   @override
//   State<SafeHome> createState() => _SafeHomeState();
// }

// class _SafeHomeState extends State<SafeHome> {
//   Position? _currentPosition;
//   String? _currentAddress; // The value of the field '_currentAddress' isn't used.
//   LocationPermission? permission;

// _getPermission() async=>
//   await [Permission.sms].request();
  
//  _isPermissionGranted() async =>
//    await Permission.sms.status.isGranted;
// //  Future <SmsStatus>
//     _sendSms(String phoneNumber, String message, {int? simSlot}) async {
//     await BackgroundSms.sendMessage(
//       phoneNumber: phoneNumber,
//       message: message,
//       simSlot: simSlot,
//     ).then((SmsStatus status) {
       
//       if (status.toString() == "SmsStatus.sent") {
//         Fluttertoast.showToast(msg: "sent");
//       } else {
//         Fluttertoast.showToast(msg: "failed");
//       }
//     });
//   }
// _getCurrentLocation() async { 
//      permission = await Geolocator.checkPermission(); 
//     if (permission == LocationPermission.denied) { 
//         permission = await Geolocator.requestPermission(); 
//         Fluttertoast.showToast(msg: "Location permissions are denind"); 
//     } 
//     if (permission == LocationPermission.deniedForever) { 
//         Fluttertoast.showToast(
//             msg: "Location permissions are permanently denind"); 
//     } 





// Geolocator.getCurrentPosition( 
//   desiredAccuracy: LocationAccuracy.high,
//   // desiredAccuracy: LocationAccuracy.high,
//     forceAndroidLocationManager: true)
//     .then((Position position){ 
//         setState(() { 
//             _currentPosition = position; 
//             print(_currentPosition!.latitude);
//             _getAddressFromLatLon(); 
//         }); 
//     }).catchError((e) { 
//         Fluttertoast.showToast(msg: e.toString()); 
//     });
// }
// _getAddressFromLatLon() async{
//   try{
//     List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);

//     Placemark place = placemarks[0];
//     setState(() {
      
// _currentAddress = "${place.locality} , ${place.postalCode},${place.street}";
//     });
//   }catch(e){
//     Fluttertoast.showToast(msg: e.toString());
//   }
// }
// _sendloc() async {
//   if (_currentPosition == null || _currentAddress == null) {
//     Fluttertoast.showToast(msg: "Location is not available yet. Please wait.");
//     return;
//   }

//   List<TContact> contactList = await DatabaseHelper().getContactList();
//   String recipients = "";
//   int i = 1;
//   for (TContact contact in contactList) {
//     recipients += contact.number;
//     if (i != contactList.length) {
//       recipients += ";";
//       i++;
//     }
//   }

//   // Ensure the location data is available before using it
//   String messageBody =
//       "https://www.google.com/maps/place/${_currentPosition!.latitude},${_currentPosition!.longitude} $_currentAddress";

//   if (await _isPermissionGranted()) {
//     for (TContact contact in contactList) {
//       _sendSms("${contact.number}", "I am in trouble. $messageBody", simSlot: 1);
//     }
//   } else {
//     Fluttertoast.showToast(msg: "SMS permission denied");
//   }
// }



// @override
// void initState(){
//   super.initState();
//   _getPermission();
//   _getCurrentLocation();
// }
//   showModelSafeHome(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return Container(
//         height: MediaQuery.of(context).size.height / 1.4,
//         child: Padding(
//           padding: const EdgeInsets.all(14.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("SEND YOUR CURRENT LOCATION TO EMERGENCY CONTACTS",style: TextStyle(fontSize: 20,color: Colors.black),
//               textAlign:TextAlign.center,),
//               SizedBox(height: 10,),
//               if(_currentPosition !=null)Text(_currentAddress!),
              
//               PrimaryButton(title: " GET LOCATION ", onPressed:(){
//                 _getCurrentLocation();
//               }),
//               SizedBox(height: 10,),

//                 PrimaryButton(title: " SEND LOCATION ", onPressed:() {
//                   _sendloc();
                  

//                 })
          
//             ],
//           ),
//         ),
//         decoration: BoxDecoration(

//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//       );
//     },
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//    return InkWell(
//     onTap: ()=>{
// showModelSafeHome(context),
//     },
//      child: Card(
     
//        elevation: 5,
//        shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(20),
//        ),
//        child: Container(
//          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight, colors:[Colors.pink,const Color.fromARGB(255, 221, 112, 148),const Color.fromARGB(255, 228, 207, 214)])),
//       height: 200,
//       width: MediaQuery.of(context).size.width * 0.9,
//       // decoration: BoxDecoration(),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Text("Send Location",
//                   style: TextStyle(fontSize: 20,
//                   color: Colors.white,
//                   fontWeight:FontWeight.bold),
//                   ),
//                   subtitle: Text("Share Location",
//                   style: TextStyle(fontSize: 15,
//                   color: Colors.white,
//                   ),),
//                 ),
//               ],
//             ),
//           ),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Image.asset("assets/loc.png"),
//           ),
//         ],
//       ),
//        ),
//      ),
//    );
//   }
//   }
  



// List<TContact> contactList =
                  // await DatabaseHelper().getContactList();
                  // String recipients = "";
                  // int i = 1 ;
                  // for(TContact contact in contactList){
                  //   recipients += contact.number; 
                  //   if(i!= contactList.length){
                  //     recipients += ";" ;
                  //     i++ ;
                    
                  //   }
                  // }
                  // String messageBody = "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}.$_currentAddress";
                  // if(await _isPermissionGranted()){
                  //   contactList.forEach((element){
                  //     _sendSms("${element.number}",
                  //     "I an in trouble $messageBody",
                  //     simSlot: 1
                  //     );
                  //   });

                  // }
                  // else{
                  //   Fluttertoast.showToast(msg: "something went wrong");
                  // }


// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_application_3_mainproject/components/primarybutton.dart';

// class Safehome extends StatefulWidget {
//   @override
//   State<Safehome> createState() => _SafehomeState();
// }

// class _SafehomeState extends State<Safehome> {
//   Position? _currentPosition;
//   String? _currentAddress;
//   LocationPermission? _permission;

//   Future<void> _getPermission() async {
//     await [Permission.sms].request();
//   }

//   Future<bool> _isPermissionGranted() async {
//     return await Permission.sms.isGranted;
//   }

//   Future<void> _sendSms(String phoneNumber, String message, {int? simSlot}) async {
//     await BackgroundSms.sendMessage(
//       phoneNumber: phoneNumber,
//       message: message,
//       simSlot: simSlot,
//     ).then((SmsStatus status) {
//       if (status == SmsStatus.sent) {
//         Fluttertoast.showToast(msg: "SMS sent");
//       } else {
//         Fluttertoast.showToast(msg: "SMS failed");
//       }
//     });
//   }

//   Future<void> _getCurrentLocation() async {
//     _permission = await Geolocator.checkPermission();
//     if (_permission == LocationPermission.denied) {
//       _permission = await Geolocator.requestPermission();
//       if (_permission == LocationPermission.denied) {
//         Fluttertoast.showToast(msg: "Location permissions are denied");
//         return;
//       }
//     }

//     if (_permission == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(msg: "Location permissions are permanently denied");
//       return;
//     }

//     Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//       forceAndroidLocationManager: true,
//     ).then((Position position) {
//       setState(() {
//         _currentPosition = position;
//         _getAddressFromLatLon();
//       });
//     }).catchError((e) {
//       Fluttertoast.showToast(msg: e.toString());
//     });
//   }

//   Future<void> _getAddressFromLatLon() async {
//     try {
//       if (_currentPosition != null) {
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude,
//           _currentPosition!.longitude,
//         );

//         Placemark place = placemarks[0];
//         setState(() {
//           _currentAddress = "${place.locality}, ${place.postalCode}, ${place.street}";
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   void showModelSafeHome(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           height: MediaQuery.of(context).size.height / 1.4,
//           child: Padding(
//             padding: const EdgeInsets.all(14.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOUR EMERGENCY CONTACTS",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 SizedBox(height: 10),
//                 PrimaryButton(
//                   title: "GET LOCATION",
//                   onPressed: () async {
//                     await _getCurrentLocation();
//                     Fluttertoast.showToast(msg: "Location: $_currentAddress");
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 PrimaryButton(
//                   title: "SEND ALERT",
//                   onPressed: () async {
//                     if (await _isPermissionGranted()) {
//                       _sendSms("1234567890", "Help! My current location is: $_currentAddress");
//                     } else {
//                       Fluttertoast.showToast(msg: "SMS permission not granted");
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => showModelSafeHome(context),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Colors.pink, Color(0xFFDD7094), Color(0xFFE4CFD6)],
//             ),
//           ),
//           height: 200,
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   children: [
//                     ListTile(
//                       title: Text(
//                         "Send Location",
//                         style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         "Share Location",
//                         style: TextStyle(fontSize: 15, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.asset("assets/loc.png"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
