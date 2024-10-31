import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samsar/Widgets/additional_info_dialog.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/l10n/l10n.dart';
import 'package:samsar/screens/main_screens/add_house.dart';
import 'package:samsar/screens/main_screens/profile_screen.dart';
import 'package:samsar/values/structures.dart';
import 'main_screens/home.dart';
import 'main_screens/notifications_screen.dart';
import 'main_screens/search.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // Add this static method
  static void switchToHomeTab(BuildContext context) {
    final state = context.findAncestorStateOfType<State<HomePage>>();
    if (state != null && state is _HomePageState) {
      state.setState(() {
        state._selectedIndex = 0;
      });
    }
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final UserManager _userManager = UserManager();
  DateTime? lastPressed;

  final List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    HouseUploadPage(),
    NotificationsPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserAdditionalInfo();
  }

  Future<void> checkUserAdditionalInfo() async {
    user = _auth.currentUser;
    if (user == null) return;

    await _userManager.loadUserData();

    SamsarUser? samsarUser = _userManager.samsarUser;

    if (samsarUser == null) return;

    if (samsarUser.phoneNumber == null || samsarUser.phoneNumber == "") {
      if(mounted) showAdditionalInfoDialog(context, user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          Fluttertoast.showToast(msg: 'Tap again to exit');
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: theme.cardColor,
          onTap: _onItemTapped,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.colorScheme.tertiary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: theme.colorScheme.tertiary),
              activeIcon: Icon(Icons.home, color: theme.primaryColor),
              label: S.of(context).home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: theme.colorScheme.tertiary),
              activeIcon: Icon(Icons.search, color: theme.primaryColor),
              label: S.of(context).search,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_home_work_outlined, color: theme.colorScheme.tertiary),
              activeIcon: Icon(Icons.add_home_work_outlined, color: theme.primaryColor),
              label: S.of(context).add,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications, color: theme.colorScheme.tertiary),
              activeIcon: Icon(Icons.notifications, color: theme.primaryColor),
              label: S.of(context).inbox,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: theme.colorScheme.tertiary),
              activeIcon: Icon(Icons.person, color: theme.primaryColor),
              label: S.of(context).profile,
            ),
          ],
        ),
      ),
    );
  }
}
