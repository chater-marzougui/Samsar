import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:samsar/Widgets/widgets.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/values/app_routes.dart';
import '../../values/structures.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Constants
  static const double _profileImageRadius = 65.0;
  static const EdgeInsets _screenPadding = EdgeInsets.only(
    top: 80.0,
    left: 16.0,
    right: 16.0,
    bottom: 16.0,
  );

  // State variables
  final UserManager _userManager = UserManager();
  String _appVersion = "";
  SamsarUser? samsarUser;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Initialization methods
  Future<void> _initializeData() async {
    await _loadAppVersion();
    _loadUserData();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "Version ${packageInfo.version} +${packageInfo.buildNumber}";
    });
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        samsarUser = _userManager.samsarUser;
      });
    } catch (e) {
      if (mounted) showSnackBar(context, 'Error loading user data: $e');
    }
  }

  // Authentication methods
  Future<void> _signOut(BuildContext context) async {
    try {
      await _userManager.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, 'Error signing out: $e');
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _signOut(context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: _profileImageRadius,
      backgroundImage: samsarUser?.profileImage.isNotEmpty == true
          ? NetworkImage(samsarUser!.profileImage)
          : const AssetImage('assets/icons/default_profile_pic_man.png')
      as ImageProvider,
    );
  }

  Widget _buildUserInfo(ThemeData theme) {
    return Column(
      children: [
        Text(
          "${samsarUser!.firstName} ${samsarUser!.middleName}${samsarUser!.middleName != "" ? " " : ""}${samsarUser!.lastName}",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(samsarUser!.email, style: theme.textTheme.titleMedium),
      ],
    );
  }

  Widget _buildMenuItems(ThemeData theme) {
    return Column(
      children: [
        settingScreenItem(
          context,
          icon: Icons.settings,
          itemName: "Settings",
          page: AppRoutes.appSettings,
        ),
        settingScreenItem(
          context,
          imagePath: "assets/icons/my_houses.png",
          itemName: "My Houses",
          page: AppRoutes.myHouses,
        ),
        settingScreenItem(
          context,
          imagePath: "assets/icons/fav_houses.png",
          itemName: "Favourite Houses",
          page: AppRoutes.favouriteHouses,
        ),
        ListTile(
          leading: Icon(Icons.person_rounded, color: theme.primaryColor),
          title: Text("Personal Account", style: theme.textTheme.titleSmall),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.editProfile)
                .then((_) => _loadUserData());
          },
        ),
        settingScreenItem(
          context,
          icon: Icons.support_agent,
          itemName: "Contact Support",
          page: AppRoutes.contactSupport,
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app, color: theme.primaryColor),
          title: Text("Logout", style: theme.textTheme.titleSmall),
          onTap: () => _handleLogout(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (samsarUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: _screenPadding,
            child: Column(
              children: [
                _buildProfileImage(),
                const SizedBox(height: 12),
                _buildUserInfo(theme),
                const SizedBox(height: 14),
                Divider(color: theme.primaryColorLight),
                const SizedBox(height: 14),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMenuItems(theme),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
            child: Text(
              _appVersion,
              style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}