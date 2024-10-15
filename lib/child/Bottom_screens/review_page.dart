

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/components/customtextfield.dart';

import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
import 'package:flutter_application_3_mainproject/components/secondarybutton.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}


class _ReviewPageState extends State<ReviewPage> { 
  TextEditingController locationC = TextEditingController();
  TextEditingController viewC = TextEditingController();
  bool isSaving = false ;

   showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return  isSaving == true ? CircularProgressIndicator(): AlertDialog(
          title: Text("Review your place"),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Customtextfield(
                    hintText:  "enter location ",
                     controller : locationC,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Customtextfield(
                    hintText: "enter review ",
                     controller : viewC ,
                     maxLines: 3,

                  ),
                ),
              ],
            ),
          ),
          actions: [
            Secondarybutton(
              title: "Cancel", 
              onPressed: () {
                // Navigator.of(context).pop(); // To close the dialog
                Navigator.pop(context);
              },
            ),
            PrimaryButton(
              title: "SAVE", 
              onPressed: () {
                saveReview();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

saveReview() async {
  setState(() {
    isSaving = true;
  });

  await FirebaseFirestore.instance
      .collection('reviews')
      .add({
        'location': locationC.text,
        'views': viewC.text,
      })
    
      .then((value) {
    setState(() {
      isSaving = false;
      Fluttertoast.showToast(msg: 'Review uploaded successfully');
    });
    

  });
}


  @override
  Widget build(BuildContext context) {
          return Scaffold(
     body:isSaving == true 
        ? CircularProgressIndicator() 
        :SafeArea(
          child: Column(
            children: [
              Text("Reviews ( UNSAFE - AREAS)",
              style: TextStyle(fontSize: 30,color: const Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.bold),),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                
                    return ListView.builder( 
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                final data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(15),
                      

                      ),
                      child: ListTile(
                        title: Text(data['location'],
                        style:TextStyle(fontSize: 20,color:const Color.fromARGB(255, 255, 255, 255) ,
                        fontWeight: FontWeight.bold)),
                        subtitle: Text(data["views"],
                        style: TextStyle(color: Colors.white),)),
                      ),
                  ),
                );},
                  );
                  } // ListTile
                ),
              ),
            ],
          ),
        ),
 floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.pink,
      onPressed: () {
        showAlert(context);
      },
      child: Icon(Icons.add),
    ), // FloatingActionButton
); 
}// Container
     
    // ListView.builder
  }



// *********************frontend **************************
// import 'package:flutter/material.dart';
// import 'package:flutter_application_3_mainproject/components/customtextfield.dart';
// import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
// import 'package:flutter_application_3_mainproject/components/secondarybutton.dart';

// class ReviewPage extends StatefulWidget {
//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

// class _ReviewPageState extends State<ReviewPage> {
//   showAlert(BuildContext context){
//     showDialog(context: context,
//         builder: (_) {
//         return AlertDialog(
//           title: Text("Review your place"),
//           content: Form(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Customtextfield(
//                     hintText: "Enter the location ",
                   
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Customtextfield(
//                     hintText: "Give Review ",
                    
                  
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             Secondarybutton(title: "Cancel", onPressed: ( ) {
//               Navigator.pop(context);
//             }),
//             PrimaryButton(title: "SAVE", onPressed: () {}),
//           ],
//         );
//       },
//     );
//   }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: null,
//     floatingActionButton: FloatingActionButton(
//       backgroundColor: Colors.pink,
//       onPressed: () {
//         showAlert(context);
//       },
//       child: Icon(Icons.add),
//     ), // FloatingActionButton
//   ); // Scaffold
// }
// }