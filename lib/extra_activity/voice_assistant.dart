// import 'package:flutter/material.dart';
// import 'package:flutter_application_3_mainproject/home_page.dart';





// class VoiceAssistant extends StatefulWidget {
//   const VoiceAssistant({super.key});

//   @override
//   State<VoiceAssistant> createState() => _VoiceAssistantState();
// }


// class _VoiceAssistantState extends State<VoiceAssistant> {
//   @override
//   Widget build(BuildContext context) {
//        return InkWell(
//         onTap: () =>{ HomePage()

//         },
//            child: Padding(
//                padding: const EdgeInsets.only(left: 20),
//            child: Column(
//            children: [
//              Card(
//                 elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Container(
//                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight, colors:[Colors.pink,const Color.fromARGB(255, 221, 112, 148),const Color.fromARGB(255, 228, 207, 214)])),
//                     height: 170,
//                     width: 170,
//                     child: Center(
                     
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 100,
//                             // child: Image.asset("assets/sirun.png"),
//                             child: Icon(Icons.mic,size: 60,
//                             color: Colors.white,)
//                           ),
//                           Text("VOICE ASSISTANT",
//                           style: TextStyle(color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                                              ),
//                           textAlign : TextAlign.center ,),
//                         ],
//                       ),
//                     ), // Center
//                   ), // Contain
//              )
           
//            ],
//                ),
//          ),
//        );
    
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/home_page.dart';
// Make sure the path is correct

class VoiceAssistant extends StatefulWidget {
  const VoiceAssistant({super.key});

  @override
  State<VoiceAssistant> createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      
        // Navigate to HomePage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          children: [
            Card(
              elevation: 3,
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
                      const Color.fromARGB(255, 221, 112, 148),
                      const Color.fromARGB(255, 228, 207, 214)
                    ],
                  ),
                ),
                height: 170,
                width: 170,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: Icon(
                          Icons.mic,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "VOICE ASSISTANT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
