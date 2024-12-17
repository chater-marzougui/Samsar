import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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

  static void switchToPage(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_HomePageState>();
    if (state != null) {
      state._onItemTapped(index);
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
  final GlobalKey<CurvedNavigationBarState> _navigationKey = GlobalKey();
  DateTime? lastPressed;

  late final List<Widget> _pages;
  late final List<Widget> _pageWidgets;
  final List<bool> _pagesUnderNav = [true, true, false, false, false];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      for (int i = 0; i < _pageWidgets.length; i++) {
        _pageWidgets[i] = Offstage(
          offstage: _selectedIndex != i,
          child: TickerMode(
            enabled: _selectedIndex == i,
            child: _pages[i],
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(),
      SearchScreen(),
      HouseUploadPage(),
      NotificationsPage(),
      ProfileScreen(),
    ];

    _pageWidgets = _pages.asMap().entries.map((entry) {
      return Offstage(
        offstage: _selectedIndex != entry.key,
        child: TickerMode(
          enabled: _selectedIndex == entry.key,
          child: entry.value,
        ),
      );
    }).toList();
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Pages that go under the navbar
            Stack(
              children: _pagesUnderNav[_selectedIndex]
                  ? _pageWidgets
                  : _pageWidgets.map((widget) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 60 + bottomPadding),
                  child: widget,
                );
              }).toList(),
            ),

            // Navigation bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: CurvedNavigationBar(
                  key: _navigationKey,
                  index: _selectedIndex,
                  backgroundColor: _pagesUnderNav[_selectedIndex]
                      ? Colors.transparent
                      : theme.canvasColor,
                  color: theme.primaryColor,
                  buttonBackgroundColor: theme.primaryColor,
                  height: 60,
                  animationDuration: const Duration(milliseconds: 400),
                  animationCurve: Curves.easeInOut,
                  onTap: _onItemTapped,
                  items: <Widget>[
                    _buildNavigationItem(
                      icon: Icons.home,
                      index: 0,
                      label: S.of(context).home,
                      theme: theme,
                    ),
                    _buildNavigationItem(
                      icon: Icons.search,
                      index: 1,
                      label: S.of(context).search,
                      theme: theme,
                    ),
                    _buildNavigationItem(
                      icon: Icons.add_home_work_outlined,
                      index: 2,
                      label: S.of(context).add,
                      theme: theme,
                    ),
                    _buildNavigationItem(
                      icon: Icons.notifications,
                      index: 3,
                      label: S.of(context).inbox,
                      theme: theme,
                    ),
                    _buildNavigationItem(
                      icon: Icons.person,
                      index: 4,
                      label: S.of(context).profile,
                      theme: theme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String label,
    required int index,
    required ThemeData theme,
  }) {
    final isSelected = _selectedIndex == index;

    return Container(
      height: 48, // Fixed height for all items
      width: 48,  // Fixed width for all items
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? Colors.white : Colors.white70,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/*
          child: BottomNavigationBar(
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

           */