import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/widgets/emergencies/ambulanceemergency.dart';
import 'package:flutter_application_3_mainproject/widgets/emergencies/fireemergency.dart';
import 'package:flutter_application_3_mainproject/widgets/emergencies/healthemergency.dart';
import 'package:flutter_application_3_mainproject/widgets/emergencies/policeemergency.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
         Policeemergency(),
         AmbulanceEmergency(),
         HealthEmergency(),
         FireEmergency(),
        ],
      ),

    );
  }
}

