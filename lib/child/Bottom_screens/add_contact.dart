// // import 'package:flutter/material.dart';

// // class AddContactpage extends StatelessWidget {
// //   const AddContactpage({super.key});
// // @Override

// // State<AddContactpage> createState() => _AddContactsPageState();

// // class _AddContactsPageState extends State<AddContactpage> {
// //   DatabaseHelper databaseHelper = DatabaseHelper();
// //   List<Contact>? contactList;
// //   int count = 0 ;

// //   void showList() {
// //   Future<Database> dbFuture = databaseHelper.initializeDatabase();
// //   dbFuture.then((database) {
// //     Future<List<TContact>> contactListFuture = databaseHelper.getContactList();
// //     contactListFuture.then((value) {
// //       setState(() {
// //         this.contactList = value;
// //         this.count = value.length;
// //       });
// //     });
// //   });
// // }

// // void deleteContact(TContact contact) async {
// //   int result = await databaseHelper.deleteContact(contact.id);
// //   if (result != 0) {
// //     Fluttertoast.showToast(msg: "Contact removed successfully");
// //     showList();
// //   }
// // }


// // @override
// // void initState() {
// //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
// //   showList();

// //   });
// //   super.initState();
// // }



// //   @override
// //   Widget build(BuildContext context) {
// //   return SafeArea(
// //     child: Container(
// //       padding: EdgeInsets.all(12),
// //       child: Column(
// //         children: [
// //           PrimaryButton(
// //             title: "Add Trusted Contacts",
// //             onPressed: () {
// //              bool result =  await Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => Contactspage(),
// //                 ),
// //               );
// //               if (result== true )
// //               {
// //                 showList() ;
// //               }
// //               },
// //           ),

// //           Expanded(
// //             child: ListView.builder(
// //                   //  shrinkWrap: true,
// //                     itemCount: count,
// //                     itemBuilder: (BuildContext context, int index) {
// //                    return Card(
// //                       child: ListTile(
// //                        title: Text(contactList[index].name),
// //                        trailing: IconButton(onPressed: (){
// //                         deleteContact(contactList![index]);
// //                        },icon: Icon(Icons.delete, color: Colors.red),
// //                       ),
            
// //                   ), // ListTile
// //                 ); // Card
// //               },
// //             ),
// //           );

// //         ],
// //       ),
// //     ),
// //   );
// // }

// // }
// // }
// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_3_mainproject/child/Bottom_screens/contacts_page.dart';
// import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
// import 'package:flutter_application_3_mainproject/db/db_service.dart';
// import 'package:flutter_application_3_mainproject/model/contactsm.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:sqflite/sqlite_api.dart'; // Assuming you're using fluttertoast for toast messages.

// class AddContactPage extends StatefulWidget {
//   const AddContactPage({super.key});

//   @override
//   State<AddContactPage> createState() => _AddContactsPageState();
// }

// class _AddContactsPageState extends State<AddContactPage> {
//   DatabaseHelper databaseHelper = DatabaseHelper();
//   List<Contact>? contactList;
//   int count = 0;

//   // Method to show contact list
//   void showList() {
//     Future<Database> dbFuture = databaseHelper.initializeDatabase();
//     dbFuture.then((database) {
//       Future<List<TContact>> contactListFuture = databaseHelper.getContactList();
//       contactListFuture.then((value) {
//         setState(() {
//           contactList = value;
//           count = value.length;
//         });
//       });
//     });
//   }

//   // Method to delete contact
//   void deleteContact(TContact contact) async {
//     int result = await databaseHelper.deleteContact(contact.id);
//     if (result != 0) {
//       Fluttertoast.showToast(msg: "Contact removed successfully");
//       showList();
//     }
//   }

//   // Initialize state
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       showList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Button to add trusted contacts
//             PrimaryButton(
//               title: "Add Trusted Contacts",
//               onPressed: () async {
//                 bool result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ContactsPage(),
//                   ),
//                 );
//                 if (result == true) {
//                   showList();
//                 }
//               },
//             ),

//             // Contact List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: count,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text(contactList?[index].name ?? 'No Name'),
//                       trailing: IconButton(
//                         onPressed: () {
//                           deleteContact(contactList![index]);
//                         },
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/child/Bottom_screens/contacts_page.dart';
import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
import 'package:flutter_application_3_mainproject/db/db_service.dart';
import 'package:flutter_application_3_mainproject/model/contactsm.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqlite_api.dart'; // Assuming you're using fluttertoast for toast messages.

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TContact>? contactList; // Using TContact type
  int count = 0;

  // Method to show contact list
  void showList() {
    Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture = databaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          contactList = value;
          count = value.length;
        });
      });
    });
  }

  // Method to delete contact
  void deleteContact(TContact contact) async {
    int result = await databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact removed successfully");
      showList();
    }
  }

  // Initialize state
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Button to add trusted contacts
            PrimaryButton(
              title: "Add Trusted Contacts",
              onPressed: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactsPage(),
                  ),
                );
                if (result == true) {
                  showList();
                }
              },
            ),

            // Contact List
            Expanded(
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  // Make sure contactList is not null before accessing
                  final contact = contactList?[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(contact?.name ?? 'No Name'),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  // Check if the number is not null before calling
                                  if (contact?.number != null) {
                                    await FlutterPhoneDirectCaller.callNumber(contact!.number);
                                  } else {
                                    Fluttertoast.showToast(msg: "Contact number not available");
                                  }
                                },
                                icon: const Icon(Icons.call, color: Colors.green),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteContact(contact!);
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
