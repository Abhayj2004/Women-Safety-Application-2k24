import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/SafeHome/SafeHome.dart';
import 'package:flutter_application_3_mainproject/camera/cameramain.dart';
import 'package:flutter_application_3_mainproject/extra_activity/record_audio.dart';
import 'package:flutter_application_3_mainproject/extra_activity/voice_assistant.dart';


class Extraactivity extends StatelessWidget {
  const Extraactivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          RecordAudio(),
          SafeHome(),
          CapturePhoto(),
        ],
      ),
    );
  }
}