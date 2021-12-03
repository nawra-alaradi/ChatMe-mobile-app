import 'package:chat_me/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat_list_screen.dart';
// import 'search_screen.dart';

class RouteScreen extends StatefulWidget {
  static const String id = "Route";
  const RouteScreen({Key? key}) : super(key: key);
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  //Update the page when tapping one of the bottom navigation bar items
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Jump to the selected screen from the bottom navigation bar
  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: const Color(0xFFBDC3C7),
            // primaryColor: Color(0xFF323232),
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.amber[10])),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            iconSize: 25.w,
            selectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w300,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w300,
            ),
            selectedItemColor: Colors.amber[10],
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            fixedColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.listAlt,
                  color: _selectedIndex == 0 ? Colors.amber[10] : Colors.grey,
                ),
                label: "Chats List",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.pageview_outlined,
                  color: _selectedIndex == 1 ? Colors.amber[10] : Colors.grey,
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
