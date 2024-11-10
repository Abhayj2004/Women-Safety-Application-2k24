import 'dart:async';
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
  Timer? _locationTimer;

  // Request permission for SMS and location.
  _getPermissions() async {
    await [Permission.sms, Permission.location].request();
  }

  // Check if SMS permission is granted.
  Future<bool> _isSmsPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  // Send SMS message with location details.
  Future<void> _sendSms(String phoneNumber, String message) async {
    SmsStatus status = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: 1,
    );

    if (status == SmsStatus.sent) {
      Fluttertoast.showToast(msg: "Location message sent");
    } else {
      Fluttertoast.showToast(msg: "Failed to send message");
    }
  }

  // Get the current location of the user.
  Future<void> _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permissions permanently denied");
      return;
    }

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
        _getAddressFromLatLon();
      }
    });
  }

  // Convert latitude and longitude into a readable address.
  Future<void> _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // Send the current location to emergency contacts.
  Future<void> _sendLocationToContacts() async {
    if (_currentPosition == null || _currentAddress == null) {
      Fluttertoast.showToast(msg: "Location not available yet. Please wait.");
      return;
    }

    List<TContact> contactList = await DatabaseHelper().getContactList();
    String messageBody =
        "I am in trouble. Here's my live location: https://www.google.com/maps/place/${_currentPosition!.latitude},${_currentPosition!.longitude}\nAddress: $_currentAddress";

    if (await _isSmsPermissionGranted()) {
      for (TContact contact in contactList) {
        _sendSms(contact.number, messageBody);
      }
    } else {
      Fluttertoast.showToast(msg: "SMS permission denied");
    }
  }

  // Start live location updates by sending SMS periodically.
  void _startLiveLocationUpdates() {
     _sendLocationToContacts();
    _locationTimer?.cancel(); // Cancel any existing timer.
    _locationTimer = Timer.periodic(Duration(seconds: 30), (Timer timer) {
      _sendLocationToContacts(); // Send updated location every 2 minutes.
    });

    Fluttertoast.showToast(msg: "Live location updates started");
  }

  // Stop live location updates.
  void _stopLiveLocationUpdates() {
    _locationTimer?.cancel();
    Fluttertoast.showToast(msg: "Live location updates stopped");
  }

  @override
  void initState() {
    super.initState();
    _getPermissions();
    _getCurrentLocation();
  }

  @override
  // void dispose() {
  //   _locationTimer?.cancel(); // Clean up the timer when the widget is disposed.
  //   super.dispose();
  // }

  // Show modal with options to start/stop live location sharing.
  void showModelSafeHome(BuildContext context) {
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
                  "LIVE LOCATION SHARING",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                if (_currentAddress != null) Text(_currentAddress!),
                PrimaryButton(
                  title: "START LIVE LOCATION",
                  onPressed: _startLiveLocationUpdates,
                ),
                SizedBox(height: 10),
                PrimaryButton(
                  title: "STOP LIVE LOCATION",
                  onPressed: _stopLiveLocationUpdates,
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
     child: Padding(
        padding: const EdgeInsets.only(left: 5),
           child: Column(
           children: [
             Card(
                elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight, colors:[Colors.pink,const Color.fromARGB(255, 221, 112, 148),const Color.fromARGB(255, 228, 207, 214)])),
                    height: 170,
                    width: 170,
                    child: Center(
                     
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            
                            child: Icon(Icons.location_on,size: 60,
                            color: Colors.white,)
                          ),
                          Text("SEND LOCATION",
                          style: TextStyle(color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                                             ),
                          textAlign : TextAlign.center ,),
                        ],
                      ),
                    ), // Center
                  ), // Contain
             )
           
           ],
               ),
         ),
    );
  }
}

