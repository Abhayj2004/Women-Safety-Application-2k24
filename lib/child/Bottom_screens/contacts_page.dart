import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/db/db_service.dart';
import 'package:flutter_application_3_mainproject/model/contactsm.dart';
import 'package:flutter_application_3_mainproject/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactFilter = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAll(RegExp(r'\D'), ''); // Flatten to digits only
  }

  void filterContact() {
    List<Contact> _filteredContacts = [];
    _filteredContacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _filteredContacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlattened = flattenPhoneNumber(searchTerm);

        // Check if contact name contains the search term
        String contactName = element.displayName?.toLowerCase() ?? '';
        bool nameMatches = contactName.contains(searchTerm);

        // Check if any phone number matches the search term
        bool phoneMatches = false;

        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlattened.isEmpty) {
          return false;
        }

        var phone = element.phones!.firstWhere((p) {
          String phnFlattened = flattenPhoneNumber(p.value!);
          return phnFlattened.contains(searchTermFlattened);
        });

        return nameMatches || phoneMatches;
      });
    }
    setState(() {
      contactFilter = _filteredContacts;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContact();
      });
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }

  Future<void> handleInvalidPermissions(
      PermissionStatus permissionStatus) async {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access to contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context,
          "Access to contacts is permanently denied. Please enable it in settings.");
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> getAllContacts() async {
    List<Contact> _contacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool hasContacts = contactFilter.isNotEmpty || contacts.isNotEmpty;

    return Scaffold(
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: "Search contact",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  hasContacts
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: isSearching
                                ? contactFilter.length
                                : contacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contact contact = isSearching
                                  ? contactFilter[index]
                                  : contacts[index];
                              return ListTile(
                                title: Text(contact.displayName ?? "No Name"),
                                leading: (contact.avatar != null &&
                                        contact.avatar!.isNotEmpty)
                                    ? CircleAvatar(
                                        backgroundColor: primaryColor,
                                        backgroundImage:
                                            MemoryImage(contact.avatar!),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: primaryColor,
                                        child: Text(contact.initials()),
                                      ),
                                onTap: () {
                                  if (contact.phones!.length > 0) {
                                    final String phoneNum =
                                        contact.phones!.elementAt(0).value!;
                                    final String name = contact.displayName!;

                                    addContact(TContact(phoneNum, name));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Oops! Phone number of this contact already exists");
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("No contacts found."),
                        ),
                ],
              ),
            ),
    );
  }

  void addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);

    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }
}
