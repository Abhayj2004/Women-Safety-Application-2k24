import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/Recorder/record_home_page.dart';
import 'package:flutter_application_3_mainproject/utils/constants.dart';


class RecordAudio extends StatelessWidget {
  const RecordAudio({super.key});

  @override
  Widget build(BuildContext context) {
     return InkWell(
      onTap: () => {
        goToBox(context, rec())
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
                            
                            child: Icon(Icons.record_voice_over_rounded,size: 60,
                            color: Colors.white,)
                          ),
                          Text("RECORD AUDIO / VOICE",
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