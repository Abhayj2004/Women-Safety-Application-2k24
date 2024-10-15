import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/home_widgets/live_safe/Hospital_card.dart';
import 'widgets/home_widgets/live_safe/buscard.dart';
import 'widgets/home_widgets/live_safe/pharmacycard.dart';
import 'widgets/home_widgets/live_safe/police_card.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({Key? key}) : super(key: key);

static Future <void> openMap(String location) async{
  String googleUrl ="https://www.google.co.in/maps/search/$location";
final Uri _url = Uri.parse(googleUrl);
  try{
    await launchUrl(_url);
  }catch(e){
    Fluttertoast.showToast(msg: "something went wrong ! call emergency number ...");
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceCard(openMapFunction: openMap),
          HospitalCard(openMapFunction: openMap),
          Pharmacycard(openMapFunction: openMap),
          BusCard(openMapFunction: openMap)
        ],
      ), // ListView
    ); // Container
  }
}
