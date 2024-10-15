import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/child/Bottom_screens/add_contact.dart';
import 'package:flutter_application_3_mainproject/child/Bottom_screens/chat_page.dart';
import 'package:flutter_application_3_mainproject/child/Bottom_screens/home_screen.dart';

import 'Bottom_screens/profile_page.dart';
import 'Bottom_screens/review_page.dart';

class BottomPage extends StatefulWidget {
  // BottomPage(Key? key) :super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    AddContactPage(),
    ChatPage(),
    ProfilePage(),
    ReviewPage(),
  ];

  onTapped(int index){
    setState(() {
      currentIndex =index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Contacts',
            icon: Icon(
              Icons.contacts,
            ),
          ),
          BottomNavigationBarItem(
          label: 'Chats',
            icon: Icon(
              Icons.chat,
            ),
          ),
          BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(
          Icons.person,
          ),
          ),
          BottomNavigationBarItem(
          label: 'Reviews',
          icon: Icon(
          Icons.reviews,
          ),
          ),
        ],
      ),
    );
  }
}